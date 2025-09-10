import logging
from django.shortcuts import render
from django.http import JsonResponse
from .models import TestModel

logger = logging.getLogger(__name__)

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
        logger.error('Health check error', exc_info=True)
        return JsonResponse({
            'status': 'error',
            'database': 'disconnected',
            'error': str(e)
        }, status=500)