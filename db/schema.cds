namespace lotr;

entity Characters {
  key ID        : UUID;
  name          : String(100) not null  @title: 'Name';
  race          : String(50)            @title: 'Race';
  realm         : String(100)           @title: 'Realm';
  fellowship    : Boolean default false @title: 'Fellowship';
  description   : String(500)           @title: 'Description';
  weapons       : Composition of many Weapons on weapons.character = $self;
}

entity Weapons {
  key ID        : UUID;
  name          : String(100) not null  @title: 'Name';
  type          : String(50)            @title: 'Type';
  description   : String(300)           @title: 'Description';
  character     : Association to Characters;
}
