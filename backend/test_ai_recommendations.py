#!/usr/bin/env python3
import requests
import json

BASE_URL = 'http://127.0.0.1:8000/api'

def test_ai_recommendations():
    print("Testing AI Recommendations Tracking...")
    print("=" * 50)
    
    # Test AI recommendation request
    print("1. Testing AI recommendation request...")
    recommendation_data = {
        'email': 'rohit@gmail.com',
        'skills': ['Python', 'JavaScript', 'React', 'Node.js'],
        'interests': ['Technology', 'AI', 'Web Development', 'Mobile Apps'],
        'academic_level': 'Computer Science',
        'stream': 'Engineering'
    }
    
    try:
        response = requests.post(f'{BASE_URL}/ai/ai-match/', json=recommendation_data)
        print(f"AI Recommendation Response: {response.status_code}")
        
        if response.status_code == 200:
            data = response.json()
            print(f"Session ID: {data.get('session_id')}")
            print(f"Recommendations Count: {len(data.get('recommendations', []))}")
            print(f"User Updated: {data.get('user_updated')}")
            print("✓ AI recommendation request successful!")
        else:
            print(f"Response: {response.text}")
            
    except Exception as e:
        print(f"AI recommendation error: {e}")
    
    # Check database
    print("\n2. Checking database for AI activities...")
    import os
    import django
    
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'futurefinder.settings')
    django.setup()
    
    from django.contrib.auth.models import User
    from apps.authentication.models import UserActivity
    
    user = User.objects.filter(email='rohit@gmail.com').first()
    if user:
        ai_activities = UserActivity.objects.filter(user=user, activity_type='ai_recommendation')
        print(f"✓ AI recommendation requests for {user.username}: {ai_activities.count()}")
        
        if ai_activities.exists():
            latest = ai_activities.first()
            print(f"  Latest request: {latest.timestamp}")
            print(f"  Details: {latest.details}")
    else:
        print("✗ User not found")

if __name__ == "__main__":
    test_ai_recommendations()