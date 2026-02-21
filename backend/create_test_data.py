import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'futurefinder.settings')
django.setup()

from django.contrib.auth.models import User
from apps.careers.models import Career
from apps.jobs.models import Job
from apps.mentorship.models import Mentor
from apps.learning.models import Course

# Create test user
user, created = User.objects.get_or_create(
    username='test',
    defaults={'email': 'test@example.com'}
)
if created:
    user.set_password('test123')
    user.save()
    print('Test user created: test/test123')

# Create test careers
Career.objects.get_or_create(
    title='Flutter Developer',
    defaults={
        'description': 'Build cross-platform mobile apps with Flutter framework',
        'required_skills': ['Flutter', 'Dart', 'Mobile Development'],
        'resources': 'Flutter documentation, Dart tutorials'
    }
)

Career.objects.get_or_create(
    title='Python Developer',
    defaults={
        'description': 'Backend development with Python and Django',
        'required_skills': ['Python', 'Django', 'REST APIs'],
        'resources': 'Python docs, Django tutorials'
    }
)

# Create test jobs
from datetime import datetime, timedelta
Job.objects.get_or_create(
    title='Flutter Developer',
    company='TechCorp',
    defaults={
        'location': 'Mumbai',
        'job_type': 'full_time',
        'salary_min': 800000,
        'salary_max': 1500000,
        'description': 'Looking for Flutter developer',
        'requirements': ['2+ years experience'],
        'skills_required': ['Flutter', 'Dart'],
        'experience_level': 'Mid-level',
        'application_deadline': datetime.now() + timedelta(days=30),
        'apply_link': 'https://example.com/apply'
    }
)

# Create test mentor
Mentor.objects.get_or_create(
    name='John Doe',
    defaults={
        'title': 'Senior Flutter Developer',
        'company': 'Google',
        'expertise': ['Flutter', 'Mobile Development'],
        'experience_years': 8,
        'bio': 'Experienced Flutter developer',
        'rating': 4.8,
        'hourly_rate': 2000,
        'availability': {}
    }
)

# Create test course
Course.objects.get_or_create(
    title='Flutter Complete Course',
    defaults={
        'provider': 'Udemy',
        'description': 'Learn Flutter from scratch',
        'category': 'Mobile Development',
        'difficulty_level': 'beginner',
        'duration_hours': 40,
        'price': 3000,
        'rating': 4.5,
        'skills_covered': ['Flutter', 'Dart'],
        'course_url': 'https://example.com/course',
        'is_free': False
    }
)

print('Test data created successfully!')