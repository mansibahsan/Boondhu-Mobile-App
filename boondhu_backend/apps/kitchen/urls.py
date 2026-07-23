from django.urls import path, include
from rest_framework.routers import DefaultRouter
from . import views

router = DefaultRouter()
router.register(r'kitchens', views.KitchenViewSet, basename='kitchen')
router.register(r'meals', views.MealViewSet, basename='meal')
router.register(r'categories', views.MealCategoryViewSet, basename='meal-category')

urlpatterns = [
    path('', include(router.urls)),
]
