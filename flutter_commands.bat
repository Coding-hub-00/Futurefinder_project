@echo off
echo ========================================
echo    FUTUREFINDER FLUTTER COMMANDS
echo ========================================
echo.

:menu
echo Choose an option:
echo.
echo 1. Setup & Dependencies
echo 2. Development
echo 3. Build & Release
echo 4. Testing & Analysis
echo 5. Assets & Icons
echo 6. Database Commands
echo 7. Exit
echo.
set /p choice="Enter your choice (1-7): "

if "%choice%"=="1" goto setup
if "%choice%"=="2" goto dev
if "%choice%"=="3" goto build
if "%choice%"=="4" goto test
if "%choice%"=="5" goto assets
if "%choice%"=="6" goto database
if "%choice%"=="7" goto exit
goto menu

:setup
echo.
echo ========== SETUP & DEPENDENCIES ==========
echo 1. flutter doctor
echo 2. flutter pub get
echo 3. flutter pub upgrade
echo 4. flutter clean
echo 5. flutter pub deps
echo 6. Back to main menu
echo.
set /p subchoice="Enter choice: "

if "%subchoice%"=="1" flutter doctor
if "%subchoice%"=="2" flutter pub get
if "%subchoice%"=="3" flutter pub upgrade
if "%subchoice%"=="4" flutter clean && flutter pub get
if "%subchoice%"=="5" flutter pub deps
if "%subchoice%"=="6" goto menu
pause
goto setup

:dev
echo.
echo ========== DEVELOPMENT ==========
echo 1. flutter run (debug)
echo 2. flutter run --release
echo 3. flutter run --profile
echo 4. flutter devices
echo 5. flutter logs
echo 6. Back to main menu
echo.
set /p subchoice="Enter choice: "

if "%subchoice%"=="1" flutter run
if "%subchoice%"=="2" flutter run --release
if "%subchoice%"=="3" flutter run --profile
if "%subchoice%"=="4" flutter devices
if "%subchoice%"=="5" flutter logs
if "%subchoice%"=="6" goto menu
pause
goto dev

:build
echo.
echo ========== BUILD & RELEASE ==========
echo 1. flutter build apk
echo 2. flutter build appbundle
echo 3. flutter build ios
echo 4. flutter build web
echo 5. flutter build windows
echo 6. Back to main menu
echo.
set /p subchoice="Enter choice: "

if "%subchoice%"=="1" flutter build apk
if "%subchoice%"=="2" flutter build appbundle
if "%subchoice%"=="3" flutter build ios
if "%subchoice%"=="4" flutter build web
if "%subchoice%"=="5" flutter build windows
if "%subchoice%"=="6" goto menu
pause
goto build

:test
echo.
echo ========== TESTING & ANALYSIS ==========
echo 1. flutter test
echo 2. flutter test --coverage
echo 3. flutter analyze
echo 4. flutter format .
echo 5. Back to main menu
echo.
set /p subchoice="Enter choice: "

if "%subchoice%"=="1" flutter test
if "%subchoice%"=="2" flutter test --coverage
if "%subchoice%"=="3" flutter analyze
if "%subchoice%"=="4" flutter format .
if "%subchoice%"=="5" goto menu
pause
goto test

:assets
echo.
echo ========== ASSETS & ICONS ==========
echo 1. Generate app icons
echo 2. Generate splash screen
echo 3. Both icons and splash
echo 4. Back to main menu
echo.
set /p subchoice="Enter choice: "

if "%subchoice%"=="1" flutter packages pub run flutter_launcher_icons:main
if "%subchoice%"=="2" flutter packages pub run flutter_native_splash:create
if "%subchoice%"=="3" (
    flutter packages pub run flutter_launcher_icons:main
    flutter packages pub run flutter_native_splash:create
)
if "%subchoice%"=="4" goto menu
pause
goto assets

:database
echo.
echo ========== DATABASE COMMANDS ==========
echo 1. Start Django backend
echo 2. Reset database
echo 3. Create superuser
echo 4. View database data
echo 5. Setup live database
echo 6. Back to main menu
echo.
set /p subchoice="Enter choice: "

if "%subchoice%"=="1" (
    cd backend
    python manage.py runserver
    cd ..
)
if "%subchoice%"=="2" (
    cd backend
    python reset_db_simple.py
    cd ..
)
if "%subchoice%"=="3" (
    cd backend
    python manage.py createsuperuser
    cd ..
)
if "%subchoice%"=="4" (
    cd backend
    python view_data_simple.py
    cd ..
)
if "%subchoice%"=="5" (
    cd backend
    python setup_live_db.py
    cd ..
)
if "%subchoice%"=="6" goto menu
pause
goto database

:exit
echo.
echo Thanks for using FutureFinder development tools!
pause
exit