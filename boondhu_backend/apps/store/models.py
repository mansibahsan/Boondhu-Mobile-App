"""
Store Models — ProductCategory, Product, ProductImage
Mapped from Flutter's Product model and StoreScreen.
Categories: Groceries, Bakery, Dairy, Medicine, Cleaning (from mock data).
"""

from django.conf import settings
from django.db import models
from django.utils.text import slugify
from apps.core.models import TimeStampedModel, RatableModel, ActiveModel, SortableModel


class ProductCategory(TimeStampedModel, ActiveModel, SortableModel):
    """Product categories — Groceries, Bakery, Dairy, Medicine, Cleaning, etc."""
    name = models.CharField(max_length=100)
    slug = models.SlugField(max_length=120, unique=True, db_index=True)
    description = models.TextField(blank=True)
    icon = models.CharField(
        max_length=50,
        blank=True,
        help_text='Icon name (e.g., shopping_basket, local_pharmacy)',
    )
    image = models.ImageField(upload_to='store/categories/', blank=True, null=True)

    class Meta:
        verbose_name = 'Product Category'
        verbose_name_plural = 'Product Categories'
        ordering = ['sort_order', 'name']

    def __str__(self):
        return self.name

    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = slugify(self.name)
        super().save(*args, **kwargs)


class Product(TimeStampedModel, RatableModel, ActiveModel):
    """
    Store product — mapped from Flutter's Product model.
    Extended with vendor support, stock management, and unit pricing.
    """
    name = models.CharField(max_length=200, db_index=True)
    slug = models.SlugField(max_length=220, unique=True, db_index=True)
    category = models.ForeignKey(
        ProductCategory,
        on_delete=models.SET_NULL,
        null=True,
        related_name='products',
    )
    vendor = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='store_products',
        limit_choices_to={'user_type': 'vendor'},
        help_text='Product vendor/seller',
    )
    price = models.DecimalField(
        max_digits=10,
        decimal_places=2,
        help_text='Price in BDT (৳)',
    )
    discount_price = models.DecimalField(
        max_digits=10,
        decimal_places=2,
        blank=True,
        null=True,
        help_text='Discounted price in BDT (৳). Leave blank if no discount.',
    )
    unit = models.CharField(
        max_length=20,
        default='piece',
        help_text='Unit of measurement (e.g., kg, piece, pack, bottle)',
    )
    description = models.TextField(
        default='Premium quality product sourced directly from the best producers.',
    )
    stock_quantity = models.PositiveIntegerField(
        default=0,
        help_text='Available stock quantity',
    )
    is_featured = models.BooleanField(
        default=False,
        db_index=True,
        help_text='Show in featured/trending section',
    )

    class Meta:
        verbose_name = 'Product'
        verbose_name_plural = 'Products'
        ordering = ['-is_featured', '-created_at']

    def __str__(self):
        return self.name

    def save(self, *args, **kwargs):
        if not self.slug:
            self.slug = slugify(self.name)
        super().save(*args, **kwargs)

    @property
    def effective_price(self):
        """Returns discount price if available, else regular price."""
        return self.discount_price if self.discount_price else self.price

    @property
    def discount_percentage(self):
        """Calculate discount percentage."""
        if self.discount_price and self.price > 0:
            return round((1 - self.discount_price / self.price) * 100)
        return 0

    @property
    def in_stock(self):
        return self.stock_quantity > 0

    @property
    def primary_image(self):
        """Return the primary image URL or the first available image."""
        img = self.images.filter(is_primary=True).first()
        if not img:
            img = self.images.first()
        return img


class ProductImage(TimeStampedModel):
    """Product images — supports multiple images per product."""
    product = models.ForeignKey(
        Product,
        on_delete=models.CASCADE,
        related_name='images',
    )
    image = models.ImageField(upload_to='store/products/')
    alt_text = models.CharField(max_length=200, blank=True)
    is_primary = models.BooleanField(
        default=False,
        help_text='Mark as the primary/thumbnail image',
    )

    class Meta:
        verbose_name = 'Product Image'
        verbose_name_plural = 'Product Images'
        ordering = ['-is_primary', 'created_at']

    def __str__(self):
        return f'{self.product.name} — Image'

    def save(self, *args, **kwargs):
        # Ensure only one primary image per product
        if self.is_primary:
            ProductImage.objects.filter(
                product=self.product, is_primary=True
            ).exclude(pk=self.pk).update(is_primary=False)
        super().save(*args, **kwargs)
