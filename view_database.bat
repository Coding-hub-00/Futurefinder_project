@echo off
echo Checking Database for rohit@gmail.com...
echo.
cd backend
python manage.py shell -c "from django.contrib.auth.models import User; from apps.authentication.models import UserActivity; print('=== ALL USERS ==='); [print(f'Username: {u.username}, Email: {u.email}, Date: {u.date_joined}') for u in User.objects.all()]; print('\n=== RECENT ACTIVITIES ==='); [print(f'{a.user.username if a.user else \"Anonymous\"} - {a.activity_type} - {a.timestamp}') for a in UserActivity.objects.all().order_by('-timestamp')[:10]]; rohit = User.objects.filter(email='rohit@gmail.com').first(); print(f'\n=== ROHIT USER ==='); print(f'Found: {\"YES\" if rohit else \"NO\"}'); print(f'Details: {rohit.username if rohit else \"Not registered\"}')"
pause