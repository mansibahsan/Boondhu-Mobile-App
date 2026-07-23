"""
Delivery Views
"""

from django.utils import timezone
from rest_framework import viewsets, permissions, status, filters
from rest_framework.decorators import action
from rest_framework.response import Response
from django_filters.rest_framework import DjangoFilterBackend
from drf_spectacular.utils import extend_schema, extend_schema_view

from .models import DeliveryParcel
from .serializers import (
    DeliveryParcelListSerializer,
    DeliveryParcelDetailSerializer,
    DeliveryParcelCreateSerializer,
    DeliveryStatusUpdateSerializer,
)


@extend_schema_view(
    list=extend_schema(tags=['Delivery']),
    create=extend_schema(tags=['Delivery']),
    retrieve=extend_schema(tags=['Delivery']),
    update_status=extend_schema(tags=['Delivery']),
    track=extend_schema(tags=['Delivery']),
)
class DeliveryParcelViewSet(viewsets.ModelViewSet):
    """
    Delivery parcel management.
    Customers can create parcels and view their deliveries.
    """
    permission_classes = [permissions.IsAuthenticated]
    filter_backends = [DjangoFilterBackend, filters.OrderingFilter]
    filterset_fields = {'status': ['exact']}
    ordering = ['-created_at']
    http_method_names = ['get', 'post', 'head', 'options']

    def get_queryset(self):
        user = self.request.user
        if user.user_type == 'rider':
            return DeliveryParcel.objects.filter(rider=user)
        return DeliveryParcel.objects.filter(sender=user)

    def get_serializer_class(self):
        if self.action == 'create':
            return DeliveryParcelCreateSerializer
        if self.action == 'retrieve':
            return DeliveryParcelDetailSerializer
        return DeliveryParcelListSerializer

    @action(detail=True, methods=['put'])
    def update_status(self, request, pk=None):
        """Update delivery status (for riders/admin)."""
        parcel = self.get_object()
        serializer = DeliveryStatusUpdateSerializer(data=request.data)
        serializer.is_valid(raise_exception=True)

        parcel.status = serializer.validated_data['status']
        if 'eta' in serializer.validated_data:
            parcel.eta = serializer.validated_data['eta']
        if parcel.status == DeliveryParcel.Status.DELIVERED:
            parcel.delivered_at = timezone.now()
        parcel.save()

        return Response(
            DeliveryParcelDetailSerializer(parcel, context={'request': request}).data,
        )

    @action(detail=False, methods=['get'], url_path='track/(?P<tracking_number>[^/.]+)')
    def track(self, request, tracking_number=None):
        """Track a parcel by tracking number (public-ish endpoint)."""
        try:
            parcel = DeliveryParcel.objects.get(tracking_number=tracking_number)
        except DeliveryParcel.DoesNotExist:
            return Response(
                {'error': 'Parcel not found with this tracking number.'},
                status=status.HTTP_404_NOT_FOUND,
            )
        serializer = DeliveryParcelDetailSerializer(parcel, context={'request': request})
        return Response(serializer.data)
