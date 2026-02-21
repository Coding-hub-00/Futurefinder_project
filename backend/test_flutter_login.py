#!/usr/bin/env python3
import requests
import json
import os
import django

def test_flutter_login():
    print("Testing Flutter Login Integration...")
    print("=" * 50)
    
    BASE_URL = 'http://127.0.0.1:8000/api'
    
    # Test login with dataadmin
    print("1. Testing login with dataadmin...")
    login_data = {
        'email': 'dataadmin@futurefinder.com',
        'password': 'dataadmin123'
    }
    
    try:
        response = requests.post(f'{BASE_URL}/auth/login/', json=login_data)
        print(f"Login Response: {response.status_code}")
        print(f"Response: {response.json()}")
        
        if response.status_code == 200:
            print("✓ Login successful!")
        else:
            print("✗ Login failed")
            
    except Exception as e:
        print(f"Login error: {e}")
    
    # Check database for login activity
    print("\n2. Checking database for login activity...")
    
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'futurefinder.settings')
    django.setup()
    
    from django.contrib.auth.models import User
    from apps.authentication.models import UserActivity
    
    user = User.objects.filter(email='dataadmin@futurefinder.com').first()
    if user:
        print(f"✓ User found: {user.username}")
        
        # Check login activities
        login_activities = UserActivity.objects.filter(user=user, activity_type='login').order_by('-timestamp')
        print(f"  Total logins: {login_activities.count()}")
        
        if login_activities.exists():
            latest_login = login_activities.first()
            print(f"  Latest login: {latest_login.timestamp}")
            print(f"  Success: {latest_login.success}")
            print(f"  Details: {latest_login.details}")
        
        # Check profile
        profile = user.profile
        print(f"  Login count: {profile.login_count}")
        print(f"  Last login: {profile.last_login}")
        print(f"  Online status: {profile.is_online}")
    else:
        print("✗ User not found")

if __name__ == "__main__":
    test_flutter_login()