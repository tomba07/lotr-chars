using LotrService as service from '../../srv/lotr-service';
annotate service.Characters with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            { $Type : 'UI.DataField', Value : name },
            { $Type : 'UI.DataField', Value : race },
            { $Type : 'UI.DataField', Value : realm },
            { $Type : 'UI.DataField', Value : fellowship },
            { $Type : 'UI.DataField', Value : description },
        ],
    },
    UI.Facets : [
        {
            $Type  : 'UI.ReferenceFacet',
            ID     : 'GeneratedFacet1',
            Label  : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
    ],
    UI.LineItem : [
        { $Type : 'UI.DataField', Value : name,       Label: 'Name'        },
        { $Type : 'UI.DataField', Value : race,       Label: 'Race'        },
        { $Type : 'UI.DataField', Value : realm,      Label: 'Realm'       },
        { $Type : 'UI.DataField', Value : fellowship, Label: 'Fellowship'  },
        { $Type : 'UI.DataField', Value : description,Label: 'Description' },
    ],
);

