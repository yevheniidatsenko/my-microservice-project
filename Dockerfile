FROM python:3.11-slim

# Встановлюємо робочу директорію
WORKDIR /app

# Встановлюємо системні залежності
RUN apt-get update \
    && apt-get install -y --no-install-recommends \
        postgresql-client \
    && rm -rf /var/lib/apt/lists/*

# Копіюємо requirements та встановлюємо Python залежності
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

# Копіюємо код проєкту
COPY . .

# Збираємо статичні файли
RUN python manage.py collectstatic --noinput

# Створюємо непривілейованого користувача
RUN adduser --disabled-password --gecos '' appuser \
    && chown -R appuser:appuser /app
USER appuser

# Відкриваємо порт
EXPOSE 8000

# Команда для запуску
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "myproject.wsgi:application"]