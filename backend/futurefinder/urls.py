from django.contrib import admin
from django.urls import path, include
from django.http import JsonResponse

def api_root(request):
    return JsonResponse({
        'message': 'FutureFinder API v2.0', 
        'status': 'running',
        'features': ['careers', 'ai_matching', 'jobs', 'learning'],
        'endpoints': {
            'auth': '/api/auth/',
            'careers': '/api/careers/',
            'ai': '/api/ai/',
            'jobs': '/api/jobs/',
            'learning': '/api/learning/'
        }
    })

urlpatterns = [
    path('', api_root),
    path('admin/', admin.site.urls),
    path('api/', api_root),
    path('api/auth/', include('apps.authentication.urls')),
    path('api/careers/', include('apps.careers.urls')),
    path('api/ai/', include('apps.ai_matching.urls')),
    path('api/jobs/', include('apps.jobs.urls')),
    path('api/learning/', include('apps.learning.urls')),
]