from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from .models import Career
from .serializers import CareerSerializer

@api_view(['GET'])
@permission_classes([AllowAny])
def recommendations(request):
    careers = Career.objects.all()
    serializer = CareerSerializer(careers, many=True)
    return Response(serializer.data)