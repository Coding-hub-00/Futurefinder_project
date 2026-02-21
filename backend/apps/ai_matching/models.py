from django.db import models

class JobMarketData(models.Model):
    skill_name = models.CharField(max_length=100)
    demand_score = models.FloatField()
    avg_salary = models.IntegerField()
    growth_rate = models.FloatField()
    location = models.CharField(max_length=100, default='Global')
    last_updated = models.DateTimeField(auto_now=True)
    
    def __str__(self):
        return f"{self.skill_name} - Demand: {self.demand_score}"

class PersonalityProfile(models.Model):
    PERSONALITY_TYPES = [
        ('analyst', 'Analyst'),
        ('diplomat', 'Diplomat'),
        ('sentinel', 'Sentinel'),
        ('explorer', 'Explorer')
    ]
    
    session_id = models.CharField(max_length=100)
    personality_type = models.CharField(max_length=20, choices=PERSONALITY_TYPES)
    traits = models.JSONField(default=dict)
    career_preferences = models.JSONField(default=list)
    work_style = models.JSONField(default=dict)
    created_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return f"{self.session_id} - {self.personality_type}"

class AIRecommendation(models.Model):
    session_id = models.CharField(max_length=100)
    career_title = models.CharField(max_length=200)
    match_score = models.FloatField()
    reasoning = models.JSONField(default=list)
    market_outlook = models.JSONField(default=dict)
    skill_gaps = models.JSONField(default=list)
    learning_path = models.JSONField(default=list)
    created_at = models.DateTimeField(auto_now_add=True)
    
    def __str__(self):
        return f"{self.career_title} - {self.match_score}%"