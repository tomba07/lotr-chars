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

    await super.init();
  }
};
