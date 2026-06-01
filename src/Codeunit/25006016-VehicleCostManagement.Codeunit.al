Codeunit 25006016 "Vehicle Cost Management"
{
    // 21.01.2015 EDMS P11
    //   Vehicle special cost adjustment
    //   Created


    trigger OnRun()
    begin
    end;

    var
        InvtSetup: Record "Inventory Setup";
        SetupIsLoaded: Boolean;
        InvalidCostingMethodErr: label 'Vehicle Cost: Item %1 has invalid costing method %2.', Comment = '%1 = Item No., %2 = item costing method';
        ItemNeedTrackingErr: label 'Vehicle Cost: Item %1 need tracking code.', Comment = '%1 - Item No.';
        InvalidQuantityErr: label 'Vehicle Cost: Quantity must have only values 1 or -1. Item No. %1, %2.', Comment = '%1 = Item No., %2 = Detailed info about record';
        InvalidEntryType: label 'Vehicle Cost: Entry type of item %1 cannot be %2. %3.', Comment = '%1 = Item No., %2 = Item Ledger Entry Type, %3 = Detailed info about record';

    local procedure LoadSetup()
    begin
        if SetupIsLoaded then
            exit;
        InvtSetup.Get;
        SetupIsLoaded := true;
    end;


    procedure ItemHaveSpecialVehicleCost(var TheItem: Record Item) result: Boolean
    var
        Item: Record Item;
    begin
        LoadSetup;
        result := InvtSetup."Vehicle Special Costing" and (TheItem."Item Type" = TheItem."item type"::"Model Version");
    end;


    procedure CheckAllItemLedgVehicleCostReq(var TheItem: Record Item)
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        ItemLedgerEntry.SetRange("Item No.", TheItem."No.");
        if ItemLedgerEntry.FindSet then
            repeat
                CheckItemLedgVehicleCostReq(TheItem, ItemLedgerEntry);
            until ItemLedgerEntry.Next = 0;
    end;


    procedure CheckItemVehicleCostReq(TheItem: Record Item; Quantity: Decimal; EntryType: Integer; TableCapt: Text; DetailedInfo: Text)
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        if TheItem."Costing Method" <> TheItem."costing method"::Specific then
            Error(InvalidCostingMethodErr, TheItem."No.", TheItem."Costing Method");

        if TheItem."Item Tracking Code" = '' then
            Error(ItemNeedTrackingErr, TheItem."No.");

        //TODO: Check Stock keeping units
        //TODO: Check Variants

        if not (Quantity in [1, -1, 0]) then
            Error(InvalidQuantityErr, TheItem."No.", DetailedInfo);

        ItemLedgerEntry."Entry Type" := EntryType;
        if not (ItemLedgerEntry."Entry Type" in [ItemLedgerEntry."entry type"::Purchase,
                                                 ItemLedgerEntry."entry type"::Sale,
                                                 ItemLedgerEntry."entry type"::"Positive Adjmt.",
                                                 ItemLedgerEntry."entry type"::"Negative Adjmt.",
                                                 ItemLedgerEntry."entry type"::Transfer])
        then
            Error(InvalidEntryType,
                  TheItem."No.", ItemLedgerEntry."Entry Type", DetailedInfo);
    end;


    procedure CheckItemLedgVehicleCostReq(TheItem: Record Item; ItemLedgerEntry: Record "Item Ledger Entry")
    begin

        CheckItemVehicleCostReq(TheItem, ItemLedgerEntry.Quantity, ItemLedgerEntry."Entry Type".AsInteger(), ItemLedgerEntry.TableCaption,
                                StrSubstNo('%1: %2.', ItemLedgerEntry.FieldCaption("Entry No."), ItemLedgerEntry."Entry No."));
    end;


    procedure CheckItemJnlVehicleCostReq(TheItem: Record Item; ItemJnlLine: Record "Item Journal Line")
    var
        DetailedInfo: Text;
    begin
        if ItemJnlLine.Adjustment then
            exit;
        if ItemJnlLine."Item Charge No." <> '' then
            exit;
        if ItemJnlLine."Value Entry Type" <> ItemJnlLine."value entry type"::"Direct Cost" then
            exit;
        if (ItemJnlLine."Journal Template Name" <> '') or (ItemJnlLine."Journal Batch Name" <> '') then
            DetailedInfo := StrSubstNo('%1: %2, %3: %4, %5: %6.',
                                       ItemJnlLine.FieldCaption("Journal Template Name"), ItemJnlLine."Journal Template Name",
                                       ItemJnlLine.FieldCaption("Journal Batch Name"), ItemJnlLine."Journal Batch Name",
                                       ItemJnlLine.FieldCaption("Line No."), ItemJnlLine."Line No.");
        CheckItemVehicleCostReq(TheItem, ItemJnlLine.Quantity, ItemJnlLine."Entry Type", ItemJnlLine.TableCaption, DetailedInfo);
    end;


    procedure GetPrevItemLedgEntry(CurrItemLedgEntryNo: Integer; var PrevItemLedgEntry: Record "Item Ledger Entry") Result: Boolean
    var
        ItemApplEntry: Record "Item Application Entry";
    begin
        Result := false;

        ItemApplEntry.SetRange("Item Ledger Entry No.", CurrItemLedgEntryNo);
        if ItemApplEntry.FindFirst then begin
            if (ItemApplEntry."Item Ledger Entry No." = ItemApplEntry."Outbound Item Entry No.") and (ItemApplEntry."Inbound Item Entry No." <> 0) then
                Result := PrevItemLedgEntry.Get(ItemApplEntry."Inbound Item Entry No.")
            else
                if (ItemApplEntry."Item Ledger Entry No." = ItemApplEntry."Inbound Item Entry No.") and (ItemApplEntry."Outbound Item Entry No." <> 0) then
                    Result := PrevItemLedgEntry.Get(ItemApplEntry."Outbound Item Entry No.");
        end;
    end;


    procedure GetNextItemLedgEntry(CurrItemLedgEntryNo: Integer; var NextItemLedgEntry: Record "Item Ledger Entry") Result: Boolean
    var
        ItemApplEntry: Record "Item Application Entry";
    begin
        Result := false;

        ItemApplEntry.SetRange("Item Ledger Entry No.", CurrItemLedgEntryNo);
        if ItemApplEntry.FindFirst then begin
            if (ItemApplEntry."Item Ledger Entry No." = ItemApplEntry."Inbound Item Entry No.") then begin
                ItemApplEntry.Reset;
                ItemApplEntry.SetRange("Inbound Item Entry No.", ItemApplEntry."Inbound Item Entry No.");
                ItemApplEntry.SetFilter("Item Ledger Entry No.", '<>%1', ItemApplEntry."Item Ledger Entry No.");
                if ItemApplEntry.FindFirst then
                    Result := NextItemLedgEntry.Get(ItemApplEntry."Item Ledger Entry No.");
            end
            else
                if (ItemApplEntry."Item Ledger Entry No." = ItemApplEntry."Outbound Item Entry No.") then begin
                    ItemApplEntry.Reset;
                    ItemApplEntry.SetRange("Outbound Item Entry No.", ItemApplEntry."Outbound Item Entry No.");
                    ItemApplEntry.SetFilter("Item Ledger Entry No.", '<>%1', ItemApplEntry."Item Ledger Entry No.");
                    if ItemApplEntry.FindFirst then
                        Result := NextItemLedgEntry.Get(ItemApplEntry."Item Ledger Entry No.");
                end;
        end;
    end;
}

