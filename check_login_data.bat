@echo off
echo Checking Login Data in Django...
echo.

cd backend

echo 1. Starting Django server...
start "Django Server" python manage.py runserver 127.0.0.1:8000

echo.
echo 2. Waiting for server to start...
timeout /t 3

echo.
echo 3. Testing Flutter login integration...
python test_flutter_login.py

echo.
echo 4. Checking all login activities...
python manage.py shell -c "from apps.authentication.models import UserActivity; login_activities = UserActivity.objects.filter(activity_type='login').order_by('-timestamp'); print(f'Total login activities: {login_activities.count()}'); [print(f'{a.user.username if a.user else \"Anonymous\"} - {a.timestamp} - Success: {a.success}') for a in login_activities[:10]]"

echo.
echo 5. Checking user profiles...
python manage.py shell -c "from django.contrib.auth.models import User; users = User.objects.all(); [print(f'{u.username} ({u.email}) - Login count: {u.profile.login_count}, Online: {u.profile.is_online}') for u in users]"

pause