const cds = require('@sap/cds');
const path = require('path');

cds.on('bootstrap', (app) => {
  app.use('/com.mt.lotr.ui', require('express').static(path.join(__dirname, 'app/com.mt.lotr.ui/webapp')));
  app.get('/', (req, res) => res.redirect('/com.mt.lotr.ui/index.html'));
});

if (require.main === module) {
  cds.server({ in_memory: true });
} else {
  module.exports = cds.server;
}
