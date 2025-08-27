# Scripts para desarrollo con Docker

# Construir todas las imágenes
build:
	docker-compose build

# Levantar todos los servicios
up:
	docker-compose up -d

# Ver logs de todos los servicios
logs:
	docker-compose logs -f

# Ver logs solo del backend
logs-backend:
	docker-compose logs -f backend

# Ver logs solo del frontend
logs-frontend:
	docker-compose logs -f frontend

# Detener todos los servicios
down:
	docker-compose down

# Detener y eliminar volúmenes
down-clean:
	docker-compose down -v

# Rebuild y restart
restart:
	docker-compose down
	docker-compose build
	docker-compose up -d

# Acceso a shell del backend
shell-backend:
	docker-compose exec backend /bin/bash

# Acceso a shell del frontend
shell-frontend:
	docker-compose exec frontend /bin/sh

# Limpiar imágenes no utilizadas
clean:
	docker system prune -f
	docker image prune -f

.PHONY: build up logs logs-backend logs-frontend down down-clean restart shell-backend shell-frontend clean
