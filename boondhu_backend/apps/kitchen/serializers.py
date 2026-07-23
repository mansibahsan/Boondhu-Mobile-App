"""
Kitchen Serializers
"""

from rest_framework import serializers
from .models import Kitchen, Meal, MealCategory


class MealCategorySerializer(serializers.ModelSerializer):
    class Meta:
        model = MealCategory
        fields = ['id', 'name', 'icon']


class KitchenListSerializer(serializers.ModelSerializer):
    meal_count = serializers.ReadOnlyField()

    class Meta:
        model = Kitchen
        fields = [
            'id', 'name', 'logo', 'cover_image', 'area', 'rating',
            'rating_count', 'is_verified', 'meal_count', 'delivery_fee',
            'opening_time', 'closing_time',
        ]


class KitchenDetailSerializer(serializers.ModelSerializer):
    meal_count = serializers.ReadOnlyField()

    class Meta:
        model = Kitchen
        fields = [
            'id', 'name', 'description', 'logo', 'cover_image', 'area',
            'phone', 'rating', 'rating_count', 'is_verified', 'meal_count',
            'opening_time', 'closing_time', 'minimum_order', 'delivery_fee',
        ]


class MealListSerializer(serializers.ModelSerializer):
    """Lightweight meal serializer for list views."""
    kitchen_name = serializers.CharField(source='kitchen.name', read_only=True)
    category_name = serializers.CharField(source='category.name', read_only=True, default=None)

    class Meta:
        model = Meal
        fields = [
            'id', 'name', 'kitchen_name', 'category_name', 'price',
            'rating', 'preparation_time', 'image', 'is_available',
            'is_featured', 'is_vegetarian', 'is_spicy',
        ]


class MealDetailSerializer(serializers.ModelSerializer):
    """Full meal detail serializer."""
    kitchen = KitchenListSerializer(read_only=True)
    category = MealCategorySerializer(read_only=True)

    class Meta:
        model = Meal
        fields = [
            'id', 'name', 'kitchen', 'category', 'price', 'description',
            'rating', 'rating_count', 'preparation_time', 'image',
            'is_available', 'is_featured', 'is_vegetarian', 'is_spicy',
            'created_at',
        ]
