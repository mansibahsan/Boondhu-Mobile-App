"""
Kitchen Views
"""

from rest_framework import viewsets, filters
from rest_framework.decorators import action
from rest_framework.response import Response
from django_filters.rest_framework import DjangoFilterBackend
from drf_spectacular.utils import extend_schema, extend_schema_view

from .models import Kitchen, Meal, MealCategory
from .serializers import (
    KitchenListSerializer, KitchenDetailSerializer,
    MealListSerializer, MealDetailSerializer, MealCategorySerializer,
)


@extend_schema_view(
    list=extend_schema(tags=['Kitchen']),
    retrieve=extend_schema(tags=['Kitchen']),
)
class KitchenViewSet(viewsets.ReadOnlyModelViewSet):
    """List and retrieve kitchens."""
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    search_fields = ['name', 'area']
    ordering_fields = ['rating', 'name']

    def get_queryset(self):
        return Kitchen.objects.filter(is_active=True)

    def get_serializer_class(self):
        if self.action == 'retrieve':
            return KitchenDetailSerializer
        return KitchenListSerializer


@extend_schema_view(
    list=extend_schema(tags=['Kitchen']),
    retrieve=extend_schema(tags=['Kitchen']),
    featured=extend_schema(tags=['Kitchen']),
)
class MealViewSet(viewsets.ReadOnlyModelViewSet):
    """List, search, filter, and retrieve meals."""
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = {
        'kitchen__id': ['exact'],
        'category__id': ['exact'],
        'price': ['gte', 'lte'],
        'is_featured': ['exact'],
        'is_vegetarian': ['exact'],
        'is_available': ['exact'],
    }
    search_fields = ['name', 'description', 'kitchen__name']
    ordering_fields = ['price', 'rating', 'name']

    def get_queryset(self):
        return Meal.objects.filter(
            is_available=True, kitchen__is_active=True,
        ).select_related('kitchen', 'category')

    def get_serializer_class(self):
        if self.action == 'retrieve':
            return MealDetailSerializer
        return MealListSerializer

    @action(detail=False, methods=['get'])
    def featured(self, request):
        """Get featured meals."""
        featured = self.get_queryset().filter(is_featured=True)[:10]
        serializer = MealListSerializer(featured, many=True, context={'request': request})
        return Response(serializer.data)


@extend_schema_view(
    list=extend_schema(tags=['Kitchen']),
)
class MealCategoryViewSet(viewsets.ReadOnlyModelViewSet):
    """List meal categories."""
    queryset = MealCategory.objects.all()
    serializer_class = MealCategorySerializer
