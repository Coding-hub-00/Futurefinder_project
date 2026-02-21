#!/usr/bin/env python
import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'futurefinder.settings')
django.setup()

from django.contrib.auth.models import User

# Create test user
username = 'testuser'
email = 'test@example.com'
password = 'testpass123'

if not User.objects.filter(username=username).exists():
    user = User.objects.create_user(username=username, email=email, password=password)
    print(f"Test user created: {username} / {email} / {password}")
else:
    print(f"Test user already exists: {username}")

# Also create a user with email as username for testing
email_username = 'user@test.com'
if not User.objects.filter(username=email_username).exists():
    user = User.objects.create_user(username=email_username, email=email_username, password=password)
    print(f"Email user created: {email_username} / {password}")
else:
    print(f"Email user already exists: {email_username}")