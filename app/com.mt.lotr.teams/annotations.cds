using LotrService as service from '../../srv/lotr-service';

annotate service.Teams with @(
    UI.HeaderInfo : {
        TypeName       : 'Team',
        TypeNamePlural : 'Teams',
        Title          : { Value : name },
        Description    : { Value : description },
    },

    UI.LineItem : [
        { $Type : 'UI.DataField', Value : name,        Label : 'Team'        },
        { $Type : 'UI.DataField', Value : description, Label : 'Description' },
    ],

    UI.FieldGroup #Info : {
        $Type : 'UI.FieldGroupType',
        Data : [
            { $Type : 'UI.DataField', Value : name,        Label : 'Team'        },
            { $Type : 'UI.DataField', Value : description, Label : 'Description' },
        ],
    },

    UI.Facets : [
        {
            $Type  : 'UI.ReferenceFacet',
            ID     : 'Info',
            Label  : 'Info',
            Target : '@UI.FieldGroup#Info',
        },
        {
            $Type  : 'UI.ReferenceFacet',
            ID     : 'Members',
            Label  : 'Members',
            Target : 'members/@UI.LineItem',
        },
    ],
);

annotate service.TeamMembers with {
    character @(
        Common.Text             : character.name,
        Common.TextArrangement  : #TextOnly,
        Common.ValueList : {
            CollectionPath : 'Characters',
            Parameters     : [
                { $Type : 'Common.ValueListParameterOut',         LocalDataProperty : character_ID, ValueListProperty : 'ID'   },
                { $Type : 'Common.ValueListParameterDisplayOnly', ValueListProperty : 'name' },
                { $Type : 'Common.ValueListParameterDisplayOnly', ValueListProperty : 'race' },
            ],
        },
    );
};

annotate service.TeamMembers with @(
    UI.LineItem : [
        { $Type : 'UI.DataField', Value : character_ID, Label : 'Character' },
        { $Type : 'UI.DataField', Value : role,         Label : 'Role'      },
    ],
);
