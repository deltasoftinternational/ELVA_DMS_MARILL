tableextension 25006376 "Value Entry" extends "Value Entry" //5802
{
    // 17.03.2014 P18 #R098 MMG7.00
    //   Added key "Document No.,Posting Date,Item No.,Item Ledger Entry Type,Location Code"
    //   Added f-n GetCostAmt
    fields
    {
        field(25006001; "Item Type"; Option)
        {
            Caption = 'Item Type';
            OptionCaption = ' ,Item,Model Version,Own Option,Material';
            OptionMembers = " ",Item,"Model Version","Own Option",Material;
        }
        field(25006670; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        field(25006671; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';
        }
        field(25006672; "Product Subgroup Code"; Code[10])
        {
            Caption = 'Product Subgroup Code';
        }
        field(25006680; "Not To Post"; Boolean)
        {
            Caption = 'Not To Post';
        }

    }

    keys
    {
        //  Create a mixed key from BaseApp & extension !!!
        /*
        key(Key18; "Not To Post", "Item Ledger Entry No.")
        {
        }
        key(Key19; "Item Ledger Entry Type", "Item Category Code", "Product Group Code", "Location Code", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date")
        {
            SumIndexFields = "Invoiced Quantity", "Sales Amount (Actual)", "Cost Amount (Actual)", "Purchase Amount (Actual)";
        }
        */
        key(Key20; "Location Code", "Posting Date")
        {
        }
        key(Key21; "Document No.", "Posting Date", "Item No.", "Item Ledger Entry Type", "Location Code")
        {
        }
        key(Key22; "Item No.", "Item Ledger Entry Type", "Order Type", "Order No.", "Order Line No.")
        {
        }
    }

    procedure GetCostAmt(): Decimal
    begin
        if "Cost Amount (Actual)" = 0 then
            exit("Cost Amount (Expected)");
        exit("Cost Amount (Actual)");
    end;

    procedure AddBalanceExpectedCostBufEDMS(ValueEntry: Record "Value Entry"; NewAdjustedCost: Decimal; NewAdjustedCostACY: Decimal)
    begin
        if ValueEntry."Expected Cost" or
          (ValueEntry."Entry Type" <> ValueEntry."entry type"::"Direct Cost")
        then
            exit;

        Reset;
        SetRange("Applies-to Entry", ValueEntry."Entry No.");
        Find;
        "Cost Amount (Expected)" := NewAdjustedCost;
        "Cost Amount (Expected) (ACY)" := NewAdjustedCostACY;
        Modify;

        Reset;
    end;

}