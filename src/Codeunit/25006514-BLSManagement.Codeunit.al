Codeunit 25006514 "BLS Management"
{

    trigger OnRun()
    begin
    end;

    local procedure "--- Quantity ---"()
    begin
    end;


    procedure NormalizeServiceQty(ServiceCode: Code[20]; UsageType: Option Single,Calculation; Qty: Decimal): Decimal
    var
        Service: Record "BLS Service";
        RoundingType: Option Nearest,Up,Down;
        RoundingPrecision: Decimal;
    begin
        if ServiceCode = '' then
            exit(Qty);

        Service.Get(ServiceCode);

        case UsageType of
            Usagetype::Single:
                begin
                    RoundingPrecision := Service."Qty. Rounding Precision";
                    RoundingType := Service."Qty. Rounding Type";
                end;
            Usagetype::Calculation:
                begin
                    RoundingPrecision := Service."Calculation Rounding Precision";
                    RoundingType := Service."Calculation Rounding Type";
                end;
            else
                RoundingPrecision := 0;
        end;

        if RoundingPrecision <> 0 then
            case RoundingType of
                Roundingtype::Up:
                    Qty := ROUND(Qty, RoundingPrecision, '>');
                Roundingtype::Down:
                    Qty := ROUND(Qty, RoundingPrecision, '<');
                else
                    Qty := ROUND(Qty, RoundingPrecision);
            end;

        exit(Qty);
    end;

    local procedure "--- Price And Discount ---"()
    begin
    end;


    procedure GetServiceStandardPrice(ServiceCode: Code[20]; ServiceVariantCode: Code[20]; ObjectCode: Code[20]; CustomerNo: Code[20]; CustPriceGroupCode: Code[20]; Date: Date; CurrencyCode: Code[10]; Qty: Decimal; var StdPrice: Decimal): Boolean
    var
        ServicePrice: Record "BLS Service Price";
        FoundPrice: Boolean;
    begin
        StdPrice := 0;

        if ServiceCode = '' then
            exit(false);

        ServicePrice.Reset;
        ServicePrice.SetRange("Service Code", ServiceCode);
        ServicePrice.SetFilter("Starting Date", '..%1', Date);
        ServicePrice.SetFilter("Ending Date", '%1|%2..', 0D, Date);
        ServicePrice.SetRange("Currency Code", CurrencyCode);
        ServicePrice.SetFilter("Minimum Quantity", '..%1', Qty);

        FoundPrice := false;

        if not FoundPrice and (CustomerNo <> '') then begin
            ServicePrice.SetRange("Sales Type", ServicePrice."sales type"::Customer);
            ServicePrice.SetRange("Sales Code", CustomerNo);
            GetServiceStandardPriceSub(ServicePrice, ServiceVariantCode, ObjectCode, FoundPrice);
        end;

        if not FoundPrice and (CustPriceGroupCode <> '') then begin
            ServicePrice.SetRange("Sales Type", ServicePrice."sales type"::"Customer Price Group");
            ServicePrice.SetRange("Sales Code", CustPriceGroupCode);
            GetServiceStandardPriceSub(ServicePrice, ServiceVariantCode, ObjectCode, FoundPrice);
        end;

        if not FoundPrice then begin
            ServicePrice.SetRange("Sales Type", ServicePrice."sales type"::"All Customers");
            ServicePrice.SetRange("Sales Code", '');
            GetServiceStandardPriceSub(ServicePrice, ServiceVariantCode, ObjectCode, FoundPrice);
        end;

        if FoundPrice then
            StdPrice := ServicePrice.Price;

        exit(FoundPrice);
    end;

    local procedure GetServiceStandardPriceSub(var ServicePrice: Record "BLS Service Price"; ServiceVariantCode: Code[20]; ObjectCode: Code[20]; var FoundPrice: Boolean)
    begin
        if FoundPrice then
            exit;

        if not FoundPrice and
           (ServiceVariantCode <> '') and (ObjectCode <> '')
        then begin
            ServicePrice.SetRange("Service Variant Code", ServiceVariantCode);
            ServicePrice.SetRange("Object Code", ObjectCode);
            FoundPrice := ServicePrice.FindLast;
        end;

        if not FoundPrice and (ObjectCode <> '') then begin
            ServicePrice.SetRange("Service Variant Code", '');
            ServicePrice.SetRange("Object Code", ObjectCode);
            FoundPrice := ServicePrice.FindLast;
        end;

        if not FoundPrice and
           (ServiceVariantCode <> '')
        then begin
            ServicePrice.SetRange("Service Variant Code", ServiceVariantCode);
            ServicePrice.SetRange("Object Code", '');
            FoundPrice := ServicePrice.FindLast;
        end;

        if not FoundPrice then begin
            ServicePrice.SetRange("Service Variant Code", '');
            ServicePrice.SetRange("Object Code", '');
            FoundPrice := ServicePrice.FindLast;
        end;
    end;


    procedure GetServiceStandardDiscount(ServiceCode: Code[20]; ServiceVariantCode: Code[20]; ObjectCode: Code[20]; CustomerNo: Code[20]; CustDiscountGroupCode: Code[20]; Date: Date; CurrencyCode: Code[10]; Qty: Decimal; var StdDiscount: Decimal): Boolean
    var
        ServiceDiscount: Record "BLS Service Discount";
        FoundDiscount: Boolean;
    begin
        StdDiscount := 0;

        if ServiceCode = '' then
            exit(false);

        ServiceDiscount.Reset;
        ServiceDiscount.SetRange("Service Code", ServiceCode);
        ServiceDiscount.SetFilter("Starting Date", '..%1', Date);
        ServiceDiscount.SetFilter("Ending Date", '%1|%2..', 0D, Date);
        ServiceDiscount.SetRange("Currency Code", CurrencyCode);
        ServiceDiscount.SetFilter("Minimum Quantity", '..%1', Qty);

        FoundDiscount := false;

        if not FoundDiscount and (CustomerNo <> '') then begin
            ServiceDiscount.SetRange("Sales Type", ServiceDiscount."sales type"::Customer);
            ServiceDiscount.SetRange("Sales Code", CustomerNo);
            GetServiceStandardDiscountSub(ServiceDiscount, ServiceVariantCode, ObjectCode, FoundDiscount);
        end;

        if not FoundDiscount and (CustDiscountGroupCode <> '') then begin
            ServiceDiscount.SetRange("Sales Type", ServiceDiscount."sales type"::"Customer Discount Group");
            ServiceDiscount.SetRange("Sales Code", CustDiscountGroupCode);
            GetServiceStandardDiscountSub(ServiceDiscount, ServiceVariantCode, ObjectCode, FoundDiscount);
        end;

        if not FoundDiscount then begin
            ServiceDiscount.SetRange("Sales Type", ServiceDiscount."sales type"::"All Customers");
            ServiceDiscount.SetRange("Sales Code", '');
            GetServiceStandardDiscountSub(ServiceDiscount, ServiceVariantCode, ObjectCode, FoundDiscount);
        end;

        if FoundDiscount then
            StdDiscount := ServiceDiscount."Discount, %";

        exit(FoundDiscount);
    end;

    local procedure GetServiceStandardDiscountSub(var ServiceDiscount: Record "BLS Service Discount"; ServiceVariantCode: Code[20]; ObjectCode: Code[20]; var FoundDiscount: Boolean)
    begin
        if FoundDiscount then
            exit;

        if not FoundDiscount and
           (ServiceVariantCode <> '') and (ObjectCode <> '')
        then begin
            ServiceDiscount.SetRange("Service Variant Code", ServiceVariantCode);
            ServiceDiscount.SetRange("Object Code", ObjectCode);
            FoundDiscount := ServiceDiscount.FindLast;
        end;

        if not FoundDiscount and (ObjectCode <> '')
        then begin
            ServiceDiscount.SetRange("Service Variant Code", '');
            ServiceDiscount.SetRange("Object Code", ObjectCode);
            FoundDiscount := ServiceDiscount.FindLast;
        end;

        if not FoundDiscount and
           (ServiceVariantCode <> '')
        then begin
            ServiceDiscount.SetRange("Service Variant Code", ServiceVariantCode);
            ServiceDiscount.SetRange("Object Code", '');
            FoundDiscount := ServiceDiscount.FindLast;
        end;

        if not FoundDiscount then begin
            ServiceDiscount.SetRange("Service Variant Code", '');
            ServiceDiscount.SetRange("Object Code", '');
            FoundDiscount := ServiceDiscount.FindLast;
        end;
    end;


    procedure GetServiceContractPrice(ContractNo: Code[20]; ServiceCode: Code[20]; ServiceVariantCode: Code[20]; ObjectCode: Code[20]; VehicleNo: Code[20]; CustPriceGroupCode: Code[20]; Date: Date; Qty: Decimal; var ContractPrice: Decimal; var FaultReason: Option " ","In Process","Incorrect Input","Not in Contract","More Conditions","Other Source")
    begin
        FaultReason := Faultreason::"Incorrect Input";
        ContractPrice := 0;

        if (ServiceCode = '') or (ContractNo = '') then
            exit;

        FaultReason := Faultreason::"In Process";

        begin
            if (FaultReason = Faultreason::"In Process") and (ObjectCode <> '') then begin
                GetServiceContractDMSPriceSub(ContractNo, ServiceCode, ServiceVariantCode, ObjectCode,
                                             VehicleNo, CustPriceGroupCode, Date, Qty, ContractPrice, FaultReason);
                if FaultReason = Faultreason::"Not in Contract" then
                    FaultReason := Faultreason::"In Process";
            end;

            if (FaultReason = Faultreason::"In Process") then
                GetServiceContractDMSPriceSub(ContractNo, ServiceCode, ServiceVariantCode, '',
                                             VehicleNo, CustPriceGroupCode, Date, Qty, ContractPrice, FaultReason);
        end;
    end;

    local procedure GetServiceContractDMSPriceSub(ContractNo: Code[20]; ServiceCode: Code[20]; ServiceVariantCode: Code[20]; ObjectCode: Code[20]; VehicleNo: Code[20]; CustPriceGroupCode: Code[20]; Date: Date; Qty: Decimal; var ContractPrice: Decimal; var FaultReason: Option " ","In Process","Incorrect Input","Not in Contract","More Conditions","Other Source")
    var
        ContractService: Record "DMS Contract Line";
    begin
        ContractService.Reset;
        ContractService.SetRange("DMS Contract No.", ContractNo);
        ContractService.SetRange("Service Code", ServiceCode);
        ContractService.SetFilter("Starting Date", '..%1', Date);
        ContractService.SetFilter("Ending Date", '%1|%2..', 0D, Date);
        ContractService.SetRange("Object Code", ObjectCode);
        ContractService.SetRange("Vehicle Serial No.", VehicleNo);

        if ContractService.IsEmpty then
            ContractService.SetRange("Vehicle Serial No.");

        if ContractService.IsEmpty then begin
            FaultReason := Faultreason::"Not in Contract";
            exit;
        end;

        if ContractService.Count > 1 then begin
            FaultReason := Faultreason::"More Conditions";
            exit;
        end;

        ContractService.FindFirst;

        if ContractService."Price Source" <> ContractService."price source"::Contract then begin
            FaultReason := Faultreason::"Other Source";
            exit;
        end;

        FaultReason := Faultreason::" ";
        ContractPrice := ContractService.Price;
    end;


    procedure GetServiceContractDiscount(ContractNo: Code[20]; ServiceCode: Code[20]; ServiceVariantCode: Code[20]; ObjectCode: Code[20]; CustDiscountGroupCode: Code[20]; Date: Date; Qty: Decimal; var CntrDiscount: Decimal): Boolean
    var
        ContractDiscount: Record "Payment Terms";
        FoundDiscount: Boolean;
    begin
        exit(false);
        /*
        CntrDiscount := 0;
        
        IF (ServiceCode = '') OR (ContractNo = '') THEN
          EXIT(FALSE);
        
        ContractDiscount.RESET;
        ContractDiscount.SETRANGE("Contract No.", ContractNo);
        ContractDiscount.SETRANGE("Service Code", ServiceCode);
        ContractDiscount.SETFILTER("Starting Date", '..%1', Date);
        ContractDiscount.SETFILTER("Ending Date", '%1|%2..', 0D, Date);
        ContractDiscount.SETFILTER("Minimum Quantity", '..%1', Qty);
        
        FoundDiscount := FALSE;
        
        IF NOT FoundDiscount AND (CustDiscountGroupCode <> '') THEN BEGIN
          ContractDiscount.SETRANGE("Customer Discount Group", CustDiscountGroupCode);
          GetServiceContractDiscountSub(ContractDiscount, ServiceVariantCode, ObjectType, ObjectCode, FoundDiscount);
        END;
        
        IF NOT FoundDiscount THEN BEGIN
          ContractDiscount.SETRANGE("Customer Discount Group", '');
          GetServiceContractDiscountSub(ContractDiscount, ServiceVariantCode, ObjectType, ObjectCode, FoundDiscount);
        END;
        
        IF FoundDiscount THEN
          CntrDiscount := ContractDiscount."Discount, %";
        
        EXIT(FoundDiscount);
        */

    end;

    local procedure GetServiceContractDiscountSub(var ContractDiscount: Record "Payment Terms"; ServiceVariantCode: Code[20]; ObjectCode: Code[20]; var FoundDiscount: Boolean)
    begin
        if FoundDiscount then
            exit;
        /*
        IF NOT FoundDiscount AND
           (ServiceVariantCode <> '') AND
           (ObjectType <> ObjectType::" ") AND (ObjectCode <> '')
        THEN BEGIN
          ContractDiscount.SETRANGE("Service Variant Code", ServiceVariantCode);
          ContractDiscount.SETRANGE("Object Type", ObjectType);
          ContractDiscount.SETRANGE("Object Code", ObjectCode);
          FoundDiscount := ContractDiscount.FINDLAST;
        END;
        
        IF NOT FoundDiscount AND
           (ObjectType <> ObjectType::" ") AND (ObjectCode <> '')
        THEN BEGIN
          ContractDiscount.SETRANGE("Service Variant Code", '');
          ContractDiscount.SETRANGE("Object Type", ObjectType);
          ContractDiscount.SETRANGE("Object Code", ObjectCode);
          FoundDiscount := ContractDiscount.FINDLAST;
        END;
        
        IF NOT FoundDiscount AND
           (ServiceVariantCode <> '')
        THEN BEGIN
          ContractDiscount.SETRANGE("Service Variant Code", ServiceVariantCode);
          ContractDiscount.SETRANGE("Object Type", ContractDiscount."Object Type"::" ");
          ContractDiscount.SETRANGE("Object Code", '');
          FoundDiscount := ContractDiscount.FINDLAST;
        END;
        
        IF NOT FoundDiscount THEN BEGIN
          ContractDiscount.SETRANGE("Service Variant Code", '');
          ContractDiscount.SETRANGE("Object Type", ContractDiscount."Object Type"::" ");
          ContractDiscount.SETRANGE("Object Code", '');
          FoundDiscount := ContractDiscount.FINDLAST;
        END;
        */

    end;


    procedure GetServiceDefaultQty(ServiceCode: Code[20]; ServiceVariantCode: Code[20]; ObjectCode: Code[20]; Date: Date; var DefaultQty: Decimal; var FreeQty: Decimal; var ToleranceQty: Decimal)
    var
        Service: Record "BLS Service";
        ServiceDefaultQty: Record "Payment Terms";
        FoundQty: Boolean;
    begin
        DefaultQty := 0;
        FreeQty := 0;
        ToleranceQty := 0;

        if ServiceCode = '' then
            exit;

        Service.Get(ServiceCode);
        /*
        ServiceDefaultQty.RESET;
        ServiceDefaultQty.SETRANGE("Service Code", ServiceCode);
        ServiceDefaultQty.SETFILTER("Starting Date", '..%1', Date);
        ServiceDefaultQty.SETFILTER("Ending Date", '%1|%2..', 0D, Date);
        
        FoundQty := FALSE;
        
        IF NOT FoundQty AND
           (ServiceVariantCode <> '') AND
           (ObjectType <> ObjectType::" ") AND (ObjectCode <> '')
        THEN BEGIN
          ServiceDefaultQty.SETRANGE("Service Variant Code", ServiceVariantCode);
          ServiceDefaultQty.SETRANGE("Object Type", ObjectType);
          ServiceDefaultQty.SETRANGE("Object Code", ObjectCode);
          FoundQty := ServiceDefaultQty.FINDLAST;
        END;
        
        IF NOT FoundQty AND
           (ObjectType <> ObjectType::" ") AND (ObjectCode <> '')
        THEN BEGIN
          ServiceDefaultQty.SETRANGE("Service Variant Code", '');
          ServiceDefaultQty.SETRANGE("Object Type", ObjectType);
          ServiceDefaultQty.SETRANGE("Object Code", ObjectCode);
          FoundQty := ServiceDefaultQty.FINDLAST;
        END;
        
        IF NOT FoundQty AND
           (ServiceVariantCode <> '')
        THEN BEGIN
          ServiceDefaultQty.SETRANGE("Service Variant Code", ServiceVariantCode);
          ServiceDefaultQty.SETRANGE("Object Type", ServiceDefaultQty."Object Type"::" ");
          ServiceDefaultQty.SETRANGE("Object Code", '');
          FoundQty := ServiceDefaultQty.FINDLAST;
        END;
        
        IF NOT FoundQty THEN BEGIN
          ServiceDefaultQty.SETRANGE("Service Variant Code", '');
          ServiceDefaultQty.SETRANGE("Object Type", ServiceDefaultQty."Object Type"::" ");
          ServiceDefaultQty.SETRANGE("Object Code", '');
          FoundQty := ServiceDefaultQty.FINDLAST;
        END;
        
        IF FoundQty THEN BEGIN
          DefaultQty := ServiceDefaultQty."Default Quantity";
          FreeQty := ServiceDefaultQty."Free Quantity";
          ToleranceQty := ServiceDefaultQty."Tolerance Quantity";
          EXIT;
        END;
        */
        DefaultQty := Service."Default Quantity";

    end;


    procedure ReverseLedgerEntry(var BLSLedgerEntry: Record "BLS Ledger Entry")
    var
        BLSJournalLine: Record "BLS Journal Line";
        BLSJournalLineLast: Record "BLS Journal Line";
        BLSJnlPostLine: Codeunit "BLS Jnl.-Post Line";
        ErrEntryIsCorr: label 'This entry is corrected already!';
    begin
        if not BLSLedgerEntry.FindFirst then
            exit;

        if BLSLedgerEntry.Correction then
            Error(ErrEntryIsCorr);

        BLSJournalLine.Init;
        BLSJournalLine.TransferFields(BLSLedgerEntry);
        // BLSJournalLineLast.SETRANGE("Journal Template Name", BLSJournalLine."Journal Template Name");
        // BLSJournalLineLast.SETRANGE("Journal Batch Name", BLSJournalLine."Journal Batch Name");
        // IF NOT BLSJournalLineLast.FINDLAST THEN
        //   CLEAR(BLSJournalLineLast);

        // BLSJournalLine."Line No." := BLSJournalLineLast."Line No." + 10000;
        BLSJournalLine.Validate(Quantity, -BLSJournalLine.Quantity);
        BLSJournalLine.Correction := true;
        // BLSJournalLine.INSERT;

        BLSJnlPostLine.Run(BLSJournalLine);
        // BLSJournalLine.DELETE;

        BLSLedgerEntry.Correction := true;
        BLSLedgerEntry.Modify;
    end;

    local procedure "--- Vehicle ---"()
    begin
    end;


    procedure GetContractByVehicle(VehicleNo: Code[20]; AtDate: Date; AllowDialog: Boolean) ContractNo: Code[20]
    var
        ContractVehicle: Record "Contract Vehicle";
        Contract: Record Contract;
        ContractNoFilter: Text;
    begin
        ContractNo := '';
        AllowDialog := AllowDialog and GuiAllowed;
        if VehicleNo = '' then
            exit;

        ContractVehicle.Reset;
        ContractVehicle.SetRange("Vehicle Serial No.", VehicleNo);
        ContractVehicle.SetRange(Blocked, false);
        if not ContractVehicle.FindFirst then
            exit;

        ContractNoFilter := ContractVehicle."Contract No.";
        while ContractVehicle.Next = 1 do
            ContractNoFilter := ContractNoFilter + '|' + ContractVehicle."Contract No.";

        Contract.Reset;
        Contract.SetFilter("Contract No.", ContractNoFilter);
        if AtDate <> 0D then begin
            Contract.SetFilter("Starting Date", '..%1', AtDate);
            Contract.SetFilter("Expiration Date", '%1|%2..', 0D, AtDate);
            Contract.SetRange(Status, Contract.Status::Active);
        end;

        case true of
            Contract.Count = 1:
                begin
                    Contract.FindFirst;
                    ContractNo := Contract."Contract No.";
                end;
            Contract.Count > 1:
                if AllowDialog then
                    if Page.RunModal(0, Contract) = Action::LookupOK then
                        ContractNo := Contract."Contract No.";
        end;
    end;


    procedure CheckVehicleInContract(ContractNo: Code[20]; VehicleNo: Code[20]; AtDate: Date): Boolean
    var
        ContractVehicle: Record "Contract Vehicle";
        Contract: Record Contract;
        ContractNoFilter: Text;
    begin
        if (ContractNo = '') or (VehicleNo = '') then
            exit(true);

        if not Contract.Get(ContractNo) then
            exit(false);

        if not (Contract.Status = Contract.Status::Active) then
            exit(false);

        if (AtDate <> 0D) then begin
            if (Contract."Starting Date" > AtDate) then
                exit(false);
            if (Contract."Expiration Date" <> 0D) then
                if (Contract."Expiration Date" < AtDate) then
                    exit(false);
        end;

        ContractVehicle.Reset;
        ContractVehicle.SetRange("Contract No.", Contract."Contract No.");
        ContractVehicle.SetRange("Vehicle Serial No.", VehicleNo);
        if AtDate <> 0D then
            ContractVehicle.SetRange(Blocked, false);
        if not ContractVehicle.FindFirst then
            exit(false);

        exit(true);
    end;

    local procedure "--- Is In Use ---"()
    begin
    end;


    procedure ObjectIsInUse(ObjectCode: Code[20]): Boolean
    var
        BLSJnlLine: Record "BLS Journal Line";
        BLSLedgEntry: Record "BLS Ledger Entry";
        DMSContractLine: Record "DMS Contract Line";
        CalcWrkshtLine: Record "BLS Calculation Worksheet Line";
        CalcLedgEntry: Record "BLS Calculation Ledger Entry";
        InvoicingLedgEntry: Record "BLS Invoicing Ledger Entry";
    begin
        BLSJnlLine.SetRange("Object Code", ObjectCode);
        if not BLSJnlLine.IsEmpty then
            exit(true);

        DMSContractLine.SetRange("Object Code", ObjectCode);
        if not DMSContractLine.IsEmpty then
            exit(true);

        BLSLedgEntry.SetRange("Object Code", ObjectCode);
        if not BLSLedgEntry.IsEmpty then
            exit(true);

        CalcWrkshtLine.SetRange("Object Code", ObjectCode);
        if not CalcWrkshtLine.IsEmpty then
            exit(true);

        CalcLedgEntry.SetRange("Object Code", ObjectCode);
        if not CalcLedgEntry.IsEmpty then
            exit(true);

        InvoicingLedgEntry.SetRange("Object Code", ObjectCode);
        if not InvoicingLedgEntry.IsEmpty then
            exit(true);

        exit(false);
    end;


    procedure ObjectCategoryIsInUse(CategoryCode: Code[20]): Boolean
    var
        BLSObject: Record "BLS Object";
    begin
        BLSObject.Reset;
        BLSObject.SetRange("Object Category Code", CategoryCode);
        if not BLSObject.IsEmpty then
            exit(true);

        exit(false);
    end;


    procedure ServiceIsInUse(ServiceCode: Code[20]): Boolean
    var
        BLSJnlLine: Record "BLS Journal Line";
        BLSLedgEntry: Record "BLS Ledger Entry";
        DMSContractLine: Record "DMS Contract Line";
        CalcWrkshtLine: Record "BLS Calculation Worksheet Line";
        CalcLedgEntry: Record "BLS Calculation Ledger Entry";
        InvoicingLedgEntry: Record "BLS Invoicing Ledger Entry";
    begin
        BLSJnlLine.SetRange("Service Code", ServiceCode);
        if not BLSJnlLine.IsEmpty then
            exit(true);

        DMSContractLine.SetRange("Service Code", ServiceCode);
        if not DMSContractLine.IsEmpty then
            exit(true);

        BLSLedgEntry.SetRange("Service Code", ServiceCode);
        if not BLSLedgEntry.IsEmpty then
            exit(true);

        CalcWrkshtLine.SetRange("Service Code", ServiceCode);
        if not CalcWrkshtLine.IsEmpty then
            exit(true);

        CalcLedgEntry.SetRange("Service Code", ServiceCode);
        if not CalcLedgEntry.IsEmpty then
            exit(true);

        InvoicingLedgEntry.SetRange("Service Code", ServiceCode);
        if not InvoicingLedgEntry.IsEmpty then
            exit(true);

        exit(false);
    end;

    local procedure "--- Calculation ---"()
    begin
    end;


    procedure DeleteInvoicingLedgEntry(EntryNo: Integer): Boolean
    var
        InvoicingLedgEntry: Record "BLS Invoicing Ledger Entry";
    begin
        if EntryNo = 0 then
            exit(false);

        if InvoicingLedgEntry.Get(EntryNo) then begin
            InvoicingLedgEntry.Delete(true);
            exit(true);
        end;

        exit(false);
    end;


    procedure CancelInvoicingLedgEntries(var InvoicingLedgEntry: Record "BLS Invoicing Ledger Entry")
    begin
        if not InvoicingLedgEntry.Find('-') then
            exit;

        repeat
            DeleteInvoicingLedgEntry(InvoicingLedgEntry."Entry No.");
        until InvoicingLedgEntry.Next = 0;
    end;

    local procedure "--- Contracts ---"()
    begin
    end;


    procedure PrepareContractDMSFilter(CustomerNo: Code[20]; DocDate: Date; var Contract: Record Contract)
    begin
        Contract.Reset;
        Contract.SetRange("Bill-to Customer No.", CustomerNo);
        Contract.SetFilter("Starting Date", '..%1', DocDate);
        Contract.SetFilter("Expiration Date", '%1|%2..', 0D, DocDate);
    end;


    procedure LookupActiveContract(PartnerType: Option " ",Customer,Vendor,Contact; PartnerNo: Code[20]; DocDate: Date; OldContractNo: Code[20]): Code[20]
    var
        ContractDMS: Record Contract;
    begin
        if PartnerType = Partnertype::Customer then begin
            PrepareContractDMSFilter(PartnerNo, DocDate, ContractDMS);
            ContractDMS.SetRange(Status, ContractDMS.Status::Active);

            if ContractDMS.Get(OldContractNo) then;

            if Page.RunModal(0, ContractDMS) = Action::LookupOK then
                exit(ContractDMS."Contract No.");
        end;

        exit(OldContractNo);
    end;

    [EventSubscriber(Objecttype::Codeunit, 80, 'OnAfterPostSalesDoc', '', false, false)]

    procedure UpdateLinkedBLSLeasingSchedule(SalesHeader: Record "Sales Header"; GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20];
                RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20]; CommitIsSuppressed: Boolean; InvtPickPutaway: Boolean)
    var
        BLSLeasingScheduleHeader: Record "BLS Leasing Schedule Header";
        BLSLeasingScheduleHeaderToUpdate: Record "BLS Leasing Schedule Header";

    begin
        BLSLeasingScheduleHeader.RESET;
        BLSLeasingScheduleHeader.SetRange("Sales Doc. No.", SalesHeader."No.");
        BLSLeasingScheduleHeader.SetRange("Sales Doc. Type", BLSLeasingScheduleHeader."Sales Doc. Type"::Order);
        if BLSLeasingScheduleHeader.FindSet() then
            repeat
                BLSLeasingScheduleHeaderToUpdate.Get(BLSLeasingScheduleHeader."No.");
                BLSLeasingScheduleHeaderToUpdate."Sales Doc. Type" := BLSLeasingScheduleHeaderToUpdate."Sales Doc. Type"::"Posted Invoice";
                BLSLeasingScheduleHeaderToUpdate."Sales Doc. No." := SalesInvHdrNo;
                BLSLeasingScheduleHeaderToUpdate.Modify();
            until BLSLeasingScheduleHeader.Next() = 0;
    end;

    [EventSubscriber(Objecttype::Codeunit, 86, 'OnBeforeModifySalesOrderHeader', '', false, false)]

    procedure UpdateLinkedBLSLeasingScheduleFromQuote(var SalesOrderHeader: Record "Sales Header"; SalesQuoteHeader: Record "Sales Header")
    var
        BLSLeasingScheduleHeader: Record "BLS Leasing Schedule Header";
        BLSLeasingScheduleHeaderToUpdate: Record "BLS Leasing Schedule Header";

    begin
        BLSLeasingScheduleHeader.RESET;
        BLSLeasingScheduleHeader.SetRange("Sales Doc. No.", SalesQuoteHeader."No.");
        BLSLeasingScheduleHeader.SetRange("Sales Doc. Type", BLSLeasingScheduleHeader."Sales Doc. Type"::Quote);
        if BLSLeasingScheduleHeader.FindSet() then
            repeat
                BLSLeasingScheduleHeaderToUpdate.Get(BLSLeasingScheduleHeader."No.");
                BLSLeasingScheduleHeaderToUpdate."Sales Doc. Type" := BLSLeasingScheduleHeaderToUpdate."Sales Doc. Type"::Order;
                BLSLeasingScheduleHeaderToUpdate."Sales Doc. No." := SalesOrderHeader."No.";
                BLSLeasingScheduleHeaderToUpdate.Modify();
            until BLSLeasingScheduleHeader.Next() = 0;
    end;
}

