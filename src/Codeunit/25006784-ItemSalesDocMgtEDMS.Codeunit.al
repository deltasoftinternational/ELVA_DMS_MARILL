Codeunit 25006784 "Item Sales Doc. Mgt. EDMS"
{
    // #Owner EDMS.Integration


    trigger OnRun()
    begin
    end;

    //>>Added for table "Sales Price Worksheet" function CalcCurrentPrice /17.02.2009 EDMS P1 
    [EventSubscriber(ObjectType::Table, Database::"Sales Price Worksheet", 'OnCalcCurrentPriceOnAfterSetFilters', '', false, false)]
    local procedure OnCalcCurrentPriceOnAfterSetFilters(var SalesPrice: Record "Sales Price"; SalesPriceWorksheet: Record "Sales Price Worksheet")

    begin
        if SalesPriceWorksheet."Type" = SalesPriceWorksheet."Type"::Item then begin
            SalesPrice.SetRange("Ordering Price Type Code", SalesPriceWorksheet."Ordering Price Type Code");
            SalesPrice.SetRange("Location Code", SalesPriceWorksheet."Location Code");
        end;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Cust. Ledger Entry", 'OnAfterCopyCustLedgerEntryFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyCustLedgerEntryFromGenJnlLine(GenJournalLine: Record "Gen. Journal Line"; var CustLedgerEntry: Record "Cust. Ledger Entry")
    begin
        CustLedgerEntry."Rent Order No." := GenJournalLine."Rent Order No.";                      // EB.P30 EDMS RENT
        CustLedgerEntry."Deal Type Code" := GenJournalLine."Deal Type Code";                      //20.08.2018 EB EDMS
        CustLedgerEntry."Document Profile" := GenJournalLine."Document Profile";                  //03.05.2019 EB.P7 EDMS
    end;

    //>>Added for table "Vendor Ledger Entry" function CopyFromGenJnlLine 
    [EventSubscriber(ObjectType::Table, Database::"Vendor Ledger Entry", 'OnAfterCopyVendLedgerEntryFromGenJnlLine', '', false, false)]
    local procedure CopyDealTypeCodeFromGenJnlLine(var VendorLedgerEntry: Record "Vendor Ledger Entry"; GenJournalLine: Record "Gen. Journal Line")
    begin
        VendorLedgerEntry."Deal Type Code" := GenJournalLine."Deal Type Code";                   //20.08.2018 EB EDMS
    end;

    [EventSubscriber(ObjectType::Table, Database::item, 'OnAfterValidateEvent', 'Profit %', false, false)]
    local procedure OnAfterValidateEventProfit(var Rec: Record Item; var xRec: Record Item)
    begin
        IF Rec."Profit %" <> xRec."Profit %" then
            IF REC."Profit %" > 100 then
                Error(Err01);
    end;

    [EventSubscriber(ObjectType::Table, Database::item, 'OnAfterValidateEvent', 'Item Category Code', false, false)]
    local procedure OnAfterValidateEventItemCategoryCode(var Rec: Record Item; var xRec: Record Item)
    var
        ProductSubgroup: Record "Product Subgroup";
        ItemCategory: Record "Item Category";
        ProductSubgrp: Record "Product Subgroup";
    begin
        //Upgrade 2017 >>
        if (Rec."Item Category Code" <> xRec."Item Category Code") or rec.GetNewEntryVariable() then begin
            //>>DELTA XX
            if rec.Type = rec.Type::Inventory then
                //<<DELTA XX
                if ItemCategory.Get(Rec."Item Category Code") then begin
                    //EDMS >>

                    Rec.Validate(Reserve, ItemCategory.Reserve);
                    Rec.Validate("Item Tracking Code", ItemCategory."Item Tracking Code");
                    //EDMS <<
                end;
        end;
        //Upgrade 2017 <<
    end;

    [EventSubscriber(ObjectType::Table, Database::item, 'OnBeforeOnInsert', '', false, false)]
    local procedure OnBeforeOnInsertItemModelVersion(var Item: Record Item; var IsHandled: Boolean)
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        if Item."Item Type" = Item."Item Type"::"Model Version" then begin
            IsHandled := true;
            DimMgt.UpdateDefaultDim(DATABASE::Item, Item."No.", Item."Global Dimension 1 Code", Item."Global Dimension 2 Code");
            Item.UpdateReferencedIds;
            Item.SetLastDateTimeModified;
        end;
    end;


    var
        Err01: Label 'The Maximum Value Allowed is 100';
        TempServLedgEntryEDMS: Record "Service Ledger Entry EDMS" temporary;
        TempDetServLedgEntryEDMS: Record "Det. Serv. Ledger Entry EDMS" temporary;
        PostingPreviewEventHandler: Codeunit "Posting Preview Event Handler";

        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        ServiceHeaderEDMS: Record "Service Header EDMS";
        ServJournalTemplate: Record "Serv. Journal Template";
        ExtServJournalTemplate: Record "Ext. Service Journal Template";
        ServJnlLine: Record "Serv. Journal Line";
        ExtServJnlLine: Record "External Serv. Journal Line";
        ReportSelection: Record "Report Selections";
        CustCheckCreditLimit: Page "Check Credit Limit";
        CustCheckCrLimit: Codeunit "Cust-Check Cr. Limit";
        OK: Boolean;
        Text000: label 'The update has been interrupted to respect the warning.';
        CreditLimitNotificationMsg: Label 'The customer''s credit limit has been exceeded.';
        OverdueBalanceNotificationMsg: Label 'This customer has an overdue balance.';
        GetDetailsTxt: Label 'Show details';
        OverdueBalanceNotificationDescriptionTxt: Label 'Show warning when a sales document is for a customer with an overdue balance.';
        InstructionMgt: Codeunit "Instruction Mgt.";

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnValidateSellToCustomerNoOnBeforeRecallModifyAddressNotification', '', false, false)]
    local procedure OnValidateSellToCustomerNoOnBeforeRecallModifyAddressNotification(var SalesHeader: Record "Sales Header"; xSalesHeader: Record "Sales Header")
    var
        Cust: Record Customer;
        ContBusRel: Record "Contact Business Relation";
    begin
        If SalesHeader."Sell-to Customer No." <> '' then begin
            if Cust.Get(SalesHeader."Sell-to Customer No.") then
                if Cust."Primary Contact No." = '' then begin
                    ContBusRel.Reset();
                    ContBusRel.SetCurrentKey("Link to Table", "No.");
                    ContBusRel.SetRange("Link to Table", ContBusRel."Link to Table"::Customer);
                    ContBusRel.SetRange("No.", SalesHeader."Sell-to Customer No.");
                    if ContBusRel.FindFirst then begin
                        //20.03.2013 EDMS >>
                        if (SalesHeader."Vehicle Serial No." = xSalesHeader."Vehicle Serial No.") and (not SalesHeader.GetFindCustomer()) then
                            SalesHeader.FindContVehicle;
                    end
                END;
        END
        Else begin
            if (SalesHeader."Vehicle Serial No." = xSalesHeader."Vehicle Serial No.") and (not SalesHeader.GetFindCustomer()) then
                SalesHeader.FindContVehicle();
        end
    END;


    /*   [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterCreateDimTableIDs', '', false, false)]
       local procedure OnAfterCreateDimTableIDsSalesHeader(var SalesHeader: Record "Sales Header"; CallingFieldNo: Integer; var TableID: array[10] of Integer; var No: array[10] of Code[20])
       begin
           if CallingFieldNo in [2, 4, 43, 104, 5050, 5054, 5700, 25006001, 25006378] then begin
               TableID[6] := Database::Vehicle;  //25.10.2013 EDMS P8
               No[6] := SalesHeader."Vehicle Serial No.";
               TableID[7] := Database::"Payment Method";
               No[7] := SalesHeader."Payment Method Code";
               // 26.03.2014 Elva Baltic P18 #RX027 MMG7.00 <<
               //27.03.2014 Elva Baltic P1 #RX MMG7.00 >>
               TableID[8] := Database::Location;
               No[8] := SalesHeader."Location Code";
               //27.03.2014 Elva Baltic P1 #RX MMG7.00 <<
               // 10.03.2015 EDMS P21 >>
               TableID[9] := Database::"Deal Type";
               No[9] := SalesHeader."Deal Type Code";
               // 10.03.2015 EDMS P21 <<
           end;
           if CallingFieldNo = 0 then begin
               TableID[6] := Database::Vehicle;
               No[6] := SalesHeader."Vehicle Serial No.";
               TableID[7] := Database::"Payment Method";
               No[7] := SalesHeader."Payment Method Code";
               TableID[8] := Database::"Deal Type";
               No[8] := SalesHeader."Deal Type Code";
               TableID[9] := Database::Location;
               No[9] := SalesHeader."Location Code";
           end;
       end;*/


    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnValidatePricesIncludingVATOnBeforeSalesLineModify', '', false, false)]
    local procedure OnValidatePricesIncludingVATOnBeforeSalesLineModify(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; Currency: Record Currency; RecalculatePrice: Boolean)
    var
        LicensePermission: Record "License Permission";
        VehPriceMgt: Codeunit "VehicleSalesPriceDiscountMgt";
    begin
        if not RecalculatePrice then begin
            //05.03.2010 EDMS P2 >>
            LicensePermission.SetRange("Object Type", LicensePermission."object type"::Codeunit);
            LicensePermission.SetRange("Object Number", Codeunit::VehicleSalesPriceDiscountMgt);
            LicensePermission.SetFilter("Execute Permission", '<>%1', LicensePermission."execute permission"::" ");
            if not LicensePermission.IsEmpty then
                VehPriceMgt.UpdAssemblyHdrField(SalesHeader, SalesLine, SalesHeader.FieldNo("Prices Including VAT"));   //23.11.2007 EDMS P3
        END;                                                                                                          //05.03.2010 EDMS P2 <<
    end;



    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterOnInsert', '', false, false)]
    local procedure OnAfterOnInsertSalesHeader(var SalesHeader: Record "Sales Header")
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.Get();
        //09.05.2008. EDMS P2 >>
        if SalesSetup."Compress Prepayment" then
            SalesHeader."Compress Prepayment" := true;
        //09.05.2008. EDMS P2 <<
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeTestNoSeries', '', false, false)]
    local procedure OnBeforeTestNoSeries(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    var
        SalesSetup: Record "Sales & Receivables Setup";
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        IsHandledDMS: Boolean;
    begin
        IsHandled := True;
        SalesSetup.Get();
        ServiceSetup.Get();
        OnBeforeTestNoSeriesEDMS(SalesHeader, IsHandledDMS);
        if not IsHandledDMS then begin
            case SalesHeader."Document Type" of
                SalesHeader."Document Type"::Quote:
                    SalesSetup.TestField("Quote Nos.");
                SalesHeader."Document Type"::Order:
                    SalesSetup.TestField("Order Nos.");
                SalesHeader."Document Type"::Invoice:
                    begin
                        //20.03.2013 EDMS >>
                        case SalesHeader."Document Profile" of
                            SalesHeader."document profile"::Service:
                                begin
                                    ServiceSetup.TestField("Invoice Nos.");
                                    ServiceSetup.TestField("Posted Invoice Nos.");
                                end
                            else begin
                                SalesSetup.TestField("Invoice Nos.");
                                SalesSetup.TestField("Posted Invoice Nos.");
                            end;
                        end;
                        //20.03.2013 EDMS <<
                    end;
                SalesHeader."Document Type"::"Return Order":
                    SalesSetup.TestField("Return Order Nos.");
                SalesHeader."Document Type"::"Credit Memo":
                    begin
                        //20.03.2013 EDMS >>
                        case SalesHeader."Document Profile" of
                            SalesHeader."document profile"::Service:
                                begin
                                    ServiceSetup.TestField("Credit Memo Nos.");
                                    ServiceSetup.TestField("Posted Credit Memo Nos.");
                                end
                            else begin
                                SalesSetup.TestField("Credit Memo Nos.");
                                SalesSetup.TestField("Posted Credit Memo Nos.");
                            end;
                        end;
                        //20.03.2013 EDMS <<
                    end;
                SalesHeader."Document Type"::"Blanket Order":
                    SalesSetup.TestField("Blanket Order Nos.");
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestNoSeriesEDMS(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterGetNoSeriesCode', '', false, false)]
    local procedure OnAfterGetNoSeriesCode(var SalesHeader: Record "Sales Header"; SalesReceivablesSetup: Record "Sales & Receivables Setup"; var NoSeriesCode: Code[20])
    var
        ServiceSetup: Record "Service Mgt. Setup EDMS";
    begin
        if ServiceSetup.Get() then;
        case SalesHeader."Document Type" of
            SalesHeader."Document Type"::Invoice:
                begin
                    //20.03.2013 EDMS <<
                    case SalesHeader."Document Profile" of
                        SalesHeader."document profile"::Service:
                            NoSeriesCode := ServiceSetup."Invoice Nos.";
                    //20.03.2013 EDMS >>
                    end;
                end;
            SalesHeader."Document Type"::"Credit Memo":
                begin
                    //20.03.2013 EDMS >>
                    case SalesHeader."Document Profile" of
                        SalesHeader."document profile"::Service:
                            NoSeriesCode := ServiceSetup."Credit Memo Nos.";
                    end;
                    //20.03.2013 EDMS >>
                end;
        END;
    END;


    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterGetPostingNoSeriesCode', '', false, false)]
    local procedure OnAfterGetPostingNoSeriesCodeGetPostingNoSeriesCode(SalesHeader: Record "Sales Header"; var PostingNos: Code[20])
    var
        ServiceSetup: Record "Service Mgt. Setup EDMS";
    begin
        if ServiceSetup.Get() Then;
        //20.03.2013 EDMS <<
        if SalesHeader.IsCreditDocType then begin
            if SalesHeader."Document Profile" = SalesHeader."document profile"::Service then
                PostingNos := ServiceSetup."Posted Credit Memo Nos."
        end
        else
            if SalesHeader."Document Profile" = SalesHeader."document profile"::Service then
                PostingNos := ServiceSetup."Posted Invoice Nos."
        //20.03.2013 EDMS >>
    end;


    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnCreateSalesLineOnAfterAssignType', '', false, false)]
    local procedure OnCreateSalesLineOnAfterAssignType(var SalesLine: Record "Sales Line"; var TempSalesLine: Record "Sales Line" temporary)
    begin
        if TempSalesLine."No." <> '' then
            SalesLine."Line Type" := TempSalesLine."Line Type"; //05.05.2016 EB.P7 #T084
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeSalesLineInsert', '', false, false)]
    local procedure OnBeforeSalesLineInsert(var SalesLine: Record "Sales Line"; var TempSalesLine: Record "Sales Line" temporary; SalesHeader: Record "Sales Header")
    begin
        //23.11.2007 EDMS P3 >>
        SalesLine."Document Profile" := TempSalesLine."Document Profile";
        SalesLine."Make Code" := TempSalesLine."Make Code";
        SalesLine."Model Code" := TempSalesLine."Model Code";
        SalesLine."Model Version No." := TempSalesLine."Model Version No.";
        SalesLine."Service Order Line No. EDMS" := TempSalesLine."Service Order Line No. EDMS"; //10.08.06 AB
        SalesLine."Order Line Type No." := TempSalesLine."Order Line Type No.";
        //23.01.2013 EDMS P8 >>
        SalesLine."Contract No." := SalesHeader."Contract No.";                                             // 17.04.2014 Elva Baltic P21
        if SalesHeader."Document Profile" = SalesHeader."document profile"::"Spare Parts Trade" then begin
            SalesLine.Validate("Vehicle Serial No.", SalesHeader."Vehicle Serial No.");
        end else begin
            SalesLine.VIN := TempSalesLine.VIN;
            SalesLine."Vehicle Serial No." := TempSalesLine."Vehicle Serial No.";
            SalesLine."Vehicle Accounting Cycle No." := TempSalesLine."Vehicle Accounting Cycle No.";
            SalesLine."Vehicle Assembly ID" := TempSalesLine."Vehicle Assembly ID";
            SalesLine."Vehicle Status Code" := TempSalesLine."Vehicle Status Code";
        end;
        //23.01.2013 EDMS P8 <<
        SalesLine."Variable Field 25006800" := TempSalesLine."Variable Field 25006800";
        SalesLine."Variable Field 25006801" := TempSalesLine."Variable Field 25006801";
        SalesLine."Variable Field 25006802" := TempSalesLine."Variable Field 25006802";
        //23.11.2007 EDMS P3 <<

        SalesLine."Ordering Price Type Code" := SalesHeader."Ordering Price Type Code";   // 07/09/2018 EB.P30
    end;


    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnValidateTypeOnCopyFromTempPurchLine', '', false, false)]
    local procedure OnValidateTypeOnCopyFromTempPurchLineCopyDocumentProfile(var PurchLine: Record "Purchase Line"; TempPurchaseLine: Record "Purchase Line" temporary)
    begin
        //EDMS1.0.00 >>
        PurchLine."Document Profile" := TempPurchaseLine."Document Profile";
        //EDMS1.0.00 <<
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnValidateNoOnAfterChecks', '', false, false)]
    local procedure OnValidateNoOnAfterChecks(var PurchaseLine: Record "Purchase Line"; xPurchaseLine: Record "Purchase Line"; CallingFieldNo: Integer)
    var
        TempReservEntry: Record "Reservation Entry" temporary;
        ReservePurchLine: Codeunit "Purch. Line-Reserve";
        PurchLineReserve: Codeunit "Purch. Line-Reserve";
        ReservationManagementEDMS: Codeunit "Reservation Management EDMS";

    begin


        // Check Verify Change
        if PurchaseLine."No." <> xPurchaseLine."No." then begin
            if (PurchaseLine.Quantity <> 0) and PurchaseLine.ItemExists(xPurchaseLine."No.") then begin
                // 26.03.2014 Elva Baltic P21 >>
                PurchaseLine.CalcFields("Reserved Qty. (Base)");
                if (PurchaseLine."Reserved Qty. (Base)" <> 0) and (PurchaseLine."No." <> '') then begin         // 04.04.2014 Elva Baltic P21
                    ReservationManagementEDMS.UpdateReservAfterItemNoChange(PurchaseLine, xPurchaseLine, TempReservEntry);
                    PurchaseLine."Item No. Changed" := true;
                end;
                // 26.03.2014 Elva Baltic P21 <<

                PurchLineReserve.VerifyChange(PurchaseLine, xPurchaseLine);
                PurchaseLine.CalcFields("Reserved Qty. (Base)");
                PurchaseLine.TestField("Reserved Qty. (Base)", 0);

                if PurchaseLine."Item No. Changed" then                                          // 26.03.2014 Elva Baltic P21
                    ReservationManagementEDMS.CopyReservEntryFromTemp(PurchaseLine, TempReservEntry);              // 26.03.2014 Elva Baltic P21
            END;
        END;
    END;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnValidateNoOnCopyFromTempPurchLine', '', false, false)]
    local procedure OnValidateNoOnCopyFromTempPurchLine(var PurchLine: Record "Purchase Line"; TempPurchaseLine: Record "Purchase Line" temporary; xPurchLine: Record "Purchase Line")
    var
        UserProfileMgt: Codeunit UserProfileManagement;
        UserProfile: Record "Branch Profile Setup";
    begin

        PurchLine."Item No. Changed" := TempPurchaseLine."Item No. Changed";                            // 26.03.2014 Elva Baltic P21
        PurchLine."Line Type" := TempPurchaseLine."Line Type";
        PurchLine."Document Profile" := TempPurchaseLine."Document Profile";
        PurchLine."Make Code" := TempPurchaseLine."Make Code";
        PurchLine."Model Code" := TempPurchaseLine."Model Code";
        PurchLine."Model Version No." := TempPurchaseLine."Model Version No.";
        PurchLine."Line Type" := TempPurchaseLine."Line Type";
        PurchLine."Deal Type Code" := TempPurchaseLine."Deal Type Code";
        PurchLine."Vehicle Serial No." := TempPurchaseLine."Vehicle Serial No.";
        PurchLine."Vehicle Accounting Cycle No." := TempPurchaseLine."Vehicle Accounting Cycle No.";
        PurchLine."Vehicle Status Code" := TempPurchaseLine."Vehicle Status Code";
        //16.03 2016 EB.P7 Branch Setup >>
        if PurchLine."Vehicle Status Code" = '' then
            if UserProfileMgt.CurrProfileID <> '' then
                if UserProfile.Get(UserProfileMgt.CurrProfileID, UserProfileMgt.CurrBranchNo) then
                    if UserProfile."Default Vehicle Status" <> '' then
                        PurchLine.Validate("Vehicle Status Code", UserProfile."Default Vehicle Status");
        //16.03 2016 EB.P7 Branch Setup <<
        PurchLine."External Serv. Tracking No." := TempPurchaseLine."External Serv. Tracking No.";
        if PurchLine."Line Type" = PurchLine."line type"::Vehicle then
            if PurchLine."No." = '' then begin
                PurchLine."Model Version No." := '';
                PurchLine."Vehicle Serial No." := '';
            end;
        //EDMS1.0.00 <<
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterAssignHeaderValues', '', false, false)]
    local procedure OnAfterAssignHeaderValues(var PurchLine: Record "Purchase Line"; PurchHeader: Record "Purchase Header")
    var
        ItemCharge: Record "Item Charge";
    begin
        case PurchLine.Type of
            PurchLine.Type::"Charge (Item)":
                begin
                    ItemCharge.Get(PurchLine."No.");
                    PurchLine."Posting Group" := ItemCharge."Inventory Posting Group"; //EDMS
                end;
            //21/05/2018 >>
            PurchLine.Type::"External Service":
                PurchLine.CopyFromExternalService();
        //21/05/2018 <<
        end;
    END;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnValidateNoOnAfterAssignQtyFromXRec', '', false, false)]
    local procedure OnValidateNoOnAfterAssignQtyFromXRec(var PurchaseLine: Record "Purchase Line"; TempPurchaseLine: Record "Purchase Line" temporary)
    begin
        //EDMS1.0.00 >>
        if PurchaseLine."Line Type" = PurchaseLine."line type"::Vehicle then
            PurchaseLine.Quantity := 1;
        //EDMS1.0.00 <<
    END;


    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnValidateNoOnBeforeInitHeaderDefaults', '', false, false)]
    local procedure OnValidateNoOnBeforeInitHeaderDefaults(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var TempSalesLine: Record "Sales Line" temporary);
    begin
        if SalesLine."Line Type" = SalesLine."line type"::Vehicle then
            SalesLine.Quantity := 1;
    end;



    /*[EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterCreateDimTableIDs', '', false, false)]
    local procedure OnAfterCreateDimTableIDs(var PurchLine: Record "Purchase Line"; CallingFieldNo: Integer; var TableID: array[10] of Integer; var No: array[10] of Code[20])
    var
        DimMgt: Codeunit DimensionManagement;
    begin
        /*If CallingFieldNo In [6, 7] then begin
            //EDMS1.0.00 <<
            TableID[2] := Database::"Vehicle Status";
            No[2] := PurchLine."Vehicle Status Code";
            TableID[5] := Database::Make;
            No[5] := PurchLine."Make Code";
            TableID[6] := Database::Vehicle;
            No[6] := PurchLine."Vehicle Serial No.";
            TableID[7] := Database::Location;
            No[7] := PurchLine."Location Code";
            TableID[8] := Database::"Deal Type";
            No[8] := PurchLine."Deal Type Code";
            //EDMS1.0.00 >>
        end;
        If CallingFieldNo In [45] then begin
            TableID[1] := Database::"Vehicle Status";
            No[1] := PurchLine."Vehicle Status Code";
            TableID[2] := DimMgt.TypeToTableID3(PurchLine.Type.AsInteger());
            No[2] := PurchLine."No.";
            TableID[3] := Database::"Responsibility Center";
            No[3] := PurchLine."Responsibility Center";
            TableID[4] := Database::"Work Center";
            No[4] := PurchLine."Work Center No.";
            TableID[5] := Database::Make;
            No[5] := PurchLine."Make Code";
            TableID[6] := Database::Vehicle;
            No[6] := PurchLine."Vehicle Serial No.";
            TableID[7] := Database::Location;
            No[7] := PurchLine."Location Code";
            TableID[8] := Database::"Deal Type";
            No[8] := PurchLine."Deal Type Code";
            //EDMS1.0.00 >>
        end;
        If CallingFieldNo In [1001, 25006001, 25006370, 25006375, 25006380] then begin
            //EDMS1.0.00 <<
            TableID[5] := Database::Make;
            No[5] := PurchLine."Make Code";
            TableID[6] := Database::Vehicle;
            No[6] := PurchLine."Vehicle Serial No.";
            TableID[7] := Database::Location;
            No[7] := PurchLine."Location Code";
            TableID[8] := Database::"Deal Type";
            No[8] := PurchLine."Deal Type Code";
            //EDMS1.0.00 >>
        end;
        If CallingFieldNo In [5700] then begin
            //EDMS1.0.00 <<
            TableID[3] := Database::"Vehicle Status";
            No[3] := PurchLine."Vehicle Status Code";
            TableID[4] := Database::"Work Center";
            No[4] := PurchLine."Work Center No.";
            TableID[5] := Database::Make;
            No[5] := PurchLine."Make Code";
            TableID[6] := Database::Vehicle;
            No[6] := PurchLine."Vehicle Serial No.";
            TableID[7] := Database::Location;
            No[7] := PurchLine."Location Code";
            TableID[8] := Database::"Deal Type";
            No[8] := PurchLine."Deal Type Code";
            //EDMS1.0.00 >>
        end;
        If CallingFieldNo In [99000752] then begin
            //EDMS1.0.00 <<
            TableID[3] := Database::"Vehicle Status";
            No[3] := PurchLine."Vehicle Status Code";
            TableID[5] := Database::Make;
            No[5] := PurchLine."Make Code";
            TableID[6] := Database::Vehicle;
            No[6] := PurchLine."Vehicle Serial No.";
            TableID[7] := Database::Location;
            No[7] := PurchLine."Location Code";
            TableID[8] := Database::"Deal Type";
            No[8] := PurchLine."Deal Type Code";
            //EDMS1.0.00 >>
        end;
    END;
    */


    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeValidateDescription', '', false, false)]
    local procedure OnBeforeValidateDescription(var PurchaseLine: Record "Purchase Line"; xPurchaseLine: Record "Purchase Line"; CurrentFieldNo: Integer; var InHandled: Boolean)
    var
        ReturnValue: Text[50];
        FindRecordMgt: Codeunit "Find Record Management";
    begin
        If (PurchaseLine.Type <> PurchaseLine.Type::" ") and (PurchaseLine.Type <> PurchaseLine.Type::Item) AND (PurchaseLine."No." = '') then begin
            ReturnValue := FindNoByDescriptionDLT(PurchaseLine.Type.AsInteger(), PurchaseLine.Description, true);
            if ReturnValue <> '' then begin
                CurrentFieldNo := PurchaseLine.FieldNo("No.");
                PurchaseLine.Validate("No.", CopyStr(ReturnValue, 1, MaxStrLen(PurchaseLine."No.")));
            end;
        end;
    END;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnValidateQuantityOnBeforeDropShptCheck', '', false, false)]
    local procedure OnValidateQuantityOnBeforeDropShptCheck(var PurchaseLine: Record "Purchase Line"; xPurchaseLine: Record "Purchase Line")
    var
        ItemSubstSync: Codeunit "Item Substitution Sync";
    begin
        ItemSubstSync.ReplacePurchaseLineItemNo(PurchaseLine);
        //09.05.2008. EDMS P2 >>
        if (PurchaseLine."Line Type" = PurchaseLine."line type"::Vehicle) and (PurchaseLine.Quantity > 1) then
            PurchaseLine.TestField(Quantity, 1);
        //09.05.2008. EDMS P2 <<
    END;


    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnDeleteOnBeforeCheckQtyNotInvoiced', '', false, false)]
    local procedure OnDeleteOnBeforeCheckQtyNotInvoiced(var PurchaseLine: Record "Purchase Line"; var IsHandled: Boolean)
    var
        VehReservePurchLine: Codeunit "Purch. Line-Veh. Reserve";
    begin
        //26.02.2008 EDMS P1 >>
        if PurchaseLine."Line Type" = PurchaseLine."line type"::Vehicle then
            VehReservePurchLine.DeleteLine(PurchaseLine);
        //26.02.2008 EDMS P1 <<	  
    END;


    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeUpdatePrepmtSetupFields', '', false, false)]
    local procedure OnBeforeUpdatePrepmtSetupFields(var PurchaseLine: Record "Purchase Line"; var IsHandled: Boolean)
    var
        GenPostingSetup: Record "General Posting Setup";
        GLAcc: Record "G/L Account";
        GenLedgSetup: Record "General Ledger Setup";
        VATPostingSetup: Record "VAT Posting Setup";
        CannotChangePrepmtAmtDiffVAtPctErr: Label 'You cannot change the prepayment amount because the prepayment invoice has been posted with a different VAT percentage. Please check the settings on the prepayment G/L account.';

    begin
        IsHandled := true;
        if (PurchaseLine."Prepayment %" <> 0) and PurchaseLine.HasTypeToFillMandatoryFields then begin
            PurchaseLine.TestField("Document Type", PurchaseLine."Document Type"::Order);
            PurchaseLine.TestField("No.");
            GenLedgSetup.Get; //20.03.2013 EDMS
            GenPostingSetup.Get(PurchaseLine."Gen. Bus. Posting Group", PurchaseLine."Gen. Prod. Posting Group");
            GenPostingSetup.TestField("Purch. Prepayments Account"); //20.03.2013 EDMS

            if GenPostingSetup."Purch. Prepayments Account" <> '' then begin
                //20.03.2013 EDMS >>
                if GenLedgSetup."Calc.Prepmt.VAT by Line PostGr" then
                    VATPostingSetup.Get(PurchaseLine."VAT Bus. Posting Group", PurchaseLine."VAT Prod. Posting Group")
                else begin
                    //20.03.2013 EDMS <<
                    GLAcc.Get(GenPostingSetup."Purch. Prepayments Account");
                    VATPostingSetup.Get(PurchaseLine."VAT Bus. Posting Group", GLAcc."VAT Prod. Posting Group");
                    VATPostingSetup.TestField("VAT Calculation Type", PurchaseLine."VAT Calculation Type");
                end //20.03.2013 EDMS
            end else
                Clear(VATPostingSetup);
            if (PurchaseLine."Prepayment VAT %" <> 0) and (PurchaseLine."Prepayment VAT %" <> VATPostingSetup."VAT %") and (PurchaseLine."Prepmt. Amt. Inv." <> 0) then
                Error(CannotChangePrepmtAmtDiffVAtPctErr);
            PurchaseLine."Prepayment VAT %" := VATPostingSetup."VAT %";
            PurchaseLine."Prepmt. VAT Calc. Type" := VATPostingSetup."VAT Calculation Type";
            PurchaseLine."Prepayment VAT Identifier" := VATPostingSetup."VAT Identifier";
            if PurchaseLine."Prepmt. VAT Calc. Type" in
               [PurchaseLine."Prepmt. VAT Calc. Type"::"Reverse Charge VAT", PurchaseLine."Prepmt. VAT Calc. Type"::"Sales Tax"]
            then
                PurchaseLine."Prepayment VAT %" := 0;
            PurchaseLine."Prepayment Tax Group Code" := GLAcc."Tax Group Code";
        end;
    END;


    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeAddItems', '', false, false)]
    local procedure OnBeforeAddItems(var PurchaseLine: Record "Purchase Line"; SelectionFilter: Text; var IsHandled: Boolean)
    var
        Item: Record Item;
    begin
        IsHandled := True;
        // PurchaseLine.InitNewLine(PurchLine);
        Item.SetFilter("No.", SelectionFilter);
        if Item.FindSet() then
            repeat
                PurchaseLine.AddItemElva(PurchaseLine, Item."No.");
            until Item.Next() = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnBeforeUpdateLeadTimeFields', '', false, false)]
    local procedure OnBeforeUpdateLeadTimeFields(var PurchaseLine: Record "Purchase Line"; var IsHandled: Boolean)
    var
        OrderingPriceType: Record "Ordering Price Type";
        PurchHeader: Record "Purchase Header";
        LeadTimeMgt: Codeunit "Lead-Time Management";
    begin
        if PurchaseLine.Type = PurchaseLine.Type::Item then begin
            //20.03.2013 EDMS >>
            if (PurchaseLine."Ordering Price Type Code" <> '') and OrderingPriceType.Get(PurchaseLine."Ordering Price Type Code") then
                PurchaseLine."Lead Time Calculation" := OrderingPriceType."Inbound Time"
            else
                Evaluate(PurchaseLine."Lead Time Calculation",
                  LeadTimeMgt.PurchaseLeadTime(
                  PurchaseLine."No.", PurchaseLine."Location Code", PurchaseLine."Variant Code",
                  PurchaseLine."Buy-from Vendor No."));
            //20.03.2013 EDMS <<
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Nonstock Item", 'OnBeforeValidateVendorNo', '', false, false)]
    local procedure OnBeforeValidateVendorNo(var NonstockItem: Record "Nonstock Item"; xNonstockItem: Record "Nonstock Item"; var IsHandled: Boolean)
    var
        Text001: Label 'Modification not allowed, item record already exists.';
        Text002: Label 'No.=<%1> and Vendor Item No.=<%2> already exists.';
    begin
        IsHandled := True;
        if (NonstockItem."Vendor No." <> xNonstockItem."Vendor No.") and (NonstockItem."Vendor Item No." <> '') then
            if NonstockItem.CheckVendorItemNo(NonstockItem."Vendor No.", NonstockItem."Vendor Item No.") then
                Error(Text002, NonstockItem."Vendor No.", NonstockItem."Vendor Item No.");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Nonstock Item", 'OnModifyOnBeforeError', '', false, false)]
    local procedure OnModifyOnBeforeError(var NonstockItem: Record "Nonstock Item"; var IsHandled: Boolean)
    begin
        IsHandled := True;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Line", 'OnValidateItemNoOnCopyFromTempTransLine', '', false, false)]
    local procedure OnValidateItemNoOnCopyFromTempTransLine(var TransferLine: Record "Transfer Line"; TempTransferLine: Record "Transfer Line" temporary)
    var
        TransferRoute: Record "Transfer Route";
    begin
        //EDMS1.0.00 >>
        TransferLine.VIN := TempTransferLine.VIN;
        TransferLine."Make Code" := TempTransferLine."Make Code";
        TransferLine."Model Code" := TempTransferLine."Model Code";
        TransferLine."Model Version No." := TempTransferLine."Model Version No.";
        TransferLine."Vehicle Serial No." := TempTransferLine."Vehicle Serial No.";
        TransferLine."Vehicle Accounting Cycle No." := TempTransferLine."Vehicle Accounting Cycle No.";
        TransferLine."Vehicle Assembly ID" := TempTransferLine."Vehicle Assembly ID";
        TransferLine."Vehicle Status Code" := TempTransferLine."Vehicle Status Code";
        //29.04.2014 Elva Baltic P8 #F037 MMG7.00 >>
        if TransferLine."Vehicle Status Code" = '' then
            TransferLine."Vehicle Status Code" := TransferRoute.GetVehicleStatusCode(TransferLine."Transfer-from Code", TransferLine."Transfer-to Code");
        //29.04.2014 Elva Baltic P8 #F037 MMG7.00 <<
        TransferLine."Document Profile" := TempTransferLine."Document Profile";
        //EDMS1.0.00 <<
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Line", 'OnAfterAssignItemValues', '', false, false)]
    local procedure OnAfterAssignItemValues(var TransferLine: Record "Transfer Line"; Item: Record Item)
    var
        TransHeader: Record "Transfer Header";
    Begin
        if TransferLine."Document Profile" = TransferLine."document profile"::"Vehicles Trade" then
            TransferLine.Validate(Quantity, 1);
        TransHeader.Get(TransferLine."Document No.");
        //23.07.08 EDMS P1>>
        TransferLine."Source Type" := TransHeader."Source Type";
        if TransHeader."Source Type" = Database::"Service Header EDMS" then
            TransferLine."Source Type" := Database::"Service Line EDMS";
        TransferLine."Source Subtype" := TransHeader."Source Subtype";
        TransferLine."Source No." := TransHeader."Source No.";
        //23.07.08 EDMS P1<<
    End;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Line", 'OnDeleteOnBeforeDeleteRelatedData', '', false, false)]
    local procedure OnDeleteOnBeforeDeleteRelatedData(var TransferLine: Record "Transfer Line")
    var
        Text109: label '%1 with %2 has reservation, delete/cancel it first.';
    begin
        //15.07.2013 EDMS P8 >>
        if TransferLine."Document Profile" = TransferLine."document profile"::"Vehicles Trade" then begin
            if TransferLine.GetReservedQtyVeh('', true, 0, false) <> 0 then
                Error(Text109, TransferLine.TableCaption, TransferLine."Document No." + ' ' + Format(TransferLine."Line No.") + ';');
        end;
        //15.07.2013 EDMS P8 <<
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Receipt Header", 'OnAfterCopyFromTransferHeader', '', false, false)]
    local procedure OnAfterCopyFromTransferHeader(var TransferReceiptHeader: Record "Transfer Receipt Header"; TransferHeader: Record "Transfer Header")
    var
    begin
        //20.01.2017 EDMS >>
        //"No." := TransHeader."No.";
        TransferReceiptHeader."Source Type" := TransferHeader."Source Type";
        TransferReceiptHeader."Source Subtype" := TransferHeader."Source Subtype";
        TransferReceiptHeader."Source No." := TransferHeader."Source No.";
        TransferReceiptHeader."Document Profile" := TransferHeader."Document Profile";
        //20.01.2017 EDMS <<
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Receipt Line", 'OnAfterCopyFromTransferLine', '', false, false)]
    local procedure OnAfterCopyFromTransferLine(var TransferReceiptLine: Record "Transfer Receipt Line"; TransferLine: Record "Transfer Line")
    var
        Vehicle: Record Vehicle;
    begin
        //20.01.2017 EDMS Upgrade 2017 >>
        if TransferLine."To Location Dimension 1 Code" <> '' then
            TransferReceiptLine."Shortcut Dimension 1 Code" := TransferLine."To Location Dimension 1 Code"
        else
            TransferReceiptLine."Shortcut Dimension 1 Code" := TransferLine."Shortcut Dimension 1 Code";
        if TransferLine."To Location Dimension 2 Code" <> '' then
            TransferReceiptLine."Shortcut Dimension 2 Code" := TransferLine."To Location Dimension 2 Code"
        else
            TransferReceiptLine."Shortcut Dimension 2 Code" := TransferLine."Shortcut Dimension 2 Code";

        TransferReceiptLine."Document Profile" := TransferReceiptLine."Document Profile";
        TransferReceiptLine."Make Code" := TransferLine."Make Code";
        TransferReceiptLine."Model Code" := TransferLine."Model Code";
        TransferReceiptLine."Model Version No." := TransferLine."Model Version No.";
        TransferReceiptLine.VIN := TransferLine.VIN;
        TransferReceiptLine."Vehicle Serial No." := TransferLine."Vehicle Serial No.";
        TransferReceiptLine."Vehicle Accounting Cycle No." := TransferLine."Vehicle Accounting Cycle No.";
        TransferReceiptLine."Vehicle Status Code" := TransferLine."Vehicle Status Code";
        if Vehicle.Get(TransferLine."Vehicle Serial No.") then begin
            Vehicle.Validate("Status Code", TransferReceiptLine."Vehicle Status Code");
            Vehicle.Modify;
        end;
        //20.01.2017 EDMS Upgrade 2017 <<
    end;

    // -------------------------------------- Codeunit 20 "Gen. Jnl.-Post Preview" ---------------------------------------------


    [EventSubscriber(ObjectType::Table, Database::"Service Ledger Entry EDMS", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnInsertServiceLedgerEDMSEntry(var Rec: Record "Service Ledger Entry EDMS"; RunTrigger: Boolean)
    var

    begin
        if Rec.IsTemporary then
            exit;

        //PreventCommit;
        TempServLedgEntryEDMS := Rec;
        TempServLedgEntryEDMS."Document No." := '***';
        TempServLedgEntryEDMS.Insert;
    end;


    [EventSubscriber(ObjectType::Table, Database::"Det. Serv. Ledger Entry EDMS", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnInsertDetailedServiceLedgerEDMSEntry(var Rec: Record "Det. Serv. Ledger Entry EDMS"; RunTrigger: Boolean)
    var

    begin
        if Rec.IsTemporary then
            exit;

        //PreventCommit;
        TempDetServLedgEntryEDMS := Rec;
        TempDetServLedgEntryEDMS."Document No." := '***';
        TempDetServLedgEntryEDMS.Insert;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Posting Preview Event Handler", 'OnAfterShowEntries', '', False, False)]
    local procedure OnAfterShowEntriesShowEntriesService(TableNo: Integer)
    begin
        case TableNo of
            DATABASE::"Service Ledger Entry EDMS":
                PAGE.RUN(PAGE::"Serv. Ledg. Entr. EDMS Preview", TempServLedgEntryEDMS);
            DATABASE::"Det. Serv. Ledger Entry EDMS":
                PAGE.RUN(PAGE::"Det. Serv. LE. EDMS Preview", TempDetServLedgEntryEDMS);
        END;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Posting Preview Event Handler", 'OnAfterFillDocumentEntry', '', False, False)]
    local procedure OnAfterFillDocumentEntryFillDocumentEntryService(var DocumentEntry: Record "Document Entry" temporary)
    begin
        PostingPreviewEventHandler.InsertDocumentEntry(TempServLedgEntryEDMS, DocumentEntry);
        PostingPreviewEventHandler.InsertDocumentEntry(TempDetServLedgEntryEDMS, DocumentEntry);
    end;


    // -------------------------------------- Codeunit 46 SelectionFilterManagement ---------------------------------------------
    // 14.01.2014 EDMS P8
    //   * Added function GetSelectionFilterForServicePackage
    // 
    // 22.08.2013 EDMS P8
    //   * Added fenction GetSelectionFilterForLaborDiscountGroup

    procedure GetSelectionFilterForLaborDiscountGroup(var LaborDiscountGroup: Record "Service Labor Discount Group"): Text
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(LaborDiscountGroup);
        exit(SelectionFilterManagement.GetSelectionFilter(RecRef, LaborDiscountGroup.FieldNo(Code)));
    end;

    procedure GetSelectionFilterForServicePackage(var ServicePackage: Record "Service Package"): Text
    var
        RecRef: RecordRef;
    begin
        RecRef.GetTable(ServicePackage);
        exit(SelectionFilterManagement.GetSelectionFilter(RecRef, ServicePackage.FieldNo("No.")));
    end;


    // -------------------------------------- Codeunit 86 "Sales-Quote to Order" ---------------------------------------------
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Quote to Order", 'OnBeforeDeleteSalesQuote', '', False, False)]
    local procedure OnBeforeDeleteSalesQuoteModifyCheckList(var QuoteSalesHeader: Record "Sales Header"; var OrderSalesHeader: Record "Sales Header")
    Var
        ProcessChecklist: Record "Process Checklist Header";
        Opp: Record Opportunity;
        OpportunityEntry: Record "Opportunity Entry";
    begin
        Opp.Reset();
        Opp.SetCurrentKey("Sales Document Type", "Sales Document No.");
        Opp.SetRange("Sales Document Type", Opp."Sales Document Type"::Quote);
        Opp.SetRange("Sales Document No.", QuoteSalesHeader."No.");
        if Opp.FindFirst then
            if Opp.Status = Opp.Status::Won then begin
                OpportunityEntry.Reset();
                OpportunityEntry.SetCurrentKey(Active, "Opportunity No.");
                OpportunityEntry.SetRange(Active, true);
                OpportunityEntry.SetRange("Opportunity No.", Opp."No.");
                if OpportunityEntry.FindFirst then begin
                    OpportunityEntry."Calcd. Current Value" := OpportunityEntry.GetSalesDocValue2(OrderSalesHeader);
                    OpportunityEntry.Modify();
                END;
            END;

        // Checklists RC >>
        ProcessChecklist.Reset;
        ProcessChecklist.SetRange("Source Profile", QuoteSalesHeader."Document Profile");
        ProcessChecklist.SetRange("Source Type", Database::"Sales Header");
        ProcessChecklist.SetRange("Source Subtype", QuoteSalesHeader."Document Type");
        ProcessChecklist.SetRange("Source ID", QuoteSalesHeader."No.");
        if ProcessChecklist.FindFirst then begin
            ProcessChecklist."Source Subtype" := OrderSalesHeader."Document Type";
            ProcessChecklist."Source ID" := OrderSalesHeader."No.";
            ProcessChecklist.Modify;
        end;
        // Checklists RC <<
    END;

    // ---------------------------------------------- codeunit 228 "Test Report-Print" ------------------------------------------------------ //
    // 18.01.2017 EDMS P7 Upgrade 2017
    //   Function PrintReport Added.
    // 
    // 12.02.2013 EDMS P8
    //   * Fix in function PrintServiceHeaderPrepmt
    // 
    // 15.10.2012 EDMS P8
    //   * Added functions: PrintServJnlBatch, PrintExtServJnlBatch, PrintServJnlLine, PrintExtServJnlLine
    // 
    // 12.03.2010 EDMS P2
    //   * Added function PrintServiceHeaderPrepmt
    // 
    // //08-05-2007 EDMS P3 PREPMT
    //   Added functions to maintain prepayments

    procedure PrintReport(ReportUsage: Integer)
    begin
        ReportSelection.Reset;
        ReportSelection.SetRange(Usage, ReportUsage);
        ReportSelection.Find('-');
        repeat
            ReportSelection.TestField("Report ID");
            case ReportUsage of
                ReportSelection.Usage::"P.Arch.Order".AsInteger(),
              ReportSelection.Usage::"Serv.Test Prepmt.".AsInteger():
                    Report.Run(ReportSelection."Report ID", true, false, ServiceHeaderEDMS);
            end;
        until ReportSelection.Next = 0;
    end;

    procedure PrintServiceHeaderPrepmt(NewServiceHeader: Record "Service Header EDMS")
    begin
        ServiceHeaderEDMS := NewServiceHeader;
        ServiceHeaderEDMS.SetRecfilter;
        PrintReport(ReportSelection.Usage::"Serv.Test Prepmt.".AsInteger());
    end;


    procedure PrintServJnlBatch(ServJnlBatch: Record "Serv. Journal Batch")
    begin
        ServJnlBatch.SetRecfilter;
        ServJournalTemplate.Get(ServJnlBatch."Journal Template Name");
        ServJournalTemplate.TestField("Test Report ID");
        Report.Run(ServJournalTemplate."Test Report ID", true, false, ServJnlBatch);
    end;


    procedure PrintExtServJnlBatch(ExtServJnlBatch: Record "External Serv. Journal Batch")
    begin
        ExtServJnlBatch.SetRecfilter;
        ExtServJournalTemplate.Get(ExtServJnlBatch."Journal Template Name");
        ExtServJournalTemplate.TestField("Test Report ID");
        Report.Run(ExtServJournalTemplate."Test Report ID", true, false, ExtServJnlBatch);
    end;


    procedure PrintServJnlLine(var NewServJnlLine: Record "Serv. Journal Line")
    begin
        ServJnlLine.Copy(NewServJnlLine);
        ServJnlLine.SetRange("Journal Template Name", ServJnlLine."Journal Template Name");
        ServJnlLine.SetRange("Journal Batch Name", ServJnlLine."Journal Batch Name");
        ServJournalTemplate.Get(ServJnlLine."Journal Template Name");
        ServJournalTemplate.TestField("Test Report ID");
        Report.Run(ServJournalTemplate."Test Report ID", true, false, ServJnlLine);
    end;

    procedure PrintExtServJnlLine(var NewServJnlLine: Record "External Serv. Journal Line")
    begin
        ExtServJnlLine.Copy(NewServJnlLine);
        ExtServJnlLine.SetRange("Journal Template Name", ExtServJnlLine."Journal Template Name");
        ExtServJnlLine.SetRange("Journal Batch Name", ExtServJnlLine."Journal Batch Name");
        ServJournalTemplate.Get(ExtServJnlLine."Journal Template Name");
        ServJournalTemplate.TestField("Test Report ID");
        Report.Run(ServJournalTemplate."Test Report ID", true, false, ExtServJnlLine);
    end;

    // ---------------------------------------------- codeunit 312 "Cust-Check Cr. Limit" --------------------------------------------------- //
    procedure ServiceHeaderCheckEDMS(var ServiceDocumentHeader: Record "Service Header EDMS")
    begin
        if CustCheckCreditLimit.ServiceHeaderShowWarningEDMS(ServiceDocumentHeader) then begin
            OK := CustCheckCreditLimit.RunModal = Action::Yes;
            //>>DELTA 01
            IF OK then
                ServiceDocumentHeader.OnCustomerCreditLimitExceeded;
            //<<DELTA 01
            Clear(CustCheckCreditLimit);
            if not OK then
                Error(Text000);
        end;
    end;

    procedure RentHeaderCheck(RentHeader: Record "Rent Header") CreditLimitExceeded: Boolean
    var
        AdditionalContextId: Guid;
    begin
        if not GuiAllowed then
            exit;

        EDMSOnNewCheckRemoveCustomerNotifications(RentHeader.RecordId, true);

        if CustCheckCreditLimit.RentHeaderShowWarningAndGetCause(RentHeader, AdditionalContextId) then
            if InstructionMgt.IsEnabled(CustCheckCrLimit.GetInstructionType(Format(RentHeader."Document Type"), RentHeader."No.")) then begin
                CreditLimitExceeded := true;
                // Check local procedure
                //CustCheckCrLimit.CreateAndSendNotification(RentHeader.RecordId, AdditionalContextId, '');
            end;
    end;

    // ----------------------------------------------------- codeunit 427 ICInboxOutboxMgt ---------------------------------------

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ICInboxOutboxMgt, 'OnCreateOutboxSalesInvTransOnAfterTransferFieldsFromSalesInvHeader', '', false, false)]
    local procedure OnCreateOutboxSalesInvTransOnAfterTransferFieldsFromSalesInvHeader(var ICOutboxSalesHeader: Record "IC Outbox Sales Header"; SalesInvHdr: Record "Sales Invoice Header"; ICOutboxTransaction: Record "IC Outbox Transaction");
    begin
        ICOutBoxSalesHeader."Order No." := SalesInvHdr."Order No."; //27.02.2008 EDMS P3
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ICInboxOutboxMgt, 'OnCreateSalesDocumentOnBeforeSetICDocDimFilters', '', false, false)]
    local procedure OnCreateSalesDocumentOnBeforeSetICDocDimFilters(var SalesHeader: Record "Sales Header"; var ICInboxSalesHeader: Record "IC Inbox Sales Header");
    begin
        SalesHeader."Document Profile" := ICInboxSalesHeader."Document Profile"; //22.02.2008 EDMS P3
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ICInboxOutboxMgt, 'OnCreateSalesLinesOnAfterValidateNo', '', false, false)]
    local procedure OnCreateSalesLinesOnAfterValidateNo(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; ICInboxSalesLine: Record "IC Inbox Sales Line");
    begin
        SalesLine."Line Type" := ICInboxSalesLine."Line Type"; //20.03.2013 EDMS	 
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ICInboxOutboxMgt, 'OnCreatePurchDocumentOnBeforeSetICDocDimFilters', '', false, false)]
    local procedure OnCreatePurchDocumentOnBeforeSetICDocDimFilters(var PurchHeader: Record "Purchase Header"; var ICInboxPurchHeader: Record "IC Inbox Purchase Header");
    begin
        PurchHeader."Document Profile" := ICInboxPurchHeader."Document Profile"; //27.02.2008 EDMS P3
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ICInboxOutboxMgt, 'OnBeforeICInboxPurchHeaderInsert', '', false, false)]
    local procedure OnBeforeICInboxPurchHeaderInsert(var ICInboxPurchaseHeader: Record "IC Inbox Purchase Header"; ICOutboxSalesHeader: Record "IC Outbox Sales Header");
    begin
        ICInboxPurchaseHeader."Document Profile" := ICOutboxSalesHeader."Document Profile"; //27.02.2008 EDMS P3
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::ICInboxOutboxMgt, 'OnBeforeICInboxPurchLineInsert', '', false, false)]
    local procedure OnBeforeICInboxPurchLineInsert(var ICInboxPurchaseLine: Record "IC Inbox Purchase Line"; ICOutboxSalesLine: Record "IC Outbox Sales Line");
    begin
        //27.02.2008 EDMS P3 >>
        ICInboxPurchaseLine."Document Profile" := ICOutboxSalesLine."Document Profile";
        case ICOutboxSalesLine."Line Type" of
            ICOutboxSalesLine."line type"::Vehicle:
                ICInboxPurchaseLine."Line Type" := ICInboxPurchaseLine."line type"::Vehicle;
            ICOutboxSalesLine."line type"::Item:
                ICInboxPurchaseLine."Line Type" := ICInboxPurchaseLine."line type"::Item;
            ICOutboxSalesLine."line type"::"Charge (Item)":
                ICInboxPurchaseLine."Line Type" := ICInboxPurchaseLine."line type"::"Charge (Item)";
            ICOutboxSalesLine."line type"::"G/L Account":
                ICInboxPurchaseLine."Line Type" := ICInboxPurchaseLine."line type"::"G/L Account";
            else
                ICInboxPurchaseLine."Line Type" := ICOutboxSalesLine."Line Type"
        end;
        ICInboxPurchaseLine.VIN := ICOutboxSalesLine.VIN;
        ICInboxPurchaseLine."Vehicle Body Colour Code" := ICOutboxSalesLine."Vehicle Body Colour Code";
        ICInboxPurchaseLine."Vehicle Interior Code" := ICOutboxSalesLine."Vehicle Interior Code";
        //27.02.2008 EDMS P3 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ICInboxOutboxMgt, 'OnBeforeICInboxSalesHeaderInsert', '', false, false)]
    local procedure OnBeforeICInboxSalesHeaderInsert(var ICInboxSalesHeader: Record "IC Inbox Sales Header"; ICOutboxPurchaseHeader: Record "IC Outbox Purchase Header");
    begin
        ICInboxSalesHeader."Document Profile" := ICOutboxPurchaseHeader."Document Profile"; //22.02.2008 EDMS P3
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ICInboxOutboxMgt, 'OnBeforeICInboxSalesLineInsert', '', false, false)]
    local procedure OnBeforeICInboxSalesLineInsert(var ICInboxSalesLine: Record "IC Inbox Sales Line"; ICOutboxPurchaseLine: Record "IC Outbox Purchase Line");
    begin
        //22.02.2008 EDMS P3 >>
        ICInboxSalesLine."Document Profile" := ICOutboxPurchaseLine."Document Profile";
        case ICOutboxPurchaseLine."Line Type" of
            ICOutboxPurchaseLine."line type"::Vehicle:
                ICInboxSalesLine."Line Type" := ICInboxSalesLine."line type"::Vehicle;
            ICOutboxPurchaseLine."line type"::Item:
                ICInboxSalesLine."Line Type" := ICInboxSalesLine."line type"::Item;
            ICOutboxPurchaseLine."line type"::"Charge (Item)":
                ICInboxSalesLine."Line Type" := ICInboxSalesLine."line type"::"Charge (Item)";
            ICOutboxPurchaseLine."line type"::"G/L Account":
                ICInboxSalesLine."Line Type" := ICInboxSalesLine."line type"::"G/L Account";
            else
                ICInboxSalesLine."Line Type" := ICOutboxPurchaseLine."Line Type"
        end;
        ICInboxSalesLine.VIN := ICOutboxPurchaseLine.VIN;
        ICInboxSalesLine."Vehicle Body Colour Code" := ICOutboxPurchaseLine."Vehicle Body Colour Code";
        ICInboxSalesLine."Vehicle Interior Code" := ICOutboxPurchaseLine."Vehicle Interior Code";
        //22.02.2008 EDMS P3 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ICInboxOutboxMgt, 'OnCreatePurchLinesOnBeforeAssignTypeAndNo', '', false, false)]
    local procedure OnCreatePurchLinesOnBeforeAssignTypeAndNo(var PurchaseLine: Record "Purchase Line"; ICInboxPurchLine: Record "IC Inbox Purchase Line");
    begin
        If ICInboxPurchLine."IC Partner Ref. Type" = ICInboxPurchLine."IC Partner Ref. Type"::Item Then begin
            PurchaseLine."Line Type" := ICInboxPurchLine."Line Type"; //20.03.2013 EDMS
        END;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Catalog Item Management", 'OnBeforeDelNonStockItem', '', false, false)]
    local procedure OnBeforeDelNonStockItem(var Item: Record Item; var IsHandled: Boolean);
    var
        ItemJnlLine: Record "Item Journal Line";
        ServLineEDMS: Record "Service Line EDMS";
    begin

        //EDMS1.0.00 >>
        ItemJnlLine.SetCurrentkey("Item No.");
        ItemJnlLine.SetRange("Item No.", Item."No.");
        if ItemJnlLine.FindFirst then
            IsHandled := true;
        //EDMS1.0.00 <<

        //06.02.2009 EDMS P1 >>
        ServLineEDMS.SetCurrentkey(Type, "No.");
        ServLineEDMS.SetRange(Type, ServLineEDMS.Type::Item);
        ServLineEDMS.SetRange("No.", Item."No.");
        if ServLineEDMS.FindFirst then
            IsHandled := true;
        //06.02.2009 EDMS P1 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Catalog Item Management", 'OnCreateNewItemOnBeforeItemInsert', '', false, false)]
    local procedure OnCreateNewItemOnBeforeItemInsert(var Item: Record Item; NonstockItem: Record "Nonstock Item");
    begin
        Item."Item Type" := NonstockItem."item type"::Item;
        Item."Item Disc. Group" := NonstockItem."Item Disc. Group";           // 10.03.2015 EDMS P21 #T029
        Item."Tariff No." := NonstockItem."Tariff No.";
        Item."Item Price Group Code" := NonstockItem."Item Price Group Code";
        //22.10.2008 EDMS P2 <<
        item."Description 2" := NonstockItem."Description 2";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Catalog Item Management", 'OnAfterCreateNewItem', '', false, false)]
    local procedure OnAfterCreateNewItem(var Item: Record Item; NonstockItem: Record "Nonstock Item"; var NewItem: Record Item);
    Var
        ItemSubstitution: Record "Item Substitution";
        ItemSbustitutionSync: Codeunit "Item Substitution Sync";
        DefDimNonstockItem: Record "Default Dimension";
        DefDimItem: Record "Default Dimension";
        ApplicationEventMgt: Codeunit "Application Event Management";
    begin
        ApplicationEventMgt.FillItemGroupDefDim(Item);      // EB.P21 #T0043

        //EDMS1.0.00 >>
        ApplicationEventMgt.TransferSalesPrices(NonstockItem);
        ApplicationEventMgt.TransferSalesLineDiscounts(NonstockItem);
        ApplicationEventMgt.TransferPurchPrices(NonstockItem);
        ApplicationEventMgt.TransferPurchLineDiscounts(NonstockItem);
        //EDMS1.0.00 <<

        //08.04.2008. EDMS P2 >>
        ItemSubstitution.Reset;
        ItemSubstitution.SetRange(Type, ItemSubstitution.Type::"Nonstock Item");
        ItemSubstitution.SetRange("No.", NonstockItem."Entry No.");
        if ItemSubstitution.FindFirst then
            repeat
                ItemSbustitutionSync.InsertItemSub(ItemSubstitution);
            until ItemSubstitution.Next = 0;

        ItemSubstitution.Reset;
        ItemSubstitution.SetRange("Substitute Type", ItemSubstitution.Type::"Nonstock Item");
        ItemSubstitution.SetRange("Substitute No.", NonstockItem."Entry No.");
        if ItemSubstitution.FindFirst then
            repeat
                ItemSbustitutionSync.InsertItemSub(ItemSubstitution);
            until ItemSubstitution.Next = 0;
        //08.04.2008. EDMS P2 <<

        //EDMS >>
        DefDimNonstockItem.Reset;
        DefDimNonstockItem.SetRange("Table ID", Database::"Nonstock Item");
        DefDimNonstockItem.SetRange("No.", NonstockItem."Entry No.");
        if DefDimNonstockItem.FindFirst then
            repeat
                DefDimItem.Reset;
                DefDimItem.TransferFields(DefDimNonstockItem);
                DefDimItem."Table ID" := Database::Item;
                DefDimItem."No." := Item."No.";
                DefDimItem.Insert(true);
            until DefDimNonstockItem.Next = 0;
        //EDMS <<

        Item.FillItemCategoryDim; // 31.03.2014 Elva Baltic P18 MMG7.00
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnBeforeCheckHeaderShippingAdvice', '', false, false)]
    local procedure OnBeforeCheckHeaderShippingAdvice(var TransferHeader: Record "Transfer Header"; var IsHandled: Boolean);
    Var
        ApplicationEventMgt: Codeunit "Application Event Management";
    begin
        //EDMS >>
        if TransferHeader."Document Profile" = TransferHeader."document profile"::Service then
            ApplicationEventMgt.CheckService(TransferHeader); //17.07.2008 EDMS P1
        ApplicationEventMgt.UpdateVehicelSerialNo(TransferHeader);
        //EDMS <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnAfterTransferOrderPostShipment', '', false, false)]
    local procedure OnAfterTransferOrderPostShipment(var TransferHeader: Record "Transfer Header"; CommitIsSuppressed: Boolean; var TransferShipmentHeader: Record "Transfer Shipment Header"; InvtPickPutaway: Boolean);
    begin
        // 21.05.2014 Elva Baltic P21 #F012 MMG7.00 >>
        TransferHeader.SetHideValidationDialog(true);
        TransferHeader.UpdateAllLineReceiptDim(TransferHeader."Receipt Dimension Set ID", 0);
        // 21.05.2014 Elva Baltic P21 #F012 MMG7.00 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnAfterCreateItemJnlLine', '', false, false)]
    local procedure OnAfterCreateItemJnlLine(var ItemJournalLine: Record "Item Journal Line"; TransferLine: Record "Transfer Line"; TransferShipmentHeader: Record "Transfer Shipment Header"; TransferShipmentLine: Record "Transfer Shipment Line");
    begin
        //14.08.2019 EB.RC >>
        ItemJournalLine."Document Profile" := TransferLine."Document Profile";
        ItemJournalLine."Make Code" := TransferLine."Make Code";
        ItemJournalLine."Model Code" := TransferLine."Model Code";
        ItemJournalLine."Model Version No." := TransferLine."Model Version No.";
        ItemJournalLine.VIN := TransferLine.VIN;
        ItemJournalLine."Vehicle Accounting Cycle No." := TransferLine."Vehicle Accounting Cycle No.";
        //14.08.2019 EB.RC <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnBeforeGenNextNo', '', false, false)]
    local procedure OnBeforeGenNextNo(var TransferShipmentHeader: Record "Transfer Shipment Header"; TransferHeader: Record "Transfer Header");
    begin
        //03.03.2010 EDMSB P2 >>
        //TransShptHeader."No." := TransHeader."No.";
        TransferShipmentHeader."Source Type" := TransferHeader."Source Type";
        TransferShipmentHeader."Source Subtype" := TransferHeader."Source Subtype";
        TransferShipmentHeader."Source No." := TransferHeader."Source No.";
        //03.03.2010 EDMSB P2 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnBeforeInsertTransShptHeader', '', false, false)]
    local procedure OnBeforeInsertTransShptHeader(var TransShptHeader: Record "Transfer Shipment Header"; TransHeader: Record "Transfer Header"; CommitIsSuppressed: Boolean);
    begin
        //EDMS1.0.00 >>
        TransShptHeader."Document Profile" := TransHeader."Document Profile";
        TransShptHeader."Transfer-to Customer No." := TransHeader."Transfer-to Customer No.";
        TransShptHeader."Transfer-to Customer Name" := TransHeader."Transfer-to Customer Name";
        //EDMS1.0.00 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Shipment", 'OnBeforeInsertTransShipmentLine', '', false, false)]
    local procedure OnBeforeInsertTransShipmentLine(TransLine: Record "Transfer Line");
    Var
        ApplicationEventMgt: Codeunit "Application Event Management";
        TransHeader: Record "Transfer Header";
        Location: Record Location;
    begin
        If TransHeader.get(TransLine."Document No.") then begin
            GetLocation(TransHeader."Transfer-from Code");
            // 28.03.2014 Elva Baltic P21 >>
            if (TransLine."Qty. to Ship" <> 0) then
                ApplicationEventMgt.EDMSCheckItemInInventory(TransLine);
            if (Location."Bin Mandatory") and (TransLine."Qty. to Ship" <> 0) then
                TransLine.TestField(TransLine."Transfer-from Bin Code");
            // 28.03.2014 Elva Baltic P21 <<
        end;
    end;

    procedure GetLocation(LocationCode: Code[10])
    Var
        Location: Record Location;
    begin
        if LocationCode = '' then
            Location.GetLocationSetup(LocationCode, Location)
        else
            if Location.Code <> LocationCode then
                Location.Get(LocationCode);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Transfer Shipment Line", 'OnAfterCopyFromTransferLine', '', false, false)]
    local procedure OnAfterCopyFromTransferShipmentLine(var TransferShipmentLine: Record "Transfer Shipment Line"; TransferLine: Record "Transfer Line");
    var
        ApplicationEventMgt: Codeunit "Application Event Management";
        TransShptHeader: Record "Transfer Shipment Header";
        Vehicle: record Vehicle;
    begin
        //25.02.2010 EDMSB P2 >>
        if TransferLine."From Location Dimension 1 Code" <> '' then
            TransferShipmentLine."Shortcut Dimension 1 Code" := TransferLine."From Location Dimension 1 Code"
        else
            //25.02.2010 EDMSB P2 <<

            //25.02.2010 EDMSB P2 >>
            if TransferLine."From Location Dimension 2 Code" <> '' then
                TransferShipmentLine."Shortcut Dimension 2 Code" := TransferLine."From Location Dimension 2 Code"
            else
                //25.02.2010 EDMSB P2 <<

                if TransShptHeader.get(TransferShipmentLine."Document No.") then begin
                    //EDMS1.0.00 >>
                    TransferShipmentLine."Document Profile" := TransShptHeader."Document Profile";
                    TransferShipmentLine."Make Code" := TransferLine."Make Code";
                    TransferShipmentLine."Model Code" := TransferLine."Model Code";
                    TransferShipmentLine."Model Version No." := TransferLine."Model Version No.";
                    TransferShipmentLine.VIN := TransferLine.VIN;
                    TransferShipmentLine."Vehicle Serial No." := TransferLine."Vehicle Serial No.";
                    TransferShipmentLine."Vehicle Accounting Cycle No." := TransferLine."Vehicle Accounting Cycle No.";
                    //29.04.2014 Elva Baltic P8 #F037 MMG7.00 >>
                    // TransShptLine."Vehicle Status Code" := TransLine."Vehicle Status Code";
                    if Vehicle.Get(TransferShipmentLine."Vehicle Serial No.") then
                        TransferShipmentLine."Vehicle Status Code" := Vehicle."Status Code";
                    //29.04.2014 Elva Baltic P8 #F037 MMG7.00 <<
                    //EDMS1.0.00 <<

                    //02.11.2007. EDMS P2 >>
                    ApplicationEventMgt.FillLineVariableFields(TransferLine, TransferShipmentLine);
                    //02.11.2007. EDMS P2 <<
                end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post Receipt", 'OnBeforePostItemJournalLine', '', false, false)]
    local procedure OnBeforePostItemJournalLine(var ItemJournalLine: Record "Item Journal Line"; TransferLine: Record "Transfer Line"; TransferReceiptHeader: Record "Transfer Receipt Header"; TransferReceiptLine: Record "Transfer Receipt Line"; CommitIsSuppressed: Boolean; TransLine: Record "Transfer Line"; PostedWhseRcptHeader: Record "Posted Whse. Receipt Header");
    Var
        Item: Record Item;
    begin
        //20.01.2017 EDMS Upgrade 2017 >>
        Item.Get(ItemJournalLine."Item No.");
        ItemJournalLine."Item Category Code" := Item."Item Category Code";
        //ItemJnlLine."Product Group Code" := Item."Product Group Code";//20.06.2019 EB.P7 BC Upgrade
        ItemJournalLine."Item Type" := Item."Item Type";
        ItemJournalLine."Document Profile" := TransLine."Document Profile";
        ItemJournalLine."Make Code" := TransLine."Make Code";
        ItemJournalLine."Model Code" := TransLine."Model Code";
        ItemJournalLine."Model Version No." := TransLine."Model Version No.";
        ItemJournalLine.VIN := TransLine.VIN;
        ItemJournalLine."Vehicle Accounting Cycle No." := TransLine."Vehicle Accounting Cycle No.";
        ItemJournalLine."Transfer Source Type" := TransferReceiptHeader."Source Type";
        ItemJournalLine."Transfer Source Subtype" := TransferReceiptHeader."Source Subtype";
        ItemJournalLine."Transfer Source No." := TransferReceiptHeader."Source No.";
        //20.01.2017 EDMS Upgrade 2017 <<
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"TransferOrder-Post (Yes/No)", 'OnCodeOnBeforePostTransferOrder', '', false, false)]
    local procedure OnCodeOnBeforePostTransferOrder(var TransHeader: Record "Transfer Header"; var DefaultNumber: Integer; var Selection: Option; var IsHandled: Boolean; var PostBatch: Boolean; var TransferOrderPost: Enum "Transfer Order Post");
    Var
        PostReceipt, PostShipment, PostTransfer : Boolean;
        ServiceTransferMgt: Codeunit "Service Transfer Mgt.";
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        TransferPostReceipt: Codeunit "TransferOrder-Post Receipt";
        TransferPostShipment: Codeunit "TransferOrder-Post Shipment";

        Text101: TextConst ENU = 'S&hip && Receive,&Ship,&Receive', FRA = 'Expédier && Réceptionner,Expédier,Réceptionner';

        DefaultNumberEDMS: Option " ","Shipment&Receipt",Shipment,Receipt;
        lIsHandled: boolean;
    begin
        If TransHeader."Document Profile" <> TransHeader."Document Profile"::Service then
            exit;

        IsHandled := True;


        if DefaultNumber = 2 then
            DefaultNumberEDMS := Defaultnumberedms::Receipt
        else
            DefaultNumberEDMS := Defaultnumberedms::"Shipment&Receipt";
        OnBeforeShowShipmentReceiptDialog(TransHeader, DefaultNumberEDMS, lIsHandled);
        if not lIsHandled then
            Selection := StrMenu(Text101, DefaultNumberEDMS);
        case Selection of
            0:
                begin
                    exit;
                end;

            1:
                begin
                    TransferPostShipment.Run(TransHeader);
                    TransferPostReceipt.Run(TransHeader);
                end;
            2:
                TransferPostShipment.Run(TransHeader);
            3:
                TransferPostReceipt.Run(TransHeader);
        end;
        //   ServiceTransferMgt.GetPostingOptions(TransHeader, DefaultNumber, Selection, PostReceipt, PostShipment, PostTransfer, PostBatch);
        //  ServiceTransferMgt.PostTransferOrder(TransHeader, PostShipment, PostReceipt, PostTransfer, PostBatch);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purchases Warehouse Mgt.", 'OnAfterPurchaseLineVerifyChange', '', false, false)]
    local procedure OnAfterPurchaseLineVerifyChange(var NewPurchaseLine: Record "Purchase Line"; var NewRecordRef: RecordRef; var OldPurchaseLine: Record "Purchase Line"; var OldRecordRef: RecordRef);
    Var
        Text000: Label 'must not be changed when a %1 for this %2 exists: ';
        ApplicationEventMgt: Codeunit "Application Event Management";
        WhseValidateSourceLine: Codeunit "Whse. Validate Source Line";
        TableCaptionValue: Text[100];
    begin

        TableCaptionValue := ApplicationEventMgt.EDMSWhseLinesExist(
                           DATABASE::"Purchase Line", NewPurchaseLine."Document Type".AsInteger(), NewPurchaseLine."Document No.",
                           NewPurchaseLine."Line No.", 0, NewPurchaseLine.Quantity);
        //18.01.2013 EDMS P8 >>
        if NewPurchaseLine."Special Order Service No." <> OldPurchaseLine."Special Order Service No." then
            NewPurchaseLine.FieldError(
              "Special Order Service No.",
              StrSubstNo(Text000, TableCaptionValue, NewPurchaseLine.TableCaption));

        if NewPurchaseLine."Special Order Service Line No." <> OldPurchaseLine."Special Order Service Line No." then
            NewPurchaseLine.FieldError(
              NewPurchaseLine."Special Order Service Line No.",
              StrSubstNo(Text000, TableCaptionValue, NewPurchaseLine.TableCaption));
        //18.01.2013 EDMS P8 <<
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Available to Promise", 'OnBeforeCalcGrossRequirement', '', false, false)]
    local procedure OnBeforeCalcGrossRequirement(var Item: Record Item; var GrossRequirement: Decimal; var IsHandled: Boolean);
    begin
        IsHandled := True;
        GrossRequirement := Item."Qty. on Component Lines" +
                            Item."Planning Issues (Qty.)" +
                            Item."Planning Transfer Ship. (Qty)." +
                            Item."Qty. on Sales Order" +
                            Item."Qty. on Service Order" +
                            Item."Qty. on Job Order" +
                            Item."Qty. on Service Order EDMS" + //EDMS
                            Item."Trans. Ord. Shipment (Qty.)" +
                            Item."Qty. on Asm. Component" +
                            Item."Qty. on Purch. Return";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Available to Promise", 'OnBeforeCalcReservedRequirement', '', false, false)]
    local procedure OnBeforeCalcReservedRequirement(var Item: Record Item; var ReservedRequirement: Decimal; var IsHandled: Boolean);
    begin
        ReservedRequirement := Item."Res. Qty. on Prod. Order Comp." +
                                        Item."Reserved Qty. on Sales Orders" +
                                        Item."Res. Qty. on Service Orders" +
                                        Item."Res. Qty. on Job Order" +
                                        Item."Res. Qty. on Outbound Transfer" +
                                        Item."Res. Qty. on  Asm. Comp." +
                                        Item."Res. Qty. on Purch. Returns" +
                                        Item."Res. Qty. on Serv. Orders EDMS"; // EDMS;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Available to Promise", 'OnBeforeCalcScheduledReceipt', '', false, false)]
    local procedure OnBeforeCalcScheduledReceipt(var Item: Record Item; var ScheduledReceipt: Decimal; var IsHandled: Boolean);
    begin
        ScheduledReceipt := Item."Scheduled Receipt (Qty.)" +
                            Item."Planned Order Receipt (Qty.)" +
                            Item."Qty. on Purch. Order" +
                            Item."Trans. Ord. Receipt (Qty.)" +
                            Item."Qty. in Transit" +
                            Item.CalcServiceReturnEDMS + //EDMS
                            Item."Qty. on Assembly Order" +
                            Item."Qty. on Sales Return";
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Available to Promise", 'OnCalcAllItemFieldsOnAfterItemCalcFields', '', false, false)]
    local procedure OnCalcAllItemFieldsOnAfterItemCalcFields(var Item: Record Item);
    begin
        Item.CalcFields("Qty. on Service Order EDMS", "Res. Qty. on Serv. Orders EDMS");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Inventory Posting To G/L", 'OnBeforeBufferInvtPosting', '', false, false)]
    local procedure OnBeforeBufferInvtPosting(var ValueEntry: Record "Value Entry"; var Result: Boolean; var IsHandled: Boolean; RunOnlyCheck: Boolean; CalledFromTestReport: Boolean);
    begin
        if ValueEntry."Not To Post" then begin
            Result := false;
            IsHandled := true;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Inventory Posting To G/L", 'OnBeforeBufferSalesPosting', '', false, false)]
    local procedure OnBeforeBufferSalesPosting(var Sender: Codeunit "Inventory Posting To G/L"; var ValueEntry: Record "Value Entry"; var GlobalInvtPostBuf: Record "Invt. Posting Buffer"; CostToPost: Decimal; CostToPostACY: Decimal; ExpCostToPost: Decimal; ExpCostToPostACY: Decimal; var IsHandled: Boolean);
    Var
        InvtPostGrp: Record "Inventory Posting Group";
        AddExpenses: Boolean;
        Text002: Label 'The following combination %1 = %2, %3 = %4, and %5 = %6 is not allowed.';

    begin
        IsHandled := True;
        case ValueEntry."Entry Type" of
            ValueEntry."Entry Type"::"Direct Cost":
                begin
                    if (ExpCostToPost <> 0) or (ExpCostToPostACY <> 0) then
                        Sender.InitInvtPostBuf(
                          ValueEntry,
                          GlobalInvtPostBuf."Account Type"::"Inventory (Interim)",
                          GlobalInvtPostBuf."Account Type"::"COGS (Interim)",
                          ExpCostToPost, ExpCostToPostACY, true);


                    if (CostToPost <> 0) or (CostToPostACY <> 0) then
              //11.04.2008 EDMS P3 >>
              begin
                        if ValueEntry."Inventory Posting Group" <> '' then
                            if InvtPostGrp.Get(ValueEntry."Inventory Posting Group") then
                                AddExpenses := InvtPostGrp."Vehicle Additional Expenses";
                        if AddExpenses then
                            Sender.InitInvtPostBuf(
                                        ValueEntry,
                                        GlobalInvtPostBuf."Account Type"::Inventory,
                              GlobalInvtPostBuf."account type"::"Veh. Additional Expenses",
                              CostToPost, CostToPostACY, false)
                        else
                            Sender.InitInvtPostBuf(
                              ValueEntry,
                              GlobalInvtPostBuf."account type"::Inventory,
                            GlobalInvtPostBuf."account type"::COGS,
                            CostToPost, CostToPostACY, false);
                    end;
                    //11.04.2008 EDMS P3 <<
                end;
            ValueEntry."Entry Type"::Revaluation:
                begin
                    if (ExpCostToPost <> 0) or (ExpCostToPostACY <> 0) then
                        Sender.InitInvtPostBuf(
                          ValueEntry,
                          GlobalInvtPostBuf."Account Type"::"Inventory (Interim)",
                          GlobalInvtPostBuf."Account Type"::"COGS (Interim)",
                          ExpCostToPost, ExpCostToPostACY, true);
                    if (CostToPost <> 0) or (CostToPostACY <> 0) then
                        Sender.InitInvtPostBuf(
                          ValueEntry,
                          GlobalInvtPostBuf."Account Type"::Inventory,
                          GlobalInvtPostBuf."Account Type"::"Inventory Adjmt.",
                          CostToPost, CostToPostACY, false);
                end;
            ValueEntry."Entry Type"::Rounding:
                Sender.InitInvtPostBuf(
                  ValueEntry,
                  GlobalInvtPostBuf."Account Type"::Inventory,
                  GlobalInvtPostBuf."Account Type"::"Inventory Adjmt.",
                  CostToPost, CostToPostACY, false);
            else begin
                Error(
                  Text002,
                  ValueEntry.FieldCaption("Item Ledger Entry Type"), ValueEntry."Item Ledger Entry Type",
                  ValueEntry.FieldCaption("Entry Type"), ValueEntry."Entry Type",
                  ValueEntry.FieldCaption("Expected Cost"), ValueEntry."Expected Cost")
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Inventory Posting To G/L", 'OnSetAccNoOnBeforeCheckAccNo', '', false, false)]
    local procedure OnSetAccNoOnBeforeCheckAccNo(var InvtPostBuf: Record "Invt. Posting Buffer"; InvtPostingSetup: Record "Inventory Posting Setup"; GenPostingSetup: Record "General Posting Setup"; CalledFromItemPosting: Boolean; var ValueEntry: Record "Value Entry");
    begin
        //11.04.2008 EDMS P3 >>
        If InvtPostBuf."account type" = InvtPostBuf."account type"::"Veh. Additional Expenses" Then begin
            GenPostingSetup.TestField(GenPostingSetup."Veh. Add. Expenses Account");
            InvtPostBuf."Account No." := GenPostingSetup."Veh. Add. Expenses Account";
        end;
        //11.04.2008 EDMS P3 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Inventory Posting To G/L", 'OnPostInvtPostBufOnAfterInitGenJnlLine', '', false, false)]
    local procedure OnPostInvtPostBufOnAfterInitGenJnlLine(var GenJournalLine: Record "Gen. Journal Line"; var ValueEntry: Record "Value Entry");
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        Item: Record Item;
    begin
        //EDMS1.0.00 >>
        if ValueEntry."Not To Post" then exit;
        //EDMS1.0.00 <<
        //EDMS1.0.00 >> 
        ItemLedgEntry.Reset;
        if Item.Get(ValueEntry."Item No.") then
            if Item."Item Type" = Item."item type"::"Model Version" then //27.08.2013 EDMS P8
                if ItemLedgEntry.Get(ValueEntry."Item Ledger Entry No.") then begin
                    GenJournalLine."Vehicle Serial No." := ItemLedgEntry."Serial No.";
                    GenJournalLine."Vehicle Accounting Cycle No." := ItemLedgEntry."Vehicle Accounting Cycle No."
                end;
        //EDMS1.0.00 <<
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Charge Assgnt. (Purch.)", 'OnBeforeInsertItemChargeAssgntWithAssignValues', '', False, False)]
    local procedure OnBeforeInsertItemChargeAssgntWithAssignValuesPurch(var ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)"; FromItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)")
    Var
        FromPurchLine: Record "Purchase Line";
        FromPurchRcptLine: Record "Purch. Rcpt. Line";
        FromTransRcptLine: Record "Transfer Receipt Line";
        FromReturnShptLine: Record "Return Shipment Line";
        FromSalesShptLine: Record "Sales Shipment Line";
        FromReturnRcptLine: Record "Return Receipt Line";
    begin
        Case ItemChargeAssgntPurch."Applies-to Doc. Type" of
            ItemChargeAssgntPurch."Applies-to Doc. Type"::Receipt:
                begin
                    if FromPurchRcptLine.get(ItemChargeAssgntPurch."Applies-to Doc. No.", ItemChargeAssgntPurch."Applies-to Doc. Line No.") then begin
                        //15.08.2013 EDMS P15 >>
                        ItemChargeAssgntPurch."Vehicle Serial No." := FromPurchRcptLine."Vehicle Serial No.";
                        ItemChargeAssgntPurch."Vehicle Accounting Cycle No." := FromPurchRcptLine."Vehicle Accounting Cycle No.";
                        ItemChargeAssgntPurch."Make Code" := FromPurchRcptLine."Make Code";
                        ItemChargeAssgntPurch."Model Code" := FromPurchRcptLine."Model Code";
                        ItemChargeAssgntPurch."Model Version No." := FromPurchRcptLine."Model Version No.";
                        //15.08.2013 EDMS P15 <<
                    end
                end;
            ItemChargeAssgntPurch."Applies-to Doc. Type"::"Transfer Receipt":
                begin
                    if FromTransRcptLine.get(ItemChargeAssgntPurch."Applies-to Doc. No.", ItemChargeAssgntPurch."Applies-to Doc. Line No.") then begin
                        //15.08.2013 EDMS P15 >>
                        ItemChargeAssgntPurch."Vehicle Serial No." := FromTransRcptLine."Vehicle Serial No.";
                        ItemChargeAssgntPurch."Vehicle Accounting Cycle No." := FromTransRcptLine."Vehicle Accounting Cycle No.";
                        ItemChargeAssgntPurch."Make Code" := FromTransRcptLine."Make Code";
                        ItemChargeAssgntPurch."Model Code" := FromTransRcptLine."Model Code";
                        ItemChargeAssgntPurch."Model Version No." := FromTransRcptLine."Model Version No.";
                        //15.08.2013 EDMS P15 <<
                    end
                end;
            ItemChargeAssgntPurch."Applies-to Doc. Type"::"Return Shipment":
                begin
                    if FromReturnShptLine.get(ItemChargeAssgntPurch."Applies-to Doc. No.", ItemChargeAssgntPurch."Applies-to Doc. Line No.") then begin
                        //15.08.2013 EDMS P15 >>
                        ItemChargeAssgntPurch."Vehicle Serial No." := FromReturnShptLine."Vehicle Serial No.";
                        ItemChargeAssgntPurch."Vehicle Accounting Cycle No." := FromReturnShptLine."Vehicle Accounting Cycle No.";
                        ItemChargeAssgntPurch."Make Code" := FromReturnShptLine."Make Code";
                        ItemChargeAssgntPurch."Model Code" := FromReturnShptLine."Model Code";
                        ItemChargeAssgntPurch."Model Version No." := FromReturnShptLine."Model Version No.";
                        //15.08.2013 EDMS P15 <<
                    end
                end;
            ItemChargeAssgntPurch."Applies-to Doc. Type"::"Sales Shipment":
                begin
                    if FromSalesShptLine.get(ItemChargeAssgntPurch."Applies-to Doc. No.", ItemChargeAssgntPurch."Applies-to Doc. Line No.") then begin
                        //15.08.2013 EDMS P15 >>
                        ItemChargeAssgntPurch."Vehicle Serial No." := FromSalesShptLine."Vehicle Serial No.";
                        ItemChargeAssgntPurch."Vehicle Accounting Cycle No." := FromSalesShptLine."Vehicle Accounting Cycle No.";
                        ItemChargeAssgntPurch."Make Code" := FromSalesShptLine."Make Code";
                        ItemChargeAssgntPurch."Model Code" := FromSalesShptLine."Model Code";
                        ItemChargeAssgntPurch."Model Version No." := FromSalesShptLine."Model Version No.";
                        //15.08.2013 EDMS P15 <<
                    end
                end;
            ItemChargeAssgntPurch."Applies-to Doc. Type"::"Return Receipt":
                begin
                    if FromReturnRcptLine.get(ItemChargeAssgntPurch."Applies-to Doc. No.", ItemChargeAssgntPurch."Applies-to Doc. Line No.") then begin
                        //15.08.2013 EDMS P15 >>
                        ItemChargeAssgntPurch."Vehicle Serial No." := FromReturnRcptLine."Vehicle Serial No.";
                        ItemChargeAssgntPurch."Vehicle Accounting Cycle No." := FromReturnRcptLine."Vehicle Accounting Cycle No.";
                        ItemChargeAssgntPurch."Make Code" := FromReturnRcptLine."Make Code";
                        ItemChargeAssgntPurch."Model Code" := FromReturnRcptLine."Model Code";
                        ItemChargeAssgntPurch."Model Version No." := FromReturnRcptLine."Model Version No.";
                        //15.08.2013 EDMS P15 <<
                    end
                end;
            else begin
                if FromPurchLine.get(ItemChargeAssgntPurch."Applies-to Doc. Type",
                                              ItemChargeAssgntPurch."Applies-to Doc. No.",
                                               ItemChargeAssgntPurch."Applies-to Doc. Line No.") then begin
                    //15.08.2013 EDMS P15 >>
                    ItemChargeAssgntPurch."Vehicle Serial No." := FromPurchLine."Vehicle Serial No.";
                    ItemChargeAssgntPurch."Vehicle Accounting Cycle No." := FromPurchLine."Vehicle Accounting Cycle No.";
                    ItemChargeAssgntPurch."Make Code" := FromPurchLine."Make Code";
                    ItemChargeAssgntPurch."Model Code" := FromPurchLine."Model Code";
                    ItemChargeAssgntPurch."Model Version No." := FromPurchLine."Model Version No.";
                    //15.08.2013 EDMS P15 <<
                end
            end;
        End;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Charge Assgnt. (Sales)", 'OnBeforeInsertItemChargeAssgntWithAssignValues', '', False, False)]
    local procedure OnBeforeInsertItemChargeAssgntWithAssignValuesSales(var ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)"; FromItemChargeAssgntSales: Record "Item Charge Assignment (Sales)")
    Var
        FromSalesShptLine: Record "Sales Shipment Line";
        FromReturnRcptLine: Record "Return Receipt Line";
        FromSalesLine: Record "Sales Line";
    begin
        Case ItemChargeAssgntSales."Applies-to Doc. Type" of
            ItemChargeAssgntSales."Applies-to Doc. Type"::Shipment:
                begin
                    if FromSalesShptLine.get(ItemChargeAssgntSales."Applies-to Doc. No.", ItemChargeAssgntSales."Applies-to Doc. Line No.") then begin
                        //15.08.2013 EDMS P15 >>
                        ItemChargeAssgntSales."Vehicle Serial No." := FromSalesShptLine."Vehicle Serial No.";
                        ItemChargeAssgntSales."Vehicle Accounting Cycle No." := FromSalesShptLine."Vehicle Accounting Cycle No.";
                        ItemChargeAssgntSales."Make Code" := FromSalesShptLine."Make Code";
                        ItemChargeAssgntSales."Model Code" := FromSalesShptLine."Model Code";
                        ItemChargeAssgntSales."Model Version No." := FromSalesShptLine."Model Version No.";
                        //15.08.2013 EDMS P15 <<
                    end;
                end;
            ItemChargeAssgntSales."Applies-to Doc. Type"::"Return Receipt":
                begin
                    if FromReturnRcptLine.get(ItemChargeAssgntSales."Applies-to Doc. No.", ItemChargeAssgntSales."Applies-to Doc. Line No.") then begin
                        //15.08.2013 EDMS P15 >>
                        ItemChargeAssgntSales."Vehicle Serial No." := FromReturnRcptLine."Vehicle Serial No.";
                        ItemChargeAssgntSales."Vehicle Accounting Cycle No." := FromReturnRcptLine."Vehicle Accounting Cycle No.";
                        ItemChargeAssgntSales."Make Code" := FromReturnRcptLine."Make Code";
                        ItemChargeAssgntSales."Model Code" := FromReturnRcptLine."Model Code";
                        ItemChargeAssgntSales."Model Version No." := FromReturnRcptLine."Model Version No.";
                        //15.08.2013 EDMS P15 <<
                    end;
                end;
            else begin
                if FromSalesLine.get(ItemChargeAssgntSales."Applies-to Doc. Type",
                                              ItemChargeAssgntSales."Applies-to Doc. No.",
                                               ItemChargeAssgntSales."Applies-to Doc. Line No.") then begin
                    //15.08.2013 EDMS P15 >>
                    ItemChargeAssgntSales."Vehicle Serial No." := FromSalesLine."Vehicle Serial No.";
                    ItemChargeAssgntSales."Vehicle Accounting Cycle No." := FromSalesLine."Vehicle Accounting Cycle No.";
                    ItemChargeAssgntSales."Make Code" := FromSalesLine."Make Code";
                    ItemChargeAssgntSales."Model Code" := FromSalesLine."Model Code";
                    ItemChargeAssgntSales."Model Version No." := FromSalesLine."Model Version No.";
                    //15.08.2013 EDMS P15 <<
                end
            end;
        END;
    END;

    procedure FindNoByDescriptionDLT(Type: Option " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)"; Description: Text; UseDefaultTableRelationFilters: Boolean): Code[20]
    var
        GLAccount: Record "G/L Account";
        ResultValue: Text;
        RecordView: Text;
    begin
        if UseDefaultTableRelationFilters and (Type = Type::"G/L Account") then
            RecordView := GetGLAccountTableRelationViewDLT();

        if FindRecordByDescriptionAndViewDLT(ResultValue, Type, Description, RecordView) = 1 then
            exit(CopyStr(ResultValue, 1, MaxStrLen(GLAccount."No.")));

        exit('');
    end;

    local procedure GetGLAccountTableRelationViewDLT(): Text
    var
        GLAccount: Record "G/L Account";
    begin
        GLAccount.SetRange("Direct Posting", true);
        GLAccount.SetRange("Account Type", GLAccount."Account Type"::Posting);
        GLAccount.SetRange(Blocked, false);
        exit(GLAccount.GetView(false));
    end;

    procedure FindRecordByDescriptionAndViewDLT(var Result: Text; Type: Option " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)"; SearchText: Text; RecordView: Text): Integer
    var
        RecRef: RecordRef;
        SearchFieldRef: array[4] of FieldRef;
        SearchFieldNo: array[4] of Integer;
        KeyNoMaxStrLen: Integer;
        RecWithoutQuote: Text;
        RecFilterFromStart: Text;
        RecFilterContains: Text;
        MatchCount: Integer;
        IsHandled: Boolean;
    begin
        // Try to find a record by SearchText looking into "No." OR "Description" fields
        // SearchFieldNo[1] - "No."
        // SearchFieldNo[2] - "Description"/"Name"
        // SearchFieldNo[3] - "Base Unit of Measure" (used for items)
        Result := '';
        if SearchText = '' then
            exit(0);

        if not (Type in [Type::" " .. Type::"Charge (Item)"]) then
            exit(0);

        GetRecRefAndFieldsNoByTypeDLT(RecRef, Type, SearchFieldNo);
        RecRef.SetView(RecordView);

        SearchFieldRef[1] := RecRef.Field(SearchFieldNo[1]);
        SearchFieldRef[2] := RecRef.Field(SearchFieldNo[2]);
        if SearchFieldNo[3] <> 0 then
            SearchFieldRef[3] := RecRef.Field(SearchFieldNo[3]);

        IsHandled := false;
        MatchCount := 0;
        OnBeforeFindRecordByDescriptionAndViewDLT(Result, Type, RecRef, SearchFieldRef, SearchText, RecordView, MatchCount, IsHandled);
        if IsHandled then
            exit(MatchCount);

        // Try GET(SearchText)
        KeyNoMaxStrLen := SearchFieldRef[1].Length;
        if StrLen(SearchText) <= KeyNoMaxStrLen then begin
            SearchFieldRef[1].SetRange(CopyStr(SearchText, 1, KeyNoMaxStrLen));
            RecRef.SetLoadFields(SearchFieldRef[1].Number);
            if RecRef.FindFirst() then begin
                Result := SearchFieldRef[1].Value;
                exit(1);
            end;
        end;
        SearchFieldRef[1].SetRange();
        ClearLastError();

        RecWithoutQuote := ConvertStr(SearchText, '''()&|', '?????');

        // Try FINDFIRST "No." by mask "Search string *"
        if TrySetFilterOnFieldRefDLT(SearchFieldRef[1], RecWithoutQuote + '*') then begin
            RecRef.SetLoadFields(SearchFieldRef[1].Number);
            if RecRef.FindFirst() then begin
                Result := SearchFieldRef[1].Value;
                exit(1);
            end;
        end;
        SearchFieldRef[1].SetRange();
        ClearLastError();

        // Two items with descrptions = "aaa" and "AAA";
        // Try FINDFIRST by exact "Description" = "AAA"
        SearchFieldRef[2].SetRange(CopyStr(SearchText, 1, SearchFieldRef[2].Length));
        RecRef.SetLoadFields(SearchFieldRef[1].Number);
        if RecRef.FindFirst() then begin
            Result := SearchFieldRef[1].Value;
            exit(1);
        end;
        SearchFieldRef[2].SetRange();

        // Example of SearchText = "Search string ''";
        // Try FINDFIRST "Description" by mask "@Search string ?"
        SearchFieldRef[2].SetFilter('''@' + RecWithoutQuote + '''');
        RecRef.SetLoadFields(SearchFieldRef[1].Number);
        if RecRef.FindFirst() then begin
            Result := SearchFieldRef[1].Value;
            exit(1);
        end;
        SearchFieldRef[2].SetRange();

        // Try FINDFIRST "No." OR "Description" by mask "@Search string ?*"
        RecRef.FilterGroup := -1;
        RecFilterFromStart := '''@' + RecWithoutQuote + '*''';
        SearchFieldRef[1].SetFilter(RecFilterFromStart);
        SearchFieldRef[2].SetFilter(RecFilterFromStart);
        OnBeforeFindRecordStartingWithSearchStringDLT(Type, RecRef, RecFilterFromStart);
        RecRef.SetLoadFields(SearchFieldRef[1].Number);
        if RecRef.FindFirst() then begin
            Result := SearchFieldRef[1].Value;
            exit(1);
        end;

        // Try FINDFIRST "No." OR "Description" OR additional field by mask "@*Search string ?*"
        RecFilterContains := '''@*' + RecWithoutQuote + '*''';
        SearchFieldRef[1].SetFilter(RecFilterContains);
        SearchFieldRef[2].SetFilter(RecFilterContains);
        if SearchFieldNo[3] <> 0 then
            SearchFieldRef[3].SetFilter(RecFilterContains);
        OnBeforeFindRecordContainingSearchStringDLT(Type, RecRef, RecFilterContains);
        RecRef.SetLoadFields(SearchFieldRef[1].Number);
        if RecRef.FindFirst() then begin
            Result := SearchFieldRef[1].Value;
            exit(RecRef.Count);
        end;

        // Try FINDLAST record with similar "Description"
        IsHandled := false;
        OnFindRecordByDescriptionAndViewOnBeforeFindRecordWithSimilarNameDLT(RecRef, SearchText, SearchFieldNo, IsHandled);
        if not IsHandled then begin
            RecRef.SetLoadFields(SearchFieldRef[1].Number);
            if FindRecordMgt.FindRecordWithSimilarName(RecRef, SearchText, SearchFieldNo[2]) then begin
                Result := SearchFieldRef[1].Value;
                exit(1);
            end;
        end;

        // Try find for extension
        MatchCount := 0;
        OnAfterFindRecordByDescriptionAndViewDLT(Result, Type, RecRef, SearchFieldRef, SearchFieldNo, SearchText, MatchCount);
        if MatchCount <> 0 then
            exit(MatchCount);

        // Not found
        exit(0);
    end;

    local procedure GetRecRefAndFieldsNoByTypeDLT(RecRef: RecordRef; Type: Option " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)"; var SearchFieldNo: array[4] of Integer)
    var
        GLAccount: Record "G/L Account";
        Item: Record Item;
        FixedAsset: Record "Fixed Asset";
        Resource: Record Resource;
        ItemCharge: Record "Item Charge";
        StandardText: Record "Standard Text";
    begin
        OnBeforeGetRecRefAndFieldsNoByTypeDLT(RecRef, Type, SearchFieldNo);
        case Type of
            Type::"G/L Account":
                begin
                    RecRef.Open(DATABASE::"G/L Account");
                    SearchFieldNo[1] := GLAccount.FieldNo("No.");
                    SearchFieldNo[2] := GLAccount.FieldNo(Name);
                    SearchFieldNo[3] := 0;
                end;
            Type::Item:
                begin
                    RecRef.Open(DATABASE::Item);
                    SearchFieldNo[1] := Item.FieldNo("No.");
                    SearchFieldNo[2] := Item.FieldNo(Description);
                    SearchFieldNo[3] := Item.FieldNo("Base Unit of Measure");
                end;
            Type::Resource:
                begin
                    RecRef.Open(DATABASE::Resource);
                    SearchFieldNo[1] := Resource.FieldNo("No.");
                    SearchFieldNo[2] := Resource.FieldNo(Name);
                    SearchFieldNo[3] := 0;
                end;
            Type::"Fixed Asset":
                begin
                    RecRef.Open(DATABASE::"Fixed Asset");
                    SearchFieldNo[1] := FixedAsset.FieldNo("No.");
                    SearchFieldNo[2] := FixedAsset.FieldNo(Description);
                    SearchFieldNo[3] := 0;
                end;
            Type::"Charge (Item)":
                begin
                    RecRef.Open(DATABASE::"Item Charge");
                    SearchFieldNo[1] := ItemCharge.FieldNo("No.");
                    SearchFieldNo[2] := ItemCharge.FieldNo(Description);
                    SearchFieldNo[3] := 0;
                end;
            Type::" ":
                begin
                    RecRef.Open(DATABASE::"Standard Text");
                    SearchFieldNo[1] := StandardText.FieldNo(Code);
                    SearchFieldNo[2] := StandardText.FieldNo(Description);
                    SearchFieldNo[3] := 0;
                end;
        end;
        OnAfterGetRecRefAndFieldsNoByTypeDLT(RecRef, Type, SearchFieldNo);
    end;

    [TryFunction]
    local procedure TrySetFilterOnFieldRefDLT(var FieldRef: FieldRef; "Filter": Text)
    begin
        FieldRef.SetFilter(Filter);
    end;

    var
        FindRecordMgt: Codeunit "Find Record Management";

    [IntegrationEvent(false, false)]
    procedure EDMSOnNewCheckRemoveCustomerNotifications(RecId: RecordID; RecallCreditOverdueNotif: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFindRecordByDescriptionAndViewDLT(var Result: Text; Type: Option " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)"; var RecRef: RecordRef; SearchFieldRef: array[4] of FieldRef; SearchText: Text; RecordView: Text; var MatchCount: Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFindRecordStartingWithSearchStringDLT(Type: Option " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)"; var RecRef: RecordRef; RecFilterFromStart: Text)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFindRecordContainingSearchStringDLT(Type: Option " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)"; var RecRef: RecordRef; RecFilterFromStart: Text)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnFindRecordByDescriptionAndViewOnBeforeFindRecordWithSimilarNameDLT(RecRef: RecordRef; var SearchText: Text; var SearchFieldNo: array[4] of Integer; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterFindRecordByDescriptionAndViewDLT(var Result: Text; Type: Option " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)"; var RecRef: RecordRef; SearchFieldRef: array[4] of FieldRef; SearchFieldNo: array[4] of Integer; SearchText: Text; var MatchCount: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetRecRefAndFieldsNoByTypeDLT(RecRef: RecordRef; Type: Option " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)"; var SearchFieldNo: array[4] of Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetRecRefAndFieldsNoByTypeDLT(RecRef: RecordRef; Type: Option " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)"; var SearchFieldNo: array[4] of Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeShowShipmentReceiptDialog(var TransHeader: Record "Transfer Header"; DefaultNumberEDMS: Option; VAR lIsHandled: Boolean)
    begin
    end;

}

