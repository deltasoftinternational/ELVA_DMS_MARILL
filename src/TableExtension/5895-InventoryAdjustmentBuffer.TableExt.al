tableextension 25006370 "Inventory Adjustment Buffer" extends "Inventory Adjustment Buffer" //5895
{
    // 18.03.2019 EDMS.KN
    //   Modified Local Variables AddActualCostBufEDMS function
    //   Inventory Posting Group Code 10 --> Code 20
    //   Gen. Prod. Posting Group Code 10 --> Code 20
    // 
    // 21.01.2015 EDMS P11
    //   Vehicle special cost adjustment
    //   Added fields:
    //     25006001  "Applies-to Entry"
    //     25006002  "Inventory Posting Group"
    //     25006003  "Gen. Prod. Posting Group"
    //   Added functions:
    //     ReadSetup
    //     AddActualCostBufEDMS
    //   Added global variables:
    //     InventSetupRead
    //     InventorySetup
    fields
    {
        field(25006001; "Applies-to Entry"; Integer)
        {
        }
        field(25006002; "Inventory Posting Group"; Code[20])
        {
        }
        field(25006003; "Gen. Prod. Posting Group"; Code[20])
        {
        }
    }

    var
        Item: Record Item;
        InventSetupRead: Boolean;
        InventorySetup: Record "Inventory Setup";


    procedure AddActualCostBufEDMS(OrigValueEntry: Record "Value Entry"; ValueEntry: Record "Value Entry"; NewAdjustedCost: Decimal; NewAdjustedCostACY: Decimal)
    var
        InvntPostGroup: Record "Inventory Posting Group";
        GenProdPostGroup: Record "Gen. Product Posting Group";
        InvPostGroupCode: Code[20];
        GenProdGroupCode: Code[20];
        NextEntryNo: Integer;
        ValueEntryPostingDate: Date;
    begin
        ReadSetup;
        ValueEntryPostingDate := OrigValueEntry."Posting Date";
        if InventorySetup."Vehicle Original Cost Date" then
            if OrigValueEntry."Posting Date" < ValueEntry."Posting Date" then
                ValueEntryPostingDate := ValueEntry."Posting Date";

        if not InvntPostGroup.Get(ValueEntry."Inventory Posting Group") then
            Clear(InvntPostGroup);
        if InvntPostGroup."Split Value Entries" then
            InvPostGroupCode := ValueEntry."Inventory Posting Group"
        else
            InvPostGroupCode := OrigValueEntry."Inventory Posting Group";

        if not GenProdPostGroup.Get(ValueEntry."Gen. Prod. Posting Group") then
            Clear(GenProdPostGroup);
        if GenProdPostGroup."Split Value Entries" then
            GenProdGroupCode := ValueEntry."Gen. Prod. Posting Group"
        else
            GenProdGroupCode := OrigValueEntry."Gen. Prod. Posting Group";

        Reset;
        SetRange("Applies-to Entry", OrigValueEntry."Entry No.");
        SetRange("Inventory Posting Group", InvPostGroupCode);
        SetRange("Gen. Prod. Posting Group", GenProdGroupCode);
        SetRange("Posting Date", ValueEntryPostingDate);

        if FindFirst then begin
            if ValueEntry."Expected Cost" then begin
                "Cost Amount (Expected)" := "Cost Amount (Expected)" + NewAdjustedCost;
                "Cost Amount (Expected) (ACY)" := "Cost Amount (Expected) (ACY)" + NewAdjustedCostACY;
            end else begin
                "Cost Amount (Actual)" := "Cost Amount (Actual)" + NewAdjustedCost;
                "Cost Amount (Actual) (ACY)" := "Cost Amount (Actual) (ACY)" + NewAdjustedCostACY;
            end;
            Modify;
        end else begin
            Reset;
            if FindLast then
                NextEntryNo := "Entry No.";
            NextEntryNo += 1;

            Init;
            "Entry No." := NextEntryNo;
            "Applies-to Entry" := OrigValueEntry."Entry No.";
            "Item No." := ValueEntry."Item No.";
            "Document No." := ValueEntry."Document No.";
            "Location Code" := ValueEntry."Location Code";
            "Variant Code" := ValueEntry."Variant Code";
            "Entry Type" := ValueEntry."Entry Type";
            "Item Ledger Entry No." := ValueEntry."Item Ledger Entry No.";
            "Expected Cost" := ValueEntry."Expected Cost";
            "Posting Date" := ValueEntryPostingDate;
            if ValueEntry."Expected Cost" then begin
                "Cost Amount (Expected)" := NewAdjustedCost;
                "Cost Amount (Expected) (ACY)" := NewAdjustedCostACY;
            end else begin
                "Cost Amount (Actual)" := NewAdjustedCost;
                "Cost Amount (Actual) (ACY)" := NewAdjustedCostACY;
            end;
            "Valued By Average Cost" := ValueEntry."Valued By Average Cost";
            "Valuation Date" := ValueEntry."Valuation Date";
            "Inventory Posting Group" := InvPostGroupCode;
            "Gen. Prod. Posting Group" := GenProdGroupCode;
            Insert;
        end;
        Reset;
    end;

    local procedure ReadSetup()
    begin
        if InventSetupRead then
            exit;
        InventorySetup.Get;
        InventSetupRead := true;
    end;

    procedure AddExpectedCostBufEDMS(OrigValueEntry: Record "Value Entry"; ValueEntry: Record "Value Entry"; BalanceExpectedCost: Decimal; BalanceExpectedCostACY: Decimal)
    var
        InvntPostGroup: Record "Inventory Posting Group";
        GenProdPostGroup: Record "Gen. Product Posting Group";
        InvPostGroupCode: Code[20];
        GenProdGroupCode: Code[20];
        NextEntryNo: Integer;
        ValueEntryPostingDate: Date;
    begin
        ReadSetup;
        ValueEntryPostingDate := OrigValueEntry."Posting Date";
        if InventorySetup."Vehicle Original Cost Date" then
            if OrigValueEntry."Posting Date" < ValueEntry."Posting Date" then
                ValueEntryPostingDate := ValueEntry."Posting Date";

        if NOT InvntPostGroup.GET(ValueEntry."Inventory Posting Group") then
            CLEAR(InvntPostGroup);
        if InvntPostGroup."Split Value Entries" then
            InvPostGroupCode := ValueEntry."Inventory Posting Group"
        ELSE
            InvPostGroupCode := OrigValueEntry."Inventory Posting Group";

        if NOT GenProdPostGroup.GET(ValueEntry."Gen. Prod. Posting Group") then
            CLEAR(GenProdPostGroup);
        if GenProdPostGroup."Split Value Entries" then
            GenProdGroupCode := ValueEntry."Gen. Prod. Posting Group"
        else
            GenProdGroupCode := OrigValueEntry."Gen. Prod. Posting Group";

        RESET;
        if FINDLAST then
            NextEntryNo := "Entry No.";
        NextEntryNo += 1;

        INIT;
        "Entry No." := NextEntryNo;
        "Applies-to Entry" := OrigValueEntry."Entry No.";
        "Item No." := ValueEntry."Item No.";
        "Document No." := ValueEntry."Document No.";
        "Location Code" := ValueEntry."Location Code";
        "Variant Code" := ValueEntry."Variant Code";
        "Entry Type" := ValueEntry."Entry Type";
        "Item Ledger Entry No." := ValueEntry."Item Ledger Entry No.";
        "Expected Cost" := ValueEntry."Expected Cost";
        "Posting Date" := ValueEntryPostingDate;

        "Cost Amount (Expected)" := BalanceExpectedCost;
        "Cost Amount (Expected) (ACY)" := BalanceExpectedCostACY;

        "Valued By Average Cost" := ValueEntry."Valued By Average Cost";
        "Valuation Date" := ValueEntry."Valuation Date";
        "Inventory Posting Group" := InvPostGroupCode;
        "Gen. Prod. Posting Group" := GenProdGroupCode;
        INSERT;

        RESET;
    end;
}
