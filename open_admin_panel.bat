@echo off
echo Opening Django Admin Panel...
echo.

cd backend

echo Starting Django server...
start "Django Server" python manage.py runserver 127.0.0.1:8000

echo Waiting for server to start...
timeout /t 5

echo Opening admin panel in browser...
start http://localhost:8000/admin/

echo.
echo ========================================
echo    ADMIN LOGIN CREDENTIALS
echo ========================================
echo Username: dataadmin
echo Password: dataadmin123
echo ========================================
echo.
echo In the admin panel, check:
echo 1. Authentication ^> Users (see all users)
echo 2. Authentication ^> User activities (see logins)
echo 3. Authentication ^> User profiles (see profile data)
echo 4. Ai matching ^> AI recommendations (see AI requests)
echo ========================================

pause