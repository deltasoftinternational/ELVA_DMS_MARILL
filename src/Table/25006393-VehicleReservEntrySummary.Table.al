Table 25006393 "Vehicle Reserv. Entry Summary"
{
    Caption = 'Vehicle Reserv. Entry Summary';

    fields
    {
        field(5; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(10; Sequence; Integer)
        {
            Caption = 'Sequence';
        }
        field(20; "Source Type"; Integer)
        {
            Caption = 'Source Type';
        }
        field(30; Description; Text[80])
        {
            Caption = 'Summary Type';
        }
        field(40; "Source Subtype"; Option)
        {
            Caption = 'Source Subtype';
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
        }
        field(50; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Serial No.';
            Editable = false;
        }
        field(60; "Source ID"; Code[20])
        {
            Caption = 'Source ID';
        }
        field(70; "Source Batch Name"; Code[10])
        {
            Caption = 'Source Batch Name';
        }
        field(80; "Source Ref. No."; Integer)
        {
            Caption = 'Source Ref. No.';
        }
        field(90; Reserved; Boolean)
        {
            CalcFormula = exist("Vehicle Reservation Entry" where("Source Type" = field("Source Type"),
                                                                   "Source Subtype" = field("Source Subtype"),
                                                                   "Source ID" = field("Source ID"),
                                                                   "Source Batch Name" = field("Source Batch Name"),
                                                                   "Source Ref. No." = field("Source Ref. No.")));
            Caption = 'Reserved';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

