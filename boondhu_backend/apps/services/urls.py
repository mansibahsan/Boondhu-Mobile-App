from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views

router = DefaultRouter()
router.register(r'categories', views.ServiceCategoryViewSet, basename='service-category')
router.register(r'providers', views.ServiceProviderViewSet, basename='service-provider')
router.register(r'list', views.ServiceViewSet, basename='service')
router.register(r'bookings', views.ServiceBookingViewSet, basename='service-booking')

urlpatterns = [
    path('', include(router.urls)),
]
