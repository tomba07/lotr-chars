using lotr from '../db/schema';

service LotrService @(path: '/lotr') {

  @cds.redirection.target
  entity Characters as projection on lotr.Characters {
    *,
    mentor : redirected to Characters,
    ring   : redirected to Rings,
  };

  entity Weapons as projection on lotr.Weapons;

  entity Rings as projection on lotr.Rings;

  // Convenience read-only view: Fellowship members only
  @readonly
  view FellowshipMembers as
    select from lotr.Characters where fellowship = true;
}
