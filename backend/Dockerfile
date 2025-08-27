# Usar la imagen oficial de Azure Functions para Node.js 20
FROM mcr.microsoft.com/azure-functions/node:4-node20

# Establecer directorio de trabajo
WORKDIR /home/site/wwwroot

# Copiar archivos de configuración
COPY package*.json ./
COPY host.json ./
COPY local.settings.docker.json ./local.settings.json

# Instalar Azure Functions Core Tools y dependencias
RUN npm install -g azure-functions-core-tools@4 --unsafe-perm true
RUN npm ci --only=production

# Copiar código fuente
COPY src/ ./src/

# Crear directorio para logs si no existe
RUN mkdir -p /tmp/LogFiles

# Exponer puerto 7071 (puerto por defecto de Azure Functions)
EXPOSE 7071

# Variables de entorno para Azure Functions
ENV AzureWebJobsScriptRoot=/home/site/wwwroot \
    AzureFunctionsJobHost__Logging__Console__IsEnabled=true \
    FUNCTIONS_WORKER_RUNTIME=node

# Comando para iniciar Azure Functions
CMD ["func", "start", "--host", "0.0.0.0", "--port", "7071"]
