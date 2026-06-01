Table 25006650 "Document Payment Line"
{

    fields
    {
        field(10; "Document Type"; Option)
        {
            OptionMembers = ,"Sales Order","Sales Invoice","Service Order","Service Invoice",,"Sales Cr.Memo","Service Return Order";
        }
        field(20; "Document No."; Code[20])
        {
        }
        field(30; "Payment Method Code"; Code[10])
        {
            TableRelation = "Payment Method";

            trigger OnValidate()
            var
                PaymentMethod: Record "Payment Method";
            begin
                Description := '';
                "Bal. Account Type" := 0;
                "Bal. Account No." := '';

                if "Payment Method Code" <> '' then begin
                    if PaymentMethod.Get("Payment Method Code") then begin
                        Description := PaymentMethod.Description;
                        "Bal. Account Type" := PaymentMethod."Bal. Account Type";
                        "Bal. Account No." := PaymentMethod."Bal. Account No.";
                    end;
                end;
            end;
        }
        field(100; Description; Text[100])
        {
        }
        field(200; Amount; Decimal)
        {
        }
        field(300; "Bal. Account Type"; Option)
        {
            Caption = 'Bal. Account Type';
            OptionCaption = 'G/L Account,Bank Account';
            OptionMembers = "G/L Account","Bank Account";

            trigger OnValidate()
            begin
                "Bal. Account No." := '';
            end;
        }
        field(310; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            TableRelation = if ("Bal. Account Type" = const("G/L Account")) "G/L Account"
            else
            if ("Bal. Account Type" = const("Bank Account")) "Bank Account";
        }
    }

    keys
    {
        key(Key1; "Document Type", "Document No.", "Payment Method Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

