"""
Accounts Serializers — Registration, Login, Profile, Address, PaymentMethod
"""

from django.contrib.auth import get_user_model
from rest_framework import serializers
from rest_framework_simplejwt.serializers import TokenObtainPairSerializer
from .models import UserAddress, UserPaymentMethod

User = get_user_model()


# ---------------------------------------------------------------------------
# Auth Serializers
# ---------------------------------------------------------------------------

class RegisterSerializer(serializers.ModelSerializer):
    """User registration — phone is required, email optional."""
    password = serializers.CharField(write_only=True, min_length=6)
    password_confirm = serializers.CharField(write_only=True, min_length=6)

    class Meta:
        model = User
        fields = [
            'phone', 'email', 'username', 'first_name', 'last_name',
            'password', 'password_confirm', 'user_type',
        ]
        extra_kwargs = {
            'email': {'required': False},
            'user_type': {'required': False},
            'username': {'required': False},
        }

    def validate_phone(self, value):
        """Ensure phone number is valid Bangladeshi format."""
        cleaned = value.replace(' ', '').replace('-', '')
        if not (cleaned.startswith('+880') or cleaned.startswith('01')):
            raise serializers.ValidationError(
                'Phone number must be a valid Bangladeshi number (e.g., +8801XXXXXXXXX or 01XXXXXXXXX).'
            )
        return cleaned

    def validate(self, attrs):
        if attrs['password'] != attrs.pop('password_confirm'):
            raise serializers.ValidationError({'password_confirm': 'Passwords do not match.'})
        return attrs

    def create(self, validated_data):
        password = validated_data.pop('password')
        # Auto-generate username from phone if not provided
        if not validated_data.get('username'):
            validated_data['username'] = validated_data['phone'].replace('+', '')
        user = User(**validated_data)
        user.set_password(password)
        user.save()
        return user


class CustomTokenObtainPairSerializer(TokenObtainPairSerializer):
    """Custom JWT token serializer that includes user info in response."""
    username_field = 'phone'

    def validate(self, attrs):
        data = super().validate(attrs)
        # Add user info to token response
        data['user'] = UserProfileSerializer(self.user).data
        return data


class UserProfileSerializer(serializers.ModelSerializer):
    """Full user profile serializer."""
    full_name = serializers.ReadOnlyField()
    total_orders = serializers.SerializerMethodField()
    wallet_balance = serializers.SerializerMethodField()
    reward_points = serializers.SerializerMethodField()

    class Meta:
        model = User
        fields = [
            'id', 'phone', 'email', 'username', 'first_name', 'last_name',
            'full_name', 'avatar', 'user_type', 'gender', 'date_of_birth',
            'is_verified', 'date_joined', 'total_orders', 'wallet_balance', 'reward_points'
        ]
        read_only_fields = ['id', 'phone', 'is_verified', 'date_joined', 'user_type']

    def get_total_orders(self, obj):
        if hasattr(obj, 'orders'):
            return obj.orders.count()
        return 0

    def get_wallet_balance(self, obj):
        return 0

    def get_reward_points(self, obj):
        return 0


class UserProfileUpdateSerializer(serializers.ModelSerializer):
    """Serializer for updating user profile."""

    class Meta:
        model = User
        fields = [
            'first_name', 'last_name', 'email', 'avatar',
            'gender', 'date_of_birth',
        ]


class ChangePasswordSerializer(serializers.Serializer):
    """Serializer for changing password."""
    old_password = serializers.CharField(required=True)
    new_password = serializers.CharField(required=True, min_length=6)

    def validate_old_password(self, value):
        user = self.context['request'].user
        if not user.check_password(value):
            raise serializers.ValidationError('Current password is incorrect.')
        return value


# ---------------------------------------------------------------------------
# Address Serializers
# ---------------------------------------------------------------------------

class UserAddressSerializer(serializers.ModelSerializer):
    """User address CRUD serializer."""

    class Meta:
        model = UserAddress
        fields = [
            'id', 'label', 'full_name', 'phone', 'full_address',
            'area', 'city', 'postal_code', 'latitude', 'longitude',
            'is_default', 'created_at',
        ]
        read_only_fields = ['id', 'created_at']

    def create(self, validated_data):
        validated_data['user'] = self.context['request'].user
        return super().create(validated_data)


# ---------------------------------------------------------------------------
# Payment Method Serializers
# ---------------------------------------------------------------------------

class UserPaymentMethodSerializer(serializers.ModelSerializer):
    """Payment method CRUD serializer."""
    method_type_display = serializers.CharField(
        source='get_method_type_display', read_only=True,
    )

    class Meta:
        model = UserPaymentMethod
        fields = [
            'id', 'method_type', 'method_type_display', 'account_number',
            'holder_name', 'is_default', 'created_at',
        ]
        read_only_fields = ['id', 'created_at']

    def create(self, validated_data):
        validated_data['user'] = self.context['request'].user
        return super().create(validated_data)
