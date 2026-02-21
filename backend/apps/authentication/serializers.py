from rest_framework import serializers
from django.contrib.auth import authenticate
from django.contrib.auth.models import User
from .models import UserProfile, UserActivity

class UserProfileSerializer(serializers.ModelSerializer):
    class Meta:
        model = UserProfile
        fields = ('interests', 'skills', 'academic_level', 'stream', 'phone', 'location', 'bio', 
                 'profile_picture', 'created_at', 'updated_at', 'last_login', 'login_count', 'is_online')
        read_only_fields = ('created_at', 'updated_at', 'last_login', 'login_count')

class UserRegistrationSerializer(serializers.ModelSerializer):
    password = serializers.CharField(write_only=True)
    profile = UserProfileSerializer(required=False)
    
    class Meta:
        model = User
        fields = ('username', 'email', 'password', 'first_name', 'last_name', 'profile')
    
    def create(self, validated_data):
        profile_data = validated_data.pop('profile', {})
        user = User.objects.create_user(**validated_data)
        
        # Update profile if provided
        if profile_data:
            for key, value in profile_data.items():
                if hasattr(user.profile, key):
                    setattr(user.profile, key, value)
            user.profile.save()
        
        return user

class UserDetailSerializer(serializers.ModelSerializer):
    profile = UserProfileSerializer(read_only=True)
    
    class Meta:
        model = User
        fields = ('id', 'username', 'email', 'first_name', 'last_name', 'date_joined', 'profile')

class UserActivitySerializer(serializers.ModelSerializer):
    class Meta:
        model = UserActivity
        fields = ('activity_type', 'timestamp', 'ip_address', 'success', 'details')