Table 25006033 "Vehicle Insurance"
{
    Caption = 'Vehicle Insurance';
    LookupPageID = "Vehicle Insurance";

    fields
    {
        field(10; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
        }
        field(20; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(30; "Insurance Policy No."; Code[20])
        {
            Caption = 'Insurance Policy No.';
        }
        field(40; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(50; "Insurer No."; Code[20])
        {
            Caption = 'Insurer No.';
            TableRelation = Customer;
        }
        field(60; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
        }
        field(70; "Ending Date"; Date)
        {
            Caption = 'Ending Date';
        }
        field(80; Type; Code[20])
        {
            Caption = 'Type';
            TableRelation = "Vehicle Insurance Type";
        }
    }

    keys
    {
        key(Key1; "Vehicle Serial No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Ending Date")
        {
        }
    }

    fieldgroups
    {
    }
}

