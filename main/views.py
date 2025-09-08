from django.shortcuts import render
from django.http import JsonResponse
from .models import TestModel

def home(request):
    """Головна сторінка"""
    test_objects = TestModel.objects.all()[:5]
    context = {
        'title': 'Django + PostgreSQL + Nginx в Docker',
        'objects': test_objects,
    }
    return render(request, 'main/home.html', context)

def health_check(request):
    """Перевірка працездатності"""
    try:
        # Перевіряємо підключення до бази даних
        count = TestModel.objects.count()
        return JsonResponse({
            'status': 'ok',
            'database': 'connected',
            'objects_count': count
        })
    except Exception as e:
        return JsonResponse({
            'status': 'error',
            'database': 'disconnected',
            'error': str(e)
        }, status=500)
