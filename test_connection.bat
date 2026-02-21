@echo off
echo Testing Django Connection...
echo.

echo 1. Starting Django server...
cd backend
start "Django Server" python manage.py runserver 127.0.0.1:8000

echo.
echo 2. Waiting for server to start...
timeout /t 5

echo.
echo 3. Testing API endpoints...
echo Testing: http://127.0.0.1:8000/api/
curl -X GET http://127.0.0.1:8000/api/

echo.
echo 4. Testing registration...
curl -X POST http://127.0.0.1:8000/api/auth/register/ -H "Content-Type: application/json" -d "{\"username\":\"rohit\",\"email\":\"rohit@gmail.com\",\"password\":\"rohit\"}"

echo.
echo 5. Checking database...
python manage.py shell -c "from django.contrib.auth.models import User; rohit = User.objects.filter(email='rohit@gmail.com').first(); print(f'Rohit found: {\"YES\" if rohit else \"NO\"}')"

pause