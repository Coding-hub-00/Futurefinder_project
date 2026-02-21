#!/usr/bin/env python3
"""
Data Viewer - Shows all stored data in your FutureFinder app
"""
import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'futurefinder.settings')
django.setup()

from django.contrib.auth.models import User
from apps.careers.models import Career
from apps.jobs.models import Job
from apps.learning.models import Course
from apps.mentorship.models import Mentor
from apps.ai_matching.models import JobMarketData, PersonalityProfile, AIRecommendation

def show_all_data():
    print("🗄️  FUTUREFINDER DATA STORAGE OVERVIEW")
    print("=" * 50)
    
    # Database location
    print(f"📍 Database Location: {os.path.abspath('db.sqlite3')}")
    print(f"📊 Database Size: {os.path.getsize('db.sqlite3') / 1024:.1f} KB")
    print()
    
    # Users
    users = User.objects.all()
    print(f"👥 USERS ({users.count()} total)")
    for user in users:
        print(f"   • {user.username} ({user.email}) - {'Admin' if user.is_superuser else 'User'}")
    print()
    
    # Careers
    careers = Career.objects.all()
    print(f"💼 CAREERS ({careers.count()} total)")
    for career in careers:
        print(f"   • {career.title}")
        print(f"     Skills: {', '.join(career.required_skills) if career.required_skills else 'None'}")
    print()
    
    # Jobs
    jobs = Job.objects.all()
    print(f"🏢 JOBS ({jobs.count()} total)")
    for job in jobs:
        print(f"   • {job.title} at {job.company}")
        print(f"     Location: {job.location}, Type: {job.job_type}")
    print()
    
    # Courses
    courses = Course.objects.all()
    print(f"📚 COURSES ({courses.count()} total)")
    for course in courses:
        print(f"   • {course.title} by {course.provider}")
        print(f"     Duration: {course.duration_hours}h, Price: ₹{course.price}")
    print()
    
    # Mentors
    mentors = Mentor.objects.all()
    print(f"👨‍🏫 MENTORS ({mentors.count()} total)")
    for mentor in mentors:
        print(f"   • {mentor.name} - {mentor.title} at {mentor.company}")
        print(f"     Experience: {mentor.experience_years} years, Rate: ₹{mentor.hourly_rate}/hr")
    print()
    
    # AI Data
    ai_recs = AIRecommendation.objects.all()
    profiles = PersonalityProfile.objects.all()
    market_data = JobMarketData.objects.all()
    
    print(f"🤖 AI DATA")
    print(f"   • AI Recommendations: {ai_recs.count()}")
    print(f"   • Personality Profiles: {profiles.count()}")
    print(f"   • Market Data: {market_data.count()}")
    print()
    
    # File Storage
    print("📁 FILE STORAGE LOCATIONS")
    print(f"   • User Profiles: backend/media/profiles/ (if any)")
    print(f"   • Static Files: backend/static/ (if any)")
    print(f"   • Logs: backend/logs/ (if any)")
    print()
    
    # Flutter App Data
    print("📱 FLUTTER APP DATA")
    print("   • User tokens: Stored in device secure storage")
    print("   • Cache: Device temporary storage")
    print("   • Preferences: Device local storage")
    print()
    
    print("🔧 DATA MANAGEMENT COMMANDS")
    print("   • View admin panel: python manage.py runserver → http://localhost:8000/admin/")
    print("   • Create superuser: python manage.py createsuperuser")
    print("   • Backup database: copy db.sqlite3 to backup location")
    print("   • Reset database: delete db.sqlite3, run migrations")

if __name__ == "__main__":
    show_all_data()