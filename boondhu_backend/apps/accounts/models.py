"""
Accounts Models — User, UserAddress, UserPaymentMethod
Mapped from the Flutter app's auth, profile, shipping_addresses, and payment_methods screens.
"""

from django.contrib.auth.models import AbstractUser
from django.db import models
from apps.core.models import TimeStampedModel


class User(AbstractUser):
    """
    Custom User model extending Django's AbstractUser.
    Supports phone-based auth (common in Bangladesh) alongside email.
    """

    class UserType(models.TextChoices):
        CUSTOMER = 'customer', 'Customer'
        VENDOR = 'vendor', 'Vendor'
        KITCHEN_OWNER = 'kitchen_owner', 'Kitchen Owner'
        SERVICE_PROVIDER = 'service_provider', 'Service Provider'
        RIDER = 'rider', 'Delivery Rider'
        ADMIN = 'admin', 'Admin'

    class Gender(models.TextChoices):
        MALE = 'male', 'Male'
        FEMALE = 'female', 'Female'
        OTHER = 'other', 'Other'

    # Override email to make it optional (phone is primary in BD)
    email = models.EmailField('email address', blank=True, null=True, unique=True)
    phone = models.CharField(
        max_length=20,
        unique=True,
        help_text='Primary phone number (e.g., +8801XXXXXXXXX)',
    )
    avatar = models.ImageField(
        upload_to='avatars/',
        blank=True,
        null=True,
        help_text='Profile picture',
    )
    user_type = models.CharField(
        max_length=20,
        choices=UserType.choices,
        default=UserType.CUSTOMER,
        db_index=True,
    )
    gender = models.CharField(
        max_length=10,
        choices=Gender.choices,
        blank=True,
    )
    date_of_birth = models.DateField(blank=True, null=True)
    is_verified = models.BooleanField(
        default=False,
        help_text='Whether the user has verified their phone/email',
    )

    # Use phone as the login field
    USERNAME_FIELD = 'phone'
    REQUIRED_FIELDS = ['username', 'first_name']

    class Meta:
        verbose_name = 'User'
        verbose_name_plural = 'Users'
        ordering = ['-date_joined']

    def __str__(self):
        type_display = 'admin' if self.is_superuser else self.user_type
        return f'{self.get_full_name() or self.phone} ({type_display})'

    @property
    def full_name(self):
        return self.get_full_name() or self.phone


class UserAddress(TimeStampedModel):
    """
    User shipping/delivery addresses.
    Mapped from Flutter's ShippingAddressesScreen.
    """

    class AddressLabel(models.TextChoices):
        HOME = 'home', 'Home'
        OFFICE = 'office', 'Office'
        OTHER = 'other', 'Other'

    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='addresses',
    )
    label = models.CharField(
        max_length=20,
        choices=AddressLabel.choices,
        default=AddressLabel.HOME,
    )
    full_name = models.CharField(max_length=100, help_text='Recipient name')
    phone = models.CharField(max_length=20, help_text='Recipient phone')
    full_address = models.TextField(help_text='Full street address')
    area = models.CharField(max_length=100, blank=True, help_text='Area/locality')
    city = models.CharField(max_length=100, default='Dhaka')
    postal_code = models.CharField(max_length=10, blank=True)
    latitude = models.DecimalField(
        max_digits=10, decimal_places=7, blank=True, null=True,
    )
    longitude = models.DecimalField(
        max_digits=10, decimal_places=7, blank=True, null=True,
    )
    is_default = models.BooleanField(default=False)

    class Meta:
        verbose_name = 'User Address'
        verbose_name_plural = 'User Addresses'
        ordering = ['-is_default', '-created_at']

    def __str__(self):
        return f'{self.label.title()} — {self.full_address[:50]}'

    def save(self, *args, **kwargs):
        # Ensure only one default address per user
        if self.is_default:
            UserAddress.objects.filter(
                user=self.user, is_default=True
            ).exclude(pk=self.pk).update(is_default=False)
        super().save(*args, **kwargs)


class UserPaymentMethod(TimeStampedModel):
    """
    Saved payment methods for the user.
    Mapped from Flutter's PaymentMethodsScreen.
    Supports bKash, Nagad, cards, and COD (common in Bangladesh).
    """

    class MethodType(models.TextChoices):
        BKASH = 'bkash', 'bKash'
        NAGAD = 'nagad', 'Nagad'
        ROCKET = 'rocket', 'Rocket'
        CARD = 'card', 'Credit/Debit Card'
        COD = 'cod', 'Cash on Delivery'

    user = models.ForeignKey(
        User,
        on_delete=models.CASCADE,
        related_name='payment_methods',
    )
    method_type = models.CharField(
        max_length=20,
        choices=MethodType.choices,
    )
    # For mobile wallets: phone number; for cards: masked card number
    account_number = models.CharField(
        max_length=50,
        blank=True,
        help_text='Phone number (bKash/Nagad) or masked card number',
    )
    holder_name = models.CharField(max_length=100, blank=True)
    is_default = models.BooleanField(default=False)

    class Meta:
        verbose_name = 'Payment Method'
        verbose_name_plural = 'Payment Methods'
        ordering = ['-is_default', '-created_at']

    def __str__(self):
        return f'{self.get_method_type_display()} — {self.account_number}'

    def save(self, *args, **kwargs):
        if self.is_default:
            UserPaymentMethod.objects.filter(
                user=self.user, is_default=True
            ).exclude(pk=self.pk).update(is_default=False)
        super().save(*args, **kwargs)
