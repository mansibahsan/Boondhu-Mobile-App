"""
Core Models — Abstract base models shared across all apps.
"""

import uuid
from django.db import models


class TimeStampedModel(models.Model):
    """Abstract base model with created/updated timestamps."""
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)

    class Meta:
        abstract = True
        ordering = ['-created_at']


class SluggedModel(TimeStampedModel):
    """Abstract model with a slug field for URL-friendly identifiers."""
    slug = models.SlugField(max_length=255, unique=True, db_index=True)

    class Meta:
        abstract = True


class UUIDModel(TimeStampedModel):
    """Abstract model using UUID as primary key."""
    id = models.UUIDField(primary_key=True, default=uuid.uuid4, editable=False)

    class Meta:
        abstract = True


class RatableModel(models.Model):
    """Abstract mixin for models that have a rating."""
    rating = models.DecimalField(
        max_digits=3,
        decimal_places=1,
        default=0.0,
        help_text='Average rating (0.0 - 5.0)',
    )
    rating_count = models.PositiveIntegerField(
        default=0,
        help_text='Number of ratings received',
    )

    class Meta:
        abstract = True


class ActiveModel(models.Model):
    """Abstract mixin for models with an active/inactive toggle."""
    is_active = models.BooleanField(default=True, db_index=True)

    class Meta:
        abstract = True


class SortableModel(models.Model):
    """Abstract mixin for models with a sort order."""
    sort_order = models.PositiveIntegerField(default=0)

    class Meta:
        abstract = True
        ordering = ['sort_order']


class SiteSettings(models.Model):
    """
    Singleton model for site-wide settings.
    Upload logo, favicon, and other branding assets from the admin panel.
    """
    site_name = models.CharField(
        max_length=100,
        default='Boondhu',
        help_text='Site name displayed in the admin header',
    )
    tagline = models.CharField(
        max_length=200,
        default='Always Everywhere',
        blank=True,
        help_text='Tagline shown in the admin footer',
    )
    logo = models.ImageField(
        upload_to='site/',
        blank=True,
        null=True,
        help_text='Main site logo (recommended: 200×200px PNG with transparent background)',
    )
    favicon = models.ImageField(
        upload_to='site/',
        blank=True,
        null=True,
        help_text='Favicon icon (recommended: 32×32px or 64×64px PNG)',
    )

    class Meta:
        verbose_name = 'Site Settings'
        verbose_name_plural = 'Site Settings'

    def __str__(self):
        return self.site_name

    def save(self, *args, **kwargs):
        """Ensure only one SiteSettings instance exists (singleton)."""
        self.pk = 1
        super().save(*args, **kwargs)

    def delete(self, *args, **kwargs):
        """Prevent deletion of the singleton."""
        pass

    @classmethod
    def load(cls):
        """Load or create the singleton instance."""
        obj, _ = cls.objects.get_or_create(pk=1)
        return obj

