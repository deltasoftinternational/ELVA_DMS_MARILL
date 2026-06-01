Table 25006602 "Rent Item Category"
{
    Caption = 'Rent Item Category';
    DrillDownPageID = "Rent Item Categories";
    LookupPageID = "Rent Item Categories";

    fields
    {
        field(10; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(20; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(30; "Def. Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Def. Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group".Code;
        }
        field(40; "Def. Inventory Posting Group"; Code[20])
        {
            Caption = 'Def. Inventory Posting Group';
            TableRelation = "Inventory Posting Group".Code;
        }
        field(50; "Def. Tax Group Code"; Code[20])
        {
            Caption = 'Def. Tax Group Code';
            TableRelation = "Tax Group".Code;
        }
        field(60; "Def. VAT Prod. Posting Group"; Code[20])
        {
            Caption = 'Def. VAT Prod. Posting Group';
            TableRelation = "VAT Product Posting Group".Code;
        }
        field(70; "Only as Main Asset"; Boolean)
        {
            Caption = 'Rent Asset can be only as Main Asset';
        }
        field(80; "Only as Child Asset"; Boolean)
        {
            Caption = 'Rent Asset can be only as Child Asset';
        }
        field(25006310; "Check VF Run 1 on Release"; Boolean)
        {
            CaptionClass = '7,25006602,25006310';
        }
        field(25006311; "Check VF Run 2 on Release"; Boolean)
        {
            CaptionClass = '7,25006602,25006311';
        }
        field(25006312; "Check VF Run 3 on Release"; Boolean)
        {
            CaptionClass = '7,25006602,25006312';
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

    trigger OnDelete()
    begin
        //ProductGroup.SETRANGE("Item Category Code",Code);
        //ProductGroup.DELETEALL;
    end;

    var
        VFMgt: Codeunit "Variable Field Management";


    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::"Rent Item Category", intFieldNo));
    end;
}

