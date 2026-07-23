"""
Payments Models — Payment transaction records
"""

from django.db import models
from apps.core.models import TimeStampedModel


class Payment(TimeStampedModel):
    """Payment transaction record."""

    class Method(models.TextChoices):
        BKASH = 'bkash', 'bKash'
        NAGAD = 'nagad', 'Nagad'
        ROCKET = 'rocket', 'Rocket'
        CARD = 'card', 'Credit/Debit Card'
        COD = 'cod', 'Cash on Delivery'

    class Status(models.TextChoices):
        PENDING = 'pending', 'Pending'
        COMPLETED = 'completed', 'Completed'
        FAILED = 'failed', 'Failed'
        REFUNDED = 'refunded', 'Refunded'
        CANCELLED = 'cancelled', 'Cancelled'

    order = models.ForeignKey(
        'orders.Order',
        on_delete=models.CASCADE,
        related_name='payments',
    )
    amount = models.DecimalField(max_digits=10, decimal_places=2)
    method = models.CharField(max_length=20, choices=Method.choices)
    transaction_id = models.CharField(
        max_length=100,
        blank=True,
        unique=True,
        null=True,
        help_text='External payment gateway transaction ID',
    )
    status = models.CharField(
        max_length=20,
        choices=Status.choices,
        default=Status.PENDING,
        db_index=True,
    )
    gateway_response = models.JSONField(
        blank=True,
        null=True,
        help_text='Raw response from payment gateway',
    )
    paid_at = models.DateTimeField(null=True, blank=True)

    class Meta:
        verbose_name = 'Payment'
        verbose_name_plural = 'Payments'
        ordering = ['-created_at']

    def __str__(self):
        return f'Payment #{self.pk} — ৳{self.amount} ({self.get_status_display()})'
