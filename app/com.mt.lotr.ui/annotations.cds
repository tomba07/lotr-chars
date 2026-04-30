using LotrService as service from '../../srv/lotr-service';
annotate service.Characters with @(
    UI.FieldGroup #GeneratedGroup : {
        $Type : 'UI.FieldGroupType',
        Data : [
            {
                $Type : 'UI.DataField',
                Label : 'name',
                Value : name,
            },
            {
                $Type : 'UI.DataField',
                Label : 'race',
                Value : race,
            },
            {
                $Type : 'UI.DataField',
                Label : 'realm',
                Value : realm,
            },
            {
                $Type : 'UI.DataField',
                Label : 'fellowship',
                Value : fellowship,
            },
            {
                $Type : 'UI.DataField',
                Label : 'description',
                Value : description,
            },
        ],
    },
    UI.Facets : [
        {
            $Type : 'UI.ReferenceFacet',
            ID : 'GeneratedFacet1',
            Label : 'General Information',
            Target : '@UI.FieldGroup#GeneratedGroup',
        },
    ],
    UI.LineItem : [
        {
            $Type : 'UI.DataField',
            Label : 'name',
            Value : name,
        },
        {
            $Type : 'UI.DataField',
            Label : 'race',
            Value : race,
        },
        {
            $Type : 'UI.DataField',
            Label : 'realm',
            Value : realm,
        },
        {
            $Type : 'UI.DataField',
            Label : 'fellowship',
            Value : fellowship,
        },
        {
            $Type : 'UI.DataField',
            Label : 'description',
            Value : description,
        },
    ],
);

