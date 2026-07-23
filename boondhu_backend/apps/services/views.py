"""
Services Views
"""

from rest_framework import viewsets, permissions, filters
from rest_framework.decorators import action
from rest_framework.response import Response
from django_filters.rest_framework import DjangoFilterBackend
from drf_spectacular.utils import extend_schema, extend_schema_view

from .models import ServiceCategory, ServiceProvider, Service, ServiceBooking
from .serializers import (
    ServiceCategorySerializer, ServiceProviderSerializer,
    ServiceListSerializer, ServiceDetailSerializer,
    ServiceBookingSerializer,
)


@extend_schema_view(
    list=extend_schema(tags=['Services']),
    retrieve=extend_schema(tags=['Services']),
)
class ServiceCategoryViewSet(viewsets.ReadOnlyModelViewSet):
    queryset = ServiceCategory.objects.filter(is_active=True)
    serializer_class = ServiceCategorySerializer
    lookup_field = 'slug'


@extend_schema_view(
    list=extend_schema(tags=['Services']),
    retrieve=extend_schema(tags=['Services']),
)
class ServiceProviderViewSet(viewsets.ReadOnlyModelViewSet):
    serializer_class = ServiceProviderSerializer
    filter_backends = [DjangoFilterBackend, filters.SearchFilter]
    search_fields = ['business_name', 'service_area']

    def get_queryset(self):
        return ServiceProvider.objects.filter(is_active=True)


@extend_schema_view(
    list=extend_schema(tags=['Services']),
    retrieve=extend_schema(tags=['Services']),
    featured=extend_schema(tags=['Services']),
)
class ServiceViewSet(viewsets.ReadOnlyModelViewSet):
    filter_backends = [DjangoFilterBackend, filters.SearchFilter, filters.OrderingFilter]
    filterset_fields = {
        'category__slug': ['exact'],
        'provider__id': ['exact'],
        'price': ['gte', 'lte'],
        'is_featured': ['exact'],
        'rating': ['gte'],
    }
    search_fields = ['name', 'description', 'provider__business_name']
    ordering_fields = ['price', 'rating', 'name']

    def get_queryset(self):
        return Service.objects.filter(
            is_active=True,
        ).select_related('provider', 'category')

    def get_serializer_class(self):
        if self.action == 'retrieve':
            return ServiceDetailSerializer
        return ServiceListSerializer

    @action(detail=False, methods=['get'])
    def featured(self, request):
        featured = self.get_queryset().filter(is_featured=True)[:10]
        serializer = ServiceListSerializer(featured, many=True, context={'request': request})
        return Response(serializer.data)


@extend_schema_view(
    list=extend_schema(tags=['Services']),
    create=extend_schema(tags=['Services']),
    retrieve=extend_schema(tags=['Services']),
)
class ServiceBookingViewSet(viewsets.ModelViewSet):
    """CRUD for service bookings (customers create, view their bookings)."""
    serializer_class = ServiceBookingSerializer
    permission_classes = [permissions.IsAuthenticated]
    http_method_names = ['get', 'post', 'head', 'options']

    def get_queryset(self):
        return ServiceBooking.objects.filter(
            customer=self.request.user,
        ).select_related('service', 'service__provider')
