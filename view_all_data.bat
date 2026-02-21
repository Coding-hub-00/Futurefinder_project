@echo off
echo ========================================
echo    FUTUREFINDER - VIEW ALL DATA
echo ========================================
echo.

cd backend

echo 1. LOGIN INFORMATION:
echo ========================
python manage.py shell -c "from django.contrib.auth.models import User; from apps.authentication.models import UserActivity; print('=== ALL USERS ==='); [print(f'Username: {u.username}, Email: {u.email}, Login Count: {u.profile.login_count}, Online: {u.profile.is_online}, Last Login: {u.profile.last_login}') for u in User.objects.all()]; print('\n=== RECENT LOGIN ACTIVITIES ==='); [print(f'{a.user.username if a.user else \"Anonymous\"} - {a.activity_type} - {a.timestamp} - Success: {a.success}') for a in UserActivity.objects.filter(activity_type='login').order_by('-timestamp')[:10]]"

echo.
echo 2. AI RECOMMENDATION REQUESTS:
echo ===============================
python manage.py shell -c "from apps.authentication.models import UserActivity; ai_requests = UserActivity.objects.filter(activity_type='ai_recommendation').order_by('-timestamp'); print(f'Total AI Requests: {ai_requests.count()}'); [print(f'{a.user.username if a.user else \"Anonymous\"} - {a.timestamp}') for a in ai_requests[:5]]"

echo.
echo 3. PROFILE UPDATES:
echo ===================
python manage.py shell -c "from apps.authentication.models import UserActivity; profile_updates = UserActivity.objects.filter(activity_type='profile_update').order_by('-timestamp'); print(f'Total Profile Updates: {profile_updates.count()}'); [print(f'{a.user.username if a.user else \"Anonymous\"} - {a.timestamp}') for a in profile_updates[:5]]"

echo.
echo 4. ALL ACTIVITIES SUMMARY:
echo ==========================
python manage.py shell -c "from apps.authentication.models import UserActivity; from collections import Counter; activities = UserActivity.objects.all(); activity_counts = Counter([a.activity_type for a in activities]); print('Activity Summary:'); [print(f'  {activity}: {count}') for activity, count in activity_counts.items()]; print(f'Total Activities: {activities.count()}')"

echo.
echo ========================================
echo To see detailed data, go to:
echo http://localhost:8000/admin/
echo Login: dataadmin / dataadmin123
echo ========================================

pause