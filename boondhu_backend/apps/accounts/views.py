"""
Accounts Views — Auth, Profile, Address, PaymentMethod APIs
"""

from django.contrib.auth import get_user_model
from rest_framework import generics, status, permissions, viewsets
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView
from drf_spectacular.utils import extend_schema, extend_schema_view

from .models import UserAddress, UserPaymentMethod
from .serializers import (
    RegisterSerializer,
    CustomTokenObtainPairSerializer,
    UserProfileSerializer,
    UserProfileUpdateSerializer,
    ChangePasswordSerializer,
    UserAddressSerializer,
    UserPaymentMethodSerializer,
)

User = get_user_model()


# ---------------------------------------------------------------------------
# Auth Views
# ---------------------------------------------------------------------------

@extend_schema(tags=['Auth'])
class RegisterView(generics.CreateAPIView):
    """Register a new user account."""
    serializer_class = RegisterSerializer
    permission_classes = [permissions.AllowAny]

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()
        return Response(
            {
                'message': 'Account created successfully.',
                'user': UserProfileSerializer(user).data,
            },
            status=status.HTTP_201_CREATED,
        )


@extend_schema(tags=['Auth'])
class LoginView(TokenObtainPairView):
    """Login with phone + password, returns JWT tokens + user info."""
    serializer_class = CustomTokenObtainPairSerializer


@extend_schema(tags=['Auth'])
class TokenRefreshView(TokenRefreshView):
    """Refresh an expired access token using the refresh token."""
    pass


# ---------------------------------------------------------------------------
# Profile Views
# ---------------------------------------------------------------------------

@extend_schema(tags=['Auth'])
class ProfileView(generics.RetrieveUpdateAPIView):
    """Get or update the authenticated user's profile."""
    permission_classes = [permissions.IsAuthenticated]

    def get_serializer_class(self):
        if self.request.method in ['PUT', 'PATCH']:
            return UserProfileUpdateSerializer
        return UserProfileSerializer

    def get_object(self):
        return self.request.user


@extend_schema(tags=['Auth'])
class ChangePasswordView(generics.UpdateAPIView):
    """Change the authenticated user's password."""
    serializer_class = ChangePasswordSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_object(self):
        return self.request.user

    def update(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        request.user.set_password(serializer.validated_data['new_password'])
        request.user.save()
        return Response({'message': 'Password updated successfully.'})


# ---------------------------------------------------------------------------
# Address Views
# ---------------------------------------------------------------------------

@extend_schema_view(
    list=extend_schema(tags=['Auth']),
    create=extend_schema(tags=['Auth']),
    retrieve=extend_schema(tags=['Auth']),
    update=extend_schema(tags=['Auth']),
    partial_update=extend_schema(tags=['Auth']),
    destroy=extend_schema(tags=['Auth']),
)
class UserAddressViewSet(viewsets.ModelViewSet):
    """CRUD operations for user addresses."""
    serializer_class = UserAddressSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return UserAddress.objects.filter(user=self.request.user)


# ---------------------------------------------------------------------------
# Payment Method Views
# ---------------------------------------------------------------------------

@extend_schema_view(
    list=extend_schema(tags=['Auth']),
    create=extend_schema(tags=['Auth']),
    retrieve=extend_schema(tags=['Auth']),
    update=extend_schema(tags=['Auth']),
    partial_update=extend_schema(tags=['Auth']),
    destroy=extend_schema(tags=['Auth']),
)
class UserPaymentMethodViewSet(viewsets.ModelViewSet):
    """CRUD operations for saved payment methods."""
    serializer_class = UserPaymentMethodSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return UserPaymentMethod.objects.filter(user=self.request.user)
