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
    UI.SelectionFields : [race, allegiance, fellowship],

    UI.PresentationVariant : {
        SortOrder      : [{ Property : fame, Descending : true }],
        Visualizations : ['@UI.LineItem']
    },

    UI.HeaderInfo : {
        TypeName       : 'Character',
        TypeNamePlural : 'Characters',
        Title          : { Value : name },
        Description    : { Value : description },
    },

    UI.Identification : [
        { $Type : 'UI.DataFieldForAction', Action : 'LotrService.changeAllegiance', Label : 'Change Allegiance' },
        { $Type : 'UI.DataFieldForAction', Action : 'LotrService.assignMentor',     Label : 'Assign Mentor'     },
    ],

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
            ID     : 'Address',
            Label  : 'Address',
            Target : 'address/@UI.FieldGroup#Address',
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

annotate service.Characters actions {
    changeAllegiance(allegiance @(
        Common.Label : 'New Allegiance',
        Common.ValueList : {
            CollectionPath : 'Allegiances',
            Parameters     : [
                { $Type : 'Common.ValueListParameterOut', LocalDataProperty : allegiance, ValueListProperty : 'code' },
            ],
        },
    ));
    assignMentor(mentorId @(
        Common.Label     : 'Mentor',
        Common.ValueList : {
            CollectionPath : 'Characters',
            Parameters     : [
                { $Type : 'Common.ValueListParameterOut',         LocalDataProperty : mentorId, ValueListProperty : 'ID'   },
                { $Type : 'Common.ValueListParameterDisplayOnly', ValueListProperty : 'name' },
                { $Type : 'Common.ValueListParameterDisplayOnly', ValueListProperty : 'race' },
            ],
        },
    ));
};

annotate service.Weapons with @(
    UI.HeaderInfo : {
        TypeName       : 'Weapon',
        TypeNamePlural : 'Weapons',
        Title          : { Value : name },
        Description    : { Value : type },
    },

    UI.FieldGroup #Details : {
        $Type : 'UI.FieldGroupType',
        Data : [
            { $Type : 'UI.DataField', Value : name,        Label : 'Name'        },
            { $Type : 'UI.DataField', Value : type,        Label : 'Type'        },
            { $Type : 'UI.DataField', Value : description, Label : 'Description' },
        ],
    },

    UI.Facets : [
        {
            $Type  : 'UI.ReferenceFacet',
            ID     : 'Details',
            Label  : 'Details',
            Target : '@UI.FieldGroup#Details',
        },
        {
            $Type  : 'UI.ReferenceFacet',
            ID     : 'Materials',
            Label  : 'Materials',
            Target : 'materials/@UI.LineItem',
        },
    ],

    UI.LineItem : [
        { $Type : 'UI.DataField', Value : name,        Label : 'Name'        },
        { $Type : 'UI.DataField', Value : type,        Label : 'Type'        },
        { $Type : 'UI.DataField', Value : description, Label : 'Description' },
    ],
);

annotate service.Materials with @(
    UI.LineItem : [
        { $Type : 'UI.DataField', Value : name,        Label : 'Material'    },
        { $Type : 'UI.DataField', Value : description, Label : 'Description' },
    ],
);

annotate service.Address with @(
    UI.FieldGroup #Address : {
        $Type : 'UI.FieldGroupType',
        Data : [
            { $Type : 'UI.DataField', Value : dwelling,   Label : 'Dwelling'   },
            { $Type : 'UI.DataField', Value : settlement, Label : 'Settlement' },
            { $Type : 'UI.DataField', Value : region,     Label : 'Region'     },
        ],
    },
);
