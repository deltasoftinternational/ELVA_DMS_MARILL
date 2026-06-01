Table 25006268 "Serv. Allocation Description"
{
    Caption = 'Serv. Allocation Description';
    DrillDownPageID = "Serv. Allocation Descriptions";
    LookupPageID = "Serv. Allocation Descriptions";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(10; Description; Text[250])
        {
            Caption = 'Description';
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

    trigger OnInsert()
    begin
        if "Entry No." = 0 then begin
            ServAllocationDetail.Reset;
            if ServAllocationDetail.FindLast then
                "Entry No." := ServAllocationDetail."Entry No.";
            "Entry No." += 1;
        end;
    end;

    var
        ServAllocationDetail: Record "Serv. Allocation Description";
}

