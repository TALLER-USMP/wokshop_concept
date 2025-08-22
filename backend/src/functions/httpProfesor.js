const { app } = require('@azure/functions');
const { httpRequestsTotal } = require('./metrics');

app.http('httpProfesor', {
    methods: ['GET', 'POST'],
    authLevel: 'anonymous',
    handler: async (request, context) => {
        context.log(`Http function processed request for url "${request.url}"`);

        const name = request.query.get('name') || await request.text() || 'Profesor322';

        httpRequestsTotal.inc({
            method: request.method,
            route: '/api/httpProfesor',
            status: 200
        });

        return { body: `Hello, ${name}!` };
    }
});
