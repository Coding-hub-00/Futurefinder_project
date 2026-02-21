import os
import django

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'futurefinder.settings')
django.setup()

from apps.careers.models import Career

# Create sample careers
careers_data = [
    {
        'title': 'Software Engineer',
        'description': 'Design, develop, and maintain software applications using various programming languages and frameworks.',
        'required_skills': ['Python', 'JavaScript', 'React', 'Node.js', 'SQL'],
        'resources': 'Practice coding on LeetCode, build projects on GitHub, contribute to open source.',
        'salary_range': '₹8-25 LPA (Entry to Senior Level)',
        'job_outlook': 'Excellent - 22% growth expected over next 10 years',
        'education_path': [
            'Bachelor\'s in Computer Science or related field',
            'Learn programming languages (Python, Java, JavaScript)',
            'Build portfolio projects',
            'Complete internships or bootcamps'
        ],
        'career_steps': [
            'Junior Developer (0-2 years)',
            'Software Engineer (2-5 years)',
            'Senior Software Engineer (5-8 years)',
            'Tech Lead/Architect (8+ years)'
        ],
        'top_companies': ['Google', 'Microsoft', 'Amazon', 'Flipkart', 'Zomato', 'Paytm']
    },
    {
        'title': 'Data Scientist',
        'description': 'Analyze complex data to help organizations make informed business decisions using statistical methods and machine learning.',
        'required_skills': ['Python', 'R', 'Machine Learning', 'Statistics', 'SQL', 'Tableau'],
        'resources': 'Complete Kaggle competitions, learn from Coursera ML courses, practice with real datasets.',
        'salary_range': '₹10-30 LPA (Entry to Senior Level)',
        'job_outlook': 'Very Good - 31% growth expected over next 10 years',
        'education_path': [
            'Bachelor\'s in Mathematics, Statistics, or Computer Science',
            'Master\'s in Data Science (preferred)',
            'Learn Python/R and ML libraries',
            'Complete data science projects'
        ],
        'career_steps': [
            'Data Analyst (0-2 years)',
            'Junior Data Scientist (2-4 years)',
            'Data Scientist (4-7 years)',
            'Senior Data Scientist/ML Engineer (7+ years)'
        ],
        'top_companies': ['Netflix', 'Uber', 'Airbnb', 'Swiggy', 'Ola', 'PhonePe']
    },
    {
        'title': 'Digital Marketing Specialist',
        'description': 'Create and execute digital marketing campaigns across various online platforms to promote products and services.',
        'required_skills': ['SEO', 'Social Media Marketing', 'Google Ads', 'Content Creation', 'Analytics'],
        'resources': 'Get Google Ads certification, learn SEO tools, create content portfolio, study successful campaigns.',
        'salary_range': '₹4-15 LPA (Entry to Senior Level)',
        'job_outlook': 'Good - 10% growth expected over next 10 years',
        'education_path': [
            'Bachelor\'s in Marketing, Communications, or Business',
            'Digital marketing certifications',
            'Learn marketing tools and platforms',
            'Build portfolio of campaigns'
        ],
        'career_steps': [
            'Marketing Assistant (0-2 years)',
            'Digital Marketing Executive (2-4 years)',
            'Digital Marketing Manager (4-7 years)',
            'Head of Digital Marketing (7+ years)'
        ],
        'top_companies': ['Byju\'s', 'Unacademy', 'Myntra', 'Nykaa', 'BigBasket', 'Grofers']
    }
]

# Clear existing careers and create new ones
Career.objects.all().delete()

for career_data in careers_data:
    Career.objects.create(**career_data)

print("Sample careers created successfully!")