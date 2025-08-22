const { app } = require("@azure/functions");
const { httpRequestsTotal } = require('./metrics');

app.http("httpSilabo", {
  methods: ["GET", "POST"],
  authLevel: "anonymous",
  handler: async (request, context) => {
    context.log(`Http function processed request for url "${request.url}"`);

    const name =
      request.query.get("name") || (await request.text()) || "SIlabo";

            httpRequestsTotal.inc({
            method: request.method,
            route: '/api/httpSilabo',
            status: 200
        });

    return { body: `Jesus ${name}!` };
  },
});
