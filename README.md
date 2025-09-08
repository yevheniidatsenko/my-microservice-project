# Django + Docker Project

Docker homework assignment

## Quick Start

```bash
# 1. Run the project
docker-compose up -d

# 2. Check if it works
# Homepage: http://localhost
# Health check: http://localhost/health
# Admin panel: http://localhost/admin
```

## Architecture

- **Django**: Web application
- **PostgreSQL**: Database
- **Nginx**: Reverse proxy
- **Docker**: Containerization

## Services

- `web` - Django on port 8000
- `db` - PostgreSQL on port 5432
- `nginx` - Nginx on port 80

## Useful Commands

```bash
# Stop containers
docker-compose down

# View logs
docker-compose logs -f

# Run migrations
docker-compose exec web python manage.py migrate

# Create superuser
docker-compose exec web python manage.py createsuperuser
```
