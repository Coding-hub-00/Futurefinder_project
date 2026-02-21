@echo off
cd backend
python manage.py makemigrations
python manage.py migrate
python setup.py
python manage.py runserver