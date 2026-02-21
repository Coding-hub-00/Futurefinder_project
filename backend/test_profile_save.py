#!/usr/bin/env python3
import requests
import json

BASE_URL = 'http://127.0.0.1:8000/api'

def test_profile_save():
    print("Testing Profile Save Functionality...")
    print("=" * 50)
    
    # First register a user
    print("1. Registering test user...")
    register_data = {
        'username': 'rohit',
        'email': 'rohit@gmail.com',
        'password': 'rohit'
    }
    
    try:
        response = requests.post(f'{BASE_URL}/auth/register/', json=register_data)
        print(f"Registration: {response.status_code}")
        if response.status_code != 201:
            print("User might already exist, continuing...")
    except Exception as e:
        print(f"Registration error: {e}")
    
    # Test profile save
    print("\n2. Testing profile save...")
    profile_data = {
        'email': 'rohit@gmail.com',
        'skills': ['Python', 'JavaScript', 'React'],
        'interests': ['Technology', 'AI', 'Web Development'],
        'academic_level': 'Computer Science',
        'stream': 'Engineering'
    }
    
    try:
        response = requests.post(f'{BASE_URL}/auth/save-profile/', json=profile_data)
        print(f"Profile Save Response: {response.status_code}")
        print(f"Response: {response.json()}")
        
        if response.status_code == 200:
            print("✓ Profile saved successfully!")
        else:
            print("✗ Profile save failed")
            
    except Exception as e:
        print(f"Profile save error: {e}")
    
    # Check database
    print("\n3. Checking database...")
    import os
    import django
    
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'futurefinder.settings')
    django.setup()
    
    from django.contrib.auth.models import User
    from apps.authentication.models import UserProfile, UserActivity
    
    user = User.objects.filter(email='rohit@gmail.com').first()
    if user:
        print(f"✓ User found: {user.username}")
        profile = user.profile
        print(f"  Skills: {profile.skills}")
        print(f"  Interests: {profile.interests}")
        print(f"  Academic Level: {profile.academic_level}")
        print(f"  Stream: {profile.stream}")
        
        # Check activities
        activities = UserActivity.objects.filter(user=user, activity_type='profile_update')
        print(f"  Profile Updates: {activities.count()}")
        if activities.exists():
            latest = activities.first()
            print(f"  Latest Update: {latest.timestamp}")
    else:
        print("✗ User not found in database")

if __name__ == "__main__":
    test_profile_save()