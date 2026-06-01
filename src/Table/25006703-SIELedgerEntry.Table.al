/*
Table 25006703 "SIE Ledger Entry"
{
    // 12.01.2015 EB.P7 #Username length EDMS
    //   User ID Field length changed to Code(50)

    Caption = 'SIE Ledger Entry';
    DrillDownPageID = "SIE Ledger Entries";
    LookupPageID = "SIE Ledger Entries";

    fields
    {
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(20; "SIE No."; Code[10])
        {
            Caption = 'SIE No.';
            TableRelation = "Special Inventory Equipment"."No.";
        }
        field(30; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(40; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = ' ,Transaction';
            OptionMembers = " ",Transaction;
        }
        field(50; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(60; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(70; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(80; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
        field(90; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(100; Open; Boolean)
        {
            Caption = 'Open';
        }
        field(110; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(120; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(130; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(140; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
        }
        field(150; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(160; "User ID"; Code[50])
        {
            Caption = 'User ID';
            //TableRelation = Table2000000002;
            //This property is currently not supported
            //TestTableRelation = false;

            trigger OnLookup()
            var
                LoginMgt: Codeunit UserProfileManagement;
            begin
                LoginMgt.LookupUserID("User ID");
            end;
        }
        field(170; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(180; Correction; Boolean)
        {
            Caption = 'Correction';
        }
        field(190; "Automatic Entry"; Boolean)
        {
            Caption = 'Automatic Entry';
        }
        field(200; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(210; "Qty. to Assign"; Decimal)
        {
            CalcFormula = sum("SIE Assignment"."Qty. to Assign" where("Entry No." = field("Entry No.")));
            Caption = 'Qty. to Assign';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(220; "Qty. Assigned"; Decimal)
        {
            CalcFormula = sum("SIE Assignment"."Qty. Assigned Det." where("Entry No." = field("Entry No."),
                                                                           Type = const(Detail)));
            Caption = 'Qty. Assigned';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(230; "Code10 1"; Code[10])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Code10 1"));
        }
        field(240; "Code10 2"; Code[10])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Code10 2"));
        }
        field(250; "Code10 3"; Code[10])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Code10 3"));
        }
        field(260; "Code10 4"; Code[10])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Code10 4"));
        }
        field(270; "Code10 5"; Code[10])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Code10 5"));
        }
        field(280; "Code10 6"; Code[10])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Code10 6"));
        }
        field(290; "Code20 1"; Code[20])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Code20 1"));
        }
        field(300; "Code20 2"; Code[20])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Code20 2"));
        }
        field(310; "Code20 3"; Code[20])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Code20 3"));
        }
        field(320; "Code20 4"; Code[20])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Code20 4"));
        }
        field(330; "Code20 5"; Code[20])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Code20 5"));
        }
        field(340; "Code20 6"; Code[20])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Code20 6"));
        }
        field(350; "Int 1"; Integer)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Int 1"));
        }
        field(360; "Int 2"; Integer)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Int 2"));
        }
        field(370; "Int 3"; Integer)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Int 3"));
        }
        field(380; "Int 4"; Integer)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Int 4"));
        }
        field(390; "Int 5"; Integer)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Int 5"));
        }
        field(400; "Int 6"; Integer)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Int 6"));
        }
        field(410; "Decimal 1"; Decimal)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Decimal 1"));
        }
        field(420; "Decimal 2"; Decimal)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Decimal 2"));
        }
        field(430; "Decimal 3"; Decimal)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Decimal 3"));
        }
        field(440; "Decimal 4"; Decimal)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Decimal 4"));
        }
        field(450; "Decimal 5"; Decimal)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Decimal 5"));
        }
        field(460; "Decimal 6"; Decimal)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Decimal 6"));
        }
        field(470; "Date 1"; Date)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Date 1"));
        }
        field(480; "Date 2"; Date)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Date 2"));
        }
        field(490; "Time 1"; Time)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Time 1"));
        }
        field(500; "Time 2"; Time)
        {
            CaptionClass = GetCaptionClass(FIELDNO("Time 2"));
        }
        field(510; "Text50 1"; Text[50])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Text50 1"));
        }
        field(520; "Text50 2"; Text[50])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Text50 2"));
        }
        field(530; "Text100 1"; Text[100])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Text100 1"));
        }
        field(540; "Text10 1"; Text[10])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Text10 1"));
        }
        field(550; "Text10 2"; Text[10])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Text10 2"));
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "External Document No.", "Code20 2")
        {
        }
        key(Key3; "Date 1", "Time 1")
        {
        }
        key(Key4; "SIE No.")
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
        exit(VFMgt.GetVFCaptionEx(Database::"SIE Ledger Entry", FieldNumber, "SIE No."));
    end;


    procedure IsVFActive(FieldNumber: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActiveEx(Database::"SIE Ledger Entry", FieldNumber, "SIE No."));
    end;
}
*/