#!/usr/bin/env python3
import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'futurefinder.settings')
django.setup()

from django.contrib.auth.models import User
from apps.authentication.models import UserProfile, UserActivity

def create_data_superuser():
    print("Creating Data Management Superuser...")
    print("=" * 50)
    
    # Delete existing user if exists
    User.objects.filter(username='dataadmin').delete()
    
    # Create superuser
    user = User.objects.create_superuser(
        username='dataadmin',
        email='dataadmin@futurefinder.com',
        password='dataadmin123',
        first_name='Data',
        last_name='Administrator'
    )
    
    # Set up profile with comprehensive data
    profile = user.profile
    profile.skills = [
        'Data Management', 'Analytics', 'Administration', 'Django', 
        'Database Management', 'User Management', 'System Administration'
    ]
    profile.interests = [
        'Technology', 'Data Science', 'Management', 'Analytics',
        'System Administration', 'User Experience', 'Database Design'
    ]
    profile.academic_level = 'Masters in Computer Science'
    profile.stream = 'Computer Science & Engineering'
    profile.phone = '+91-9876543210'
    profile.location = 'Mumbai, India'
    profile.bio = 'Data Administrator for FutureFinder application. Manages all user data, analytics, and system administration.'
    profile.save()
    
    # Log creation activity
    UserActivity.objects.create(
        user=user,
        activity_type='registration',
        details={
            'user_type': 'superuser',
            'role': 'data_administrator',
            'created_by': 'system',
            'permissions': ['admin_access', 'data_management', 'user_management']
        }
    )
    
    print("✓ Superuser created successfully!")
    print(f"Username: dataadmin")
    print(f"Email: dataadmin@futurefinder.com")
    print(f"Password: dataadmin123")
    print(f"Role: Data Administrator")
    print(f"Permissions: Full admin access")
    print()
    print("This user can:")
    print("- Access Django admin panel")
    print("- View all user data")
    print("- Manage user profiles")
    print("- View all activities")
    print("- Manage AI recommendations")
    print("- Export/import data")
    print()
    print("Login URLs:")
    print("- Admin Panel: http://localhost:8000/admin/")
    print("- Flutter App: Use dataadmin@futurefinder.com / dataadmin123")

if __name__ == "__main__":
    create_data_superuser()