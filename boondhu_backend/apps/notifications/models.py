"""
Notifications Models
Mapped from Flutter's NotificationsScreen.
"""

from django.conf import settings
from django.db import models
from apps.core.models import TimeStampedModel


class Notification(TimeStampedModel):
    """User notifications for order updates, promos, etc."""

    class NotificationType(models.TextChoices):
        ORDER = 'order', 'Order Update'
        PROMO = 'promo', 'Promotion'
        SYSTEM = 'system', 'System Alert'
        PAYMENT = 'payment', 'Payment Update'

    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='notifications',
    )
    title = models.CharField(max_length=200)
    message = models.TextField()
    notification_type = models.CharField(
        max_length=20,
        choices=NotificationType.choices,
        default=NotificationType.SYSTEM,
    )
    is_read = models.BooleanField(default=False, db_index=True)
    data = models.JSONField(
        blank=True,
        null=True,
        help_text='Additional data (e.g., order_id, deep_link)',
    )

    class Meta:
        verbose_name = 'Notification'
        verbose_name_plural = 'Notifications'
        ordering = ['-created_at']

    def __str__(self):
        return f'{self.title} — {self.user.phone}'
