const cds = require('@sap/cds');

module.exports = class LotrService extends cds.ApplicationService {

  async init() {
    const { Characters, Teams, TeamMembers } = this.entities;

    // Validate race on create/update
    this.before(['CREATE', 'UPDATE'], Characters, (req) => {
      const allowed = ['Hobbit', 'Elf', 'Dwarf', 'Man', 'Wizard', 'Orc', 'Ent', 'Wraith', 'Maiar'];
      if (req.data.race && !allowed.includes(req.data.race)) {
        req.warn(400, `Unknown race "${req.data.race}". Known races: ${allowed.join(', ')}`);
      }
    });

    // ── Character actions ────────────────────────────────────────────────

    this.on('changeAllegiance', Characters, async (req) => {
      const key = req.params[0];
      const ID  = key?.ID ?? key;
      const { allegiance } = req.data;
      if (!allegiance) return req.error(400, 'Allegiance is required');
      await cds.db.run(UPDATE('lotr.Characters', ID).set({ allegiance }));
      return SELECT.one(Characters, ID);
    });

    this.on('assignMentor', Characters, async (req) => {
      const key = req.params[0];
      const ID  = key?.ID ?? key;
      const { mentorId } = req.data;
      if (mentorId === ID) return req.error(400, 'A character cannot mentor themselves');
      await cds.db.run(UPDATE('lotr.Characters', ID).set({ mentor_ID: mentorId }));
      return SELECT.one(Characters, ID);
    });

    // ── Team actions ─────────────────────────────────────────────────────

    const charIDofMember = async (memberKey) => {
      const memberID = memberKey?.ID ?? memberKey;
      const m = await SELECT.one.from('lotr.TeamMembers', ['character_ID']).where({ ID: memberID });
      return m?.character_ID;
    };

    this.on('changeAllegiance', TeamMembers, async (req) => {
      const charID     = await charIDofMember(req.params[0]);
      const { allegiance } = req.data;
      if (!allegiance) return req.error(400, 'Allegiance is required');
      await cds.db.run(UPDATE('lotr.Characters', charID).set({ allegiance }));
    });

    this.on('assignMentor', TeamMembers, async (req) => {
      const charID     = await charIDofMember(req.params[0]);
      const { mentorId } = req.data;
      if (mentorId === charID) return req.error(400, 'A character cannot mentor themselves');
      await cds.db.run(UPDATE('lotr.Characters', charID).set({ mentor_ID: mentorId }));
    });

    this.on('disbandTeam', Teams, async (req) => {
      const { ID } = req.params[0];
      await DELETE.from(TeamMembers).where({ team_ID: ID });
    });

    this.on('recruitCharacter', Teams, async (req) => {
      const { ID } = req.params[0];
      const { characterId, role } = req.data;
      await INSERT.into(TeamMembers).entries({
        ID: cds.utils.uuid(), team_ID: ID, character_ID: characterId, role: role || 'Member',
      });
    });

    // ── Compute aggregated team stats ────────────────────────────────────
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
