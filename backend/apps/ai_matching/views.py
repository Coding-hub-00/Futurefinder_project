from rest_framework.decorators import api_view, permission_classes
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from .models import JobMarketData, PersonalityProfile, AIRecommendation
from apps.careers.models import Career
import uuid
import random
from datetime import datetime
import requests
import json
try:
    from config import GEMINI_API_KEY
except ImportError:
    GEMINI_API_KEY = "YOUR_GEMINI_API_KEY_HERE"

@api_view(['GET'])
@permission_classes([AllowAny])
def get_market_trends(request):
    trends = JobMarketData.objects.all().order_by('-demand_score')[:10]
    return Response([{
        'skill': trend.skill_name,
        'demand_score': trend.demand_score,
        'avg_salary': trend.avg_salary,
        'growth_rate': trend.growth_rate,
        'location': trend.location
    } for trend in trends])

@api_view(['POST'])
@permission_classes([AllowAny])
def personality_assessment(request):
    answers = request.data.get('answers', [])
    session_id = str(uuid.uuid4())
    
    # Simple personality analysis
    traits = analyze_personality(answers)
    personality_type = determine_personality_type(traits)
    
    profile = PersonalityProfile.objects.create(
        session_id=session_id,
        personality_type=personality_type,
        traits=traits,
        career_preferences=request.data.get('preferences', []),
        work_style=request.data.get('work_style', {})
    )
    
    return Response({
        'session_id': session_id,
        'personality_type': personality_type,
        'traits': traits,
        'description': get_personality_description(personality_type)
    })

@api_view(['POST'])
@permission_classes([AllowAny])
def ai_career_match(request):
    user_skills = request.data.get('skills', [])
    academic_level = request.data.get('academic_level', 'undergraduate')
    stream = request.data.get('stream', 'engineering')
    interests = request.data.get('interests', [])
    user_email = request.data.get('email', '')
    session_id = str(uuid.uuid4())
    
    # Find user if email provided
    user = None
    if user_email:
        from django.contrib.auth.models import User
        user = User.objects.filter(email=user_email).first()
    
    # Log recommendation request
    if user:
        from apps.authentication.models import UserActivity
        UserActivity.objects.create(
            user=user,
            activity_type='ai_recommendation',
            details={
                'skills': user_skills,
                'academic_level': academic_level,
                'stream': stream,
                'interests': interests,
                'session_id': session_id,
                'timestamp': datetime.now().isoformat()
            }
        )
    
    # AI Bot Analysis
    bot_analysis = ai_bot_analyze_profile({
        'skills': user_skills,
        'academic_level': academic_level,
        'stream': stream,
        'interests': interests
    })
    
    careers = Career.objects.all()
    recommendations = []
    
    for career in careers:
        match_score = ai_calculate_match_score(career, user_skills, academic_level, stream, interests, bot_analysis)
        reasoning = ai_generate_reasoning(career, user_skills, bot_analysis)
        market_data = get_market_outlook(career.required_skills)
        skill_gaps = list(set(career.required_skills) - set(user_skills))
        learning_path = ai_generate_learning_path(skill_gaps, academic_level)
        
        recommendation = AIRecommendation.objects.create(
            session_id=session_id,
            career_title=career.title,
            match_score=match_score,
            reasoning=reasoning,
            market_outlook=market_data,
            skill_gaps=skill_gaps,
            learning_path=learning_path
        )
        
        recommendations.append({
            'career': career.title,
            'description': career.description,
            'match_score': match_score,
            'reasoning': reasoning,
            'market_outlook': market_data,
            'skill_gaps': skill_gaps,
            'learning_path': learning_path,
            'bot_insights': bot_analysis.get('insights', [])
        })
    
    # AI-powered sorting
    recommendations.sort(key=lambda x: x['match_score'], reverse=True)
    
    # Update user profile if provided
    if user and user_skills:
        profile = user.profile
        profile.skills = user_skills
        profile.interests = interests
        profile.academic_level = academic_level
        profile.stream = stream
        profile.save()
    
    return Response({
        'session_id': session_id,
        'recommendations': recommendations[:5],
        'bot_message': bot_analysis.get('message', 'Based on your profile, here are my top recommendations!'),
        'user_updated': bool(user)
    })

def analyze_personality(answers):
    # Simplified personality analysis
    traits = {
        'extroversion': random.uniform(0.3, 0.9),
        'openness': random.uniform(0.4, 0.8),
        'conscientiousness': random.uniform(0.5, 0.9),
        'agreeableness': random.uniform(0.4, 0.8),
        'neuroticism': random.uniform(0.2, 0.6)
    }
    return traits

def determine_personality_type(traits):
    if traits['openness'] > 0.7 and traits['conscientiousness'] > 0.7:
        return 'analyst'
    elif traits['agreeableness'] > 0.7 and traits['extroversion'] > 0.6:
        return 'diplomat'
    elif traits['conscientiousness'] > 0.8:
        return 'sentinel'
    else:
        return 'explorer'

def get_personality_description(personality_type):
    descriptions = {
        'analyst': 'Logical, innovative, and strategic thinkers',
        'diplomat': 'Empathetic, cooperative, and people-focused',
        'sentinel': 'Practical, reliable, and detail-oriented',
        'explorer': 'Flexible, adaptable, and action-oriented'
    }
    return descriptions.get(personality_type, 'Unique personality profile')

def calculate_match_score(career, user_skills, personality_type, preferences):
    skill_match = len(set(user_skills).intersection(set(career.required_skills))) / len(career.required_skills) if career.required_skills else 0
    personality_bonus = 0.2 if personality_type in ['analyst', 'explorer'] else 0.1
    preference_bonus = 0.1 if any(pref in career.title.lower() for pref in preferences) else 0
    
    return min(100, (skill_match * 70 + personality_bonus * 100 + preference_bonus * 100))

def generate_reasoning(career, user_skills, personality_type):
    matched_skills = set(user_skills).intersection(set(career.required_skills))
    return [
        f"You have {len(matched_skills)} out of {len(career.required_skills)} required skills",
        f"Your {personality_type} personality type aligns well with this role",
        "Strong growth potential in this field"
    ]

def get_market_outlook(skills):
    return {
        'demand': 'High',
        'growth_rate': f"{random.uniform(5, 15):.1f}%",
        'avg_salary': f"${random.randint(50000, 120000):,}"
    }

def generate_learning_path(skill_gaps):
    return [f"Learn {skill}" for skill in skill_gaps[:3]]

def ai_bot_analyze_profile(profile):
    """AI Bot analyzes user profile and provides insights"""
    skills = profile.get('skills', [])
    academic_level = profile.get('academic_level', '')
    stream = profile.get('stream', '')
    interests = profile.get('interests', [])
    
    # AI Bot Logic
    insights = []
    message = "Hello! I'm your AI career advisor. "
    
    if len(skills) >= 3:
        insights.append("Strong skill foundation detected")
        message += "I see you have a solid skill set. "
    else:
        insights.append("Skill development recommended")
        message += "Let's work on building more skills. "
    
    if stream == 'engineering' and 'python' in [s.lower() for s in skills]:
        insights.append("Tech career alignment strong")
        message += "Your engineering background with Python is excellent for tech careers!"
    elif stream == 'business' and any(interest.lower() in ['finance', 'marketing'] for interest in interests):
        insights.append("Business domain expertise")
        message += "Your business background aligns well with your interests!"
    
    return {
        'insights': insights,
        'message': message,
        'confidence': min(90, 60 + len(skills) * 5 + len(interests) * 3)
    }

def ai_calculate_match_score(career, user_skills, academic_level, stream, interests, bot_analysis):
    """Enhanced AI matching with bot insights"""
    base_score = len(set(user_skills).intersection(set(career.required_skills))) / len(career.required_skills) if career.required_skills else 0
    
    # Academic level bonus
    level_bonus = {
        'high_school': 0.1,
        'undergraduate': 0.15,
        'postgraduate': 0.2,
        'phd': 0.25
    }.get(academic_level, 0.1)
    
    # Stream alignment
    stream_bonus = 0.1 if stream in career.title.lower() or stream in career.description.lower() else 0
    
    # Interest alignment
    interest_bonus = 0.05 * sum(1 for interest in interests if interest.lower() in career.description.lower())
    
    # Bot confidence factor
    bot_bonus = bot_analysis.get('confidence', 60) / 1000
    
    final_score = (base_score * 70 + level_bonus * 100 + stream_bonus * 100 + interest_bonus * 100 + bot_bonus * 100)
    return min(100, final_score)

def ai_generate_reasoning(career, user_skills, bot_analysis):
    """AI-powered reasoning generation"""
    matched_skills = set(user_skills).intersection(set(career.required_skills))
    reasoning = [
        f"✓ You have {len(matched_skills)} out of {len(career.required_skills)} required skills",
        f"✓ AI Confidence: {bot_analysis.get('confidence', 60)}%"
    ]
    
    for insight in bot_analysis.get('insights', []):
        reasoning.append(f"✓ {insight}")
    
    return reasoning

def ai_generate_learning_path(skill_gaps, academic_level):
    """AI-powered learning path generation"""
    if not skill_gaps:
        return ["Continue advancing your existing skills"]
    
    paths = []
    for skill in skill_gaps[:3]:
        if academic_level in ['undergraduate', 'postgraduate']:
            paths.append(f"📚 Master {skill} through advanced courses")
        else:
            paths.append(f"🎯 Learn {skill} fundamentals")
    
    return paths

@api_view(['POST'])
@permission_classes([AllowAny])
def ai_chat_bot(request):
    """AI Chat Bot for career guidance using Google Gemini"""
    message = request.data.get('message', '')
    user_profile = request.data.get('profile', {})
    
    try:
        # Try Gemini API first
        response = generate_gemini_response(message, user_profile)
    except Exception as e:
        print(f"Gemini API Error: {e}")
        # Fallback to local responses
        response = generate_bot_response(message, user_profile)
    
    return Response({
        'bot_response': response,
        'timestamp': datetime.now().isoformat(),
        'suggestions': get_chat_suggestions(message)
    })

def generate_gemini_response(message, profile):
    """Generate response using Google Gemini API"""
    API_KEY = GEMINI_API_KEY
    
    if API_KEY == "YOUR_GEMINI_API_KEY_HERE":
        raise Exception("Gemini API key not configured")
    
    # Build context from user profile
    context = f"""
You are an AI Career Advisor helping users with career guidance. 

User Profile:
- Skills: {', '.join(profile.get('skills', []))}
- Academic Level: {profile.get('academic_level', 'Not specified')}
- Stream: {profile.get('stream', 'Not specified')}
- Interests: {', '.join(profile.get('interests', []))}

Provide helpful, personalized career advice. Keep responses concise but informative. Use emojis appropriately.

User Question: {message}
"""
    
    url = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key={API_KEY}"
    
    payload = {
        "contents": [{
            "parts": [{
                "text": context
            }]
        }]
    }
    
    headers = {
        "Content-Type": "application/json"
    }
    
    response = requests.post(url, json=payload, headers=headers, timeout=10)
    
    if response.status_code == 200:
        data = response.json()
        if 'candidates' in data and len(data['candidates']) > 0:
            return data['candidates'][0]['content']['parts'][0]['text']
    
    raise Exception(f"Gemini API failed: {response.status_code}")

def generate_bot_response(message, profile):
    """Fallback AI bot responses"""
    message_lower = message.lower()
    
    if any(word in message_lower for word in ['hello', 'hi', 'hey']):
        return "Hi there! I'm your AI career advisor. How can I help you today? 🚀"
    
    elif 'career' in message_lower or 'job' in message_lower:
        return "I'd love to help you explore career options! Based on your profile, I can suggest personalized career paths. What specific field interests you?"
    
    elif 'skill' in message_lower:
        skills = profile.get('skills', [])
        if skills:
            return f"Great question! I see you have skills in {', '.join(skills[:3])}. I recommend building on these with advanced projects and certifications."
        else:
            return "Skills are crucial for career growth! What field are you interested in? I can suggest the most in-demand skills."
    
    elif 'salary' in message_lower or 'money' in message_lower:
        return "Salary depends on many factors like location, experience, and skills. Tech roles typically offer ₹6-25L+ based on expertise. Would you like specific salary insights for any career?"
    
    elif 'learn' in message_lower or 'course' in message_lower:
        return "Learning never stops! I can recommend personalized courses based on your career goals. What skills would you like to develop?"
    
    else:
        return "That's an interesting question! I'm here to help with career guidance, skill development, and job market insights. Feel free to ask me anything about your career journey! 🎆"

def get_chat_suggestions(message):
    """Get suggested follow-up questions"""
    suggestions = [
        "What careers match my profile?",
        "How can I improve my skills?",
        "What's the job market like?",
        "Suggest learning paths for me"
    ]
    
    if 'career' in message.lower():
        suggestions = [
            "Show me salary ranges",
            "What skills do I need?",
            "Find similar careers",
            "Growth opportunities?"
        ]
    
    return suggestions[:3]