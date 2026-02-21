from django.contrib import admin
from .models import Course, LearningPath, PathCourse

@admin.register(Course)
class CourseAdmin(admin.ModelAdmin):
    list_display = ('title', 'provider', 'category', 'difficulty_level', 'price', 'rating')
    list_filter = ('category', 'difficulty_level', 'is_free', 'provider')

@admin.register(LearningPath)
class LearningPathAdmin(admin.ModelAdmin):
    list_display = ('title', 'target_role', 'difficulty', 'total_duration')
    list_filter = ('difficulty', 'target_role')

@admin.register(PathCourse)
class PathCourseAdmin(admin.ModelAdmin):
    list_display = ('learning_path', 'course', 'order', 'is_mandatory')
    list_filter = ('is_mandatory',)