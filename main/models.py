from django.db import models

class TestModel(models.Model):
    title = models.CharField(max_length=200, verbose_name='Назва')
    description = models.TextField(blank=True, verbose_name='Опис')
    created_at = models.DateTimeField(auto_now_add=True, verbose_name='Створено')

    class Meta:
        verbose_name = 'Тестова модель'
        verbose_name_plural = 'Тестові моделі'
        ordering = ['-created_at']

    def __str__(self):
        return self.title
