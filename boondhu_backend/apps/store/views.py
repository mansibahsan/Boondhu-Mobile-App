"""
Store Views — Product and Category APIs
"""

from rest_framework import viewsets, permissions, filters
from rest_framework.decorators import action
from rest_framework.response import Response
from django_filters.rest_framework import DjangoFilterBackend
from drf_spectacular.utils import extend_schema, extend_schema_view

from .models import ProductCategory, Product
from .serializers import (
    ProductCategorySerializer,
    ProductListSerializer,
    ProductDetailSerializer,
)


@extend_schema_view(
    list=extend_schema(tags=['Store']),
    retrieve=extend_schema(tags=['Store']),
)
class ProductCategoryViewSet(viewsets.ReadOnlyModelViewSet):
    """List and retrieve product categories."""
    queryset = ProductCategory.objects.filter(is_active=True)
    serializer_class = ProductCategorySerializer
    lookup_field = 'slug'


@extend_schema_view(
    list=extend_schema(tags=['Store']),
    retrieve=extend_schema(tags=['Store']),
    featured=extend_schema(tags=['Store']),
)
class ProductViewSet(viewsets.ReadOnlyModelViewSet):
    """
    List, search, filter, and retrieve products.
    Supports filtering by category, price range, and featured status.
    """
    lookup_field = 'slug'
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = {
        'category__slug': ['exact'],
        'price': ['gte', 'lte'],
        'is_featured': ['exact'],
        'rating': ['gte'],
    }
    search_fields = ['name', 'description', 'category__name']
    ordering_fields = ['price', 'rating', 'created_at', 'name']
    ordering = ['-is_featured', '-created_at']

    def get_queryset(self):
        return Product.objects.filter(
            is_active=True,
        ).select_related('category', 'vendor').prefetch_related('images')

    def get_serializer_class(self):
        if self.action == 'retrieve':
            return ProductDetailSerializer
        return ProductListSerializer

    @action(detail=False, methods=['get'])
    def featured(self, request):
        """Get featured/trending products."""
        featured = self.get_queryset().filter(is_featured=True)[:10]
        serializer = ProductListSerializer(
            featured, many=True, context={'request': request},
        )
        return Response(serializer.data)
