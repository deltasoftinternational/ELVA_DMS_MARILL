/*
Table 25006710 "SIE Item"
{
    DrillDownPageID = "SIE Items";
    LookupPageID = "SIE Items";

    fields
    {
        field(10; "SIE No."; Code[10])
        {
            Caption = 'SIE No.';
            NotBlank = true;
            TableRelation = "Special Inventory Equipment"."No.";
        }
        field(20; "Object No."; Code[20])
        {
            Caption = 'Object No.';
            TableRelation = "SIE Object"."No." where("SIE No." = field("SIE No."),
                                                      Category = field(Category));
        }
        field(30; Category; Code[10])
        {
            Caption = 'Category';
            TableRelation = "SIE Object Category"."No." where("SIE No." = field("SIE No."));
        }
        field(40; "Code20 1"; Code[20])
        {
            CaptionClass = GetCaptionClass(FIELDNO("Code20 1"));
            Description = 'REELNO comes from "SIE Journal Line"."Code10 1"';
            NotBlank = true;
        }
        field(100; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
    }

    keys
    {
        key(Key1; "SIE No.", Category, "Object No.", "Code20 1")
        {
            Clustered = true;
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
        exit(VFMgt.GetVFCaptionEx(Database::"SIE Item", FieldNumber, "SIE No."));
    end;


    procedure IsVFActive(FieldNumber: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActiveEx(Database::"SIE Item", FieldNumber, "SIE No."));
    end;


    procedure GetCaption(FldNum: Integer): Text[80]
    begin
        exit(GetCaptionClass(FldNum))
    end;
}
*/