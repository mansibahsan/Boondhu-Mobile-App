"""
Accounts Admin — Custom admin for User, Address, PaymentMethod
"""

from django.contrib import admin
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
from .models import User, UserAddress, UserPaymentMethod


class UserAddressInline(admin.TabularInline):
    model = UserAddress
    extra = 0
    fields = ['label', 'full_address', 'area', 'city', 'is_default']


class UserPaymentMethodInline(admin.TabularInline):
    model = UserPaymentMethod
    extra = 0
    fields = ['method_type', 'account_number', 'holder_name', 'is_default']


@admin.register(User)
class UserAdmin(BaseUserAdmin):
    list_display = [
        'phone', 'first_name', 'last_name', 'email',
        'user_type', 'is_verified', 'is_active', 'date_joined',
    ]
    list_filter = ['user_type', 'is_verified', 'is_active', 'is_staff', 'gender']
    search_fields = ['phone', 'email', 'first_name', 'last_name', 'username']
    ordering = ['-date_joined']

    fieldsets = (
        (None, {'fields': ('phone', 'username', 'password')}),
        ('Personal Info', {'fields': ('first_name', 'last_name', 'email', 'avatar', 'gender', 'date_of_birth')}),
        ('Account Type', {'fields': ('user_type', 'is_verified')}),
        ('Permissions', {
            'fields': ('is_active', 'is_staff', 'is_superuser', 'groups', 'user_permissions'),
            'classes': ('collapse',),
        }),
        ('Important Dates', {
            'fields': ('last_login', 'date_joined'),
            'classes': ('collapse',),
        }),
    )

    add_fieldsets = (
        (None, {
            'classes': ('wide',),
            'fields': ('phone', 'username', 'first_name', 'password1', 'password2', 'user_type'),
        }),
    )

    inlines = [UserAddressInline, UserPaymentMethodInline]


@admin.register(UserAddress)
class UserAddressAdmin(admin.ModelAdmin):
    list_display = ['user', 'label', 'full_address', 'city', 'is_default', 'created_at']
    list_filter = ['label', 'city', 'is_default']
    search_fields = ['full_address', 'area', 'user__phone', 'user__first_name']
    raw_id_fields = ['user']


@admin.register(UserPaymentMethod)
class UserPaymentMethodAdmin(admin.ModelAdmin):
    list_display = ['user', 'method_type', 'account_number', 'is_default', 'created_at']
    list_filter = ['method_type', 'is_default']
    search_fields = ['account_number', 'user__phone', 'user__first_name']
    raw_id_fields = ['user']
