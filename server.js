const cds = require('@sap/cds');

cds.on('bootstrap', (app) => {
  app.get('/', (req, res) => res.redirect('/com.mt.lotr.ui/index.html'));
});

if (require.main === module) {
  cds.server();
} else {
  module.exports = cds.server;
}
