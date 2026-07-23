"""
Notifications Admin
"""

from django.contrib import admin
from .models import Notification


@admin.register(Notification)
class NotificationAdmin(admin.ModelAdmin):
    list_display = [
        'title', 'user', 'notification_type', 'is_read', 'created_at',
    ]
    list_filter = ['notification_type', 'is_read', 'created_at']
    search_fields = ['title', 'message', 'user__phone', 'user__first_name']
    raw_id_fields = ['user']
    list_editable = ['is_read']
    date_hierarchy = 'created_at'
