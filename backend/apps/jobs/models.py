from django.db import models

class Job(models.Model):
    title = models.CharField(max_length=200)
    company = models.CharField(max_length=200)
    location = models.CharField(max_length=200)
    job_type = models.CharField(max_length=50, choices=[
        ('full_time', 'Full Time'),
        ('part_time', 'Part Time'),
        ('internship', 'Internship'),
        ('contract', 'Contract')
    ])
    salary_min = models.IntegerField()
    salary_max = models.IntegerField()
    description = models.TextField()
    requirements = models.JSONField(default=list)
    skills_required = models.JSONField(default=list)
    experience_level = models.CharField(max_length=50)
    posted_date = models.DateTimeField(auto_now_add=True)
    application_deadline = models.DateTimeField()
    apply_link = models.URLField()
    is_remote = models.BooleanField(default=False)
    
    def __str__(self):
        return f"{self.title} at {self.company}"

class JobApplication(models.Model):
    job = models.ForeignKey(Job, on_delete=models.CASCADE)
    applicant_name = models.CharField(max_length=200)
    applicant_email = models.EmailField()
    resume_text = models.TextField()
    cover_letter = models.TextField(blank=True)
    match_score = models.FloatField(default=0.0)
    status = models.CharField(max_length=20, choices=[
        ('applied', 'Applied'),
        ('reviewing', 'Under Review'),
        ('shortlisted', 'Shortlisted'),
        ('rejected', 'Rejected')
    ], default='applied')
    applied_date = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return f"{self.applicant_name} - {self.job.title}"