"""
Services Admin
"""

from django.contrib import admin
from .models import ServiceCategory, ServiceProvider, Service, ServiceBooking


@admin.register(ServiceCategory)
class ServiceCategoryAdmin(admin.ModelAdmin):
    list_display = ['name', 'slug', 'is_active', 'sort_order']
    list_editable = ['is_active', 'sort_order']
    prepopulated_fields = {'slug': ('name',)}


class ServiceInline(admin.TabularInline):
    model = Service
    extra = 0
    fields = ['name', 'category', 'price', 'duration_minutes', 'rating', 'is_active', 'is_featured']


@admin.register(ServiceProvider)
class ServiceProviderAdmin(admin.ModelAdmin):
    list_display = [
        'business_name', 'service_area', 'rating', 'is_verified',
        'is_active', 'years_experience',
    ]
    list_filter = ['is_verified', 'is_active', 'categories']
    search_fields = ['business_name', 'service_area']
    raw_id_fields = ['user']
    filter_horizontal = ['categories']
    inlines = [ServiceInline]
    list_editable = ['is_verified', 'is_active']


@admin.register(Service)
class ServiceAdmin(admin.ModelAdmin):
    list_display = [
        'name', 'provider', 'category', 'price_display',
        'duration_display', 'rating', 'is_featured', 'is_active',
    ]
    list_filter = ['category', 'is_featured', 'is_active']
    search_fields = ['name', 'description', 'provider__business_name']
    raw_id_fields = ['provider']
    list_editable = ['is_featured', 'is_active']

    def price_display(self, obj):
        return f'৳{obj.price}'
    price_display.short_description = 'Price'

    def duration_display(self, obj):
        return f'{obj.duration_minutes} min'
    duration_display.short_description = 'Duration'


@admin.register(ServiceBooking)
class ServiceBookingAdmin(admin.ModelAdmin):
    list_display = [
        'id', 'customer', 'service', 'booking_date', 'booking_time',
        'status', 'price_display', 'created_at',
    ]
    list_filter = ['status', 'booking_date', 'created_at']
    search_fields = ['customer__phone', 'service__name']
    raw_id_fields = ['customer', 'service', 'address']
    list_editable = ['status']

    def price_display(self, obj):
        return f'৳{obj.price}'
    price_display.short_description = 'Price'
