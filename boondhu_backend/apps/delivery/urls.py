from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views

router = DefaultRouter()
router.register(r'parcels', views.DeliveryParcelViewSet, basename='delivery-parcel')

urlpatterns = [
    path('', include(router.urls)),
]
