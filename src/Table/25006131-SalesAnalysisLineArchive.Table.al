Table 25006131 "Sales Analysis Line Archive"
{

    fields
    {
        field(10; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(20; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Service Quote,Service Order';
            OptionMembers = Quote,"Order","Service Quote","Service Order";
        }
        field(30; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(35; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,Labor,External Service,Resource';
            OptionMembers = " ","G/L Account",Item,Labor,"External Service",Resource;

            trigger OnValidate()
            var
                ServiceHeader: Record "Service Header EDMS";
                recMarkup: Record "Sales/Serv. Item Markup";
                recItemDisc: Record "Sales Line Discount";
                recLabTransl: Record "Service Labor Translation";
                recItemTransl: Record "Item Translation";
            begin
            end;
        }
        field(40; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = if (Type = const(" ")) "Standard Text"
            else
            if (Type = const("G/L Account")) "G/L Account"
            else
            if (Type = const(Item)) Item
            else
            if (Type = const(Labor)) "Service Labor"
            else
            if (Type = const("External Service")) "External Service"
            else
            if (Type = const(Resource)) Resource;
        }
        field(50; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(60; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(70; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
        }
        field(80; "Unit Freight Cost"; Decimal)
        {
            Caption = 'Unit Freight Cost';
        }
        field(90; "Total Unit Cost"; Decimal)
        {
            Caption = 'Total Unit Cost';
        }
        field(100; "Total Cost"; Decimal)
        {
            Caption = 'Total Cost';
        }
        field(103; "Retail Price"; Decimal)
        {
            Caption = 'Retail Price';
        }
        field(105; "Line Discount %"; Decimal)
        {
            Caption = 'Line Discount %';
        }
        field(110; "Retail Unit Price"; Decimal)
        {
            Caption = 'Retail Unit Price';
        }
        field(120; "Margin Retail %"; Decimal)
        {
            Caption = 'Margin Retail %';
        }
        field(130; "Retail Total Price"; Decimal)
        {
            Caption = 'Retail Total Price';
        }
        field(160; "Offer Unit Price"; Decimal)
        {
            Caption = 'Offer Unit Price';
        }
        field(161; "Offer Line Discount %"; Decimal)
        {
            Caption = 'Offer Line Discount %';
        }
        field(162; "Margin Amount"; Decimal)
        {
            Caption = 'Margin Amount';
        }
        field(170; "Margin %"; Decimal)
        {
            Caption = 'Margin %';
        }
        field(180; "Total Offer Price"; Decimal)
        {
            Caption = 'Total Offer Price';
        }
        field(190; "Currency Code"; Code[10])
        {
            CalcFormula = lookup("Sales Analysis Header"."Currency Code" where("No." = field("Document No."),
                                                                                "Document Type" = field("Document Type")));
            Caption = 'Currency Code';
            FieldClass = FlowField;
        }
        field(200; "Currency Factor"; Decimal)
        {
            CalcFormula = lookup("Sales Analysis Header"."Currency Factor" where("No." = field("Document No."),
                                                                                  "Document Type" = field("Document Type")));
            Caption = 'Currency Factor';
            FieldClass = FlowField;
        }
        field(220; "Quantity in Stock"; Decimal)
        {
            Caption = 'Quantity in Stock';
        }
        field(230; "Stock Average Unit Cost"; Decimal)
        {
            Caption = 'Stock Average Unit Cost';
        }
        field(240; "Vendor Stock Quantity"; Decimal)
        {
            Caption = 'Vendor Stock Quantity';
        }
        field(250; Weight; Decimal)
        {
            Caption = 'Weight';
        }
        field(300; "Version No."; Integer)
        {
            Caption = 'Version No.';
        }
    }

    keys
    {
        key(Key1; "Document No.", "Document Type", "Line No.", "Version No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

