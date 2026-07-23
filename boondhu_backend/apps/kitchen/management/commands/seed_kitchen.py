from django.core.management.base import BaseCommand
from apps.kitchen.models import Kitchen, MealCategory, Meal
from django.contrib.auth import get_user_model
import random
from decimal import Decimal

User = get_user_model()

class Command(BaseCommand):
    help = 'Seeds initial kitchen data'

    def handle(self, *args, **kwargs):
        self.stdout.write('Seeding Kitchen data...')

        owner, _ = User.objects.get_or_create(
            phone='+8801711111111',
            defaults={
                'username': 'mock_kitchen_owner',
                'first_name': 'Mock Kitchen Owner',
                'user_type': 'kitchen_owner',
                'is_active': True,
            }
        )
        if owner.user_type != 'kitchen_owner':
            owner.user_type = 'kitchen_owner'
            owner.save()
            
        kitchens_data = [
            {'name': 'Spice Route Kitchen', 'area': 'Banani', 'delivery_fee': '40.00'},
            {'name': 'Mama Home Kitchen', 'area': 'Dhanmondi', 'delivery_fee': '30.00'},
            {'name': 'The Healthy Bowl', 'area': 'Gulshan', 'delivery_fee': '50.00'},
        ]

        kitchens = {}
        for k_data in kitchens_data:
            k, _ = Kitchen.objects.get_or_create(
                name=k_data['name'],
                defaults={
                    'owner': owner,
                    'area': k_data['area'],
                    'delivery_fee': Decimal(k_data['delivery_fee']),
                    'is_verified': True,
                    'rating': round(random.uniform(4.0, 5.0), 1),
                    'rating_count': random.randint(10, 100),
                    'is_active': True,
                }
            )
            kitchens[k.name] = k

        categories = ['Bengali', 'Chinese', 'Indian', 'Fast Food', 'Desserts']
        cat_objs = {}
        for c_name in categories:
            cat, _ = MealCategory.objects.get_or_create(name=c_name)
            cat_objs[c_name] = cat
            
        meals_data = [
            {'name': 'Kacchi Biryani', 'kitchen': 'Spice Route Kitchen', 'category': 'Bengali', 'price': '250.00', 'time': '40 mins'},
            {'name': 'Beef Tehari', 'kitchen': 'Mama Home Kitchen', 'category': 'Bengali', 'price': '180.00', 'time': '30 mins'},
            {'name': 'Chicken Fried Rice', 'kitchen': 'Spice Route Kitchen', 'category': 'Chinese', 'price': '200.00', 'time': '25 mins'},
            {'name': 'Grilled Chicken Salad', 'kitchen': 'The Healthy Bowl', 'category': 'Fast Food', 'price': '220.00', 'time': '20 mins'},
            {'name': 'Chicken Tikka Masala', 'kitchen': 'Mama Home Kitchen', 'category': 'Indian', 'price': '260.00', 'time': '35 mins'},
            {'name': 'Quinoa Veggie Bowl', 'kitchen': 'The Healthy Bowl', 'category': 'Fast Food', 'price': '300.00', 'time': '15 mins'},
            {'name': 'Rasmalai', 'kitchen': 'Mama Home Kitchen', 'category': 'Desserts', 'price': '150.00', 'time': '10 mins'},
        ]
        
        for m_data in meals_data:
            k = kitchens.get(m_data['kitchen'])
            c = cat_objs.get(m_data['category'])
            if k and c:
                Meal.objects.get_or_create(
                    name=m_data['name'],
                    kitchen=k,
                    defaults={
                        'category': c,
                        'price': Decimal(m_data['price']),
                        'preparation_time': m_data['time'],
                        'is_available': True,
                        'rating': round(random.uniform(3.5, 5.0), 1),
                        'rating_count': random.randint(5, 50),
                    }
                )

        self.stdout.write(self.style.SUCCESS('Successfully seeded kitchen data!'))
