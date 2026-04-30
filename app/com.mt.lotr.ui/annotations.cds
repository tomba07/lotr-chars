using LotrService as service from '../../srv/lotr-service';

annotate service.Characters with @(
    UI.PresentationVariant : {
        SortOrder      : [{ Property : fame, Descending : true }],
        Visualizations : ['@UI.LineItem']
    },

    UI.HeaderInfo : {
        TypeName       : 'Character',
        TypeNamePlural : 'Characters',
        Title          : { Value : name },
        Description    : { Value : description }
    },

    // ─── Field Groups ────────────────────────────────────────────────
    UI.FieldGroup #Identity : {
        $Type : 'UI.FieldGroupType',
        Data : [
            { $Type : 'UI.DataField', Value : name,       Label : 'Name'       },
            { $Type : 'UI.DataField', Value : race,       Label : 'Race'       },
            { $Type : 'UI.DataField', Value : realm,      Label : 'Realm'      },
            { $Type : 'UI.DataField', Value : status,     Label : 'Status'     },
            { $Type : 'UI.DataField', Value : allegiance, Label : 'Allegiance' },
            { $Type : 'UI.DataField', Value : fame,       Label : 'Fame'       },
        ],
    },

    UI.FieldGroup #Background : {
        $Type : 'UI.FieldGroupType',
        Data : [
            { $Type : 'UI.DataField', Value : description, Label : 'Description' },
        ],
    },

    UI.FieldGroup #Relations : {
        $Type : 'UI.FieldGroupType',
        Data : [
            { $Type : 'UI.DataField', Value : fellowship,  Label : 'Member of Fellowship' },
            { $Type : 'UI.DataField', Value : mentor_ID,   Label : 'Mentor'               },
            { $Type : 'UI.DataField', Value : ring_ID,     Label : 'Ring'                 },
        ],
    },

    // ─── Object Page Facets ──────────────────────────────────────────
    UI.Facets : [
        {
            $Type  : 'UI.CollectionFacet',
            ID     : 'Overview',
            Label  : 'Overview',
            Facets : [
                {
                    $Type  : 'UI.ReferenceFacet',
                    ID     : 'Identity',
                    Label  : 'Identity',
                    Target : '@UI.FieldGroup#Identity',
                },
                {
                    $Type  : 'UI.ReferenceFacet',
                    ID     : 'Background',
                    Label  : 'Background',
                    Target : '@UI.FieldGroup#Background',
                },
            ],
        },
        {
            $Type  : 'UI.ReferenceFacet',
            ID     : 'Relations',
            Label  : 'Relations',
            Target : '@UI.FieldGroup#Relations',
        },
        {
            $Type  : 'UI.ReferenceFacet',
            ID     : 'Weapons',
            Label  : 'Weapons',
            Target : 'weapons/@UI.LineItem',
        },
    ],

    // ─── List Report ─────────────────────────────────────────────────
    UI.LineItem : [
        { $Type : 'UI.DataField', Value : name,        Label : 'Name'        },
        { $Type : 'UI.DataField', Value : fame,        Label : 'Fame'        },
        { $Type : 'UI.DataField', Value : race,        Label : 'Race'        },
        { $Type : 'UI.DataField', Value : realm,       Label : 'Realm'       },
        { $Type : 'UI.DataField', Value : status,      Label : 'Status'      },
        { $Type : 'UI.DataField', Value : allegiance,  Label : 'Allegiance'  },
        { $Type : 'UI.DataField', Value : fellowship,  Label : 'Fellowship'  },
        { $Type : 'UI.DataField', Value : description, Label : 'Description' },
    ],
);

annotate service.Weapons with @(
    UI.LineItem : [
        { $Type : 'UI.DataField', Value : name,        Label : 'Name'        },
        { $Type : 'UI.DataField', Value : type,        Label : 'Type'        },
        { $Type : 'UI.DataField', Value : description, Label : 'Description' },
    ],
);
