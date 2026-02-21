from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from rest_framework.response import Response

@api_view(['GET'])
@permission_classes([AllowAny])
def job_list(request):
    jobs = [
        {
            'id': 1,
            'title': 'Software Developer',
            'company': 'TechCorp India',
            'location': 'Bangalore',
            'salary': '₹8-12 LPA',
            'type': 'Full-time',
            'posted': '2 days ago'
        },
        {
            'id': 2,
            'title': 'Data Scientist',
            'company': 'DataTech Solutions',
            'location': 'Mumbai',
            'salary': '₹10-15 LPA',
            'type': 'Full-time',
            'posted': '1 day ago'
        },
        {
            'id': 3,
            'title': 'UI/UX Designer',
            'company': 'Design Studio',
            'location': 'Delhi',
            'salary': '₹6-10 LPA',
            'type': 'Full-time',
            'posted': '3 days ago'
        }
    ]
    return Response(jobs)