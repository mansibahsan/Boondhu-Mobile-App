"""
Delivery Models — DeliveryParcel
Mapped from Flutter's DeliveryModel (from, to, status, type, weight, price, eta, image).
"""

import uuid
from django.conf import settings
from django.db import models
from apps.core.models import TimeStampedModel


class DeliveryParcel(TimeStampedModel):
    """
    Parcel delivery request.
    Directly mapped from Flutter's DeliveryModel.
    """

    class ParcelType(models.TextChoices):
        DOCUMENT = 'document', 'Document'
        SMALL_PARCEL = 'small_parcel', 'Small Parcel'
        MEDIUM_PARCEL = 'medium_parcel', 'Medium Parcel'
        LARGE_PARCEL = 'large_parcel', 'Large Parcel'
        FRAGILE = 'fragile', 'Fragile Item'
        FOOD = 'food', 'Food Delivery'

    class Status(models.TextChoices):
        PENDING = 'pending', 'Pending'
        ACCEPTED = 'accepted', 'Accepted'
        PICKED_UP = 'picked_up', 'Picked Up'
        IN_TRANSIT = 'in_transit', 'In Transit'
        DELIVERED = 'delivered', 'Delivered'
        CANCELLED = 'cancelled', 'Cancelled'
        RETURNED = 'returned', 'Returned'

    class WeightRange(models.TextChoices):
        LIGHT = 'up_to_1kg', 'Up to 1 kg'
        MEDIUM = '1_to_5kg', '1-5 kg'
        HEAVY = '5_to_10kg', '5-10 kg'
        EXTRA_HEAVY = 'above_10kg', 'Above 10 kg'

    # Tracking
    tracking_number = models.CharField(
        max_length=20,
        unique=True,
        db_index=True,
        editable=False,
    )

    # Sender
    sender = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='sent_parcels',
    )
    sender_name = models.CharField(max_length=100)
    sender_phone = models.CharField(max_length=20)

    # Addresses (mapped from Flutter's `from` and `to` fields)
    pickup_address = models.TextField(help_text='Pickup location')
    pickup_area = models.CharField(max_length=100, blank=True)
    delivery_address = models.TextField(help_text='Delivery location')
    delivery_area = models.CharField(max_length=100, blank=True)

    # Recipient
    recipient_name = models.CharField(max_length=100)
    recipient_phone = models.CharField(max_length=20)

    # Parcel details
    parcel_type = models.CharField(
        max_length=20,
        choices=ParcelType.choices,
        default=ParcelType.SMALL_PARCEL,
    )
    weight = models.CharField(
        max_length=20,
        choices=WeightRange.choices,
        default=WeightRange.LIGHT,
    )
    description = models.TextField(blank=True, help_text='Parcel description')
    image = models.ImageField(upload_to='delivery/parcels/', blank=True, null=True)

    # Pricing
    price = models.DecimalField(
        max_digits=8,
        decimal_places=2,
        help_text='Delivery fee in BDT (৳)',
    )

    # Status & tracking
    status = models.CharField(
        max_length=20,
        choices=Status.choices,
        default=Status.PENDING,
        db_index=True,
    )
    rider = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='delivery_assignments',
        limit_choices_to={'user_type': 'rider'},
    )
    eta = models.CharField(max_length=50, default='Calculating...', help_text='Estimated time of arrival')
    delivered_at = models.DateTimeField(null=True, blank=True)
    notes = models.TextField(blank=True, help_text='Delivery instructions')

    class Meta:
        verbose_name = 'Delivery Parcel'
        verbose_name_plural = 'Delivery Parcels'
        ordering = ['-created_at']

    def __str__(self):
        return f'{self.tracking_number} — {self.get_status_display()}'

    def save(self, *args, **kwargs):
        if not self.tracking_number:
            self.tracking_number = f'BD{uuid.uuid4().hex[:8].upper()}'
        super().save(*args, **kwargs)
