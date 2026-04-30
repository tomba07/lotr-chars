const cds = require('@sap/cds');

// When required by cds watch, export the server function.
// When run directly (node server.js), start the server.
if (require.main === module) {
  cds.server();
} else {
  module.exports = cds.server;
}
