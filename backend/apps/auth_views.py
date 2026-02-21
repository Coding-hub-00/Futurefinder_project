from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework import status
from django.contrib.auth import authenticate
from django.contrib.auth.models import User
import json

@api_view(['POST'])
@permission_classes([AllowAny])
def login(request):
    try:
        username = request.data.get('username')
        password = request.data.get('password')
        
        # Try direct username authentication
        user = authenticate(username=username, password=password)
        
        # If failed and looks like email, try email lookup
        if not user and '@' in username:
            try:
                user_obj = User.objects.filter(email=username).first()
                if user_obj:
                    user = authenticate(username=user_obj.username, password=password)
            except:
                pass
        
        if user:
            return Response({
                'access': 'dummy_token',
                'user': {'id': user.id, 'username': user.username, 'email': user.email}
            })
        return Response({'error': 'Invalid credentials'}, status=400)
    except Exception as e:
        return Response({'error': str(e)}, status=500)

@api_view(['POST'])
@permission_classes([AllowAny])
def register(request):
    username = request.data.get('username')
    email = request.data.get('email')
    password = request.data.get('password')
    
    if User.objects.filter(username=username).exists():
        return Response({'error': 'Username exists'}, status=400)
    
    user = User.objects.create_user(username=username, email=email, password=password)
    return Response({'message': 'User created'}, status=201)

@api_view(['GET'])
@permission_classes([AllowAny])
def profile(request):
    return Response({
        'id': 1,
        'username': 'demo',
        'email': 'demo@example.com',
        'interests': [],
        'skills': []
    })