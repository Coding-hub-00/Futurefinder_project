#!/usr/bin/env python3
import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'futurefinder.settings')
django.setup()

from django.contrib.auth.models import User
from apps.authentication.models import UserActivity
from apps.ai_matching.models import AIRecommendation

def show_ai_recommendations():
    print("AI RECOMMENDATION TRACKING")
    print("=" * 50)
    
    # Show AI recommendation requests
    ai_activities = UserActivity.objects.filter(activity_type='ai_recommendation').order_by('-timestamp')
    
    print(f"TOTAL AI RECOMMENDATION REQUESTS: {ai_activities.count()}")
    print()
    
    if ai_activities.exists():
        print("RECENT AI RECOMMENDATION REQUESTS:")
        for activity in ai_activities[:10]:
            username = activity.user.username if activity.user else 'Anonymous'
            print(f"  - {username} at {activity.timestamp}")
            if activity.details:
                details = activity.details
                print(f"    Skills: {details.get('skills', [])}")
                print(f"    Stream: {details.get('stream', 'Not specified')}")
                print(f"    Academic Level: {details.get('academic_level', 'Not specified')}")
                print(f"    Interests: {details.get('interests', [])}")
                print(f"    Session ID: {details.get('session_id', 'N/A')}")
            print()
    else:
        print("No AI recommendation requests found")
    
    # Show stored AI recommendations
    stored_recommendations = AIRecommendation.objects.all().order_by('-id')
    print(f"STORED AI RECOMMENDATIONS: {stored_recommendations.count()}")
    
    if stored_recommendations.exists():
        print("RECENT STORED RECOMMENDATIONS:")
        for rec in stored_recommendations[:5]:
            print(f"  - {rec.career_title} (Match: {rec.match_score}%)")
            print(f"    Session: {rec.session_id}")
            print(f"    Reasoning: {rec.reasoning[:100] if rec.reasoning else 'N/A'}...")
            print()
    
    # Show users who requested recommendations
    users_with_ai_requests = User.objects.filter(activities__activity_type='ai_recommendation').distinct()
    print(f"USERS WHO REQUESTED AI RECOMMENDATIONS: {users_with_ai_requests.count()}")
    for user in users_with_ai_requests:
        request_count = user.activities.filter(activity_type='ai_recommendation').count()
        latest_request = user.activities.filter(activity_type='ai_recommendation').first()
        print(f"  - {user.username} ({user.email}): {request_count} requests")
        if latest_request:
            print(f"    Latest: {latest_request.timestamp}")

if __name__ == "__main__":
    show_ai_recommendations()