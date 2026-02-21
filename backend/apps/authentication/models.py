from django.contrib.auth.models import User
from django.db import models
from django.utils import timezone
from django.db.models.signals import post_save
from django.contrib.auth.signals import user_logged_in
from django.dispatch import receiver

class UserProfile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name='profile')
    interests = models.JSONField(default=list, blank=True)
    skills = models.JSONField(default=list, blank=True)
    academic_level = models.CharField(max_length=50, blank=True)
    stream = models.CharField(max_length=50, blank=True)
    profile_picture = models.CharField(max_length=255, blank=True)  # URL to profile picture
    phone = models.CharField(max_length=15, blank=True)
    location = models.CharField(max_length=100, blank=True)
    bio = models.TextField(blank=True)
    
    # Live tracking fields
    created_at = models.DateTimeField(auto_now_add=True)
    updated_at = models.DateTimeField(auto_now=True)
    last_login = models.DateTimeField(null=True, blank=True)
    login_count = models.IntegerField(default=0)
    is_online = models.BooleanField(default=False)
    
    def __str__(self):
        return f"{self.user.username}'s Profile"

class UserActivity(models.Model):
    ACTIVITY_CHOICES = [
        ('registration', 'Registration'),
        ('login', 'Login'),
        ('logout', 'Logout'),
        ('profile_update', 'Profile Update'),
        ('password_change', 'Password Change'),
        ('ai_recommendation', 'AI Recommendation Request'),
    ]
    
    user = models.ForeignKey(User, on_delete=models.CASCADE, related_name='activities', null=True, blank=True)
    activity_type = models.CharField(max_length=20, choices=ACTIVITY_CHOICES)
    ip_address = models.GenericIPAddressField(null=True, blank=True)
    user_agent = models.TextField(blank=True)
    timestamp = models.DateTimeField(auto_now_add=True)
    success = models.BooleanField(default=True)
    details = models.JSONField(default=dict, blank=True)
    
    class Meta:
        ordering = ['-timestamp']
        verbose_name_plural = 'User Activities'
    
    def __str__(self):
        username = self.user.username if self.user else 'Anonymous'
        return f"{username} - {self.activity_type} at {self.timestamp}"

@receiver(post_save, sender=User)
def create_user_profile(sender, instance, created, **kwargs):
    if created:
        UserProfile.objects.create(user=instance)
        UserActivity.objects.create(
            user=instance,
            activity_type='registration',
            details={'email': instance.email}
        )

@receiver(user_logged_in)
def log_user_login(sender, request, user, **kwargs):
    profile = user.profile
    profile.last_login = timezone.now()
    profile.login_count += 1
    profile.is_online = True
    profile.save()
    
    UserActivity.objects.create(
        user=user,
        activity_type='login',
        ip_address=get_client_ip(request),
        user_agent=request.META.get('HTTP_USER_AGENT', ''),
        details={'login_count': profile.login_count}
    )

def get_client_ip(request):
    x_forwarded_for = request.META.get('HTTP_X_FORWARDED_FOR')
    if x_forwarded_for:
        ip = x_forwarded_for.split(',')[0]
    else:
        ip = request.META.get('REMOTE_ADDR')
    return ip