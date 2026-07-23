"""
Orders Models — Order, OrderItem
Unified order system supporting all Boondhu verticals (store, kitchen, service, delivery).
"""

import uuid
from django.conf import settings
from django.db import models
from django.contrib.contenttypes.fields import GenericForeignKey
from django.contrib.contenttypes.models import ContentType
from apps.core.models import TimeStampedModel


class Order(TimeStampedModel):
    """
    Unified order model for all Boondhu verticals.
    Mapped from Flutter's OrdersScreen.
    """

    class OrderType(models.TextChoices):
        STORE = 'store', 'e-Store'
        KITCHEN = 'kitchen', 'e-Kitchen'
        SERVICE = 'service', 'e-Service'
        DELIVERY = 'delivery', 'e-Delivery'

    class Status(models.TextChoices):
        PENDING = 'pending', 'Pending'
        CONFIRMED = 'confirmed', 'Confirmed'
        PROCESSING = 'processing', 'Processing'
        SHIPPED = 'shipped', 'Shipped / On the Way'
        DELIVERED = 'delivered', 'Delivered'
        COMPLETED = 'completed', 'Completed'
        CANCELLED = 'cancelled', 'Cancelled'
        REFUNDED = 'refunded', 'Refunded'

    class PaymentStatus(models.TextChoices):
        UNPAID = 'unpaid', 'Unpaid'
        PAID = 'paid', 'Paid'
        PARTIALLY_PAID = 'partially_paid', 'Partially Paid'
        REFUNDED = 'refunded', 'Refunded'

    # Order identification
    order_number = models.CharField(
        max_length=20,
        unique=True,
        db_index=True,
        editable=False,
    )
    user = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.CASCADE,
        related_name='orders',
    )
    order_type = models.CharField(
        max_length=20,
        choices=OrderType.choices,
        db_index=True,
    )

    # Status
    status = models.CharField(
        max_length=20,
        choices=Status.choices,
        default=Status.PENDING,
        db_index=True,
    )

    # Pricing
    subtotal = models.DecimalField(max_digits=10, decimal_places=2, default=0)
    delivery_fee = models.DecimalField(max_digits=8, decimal_places=2, default=0)
    discount = models.DecimalField(max_digits=8, decimal_places=2, default=0)
    total = models.DecimalField(max_digits=10, decimal_places=2, default=0)

    # Payment
    payment_status = models.CharField(
        max_length=20,
        choices=PaymentStatus.choices,
        default=PaymentStatus.UNPAID,
    )
    payment_method = models.CharField(
        max_length=20,
        blank=True,
        help_text='Payment method used (bkash, nagad, card, cod)',
    )

    # Delivery address
    delivery_address = models.ForeignKey(
        'accounts.UserAddress',
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
    )
    delivery_address_text = models.TextField(blank=True)

    # Additional info
    notes = models.TextField(blank=True, help_text='Order notes from customer')
    coupon_code = models.CharField(max_length=50, blank=True)

    class Meta:
        verbose_name = 'Order'
        verbose_name_plural = 'Orders'
        ordering = ['-created_at']

    def __str__(self):
        return f'#{self.order_number} — {self.get_order_type_display()} ({self.get_status_display()})'

    def save(self, *args, **kwargs):
        if not self.order_number:
            prefix = self.order_type[0].upper() if self.order_type else 'X'
            self.order_number = f'B{prefix}{uuid.uuid4().hex[:8].upper()}'
        # Calculate total
        self.total = self.subtotal + self.delivery_fee - self.discount
        super().save(*args, **kwargs)

    @property
    def item_count(self):
        return self.items.count()


class OrderItem(TimeStampedModel):
    """
    Individual item in an order.
    Uses GenericForeignKey to reference Product, Meal, or Service.
    """
    order = models.ForeignKey(
        Order,
        on_delete=models.CASCADE,
        related_name='items',
    )

    # Generic foreign key to reference any item type
    content_type = models.ForeignKey(
        ContentType,
        on_delete=models.CASCADE,
        null=True,
        blank=True,
    )
    object_id = models.PositiveIntegerField(null=True, blank=True)
    content_object = GenericForeignKey('content_type', 'object_id')

    # Snapshot of item details at order time (prices may change)
    item_name = models.CharField(max_length=200)
    item_image = models.URLField(blank=True)
    quantity = models.PositiveIntegerField(default=1)
    unit_price = models.DecimalField(max_digits=10, decimal_places=2)
    total_price = models.DecimalField(max_digits=10, decimal_places=2)

    class Meta:
        verbose_name = 'Order Item'
        verbose_name_plural = 'Order Items'

    def __str__(self):
        return f'{self.item_name} x{self.quantity}'

    def save(self, *args, **kwargs):
        self.total_price = self.unit_price * self.quantity
        super().save(*args, **kwargs)
