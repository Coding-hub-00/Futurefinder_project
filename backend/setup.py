#!/usr/bin/env python
import os
import django
from django.core.management import execute_from_command_line

os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'futurefinder.settings')
django.setup()

# Create sample data
from apps.careers.models import Career
from apps.resources.models import Resource

# Sample careers
careers_data = [
    {
        'title': 'Software Developer',
        'description': 'Build applications and systems using programming languages',
        'required_skills': ['Python', 'JavaScript', 'SQL', 'Git'],
        'resources': 'Learn programming fundamentals, practice coding, build projects'
    },
    {
        'title': 'Data Scientist',
        'description': 'Analyze data to extract insights and build predictive models',
        'required_skills': ['Python', 'Statistics', 'Machine Learning', 'SQL'],
        'resources': 'Study statistics, learn Python/R, practice with datasets'
    },
    {
        'title': 'UX Designer',
        'description': 'Design user experiences for digital products',
        'required_skills': ['Design Thinking', 'Prototyping', 'User Research', 'Figma'],
        'resources': 'Learn design principles, practice with design tools, study user psychology'
    }
]

for career_data in careers_data:
    Career.objects.get_or_create(**career_data)

# Sample resources
resources_data = [
    {
        'title': 'Resume Writing Tips',
        'content': 'Learn how to create an effective resume that stands out to employers.',
        'category': 'resume'
    },
    {
        'title': 'Interview Preparation',
        'content': 'Master the art of interviewing with these proven strategies.',
        'category': 'interview'
    },
    {
        'title': 'Networking Guide',
        'content': 'Build professional relationships that advance your career.',
        'category': 'networking'
    }
]

for resource_data in resources_data:
    Resource.objects.get_or_create(**resource_data)

print("Sample data created successfully!")