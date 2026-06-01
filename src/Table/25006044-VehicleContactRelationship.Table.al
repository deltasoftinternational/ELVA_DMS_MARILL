Table 25006044 "Vehicle-Contact Relationship"
{
    Caption = 'Vehicle-Contact Relationship';
    LookupPageID = "Vehicle-Contact Relationships";

    fields
    {
        field(10; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(20; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(30; "Do Not Use In Service"; Boolean)
        {
            Caption = 'Don''t Use In Service';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

