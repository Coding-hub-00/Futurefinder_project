from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from rest_framework.response import Response

@api_view(['GET'])
@permission_classes([AllowAny])
def course_list(request):
    courses = [
        {
            'id': 1,
            'title': 'Python Programming Bootcamp',
            'provider': 'TechEd',
            'duration': '8 weeks',
            'level': 'Beginner',
            'rating': 4.8,
            'price': '₹4,999'
        },
        {
            'id': 2,
            'title': 'Data Science with Python',
            'provider': 'DataLearn',
            'duration': '12 weeks',
            'level': 'Intermediate',
            'rating': 4.9,
            'price': '₹8,999'
        },
        {
            'id': 3,
            'title': 'UI/UX Design Fundamentals',
            'provider': 'DesignAcademy',
            'duration': '6 weeks',
            'level': 'Beginner',
            'rating': 4.7,
            'price': '₹3,999'
        }
    ]
    return Response(courses)