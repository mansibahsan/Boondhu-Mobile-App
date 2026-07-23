"""
Kitchen Admin
"""

from django.contrib import admin
from django.utils.html import format_html
from .models import Kitchen, Meal, MealCategory


class MealInline(admin.TabularInline):
    model = Meal
    extra = 0
    fields = ['name', 'price', 'preparation_time', 'rating', 'is_available', 'is_featured']


@admin.register(Kitchen)
class KitchenAdmin(admin.ModelAdmin):
    list_display = [
        'name', 'area', 'rating', 'meal_count_display', 'is_verified',
        'is_active', 'opening_time', 'closing_time',
    ]
    list_filter = ['is_verified', 'is_active', 'area']
    search_fields = ['name', 'area', 'description']
    raw_id_fields = ['owner']
    inlines = [MealInline]
    list_editable = ['is_verified', 'is_active']

    def meal_count_display(self, obj):
        return obj.meal_count
    meal_count_display.short_description = 'Available Meals'


@admin.register(MealCategory)
class MealCategoryAdmin(admin.ModelAdmin):
    list_display = ['name', 'icon']
    search_fields = ['name']


@admin.register(Meal)
class MealAdmin(admin.ModelAdmin):
    list_display = [
        'name', 'kitchen', 'price_display', 'preparation_time',
        'rating', 'is_available', 'is_featured',
    ]
    list_filter = ['kitchen', 'category', 'is_available', 'is_featured', 'is_vegetarian']
    search_fields = ['name', 'description', 'kitchen__name']
    raw_id_fields = ['kitchen']
    list_editable = ['is_available', 'is_featured']

    def price_display(self, obj):
        return f'৳{obj.price}'
    price_display.short_description = 'Price'
