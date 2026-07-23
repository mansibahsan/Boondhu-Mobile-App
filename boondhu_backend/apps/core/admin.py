"""
Core Admin — Site Settings management.
"""

from django.contrib import admin
from .models import SiteSettings


@admin.register(SiteSettings)
class SiteSettingsAdmin(admin.ModelAdmin):
    """Admin for the singleton SiteSettings model."""

    list_display = ('site_name', 'tagline', 'logo_preview', 'favicon_preview')
    fieldsets = (
        ('Branding', {
            'fields': ('site_name', 'tagline'),
            'description': 'General site branding information.',
        }),
        ('Logo & Favicon', {
            'fields': ('logo', 'logo_preview_large', 'favicon', 'favicon_preview_large'),
            'description': 'Upload your site logo and favicon. Changes will reflect in the admin panel after a page refresh.',
        }),
    )
    readonly_fields = ('logo_preview', 'favicon_preview', 'logo_preview_large', 'favicon_preview_large')

    def logo_preview(self, obj):
        if obj.logo:
            return admin.utils.format_html(
                '<img src="{}" style="height:30px; border-radius:4px;" />',
                obj.logo.url,
            )
        return '—'
    logo_preview.short_description = 'Logo'

    def favicon_preview(self, obj):
        if obj.favicon:
            return admin.utils.format_html(
                '<img src="{}" style="height:20px;" />',
                obj.favicon.url,
            )
        return '—'
    favicon_preview.short_description = 'Favicon'

    def logo_preview_large(self, obj):
        if obj.logo:
            return admin.utils.format_html(
                '<img src="{}" style="max-height:120px; border:1px solid #ccc; border-radius:8px; padding:8px; background:#f8f9fa;" />',
                obj.logo.url,
            )
        return 'No logo uploaded yet.'
    logo_preview_large.short_description = 'Current Logo'

    def favicon_preview_large(self, obj):
        if obj.favicon:
            return admin.utils.format_html(
                '<img src="{}" style="max-height:64px; border:1px solid #ccc; border-radius:4px; padding:4px; background:#f8f9fa;" />',
                obj.favicon.url,
            )
        return 'No favicon uploaded yet.'
    favicon_preview_large.short_description = 'Current Favicon'

    def has_add_permission(self, request):
        """Only allow one SiteSettings instance."""
        return not SiteSettings.objects.exists()

    def has_delete_permission(self, request, obj=None):
        """Prevent deletion of the singleton."""
        return False

    def changeform_view(self, request, object_id=None, form_url='', extra_context=None):
        """Auto-redirect to the singleton edit page."""
        extra_context = extra_context or {}
        extra_context['show_save_and_add_another'] = False
        extra_context['show_delete_link'] = False
        return super().changeform_view(request, object_id, form_url, extra_context)
