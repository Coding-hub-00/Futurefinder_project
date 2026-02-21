from django.contrib import admin
from .models import UserProfile, UserActivity

@admin.register(UserProfile)
class UserProfileAdmin(admin.ModelAdmin):
    list_display = ('user', 'academic_level', 'stream', 'login_count', 'is_online', 'last_login', 'updated_at')
    list_filter = ('academic_level', 'stream', 'is_online', 'created_at')
    search_fields = ('user__username', 'user__email', 'location')
    readonly_fields = ('created_at', 'updated_at', 'login_count', 'last_login')
    
    fieldsets = (
        ('User Info', {
            'fields': ('user', 'phone', 'location', 'bio')
        }),
        ('Academic Info', {
            'fields': ('academic_level', 'stream', 'skills', 'interests')
        }),
        ('Activity Tracking', {
            'fields': ('login_count', 'last_login', 'is_online', 'created_at', 'updated_at'),
            'classes': ('collapse',)
        }),
    )

@admin.register(UserActivity)
class UserActivityAdmin(admin.ModelAdmin):
    list_display = ('user', 'activity_type', 'success', 'timestamp', 'ip_address')
    list_filter = ('activity_type', 'success', 'timestamp')
    search_fields = ('user__username', 'ip_address')
    readonly_fields = ('timestamp',)
    
    def has_add_permission(self, request):
        return False  # Prevent manual creation
    
    def has_change_permission(self, request, obj=None):
        return False  # Prevent editing