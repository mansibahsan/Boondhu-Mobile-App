"""
Core Context Processors — Provide site settings to all templates.
"""

from .models import SiteSettings


def site_settings(request):
    """Inject SiteSettings into every template context."""
    try:
        settings = SiteSettings.load()
    except Exception:
        settings = None

    return {
        'site_settings': settings,
    }
