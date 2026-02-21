from django.db import models

class Course(models.Model):
    title = models.CharField(max_length=200)
    provider = models.CharField(max_length=100)
    description = models.TextField()
    category = models.CharField(max_length=100)
    difficulty_level = models.CharField(max_length=20, choices=[
        ('beginner', 'Beginner'),
        ('intermediate', 'Intermediate'),
        ('advanced', 'Advanced')
    ])
    duration_hours = models.IntegerField()
    price = models.IntegerField(default=0)
    rating = models.FloatField(default=0.0)
    skills_covered = models.JSONField(default=list)
    course_url = models.URLField()
    is_free = models.BooleanField(default=False)
    
    def __str__(self):
        return f"{self.title} - {self.provider}"

class LearningPath(models.Model):
    title = models.CharField(max_length=200)
    description = models.TextField()
    target_role = models.CharField(max_length=200)
    total_duration = models.CharField(max_length=50)
    difficulty = models.CharField(max_length=20)
    courses = models.ManyToManyField(Course, through='PathCourse')
    
    def __str__(self):
        return self.title

class PathCourse(models.Model):
    learning_path = models.ForeignKey(LearningPath, on_delete=models.CASCADE)
    course = models.ForeignKey(Course, on_delete=models.CASCADE)
    order = models.IntegerField()
    is_mandatory = models.BooleanField(default=True)
    
    class Meta:
        ordering = ['order']