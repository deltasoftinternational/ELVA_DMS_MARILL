Codeunit 25006792 "Vehicle Proposal Mgt. EDMS"
{
    // #Owner EDMS.Integration
    //HELA

    trigger OnRun()
    begin
    end;

    var
        EDMS001: label 'You are not allowed to cancel other user reservation.';
        Text002: Label 'must not be filled in when a quantity is reserved';

        EDMSText002: Label 'Do you want to Restore %1 Version %2?';
        EDMSText003: Label '%1 has been restored.';
        EDMSText007: Label 'Archive no.: %1?';
        EDMSText009: Label 'Unposted %1 does not exist anymore.\It is not possible to restore the %1.';
        ELVAReleaseServiceDoc: Codeunit 25006119;
        ArchiveManagement: Codeunit ArchiveManagement;
        EDMSText101: label 'You cannot restore Service %1 %2, because there are entris in schedule.';
        EDMSText107: label 'Archive Process Checklist No.: %1?';
        Text001: Label 'Document %1 has been archived.';
        Text008: Label 'Item Tracking Line';
        Text004: Label 'Document restored from Version %1.';
        Text006: Label 'Entries exist for on or more of the following:\  - %1\  - %2\  - %3.\Restoration of document will delete these entries.\Continue with restore?';



    //>>ADDED For CU 12
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeStartOrContinuePosting', '', false, false)]
    local procedure OnBeforeStartOrContinuePosting(var GenJnlLine: Record "Gen. Journal Line"; LastDocType: Option; LastDocNo: Code[20]; LastDate: Date; var NextEntryNo: Integer);
    VAR
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchInvLine: Record "Purch. Inv. Line";
    begin
        //23.01.2013 EDMS P8 >>
        // update fields related to EDMS
        if GenJnlLine."Vehicle Serial No." = '' then
            case GenJnlLine."Gen. Posting Type" of
                GenJnlLine."gen. posting type"::Purchase, GenJnlLine."gen. posting type"::" ":
                    begin
                        case GenJnlLine."Document Type" of
                            GenJnlLine."document type"::Invoice, GenJnlLine."document type"::"Credit Memo":
                                if PurchInvHeader.Get(GenJnlLine."Document No.") then begin
                                    PurchInvLine.Reset;
                                    PurchInvLine.SetRange("Document No.", GenJnlLine."Document No.");
                                    if PurchInvLine.Count = 1 then begin
                                        PurchInvLine.FindFirst;
                                        GenJnlLine.VIN := PurchInvLine.VIN;
                                        GenJnlLine."Make Code" := PurchInvLine."Make Code";
                                        GenJnlLine."Model Code" := PurchInvLine."Model Code";
                                        GenJnlLine."Model Version No." := PurchInvLine."Model Version No.";
                                        GenJnlLine."Vehicle Serial No." := PurchInvLine."Vehicle Serial No.";
                                        GenJnlLine."Vehicle Accounting Cycle No." := PurchInvLine."Vehicle Accounting Cycle No.";
                                        GenJnlLine."Document Profile" := PurchInvLine."Document Profile";
                                    end;
                                end;
                        end;
                    end;
                GenJnlLine."gen. posting type"::Sale:
                    begin
                        case GenJnlLine."Document Type" of
                            GenJnlLine."document type"::Invoice:
                                if SalesInvoiceHeader.Get(GenJnlLine."Document No.") then begin
                                    if (SalesInvoiceHeader."Document Profile" = SalesInvoiceHeader."document profile"::"Vehicles Trade") and
                                        (GenJnlLine."Account Type" = GenJnlLine."account type"::Customer) then begin
                                        SalesInvoiceLine.Reset;
                                        SalesInvoiceLine.SetRange("Document No.", GenJnlLine."Document No.");
                                        if SalesInvoiceLine.Count = 1 then begin
                                            SalesInvoiceLine.FindFirst;
                                            GenJnlLine.VIN := SalesInvoiceLine.VIN;
                                            GenJnlLine."Make Code" := SalesInvoiceLine."Make Code";
                                            GenJnlLine."Model Code" := SalesInvoiceLine."Model Code";
                                            GenJnlLine."Model Version No." := SalesInvoiceLine."Model Version No.";
                                            GenJnlLine."Vehicle Serial No." := SalesInvoiceLine."Vehicle Serial No.";
                                            GenJnlLine."Vehicle Accounting Cycle No." := SalesInvoiceLine."Vehicle Accounting Cycle No.";
                                            GenJnlLine."Document Profile" := SalesInvoiceLine."Document Profile";
                                            GenJnlLine."Contract No." := SalesInvoiceHeader."Contract No.";    //08.06.2022 EB EDMS
                                        end;
                                    end else begin
                                        GenJnlLine.VIN := SalesInvoiceHeader.VIN;
                                        GenJnlLine."Make Code" := SalesInvoiceHeader."Make Code";
                                        GenJnlLine."Model Code" := SalesInvoiceHeader."Model Code";
                                        GenJnlLine."Model Version No." := SalesInvoiceHeader."Model Version No.";
                                        GenJnlLine."Vehicle Serial No." := SalesInvoiceHeader."Vehicle Serial No.";
                                        GenJnlLine."Vehicle Accounting Cycle No." := SalesInvoiceHeader."Vehicle Accounting Cycle No.";
                                        GenJnlLine."Document Profile" := SalesInvoiceHeader."Document Profile";
                                        GenJnlLine."Contract No." := SalesInvoiceHeader."Contract No.";    //08.06.2022 EB EDMS
                                    end;
                                end;
                            GenJnlLine."document type"::"Credit Memo":
                                if SalesCrMemoHeader.Get(GenJnlLine."Document No.") then begin
                                    if (SalesCrMemoHeader."Document Profile" = SalesCrMemoHeader."document profile"::"Vehicles Trade") and
                                        (GenJnlLine."Account Type" = GenJnlLine."account type"::Customer) then begin
                                        SalesCrMemoLine.Reset;
                                        SalesCrMemoLine.SetRange("Document No.", GenJnlLine."Document No.");
                                        if SalesCrMemoLine.Count = 1 then begin
                                            SalesCrMemoLine.FindFirst;
                                            GenJnlLine.VIN := SalesCrMemoLine.VIN;
                                            GenJnlLine."Make Code" := SalesCrMemoLine."Make Code";
                                            GenJnlLine."Model Code" := SalesCrMemoLine."Model Code";
                                            GenJnlLine."Model Version No." := SalesCrMemoLine."Model Version No.";
                                            GenJnlLine."Vehicle Serial No." := SalesCrMemoLine."Vehicle Serial No.";
                                            GenJnlLine."Vehicle Accounting Cycle No." := SalesCrMemoLine."Vehicle Accounting Cycle No.";
                                            GenJnlLine."Document Profile" := SalesCrMemoLine."Document Profile";
                                            GenJnlLine."Contract No." := SalesCrMemoHeader."Contract No.";    //08.06.2022 EB EDMS
                                        end;
                                    end else begin
                                        GenJnlLine.VIN := SalesCrMemoHeader.VIN;
                                        GenJnlLine."Make Code" := SalesCrMemoHeader."Make Code";
                                        GenJnlLine."Model Code" := SalesCrMemoHeader."Model Code";
                                        GenJnlLine."Model Version No." := SalesCrMemoHeader."Model Version No.";
                                        GenJnlLine."Vehicle Serial No." := SalesCrMemoHeader."Vehicle Serial No.";
                                        GenJnlLine."Vehicle Accounting Cycle No." := SalesCrMemoHeader."Vehicle Accounting Cycle No.";
                                        GenJnlLine."Document Profile" := SalesCrMemoHeader."Document Profile";
                                        GenJnlLine."Contract No." := SalesCrMemoHeader."Contract No.";    //08.06.2022 EB EDMS
                                    end;
                                end;
                        end;
                    end;
            end;
        //23.01.2013 EDMS P8 <<

        //08.06.2022 EB EDMS >>
        if GenJnlLine."Contract No." = '' then
            case GenJnlLine."Gen. Posting Type" of
                GenJnlLine."gen. posting type"::Sale:
                    case GenJnlLine."Document Type" of
                        GenJnlLine."document type"::Invoice:
                            if SalesInvoiceHeader.Get(GenJnlLine."Document No.") then
                                GenJnlLine."Contract No." := SalesInvoiceHeader."Contract No.";
                        GenJnlLine."document type"::"Credit Memo":
                            if SalesCrMemoHeader.Get(GenJnlLine."Document No.") then
                                GenJnlLine."Contract No." := SalesCrMemoHeader."Contract No.";

                    end;
            end;
        //08.06.2022 EB EDMS <<
    end;

    //>>ADDED For CU 12
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnBeforeInitGLEntry', '', false, false)]
    local procedure OnBeforeInitGLEntry(var GenJournalLine: Record "Gen. Journal Line"; var GLAccNo: Code[20]; SystemCreatedEntry: Boolean; Amount: Decimal; AmountAddCurr: Decimal);
    var
        GLAcc: Record "G/L Account";
    begin
        if GLAccNo <> '' then begin
            GLAcc.Get(GLAccNo);
            //EDMS1.0.00 >>
            if (GLAcc."Vehicle ID Mandatory") then
                GenJournalLine.TestField("Vehicle Serial No.");
            //EDMS1.0.00 <<
        end;
    END;
    //>>ADDED For CU 12
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Post Line", 'OnAfterInitGLEntry', '', false, false)]
    local procedure OnAfterInitGLEntry(var GLEntry: Record "G/L Entry"; GenJournalLine: Record "Gen. Journal Line"; Amount: Decimal; AddCurrAmount: Decimal; UseAddCurrAmount: Boolean; var CurrencyFactor: Decimal);
    begin
        //EDMS1.0.00 >>
        GLEntry."Vehicle Serial No." := GenJournalLine."Vehicle Serial No.";
        GLEntry."Vehicle Accounting Cycle No." := GenJournalLine."Vehicle Accounting Cycle No.";
        //EDMS1.0.00 <<

        GLEntry."Deal Type Code" := GenJournalLine."Deal Type Code"; //20.08.2018 EB EDMS
        GLEntry."Contract No." := GenJournalLine."Contract No.";  //08.06.2022 EB EDMS
    end;


    //>>ADDED For CU 700 
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Page Management", 'OnConditionalCardPageIDNotFound', '', false, false)]
    local procedure OnConditionalCardPageIDNotFound(RecordRef: RecordRef; var CardPageID: Integer);
    begin
        if RecordRef.Number = Database::"Service Header EDMS" then //11.10.2019 EB.P7 B3030DMS-14
            CardPageID := GetServiceHeaderListPageID(RecordRef); //11.10.2019 EB.P7 B3030DMS-14
    end;


    local procedure GetServiceHeaderListPageID(RecordRef: RecordRef): Integer
    var
        ServiceHeader: Record "Service Header EDMS";
    begin
        RecordRef.SetTable(ServiceHeader);
        case ServiceHeader."Document Type" of
            ServiceHeader."document type"::Quote:
                exit(Page::"Service Quote EDMS");
            ServiceHeader."document type"::Order:
                exit(Page::"Service Order EDMS");
        end;
    end;



    //>>ADDED For 703   -- on a place le code ajouté par Elva dans table 37 39
    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeFindOrCreateRecordByNo', '', false, false)]
    local procedure OnBeforeFindOrCreateRecordByNo(var PurchLine: Record "Purchase Line"; xPurchLine: Record "Purchase Line"; CurrentFieldNo: Integer; var IsHandled: Boolean);
    begin
        if PurchLine.Type = PurchLine.Type::"External Service" then
            IsHandled := true;
    end;
    //>>ADDED For 703   -- on a place le code ajouté par Elva dans table 37 39
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeFindOrCreateRecordByNo', '', false, false)]
    local procedure OnBeforeFindOrCreateRecordByNoSales(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line"; CurrentFieldNo: Integer; var IsHandled: Boolean);
    begin
        if SalesLine.Type = SalesLine.Type::"External Service" then
            IsHandled := true;
    end;


    //>>Addes for 99000841
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Ledger Entry-Reserve", 'OnDrillDownTotalQuantityElseCase', '', false, false)]
    local procedure OnDrillDownTotalQuantityElseCase(SourceRecRef: RecordRef; EntrySummary: Record "Entry Summary" temporary; ReservEntry: Record "Reservation Entry"; Location: Record Location; MaxQtyToReserve: Decimal);
    var
        AvailableItemLedgEntries: Page "Available - Item Ledg. Entries";
    begin
        if ReservEntry."Source Type" = Database::"Service Line EDMS" then begin
            AvailableItemLedgEntries.SetSource(SourceRecRef, ReservEntry, ReservEntry.GetTransferDirection());
            AvailableItemLedgEntries.SetTotalAvailQty(EntrySummary."Total Available Quantity");
            AvailableItemLedgEntries.SetMaxQtyToReserve(MaxQtyToReserve);
            AvailableItemLedgEntries.RunModal;

        end;
    end;

    //>>added for  99000834
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Line-Reserve", 'OnVerifyChangeOnBeforeHasError', '', false, false)]
    local procedure OnVerifyChangeOnBeforeHasError(NewPurchLine: Record "Purchase Line"; OldPurchLine: Record "Purchase Line"; var HasError: Boolean; var ShowError: Boolean);
    begin
        //18.01.2013 EDMS P8 >>
        if NewPurchLine."Special Order Service No." <> '' then
            if ShowError then
                NewPurchLine.FieldError("Special Order Service No.", Text002)
            else
                HasError := NewPurchLine."Special Order Service No." <> OldPurchLine."Special Order Service No.";

        if NewPurchLine."Special Order Service Line No." <> 0 then
            if ShowError then
                NewPurchLine.FieldError(
                  "Special Order Service Line No.", Text002)
            else
                HasError := NewPurchLine."Special Order Service Line No." <> OldPurchLine."Special Order Service Line No.";
        //18.01.2013 EDMS P8 <<

    end;
    //>>added for  99000830
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Create Reserv. Entry", 'OnAfterSignFactor', '', false, false)]
    local procedure OnAfterSignFactor(ReservationEntry: Record "Reservation Entry"; var Sign: Integer);
    begin
        if (ReservationEntry."Source Type" = Database::"Service Line EDMS") then //08.07.08 EDMS P1
            if ReservationEntry."Source Subtype" in [2] then // Return Order
                Sign := 1
            else
                Sign := -1
    end;

    //>>added for 99000831
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Engine Mgt.", 'OnBeforeCancelReservation', '', false, false)]
    local procedure OnBeforeCancelReservation(var ReservEntry: Record "Reservation Entry");
    var
        UserSetup: Record "User Setup";
    begin
        //09.10.2007. EDMS P2 >>
        if UserSetup.Get(UserId) then;
        if UserSetup."Cancel Only Own Reservation" and (ReservEntry."Created By" <> UpperCase(UserId)) then
            Error(EDMS001);
        //09.10.2007. EDMS P2 <<
    end;

    //>>added for 99000831
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Engine Mgt.", 'OnAfterCreateText', '', false, false)]
    local procedure OnAfterCreateText(ReservationEntry: Record "Reservation Entry"; var SourceTypeText: Text);
    var
        SourceType: Option " ",Sales,"Requisition Line",Purchase,"Item Journal","BOM Journal","Item Ledger Entry","Prod. Order Line","Prod. Order Component","Planning Line","Planning Component",Transfer,Service,"Job Journal",Job,"Assembly Header","Assembly Line","Inventory Document";
        lSourceTypeText: Label 'Sales,Requisition Line,Purchase,Item Journal,BOM Journal,Item Ledger Entry,Prod. Order Line,Prod. Order Component,Planning Line,Planning Component,Transfer,Service,Job Journal,Job,Assembly Header,Assembly Line,Inventory Document';

    begin
        if ReservationEntry."Source Type" = Database::"Service Line EDMS" then begin
            SourceType := Sourcetype::Service;
            SourceTypeText := StrSubstNo('%1 %2', SelectStr(SourceType, lSourceTypeText), ReservationEntry."Source ID");
        end;

    end;
    //>>added for 99000831
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Reservation Engine Mgt.", 'OnGetActivePointerFieldsOnBeforeAssignArrayValues', '', false, false)]
    local procedure OnGetActivePointerFieldsOnBeforeAssignArrayValues(TableID: Integer; var PointerFieldIsActive: array[6] of Boolean; var IsHandled: Boolean);
    begin
        if TableID = (Database::"Service Line EDMS") then begin
            PointerFieldIsActive[2] := true;  // SubType
            PointerFieldIsActive[3] := true;  // ID
            PointerFieldIsActive[6] := true;  // RefNo
            IsHandled := true;
        end;
    end;

    //>>added for 99000832
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Line-Reserve", 'OnTestSalesLineModificationOnBeforeTestBinCode', '', false, false)]
    local procedure OnTestSalesLineModificationOnBeforeTestBinCode(var NewSalesLine: Record "Sales Line"; var OldSalesLine: Record "Sales Line"; var IsHandled: Boolean);
    begin
        IsHandled := true;   //code commenté par ELVA
    end;


    //>>added for 99000833
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Req. Line-Reserve", 'OnVerifyChangeOnBeforeHasError', '', false, false)]
    local procedure OnVerifyChangeOnBeforeHasErrorResq(NewReqLine: Record "Requisition Line"; OldReqLine: Record "Requisition Line"; var HasError: Boolean; var ShowError: Boolean);
    begin
        //18.01.2013 EDMS P8 >>
        if NewReqLine."Service Order No." <> '' then
            if ShowError then
                NewReqLine.FieldError("Service Order No.", Text002)
            else
                HasError := true;

        if NewReqLine."Service Order Line No." <> 0 then
            if ShowError then
                NewReqLine.FieldError("Service Order Line No.", Text002)
            else
                HasError := true;
        //18.01.2013 EDMS P8 <<
    end;

    //>> added for 99000854
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Inventory Profile Offsetting", 'OnAfterDemandToInvProfile', '', false, false)]
    local procedure OnAfterDemandToInvProfile(var InventoryProfile: Record "Inventory Profile"; var Item: Record Item; var ReservEntry: Record "Reservation Entry"; var NextLineNo: Integer);
    var
        ServLineEDMS: Record "Service Line EDMS";
        TempItemTrkgEntry: Record "Reservation Entry" temporary;
    begin

        //23.02.2010 EDMSB P2 >>
        ServLineEDMS.SetCurrentkey(Type, "No.", "Variant Code", "Location Code", "Document Type", "Shortcut Dimension 1 Code",
                              "Shortcut Dimension 2 Code");
        ServLineEDMS.SetFilter("Document Type", '%1|%2', ServLineEDMS."document type"::Order, ServLineEDMS."document type"::"Return Order");
        ServLineEDMS.SetRange(Type, ServLineEDMS.Type::Item);
        ServLineEDMS.SetRange("No.", Item."No.");
        Item.Copyfilter("Location Filter", ServLineEDMS."Location Code");
        Item.Copyfilter("Variant Filter", ServLineEDMS."Variant Code");
        ServLineEDMS.SetFilter("Outstanding Qty. (Base)", '<>0');

        if ServLineEDMS.FindSet then
            repeat
                InventoryProfile.Init;
                InventoryProfile."Line No." := NextLineNo;
                InventoryProfile.TransferFromServLineEDMS(ServLineEDMS, TempItemTrkgEntry);
                if InventoryProfile.IsSupply then
                    InventoryProfile.ChangeSign;
                InventoryProfile.Insert;
            until ServLineEDMS.Next = 0;
        //23.02.2010 EDMSB P2 <<
    end;

    //>> added for 99000854
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Inventory Profile Offsetting", 'OnAfterSetOrderPriority', '', false, false)]
    local procedure OnAfterSetOrderPriority(var InventoryProfile: Record "Inventory Profile");
    begin
        if InventoryProfile.IsSupply then begin
            if InventoryProfile."Source Type" = Database::"Service Line EDMS" then
                case InventoryProfile."Source Order Status" of // Quote,Order,Return Order
                    2:
                        InventoryProfile."Order Priority" := 200; // Return Order
                    1:
                        InventoryProfile."Order Priority" := 200; // Negative Sales Order
                end;
        end else begin
            if InventoryProfile."Source Type" = Database::"Service Line EDMS" then
                case InventoryProfile."Source Order Status" of // Quote,Order,Return Order
                    1:
                        InventoryProfile."Order Priority" := 300; // Order
                end;
        end;

    end;



    //>>ADDED 5062
    [EventSubscriber(ObjectType::Codeunit, Codeunit::SegCriteriaManagement, 'OnAfterGetSegCriteriaFilters', '', false, false)]
    local procedure OnAfterSegCriteriaFilter(TableNo: Integer; TableView: Text; var TableFilters: Text);
    VAR
        SalesInvoiceLine: Record "Sales Invoice Line";
        Vehicle: Record Vehicle;
        RecRef: RecordRef;
    begin
        case TableNo of
            //23.01.2008 EDMS P3 >>
            Database::"Sales Invoice Line":
                begin
                    SalesInvoiceLine.SetView(TableView);
                    TableFilters := SalesInvoiceLine.GetFilters;
                end;
            Database::Vehicle:
                begin
                    Vehicle.SetView(TableView);
                    TableFilters := Vehicle.GetFilters;
                end;
            //08.10.2014 EB.P8 EDMS7.10 >>
            else
                if TableNo > 0 then begin
                    RecRef.Open(TableNo);
                    RecRef.SetView(TableView);
                    TableFilters := RecRef.GetFilters;
                end;
        //08.10.2014 EB.P8 EDMS7.10 <<
        //23.01.2008 EDMS P3 <<
        END;
    end;
    //>>ADDED 5063
    [EventSubscriber(ObjectType::Codeunit, Codeunit::ArchiveManagement, 'OnAfterStoreSalesDocument', '', false, false)]
    local procedure OnAfterStoreSalesDocument(var SalesHeader: Record "Sales Header"; var SalesHeaderArchive: Record "Sales Header Archive");
    begin
        case SalesHeader."Document Type" of
            SalesHeader."document type"::Quote:
                ArchiveSalesOfferAnalysis(SalesHeader."No.", 0, SalesHeaderArchive."Version No.");
            SalesHeader."document type"::Order:
                ArchiveSalesOfferAnalysis(SalesHeader."No.", 1, SalesHeaderArchive."Version No.");
        end;
    end;

    local procedure ArchiveSalesOfferAnalysis(DocumentNo: Code[20]; DocumentType: Integer; VersionNo: Integer)
    var
        SalesOfferAnalysisHeader: Record "Sales Analysis Header";
        SalesOfferAnalysisLine: Record "Sales Analysis Line";
        SalesOfferAnalysisHeaderArchive: Record "Sales Analysis Header Archive";
        SalesOfferAnalysisLineArchive: Record "Sales Analysis Line Archive";
        SalesHeader: Record "Sales Header";
        ServiceHeader: Record "Service Header EDMS";
        IsHandled: Boolean;
    begin
        OnBeforeArchiveSalesOfferAnalysis(DocumentNo, DocumentType, VersionNo, IsHandled);
        If IsHandled Then
            exit;
        if not SalesOfferAnalysisHeader.Get(DocumentNo, DocumentType) then begin
            case DocumentType of
                0:
                    if SalesHeader.Get(DocumentType, DocumentNo) then
                        SalesOfferAnalysisHeader.FillFromSalesDocument(SalesHeader);
                2:
                    if ServiceHeader.Get(DocumentType - 2, DocumentNo) then
                        SalesOfferAnalysisHeader.FillFromServiceDocument(ServiceHeader);
            end;
        end;

        if SalesOfferAnalysisHeader.Get(DocumentNo, DocumentType) then begin
            SalesOfferAnalysisHeaderArchive.Init;
            SalesOfferAnalysisHeaderArchive.TransferFields(SalesOfferAnalysisHeader);
            SalesOfferAnalysisHeaderArchive."Version No." := VersionNo;
            SalesOfferAnalysisHeaderArchive.Insert;
            SalesOfferAnalysisLine.Reset;
            SalesOfferAnalysisLine.SetRange("Document No.", DocumentNo);
            SalesOfferAnalysisLine.SetRange("Document Type", DocumentType);
            if SalesOfferAnalysisLine.FindFirst then
                repeat
                    SalesOfferAnalysisLineArchive.Init;
                    SalesOfferAnalysisLineArchive.TransferFields(SalesOfferAnalysisLine);
                    SalesOfferAnalysisLineArchive."Version No." := VersionNo;
                    SalesOfferAnalysisLineArchive.Insert;
                until SalesOfferAnalysisLine.Next = 0;
        end;
    end;
    //>>ADDED 5063
    [EventSubscriber(ObjectType::Codeunit, Codeunit::ArchiveManagement, 'OnGetNextOccurrenceNo', '', false, false)]
    local procedure OnGetNextOccurrenceNo(TableId: Integer; DocType: Option; DocNo: Code[20]; var OccurenceNo: Integer);
    var
        ServiceHeaderArchive: Record "Service Header Archive";
        ContractArchive: Record "Contract Archive";
    begin
        case TableId of
            Database::"Service Header EDMS":
                begin
                    ServiceHeaderArchive.LockTable;
                    ServiceHeaderArchive.SetRange("Document Type", DocType);
                    ServiceHeaderArchive.SetRange("No.", DocNo);
                    if ServiceHeaderArchive.FindLast then
                        OccurenceNo := ServiceHeaderArchive."Doc. No. Occurrence" + 1
                    else
                        OccurenceNo := 1;
                end;
            Database::Contract:
                begin
                    ContractArchive.LockTable;
                    ContractArchive.SetRange("Contract No.", DocNo);
                    if ContractArchive.FindLast then
                        OccurenceNo := ContractArchive."Doc. No. Occurrence" + 1
                    else
                        OccurenceNo := 1;
                end;
        end;
    end;

    //>>ADDED 5062
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Calc. Item Plan - Plan Wksh.", 'OnBeforePlanThisItem', '', false, false)]
    local procedure OnBeforePlanThisItem(Item: Record Item; var IsHandled: Boolean; MPS: Boolean; MRP: Boolean; NetChange: Boolean; var FromDate: Date; ToDate: Date; UseForecast: Code[10]; RespectPlanningParm: Boolean; var Result: Boolean);
    var
        SKU: Record "Stockkeeping Unit";
        ForecastEntry: Record "Production Forecast Entry";
        SalesLine: Record "Sales Line";
        ServLine: Record "Service Line";
        PurchaseLine: Record "Purchase Line";
        ProdOrderLine: Record "Prod. Order Line";
        PlanningAssignment: Record "Planning Assignment";
        JobPlanningLine: Record "Job Planning Line";
        MfgSetup: record "Manufacturing Setup";
        GeneralSKU: Record "General Stockkeeping Unit";
    begin

        IsHandled := true;
        SKU.SetCurrentKey("Item No.");
        Item.CopyFilter("Variant Filter", SKU."Variant Code");
        Item.CopyFilter("Location Filter", SKU."Location Code");
        SKU.SetRange("Item No.", Item."No.");
        if SKU.IsEmpty() and (Item."Reordering Policy" = Item."Reordering Policy"::" ") then begin
            //04.03.2009. EDMS P2 >>
            GeneralSKU.Reset;
            Item.Copyfilter("Location Filter", GeneralSKU."Location Code");
            Item.Copyfilter("Item Category Code", GeneralSKU."Item Category Code");
            if not GeneralSKU.FindFirst then
                Result := false;
            //04.03.2009. EDMS P2 <<
        end;


        Item.CopyFilter("Variant Filter", PlanningAssignment."Variant Code");
        Item.CopyFilter("Location Filter", PlanningAssignment."Location Code");
        PlanningAssignment.SetRange(Inactive, false);
        PlanningAssignment.SetRange("Net Change Planning", true);
        PlanningAssignment.SetRange("Item No.", Item."No.");
        if NetChange and PlanningAssignment.IsEmpty() then
            Result := false;

        if MRP = MPS then
            Result := true;

        SalesLine.SetCurrentKey("Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Shipment Date");
        SalesLine.SetFilter("Document Type", '%1|%2', SalesLine."Document Type"::Order, SalesLine."Document Type"::"Blanket Order");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        Item.CopyFilter("Variant Filter", SalesLine."Variant Code");
        Item.CopyFilter("Location Filter", SalesLine."Location Code");
        SalesLine.SetRange("No.", Item."No.");
        SalesLine.SetFilter("Outstanding Qty. (Base)", '<>0');
        if not SalesLine.IsEmpty() then
            Result := MPS;

        ForecastEntry.SetCurrentKey("Production Forecast Name", "Item No.", "Location Code", "Forecast Date", "Component Forecast");
        ForecastEntry.SetRange("Production Forecast Name", UseForecast);
        if MfgSetup."Use Forecast on Locations" then
            Item.CopyFilter("Location Filter", ForecastEntry."Location Code");
        if MfgSetup."Use Forecast on Variants" then
            Item.CopyFilter("Variant Filter", ForecastEntry."Variant Code");
        ForecastEntry.SetRange("Item No.", Item."No.");
        if ForecastEntry.FindFirst() then begin
            ForecastEntry.CalcSums("Forecast Quantity (Base)");
            if ForecastEntry."Forecast Quantity (Base)" > 0 then
                Result := MPS;
        end;

        if ServLine.LinesWithItemToPlanExist(Item) then
            Result := MPS;

        if JobPlanningLine.LinesWithItemToPlanExist(Item) then
            Result := MPS;

        ProdOrderLine.SetCurrentKey("Item No.");
        ProdOrderLine.SetRange("MPS Order", true);
        ProdOrderLine.SetRange("Item No.", Item."No.");
        if not ProdOrderLine.IsEmpty() then
            Result := MPS;

        PurchaseLine.SetCurrentKey("Document Type", Type, "No.");
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        PurchaseLine.SetRange(Type, PurchaseLine.Type::Item);
        PurchaseLine.SetRange("MPS Order", true);
        PurchaseLine.SetRange("No.", Item."No.");
        if not PurchaseLine.IsEmpty() then
            Result := MPS;

        Result := MRP;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeArchiveSalesOfferAnalysis(DocumentNo: Code[20]; DocumentType: Integer; VersionNo: Integer; var IsHandled: Boolean)
    begin
    end;


    //>>-----------------CU 5063

    procedure ArchServDocumentNoConfirm(var ServiceHeader: Record "Service Header EDMS")
    begin
        StoreServiceDocument(ServiceHeader, false);
    end;


    procedure ArchiveServiceDocument(var ServiceHeader: Record "Service Header EDMS")
    begin
        if Confirm(
          EDMSText007, true, ServiceHeader."Document Type",
          ServiceHeader."No.")
        then begin
            StoreServiceDocument(ServiceHeader, false);
            Message(Text001, ServiceHeader."No.");
        end;
    end;


    procedure StoreServiceDocument(var ServiceHeader: Record "Service Header EDMS"; InteractionExist: Boolean)
    var
        ServiceLine: Record "Service Line EDMS";
        ServiceHeaderArchive: Record "Service Header Archive";
        ServiceLineArchive: Record "Service Line Archive";
    begin
        ServiceHeaderArchive.Init;
        ServiceHeaderArchive.TransferFields(ServiceHeader);
        ServiceHeaderArchive."Archived By" := UserId;
        ServiceHeaderArchive."Date Archived" := WorkDate;
        ServiceHeaderArchive."Time Archived" := Time;
        ServiceHeaderArchive."Version No." := ArchiveManagement.GetNextVersionNo(
          Database::"Service Header EDMS", ServiceHeader."Document Type", ServiceHeader."No.", ServiceHeader."Doc. No. Occurrence");
        ServiceHeaderArchive."Interaction Exist" := InteractionExist;
        ServiceHeaderArchive.Insert;


        StoreServiceDocumentComments(
          ServiceHeader."Document Type", ServiceHeader."No.",
          ServiceHeader."Doc. No. Occurrence", ServiceHeaderArchive."Version No.");

        ServiceLine.SetRange("Document Type", ServiceHeader."Document Type");
        ServiceLine.SetRange("Document No.", ServiceHeader."No.");
        if ServiceLine.FindSet then
            repeat
                ServiceLineArchive.Init;
                ServiceLineArchive.TransferFields(ServiceLine);
                ServiceLineArchive."Doc. No. Occurrence" := ServiceHeader."Doc. No. Occurrence";
                ServiceLineArchive."Version No." := ServiceHeaderArchive."Version No.";
                ServiceLineArchive.Insert;
            until ServiceLine.Next = 0;

        // 13.10.2017 EDMS P30 >>
        case ServiceHeader."Document Type" of
            ServiceHeader."document type"::Quote:
                ArchiveSalesOfferAnalysis(ServiceHeader."No.", 2, ServiceHeaderArchive."Version No.");
            ServiceHeader."document type"::Order:
                ArchiveSalesOfferAnalysis(ServiceHeader."No.", 3, ServiceHeaderArchive."Version No.");
        end;
        // 13.10.2017 EDMS P30 <<
    end;

    local procedure StoreServiceDocumentComments(DocType: Option Quote,"Order","Return Order"; DocNo: Code[20]; DocNoOccurrence: Integer; VersionNo: Integer)
    var
        ServiceCommentLine: Record "Service Comment Line EDMS";
        ServiceCommentLineArch: Record "Serv. Comment Line Arch. EDMS";
    begin
        case DocType of
            Doctype::Quote:
                ServiceCommentLine.SetRange(Type, ServiceCommentLine.Type::"Service Quote");
            Doctype::Order:
                ServiceCommentLine.SetRange(Type, ServiceCommentLine.Type::"Service Order");
            Doctype::"Return Order":
                ServiceCommentLine.SetRange(Type, ServiceCommentLine.Type::"Service Return Order");
        end;
        ServiceCommentLine.SetRange("No.", DocNo);
        if ServiceCommentLine.FindSet then
            repeat
                ServiceCommentLineArch.Init;
                ServiceCommentLineArch.TransferFields(ServiceCommentLine);

                case DocType of
                    Doctype::Quote:
                        ServiceCommentLineArch.Type := ServiceCommentLineArch.Type::"Service Quote";
                    Doctype::Order:
                        ServiceCommentLineArch.Type := ServiceCommentLineArch.Type::"Service Order";
                    Doctype::"Return Order":
                        ServiceCommentLineArch.Type := ServiceCommentLineArch.Type::"Service Return Order";
                end;


                ServiceCommentLineArch."Doc. No. Occurrence" := DocNoOccurrence;
                ServiceCommentLineArch."Version No." := VersionNo;
                ServiceCommentLineArch.Insert;
            until ServiceCommentLine.Next = 0;
    end;


    procedure RestoreServiceDocument(var ServiceHeaderArchive: Record "Service Header Archive EDMS")
    var
        ServiceHeader: Record "Service Header EDMS";
        ServiceLine: Record "Service Line EDMS";
        ServiceLineArchive: Record "Service Line Archive";
        SalesShptHeader: Record "Sales Shipment Header";
        SalesInvHeader: Record "Sales Invoice Header";
        ReservEntry: Record "Reservation Entry";
        ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
        ServiceCommentLine: Record "Service Comment Line EDMS";
        ServCommentLineArchive: Record "Serv. Comment Line Arch. EDMS";
        SalesPost: Codeunit "Sales-Post";
        DimMgt: Codeunit DimensionManagement;
        NextLine: Integer;
        ConfirmRequired: Boolean;
        RestoreDocument: Boolean;
        LaborAllocApp: Record "Serv. Labor Alloc. Application";
    begin
        if not (ServiceHeader.Get(ServiceHeaderArchive."Document Type", ServiceHeaderArchive."No.")) then
            Error(EDMSText007, ServiceHeaderArchive."Document Type", ServiceHeaderArchive."No.");
        ServiceHeader.TestField(Status, ServiceHeader.Status::Open);

        LaborAllocApp.Reset;
        LaborAllocApp.SetRange("Document Type", ServiceHeader."Document Type");
        LaborAllocApp.SetRange("Document No.", ServiceHeader."No.");
        if not LaborAllocApp.IsEmpty then
            Error(EDMSText101, ServiceHeader."Document Type", ServiceHeader."No.");


        ConfirmRequired := false;
        ReservEntry.Reset;
        ReservEntry.SetCurrentkey(
          "Source ID",
          "Source Ref. No.",
          "Source Type",
          "Source Subtype");

        ReservEntry.SetRange("Source ID", ServiceHeader."No.");
        ReservEntry.SetRange("Source Type", Database::"Service Line EDMS");
        ReservEntry.SetRange("Source Subtype", ServiceHeader."Document Type");
        if ReservEntry.FindFirst then
            ConfirmRequired := true;

        RestoreDocument := false;
        if ConfirmRequired then begin
            if Confirm(
              Text006, false, ReservEntry.TableCaption, ItemChargeAssgntSales.TableCaption, Text008)
            then
                RestoreDocument := true;
        end else
            if Confirm(
              EDMSText002, true, ServiceHeaderArchive."Document Type",
              ServiceHeaderArchive."No.", ServiceHeaderArchive."Version No.")
            then
                RestoreDocument := true;
        if RestoreDocument then begin
            ServiceHeader.TestField("Doc. No. Occurrence", ServiceHeaderArchive."Doc. No. Occurrence");
            ServiceHeader.Delete(true);
            ServiceHeader.Init;

            ServiceHeader.SetHideValidationDialog(true);
            ServiceHeader."Document Type" := ServiceHeaderArchive."Document Type";
            ServiceHeader."No." := ServiceHeaderArchive."No.";
            ServiceHeader.Insert(true);
            ServiceHeader.TransferFields(ServiceHeaderArchive);
            ServiceHeader.Status := ServiceHeader.Status::Open;

            //if ServiceHeaderArchive."Sell-to Contact No." <> '' then
            //    ServiceHeader.Validate("Sell-to Contact No.", ServiceHeaderArchive."Sell-to Contact No.")
            //else
            //    ServiceHeader.Validate("Sell-to Customer No.", ServiceHeaderArchive."Sell-to Customer No.");

            if ServiceHeaderArchive."Bill-to Contact No." <> '' then
                ServiceHeader.Validate("Bill-to Contact No.", ServiceHeaderArchive."Bill-to Contact No.")
            else
                ServiceHeader.Validate("Bill-to Customer No.", ServiceHeaderArchive."Bill-to Customer No.");
            ServiceHeader.Validate("Service Advisor", ServiceHeaderArchive."Service Advisor");
            ServiceHeader.Validate("Payment Terms Code", ServiceHeaderArchive."Payment Terms Code");
            ServiceHeader.Validate("Payment Discount %", ServiceHeaderArchive."Payment Discount %");
            ServiceHeader."Shortcut Dimension 1 Code" := ServiceHeaderArchive."Shortcut Dimension 1 Code";
            ServiceHeader."Shortcut Dimension 2 Code" := ServiceHeaderArchive."Shortcut Dimension 2 Code";


            ServiceHeader.Modify(true);

            case ServiceHeaderArchive."Document Type" of
                ServiceHeaderArchive."document type"::Quote:
                    ServCommentLineArchive.SetRange(Type, ServCommentLineArchive.Type::"Service Quote");
                ServiceHeaderArchive."document type"::Order:
                    ServCommentLineArchive.SetRange(Type, ServCommentLineArchive.Type::"Service Order");
                ServiceHeaderArchive."document type"::"Return Order":
                    ServCommentLineArchive.SetRange(Type, ServCommentLineArchive.Type::"Service Return Order");
            end;

            ServCommentLineArchive.SetRange("No.", ServiceHeaderArchive."No.");
            ServCommentLineArchive.SetRange("Doc. No. Occurrence", ServiceHeaderArchive."Doc. No. Occurrence");
            ServCommentLineArchive.SetRange("Version No.", ServiceHeaderArchive."Version No.");
            if ServCommentLineArchive.FindSet then
                repeat
                    ServiceCommentLine.Init;
                    ServiceCommentLine.TransferFields(ServCommentLineArchive);
                    ServiceCommentLine.Insert;
                until ServCommentLineArchive.Next = 0;

            case ServiceHeader."Document Type" of
                ServiceHeader."document type"::Quote:
                    ServiceCommentLine.SetRange(Type, ServiceCommentLine.Type::"Service Quote");
                ServiceHeader."document type"::Order:
                    ServiceCommentLine.SetRange(Type, ServiceCommentLine.Type::"Service Order");
                ServiceHeader."document type"::"Return Order":
                    ServiceCommentLine.SetRange(Type, ServiceCommentLine.Type::"Service Return Order");
            end;
            ServiceCommentLine.SetRange("No.", ServiceHeader."No.");
            if ServiceCommentLine.FindLast then
                NextLine := ServiceCommentLine."Line No.";
            NextLine += 10000;
            ServiceCommentLine.Init;
            case ServiceHeader."Document Type" of
                ServiceHeader."document type"::Quote:
                    ServiceCommentLine.Type := ServiceCommentLine.Type::"Service Quote";
                ServiceHeader."document type"::Order:
                    ServiceCommentLine.Type := ServiceCommentLine.Type::"Service Order";
                ServiceHeader."document type"::"Return Order":
                    ServiceCommentLine.Type := ServiceCommentLine.Type::"Service Return Order";
            end;
            ServiceCommentLine."No." := ServiceHeader."No.";
            ServiceCommentLine."Line No." := NextLine;
            ServiceCommentLine.Date := WorkDate;
            ServiceCommentLine.Comment := StrSubstNo(Text004, Format(ServiceHeaderArchive."Version No."));
            ServiceCommentLine."User ID" := UserId;
            ServiceCommentLine.Insert;

            ServiceLineArchive.SetRange("Document Type", ServiceHeaderArchive."Document Type");
            ServiceLineArchive.SetRange("Document No.", ServiceHeaderArchive."No.");
            ServiceLineArchive.SetRange("Doc. No. Occurrence", ServiceHeaderArchive."Doc. No. Occurrence");
            ServiceLineArchive.SetRange("Version No.", ServiceHeaderArchive."Version No.");
            if ServiceLineArchive.FindSet then begin
                repeat
                    ServiceLine.Init;
                    ServiceLine.TransferFields(ServiceLineArchive);
                    ServiceLine.Insert(true);
                    if ServiceLine.Type <> ServiceLine.Type::Comment then begin
                        if ServiceLineArchive."No." <> '' then
                            ServiceLine.Validate("No.");
                        if ServiceLineArchive."Variant Code" <> '' then
                            ServiceLine.Validate("Variant Code", ServiceLineArchive."Variant Code");
                        if ServiceLineArchive."Unit of Measure Code" <> '' then
                            ServiceLine.Validate("Unit of Measure Code", ServiceLineArchive."Unit of Measure Code");
                        //IF Quantity <> 0 THEN
                        ServiceLine.Validate(Quantity, ServiceLineArchive.Quantity);
                        ServiceLine.Validate("Unit Price", ServiceLineArchive."Unit Price");
                        ServiceLine.Validate("Line Discount %", ServiceLineArchive."Line Discount %");
                        //IF ServiceLineArchive."Inv. Discount Amount" <> 0 THEN
                        //  VALIDATE("Inv. Discount Amount", ServiceLineArchive."Inv. Discount Amount");
                        if ServiceLine.Amount <> ServiceLineArchive.Amount then
                            ServiceLine.Validate(Amount, ServiceLineArchive.Amount);
                        ServiceLine.Validate(Description, ServiceLineArchive.Description);
                    end;
                    ServiceLine."Shortcut Dimension 1 Code" := ServiceLineArchive."Shortcut Dimension 1 Code";
                    ServiceLine."Shortcut Dimension 2 Code" := ServiceLineArchive."Shortcut Dimension 2 Code";


                    ServiceLine.Modify(true);
                until ServiceLineArchive.Next = 0;
            end;
            ServiceHeader.Status := ServiceHeader.Status::Released;
            ELVAReleaseServiceDoC.Reopen(ServiceHeader);
            Message(EDMSText002, ServiceHeader."Document Type", ServiceHeader."No.");
        end;
    end;


    procedure ArchiveContract(var Contract: Record Contract)
    begin
        if Confirm(
          EDMSText007, true,
          Contract."Contract No.")
        then begin
            StoreContract(Contract, false);
            Message(Text001, Contract."Contract No.");
        end;
    end;


    procedure StoreContract(var Contract: Record Contract; InteractionExist: Boolean)
    var
        ContractSigner: Record "Contract Signer";
        ContractSalesPrice: Record "Contract Sales Price";
        ContractSalesLineDisc: Record "Contract Sales Line Discount";
        ContractArchive: Record "Contract Archive";
        ContractSignerArch: Record "Contract Signer Archive";
        ContractSalesPriceArch: Record "Contract Sales Price Archive";
        ContractSalesLineDiscArch: Record "Contract Sales Line Disc.Arch.";
    begin
        ContractArchive.Init;
        ContractArchive.TransferFields(Contract);
        ContractArchive."Archived By" := UserId;
        ContractArchive."Date Archived" := WorkDate;
        ContractArchive."Time Archived" := Time;
        ContractArchive."Version No." := ArchiveManagement.GetNextVersionNo(
          Database::Contract, 0, Contract."Contract No.", Contract."Doc. No. Occurrence");
        ContractArchive."Interaction Exist" := InteractionExist;
        ContractArchive.Insert;


        StoreContractComments(
          Contract."Contract No.",
          Contract."Doc. No. Occurrence", ContractArchive."Version No.");

        //ContractSigner.SETRANGE("Contract Type", Contract."Contract Type");
        ContractSigner.SetRange("Contract No.", Contract."Contract No.");
        if ContractSigner.FindSet then
            repeat
                ContractSignerArch.Init;
                ContractSignerArch.TransferFields(ContractSigner);
                ContractSignerArch."Doc. No. Occurrence" := Contract."Doc. No. Occurrence";
                ContractSignerArch."Version No." := ContractArchive."Version No.";
                ContractSignerArch.Insert;
            until ContractSigner.Next = 0;

        //ContractSalesPrice.SETRANGE("Contract Type", Contract."Contract Type");
        ContractSalesPrice.SetRange("Contract No.", Contract."Contract No.");
        if ContractSalesPrice.FindSet then
            repeat
                ContractSalesPriceArch.Init;
                ContractSalesPriceArch.TransferFields(ContractSalesPrice);
                ContractSalesPriceArch."Doc. No. Occurrence" := Contract."Doc. No. Occurrence";
                ContractSalesPriceArch."Version No." := ContractArchive."Version No.";
                ContractSalesPriceArch.Insert;
            until ContractSalesPrice.Next = 0;

        //ContractSalesLineDisc.SETRANGE("Contract Type", Contract."Contract Type");
        ContractSalesLineDisc.SetRange("Contract No.", Contract."Contract No.");
        if ContractSalesLineDisc.FindSet then
            repeat
                ContractSalesLineDiscArch.Init;
                ContractSalesLineDiscArch.TransferFields(ContractSalesLineDisc);
                ContractSalesLineDiscArch."Doc. No. Occurrence" := Contract."Doc. No. Occurrence";
                ContractSalesLineDiscArch."Version No." := ContractArchive."Version No.";
                ContractSalesLineDiscArch.Insert;
            until ContractSalesLineDisc.Next = 0;
    end;

    local procedure StoreContractComments(ContractNo: Code[20]; DocNoOccurrence: Integer; VersionNo: Integer)
    var
        ServiceCommentLine: Record "Service Comment Line EDMS";
        ServiceCommentLineArch: Record "Serv. Comment Line Arch. EDMS";
    begin
        ServiceCommentLine.SetRange(Type, ServiceCommentLine.Type::Contract);
        ServiceCommentLine.SetRange("No.", ContractNo);
        if ServiceCommentLine.FindSet then
            repeat
                ServiceCommentLineArch.Init;
                ServiceCommentLineArch.TransferFields(ServiceCommentLine);
                ServiceCommentLineArch."Doc. No. Occurrence" := DocNoOccurrence;
                ServiceCommentLineArch."Version No." := VersionNo;
                ServiceCommentLineArch.Insert;
            until ServiceCommentLine.Next = 0;
    end;


    procedure RestoreContract(var ContractArchive: Record "Contract Archive")
    var
        ContractSigner: Record "Contract Signer";
        ContractSalesPrice: Record "Contract Sales Price";
        ContractSalesLineDisc: Record "Contract Sales Line Discount";
        ContractSalesLineDiscBrowse: Record "Contract Sales Line Discount";
        Contract: Record Contract;
        ContractSignerArch: Record "Contract Signer Archive";
        ContractSalesPriceArch: Record "Contract Sales Price Archive";
        ContractSalesLineDiscArch: Record "Contract Sales Line Disc.Arch.";
        ServiceHeader: Record "Service Header EDMS";
        ServiceLine: Record "Service Line EDMS";
        ServiceLineArchive: Record "Service Line Archive";
        SalesShptHeader: Record "Sales Shipment Header";
        SalesInvHeader: Record "Sales Invoice Header";
        ReservEntry: Record "Reservation Entry";
        ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
        ServiceCommentLine: Record "Service Comment Line EDMS";
        ServCommentLineArchive: Record "Serv. Comment Line Arch. EDMS";
        SalesPost: Codeunit "Sales-Post";
        DimMgt: Codeunit DimensionManagement;
        NextLine: Integer;
        ConfirmRequired: Boolean;
        RestoreDocument: Boolean;
        LaborAllocApp: Record "Serv. Labor Alloc. Application";
    begin
        if not (Contract.Get(ContractArchive."Contract No.")) then
            Error(EDMSText007, ContractArchive."Contract No.");

        Contract.TestField(Status, Contract.Status::Inactive);

        RestoreDocument := false;

        if Confirm(
          EDMSText002, true,
          ContractArchive."Contract No.", ContractArchive."Version No.")
        then
            RestoreDocument := true;

        if RestoreDocument then begin
            Contract.TestField("Doc. No. Occurrence", Contract."Doc. No. Occurrence");
            Contract.Delete(true);
            Contract.Init;

            Contract."Contract No." := ContractArchive."Contract No.";
            Contract.Insert(true);
            Contract.TransferFields(ContractArchive);
            Contract.Status := Contract.Status::Inactive;
            Contract.Modify(true);

            ServCommentLineArchive.SetRange(Type, ServCommentLineArchive.Type::Contract);
            ServCommentLineArchive.SetRange("No.", ContractArchive."Contract No.");
            ServCommentLineArchive.SetRange("Doc. No. Occurrence", ContractArchive."Doc. No. Occurrence");
            ServCommentLineArchive.SetRange("Version No.", ContractArchive."Version No.");
            if ServCommentLineArchive.FindSet then
                repeat
                    ServiceCommentLine.Init;
                    ServiceCommentLine.TransferFields(ServCommentLineArchive);
                    ServiceCommentLine.Insert;
                until ServCommentLineArchive.Next = 0;

            //ContractSignerArch.SETRANGE("Contract Type", ContractArchive."Contract Type");
            ContractSignerArch.SetRange("Contract No.", ContractArchive."Contract No.");
            ContractSignerArch.SetRange("Doc. No. Occurrence", ContractArchive."Doc. No. Occurrence");
            ContractSignerArch.SetRange("Version No.", ContractArchive."Version No.");
            if ContractSignerArch.FindSet then begin
                repeat
                    ContractSigner.Init;
                    ContractSigner.TransferFields(ContractSignerArch);
                    ContractSigner.Insert(true);
                until ContractSignerArch.Next = 0;
            end;

            //ContractSalesPriceArch.SETRANGE("Contract Type", ContractArchive."Contract Type");
            ContractSalesPriceArch.SetRange("Contract No.", ContractArchive."Contract No.");
            ContractSalesPriceArch.SetRange("Doc. No. Occurrence", ContractArchive."Doc. No. Occurrence");
            ContractSalesPriceArch.SetRange("Version No.", ContractArchive."Version No.");
            if ContractSalesPriceArch.FindSet then begin
                repeat
                    ContractSalesPrice.Init;
                    ContractSalesPrice.TransferFields(ContractSalesPriceArch);
                    ContractSalesPrice.Insert(true);
                until ContractSalesPriceArch.Next = 0;
            end;

            //ContractSalesLineDiscArch.SETRANGE("Contract Type", ContractArchive."Contract Type");
            ContractSalesLineDiscArch.SetRange("Contract No.", ContractArchive."Contract No.");
            ContractSalesLineDiscArch.SetRange("Doc. No. Occurrence", ContractArchive."Doc. No. Occurrence");
            ContractSalesLineDiscArch.SetRange("Version No.", ContractArchive."Version No.");
            if ContractSalesLineDiscArch.FindSet then begin
                repeat
                    ContractSalesLineDisc.Init;
                    ContractSalesLineDisc.TransferFields(ContractSalesLineDiscArch);
                    if ContractSalesLineDisc."Line No." = 0 then begin  //15.01.2014 EDMS P8
                        ContractSalesLineDiscBrowse.SetRange("Contract Type", ContractSalesLineDisc."Contract Type");
                        ContractSalesLineDiscBrowse.SetRange("Contract No.", ContractSalesLineDisc."Contract No.");
                        if ContractSalesLineDiscBrowse.FindLast then
                            ContractSalesLineDisc."Line No." := ContractSalesLineDiscBrowse."Line No.";
                        ContractSalesLineDisc."Line No." += 10000;
                    end;
                    ContractSalesLineDisc.Insert(true);
                until ContractSalesLineDiscArch.Next = 0;
            end;

            Message(EDMSText002, Contract."Contract No.");
        end;
    end;


    procedure AssemblyToArchive(VehSerialNo: Code[20]; AssemblyID: Code[20]; VersionNo: Integer): Integer
    var
        VehicleAssemblyHeaderArch: Record "Vehicle Assembly Header Arch.";
        VehicleAssemblyArch: Record "Vehicle Assembly Line Arch.";
        VehicleAssemblyHeader: Record "Vehicle Assembly Header";
        VehicleAssembly: Record "Vehicle Assembly Line";
    begin
        if not VehicleAssemblyHeader.Get(AssemblyID) then
            exit(0);
        VersionNo := ArchiveManagement.GetNextVersionNo(Database::"Vehicle Assembly Header", 0, AssemblyID, 0);

        VehicleAssemblyHeaderArch.Init;
        VehicleAssemblyHeaderArch.TransferFields(VehicleAssemblyHeader);
        VehicleAssemblyHeaderArch."Version No." := VersionNo;
        VehicleAssemblyHeaderArch."Archived By" := UserId;
        VehicleAssemblyHeaderArch."Date Archived" := WorkDate;
        VehicleAssemblyHeaderArch."Time Archived" := Time;
        VehicleAssemblyHeaderArch.Insert(true);

        VehicleAssembly.Reset;
        VehicleAssembly.SetRange("Serial No.", VehSerialNo);
        VehicleAssembly.SetRange("Assembly ID", AssemblyID);
        if VehicleAssembly.FindFirst then
            with VehicleAssemblyArch do begin
                repeat
                    VehicleAssemblyArch.Init;
                    VehicleAssemblyArch.TransferFields(VehicleAssembly);
                    VehicleAssemblyArch."Version No." := VersionNo;
                    VehicleAssemblyArch.Insert(true);
                until VehicleAssembly.Next = 0;
            end;
        exit(VersionNo);
    end;


    procedure AssemblyFromArchive(VehSerialNo: Code[20]; AssemblyID: Code[20]; VersionNo: Integer)
    var
        VehicleAssemblyHeaderArch: Record "Vehicle Assembly Header Arch.";
        VehicleAssemblyArch: Record "Vehicle Assembly Line Arch.";
        VehicleAssemblyHeader: Record "Vehicle Assembly Header";
        VehicleAssembly: Record "Vehicle Assembly Line";
    begin
        if not VehicleAssemblyHeaderArch.Get(AssemblyID, VersionNo) then
            exit;
        VehicleAssemblyHeader.Init;
        VehicleAssemblyHeader.TransferFields(VehicleAssemblyHeaderArch);
        VehicleAssemblyHeader.Insert(true);

        VehicleAssemblyArch.Reset;
        VehicleAssemblyArch.SetRange("Serial No.", VehSerialNo);
        VehicleAssemblyArch.SetRange("Assembly ID", AssemblyID);
        VehicleAssemblyArch.SetRange("Version No.", VersionNo);
        if VehicleAssemblyArch.FindFirst then
            with VehicleAssembly do begin
                repeat
                    VehicleAssembly.Init;
                    VehicleAssembly.TransferFields(VehicleAssemblyArch);
                    VehicleAssembly.Insert(true);
                until VehicleAssemblyArch.Next = 0;
            end;
    end;



    procedure ArchiveProcessChecklistDocument(var ProcessChecklistHeader: Record "Process Checklist Header")
    begin
        if Confirm(
          EDMSText101, true,
          ProcessChecklistHeader."No.")
        then begin
            StoreProcessChecklistDocument(ProcessChecklistHeader, 0, 0);
            Message(Text001, ProcessChecklistHeader."No.");
        end;
    end;


    procedure StoreProcessChecklistDocument(var ProcessChecklistHeader: Record "Process Checklist Header"; VHCDocOccurenceNo: Integer; VHCDocVersionNo: Integer)
    var
        ProcessChecklistLine: Record "Process Checklist Line";
        ProcessChecklistHeaderArchive: Record "Process Checklist Header Arch.";
        ProcessChecklistLineArchive: Record "Process Checklist Line Arch.";
    begin
        ProcessChecklistHeaderArchive.Init;
        ProcessChecklistHeaderArchive.TransferFields(ProcessChecklistHeader);
        ProcessChecklistHeaderArchive."Archived By" := UserId;
        ProcessChecklistHeaderArchive."Date Archived" := WorkDate;
        ProcessChecklistHeaderArchive."Time Archived" := Time;
        ProcessChecklistHeaderArchive."Version No." := ArchiveManagement.GetNextVersionNo(
          Database::"Process Checklist Header Arch.", 0, ProcessChecklistHeader."No.", ProcessChecklistHeader."Doc. No. Occurrence");
        ProcessChecklistHeaderArchive."VHC Doc. No. Occurrence" := VHCDocOccurenceNo;
        ProcessChecklistHeaderArchive."VHC Version No." := VHCDocVersionNo;
        ProcessChecklistHeaderArchive.Insert;

        ProcessChecklistLine.SetRange("Process Checklist No.", ProcessChecklistHeader."No.");
        if ProcessChecklistLine.FindSet then
            repeat
                ProcessChecklistLineArchive.Init;
                ProcessChecklistLineArchive.TransferFields(ProcessChecklistLine);
                ProcessChecklistLineArchive."Doc. No. Occurrence" := ProcessChecklistHeader."Doc. No. Occurrence";
                ProcessChecklistLineArchive."Version No." := ProcessChecklistHeaderArchive."Version No.";
                ProcessChecklistLineArchive.Insert;
            until ProcessChecklistLine.Next = 0;
    end;


    procedure ArchiveProcessChecklistDocumentNoConfirm(var ProcessChecklistHeader: Record "Process Checklist Header")
    begin
        StoreProcessChecklistDocument(ProcessChecklistHeader, 0, 0);
    end;


    procedure StorePictures(SourceType: Integer; SourceSubType: Integer; SourceId: Code[20]; ArchSourceType: Integer; ArchSourceSubType: Integer; ArchSourceId: Code[20]; DocNoOccurrence: Integer; VersionNo: Integer)
    var
        Picture: Record Picture;
        PictureNew: Record Picture;
    begin
        Picture.Reset;
        Picture.SetRange("Source Type", SourceType);
        Picture.SetRange("Source Subtype", SourceSubType);
        Picture.SetRange("Source ID", SourceId);
        if Picture.FindSet then
            repeat
                PictureNew.Init;
                PictureNew := Picture;
                PictureNew."No." := '';
                PictureNew."Source Type" := ArchSourceType;
                PictureNew."Source Subtype" := ArchSourceSubType;
                PictureNew."Source ID" := ArchSourceId;
                PictureNew."Doc. No. Occurrence" := DocNoOccurrence;
                PictureNew."Version No." := VersionNo;
                PictureNew.Insert(true);
            until Picture.Next = 0;
    end;

    local procedure DetermineServiceSeriesNo(DocType: Option Quote,"Order","Return Order",Booking): Code[10]
    var
        ServiceMgtSetup: Record "Service Mgt. Setup EDMS";
    begin
        ServiceMgtSetup.Get;
        case DocType of
            Doctype::Quote:
                exit(ServiceMgtSetup."Quote Nos.");
            Doctype::Order:
                exit(ServiceMgtSetup."Order Nos.");
            Doctype::"Return Order":
                exit(ServiceMgtSetup."Return Order Nos.");
            Doctype::Booking:
                exit(ServiceMgtSetup."Service Booking Nos.");
        end;
    end;

    procedure ServiceDocumentNoIsVisible(DocType: Option Quote,"Order","Return Order",Booking; DocNo: Code[20]): Boolean
    var
        NoSeries: Record "No. Series";
        ServiceNoSeriesSetup: Page "Service No. Series Setup EDMS";
        DocNoSeries: Code[10];
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
    begin
        if DocNo <> '' then
            exit(false);

        DocNoSeries := DetermineServiceSeriesNo(DocType);

        if not NoSeries.Get(DocNoSeries) then begin
            ServiceNoSeriesSetup.SetFieldsVisibility(DocType);
            ServiceNoSeriesSetup.RunModal;
            DocNoSeries := DetermineServiceSeriesNo(DocType);
            if not NoSeries.Get(DocNoSeries) then
                exit(true);
        end;

        exit(DocumentNoVisibility.ForceShowNoSeriesForDocNo(DocNoSeries));
    end;

    procedure VehicleSerialNoIsVisible(SerialNo: Code[20]): Boolean
    var
        NoSeries: Record "No. Series";
        SerialNoSeriesSetup: Page "Service No. Series Setup EDMS";
        SerialNoSeries: Code[10];
        VehicleNoSeriesSetup: Page "Vehicle No. Series Setup";
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
    begin
        if SerialNo <> '' then
            exit(false);

        SerialNoSeries := DetermineVehicleSeriesNo;

        if not NoSeries.Get(SerialNoSeries) then begin
            VehicleNoSeriesSetup.RunModal;
            SerialNoSeries := DetermineVehicleSeriesNo;
            if not NoSeries.Get(SerialNoSeries) then
                exit(true);
        end;
        exit(DocumentNoVisibility.ForceShowNoSeriesForDocNo(SerialNoSeries));
    end;

    local procedure DetermineVehicleSeriesNo(): Code[10]
    var
        InventorySetup: Record "Inventory Setup";
    begin
        InventorySetup.Get;
        exit(InventorySetup."Vehicle Serial No. Nos.");
    end;
}



