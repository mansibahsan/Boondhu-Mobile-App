"""
Payments Views
"""

from rest_framework import viewsets, permissions, mixins
from drf_spectacular.utils import extend_schema, extend_schema_view

from .models import Payment
from .serializers import PaymentSerializer


@extend_schema_view(
    list=extend_schema(tags=['Payments']),
    retrieve=extend_schema(tags=['Payments']),
)
class PaymentViewSet(viewsets.ReadOnlyModelViewSet):
    """
    List and retrieve payment records for the authenticated user.
    Payment creation happens mostly via webhook or specific order payment flow.
    """
    serializer_class = PaymentSerializer
    permission_classes = [permissions.IsAuthenticated]

    def get_queryset(self):
        return Payment.objects.filter(order__user=self.request.user)
