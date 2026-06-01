Codeunit 25006504 "Lost Sales Management"
{

    trigger OnRun()
    begin
    end;

    var
        LostSalesEntry: Record "Lost Sales Entry";
        LostSalesSetup: Record "Lost Sales Setup";
        Text100: label 'Is this a lost sale?';
        Text110: label 'Item %1. Is this a lost sale?';


    procedure RegisterLostSale_Item(ItemNo: Code[20])
    var
        LostSaleReg_Item: Page "Register Item Lost Sale";
    begin
        Clear(LostSaleReg_Item);
        LostSaleReg_Item.SetItem(ItemNo);
        LostSaleReg_Item.RunModal;
    end;


    procedure CreateEntry_Item(EntryDate: Date; ItemNo: Code[20]; CustNo: Code[20]; Desc: Text[30]; Desc2: Text[30]; ReasonCode: Code[20]; Priority: Option ,Highest,High,Mediun,Low,Lowest; Automatic: Boolean; LocationCode: Code[20])
    var
        EntryNo: Integer;
        Item: Record Item;
    begin
        LostSalesEntry.Reset;
        LostSalesEntry.LockTable;
        if LostSalesEntry.FindLast then
            EntryNo := LostSalesEntry."Entry No.";

        EntryNo := EntryNo + 1;

        LostSalesEntry.Init;
        LostSalesEntry."Entry No." := EntryNo;
        LostSalesEntry.Date := EntryDate;
        LostSalesEntry."Item No." := ItemNo;
        if Item.Get(ItemNo) then begin
            LostSalesEntry."Item Category Code" := Item."Item Category Code";
            //LostSalesEntry."Product Group Code" := Item."Product Group Code";//20.06.2019 EB.P7 BC Upgrade
        end;
        LostSalesEntry."Customer No." := CustNo;
        LostSalesEntry.Description := Desc;
        LostSalesEntry."Description 2" := Desc2;
        LostSalesEntry."Reason Code" := ReasonCode;
        LostSalesEntry.Priority := Priority;
        LostSalesEntry.Automatic := Automatic;
        LostSalesEntry."Location Code" := LocationCode;
        LostSalesEntry.Insert;
    end;


    procedure OnServLineDelete(ServLine: Record "Service Line EDMS")
    var
        ServHeader: Record "Service Header EDMS";
    begin
        if ServLine.Type <> ServLine.Type::Item then
            exit;

        ServHeader.Reset;
        ServHeader.Get(ServLine."Document Type", ServLine."Document No.");
        if not LostSalesSetup.Get then
            exit;
        case LostSalesSetup."On Service Doc. Deletion" of
            LostSalesSetup."on service doc. deletion"::Prompt:
                if Confirm(Text110, true, ServLine."No.") then
                    CreateEntry_Item(WorkDate, ServLine."No.", ServHeader."Sell-to Customer No.", '', '', '', 3, true, ServLine."Location Code");
            LostSalesSetup."on service doc. deletion"::Yes:
                CreateEntry_Item(WorkDate, ServLine."No.", ServHeader."Sell-to Customer No.", '', '', '', 3, true, ServLine."Location Code");
        end;
    end;


    procedure OnSalesLineDelete(SalesLine: Record "Sales Line")
    begin
        if SalesLine.Type <> SalesLine.Type::Item then
            exit;

        if not LostSalesSetup.Get then
            exit;
        case LostSalesSetup."On Sales Doc. Deletion" of
            LostSalesSetup."on sales doc. deletion"::Prompt:
                if Confirm(Text110, true, SalesLine."No.") then
                    CreateEntry_Item(WorkDate, SalesLine."No.", SalesLine."Sell-to Customer No.", '', '', '', 3, true, SalesLine."Location Code");
            LostSalesSetup."on sales doc. deletion"::Yes:
                CreateEntry_Item(WorkDate, SalesLine."No.", SalesLine."Sell-to Customer No.", '', '', '', 3, true, SalesLine."Location Code");
        end;
    end;


    procedure OnServHeaderDelete(ServHeader: Record "Service Header EDMS")
    var
        ServLine: Record "Service Line EDMS";
    begin
        if not LostSalesSetup.Get then
            exit;

        if LostSalesSetup."On Service Doc. Deletion" = LostSalesSetup."on service doc. deletion"::No then
            exit;

        if LostSalesSetup."On Service Doc. Deletion" = LostSalesSetup."on service doc. deletion"::Prompt then
            if not Confirm(Text100) then
                exit;

        ServLine.Reset;
        ServLine.SetRange("Document Type", ServHeader."Document Type");
        ServLine.SetRange("Document No.", ServHeader."No.");
        ServLine.SetRange(Type, ServLine.Type::Item);
        if ServLine.FindFirst then
            repeat
                CreateEntry_Item(WorkDate, ServLine."No.", ServHeader."Sell-to Customer No.", '', '', '', 3, true, ServLine."Location Code");
            until ServLine.Next = 0;
    end;


    procedure OnSalesHeaderDelete(SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
    begin
        if SalesHeader."Document Profile" = SalesHeader."document profile"::"Vehicles Trade" then
            exit;

        if not LostSalesSetup.Get then
            exit;

        if LostSalesSetup."On Sales Doc. Deletion" = LostSalesSetup."on sales doc. deletion"::No then
            exit;

        if LostSalesSetup."On Sales Doc. Deletion" = LostSalesSetup."on sales doc. deletion"::Prompt then
            if not Confirm(Text100) then
                exit;

        SalesLine.Reset;
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        if SalesLine.FindFirst then
            repeat
                CreateEntry_Item(WorkDate, SalesLine."No.", SalesHeader."Sell-to Customer No.", '', '', '', 3, true, SalesLine."Location Code");
            until SalesLine.Next = 0;
    end;
}

