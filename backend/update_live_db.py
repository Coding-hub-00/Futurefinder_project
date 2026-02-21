#!/usr/bin/env python3
import os
import django

def update_database():
    print("Updating database for live tracking...")
    print("=" * 50)
    
    # Make migrations
    print("Creating migrations...")
    os.system('python manage.py makemigrations authentication')
    os.system('python manage.py makemigrations')
    
    # Apply migrations
    print("Applying migrations...")
    os.system('python manage.py migrate')
    
    # Create profiles for existing users
    print("Creating profiles for existing users...")
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'futurefinder.settings')
    django.setup()
    
    from django.contrib.auth.models import User
    from apps.authentication.models import UserProfile
    
    for user in User.objects.all():
        if not hasattr(user, 'profile'):
            UserProfile.objects.create(user=user)
            print(f"Created profile for {user.username}")
    
    print("Database updated successfully!")
    print("Live tracking features:")
    print("- User registration tracking")
    print("- Login/logout tracking")
    print("- Profile update tracking")
    print("- IP address and user agent logging")
    print("- Online status tracking")

if __name__ == "__main__":
    update_database()