Codeunit 25006132 "Service WIP Management"
{

    trigger OnRun()
    begin
    end;

    var
        ServWIPMngt: Record "Vehicle Service Plan Stage";
        TmpWIPEntry: Record "Service WIP Entry" temporary;
        GenJnPostLine: Codeunit "Gen. Jnl.-Post Line";
        TEXT01: label 'Do You want to delete calculated WIP for Service Order %1 ?';


    procedure ReCalcWIP2(WIPServiceOrderHeader: Record "Service Order WIP Header")
    var
        WIPServiceOrderLine: Record "Service Order WIP Line";
        ServiceWIPSetup: Record "Service WIP Setup";
        ResourceCost: Decimal;
        UnitCost: Decimal;
        ReservQty: Decimal;
        FinishedQty: Decimal;
    begin
        ServiceWIPSetup.Get;
        WIPServiceOrderLine.Reset;
        WIPServiceOrderLine.SetRange("Service Order No.", WIPServiceOrderHeader."Service Order No.");
        if WIPServiceOrderLine.Find('-') then
            repeat
                case WIPServiceOrderLine.Type of
                    WIPServiceOrderLine.Type::Item:
                        begin
                            CalcTransferedQtyOnDate(WIPServiceOrderHeader."Service Order No.", WIPServiceOrderLine."Service Order Line No.", WIPServiceOrderHeader."WIP Date", WIPServiceOrderLine."Unit Cost", ReservQty);
                            WIPServiceOrderLine.Validate("Recognized Cost Qty.", ReservQty);
                            WIPServiceOrderLine.Validate("Recognized Sales Qty.", ReservQty);
                        end;

                    WIPServiceOrderLine.Type::Labor:
                        begin
                            ResourceCost := ServiceWIPSetup."Default Resource Unit Cost";
                            CalcFinishedLaborOnDate(WIPServiceOrderHeader."Service Order No.", WIPServiceOrderLine."Service Order Line No.", WIPServiceOrderHeader."WIP Date", ResourceCost, FinishedQty);
                            WIPServiceOrderLine."Unit Cost" := ResourceCost;
                            WIPServiceOrderLine.Validate("Recognized Cost Qty.", FinishedQty);
                            if WIPServiceOrderLine.Finished then
                                WIPServiceOrderLine.Validate("Recognized Sales Qty.", WIPServiceOrderLine.Quantity);
                        end;

                    WIPServiceOrderLine.Type::"External Service":
                        begin
                            CalcFinishedExtServOnDate(WIPServiceOrderLine."No.", WIPServiceOrderHeader."WIP Date", WIPServiceOrderLine."External Serv. Tracking No.", WIPServiceOrderLine."Unit Cost", WIPServiceOrderLine."Finished Qty.");
                            WIPServiceOrderLine.Validate("Recognized Cost Qty.", WIPServiceOrderLine."Finished Qty.");
                            WIPServiceOrderLine.Validate("Recognized Sales Qty.", WIPServiceOrderLine."Finished Qty.");
                        end;
                end;
                WIPServiceOrderLine.Modify;
            until WIPServiceOrderLine.Next = 0;
    end;


    procedure ReCalcWIP(WIPServiceOrderHeader: Record "Service Order WIP Header")
    var
        WIPServiceOrderLine: Record "Service Order WIP Line";
        ServiceWIPSetup: Record "Service WIP Setup";
        ResourceCost: Decimal;
        UnitCost: Decimal;
        ReservQty: Decimal;
        FinishedQty: Decimal;
    begin
        ServiceWIPSetup.Get;
        WIPServiceOrderLine.Reset;
        WIPServiceOrderLine.SetRange("Service Order No.", WIPServiceOrderHeader."Service Order No.");
        if WIPServiceOrderLine.Find('-') then
            repeat
                WIPServiceOrderLine.Validate("Recognized Cost Qty.", WIPServiceOrderLine."Recognized Cost Qty. (Calc)");
                WIPServiceOrderLine.Validate("Recognized Sales Qty.", WIPServiceOrderLine."Recognized Sales Qty. (Calc)");
                WIPServiceOrderLine.Modify;
            until WIPServiceOrderLine.Next = 0;
    end;


    procedure CalcWIP(ServiceHeader: Record "Service Header EDMS"; DocumentNo: Code[20]; WIPDate: Date; DeleteCalculated: Boolean)
    var
        WIPServiceOrderHeader: Record "Service Order WIP Header";
        WIPServiceOrderLine: Record "Service Order WIP Line";
        ServiceWIPSetup: Record "Service WIP Setup";
        ServiceLine: Record "Service Line EDMS";
        ServiceWorkStatusEDMS: Record "Service Work Status EDMS";
        Item: Record Item;
        Resource: Record Resource;
        FinishedCost: Decimal;
        ResourceCost: Decimal;
        FinishedQty: Decimal;
        NoSeries: Code[20];
        NoSeriesMgt: Codeunit "No. Series";
        LaborFinishPercentage: Decimal;
    begin
        WIPServiceOrderHeader.Reset;
        WIPServiceOrderHeader.SetRange("Service Order No.", ServiceHeader."No.");
        if WIPServiceOrderHeader.FindFirst then begin
            if DeleteCalculated then
                WIPServiceOrderHeader.Delete(true)
            else
                exit;
        end;

        ServiceWIPSetup.Get;
        WIPServiceOrderHeader.Init;
        //IF DocumentNo = '' THEN
        //  NoSeriesMgt.InitSeries(ServiceWIPSetup."WIP Document No. Series",NoSeries,WIPDate,WIPServiceOrderHeader."WIP Document No.",NoSeries)
        //ELSE
        //  WIPServiceOrderHeader."WIP Document No." := DocumentNo;

        WIPServiceOrderHeader."WIP Date" := WIPDate;
        WIPServiceOrderHeader."Service Order No." := ServiceHeader."No.";
        WIPServiceOrderHeader."Service Order Date" := ServiceHeader."Document Date";
        WIPServiceOrderHeader."Sell-to Customer No." := ServiceHeader."Sell-to Customer No.";
        WIPServiceOrderHeader."Sell-to Customer Name" := ServiceHeader."Sell-to Customer Name";
        WIPServiceOrderHeader."Gen. Bus. Posting Group" := ServiceHeader."Gen. Bus. Posting Group";
        WIPServiceOrderHeader."Currency Code" := ServiceHeader."Currency Code";
        WIPServiceOrderHeader."Currency Factor" := ServiceHeader."Currency Factor";
        WIPServiceOrderHeader."Prices Including VAT" := ServiceHeader."Prices Including VAT";
        WIPServiceOrderHeader."Vehicle Registration No." := ServiceHeader."Vehicle Registration No.";
        WIPServiceOrderHeader."Make Code" := ServiceHeader."Make Code";
        WIPServiceOrderHeader."Model Code" := ServiceHeader."Model Code";
        WIPServiceOrderHeader."Vehicle Serial No." := ServiceHeader."Vehicle Serial No.";
        WIPServiceOrderHeader."Vehicle Accounting Cycle No." := ServiceHeader."Vehicle Accounting Cycle No.";
        WIPServiceOrderHeader.Insert;

        WIPServiceOrderLine.Reset;
        WIPServiceOrderLine.SetRange("Service Order No.", ServiceHeader."No.");
        WIPServiceOrderLine.DeleteAll;
        ServiceLine.Reset;
        ServiceLine.SetRange("Document No.", ServiceHeader."No.");
        ServiceLine.SetFilter(Type, '%1|%2|%3', 2, 3, 4);
        if ServiceLine.Find('-') then
            repeat
                WIPServiceOrderLine.Init;
                WIPServiceOrderLine."Service Order No." := ServiceHeader."No.";
                WIPServiceOrderLine."Service Order Line No." := ServiceLine."Line No.";
                //"WIP Date" := WIPServiceOrderHeader."WIP Date";
                WIPServiceOrderLine."WIP Method" := ServiceWIPSetup."WIP Method";
                WIPServiceOrderLine."Service Order Date." := ServiceHeader."Order Date";
                WIPServiceOrderLine."Sell-to Customer No." := ServiceHeader."Sell-to Customer No.";
                WIPServiceOrderLine."Sell-to Customer Name" := ServiceHeader."Sell-to Customer Name";

                WIPServiceOrderLine."No." := ServiceLine."No.";
                WIPServiceOrderLine.Description := ServiceLine.Description;
                WIPServiceOrderLine."Gen. Prod. Posting Group" := ServiceLine."Gen. Prod. Posting Group";
                WIPServiceOrderLine."Gen. Bus. Posting Group" := ServiceHeader."Gen. Bus. Posting Group";
                WIPServiceOrderLine."Unit of Measure Code" := ServiceLine."Unit of Measure Code";
                WIPServiceOrderLine."Dimension Set ID" := ServiceLine."Dimension Set ID";
                WIPServiceOrderLine.Quantity := ServiceLine.Quantity;
                WIPServiceOrderLine."VAT %" := ServiceLine."VAT %";
                WIPServiceOrderLine."Line Discount %" := ServiceLine."Line Discount %";

                if ServiceLine.Status <> '' then
                    ServiceWorkStatusEDMS.Get(ServiceLine.Status);

                if ServiceWorkStatusEDMS."Service Order Status" = ServiceWorkStatusEDMS."service order status"::Finished then
                    WIPServiceOrderLine.Finished := true;

                if (WIPServiceOrderHeader."Currency Code" <> '') and (WIPServiceOrderHeader."Currency Factor" <> 0) then
                    WIPServiceOrderLine."Unit Price (LCY)" := ServiceLine."Unit Price" / WIPServiceOrderHeader."Currency Factor"
                else
                    WIPServiceOrderLine."Unit Price (LCY)" := ServiceLine."Unit Price";

                if WIPServiceOrderHeader."Prices Including VAT" then
                    WIPServiceOrderLine."Unit Price (LCY)" := ROUND(WIPServiceOrderLine."Unit Price (LCY)" / ((100 + WIPServiceOrderLine."VAT %") / 100), 0.00001);

                if WIPServiceOrderLine."Line Discount %" <> 0 then
                    WIPServiceOrderLine."Unit Price (LCY)" := ROUND(WIPServiceOrderLine."Unit Price (LCY)" * ((100 - WIPServiceOrderLine."Line Discount %") / 100), 0.00001);

                case ServiceLine.Type of
                    ServiceLine.Type::Item:
                        begin
                            WIPServiceOrderLine.Type := WIPServiceOrderLine.Type::Item;
                            CalcTransferedQtyOnDate(ServiceHeader."No.", ServiceLine."Line No.", WIPServiceOrderHeader."WIP Date", WIPServiceOrderLine."Unit Cost", WIPServiceOrderLine."Finished Qty.");
                            WIPServiceOrderLine.Validate("Recognized Cost Qty.", WIPServiceOrderLine."Finished Qty.");
                            WIPServiceOrderLine.Validate("Recognized Sales Qty.", WIPServiceOrderLine."Finished Qty.");
                            if WIPServiceOrderLine."Finished Qty." = WIPServiceOrderLine.Quantity then
                                WIPServiceOrderLine.Finished := true;
                        end;
                    ServiceLine.Type::Labor:
                        begin
                            LaborFinishPercentage := 0;
                            WIPServiceOrderLine.Type := WIPServiceOrderLine.Type::Labor;
                            ResourceCost := ServiceWIPSetup."Default Resource Unit Cost";
                            CalcFinishedLaborOnDate(ServiceHeader."No.", ServiceLine."Line No.", WIPServiceOrderHeader."WIP Date", ResourceCost, FinishedQty);
                            WIPServiceOrderLine."Unit Cost" := ResourceCost;
                            WIPServiceOrderLine.Validate("Recognized Cost Qty.", FinishedQty);

                            if WIPServiceOrderLine.Finished then
                                WIPServiceOrderLine.Validate("Recognized Sales Qty.", WIPServiceOrderLine.Quantity)
                            else begin
                                if WIPServiceOrderLine.Quantity <> 0 then
                                    LaborFinishPercentage := FinishedQty / WIPServiceOrderLine.Quantity;
                                if LaborFinishPercentage > 1 then
                                    LaborFinishPercentage := 1;
                                WIPServiceOrderLine.Validate("Recognized Sales Qty.", ROUND(WIPServiceOrderLine.Quantity * LaborFinishPercentage, 0.01));
                            end;
                        end;
                    ServiceLine.Type::"External Service":
                        begin
                            WIPServiceOrderLine.Type := WIPServiceOrderLine.Type::"External Service";
                            CalcFinishedExtServOnDate(WIPServiceOrderLine."No.", WIPServiceOrderHeader."WIP Date", WIPServiceOrderLine."External Serv. Tracking No.", WIPServiceOrderLine."Unit Cost", WIPServiceOrderLine."Finished Qty.");
                            WIPServiceOrderLine.Validate("Recognized Cost Qty.", WIPServiceOrderLine."Finished Qty.");
                            WIPServiceOrderLine.Validate("Recognized Sales Qty.", WIPServiceOrderLine."Finished Qty.");
                            if WIPServiceOrderLine."Finished Qty." > 0 then
                                WIPServiceOrderLine.Finished := true;
                        end;
                end;
                WIPServiceOrderLine."Recognized Cost Qty. (Calc)" := WIPServiceOrderLine."Recognized Cost Qty.";
                WIPServiceOrderLine."Recognized Sales Qty. (Calc)" := WIPServiceOrderLine."Recognized Sales Qty.";
                WIPServiceOrderLine.Amount := ROUND(WIPServiceOrderLine.Quantity * WIPServiceOrderLine."Unit Price");
                WIPServiceOrderLine.Insert;

            until ServiceLine.Next = 0;
    end;


    procedure CheckWIPGLAcc(AccNo: Code[20])
    var
        GLAcc: Record "G/L Account";
    begin
        GLAcc.Get(AccNo);
        GLAcc.CheckGLAcc;
        GLAcc.TestField("Gen. Posting Type", GLAcc."gen. posting type"::" ");
        GLAcc.TestField("Gen. Bus. Posting Group", '');
        GLAcc.TestField("Gen. Prod. Posting Group", '');
        GLAcc.TestField("VAT Bus. Posting Group", '');
        GLAcc.TestField("VAT Prod. Posting Group", '');
    end;


    procedure PostWIPLine(TmpWIPEntry: Record "Service WIP Entry" temporary; Reversed: Boolean) GLEntryPosted: Integer
    var
        GLAmount: Decimal;
        SorceCodeSetup: Record "Source Code Setup";
    begin
        SorceCodeSetup.Get;

        CheckWIPGLAcc(TmpWIPEntry."G/L Account No.");
        CheckWIPGLAcc(TmpWIPEntry."G/L Bal. Account No.");
        GLAmount := TmpWIPEntry."WIP Entry Amount";
        if Reversed then
            GLAmount := -GLAmount;

        GLEntryPosted := InsertWIPGL(TmpWIPEntry."G/L Account No.", TmpWIPEntry."G/L Bal. Account No.", TmpWIPEntry."Document No.", TmpWIPEntry."Posting Date",
            SorceCodeSetup."Service G/L WIP EDMS", GLAmount, TmpWIPEntry.Description, TmpWIPEntry."Dimension Set ID",
            TmpWIPEntry."Vehicle Accounting Cycle No.", TmpWIPEntry."Vehicle Serial No.");
    end;


    procedure InsertWIPGL(GLAccountNo: Code[20]; BalGLAccountNo: Code[20]; WIPDocNo: Code[20]; PostingDate: Date; SourceCode: Code[10]; GLAmount: Decimal; Description: Text[50]; DimSetID: Integer; VehAccCycleNo: Code[20]; VehicleSerialNo: Code[20]) GLEntryPosted: Integer
    var
        GLAcc: Record "G/L Account";
        GenJnlLine: Record "Gen. Journal Line";
        DimMgt: Codeunit DimensionManagement;
        GLReg: Record "G/L Register";
        WIPGLLink: Record "Service WIP - G/L Link";
        GLEntry: Record "G/L Entry";
        n: Integer;
    begin
        GLAcc.Get(GLAccountNo);
        GenJnlLine.Init;
        GenJnlLine."Posting Date" := PostingDate;
        GenJnlLine."Account No." := GLAccountNo;
        GenJnlLine."Bal. Account No." := BalGLAccountNo;
        GenJnlLine.Amount := GLAmount;
        GenJnlLine."Document No." := WIPDocNo;
        GenJnlLine."Source Code" := SourceCode;
        GenJnlLine.Description := GenJnlLine.Description;
        GenJnlLine."System-Created Entry" := true;
        GenJnlLine."Dimension Set ID" := DimSetID;
        //  "Vehicle Serial No." := VehicleSerialNo;
        //  "Vehicle Accounting Cycle No." := VehAccCycleNo;
        Clear(DimMgt);
        DimMgt.UpdateGlobalDimFromDimSetID(GenJnlLine."Dimension Set ID", GenJnlLine."Shortcut Dimension 1 Code",
          GenJnlLine."Shortcut Dimension 2 Code");
        GLEntryPosted := GenJnPostLine.RunWithCheck(GenJnlLine);

        //GenJnPostLine.GetGLReg(GLReg);
        //GLEntry.RESET;
        //GLEntry.SETFILTER("Entry No.", '%1..%2', GLReg."From Entry No.", GLReg."To Entry No.");
        //IF GLEntry.FIND('-') THEN REPEAT
        //  n += 1;   // only for test. Must remove
        //  WIPGLLink.INIT;
        //  WIPGLLink."G/L Register No." := GLReg."No.";
        //  WIPGLLink."G/L Entry No." := GLEntry."Entry No.";
        //  WIPGLLink."WIP Entry No." := n;
        //  WIPGLLink.INSERT;
        //UNTIL GLEntry.NEXT = 0;
    end;


    procedure CalcTransferedQtyOnDate(ServiceHeaderNo: Code[20]; ServiceLineNo: Integer; WIPCalcDate: Date; var UnitCost: Decimal; var ReservQty: Decimal)
    var
        ReservationEntry: Record "Reservation Entry";
        ReservationEntry2: Record "Reservation Entry";
        ItemLedgEntry: Record "Item Ledger Entry";
        TotalCost: Decimal;
    begin
        ReservQty := 0;
        UnitCost := 0;
        ReservationEntry.Reset;
        ReservationEntry.SetRange("Source Type", 25006146);
        ReservationEntry.SetRange("Source ID", ServiceHeaderNo);
        ReservationEntry.SetRange("Source Ref. No.", ServiceLineNo);
        ReservationEntry.SetRange("Reservation Status", ReservationEntry."reservation status"::Reservation);
        if ReservationEntry.Find('-') then
            repeat
                ReservationEntry2.Get(ReservationEntry."Entry No.", true);
                if ReservationEntry2."Source Type" = 32 then begin
                    ItemLedgEntry.Get(ReservationEntry2."Source Ref. No.");
                    if ItemLedgEntry."Posting Date" <= WIPCalcDate then begin
                        ReservQty += ReservationEntry2."Quantity (Base)";
                        if ItemLedgEntry.Quantity <> 0 then begin
                            ItemLedgEntry.CalcFields("Cost Amount (Actual)");
                            TotalCost += ReservationEntry2."Quantity (Base)" * (ItemLedgEntry."Cost Amount (Actual)" / ItemLedgEntry.Quantity);
                        end;
                    end;
                end;
            until ReservationEntry.Next = 0;
        if ReservQty <> 0 then
            UnitCost := ROUND(TotalCost / ReservQty, 0.01);                   // ROUNDING precision ? 0.00001
    end;


    procedure CalcFinishedLaborOnDate(ServiceHeaderNo: Code[20]; ServiceLineNo: Integer; WIPCalcDate: Date; var UnitCost: Decimal; var FinishedQty: Decimal)
    var
        ServLaborAllocApplication: Record "Serv. Labor Alloc. Application";
        ServLaborAllocEntry: Record "Serv. Labor Allocation Entry";
        DatetimeMgt: Codeunit "Datetime Mgt.";
        ResourceCost: Decimal;
        FinishedCost: Decimal;
        Resource: Record Resource;
    begin
        FinishedCost := 0;
        FinishedQty := 0;
        ServLaborAllocApplication.Reset;
        ServLaborAllocApplication.SetRange("Document Type", ServLaborAllocApplication."document type"::Order);
        ServLaborAllocApplication.SetRange("Document No.", ServiceHeaderNo);
        ServLaborAllocApplication.SetRange("Document Line No.", ServiceLineNo);
        if ServLaborAllocApplication.Find('-') then
            repeat
                if ServLaborAllocApplication."Finished Quantity (Hours)" <> 0 then begin
                    if ServLaborAllocApplication."Allocation Entry No." <> 0 then begin
                        ServLaborAllocEntry.Get(ServLaborAllocApplication."Allocation Entry No.");
                        if DatetimeMgt.Datetime2Date(ServLaborAllocEntry."End Date-Time") <= WIPCalcDate then
                            FinishedQty += ServLaborAllocApplication."Finished Quantity (Hours)";
                    end else
                        FinishedQty += ServLaborAllocApplication."Finished Quantity (Hours)";
                    Resource.Get(ServLaborAllocApplication."Resource No.");
                    ResourceCost := UnitCost;
                    if Resource."Unit Cost" <> 0 then
                        ResourceCost := Resource."Unit Cost";
                    FinishedCost += ServLaborAllocApplication."Finished Quantity (Hours)" * ResourceCost;
                end;
            until ServLaborAllocApplication.Next = 0;
        if FinishedQty <> 0 then
            UnitCost := ROUND(FinishedCost / FinishedQty, 0.01);             // ROUNDING precision ? 0.00001

        FinishedQty := ROUND(FinishedQty, 0.01);                          // ROUNDING precision ? 0.01
    end;


    procedure CalcFinishedExtServOnDate(ExtServiceNo: Code[20]; WIPCalcDate: Date; ExternalServTrackingNo: Code[10]; var UnitCost: Decimal; var FinishedQty: Decimal)
    var
        ExternalService: Record "External Service";
        ExternalServLedgEntry: Record "External Serv. Ledger Entry";
    begin
        UnitCost := 0;
        FinishedQty := 0;
        ExternalService.Get(ExtServiceNo);
        ExternalServLedgEntry.Reset;
        ExternalServLedgEntry.SetCurrentkey("External Serv. No.", "External Serv. Tracking No.", "Entry Type");
        ExternalServLedgEntry.SetRange("External Serv. No.", ExternalService."No.");
        ExternalServLedgEntry.SetRange("Entry Type", ExternalServLedgEntry."entry type"::Purchase);
        ExternalServLedgEntry.SetRange("External Serv. Tracking No.", ExternalServTrackingNo);
        ExternalServLedgEntry.SetFilter("Posting Date", '..%1', WIPCalcDate);
        ExternalServLedgEntry.CalcSums(Amount);
        UnitCost := ExternalServLedgEntry.Amount;
        if UnitCost <> 0 then
            FinishedQty := 1;
    end;


    procedure PostWIP(var WIPServiceOrderHeader: Record "Service Order WIP Header"; PostingDate: Date; Consolidated: Boolean; ReverseDocumentNo: Code[20]; ReversePostingDate: Date)
    var
        WIPServiceOrderLine: Record "Service Order WIP Line";
        GeneralPostingSetup: Record "General Posting Setup";
        EntryNo: Integer;
        TmpEntryNo: Integer;
        WIPTransactionNo: Integer;
        WIPTotals: Record "Service WIP Total";
        NoSeriesMgt: Codeunit "No. Series";
        ServiceWIPSetup: Record "Service WIP Setup";
        NoSeries: Code[10];
    begin
        //-------- Post reverse WIP

        WIPTotals.Reset;
        WIPTotals.SetRange("Service Order No.", WIPServiceOrderHeader."Service Order No.");
        WIPTotals.SetRange(Reversed, false);
        if WIPTotals.FindFirst then
            PostReverseWIP(WIPTotals."Document No.", ReverseDocumentNo, ReversePostingDate);

        //-------- Post WIP

        ServiceWIPSetup.Get;
        NoSeries := ServiceWIPSetup."WIP Document No. Series";
        WIPServiceOrderHeader."WIP Document No." := NoSeriesMgt.GetNextNo(NoSeries, PostingDate);
        Clear(TmpWIPEntry);
        WIPServiceOrderLine.Reset;
        WIPServiceOrderLine.SetRange("Service Order No.", WIPServiceOrderHeader."Service Order No.");
        if WIPServiceOrderLine.Find('-') then
            repeat
                GeneralPostingSetup.Get(WIPServiceOrderLine."Gen. Bus. Posting Group", WIPServiceOrderLine."Gen. Prod. Posting Group");


                if WIPServiceOrderLine."WIP Method" = WIPServiceOrderLine."wip method"::"Sales Method" then begin
                    GeneralPostingSetup.TestField("WIP Cost Adjustment Acc.");
                    GeneralPostingSetup.TestField("WIP Accured Cost Acc.");
                    InsertWIPEntry(WIPServiceOrderHeader."WIP Document No.", WIPServiceOrderLine, GeneralPostingSetup."WIP Cost Adjustment Acc.", GeneralPostingSetup."WIP Accured Cost Acc.",
                                        PostingDate, TmpWIPEntry."entry type"::"Accrued Costs", Consolidated, WIPServiceOrderLine."Recognized Cost Amount",
                                        WIPServiceOrderHeader."Vehicle Serial No.", WIPServiceOrderHeader."Vehicle Accounting Cycle No.");
                    GeneralPostingSetup.TestField("WIP Accured Sales Acc.");
                    GeneralPostingSetup.TestField("WIP Sales Adjusment Acc.");
                    InsertWIPEntry(WIPServiceOrderHeader."WIP Document No.", WIPServiceOrderLine, GeneralPostingSetup."WIP Accured Sales Acc.", GeneralPostingSetup."WIP Sales Adjusment Acc.",
                                        PostingDate, TmpWIPEntry."entry type"::"Accrued Sales", Consolidated, WIPServiceOrderLine."Recognized Sales Amount",
                                        WIPServiceOrderHeader."Vehicle Serial No.", WIPServiceOrderHeader."Vehicle Accounting Cycle No.");

                end else
                    if WIPServiceOrderLine."WIP Method" = WIPServiceOrderLine."wip method"::"Cost Method" then begin
                        GeneralPostingSetup.TestField("WIP Accured Cost Acc.");
                        GeneralPostingSetup.TestField("WIP Cost Adjustment Acc.");
                        InsertWIPEntry(WIPServiceOrderHeader."WIP Document No.", WIPServiceOrderLine, GeneralPostingSetup."WIP Accured Cost Acc.", GeneralPostingSetup."WIP Cost Adjustment Acc.",
                                            PostingDate, TmpWIPEntry."entry type"::"Accrued Costs", Consolidated, WIPServiceOrderLine."Recognized Cost Amount",
                                            WIPServiceOrderHeader."Vehicle Serial No.", WIPServiceOrderHeader."Vehicle Accounting Cycle No.");
                    end;
                InsertPostedWIPServLine(WIPServiceOrderHeader."WIP Document No.", WIPServiceOrderLine);

            until WIPServiceOrderLine.Next = 0;

        TmpWIPEntry.Reset;
        if TmpWIPEntry.Find('-') then
            repeat
                if TmpWIPEntry."WIP Entry Amount" <> 0 then begin
                    PostWIPLine(TmpWIPEntry, false);
                    WIPTotals.Reset;
                    if WIPTotals.FindLast then
                        EntryNo := WIPTotals."Entry No.";
                    WIPTotals.SetRange("Document No.", WIPServiceOrderHeader."WIP Document No.");                // ?
                    WIPTotals.SetRange("Service Order No.", WIPServiceOrderHeader."Service Order No.");          // ?
                    if not WIPTotals.FindFirst then begin
                        WIPTotals.Init;
                        WIPTotals."Entry No." := EntryNo + 1;
                        WIPTotals."Document No." := TmpWIPEntry."Document No.";                                      // WIP Document No.
                        WIPTotals."Posting Date" := TmpWIPEntry."Posting Date";
                        WIPTotals."Service Order No." := WIPServiceOrderHeader."Service Order No.";
                        WIPTotals.Consolidated := Consolidated;
                        WIPTotals.Insert;
                    end;
                end;
            until TmpWIPEntry.Next = 0;

        WIPServiceOrderHeader.Delete(true);
    end;


    procedure PostReverseWIP(WIPDocumentNo: Code[20]; ReverseDocumentNo: Code[20]; ReversePostingDate: Date)
    var
        WIPTotal: Record "Service WIP Total";
        WIPEntry: Record "Service WIP Entry";
        Consolidated: Boolean;
        TmpWIPEntry: Record "Service WIP Entry" temporary;
        TmpEntryNo: Integer;
        NoSeries: Code[20];
        NoSeriesMgt: Codeunit "No. Series";
        ServiceWIPSetup: Record "Service WIP Setup";
        PostedOK: Boolean;
        GLEntryPosted: Integer;
    begin
        Clear(TmpWIPEntry);
        WIPTotal.Reset;
        WIPTotal.SetRange("Document No.", WIPDocumentNo);                          // must Find by WIPTotal Entry No
        if WIPTotal.FindFirst then
            Consolidated := WIPTotal.Consolidated;

        ServiceWIPSetup.Get;
        if ReverseDocumentNo = '' then begin
            NoSeries := ServiceWIPSetup."WIP Document No. Series";
            ReverseDocumentNo := NoSeriesMgt.GetNextNo(NoSeries, ReversePostingDate);
        end;

        WIPEntry.Reset;
        WIPEntry.SetRange("Document No.", WIPDocumentNo);
        if WIPEntry.Find('-') then
            repeat
                //--------- Consolidate Postings >>
                TmpWIPEntry.Reset;
                TmpWIPEntry.SetRange("Document No.", ReverseDocumentNo);
                TmpWIPEntry.SetRange("Service Order No.", WIPEntry."Service Order No.");
                TmpWIPEntry.SetRange("G/L Account No.", WIPEntry."G/L Account No.");
                TmpWIPEntry.SetRange("G/L Bal. Account No.", WIPEntry."G/L Bal. Account No.");
                TmpWIPEntry.SetRange("Posting Date", ReversePostingDate);
                TmpWIPEntry.SetRange("Gen. Bus. Posting Group", WIPEntry."Gen. Bus. Posting Group");
                TmpWIPEntry.SetRange("Gen. Prod. Posting Group", WIPEntry."Gen. Prod. Posting Group");
                TmpWIPEntry.SetRange("Entry Type", WIPEntry."Entry Type");
                TmpWIPEntry.SetRange("WIP Method", WIPEntry."WIP Method");
                TmpWIPEntry.SetRange("Dimension Set ID", WIPEntry."Dimension Set ID");
                if TmpWIPEntry.Find('-') and Consolidated then begin
                    TmpWIPEntry."WIP Entry Amount" += WIPEntry."WIP Entry Amount";
                    TmpWIPEntry.Modify;
                end else begin
                    //---------- Consolidate Postings <<
                    TmpWIPEntry.Reset;
                    if TmpWIPEntry.FindLast then begin
                        TmpEntryNo := TmpWIPEntry."Entry No." + 1;
                    end else begin
                        TmpEntryNo := 1;
                    end;

                    TmpWIPEntry.Init;
                    TmpWIPEntry."Entry No." := TmpEntryNo;
                    TmpWIPEntry."Document No." := ReverseDocumentNo;
                    TmpWIPEntry."Service Order No." := WIPEntry."Service Order No.";
                    TmpWIPEntry."G/L Account No." := WIPEntry."G/L Account No.";
                    TmpWIPEntry."G/L Bal. Account No." := WIPEntry."G/L Bal. Account No.";
                    TmpWIPEntry."Posting Date" := ReversePostingDate;
                    TmpWIPEntry."Gen. Bus. Posting Group" := WIPEntry."Gen. Bus. Posting Group";
                    TmpWIPEntry."Gen. Prod. Posting Group" := WIPEntry."Gen. Prod. Posting Group";
                    TmpWIPEntry."Entry Type" := WIPEntry."Entry Type";
                    TmpWIPEntry."WIP Method" := WIPEntry."WIP Method";
                    TmpWIPEntry."Dimension Set ID" := WIPEntry."Dimension Set ID";
                    TmpWIPEntry."WIP Entry Amount" := WIPEntry."WIP Entry Amount";
                    TmpWIPEntry.Insert;
                end;
            until WIPEntry.Next = 0;

        TmpWIPEntry.Reset;
        if TmpWIPEntry.Find('-') then
            repeat
                if TmpWIPEntry."WIP Entry Amount" <> 0 then
                    GLEntryPosted := PostWIPLine(TmpWIPEntry, true);
            until TmpWIPEntry.Next = 0;

        if GLEntryPosted <> 0 then begin
            WIPTotal.Reset;
            WIPTotal.SetRange("Document No.", WIPDocumentNo);
            if WIPTotal.FindFirst then begin
                WIPTotal.Reversed := true;
                WIPTotal."Reverse Document No." := ReverseDocumentNo;
                WIPTotal."Reverse Posting Date" := ReversePostingDate;
                WIPTotal.Modify;
            end;
            WIPEntry.Reset;
            WIPEntry.SetRange("Document No.", WIPDocumentNo);
            if WIPEntry.Find('-') then
                repeat
                    WIPEntry.Reversed := true;
                    WIPEntry."Reverse Document No." := ReverseDocumentNo;
                    WIPEntry."Reverse Date" := ReversePostingDate;
                    WIPEntry.Modify;
                until WIPEntry.Next = 0;
        end;
    end;

    local procedure InsertWIPEntry(WIPDocumentNo: Code[20]; WIPServiceOrderLine: Record "Service Order WIP Line"; GLAccountNo: Code[10]; GLBalAccountNo: Code[10]; PostingDate: Date; EntryType: Integer; Consolidated: Boolean; Amount: Decimal; VehicleSerialNo: Code[20]; VehAccCycleNo: Code[20])
    var
        TmpEntryNo: Integer;
        EntryNo: Integer;
        WIPEntry: Record "Service WIP Entry";
        ServWIPSetup: Record "Service WIP Setup";
        DimMgt: Codeunit DimensionManagement;
    begin
        ServWIPSetup.Get;
        if (WIPServiceOrderLine."WIP Method" = WIPServiceOrderLine."wip method"::"Sales Method") and (EntryType = 0) and (not ServWIPSetup."Post Labor Cost for Sales Meth") then
            Amount := 0;
        //--------- Consolidate Postings >>
        TmpWIPEntry.Reset;
        TmpWIPEntry.SetRange("Document No.", WIPDocumentNo);
        TmpWIPEntry.SetRange("Service Order No.", WIPServiceOrderLine."Service Order No.");
        TmpWIPEntry.SetRange("G/L Account No.", GLAccountNo);
        TmpWIPEntry.SetRange("G/L Bal. Account No.", GLBalAccountNo);
        TmpWIPEntry.SetRange("Posting Date", PostingDate);
        TmpWIPEntry.SetRange("Gen. Bus. Posting Group", WIPServiceOrderLine."Gen. Bus. Posting Group");
        TmpWIPEntry.SetRange("Gen. Prod. Posting Group", WIPServiceOrderLine."Gen. Prod. Posting Group");
        TmpWIPEntry.SetRange("Entry Type", EntryType);
        TmpWIPEntry.SetRange("WIP Method", WIPServiceOrderLine."WIP Method");
        TmpWIPEntry.SetRange("Dimension Set ID", WIPServiceOrderLine."Dimension Set ID");
        if Consolidated and TmpWIPEntry.Find('-') then begin
            TmpWIPEntry."WIP Entry Amount" += Amount;
            TmpWIPEntry.Modify;
        end else begin
            //---------- Consolidate Postings <<

            TmpWIPEntry.Reset;
            if TmpWIPEntry.FindLast then
                TmpEntryNo := TmpWIPEntry."Entry No." + 1
            else
                TmpEntryNo := 1;

            TmpWIPEntry.Init;
            TmpWIPEntry."Entry No." := TmpEntryNo;
            TmpWIPEntry."Document No." := WIPDocumentNo;
            TmpWIPEntry."Service Order No." := WIPServiceOrderLine."Service Order No.";
            TmpWIPEntry."G/L Account No." := GLAccountNo;
            TmpWIPEntry."G/L Bal. Account No." := GLBalAccountNo;
            TmpWIPEntry."Posting Date" := PostingDate;
            TmpWIPEntry."Gen. Bus. Posting Group" := WIPServiceOrderLine."Gen. Bus. Posting Group";
            TmpWIPEntry."Gen. Prod. Posting Group" := WIPServiceOrderLine."Gen. Prod. Posting Group";
            TmpWIPEntry."Entry Type" := EntryType;
            TmpWIPEntry."WIP Method" := WIPServiceOrderLine."WIP Method";
            TmpWIPEntry."Dimension Set ID" := WIPServiceOrderLine."Dimension Set ID";
            TmpWIPEntry."WIP Entry Amount" := Amount;
            TmpWIPEntry."Vehicle Serial No." := VehAccCycleNo;
            TmpWIPEntry."Vehicle Accounting Cycle No." := VehicleSerialNo;
            TmpWIPEntry.Insert;
        end;

        WIPEntry.Reset;
        if WIPEntry.FindLast then begin
            EntryNo := WIPEntry."Entry No." + 1;
        end else begin
            EntryNo := 1;
        end;


        WIPEntry.Init;
        WIPEntry."Entry No." := EntryNo;
        WIPEntry."Document No." := WIPDocumentNo;
        WIPEntry."Service Order No." := WIPServiceOrderLine."Service Order No.";
        WIPEntry."Service Order Line No." := WIPServiceOrderLine."Service Order Line No.";
        WIPEntry.Type := WIPServiceOrderLine.Type;
        WIPEntry."No." := WIPServiceOrderLine."No.";
        WIPEntry.Quantity := WIPServiceOrderLine.Quantity;
        WIPEntry."Finished Qty." := WIPServiceOrderLine."Finished Qty.";
        WIPEntry."G/L Account No." := GLAccountNo;
        WIPEntry."G/L Bal. Account No." := GLBalAccountNo;
        WIPEntry."Posting Date" := PostingDate;
        WIPEntry."Gen. Bus. Posting Group" := WIPServiceOrderLine."Gen. Bus. Posting Group";
        WIPEntry."Gen. Prod. Posting Group" := WIPServiceOrderLine."Gen. Prod. Posting Group";
        WIPEntry."Entry Type" := EntryType;
        WIPEntry."WIP Method" := WIPServiceOrderLine."WIP Method";
        WIPEntry."Dimension Set ID" := WIPServiceOrderLine."Dimension Set ID";
        WIPEntry."WIP Entry Amount" := Amount;
        WIPEntry.Description := WIPServiceOrderLine.Description;
        WIPEntry."Vehicle Serial No." := VehAccCycleNo;
        WIPEntry."Vehicle Accounting Cycle No." := VehicleSerialNo;

        DimMgt.UpdateGlobalDimFromDimSetID(WIPEntry."Dimension Set ID", WIPEntry."Global Dimension 1 Code",
          WIPEntry."Global Dimension 2 Code");

        WIPEntry.Insert;
    end;


    procedure ServiceOrderCheckAndPostWIP(ServiceOrderNo: Code[20]; ReversePostingDate: Date)
    var
        WIPTotals: Record "Service WIP Total";
    begin
        WIPTotals.Reset;
        WIPTotals.SetRange("Service Order No.", ServiceOrderNo);
        WIPTotals.SetRange(Reversed, false);
        if WIPTotals.FindFirst then
            PostReverseWIP(WIPTotals."Document No.", '', ReversePostingDate);
    end;


    procedure DeleteCalculatedWIP(ServiceOrderNo: Code[20])
    var
        ServiceWIPHeader: Record "Service Order WIP Header";
        ServiceWIPLine: Record "Service Order WIP Line";
    begin
        ServiceWIPHeader.Reset;
        ServiceWIPHeader.SetRange("Service Order No.", ServiceOrderNo);
        if ServiceWIPHeader.Find('-') then begin
            if Confirm(StrSubstNo(TEXT01, ServiceOrderNo), true) then
                ServiceWIPHeader.Delete(true);
        end;
    end;

    local procedure InsertPostedWIPServLine(WIPDocumentNo: Code[20]; ServOrderWIPLine: Record "Service Order WIP Line")
    var
        PostedServWIPOrdLine: Record "Posted Serv. WIP Order Line";
    begin
        PostedServWIPOrdLine.Init;
        PostedServWIPOrdLine."Document No." := WIPDocumentNo;
        PostedServWIPOrdLine.TransferFields(ServOrderWIPLine);
        PostedServWIPOrdLine.Insert;
    end;
}

