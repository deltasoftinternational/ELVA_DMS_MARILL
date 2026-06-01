Table 25006774 "Integration Connector Mapping"
{
    // #Owner EDMS.Integration

    Caption = 'Integration Connector Setup';
    LookupPageID = "Integration Connector Mapping";

    fields
    {
        field(10; "Connector Code"; Code[10])
        {
            Caption = 'Connector Code';
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = "Integration Connector EDMS";
        }
        field(20; Type; Option)
        {
            DataClassification = ToBeClassified;
            NotBlank = true;
            OptionCaption = ' ,Location,Vendor,Customer,Ordering Price Type,Shipment Method,Transport Method,UoM,Payment Terms';
            OptionMembers = " ",Location,Vendor,Customer,"Ordering Price Type","Shipment Method","Transport Method",UoM,"Payment Terms";
        }
        field(30; "Code"; Code[20])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = if (Type = const(Location)) Location.Code
            else
            if (Type = filter(Vendor)) Vendor."No."
            else
            if (Type = const(Customer)) Customer."No."
            else
            if (Type = const("Shipment Method")) "Shipment Method".Code
            else
            if (Type = const("Transport Method")) "Transport Method".Code
            else
            if (Type = const("Ordering Price Type")) "Ordering Price Type".Code
            else
            if (Type = const(UoM)) "Unit of Measure".Code
            else
            if (Type = const("Payment Terms")) "Payment Terms".Code;
        }
        field(100; "External Code"; Code[20])
        {
            Caption = 'External Code';
            DataClassification = ToBeClassified;
        }
        field(200; Default; Boolean)
        {
            Caption = 'Default';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Connector Code", Type, "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        IntegrationMethod: Record "Integration Method EDMS";
}

