from django.db import models

class Career(models.Model):
    title = models.CharField(max_length=200)
    description = models.TextField()
    required_skills = models.JSONField(default=list)
    resources = models.TextField(blank=True)
    salary_range = models.CharField(max_length=100, blank=True)
    job_outlook = models.TextField(blank=True)
    education_path = models.JSONField(default=list)
    career_steps = models.JSONField(default=list)
    top_companies = models.JSONField(default=list)
    created_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return self.title