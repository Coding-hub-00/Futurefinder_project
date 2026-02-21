from rest_framework import status
from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework.response import Response
from django.contrib.auth import authenticate, login
from django.contrib.auth.models import User
from django.utils import timezone
from .models import UserProfile, UserActivity
from .serializers import UserRegistrationSerializer, UserDetailSerializer, UserProfileSerializer

def get_client_ip(request):
    x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
    if x_forwarded_for:
        ip = x_forwarded_for.split(',')[0]
    else:
        ip = request.META.get('REMOTE_ADDR')
    return ip

@api_view(['POST'])
@permission_classes([AllowAny])
def register(request):
    serializer = UserRegistrationSerializer(data=request.data)
    if serializer.is_valid():
        user = serializer.save()
        
        # Log registration activity
        UserActivity.objects.create(
            user=user,
            activity_type='registration',
            ip_address=get_client_ip(request),
            user_agent=request.META.get('HTTP_USER_AGENT', ''),
            details={
                'email': user.email,
                'username': user.username,
                'registration_time': timezone.now().isoformat()
            }
        )
        
        return Response({
            'message': 'User created successfully',
            'user_id': user.id,
            'username': user.username
        }, status=status.HTTP_201_CREATED)
    return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['POST'])
@permission_classes([AllowAny])
def login_user(request):
    username_or_email = request.data.get('username') or request.data.get('email')
    password = request.data.get('password')
    
    # Try to find user by email if it looks like an email
    user = None
    if '@' in username_or_email:
        try:
            user_obj = User.objects.get(email=username_or_email)
            user = authenticate(username=user_obj.username, password=password)
        except User.DoesNotExist:
            pass
    else:
        user = authenticate(username=username_or_email, password=password)
    
    if user:
        # Update profile
        profile = user.profile
        profile.last_login = timezone.now()
        profile.login_count += 1
        profile.is_online = True
        profile.save()
        
        # Log login activity
        UserActivity.objects.create(
            user=user,
            activity_type='login',
            ip_address=get_client_ip(request),
            user_agent=request.META.get('HTTP_USER_AGENT', ''),
            success=True,
            details={
                'login_time': timezone.now().isoformat(),
                'login_count': profile.login_count
            }
        )
        
        return Response({
            'message': 'Login successful',
            'user_id': user.id,
            'username': user.username,
            'login_count': profile.login_count,
            'last_login': profile.last_login
        })
    else:
        # Log failed login attempt
        try:
            if '@' in username_or_email:
                failed_user = User.objects.get(email=username_or_email)
            else:
                failed_user = User.objects.get(username=username_or_email)
            UserActivity.objects.create(
                user=failed_user,
                activity_type='login',
                ip_address=get_client_ip(request),
                user_agent=request.META.get('HTTP_USER_AGENT', ''),
                success=False,
                details={'reason': 'Invalid password', 'attempted_login': username_or_email}
            )
        except User.DoesNotExist:
            # Log anonymous failed attempt
            UserActivity.objects.create(
                user=None,
                activity_type='login',
                ip_address=get_client_ip(request),
                user_agent=request.META.get('HTTP_USER_AGENT', ''),
                success=False,
                details={'reason': 'User not found', 'attempted_login': username_or_email}
            )
            
        return Response({'error': 'Invalid credentials'}, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET', 'PUT'])
@permission_classes([IsAuthenticated])
def profile(request):
    user = request.user
    
    if request.method == 'GET':
        serializer = UserDetailSerializer(user)
        return Response(serializer.data)
    
    elif request.method == 'PUT':
        # Update user basic info
        user.first_name = request.data.get('first_name', user.first_name)
        user.last_name = request.data.get('last_name', user.last_name)
        user.email = request.data.get('email', user.email)
        user.save()
        
        # Update profile
        profile_data = request.data.get('profile', {})
        profile = user.profile
        
        old_data = {
            'interests': profile.interests,
            'skills': profile.skills,
            'academic_level': profile.academic_level,
            'stream': profile.stream
        }
        
        for key, value in profile_data.items():
            if hasattr(profile, key):
                setattr(profile, key, value)
        
        profile.save()
        
        # Log profile update
        UserActivity.objects.create(
            user=user,
            activity_type='profile_update',
            ip_address=get_client_ip(request),
            user_agent=request.META.get('HTTP_USER_AGENT', ''),
            details={
                'updated_fields': list(profile_data.keys()),
                'old_data': old_data,
                'new_data': profile_data,
                'update_time': timezone.now().isoformat()
            }
        )
        
        serializer = UserDetailSerializer(user)
        return Response({
            'message': 'Profile updated successfully',
            'user': serializer.data
        })

@api_view(['POST'])
@permission_classes([IsAuthenticated])
def logout_user(request):
    user = request.user
    
    # Update online status
    profile = user.profile
    profile.is_online = False
    profile.save()
    
    # Log logout activity
    UserActivity.objects.create(
        user=user,
        activity_type='logout',
        ip_address=get_client_ip(request),
        user_agent=request.META.get('HTTP_USER_AGENT', ''),
        details={'logout_time': timezone.now().isoformat()}
    )
    
    return Response({'message': 'Logged out successfully'})

@api_view(['POST'])
@permission_classes([AllowAny])
def save_profile_data(request):
    """Save user profile data from quick recommendation"""
    try:
        # Get user by email or username
        email = request.data.get('email')
        username = request.data.get('username')
        
        user = None
        if email:
            user = User.objects.filter(email=email).first()
        elif username:
            user = User.objects.filter(username=username).first()
        
        if not user:
            return Response({'error': 'User not found'}, status=404)
        
        # Update profile data
        profile = user.profile
        profile.skills = request.data.get('skills', profile.skills)
        profile.interests = request.data.get('interests', profile.interests)
        profile.academic_level = request.data.get('academic_level', profile.academic_level)
        profile.stream = request.data.get('stream', profile.stream)
        profile.save()
        
        # Log profile update
        UserActivity.objects.create(
            user=user,
            activity_type='profile_update',
            ip_address=get_client_ip(request),
            user_agent=request.META.get('HTTP_USER_AGENT', ''),
            details={
                'updated_via': 'quick_recommendation',
                'skills': profile.skills,
                'interests': profile.interests,
                'academic_level': profile.academic_level,
                'stream': profile.stream,
                'update_time': timezone.now().isoformat()
            }
        )
        
        return Response({
            'message': 'Profile updated successfully',
            'user': {
                'username': user.username,
                'email': user.email,
                'skills': profile.skills,
                'interests': profile.interests,
                'academic_level': profile.academic_level,
                'stream': profile.stream
            }
        })
        
    except Exception as e:
        return Response({'error': str(e)}, status=400)

@api_view(['GET'])
@permission_classes([IsAuthenticated])
def user_activities(request):
    activities = UserActivity.objects.filter(user=request.user)[:20]
    data = [{
        'activity_type': activity.activity_type,
        'timestamp': activity.timestamp,
        'success': activity.success,
        'details': activity.details
    } for activity in activities]
    
    return Response({'activities': data})