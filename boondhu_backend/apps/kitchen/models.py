"""
Kitchen Models — Kitchen, Meal
Mapped from Flutter's MealModel (name, kitchenName, price, rating, time, description, image).
"""

from django.conf import settings
from django.db import models
from apps.core.models import TimeStampedModel, RatableModel, ActiveModel


class Kitchen(TimeStampedModel, RatableModel, ActiveModel):
    """
    Kitchen/restaurant profile.
    Maps to Flutter's `kitchenName` field in MealModel.
    """
    name = models.CharField(max_length=200, db_index=True)
    owner = models.ForeignKey(
        settings.AUTH_USER_MODEL,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='kitchens',
        limit_choices_to={'user_type': 'kitchen_owner'},
    )
    description = models.TextField(blank=True)
    logo = models.ImageField(upload_to='kitchen/logos/', blank=True, null=True)
    cover_image = models.ImageField(upload_to='kitchen/covers/', blank=True, null=True)
    area = models.CharField(max_length=100, blank=True, help_text='Service area/locality')
    phone = models.CharField(max_length=20, blank=True)
    is_verified = models.BooleanField(default=False)
    opening_time = models.TimeField(default='08:00')
    closing_time = models.TimeField(default='22:00')
    minimum_order = models.DecimalField(
        max_digits=8, decimal_places=2, default=0,
        help_text='Minimum order amount in BDT',
    )
    delivery_fee = models.DecimalField(
        max_digits=8, decimal_places=2, default=30,
        help_text='Delivery fee in BDT',
    )

    class Meta:
        verbose_name = 'Kitchen'
        verbose_name_plural = 'Kitchens'
        ordering = ['-rating', 'name']

    def __str__(self):
        return self.name

    @property
    def meal_count(self):
        return self.meals.filter(is_available=True).count()


class MealCategory(TimeStampedModel):
    """Meal categories (e.g., Biryani, BBQ, Snacks, Drinks)."""
    name = models.CharField(max_length=100)
    icon = models.CharField(max_length=50, blank=True)

    class Meta:
        verbose_name = 'Meal Category'
        verbose_name_plural = 'Meal Categories'
        ordering = ['name']

    def __str__(self):
        return self.name


class Meal(TimeStampedModel, RatableModel):
    """
    Meal/food item offered by a kitchen.
    Directly mapped from Flutter's MealModel.
    """
    name = models.CharField(max_length=200, db_index=True)
    kitchen = models.ForeignKey(
        Kitchen,
        on_delete=models.CASCADE,
        related_name='meals',
    )
    category = models.ForeignKey(
        MealCategory,
        on_delete=models.SET_NULL,
        null=True,
        blank=True,
        related_name='meals',
    )
    price = models.DecimalField(
        max_digits=8,
        decimal_places=2,
        help_text='Price in BDT (৳)',
    )
    description = models.TextField(blank=True)
    preparation_time = models.CharField(
        max_length=50,
        default='30 mins',
        help_text='Estimated preparation time (e.g., 30 mins)',
    )
    image = models.ImageField(upload_to='kitchen/meals/', blank=True, null=True)
    is_available = models.BooleanField(default=True, db_index=True)
    is_featured = models.BooleanField(default=False)
    is_vegetarian = models.BooleanField(default=False)
    is_spicy = models.BooleanField(default=False)

    class Meta:
        verbose_name = 'Meal'
        verbose_name_plural = 'Meals'
        ordering = ['-is_featured', '-rating', 'name']

    def __str__(self):
        return f'{self.name} — {self.kitchen.name}'
