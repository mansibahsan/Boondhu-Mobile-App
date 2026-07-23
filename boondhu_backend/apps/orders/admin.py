"""
Orders Admin
"""

import csv
from django.contrib import admin
from django.http import HttpResponse
from django.utils.html import format_html
from .models import Order, OrderItem


class OrderItemInline(admin.TabularInline):
    model = OrderItem
    extra = 0
    fields = ['item_name', 'quantity', 'unit_price', 'total_price']
    readonly_fields = ['total_price']


@admin.register(Order)
class OrderAdmin(admin.ModelAdmin):
    list_display = [
        'order_number', 'user', 'order_type_badge', 'status_badge',
        'total_display', 'payment_status', 'payment_method', 'item_count',
        'created_at',
    ]
    list_filter = ['order_type', 'status', 'payment_status', 'payment_method', 'created_at']
    search_fields = ['order_number', 'user__phone', 'user__first_name']
    raw_id_fields = ['user', 'delivery_address']
    readonly_fields = ['order_number', 'total']
    inlines = [OrderItemInline]
    date_hierarchy = 'created_at'
    list_editable = ['payment_status']
    actions = ['mark_confirmed', 'mark_processing', 'mark_completed', 'export_as_csv']

    fieldsets = (
        ('Order Info', {'fields': ('order_number', 'user', 'order_type', 'status')}),
        ('Pricing', {'fields': ('subtotal', 'delivery_fee', 'discount', 'total')}),
        ('Payment', {'fields': ('payment_status', 'payment_method', 'coupon_code')}),
        ('Delivery', {'fields': ('delivery_address', 'delivery_address_text')}),
        ('Notes', {'fields': ('notes',)}),
    )

    def total_display(self, obj):
        return format_html('<strong>৳{}</strong>', obj.total)
    total_display.short_description = 'Total'

    def order_type_badge(self, obj):
        colors = {
            'store': '#3B82F6',
            'kitchen': '#F97316',
            'service': '#10B981',
            'delivery': '#8B5CF6',
        }
        color = colors.get(obj.order_type, '#64748B')
        return format_html(
            '<span style="background: {}; color: white; padding: 3px 10px; '
            'border-radius: 12px; font-size: 11px; font-weight: 600;">{}</span>',
            color, obj.get_order_type_display(),
        )
    order_type_badge.short_description = 'Type'

    def status_badge(self, obj):
        colors = {
            'pending': '#F59E0B',
            'confirmed': '#3B82F6',
            'processing': '#6366F1',
            'shipped': '#8B5CF6',
            'delivered': '#22C55E',
            'completed': '#059669',
            'cancelled': '#EF4444',
            'refunded': '#64748B',
        }
        color = colors.get(obj.status, '#64748B')
        return format_html(
            '<span style="background: {}; color: white; padding: 3px 10px; '
            'border-radius: 12px; font-size: 11px; font-weight: 600;">{}</span>',
            color, obj.get_status_display(),
        )
    status_badge.short_description = 'Status'

    def item_count(self, obj):
        return obj.items.count()
    item_count.short_description = 'Items'

    @admin.action(description='Mark as Confirmed')
    def mark_confirmed(self, request, queryset):
        queryset.update(status='confirmed')

    @admin.action(description='Mark as Processing')
    def mark_processing(self, request, queryset):
        queryset.update(status='processing')

    @admin.action(description='Mark as Completed')
    def mark_completed(self, request, queryset):
        queryset.update(status='completed')

    @admin.action(description='Export Selected to CSV')
    def export_as_csv(self, request, queryset):
        meta = self.model._meta
        field_names = [field.name for field in meta.fields]

        response = HttpResponse(content_type='text/csv')
        response['Content-Disposition'] = f'attachment; filename={meta.model_name}s.csv'
        writer = csv.writer(response)

        writer.writerow(field_names)
        for obj in queryset:
            writer.writerow([getattr(obj, field) for field in field_names])

        return response
