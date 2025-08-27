# Docker Setup - Sílabos USMP

Este documento describe cómo ejecutar la aplicación usando Docker y Docker Compose.

## Prerrequisitos

- Docker Desktop instalado
- Docker Compose (incluido en Docker Desktop)

## Servicios Incluidos

- **Frontend**: React + Vite servido con Nginx (Puerto 80)
- **Backend**: Azure Functions con Node.js (Puerto 7071)
- **Prometheus**: Monitoreo de métricas (Puerto 9090)
- **Grafana**: Dashboard de visualización (Puerto 3000)

## Comandos Básicos

### En archivos Makefile

## Acceso a los Servicios

- **Frontend**: http://localhost
- **Backend API**: http://localhost:7071/api
- **Prometheus**: http://localhost:9090
- **Grafana**: http://localhost:3000 (admin/admin)

## Estructura de Archivos Docker

```
├── docker-compose.yml          # Orquestación de servicios
├── frontend/
│   ├── Dockerfile             # Imagen del frontend
│   ├── nginx.conf             # Configuración de Nginx
│   └── .dockerignore          # Archivos excluidos
├── backend/
│   ├── Dockerfile             # Imagen del backend
│   └── .dockerignore          # Archivos excluidos
└── prometheus/
    └── prometheus.yml         # Configuración de Prometheus
```

## Troubleshooting

### Problemas de red
```bash
docker network ls
docker network inspect wokshop_concept_app-network
```

### Ver estado de contenedores
```bash
docker-compose ps
```
