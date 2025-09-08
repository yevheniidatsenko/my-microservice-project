from django.contrib import admin
from .models import TestModel

@admin.register(TestModel)
class TestModelAdmin(admin.ModelAdmin):
    list_display = ['title', 'created_at']
    list_filter = ['created_at']
