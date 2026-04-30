using lotr from '../db/schema';

service LotrService @(path: '/lotr') {

  @cds.redirection.target
  entity Characters as projection on lotr.Characters {
    *,
    weapons
  };

  entity Weapons as projection on lotr.Weapons;

  // Convenience read-only view: Fellowship members only
  @readonly
  view FellowshipMembers as
    select from lotr.Characters where fellowship = true;
}
