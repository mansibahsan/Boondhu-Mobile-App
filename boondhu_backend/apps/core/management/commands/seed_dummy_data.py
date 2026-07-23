import random
from django.utils.text import slugify
from django.core.management.base import BaseCommand
from django.contrib.auth import get_user_model
from apps.store.models import ProductCategory, Product
from apps.kitchen.models import Kitchen, MealCategory, Meal
from apps.services.models import ServiceCategory, ServiceProvider, Service

User = get_user_model()

class Command(BaseCommand):
    help = 'Seeds the database with dummy data for Store, Kitchen, and Services'

    def handle(self, *args, **kwargs):
        self.stdout.write('Starting database seeding...')

        # Create dummy users if they don't exist
        vendor, _ = User.objects.get_or_create(phone='+8801700000001', defaults={'username': 'vendor', 'first_name': 'Store', 'last_name': 'Vendor', 'user_type': 'vendor'})
        kitchen_owner, _ = User.objects.get_or_create(phone='+8801700000002', defaults={'username': 'kitchen_owner', 'first_name': 'Kitchen', 'last_name': 'Owner', 'user_type': 'kitchen_owner'})
        service_provider_user, _ = User.objects.get_or_create(phone='+8801700000003', defaults={'username': 'service_provider', 'first_name': 'Service', 'last_name': 'Provider', 'user_type': 'service_provider'})

        # -----------------------------
        # 1. STORE SEEDING
        # -----------------------------
        self.stdout.write('Seeding e-Store...')
        store_categories = ['Groceries', 'Bakery', 'Dairy', 'Medicine', 'Cleaning']
        for cat_name in store_categories:
            ProductCategory.objects.get_or_create(name=cat_name, defaults={'icon': 'category'})
            
        groceries = ProductCategory.objects.filter(name='Groceries').first()
        bakery = ProductCategory.objects.filter(name='Bakery').first()
        dairy = ProductCategory.objects.filter(name='Dairy').first()

        products_data = [
            {'name': 'Fresh Organic Apples', 'category': groceries, 'price': 250, 'unit': 'kg', 'rating': 4.8, 'img': 'https://images.pexels.com/photos/102104/pexels-photo-102104.jpeg?auto=compress&cs=tinysrgb&w=500'},
            {'name': 'Whole Wheat Bread', 'category': bakery, 'price': 80, 'unit': 'piece', 'rating': 4.5, 'img': 'https://images.pexels.com/photos/1070850/pexels-photo-1070850.jpeg?auto=compress&cs=tinysrgb&w=500'},
            {'name': 'Farm Fresh Eggs (12 pcs)', 'category': dairy, 'price': 140, 'unit': 'pack', 'rating': 4.9, 'img': 'https://images.pexels.com/photos/1556704/pexels-photo-1556704.jpeg?auto=compress&cs=tinysrgb&w=500'},
        ]
        
        for p in products_data:
            Product.objects.get_or_create(
                name=p['name'],
                defaults={
                    'category': p['category'], 'vendor': vendor, 'price': p['price'], 
                    'unit': p['unit'], 'rating': p['rating'], 'stock_quantity': 50,
                }
            )

        # -----------------------------
        # 2. KITCHEN SEEDING
        # -----------------------------
        self.stdout.write('Seeding e-Kitchen...')
        kitchen, _ = Kitchen.objects.get_or_create(name="Nawab's Kitchen", defaults={'owner': kitchen_owner, 'area': 'Dhanmondi', 'rating': 4.9, 'is_verified': True})
        kitchen2, _ = Kitchen.objects.get_or_create(name="Spicy Grill", defaults={'owner': kitchen_owner, 'area': 'Gulshan', 'rating': 4.7})

        cat_biryani, _ = MealCategory.objects.get_or_create(name='Biryani')
        cat_bbq, _ = MealCategory.objects.get_or_create(name='BBQ')

        meals_data = [
            {'name': 'Kacchi Biryani', 'kitchen': kitchen, 'cat': cat_biryani, 'price': 350, 'rating': 4.9, 'time': '45 mins'},
            {'name': 'Grilled Chicken & Naan', 'kitchen': kitchen2, 'cat': cat_bbq, 'price': 280, 'rating': 4.7, 'time': '30 mins'},
            {'name': 'Beef Tehari', 'kitchen': kitchen, 'cat': cat_biryani, 'price': 180, 'rating': 4.8, 'time': '25 mins'},
        ]

        for m in meals_data:
            Meal.objects.get_or_create(
                name=m['name'],
                defaults={
                    'kitchen': m['kitchen'], 'category': m['cat'], 'price': m['price'],
                    'rating': m['rating'], 'preparation_time': m['time'],
                }
            )

        # -----------------------------
        # 3. SERVICES SEEDING
        # -----------------------------
        self.stdout.write('Seeding e-Services...')
        service_categories = ['Cleaning', 'AC Service', 'Plumbing', 'Electrical']
        for cat_name in service_categories:
            ServiceCategory.objects.get_or_create(name=cat_name, defaults={'icon': 'build', 'slug': slugify(cat_name)})

        provider, _ = ServiceProvider.objects.get_or_create(business_name='CleanPro Services', defaults={'user': service_provider_user, 'rating': 4.9, 'service_area': 'All Dhaka', 'is_verified': True})

        cat_clean = ServiceCategory.objects.filter(name='Cleaning').first()
        cat_ac = ServiceCategory.objects.filter(name='AC Service').first()

        services_data = [
            {'name': 'Home Cleaning', 'cat': cat_clean, 'price': 1500, 'rating': 4.9},
            {'name': 'AC Servicing', 'cat': cat_ac, 'price': 800, 'rating': 4.7},
        ]

        for s in services_data:
            Service.objects.get_or_create(
                name=s['name'],
                defaults={
                    'provider': provider, 'category': s['cat'], 'price': s['price'],
                    'rating': s['rating']
                }
            )

        self.stdout.write(self.style.SUCCESS('Successfully seeded dummy data!'))
