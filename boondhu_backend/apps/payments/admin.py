"""
Payments Admin
"""

from django.contrib import admin
from django.utils.html import format_html
from .models import Payment


@admin.register(Payment)
class PaymentAdmin(admin.ModelAdmin):
    list_display = [
        'id', 'order', 'amount_display', 'method',
        'status', 'status_badge', 'transaction_id', 'paid_at', 'created_at',
    ]
    list_filter = ['status', 'method', 'created_at']
    search_fields = ['transaction_id', 'order__order_number', 'order__user__phone']
    raw_id_fields = ['order']
    list_editable = ['status']
    readonly_fields = ['amount', 'method', 'gateway_response']
    date_hierarchy = 'created_at'

    def amount_display(self, obj):
        return f'৳{obj.amount}'
    amount_display.short_description = 'Amount'

    def status_badge(self, obj):
        colors = {
            'pending': '#F59E0B',
            'completed': '#22C55E',
            'failed': '#EF4444',
            'refunded': '#64748B',
            'cancelled': '#EF4444',
        }
        color = colors.get(obj.status, '#64748B')
        return format_html(
            '<span style="background: {}; color: white; padding: 3px 10px; '
            'border-radius: 12px; font-size: 11px; font-weight: 600;">{}</span>',
            color, obj.get_status_display(),
        )
    status_badge.short_description = 'Status'
