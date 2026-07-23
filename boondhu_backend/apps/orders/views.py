"""
Orders Views
"""

from django.contrib.contenttypes.models import ContentType
from rest_framework import viewsets, permissions, status
from rest_framework.decorators import action
from rest_framework.response import Response
from django_filters.rest_framework import DjangoFilterBackend
from drf_spectacular.utils import extend_schema, extend_schema_view

from .models import Order, OrderItem
from .serializers import (
    OrderListSerializer, OrderDetailSerializer, OrderCreateSerializer,
)


@extend_schema_view(
    list=extend_schema(tags=['Orders']),
    create=extend_schema(tags=['Orders']),
    retrieve=extend_schema(tags=['Orders']),
    cancel=extend_schema(tags=['Orders']),
)
class OrderViewSet(viewsets.ModelViewSet):
    """
    Order management — create, list, retrieve, cancel.
    """
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [DjangoFilterBackend]
    filterset_fields = {'order_type': ['exact'], 'status': ['exact']}
    lookup_field = 'order_number'
    http_method_names = ['get', 'post', 'head', 'options']

    def get_queryset(self):
        return Order.objects.filter(
            user=self.request.user,
        ).prefetch_related('items')

    def get_serializer_class(self):
        if self.action == 'create':
            return OrderCreateSerializer
        if self.action == 'retrieve':
            return OrderDetailSerializer
        return OrderListSerializer

    def create(self, request, *args, **kwargs):
        """Place a new order."""
        serializer = OrderCreateSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        data = serializer.validated_data

        # Create the order
        order = Order.objects.create(
            user=request.user,
            order_type=data['order_type'],
            payment_method=data.get('payment_method', 'cod'),
            notes=data.get('notes', ''),
            coupon_code=data.get('coupon_code', ''),
            delivery_address_text=data.get('delivery_address_text', ''),
        )

        # Set delivery address if provided
        if 'delivery_address_id' in data:
            from apps.accounts.models import UserAddress
            try:
                address = UserAddress.objects.get(
                    id=data['delivery_address_id'], user=request.user,
                )
                order.delivery_address = address
                order.delivery_address_text = address.full_address
            except UserAddress.DoesNotExist:
                pass

        # Create order items
        subtotal = 0
        item_model_map = {
            'product': 'store.Product',
            'meal': 'kitchen.Meal',
            'service': 'services.Service',
        }

        for item_data in data['items']:
            item_type = item_data['item_type']
            item_id = item_data['item_id']
            quantity = item_data.get('quantity', 1)

            model_path = item_model_map.get(item_type)
            if not model_path:
                continue

            app_label, model_name = model_path.split('.')
            try:
                ct = ContentType.objects.get(app_label=app_label, model=model_name.lower())
                item_obj = ct.get_object_for_this_type(pk=item_id)
            except Exception:
                continue

            unit_price = float(item_obj.price)
            image_url = ''
            if hasattr(item_obj, 'primary_image') and item_obj.primary_image:
                image_url = item_obj.primary_image.image.url if item_obj.primary_image.image else ''
            elif hasattr(item_obj, 'image') and item_obj.image:
                image_url = item_obj.image.url

            OrderItem.objects.create(
                order=order,
                content_type=ct,
                object_id=item_id,
                item_name=item_obj.name,
                item_image=image_url,
                quantity=quantity,
                unit_price=unit_price,
                total_price=unit_price * quantity,
            )
            subtotal += unit_price * quantity

        # Update order totals
        order.subtotal = subtotal
        order.delivery_fee = 30 if data['order_type'] in ['store', 'kitchen'] else 0
        order.save()

        return Response(
            OrderDetailSerializer(order).data,
            status=status.HTTP_201_CREATED,
        )

    @action(detail=True, methods=['post'])
    def cancel(self, request, order_number=None):
        """Cancel an order (only if pending/confirmed)."""
        order = self.get_object()
        if order.status not in ['pending', 'confirmed']:
            return Response(
                {'error': 'Order can only be cancelled when pending or confirmed.'},
                status=status.HTTP_400_BAD_REQUEST,
            )
        order.status = Order.Status.CANCELLED
        order.save()
        return Response(OrderDetailSerializer(order).data)
