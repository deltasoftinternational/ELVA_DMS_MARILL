Table 25006790 "User Integr. Session Header"
{

    fields
    {
        field(10; ID; Integer)
        {
            AutoIncrement = true;
            Caption = 'ID';
        }
        field(1000; "User ID"; Code[50])
        {
            Caption = 'User ID';
        }
        field(1010; "Started At"; DateTime)
        {
            Caption = 'Started At';
        }
        field(2000; "Connector Source Type"; Integer)
        {
            Caption = 'Connector Source Type';
        }
        field(3000; "Source Type"; Integer)
        {
            Caption = 'Source Type';
        }
        field(3010; "Source Subtype"; Integer)
        {
            Caption = 'Source Subtype';
        }
        field(3020; "Source ID"; Code[20])
        {
            Caption = 'Source ID';
        }
        field(3030; "Source Line No."; Integer)
        {
            Caption = 'Source Line No.';
        }
    }

    keys
    {
        key(Key1; ID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        UserIntegrSessionLine.Reset;
        UserIntegrSessionLine.SetRange("Session ID", ID);
        UserIntegrSessionLine.DeleteAll(true);
    end;

    trigger OnInsert()
    begin
        "User ID" := UserId;
        "Started At" := CurrentDatetime;
    end;

    var
        UserIntegrSessionLine: Record "User Integr. Session Line";


    procedure AddLine(var UserIntegrSessionLine: Record "User Integr. Session Line")
    begin
        Clear(UserIntegrSessionLine);
        UserIntegrSessionLine."Session ID" := ID;
        UserIntegrSessionLine."Line No." := GetLastLineNo + 1;
        UserIntegrSessionLine.Insert(true);
    end;

    local procedure GetLastLineNo(): Integer
    var
        UserIntegrSessionLine: Record "User Integr. Session Line";
    begin
        UserIntegrSessionLine.Reset;
        UserIntegrSessionLine.SetRange("Session ID", ID);
        if UserIntegrSessionLine.FindLast then
            exit(UserIntegrSessionLine."Line No.");

        exit(0);
    end;

    local procedure "-- Add Line For --"()
    begin
    end;


    procedure AddLineForItem(ItemNo: Code[20]; VariantCode: Code[10]; LocationCode: Code[10]; Qty: Decimal; SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceLineNo: Integer)
    var
        UserIntegrSessionLine: Record "User Integr. Session Line";
    begin
        TestField(ID);

        UserIntegrSessionLine.Reset;
        UserIntegrSessionLine.SetRange("Session ID", ID);
        UserIntegrSessionLine.SetRange("Item No.", ItemNo);
        UserIntegrSessionLine.SetRange("Variant Code", VariantCode);
        UserIntegrSessionLine.SetRange("Location Code", LocationCode);
        UserIntegrSessionLine.SetRange("Source Type", SourceType);
        UserIntegrSessionLine.SetRange("Source Subtype", SourceSubtype);
        UserIntegrSessionLine.SetRange("Source ID", SourceID);
        UserIntegrSessionLine.SetRange("Source Line No.", SourceLineNo);
        if UserIntegrSessionLine.FindLast then
            exit;

        AddLine(UserIntegrSessionLine);
        UserIntegrSessionLine.Validate("Item No.", ItemNo);
        UserIntegrSessionLine.Validate("Variant Code", VariantCode);
        UserIntegrSessionLine.Validate("Location Code", LocationCode);
        UserIntegrSessionLine.Validate("Source Type", SourceType);
        UserIntegrSessionLine.Validate("Source Subtype", SourceSubtype);
        UserIntegrSessionLine.Validate("Source ID", SourceID);
        UserIntegrSessionLine.Validate("Source Line No.", SourceLineNo);
        UserIntegrSessionLine.Validate(Quantity, Qty);
        UserIntegrSessionLine.Modify;
    end;
}

