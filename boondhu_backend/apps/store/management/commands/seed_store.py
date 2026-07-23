from django.core.management.base import BaseCommand
from apps.store.models import ProductCategory, Product
from django.contrib.auth import get_user_model
import random
from decimal import Decimal

User = get_user_model()

class Command(BaseCommand):
    help = 'Seeds initial store data from Flutter mock data'

    def handle(self, *args, **kwargs):
        self.stdout.write('Seeding Store data...')
        
        vendor, _ = User.objects.get_or_create(
            phone='+8801700000000',
            defaults={
                'username': 'mock_vendor',
                'first_name': 'Mock Vendor',
                'user_type': 'vendor',
                'is_active': True,
            }
        )
        if vendor.user_type != 'vendor':
            vendor.user_type = 'vendor'
            vendor.save()

        categories_data = [
            {'name': 'Groceries', 'icon': 'shopping_basket'},
            {'name': 'Bakery', 'icon': 'bakery_dining'},
            {'name': 'Dairy', 'icon': 'egg'},
            {'name': 'Medicine', 'icon': 'local_pharmacy'},
            {'name': 'Cleaning', 'icon': 'cleaning_services'},
            {'name': 'Baby Care', 'icon': 'child_care'},
        ]

        categories = {}
        for cat_data in categories_data:
            cat, created = ProductCategory.objects.get_or_create(
                name=cat_data['name'],
                defaults={'icon': cat_data['icon'], 'is_active': True}
            )
            categories[cat.name] = cat
        
        products_data = [
            {'name': 'Fresh Organic Apples', 'category': 'Groceries', 'price': '150.00', 'unit': 'kg'},
            {'name': 'Whole Wheat Bread', 'category': 'Bakery', 'price': '60.00', 'unit': 'piece'},
            {'name': 'Farm Fresh Eggs', 'category': 'Dairy', 'price': '130.00', 'unit': 'dozen'},
            {'name': 'Paracetamol 500mg', 'category': 'Medicine', 'price': '20.00', 'unit': 'strip'},
            {'name': 'Dishwashing Liquid', 'category': 'Cleaning', 'price': '120.00', 'unit': 'bottle'},
            {'name': 'Baby Diapers (Large)', 'category': 'Baby Care', 'price': '950.00', 'unit': 'pack'},
            {'name': 'Premium Rice (Miniket)', 'category': 'Groceries', 'price': '350.00', 'unit': '5kg'},
            {'name': 'Pasteurized Milk', 'category': 'Dairy', 'price': '80.00', 'unit': '1L'},
            {'name': 'Chocolate Chip Cookies', 'category': 'Bakery', 'price': '150.00', 'unit': 'pack'},
            {'name': 'Vitamin C Tablets', 'category': 'Medicine', 'price': '80.00', 'unit': 'bottle'},
        ]

        for p_data in products_data:
            cat = categories.get(p_data['category'])
            if cat:
                Product.objects.get_or_create(
                    name=p_data['name'],
                    defaults={
                        'category': cat,
                        'vendor': vendor,
                        'price': Decimal(p_data['price']),
                        'unit': p_data['unit'],
                        'stock_quantity': random.randint(10, 100),
                        'is_active': True,
                        'rating': round(random.uniform(3.5, 5.0), 1),
                        'rating_count': random.randint(5, 50),
                    }
                )

        self.stdout.write(self.style.SUCCESS('Successfully seeded store data!'))
