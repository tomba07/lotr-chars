using LotrService as service from '../../srv/lotr-service';

annotate service.Characters with @(
    UI.LineItem #fellowship : [
        { $Type : 'UI.DataField', Value : name,       Label : 'Name'       },
        { $Type : 'UI.DataField', Value : race,       Label : 'Race'       },
        { $Type : 'UI.DataField', Value : allegiance, Label : 'Allegiance' },
        { $Type : 'UI.DataField', Value : status,     Label : 'Status'     },
        { $Type : 'UI.DataField', Value : fellowship, Label : 'Fellowship' },
        { $Type : 'UI.DataField', Value : ring_ID,    Label : 'Ring'       },
    ],
);
