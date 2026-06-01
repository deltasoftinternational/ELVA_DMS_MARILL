/*
Table 25006707 "SIE Object"
{
    Caption = 'SIE Object';
    LookupPageID = "SIE Object List";

    fields
    {
        field(10; "SIE No."; Code[10])
        {
            Caption = 'SIE No.';
            NotBlank = true;
            TableRelation = "Special Inventory Equipment"."No.";
        }
        field(20; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(30; Category; Code[10])
        {
            Caption = 'Category';
            TableRelation = "SIE Object Category"."No." where("SIE No." = field("SIE No."));
        }
        field(35; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(40; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(50; "NAV No."; Code[20])
        {
            Caption = 'NAV No.';
        }
        field(60; "NAV No. 2"; Code[20])
        {
            Caption = 'NAV No. 2';
        }
        field(70; "Variable Int 1"; Integer)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Variable Int 1"));
        }
        field(80; "Variable Int 2"; Integer)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Variable Int 2"));
        }
        field(90; "Variable Int 3"; Integer)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Variable Int 3"));
        }
        field(100; "Variable Decimal 1"; Decimal)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Variable Decimal 1"));
        }
        field(110; "Variable Decimal 2"; Decimal)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Variable Decimal 2"));
        }
        field(120; "Variable Decimal 3"; Decimal)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Variable Decimal 3"));
        }
        field(130; "Variable Decimal 4"; Decimal)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Variable Decimal 4"));
        }
        field(140; "Variable Decimal 5"; Decimal)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Variable Decimal 5"));
        }
        field(150; "Variable Text30 1"; Text[30])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Variable Text30 1"));
        }
        field(160; "Variable Text30 2"; Text[30])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Variable Text30 2"));
        }
        field(170; "Variable Text30 3"; Text[30])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Variable Text30 3"));
        }
        field(180; "Variable Text50 1"; Text[50])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Variable Text50 1"));
        }
        field(190; "Variable Text50 2"; Text[50])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Variable Text50 2"));
        }
        field(200; "Variable Code10 1"; Code[10])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Variable Code10 1"));
        }
        field(210; "Variable Code10 2"; Code[10])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Variable Code10 2"));
        }
        field(220; "Variable Code20 1"; Code[20])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Variable Code20 1"));
        }
        field(230; "Variable Code20 2"; Code[20])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Variable Code20 2"));
        }
        field(240; "Variable Bool 1"; Boolean)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Variable Bool 1"));
        }
        field(250; "Variable Bool 2"; Boolean)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Variable Bool 2"));
        }
        field(260; "Variable Bool 3"; Boolean)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Variable Bool 3"));
        }
    }

    keys
    {
        key(Key1; "SIE No.", Category, "No.")
        {
            Clustered = true;
        }
        key(Key2; "SIE No.", Category, "Location Code")
        {
        }
    }

    fieldgroups
    {
    }

    var
        VFMgt: Codeunit "Variable Field Management";

    local procedure GetCaptionClass(FieldNumber: Integer): Text[80]
    begin
        Clear(VFMgt);
        //exit(VFMgt.GetVFCaptionEx(Database::Table55007,FieldNumber,"SIE No.")); //FIXME
    end;


    procedure IsVFActive(FieldNumber: Integer): Boolean
    begin
        Clear(VFMgt);
        //exit(VFMgt.IsVFActiveEx(Database::Table55007,FieldNumber,"SIE No.")); //FIXME
    end;
}
*/