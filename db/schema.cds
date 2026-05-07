namespace lotr;

type Race      : String enum { Hobbit; Elf; Dwarf; Man; Wizard; Orc; Ent; Wraith; Maiar; };
type Allegiance: String enum { Good; Evil; Neutral; };

entity Characters {
  key ID        : UUID;
  name          : String(100) not null  @title: 'Name';
  race          : Race                  @title: 'Race';
  realm         : String(100)           @title: 'Realm';
  fellowship    : Boolean default false @title: 'Fellowship';
  fame          : Integer               @title: 'Fame';
  strength      : Integer               @title: 'Strength';
  status        : String(20)            @title: 'Status';
  allegiance    : Allegiance            @title: 'Allegiance';
  description   : String(500)           @title: 'Description';
  mentor        : Association to Characters;
  ring          : Association to Rings;
  weapons       : Composition of many Weapons on weapons.character = $self;
  address       : Composition of one Address on address.up_ = $self;
}

annotate Characters with {
  mentor @(
    Common.Text: mentor.name,
    Common.TextArrangement: #TextOnly
  );
  ring @(
    Common.Text: ring.name,
    Common.TextArrangement: #TextOnly
  );
}

entity Weapons {
  key ID        : UUID;
  name          : String(100) not null  @title: 'Name';
  type          : String(50)            @title: 'Type';
  description   : String(300)           @title: 'Description';
  character     : Association to Characters;
  materials     : Composition of many Materials on materials.weapon = $self;
}

entity Materials {
  key ID          : UUID;
  name            : String(100) not null @title: 'Material';
  description     : String(200)          @title: 'Description';
  weapon          : Association to Weapons;
}

entity Rings {
  key ID          : UUID;
  name            : String(100) not null  @title: 'Name';
  description     : String(300)           @title: 'Description';
}

entity Address {
  key up_        : Association to one Characters;
  dwelling       : String(100)  @title: 'Dwelling';
  settlement     : String(100)  @title: 'Settlement';
  region         : String(100)  @title: 'Region';
}

entity Races       { key code : Race;       }
entity Allegiances { key code : Allegiance; }
