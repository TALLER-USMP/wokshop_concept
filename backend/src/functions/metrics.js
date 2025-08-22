const { app } = require('@azure/functions');
const client = require('prom-client');

const register = client.register;

const httpRequestsTotal = new client.Counter({
  name: 'http_requests_total',
  help: 'Total de requests HTTP recibidas',
  labelNames: ['method', 'route', 'status'],
});

app.http('metrics', {
  methods: ['GET'],
  authLevel: 'anonymous',
  route: 'metrics',
  handler: async (request, context) => {
    context.log('Serving Prometheus metrics');
    return {
      status: 200,
      headers: {
        'Content-Type': register.contentType,
        'Access-Control-Allow-Origin': '*',
      },
      body: await register.metrics(),
    };
  },
});

// Exporta el contador para que otros archivos puedan usarlo
module.exports = {
  httpRequestsTotal
};