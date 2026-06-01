Codeunit 25006000 "DocumentManagementDMS"
{
    // 20.02.2018 EB.AKR
    //   Added functions:
    //     EmailSalesInvoiceHeaderDocument
    //     SaveSalesInvoiceHeaderReportAsPdf
    //     SaveSalesCrMemoHeaderReportAsPdf
    //     EmailSalesCrMemoHeaderDocument
    //     SaveSalesShipmentHeaderReportAsPdf
    //     EmailSalesShipmentHeaderDocument
    //     EmailSalesInvoiceLineDocument
    //     SaveSalesInvoiceLineReportAsPdf
    //     SaveSalesCrMemoLineReportAsPdf
    //     EmailSalesCrMemoLineDocument
    //     SaveSalesShipmentLineReportAsPdf
    //     EmailSalesShipmentLineDocument
    //     SavePurchaseInvoiceLineReportAsPdf
    //     EmailPurchaseInvoiceLineDocument
    //     SavePurchaseInvoiceHeaderReportAsPdf
    //     EmailPurchaseInvoiceHeaderDocument
    //     SavePurchaseCrMemoLineReportAsPdf
    //     EmailPurchaseCrMemoLineDocument
    //     SavePurchaseCrMemoHeaderReportAsPdf
    //     EmailPurchaseCrMemoHeaderDocument
    //     SavePurchaseReceiptLineReportAsPdf
    //     EmailPurchaseReceiptLineDocument
    //     SavePurchaseReceiptHeaderReportAsPdf
    //     EmailPurchaseReceiptHeaderDocument
    // 
    //   Modified function:
    // 
    // 
    // 16.03.2016 EB.P7 Branch Profile Setup
    //   Modified GetDefaultItemFlow(), Usert Profile Setup to Branch Profile Setup
    // 
    // 24.08.2014 EDMS P7
    //   * Added function IsWebClientSession
    // 
    // 26.06.2013 EDMS P8
    //   * Added function WriteBigTextToFile
    // 
    // 10.01.2008. EDMS P2
    //   * Added functions:
    //               ServiceSplitLine
    //               ServiceCopyDimensions
    //               ServiceGetNewLineNo
    // 
    // 04.10.2007. EDMS P2
    //   * Addded function ShowVehicleComment
    // 
    // 31.08.2007. EDMS P2
    //   * Added code in function "fSL_SetType_LineType(VAR recSalesLine : Record "Sales Line")"
    // 
    // 27.08.2007. EDMS P2
    //   * Added functions
    //      SelectSalesInvDocReport
    //      SelectShipmentDocReport
    //      SelectCrMemoDocReport
    //      SelectReturnReceiptDocReport
    //      SelectPurchHdrDocReport
    //      SelectTransferDocReport
    //      SelectPurchInvDocReport
    //      SelectRetShipmentDocReport
    //      SelectPurchCrMemoDocReport
    //      SelectPurchRcptDocReport
    //      SelectPostServDocReport
    //      SelectPostServRetDocReport
    //      SelectExportSalesHdr
    //      SelectExportSalesInvHdr
    //      SelectImportPurchHdr
    //      fPrintCurrentDoc
    //      ChooseExcelReport
    // 
    // 27.07.2007. EDMS P2
    //   * Added function ShowCustomerComments

    SingleInstance = true;

    trigger OnRun()
    begin
    end;

    var
        bDocItemStatFrmOpen: Boolean;
        cuSingleInstanceMgt: Codeunit SingleInstanceManagement;
        cuWorkplaceMgt: Codeunit UserProfileManagement;
        recWorkplace: Record "Branch Profile Setup";
        EDMS001: label 'Customer %1 comment lines: %2';
        EDMS002: label 'Vehicle %1 comment lines: %2';
        Text004: label 'The parameter %1 is out of the valid range.\';
        Text008: label '<Color>';
        Text009: label 'Valid range: 0..16777215';
        ServiceScheduleMgt: Codeunit "Service Schedule Mgt.";
        UserSetup: Record "User Setup";
        ServerSaveAsPdfFailedErr: label 'Cannot open the document because it is empty or cannot be created.';
        DocumentMailing: Codeunit "Document-Mailing";
        Text010: label 'Service Order';
        Text011: label 'Sales %1';
        ReportAsPdfFileNameMsg: label '%1 %2.pdf', Comment = '%1 = Document Type %2 = Invoice No.';
        Text012: label 'Purchase %1';
        EmailSubjectCapTxt: label '%1 - %2 %3', Comment = '%1 = Vendor Name. %2 = Document Type %3 = Document No.';
        Text021: label 'Purchase Order';
        Text022: label 'Purchase Invoice';
        Text023: label 'Purchase Receipt';
        Text024: label 'Purchase Cr.Memo';
        Text025: label 'Return Shipment';
        Text026: label 'Return Receipt';
        CaptionManagement: Codeunit "Caption Class";
        TextManagement: Codeunit "Filter Tokens";
        Text027: label 'Rent Order';
        Text028: Label 'Vehicle not created, Sales Line No. %1';
        Text029: label 'For Sell-to Customer,For Bill-to Customer';
        Text030: label 'There is already a contract specified in Sales Order. Do you want to continue and create another contract?';
        Text031: Label 'Contract is not Active';
        Text032: Label 'Rent Order %1 is created';
        Text033: Label 'Service Order %1 is created';
        Text034: Label 'Vehicle does not exist, Rent Line No. %1';
        Text035: label 'There is already a Rent Order with this contract. Do you want to continue and create another order?';
        Text036: Label 'Sales document is created, Document Type: %1, Document No.: %2. Do you want to open it?';
        Text037: Label 'Service document is created, Document Type: %1, Document No.: %2. Do you want to open it?';
        OpenRentOrderQst: label 'The Rent Order %1 has been created. Do you want to open the new order?';
        SendToContact: Boolean;


    procedure GetDMSVersion(): Text[80]
    var
        "Object": Record AllObjWithCaption;
    begin
        exit('Elva DMS Add-On version 16.00.00');
    end;


    procedure DocSetItemStatFrmOpen(bNewValue: Boolean)
    begin
        bDocItemStatFrmOpen := bNewValue;
    end;


    procedure DocGetItemStatFrmOpen(): Boolean
    begin
        exit(bDocItemStatFrmOpen);
    end;


    procedure SL_SetType_LineType(var recSalesLine: Record "Sales Line")
    begin
        case recSalesLine."Line Type" of
            recSalesLine."line type"::Comment:
                begin
                    recSalesLine.Validate(Type, recSalesLine.Type::" ");
                end;
            recSalesLine."line type"::"G/L Account":
                begin
                    recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                end;
            recSalesLine."line type"::Item:
                begin
                    recSalesLine.Validate(Type, recSalesLine.Type::Item);
                end;
            recSalesLine."line type"::Labor:
                begin
                    recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                end;
            recSalesLine."line type"::"Ext. Service":
                begin
                    recSalesLine.Validate(Type, recSalesLine.Type::"G/L Account");
                end;
            recSalesLine."line type"::Vehicle:
                begin
                    recSalesLine.Validate(Type, recSalesLine.Type::Item);
                end;
            recSalesLine."line type"::"Charge (Item)":
                begin
                    recSalesLine.Validate(Type, recSalesLine.Type::"Charge (Item)");
                end;
            //31.08.2007. EDMS P2 >>
            recSalesLine."line type"::"Fixed Asset":
                begin
                    recSalesLine.Validate(Type, recSalesLine.Type::"Fixed Asset");
                end;
            //31.08.2007. EDMS P2 <<
            recSalesLine."line type"::Resource:
                begin
                    recSalesLine.Validate(Type, recSalesLine.Type::Resource);
                end;
        end;
    end;


    procedure PL_SetType_LineType(var recPurchLine: Record "Purchase Line")
    begin
        case recPurchLine."Line Type" of
            recPurchLine."line type"::Comment:
                begin
                    recPurchLine.Validate(Type, recPurchLine.Type::" ");
                end;
            recPurchLine."line type"::Vehicle:
                begin
                    recPurchLine.Validate(Type, recPurchLine.Type::Item);
                end;
            recPurchLine."line type"::Item:
                begin
                    recPurchLine.Validate(Type, recPurchLine.Type::Item);
                end;
            recPurchLine."line type"::"Charge (Item)":
                begin
                    recPurchLine.Validate(Type, recPurchLine.Type::"Charge (Item)");
                end;
            recPurchLine."line type"::"G/L Account":
                begin
                    recPurchLine.Validate(Type, recPurchLine.Type::"G/L Account");
                end;
            recPurchLine."line type"::Resource:
                begin
                    recPurchLine.Validate(Type, recPurchLine.Type::Resource);
                end;
        end;
    end;


    procedure GetDefaultItemFlow(): Code[10]
    var
        codWorkplaceCode: Code[10];
    begin
        codWorkplaceCode := cuWorkplaceMgt.CurrProfileID;
        if codWorkplaceCode <> '' then begin
            Clear(recWorkplace);
            if recWorkplace.Get(codWorkplaceCode, cuWorkplaceMgt.CurrBranchNo) then begin
                exit(recWorkplace."Default Deal Type Code");
            end;
        end;
    end;


    procedure SelectSalesDocReport(var recRepSelect: Record "Document Report"; recSalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; SendAsEmail: Boolean)
    var
        intCount: Integer;
    begin
        recSalesHeader.SetRange("Document Type", recSalesHeader."Document Type");
        recSalesHeader.SetRange("No.", recSalesHeader."No.");
        intCount := recRepSelect.Count;
        if intCount > 1 then begin
            if Page.RunModal(Page::"Document Reports-Selection", recRepSelect) = Action::LookupOK then begin
                if recRepSelect."E-mail To" = recRepSelect."E-mail To"::Contact then
                    SendToContact := true
                else
                    SendToContact := false;
                if recRepSelect."Take From Lines" then begin
                    if SendAsEmail then
                        EmailSalesLineDocument(SalesLine, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, SalesLine);
                end else begin
                    if SendAsEmail then
                        EmailSalesHeaderDocument(recSalesHeader, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, recSalesHeader);
                end;
            end;
        end else
            if intCount = 1 then begin
                recRepSelect.FindFirst;
                if recRepSelect."E-mail To" = recRepSelect."E-mail To"::Contact then
                    SendToContact := true
                else
                    SendToContact := false;
                if recRepSelect."Take From Lines" then begin
                    if SendAsEmail then
                        EmailSalesLineDocument(SalesLine, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, SalesLine);
                end else begin
                    if SendAsEmail then
                        EmailSalesHeaderDocument(recSalesHeader, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, recSalesHeader);
                end;
            end;
    end;


    procedure SelectSalesInvDocReport(var recRepSelect: Record "Document Report"; recSalesInvHeader: Record "Sales Invoice Header"; var recSalesInvLine: Record "Sales Invoice Line"; SendAsEmail: Boolean)
    var
        intCount: Integer;
    begin
        recSalesInvHeader.SetRange("No.", recSalesInvHeader."No.");
        intCount := recRepSelect.Count;
        if intCount > 1 then begin
            if Page.RunModal(Page::"Document Reports-Selection", recRepSelect) = Action::LookupOK then begin
                if recRepSelect."E-mail To" = recRepSelect."E-mail To"::Contact then
                    SendToContact := true
                else
                    SendToContact := false;
                if recRepSelect."Take From Lines" then begin
                    if SendAsEmail then
                        EmailSalesInvoiceLineDocument(recSalesInvLine, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, recSalesInvLine);
                end else begin
                    if SendAsEmail then
                        EmailSalesInvoiceHeaderDocument(recSalesInvHeader, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, recSalesInvHeader);
                end;
            end;
        end else
            if intCount = 1 then begin
                recRepSelect.FindFirst;
                if recRepSelect."E-mail To" = recRepSelect."E-mail To"::Contact then
                    SendToContact := true
                else
                    SendToContact := false;
                if recRepSelect."Take From Lines" then begin
                    if SendAsEmail then
                        EmailSalesInvoiceLineDocument(recSalesInvLine, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, recSalesInvLine);
                end else begin
                    if SendAsEmail then
                        EmailSalesInvoiceHeaderDocument(recSalesInvHeader, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, recSalesInvHeader);
                end;
            end;
    end;


    procedure SelectShipmentDocReport(var recRepSelect: Record "Document Report"; SalesShipmentHeader: Record "Sales Shipment Header"; var SalesShipmentLine: Record "Sales Shipment Line"; SendAsEmail: Boolean)
    var
        intCount: Integer;
    begin
        SalesShipmentHeader.SetRange("No.", SalesShipmentHeader."No.");
        intCount := recRepSelect.Count;
        if intCount > 1 then begin
            if Page.RunModal(Page::"Document Reports-Selection", recRepSelect) = Action::LookupOK then begin
                if recRepSelect."E-mail To" = recRepSelect."E-mail To"::Contact then
                    SendToContact := true
                else
                    SendToContact := false;
                if recRepSelect."Take From Lines" then begin
                    if SendAsEmail then
                        EmailSalesShipmentLineDocument(SalesShipmentLine, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, SalesShipmentLine);
                end else begin
                    if SendAsEmail then
                        EmailSalesShipmentHeaderDocument(SalesShipmentHeader, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, SalesShipmentHeader);
                end;
            end;
        end else
            if intCount = 1 then begin
                recRepSelect.FindFirst;
                if recRepSelect."E-mail To" = recRepSelect."E-mail To"::Contact then
                    SendToContact := true
                else
                    SendToContact := false;
                if recRepSelect."Take From Lines" then begin
                    if SendAsEmail then
                        EmailSalesShipmentLineDocument(SalesShipmentLine, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, SalesShipmentLine);
                end else begin
                    if SendAsEmail then
                        EmailSalesShipmentHeaderDocument(SalesShipmentHeader, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, SalesShipmentHeader);
                end;
            end;
    end;


    procedure SelectCrMemoDocReport(var recRepSelect: Record "Document Report"; SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var SalesCrMemoLine: Record "Sales Cr.Memo Line"; SendAsEmail: Boolean)
    var
        intCount: Integer;
    begin
        SalesCrMemoHeader.SetRange("No.", SalesCrMemoHeader."No.");
        intCount := recRepSelect.Count;
        if intCount > 1 then begin
            if Page.RunModal(Page::"Document Reports-Selection", recRepSelect) = Action::LookupOK then begin
                if recRepSelect."E-mail To" = recRepSelect."E-mail To"::Contact then
                    SendToContact := true
                else
                    SendToContact := false;
                if recRepSelect."Take From Lines" then begin
                    if SendAsEmail then
                        EmailSalesCrMemoLineDocument(SalesCrMemoLine, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, SalesCrMemoLine);
                end else begin
                    if SendAsEmail then
                        EmailSalesCrMemoHeaderDocument(SalesCrMemoHeader, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, SalesCrMemoHeader);
                end;
            end;
        end else
            if intCount = 1 then begin
                recRepSelect.FindFirst;
                if recRepSelect."E-mail To" = recRepSelect."E-mail To"::Contact then
                    SendToContact := true
                else
                    SendToContact := false;
                if recRepSelect."Take From Lines" then begin
                    if SendAsEmail then
                        EmailSalesCrMemoLineDocument(SalesCrMemoLine, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, SalesCrMemoLine);
                end else begin
                    if SendAsEmail then
                        EmailSalesCrMemoHeaderDocument(SalesCrMemoHeader, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, SalesCrMemoHeader);
                end;
            end;
    end;


    procedure SelectReturnReceiptDocReport(var recRepSelect: Record "Document Report"; ReturnReceiptHdr: Record "Return Receipt Header"; var ReturnReceiptLine: Record "Return Receipt Line"; SendAsEmail: Boolean)
    var
        intCount: Integer;
    begin
        ReturnReceiptHdr.SetRange("No.", ReturnReceiptHdr."No.");
        intCount := recRepSelect.Count;
        if intCount > 1 then begin
            if Page.RunModal(Page::"Document Reports-Selection", recRepSelect) = Action::LookupOK then begin
                if recRepSelect."E-mail To" = recRepSelect."E-mail To"::Contact then
                    SendToContact := true
                else
                    SendToContact := false;
                if recRepSelect."Take From Lines" then begin
                    if SendAsEmail then
                        EmailReturnReceiptLineDocument(ReturnReceiptLine, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, ReturnReceiptLine);
                end else begin
                    if SendAsEmail then
                        EmailReturnReceiptHeaderDocument(ReturnReceiptHdr, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, ReturnReceiptHdr);
                end;
            end;
        end else
            if intCount = 1 then begin
                recRepSelect.FindFirst;
                if recRepSelect."E-mail To" = recRepSelect."E-mail To"::Contact then
                    SendToContact := true
                else
                    SendToContact := false;
                if recRepSelect."Take From Lines" then begin
                    if SendAsEmail then
                        EmailReturnReceiptLineDocument(ReturnReceiptLine, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, ReturnReceiptLine);
                end else begin
                    if SendAsEmail then
                        EmailReturnReceiptHeaderDocument(ReturnReceiptHdr, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, ReturnReceiptHdr);
                end;
            end;

        /*ReturnReceiptHdr.SETRANGE("No.",ReturnReceiptHdr."No.");
        intCount := recRepSelect.COUNT;
        IF intCount > 1 THEN
         BEGIN
          IF PAGE.RUNMODAL(PAGE::"Document Reports-Selection",recRepSelect) = ACTION::LookupOK THEN
           REPORT.RUNMODAL(recRepSelect."Report ID",TRUE,FALSE,ReturnReceiptHdr);
         END
        ELSE
         IF intCount = 1 THEN
          BEGIN
           recRepSelect.FINDFIRST;
           REPORT.RUNMODAL(recRepSelect."Report ID",TRUE,FALSE,ReturnReceiptHdr);
          END;
          */

    end;


    procedure SelectPurchHdrDocReport(var recRepSelect: Record "Document Report"; PurchHdr: Record "Purchase Header"; var PurchLine: Record "Purchase Line"; SendAsEmail: Boolean)
    var
        intCount: Integer;
    begin
        PurchHdr.SetRange("Document Type", PurchHdr."Document Type");
        PurchHdr.SetRange("No.", PurchHdr."No.");
        intCount := recRepSelect.Count;
        if intCount > 1 then begin
            if Page.RunModal(Page::"Document Reports-Selection", recRepSelect) = Action::LookupOK then begin
                if recRepSelect."E-mail To" = recRepSelect."E-mail To"::Contact then
                    SendToContact := true
                else
                    SendToContact := false;
                if recRepSelect."Take From Lines" then begin
                    if SendAsEmail then
                        EmailPurchaseLineDocument(PurchLine, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, PurchLine);
                end else begin
                    if SendAsEmail then
                        EmailPurchaseHeaderDocument(PurchHdr, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, PurchHdr);
                end;
            end;
        end else begin
            if intCount = 1 then begin
                recRepSelect.FindFirst;
                if recRepSelect."E-mail To" = recRepSelect."E-mail To"::Contact then
                    SendToContact := true
                else
                    SendToContact := false;
                if recRepSelect."Take From Lines" then begin
                    if SendAsEmail then
                        EmailPurchaseLineDocument(PurchLine, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, PurchLine);
                end else begin
                    if SendAsEmail then
                        EmailPurchaseHeaderDocument(PurchHdr, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, PurchHdr);
                end;
            end;
        end;
    end;


    procedure SelectTransferDocReport(var recRepSelect: Record "Document Report"; TransferHdr: Record "Transfer Header")
    var
        intCount: Integer;
    begin
        TransferHdr.SetRange("No.", TransferHdr."No.");
        intCount := recRepSelect.Count;
        if intCount > 1 then begin
            if Page.RunModal(Page::"Document Reports-Selection", recRepSelect) = Action::LookupOK then begin
                if recRepSelect."E-mail To" = recRepSelect."E-mail To"::Contact then
                    SendToContact := true
                else
                    SendToContact := false;
                Report.RunModal(recRepSelect."Report ID", true, false, TransferHdr);
            end;
        end
        else
            if intCount = 1 then begin
                recRepSelect.FindFirst;
                if recRepSelect."E-mail To" = recRepSelect."E-mail To"::Contact then
                    SendToContact := true
                else
                    SendToContact := false;
                Report.RunModal(recRepSelect."Report ID", true, false, TransferHdr);
            end;
    end;


    procedure SelectPurchInvDocReport(var recRepSelect: Record "Document Report"; PurchInvHdr: Record "Purch. Inv. Header"; var PurchInvLine: Record "Purch. Inv. Line"; SendAsEmail: Boolean)
    var
        intCount: Integer;
    begin
        PurchInvHdr.SetRange("No.", PurchInvHdr."No.");
        intCount := recRepSelect.Count;
        if intCount > 1 then begin
            if Page.RunModal(Page::"Document Reports-Selection", recRepSelect) = Action::LookupOK then begin
                if recRepSelect."E-mail To" = recRepSelect."E-mail To"::Contact then
                    SendToContact := true
                else
                    SendToContact := false;
                if recRepSelect."Take From Lines" then begin
                    if SendAsEmail then
                        EmailPurchaseInvoiceLineDocument(PurchInvLine, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, PurchInvLine);
                end else begin
                    if SendAsEmail then
                        EmailPurchaseInvoiceHeaderDocument(PurchInvHdr, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, PurchInvHdr);
                end;
            end;
        end else begin
            if intCount = 1 then begin
                recRepSelect.FindFirst;
                if recRepSelect."E-mail To" = recRepSelect."E-mail To"::Contact then
                    SendToContact := true
                else
                    SendToContact := false;
                if recRepSelect."Take From Lines" then begin
                    if SendAsEmail then
                        EmailPurchaseInvoiceLineDocument(PurchInvLine, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, PurchInvLine);
                end else begin
                    if SendAsEmail then
                        EmailPurchaseInvoiceHeaderDocument(PurchInvHdr, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, PurchInvHdr);
                end;
            end;
        end;
    end;


    procedure SelectRetShipmentDocReport(var recRepSelect: Record "Document Report"; RetShipmentHdr: Record "Return Shipment Header"; var RetShipmentLine: Record "Return Shipment Line"; SendAsEmail: Boolean)
    var
        intCount: Integer;
    begin
        RetShipmentHdr.SetRange("No.", RetShipmentHdr."No.");
        intCount := recRepSelect.Count;
        if intCount > 1 then begin
            if Page.RunModal(Page::"Document Reports-Selection", recRepSelect) = Action::LookupOK then begin
                if recRepSelect."E-mail To" = recRepSelect."E-mail To"::Contact then
                    SendToContact := true
                else
                    SendToContact := false;
                if recRepSelect."Take From Lines" then begin
                    if SendAsEmail then
                        EmailReturnShipmentLineDocument(RetShipmentLine, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, RetShipmentLine);
                end else begin
                    if SendAsEmail then
                        EmailReturnShipmentHeaderDocument(RetShipmentHdr, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, RetShipmentHdr);
                end;
            end;
        end else begin
            if intCount = 1 then begin
                recRepSelect.FindFirst;
                if recRepSelect."E-mail To" = recRepSelect."E-mail To"::Contact then
                    SendToContact := true
                else
                    SendToContact := false;
                if recRepSelect."Take From Lines" then begin
                    if SendAsEmail then
                        EmailReturnShipmentLineDocument(RetShipmentLine, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, RetShipmentLine);
                end else begin
                    if SendAsEmail then
                        EmailReturnShipmentHeaderDocument(RetShipmentHdr, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, RetShipmentHdr);
                end;
            end;
        end;
    end;


    procedure SelectPurchCrMemoDocReport(var recRepSelect: Record "Document Report"; PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var PurchCrMemoLine: Record "Purch. Cr. Memo Line"; SendAsEmail: Boolean)
    var
        intCount: Integer;
    begin
        PurchCrMemoHdr.SetRange("No.", PurchCrMemoHdr."No.");
        intCount := recRepSelect.Count;
        if intCount > 1 then begin
            if Page.RunModal(Page::"Document Reports-Selection", recRepSelect) = Action::LookupOK then begin
                if recRepSelect."E-mail To" = recRepSelect."E-mail To"::Contact then
                    SendToContact := true
                else
                    SendToContact := false;
                if recRepSelect."Take From Lines" then begin
                    if SendAsEmail then
                        EmailPurchaseCrMemoLineDocument(PurchCrMemoLine, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, PurchCrMemoLine);
                end else begin
                    if SendAsEmail then
                        EmailPurchaseCrMemoHeaderDocument(PurchCrMemoHdr, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, PurchCrMemoHdr);
                end;
            end;
        end else begin
            if intCount = 1 then begin
                recRepSelect.FindFirst;
                if recRepSelect."E-mail To" = recRepSelect."E-mail To"::Contact then
                    SendToContact := true
                else
                    SendToContact := false;
                if recRepSelect."Take From Lines" then begin
                    if SendAsEmail then
                        EmailPurchaseCrMemoLineDocument(PurchCrMemoLine, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, PurchCrMemoLine);
                end else begin
                    if SendAsEmail then
                        EmailPurchaseCrMemoHeaderDocument(PurchCrMemoHdr, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, PurchCrMemoHdr);
                end;
            end;
        end;
    end;


    procedure SelectPurchRcptDocReport(var recRepSelect: Record "Document Report"; PurchRcptHdr: Record "Purch. Rcpt. Header"; var PurchRcptLine: Record "Purch. Rcpt. Line"; SendAsEmail: Boolean)
    var
        intCount: Integer;
    begin
        PurchRcptHdr.SetRange("No.", PurchRcptHdr."No.");
        intCount := recRepSelect.Count;
        if intCount > 1 then begin
            if Page.RunModal(Page::"Document Reports-Selection", recRepSelect) = Action::LookupOK then begin
                if recRepSelect."E-mail To" = recRepSelect."E-mail To"::Contact then
                    SendToContact := true
                else
                    SendToContact := false;
                if recRepSelect."Take From Lines" then begin
                    if SendAsEmail then
                        EmailPurchaseReceiptLineDocument(PurchRcptLine, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, PurchRcptLine);
                end else begin
                    if SendAsEmail then
                        EmailPurchaseReceiptHeaderDocument(PurchRcptHdr, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, PurchRcptHdr);
                end;
            end;
        end else begin
            if intCount = 1 then begin
                recRepSelect.FindFirst;
                if recRepSelect."E-mail To" = recRepSelect."E-mail To"::Contact then
                    SendToContact := true
                else
                    SendToContact := false;
                if recRepSelect."Take From Lines" then begin
                    if SendAsEmail then
                        EmailPurchaseReceiptLineDocument(PurchRcptLine, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, PurchRcptLine);
                end else begin
                    if SendAsEmail then
                        EmailPurchaseReceiptHeaderDocument(PurchRcptHdr, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, PurchRcptHdr);
                end;
            end;
        end;

        /*PurchRcptHdr.SETRANGE("No.",PurchRcptHdr."No.");
        intCount := recRepSelect.COUNT;
        IF intCount > 1 THEN
         BEGIN
          IF PAGE.RUNMODAL(PAGE::"Document Reports-Selection",recRepSelect) = ACTION::LookupOK THEN
           REPORT.RUNMODAL(recRepSelect."Report ID",TRUE,FALSE,PurchRcptHdr);
         END
        ELSE
         IF intCount = 1 THEN
          BEGIN
           recRepSelect.FINDFIRST;
           REPORT.RUNMODAL(recRepSelect."Report ID",TRUE,FALSE,PurchRcptHdr);
          END;*/

    end;


    procedure SelectServDocReport(var recRepSelect: Record "Document Report"; recServHeader: Record "Service Header EDMS"; var ServLines: Record "Service Line EDMS"; SendAsEmail: Boolean)
    var
        intCount: Integer;
    begin
        recServHeader.SetRange("Document Type", recServHeader."Document Type");
        recServHeader.SetRange("No.", recServHeader."No.");
        intCount := recRepSelect.Count;
        if intCount > 1 then begin
            if Page.RunModal(Page::"Document Reports-Selection", recRepSelect) = Action::LookupOK then begin
                if recRepSelect."E-mail To" = recRepSelect."E-mail To"::Contact then
                    SendToContact := true
                else
                    SendToContact := false;
                if recRepSelect."Take From Lines" then begin
                    if SendAsEmail then
                        EmailServiceLineDocument(ServLines, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, ServLines);
                end else begin
                    if SendAsEmail then
                        EmailServiceHeaderDocument(recServHeader, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, recServHeader);
                end;
            end;
        end
        else
            if intCount = 1 then begin
                recRepSelect.FindFirst;
                if recRepSelect."E-mail To" = recRepSelect."E-mail To"::Contact then
                    SendToContact := true
                else
                    SendToContact := false;
                if recRepSelect."Take From Lines" then begin
                    if SendAsEmail then
                        EmailServiceLineDocument(ServLines, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, ServLines);
                end else begin
                    if SendAsEmail then
                        EmailServiceHeaderDocument(recServHeader, recRepSelect."Report ID")
                    else
                        Report.RunModal(recRepSelect."Report ID", true, false, recServHeader);
                end;
            end;
    end;


    procedure SelectPostServDocReport(var recRepSelect: Record "Document Report"; PostServHdr: Record "Posted Serv. Order Header")
    var
        intCount: Integer;
    begin
        PostServHdr.SetRange("No.", PostServHdr."No.");
        intCount := recRepSelect.Count;
        if intCount > 1 then begin
            if Page.RunModal(Page::"Document Reports-Selection", recRepSelect) = Action::LookupOK then begin
                if recRepSelect."E-mail To" = recRepSelect."E-mail To"::Contact then
                    SendToContact := true
                else
                    SendToContact := false;
                Report.RunModal(recRepSelect."Report ID", true, false, PostServHdr);
            end;
        end
        else
            if intCount = 1 then begin
                recRepSelect.FindFirst;
                if recRepSelect."E-mail To" = recRepSelect."E-mail To"::Contact then
                    SendToContact := true
                else
                    SendToContact := false;
                Report.RunModal(recRepSelect."Report ID", true, false, PostServHdr);
            end;
    end;


    procedure SelectPostServRetDocReport(var recRepSelect: Record "Document Report"; PostServRetHdr: Record "Posted Serv. Ret. Order Header")
    var
        intCount: Integer;
    begin
        PostServRetHdr.SetRange("No.", PostServRetHdr."No.");
        intCount := recRepSelect.Count;
        if intCount > 1 then begin
            if Page.RunModal(Page::"Document Reports-Selection", recRepSelect) = Action::LookupOK then begin
                if recRepSelect."E-mail To" = recRepSelect."E-mail To"::Contact then
                    SendToContact := true
                else
                    SendToContact := false;
                Report.RunModal(recRepSelect."Report ID", true, false, PostServRetHdr);
            end;
        end
        else
            if intCount = 1 then begin
                recRepSelect.FindFirst;
                if recRepSelect."E-mail To" = recRepSelect."E-mail To"::Contact then
                    SendToContact := true
                else
                    SendToContact := false;
                Report.RunModal(recRepSelect."Report ID", true, false, PostServRetHdr);
            end;
    end;


    procedure SelectExportSalesHdr(var DataExchangeSelect: Record "Data Exch. Reports"; SalesHdr: Record "Sales Header"; var SalesLine: Record "Sales Line")
    var
        intCount: Integer;
    begin
        SalesHdr.SetRange("Document Type", SalesHdr."Document Type");
        SalesHdr.SetRange("No.", SalesHdr."No.");
        intCount := DataExchangeSelect.Count;
        if intCount > 1 then begin
            if Page.RunModal(Page::"Data Exch. Reports-Selection", DataExchangeSelect) = Action::LookupOK then begin
                if DataExchangeSelect."Take From Lines" then
                    Report.RunModal(DataExchangeSelect."Report ID", true, false, SalesLine)
                else
                    Report.RunModal(DataExchangeSelect."Report ID", true, false, SalesHdr);
            end;
        end
        else
            if intCount = 1 then begin
                DataExchangeSelect.FindFirst;
                if DataExchangeSelect."Take From Lines" then
                    Report.RunModal(DataExchangeSelect."Report ID", true, false, SalesLine)
                else
                    Report.RunModal(DataExchangeSelect."Report ID", true, false, SalesHdr);
            end;
    end;


    procedure SelectExportSalesInvHdr(var DataExchangeSelect: Record "Data Exch. Reports"; SalesInvHdr: Record "Sales Invoice Header")
    var
        intCount: Integer;
    begin
        SalesInvHdr.SetRange("No.", SalesInvHdr."No.");
        intCount := DataExchangeSelect.Count;
        if intCount > 1 then begin
            if Page.RunModal(Page::"Data Exch. Reports-Selection", DataExchangeSelect) = Action::LookupOK then
                Report.RunModal(DataExchangeSelect."Report ID", true, false, SalesInvHdr);
        end
        else
            if intCount = 1 then begin
                DataExchangeSelect.FindFirst;
                Report.RunModal(DataExchangeSelect."Report ID", true, false, SalesInvHdr);
            end;
    end;


    procedure SelectImportPurchHdr(var DataExchangeSelect: Record "Data Exch. Reports"; PurchaseHdr: Record "Purchase Header"; var PurchLine: Record "Purchase Line")
    var
        intCount: Integer;
    begin
        PurchaseHdr.SetRange("Document Type", PurchaseHdr."Document Type");
        PurchaseHdr.SetRange("No.", PurchaseHdr."No.");
        intCount := DataExchangeSelect.Count;
        if intCount > 1 then begin
            if Page.RunModal(Page::"Data Exch. Reports-Selection", DataExchangeSelect) = Action::LookupOK then begin
                if DataExchangeSelect."Take From Lines" then
                    Report.RunModal(DataExchangeSelect."Report ID", true, false, PurchLine)
                else
                    Report.RunModal(DataExchangeSelect."Report ID", true, false, PurchaseHdr);
            end;
        end
        else
            if intCount = 1 then begin
                DataExchangeSelect.FindFirst;
                if DataExchangeSelect."Take From Lines" then
                    Report.RunModal(DataExchangeSelect."Report ID", true, false, PurchLine)
                else
                    Report.RunModal(DataExchangeSelect."Report ID", true, false, PurchaseHdr);
            end;
    end;


    procedure SelectContractDocReport(var recRepSelect: Record "Document Report"; Contract: Record Contract)
    var
        intCount: Integer;
    begin
        Contract.SetRange("Contract No.", Contract."Contract No.");
        intCount := recRepSelect.Count;
        if intCount > 1 then begin
            if Page.RunModal(Page::"Document Reports-Selection", recRepSelect) = Action::LookupOK then begin
                if recRepSelect."E-mail To" = recRepSelect."E-mail To"::Contact then
                    SendToContact := true
                else
                    SendToContact := false;
                Report.RunModal(recRepSelect."Report ID", true, false, Contract);
            end;
        end else
            if intCount = 1 then begin
                recRepSelect.FindFirst;
                if recRepSelect."E-mail To" = recRepSelect."E-mail To"::Contact then
                    SendToContact := true
                else
                    SendToContact := false;
                Report.RunModal(recRepSelect."Report ID", true, false, Contract)
            end;
    end;


    procedure SelectProcessChklistDocReport(var RepSelect: Record "Document Report"; ProcessChecklistHeader: Record "Process Checklist Header")
    var
        intCount: Integer;
    begin
        ProcessChecklistHeader.SetRange("No.", ProcessChecklistHeader."No.");
        intCount := RepSelect.Count;
        if intCount > 1 then begin
            if Page.RunModal(Page::"Document Reports-Selection", RepSelect) = Action::LookupOK then begin
                if RepSelect."E-mail To" = RepSelect."E-mail To"::Contact then
                    SendToContact := true
                else
                    SendToContact := false;
                Report.RunModal(RepSelect."Report ID", true, false, ProcessChecklistHeader);
            end;
        end else
            if intCount = 1 then begin
                RepSelect.FindFirst;
                if RepSelect."E-mail To" = RepSelect."E-mail To"::Contact then
                    SendToContact := true
                else
                    SendToContact := false;
                Report.RunModal(RepSelect."Report ID", true, false, ProcessChecklistHeader)
            end;
    end;


    procedure PrintCurrentDoc(DocumentProfile: Option ,"Spare Parts Trade","Vehicles Trade",Service,Rent; DocumentKind: Integer; DocumentType: Integer; var recRepSelect: Record "Document Report")
    begin
        recRepSelect.Reset;
        case DocumentProfile of
            Documentprofile::"Vehicles Trade":
                recRepSelect.SetRange("Document Profile", recRepSelect."document profile"::"Vehicles Trade");
            Documentprofile::"Spare Parts Trade":
                recRepSelect.SetRange("Document Profile", recRepSelect."document profile"::"Spare Parts Trade");
            Documentprofile::Service:
                recRepSelect.SetRange("Document Profile", recRepSelect."document profile"::Service);
            Documentprofile::Rent:
                recRepSelect.SetRange("Document Profile", recRepSelect."document profile"::Rent);
        end;

        case DocumentKind of
            1:
                recRepSelect.SetRange("Document Functional Type", recRepSelect."document functional type"::Sale);
            2:
                recRepSelect.SetRange("Document Functional Type", recRepSelect."document functional type"::Purchase);
            3:
                recRepSelect.SetRange("Document Functional Type", recRepSelect."document functional type"::Service);
            4:
                recRepSelect.SetRange("Document Functional Type", recRepSelect."document functional type"::Rent);

        end;

        case DocumentType of
            0:
                recRepSelect.SetRange("Document Type", recRepSelect."document type"::Quote);
            1:
                recRepSelect.SetRange("Document Type", recRepSelect."document type"::Order);
            2:
                recRepSelect.SetRange("Document Type", recRepSelect."document type"::Invoice);
            3:
                recRepSelect.SetRange("Document Type", recRepSelect."document type"::"Credit Memo");
            4:
                recRepSelect.SetRange("Document Type", recRepSelect."document type"::"Blanket Order");
            5:
                recRepSelect.SetRange("Document Type", recRepSelect."document type"::"Return Order");
            6:
                recRepSelect.SetRange("Document Type", recRepSelect."document type"::Shipment);
            7:
                recRepSelect.SetRange("Document Type", recRepSelect."document type"::Transfer);
            8:
                recRepSelect.SetRange("Document Type", recRepSelect."document type"::"Posted Order");
            9:
                recRepSelect.SetRange("Document Type", recRepSelect."document type"::"Posted Invoice");
            10:
                recRepSelect.SetRange("Document Type", recRepSelect."document type"::"Posted Credit Memo");
            11:
                recRepSelect.SetRange("Document Type", recRepSelect."document type"::"Posted Return Order");
            12:
                recRepSelect.SetRange("Document Type", recRepSelect."document type"::"Posted Shipment");
            13:
                recRepSelect.SetRange("Document Type", recRepSelect."document type"::Contract);
            14:
                recRepSelect.SetRange("Document Type", recRepSelect."document type"::"Process Checklist");

        end;
    end;


    procedure ChooseExcelReport(DocumentProfile: Option ,"Spare Parts Trade","Vehicles Trade",Service; DocumentKind: Integer; DocumentType: Integer; var DataExchangeSelect: Record "Data Exch. Reports")
    begin
        DataExchangeSelect.Reset;
        case DocumentProfile of
            Documentprofile::"Vehicles Trade":
                DataExchangeSelect.SetRange("Document Profile", DataExchangeSelect."document profile"::"Vehicles Trade");
            Documentprofile::"Spare Parts Trade":
                DataExchangeSelect.SetRange("Document Profile", DataExchangeSelect."document profile"::"Spare Parts Trade");
            Documentprofile::Service:
                DataExchangeSelect.SetRange("Document Profile", DataExchangeSelect."document profile"::Service);
        end;

        case DocumentKind of
            0:
                DataExchangeSelect.SetRange("Document Functional Type", DataExchangeSelect."document functional type"::Sale);
            1:
                DataExchangeSelect.SetRange("Document Functional Type", DataExchangeSelect."document functional type"::Purchase);
            2:
                DataExchangeSelect.SetRange("Document Functional Type", DataExchangeSelect."document functional type"::Service);
        end;

        case DocumentType of
            0:
                DataExchangeSelect.SetRange("Document Type", DataExchangeSelect."document type"::Quote);
            1:
                DataExchangeSelect.SetRange("Document Type", DataExchangeSelect."document type"::Order);
            2:
                DataExchangeSelect.SetRange("Document Type", DataExchangeSelect."document type"::Invoice);
            3:
                DataExchangeSelect.SetRange("Document Type", DataExchangeSelect."document type"::"Credit Memo");
            4:
                DataExchangeSelect.SetRange("Document Type", DataExchangeSelect."document type"::"Blanket Order");
            5:
                DataExchangeSelect.SetRange("Document Type", DataExchangeSelect."document type"::"Return Order");
            6:
                DataExchangeSelect.SetRange("Document Type", DataExchangeSelect."document type"::Shipment);
            7:
                DataExchangeSelect.SetRange("Document Type", DataExchangeSelect."document type"::Transfer);
            8:
                DataExchangeSelect.SetRange("Document Type", DataExchangeSelect."document type"::"Posted Order");
            9:
                DataExchangeSelect.SetRange("Document Type", DataExchangeSelect."document type"::"Posted Invoice");
            10:
                DataExchangeSelect.SetRange("Document Type", DataExchangeSelect."document type"::"Posted Credit Memo");
            11:
                DataExchangeSelect.SetRange("Document Type", DataExchangeSelect."document type"::"Posted Return Order");
            12:
                DataExchangeSelect.SetRange("Document Type", DataExchangeSelect."document type"::"Posted Shipment");
        end;
    end;


    procedure ShowCustomerComments(CustomerNo: Code[20])
    var
        CommentLine: Record "Comment Line";
        Customer: Record Customer;
        Comment: Text[1000];
        i: Integer;
    begin
        CommentLine.Reset;
        CommentLine.SetRange("Table Name", CommentLine."table name"::Customer);
        CommentLine.SetRange("No.", CustomerNo);
        i := 0;
        Comment := '\';
        if CommentLine.FindFirst then begin
            repeat
                i += 1;
                if i < 4 then
                    Comment += '       ' + CommentLine.Comment + '\'
                else
                    Comment += '       ' + '...';
            until (CommentLine.Next = 0) or (i = 4);
        end
        else
            exit;
        Customer.Get(CustomerNo);
        if Comment <> '\' then
            Message(StrSubstNo(EDMS001, Customer.Name, Comment));
    end;


    procedure ShowVehicleComments(VehicleSerialNo: Code[20])
    var
        CommentLine: Record "Service Comment Line EDMS";
        Vehicle: Record Vehicle;
        Comment: Text[1000];
        i: Integer;
    begin
        CommentLine.Reset;
        CommentLine.SetRange(Type, CommentLine.Type::Vehicle);
        CommentLine.SetRange("No.", VehicleSerialNo);
        i := 0;
        Comment := '\';
        if CommentLine.FindFirst then begin
            repeat
                i += 1;
                if i < 4 then
                    Comment += '       ' + CommentLine.Comment + '\'
                else
                    Comment += '       ' + '...';
            until (CommentLine.Next = 0) or (i = 4);
        end
        else
            exit;
        Vehicle.Get(VehicleSerialNo);
        if Comment <> '\' then
            Message(StrSubstNo(EDMS002, Vehicle.VIN, Comment));
    end;


    procedure ServiceSplitLine(var ServLine: Record "Service Line EDMS"; LineQty: Integer): Integer
    var
        OldServLine: Record "Service Line EDMS";
        SplitQuantity: Decimal;
        SplitHours: Decimal;
        OldQuantity: Decimal;
        OldHours: Decimal;
        NewQuantity: Decimal;
        NewHours: Decimal;
        NewLineNo: Integer;
        CurrentLineNo: Integer;
        NextLineStep: Integer;
        LineQtyAtBegin: Integer;
    begin
        if LineQty < 2 then
            exit;
        LineQtyAtBegin := LineQty;
        ServLine.TestField(Type, ServLine.Type::Labor);

        OldServLine := ServLine;
        NewLineNo := ServLine."Line No.";

        OldQuantity := OldServLine.Quantity;
        OldHours := ServLine."Standard Time";
        NewQuantity := OldQuantity / LineQty;
        NewHours := OldHours / LineQty;

        NextLineStep := ServiceGetNewLineNo(ServLine, LineQty);

        ServLine.Get(OldServLine."Document Type", OldServLine."Document No.", OldServLine."Line No.");
        ServLine.Validate("Standard Time", NewHours);
        ServLine.Validate(Quantity, NewQuantity);
        ServLine.Split := true;
        ServLine.Modify;

        SplitQuantity := ServLine.Quantity;
        SplitHours := ServLine."Standard Time";

        repeat
            NewLineNo := NewLineNo + NextLineStep;
            ServLine."Line No." := NewLineNo;
            ServLine.Insert;
            if LineQty <> 2 then begin
                ServLine.Validate("Standard Time", NewHours);
                ServLine.Validate(Quantity, NewQuantity);
                SplitQuantity += ServLine.Quantity;
                SplitHours += ServLine."Standard Time";
            end else begin
                ServLine.Validate("Standard Time", OldHours - SplitHours);
                ServLine.Validate(Quantity, OldQuantity - SplitQuantity);
            end;
            ServLine.Modify;
            ServLine.Get(OldServLine."Document Type", OldServLine."Document No.", OldServLine."Line No.");
            //  ServiceCopyDimensions(ServLine, NewLineNo);//30.10.2012 EDMS
            LineQty -= 1;
        until LineQty = 1;
        ServiceScheduleMgt.AdjustAllocEntryByShare(OldServLine, ROUND(100 / LineQtyAtBegin));// P8

        exit(NewLineNo);
    end;


    procedure ServiceGetNewLineNo(ServLine: Record "Service Line EDMS"; LineQty: Integer): Integer
    var
        ServLine2: Record "Service Line EDMS";
        CurrentNo: Integer;
    begin
        CurrentNo := ServLine."Line No.";
        ServLine2.Reset;
        ServLine2.SetRange("Document Type", ServLine."Document Type");
        ServLine2.SetRange("Document No.", ServLine."Document No.");
        if ServLine2.FindFirst then
            repeat
                if ServLine2."Line No." = ServLine."Line No." then begin
                    if ServLine2.Next = 0 then
                        exit(10000)
                    else
                        exit(ROUND((ServLine2."Line No." - CurrentNo) / LineQty, 1))
                end;
            until ServLine2.Next = 0;
        exit(10000);
    end;


    procedure Color2Blue(Color: Integer): Integer
    begin
        if not (Color in [0 .. 16777215]) then
            Error(StrSubstNo(Text004 + Text009, Text008));

        exit(ROUND(Color / 65536, 1, '<'));
    end;


    procedure Color2Green(Color: Integer): Integer
    begin
        if not (Color in [0 .. 16777215]) then
            Error(StrSubstNo(Text004 + Text009, Text008));

        exit(ROUND((Color - Color2Blue(Color) * 65536) / 256, 1, '<'));
    end;


    procedure Color2Red(Color: Integer): Integer
    begin
        if not (Color in [0 .. 16777215]) then
            Error(StrSubstNo(Text004 + Text009, Text008));

        exit(ROUND(Color - Color2Blue(Color) * 65536 - Color2Green(Color) * 256, 1, '<'));
    end;


    procedure IsASCII(TextPar: Text[1024]; StartPos: Integer; EndPos: Integer) RetValue: Boolean
    var
        CurrPos: Integer;
    begin
        RetValue := true;
        if StartPos < EndPos then begin
            CurrPos := StartPos;
            repeat
                if TextPar[CurrPos] > 127 then
                    RetValue := false;
                CurrPos += 1;
            until CurrPos > EndPos;
        end;
        exit(RetValue);
    end;


    procedure WriteBigTextToFile(var TextPar: Text; LogFileName: Text[1024]): Boolean
    var
        LogFile: File;
        OutStream: OutStream;
        InStream: InStream;
        TextTmp: Text[1024];
        tempData: Codeunit "Temp Blob";
        BText: Text;
        CRLF: Text[2];
        CR: Char;
        LF: Char;
        TempBlob: Codeunit "Temp Blob";
    begin
        // returns either is written or not
        if not UserSetup.Get(UserId) then
            exit(false);

        if LogFileName = '' then
            exit(false);
        if UploadIntoStream('Import', '', '', LogFileName, InStream) then begin
            // if LogFile.Open(LogFileName) then begin
            TempBlob.CreateInstream(InStream);
            //InStream.ReadText(BText); /// Why in RTC it does not work?
            InStream.ReadText(BText);
            InStream.ReadText(TextTmp);
            // LogFile.Close;
        end;

        // if not LogFile.Create(LogFileName) then
        //     exit(false);
        TempBlob.CreateOutstream(OutStream);


        OutStream.WriteText(BText);
        CR := 13;
        CRLF := Format(CR);
        TextTmp := 'Log info at:' + Format(CurrentDatetime) + ':';
        OutStream.WriteText(TextTmp);
        OutStream.WriteText(CRLF);
        //OutStream.WriteText(TextPar);
        OutStream.WriteText(TextPar);
        OutStream.WriteText(CRLF);
        TempBlob.CreateInstream(InStream);
        if not DownloadFromStream(InStream, '', '', '', LogFileName) then
            exit(false);
        // LogFile.Close;

        exit(true);
    end;


    procedure IsWebClientSession(): Boolean
    var
        ActiveSession: Record "Active Session";
    begin
        ActiveSession.SetRange("User ID", UserId);
        ActiveSession.SetFilter("Session ID", Format(SessionId));
        ActiveSession.SetRange("Client Type", ActiveSession."client type"::"Web Client");
        if not ActiveSession.FindFirst then
            exit(false)
        else
            exit(true);
    end;


    procedure SaveServiceHeaderReportAsPdf(var TempBlob: Codeunit "Temp Blob"; var ServiceHeader: Record "Service Header EDMS"; ReportId: Integer): Text[250]
    var
        Out: OutStream;
        RecRef: RecordRef;
    begin
        TempBlob.CreateOutStream(Out);
        RecRef.GetTable(ServiceHeader);
        REPORT.SAVEAS(ReportId, '', REPORTFORMAT::Pdf, Out, RecRef);
        exit(StrSubstNo(ReportAsPdfFileNameMsg, 'Service Order', ServiceHeader."No.", GetTimeStampForFileName()));
    end;


    procedure SaveServiceLineReportAsPdf(var TempBlob: Codeunit "Temp Blob"; var ServiceLine: Record "Service Line EDMS"; ReportId: Integer): Text[250]
    var
        Out: OutStream;
        RecRef: RecordRef;
    begin
        TempBlob.CreateOutStream(Out);
        RecRef.GetTable(ServiceLine);
        REPORT.SAVEAS(ReportId, '', REPORTFORMAT::Pdf, Out, RecRef);
        exit(STRSUBSTNO('%1 %2 Line %3.Pdf', ServiceLine.TableCaption, ServiceLine."Document No.", ServiceLine."Line No."));
    end;

    procedure SaveSalesHeaderReportAsPdf(var TempBlob: Codeunit "Temp Blob"; var SalesHeader: Record "Sales Header"; ReportId: Integer): Text[250]
    var
        Out: OutStream;
        RecRef: RecordRef;
    begin
        TempBlob.CreateOutStream(Out);
        RecRef.GetTable(SalesHeader);
        REPORT.SAVEAS(ReportId, '', REPORTFORMAT::Pdf, Out, RecRef);
        exit(StrSubstNo(ReportAsPdfFileNameMsg, 'Service Order', SalesHeader."No.", GetTimeStampForFileName()));
    end;

    procedure SaveChecklistHeaderReportAsPdf(var TempBlob: Codeunit "Temp Blob"; var ChecklistHeader: Record "Process Checklist Header"; ReportId: Integer): Text[250]
    var
        Out: OutStream;
        RecRef: RecordRef;
    begin
        TempBlob.CreateOutStream(Out);
        RecRef.GetTable(ChecklistHeader);
        REPORT.SAVEAS(ReportId, '', REPORTFORMAT::Pdf, Out, RecRef);
        exit(StrSubstNo(ReportAsPdfFileNameMsg, 'Checklist Document', ChecklistHeader."No.", GetTimeStampForFileName()));
    end;

    procedure SaveRentTransferHeaderReportAsPdf(var TempBlob: Codeunit "Temp Blob"; var RentTransferHeader: Record "Rent Transfer Header"; ReportId: Integer): Text[250]
    var
        Out: OutStream;
        RecRef: RecordRef;
    begin
        TempBlob.CreateOutStream(Out);
        RecRef.GetTable(RentTransferHeader);
        REPORT.SAVEAS(ReportId, '', REPORTFORMAT::Pdf, Out, RecRef);
        exit(StrSubstNo(ReportAsPdfFileNameMsg, 'Rent Transfer Order', RentTransferHeader."No.", GetTimeStampForFileName()));
    end;

    procedure SavePostedRentTransferHeaderReportAsPdf(var TempBlob: Codeunit "Temp Blob"; var RentTransferHeader: Record "Posted Rent Transfer Header"; ReportId: Integer): Text[250]
    var
        Out: OutStream;
        RecRef: RecordRef;
    begin
        TempBlob.CreateOutStream(Out);
        RecRef.GetTable(RentTransferHeader);
        REPORT.SAVEAS(ReportId, '', REPORTFORMAT::Pdf, Out, RecRef);
        exit(StrSubstNo(ReportAsPdfFileNameMsg, 'Posted Rent Transfer Order', RentTransferHeader."No.", GetTimeStampForFileName()));
    end;

    procedure EmailServiceHeaderDocument(var ServiceHeader: Record "Service Header EDMS"; ReportID: Integer)
    var
        CustomReportSelection: Record "Custom Report Selection";
        AttachmentFileName: Text;
        Reportusage: enum "report selection usage";
        TempBlob: Codeunit "Temp Blob";
        AttachmentStream: Instream;
    begin

        TempBlob.CreateInStream(AttachmentStream);
        AttachmentFileName := SaveServiceHeaderReportAsPdf(TempBlob, ServiceHeader, ReportID);
        Commit;
        Reportusage := GetServDocTypeUsage(ServiceHeader);
        if SendToContact then
            //DocumentMailing.EmailFile(AttachmentStream, '', '', ServiceHeader."No.", GetToAddressFromContact(ServiceHeader."Sell-to Contact No."), ServiceHeader.GetServiceDocTypeTxt, false, Reportusage.AsInteger())
            DocumentMailing.EmailFile(AttachmentStream, AttachmentFileName, '', AttachmentFileName, GetToAddressFromContact(ServiceHeader."Sell-to Contact No."), False, enum::"Email Scenario"::Default)
        else
            DocumentMailing.EmailFile(AttachmentStream, AttachmentFileName, '', AttachmentFileName, GetToAddressFromContact(ServiceHeader."Sell-to Customer No."), False, enum::"Email Scenario"::Default);
        //DocumentMailing.EmailFile(AttachmentStream, '', '', ServiceHeader."No.", GetToAddressFromCustomer(ServiceHeader."Sell-to Customer No."), ServiceHeader.GetServiceDocTypeTxt, false, Reportusage.AsInteger());

    end;


    procedure EmailServiceLineDocument(var ServiceLine: Record "Service Line EDMS"; ReportID: Integer)
    var
        CustomReportSelection: Record "Custom Report Selection";
        AttachmentFileName: Text;
        ServiceHeader: Record "Service Header EDMS";
        TempBlob: Codeunit "Temp Blob";
        AttachmentStream: Instream;
    begin
        TempBlob.CreateInStream(AttachmentStream);
        AttachmentFileName := SaveServiceLineReportAsPdf(TempBlob, ServiceLine, ReportID);
        Commit;
        if SendToContact then begin
            ServiceHeader.Get(ServiceLine."Document Type", ServiceLine."Document No.");
            //DocumentMailing.EmailFile(AttachmentStream, '', '', ServiceLine."Document No.", GetToAddressFromContact(ServiceHeader."Sell-to Contact No."), Text010, false, CustomReportSelection.Usage::"S.Order")
            DocumentMailing.EmailFile(AttachmentStream, AttachmentFileName, '', AttachmentFileName, GetToAddressFromContact(ServiceHeader."Sell-to Contact No."), False, enum::"Email Scenario"::Default);
        end else
            DocumentMailing.EmailFile(AttachmentStream, AttachmentFileName, '', AttachmentFileName, GetToAddressFromContact(ServiceLine."Sell-to Customer No."), False, enum::"Email Scenario"::Default);
        //DocumentMailing.EmailFile(AttachmentStream, '', '', ServiceLine."Document No.", GetToAddressFromCustomer(ServiceLine."Sell-to Customer No."), Text010, false, CustomReportSelection.Usage::"S.Order");


    end;


    procedure SaveSalesHeaderReportAsPdf(var SalesHeader: Record "Sales Header"; ReportId: Integer): Text[250]
    var

        ServerAttachmentFilePath: Text;
        TempBlob_l: Codeunit "Temp Blob";
        Out: OutStream;
        Ins: InStream;
        RecRef: RecordRef;
        FileName: Text;
    begin
        TempBlob_l.CreateOutStream(Out);
        RecRef.GetTable(SalesHeader);
        REPORT.SAVEAS(ReportId, '', REPORTFORMAT::Pdf, Out, RecRef);

        FileName := STRSUBSTNO('%1 %2.Pdf', SalesHeader.TableCaption, SalesHeader."No.");
        CopyStream(Out, Ins);
        DownloadFromStream(Ins, '', '', '', FileName);
    end;


    procedure EmailSalesHeaderDocument(var SalesHeader: Record "Sales Header"; ReportID: Integer)
    var
        CustomReportSelection: Record "Custom Report Selection";
        AttachmentFileName: Text;
        Reportusage: enum "report selection usage";
        TempBlob: Codeunit "Temp Blob";
        AttachmentStream: Instream;
    begin
        TempBlob.CreateInStream(AttachmentStream);
        AttachmentFileName := SaveSalesHeaderReportAsPdf(SalesHeader, ReportID);
        Commit;

        //Reportusage := DocumentPrint.GetSalesDocTypeUsage(SalesHeader);
        //Function commenté par elva pas d''mpact
        //DocumentMailing.SetParameters(ReportID, SalesHeader."Location Code", SalesHeader."Deal Type Code");
        if SendToContact then
            DocumentMailing.EmailFile(AttachmentStream, AttachmentFileName, '', AttachmentFileName, GetToAddressFromContact(SalesHeader."Sell-to Contact No."), False, enum::"Email Scenario"::Default)
        //DocumentMailing.EmailFile(AttachmentStream, '', '', SalesHeader."No.", GetToAddressFromContact(SalesHeader."Sell-to Contact No."), SalesHeader.GetDocTypeTxt(), false, Reportusage.AsInteger())
        else
            DocumentMailing.EmailFile(AttachmentStream, AttachmentFileName, '', AttachmentFileName, GetToAddressFromContact(SalesHeader."Sell-to Customer No."), False, enum::"Email Scenario"::Default)
        //DocumentMailing.EmailFile(AttachmentStream, '', '', SalesHeader."No.", GetToAddressFromCustomer(SalesHeader."Sell-to Customer No."), SalesHeader.GetDocTypeTxt(), false, Reportusage.AsInteger());
    end;


    procedure SaveSalesLineReportAsPdf(var SalesLine: Record "Sales Line"; ReportId: Integer): Text[250]
    var

        ServerAttachmentFilePath: Text;
        TempBlob_l: Codeunit "Temp Blob";
        Out: OutStream;
        RecRef: RecordRef;
    begin
        TempBlob_l.CreateOutStream(Out);
        RecRef.GetTable(SalesLine);
        REPORT.SAVEAS(ReportId, '', REPORTFORMAT::Pdf, Out, RecRef);
        exit(FileManagement.BLOBExport(TempBlob_l, STRSUBSTNO('%1 %2 Line %3.Pdf', SalesLine.TableCaption, SalesLine."Document No.", SalesLine."Line No."), TRUE));

        // ServerAttachmentFilePath := FileManagement.ServerTempFileName('pdf');

        // Report.SaveAsPdf(ReportId, ServerAttachmentFilePath, SalesLine);
        // if not Exists(ServerAttachmentFilePath) then
        //     Error(ServerSaveAsPdfFailedErr);

        // exit(ServerAttachmentFilePath);
    end;


    procedure EmailSalesLineDocument(var SalesLine: Record "Sales Line"; ReportID: Integer)
    var
        CustomReportSelection: Record "Custom Report Selection";
        AttachmentFileName: Text;
        SalesHeader: Record "Sales Header";
        TempBlob: Codeunit "Temp Blob";
        AttachmentStream: Instream;
    begin
        TempBlob.CreateInStream(AttachmentStream);
        AttachmentFileName := SaveSalesLineReportAsPdf(SalesLine, ReportID);
        Commit;
        if SendToContact then begin
            SalesHeader.get(SalesLine."Document Type", SalesLine."Document No.");
            //DocumentMailing.EmailFile(AttachmentStream, '', '', SalesLine."Document No.", GetToAddressFromContact(SalesHeader."Sell-to Contact No."), Text010, false, CustomReportSelection.Usage::"S.Invoice")
            DocumentMailing.EmailFile(AttachmentStream, AttachmentFileName, '', AttachmentFileName, GetToAddressFromContact(SalesHeader."Sell-to Contact No."), False, enum::"Email Scenario"::Default)
        end else
            DocumentMailing.EmailFile(AttachmentStream, AttachmentFileName, '', AttachmentFileName, GetToAddressFromContact(SalesHeader."Sell-to Customer No."), False, enum::"Email Scenario"::Default)
        //DocumentMailing.EmailFile(AttachmentStream, '', '', SalesLine."Document No.", GetToAddressFromCustomer(SalesLine."Sell-to Customer No."), Text010, false, CustomReportSelection.Usage::"S.Invoice");
    end;


    procedure SavePurchaseLineReportAsPdf(var PurchaseLine: Record "Purchase Line"; ReportId: Integer): Text[250]
    var

        ServerAttachmentFilePath: Text;
        TempBlob_l: Codeunit "Temp Blob";
        Out: OutStream;
        RecRef: RecordRef;
    begin
        TempBlob_l.CreateOutStream(Out);
        RecRef.GetTable(PurchaseLine);
        REPORT.SAVEAS(ReportId, '', REPORTFORMAT::Pdf, Out, RecRef);
        exit(FileManagement.BLOBExport(TempBlob_l, STRSUBSTNO('%1 %2 Line %3.Pdf', PurchaseLine.TableCaption, PurchaseLine."Document No.", PurchaseLine."Line No."), TRUE));

        // ServerAttachmentFilePath := FileManagement.ServerTempFileName('pdf');

        // Report.SaveAsPdf(ReportId, ServerAttachmentFilePath, PurchaseLine);
        // if not Exists(ServerAttachmentFilePath) then
        //     Error(ServerSaveAsPdfFailedErr);

        // exit(ServerAttachmentFilePath);
    end;


    procedure EmailPurchaseLineDocument(var PurchaseLine: Record "Purchase Line"; ReportID: Integer)
    var
        CustomReportSelection: Record "Custom Report Selection";
        AttachmentFileName: Text;
        PurchaseHeader: Record "Purchase Header";
        TempBlob: Codeunit "Temp Blob";
        AttachmentStream: Instream;
    begin
        TempBlob.CreateInStream(AttachmentStream);
        AttachmentFileName := SavePurchaseLineReportAsPdf(PurchaseLine, ReportID);
        Commit;
        if SendToContact then begin
            PurchaseHeader.get(PurchaseLine."Document Type", PurchaseLine."Document No.");
            DocumentMailing.EmailFile(AttachmentStream, AttachmentFileName, '', AttachmentFileName, GetToAddressFromContact(PurchaseHeader."Buy-from Contact No."), False, enum::"Email Scenario"::Default);
            //EmailFileToContact(AttachmentFilePath, '', PurchaseLine."Document No.", PurchaseHeader."Buy-from Contact No.", StrSubstNo(Text012, Format(PurchaseLine."Document Type")), false, CustomReportSelection)
        end else
            DocumentMailing.EmailFile(AttachmentStream, AttachmentFileName, '', AttachmentFileName, GetToAddressFromContact(PurchaseLine."Buy-from Vendor No."), False, enum::"Email Scenario"::Default);
        //EmailFileToVendor(AttachmentFilePath, '', PurchaseLine."Document No.", PurchaseLine."Buy-from Vendor No.", StrSubstNo(Text012, Format(PurchaseLine."Document Type")), false, CustomReportSelection);
    end;


    procedure SavePurchaseHeaderReportAsPdf(var PurchaseHeader: Record "Purchase Header"; ReportId: Integer): Text[250]
    var

        ServerAttachmentFilePath: Text;
        TempBlob_l: Codeunit "Temp Blob";
        Out: OutStream;
        RecRef: RecordRef;
    begin
        TempBlob_l.CreateOutStream(Out);
        RecRef.GetTable(PurchaseHeader);
        REPORT.SAVEAS(ReportId, '', REPORTFORMAT::Pdf, Out, RecRef);
        exit(FileManagement.BLOBExport(TempBlob_l, STRSUBSTNO('%1 %2.Pdf', PurchaseHeader.TableCaption, PurchaseHeader."No."), TRUE));

        // ServerAttachmentFilePath := FileManagement.ServerTempFileName('pdf');

        // Report.SaveAsPdf(ReportId, ServerAttachmentFilePath, PurchaseHeader);
        // if not Exists(ServerAttachmentFilePath) then
        //     Error(ServerSaveAsPdfFailedErr);

        // exit(ServerAttachmentFilePath);
    end;


    procedure EmailPurchaseHeaderDocument(var PurchaseHeader: Record "Purchase Header"; ReportID: Integer)
    var
        CustomReportSelection: Record "Custom Report Selection";
        AttachmentFileName: Text;
        TempBlob: Codeunit "Temp Blob";
        AttachmentStream: Instream;
    begin
        AttachmentFileName := SavePurchaseHeaderReportAsPdf(PurchaseHeader, ReportID);
        Commit;
        //Function commenté par elva pas d''mpact
        //DocumentMailing.SetParameters(ReportID, PurchaseHeader."Location Code", PurchaseHeader."Deal Type Code");
        if SendToContact then begin
            //EmailFileToContact(AttachmentFilePath, '', PurchaseHeader."No.", PurchaseHeader."Buy-from Contact No.", StrSubstNo(Text012, Format(PurchaseHeader."Document Type")), false, CustomReportSelection)
            DocumentMailing.EmailFile(AttachmentStream, AttachmentFileName, '', AttachmentFileName, GetToAddressFromContact(PurchaseHeader."Buy-from Contact No."), False, enum::"Email Scenario"::Default)
        end else
            DocumentMailing.EmailFile(AttachmentStream, AttachmentFileName, '', AttachmentFileName, GetToAddressFromContact(PurchaseHeader."Buy-from Vendor No."), False, enum::"Email Scenario"::Default);
        //EmailFileToVendor(AttachmentFilePath, '', PurchaseHeader."No.", PurchaseHeader."Buy-from Vendor No.", StrSubstNo(Text012, Format(PurchaseHeader."Document Type")), false, CustomReportSelection);
    end;


    procedure EmailFileToVendor(AttachmentFilePath: Text[250]; AttachmentFileName: Text[250]; PostedDocNo: Code[20]; SendEmaillToVendNo: Code[20]; EmailDocName: Text[150]; HideDialog: Boolean; CustomReportSelection: Record "Custom Report Selection")
    var
        TempEmailItem: Record "Email Item" temporary;
        CompanyInformation: Record "Company Information";
        EmailScenario: Enum "Email Scenario";
        EmailMessage: Codeunit "Email Message";
        Email: Codeunit Email;
        TempBlob: Codeunit "Temp Blob";
        InStream: InStream;
        OutStream: OutStream;
        FileManagement: Codeunit "File Management";
        SendTo: Text;
        SubjectTxt: Text;

    begin
        if AttachmentFileName = '' then
            AttachmentFileName := StrSubstNo(ReportAsPdfFileNameMsg, EmailDocName, PostedDocNo);
        CompanyInformation.Get;
        if CustomReportSelection."Send To Email" <> '' then
            SendTo := CustomReportSelection."Send To Email"
        else
            SendTo := GetToAddressFromVendor(SendEmaillToVendNo);
        SubjectTxt :=
          StrSubstNo(
              EmailSubjectCapTxt,
              CompanyInformation.Name, EmailDocName, PostedDocNo);
        TempEmailItem.Subject := CopyStr(
            StrSubstNo(
              EmailSubjectCapTxt, CompanyInformation.Name, EmailDocName, PostedDocNo), 1,
            MaxStrLen(TempEmailItem.Subject));
        //TempEmailItem."Attachment File Path" := AttachmentFilePath;
        //TempEmailItem."Attachment Name" := AttachmentFileName;
        //Function commenté par elva pas d''impact
        //DocumentMailing.GetAttachment2(TempEmailItem);
        TempEmailItem.Send(HideDialog, EmailScenario::Default);
    end;

    procedure EmailFileToContact(AttachmentFilePath: Text[250]; AttachmentFileName: Text[250]; PostedDocNo: Code[20]; SendEmaillToContNo: Code[20]; EmailDocName: Text[150]; HideDialog: Boolean; CustomReportSelection: Record "Custom Report Selection")
    var
        TempEmailItem: Record "Email Item" temporary;
        CompanyInformation: Record "Company Information";
        EmailScenario: Enum "Email Scenario";
    begin
        if AttachmentFileName = '' then
            AttachmentFileName := StrSubstNo(ReportAsPdfFileNameMsg, EmailDocName, PostedDocNo);
        CompanyInformation.Get;
        if CustomReportSelection."Send To Email" <> '' then
            TempEmailItem."Send to" := CustomReportSelection."Send To Email"
        else
            TempEmailItem."Send to" := GetToAddressFromContact(SendEmaillToContNo);
        TempEmailItem.Subject := CopyStr(
            StrSubstNo(
              EmailSubjectCapTxt, CompanyInformation.Name, EmailDocName, PostedDocNo), 1,
            MaxStrLen(TempEmailItem.Subject));
        //TempEmailItem."Attachment File Path" := AttachmentFilePath;
        //TempEmailItem."Attachment Name" := AttachmentFileName;
        //Function commenté par elva pas d''impact
        //DocumentMailing.GetAttachment2(TempEmailItem);
        TempEmailItem.Send(HideDialog, EmailScenario::Default);
    end;

    local procedure GetToAddressFromCustomer(CustomerNo: Code[20]): Text[250]
    var
        Customer: Record Customer;
        ToAddress: Text;
    begin
        if Customer.Get(CustomerNo) then
            ToAddress := Customer."E-Mail";

        exit(ToAddress);
    end;

    local procedure GetToAddressFromVendor(VendorNo: Code[20]): Text[250]
    var
        Vendor: Record Vendor;
        ToAddress: Text;
    begin
        if Vendor.Get(VendorNo) then
            ToAddress := Vendor."E-Mail";

        exit(ToAddress);
    end;

    local procedure GetToAddressFromContact(ContactNo: Code[20]): Text[250]
    var
        Contact: Record Contact;
        ToAddress: Text;
    begin
        if Contact.Get(ContactNo) then
            ToAddress := Contact."E-Mail";

        exit(ToAddress);
    end;


    procedure EmailSalesInvoiceHeaderDocument(var SalesInvoiceHeader: Record "Sales Invoice Header"; ReportID: Integer)
    var
        CustomReportSelection: Record "Custom Report Selection";
        AttachmentFilePath: Text[250];
        TempBlob: Codeunit "Temp Blob";
        AttachmentStream: Instream;
    begin
        TempBlob.CreateInStream(AttachmentStream);
        AttachmentFilePath := SaveSalesInvoiceHeaderReportAsPdf(SalesInvoiceHeader, ReportID);
        Commit;
        //Function commenté par elva pas d''mpact
        //DocumentMailing.SetParameters(ReportID, SalesInvoiceHeader."Location Code", SalesInvoiceHeader."Deal Type Code");
        if SendToContact then
            DocumentMailing.EmailFile(AttachmentStream, '', '', SalesInvoiceHeader."No.", GetToAddressFromContact(SalesInvoiceHeader."Sell-to Contact No."), Text010, false, CustomReportSelection.Usage::"S.Invoice")
        else
            DocumentMailing.EmailFile(AttachmentStream, '', '', SalesInvoiceHeader."No.", GetToAddressFromCustomer(SalesInvoiceHeader."Sell-to Customer No."), Text010, false, CustomReportSelection.Usage::"S.Invoice");
    end;


    procedure SaveSalesInvoiceHeaderReportAsPdf(var SalesInvoiceHeader: Record "Sales Invoice Header"; ReportId: Integer): Text[250]
    var

        ServerAttachmentFilePath: Text;
        TempBlob_l: Codeunit "Temp Blob";
        Out: OutStream;
        RecRef: RecordRef;
    begin
        TempBlob_l.CreateOutStream(Out);
        RecRef.GetTable(SalesInvoiceHeader);
        REPORT.SAVEAS(ReportId, '', REPORTFORMAT::Pdf, Out, RecRef);
        exit(FileManagement.BLOBExport(TempBlob_l, STRSUBSTNO('%1 %2.Pdf', SalesInvoiceHeader.TableCaption, SalesInvoiceHeader."No."), TRUE));

        // ServerAttachmentFilePath := FileManagement.ServerTempFileName('pdf');

        // Report.SaveAsPdf(ReportId, ServerAttachmentFilePath, SalesInvoiceHeader);
        // if not Exists(ServerAttachmentFilePath) then
        //     Error(ServerSaveAsPdfFailedErr);

        // exit(ServerAttachmentFilePath);
    end;


    procedure SaveSalesCrMemoHeaderReportAsPdf(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; ReportId: Integer): Text[250]
    var

        ServerAttachmentFilePath: Text;
        TempBlob_l: Codeunit "Temp Blob";
        Out: OutStream;
        RecRef: RecordRef;
    begin
        TempBlob_l.CreateOutStream(Out);
        RecRef.GetTable(SalesCrMemoHeader);
        REPORT.SAVEAS(ReportId, '', REPORTFORMAT::Pdf, Out, RecRef);
        exit(FileManagement.BLOBExport(TempBlob_l, STRSUBSTNO('%1 %2.Pdf', SalesCrMemoHeader.TableCaption, SalesCrMemoHeader."No."), TRUE));

        // ServerAttachmentFilePath := FileManagement.ServerTempFileName('pdf');

        // Report.SaveAsPdf(ReportId, ServerAttachmentFilePath, SalesCrMemoHeader);
        // if not Exists(ServerAttachmentFilePath) then
        //     Error(ServerSaveAsPdfFailedErr);

        // exit(ServerAttachmentFilePath);
    end;


    procedure EmailSalesCrMemoHeaderDocument(var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; ReportID: Integer)
    var
        CustomReportSelection: Record "Custom Report Selection";
        AttachmentFilePath: Text[250];
        TempBlob: Codeunit "Temp Blob";
        AttachmentStream: Instream;
    begin
        TempBlob.CreateInStream(AttachmentStream);
        AttachmentFilePath := SaveSalesCrMemoHeaderReportAsPdf(SalesCrMemoHeader, ReportID);
        Commit;
        //Function commenté par elva pas d''mpact
        //DocumentMailing.SetParameters(ReportID, SalesCrMemoHeader."Location Code", SalesCrMemoHeader."Deal Type Code");
        if SendToContact then
            DocumentMailing.EmailFile(AttachmentStream, '', '', SalesCrMemoHeader."No.", GetToAddressFromContact(SalesCrMemoHeader."Sell-to Contact No."), Text010, false, CustomReportSelection.Usage::"S.Cr.Memo")
        else
            DocumentMailing.EmailFile(AttachmentStream, '', '', SalesCrMemoHeader."No.", GetToAddressFromCustomer(SalesCrMemoHeader."Sell-to Customer No."), Text010, false, CustomReportSelection.Usage::"S.Cr.Memo");
    end;


    procedure SaveSalesShipmentHeaderReportAsPdf(var SalesShipmentHeader: Record "Sales Shipment Header"; ReportId: Integer): Text[250]
    var

        ServerAttachmentFilePath: Text;
        TempBlob_l: Codeunit "Temp Blob";
        Out: OutStream;
        RecRef: RecordRef;
    begin
        TempBlob_l.CreateOutStream(Out);
        RecRef.GetTable(SalesShipmentHeader);
        REPORT.SAVEAS(ReportId, '', REPORTFORMAT::Pdf, Out, RecRef);
        exit(FileManagement.BLOBExport(TempBlob_l, STRSUBSTNO('%1 %2.Pdf', SalesShipmentHeader.TableCaption, SalesShipmentHeader."No."), TRUE));

        // ServerAttachmentFilePath := FileManagement.ServerTempFileName('pdf');

        // Report.SaveAsPdf(ReportId, ServerAttachmentFilePath, SalesShipmentHeader);
        // if not Exists(ServerAttachmentFilePath) then
        //     Error(ServerSaveAsPdfFailedErr);

        // exit(ServerAttachmentFilePath);
    end;


    procedure EmailSalesShipmentHeaderDocument(var SalesShipmentHeader: Record "Sales Shipment Header"; ReportID: Integer)
    var
        CustomReportSelection: Record "Custom Report Selection";
        AttachmentFilePath: Text[250];
        TempBlob: Codeunit "Temp Blob";
        AttachmentStream: Instream;
    begin
        TempBlob.CreateInStream(AttachmentStream);
        AttachmentFilePath := SaveSalesShipmentHeaderReportAsPdf(SalesShipmentHeader, ReportID);
        Commit;
        //Function commenté par elva pas d''mpact
        //DocumentMailing.SetParameters(ReportID, SalesShipmentHeader."Location Code", SalesShipmentHeader."Deal Type Code");
        if SendToContact then
            DocumentMailing.EmailFile(AttachmentStream, '', '', SalesShipmentHeader."No.", GetToAddressFromContact(SalesShipmentHeader."Sell-to Contact No."), Text010, false, CustomReportSelection.Usage::"S.Shipment")
        else
            DocumentMailing.EmailFile(AttachmentStream, '', '', SalesShipmentHeader."No.", GetToAddressFromCustomer(SalesShipmentHeader."Sell-to Customer No."), Text010, false, CustomReportSelection.Usage::"S.Shipment");
    end;


    procedure EmailSalesInvoiceLineDocument(var SalesInvoiceLine: Record "Sales Invoice Line"; ReportID: Integer)
    var
        CustomReportSelection: Record "Custom Report Selection";
        AttachmentFilePath: Text[250];
        SalesInvoiceHeader: Record "Sales Invoice Header";
        TempBlob: Codeunit "Temp Blob";
        AttachmentStream: Instream;
    begin
        TempBlob.CreateInStream(AttachmentStream);
        AttachmentFilePath := SaveSalesInvoiceLineReportAsPdf(SalesInvoiceLine, ReportID);
        Commit;
        if SendToContact then begin
            SalesInvoiceHeader.get(SalesInvoiceLine."Document No.");
            DocumentMailing.EmailFile(AttachmentStream, '', '', SalesInvoiceHeader."No.", GetToAddressFromContact(SalesInvoiceHeader."Sell-to Contact No."), Text010, false, CustomReportSelection.Usage::"S.Shipment")
        end else
            DocumentMailing.EmailFile(AttachmentStream, '', '', SalesInvoiceLine."Document No.", GetToAddressFromCustomer(SalesInvoiceLine."Sell-to Customer No."), Text010, false, CustomReportSelection.Usage::"S.Invoice");
    end;


    procedure SaveSalesInvoiceLineReportAsPdf(var SalesInvoiceLine: Record "Sales Invoice Line"; ReportId: Integer): Text[250]
    var

        ServerAttachmentFilePath: Text;
        TempBlob_l: Codeunit "Temp Blob";
        Out: OutStream;
        RecRef: RecordRef;
    begin
        TempBlob_l.CreateOutStream(Out);
        RecRef.GetTable(SalesInvoiceLine);
        REPORT.SAVEAS(ReportId, '', REPORTFORMAT::Pdf, Out, RecRef);
        exit(FileManagement.BLOBExport(TempBlob_l, STRSUBSTNO('%1 %2 Line %3.Pdf', SalesInvoiceLine.TableCaption, SalesInvoiceLine."Document No.", SalesInvoiceLine."Line No."), TRUE));

        // ServerAttachmentFilePath := FileManagement.ServerTempFileName('pdf');

        // Report.SaveAsPdf(ReportId, ServerAttachmentFilePath, SalesInvoiceLine);
        // if not Exists(ServerAttachmentFilePath) then
        //     Error(ServerSaveAsPdfFailedErr);

        // exit(ServerAttachmentFilePath);
    end;


    procedure SaveSalesCrMemoLineReportAsPdf(var SaleCreditMemoLine: Record "Sales Cr.Memo Line"; ReportId: Integer): Text[250]
    var

        ServerAttachmentFilePath: Text;
        TempBlob_l: Codeunit "Temp Blob";
        Out: OutStream;
        RecRef: RecordRef;
    begin
        TempBlob_l.CreateOutStream(Out);
        RecRef.GetTable(SaleCreditMemoLine);
        REPORT.SAVEAS(ReportId, '', REPORTFORMAT::Pdf, Out, RecRef);
        exit(FileManagement.BLOBExport(TempBlob_l, STRSUBSTNO('%1 %2 Line %3.Pdf', SaleCreditMemoLine.TableCaption, SaleCreditMemoLine."Document No.", SaleCreditMemoLine."Line No."), TRUE));

        // ServerAttachmentFilePath := FileManagement.ServerTempFileName('pdf');

        // Report.SaveAsPdf(ReportId, ServerAttachmentFilePath, SaleCreditMemoLine);
        // if not Exists(ServerAttachmentFilePath) then
        //     Error(ServerSaveAsPdfFailedErr);

        // exit(ServerAttachmentFilePath);
    end;


    procedure EmailSalesCrMemoLineDocument(var SaleCreditMemoLine: Record "Sales Cr.Memo Line"; ReportID: Integer)
    var
        CustomReportSelection: Record "Custom Report Selection";
        AttachmentFilePath: Text[250];
        SaleCreditMemoHeader: Record "Sales Cr.Memo Header";
        TempBlob: Codeunit "Temp Blob";
        AttachmentStream: Instream;
    begin
        TempBlob.CreateInStream(AttachmentStream);
        AttachmentFilePath := SaveSalesCrMemoLineReportAsPdf(SaleCreditMemoLine, ReportID);
        Commit;
        if SendToContact then begin
            SaleCreditMemoHeader.get(SaleCreditMemoLine."Document No.");
            DocumentMailing.EmailFile(AttachmentStream, '', '', SaleCreditMemoHeader."No.", GetToAddressFromContact(SaleCreditMemoHeader."Sell-to Contact No."), Text010, false, CustomReportSelection.Usage::"S.Shipment")
        end else
            DocumentMailing.EmailFile(AttachmentStream, '', '', SaleCreditMemoLine."Document No.", GetToAddressFromCustomer(SaleCreditMemoLine."Sell-to Customer No."), Text010, false, CustomReportSelection.Usage::"S.Cr.Memo");
    end;


    procedure SaveSalesShipmentLineReportAsPdf(var SalesShipmentLine: Record "Sales Shipment Line"; ReportId: Integer): Text[250]
    var

        ServerAttachmentFilePath: Text;
        TempBlob_l: Codeunit "Temp Blob";
        Out: OutStream;
        RecRef: RecordRef;
    begin
        TempBlob_l.CreateOutStream(Out);
        RecRef.GetTable(SalesShipmentLine);
        REPORT.SAVEAS(ReportId, '', REPORTFORMAT::Pdf, Out, RecRef);
        exit(FileManagement.BLOBExport(TempBlob_l, STRSUBSTNO('%1 %2 Line %3.Pdf', SalesShipmentLine.TableCaption, SalesShipmentLine."Document No.", SalesShipmentLine."Line No."), TRUE));

        // ServerAttachmentFilePath := FileManagement.ServerTempFileName('pdf');

        // Report.SaveAsPdf(ReportId, ServerAttachmentFilePath, SalesShipmentLine);
        // if not Exists(ServerAttachmentFilePath) then
        //     Error(ServerSaveAsPdfFailedErr);

        // exit(ServerAttachmentFilePath);
    end;


    procedure EmailSalesShipmentLineDocument(var SalesShipmentLine: Record "Sales Shipment Line"; ReportID: Integer)
    var
        CustomReportSelection: Record "Custom Report Selection";
        AttachmentFilePath: Text[250];
        SalesShipmentHeader: Record "Sales Shipment Header";
        TempBlob: Codeunit "Temp Blob";
        AttachmentStream: Instream;
    begin
        TempBlob.CreateInStream(AttachmentStream);
        AttachmentFilePath := SaveSalesShipmentLineReportAsPdf(SalesShipmentLine, ReportID);
        Commit;
        if SendToContact then begin
            SalesShipmentHeader.get(SalesShipmentLine."Document No.");
            DocumentMailing.EmailFile(AttachmentStream, '', '', SalesShipmentHeader."No.", GetToAddressFromContact(SalesShipmentHeader."Sell-to Contact No."), Text010, false, CustomReportSelection.Usage::"S.Shipment")
        end else
            DocumentMailing.EmailFile(AttachmentStream, '', '', SalesShipmentLine."Document No.", GetToAddressFromCustomer(SalesShipmentLine."Sell-to Customer No."), Text010, false, CustomReportSelection.Usage::"S.Shipment");
    end;


    procedure SavePurchaseInvoiceLineReportAsPdf(var PurchaseInvLine: Record "Purch. Inv. Line"; ReportId: Integer): Text[250]
    var

        ServerAttachmentFilePath: Text;
        TempBlob_l: Codeunit "Temp Blob";
        Out: OutStream;
        RecRef: RecordRef;
    begin
        TempBlob_l.CreateOutStream(Out);
        RecRef.GetTable(PurchaseInvLine);
        REPORT.SAVEAS(ReportId, '', REPORTFORMAT::Pdf, Out, RecRef);
        exit(FileManagement.BLOBExport(TempBlob_l, STRSUBSTNO('%1 %2 Line %3.Pdf', PurchaseInvLine.TableCaption, PurchaseInvLine."Document No.", PurchaseInvLine."Line No."), TRUE));

        // ServerAttachmentFilePath := FileManagement.ServerTempFileName('pdf');

        // Report.SaveAsPdf(ReportId, ServerAttachmentFilePath, PurchaseInvLine);
        // if not Exists(ServerAttachmentFilePath) then
        //     Error(ServerSaveAsPdfFailedErr);

        // exit(ServerAttachmentFilePath);
    end;


    procedure EmailPurchaseInvoiceLineDocument(var PurchaseInvLine: Record "Purch. Inv. Line"; ReportID: Integer)
    var
        CustomReportSelection: Record "Custom Report Selection";
        AttachmentFilePath: Text[250];
        PurchaseInvHeader: Record "Purch. Inv. Header";
    begin
        AttachmentFilePath := SavePurchaseInvoiceLineReportAsPdf(PurchaseInvLine, ReportID);
        Commit;
        if SendToContact then begin
            PurchaseInvHeader.get(PurchaseInvLine."Document No.");
            EmailFileToContact(AttachmentFilePath, '', PurchaseInvHeader."No.", PurchaseInvHeader."Buy-from Contact No.", Text022, false, CustomReportSelection)
        end else
            EmailFileToVendor(AttachmentFilePath, '', PurchaseInvLine."Document No.", PurchaseInvLine."Buy-from Vendor No.", Text022, false, CustomReportSelection);
    end;


    procedure SavePurchaseInvoiceHeaderReportAsPdf(var PurchaseInvHeader: Record "Purch. Inv. Header"; ReportId: Integer): Text[250]
    var

        ServerAttachmentFilePath: Text;
        TempBlob_l: Codeunit "Temp Blob";
        Out: OutStream;
        RecRef: RecordRef;
    begin
        TempBlob_l.CreateOutStream(Out);
        RecRef.GetTable(PurchaseInvHeader);
        REPORT.SAVEAS(ReportId, '', REPORTFORMAT::Pdf, Out, RecRef);
        exit(FileManagement.BLOBExport(TempBlob_l, STRSUBSTNO('%1 %2.Pdf', PurchaseInvHeader.TableCaption, PurchaseInvHeader."No."), TRUE));

        // ServerAttachmentFilePath := FileManagement.ServerTempFileName('pdf');

        // Report.SaveAsPdf(ReportId, ServerAttachmentFilePath, PurchaseInvHeader);
        // if not Exists(ServerAttachmentFilePath) then
        //     Error(ServerSaveAsPdfFailedErr);

        // exit(ServerAttachmentFilePath);
    end;


    procedure EmailPurchaseInvoiceHeaderDocument(var PurchaseInvHeader: Record "Purch. Inv. Header"; ReportID: Integer)
    var
        CustomReportSelection: Record "Custom Report Selection";
        AttachmentFilePath: Text[250];
    begin
        AttachmentFilePath := SavePurchaseInvoiceHeaderReportAsPdf(PurchaseInvHeader, ReportID);
        Commit;
        //Function commenté par elva pas d''mpact
        //DocumentMailing.SetParameters(ReportID, PurchaseInvHeader."Location Code", PurchaseInvHeader."Deal Type Code");
        if SendToContact then
            EmailFileToContact(AttachmentFilePath, '', PurchaseInvHeader."No.", PurchaseInvHeader."Buy-from Contact No.", Text022, false, CustomReportSelection)
        else
            EmailFileToVendor(AttachmentFilePath, '', PurchaseInvHeader."No.", PurchaseInvHeader."Buy-from Vendor No.", Text022, false, CustomReportSelection);
    end;


    procedure SavePurchaseCrMemoLineReportAsPdf(var PurchaseCrMemoLine: Record "Purch. Cr. Memo Line"; ReportId: Integer): Text[250]
    var

        ServerAttachmentFilePath: Text;
        TempBlob_l: Codeunit "Temp Blob";
        Out: OutStream;
        RecRef: RecordRef;
    begin
        TempBlob_l.CreateOutStream(Out);
        RecRef.GetTable(PurchaseCrMemoLine);
        REPORT.SAVEAS(ReportId, '', REPORTFORMAT::Pdf, Out, RecRef);
        exit(FileManagement.BLOBExport(TempBlob_l, STRSUBSTNO('%1 %2 Line %3.Pdf', PurchaseCrMemoLine.TableCaption, PurchaseCrMemoLine."Document No.", PurchaseCrMemoLine."Line No."), TRUE));

        // ServerAttachmentFilePath := FileManagement.ServerTempFileName('pdf');

        // Report.SaveAsPdf(ReportId, ServerAttachmentFilePath, PurchaseCrMemoLine);
        // if not Exists(ServerAttachmentFilePath) then
        //     Error(ServerSaveAsPdfFailedErr);

        // exit(ServerAttachmentFilePath);
    end;


    procedure EmailPurchaseCrMemoLineDocument(var PurchaseCrMemoLine: Record "Purch. Cr. Memo Line"; ReportID: Integer)
    var
        CustomReportSelection: Record "Custom Report Selection";
        AttachmentFilePath: Text[250];
        PurchaseCrMemoHeader: Record "Purch. Cr. Memo Hdr.";

    begin
        AttachmentFilePath := SavePurchaseCrMemoLineReportAsPdf(PurchaseCrMemoLine, ReportID);
        Commit;
        if SendToContact then begin
            PurchaseCrMemoHeader.get(PurchaseCrMemoLine."Document No.");
            EmailFileToContact(AttachmentFilePath, '', PurchaseCrMemoHeader."No.", PurchaseCrMemoHeader."Buy-from Contact No.", Text024, false, CustomReportSelection)
        end else
            EmailFileToVendor(AttachmentFilePath, '', PurchaseCrMemoLine."Document No.", PurchaseCrMemoLine."Buy-from Vendor No.", Text024, false, CustomReportSelection);
    end;


    procedure SavePurchaseCrMemoHeaderReportAsPdf(var PurchaseCrMemoHeader: Record "Purch. Cr. Memo Hdr."; ReportId: Integer): Text[250]
    var

        ServerAttachmentFilePath: Text;
        TempBlob_l: Codeunit "Temp Blob";
        Out: OutStream;
        RecRef: RecordRef;
    begin
        TempBlob_l.CreateOutStream(Out);
        RecRef.GetTable(PurchaseCrMemoHeader);
        REPORT.SAVEAS(ReportId, '', REPORTFORMAT::Pdf, Out, RecRef);
        exit(FileManagement.BLOBExport(TempBlob_l, STRSUBSTNO('%1 %2.Pdf', PurchaseCrMemoHeader.TableCaption, PurchaseCrMemoHeader."No."), TRUE));

        // ServerAttachmentFilePath := FileManagement.ServerTempFileName('pdf');

        // Report.SaveAsPdf(ReportId, ServerAttachmentFilePath, PurchaseCrMemoHeader);
        // if not Exists(ServerAttachmentFilePath) then
        //     Error(ServerSaveAsPdfFailedErr);

        // exit(ServerAttachmentFilePath);
    end;


    procedure EmailPurchaseCrMemoHeaderDocument(var PurchaseCrMemoHeader: Record "Purch. Cr. Memo Hdr."; ReportID: Integer)
    var
        CustomReportSelection: Record "Custom Report Selection";
        AttachmentFilePath: Text[250];
    begin
        AttachmentFilePath := SavePurchaseCrMemoHeaderReportAsPdf(PurchaseCrMemoHeader, ReportID);
        Commit;
        //DocumentMailing.SetParameters(ReportID, PurchaseCrMemoHeader."Location Code", PurchaseCrMemoHeader."Deal Type Code");
        if SendToContact then
            EmailFileToContact(AttachmentFilePath, '', PurchaseCrMemoHeader."No.", PurchaseCrMemoHeader."Buy-from Contact No.", Text024, false, CustomReportSelection)
        else
            EmailFileToVendor(AttachmentFilePath, '', PurchaseCrMemoHeader."No.", PurchaseCrMemoHeader."Buy-from Vendor No.", Text024, false, CustomReportSelection);
    end;


    procedure SavePurchaseReceiptLineReportAsPdf(var PurchaseReceiptLine: Record "Purch. Rcpt. Line"; ReportId: Integer): Text[250]
    var

        ServerAttachmentFilePath: Text;
        TempBlob_l: Codeunit "Temp Blob";
        Out: OutStream;
        RecRef: RecordRef;
    begin
        TempBlob_l.CreateOutStream(Out);
        RecRef.GetTable(PurchaseReceiptLine);
        REPORT.SAVEAS(ReportId, '', REPORTFORMAT::Pdf, Out, RecRef);
        exit(FileManagement.BLOBExport(TempBlob_l, STRSUBSTNO('%1 %2 Line %3.Pdf', PurchaseReceiptLine.TableCaption, PurchaseReceiptLine."Document No.", PurchaseReceiptLine."Line No."), TRUE));

        // ServerAttachmentFilePath := FileManagement.ServerTempFileName('pdf');

        // Report.SaveAsPdf(ReportId, ServerAttachmentFilePath, PurchaseReceiptLine);
        // if not Exists(ServerAttachmentFilePath) then
        //     Error(ServerSaveAsPdfFailedErr);

        // exit(ServerAttachmentFilePath);
    end;


    procedure EmailPurchaseReceiptLineDocument(var PurchaseReceiptLine: Record "Purch. Rcpt. Line"; ReportID: Integer)
    var
        CustomReportSelection: Record "Custom Report Selection";
        AttachmentFilePath: Text[250];
        PurchaseReceiptHeader: Record "Purch. Rcpt. Header";
    begin
        AttachmentFilePath := SavePurchaseReceiptLineReportAsPdf(PurchaseReceiptLine, ReportID);
        Commit;
        if SendToContact then begin
            PurchaseReceiptHeader.get(PurchaseReceiptLine."Document No.");
            EmailFileToContact(AttachmentFilePath, '', PurchaseReceiptHeader."No.", PurchaseReceiptHeader."Buy-from Contact No.", Text023, false, CustomReportSelection)
        end else
            EmailFileToVendor(AttachmentFilePath, '', PurchaseReceiptLine."Document No.", PurchaseReceiptLine."Buy-from Vendor No.", Text023, false, CustomReportSelection);
    end;


    procedure SavePurchaseReceiptHeaderReportAsPdf(var PurchaseReceiptHeader: Record "Purch. Rcpt. Header"; ReportId: Integer): Text[250]
    var

        ServerAttachmentFilePath: Text;
        TempBlob_l: Codeunit "Temp Blob";
        Out: OutStream;
        RecRef: RecordRef;
    begin
        TempBlob_l.CreateOutStream(Out);
        RecRef.GetTable(PurchaseReceiptHeader);
        REPORT.SAVEAS(ReportId, '', REPORTFORMAT::Pdf, Out, RecRef);
        exit(FileManagement.BLOBExport(TempBlob_l, STRSUBSTNO('%1 %2.Pdf', PurchaseReceiptHeader.TableCaption, PurchaseReceiptHeader."No."), TRUE));

        // ServerAttachmentFilePath := FileManagement.ServerTempFileName('pdf');

        // Report.SaveAsPdf(ReportId, ServerAttachmentFilePath, PurchaseReceiptHeader);
        // if not Exists(ServerAttachmentFilePath) then
        //     Error(ServerSaveAsPdfFailedErr);

        // exit(ServerAttachmentFilePath);
    end;


    procedure EmailPurchaseReceiptHeaderDocument(var PurchaseReceiptHeader: Record "Purch. Rcpt. Header"; ReportID: Integer)
    var
        CustomReportSelection: Record "Custom Report Selection";
        AttachmentFilePath: Text[250];
    begin
        AttachmentFilePath := SavePurchaseReceiptHeaderReportAsPdf(PurchaseReceiptHeader, ReportID);
        Commit;
        //Function commenté par elva pas d''mpact
        //DocumentMailing.SetParameters(ReportID, PurchaseReceiptHeader."Location Code", PurchaseReceiptHeader."Deal Type Code");
        if SendToContact then
            EmailFileToContact(AttachmentFilePath, '', PurchaseReceiptHeader."No.", PurchaseReceiptHeader."Buy-from Contact No.", Text023, false, CustomReportSelection)
        else
            EmailFileToVendor(AttachmentFilePath, '', PurchaseReceiptHeader."No.", PurchaseReceiptHeader."Buy-from Vendor No.", Text023, false, CustomReportSelection);
    end;


    procedure SaveReturnShipmentLineReportAsPdf(var ReturnShipmentLine: Record "Return Shipment Line"; ReportId: Integer): Text[250]
    var

        ServerAttachmentFilePath: Text;
        TempBlob_l: Codeunit "Temp Blob";
        Out: OutStream;
        RecRef: RecordRef;
    begin
        TempBlob_l.CreateOutStream(Out);
        RecRef.GetTable(ReturnShipmentLine);
        REPORT.SAVEAS(ReportId, '', REPORTFORMAT::Pdf, Out, RecRef);
        exit(FileManagement.BLOBExport(TempBlob_l, STRSUBSTNO('%1 %2 Line %3.Pdf', ReturnShipmentLine.TableCaption, ReturnShipmentLine."Document No.", ReturnShipmentLine."Line No."), TRUE));

        // ServerAttachmentFilePath := FileManagement.ServerTempFileName('pdf');

        // Report.SaveAsPdf(ReportId, ServerAttachmentFilePath, ReturnShipmentLine);
        // if not Exists(ServerAttachmentFilePath) then
        //     Error(ServerSaveAsPdfFailedErr);

        // exit(ServerAttachmentFilePath);
    end;


    procedure EmailReturnShipmentLineDocument(var ReturnShipmentLine: Record "Return Shipment Line"; ReportID: Integer)
    var
        CustomReportSelection: Record "Custom Report Selection";
        AttachmentFilePath: Text[250];
        ReturnShipmentHeader: Record "Return Shipment Header";
    begin
        AttachmentFilePath := SaveReturnShipmentLineReportAsPdf(ReturnShipmentLine, ReportID);
        Commit;
        if SendToContact then begin
            ReturnShipmentHeader.get(ReturnShipmentLine."Document No.");
            EmailFileToContact(AttachmentFilePath, '', ReturnShipmentHeader."No.", ReturnShipmentHeader."Buy-from Contact No.", Text025, false, CustomReportSelection)
        end else
            EmailFileToVendor(AttachmentFilePath, '', ReturnShipmentLine."Document No.", ReturnShipmentLine."Buy-from Vendor No.", Text025, false, CustomReportSelection);
    end;


    procedure SaveReturnShipmentHeaderReportAsPdf(var ReturnShipmentHeader: Record "Return Shipment Header"; ReportId: Integer): Text[250]
    var

        ServerAttachmentFilePath: Text;
        TempBlob_l: Codeunit "Temp Blob";
        Out: OutStream;
        RecRef: RecordRef;
    begin
        TempBlob_l.CreateOutStream(Out);
        RecRef.GetTable(ReturnShipmentHeader);
        REPORT.SAVEAS(ReportId, '', REPORTFORMAT::Pdf, Out, RecRef);
        exit(FileManagement.BLOBExport(TempBlob_l, STRSUBSTNO('%1 %2.Pdf', ReturnShipmentHeader.TableCaption, ReturnShipmentHeader."No."), TRUE));

        // ServerAttachmentFilePath := FileManagement.ServerTempFileName('pdf');

        // Report.SaveAsPdf(ReportId, ServerAttachmentFilePath, PurchaseReceiptHeader);
        // if not Exists(ServerAttachmentFilePath) then
        //     Error(ServerSaveAsPdfFailedErr);

        // exit(ServerAttachmentFilePath);
    end;


    procedure EmailReturnShipmentHeaderDocument(var ReturnShipmentHeader: Record "Return Shipment Header"; ReportID: Integer)
    var
        CustomReportSelection: Record "Custom Report Selection";
        AttachmentFilePath: Text[250];
    begin
        AttachmentFilePath := SaveReturnShipmentHeaderReportAsPdf(ReturnShipmentHeader, ReportID);
        Commit;
        //Function commenté par elva pas d''mpact
        //DocumentMailing.SetParameters(ReportID, ReturnShipmentHeader."Location Code", ReturnShipmentHeader."Deal Type Code");
        if SendToContact then
            EmailFileToContact(AttachmentFilePath, '', ReturnShipmentHeader."No.", ReturnShipmentHeader."Buy-from Contact No.", Text025, false, CustomReportSelection)
        else
            EmailFileToVendor(AttachmentFilePath, '', ReturnShipmentHeader."No.", ReturnShipmentHeader."Buy-from Vendor No.", Text025, false, CustomReportSelection);
    end;


    procedure EmailReturnReceiptHeaderDocument(var ReturnReceiptHeader: Record "Return Receipt Header"; ReportID: Integer)
    var
        CustomReportSelection: Record "Custom Report Selection";
        AttachmentFilePath: Text[250];
        TempBlob: Codeunit "Temp Blob";
        AttachmentStream: Instream;
    begin
        TempBlob.CreateInStream(AttachmentStream);
        AttachmentFilePath := SaveReturnReceiptHeaderReportAsPdf(ReturnReceiptHeader, ReportID);
        Commit;
        //Function commenté par elva pas d''mpact
        //DocumentMailing.SetParameters(ReportID, ReturnReceiptHeader."Location Code", ReturnReceiptHeader."Deal Type Code");
        if SendToContact then
            DocumentMailing.EmailFile(AttachmentStream, '', '', ReturnReceiptHeader."No.", GetToAddressFromContact(ReturnReceiptHeader."Sell-to Contact No."), Text026, false, CustomReportSelection.Usage::"S.Ret.Rcpt.")
        else
            DocumentMailing.EmailFile(AttachmentStream, '', '', ReturnReceiptHeader."No.", GetToAddressFromCustomer(ReturnReceiptHeader."Sell-to Customer No."), Text026, false, CustomReportSelection.Usage::"S.Ret.Rcpt.");
    end;


    procedure SaveReturnReceiptHeaderReportAsPdf(var ReturnReceiptHeader: Record "Return Receipt Header"; ReportId: Integer): Text[250]
    var

        ServerAttachmentFilePath: Text;
        TempBlob_l: Codeunit "Temp Blob";
        Out: OutStream;
        RecRef: RecordRef;
    begin
        TempBlob_l.CreateOutStream(Out);
        RecRef.GetTable(ReturnReceiptHeader);
        REPORT.SAVEAS(ReportId, '', REPORTFORMAT::Pdf, Out, RecRef);
        exit(FileManagement.BLOBExport(TempBlob_l, STRSUBSTNO('%1 %2.Pdf', ReturnReceiptHeader.TableCaption, ReturnReceiptHeader."No."), TRUE));

        // ServerAttachmentFilePath := FileManagement.ServerTempFileName('pdf');

        // Report.SaveAsPdf(ReportId, ServerAttachmentFilePath, ReturnReceiptHeader);
        // if not Exists(ServerAttachmentFilePath) then
        //     Error(ServerSaveAsPdfFailedErr);

        // exit(ServerAttachmentFilePath);
    end;


    procedure EmailReturnReceiptLineDocument(var ReturnReceiptLine: Record "Return Receipt Line"; ReportID: Integer)
    var
        CustomReportSelection: Record "Custom Report Selection";
        AttachmentFilePath: Text[250];
        ReturnReceiptHeader: Record "Return Receipt Header";
        TempBlob: Codeunit "Temp Blob";
        AttachmentStream: Instream;
    begin
        TempBlob.CreateInStream(AttachmentStream);
        AttachmentFilePath := SaveReturnReceiptLineReportAsPdf(ReturnReceiptLine, ReportID);
        Commit;
        if SendToContact then begin
            ReturnReceiptHeader.get(ReturnReceiptLine."Document No.");
            DocumentMailing.EmailFile(AttachmentStream, '', '', ReturnReceiptHeader."No.", GetToAddressFromContact(ReturnReceiptHeader."Sell-to Contact No."), Text026, false, CustomReportSelection.Usage::"S.Ret.Rcpt.")
        end else
            DocumentMailing.EmailFile(AttachmentStream, '', '', ReturnReceiptLine."Document No.", GetToAddressFromCustomer(ReturnReceiptLine."Sell-to Customer No."), Text026, false, CustomReportSelection.Usage::"S.Ret.Rcpt.");
    end;


    procedure SaveReturnReceiptLineReportAsPdf(var ReturnReceiptLine: Record "Return Receipt Line"; ReportId: Integer): Text[250]
    var

        ServerAttachmentFilePath: Text;
        TempBlob_l: Codeunit "Temp Blob";
        Out: OutStream;
        RecRef: RecordRef;
    begin
        TempBlob_l.CreateOutStream(Out);
        RecRef.GetTable(ReturnReceiptLine);
        REPORT.SAVEAS(ReportId, '', REPORTFORMAT::Pdf, Out, RecRef);
        exit(FileManagement.BLOBExport(TempBlob_l, STRSUBSTNO('%1 %2 Line %3.Pdf', ReturnReceiptLine.TableCaption, ReturnReceiptLine."Document No.", ReturnReceiptLine."Line No."), TRUE));

        // ServerAttachmentFilePath := FileManagement.ServerTempFileName('pdf');

        // Report.SaveAsPdf(ReportId, ServerAttachmentFilePath, ReturnReceiptLine);
        // if not Exists(ServerAttachmentFilePath) then
        //     Error(ServerSaveAsPdfFailedErr);

        // exit(ServerAttachmentFilePath);
    end;

    procedure CaptionClassTranslate_off(Language: Integer; CaptionExpr: Text[1024]): Text[1024]
    var
        Caption: Text[1024];
    begin
        //Caption := CaptionManagement.ResolveCaptionClass(Language, CaptionExpr);
        EXIT(Caption);
    end;

    procedure MakeDateFilter(var DateFilterText: Text): Integer
    var
        Position: Integer;
    begin
        //Position := TextManagement.MakeDateFilter(DateFilterText); //FIXME
        exit(Position);
    end;


    procedure SelectRentHeaderReport(var recRepSelect: Record "Document Report"; recRentHeader: Record "Rent Header"; SendAsEmail: Boolean)
    var
        intCount: Integer;
    begin
        recRentHeader.SetRange("No.", recRentHeader."No.");
        intCount := recRepSelect.Count;
        if intCount > 1 then begin
            if Page.RunModal(Page::"Document Reports-Selection", recRepSelect) = Action::LookupOK then begin
                if SendAsEmail then
                    EmailRentHeaderDocument(recRentHeader, recRepSelect."Report ID")
                else
                    Report.RunModal(recRepSelect."Report ID", true, false, recRentHeader);
            end;
        end else
            if intCount = 1 then begin
                recRepSelect.FindFirst;
                if SendAsEmail then
                    EmailRentHeaderDocument(recRentHeader, recRepSelect."Report ID")
                else
                    Report.RunModal(recRepSelect."Report ID", true, false, recRentHeader);
            end;
    end;


    procedure EmailRentHeaderDocument(var RentHeader: Record "Rent Header"; ReportID: Integer)
    var
        CustomReportSelection: Record "Custom Report Selection";
        AttachmentFilePath: Text[250];
        TempBlob: Codeunit "Temp Blob";
        AttachmentStream: Instream;
    begin
        TempBlob.CreateInStream(AttachmentStream);
        AttachmentFilePath := SaveRentHeaderReportAsPdf(RentHeader, ReportID);
        Commit;
        //Function commenté par elva pas d''mpact
        //DocumentMailing.SetParameters(ReportID, RentHeader."Location Code", '');
        if SendToContact then
            DocumentMailing.EmailFile(AttachmentStream, '', '', RentHeader."No.", GetToAddressFromContact(RentHeader."Sell-to Contact No."), Text027, false, 0)
        else
            DocumentMailing.EmailFile(AttachmentStream, '', '', RentHeader."No.", GetToAddressFromCustomer(RentHeader."Sell-to Customer No."), Text027, false, 0);
    end;


    procedure SaveRentHeaderReportAsPdf(var RentHeader: Record "Rent Header"; ReportId: Integer): Text[250]
    var

        ServerAttachmentFilePath: Text;
        TempBlob_l: Codeunit "Temp Blob";
        Out: OutStream;
        RecRef: RecordRef;
    begin
        TempBlob_l.CreateOutStream(Out);
        RecRef.GetTable(RentHeader);
        REPORT.SAVEAS(ReportId, '', REPORTFORMAT::Pdf, Out, RecRef);
        exit(FileManagement.BLOBExport(TempBlob_l, STRSUBSTNO('%1 %2.Pdf', RentHeader.TableCaption, RentHeader."No."), TRUE));

        // ServerAttachmentFilePath := FileManagement.ServerTempFileName('pdf');

        // Report.SaveAsPdf(ReportId, ServerAttachmentFilePath, RentHeader);
        // if not Exists(ServerAttachmentFilePath) then
        //     Error(ServerSaveAsPdfFailedErr);

        // exit(ServerAttachmentFilePath);
    end;


    procedure SelectRentTransferHeaderReport(var recRepSelect: Record "Document Report"; recRentTransferHeader: Record "Rent Transfer Header"; SendAsEmail: Boolean)
    var
        intCount: Integer;
    begin
        recRentTransferHeader.SetRange("No.", recRentTransferHeader."No.");
        intCount := recRepSelect.Count;
        if intCount > 1 then begin
            if Page.RunModal(Page::"Document Reports-Selection", recRepSelect) = Action::LookupOK then begin
                if SendAsEmail then
                    EmailRentTransferHeaderDocument(recRentTransferHeader, recRepSelect."Report ID")
                else
                    Report.RunModal(recRepSelect."Report ID", true, false, recRentTransferHeader);
            end;
        end else
            if intCount = 1 then begin
                recRepSelect.FindFirst;
                if SendAsEmail then
                    EmailRentTransferHeaderDocument(recRentTransferHeader, recRepSelect."Report ID")
                else
                    Report.RunModal(recRepSelect."Report ID", true, false, recRentTransferHeader);
            end;
    end;


    procedure SelectPostedRentTransferHeaderReport(var recRepSelect: Record "Document Report"; recRentTransferHeader: Record "Posted Rent Transfer Header"; SendAsEmail: Boolean)
    var
        intCount: Integer;
    begin
        recRentTransferHeader.SetRange("No.", recRentTransferHeader."No.");
        intCount := recRepSelect.Count;
        if intCount > 1 then begin
            if Page.RunModal(Page::"Document Reports-Selection", recRepSelect) = Action::LookupOK then begin
                if SendAsEmail then
                    EmailPostedRentTransferHeaderDocument(recRentTransferHeader, recRepSelect."Report ID")
                else
                    Report.RunModal(recRepSelect."Report ID", true, false, recRentTransferHeader);
            end;
        end else
            if intCount = 1 then begin
                recRepSelect.FindFirst;
                if SendAsEmail then
                    EmailPostedRentTransferHeaderDocument(recRentTransferHeader, recRepSelect."Report ID")
                else
                    Report.RunModal(recRepSelect."Report ID", true, false, recRentTransferHeader);
            end;
    end;


    procedure EmailRentTransferHeaderDocument(var RentTransferHeader: Record "Rent Transfer Header"; ReportID: Integer)
    var
        CustomReportSelection: Record "Custom Report Selection";
        AttachmentFilePath: Text[250];
        TempBlob: Codeunit "Temp Blob";
        AttachmentStream: Instream;
    begin
        /*
        TempBlob.CreateInStream(AttachmentStream);
        AttachmentFilePath := SaveRentTransferHeaderReportAsPdf(RentTransferHeader, ReportID);
        Commit;
        //Function commenté par elva pas d''mpact
        //DocumentMailing.SetParameters(ReportID, RentTransferHeader."Location Code", '');
        if SendToContact then
            DocumentMailing.EmailFile(AttachmentStream, '', '', RentTransferHeader."No.", GetToAddressFromContact(RentTransferHeader."Sell-to Contact No."), Text027, false, 0)
        else
            DocumentMailing.EmailFile(AttachmentStream, '', '', RentTransferHeader."No.", GetToAddressFromCustomer(RentTransferHeader."Sell-to Customer No."), Text027, false, 0);
            */
    end;


    procedure EmailPostedRentTransferHeaderDocument(var RentTransferHeader: Record "Posted Rent Transfer Header"; ReportID: Integer)
    var
        CustomReportSelection: Record "Custom Report Selection";
        AttachmentFilePath: Text[250];
        TempBlob: Codeunit "Temp Blob";
        AttachmentStream: Instream;
    begin
        /*
        TempBlob.CreateInStream(AttachmentStream);
        AttachmentFilePath := SavePostedRentTransferHeaderReportAsPdf(RentTransferHeader, ReportID);
        Commit;
        //Function commenté par elva pas d''mpact
        //DocumentMailing.SetParameters(ReportID, RentTransferHeader."Location Code", '');
        if SendToContact then
            DocumentMailing.EmailFile(AttachmentStream, '', '', RentTransferHeader."No.", GetToAddressFromContact(RentTransferHeader."Sell-to Contact No."), Text027, false, 0)
        else
            DocumentMailing.EmailFile(AttachmentStream, '', '', RentTransferHeader."No.", GetToAddressFromCustomer(RentTransferHeader."Sell-to Customer No."), Text027, false, 0);
            */
    end;




    procedure CreatePurchaseOrderForExternalService(var ServiceLine: Record "Service Line EDMS")
    var
        Customer: Record Customer;
        PurchSetup: Record "Purchases & Payables Setup";
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
        NoSeriesMgt: Codeunit "No. Series";
        ServiceHeader: record "Service Header EDMS";
        ExternalService: Record "External Service";
        PrchOrdCreate: Label 'Purchase Order Nr. %1 created.';
    begin
        if ServiceLine.Type <> ServiceLine.Type::"External Service" then exit;
        if not ExternalService.Get(ServiceLine."No.") then exit;
        if not ServiceHeader.get(ServiceLine."Document Type", ServiceLine."Document No.") then exit;
        ExternalService.TestField("Vendor No.");

        PurchaseHeader.Init();
        PurchaseHeader."Document Type" := PurchaseHeader."Document Type"::Order;
        PurchaseHeader.Insert(true);
        PurchaseHeader.TestField("Posting No. Series");
        //PurchaseHeader."Posting No." := NoSeriesMgt.GetNextNo(PurchaseHeader."Posting No. Series", PurchaseHeader."Posting Date", true);
        //PurchaseHeader."Auto Created Doc" := true;

        PurchaseHeader."Document Date" := ServiceHeader."Document Date";
        PurchaseHeader."Document Profile" := PurchaseHeader."document profile"::Service;
        PurchaseHeader.Validate("Location Code", ServiceHeader."Location Code");
        PurchaseHeader.Validate("Payment Method Code", ServiceHeader."Payment Method Code");
        PurchaseHeader.Validate("Buy-from Vendor No.", ExternalService."Vendor No.");
        PurchaseHeader."Prices Including VAT" := ServiceHeader."Prices Including VAT";

        PurchaseHeader."Vehicle Serial No." := ServiceHeader."Vehicle Serial No.";
        PurchaseHeader."Vehicle Accounting Cycle No." := ServiceHeader."Vehicle Accounting Cycle No.";

        //if Customer."Item Charge Invoice Deal Type" <> '' then
        //   Validate("Deal Type Code", Customer."Item Charge Invoice Deal Type");
        // VALIDATE("Dimension Set ID", SalesHeader."Dimension Set ID");  //03.11.2014 EB.P8 #Exxx EDMS

        PurchaseHeader.Modify;

        PurchaseLine.Init();
        PurchaseLine."Document Type" := PurchaseHeader."Document Type";
        PurchaseLine."Document No." := PurchaseHeader."No.";
        PurchaseLine."Line No." := 1000;
        PurchaseLine.Type := PurchaseLine.Type::"External Service";
        PurchaseLine.Validate("No.", ServiceLine."No.");
        PurchaseLine.Validate(Quantity, ServiceLine.Quantity);
        PurchaseLine.Validate("Unit of Measure", ServiceLine."Unit of Measure");
        PurchaseLine.Validate("External Serv. Tracking No.", ServiceLine."External Serv. Tracking No.");
        PurchaseLine.Insert(true);

        Message(PrchOrdCreate, PurchaseHeader."No.");
    end;

    procedure CreateContractFromSalesOrder(var SalesOrder: Record "Sales Header")
    var
        DMSContract: Record Contract;
        DMSContractVehicle: Record "Contract Vehicle";
        SalesOrderLines: Record "Sales Line";
        Vehicle: Record Vehicle;
        OptionNumber: Integer;
    begin
        if SalesOrder."Contract No." <> '' then
            if not Confirm(Text030) then
                exit;

        OptionNumber := StrMenu(Text029);
        if OptionNumber = 0 then
            exit;

        DMSContract.Init();
        if OptionNumber = 1 then
            DMSContract.Validate("Bill-to Customer No.", SalesOrder."Sell-to Customer No.");
        if OptionNumber = 2 then
            DMSContract.Validate("Bill-to Customer No.", SalesOrder."Bill-to Customer No.");
        DMSContract."Salesperson Code" := SalesOrder."Salesperson Code";
        DMSContract.Status := DMSContract.Status::Inactive;
        DMSContract.Insert(true);

        SalesOrderLines.Reset();
        SalesOrderLines.SetRange("Document Type", SalesOrder."Document Type");
        SalesOrderLines.SetRange("Document No.", SalesOrder."No.");
        SalesOrderLines.SetRange("Line Type", SalesOrderLines."Line Type"::Vehicle);
        if SalesOrderLines.FindFirst() then
            repeat
                if SalesOrderLines."Vehicle Serial No." <> '' then begin
                    IF Vehicle.Get(SalesOrderLines."Vehicle Serial No.") then begin
                        DMSContractVehicle.Init();
                        DMSContractVehicle."Contract No." := DMSContract."Contract No.";
                        DMSContractVehicle.Validate("Vehicle Serial No.", SalesOrderLines."Vehicle Serial No.");
                        DMSContractVehicle.Insert(true);
                    end else begin
                        Error(Text028, SalesOrderLines."Line No.");
                    end;
                end;

            Until SalesOrderLines.Next = 0;

        DMSContract."Starting Date" := SalesOrder."Document Date";
        DMSContract.Status := DMSContract.Status::Active;
        DMSContract.Modify;

        if SalesOrder."Contract No." = '' then begin
            SalesOrder."Contract No." := DMSContract."Contract No.";
            SalesOrder.Modify();
        end;
    end;

    procedure CreateContractFromRentOrder(var RentOrder: Record "Rent Header")
    var
        DMSContract: Record Contract;
        DMSContractVehicle: Record "Contract Vehicle";
        RentOrderLines: Record "Rent Line";
        Vehicle: Record Vehicle;
        OptionNumber: Integer;
    begin
        if RentOrder."Contract No." <> '' then
            if not Confirm(Text030) then
                exit;

        OptionNumber := StrMenu(Text029);
        if OptionNumber = 0 then
            exit;

        DMSContract.Init();
        if OptionNumber = 1 then
            DMSContract.Validate("Bill-to Customer No.", RentOrder."Sell-to Customer No.");
        if OptionNumber = 2 then
            DMSContract.Validate("Bill-to Customer No.", RentOrder."Bill-to Customer No.");
        DMSContract."Salesperson Code" := RentOrder."Salesperson Code";
        DMSContract.Status := DMSContract.Status::Inactive;
        DMSContract.Insert(true);

        RentOrderLines.Reset();
        RentOrderLines.SetRange("Document Type", RentOrder."Document Type");
        RentOrderLines.SetRange("Document No.", RentOrder."No.");
        if RentOrderLines.FindFirst() then
            repeat
                if RentOrderLines."Vehicle Serial No." <> '' then begin
                    IF Vehicle.Get(RentOrderLines."Vehicle Serial No.") then begin
                        DMSContractVehicle.Init();
                        DMSContractVehicle."Contract No." := DMSContract."Contract No.";
                        DMSContractVehicle.Validate("Vehicle Serial No.", RentOrderLines."Vehicle Serial No.");
                        DMSContractVehicle.Validate("Rent Asset No.", RentOrderLines."Rent Asset No.");
                        DMSContractVehicle.Insert(true);
                    end else begin
                        Error(Text034, RentOrderLines."Line No.");
                    end;
                end;

            Until RentOrderLines.Next = 0;

        DMSContract."Starting Date" := RentOrder."Document Date";
        DMSContract.Status := DMSContract.Status::Active;
        DMSContract.Modify;

        if RentOrder."Contract No." = '' then begin
            RentOrder."Contract No." := DMSContract."Contract No.";
            RentOrder.Modify();
        end;
    end;

    procedure CreateRentOrderFromContract(var Contract: Record Contract)
    var
        RentOrder: Record "Rent Header";
        RentOrderCheck: Record "Rent Header";
        RentLine: Record "Rent Line";
        DMSContractVehicle: Record "Contract Vehicle";
        RentItemRelation: Record "Rent Item Relation";
        SalesOrderLines: Record "Sales Line";
        Vehicle: Record Vehicle;
        OptionNumber: Integer;
        OpenPage: Boolean;
        RentOrderPage: Page "Rent Order";
        LineNo: Integer;
    begin
        if Contract.Status <> Contract.Status::Active then
            Error(Text031);

        RentOrderCheck.Reset();
        RentOrderCheck.SetRange("Contract No.", Contract."Contract No.");
        if RentOrderCheck.FindFirst then
            if not Confirm(Text035) then
                exit;

        RentOrder.Reset();
        RentOrder.Init();
        RentOrder."Document Type" := RentOrder."Document Type"::Order;
        RentOrder.Insert(true);
        RentOrder.Validate("Sell-to Customer No.", Contract."Bill-to Customer No.");
        RentOrder.Validate("Contract No.", Contract."Contract No.");
        RentOrder.Validate("Shipment Date", Today);
        if Contract."Payment Terms Code" <> '' then
            RentOrder."Payment Terms Code" := Contract."Payment Terms Code";
        RentOrder.Modify;

        DMSContractVehicle.Reset();
        DMSContractVehicle.SetRange("Contract No.", Contract."Contract No.");
        DMSContractVehicle.SetFilter("Vehicle Serial No.", '<>%1', '');
        DMSContractVehicle.SetFilter("Rent Asset No.", '<>%1', '');
        IF DMSContractVehicle.FindFirst then
            repeat
                RentItemRelation.Reset();
                RentItemRelation.SetRange("Rent Asset No.", DMSContractVehicle."Rent Asset No.");
                if RentItemRelation.FindFirst then begin
                    RentLine.Init();
                    LineNo := LineNo + 10000;
                    RentLine."Document Type" := RentOrder."Document Type";
                    RentLine."Document No." := RentOrder."No.";
                    RentLine."Line No." := LineNo;
                    RentLine.Insert(true);
                    RentLine.Validate("Rent Item No.", RentItemRelation."Rent Item No.");
                    If RentLine."Rent Asset No." <> DMSContractVehicle."Rent Asset No." then
                        RentLine.Validate("Rent Asset No.", DMSContractVehicle."Rent Asset No.");
                    RentLine.Modify;
                end;
            Until DMSContractVehicle.Next = 0;

        //Message(Text032, RentOrder."No.");
        if GuiAllowed then
            OpenPage := Confirm(StrSubstNo(OpenRentOrderQst, RentOrder."No."), true);
        if OpenPage then begin
            Clear(RentOrderPage);
            RentOrder.SetRecfilter;
            RentOrderPage.SetTableview(RentOrder);
            RentOrderPage.Run;
        end;
    end;

    procedure CreateServiceOrderFromContract(var Contract: Record Contract)
    var
        ServiceOrder: Record "Service Header EDMS";
        DMSContractVehicle: Record "Contract Vehicle";
        DMSContractVehiclePage: Page "Contract Vehicles";
        Vehicle: Record Vehicle;
        OptionNumber: Integer;
        VehicleNo: Code[20];
    begin
        if Contract.Status <> Contract.Status::Active then
            Error(Text031);

        DMSContractVehicle.Reset;
        DMSContractVehicle.SetRange("Contract No.", Contract."Contract No.");
        if DMSContractVehicle.FindFirst then
            repeat
                DMSContractVehicle.Mark := true;
            until DMSContractVehicle.Next = 0;

        DMSContractVehicle.MarkedOnly(true);

        DMSContractVehiclePage.SetTableview(DMSContractVehicle);
        DMSContractVehiclePage.SetRecord(DMSContractVehicle);
        DMSContractVehiclePage.LookupMode(true);
        if DMSContractVehiclePage.RunModal = Action::LookupOK then begin
            DMSContractVehiclePage.GetRecord(DMSContractVehicle);
            VehicleNo := DMSContractVehicle."Vehicle Serial No.";
        end;

        ServiceOrder.Init();
        ServiceOrder."Document Type" := ServiceOrder."Document Type"::Order;
        ServiceOrder.Insert(true);

        ServiceOrder.Validate("Sell-to Customer No.", Contract."Bill-to Customer No.");
        ServiceOrder."Contract No." := Contract."Contract No.";
        ServiceOrder.Validate("Vehicle Serial No.", VehicleNo);


        ServiceOrder.Modify;

        Message(Text033, ServiceOrder."No.");
    end;

    procedure GetSelectionFilterForServicePackage(var ServicePackage: Record "Service Package"): Text
    var
        RecRef: RecordRef;
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
    begin
        RecRef.GetTable(ServicePackage);
        exit(SelectionFilterManagement.GetSelectionFilter(RecRef, ServicePackage.FieldNo("No.")));
    end;

    procedure ServToSalesLineType(LineType: Option): Integer
    var
        FromServiceLine: Record "Service Line EDMS";
        ToSalesLine: Record "Sales Line";
    begin
        case LineType of
            FromServiceLine.Type::Comment:
                exit(ToSalesLine.Type::" ");
            FromServiceLine.Type::"External Service":
                exit(ToSalesLine.Type::"External Service");
            FromServiceLine.Type::"G/L Account":
                exit(ToSalesLine.Type::"G/L Account");
            FromServiceLine.Type::Item:
                exit(ToSalesLine.Type::Item);
        end;
    end;

    procedure CopyServQuoteToSalesQuote(var ToSalesHeader: Record "Sales Header"; FromDocNo: Code[20]) AllLinesCopied: Boolean
    var
        LineNo: Integer;
        FromServiceHeader: Record "Service Header EDMS";
        Cust: Record Customer;
        GLSetUp: Record "General Ledger Setup";
        ToSalesLine: Record "Sales Line";
        Resources: Text[250];
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        FromServiceLine: Record "Service Line EDMS";
        Text000: Label 'Please enter a Document No.';
        OpenPage: Boolean;
        SalesQuote: page "Sales Quote";
    begin
        if FromDocNo = '' then
            Error(Text000);


        if FromServiceHeader.Get(FromServiceHeader."document type"::Quote, FromDocNo) then begin

            if not ToSalesHeader.RECORDLEVELLOCKING then
                ToSalesHeader.LockTable(true, true);


            if Cust.Get(FromServiceHeader."Sell-to Customer No.") then
                Cust.CheckBlockedCustOnDocs(Cust, ToSalesHeader."Document Type", false, false);
            if Cust.Get(FromServiceHeader."Bill-to Customer No.") then
                Cust.CheckBlockedCustOnDocs(Cust, ToSalesHeader."Document Type", false, false);

            ServiceSetup.Get;
            ServiceSetup.TestField("Order Nos.");
            Clear(ToSalesHeader);
            ToSalesHeader.Init;
            ToSalesHeader."Document Type" := ToSalesHeader."document type"::Quote;
            ToSalesHeader."No." := '';
            ToSalesHeader."Posting Date" := 0D; //FromSalesHeader."Posting Date";
            ToSalesHeader."Document Profile" := ToSalesHeader."document profile"::"Spare Parts Trade";
            ToSalesHeader.Insert(true);

            ToSalesHeader.SetHideValidationDialog(true);

            ToSalesHeader.Validate("Sell-to Customer No.", FromServiceHeader."Sell-to Customer No.");
            ToSalesHeader.Validate("Bill-to Customer No.", FromServiceHeader."Bill-to Customer No.");
            ToSalesHeader.Validate("Vehicle Serial No.", FromServiceHeader."Vehicle Serial No.");

            ToSalesHeader.Validate("Deal Type Code", FromServiceHeader."Deal Type");
            ToSalesHeader.Validate("Salesperson Code", FromServiceHeader."Service Advisor");
            ToSalesHeader.Validate("Location Code", FromServiceHeader."Location Code");

            ToSalesHeader."Dimension Set ID" := FromServiceHeader."Dimension Set ID";
            ToSalesHeader."Shortcut Dimension 1 Code" := FromServiceHeader."Shortcut Dimension 1 Code";
            ToSalesHeader."Shortcut Dimension 2 Code" := FromServiceHeader."Shortcut Dimension 2 Code";

            ToSalesHeader.Modify;


            ToSalesLine.LockTable;


            FromServiceLine.Reset;
            FromServiceLine.SetRange("Document Type", FromServiceLine."document type"::Quote);
            FromServiceLine.SetRange("Document No.", FromServiceHeader."No.");
            FromServiceLine.SetFilter(Type, '%1|%2|%3|%4', FromServiceLine.Type::Item, FromServiceLine.Type::Comment, FromServiceLine.Type::"External Service", FromServiceLine.Type::"G/L Account");

            if FromServiceLine.FindFirst then
                repeat
                    LineNo := LineNo + 10000;
                    ToSalesLine.Init;
                    ToSalesLine."Document Type" := ToSalesHeader."Document Type";
                    ToSalesLine."Document No." := ToSalesHeader."No.";
                    ToSalesLine."Line No." := LineNo;
                    ToSalesLine.Insert(true);

                    ToSalesLine.Type := ServToSalesLineType(FromServiceLine.Type);
                    ToSalesLine.Validate("No.", FromServiceLine."No.");
                    ToSalesLine.Validate("Location Code", FromServiceLine."Location Code");



                    if ToSalesLine.Type <> ToSalesLine.Type::" " then begin
                        ToSalesLine.Validate("Unit of Measure Code", FromServiceLine."Unit of Measure Code");
                        ToSalesLine.Validate(Quantity, FromServiceLine.Quantity);
                        ToSalesLine.Validate("Unit Cost", FromServiceLine."Unit Cost");
                        ToSalesLine.Validate("Unit Price", FromServiceLine."Unit Price");
                        ToSalesLine.Validate("Line Discount %", FromServiceLine."Line Discount %");
                        // ToSalesLine.VALIDATE("Line Discount Amount",FromServiceLine."Line Discount Amount");
                    end;

                    ToSalesLine.Description := FromServiceLine.Description;
                    ToSalesLine."Description 2" := FromServiceLine."Description 2";

                    if ToSalesLine.Type <> ToSalesLine.Type::" " then begin
                        ToSalesLine.Validate("Unit Price", FromServiceLine."Unit Price");
                    end;

                    ToSalesLine."Dimension Set ID" := FromServiceLine."Dimension Set ID";
                    ToSalesLine."Shortcut Dimension 1 Code" := FromServiceLine."Shortcut Dimension 1 Code";
                    ToSalesLine."Shortcut Dimension 2 Code" := FromServiceLine."Shortcut Dimension 2 Code";

                    ToSalesLine.Modify;

                until FromServiceLine.Next = 0;
            Commit;
            if GuiAllowed then
                OpenPage := Confirm(StrSubstNo(Text036, Format(ToSalesHeader."Document Type"), Format(ToSalesHeader."No.")), true);
            if OpenPage then begin
                Clear(SalesQuote);
                //SalesQuote.CheckNotificationsOnce;
                ToSalesHeader.SetRecfilter;
                SalesQuote.SetTableview(ToSalesHeader);
                SalesQuote.Run;
            end;
            //Message(Text036, Format("Document Type"), Format("No."));
        end;
    end;

    procedure LogDocumentEDMS(DocumentType: Integer; DocumentNo: Code[20]; DocNoOccurrence: Integer; VersionNo: Integer; AccountTableNo: Integer; AccountNo: Code[20]; SalespersonCode: Code[10]; CampaignNo: Code[20]; Description: Text[50]; OpportunityNo: Code[20]; VehicleSerialNo: Code[20])
    var
        InteractTmpl: Record "Interaction Template";
        TempSegmentLine: Record "Segment Line" temporary;
        ContBusRel: Record "Contact Business Relation";
        Attachment: Record Attachment;
        Cont: Record Contact;
        InteractTmplLanguage: Record "Interaction Tmpl. Language";
        InterLogEntryCommentLine: Record "Inter. Log Entry Comment Line" temporary;
        InteractTmplCode: Code[10];
        ContNo: Code[20];
        SegManagement: Codeunit SegManagement;
        Text003: Label 'Interaction Template %1 has assigned Interaction Template Language %2.\It is not allowed to have languages assigned to templates used for system document logging.';

    begin
        InteractTmplCode := SegManagement.FindInteractionTemplateCode(DocumentType);
        if InteractTmplCode = '' then
            exit;

        InteractTmpl.Get(InteractTmplCode);

        InteractTmplLanguage.SetRange("Interaction Template Code", InteractTmplCode);
        if InteractTmplLanguage.FindFirst then
            Error(Text003, InteractTmplCode, InteractTmplLanguage."Language Code");

        if Description = '' then
            Description := InteractTmpl.Description;

        case AccountTableNo of
            Database::Customer:
                begin
                    ContNo := FindContactFromContBusRelation(ContBusRel."link to table"::Customer, AccountNo);
                    if ContNo = '' then
                        exit;
                end;
            Database::Vendor:
                begin
                    ContNo := FindContactFromContBusRelation(ContBusRel."link to table"::Vendor, AccountNo);
                    if ContNo = '' then
                        exit;
                end;
            Database::Contact:
                begin
                    if not Cont.Get(AccountNo) then
                        exit;
                    if SalespersonCode = '' then
                        SalespersonCode := Cont."Salesperson Code";
                    ContNo := AccountNo;
                end;
        end;

        TempSegmentLine.Init;
        TempSegmentLine."Document Type" := DocumentType;
        TempSegmentLine."Document No." := DocumentNo;
        TempSegmentLine."Doc. No. Occurrence" := DocNoOccurrence;
        TempSegmentLine."Version No." := VersionNo;
        TempSegmentLine.Validate("Contact No.", ContNo);
        TempSegmentLine.Date := Today;
        TempSegmentLine."Time of Interaction" := Time;
        TempSegmentLine.Description := Description;
        TempSegmentLine."Salesperson Code" := SalespersonCode;
        TempSegmentLine."Opportunity No." := OpportunityNo;
        TempSegmentLine.VehicleAddToSublines(VehicleSerialNo, 0);  //26.07.2013 EDMS P8
        TempSegmentLine.Insert;
        TempSegmentLine.Validate("Interaction Template Code", InteractTmplCode);
        if CampaignNo <> '' then
            TempSegmentLine."Campaign No." := CampaignNo;
        TempSegmentLine.Modify;

        SegManagement.LogInteraction(TempSegmentLine, Attachment, InterLogEntryCommentLine, false, false);
    end;

    procedure FindContactFromContBusRelation(LinkToTable: Enum "Contact Business Relation Link To Table"; AccountNo: Code[20]): Code[20]
    var
        ContBusRel: Record "Contact Business Relation";
    begin
        ContBusRel.SetRange("Link to Table", LinkToTable);
        ContBusRel.SetRange("No.", AccountNo);
        if ContBusRel.FindFirst then
            exit(ContBusRel."Contact No.");
    end;

    procedure ServOrdHeaderDocType(DocType: Option): Integer
    var
        ServOrdHeader: Record "Service Header EDMS";
        ServDocTypeEDMS: Option Quote,"Order","Return Order","Posted Order","Posted Return Order";
    begin
        case DocType of
            Servdoctypeedms::Quote:
                exit(ServOrdHeader."document type"::Quote);  //10.04.2013 EDMS P8
            Servdoctypeedms::Order:
                exit(ServOrdHeader."document type"::Order);
            Servdoctypeedms::"Return Order":
                exit(ServOrdHeader."document type"::"Return Order");
        end;
    end;

    procedure CopyServOrd(var ToServOrdHeader: Record "Service Header EDMS"; FromDocType: Option; FromDocNo: Code[20]; var FromServOrdLine: Record "Service Line EDMS"; IncludeHeader: Boolean) AllLinesCopied: Boolean
    var
        LineNo: Integer;
        FromServOrdHeader: Record "Service Header EDMS";
        OldServOrdHeader: Record "Service Header EDMS";
        FromPstServOrdHeader: Record "Posted Serv. Order Header";
        FromPstServRetOrdHdr: Record "Posted Serv. Ret. Order Header";
        Cust: Record Customer;
        CustLedgEntry: Record "Cust. Ledger Entry";
        GLSetUp: Record "General Ledger Setup";
        PaymentTerms: Record "Payment Terms";
        FromPstServOrdLine: Record "Posted Serv. Order Line";
        ToServOrdLine: Record "Service Line EDMS";
        FromPstServRetOrdLine: Record "Posted Serv. Return Order Line";
        Resources: Text[250];
        SerLaborAllocApplDocType: Option Quote,"Order","Return Order",Invoice,"Credit Memo","Blanket Order";
        ServDocTypeEDMS: Option Quote,"Order","Return Order","Posted Order","Posted Return Order";
        RecalculateLines: Boolean;
        Text000: Label 'Please enter a Document No.';
        Text001: Label '%1 %2 cannot be copied onto itself.';
    begin
        if FromDocNo = '' then
            Error(Text000);
        case FromDocType of
            Servdoctypeedms::Quote,
            Servdoctypeedms::Order,
            Servdoctypeedms::"Return Order":
                begin
                    FromServOrdHeader.Get(ServOrdHeaderDocType(FromDocType), FromDocNo);
                    if (FromServOrdHeader."Document Type" = ToServOrdHeader."Document Type") and
                       (FromServOrdHeader."No." = ToServOrdHeader."No.")
                    then
                        Error(
                          Text001,
                          ToServOrdHeader."Document Type", ToServOrdHeader."No.");
                    if not IncludeHeader and not RecalculateLines then begin
                        FromServOrdHeader.TestField("Sell-to Customer No.", ToServOrdHeader."Sell-to Customer No.");
                        FromServOrdHeader.TestField("Bill-to Customer No.", ToServOrdHeader."Bill-to Customer No.");
                        FromServOrdHeader.TestField("Customer Posting Group", ToServOrdHeader."Customer Posting Group");
                        FromServOrdHeader.TestField("Gen. Bus. Posting Group", ToServOrdHeader."Gen. Bus. Posting Group");
                        FromServOrdHeader.TestField("Currency Code", ToServOrdHeader."Currency Code");
                    end;
                end;
            Servdoctypeedms::"Posted Order":
                begin
                    FromPstServOrdHeader.Get(FromDocNo);
                    if not IncludeHeader then begin
                        FromPstServOrdHeader.TestField("Sell-to Customer No.", ToServOrdHeader."Sell-to Customer No.");
                        FromPstServOrdHeader.TestField("Bill-to Customer No.", ToServOrdHeader."Bill-to Customer No.");
                        FromPstServOrdHeader.TestField("Customer Posting Group", ToServOrdHeader."Customer Posting Group");
                        FromPstServOrdHeader.TestField("Gen. Bus. Posting Group", ToServOrdHeader."Gen. Bus. Posting Group");
                        FromPstServOrdHeader.TestField("Currency Code", ToServOrdHeader."Currency Code");
                    end else
                        FromServOrdHeader.TransferFields(FromPstServOrdHeader)
                end;
            Servdoctypeedms::"Posted Return Order":
                begin
                    FromPstServRetOrdHdr.Get(FromDocNo);
                    if not IncludeHeader then begin
                        FromPstServRetOrdHdr.TestField("Sell-to Customer No.", ToServOrdHeader."Sell-to Customer No.");
                        FromPstServRetOrdHdr.TestField("Bill-to Customer No.", ToServOrdHeader."Bill-to Customer No.");
                        FromPstServRetOrdHdr.TestField("Customer Posting Group", ToServOrdHeader."Customer Posting Group");
                        FromPstServRetOrdHdr.TestField("Gen. Bus. Posting Group", ToServOrdHeader."Gen. Bus. Posting Group");
                        FromPstServRetOrdHdr.TestField("Currency Code", ToServOrdHeader."Currency Code");
                    end else
                        FromServOrdHeader.TransferFields(FromPstServRetOrdHdr)
                end
        end;

        if not ToServOrdHeader.RECORDLEVELLOCKING then
            ToServOrdHeader.LockTable(true, true);

        if IncludeHeader then begin
            if Cust.Get(FromServOrdHeader."Sell-to Customer No.") then
                Cust.CheckBlockedCustOnDocs(Cust, ToServOrdHeader."Document Type", false, false);
            if Cust.Get(FromServOrdHeader."Bill-to Customer No.") then
                Cust.CheckBlockedCustOnDocs(Cust, ToServOrdHeader."Document Type", false, false);

            OldServOrdHeader := ToServOrdHeader;
            case FromDocType of
                Servdoctypeedms::Quote,
                Servdoctypeedms::Order,
                Servdoctypeedms::"Return Order":
                    begin
                        ToServOrdHeader.TransferFields(FromServOrdHeader, false);

                        if ToServOrdHeader."Document Type" = ToServOrdHeader."document type"::"Return Order" then
                            ToServOrdHeader."Applies-to Doc. No." := FromServOrdHeader."No."
                        else
                            ToServOrdHeader."Applies-to Doc. No." := '';
                        ToServOrdHeader."Applies-to Doc. Type" := ToServOrdHeader."applies-to doc. type"::" ";                        // 10.05.2014 Elva Baltic P21
                    end;
                Servdoctypeedms::"Posted Order":
                    begin
                        ToServOrdHeader.TransferFields(FromPstServOrdHeader, false);
                        CopyFromPstdServDocDimToHdr(ToServOrdHeader, FromDocType, FromPstServOrdHeader, FromPstServRetOrdHdr);
                        if ToServOrdHeader."Document Type" = ToServOrdHeader."document type"::"Return Order" then begin
                            ToServOrdHeader."Applies-to Doc. No." := FromPstServOrdHeader."Order No.";
                            ToServOrdHeader."Applies-to Doc. Type" := ToServOrdHeader."applies-to doc. type"::Order;                    // 10.05.2014 Elva Baltic P21
                        end else begin
                            ToServOrdHeader."Applies-to Doc. No." := '';
                            ToServOrdHeader."Applies-to Doc. Type" := ToServOrdHeader."applies-to doc. type"::" ";                      // 10.05.2014 Elva Baltic P21
                        end;
                    end;
                Servdoctypeedms::"Posted Return Order":
                    begin
                        ToServOrdHeader.TransferFields(FromPstServRetOrdHdr, false);
                        CopyFromPstdServDocDimToHdr(ToServOrdHeader, FromDocType, FromPstServOrdHeader, FromPstServRetOrdHdr);
                        if ToServOrdHeader."Document Type" = ToServOrdHeader."document type"::"Return Order" then begin
                            ToServOrdHeader."Applies-to Doc. No." := FromPstServRetOrdHdr."Return Order No.";
                            ToServOrdHeader."Applies-to Doc. Type" := ToServOrdHeader."applies-to doc. type"::"Return Order";           // 10.05.2014 Elva Baltic P21
                        end else begin
                            ToServOrdHeader."Applies-to Doc. No." := '';
                            ToServOrdHeader."Applies-to Doc. Type" := ToServOrdHeader."applies-to doc. type"::" ";                      // 10.05.2014 Elva Baltic P21
                        end;
                    end
            end;

            ToServOrdHeader."Document Type" := OldServOrdHeader."Document Type";
            ToServOrdHeader."No." := OldServOrdHeader."No.";
            ToServOrdHeader."No. Series" := OldServOrdHeader."No. Series";
            ToServOrdHeader."Posting Description" := OldServOrdHeader."Posting Description";
            ToServOrdHeader."Posting No." := OldServOrdHeader."Posting No.";
            ToServOrdHeader."Posting No. Series" := OldServOrdHeader."Posting No. Series";
            ToServOrdHeader."Pst. Return Order No." := OldServOrdHeader."Pst. Return Order No.";
            ToServOrdHeader."Pst. Return Order No. Series" := OldServOrdHeader."Pst. Return Order No. Series";
            ToServOrdHeader."No. Printed" := 0;
            // "Applies-to Doc. Type" := "Applies-to Doc. Type"::" ";                           // 10.05.2014 Elva Baltic P21
            ToServOrdHeader.Status := OldServOrdHeader.Status;

            if ToServOrdHeader."Document Type" in [ToServOrdHeader."document type"::Quote] then
                ToServOrdHeader."Posting Date" := 0D;

            ToServOrdHeader.Correction := false;
            if ToServOrdHeader."Document Type" in [ToServOrdHeader."document type"::"Return Order"] then begin
                GLSetUp.Get;
                ToServOrdHeader.Correction := GLSetUp."Mark Cr. Memos as Corrections";
                if (ToServOrdHeader."Payment Terms Code" <> '') and (ToServOrdHeader."Document Date" <> 0D) then
                    PaymentTerms.Get(ToServOrdHeader."Payment Terms Code")
                else
                    Clear(PaymentTerms);
                if not PaymentTerms."Calc. Pmt. Disc. on Cr. Memos" then begin
                    ToServOrdHeader."Payment Terms Code" := '';
                    ToServOrdHeader."Due Date" := 0D;
                end;
            end;
            ToServOrdHeader.Modify
        end;

        ToServOrdLine.LockTable;
        ToServOrdLine.Reset;
        ToServOrdLine.SetRange("Document Type", ToServOrdHeader."Document Type");
        ToServOrdLine.SetRange("Document No.", ToServOrdHeader."No.");
        if ToServOrdLine.Find('+') then
            LineNo := ToServOrdLine."Line No." + 10000
        else
            LineNo := 10000;

        AllLinesCopied := true;
        case FromDocType of
            Servdoctypeedms::Quote,  //10.04.2013 EDMS P8
            Servdoctypeedms::Order,
            Servdoctypeedms::"Return Order":
                begin
                    FromServOrdLine.Reset;
                    FromServOrdLine.SetRange("Document Type", ServOrdHeaderDocType(FromDocType));
                    FromServOrdLine.SetRange("Document No.", FromDocNo);
                    if FromServOrdLine.Find('-') then
                        repeat
                            if not CopyServOrdLine(ToServOrdHeader, ToServOrdLine, FromServOrdLine) then begin
                                AllLinesCopied := false;
                                FromServOrdLine.Mark(true)
                            end else
                                LineNo := LineNo + 10000;

                        until FromServOrdLine.Next = 0;
                end;
            Servdoctypeedms::"Posted Order":
                begin
                    FromServOrdHeader.TransferFields(FromPstServOrdHeader);
                    FromPstServOrdLine.Reset;
                    FromPstServOrdLine.SetRange("Document No.", FromPstServOrdHeader."No.");
                    if FromPstServOrdLine.Find('-') then
                        repeat
                            FromServOrdLine.TransferFields(FromPstServOrdLine);

                            //09.04.2010 EDMS P2 >>
                            FromServOrdLine."Inv. Disc. Amount to Invoice" := FromServOrdLine."Inv. Discount Amount";
                            //09.04.2010 EDMS P2 <<

                            if not CopyServOrdLine(ToServOrdHeader, ToServOrdLine, FromServOrdLine) then begin
                                AllLinesCopied := false;
                                FromServOrdLine.Mark(true)
                            end else begin
                                LineNo := LineNo + 10000;

                                //21.07.2008. EDMS P2 (for Item Tracking) >>
                                CopyServInvLinesToDoc(ToServOrdLine, FromPstServOrdHeader."No.", FromServOrdLine);
                                //21.07.2008. EDMS P2 <<
                            end;

                            CopyFromPstdServDocDimToLine(
                              ToServOrdLine, FromDocType, FromPstServOrdLine, FromPstServRetOrdLine);

                            // 10.05.2014 Elva Baltic P21 >>
                            if ToServOrdHeader."Document Type" in [ToServOrdHeader."document type"::Order, ToServOrdHeader."document type"::"Return Order"] then
                                if FromPstServOrdLine.Resources <> '' then
                                    ServiceScheduleMgt.CopyServLaborAllocApplFromDetServLedg(1, FromPstServOrdLine."Document No.",
                                      FromPstServOrdLine."Line No.", ToServOrdLine);                 // 28.05.2015 EB.P30 #T030
                                                                                                     // 10.05.2014 Elva Baltic P21 <<
                        until FromPstServOrdLine.Next = 0;

                end;
            Servdoctypeedms::"Posted Return Order":
                begin
                    FromServOrdHeader.TransferFields(FromPstServRetOrdHdr);
                    FromPstServRetOrdLine.Reset;
                    FromPstServRetOrdLine.SetRange("Document No.", FromPstServRetOrdHdr."No.");
                    if FromPstServRetOrdLine.Find('-') then
                        repeat
                            FromServOrdLine.TransferFields(FromPstServRetOrdLine);

                            //09.04.2010 EDMS P2 >>
                            FromServOrdLine."Inv. Disc. Amount to Invoice" := FromServOrdLine."Inv. Discount Amount";
                            //09.04.2010 EDMS P2 <<

                            if not CopyServOrdLine(ToServOrdHeader, ToServOrdLine, FromServOrdLine) then begin
                                AllLinesCopied := false;
                                FromServOrdLine.Mark(true)
                            end else begin
                                LineNo := LineNo + 10000;

                                //21.07.2008. EDMS P2 (for Item Tracking) >>
                                CopyServCrMemoLinesToDoc(ToServOrdLine, FromPstServRetOrdHdr."No.");
                                //21.07.2008. EDMS P2 <<
                            end;

                            CopyFromPstdServDocDimToLine(
                              ToServOrdLine, FromDocType, FromPstServOrdLine, FromPstServRetOrdLine);

                            // 10.05.2014 Elva Baltic P21 >>
                            if ToServOrdHeader."Document Type" in [ToServOrdHeader."document type"::Order, ToServOrdHeader."document type"::"Return Order"] then
                                if FromPstServRetOrdLine.Resources <> '' then
                                    ServiceScheduleMgt.CopyServLaborAllocApplFromDetServLedg(5, FromPstServRetOrdLine."Document No.",
                                      FromPstServRetOrdLine."Line No.", ToServOrdLine);              //28.05.2015 EB.P30 #T030
                                                                                                     // 10.05.2014 Elva Baltic P21 <<
                        until FromPstServRetOrdLine.Next = 0;
                end
        end
    end;

    procedure CopyServOrdLine(ToServOrdHeader: Record "Service Header EDMS"; var ToServOrdLine: Record "Service Line EDMS"; var FromServOrdLine: Record "Service Line EDMS"): Boolean
    begin
        ToServOrdLine := FromServOrdLine;
        ToServOrdLine."Document Type" := ToServOrdHeader."Document Type";
        ToServOrdLine."Document No." := ToServOrdHeader."No.";

        //28.07.2008. EDMS P2 >>
        if ToServOrdLine."Document Type" <> ToServOrdLine."document type"::Order then begin
            ToServOrdLine."Prepayment %" := 0;
            ToServOrdLine."Prepayment VAT %" := 0;
            ToServOrdLine."Prepmt. VAT Calc. Type" := 0;
            ToServOrdLine."Prepayment VAT Identifier" := '';
            ToServOrdLine."Prepayment VAT %" := 0;
            ToServOrdLine."Prepayment Tax Group Code" := '';
            ToServOrdLine."Prepmt. Line Amount" := 0;
            ToServOrdLine."Prepmt. Amt. Incl. VAT" := 0;
        end;
        ToServOrdLine."Prepmt. Amt. Inv." := 0;
        ToServOrdLine."Prepayment Amount" := 0;
        ToServOrdLine."Prepmt. VAT Base Amt." := 0;
        ToServOrdLine."Prepmt Amt to Deduct" := 0;
        ToServOrdLine."Prepmt Amt Deducted" := 0;
        ToServOrdLine."Prepayment Amount Incl. VAT" := 0;
        ToServOrdLine."Reserved Quantity" := 0;
        ToServOrdLine."Reserved Qty. (Base)" := 0;
        ToServOrdLine."Job No." := '';
        ToServOrdLine.InitOutstanding;
        //28.07.2008. EDMS P2 <<

        ToServOrdLine.Insert(true);

        exit(true);
    end;

    procedure CopyFromPstdServDocDimToLine(var ToServOrdLine: Record "Service Line EDMS"; FromDocType: Option; var FromPstServOrdLine: Record "Posted Serv. Order Line"; var FromPstServRetOrdLine: Record "Posted Serv. Return Order Line")
    Var
        ServDocTypeEDMS: Option Quote,"Order","Return Order","Posted Order","Posted Return Order";
    begin
        case FromDocType of
            Servdoctypeedms::"Posted Order":
                begin
                    ToServOrdLine."Shortcut Dimension 1 Code" := FromPstServOrdLine."Shortcut Dimension 1 Code";
                    ToServOrdLine."Shortcut Dimension 2 Code" := FromPstServOrdLine."Shortcut Dimension 2 Code";


                end;
            Servdoctypeedms::"Posted Return Order":
                begin
                    ToServOrdLine."Shortcut Dimension 1 Code" := FromPstServRetOrdLine."Shortcut Dimension 1 Code";
                    ToServOrdLine."Shortcut Dimension 2 Code" := FromPstServRetOrdLine."Shortcut Dimension 2 Code";

                end;
        end;
    end;

    procedure CopyServCrMemoLinesToDoc(ToServiceLine: Record "Service Line EDMS"; OldOrderNo: Code[20])
    var
        ItemLedgEntryBuf: Record "Item Ledger Entry" temporary;
        TempTrkgItemLedgEntry: Record "Item Ledger Entry" temporary;
        FromSalesCrMemoHdr: Record "Sales Cr.Memo Header";
        FromSalesCrMemoLine: Record "Sales Cr.Memo Line";
        TempItemTrkgEntry: Record "Reservation Entry" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        FillExactCostRevLink: Boolean;
        CopyItemTrkg: Boolean;
        ToServiceHeader: Record "Service Header EDMS";
    begin
        // copy item tracking
        FromSalesCrMemoHdr.SetCurrentkey("Service Return Order No.");
        FromSalesCrMemoHdr.SetRange("Service Return Order No.", OldOrderNo);
        if FromSalesCrMemoHdr.FindFirst then;
        if ToServiceHeader.Get(ToServiceLine."Document Type", ToServiceLine."Document No.") then;

        if FromSalesCrMemoLine.Get(FromSalesCrMemoHdr."No.", ToServiceLine."Line No.") then;

        FillExactCostRevLink :=
          IsServFillExactCostRevLink(ToServiceHeader, 1, FromSalesCrMemoHdr."Currency Code");

        if (ToServiceLine.Type = ToServiceLine.Type::Item) and (ToServiceLine.Quantity <> 0) then begin
            FromSalesCrMemoLine.GetItemLedgEntries(ItemLedgEntryBuf, true);
            if IsCopyItemTrkg(ItemLedgEntryBuf, CopyItemTrkg, FillExactCostRevLink) then begin

                // 22.10.2015 NAV2016 Merge >>
                //ItemTrackingMgt.CollectItemTrkgPerPstdDocLine(TempTrkgItemLedgEntry,ItemLedgEntryBuf);
                // 22.10.2015 NAV2016 Merge <<

                CopyItemLedgEntryTrkgToServLn(
                TempTrkgItemLedgEntry, ToServiceLine);
            end;
        end;
    end;

    procedure IsServFillExactCostRevLink(ToServiceHeader: Record "Service Header EDMS"; FromDocType: Option "Sales Invoice","Sales Credit Memo"; CurrencyCode: Code[10]): Boolean
    begin
        case FromDocType of
            Fromdoctype::"Sales Invoice":
                exit(
                  (ToServiceHeader."Document Type" in [ToServiceHeader."document type"::"Return Order"]) and
                  (ToServiceHeader."Currency Code" = CurrencyCode));
            Fromdoctype::"Sales Credit Memo":
                exit(
                  (ToServiceHeader."Document Type" in [ToServiceHeader."document type"::Order]) and
                  (ToServiceHeader."Currency Code" = CurrencyCode));
        end;
        exit(false);
    end;

    procedure CopyFromPstdServDocDimToHdr(var ToServOrdHeader: Record "Service Header EDMS"; FromDocType: Option; var FromPstServOrdHeader: Record "Posted Serv. Order Header"; var FromPstRetServOrdHdr: Record "Posted Serv. Ret. Order Header")
    Var
        ServDocTypeEDMS: Option Quote,"Order","Return Order","Posted Order","Posted Return Order";
    begin
        case FromDocType of
            Servdoctypeedms::"Posted Order":
                begin
                    ToServOrdHeader."Shortcut Dimension 1 Code" := FromPstServOrdHeader."Shortcut Dimension 1 Code";
                    ToServOrdHeader."Shortcut Dimension 2 Code" := FromPstServOrdHeader."Shortcut Dimension 2 Code";


                end;
            Servdoctypeedms::"Posted Return Order":
                begin
                    ToServOrdHeader."Shortcut Dimension 1 Code" := FromPstRetServOrdHdr."Shortcut Dimension 1 Code";
                    ToServOrdHeader."Shortcut Dimension 2 Code" := FromPstRetServOrdHdr."Shortcut Dimension 2 Code";

                end;
        end;
    end;

    procedure CopyServInvLinesToDoc(ToServiceLine: Record "Service Line EDMS"; OldOrderNo: Code[20]; FromServOrdLine: Record "Service Line EDMS")
    var
        ItemLedgEntryBuf: Record "Item Ledger Entry" temporary;
        TempTrkgItemLedgEntry: Record "Item Ledger Entry" temporary;
        FromSalesInvHeader: Record "Sales Invoice Header";
        FromSalesCrMemoLine: Record "Sales Cr.Memo Line";
        TempItemTrkgEntry: Record "Reservation Entry" temporary;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        FillExactCostRevLink: Boolean;
        CopyItemTrkg: Boolean;
        ToServiceHeader: Record "Service Header EDMS";
        FromSalesInvLine: Record "Sales Invoice Line";
    begin
        // copy item tracking
        FromSalesInvHeader.SetCurrentkey("Service Order No.");
        FromSalesInvHeader.SetRange("Service Order No.", OldOrderNo);
        if FromSalesInvHeader.FindFirst then;
        if ToServiceHeader.Get(ToServiceLine."Document Type", ToServiceLine."Document No.") then;

        // 14.04.2014 Elva Baltic P21 >>
        // IF FromSalesInvLine.GET(FromSalesInvHeader."No.", ToServiceLine."Line No.") THEN;
        FromSalesInvLine.Reset;
        FromSalesInvLine.SetCurrentkey("Service Order No. EDMS", "Service Order Line No. EDMS");
        FromSalesInvLine.SetRange("Service Order No. EDMS", OldOrderNo);
        FromSalesInvLine.SetRange("Service Order Line No. EDMS", FromServOrdLine."Line No.");
        if FromSalesInvLine.FindFirst then;
        // 14.04.2014 Elva Baltic P21 <<

        FillExactCostRevLink :=
          IsServFillExactCostRevLink(ToServiceHeader, 0, FromSalesInvHeader."Currency Code");

        if (ToServiceLine.Type = ToServiceLine.Type::Item) and (ToServiceLine.Quantity <> 0) then begin
            FromSalesInvLine.GetItemLedgEntries(ItemLedgEntryBuf, true);
            // 14.04.2014 Elva Baltic P21 >>
            if ItemLedgEntryBuf.FindFirst and (ToServiceHeader."Document Type" = ToServiceHeader."document type"::"Return Order") then begin
                ToServiceLine."Appl.-from Item Entry" := ItemLedgEntryBuf."Entry No.";
                ToServiceLine.Modify;
            end;
            // 14.04.2014 Elva Baltic P21 <<

            if IsCopyItemTrkg(ItemLedgEntryBuf, CopyItemTrkg, FillExactCostRevLink) then begin

                // 22.10.2015 NAV2016 Merge >>
                //ItemTrackingMgt.CollectItemTrkgPerPstdDocLine(TempTrkgItemLedgEntry,ItemLedgEntryBuf);
                // 22.10.2015 NAV2016 Merge <<

                CopyItemLedgEntryTrkgToServLn(
              TempTrkgItemLedgEntry, ToServiceLine);
            end;
        end;
    end;

    procedure IsCopyItemTrkg(var ItemLedgEntry: Record "Item Ledger Entry"; var CopyItemTrkg: Boolean; FillExactCostRevLink: Boolean) Result: Boolean
    var
    begin
        if ItemLedgEntry.IsEmpty() then
            exit(true);
        ItemLedgEntry.SetFilter("Serial No.", '<>%1', '');
        if not ItemLedgEntry.IsEmpty() then begin
            if FillExactCostRevLink then
                CopyItemTrkg := true;
            exit(true);
        end;
        ItemLedgEntry.SetRange("Serial No.");
        ItemLedgEntry.SetFilter("Lot No.", '<>%1', '');
        if not ItemLedgEntry.IsEmpty() then begin
            if FillExactCostRevLink then
                CopyItemTrkg := true;
            exit(true);
        end;
        ItemLedgEntry.SetRange("Lot No.");
        exit(false);
    end;

    procedure CopySalesShptExtTextToDoc(ToSalesHeader: Record "Sales Header"; ToSalesLine: Record "Sales Line"; FromSalesShptLine: Record "Sales Shipment Line"; FromLanguageCode: Code[10]; var NextLineNo: Integer; ExactCostReverse: Boolean)
    var
        ToSalesLine2: Record "Sales Line";
        RecalculateLines: Boolean;
        TransferExtendedText: Codeunit "Transfer Extended Text";

    begin
        ToSalesLine2.SetRange("Document No.", ToSalesLine."Document No.");
        ToSalesLine2.SetRange("Attached to Line No.", ToSalesLine."Line No.");
        if ToSalesLine2.IsEmpty then begin
            FromSalesShptLine.SetRange("Document No.", FromSalesShptLine."Document No.");
            FromSalesShptLine.SetRange("Attached to Line No.", FromSalesShptLine."Line No.");
            if FromSalesShptLine.FindSet then
                repeat
                    if (ToSalesHeader."Language Code" <> FromLanguageCode) or
                       (RecalculateLines and not ExactCostReverse)
                    then begin
                        if TransferExtendedText.SalesCheckIfAnyExtText(ToSalesLine, false) then begin
                            TransferExtendedText.InsertSalesExtText(ToSalesLine);
                            NextLineNo := GetLastToSalesLineNo(ToSalesHeader);
                        end;
                    end else begin
                        CopySalesExtTextLines(
                          ToSalesLine2, ToSalesLine, FromSalesShptLine.Description, FromSalesShptLine."Description 2", NextLineNo);
                        ToSalesLine2."Shortcut Dimension 1 Code" := FromSalesShptLine."Shortcut Dimension 1 Code";
                        ToSalesLine2."Shortcut Dimension 2 Code" := FromSalesShptLine."Shortcut Dimension 2 Code";
                        ToSalesLine2."Dimension Set ID" := FromSalesShptLine."Dimension Set ID";
                    end;
                until FromSalesShptLine.Next = 0;
        end;
    end;

    procedure GetLastToSalesLineNo(ToSalesHeader: Record "Sales Header"): Decimal
    var
        ToSalesLine: Record "Sales Line";
    begin
        ToSalesLine.LockTable();
        ToSalesLine.SetRange("Document Type", ToSalesHeader."Document Type");
        ToSalesLine.SetRange("Document No.", ToSalesHeader."No.");
        if ToSalesLine.FindLast then
            exit(ToSalesLine."Line No.");
        exit(0);
    end;

    procedure CopySalesExtTextLines(var ToSalesLine2: Record "Sales Line"; ToSalesLine: Record "Sales Line"; Description: Text[50]; Description2: Text[50]; var NextLineNo: Integer)
    begin
        NextLineNo := NextLineNo + 10000;
        ToSalesLine2.Init;
        ToSalesLine2."Line No." := NextLineNo;
        ToSalesLine2."Document Type" := ToSalesLine."Document Type";
        ToSalesLine2."Document No." := ToSalesLine."Document No.";
        ToSalesLine2.Description := Description;
        ToSalesLine2."Description 2" := Description2;
        ToSalesLine2."Attached to Line No." := ToSalesLine."Line No.";
        ToSalesLine2.Insert;
    end;

    procedure CopyPurchExtTextLines(var ToPurchLine2: Record "Purchase Line"; ToPurchLine: Record "Purchase Line"; Description: Text[50]; Description2: Text[50]; var NextLineNo: Integer)
    begin
        NextLineNo := NextLineNo + 10000;
        ToPurchLine2.Init;
        ToPurchLine2."Line No." := NextLineNo;
        ToPurchLine2."Document Type" := ToPurchLine."Document Type";
        ToPurchLine2."Document No." := ToPurchLine."Document No.";
        ToPurchLine2.Description := Description;
        ToPurchLine2."Description 2" := Description2;
        ToPurchLine2."Attached to Line No." := ToPurchLine."Line No.";
        ToPurchLine2.Insert;
    end;

    procedure CopySalesQuoteToServQuote(var ToServOrdHeader: Record "Service Header EDMS"; FromDocNo: Code[20]) AllLinesCopied: Boolean
    var
        FromSalesHeader: Record "Sales Header";
        Cust: Record Customer;
        GLSetUp: Record "General Ledger Setup";
        ToServOrdLine: Record "Service Line EDMS";
        Resources: Text[250];
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        FromSalesLine: Record "Sales Line";
        LineNo: Integer;
        Text000: Label 'Please enter a Document No.';
        OpenPage: Boolean;
        ServiceQuote: page "Service Quote EDMS";
    begin
        if FromDocNo = '' then
            Error(Text000);


        if FromSalesHeader.Get(FromSalesHeader."document type"::Quote, FromDocNo) then begin

            if not ToServOrdHeader.RECORDLEVELLOCKING then
                ToServOrdHeader.LockTable(true, true);


            if Cust.Get(FromSalesHeader."Sell-to Customer No.") then
                Cust.CheckBlockedCustOnDocs(Cust, ToServOrdHeader."Document Type", false, false);
            if Cust.Get(FromSalesHeader."Bill-to Customer No.") then
                Cust.CheckBlockedCustOnDocs(Cust, ToServOrdHeader."Document Type", false, false);

            ServiceSetup.Get;
            ServiceSetup.TestField("Order Nos.");
            Clear(ToServOrdHeader);
            ToServOrdHeader.Init;
            ToServOrdHeader."Document Type" := ToServOrdHeader."document type"::Quote;
            ToServOrdHeader."No." := '';
            ToServOrdHeader."Posting Date" := 0D; //FromSalesHeader."Posting Date";
            ToServOrdHeader.Insert(true);

            ToServOrdHeader.SetHideValidationDialog(true);

            ToServOrdHeader.Validate("Sell-to Customer No.", FromSalesHeader."Sell-to Customer No.");
            ToServOrdHeader.Validate("Bill-to Customer No.", FromSalesHeader."Bill-to Customer No.");
            ToServOrdHeader.Validate("Vehicle Serial No.", FromSalesHeader."Vehicle Serial No.");

            ToServOrdHeader.Validate("Deal Type", FromSalesHeader."Deal Type Code");
            ToServOrdHeader.Validate("Service Advisor", FromSalesHeader."Salesperson Code");
            ToServOrdHeader.Validate("Location Code", FromSalesHeader."Location Code");

            ToServOrdHeader."Dimension Set ID" := FromSalesHeader."Dimension Set ID";
            ToServOrdHeader."Shortcut Dimension 1 Code" := FromSalesHeader."Shortcut Dimension 1 Code";
            ToServOrdHeader."Shortcut Dimension 2 Code" := FromSalesHeader."Shortcut Dimension 2 Code";

            ToServOrdHeader.Modify;


            ToServOrdLine.LockTable;

            FromSalesLine.Reset;
            FromSalesLine.SetRange("Document Type", FromSalesLine."document type"::Quote);
            FromSalesLine.SetRange("Document No.", FromSalesHeader."No.");
            FromSalesLine.SetFilter(Type, '%1|%2|%3|%4', FromSalesLine.Type::Item, FromSalesLine.Type::" ", FromSalesLine.Type::"External Service", FromSalesLine.Type::"G/L Account");
            if FromSalesLine.FindFirst then
                repeat
                    LineNo := LineNo + 10000;
                    ToServOrdLine.Init;
                    ToServOrdLine."Document Type" := ToServOrdHeader."Document Type";
                    ToServOrdLine."Document No." := ToServOrdHeader."No.";
                    ToServOrdLine."Line No." := LineNo;
                    ToServOrdLine.Insert(true);

                    ToServOrdLine.Type := SalesToServLineType(FromSalesLine.Type);
                    ToServOrdLine.Validate("No.", FromSalesLine."No.");
                    ToServOrdLine.Validate("Location Code", FromSalesLine."Location Code");

                    if (ToServOrdLine.Type <> ToServOrdLine.Type::Comment) then begin
                        ToServOrdLine.Validate("Unit of Measure Code", FromSalesLine."Unit of Measure Code");
                        ToServOrdLine.Validate(Quantity, FromSalesLine.Quantity);
                        ToServOrdLine.Validate("Unit Cost", FromSalesLine."Unit Cost");
                        ToServOrdLine.Validate("Unit Price", FromSalesLine."Unit Price");
                        ToServOrdLine.Validate("Line Discount %", FromSalesLine."Line Discount %");
                        //ToServOrdLine.VALIDATE("Line Discount Amount",FromSalesLine."Line Discount Amount");
                    end;
                    ToServOrdLine.Description := FromSalesLine.Description;
                    ToServOrdLine."Description 2" := FromSalesLine."Description 2";

                    ToServOrdLine."Dimension Set ID" := FromSalesLine."Dimension Set ID";
                    ToServOrdLine."Shortcut Dimension 1 Code" := FromSalesLine."Shortcut Dimension 1 Code";
                    ToServOrdLine."Shortcut Dimension 2 Code" := FromSalesLine."Shortcut Dimension 2 Code";

                    ToServOrdLine.Modify(true);
                until FromSalesLine.Next = 0;
            Commit;
            if GuiAllowed then
                OpenPage := Confirm(StrSubstNo(Text037, Format(ToServOrdHeader."Document Type"), Format(ToServOrdHeader."No.")), true);
            if OpenPage then begin
                Clear(ServiceQuote);
                //ServiceQuote.CheckNotificationsOnce;
                ToServOrdHeader.SetRecfilter;
                ServiceQuote.SetTableview(ToServOrdHeader);
                ServiceQuote.Run;
            end;
            //Message(Text037, Format("Document Type"), Format("No."));
        end;
    end;

    procedure SalesToServLineType(LineType: Option): Integer
    var
        FromSalesLine: Record "Sales Line";
        ToServiceLine: Record "Service Line EDMS";
    begin
        case LineType of
            FromSalesLine.Type::" ":
                exit(ToServiceLine.Type::Comment);
            FromSalesLine.Type::"External Service":
                exit(ToServiceLine.Type::"External Service");
            FromSalesLine.Type::"G/L Account":
                exit(ToServiceLine.Type::"G/L Account");
            FromSalesLine.Type::Item:
                exit(ToServiceLine.Type::Item);
        end;
    end;

    // From codeunit 6500 "Item Tracking Management"
    procedure CopyItemLedgEntryTrkgToServLn(var ItemLedgEntryBuf: Record "Item Ledger Entry" temporary; ToServiceLine: Record "Service Line EDMS")
    var
        TempReservEntry: Record "Reservation Entry" temporary;
        ReservEntry: Record "Reservation Entry";
        CopyDocMgt: Codeunit "Copy Document Mgt.";
        ReservMgt: Codeunit "Reservation Management";
        ReservMgtEDMS: Codeunit "Reservation Management EDMS";
        ItemTrackingManagement: Codeunit "Item Tracking Management";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        ItemTrackingSetup: Record "Item Tracking Setup";
        TotalCostLCY: Decimal;
        ItemLedgEntryQty: Decimal;
        LastEntryNo: Integer;
        SignFactor: Integer;
        LinkThisEntry: Boolean;
        EntriesExist: Boolean;
    begin
        if (ToServiceLine.Type <> ToServiceLine.Type::Item) or
           (ToServiceLine.Quantity = 0)
        then
            exit;

        if ItemLedgEntryBuf.FindSet then begin
            if ItemLedgEntryBuf.Quantity / ToServiceLine.Quantity < 0 then
                SignFactor := 1
            else
                SignFactor := -1;
            if ToServiceLine."Document Type" in
               [ToServiceLine."document type"::"Return Order"]
            then
                SignFactor := -SignFactor;

            if ReservEntry.FindLast then
                LastEntryNo := ReservEntry."Entry No.";

            ReservMgtEDMS.SetServiceReserv(ToServiceLine."Document Type", ToServiceLine."Document No.");
            ReservMgtEDMS.SetServLineEDMS(ToServiceLine);
            ReservMgtEDMS.DeleteReservEntries(true, 0);

            repeat
                ItemTrackingSetup."Lot No." := ItemLedgEntryBuf."Lot No.";
                ItemTrackingSetup."Serial No." := ItemLedgEntryBuf."Serial No.";
                LinkThisEntry := ItemLedgEntryBuf."Entry No." > 0;
                ReservEntry.Init;
                ReservEntry."Item No." := ItemLedgEntryBuf."Item No.";
                ReservEntry."Location Code" := ItemLedgEntryBuf."Location Code";
                ReservEntry."Serial No." := ItemLedgEntryBuf."Serial No.";
                ReservEntry."Qty. per Unit of Measure" := ItemLedgEntryBuf."Qty. per Unit of Measure";
                ReservEntry."Lot No." := ItemLedgEntryBuf."Lot No.";
                ReservEntry."Variant Code" := ItemLedgEntryBuf."Variant Code";
                ReservEntry."Source Type" := Database::"Service Line EDMS";
                ReservEntry."Source Subtype" := ToServiceLine."Document Type";
                ReservEntry."Source ID" := ToServiceLine."Document No.";
                ReservEntry."Source Ref. No." := ToServiceLine."Line No.";
                if ToServiceLine."Document Type" in
                   [ToServiceLine."document type"::Order, ToServiceLine."document type"::"Return Order"]
                then
                    ReservEntry."Reservation Status" := ReservEntry."reservation status"::Surplus
                else
                    ReservEntry."Reservation Status" := ReservEntry."reservation status"::Prospect;
                ReservEntry."Quantity Invoiced (Base)" := 0;
                ReservEntry.Validate("Quantity (Base)", ItemLedgEntryBuf.Quantity * SignFactor);
                ReservEntry.Positive := (ReservEntry."Quantity (Base)" > 0);
                ReservEntry."Entry No." := LastEntryNo + 1;
                if ReservEntry.Positive then begin
                    ReservEntry."Warranty Date" := ItemLedgEntryBuf."Warranty Date";
                    ReservEntry."Expiration Date" := ItemTrackingManagement.ExistingExpirationDate(
                      ItemLedgEntryBuf."Item No.", ItemLedgEntryBuf."Variant Code", ItemTrackingSetup, false, EntriesExist);
                    ReservEntry."Expected Receipt Date" := ToServiceLine."Planned Service Date"
                end else
                    ReservEntry."Shipment Date" := ToServiceLine."Planned Service Date";

                ReservEntry.Description := ToServiceLine.Description;
                ReservEntry."Creation Date" := WorkDate;
                ReservEntry."Created By" := UserId;
                ReservEntry.UpdateItemTracking;
                ReservEntry.Insert;
                TempReservEntry := ReservEntry;
                TempReservEntry.Insert;
                LastEntryNo := ReservEntry."Entry No.";
            until ItemLedgEntryBuf.Next = 0;
            ReservEngineMgt.UpdateOrderTracking(TempReservEntry);
        end;
    end;

    //---------------------------------- codeunit 5063 ArchiveManagement
    procedure StoreServiceDocument(var ServiceHeader: Record "Service Header EDMS"; InteractionExist: Boolean)
    var
        ServiceLine: Record "Service Line EDMS";
        ServiceHeaderArchive: Record "Service Header Archive";
        ServiceLineArchive: Record "Service Line Archive";
        ArchiveManagement: Codeunit ArchiveManagement;
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

    procedure StoreServiceDocumentComments(DocType: Option Quote,"Order","Return Order"; DocNo: Code[20]; DocNoOccurrence: Integer; VersionNo: Integer)
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

    procedure ArchiveSalesOfferAnalysis(DocumentNo: Code[20]; DocumentType: Integer; VersionNo: Integer)
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

    // From codeunit 99000889 AvailabilityManagement
    procedure SetServHeaderEDMS(var OrderPromisingLine: Record "Order Promising Line"; var CrntServiceHeaderEDMS: Record "Service Header EDMS")
    var
        NeededQty: Decimal;
        Item: Record Item;
        CaptionText: Text;
        Text101: label 'Service Order';
        ServiceLineEDMS: Record "Service Line EDMS";
        CompanyInfo: Record "Company Information";
        InvtSetup: Record "Inventory Setup";
        AvailabilityManagement: codeunit AvailabilityManagement;
        Text001: Label 'The Check-Avail. Period Calc. field cannot be empty in the Company Information card.';
    begin
        CaptionText := Text101;
        OrderPromisingLine.DeleteAll;
        ServiceLineEDMS.SetRange("Document Type", CrntServiceHeaderEDMS."Document Type");
        ServiceLineEDMS.SetRange("Document No.", CrntServiceHeaderEDMS."No.");
        ServiceLineEDMS.SetRange(Type, ServiceLineEDMS.Type::Item);
        ServiceLineEDMS.SetFilter(Quantity, '>0');
        if ServiceLineEDMS.Find('-') then
            repeat
                Item.Get(ServiceLineEDMS."No.");
                if Item.type = Item.type::Inventory then begin
                    OrderPromisingLine."Entry No." := ServiceLineEDMS."Line No.";
                    OrderPromisingLine.TransferFromServiceLineEDMS(ServiceLineEDMS);
                    ServiceLineEDMS.CalcFields("Reserved Qty. (Base)");
                    OrderPromisingLine."Unavailable Quantity (Base)" := OrderPromisingLine."Quantity (Base)" - ServiceLineEDMS."Reserved Qty. (Base)";
                    if OrderPromisingLine."Unavailable Quantity (Base)" > 0 then begin
                        NeededQty := OrderPromisingLine."Unavailable Quantity (Base)";
                        CompanyInfo.Get;
                        InvtSetup.Get();
                        if Format(CompanyInfo."Check-Avail. Period Calc.") <> '' then
                            OrderPromisingLine."Unavailable Quantity (Base)" := -AvailabilityManagement.CalcAvailableQty(OrderPromisingLine)
                        else
                            Error(Text001);
                        if (InvtSetup."Location Mandatory") then
                            ServiceLineEDMS.TestField("Location Code");
                        if OrderPromisingLine."Unavailable Quantity (Base)" < 0 then
                            OrderPromisingLine."Unavailable Quantity (Base)" := 0;
                        if OrderPromisingLine."Unavailable Quantity (Base)" > NeededQty then
                            OrderPromisingLine."Unavailable Quantity (Base)" := NeededQty;
                    end else
                        OrderPromisingLine."Unavailable Quantity (Base)" := 0;
                    if OrderPromisingLine."Qty. per Unit of Measure" = 0 then
                        OrderPromisingLine."Qty. per Unit of Measure" := 1;
                    OrderPromisingLine."Unavailable Quantity" :=
                      ROUND(OrderPromisingLine."Unavailable Quantity (Base)" / OrderPromisingLine."Qty. per Unit of Measure", 0.00001);
                    OrderPromisingLine.Insert;
                END;
            until ServiceLineEDMS.Next = 0;
    end;

    procedure CopyOwnOptionsToModel(var OwnOption: Record "Own Option"; ToModel: Record Model; SalesType: Option Customer,"Customer Discount Group","All Customers",Campaign,"None"; SalesCode: Code[20]; StartingDate: DateFormula)
    var
        ToOwnOption: Record "Own Option";
        OptionTranslation: Record "Option Translation";
        ToOptionTranslation: Record "Option Translation";
        OptionSalesPrice: Record "Option Sales Price";
        ToOptionSalesPrice: Record "Option Sales Price";
        OptionSalesDiscount: Record "Option Sales Discount";
        ToOptionSalesDiscount: Record "Option Sales Discount";
    begin
        // it supposed that record from is filtered, so need to take all records
        if OwnOption.FindFirst then
            repeat
                ToOwnOption := OwnOption;
                ToOwnOption.Validate("Make Code", ToModel."Make Code");
                ToOwnOption.Validate("Model Code", ToModel.Code);
                ToOwnOption.Insert;
                // copy "Option Translation"
                OptionTranslation.Reset;
                OptionTranslation.SetRange("Make Code", OwnOption."Make Code");
                OptionTranslation.SetRange("Model Code", OwnOption."Model Code");
                OptionTranslation.SetRange("Option Code", OwnOption."Option Code");
                if OptionTranslation.FindFirst then
                    repeat
                        ToOptionTranslation := OptionTranslation;
                        ToOptionTranslation.Validate("Make Code", ToModel."Make Code");
                        ToOptionTranslation.Validate("Model Code", ToModel.Code);
                        ToOptionTranslation.Insert;
                    until OptionTranslation.Next = 0;
                // copy "Option Sales Price"
                //Make Code,Model Code,Model Version No.,Option Type,Option Code,Sales Type,Sales Code,Starting Date,Currency Code
                OptionSalesPrice.Reset;
                OptionSalesPrice.SetRange("Make Code", OwnOption."Make Code");
                OptionSalesPrice.SetRange("Model Code", OwnOption."Model Code");
                if (SalesType >= 0) and (SalesType <> Salestype::None) then
                    OptionSalesPrice.SetRange("Sales Type", SalesType);
                if SalesCode <> '' then
                    OptionSalesPrice.SetRange("Sales Code", SalesCode);
                if Format(StartingDate) <> '' then
                    OptionSalesPrice.SetFilter("Starting Date", Format(StartingDate));
                if OptionSalesPrice.FindFirst then
                    repeat
                        ToOptionSalesPrice := OptionSalesPrice;
                        ToOptionSalesPrice.Validate("Make Code", ToModel."Make Code");
                        ToOptionSalesPrice.Validate("Model Code", ToModel.Code);
                        ToOptionSalesPrice.Insert;
                    until OptionSalesPrice.Next = 0;
                // copy "Option Sales Discount"
                //Make Code,Model Code,Model Version No.,Option Type,Option Code,Sales Type,Sales Code,Starting Date
                OptionSalesDiscount.Reset;
                OptionSalesDiscount.SetRange("Make Code", OwnOption."Make Code");
                OptionSalesDiscount.SetRange("Model Code", OwnOption."Model Code");
                if (SalesType >= 0) and (SalesType <> Salestype::None) then
                    OptionSalesDiscount.SetRange("Sales Type", SalesType);
                if SalesCode <> '' then
                    OptionSalesDiscount.SetRange("Sales Code", SalesCode);
                if Format(StartingDate) <> '' then
                    OptionSalesDiscount.SetFilter("Starting Date", Format(StartingDate));
                if OptionSalesDiscount.FindFirst then
                    repeat
                        ToOptionSalesDiscount := OptionSalesDiscount;
                        ToOptionSalesDiscount.Validate("Make Code", ToModel."Make Code");
                        ToOptionSalesDiscount.Validate("Model Code", ToModel.Code);
                        ToOptionSalesDiscount.Insert;
                    until OptionSalesDiscount.Next = 0;

            until OwnOption.Next = 0;
    end;

    procedure CopyManufOptionsToModelVersion(var ManufacturerOption: Record "Manufacturer Option"; ToModelVersion: Record Item; SalesType: Option Customer,"Customer Discount Group","All Customers",Campaign,"None"; SalesCode: Code[20]; StartingDate: DateFormula)
    var
        ToManufacturerOption: Record "Manufacturer Option";
        ManufacturerOptionCondition: Record "Manufacturer Option Condition";
        ToManufacturerOptionCondition: Record "Manufacturer Option Condition";
        OptionTranslation: Record "Option Translation";
        ToOptionTranslation: Record "Option Translation";
        OptionSalesPrice: Record "Option Sales Price";
        ToOptionSalesPrice: Record "Option Sales Price";
        OptionSalesDiscount: Record "Option Sales Discount";
        ToOptionSalesDiscount: Record "Option Sales Discount";
    begin
        // it supposed that record from is filtered, so need to take all records
        //11.04.2013 EDMS P8 >>
        if ManufacturerOption.FindFirst then
            repeat
                ToManufacturerOption := ManufacturerOption;
                ToManufacturerOption.Validate("Make Code", ToModelVersion."Make Code");
                ToManufacturerOption.Validate("Model Code", ToModelVersion."Model Code");
                ToManufacturerOption.Validate("Model Version No.", ToModelVersion."No.");
                ToManufacturerOption.Insert;
                // copy CONDITIONS
                ManufacturerOptionCondition.Reset;
                ManufacturerOptionCondition.SetRange("Make Code", ManufacturerOption."Make Code");
                ManufacturerOptionCondition.SetRange("Model Code", ManufacturerOption."Model Code");
                ManufacturerOptionCondition.SetRange("Model Version No.", ManufacturerOption."Model Version No.");
                ManufacturerOptionCondition.SetRange("Option Type", ManufacturerOption.Type);
                ManufacturerOptionCondition.SetRange("Option Code", ManufacturerOption."Option Code");
                if ManufacturerOptionCondition.FindFirst then
                    repeat
                        ToManufacturerOptionCondition := ManufacturerOptionCondition;
                        ToManufacturerOptionCondition.Validate("Make Code", ToModelVersion."Make Code");
                        ToManufacturerOptionCondition.Validate("Model Code", ToModelVersion."Model Code");
                        ToManufacturerOptionCondition.Validate("Model Version No.", ToModelVersion."No.");
                        ToManufacturerOptionCondition.Validate("Option Code", ManufacturerOption."Option Code");
                        ToManufacturerOptionCondition.Insert;
                    until ManufacturerOptionCondition.Next = 0;
                // copy "Option Translation"
                // Option Type,Make Code,Model Code,Model Version No.,Option Subtype,Option Code,Language Code
                OptionTranslation.Reset;
                OptionTranslation.SetRange("Option Type", OptionTranslation."option type"::"Manufacturer Option");
                OptionTranslation.SetRange("Make Code", ManufacturerOption."Make Code");
                OptionTranslation.SetRange("Model Code", ManufacturerOption."Model Code");
                OptionTranslation.SetRange("Model Version No.", ManufacturerOption."Model Version No.");
                OptionTranslation.SetRange("Option Subtype", ManufacturerOption.Type);
                OptionTranslation.SetRange("Option Code", ManufacturerOption."Option Code");
                if OptionTranslation.FindFirst then
                    repeat
                        ToOptionTranslation := OptionTranslation;
                        ToOptionTranslation.Validate("Make Code", ToModelVersion."Make Code");
                        ToOptionTranslation.Validate("Model Code", ToModelVersion."Model Code");
                        ToOptionTranslation.Validate("Model Version No.", ToModelVersion."No.");
                        ToOptionTranslation.Validate("Option Code", ManufacturerOption."Option Code");
                        ToOptionTranslation.Insert;
                    until OptionTranslation.Next = 0;
                // copy "Option Sales Price"
                //Make Code,Model Code,Model Version No.,Option Type,Option Subtype,Option Code,Sales Type,Sales Code,Starting Date,Currency Code
                OptionSalesPrice.Reset;
                OptionSalesPrice.SetRange("Make Code", ManufacturerOption."Make Code");
                OptionSalesPrice.SetRange("Model Code", ManufacturerOption."Model Code");
                OptionSalesPrice.SetRange("Model Version No.", ManufacturerOption."Model Version No.");
                OptionSalesPrice.SetRange("Option Type", OptionSalesPrice."option type"::"Manufacturer Option");
                OptionSalesPrice.SetRange("Option Subtype", ManufacturerOption.Type);
                OptionSalesPrice.SetRange("Option Code", ManufacturerOption."Option Code");
                if (SalesType >= 0) and (SalesType <> Salestype::None) then
                    OptionSalesPrice.SetRange("Sales Type", SalesType);
                if SalesCode <> '' then
                    OptionSalesPrice.SetRange("Sales Code", SalesCode);
                if Format(StartingDate) <> '' then
                    OptionSalesPrice.SetFilter("Starting Date", Format(StartingDate));
                if OptionSalesPrice.FindFirst then
                    repeat
                        ToOptionSalesPrice := OptionSalesPrice;
                        ToOptionSalesPrice.Validate("Make Code", ToModelVersion."Make Code");
                        ToOptionSalesPrice.Validate("Model Code", ToModelVersion."Model Code");
                        ToOptionSalesPrice.Validate("Model Version No.", ToModelVersion."No.");
                        ToOptionSalesPrice.Validate("Option Code", ManufacturerOption."Option Code");
                        ToOptionSalesPrice.Insert;
                    until OptionSalesPrice.Next = 0;
                // copy "Option Sales Discount"
                //Make Code,Model Code,Model Version No.,Option Type,Option Subtype,Option Code,Sales Type,Sales Code,Starting Date
                OptionSalesDiscount.Reset;
                OptionSalesDiscount.SetRange("Make Code", ManufacturerOption."Make Code");
                OptionSalesDiscount.SetRange("Model Code", ManufacturerOption."Model Code");
                OptionSalesDiscount.SetRange("Model Version No.", ManufacturerOption."Model Version No.");
                OptionSalesDiscount.SetRange("Option Type", OptionSalesDiscount."option type"::"Manufacturer Option");
                OptionSalesDiscount.SetRange("Option Subtype", ManufacturerOption.Type);
                OptionSalesDiscount.SetRange("Option Code", ManufacturerOption."Option Code");
                if (SalesType >= 0) and (SalesType <> Salestype::None) then
                    OptionSalesDiscount.SetRange("Sales Type", SalesType);
                if SalesCode <> '' then
                    OptionSalesDiscount.SetRange("Sales Code", SalesCode);
                if Format(StartingDate) <> '' then
                    OptionSalesDiscount.SetFilter("Starting Date", Format(StartingDate));
                if OptionSalesDiscount.FindFirst then
                    repeat
                        ToOptionSalesDiscount := OptionSalesDiscount;
                        ToOptionSalesDiscount.Validate("Make Code", ToModelVersion."Make Code");
                        ToOptionSalesDiscount.Validate("Model Code", ToModelVersion."Model Code");
                        ToOptionSalesDiscount.Validate("Model Version No.", ToModelVersion."No.");
                        ToOptionSalesDiscount.Validate("Option Code", ManufacturerOption."Option Code");
                        ToOptionSalesDiscount.Insert;
                    until OptionSalesDiscount.Next = 0;

            until ManufacturerOption.Next = 0;
    end;

    procedure GetServDocTypeUsage(ServiceHeader: Record "Service Header EDMS"): Enum "Report Selection Usage"
    var
        ReportSelections: Record "Report Selections";
        TypeUsage: Integer;
        IsHandled: Boolean;
    begin
        case ServiceHeader."Document Type" of
            ServiceHeader."Document Type"::Quote:
                exit(ReportSelections.Usage::"SM.Quote");
            ServiceHeader."Document Type"::Order:
                exit(ReportSelections.Usage::"SM.Order");
            ServiceHeader."Document Type"::"Return Order":
                exit(ReportSelections.Usage::"Serv. Return Order");
            //ServiceHeader."Document Type"::Booking:
            //     exit(ReportSelections.Usage::"SM.Quote");
            //   ServiceHeader."Document Type"::VHC:
            //  exit(ReportSelections.Usage::"SM.Quote");
            else begin
                IsHandled := false;
                if IsHandled then
                    exit("Report Selection Usage".FromInteger(TypeUsage));
                Error('');
            end;
        end;
    end;
    // From codeunit 99000886 "Capable to Promise"
    procedure RemoveReqLines(OrderPromisingType: Integer; OrderPromisingID: Code[20]; SourceLineNo: Integer; LastGoodLineNo: Integer; FilterOnNonAccepted: Boolean)
    var
        ReqLine: Record "Requisition Line";
    begin
        ReqLine.SetCurrentKey("Order Promising ID", "Order Promising Line ID", "Order Promising Line No.");
        ReqLine.SetRange("Order Promising Type", OrderPromisingType); //06.08.2008 EDMS P1
        ReqLine.SetRange("Order Promising ID", OrderPromisingID);
        if SourceLineNo <> 0 then
            ReqLine.SetRange("Order Promising Line ID", SourceLineNo);
        if LastGoodLineNo <> 0 then
            ReqLine.SetFilter("Order Promising Line No.", '>=%1', LastGoodLineNo);
        if FilterOnNonAccepted then
            ReqLine.SetRange("Accept Action Message", false);
        if ReqLine.Find('-') then
            repeat
                ReqLine.DeleteMultiLevel;
                ReqLine.Delete(true);
            until ReqLine.Next() = 0;
    end;

    // From 99000778 OrderTrackingManagement
    procedure SetServiceLine(var CurrentServiceLine: Record "Service Line EDMS")
    Var
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        ServiceLine: Record "Service Line EDMS";
        ReservEntry: Record "Reservation Entry";
        ReserveServiceLine: Codeunit "Service Line EDMS-Reserve";
        CaptionText: Text;
    begin
        CurrentServiceLine.TestField(Type, CurrentServiceLine.Type::Item);
        ServiceLine := CurrentServiceLine;
        ReservEntry."Source Type" := Database::"Service Line EDMS";

        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry, false);
        ReserveServiceLine.FilterReservFor(ReservEntry, ServiceLine);

        CaptionText := ReserveServiceLine.Caption(ServiceLine);
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnValidateSellToCustomerNoOnBeforeValidateLocationCode', '', false, false)]
    local procedure OnValidateSellToCustomerNoOnBeforeValidateLocationCode(var SalesHeader: Record "Sales Header"; var Cust: Record Customer; var IsHandled: Boolean);
    var
        Dimsource: List of [Dictionary of [Integer, code[20]]];
        DimMgt: Codeunit DimensionManagement;
    begin
        SalesHeader.SetUserDefaultValues();
        /* SalesHeader.CreateDim(
                      DATABASE::Customer, SalesHeader."Bill-to Customer No.",
                      DATABASE::"Salesperson/Purchaser", SalesHeader."Salesperson Code",
                      DATABASE::Campaign, SalesHeader."Campaign No.",
                      DATABASE::"Responsibility Center", SalesHeader."Responsibility Center",
                      DATABASE::"Customer Templ.", SalesHeader."Bill-to Customer Templ. Code") ;*/
        Clear(Dimsource);
        DimMgt.AddDimSource(Dimsource, DATABASE::Customer, SalesHeader."Bill-to Customer No.");
        DimMgt.AddDimSource(Dimsource, DATABASE::"Salesperson/Purchaser", SalesHeader."Salesperson Code");
        DimMgt.AddDimSource(Dimsource, Database::Campaign, SalesHeader."Campaign No.");
        DimMgt.AddDimSource(Dimsource, Database::"Responsibility Center", SalesHeader."Responsibility Center");
        DimMgt.AddDimSource(Dimsource, DATABASE::"Customer Templ.", SalesHeader."Bill-to Customer Templ. Code");
        SalesHeader.CreateDim(Dimsource);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Report Distribution Management", 'OnAfterGetFullDocumentTypeText', '', false, false)]
    local procedure OnAfterGetFullDocumentTypeText(DocumentVariant: Variant; var DocumentTypeText: Text[50]);
    var
        ServiceHeaderEDMS: Record "Service Header EDMS";
        DocumentRecordRef: RecordRef;
        ServiceInvoiceDocTypeTxt: Label 'Service Invoice';
        ServiceReturnOrderDocTypeTxt: Label 'Service Return Order';
        ServiceQuoteDocTypeTxt: Label 'Service Quote';
        ServiceOrderDocTypeTxt: Label 'Service Order';
    Begin
        if DocumentVariant.IsRecord then
            DocumentRecordRef.GetTable(DocumentVariant)
        else
            if DocumentVariant.IsRecordRef then
                DocumentRecordRef := DocumentVariant;
        case DocumentRecordRef.Number of
            DATABASE::"Service Header EDMS":
                begin
                    DocumentRecordRef.SetTable(ServiceHeaderEDMS);
                    case ServiceHeaderEDMS."Document Type" of
                        ServiceHeaderEDMS."Document Type"::Quote:
                            DocumentTypeText := ServiceQuoteDocTypeTxt;
                        ServiceHeaderEDMS."Document Type"::Order:
                            DocumentTypeText := ServiceOrderDocTypeTxt;
                        ServiceHeaderEDMS."Document Type"::Booking:
                            DocumentTypeText := ServiceQuoteDocTypeTxt;
                        ServiceHeaderEDMS."Document Type"::"Return Order":
                            DocumentTypeText := ServiceReturnOrderDocTypeTxt;
                    end;
                end;
        end;
    end;



    var
        FileManagement: Codeunit "File Management";
        DocumentPrint: codeunit "Document-Print";

    local procedure GetTimeStampForFileName(): Text
    begin
        exit(Format(CurrentDatetime, 0, '<Year,2><Month,2><Day,2><Hours24,2><Minutes,2><Seconds,2><Thousands,3>'));
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeArchiveSalesOfferAnalysis(DocumentNo: Code[20]; DocumentType: Integer; VersionNo: Integer; var IsHandled: Boolean)
    begin
    end;

}