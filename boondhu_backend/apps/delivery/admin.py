"""
Delivery Admin
"""

from django.contrib import admin
from django.utils.html import format_html
from .models import DeliveryParcel


@admin.register(DeliveryParcel)
class DeliveryParcelAdmin(admin.ModelAdmin):
    list_display = [
        'tracking_number', 'sender', 'pickup_short', 'delivery_short',
        'parcel_type', 'status_badge', 'price_display', 'rider', 'eta', 'created_at',
    ]
    list_filter = ['status', 'parcel_type', 'weight', 'created_at']
    search_fields = [
        'tracking_number', 'sender__phone', 'sender_name',
        'recipient_name', 'recipient_phone',
    ]
    raw_id_fields = ['sender', 'rider']
    list_editable = ['rider']
    readonly_fields = ['tracking_number', 'delivered_at']
    date_hierarchy = 'created_at'

    fieldsets = (
        ('Tracking', {'fields': ('tracking_number', 'status', 'eta')}),
        ('Sender', {'fields': ('sender', 'sender_name', 'sender_phone')}),
        ('Pickup', {'fields': ('pickup_address', 'pickup_area')}),
        ('Recipient', {'fields': ('recipient_name', 'recipient_phone')}),
        ('Delivery', {'fields': ('delivery_address', 'delivery_area')}),
        ('Parcel Details', {'fields': ('parcel_type', 'weight', 'description', 'image')}),
        ('Assignment', {'fields': ('rider', 'price', 'notes')}),
        ('Completion', {'fields': ('delivered_at',)}),
    )

    actions = ['mark_in_transit', 'mark_delivered']

    def pickup_short(self, obj):
        return obj.pickup_address[:40] + '...' if len(obj.pickup_address) > 40 else obj.pickup_address
    pickup_short.short_description = 'From'

    def delivery_short(self, obj):
        return obj.delivery_address[:40] + '...' if len(obj.delivery_address) > 40 else obj.delivery_address
    delivery_short.short_description = 'To'

    def price_display(self, obj):
        return f'৳{obj.price}'
    price_display.short_description = 'Fee'

    def status_badge(self, obj):
        colors = {
            'pending': '#F59E0B',
            'accepted': '#3B82F6',
            'picked_up': '#8B5CF6',
            'in_transit': '#6366F1',
            'delivered': '#22C55E',
            'cancelled': '#EF4444',
            'returned': '#64748B',
        }
        color = colors.get(obj.status, '#64748B')
        return format_html(
            '<span style="background: {}; color: white; padding: 3px 10px; '
            'border-radius: 12px; font-size: 11px; font-weight: 600;">{}</span>',
            color, obj.get_status_display(),
        )
    status_badge.short_description = 'Status'

    @admin.action(description='Mark selected as In Transit')
    def mark_in_transit(self, request, queryset):
        queryset.update(status='in_transit')

    @admin.action(description='Mark selected as Delivered')
    def mark_delivered(self, request, queryset):
        from django.utils import timezone
        queryset.update(status='delivered', delivered_at=timezone.now())
