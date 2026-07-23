"""
Services Models — ServiceCategory, ServiceProvider, Service, ServiceBooking
Mapped from Flutter's ServiceModel (name, providerName, price, rating, description, category, image).
"""

from django.conf import settings
from django.db import models
from apps.core.models import TimeStampedModel, RatableModel, ActiveModel, SortableModel


class ServiceCategory(TimeStampedModel, ActiveModel, SortableModel):
    """
    Service categories — Cleaning, AC Service, Plumbing, Electrical, etc.
    Mapped from Flutter's service categories.
    """
    name = models.CharField(max_length=100)
    slug = models.SlugField(max_length=120, unique=True)
    description = models.TextField(blank=True)
    icon = models.CharField(max_length=50, blank=True, help_text='Icon name')
    image = models.ImageField(upload_to='services/categories/', blank=True, null=True)

    class Meta:
        verbose_name = 'Service Category'
        verbose_name_plural = 'Service Categories'
        ordering = ['sort_order', 'name']

    def __str__(self):
        return self.name


class ServiceProvider(TimeStampedModel, RatableModel, ActiveModel):
    """
    Service provider profile.
    Maps to Flutter's `providerName` field in ServiceModel.
    """
    user = models.OneToOneField(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='service_provider_profile',
        limit_choices_to={'user_type': 'service_provider'},
    )
    business_name = models.CharField(max_length=200, db_index=True)
    description = models.TextField(blank=True)
    logo = models.ImageField(upload_to='services/providers/', blank=True, null=True)
    categories = models.ManyToManyField(
        ServiceCategory,
        related_name='providers',
        blank=True,
    )
    phone = models.CharField(max_length=20, blank=True)
    service_area = models.CharField(max_length=200, blank=True, help_text='Areas served')
    is_verified = models.BooleanField(default=False)
    years_experience = models.PositiveIntegerField(default=0)

    class Meta:
        verbose_name = 'Service Provider'
        verbose_name_plural = 'Service Providers'
        ordering = ['-rating', 'business_name']

    def __str__(self):
        return self.business_name


class Service(TimeStampedModel, RatableModel, ActiveModel):
    """
    Individual service offering.
    Directly mapped from Flutter's ServiceModel.
    """
    name = models.CharField(max_length=200, db_index=True)
    provider = models.ForeignKey(
        ServiceProvider,
        on_delete=models.CASCADE,
        related_name='services',
    )
    category = models.ForeignKey(
        ServiceCategory,
        on_delete=models.SET_NULL,
        null=True,
        related_name='services',
    )
    price = models.DecimalField(
        max_digits=10,
        decimal_places=2,
        help_text='Base price in BDT (৳)',
    )
    description = models.TextField(blank=True)
    image = models.ImageField(upload_to='services/items/', blank=True, null=True)
    duration_minutes = models.PositiveIntegerField(
        default=60,
        help_text='Estimated service duration in minutes',
    )
    is_featured = models.BooleanField(default=False)

    class Meta:
        verbose_name = 'Service'
        verbose_name_plural = 'Services'
        ordering = ['-is_featured', '-rating', 'name']

    def __str__(self):
        return f'{self.name} — {self.provider.business_name}'


class ServiceBooking(TimeStampedModel):
    """
    Service booking made by a customer.
    Mapped from Flutter's ServiceBookingScreen.
    """

    class Status(models.TextChoices):
        PENDING = 'pending', 'Pending'
        CONFIRMED = 'confirmed', 'Confirmed'
        IN_PROGRESS = 'in_progress', 'In Progress'
        COMPLETED = 'completed', 'Completed'
        CANCELLED = 'cancelled', 'Cancelled'

    customer = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='service_bookings',
    )
    service = models.ForeignKey(
        Service,
        on_delete=models.CASCADE,
        related_name='bookings',
    )
    booking_date = models.DateField()
    booking_time = models.TimeField()
    address = models.ForeignKey(
        'accounts.UserAddress',
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
    )
    address_text = models.TextField(blank=True, help_text='Address if not from saved addresses')
    notes = models.TextField(blank=True, help_text='Special instructions')
    status = models.CharField(
        max_length=20,
        choices=Status.choices,
        default=Status.PENDING,
        db_index=True,
    )
    price = models.DecimalField(max_digits=10, decimal_places=2)

    class Meta:
        verbose_name = 'Service Booking'
        verbose_name_plural = 'Service Bookings'
        ordering = ['-created_at']

    def __str__(self):
        return f'Booking #{self.pk} — {self.service.name} ({self.status})'
