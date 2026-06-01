Table 25006130 "Sales Analysis Header Archive"
{

    fields
    {
        field(10; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(20; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Service Quote,Service Order';
            OptionMembers = Quote,"Order","Service Quote","Service Order";
        }
        field(30; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
        }
        field(40; "Total Cost"; Decimal)
        {
            CalcFormula = sum("Sales Analysis Line"."Total Cost" where("Document No." = field("No."),
                                                                        "Document Type" = field("Document Type")));
            Caption = 'Total Cost';
            FieldClass = FlowField;
        }
        field(50; "Margin Retail %"; Decimal)
        {
            Caption = 'Margin Retail %';
        }
        field(80; "Total Retail Price"; Decimal)
        {
            CalcFormula = sum("Sales Analysis Line"."Retail Total Price" where("Document No." = field("No."),
                                                                                "Document Type" = field("Document Type")));
            Caption = 'Total Retail Price';
            FieldClass = FlowField;
        }
        field(90; "Total Offer Price"; Decimal)
        {
            CalcFormula = sum("Sales Analysis Line"."Total Offer Price" where("Document No." = field("No."),
                                                                               "Document Type" = field("Document Type")));
            Caption = 'Total Offer Price';
            FieldClass = FlowField;
        }
        field(100; "Margin %"; Decimal)
        {
            Caption = 'Margin %';
        }
        field(110; "Currency Factor"; Decimal)
        {
        }
        field(300; "Version No."; Integer)
        {
            Caption = 'Version No.';
        }
    }

    keys
    {
        key(Key1; "No.", "Document Type", "Version No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure GetTotalRevenue(): Decimal
    begin
        exit("Total Offer Price" - "Total Cost");
    end;


    procedure GetTotalPriceDiff(): Decimal
    begin
        if "Total Retail Price" <> 0 then
            exit((1 - "Total Offer Price" / "Total Retail Price") * 100)
        else
            exit(0);
    end;
}

