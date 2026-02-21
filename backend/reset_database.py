#!/usr/bin/env python3
"""
Database Reset and Setup Script for FutureFinder
Resets database to match current Flutter app structure
"""
import os
import django
import shutil

def reset_database():
    print("🔄 Resetting FutureFinder Database...")
    print("=" * 50)
    
    # Remove old database
    if os.path.exists('db.sqlite3'):
        os.remove('db.sqlite3')
        print("✅ Old database removed")
    
    # Remove migration files
    apps = ['careers', 'ai_matching', 'jobs', 'learning']
    for app in apps:
        migrations_dir = f'apps/{app}/migrations'
        if os.path.exists(migrations_dir):
            for file in os.listdir(migrations_dir):
                if file.endswith('.py') and file != '__init__.py':
                    os.remove(os.path.join(migrations_dir, file))
            print(f"✅ {app} migrations cleared")
    
    print("\n📦 Creating new migrations...")
    os.system('python manage.py makemigrations')
    
    print("\n🏗️ Applying migrations...")
    os.system('python manage.py migrate')
    
    print("\n👤 Creating superuser...")
    os.system('python manage.py shell -c "from django.contrib.auth.models import User; User.objects.create_superuser(\'admin\', \'admin@futurefinder.com\', \'admin123\') if not User.objects.filter(username=\'admin\').exists() else print(\'Admin already exists\')"')
    
    print("\n📊 Loading sample data...")
    load_sample_data()
    
    print("\n✅ Database reset complete!")
    print("🔑 Admin credentials: admin / admin123")
    print("🌐 Admin panel: http://localhost:8000/admin/")

def load_sample_data():
    os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'futurefinder.settings')
    django.setup()
    
    from apps.careers.models import Career
    from apps.jobs.models import Job
    from apps.learning.models import Course
    from django.contrib.auth.models import User
    
    # Create sample careers
    careers_data = [
        {
            'title': 'Flutter Developer',
            'description': 'Build cross-platform mobile applications using Flutter framework',
            'required_skills': ['Flutter', 'Dart', 'Mobile Development', 'Firebase'],
            'resources': 'Flutter documentation, Dart tutorials, Firebase guides',
            'salary_range': '₹6-18 LPA',
            'job_outlook': 'Excellent - High demand for mobile developers',
            'education_path': ['Learn Dart programming', 'Master Flutter framework', 'Build portfolio apps'],
            'career_steps': ['Junior Flutter Developer', 'Flutter Developer', 'Senior Flutter Developer', 'Mobile Architect'],
            'top_companies': ['Google', 'Flipkart', 'Zomato', 'Paytm', 'Byju\'s']
        },
        {
            'title': 'AI/ML Engineer',
            'description': 'Develop artificial intelligence and machine learning solutions',
            'required_skills': ['Python', 'Machine Learning', 'TensorFlow', 'Data Science'],
            'resources': 'Python tutorials, ML courses, TensorFlow documentation',
            'salary_range': '₹8-25 LPA',
            'job_outlook': 'Excellent - AI is the future',
            'education_path': ['Master Python', 'Learn ML algorithms', 'Practice with datasets'],
            'career_steps': ['ML Intern', 'Junior ML Engineer', 'ML Engineer', 'Senior AI Engineer'],
            'top_companies': ['Google', 'Microsoft', 'Amazon', 'Netflix', 'Tesla']
        }
    ]
    
    for career_data in careers_data:
        Career.objects.get_or_create(title=career_data['title'], defaults=career_data)
    
    # Create sample jobs
    Job.objects.get_or_create(
        title='Flutter Developer',
        company='TechCorp',
        defaults={
            'location': 'Mumbai',
            'job_type': 'full_time',
            'salary_min': 600000,
            'salary_max': 1200000,
            'description': 'Looking for Flutter developer with 2+ years experience',
            'requirements': ['Flutter', 'Dart', 'Firebase'],
            'skills_required': ['Flutter', 'Dart', 'Mobile Development'],
            'experience_level': 'Mid-level',
            'apply_link': 'https://example.com/apply'
        }
    )
    
    # Create sample course
    Course.objects.get_or_create(
        title='Complete Flutter Development',
        defaults={
            'provider': 'Udemy',
            'description': 'Master Flutter from basics to advanced',
            'category': 'Mobile Development',
            'difficulty_level': 'beginner',
            'duration_hours': 50,
            'price': 2999,
            'rating': 4.7,
            'skills_covered': ['Flutter', 'Dart', 'Firebase'],
            'course_url': 'https://example.com/course',
            'is_free': False
        }
    )
    
    print("✅ Sample data loaded")

if __name__ == "__main__":
    reset_database()