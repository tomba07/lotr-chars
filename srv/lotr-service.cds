using lotr from '../db/schema';

service LotrService @(path: '/lotr') {

  @cds.redirection.target
  entity Characters as projection on lotr.Characters {
    *,
    mentor : redirected to Characters,
    ring   : redirected to Rings,
    case when status   = 'Alive' then 3 when status   = 'Dead' then 1 else 2 end as statusCriticality   : Integer,
    case when strength >= 60     then 3 when strength >= 40    then 2 else 1 end as strengthCriticality : Integer,
    cast(fame as Double) / 20 as fameRating : Decimal,
    5   as fameMax    : Integer,
    100 as strengthMax: Integer,
  };

  entity Weapons as projection on lotr.Weapons {
    *, character : redirected to Characters
  };

  entity Materials as projection on lotr.Materials;

  entity Rings as projection on lotr.Rings;

  @readonly entity Races       as projection on lotr.Races;
  @readonly entity Allegiances as projection on lotr.Allegiances;
  entity Address               as projection on lotr.Address;

  @odata.draft.enabled
  entity Teams as projection on lotr.Teams {
    *,
    virtual null as totalStrength       : Integer,
    virtual null as monthlyCost         : Integer,
    virtual null as cohesion            : Integer,
    virtual null as cohesionCriticality : Integer,
  };

  entity TeamMembers as projection on lotr.TeamMembers {
    *, character : redirected to Characters
  };

  // Convenience read-only view: Fellowship members only
  @readonly
  view FellowshipMembers as
    select from lotr.Characters where fellowship = true;
}
