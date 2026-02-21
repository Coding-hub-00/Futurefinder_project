from django.urls import path
from . import views

urlpatterns = [
    path('market-trends/', views.get_market_trends, name='market_trends'),
    path('personality-assessment/', views.personality_assessment, name='personality_assessment'),
    path('ai-match/', views.ai_career_match, name='ai_career_match'),
    path('chat-bot/', views.ai_chat_bot, name='ai_chat_bot'),
]