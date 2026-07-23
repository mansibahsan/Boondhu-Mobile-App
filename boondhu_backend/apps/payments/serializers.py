"""
Payments Serializers
"""

from rest_framework import serializers
from .models import Payment


class PaymentSerializer(serializers.ModelSerializer):
    method_display = serializers.CharField(source='get_method_display', read_only=True)
    status_display = serializers.CharField(source='get_status_display', read_only=True)

    class Meta:
        model = Payment
        fields = [
            'id', 'order', 'amount', 'method', 'method_display',
            'transaction_id', 'status', 'status_display', 'paid_at',
            'created_at',
        ]
        read_only_fields = ['id', 'status', 'paid_at', 'created_at']
