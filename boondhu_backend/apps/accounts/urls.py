"""
Accounts URL Configuration
"""

from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views

router = DefaultRouter()
router.register(r'addresses', views.UserAddressViewSet, basename='address')
router.register(r'payment-methods', views.UserPaymentMethodViewSet, basename='payment-method')

urlpatterns = [
    # Auth endpoints
    path('register/', views.RegisterView.as_view(), name='register'),
    path('login/', views.LoginView.as_view(), name='login'),
    path('token/refresh/', views.TokenRefreshView.as_view(), name='token-refresh'),

    # Profile endpoints
    path('profile/', views.ProfileView.as_view(), name='profile'),
    path('change-password/', views.ChangePasswordView.as_view(), name='change-password'),

    # Address & Payment Method CRUD (routed by ViewSets)
    path('', include(router.urls)),
]
