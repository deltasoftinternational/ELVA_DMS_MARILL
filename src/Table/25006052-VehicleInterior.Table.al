Table 25006052 "Vehicle Interior"
{
    Caption = 'Vehicle Interior';
    DrillDownPageID = "Vehicle Interiors";
    LookupPageID = "Vehicle Interiors";

    fields
    {
        field(4; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(20; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make.Code;
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

        field(30; Description; Text[50])
        {
            Caption = 'Description';
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

