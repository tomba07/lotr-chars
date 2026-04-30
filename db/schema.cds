namespace lotr;

entity Characters {
  key ID        : UUID;
  name          : String(100) not null;
  race          : String(50);
  realm         : String(100);
  fellowship    : Boolean default false;
  description   : String(500);
  weapons       : Composition of many Weapons on weapons.character = $self;
}

entity Weapons {
  key ID        : UUID;
  name          : String(100) not null;
  type          : String(50);
  description   : String(300);
  character     : Association to Characters;
}
