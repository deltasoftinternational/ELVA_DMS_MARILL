Table 25006032 "Body Color"
{
    Caption = 'Body Color';
    DrillDownPageID = "Body Colors";
    LookupPageID = "Body Colors";

    fields
    {
        field(4; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(20; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make.Code;
        }
        field(30; Description; Text[50])
        {
            Caption = 'Description';
        }

        field(40; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item."No." where("Make Code" = field("Make Code"),
                                              "Item Type" = const("Model Version"));
            trigger OnLookup()
            var
                recItem: Record Item;
                LookUpMgt: Codeunit "LookUpManagement";
            begin
                recItem.Reset;
                if LookUpMgt.LookUpModelVersion(recItem, '', "Make Code", '') then begin
                    if "make code" = '' then
                        "make code" := recitem."make code";
                    Validate("Model Version No.", recItem."No.");
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "Code", "Make Code", "Model Version No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

