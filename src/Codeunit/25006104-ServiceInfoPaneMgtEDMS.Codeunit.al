Codeunit 25006104 "Service Info-Pane Mgt. EDMS"
{
    // 16.03.2016 EB.P7 Branch Profile Setup
    //   Modified CalcAvailability(), Usert Profile Setup to Branch Profile Setup
    // 
    // 14.05.2014 Elva Baltic P8 #S0038 MMG7.00
    //   * PERFORMANCE ISSUE resolve
    // 
    // 10.05.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added functions:
    //     GetVehicleDocCount
    //     LookupVehicleDoc
    // 
    // 30.01.2014 Elva Baltic P8 #F038 MMG7.00
    //   * Added functions *VehicleContracts*, *VehicleWarranty*
    // 
    // 26.04.2013 EDMS P8
    //   * Added functions: LookupRet*


    trigger OnRun()
    begin
    end;

    var
        Cust: Record Customer;
        Item: Record Item;
        ServiceHeader: Record "Service Header EDMS";
        ServPlanDocumentLink: Record "Service Plan Document Link";
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt. edms";
        Text000: label 'The Ship-to Address has been changed.';
        cuLookUpMgt: Codeunit LookUpManagement;
        Text001: label 'Pending';
        Text002: label 'Serviced';
        Text003: label 'In Process';
        Text004: label 'Skipped';
        UOMMgt: Codeunit "Unit of Measure Management";



    procedure CalcNoOfDocuments(var Cust: Record Customer)
    begin
        Cust.CalcFields(
          "No. of Quotes", "No. of Blanket Orders", "No. of Orders", "No. of Invoices",
          "No. of Return Orders", "No. of Credit Memos", "No. of Pstd. Shipments",
          "No. of Pstd. Invoices", "No. of Pstd. Return Receipts", "No. of Pstd. Credit Memos");
    end;


    procedure CalcTotalNoOfDocuments(CustNo: Code[20]): Integer
    begin
        GetCust(CustNo);
        CalcNoOfDocuments(Cust);
        exit(
          Cust."No. of Quotes" + Cust."No. of Blanket Orders" + Cust."No. of Orders" + Cust."No. of Invoices" +
          Cust."No. of Return Orders" + Cust."No. of Credit Memos" + Cust."No. of Pstd. Shipments" +
          Cust."No. of Pstd. Invoices" + Cust."No. of Pstd. Return Receipts" + Cust."No. of Pstd. Credit Memos");
    end;


    procedure CalcNoOfShipToAddr(CustNo: Code[20]): Integer
    begin
        GetCust(CustNo);
        Cust.CalcFields("No. of Ship-to Addresses");
        exit(Cust."No. of Ship-to Addresses");
    end;


    procedure CalcNoOfContacts(ServiceHeader: Record "Service Header EDMS"): Integer
    var
        Cont: Record Contact;
        ContBusRelation: Record "Contact Business Relation";
    begin
        Cont.SetCurrentkey("Company No.");
        if ServiceHeader."Sell-to Customer No." <> '' then begin
            if Cont.Get(ServiceHeader."Sell-to Contact No.") then
                Cont.SetRange("Company No.", Cont."Company No.")
            else begin
                ContBusRelation.Reset;
                ContBusRelation.SetCurrentkey("Link to Table", "No.");
                ContBusRelation.SetRange("Link to Table", ContBusRelation."link to table"::Customer);
                ContBusRelation.SetRange("No.", ServiceHeader."Sell-to Customer No.");
                if ContBusRelation.FindFirst then
                    Cont.SetRange("Company No.", ContBusRelation."Contact No.")
                else
                    Cont.SetRange("No.", '');
            end;
            exit(Cont.Count);
        end;
    end;


    procedure CalcAvailableCredit(CustNo: Code[20]): Decimal
    var
        TotalAmountLCY: Decimal;
    begin
        GetCust(CustNo);
        Cust.SetRange("Date Filter", 0D, WorkDate);
        Cust.CalcFields("Balance (LCY)", "Outstanding Orders (LCY)", "Shipped Not Invoiced (LCY)");
        TotalAmountLCY := Cust."Balance (LCY)" + Cust."Outstanding Orders (LCY)" + Cust."Shipped Not Invoiced (LCY)";

        if Cust."Credit Limit (LCY)" <> 0 then
            exit(Cust."Credit Limit (LCY)" - TotalAmountLCY);
    end;


    procedure CalcAvailability(var recServiceLine: Record "Service Line EDMS"): Decimal
    var
        UserProfile: Record "Branch Profile Setup";
        AvailableToPromise: Codeunit "Available to Promise";
        SingleInstanceMgt: Codeunit SingleInstanceManagement;
        LocationCode: Code[20];
        GrossRequirement: Decimal;
        ScheduledReceipt: Decimal;
        PeriodType: Option Day,Week,Month,Quarter,Year;
        AvailabilityDate: Date;
        LookaheadDateformula: DateFormula;
        UserProfileMgt: Codeunit UserProfileManagement;
    begin
        if GetItem(recServiceLine) then begin
            if recServiceLine."Planned Service Date" <> 0D then
                AvailabilityDate := recServiceLine."Planned Service Date"
            else
                AvailabilityDate := WorkDate;

            //25.02.2010 EDMSB P2 >>
            LocationCode := recServiceLine."Location Code";
            if UserProfile.Get(UserProfileMgt.CurrProfileID, UserProfileMgt.CurrBranchNo) and (UserProfile."Def. Spare Part Location Code" <> '') then
                LocationCode := UserProfile."Def. Spare Part Location Code";
            //25.02.2010 EDMSB P2 <<

            Item.Reset;
            Item.SetRange("Date Filter", 0D, AvailabilityDate);
            Item.SetRange("Variant Filter", recServiceLine."Variant Code");
            Item.SetRange("Location Filter", LocationCode);
            Item.SetRange("Drop Shipment Filter", false);

            exit(
              AvailableToPromise.CalcQtyAvailableToPromise(
                Item,
                GrossRequirement,
                ScheduledReceipt,
                AvailabilityDate,
                PeriodType,
                LookaheadDateformula));
        end;
    end;


    procedure CalcNoOfSubstitutions(var recServiceLine: Record "Service Line EDMS"): Integer
    begin
        if GetItem(recServiceLine) then begin
            Item.CalcFields("No. of Substitutes");
            exit(Item."No. of Substitutes");
        end;
    end;


    procedure CalcNoOfSalesPrices(var recServiceLine: Record "Service Line EDMS"): Integer
    Var
        SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management";
        SalesPriceDMS: Codeunit "Sales Price Calc. Mgt. EDMS";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        if GetItem(recServiceLine) then begin
            GetServiceHeader(recServiceLine);
            SalesPriceDMS.CreateSalesDocument(ServiceHeader, recServiceLine, SalesHeader, SalesLine);
            SalesLine.SetSalesHeader(SalesHeader);
            exit(SalesInfoPaneMgt.CalcNoOfSalesPrices(SalesLine))
        end
        Else
            exit(SalesPriceDMS.NoOfServLinePriceEDMS(ServiceHeader, recServiceLine, true))
    end;


    procedure CalcNoOfSalesLineDisc(var recServiceLine: Record "Service Line EDMS"): Integer
    Var
        SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management";
        SalesPriceDMS: Codeunit "Sales Price Calc. Mgt. EDMS";
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        if GetItem(recServiceLine) then begin
            GetServiceHeader(recServiceLine);
            SalesPriceDMS.CreateSalesDocument(ServiceHeader, recServiceLine, SalesHeader, SalesLine);
            SalesLine.SetSalesHeader(SalesHeader);
            exit(SalesInfoPaneMgt.CalcNoOfSalesLineDisc(SalesLine));
        end
        else begin
            exit(SalesPriceDMS.NoOfServLineLineDiscEDMS(ServiceHeader, recServiceLine, true))

        end;

    end;


    procedure DocExist(CurrentSalesHeader: Record "Sales Header"; CustNo: Code[20]): Boolean
    var
        SalesInvHeader: Record "Sales Invoice Header";
        SalesShptHeader: Record "Sales Shipment Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        ReturnReceipt: Record "Return Receipt Header";
        SalesHeader: Record "Sales Header";
    begin
        if CustNo = '' then
            exit(false);
        SalesInvHeader.SetCurrentkey("Sell-to Customer No.");
        SalesInvHeader.SetRange("Sell-to Customer No.", CustNo);
        if not SalesInvHeader.IsEmpty then
            exit(true);
        SalesShptHeader.SetCurrentkey("Sell-to Customer No.");
        SalesShptHeader.SetRange("Sell-to Customer No.", CustNo);
        if not SalesShptHeader.IsEmpty then
            exit(true);
        SalesCrMemoHeader.SetCurrentkey("Sell-to Customer No.");
        SalesCrMemoHeader.SetRange("Sell-to Customer No.", CustNo);
        if not SalesCrMemoHeader.IsEmpty then
            exit(true);
        SalesHeader.SetCurrentkey("Sell-to Customer No.");
        SalesHeader.SetRange("Sell-to Customer No.", CustNo);
        if SalesHeader.FindFirst then begin
            if (SalesHeader."Document Type" <> CurrentSalesHeader."Document Type") or
               (SalesHeader."No." <> CurrentSalesHeader."No.")
            then
                exit(true);
            if SalesHeader.Find('>') then
                exit(true);
        end;
        ReturnReceipt.SetCurrentkey("Sell-to Customer No.");
        ReturnReceipt.SetRange("Sell-to Customer No.", CustNo);
        if not ReturnReceipt.IsEmpty then
            exit(true);
    end;


    procedure CustCommentExists(CustNo: Code[20]): Boolean
    begin
        GetCust(CustNo);
        Cust.CalcFields(Comment);
        exit(Cust.Comment);
    end;


    procedure ItemCommentExists(recServiceLine: Record "Service Line EDMS"): Boolean
    begin
        if GetItem(recServiceLine) then begin
            Item.CalcFields(Comment);
            exit(Item.Comment);
        end;
    end;


    procedure LookupShipToAddr(var SalesHeader: Record "Sales Header")
    var
        ShipToAddr: Record "Ship-to Address";
    begin
        ShipToAddr.SetRange("Customer No.", SalesHeader."Sell-to Customer No.");
        if Page.RunModal(0, ShipToAddr) = Action::LookupOK then begin
            SalesHeader.Validate("Ship-to Code", ShipToAddr.Code);
            SalesHeader.Modify(true);
            Message(Text000);
        end;
    end;


    procedure LookupContacts(var SalesHeader: Record "Sales Header")
    var
        Cont: Record Contact;
        ContBusRelation: Record "Contact Business Relation";
    begin
        if (SalesHeader."Sell-to Customer No." <> '') and (Cont.Get(SalesHeader."Sell-to Contact No.")) then
            Cont.SetRange("Company No.", Cont."Company No.")
        else
            if SalesHeader."Sell-to Customer No." <> '' then begin
                ContBusRelation.Reset;
                ContBusRelation.SetCurrentkey("Link to Table", "No.");
                ContBusRelation.SetRange("Link to Table", ContBusRelation."link to table"::Customer);
                ContBusRelation.SetRange("No.", SalesHeader."Sell-to Customer No.");
                if ContBusRelation.FindFirst then
                    Cont.SetRange("Company No.", ContBusRelation."Contact No.");
            end else
                Cont.SetFilter("Company No.", '<>''''');

        if SalesHeader."Sell-to Contact No." <> '' then
            if Cont.Get(SalesHeader."Sell-to Contact No.") then;
        if Page.RunModal(0, Cont) = Action::LookupOK then begin
            SalesHeader.Validate("Sell-to Contact No.", Cont."No.");
            SalesHeader.Modify(true);
        end;
    end;


    procedure LookupServContacts(var ServiceHeader: Record "Service Header EDMS")
    var
        Cont: Record Contact;
        ContBusRelation: Record "Contact Business Relation";
    begin
        if (ServiceHeader."Sell-to Customer No." <> '') and (Cont.Get(ServiceHeader."Sell-to Contact No.")) then
            Cont.SetRange("Company No.", Cont."Company No.")
        else
            if ServiceHeader."Sell-to Customer No." <> '' then begin
                ContBusRelation.Reset;
                ContBusRelation.SetCurrentkey("Link to Table", "No.");
                ContBusRelation.SetRange("Link to Table", ContBusRelation."link to table"::Customer);
                ContBusRelation.SetRange("No.", ServiceHeader."Sell-to Customer No.");
                if ContBusRelation.FindFirst then
                    Cont.SetRange("Company No.", ContBusRelation."Contact No.");
            end else
                Cont.SetFilter("Company No.", '<>''''');

        if ServiceHeader."Sell-to Contact No." <> '' then
            if Cont.Get(ServiceHeader."Sell-to Contact No.") then;
        if Page.RunModal(0, Cont) = Action::LookupOK then begin
            ServiceHeader.Validate("Sell-to Contact No.", Cont."No.");
            ServiceHeader.Modify(true);
        end;
    end;


    procedure LookupAvailCredit(CustNo: Code[20])
    begin
        GetCust(CustNo);
        Page.RunModal(Page::"Available Credit", Cust);
    end;


    procedure LookupItem(recServiceLine: Record "Service Line EDMS")
    begin
        recServiceLine.TestField(Type, recServiceLine.Type::Item);
        recServiceLine.TestField("No.");
        GetItem(recServiceLine);
        Page.RunModal(Page::"Sales Invoice List", Item);
    end;


    procedure LookupItemComment(recServiceLine: Record "Service Line EDMS")
    var
        CommentLine: Record "Comment Line";
    begin
        if GetItem(recServiceLine) then begin
            CommentLine.SetRange("Table Name", CommentLine."table name"::Item);
            CommentLine.SetRange("No.", recServiceLine."No.");
            Page.RunModal(Page::"Comment Sheet", CommentLine);
        end;
    end;

    local procedure GetCust(CustNo: Code[20])
    begin
        if CustNo <> '' then begin
            if CustNo <> Cust."No." then
                if not Cust.Get(CustNo) then
                    Clear(Cust);
        end else
            Clear(Cust);
    end;

    local procedure GetItem(var recServiceLine: Record "Service Line EDMS"): Boolean
    begin
        if (recServiceLine.Type <> recServiceLine.Type::Item) or (recServiceLine."No." = '') then
            exit(false);

        if recServiceLine."No." <> Item."No." then
            Item.Get(recServiceLine."No.");
        exit(true);
    end;

    local procedure GetServiceHeader(recServiceLine: Record "Service Line EDMS")
    begin
        if (recServiceLine."Document Type" <> ServiceHeader."Document Type") or
           (recServiceLine."Document No." <> ServiceHeader."No.")
        then
            ServiceHeader.Get(recServiceLine."Document Type", recServiceLine."Document No.");
    end;


    procedure CalcNoOfBillToDocuments(var Cust: Record Customer)
    begin
        Cust.CalcFields(
          "Bill-To No. of Quotes", "Bill-To No. of Blanket Orders", "Bill-To No. of Orders", "Bill-To No. of Invoices",
          "Bill-To No. of Return Orders", "Bill-To No. of Credit Memos", "Bill-To No. of Pstd. Shipments",
          "Bill-To No. of Pstd. Invoices", "Bill-To No. of Pstd. Return R.", "Bill-To No. of Pstd. Cr. Memos");
    end;


    procedure GetServiceContractCount(ServiceHdr: Record "Service Header EDMS"): Integer
    var
        ContractHdr: Record Contract;
    begin
        ContractHdr.Reset;
        ContractHdr.SetCurrentkey("Bill-to Customer No.");
        ContractHdr.SetRange("Bill-to Customer No.", ServiceHdr."Bill-to Customer No.");
        ContractHdr.SetFilter("Document Profile", '%1|%2', ContractHdr."document profile"::" ", ContractHdr."document profile"::Service);
        exit(ContractHdr.Count);
    end;


    procedure LookupOrdTransf(ServHeader: Record "Service Header EDMS")
    var
        TransfHeader: Record "Transfer Header";
        TransfList: Page "Transfer Orders";
    begin
        Clear(TransfList);
        TransfHeader.Reset;
        TransfHeader.SetCurrentkey("Source Type", "Source Subtype", "Source No.", "Document Profile");
        TransfHeader.SetRange("Source Type", Database::"Service Header EDMS");
        TransfHeader.SetRange("Source Subtype", 1);
        TransfHeader.SetRange("Source No.", ServHeader."No.");
        TransfHeader.SetRange("Document Profile", TransfHeader."document profile"::Service);

        if TransfHeader.Count = 1 then begin
            if TransfHeader.FindFirst() then
                Page.RunModal(Page::"Transfer Order", TransfHeader);


        end else begin
            Page.RunModal(Page::"Transfer Orders", TransfHeader)
        end
    end;


    procedure LookupRetOrdTransf(ServHeader: Record "Service Header EDMS")
    var
        TransfHeader: Record "Transfer Header";
        TransfList: Page "Transfer Orders";
    begin
        Clear(TransfList);
        TransfHeader.Reset;
        TransfHeader.SetCurrentkey("Source Type", "Source Subtype", "Source No.", "Document Profile");
        TransfHeader.SetRange("Source Type", Database::"Service Header EDMS");
        TransfHeader.SetRange("Source Subtype", 2);
        TransfHeader.SetRange("Source No.", ServHeader."No.");
        TransfHeader.SetRange("Document Profile", TransfHeader."document profile"::Service);

        if TransfHeader.Count = 1 then begin
            Page.RunModal(Page::"Transfer Order", TransfHeader);
        end else begin
            Page.RunModal(Page::"Transfer Orders", TransfHeader)
        end
    end;


    procedure LookupTransferShipment(ServHeader: Record "Service Header EDMS")
    var
        TransferShipment: Record "Transfer Shipment Header";
        TransferShipmentList: Page "Posted Transfer Shipments";
    begin
        Clear(TransferShipmentList);
        TransferShipment.Reset;
        TransferShipment.SetCurrentkey("Document Profile", "Source Type", "Source Subtype", "Source No.");
        TransferShipment.SetRange("Document Profile", TransferShipment."document profile"::Service);
        TransferShipment.SetRange("Source Type", Database::"Service Header EDMS");
        TransferShipment.SetRange("Source Subtype", 1);
        TransferShipment.SetRange("Source No.", ServHeader."No.");

        if TransferShipment.Count = 1 then
            //PAGE.RUNMODAL(PAGE::"Service Line FactBox EDMS",TransferShipment) //29.05.2017 JEMEL Closed
            Page.RunModal(Page::"Posted Transfer Shipment", TransferShipment) //29.05.2017 JEMEL
        else begin
            TransferShipmentList.SetTableview(TransferShipment);
            TransferShipmentList.RunModal
        end
    end;


    procedure LookupRetTransferShipment(ServHeader: Record "Service Header EDMS")
    var
        TransferShipment: Record "Transfer Shipment Header";
        TransferShipmentList: Page "Posted Transfer Shipments";
    begin
        Clear(TransferShipmentList);
        TransferShipment.Reset;
        TransferShipment.SetCurrentkey("Document Profile", "Source Type", "Source Subtype", "Source No.");
        TransferShipment.SetRange("Document Profile", TransferShipment."document profile"::Service);
        TransferShipment.SetRange("Source Type", Database::"Service Header EDMS");
        TransferShipment.SetRange("Source Subtype", 2);
        TransferShipment.SetRange("Source No.", ServHeader."No.");

        if TransferShipment.Count = 1 then
            Page.RunModal(Page::"Service Line FactBox EDMS", TransferShipment)
        else begin
            TransferShipmentList.SetTableview(TransferShipment);
            TransferShipmentList.RunModal
        end
    end;


    procedure LookupTransferReceipt(ServHeader: Record "Service Header EDMS")
    var
        TransferReceiptHeader: Record "Transfer Receipt Header";
        TransferReceiptList: Page "Posted Transfer Receipts";
    begin
        Clear(TransferReceiptList);
        TransferReceiptHeader.Reset;
        TransferReceiptHeader.SetCurrentkey("Document Profile", "Source Type", "Source Subtype", "Source No.");
        TransferReceiptHeader.SetRange("Document Profile", TransferReceiptHeader."document profile"::Service);
        TransferReceiptHeader.SetRange("Source Type", Database::"Service Header EDMS");
        TransferReceiptHeader.SetRange("Source Subtype", 1);
        TransferReceiptHeader.SetRange("Source No.", ServHeader."No.");

        TransferReceiptList.SetTableview(TransferReceiptHeader);
        TransferReceiptList.RunModal
    end;


    procedure LookupRetTransferReceipt(ServHeader: Record "Service Header EDMS")
    var
        TransferReceiptHeader: Record "Transfer Receipt Header";
        TransferReceiptList: Page "Posted Transfer Receipts";
    begin
        Clear(TransferReceiptList);
        TransferReceiptHeader.Reset;
        TransferReceiptHeader.SetCurrentkey("Document Profile", "Source Type", "Source Subtype", "Source No.");
        TransferReceiptHeader.SetRange("Document Profile", TransferReceiptHeader."document profile"::Service);
        TransferReceiptHeader.SetRange("Source Type", Database::"Service Header EDMS");
        TransferReceiptHeader.SetRange("Source Subtype", 2);
        TransferReceiptHeader.SetRange("Source No.", ServHeader."No.");

        TransferReceiptList.SetTableview(TransferReceiptHeader);
        TransferReceiptList.RunModal
    end;


    procedure LookupServiceContracts(ServiceHdr: Record "Service Header EDMS")
    var
        ContractHdr: Record Contract;
    begin
        ContractHdr.Reset;
        ContractHdr.SetCurrentkey("Bill-to Customer No.");
        ContractHdr.FilterGroup(2);
        ContractHdr.SetRange("Bill-to Customer No.", ServiceHdr."Bill-to Customer No.");
        ContractHdr.SetFilter("Document Profile", '%1|%2', ContractHdr."document profile"::" ",
            ContractHdr."document profile"::Service);
        ContractHdr.FilterGroup(0);
        if ContractHdr.Count = 1 then
            Page.RunModal(Page::Contract, ContractHdr)
        else
            Page.RunModal(Page::"Contract List EDMS", ContractHdr);
    end;


    procedure CalcLastVisitVFRun1(VehSerialNo: Code[20]): Decimal
    var
        ServiceLedgerEntry: Record "Service Ledger Entry EDMS";
    begin
        ServiceLedgerEntry.Reset;
        ServiceLedgerEntry.SetCurrentkey("Vehicle Serial No.", "Entry Type", "Posting Date");
        ServiceLedgerEntry.SetRange("Vehicle Serial No.", VehSerialNo);
        ServiceLedgerEntry.SetRange("Entry Type", ServiceLedgerEntry."entry type"::Usage);
        if ServiceLedgerEntry.FindLast then
            exit(ServiceLedgerEntry."Variable Field Run 1")
        else
            exit(0);
    end;


    procedure CalcLastVisitVFRun2(VehSerialNo: Code[20]): Decimal
    var
        ServiceLedgerEntry: Record "Service Ledger Entry EDMS";
    begin
        ServiceLedgerEntry.Reset;
        ServiceLedgerEntry.SetCurrentkey("Vehicle Serial No.", "Entry Type", "Posting Date");
        ServiceLedgerEntry.SetRange("Vehicle Serial No.", VehSerialNo);
        ServiceLedgerEntry.SetRange("Entry Type", ServiceLedgerEntry."entry type"::Usage);
        if ServiceLedgerEntry.FindLast then
            exit(ServiceLedgerEntry."Variable Field Run 2")
        else
            exit(0);
    end;


    procedure CalcLastVisitVFRun3(VehSerialNo: Code[20]): Decimal
    var
        ServiceLedgerEntry: Record "Service Ledger Entry EDMS";
    begin
        ServiceLedgerEntry.Reset;
        ServiceLedgerEntry.SetCurrentkey("Vehicle Serial No.", "Entry Type", "Posting Date");
        ServiceLedgerEntry.SetRange("Vehicle Serial No.", VehSerialNo);
        ServiceLedgerEntry.SetRange("Entry Type", ServiceLedgerEntry."entry type"::Usage);
        if ServiceLedgerEntry.FindLast then
            exit(ServiceLedgerEntry."Variable Field Run 3")
        else
            exit(0);
    end;


    procedure CalcLastVFRun1(VehSerialNo: Code[20]): Decimal
    var
        ServiceLedgerEntry: Record "Service Ledger Entry EDMS";
    begin
        ServiceLedgerEntry.Reset;
        ServiceLedgerEntry.SetCurrentkey("Vehicle Serial No.", "Posting Date", "Entry Type");
        ServiceLedgerEntry.SetRange("Vehicle Serial No.", VehSerialNo);
        ServiceLedgerEntry.SetFilter("Entry Type", '%1|%2', ServiceLedgerEntry."entry type"::Usage, ServiceLedgerEntry."entry type"::Info);
        if ServiceLedgerEntry.FindLast then
            exit(ServiceLedgerEntry."Variable Field Run 1")
        else
            exit(0);
    end;


    procedure CalcLastVFRun2(VehSerialNo: Code[20]): Decimal
    var
        ServiceLedgerEntry: Record "Service Ledger Entry EDMS";
    begin
        ServiceLedgerEntry.Reset;
        ServiceLedgerEntry.SetCurrentkey("Vehicle Serial No.", "Posting Date", "Entry Type");
        ServiceLedgerEntry.SetRange("Vehicle Serial No.", VehSerialNo);
        ServiceLedgerEntry.SetFilter("Entry Type", '%1|%2', ServiceLedgerEntry."entry type"::Usage, ServiceLedgerEntry."entry type"::Info);
        if ServiceLedgerEntry.FindLast then
            exit(ServiceLedgerEntry."Variable Field Run 2")
        else
            exit(0);
    end;


    procedure CalcLastVFRun3(VehSerialNo: Code[20]): Decimal
    var
        ServiceLedgerEntry: Record "Service Ledger Entry EDMS";
    begin
        ServiceLedgerEntry.Reset;
        ServiceLedgerEntry.SetCurrentkey("Vehicle Serial No.", "Posting Date", "Entry Type");
        ServiceLedgerEntry.SetRange("Vehicle Serial No.", VehSerialNo);
        ServiceLedgerEntry.SetFilter("Entry Type", '%1|%2', ServiceLedgerEntry."entry type"::Usage, ServiceLedgerEntry."entry type"::Info);
        if ServiceLedgerEntry.FindLast then
            exit(ServiceLedgerEntry."Variable Field Run 3")
        else
            exit(0);
    end;


    procedure CalcLastVisitDate(VehSerialNo: Code[20]): Date
    var
        ServiceLedgerEntry: Record "Service Ledger Entry EDMS";
    begin
        ServiceLedgerEntry.Reset;
        ServiceLedgerEntry.SetCurrentkey("Vehicle Serial No.", "Entry Type", "Posting Date");
        ServiceLedgerEntry.SetRange("Vehicle Serial No.", VehSerialNo);
        ServiceLedgerEntry.SetRange("Entry Type", ServiceLedgerEntry."entry type"::Usage);
        if ServiceLedgerEntry.FindLast then
            exit(ServiceLedgerEntry."Posting Date")
        else
            exit(0D);
    end;


    procedure CalcVehSalesDate(VehSerialNo: Code[20]): Date
    var
        Vehicle: Record Vehicle;
    begin
        Vehicle.Reset;
        if Vehicle.Get(VehSerialNo) then
            exit(Vehicle."Sales Date");
    end;


    procedure LookupServiceHistory(VehSerialNo: Code[20])
    var
        Vehicle: Record Vehicle;
        ServiceLedgerEntry: Record "Service Ledger Entry EDMS";
    begin
        ServiceLedgerEntry.Reset;
        ServiceLedgerEntry.SetCurrentkey("Vehicle Serial No.");
        ServiceLedgerEntry.SetRange("Vehicle Serial No.", VehSerialNo);
        ServiceLedgerEntry.SetRange("Entry Type", ServiceLedgerEntry."entry type"::Usage);
        Page.RunModal(Page::"Service Ledger Entries EDMS", ServiceLedgerEntry);
    end;


    procedure LookupServiceHistory2(VehSerialNo: Code[20])
    var
        Vehicle: Record Vehicle;
        ServiceLedgerEntry: Record "Service Ledger Entry EDMS";
    begin
        ServiceLedgerEntry.Reset;
        ServiceLedgerEntry.SetCurrentkey("Vehicle Serial No.");
        ServiceLedgerEntry.SetRange("Vehicle Serial No.", VehSerialNo);
        Page.RunModal(Page::"Service Ledger Entries EDMS", ServiceLedgerEntry);
    end;


    procedure GetTransfCount(ServHeader: Record "Service Header EDMS"): Integer
    var
        TransfHeader: Record "Transfer Header";
    begin
        TransfHeader.Reset;
        TransfHeader.SetCurrentkey("Source Type", "Source Subtype", "Source No.", "Document Profile");
        TransfHeader.SetRange("Source Type", Database::"Service Header EDMS");
        TransfHeader.SetRange("Source Subtype", 1);
        TransfHeader.SetRange("Source No.", ServHeader."No.");
        TransfHeader.SetRange("Document Profile", TransfHeader."document profile"::Service);
        if not TransfHeader.FindFirst then
            exit(0)
        else
            exit(TransfHeader.Count)
    end;


    procedure LookupVehicle(SerialNo: Code[20])
    var
        Vehicle: Record Vehicle;
    begin
        if Vehicle.Get(SerialNo) then
            Page.RunModal(Page::"Vehicle Card", Vehicle);
    end;


    procedure LookupLastServiceOrder(VehSerialNo: Code[20])
    var
        Vehicle: Record Vehicle;
        ServiceLedgerEntry: Record "Service Ledger Entry EDMS";
    begin
        ServiceLedgerEntry.Reset;
        //ServiceLedgerEntry.SETCURRENTKEY("Vehicle Serial No.");  //14.05.2014 Elva Baltic P8 #S0038 MMG7.00
        ServiceLedgerEntry.SetRange("Vehicle Serial No.", VehSerialNo);
        ServiceLedgerEntry.SetRange("Entry Type", ServiceLedgerEntry."entry type"::Usage);
        if ServiceLedgerEntry.FindLast then
            ServiceLedgerEntry.SetRange("Document No.", ServiceLedgerEntry."Document No.");
        Page.RunModal(Page::"Service Ledger Entries EDMS", ServiceLedgerEntry);
    end;


    procedure LookupLastSLEntry(VehSerialNo: Code[20])
    var
        Vehicle: Record Vehicle;
        ServiceLedgerEntry: Record "Service Ledger Entry EDMS";
    begin
        ServiceLedgerEntry.Reset;
        ServiceLedgerEntry.SetCurrentkey("Vehicle Serial No.", "Posting Date", "Entry Type");
        ServiceLedgerEntry.SetRange("Vehicle Serial No.", VehSerialNo);
        Page.RunModal(Page::"Service Ledger Entries EDMS", ServiceLedgerEntry);
    end;


    procedure LookupVehWarranties(ServiceHdr: Record "Service Header EDMS")
    var
        VehWarranty: Record "Vehicle Warranty";
    begin
        VehWarranty.Reset;
        VehWarranty.FilterGroup(2);
        VehWarranty.SetRange("Vehicle Serial No.", ServiceHdr."Vehicle Serial No.");
        VehWarranty.FilterGroup(0);
        if VehWarranty.Count = 1 then
            Page.RunModal(Page::"Vehicle Warranty Card", VehWarranty)
        else
            Page.RunModal(Page::"Vehicle Warranty List", VehWarranty);
    end;


    procedure GetVehWarrantyCount(ServiceHdr: Record "Service Header EDMS"): Integer
    var
        VehWarranty: Record "Vehicle Warranty";
    begin
        VehWarranty.Reset;
        VehWarranty.SetRange("Vehicle Serial No.", ServiceHdr."Vehicle Serial No.");
        exit(VehWarranty.Count);
    end;


    procedure LookupServicePlans(ServiceHdr: Record "Service Header EDMS")
    var
        VehServicePlanStage: Record "Vehicle Service Plan Stage";
        TempVehServicePlanStage: Record "Vehicle Service Plan Stage" temporary;
        ChooseServicePlanStages: Page "Choose Service Plan Stages";
    begin
        if ServiceHdr."Vehicle Serial No." = '' then
            exit;

        //write two group records >>
        if not ISSERVICETIER then begin
            TempVehServicePlanStage.Init;
            TempVehServicePlanStage.Code := Text001;
            TempVehServicePlanStage.Group := true;
            TempVehServicePlanStage.Status := TempVehServicePlanStage.Status::Pending;
            TempVehServicePlanStage.Insert;

            TempVehServicePlanStage.Init;
            TempVehServicePlanStage.Code := Text002;
            TempVehServicePlanStage.Group := true;
            TempVehServicePlanStage.Status := TempVehServicePlanStage.Status::Serviced;
            TempVehServicePlanStage.Insert;

            TempVehServicePlanStage.Init;
            TempVehServicePlanStage.Code := Text003;
            TempVehServicePlanStage.Group := true;
            TempVehServicePlanStage.Status := TempVehServicePlanStage.Status::"In Process";
            TempVehServicePlanStage.Insert;

            TempVehServicePlanStage.Init;
            TempVehServicePlanStage.Code := Text004;
            TempVehServicePlanStage.Group := true;
            TempVehServicePlanStage.Status := TempVehServicePlanStage.Status::Skipped;
            TempVehServicePlanStage.Insert;
        end;
        //write two group records <<

        VehServicePlanStage.SetRange("Vehicle Serial No.", ServiceHdr."Vehicle Serial No.");
        if VehServicePlanStage.FindFirst then
            repeat
                TempVehServicePlanStage := VehServicePlanStage;
                case TempVehServicePlanStage.Status of
                    TempVehServicePlanStage.Status::"In Process":
                        TempVehServicePlanStage."Applies-to Code" := Text003;
                    TempVehServicePlanStage.Status::Pending:
                        TempVehServicePlanStage."Applies-to Code" := Text001;
                    TempVehServicePlanStage.Status::Skipped:
                        TempVehServicePlanStage."Applies-to Code" := Text004
                    else
                        TempVehServicePlanStage."Applies-to Code" := Text002;
                end;
                TempVehServicePlanStage.Insert;
            until VehServicePlanStage.Next = 0;

        if Page.RunModal(Page::"Choose Service Plan Stages", TempVehServicePlanStage) = Action::LookupOK then begin
            TempVehServicePlanStage.Reset;
            TempVehServicePlanStage.SetRange("Maintain Stage", true);
            if TempVehServicePlanStage.FindFirst then
                // for now there should be only one record
                    repeat
                        InsertServicePackByPlanStages(ServiceHdr, TempVehServicePlanStage);
                until TempVehServicePlanStage.Next = 0;
        end;
    end;


    procedure GetServicePlanCount(ServiceHdr: Record "Service Header EDMS"): Integer
    var
        ServicePlan: Record "Vehicle Service Plan";
    begin
        ServicePlan.Reset;
        ServicePlan.SetRange("Vehicle Serial No.", ServiceHdr."Vehicle Serial No.");

        //09.02.2010 EDMSB P2 >>
        ServicePlan.SetRange(Active, true);
        //09.02.2010 EDMSB P2 <<

        exit(ServicePlan.Count);
    end;


    procedure GetActiveRecallCount(ServiceHdr: Record "Service Header EDMS"): Integer
    var
        RecallVehicle: Record "Recall Campaign Vehicle";
    begin
        RecallVehicle.Reset;
        RecallVehicle.SetRange(VIN, ServiceHdr.VIN);
        RecallVehicle.SetRange(Serviced, false);
        RecallVehicle.SetRange("Active Campaign", true);
        exit(RecallVehicle.Count);
    end;


    procedure LookupActiveRecalls(var ServiceHdr: Record "Service Header EDMS")
    var
        RecallVehicle: Record "Recall Campaign Vehicle";
        ServicePackageVersionTmp: Record "Service Package Version" temporary;
        ServiceHeader2: Record "Service Header EDMS";
        RecallCampaignVehicles: Page "Recall Campaign Vehicles";
    begin
        RecallVehicle.Reset;
        RecallVehicle.FilterGroup(2);
        RecallVehicle.SetRange(VIN, ServiceHdr.VIN);
        RecallVehicle.SetRange(Serviced, false);
        RecallVehicle.SetRange("Active Campaign", true);
        RecallVehicle.FilterGroup(0);

        RecallCampaignVehicles.SetTableview(RecallVehicle);
        RecallCampaignVehicles.LookupMode := true;
        RecallCampaignVehicles.RunModal;
        //IF PAGE.RUNMODAL(PAGE::"Recall Campaign Vehicles", RecallVehicle) = ACTION::LookupOK THEN BEGIN
        RecallVehicle.Reset;
        RecallVehicle.SetRange(VIN, ServiceHdr.VIN);
        RecallVehicle.SetRange("Active Campaign", true);
        RecallVehicle.SetRange(Serviced, false, true);
        RecallVehicle.SetRange("Campaign No.", RecallCampaignVehicles.GetSelectedRecallNo);
        if RecallVehicle.FindFirst then begin
            if ServiceHdr."Sell-to Customer No." = '' then begin
                RecallVehicle.Serviced := false;
                RecallVehicle.Modify(true);
                Commit;
                ServiceHdr.TestField("Sell-to Customer No.");
            end else
                if RecallVehicle.Serviced then begin
                    ServiceHdr.InsertServPackageByRecallNo(RecallCampaignVehicles.GetSelectedRecallNo);
                end;
        end;
    end;


    procedure InsertServicePackByPlanStages(var ServiceHdr: Record "Service Header EDMS"; VehicleServicePlanStage: Record "Vehicle Service Plan Stage")
    var
        PackageNoFilter: Text[1024];
        SPVersion: Record "Service Package Version";
    begin
        ServiceHdr.InsertServPlanDocLink(VehicleServicePlanStage);
        Commit;
        SPVersion.SetRange("Package No.", VehicleServicePlanStage."Package No.");
        ServiceHdr.SetCurrPlanStage(VehicleServicePlanStage);
        ServiceHdr.InsertLookupSPVersion(SPVersion);
    end;


    procedure InsertLookupSPVersions(var SPVersion: Record "Service Package Version"; ServiceHeader: Record "Service Header EDMS")
    var
        SPVersionSpec: Record "Service Package Version Line";
        ServLine: Record "Service Line EDMS";
        ServicePackage: Record "Service Package";
        LastLineNo: Integer;
        Text001: label 'No records to list.';
        SPVersionResult: Record "Service Package Version";
        SPVersionForm: Page "Service Package Version-Select";
    begin
        // main source is taken from T2500645.InsertLookupSPVersion
        // but the difference is that is able to work with multiselect
        SPVersionForm.SetTableview(SPVersion);
        SPVersionForm.LookupMode := true;
        if SPVersionForm.RunModal = Action::LookupOK then begin

            if SPVersionForm.GetSelectedRecordSet(SPVersionResult) then begin
                // means is multiselect
                if SPVersionResult.FindFirst then
                    repeat
                        InsertSPVesionToSHeader(SPVersionResult, ServiceHeader);
                    until SPVersionResult.Next = 0;
            end else begin
                // only current record to be inerted
                if SPVersionResult."Package No." <> '' then
                    InsertSPVesionToSHeader(SPVersionResult, ServiceHeader);
            end;
        end;
    end;


    procedure InsertSPVesionToSHeader(SPVersion: Record "Service Package Version"; ServiceHeader: Record "Service Header EDMS")
    var
        SPVersionSpec: Record "Service Package Version Line";
        ServLine: Record "Service Line EDMS";
        ServicePackage: Record "Service Package";
        LastLineNo: Integer;
        Text001: label 'No records to list.';
        SPVersionForm: Page "Service Package Version-Select";
        SPVersionResult: Record "Service Package Version";
        Text124: label 'Service package %1 is blocked.';
    begin
        if ServicePackage.Get(SPVersion."Package No.") then begin
            if ServicePackage.Blocked then
                Error(StrSubstNo(Text124, SPVersionResult."Package No."));

            SPVersionSpec.Reset;
            SPVersionSpec.SetRange("Package No.", SPVersionResult."Package No.");
            SPVersionSpec.SetRange("Version No.", SPVersionResult."Version No.");
            if SPVersionSpec.FindSet then
                repeat
                    SPVersionSpec.CreateServLine(ServiceHeader."Document Type", ServiceHeader."No.");
                until SPVersionSpec.Next = 0
        end;
    end;


    procedure GetComponentServicePlansCount(ServiceHdr: Record "Service Header EDMS") RetValue: Integer
    var
        VehicleComponent: Record "Vehicle Component";
        VehicleServicePlan: Record "Vehicle Service Plan";
    begin
        VehicleComponent.Reset;
        VehicleComponent.SetRange("Parent Vehicle Serial No.", ServiceHdr."Vehicle Serial No.");
        VehicleComponent.SetRange(Active, true);
        if VehicleComponent.FindFirst then begin
            repeat
                VehicleServicePlan.Reset;
                VehicleServicePlan.SetRange("Vehicle Serial No.", VehicleComponent."No.");
                VehicleServicePlan.SetRange(Active, true);
                RetValue += VehicleServicePlan.Count;
            until VehicleComponent.Next = 0;
        end;

        exit(RetValue);
    end;


    procedure LookupVehicleComponentsPlans(ServiceHdr: Record "Service Header EDMS")
    var
        VehicleComponent: Record "Vehicle Component";
        VehServicePlanStage: Record "Vehicle Service Plan Stage";
        TempVehServicePlanStage: Record "Vehicle Service Plan Stage" temporary;
        ChooseServicePlanStages: Page "Choose Service Plan Stages";
        ServicePlanMgt: Codeunit "Service Plan Management";
        ServiceHeaderTmp: Record "Service Header EDMS" temporary;
        VehicleServicePlanStage: Record "Vehicle Service Plan Stage";
        ServicePackage: Record "Service Package";
        ServicePackageVersion: Record "Service Package Version";
        Customer: Record Customer;
        TextLoc001: label 'New %2 created: %1';
        NewCreatedIDs: Text[250];
        ServiceHdrLocal: Record "Service Header EDMS";
    begin
        if ServiceHdr."Vehicle Serial No." = '' then
            exit;

        //write two group records >>
        if not ISSERVICETIER then begin
            TempVehServicePlanStage.Init;
            TempVehServicePlanStage.Code := Text001;
            TempVehServicePlanStage.Group := true;
            TempVehServicePlanStage.Status := TempVehServicePlanStage.Status::Pending;
            TempVehServicePlanStage.Insert;

            TempVehServicePlanStage.Init;
            TempVehServicePlanStage.Code := Text002;
            TempVehServicePlanStage.Group := true;
            TempVehServicePlanStage.Status := TempVehServicePlanStage.Status::Serviced;
            TempVehServicePlanStage.Insert;

            TempVehServicePlanStage.Init;
            TempVehServicePlanStage.Code := Text003;
            TempVehServicePlanStage.Group := true;
            TempVehServicePlanStage.Status := TempVehServicePlanStage.Status::"In Process";
            TempVehServicePlanStage.Insert;

            TempVehServicePlanStage.Init;
            TempVehServicePlanStage.Code := Text004;
            TempVehServicePlanStage.Group := true;
            TempVehServicePlanStage.Status := TempVehServicePlanStage.Status::Skipped;
            TempVehServicePlanStage.Insert;
        end;
        TempVehServicePlanStage.Init;
        TempVehServicePlanStage.Code := 'COMPONENTS';
        TempVehServicePlanStage.Group := true;
        TempVehServicePlanStage.Status := TempVehServicePlanStage.Status::Pending;
        TempVehServicePlanStage.Insert;

        VehicleComponent.Reset;
        VehicleComponent.SetRange("Parent Vehicle Serial No.", ServiceHdr."Vehicle Serial No.");
        VehicleComponent.SetRange(Active, true);
        if VehicleComponent.FindFirst then
            repeat
                VehServicePlanStage.SetRange("Vehicle Serial No.", VehicleComponent."No.");
                if VehServicePlanStage.FindFirst then
                    repeat
                        TempVehServicePlanStage := VehServicePlanStage;
                        case TempVehServicePlanStage.Status of
                            TempVehServicePlanStage.Status::"In Process":
                                TempVehServicePlanStage."Applies-to Code" := Text003;
                            TempVehServicePlanStage.Status::Skipped:
                                TempVehServicePlanStage."Applies-to Code" := Text004;
                            TempVehServicePlanStage.Status::Pending:
                                TempVehServicePlanStage."Applies-to Code" := Text001
                            else
                                TempVehServicePlanStage."Applies-to Code" := Text002;
                        end;
                        TempVehServicePlanStage.Insert;
                    until VehServicePlanStage.Next = 0;
            until VehicleComponent.Next = 0;

        if Page.RunModal(Page::"Choose Service Plan Stages", TempVehServicePlanStage) = Action::LookupOK then begin
            //IF ChooseServicePlanStages.RUNMODAL = ACTION::LookupOK THEN BEGIN
            TempVehServicePlanStage.Reset;
            TempVehServicePlanStage.SetRange("Maintain Stage", true);
            if TempVehServicePlanStage.FindFirst then
                // for now there should be only one record
                    repeat
                        VehicleServicePlanStage.Get(TempVehServicePlanStage."Vehicle Serial No.", TempVehServicePlanStage."Plan No.",
                          TempVehServicePlanStage.Recurrence, TempVehServicePlanStage.Code);
                        ServicePackage.Get(VehicleServicePlanStage."Package No.");
                        ServicePackageVersion.SetRange("Package No.", ServicePackage."No.");
                        if ServicePackageVersion.FindFirst then begin
                            if Customer.Get(ServiceHdr."Sell-to Customer No.") then begin
                                Clear(ServicePlanMgt);
                                ServiceHdrLocal.Reset;
                                ServiceHeaderTmp.Reset;
                                ServiceHeaderTmp.SetRange("Vehicle Serial No.", VehicleServicePlanStage."Vehicle Serial No.");
                                if ServiceHeaderTmp.FindFirst then begin
                                    ServiceHdrLocal.Get(ServiceHeaderTmp."Document Type", ServiceHeaderTmp."No.");
                                end else begin
                                    ServiceHdrLocal.CreateServHeader(ServiceHdrLocal."document type"::Order, ServiceHdr."Order Date",
                                      ServiceHdr."Planned Service Date", ServiceHdr.Description, ServiceHdr."Sell-to Customer No.",
                                      ServiceHdr."Bill-to Customer No.", VehicleServicePlanStage."Vehicle Serial No.");
                                end;
                                InsertServicePackByPlanStages(ServiceHdrLocal, TempVehServicePlanStage);
                                ServiceHeaderTmp.TransferFields(ServiceHdrLocal);
                                ServiceHeaderTmp.Insert;
                            end;
                        end;
                until TempVehServicePlanStage.Next = 0;
            if ServiceHeaderTmp.FindFirst then begin
                Clear(NewCreatedIDs);
                repeat
                    NewCreatedIDs += ServiceHeaderTmp."No." + ', ';
                until ServiceHeaderTmp.Next = 0;
                NewCreatedIDs := CopyStr(NewCreatedIDs, 1, StrLen(NewCreatedIDs) - 2);
                Message(TextLoc001, NewCreatedIDs, ServiceHdr.TableCaption);
            end;
        end;
    end;


    procedure GetInsuranceCount(ServiceHdr: Record "Service Header EDMS") RetValue: Integer
    var
        VehicleInsurance: Record "Vehicle Insurance";
    begin
        VehicleInsurance.Reset;
        VehicleInsurance.SetRange("Vehicle Serial No.", ServiceHdr."Vehicle Serial No.");
        RetValue := VehicleInsurance.Count;

        exit(RetValue);
    end;


    procedure LookupVehicleInsurancesPlans(ServiceHdr: Record "Service Header EDMS")
    var
        VehicleInsurance: Record "Vehicle Insurance";
    begin
        if ServiceHdr."Vehicle Serial No." = '' then
            exit;

        VehicleInsurance.Reset;
        VehicleInsurance.FilterGroup(2);
        VehicleInsurance.SetRange("Vehicle Serial No.", ServiceHdr."Vehicle Serial No.");
        VehicleInsurance.FilterGroup(0);
        Page.RunModal(0, VehicleInsurance);
    end;


    procedure GetVehicleContractsCount(Vehicle: Record Vehicle): Integer
    var
        ContractHdr: Record Contract;
    begin
        //31.01.2014 Elva Baltic P8 #F038 MMG7.00 >>
        //HOTFIX P1 !! >>
        exit(0);
        //HOTFIX P1 !! <<
        PrepareVehicleContractsFilteredTable(Vehicle, ContractHdr);
        exit(ContractHdr.Count);
    end;


    procedure LookupVehicleContracts(Vehicle: Record Vehicle)
    var
        ContractHdr: Record Contract;
    begin
        PrepareVehicleContractsFilteredTable(Vehicle, ContractHdr);
        if ContractHdr.Count = 1 then
            Page.RunModal(Page::Contract, ContractHdr)
        else
            Page.RunModal(Page::"Contract List EDMS", ContractHdr);
    end;


    procedure PrepareVehicleContractsFilteredTable(Vehicle: Record Vehicle; var ContractHdr: Record Contract)
    var
        ContractSalesLineDiscount: Record "Contract Sales Line Discount";
        ContractSalesPrice: Record "Contract Sales Price";
        FilterStr: Text[250];
    begin
        ContractHdr.FilterGroup(2);
        FilterStr := '';
        ContractSalesLineDiscount.Reset;
        ContractSalesLineDiscount.SetRange("Vehicle Serial No.", Vehicle."Serial No.");
        if ContractSalesLineDiscount.FindFirst then
            repeat
                if StrPos(FilterStr, ContractSalesLineDiscount."Contract No.") = 0 then begin
                    if FilterStr = '' then
                        FilterStr := ContractSalesLineDiscount."Contract No."
                    else
                        FilterStr += '|' + ContractSalesLineDiscount."Contract No.";
                    ContractHdr.SetFilter("Contract No.", FilterStr);
                end;
            until ContractSalesLineDiscount.Next = 0;
        ContractSalesPrice.Reset;
        ContractSalesPrice.SetRange("Vehicle Serial No.", Vehicle."Serial No.");
        if ContractSalesPrice.FindFirst then
            repeat
                if StrPos(FilterStr, ContractSalesPrice."Contract No.") = 0 then begin
                    if FilterStr = '' then
                        FilterStr := ContractSalesPrice."Contract No."
                    else
                        FilterStr += '|' + ContractSalesPrice."Contract No.";
                    ContractHdr.SetFilter("Contract No.", FilterStr);
                end;
            until ContractSalesPrice.Next = 0;
        ContractHdr.FilterGroup(0);
    end;


    procedure LookupVehicleWarranties(Vehicle: Record Vehicle)
    var
        VehWarranty: Record "Vehicle Warranty";
    begin
        VehWarranty.Reset;
        VehWarranty.FilterGroup(2);
        VehWarranty.SetRange("Vehicle Serial No.", Vehicle."Serial No.");
        VehWarranty.FilterGroup(0);
        if VehWarranty.Count = 1 then
            Page.RunModal(Page::"Vehicle Warranty Card", VehWarranty)
        else
            Page.RunModal(Page::"Vehicle Warranty List", VehWarranty);
    end;


    procedure GetVehicleWarrantyCount(Vehicle: Record Vehicle): Integer
    var
        VehWarranty: Record "Vehicle Warranty";
    begin
        VehWarranty.Reset;
        VehWarranty.SetRange("Vehicle Serial No.", Vehicle."Serial No.");
        exit(VehWarranty.Count);
    end;


    procedure GetVehicleDocCount(ServiceHdr: Record "Service Header EDMS"; DocType: Option Quote,"Order","Return Order"): Integer
    var
        ServiceHeader: Record "Service Header EDMS";
    begin
        if ServiceHdr."Vehicle Serial No." = '' then
            exit(0);

        ServiceHeader.Reset;
        ServiceHeader.SetRange("Vehicle Serial No.", ServiceHdr."Vehicle Serial No.");
        ServiceHeader.SetRange("Document Type", DocType);
        exit(ServiceHeader.Count);
    end;


    procedure LookupVehicleDoc(ServiceHdr: Record "Service Header EDMS"; DocType: Option Quote,"Order","Return Order")
    begin
        if ServiceHdr."Vehicle Serial No." = '' then
            exit;

        ServiceHeader.Reset;
        ServiceHeader.SetRange("Vehicle Serial No.", ServiceHdr."Vehicle Serial No.");
        ServiceHeader.SetRange("Document Type", DocType);
        if ServiceHeader.Count = 1 then begin
            case DocType of
                Doctype::Quote:
                    Page.RunModal(Page::"Service Quote EDMS", ServiceHeader);
                Doctype::Order:
                    Page.RunModal(Page::"Service Order EDMS", ServiceHeader);
            end
        end else begin
            case DocType of
                Doctype::Quote:
                    Page.RunModal(Page::"Service Quotes EDMS", ServiceHeader);
                Doctype::Order:
                    Page.RunModal(Page::"Service Orders EDMS", ServiceHeader);
            end;
        end;
    end;


    procedure VehicleGetInsuranceCount(Vehicle: Record Vehicle) RetValue: Integer
    var
        VehicleInsurance: Record "Vehicle Insurance";
    begin
        VehicleInsurance.Reset;
        VehicleInsurance.SetRange("Vehicle Serial No.", Vehicle."Serial No.");
        RetValue := VehicleInsurance.Count;

        exit(RetValue);
    end;


    procedure VehicleLookupVehicleInsurancesPlans(Vehicle: Record Vehicle)
    var
        VehicleInsurance: Record "Vehicle Insurance";
    begin
        VehicleInsurance.Reset;
        VehicleInsurance.FilterGroup(2);
        VehicleInsurance.SetRange("Vehicle Serial No.", Vehicle."Serial No.");
        VehicleInsurance.FilterGroup(0);
        Page.RunModal(0, VehicleInsurance);
    end;


    procedure VehicleGetActiveRecallCount(Vehicle: Record Vehicle): Integer
    var
        RecallVehicle: Record "Recall Campaign Vehicle";
    begin
        RecallVehicle.Reset;
        RecallVehicle.SetRange(VIN, Vehicle.VIN);
        RecallVehicle.SetRange(Serviced, false);
        RecallVehicle.SetRange("Active Campaign", true);
        exit(RecallVehicle.Count);
    end;


    procedure VehicleLookupActiveRecalls(var Vehicle: Record Vehicle)
    var
        RecallVehicle: Record "Recall Campaign Vehicle";
        ServicePackageVersionTmp: Record "Service Package Version" temporary;
        ServiceHeader2: Record "Service Header EDMS";
        RecallCampaignVehicles: Page "Recall Campaign Vehicles";
    begin
        RecallVehicle.Reset;
        RecallVehicle.FilterGroup(2);
        RecallVehicle.SetRange(VIN, Vehicle.VIN);
        RecallVehicle.SetRange(Serviced, false);
        RecallVehicle.SetRange("Active Campaign", true);
        RecallVehicle.FilterGroup(0);

        RecallCampaignVehicles.SetTableview(RecallVehicle);
        RecallCampaignVehicles.LookupMode := true;
        RecallCampaignVehicles.RunModal;
        //IF PAGE.RUNMODAL(PAGE::"Recall Campaign Vehicles", RecallVehicle) = ACTION::LookupOK THEN BEGIN
    end;


    procedure PrepareVehicleInfoContractsFilteredTable(Vehicle: Record Vehicle; var ContractHdr: Record Contract)
    var
        FilterStr: Text[250];
        VehicleContract: Record "Contract Vehicle";
    begin
        ContractHdr.FilterGroup(2);
        FilterStr := '';
        VehicleContract.Reset;
        VehicleContract.SetRange("Vehicle Serial No.", Vehicle."Serial No.");
        if VehicleContract.FindFirst then
            repeat
                if StrPos(FilterStr, VehicleContract."Contract No.") = 0 then begin
                    if FilterStr = '' then
                        FilterStr := VehicleContract."Contract No."
                    else
                        FilterStr += '|' + VehicleContract."Contract No.";
                    ContractHdr.SetFilter("Contract No.", FilterStr);
                end;
            until VehicleContract.Next = 0;

        if FilterStr = '' then
            ContractHdr.SetFilter("Contract No.", '%1', '');

        ContractHdr.FilterGroup(0);
    end;


    procedure LookupVehicleInfoContracts(Vehicle: Record Vehicle)
    var
        ContractHdr: Record Contract;
    begin
        PrepareVehicleInfoContractsFilteredTable(Vehicle, ContractHdr);
        if ContractHdr.Count = 1 then
            Page.RunModal(Page::Contract, ContractHdr)
        else
            Page.RunModal(Page::"Contract List EDMS", ContractHdr);
    end;


    procedure GetVehicleInfoContractsCount(Vehicle: Record Vehicle): Integer
    var
        ContractHdr: Record Contract;
    begin
        PrepareVehicleInfoContractsFilteredTable(Vehicle, ContractHdr);
        exit(ContractHdr.Count);
    end;


    procedure LookupMapViewVehicleTelematics(VehicleSerialNo: Code[20])
    var
        MapViewVehicleTelematics: Record "Vehicle Telematics";
    begin
        MapViewVehicleTelematics.Reset;
        MapViewVehicleTelematics.SetRange("Vehicle Serial No.", VehicleSerialNo);
        Page.RunModal(Page::"MapView Vehicle Telematics", MapViewVehicleTelematics);
    end;


    procedure CalcAvailableInventory(var ServiceLineEDMS: Record "Service Line EDMS"): Decimal
    var
        AvailabilityDate: Date;
        LocationCode: Code[10];
        UserProfile: Record "Branch Profile Setup";
        UserProfileMgt: Codeunit "UserProfileManagement";
        AvailableToPromise: Codeunit "Available to Promise";
    begin
        if GetItem(ServiceLineEDMS) then begin

            if ServiceLineEDMS."Planned Service Date" <> 0D then
                AvailabilityDate := ServiceLineEDMS."Planned Service Date"
            else
                AvailabilityDate := WORKDATE;

            LocationCode := ServiceLineEDMS."Location Code";
            if UserProfile.GET(UserProfileMgt.CurrProfileID, UserProfileMgt.CurrBranchNo) and (UserProfile."Def. Spare Part Location Code" <> '') then
                LocationCode := UserProfile."Def. Spare Part Location Code";

            Item.RESET;
            Item.SETRANGE("Date Filter", 0D, AvailabilityDate);
            Item.SETRANGE("Variant Filter", ServiceLineEDMS."Variant Code");
            Item.SETRANGE("Location Filter", LocationCode);
            Item.SETRANGE("Drop Shipment Filter", FALSE);

            exit(ConvertQty(AvailableToPromise.CalcAvailableInventory(Item), ServiceLineEDMS."Qty. per Unit of Measure"));
        end;
    end;

    procedure ConvertQty(Qty: Decimal; PerUoMQty: Decimal): Decimal
    begin
        if PerUoMQty = 0 then
            PerUoMQty := 1;
        exit(ROUND(Qty / PerUoMQty, UOMMgt.QtyRndPrecision));
    end;

    procedure CalcExpectedSockReceiptDate(VehSerialNo: Code[20]): Date
    var
        Vehicle: Record Vehicle;
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.Reset;
        PurchaseLine.SetRange("Vehicle Serial No.", VehSerialNo);
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        if PurchaseLine.FindLast then
            exit(PurchaseLine."Expected Receipt Date");
    end;

    procedure LookupVehicleExpectedReceipt(VehSerialNo: Code[20])
    var
        Vehicle: Record Vehicle;
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.Reset;
        PurchaseLine.SetRange("Vehicle Serial No.", VehSerialNo);
        PurchaseLine.SetRange("Document Type", PurchaseLine."Document Type"::Order);
        if PurchaseLine.FindLast then
            PurchaseLine.SetRange("Document No.", PurchaseLine."Document No.");
        Page.RunModal(Page::"Purchase Lines", PurchaseLine);
    end;

    procedure LookupVehicleLinkedVehicles(VehicleSerialNo: Code[20])
    var
        Vehicle: Record Vehicle;
        Vehicle2: Record Vehicle;
    begin
        if Vehicle.Get(VehicleSerialNo) then begin
            PrepareLookupVehicleLinkedVehicles(Vehicle, Vehicle2);
            if Vehicle2.Count > 0 then
                Page.RunModal(Page::"Vehicle List", Vehicle2);
        end;
    end;

    procedure GetVehicleLinkedVehiclesCount(VehicleSerialNo: Code[20]): Integer
    var
        Vehicle: Record Vehicle;
        Vehicle2: Record Vehicle;
    begin
        if Vehicle.Get(VehicleSerialNo) then begin
            PrepareLookupVehicleLinkedVehicles(Vehicle, Vehicle2);
            exit(Vehicle2.Count);
        end;
    end;

    procedure PrepareLookupVehicleLinkedVehicles(Vehicle: Record Vehicle; var Vehicle2: Record Vehicle)
    var
        FilterStr: Text;
        VehicleComponents: Record "Vehicle Component";
        VehicleComponents2: Record "Vehicle Component";
    begin
        Vehicle2.Reset();
        Vehicle2.FilterGroup(2);
        FilterStr := '';
        VehicleComponents.Reset;
        VehicleComponents.SetRange("Parent Vehicle Serial No.", Vehicle."Serial No.");
        if VehicleComponents.FindFirst then
            repeat
                if StrPos(FilterStr, VehicleComponents."No.") = 0 then begin
                    if FilterStr = '' then
                        FilterStr := VehicleComponents."No."
                    else
                        FilterStr += '|' + VehicleComponents."No.";
                end;
                if StrPos(FilterStr, VehicleComponents."Parent Vehicle Serial No.") = 0 then begin
                    if FilterStr = '' then
                        FilterStr := VehicleComponents."Parent Vehicle Serial No."
                    else
                        FilterStr += '|' + VehicleComponents."Parent Vehicle Serial No.";
                end;
            until VehicleComponents.Next = 0;

        if FilterStr = '' then begin
            VehicleComponents2.Reset;
            VehicleComponents2.SetRange("No.", Vehicle."Serial No.");
            if VehicleComponents2.FindFirst then begin
                VehicleComponents.Reset;
                VehicleComponents.SetRange("Parent Vehicle Serial No.", VehicleComponents2."Parent Vehicle Serial No.");
                if VehicleComponents.FindFirst then
                    repeat
                        if StrPos(FilterStr, VehicleComponents."No.") = 0 then begin
                            if FilterStr = '' then
                                FilterStr := VehicleComponents."No."
                            else
                                FilterStr += '|' + VehicleComponents."No.";
                        end;
                        if StrPos(FilterStr, VehicleComponents."Parent Vehicle Serial No.") = 0 then begin
                            if FilterStr = '' then
                                FilterStr := VehicleComponents."Parent Vehicle Serial No."
                            else
                                FilterStr += '|' + VehicleComponents."Parent Vehicle Serial No.";
                        end;
                    until VehicleComponents.Next = 0;
            end;
        end;

        if FilterStr = '' then
            Vehicle2.SetFilter("Serial No.", '%1', '')
        else
            Vehicle2.SetFilter("Serial No.", FilterStr);

        Vehicle2.FilterGroup(0);
    end;
}

