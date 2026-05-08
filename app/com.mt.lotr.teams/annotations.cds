using LotrService as service from '../../srv/lotr-service';

annotate service.Teams with @(
    UI.HeaderInfo : {
        TypeName       : 'Team',
        TypeNamePlural : 'Teams',
        Title          : { Value : name },
        Description    : { Value : description },
    },

    UI.Identification : [
        { $Type : 'UI.DataFieldForAction', Action : 'LotrService.recruitCharacter', Label : 'Recruit Character' },
        { $Type : 'UI.DataFieldForAction', Action : 'LotrService.disbandTeam',      Label : 'Disband Team'      },
    ],

    UI.HeaderFacets : [
        { $Type : 'UI.ReferenceFacet', Target : '@UI.DataPoint#TotalStrength' },
        { $Type : 'UI.ReferenceFacet', Target : '@UI.DataPoint#MonthlyCost'   },
        { $Type : 'UI.ReferenceFacet', Target : '@UI.DataPoint#Cohesion'      },
    ],

    UI.DataPoint #TotalStrength : {
        Value : totalStrength,
        Title : 'Total Strength',
    },

    UI.DataPoint #MonthlyCost : {
        Value : monthlyCost,
        Title : 'Monthly Cost (gold)',
    },

    UI.DataPoint #Cohesion : {
        Value       : cohesion,
        Title       : 'Cohesion (%)',
        Criticality : cohesionCriticality,
    },

    UI.LineItem : [
        { $Type : 'UI.DataField', Value : name,          Label : 'Team'            },
        { $Type : 'UI.DataField', Value : description,   Label : 'Description'     },
        { $Type : 'UI.DataField', Value : totalStrength, Label : 'Total Strength'  },
        { $Type : 'UI.DataField', Value : monthlyCost,   Label : 'Monthly Cost'    },
        { $Type : 'UI.DataField', Value : cohesion,      Label : 'Cohesion (%)'    },
    ],

    UI.FieldGroup #Info : {
        $Type : 'UI.FieldGroupType',
        Data : [
            { $Type : 'UI.DataField', Value : name,        Label : 'Team'        },
            { $Type : 'UI.DataField', Value : description, Label : 'Description' },
        ],
    },

    UI.FieldGroup #Stats : {
        $Type : 'UI.FieldGroupType',
        Data : [
            { $Type : 'UI.DataField', Value : totalStrength, Label : 'Total Strength'  },
            { $Type : 'UI.DataField', Value : monthlyCost,   Label : 'Monthly Cost (gold)' },
            { $Type : 'UI.DataField', Value : cohesion,      Label : 'Cohesion (%)'    },
        ],
    },

    UI.Facets : [
        {
            $Type  : 'UI.CollectionFacet',
            ID     : 'Overview',
            Label  : 'Overview',
            Facets : [
                { $Type : 'UI.ReferenceFacet', ID : 'Info',  Label : 'Info',       Target : '@UI.FieldGroup#Info'  },
                { $Type : 'UI.ReferenceFacet', ID : 'Stats', Label : 'Statistics', Target : '@UI.FieldGroup#Stats' },
            ],
        },
        {
            $Type  : 'UI.ReferenceFacet',
            ID     : 'Members',
            Label  : 'Members',
            Target : 'members/@UI.LineItem',
        },
    ],
);

annotate service.Teams actions {
    recruitCharacter(
        characterId @(
            Common.Label : 'Character',
            Common.ValueList : {
                CollectionPath : 'Characters',
                Parameters     : [
                    { $Type : 'Common.ValueListParameterOut',         LocalDataProperty : characterId, ValueListProperty : 'ID'   },
                    { $Type : 'Common.ValueListParameterDisplayOnly', ValueListProperty : 'name' },
                    { $Type : 'Common.ValueListParameterDisplayOnly', ValueListProperty : 'race' },
                ],
            },
        ),
        role @Common.Label : 'Role'
    );
};

annotate service.TeamMembers actions {
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
        Common.Label : 'Mentor',
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

annotate service.TeamMembers with {
    character @(
        Common.Text            : character.name,
        Common.TextArrangement : #TextOnly,
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
    UI.HeaderInfo : {
        TypeName       : 'Member',
        TypeNamePlural : 'Members',
        Title          : { Value : character.name },
        Description    : { Value : role },
    },

    UI.Identification : [
        { $Type : 'UI.DataFieldForAction', Action : 'LotrService.changeAllegiance', Label : 'Change Allegiance' },
        { $Type : 'UI.DataFieldForAction', Action : 'LotrService.assignMentor',     Label : 'Assign Mentor'     },
    ],

    UI.HeaderFacets : [
        { $Type : 'UI.ReferenceFacet', Target : '@UI.DataPoint#CharFame'   },
        { $Type : 'UI.ReferenceFacet', Target : '@UI.Chart#CharStrength'   },
        { $Type : 'UI.ReferenceFacet', Target : '@UI.DataPoint#CharStatus' },
    ],

    UI.DataPoint #CharFame : {
        Value        : character.fameRating,
        Title        : 'Fame',
        MaximumValue : character.fameMax,
        Visualization: #Rating,
    },

    UI.DataPoint #CharStrength : {
        Value        : character.strength,
        Title        : 'Strength',
        MinimumValue : 0,
        MaximumValue : character.strengthMax,
        Criticality  : character.strengthCriticality,
    },

    UI.Chart #CharStrength : {
        ChartType         : #Pie,
        Title             : 'Strength',
        Measures          : [character.strength],
        MeasureAttributes : [{
            $Type     : 'UI.ChartMeasureAttributeType',
            Measure   : character.strength,
            Role      : #Axis1,
            DataPoint : '@UI.DataPoint#CharStrength',
        }],
    },

    UI.DataPoint #CharStatus : {
        Value       : character.status,
        Title       : 'Status',
        Criticality : character.statusCriticality,
    },

    UI.LineItem : [
        { $Type : 'UI.DataField', Value : character_ID, Label : 'Character' },
        { $Type : 'UI.DataField', Value : role,         Label : 'Role'      },
    ],

    UI.FieldGroup #MemberInfo : {
        $Type : 'UI.FieldGroupType',
        Data : [
            { $Type : 'UI.DataField', Value : role, Label : 'Role' },
        ],
    },

    UI.FieldGroup #CharacterInfo : {
        $Type : 'UI.FieldGroupType',
        Data : [
            { $Type : 'UI.DataField', Value : character.name,        Label : 'Name'        },
            { $Type : 'UI.DataField', Value : character.race,        Label : 'Race'        },
            { $Type : 'UI.DataField', Value : character.realm,       Label : 'Realm'       },
            { $Type : 'UI.DataField', Value : character.allegiance,  Label : 'Allegiance'  },
            { $Type : 'UI.DataField', Value : character.status,      Label : 'Status'      },
            { $Type : 'UI.DataField', Value : character.strength,    Label : 'Strength'    },
            { $Type : 'UI.DataField', Value : character.fame,        Label : 'Fame'        },
            { $Type : 'UI.DataField', Value : character.description, Label : 'Description' },
        ],
    },

    UI.Facets : [
        { $Type : 'UI.ReferenceFacet', ID : 'MemberInfo',    Label : 'Membership',        Target : '@UI.FieldGroup#MemberInfo'    },
        { $Type : 'UI.ReferenceFacet', ID : 'CharacterInfo', Label : 'Character Profile', Target : '@UI.FieldGroup#CharacterInfo' },
    ],
);
