Codeunit 25006314 "Veh.Trade-In Mgt."
{
    // 20.10.2008. EDMS P2
    //   * Added function SyncronizePurchaseAmount
    // 
    // 17.10.2008. EDMS P2
    //   * Changed code ApplyTradeIn
    // 
    // 01.09.2008. EDMS P2
    //   * Added function InsertPurcahseLineEntry
    //   * Added code PostPurchaseEntry, ApplyTradeIn, InsertSalesLine
    // 
    // 23.05.2007. EDMS P2
    //   * Created functions
    //      PostPurchaseEntry(DocumentNo : Code[20];DocumentLine : Integer;DocumentType : Integer)
    //      PostSalesEntry(DocumentNo : Code[20];DocumentLine : Integer;DocumentType : Integer)


    trigger OnRun()
    begin
    end;

    var
        Text001: label 'This Purchase Line is already in Vehicle Trade-In Entries.';
        SalesSetup: Record "Sales & Receivables Setup";


    procedure PostPurchaseEntry(DocumentNo: Code[20]; DocumentLine: Integer; DocumentType: Integer; LinkTradeInEntry: Integer)
    var
        VehTradeInAppEntry: Record "Trade-In Application Entry";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchInvLine: Record "Purch. Inv. Line";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        EntryNo: Integer;
    begin
        //01.09.2008. EDMS P2 >>
        if not ((LinkTradeInEntry <> 0) and VehTradeInAppEntry.Get(LinkTradeInEntry)) then begin
            //01.09.2008. EDMS P2 <<
            VehTradeInAppEntry.Reset;
            if VehTradeInAppEntry.FindLast then
                EntryNo := VehTradeInAppEntry."Entry No."
            else
                EntryNo := 0;
            EntryNo += 1;

            VehTradeInAppEntry.Init;
            VehTradeInAppEntry."Entry No." := EntryNo;
            VehTradeInAppEntry."Entry Type" := VehTradeInAppEntry."entry type"::Purchase;
            VehTradeInAppEntry.Insert;
        end;
        if DocumentType = 1 then begin
            if PurchInvHeader.Get(DocumentNo) then
                if PurchInvLine.Get(DocumentNo, DocumentLine) then;
            VehTradeInAppEntry."Posting Date" := PurchInvHeader."Posting Date";
            VehTradeInAppEntry."Document Type" := VehTradeInAppEntry."document type"::Invoice;
            VehTradeInAppEntry."Document No." := DocumentNo;
            if PurchInvHeader."Currency Code" <> '' then
                VehTradeInAppEntry."Amount (LCY)" := ROUND(PurchInvLine.Amount / PurchInvHeader."Currency Factor", 0.01)
            else
                VehTradeInAppEntry."Amount (LCY)" := PurchInvLine.Amount;
            VehTradeInAppEntry."Amount (FCY)" := PurchInvLine.Amount;
            VehTradeInAppEntry."Currency Code" := PurchInvHeader."Currency Code";
            VehTradeInAppEntry."Vehicle Serial No." := PurchInvLine."Vehicle Serial No.";
            VehTradeInAppEntry."Vehicle Accounting Cycle No." := PurchInvLine."Vehicle Accounting Cycle No.";
        end
        else begin
            if PurchCrMemoHdr.Get(DocumentNo) then
                if PurchCrMemoLine.Get(DocumentNo, DocumentLine) then;
            VehTradeInAppEntry."Posting Date" := PurchCrMemoHdr."Posting Date";
            VehTradeInAppEntry."Document Type" := VehTradeInAppEntry."document type"::"Cr.Memo";
            VehTradeInAppEntry."Document No." := DocumentNo;
            if PurchCrMemoHdr."Currency Code" <> '' then
                VehTradeInAppEntry."Amount (LCY)" := -ROUND(PurchCrMemoLine.Amount / PurchCrMemoHdr."Currency Factor", 0.01)
            else
                VehTradeInAppEntry."Amount (LCY)" := -PurchCrMemoLine.Amount;
            VehTradeInAppEntry."Amount (FCY)" := -PurchCrMemoLine.Amount;
            VehTradeInAppEntry."Currency Code" := PurchCrMemoHdr."Currency Code";
            VehTradeInAppEntry."Vehicle Serial No." := PurchCrMemoLine."Vehicle Serial No.";
            VehTradeInAppEntry."Vehicle Accounting Cycle No." := PurchCrMemoLine."Vehicle Accounting Cycle No.";
        end;
        VehTradeInAppEntry.Modify;
    end;


    procedure InsertPurchaseLineEntry(DocumentNo: Code[20]; DocumentLine: Integer; DocumentType: Integer)
    var
        VehTradeInAppEntry: Record "Trade-In Application Entry";
        PurchaseHdr: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        PurchaseLineAmount: Decimal;
        EntryNo: Integer;
    begin
        if PurchaseHdr.Get(DocumentType, DocumentNo) then
            if PurchaseLine.Get(DocumentType, DocumentNo, DocumentLine) then;

        if PurchaseLine."Link Trade-In Entry" <> 0 then
            Error(Text001);

        VehTradeInAppEntry.Reset;
        if VehTradeInAppEntry.FindLast then
            EntryNo := VehTradeInAppEntry."Entry No."
        else
            EntryNo := 0;
        EntryNo += 1;

        VehTradeInAppEntry.Init;
        VehTradeInAppEntry."Entry No." := EntryNo;
        VehTradeInAppEntry."Entry Type" := VehTradeInAppEntry."entry type"::Purchase;
        VehTradeInAppEntry."Posting Date" := PurchaseHdr."Posting Date";
        if PurchaseHdr."Document Type" = PurchaseHdr."document type"::Order then
            VehTradeInAppEntry."Document Type" := VehTradeInAppEntry."document type"::Order
        else
            VehTradeInAppEntry."Document Type" := VehTradeInAppEntry."document type"::"Ret. Order";

        VehTradeInAppEntry."Document No." := DocumentNo;

        if PurchaseHdr."Prices Including VAT" then
            PurchaseLineAmount := PurchaseLine."Line Amount" / (1 + PurchaseLine."VAT %" / 100)
        else
            PurchaseLineAmount := PurchaseLine."Line Amount";

        if PurchaseHdr."Currency Code" <> '' then
            VehTradeInAppEntry."Amount (LCY)" := ROUND(PurchaseLineAmount / PurchaseHdr."Currency Factor", 0.01)
        else
            VehTradeInAppEntry."Amount (LCY)" := ROUND(PurchaseLineAmount, 0.01);

        VehTradeInAppEntry."Amount (FCY)" := ROUND(PurchaseLineAmount, 0.01);
        VehTradeInAppEntry."Currency Code" := PurchaseHdr."Currency Code";
        VehTradeInAppEntry."Vehicle Serial No." := PurchaseLine."Vehicle Serial No.";
        VehTradeInAppEntry."Vehicle Accounting Cycle No." := PurchaseLine."Vehicle Accounting Cycle No.";
        VehTradeInAppEntry.Insert;

        PurchaseLine."Link Trade-In Entry" := EntryNo;
        PurchaseLine.Modify;
    end;


    procedure SyncronizePurchaseAmount(PurchaseLine: Record "Purchase Line")
    var
        VehTradeInAppEntry: Record "Trade-In Application Entry";
        PurchaseHdr: Record "Purchase Header";
        PurchaseLineAmount: Decimal;
    begin
        if PurchaseLine."Link Trade-In Entry" = 0 then
            exit;

        PurchaseHdr.Get(PurchaseLine."Document Type", PurchaseLine."Document No.");

        if not VehTradeInAppEntry.Get(PurchaseLine."Link Trade-In Entry") then
            exit;

        if PurchaseHdr."Prices Including VAT" then
            PurchaseLineAmount := PurchaseLine."Line Amount" / (1 + PurchaseLine."VAT %" / 100)
        else
            PurchaseLineAmount := PurchaseLine."Line Amount";

        if PurchaseHdr."Currency Code" <> '' then
            VehTradeInAppEntry."Amount (LCY)" := ROUND(PurchaseLineAmount / PurchaseHdr."Currency Factor", 0.01)
        else
            VehTradeInAppEntry."Amount (LCY)" := ROUND(PurchaseLineAmount, 0.01);

        VehTradeInAppEntry."Amount (FCY)" := ROUND(PurchaseLineAmount, 0.01);
        VehTradeInAppEntry."Currency Code" := PurchaseHdr."Currency Code";
        VehTradeInAppEntry.Modify;
    end;


    procedure PostSalesEntry(DocumentNo: Code[20]; DocumentLine: Integer; DocumentType: Integer)
    var
        VehTradeInAppEntry: Record "Trade-In Application Entry";
        SalesInvHdr: Record "Sales Invoice Header";
        SalesInvLine: Record "Sales Invoice Line";
        SalesCrMemoHdr: Record "Sales Cr.Memo Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        EntryNo: Integer;
    begin
        VehTradeInAppEntry.Reset;
        if VehTradeInAppEntry.FindLast then
            EntryNo := VehTradeInAppEntry."Entry No."
        else
            EntryNo := 0;
        EntryNo += 1;

        VehTradeInAppEntry.Init;
        VehTradeInAppEntry."Entry No." := EntryNo;
        VehTradeInAppEntry."Entry Type" := VehTradeInAppEntry."entry type"::Sale;
        if DocumentType = 1 then begin
            if SalesInvHdr.Get(DocumentNo) then
                if SalesInvLine.Get(DocumentNo, DocumentLine) then;
            VehTradeInAppEntry."Posting Date" := SalesInvHdr."Posting Date";
            VehTradeInAppEntry."Document Type" := VehTradeInAppEntry."document type"::Invoice;
            VehTradeInAppEntry."Document No." := DocumentNo;
            if SalesInvHdr."Currency Code" <> '' then
                VehTradeInAppEntry."Amount (LCY)" := ROUND(SalesInvLine.Amount / SalesInvHdr."Currency Factor", 0.01)
            else
                VehTradeInAppEntry."Amount (LCY)" := SalesInvLine.Amount;
            VehTradeInAppEntry."Amount (FCY)" := SalesInvLine.Amount;
            VehTradeInAppEntry."Currency Code" := SalesInvHdr."Currency Code";
            VehTradeInAppEntry."Vehicle Serial No." := SalesInvLine."Vehicle Serial No.";
            VehTradeInAppEntry."Vehicle Accounting Cycle No." := SalesInvLine."Vehicle Accounting Cycle No.";
            VehTradeInAppEntry."Applies-to Vehicle Serial No." := SalesInvLine."Applies-to Veh. Serial No.";
            VehTradeInAppEntry."Applies-to Veh. Acc. Cycle No." := SalesInvLine."Applies-to Veh. Cycle No.";
        end
        else begin
            if SalesCrMemoHdr.Get(DocumentNo) then
                if SalesCrMemoLine.Get(DocumentNo, DocumentLine) then;
            VehTradeInAppEntry."Posting Date" := SalesCrMemoHdr."Posting Date";
            VehTradeInAppEntry."Document Type" := VehTradeInAppEntry."document type"::"Cr.Memo";
            VehTradeInAppEntry."Document No." := DocumentNo;
            if SalesCrMemoHdr."Currency Code" <> '' then
                VehTradeInAppEntry."Amount (LCY)" := -ROUND(SalesCrMemoLine.Amount / SalesCrMemoHdr."Currency Factor", 0.01)
            else
                VehTradeInAppEntry."Amount (LCY)" := -SalesCrMemoLine.Amount;
            VehTradeInAppEntry."Amount (FCY)" := -SalesCrMemoLine.Amount;
            VehTradeInAppEntry."Currency Code" := SalesCrMemoHdr."Currency Code";
            VehTradeInAppEntry."Vehicle Serial No." := SalesCrMemoLine."Vehicle Serial No.";
            VehTradeInAppEntry."Vehicle Accounting Cycle No." := SalesCrMemoLine."Vehicle Accounting Cycle No.";
            VehTradeInAppEntry."Applies-to Vehicle Serial No." := SalesCrMemoLine."Applies-to Veh. Serial No.";
            VehTradeInAppEntry."Applies-to Veh. Acc. Cycle No." := SalesCrMemoLine."Applies-to Veh. Cycle No.";
        end;
        VehTradeInAppEntry.Insert;
    end;


    procedure ApplyTradeIn(var SalesLine: Record "Sales Line")
    var
        VehTradeInApp: Record "Trade-In Application Entry";
        TradeInType: Option TradeIn,Interdepartament;
        TradeInAmount: Decimal;
        InterdepartAmount: Decimal;
        VehTradeIn: Page "Veh.Trade-In App.Entries";
        VehTradeInAppPurchase: Page "Veh.Trade-In Apply to Purchase";
    begin
        Clear(VehTradeIn);
        VehTradeIn.LookupMode(true);
        if VehTradeIn.RunModal = Action::LookupOK then begin
            VehTradeIn.GetRecord(VehTradeInApp);
            VehTradeInAppPurchase.SetVariables(VehTradeInApp, SalesLine);
            if VehTradeInAppPurchase.RunModal = Action::OK then begin
                TradeInAmount := VehTradeInAppPurchase.GetTradeInAmount;
                if TradeInAmount <> 0 then
                    InsertSalesLine(SalesLine, VehTradeInApp, TradeInAmount, Tradeintype::TradeIn);
            end;
        end;
    end;


    procedure InsertSalesLine(SalesLine: Record "Sales Line"; VehTradeInApp: Record "Trade-In Application Entry"; TradeInAmount: Decimal; TradeInType: Option TradeIn,Interdepartement)
    var
        SalesLine2: Record "Sales Line";
        SalesHdr: Record "Sales Header";
        SalesSetup: Record "Sales & Receivables Setup";
        Currency: Record Currency;
        Vehicle: Record Vehicle;
        Item: Record Item;
        SalesAmount: Decimal;
        LineNo: Integer;
    begin
        SalesSetup.Get;
        if SalesHdr.Get(SalesLine."Document Type", SalesLine."Document No.") then;  //19.07.2013 EDMS P8
        if SalesHdr."Currency Code" = '' then
            Currency.InitRoundingPrecision
        else
            Currency.Get(SalesHdr."Currency Code");


        if SalesHdr."Currency Code" <> '' then
            SalesAmount := TradeInAmount * SalesHdr."Currency Factor"
        else
            SalesAmount := TradeInAmount;

        if SalesHdr."Prices Including VAT" then begin
            SalesAmount := ROUND(SalesAmount * (1 + (SalesLine."VAT %" / 100)),
              Currency."Unit-Amount Rounding Precision");
        end;

        SalesLine2.Reset;
        SalesLine2.SetRange("Document Type", SalesLine."Document Type");
        SalesLine2.SetRange("Document No.", SalesLine."Document No.");
        SalesLine2.FindLast;
        LineNo := SalesLine2."Line No." + 10000;

        SalesLine2.Init;
        SalesLine2.Validate("Document Type", SalesLine."Document Type");
        SalesLine2.Validate("Document No.", SalesLine."Document No.");
        SalesLine2.Validate("Line No.", LineNo);
        SalesLine2.Insert;
        SalesLine2.Type := SalesLine2.Type::"G/L Account";
        SalesLine2."Line Type" := SalesLine2."line type"::"G/L Account";
        if TradeInType = Tradeintype::TradeIn then begin
            SalesLine2."No." := SalesSetup."Trade-In Sales Account No.";
            SalesLine2."Vehicle Trade-In Line" := true;
        end;

        SalesLine2.Validate(Description, SalesLine.Description);
        SalesLine2.Validate("Location Code", SalesLine."Location Code");
        SalesLine2.Validate("VAT Prod. Posting Group", SalesLine."VAT Prod. Posting Group");
        SalesLine2.Validate("VAT Bus. Posting Group", SalesLine."VAT Bus. Posting Group");
        SalesLine2.Validate("Gen. Prod. Posting Group", SalesLine."Gen. Prod. Posting Group");
        SalesLine2.Validate("Gen. Bus. Posting Group", SalesLine."Gen. Bus. Posting Group");
        SalesLine2.Validate(Quantity, -1);
        SalesLine2.Validate("Unit Price", SalesAmount);

        Vehicle.Get(VehTradeInApp."Vehicle Serial No.");
        SalesLine2.Validate("Make Code", Vehicle."Make Code");
        SalesLine2.Validate("Model Code", Vehicle."Model Code");
        SalesLine2.Validate("Model Version No.", Vehicle."Model Version No.");
        SalesLine2.Validate("Vehicle Serial No.", VehTradeInApp."Vehicle Serial No.");
        SalesLine2.Validate("Vehicle Status Code", Vehicle."Status Code");
        SalesLine2.Validate("Vehicle Accounting Cycle No.", VehTradeInApp."Vehicle Accounting Cycle No.");
        if Item.Get(Vehicle."Model Version No.") then
            SalesLine2.Validate(Description, Item.Description);

        SalesLine2.Validate("Vehicle Assembly ID", SalesLine."Vehicle Assembly ID");
        SalesLine2."Applies-to Veh. Serial No." := VehTradeInApp."Vehicle Serial No.";
        SalesLine2."Applies-to Veh. Cycle No." := VehTradeInApp."Vehicle Accounting Cycle No.";
        SalesLine2.Modify;
    end;
}

