"""
Services Serializers
"""

from rest_framework import serializers
from .models import ServiceCategory, ServiceProvider, Service, ServiceBooking


class ServiceCategorySerializer(serializers.ModelSerializer):
    service_count = serializers.SerializerMethodField()

    class Meta:
        model = ServiceCategory
        fields = ['id', 'name', 'slug', 'description', 'icon', 'image', 'service_count']

    def get_service_count(self, obj):
        return obj.services.filter(is_active=True).count()


class ServiceProviderSerializer(serializers.ModelSerializer):
    class Meta:
        model = ServiceProvider
        fields = [
            'id', 'business_name', 'description', 'logo', 'rating',
            'rating_count', 'service_area', 'is_verified', 'years_experience',
        ]


class ServiceListSerializer(serializers.ModelSerializer):
    provider_name = serializers.CharField(source='provider.business_name', read_only=True)
    category_name = serializers.CharField(source='category.name', read_only=True, default=None)

    class Meta:
        model = Service
        fields = [
            'id', 'name', 'provider_name', 'category_name', 'price',
            'rating', 'rating_count', 'image', 'duration_minutes',
            'is_featured',
        ]


class ServiceDetailSerializer(serializers.ModelSerializer):
    provider = ServiceProviderSerializer(read_only=True)
    category = ServiceCategorySerializer(read_only=True)

    class Meta:
        model = Service
        fields = [
            'id', 'name', 'provider', 'category', 'price', 'description',
            'rating', 'rating_count', 'image', 'duration_minutes',
            'is_featured', 'created_at',
        ]


class ServiceBookingSerializer(serializers.ModelSerializer):
    service_name = serializers.CharField(source='service.name', read_only=True)
    provider_name = serializers.CharField(source='service.provider.business_name', read_only=True)
    status_display = serializers.CharField(source='get_status_display', read_only=True)

    class Meta:
        model = ServiceBooking
        fields = [
            'id', 'service', 'service_name', 'provider_name', 'booking_date',
            'booking_time', 'address', 'address_text', 'notes', 'status',
            'status_display', 'price', 'created_at',
        ]
        read_only_fields = ['id', 'status', 'price', 'created_at']

    def create(self, validated_data):
        validated_data['customer'] = self.context['request'].user
        validated_data['price'] = validated_data['service'].price
        return super().create(validated_data)
