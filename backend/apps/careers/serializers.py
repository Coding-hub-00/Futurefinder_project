from rest_framework import serializers
from .models import Career

class CareerSerializer(serializers.ModelSerializer):
    match_percentage = serializers.SerializerMethodField()
    
    class Meta:
        model = Career
        fields = ['id', 'title', 'description', 'required_skills', 'resources', 
                 'salary_range', 'job_outlook', 'education_path', 'career_steps', 
                 'top_companies', 'match_percentage']
    
    def get_match_percentage(self, obj):
        return 85.0  # Default match percentage