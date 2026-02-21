#!/usr/bin/env python3
import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'futurefinder.settings')
django.setup()

from django.contrib.auth.models import User
from apps.careers.models import Career
from apps.jobs.models import Job
from apps.learning.models import Course
from apps.mentorship.models import Mentor

def show_all_data():
    print("FUTUREFINDER DATA STORAGE OVERVIEW")
    print("=" * 50)
    
    print(f"Database Location: {os.path.abspath('db.sqlite3')}")
    print(f"Database Size: {os.path.getsize('db.sqlite3') / 1024:.1f} KB")
    print()
    
    users = User.objects.all()
    print(f"USERS ({users.count()} total)")
    for user in users:
        print(f"   - {user.username} ({user.email}) - {'Admin' if user.is_superuser else 'User'}")
    print()
    
    careers = Career.objects.all()
    print(f"CAREERS ({careers.count()} total)")
    for career in careers:
        print(f"   - {career.title}")
        print(f"     Skills: {', '.join(career.required_skills) if career.required_skills else 'None'}")
    print()
    
    jobs = Job.objects.all()
    print(f"JOBS ({jobs.count()} total)")
    for job in jobs:
        print(f"   - {job.title} at {job.company}")
        print(f"     Location: {job.location}, Type: {job.job_type}")
    print()
    
    courses = Course.objects.all()
    print(f"COURSES ({courses.count()} total)")
    for course in courses:
        print(f"   - {course.title} by {course.provider}")
        print(f"     Duration: {course.duration_hours}h, Price: Rs.{course.price}")
    print()
    
    mentors = Mentor.objects.all()
    print(f"MENTORS ({mentors.count()} total)")
    for mentor in mentors:
        print(f"   - {mentor.name} - {mentor.title} at {mentor.company}")
        print(f"     Experience: {mentor.experience_years} years, Rate: Rs.{mentor.hourly_rate}/hr")
    print()
    
    print("DATA STORAGE LOCATIONS")
    print("   - Main Database: backend/db.sqlite3")
    print("   - User Profiles: backend/media/profiles/")
    print("   - API Keys: backend/config.py")
    print("   - Flutter Data: Device secure storage")
    print()
    
    print("MANAGEMENT COMMANDS")
    print("   - Admin panel: python manage.py runserver -> localhost:8000/admin/")
    print("   - Create admin: python manage.py createsuperuser")
    print("   - Backup: copy db.sqlite3")

if __name__ == "__main__":
    show_all_data()