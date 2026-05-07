const cds = require('@sap/cds');

module.exports = class LotrService extends cds.ApplicationService {

  async init() {
    const { Characters, Weapons } = this.entities;

    // Validate race on create/update
    this.before(['CREATE', 'UPDATE'], Characters, (req) => {
      const allowed = ['Hobbit', 'Elf', 'Dwarf', 'Man', 'Wizard', 'Orc', 'Ent', 'Wraith', 'Maiar'];
      if (req.data.race && !allowed.includes(req.data.race)) {
        req.warn(400, `Unknown race "${req.data.race}". Known races: ${allowed.join(', ')}`);
      }
    });

    this.after('READ', Characters, results => {
      const rows = Array.isArray(results) ? results : [results];
      for (const row of rows) {
        row.statusCriticality   = row.status === 'Alive' ? 3 : row.status === 'Dead' ? 1 : 2;
        row.strengthCriticality = row.strength >= 60 ? 3 : row.strength >= 40 ? 2 : 1;
        row.fameRating          = Math.round(row.fame / 20);
      }
    });

    await super.init();
  }
};
