const cds = require('@sap/cds');

module.exports = class LotrService extends cds.ApplicationService {

  async init() {
    const { Characters, Teams } = this.entities;

    // Validate race on create/update
    this.before(['CREATE', 'UPDATE'], Characters, (req) => {
      const allowed = ['Hobbit', 'Elf', 'Dwarf', 'Man', 'Wizard', 'Orc', 'Ent', 'Wraith', 'Maiar'];
      if (req.data.race && !allowed.includes(req.data.race)) {
        req.warn(400, `Unknown race "${req.data.race}". Known races: ${allowed.join(', ')}`);
      }
    });

    // Compute aggregated team stats
    this.after('READ', Teams, async (results) => {
      const rows = Array.isArray(results) ? results : [results];
      const ids  = rows.map(r => r.ID).filter(Boolean);
      if (!ids.length) return;

      const members = await SELECT.from('lotr.TeamMembers', ['team_ID', 'character_ID'])
        .where({ team_ID: { in: ids } });

      const charIds = [...new Set(members.map(m => m.character_ID))];
      const chars = charIds.length
        ? await SELECT.from('lotr.Characters', ['ID', 'strength', 'fame', 'allegiance'])
            .where({ ID: { in: charIds } })
        : [];

      const charMap = Object.fromEntries(chars.map(c => [c.ID, c]));
      const byTeam  = {};
      for (const m of members) {
        (byTeam[m.team_ID] ??= []).push(charMap[m.character_ID] || {});
      }

      for (const row of rows) {
        const mems = byTeam[row.ID] || [];
        row.totalStrength = mems.reduce((s, c) => s + (c.strength || 0), 0);
        row.monthlyCost   = mems.reduce((s, c) => s + (c.fame    || 0) * 50, 0);
        const allegiances = new Set(mems.map(c => c.allegiance).filter(Boolean));
        row.cohesion = allegiances.size <= 1 ? 100 : allegiances.size === 2 ? 60 : 20;
        row.cohesionCriticality = row.cohesion === 100 ? 3 : row.cohesion === 60 ? 2 : 1;
      }
    });

    await super.init();
  }
};
