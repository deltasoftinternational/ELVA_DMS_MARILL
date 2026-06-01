Table 25006280 "Serv. Schedule Cell Config."
{
    Caption = 'Serv. Schedule Cell Config.';
    LookupPageID = "Schedule Cell Config.";

    fields
    {
        field(10; "Source Type"; Integer)
        {
            Caption = 'Source Type';

            trigger OnLookup()
            begin
                LookupMgt.LookUpObject("Source Type");
            end;
        }
        field(20; "Source Ref. No."; Integer)
        {
            Caption = 'Source Ref. No.';

            trigger OnLookup()
            begin
                LookupMgt.LookUpField("Source Type", "Source Ref. No.");
            end;
        }
        field(30; Sequence; Integer)
        {
            Caption = 'Sequence';
        }
        field(40; Prefix; Text[10])
        {
            Caption = 'Prefix';
        }
    }

    keys
    {
        key(Key1; "Source Type", "Source Ref. No.")
        {
            Clustered = true;
        }
        key(Key2; Sequence)
        {
        }
    }

    fieldgroups
    {
    }

    var
        LookupMgt: Codeunit LookUpManagement;
}

