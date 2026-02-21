from django.contrib import admin
from .models import Job, JobApplication

@admin.register(Job)
class JobAdmin(admin.ModelAdmin):
    list_display = ('title', 'company', 'location', 'job_type', 'salary_min', 'posted_date')
    list_filter = ('job_type', 'location', 'is_remote', 'posted_date')
    search_fields = ('title', 'company', 'location')

@admin.register(JobApplication)
class JobApplicationAdmin(admin.ModelAdmin):
    list_display = ('applicant_name', 'job', 'match_score', 'status', 'applied_date')
    list_filter = ('status', 'applied_date')
    search_fields = ('applicant_name', 'applicant_email')