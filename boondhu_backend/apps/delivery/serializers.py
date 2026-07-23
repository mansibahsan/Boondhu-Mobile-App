"""
Delivery Serializers
"""

from rest_framework import serializers
from .models import DeliveryParcel


class DeliveryParcelListSerializer(serializers.ModelSerializer):
    status_display = serializers.CharField(source='get_status_display', read_only=True)
    parcel_type_display = serializers.CharField(source='get_parcel_type_display', read_only=True)
    weight_display = serializers.CharField(source='get_weight_display', read_only=True)

    class Meta:
        model = DeliveryParcel
        fields = [
            'id', 'tracking_number', 'pickup_address', 'delivery_address',
            'parcel_type', 'parcel_type_display', 'weight', 'weight_display',
            'status', 'status_display', 'price', 'eta', 'created_at',
        ]


class DeliveryParcelDetailSerializer(serializers.ModelSerializer):
    status_display = serializers.CharField(source='get_status_display', read_only=True)
    parcel_type_display = serializers.CharField(source='get_parcel_type_display', read_only=True)
    weight_display = serializers.CharField(source='get_weight_display', read_only=True)
    rider_name = serializers.SerializerMethodField()

    class Meta:
        model = DeliveryParcel
        fields = [
            'id', 'tracking_number', 'sender_name', 'sender_phone',
            'pickup_address', 'pickup_area', 'delivery_address', 'delivery_area',
            'recipient_name', 'recipient_phone', 'parcel_type', 'parcel_type_display',
            'weight', 'weight_display', 'description', 'image', 'price',
            'status', 'status_display', 'rider_name', 'eta', 'notes',
            'delivered_at', 'created_at',
        ]

    def get_rider_name(self, obj):
        if obj.rider:
            return obj.rider.full_name
        return None


class DeliveryParcelCreateSerializer(serializers.ModelSerializer):
    """Serializer for creating a delivery request."""

    class Meta:
        model = DeliveryParcel
        fields = [
            'sender_name', 'sender_phone', 'pickup_address', 'pickup_area',
            'delivery_address', 'delivery_area', 'recipient_name', 'recipient_phone',
            'parcel_type', 'weight', 'description', 'image', 'notes',
        ]

    def create(self, validated_data):
        validated_data['sender'] = self.context['request'].user
        # Calculate price based on weight and type
        validated_data['price'] = self._calculate_price(
            validated_data.get('weight', 'up_to_1kg'),
            validated_data.get('parcel_type', 'small_parcel'),
        )
        return super().create(validated_data)

    def _calculate_price(self, weight, parcel_type):
        """Basic pricing logic — can be expanded later."""
        base_prices = {
            'up_to_1kg': 60,
            '1_to_5kg': 100,
            '5_to_10kg': 150,
            'above_10kg': 250,
        }
        type_multipliers = {
            'document': 0.8,
            'small_parcel': 1.0,
            'medium_parcel': 1.2,
            'large_parcel': 1.5,
            'fragile': 1.8,
            'food': 1.0,
        }
        base = base_prices.get(weight, 100)
        multiplier = type_multipliers.get(parcel_type, 1.0)
        return round(base * multiplier, 2)


class DeliveryStatusUpdateSerializer(serializers.Serializer):
    """For riders to update delivery status."""
    status = serializers.ChoiceField(choices=DeliveryParcel.Status.choices)
    eta = serializers.CharField(required=False)
