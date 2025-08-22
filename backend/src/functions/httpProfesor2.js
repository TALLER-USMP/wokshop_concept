const { app } = require('@azure/functions');
const { httpRequestsTotal } = require('./metrics');

app.http('httpProfesor2', {
    methods: ['GET', 'POST'],
    authLevel: 'anonymous',
    handler: async (request, context) => {
        context.log(`Http function processed request for url "${request.url}"`);

        const name = request.query.get('name') || await request.text() || 'Profesor322';

        httpRequestsTotal.inc({
            method: request.method,
            route: '/api/httpProfesor2',
            status: 200
        });

        return { body: `Hello, ${name}!` };
    }
});
