"""
Orders Serializers
"""

from rest_framework import serializers
from .models import Order, OrderItem


class OrderItemSerializer(serializers.ModelSerializer):
    class Meta:
        model = OrderItem
        fields = [
            'id', 'item_name', 'item_image', 'quantity',
            'unit_price', 'total_price',
        ]


class OrderItemCreateSerializer(serializers.Serializer):
    """Input serializer for creating order items."""
    item_type = serializers.ChoiceField(choices=['product', 'meal', 'service'])
    item_id = serializers.IntegerField()
    quantity = serializers.IntegerField(default=1, min_value=1)


class OrderListSerializer(serializers.ModelSerializer):
    """Lightweight order serializer for list views."""
    status_display = serializers.CharField(source='get_status_display', read_only=True)
    order_type_display = serializers.CharField(source='get_order_type_display', read_only=True)
    payment_status_display = serializers.CharField(source='get_payment_status_display', read_only=True)
    item_count = serializers.ReadOnlyField()

    class Meta:
        model = Order
        fields = [
            'id', 'order_number', 'order_type', 'order_type_display',
            'status', 'status_display', 'total', 'payment_status',
            'payment_status_display', 'item_count', 'created_at',
        ]


class OrderDetailSerializer(serializers.ModelSerializer):
    """Full order detail serializer."""
    items = OrderItemSerializer(many=True, read_only=True)
    status_display = serializers.CharField(source='get_status_display', read_only=True)
    order_type_display = serializers.CharField(source='get_order_type_display', read_only=True)
    payment_status_display = serializers.CharField(source='get_payment_status_display', read_only=True)

    class Meta:
        model = Order
        fields = [
            'id', 'order_number', 'order_type', 'order_type_display',
            'status', 'status_display', 'subtotal', 'delivery_fee',
            'discount', 'total', 'payment_status', 'payment_status_display',
            'payment_method', 'delivery_address_text', 'notes',
            'coupon_code', 'items', 'created_at', 'updated_at',
        ]


class OrderCreateSerializer(serializers.Serializer):
    """Serializer for placing a new order."""
    order_type = serializers.ChoiceField(choices=Order.OrderType.choices)
    items = OrderItemCreateSerializer(many=True)
    delivery_address_id = serializers.IntegerField(required=False)
    delivery_address_text = serializers.CharField(required=False, allow_blank=True)
    payment_method = serializers.CharField(required=False, default='cod')
    notes = serializers.CharField(required=False, allow_blank=True, default='')
    coupon_code = serializers.CharField(required=False, allow_blank=True, default='')
