using LotrService as service from '../../srv/lotr-service';

annotate service.Characters with {
  race @(
    Common.ValueListWithFixedValues: true,
    Common.ValueList: {
      CollectionPath: 'Races',
      Parameters: [{ $Type: 'Common.ValueListParameterOut', LocalDataProperty: race, ValueListProperty: 'code' }]
    }
  );
  allegiance @(
    Common.ValueListWithFixedValues: true,
    Common.ValueList: {
      CollectionPath: 'Allegiances',
      Parameters: [{ $Type: 'Common.ValueListParameterOut', LocalDataProperty: allegiance, ValueListProperty: 'code' }]
    }
  );
};

annotate service.Characters with @(
    UI.SelectionFields : [race, allegiance],

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

    // ─── Header Facets ───────────────────────────────────────────────
    UI.HeaderFacets : [
        { $Type : 'UI.ReferenceFacet', Target : '@UI.DataPoint#Fame'     },
        { $Type : 'UI.ReferenceFacet', Target : '@UI.Chart#Strength'     },
        { $Type : 'UI.ReferenceFacet', Target : '@UI.DataPoint#Status'   },
    ],

    UI.DataPoint #Fame : {
        Value        : fameRating,
        Title        : 'Fame',
        MaximumValue : fameMax,
        Visualization: #Rating,
    },
    UI.DataPoint #Strength : {
        Value        : strength,
        Title        : 'Strength',
        MinimumValue : 0,
        MaximumValue : strengthMax,
        Criticality  : strengthCriticality,
    },

    UI.Chart #Strength : {
        ChartType         : #Pie,
        Title             : 'Strength',
        Measures          : [strength],
        MeasureAttributes : [{
            $Type     : 'UI.ChartMeasureAttributeType',
            Measure   : strength,
            Role      : #Axis1,
            DataPoint : '@UI.DataPoint#Strength',
        }],
    },


    UI.DataPoint #Status : {
        Value       : status,
        Title       : 'Status',
        Criticality : statusCriticality,
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
            { $Type : 'UI.DataField', Value : strength,   Label : 'Strength'   },
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
            { $Type : 'UI.DataField',                   Value  : fellowship,  Label : 'Member of Fellowship' },
            { $Type : 'UI.DataFieldWithNavigationPath', Value  : mentor_ID,   Label : 'Mentor', Target : 'mentor' },
            { $Type : 'UI.DataField',                   Value  : ring_ID,     Label : 'Ring'                 },
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
        { $Type : 'UI.DataFieldForAnnotation', Target : '@UI.DataPoint#Fame', Label : 'Fame' },
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
