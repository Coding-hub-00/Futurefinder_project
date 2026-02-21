from django.contrib import admin
from .models import JobMarketData, PersonalityProfile, AIRecommendation

@admin.register(JobMarketData)
class JobMarketDataAdmin(admin.ModelAdmin):
    list_display = ('skill_name', 'demand_score', 'avg_salary', 'growth_rate', 'location')
    list_filter = ('location', 'last_updated')

@admin.register(PersonalityProfile)
class PersonalityProfileAdmin(admin.ModelAdmin):
    list_display = ('session_id', 'personality_type', 'created_at')
    list_filter = ('personality_type', 'created_at')

@admin.register(AIRecommendation)
class AIRecommendationAdmin(admin.ModelAdmin):
    list_display = ('session_id', 'career_title', 'match_score', 'created_at')
    list_filter = ('created_at',)