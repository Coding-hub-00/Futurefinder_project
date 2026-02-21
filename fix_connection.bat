@echo off
echo Fixing Flutter-Django Connection...
echo.

echo 1. Starting Django server on all interfaces...
cd backend
start "Django Server" python manage.py runserver 0.0.0.0:8000

echo.
echo 2. Waiting for server to start...
timeout /t 3

echo.
echo 3. Testing connection...
curl -X GET http://192.168.94.161:8000/api/ 2>nul
if %errorlevel% equ 0 (
    echo SUCCESS: Django server is accessible at 192.168.94.161:8000
) else (
    echo FAILED: Server not accessible at 192.168.94.161:8000
    echo Trying localhost...
    curl -X GET http://127.0.0.1:8000/api/ 2>nul
    if %errorlevel% equ 0 (
        echo SUCCESS: Server running on localhost:8000
        echo You need to update Flutter app to use: http://127.0.0.1:8000
    ) else (
        echo ERROR: Django server not running
    )
)

echo.
echo 4. Current network IP addresses:
ipconfig | findstr "IPv4"

pause