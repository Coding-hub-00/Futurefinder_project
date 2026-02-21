#!/usr/bin/env python3
import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'futurefinder.settings')
django.setup()

from django.contrib.auth.models import User
from apps.authentication.models import UserProfile, UserActivity

def show_database_activities():
    print("FUTUREFINDER DATABASE ACTIVITIES")
    print("=" * 50)
    
    # Show all users
    users = User.objects.all()
    print(f"TOTAL USERS: {users.count()}")
    for user in users:
        profile = getattr(user, 'profile', None)
        if profile:
            print(f"  - {user.username} ({user.email})")
            print(f"    Login Count: {profile.login_count}")
            print(f"    Last Login: {profile.last_login}")
            print(f"    Online: {profile.is_online}")
        else:
            print(f"  - {user.username} ({user.email}) - No profile")
    
    print(f"\nRECENT ACTIVITIES:")
    activities = UserActivity.objects.all().order_by('-timestamp')[:10]
    
    if not activities:
        print("  No activities found")
    else:
        for activity in activities:
            username = activity.user.username if activity.user else 'Anonymous'
            status = "✓" if activity.success else "✗"
            print(f"  {status} {username} - {activity.activity_type} at {activity.timestamp}")
            if activity.details:
                print(f"    Details: {activity.details}")
    
    print(f"\nACTIVITY SUMMARY:")
    print(f"  Total Activities: {UserActivity.objects.count()}")
    print(f"  Registrations: {UserActivity.objects.filter(activity_type='registration').count()}")
    print(f"  Successful Logins: {UserActivity.objects.filter(activity_type='login', success=True).count()}")
    print(f"  Failed Logins: {UserActivity.objects.filter(activity_type='login', success=False).count()}")
    print(f"  Profile Updates: {UserActivity.objects.filter(activity_type='profile_update').count()}")

if __name__ == "__main__":
    show_database_activities()