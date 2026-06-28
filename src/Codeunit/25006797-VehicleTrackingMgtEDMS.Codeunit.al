Codeunit 25006797 "Vehicle Tracking Mgt. EDMS"
{
    //Ramzi
    Var
        Currency: Record Currency;
        PurchLineACY: Record "Purchase Line";



    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Post Invoice Events", 'OnAfterPrepareInvoicePostingBuffer', '', false, false)]
    local procedure OnAfterPrepareSales(var SalesLine: Record "Sales Line"; var InvoicePostingBuffer: Record "Invoice Posting Buffer")
    var
        SalesHeader: Record "Sales Header";
        DealType: Record "Deal Type";
        VehicleNotMandatory: Boolean;

    begin
        //EDMS >>
        if SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then
            case SalesHeader."Document Profile" of
                SalesHeader."Document Profile"::"Vehicles Trade":
                    begin
                        InvoicePostingBuffer."Vehicle Serial No." := SalesLine."Vehicle Serial No.";
                        InvoicePostingBuffer."Vehicle Accounting Cycle No." := SalesLine."Vehicle Accounting Cycle No.";
                        InvoicePostingBuffer."Additional Grouping Identifier" := CopyStr(SalesLine."Vehicle Serial No." + SalesLine."Vehicle Accounting Cycle No.", 1, 20);
                    end;

                SalesHeader."Document Profile"::Service:
                    begin
                        VehicleNotMandatory := false;
                        if SalesHeader."Deal Type Code" <> '' then begin
                            if DealType.Get(SalesHeader."Deal Type Code") then
                                VehicleNotMandatory := DealType."Vehicle Not Mandatory";
                        end;
                        if not VehicleNotMandatory then begin
                            SalesHeader.TestField("Vehicle Serial No.");
                            InvoicePostingBuffer."Vehicle Serial No." := SalesHeader."Vehicle Serial No.";
                            InvoicePostingBuffer."Vehicle Accounting Cycle No." := SalesHeader."Vehicle Accounting Cycle No.";
                            InvoicePostingBuffer."Additional Grouping Identifier" := CopyStr(SalesHeader."Vehicle Serial No." + SalesHeader."Vehicle Accounting Cycle No.", 1, 20);
                        end;
                    end;
                //13.01.2022 EB.KN >>
                SalesHeader."Document Profile"::" ", SalesHeader."Document Profile"::Rent, SalesHeader."Document Profile"::"Spare Parts Trade":
                    begin
                        if SalesLine."Vehicle Serial No." <> '' then begin
                            InvoicePostingBuffer."Vehicle Serial No." := SalesLine."Vehicle Serial No.";
                            InvoicePostingBuffer."Vehicle Accounting Cycle No." := SalesLine."Vehicle Accounting Cycle No.";
                            InvoicePostingBuffer."Additional Grouping Identifier" := CopyStr(SalesLine."Vehicle Serial No." + SalesLine."Vehicle Accounting Cycle No.", 1, 20);
                        end else begin
                            if SalesHeader."Vehicle Serial No." <> '' then begin
                                InvoicePostingBuffer."Vehicle Serial No." := SalesHeader."Vehicle Serial No.";
                                InvoicePostingBuffer."Vehicle Accounting Cycle No." := SalesHeader."Vehicle Accounting Cycle No.";
                                InvoicePostingBuffer."Additional Grouping Identifier" := CopyStr(SalesLine."Vehicle Serial No." + SalesLine."Vehicle Accounting Cycle No.", 1, 20);
                            end;
                        end;
                    end;
            //13.01.2022 EB.KN <<
            end;
        //EDMS <<

    end;


    [EventSubscriber(ObjectType::Table, database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromPurchHeader', '', false, false)]
    local procedure OnAfterCopyGenJnlLineFromPurchHeader(PurchaseHeader: Record "Purchase Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."Deal Type Code" := PurchaseHeader."Deal Type Code";       //20.08.2018 EB EDMS
    end;


    [EventSubscriber(ObjectType::Table, database::"Gen. Journal Line", 'OnAfterCopyGenJnlLineFromSalesHeader', '', false, false)]
    local procedure OnAfterCopyGenJnlLineFromSalesHeader(SalesHeader: Record "Sales Header"; var GenJournalLine: Record "Gen. Journal Line")
    begin
        GenJournalLine."Rent Order No." := SalesHeader."Rent Order No.";       // EB.P30 EDMS RENT

        GenJournalLine."Deal Type Code" := SalesHeader."Deal Type Code";       //20.08.2018 EB EDMS
    end;




    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnAfterValidateEvent', 'Applies-to Doc. No.', false, false)]

    local procedure OnAfterValidateEventAppliesToDocNo(var Rec: Record "Gen. Journal Line"; var xRec: Record "Gen. Journal Line"; CurrFieldNo: Integer)

    begin
        //08.04.2014 Elva Baltic P1 #RX MMG7.00 >>
        Rec.SetDefSalesperson;
        //08.04.2014 Elva Baltic P1 #RX MMG7.00 <<
    end;

    [EventSubscriber(ObjectType::Table, Database::"Item Journal Line", 'OnBeforeValidateEvent', 'Item No.', false, false)]

    local procedure OnBeforeValidateEventItemNo(var Rec: Record "Item Journal Line"; var xRec: Record "Item Journal Line"; CurrFieldNo: Integer)
    var
        ItemJnlBatch: Record "Item Journal Batch";
    begin
        //EDMS1.0.00 >>
        if ItemJnlBatch.Get(Rec."Journal Template Name", Rec."Journal Batch Name") then begin
            if ItemJnlBatch."Location Code" <> '' then
                Rec.Validate("Location Code", ItemJnlBatch."Location Code");
            if ItemJnlBatch."New Location Code" <> '' then
                Rec.Validate("New Location Code", ItemJnlBatch."New Location Code");
        end;
        //EDMS1.0.00 <<

    end;



    [EventSubscriber(ObjectType::Table, database::"Item Journal Line", 'OnValidateItemNoOnAfterGetItem', '', false, false)]
    local procedure OnValidateItemNoOnAfterGetItem(var ItemJournalLine: Record "Item Journal Line"; Item: Record Item)
    begin

        //EDMS1.0.00 >>
        ItemJournalLine."Item Type" := Item."Item Type";
        if ItemJournalLine."Item Type" = Item."item type"::"Model Version" then begin
            ItemJournalLine."Make Code" := Item."Make Code";
            ItemJournalLine."Model Code" := Item."Model Code";
            ItemJournalLine."Model Version No." := Item."No.";
        end;
        //EDMS1.0.00 <<
    end;


    [EventSubscriber(ObjectType::Table, database::"Item Journal Line", 'OnBeforeFindUnitCost', '', false, false)]
    local procedure OnBeforeFindUnitCost(var ItemJournalLine: Record "Item Journal Line"; var UnitCost: Decimal; var IsHandled: Boolean)
    var
        Item: Record Item;
        UnitCost2: Decimal;
        VehAdditionalExpenses: Boolean;
    begin
        VehAdditionalExpenses := ItemJournalLine.GetVehAdditionalExpenses();
        //07.11.2007. EDMS P2 >>
        IF item.get(ItemJournalLine."Item No.") then
            if (Item."Item Type" = Item."item type"::"Model Version") and (ItemJournalLine."Vehicle Serial No." <> '') then begin
                UnitCost2 := ItemJournalLine.CalcVehicleUnitCost(ItemJournalLine."Vehicle Serial No.", VehAdditionalExpenses);
                if UnitCost2 <> 0 then Begin
                    UnitCost := UnitCost2;
                    IsHandled := true;
                end;
            end;
        //07.11.2007. EDMS P2 <<
    end;


    [EventSubscriber(ObjectType::Table, database::"Item Journal Line", 'OnBeforeLookupItemNo', '', false, false)]
    local procedure OnBeforeLookupItemNo(var ItemJournalLine: Record "Item Journal Line"; var IsHandled: Boolean)
    Var
        Item: Record item;
        cuLookUpMgt: Codeunit LookUpManagement;
    begin
        If (ItemJournalLine."Entry Type" <> ItemJournalLine."Entry Type"::Consumption) and
        (ItemJournalLine."Entry Type" <> ItemJournalLine."Entry Type"::Output) then begin

            Item.Reset;
            if cuLookUpMgt.LookUpItemREZ(Item, ItemJournalLine."Item No.") then
                ItemJournalLine.Validate("Item No.", Item."No.");


            IsHandled := true;

        end;

    end;


    [EventSubscriber(ObjectType::codeunit, Codeunit::"Sales-Post", 'OnPostSalesLineOnBeforeTestUnitOfMeasureCode', '', false, false)]
    local procedure OnPostSalesLineOnBeforeTestUnitOfMeasureCode(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var TempSalesLineGlobal: Record "Sales Line" temporary)
    Var
        VehReserveSalesLine: Codeunit "Sales Line-Veh. Reserve";
    begin

        if SalesLine."Line Type" = SalesLine."line type"::Vehicle then
            VehReserveSalesLine.CheckReservation(TempSalesLineGlobal);
    end;

    [EventSubscriber(ObjectType::codeunit, Codeunit::"Sales-Post", 'OnRunOnBeforeCheckAndUpdate', '', false, false)]
    local procedure OnRunOnBeforeCheckAndUpdate(var SalesHeader: Record "Sales Header")
    var
        Vehicle: Record Vehicle;
        VehicleContact: Record "Vehicle Contact";
        SalesInvHeaderServ: Record "Sales Invoice Header";
        SalesCrMemoHdrServ: Record "Sales Cr.Memo Header";
        isFound: Boolean;
        UserProfileMgt: Codeunit UserProfileManagement;
        UserProfile: Record "Branch Profile Setup";
        PostedServOrderLineEDMS: Record "Posted Serv. Order Line";
        PostedReturnServOrderLineEDMS: Record "Posted Serv. Return Order Line";
        NewLineNo: Integer;
        ToBin: Code[20];
        ItemCharge: Record "Item Charge";
        ServicePostEDMS: Codeunit "Service-Post EDMS";
        SalesLineTmpDefault: Record "Sales Line";
        SalesLine2: Record "Sales Line";
        VehContactBusinessRelation: Record "Contact Business Relation";
        cuVehSN: Codeunit "Vehicle Serial No. Mgt.";
        VehOptionManagement: Codeunit VehicleOptionManagement;
        SalesLine: Record "Sales Line";
        SalesSetup: Record "Sales & Receivables Setup";
        ChApplyToDocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Receipt,"Transfer Receipt","Return Shipment","Sales Shipment","Return Receipt";
        ChApplyToDocNo: Code[20];
        ChApplyToLineNo: Integer;
        ChApplyToItemNo: Code[20];
        PostPurchInvc: Boolean;
        MarketingSetup: Record "Marketing Setup";
    begin

        //EDMS1.0.00 P3>>
        SalesSetup.Get;
        MarketingSetup.get;
        MarketingSetup.TestField("Bus. Rel. Code for Customers");
        //EDMS1.0.00 P3<<
        //EDMS1.0.00 P3>>
        if SalesHeader."Document Profile" = SalesHeader."document profile"::Service then begin
            if SalesSetup."Payment Method Mandatory" then
                SalesHeader.TestField(SalesHeader."Payment Method Code");
            if SalesHeader."Vehicle Item Charge No." <> '' then begin
                PostPurchInvc := FindItemEntryForApplyCh(SalesHeader."Vehicle Serial No.", SalesHeader."Vehicle Accounting Cycle No.",
                    ChApplyToDocType, ChApplyToDocNo, ChApplyToLineNo, ChApplyToItemNo);
                SalesHeader.TestField("Model Version No.");
                SalesHeader."Post Purchasing Invoice" := PostPurchInvc;
                SalesHeader."Apply To Doc Type EDMS" := ChApplyToDocType;
                SalesHeader."Apply To Doc No EDMS" := ChApplyToDocNo;
                SalesHeader."Apply To Line No EDMS" := ChApplyToLineNo;
                SalesHeader."Apply To Item No EDMS" := ChApplyToItemNo;
            end;
        end;
        //EDMS1.0.00 P3<<
        //Moved To OnAfterCheckAndUpdate
        /*         //EDMS1.0.00 P3>>
                if SalesHeader."Document Profile" = SalesHeader."document profile"::"Vehicles Trade" then begin
                    SalesLine.Reset;
                    SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                    SalesLine.SetRange("Document No.", SalesHeader."No.");
                    if SalesLine.FindFirst then
                        repeat
                            if (SalesLine."Line Type" = SalesLine."line type"::Vehicle) and (SalesLine."Vehicle Serial No." <> '') then begin
                                if Vehicle.Get(SalesLine."Vehicle Serial No.") then begin
                                    // 23.05.2016 EB.P30 >>
                                    VehContactBusinessRelation.Reset;
                                    VehContactBusinessRelation.SetRange("Link to Table", VehContactBusinessRelation."link to table"::Customer);
                                    VehContactBusinessRelation.SetRange("Business Relation Code", MarketingSetup."Bus. Rel. Code for Customers");
                                    VehContactBusinessRelation.SetRange("No.", SalesHeader."Sell-to Customer No.");
                                    if VehContactBusinessRelation.FindFirst then begin
                                        VehicleContact.Init;
                                        VehicleContact.Validate("Vehicle Serial No.", SalesLine."Vehicle Serial No.");
                                        VehicleContact.Validate("Contact No.", VehContactBusinessRelation."Contact No.");
                                        if SalesSetup."Def.Vehicle-Contact Rel." <> '' then
                                            VehicleContact.Validate("Relationship Code", SalesSetup."Def.Vehicle-Contact Rel.");
                                        if VehicleContact.Insert(true) then;
                                        // << 23.05.2016 EB.P30
                                    end;
                                end;
                            end;
                        until SalesLine.Next = 0;
                end;
                //EDMS1.0.00 P3<< */


        //10.05.2014 EB.P8 EDMS >>
        Clear(SalesLineTmpDefault);
        SalesLineTmpDefault.Init;
        SalesLine2.Reset;
        SalesLine2.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine2.SetRange("Document No.", SalesHeader."No.");
        SalesLine2.SetFilter("Vehicle Serial No.", '<>%1', '');
        if SalesLine2.FindFirst then begin
            SalesLineTmpDefault.TransferFields(SalesLine2);
            repeat
                if (SalesLine2."Vehicle Serial No." <> '') and
                    (SalesLine2."Vehicle Serial No." <> SalesLineTmpDefault."Vehicle Serial No.") then
                    isFound := true;
            until SalesLine2.Next = 0;
            if isFound then begin
                SalesHeader.VIN := '';
                SalesHeader."Vehicle Serial No." := '';
                SalesHeader."Vehicle Accounting Cycle No." := '';
            end else begin
                SalesHeader.VIN := SalesLineTmpDefault.VIN;
                SalesHeader."Vehicle Serial No." := SalesLineTmpDefault."Vehicle Serial No.";
                SalesHeader."Vehicle Accounting Cycle No." := SalesLineTmpDefault."Vehicle Accounting Cycle No.";
            end;
        end;
        //10.05.2014 EB.P8 EDMS <<

    end;

    [EventSubscriber(ObjectType::codeunit, Codeunit::"Sales-Post", 'OnAfterCheckAndUpdate', '', false, false)]
    local procedure OnAfterCheckAndUpdateModifyVehicle(var SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        Vehicle: Record Vehicle;
        VehicleContact: Record "Vehicle Contact";
        VehContactBusinessRelation: Record "Contact Business Relation";
        SalesSetup: Record "Sales & Receivables Setup";
        MarketingSetup: Record "Marketing Setup";
    BEGIN
        if SalesHeader."Document Profile" = SalesHeader."document profile"::"Vehicles Trade" then begin
            MarketingSetup.get();
            SalesSetup.get();
            SalesLine.Reset;
            SalesLine.SetRange("Document Type", SalesHeader."Document Type");
            SalesLine.SetRange("Document No.", SalesHeader."No.");
            if SalesLine.FindFirst then
                repeat
                    if (SalesLine."Line Type" = SalesLine."line type"::Vehicle) and (SalesLine."Vehicle Serial No." <> '') then begin
                        if Vehicle.Get(SalesLine."Vehicle Serial No.") then begin
                            // 23.05.2016 EB.P30 >>
                            VehContactBusinessRelation.Reset;
                            VehContactBusinessRelation.SetRange("Link to Table", VehContactBusinessRelation."link to table"::Customer);
                            VehContactBusinessRelation.SetRange("Business Relation Code", MarketingSetup."Bus. Rel. Code for Customers");
                            VehContactBusinessRelation.SetRange("No.", SalesHeader."Sell-to Customer No.");
                            if VehContactBusinessRelation.FindFirst then begin
                                VehicleContact.Init;
                                VehicleContact.Validate("Vehicle Serial No.", SalesLine."Vehicle Serial No.");
                                VehicleContact.Validate("Contact No.", VehContactBusinessRelation."Contact No.");
                                if SalesSetup."Def.Vehicle-Contact Rel." <> '' then
                                    VehicleContact.Validate("Relationship Code", SalesSetup."Def.Vehicle-Contact Rel.");
                                if VehicleContact.Insert(true) then;
                                // << 23.05.2016 EB.P30
                            end;
                        end;
                    end;
                until SalesLine.Next = 0;
        end;
    END;



    procedure FindItemEntryForApplyCh(VehSerialNo: Code[20]; VehAccCycleNo: Code[20]; var AplDocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Receipt,"Transfer Receipt","Return Shipment","Sales Shipment","Return Receipt"; var AplDocNo: Code[20]; var AplLineNo: Integer; var AplItemNo: Code[20]): Boolean
    var
        TRRcptLine: Record "Transfer Receipt Line";
        PurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        PurchRcptLine.Reset;
        PurchRcptLine.SetCurrentkey(Type, "Line Type", "Vehicle Serial No.", "Vehicle Accounting Cycle No.");
        PurchRcptLine.SetRange(Type, PurchRcptLine.Type::Item);
        PurchRcptLine.SetRange("Line Type", PurchRcptLine."line type"::Vehicle);
        PurchRcptLine.SetRange("Vehicle Serial No.", VehSerialNo);
        PurchRcptLine.SetRange("Vehicle Accounting Cycle No.", VehAccCycleNo);
        if PurchRcptLine.FindLast then begin
            AplDocType := Apldoctype::Receipt;
            AplDocNo := PurchRcptLine."Document No.";
            AplLineNo := PurchRcptLine."Line No.";
            AplItemNo := PurchRcptLine."No.";
            exit(true)
        end;
        TRRcptLine.Reset;
        TRRcptLine.SetCurrentkey("Vehicle Serial No.", "Vehicle Accounting Cycle No.", "Receipt Date");
        TRRcptLine.SetRange("Vehicle Serial No.", VehSerialNo);
        TRRcptLine.SetRange("Vehicle Accounting Cycle No.", VehAccCycleNo);
        if TRRcptLine.FindFirst then begin
            AplDocType := Apldoctype::"Transfer Receipt";
            AplDocNo := TRRcptLine."Document No.";
            AplLineNo := TRRcptLine."Line No.";
            AplItemNo := TRRcptLine."Item No.";
            exit(true)
        end else
            exit(false)
    end;




    [EventSubscriber(ObjectType::codeunit, Codeunit::"Sales-Post", 'OnAfterCheckAndUpdate', '', false, false)]
    local procedure OnAfterCheckAndUpdate(var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean)
    Var
        PurchInvcHeader: record "Purchase Header";

    begin
        //EDMS1.0.00 >>
        SalesHeader.CalcFields(Amount);
        if (SalesHeader."Document Profile" = SalesHeader."document profile"::Service) and
          (SalesHeader."Vehicle Item Charge No." <> '') and (SalesHeader.Amount <> 0) then Begin
            CreatePurchInvcHeader(SalesHeader, PurchInvcHeader);
            SalesHeader."Purchase Doc No" := PurchInvcHeader."No.";
        End;
        //EDMS1.0.00 >>

    end;


    procedure CreatePurchInvcHeader(SalesHeader: Record "Sales Header"; var PurchInvcHdr: Record "Purchase Header")
    var
        SalesLine3: Record "Sales Line";
        Customer: Record Customer;
        PurchSetup: Record "Purchases & Payables Setup";
        PostPurchInvHdr: Record "Purch. Inv. Header";
        NoSeriesMgt: Codeunit "No. Series";
    begin
        if SalesHeader."Vehicle Item Charge No." = '' then exit;

        Customer.Get(SalesHeader."Sell-to Customer No.");
        if Customer."Corresponding Vendor No." = '' then begin
            Customer.Get(SalesHeader."Bill-to Customer No.");
            Customer.TestField("Corresponding Vendor No.")
        end;

        PurchInvcHdr.Init;
        PurchInvcHdr."Document Type" := SalesHeader."Document Type";
        //>>DELTA 01
        OnBeforeInsertPurchaseInvoiceHeader(PurchInvcHdr, SalesHeader);
        //<<DELTA 01
        PurchInvcHdr.Insert(true);

        PurchInvcHdr.TestField("Posting No. Series");


        PurchInvcHdr."Auto Created Doc" := true;
        case PurchInvcHdr."Document Type" of
            PurchInvcHdr."document type"::Invoice:
                //RC 14/06
                //"Vendor Invoice No." := GenJnlLineDocNo;

                PurchInvcHdr."Vendor Invoice No." := SalesHeader."Service Document No.";
            PurchInvcHdr."document type"::"Credit Memo":
                begin
                    // RC 14/06
                    // "Vendor Cr. Memo No." := GenJnlLineDocNo;

                    PurchInvcHdr."Vendor Cr. Memo No." := SalesHeader."Service Document No.";
                    ;
                    PurchInvcHdr."Applies-to Doc. Type" := PurchInvcHdr."applies-to doc. type"::Invoice;
                    PostPurchInvHdr.SetCurrentkey("Vendor Invoice No.", "Posting Date");
                    PostPurchInvHdr.SetRange("Vendor Invoice No.", SalesHeader."Applies-to Doc. No.");
                    if PostPurchInvHdr.FindFirst then
                        PurchInvcHdr."Applies-to Doc. No." := PostPurchInvHdr."No."
                end
        end;
        PurchInvcHdr."Posting Date" := SalesHeader."Posting Date";
        PurchInvcHdr."Document Date" := SalesHeader."Document Date";
        PurchInvcHdr."Document Profile" := PurchInvcHdr."document profile"::Service;

        PurchInvcHdr.Validate("Location Code", SalesHeader."Location Code");
        PurchInvcHdr.Validate("Payment Method Code", SalesHeader."Payment Method Code");
        PurchInvcHdr.Validate("Buy-from Vendor No.", Customer."Corresponding Vendor No.");
        PurchInvcHdr."Prices Including VAT" := SalesHeader."Prices Including VAT";

        PurchInvcHdr."Vehicle Serial No." := SalesHeader."Vehicle Serial No.";
        PurchInvcHdr."Vehicle Accounting Cycle No." := SalesHeader."Vehicle Accounting Cycle No.";
        PurchInvcHdr."Location Code" := SalesHeader."Location Code";
        // 10.03.2015 EDMS P21 >>
        if Customer."Item Charge Invoice Deal Type" <> '' then
            PurchInvcHdr.Validate("Deal Type Code", Customer."Item Charge Invoice Deal Type");
        // VALIDATE("Dimension Set ID", SalesHeader."Dimension Set ID");  //03.11.2014 EB.P8 #Exxx EDMS
        // 10.03.2015 EDMS P21 <<
        PurchInvcHdr.Modify;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", OnPostSalesLineOnBeforePostSalesLine, '', false, false)]
    local procedure "Sales-Post_OnPostSalesLineOnBeforePostSalesLine"(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; GenJnlLineDocNo: Code[20]; GenJnlLineExtDocNo: Code[35]; GenJnlLineDocType: Enum "Gen. Journal Document Type"; SrcCode: Code[10]; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; var IsHandled: Boolean; SalesLineACY: Record "Sales Line")
    var
        VehOptionManagement: Codeunit VehicleOptionManagement;
        ItemCharge: Record "Item Charge";
        PostedServOrderLineEDMS: Record "Posted Serv. Order Line";
        PostedReturnServOrderLineEDMS: Record "Posted Serv. Return Order Line";
        ServicePostEDMS: Codeunit "Service-Post EDMS";
        TempSalesLineForServicePosting: Record "Sales Line" temporary;
        TempSalesLineForRentPosting: Record "Sales Line" temporary;
        RentJnlLine: Record "Rent Journal Line";
        RentJnlPostLine: Codeunit "Rent Jnl.-Post Line";
        ExternalServiceTrackingNo: Record "External Serv. Tracking No.";
        ExtServiceJnlLine: Record "External Serv. Journal Line";
        ExtServiceJnlPostLine: Codeunit "Ext. Service Jnl.-Post Line";
        PurchInvcLine: Record "Purchase Line";
        ServJnlLine: Record "Serv. Journal Line";
        ServJnlPostLine: Codeunit "Serv. Jnl.-Post Line";
        PurchInvcHeader: Record "Purchase Header";
        IsHandledL: Boolean;
    begin
        VehTrackingMgtOnPostSalesLineOnBeforePostSalesLine(IsHandledL, SalesHeader);
        if IsHandledL then
            exit;
        case SalesLine.Type of

            //EDMS1.0.00 P5 >>
            SalesLine.Type::"External Service":
                if (SalesLine."Qty. to Invoice" <> 0) and
                (SalesLine."Line Discount %" <> 100)
                then begin
                    ExtServiceJnlLine.Init;
                    ExtServiceJnlLine."Posting Date" := SalesHeader."Posting Date";
                    ExtServiceJnlLine."Entry Type" := ExtServiceJnlLine."entry type"::Sale;
                    ExtServiceJnlLine."Reason Code" := SalesHeader."Reason Code";
                    ExtServiceJnlLine."Ext. Service No." := SalesLine."No.";
                    ExtServiceJnlLine."Ext. Service Tracking No." := SalesLine."External Serv. Tracking No.";
                    ExtServiceJnlLine.Description := SalesLine.Description;
                    ExtServiceJnlLine."Source Type" := ExtServiceJnlLine."source type"::Customer;
                    ExtServiceJnlLine."Source No." := SalesLine."Sell-to Customer No.";
                    ExtServiceJnlLine."Shortcut Dimension 1 Code" := SalesLine."Shortcut Dimension 1 Code";
                    ExtServiceJnlLine."Shortcut Dimension 2 Code" := SalesLine."Shortcut Dimension 2 Code";
                    ExtServiceJnlLine."Location Code" := SalesLine."Location Code";
                    ExtServiceJnlLine."Document No." := GenJnlLineDocNo;
                    ExtServiceJnlLine."External Document No." := GenJnlLineExtDocNo;
                    ExtServiceJnlLine.Quantity := SalesLine."Qty. to Invoice";
                    ExtServiceJnlLine.Amount := SalesLine.Amount;
                    ExtServiceJnlLine."Source Code" := SrcCode;
                    ExtServiceJnlLine."Posting No. Series" := SalesHeader."Posting No. Series";

                    //08.05.2021 EDMS.P7 BUG78 >>
                    if ExternalServiceTrackingNo.get(ExtServiceJnlLine."Ext. Service No.", ExtServiceJnlLine."Ext. Service Tracking No.") then begin
                        ExternalServiceTrackingNo.CalcFields("Vehicle Registration No.", VIN, "Make Code", "Model Code");
                        ExtServiceJnlLine."Service Order No." := ExternalServiceTrackingNo."Service Order No.";
                        ExtServiceJnlLine."Vehicle Serial No." := ExternalServiceTrackingNo."Vehicle Serial No.";
                        ExtServiceJnlLine."Vehicle Registration No." := ExternalServiceTrackingNo."Vehicle Registration No.";
                        ExtServiceJnlLine.VIN := ExternalServiceTrackingNo.VIN;
                        ExtServiceJnlLine."Make Code" := ExternalServiceTrackingNo."Make Code";
                        ExtServiceJnlLine."Model Code" := ExternalServiceTrackingNo."Model Code";
                    end;
                    //08.05.2021 EDMS.P7 BUG78 <<

                    //30.10.2012 EDMS >>
                    ExtServiceJnlPostLine.RunWithCheck(ExtServiceJnlLine);
                    //30.10.2012 EDMS <<
                end;
        //EDMS1.0.00 P5 <<
        end;

        //EDMS1.0.00 >>
        if SalesLine."Include In Veh. Sales Amt." then
            IncludeInVehSalesAmt(SalesLine);

        PurchInvcHeader.SetRange("No.", SalesHeader."Purchase Doc No");
        IF PurchInvcHeader.FindFirst() THEN
            if (PurchInvcHeader."No." <> '') and
              ((SalesLine.Type = SalesLine.Type::Item) or (SalesLine.Type = SalesLine.Type::"G/L Account") or
                (SalesLine.Type = SalesLine.Type::"External Service") and (SalesLine."Line Amount" <> 0))
            then begin
                PurchInvcLine.Init;
                PurchInvcLine.Validate("Document Type", PurchInvcHeader."Document Type");
                PurchInvcLine.Validate("Document No.", PurchInvcHeader."No.");
                PurchInvcLine."Line No." := SalesLine."Line No.";
                PurchInvcLine."Document Profile" := PurchInvcHeader."Document Profile";
                PurchInvcLine.Validate("Line Type", PurchInvcLine."line type"::"Charge (Item)");
                PurchInvcLine.Validate("No.", SalesHeader."Vehicle Item Charge No.");
                ItemCharge.Get(SalesHeader."Vehicle Item Charge No.");
                PurchInvcLine.Validate("Posting Group", ItemCharge."Inventory Posting Group");
                PurchInvcLine.Validate(Quantity, SalesLine.Quantity);
                PurchInvcLine.Validate("Buy-from Vendor No.", PurchInvcHeader."Buy-from Vendor No.");
                PurchInvcLine.Validate("Direct Unit Cost", SalesLine."Unit Price");
                PurchInvcLine.Validate("Line Discount %", SalesLine."Line Discount %");
                PurchInvcLine."System-Created Entry" := true;
                PurchInvcLine."Deal Type Code" := SalesLine."Deal Type Code";
                PurchInvcLine.Validate("Vehicle Serial No.", SalesHeader."Vehicle Serial No.");
                PurchInvcLine.Description := SalesLine.Description;
                PurchInvcLine."Location Code" := PurchInvcHeader."Location Code";
                PurchInvcLine.Validate("Dimension Set ID", SalesLine."Dimension Set ID");  //10.05.2014 EB.P8 EDMS
                PurchInvcLine.Validate("Unit of Measure Code", SalesLine."Unit of Measure Code");
                //>>DELTA 01
                OnBeforeInsertPurchaseInvoiceLine(PurchInvcLine, SalesHeader, SalesLine);
                //<<DELTA 01
                PurchInvcLine.Insert(true);
                CreateItemChargeAssgnt(PurchInvcHeader, PurchInvcLine, SalesHeader."Apply To Doc Type EDMS", SalesHeader."Apply To Doc No EDMS",
                  SalesHeader."Apply To Line No EDMS", SalesHeader."Apply To Item No EDMS", SalesHeader."Post Purchasing Invoice");


            end;
        //10.05.2014 EB.P8 EDMS >>
        TempSalesLineForServicePosting := SalesLine;
        if (SalesHeader."Document Profile" = SalesHeader."document profile"::Service) and IsServiceLine(TempSalesLineForServicePosting) then begin
            ServJnlLine.Init;
            ServJnlLine."Posting Date" := SalesHeader."Posting Date";
            ServJnlLine."Document Date" := SalesHeader."Document Date";
            ServJnlLine."Document Type" := TempSalesLineForServicePosting."Document Type";

            ServJnlLine."Vehicle Serial No." := SalesHeader."Vehicle Serial No.";
            ServJnlLine."Make Code" := SalesHeader."Make Code";
            ServJnlLine."Model Code" := SalesHeader."Model Code";
            ServJnlLine."Model Version No." := SalesHeader."Model Version No.";
            ServJnlLine."Vehicle Accounting Cycle No." := SalesHeader."Vehicle Accounting Cycle No.";

            ServJnlLine."Responsibility Center" := SalesHeader."Responsibility Center";
            ServJnlLine.Description := TempSalesLineForServicePosting.Description;
            ServJnlLine."Job No." := TempSalesLineForServicePosting."Job No.";
            ServJnlLine."Unit of Measure Code" := TempSalesLineForServicePosting."Unit of Measure Code";
            ServJnlLine."Shortcut Dimension 1 Code" := SalesHeader."Shortcut Dimension 1 Code";
            ServJnlLine."Shortcut Dimension 2 Code" := SalesHeader."Shortcut Dimension 2 Code";
            ServJnlLine."Dimension Set ID" := SalesHeader."Dimension Set ID";
            ServJnlLine."Gen. Bus. Posting Group" := TempSalesLineForServicePosting."Gen. Bus. Posting Group";
            ServJnlLine."Gen. Prod. Posting Group" := TempSalesLineForServicePosting."Gen. Prod. Posting Group";
            ServJnlLine."Entry Type" := ServJnlLine."entry type"::Sale;
            ServJnlLine."Pre-Assigned No." := TempSalesLineForServicePosting."Document No.";
            ServJnlLine."Document No." := GenJnlLineDocNo;
            ServJnlLine."Document Line No." := TempSalesLineForServicePosting."Line No.";                                              // 10.05.2014 Elva Baltic P21
            ServJnlLine."Service Order No." := TempSalesLineForServicePosting."Service Order No. EDMS";
            ServJnlLine."Warranty Claim No." := SalesHeader."Warranty Claim No.";
            ServJnlLine."External Document No." := GenJnlLineExtDocNo;
            ServJnlLine."Unit Cost" := TempSalesLineForServicePosting."Unit Cost (LCY)";
            if not SalesHeader."Prices Including VAT" then begin
                ServJnlLine."Line Discount Amount" := TempSalesLineForServicePosting."Line Discount Amount";
                ServJnlLine."Inv. Discount Amount" := TempSalesLineForServicePosting."Inv. Discount Amount";
                ServJnlLine."Unit Price" := TempSalesLineForServicePosting."Unit Price";
                ServJnlLine."Line Discount Amount (LCY)" := SalesLine."Line Discount Amount";
                ServJnlLine."Inv. Discount Amount (LCY)" := SalesLine."Inv. Discount Amount";
            end else begin
                ServJnlLine."Line Discount Amount" := ROUND(TempSalesLineForServicePosting."Line Discount Amount" / (1 + SalesLine."VAT %" / 100));
                ServJnlLine."Inv. Discount Amount" := ROUND(TempSalesLineForServicePosting."Inv. Discount Amount" / (1 + SalesLine."VAT %" / 100));
                ServJnlLine."Unit Price" := ROUND(SalesLine."Unit Price" / (1 + SalesLine."VAT %" / 100));
                ServJnlLine."Line Discount Amount (LCY)" := ROUND(SalesLine."Line Discount Amount" / (1 + SalesLine."VAT %" / 100));
                ServJnlLine."Inv. Discount Amount (LCY)" := ROUND(SalesLine."Inv. Discount Amount" / (1 + SalesLine."VAT %" / 100));
            end;

            //17/05/2018 P30 >>
            ServJnlLine.Amount := -TempSalesLineForServicePosting.Amount;
            ServJnlLine."Amount Including VAT" := TempSalesLineForServicePosting."Amount Including VAT";
            ServJnlLine."Amount (LCY)" := SalesLine.Amount; //Sales Line Amount is transferred to amount in LCY
            ServJnlLine."Amount Including VAT (LCY)" := SalesLine."Amount Including VAT";
            ServJnlLine."Line Discount Amount" := -ServJnlLine."Line Discount Amount";
            ServJnlLine."Inv. Discount Amount" := -ServJnlLine."Inv. Discount Amount";
            ServJnlLine.Quantity := -TempSalesLineForServicePosting."Qty. to Invoice";
            ServJnlLine."Total Cost" := TempSalesLineForServicePosting."Unit Cost (LCY)" * ServJnlLine.Quantity;
            if TempSalesLineForServicePosting."Document Type" = TempSalesLineForServicePosting."document type"::Invoice then begin
                if PostedServOrderLineEDMS.Get(TempSalesLineForServicePosting."Service Order No. EDMS", TempSalesLineForServicePosting."Service Order Line No. EDMS") then
                    ServJnlLine."Quantity (Hours)" := -PostedServOrderLineEDMS."Quantity (Hours)";
            end else begin
                if PostedReturnServOrderLineEDMS.Get(TempSalesLineForServicePosting."Service Order No. EDMS", TempSalesLineForServicePosting."Service Order Line No. EDMS") then
                    ServJnlLine."Quantity (Hours)" := PostedReturnServOrderLineEDMS."Quantity (Hours)";
            end;
            //17/05/2018 P30 <<

            ServJnlLine."Currency Code" := TempSalesLineForServicePosting."Currency Code";
            ServJnlLine."Source Code" := SrcCode;
            ServJnlLine.Type := TempSalesLineForServicePosting."Line Type";
            if SalesLine.Type = TempSalesLineForServicePosting.Type::"G/L Account" then begin
                if TempSalesLineForServicePosting."Order Line Type No." = '' then
                    ServJnlLine."No." := TempSalesLineForServicePosting."No."
                else
                    ServJnlLine."No." := TempSalesLineForServicePosting."Order Line Type No.";
            end else
                ServJnlLine."No." := TempSalesLineForServicePosting."No.";

            ServJnlLine."Customer No." := TempSalesLineForServicePosting."Sell-to Customer No.";
            ServJnlLine."Bill-to Customer No." := TempSalesLineForServicePosting."Bill-to Customer No.";
            ServJnlLine."Posting No. Series" := SalesHeader."Posting No. Series";
            ServJnlLine."Location Code" := TempSalesLineForServicePosting."Location Code";
            ServJnlLine."Discount %" := TempSalesLineForServicePosting."Line Discount %";
            ServJnlLine."Payment Method Code" := SalesHeader."Payment Method Code";
            //ServJnlLine."Variable Field Run 1" := SalesHeader."Variable Field Run 1";
            //ServJnlLine."Variable Field Run 2" := SalesHeader."Variable Field Run 2";
            //ServJnlLine."Variable Field Run 3" := SalesHeader."Variable Field Run 3";
            ServJnlLine."Package No." := TempSalesLineForServicePosting."Package No.";
            ServJnlLine."Package Version No." := TempSalesLineForServicePosting."Package Version No.";
            ServJnlLine."Package Version Spec. Line No." := TempSalesLineForServicePosting."Package Version Spec. Line No.";
            ServJnlLine."Deal Type Code" := TempSalesLineForServicePosting."Deal Type Code";
            ServJnlLine."Standard Time" := TempSalesLineForServicePosting."Standard Time";
            ServJnlLine."Campaign No." := TempSalesLineForServicePosting."Campaign No.";
            //30.07.2015 EB.P30 #T045 >>
            ServJnlLine."Service Receiver" := SalesHeader."Salesperson Code";
            //30.07.2015 EB.P30 #T045 <<
            FillServJournalVariableFields(ServJnlLine, TempSalesLineForServicePosting);
            ServJnlLine."Service Order No." := SalesHeader."Service Document No.";
            //28.05.2015 EB.P30 #T030 >>
            //20.07.2016 EB.P7 #AMStoDMS Address >>
            ServJnlLine."Service Address Code" := SalesHeader."Ship-to Code";
            ServJnlLine."Service Address" := SalesHeader."Ship-to Address";
            ServJnlLine."Variable Field Run 1" := SalesHeader."Variable Field Run 1";
            ServJnlLine."Variable Field Run 2" := SalesHeader."Variable Field Run 2";
            ServJnlLine."Variable Field Run 3" := SalesHeader."Variable Field Run 3";
            //20.07.2016 EB.P7 #AMStoDMS Address <<
            if ServJnlLine."Document Type" = ServJnlLine."document type"::Invoice then
                ServicePostEDMS.FillDetServJnlByResource(ServJnlLine, 1,
                  ServJnlLine."Service Order No.", TempSalesLineForServicePosting."Service Order Line No. EDMS", '111')  //08.04.2013 EDMS P8
            else
                ServicePostEDMS.FillDetServJnlByResource(ServJnlLine, 2,
                  ServJnlLine."Service Order No.", TempSalesLineForServicePosting."Service Order Line No. EDMS", '111');  //08.04.2013 EDMS P8
                                                                                                                          //28.05.2015 EB.P30 #T030 <<
            OnBeforeServJnlLineRunWithCheck(ServJnlLine, SalesHeader, SalesLine);
            ServJnlPostLine.RunWithCheck(ServJnlLine);//30.10.2012 EDMS
        end;
        //10.05.2014 EB.P8 EDMS <<
        //EDMS1.0.00 <<


        //EB.P30 RENT >>
        TempSalesLineForRentPosting := SalesLine;
        if SalesHeader."Rent Order No." <> '' then begin
            RentJnlLine.Init;
            RentJnlLine."Posting Date" := SalesHeader."Posting Date";
            RentJnlLine."Document Date" := SalesHeader."Document Date";
            RentJnlLine."Document Type" := TempSalesLineForRentPosting."Document Type";
            RentJnlLine."Document No." := GenJnlLineDocNo;
            RentJnlLine."External Document No." := SalesHeader."External Document No.";
            RentJnlLine."Document Line No." := TempSalesLineForRentPosting."Line No.";
            RentJnlLine.Description := TempSalesLineForRentPosting.Description;
            RentJnlLine."Entry Type" := RentJnlLine."entry type"::Sale;
            RentJnlLine."Rent Order Type" := RentJnlLine."rent order type"::Order;
            RentJnlLine."Rent Order No." := SalesHeader."Rent Order No.";
            RentJnlLine."Rent Order Line No." := TempSalesLineForRentPosting."Rent Order Line No.";
            RentJnlLine."Rent Order Sales Line No." := TempSalesLineForRentPosting."Rent Order Sales Line No.";
            RentJnlLine."Responsibility Center" := TempSalesLineForRentPosting."Responsibility Center";
            RentJnlLine."Deal Type" := TempSalesLineForRentPosting."Deal Type Code";
            RentJnlLine."Source Code" := SrcCode;
            RentJnlLine.Type := TempSalesLineForRentPosting.Type;
            RentJnlLine."No." := TempSalesLineForRentPosting."No.";
            RentJnlLine."Unit of Measure Code" := TempSalesLineForRentPosting."Unit of Measure Code";
            RentJnlLine."Rent Item No." := TempSalesLineForRentPosting."Rent Item No.";
            RentJnlLine."Rent Asset No." := TempSalesLineForRentPosting."Rent Asset No.";
            RentJnlLine."Location Code" := TempSalesLineForRentPosting."Location Code";
            RentJnlLine.Quantity := TempSalesLineForRentPosting.Quantity;
            RentJnlLine."Gen. Bus. Posting Group" := TempSalesLineForRentPosting."Gen. Bus. Posting Group";
            RentJnlLine."Gen. Prod. Posting Group" := TempSalesLineForRentPosting."Gen. Prod. Posting Group";
            RentJnlLine."VAT Bus. Posting Group" := TempSalesLineForRentPosting."VAT Bus. Posting Group";
            RentJnlLine."VAT Prod. Posting Group" := TempSalesLineForRentPosting."VAT Prod. Posting Group";
            RentJnlLine."Shortcut Dimension 1 Code" := TempSalesLineForRentPosting."Shortcut Dimension 1 Code";
            RentJnlLine."Shortcut Dimension 2 Code" := TempSalesLineForRentPosting."Shortcut Dimension 2 Code";
            RentJnlLine."Dimension Set ID" := TempSalesLineForRentPosting."Dimension Set ID";
            RentJnlLine."Unit Cost" := TempSalesLineForRentPosting."Unit Cost (LCY)";
            RentJnlLine."Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
            RentJnlLine."Bill-to Customer No." := SalesHeader."Bill-to Customer No.";
            RentJnlLine."Salesperson Code" := SalesHeader."Salesperson Code";
            RentJnlLine."Starting Date" := TempSalesLineForRentPosting."Rent Start Date";
            RentJnlLine."Ending Date" := TempSalesLineForRentPosting."Rent End Date";
            if not SalesHeader."Prices Including VAT" then begin
                RentJnlLine."Line Discount Amount" := TempSalesLineForRentPosting."Line Discount Amount";
                RentJnlLine."Inv. Discount Amount" := TempSalesLineForRentPosting."Inv. Discount Amount";
                RentJnlLine."Unit Price" := TempSalesLineForRentPosting."Unit Price";
                RentJnlLine."Line Discount Amount (LCY)" := SalesLine."Line Discount Amount";
                RentJnlLine."Inv. Discount Amount (LCY)" := SalesLine."Inv. Discount Amount";
            end else begin
                RentJnlLine."Line Discount Amount" := ROUND(TempSalesLineForRentPosting."Line Discount Amount" / (1 + SalesLine."VAT %" / 100));
                RentJnlLine."Inv. Discount Amount" := ROUND(TempSalesLineForRentPosting."Inv. Discount Amount" / (1 + SalesLine."VAT %" / 100));
                RentJnlLine."Unit Price" := ROUND(TempSalesLineForRentPosting."Unit Price" / (1 + SalesLine."VAT %" / 100));
                RentJnlLine."Line Discount Amount (LCY)" := ROUND(SalesLine."Line Discount Amount" / (1 + SalesLine."VAT %" / 100));
                RentJnlLine."Inv. Discount Amount (LCY)" := ROUND(SalesLine."Inv. Discount Amount" / (1 + SalesLine."VAT %" / 100));
            end;
            //IF "Document Type" = "Document Type"::Invoice THEN BEGIN
            RentJnlLine.Amount := TempSalesLineForRentPosting.Amount;
            RentJnlLine."Amount Including VAT" := TempSalesLineForRentPosting."Amount Including VAT";
            RentJnlLine."Amount (LCY)" := SalesLine.Amount; //Sales Line Amount is transferred to amount in LCY
            RentJnlLine."Amount Including VAT (LCY)" := SalesLine."Amount Including VAT";
            RentJnlLine."Line Discount Amount" := RentJnlLine."Line Discount Amount";
            RentJnlLine."Inv. Discount Amount" := RentJnlLine."Inv. Discount Amount";
            RentJnlLine.Quantity := TempSalesLineForRentPosting."Qty. to Invoice";
            RentJnlLine."Total Cost" := TempSalesLineForRentPosting."Unit Cost (LCY)" * RentJnlLine.Quantity;
            if SalesLine."Document Type" = SalesLine."Document Type"::Invoice then
                RentJnlLine."Document Type" := RentJnlLine."document type"::"Posted Sales Invoice";
            if SalesLine."Document Type" = SalesLine."Document Type"::"Credit Memo" then
                RentJnlLine."Document Type" := RentJnlLine."document type"::"Posted Sales Cr.Memo";
            //      END ELSE BEGIN
            //        RentJnlLine.Amount :=  -Amount;
            //        RentJnlLine."Amount Including VAT" :=  -"Amount Including VAT";
            //        RentJnlLine."Amount (LCY)" := -SalesLine.Amount; //Sales Line Amount is transferred to amount in LCY
            //        RentJnlLine."Amount Including VAT (LCY)" :=  -SalesLine."Amount Including VAT";
            //        RentJnlLine.Quantity := -"Qty. to Invoice";
            //        RentJnlLine."Total Cost" := "Unit Cost (LCY)" * RentJnlLine.Quantity;
            //        RentJnlLine."Document Type" := RentJnlLine."Document Type"::"Posted Sales Cr.Memo";
            //      END;
            RentJnlLine."Currency Code" := TempSalesLineForRentPosting."Currency Code";
            RentJnlLine."Discount %" := TempSalesLineForRentPosting."Line Discount %";
            OnBeforeRentJnlLineRunWithCheck(RentJnlLine, SalesHeader, SalesLine);
            RentJnlPostLine.RunWithCheck(RentJnlLine);
            OnAfterRentJnlLineRunWithCheck(RentJnlLine, SalesHeader, SalesLine);
        end;
        //EB.P30 RENT <<

        //14.01.2008 EDMS P3
        PostDealAppEntry(SalesLine, SalesHeader."Posting Date", GenJnlLineDocType, GenJnlLineDocNo);
        //14.01.2008 EDMS P3



    end;

    procedure IsServiceLine(var SalesLine: Record "Sales Line"): Boolean
    var
        GLAccount: Record "G/L Account";
    begin
        //03.11.2014 EB.P8 #Exxx EDMS
        //Function to detect whether this sales line must got Service Ledger Entries
        if SalesLine."Line Type" = SalesLine."line type"::Comment then
            exit(false);
        exit(true);
    end;

    procedure CreateItemChargeAssgnt(PurchHeader: Record "Purchase Header"; PurchLine: Record "Purchase Line"; AplDocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Receipt,"Transfer Receipt","Return Shipment","Sales Shipment","Return Receipt"; AplDocNo: Code[20]; AplLineNo: Integer; AplItemNo: Code[20]; InsertAssgnt: Boolean)
    var
        ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
        ShipmentMethod: Record "Shipment Method";
        AssignItemChargePurch: Codeunit "Item Charge Assgnt. (Purch.)";
        NextNo: Integer;
        EquallyTok: Label 'Equally';
        //>>DELTA 02
        Selection: Option Equally,"By Amount","By Weight","By Volume";
    //<<DELTA 02
    begin
        GetCurrency('');
        //Assign Item Charge
        ItemChargeAssgntPurch.Reset;
        ItemChargeAssgntPurch."Document Type" := PurchLine."Document Type";
        ItemChargeAssgntPurch."Document No." := PurchLine."Document No.";
        ItemChargeAssgntPurch."Document Line No." := PurchLine."Line No.";
        ItemChargeAssgntPurch."Item Charge No." := PurchLine."No.";
        ItemChargeAssgntPurch.Validate("Vehicle Serial No.", PurchLine."Vehicle Serial No.");  //03.11.2014 EB.P8 #Exxx EDMS
                                                                                               //11.06.2015 EB.P30 #T036 >>
                                                                                               //IF ("Inv. Discount Amount" = 0) AND (NOT PurchHeader."Prices Including VAT") THEN
                                                                                               //  ItemChargeAssgntPurch."Unit Cost" := "Unit Cost"
                                                                                               //ELSE
        if PurchHeader."Prices Including VAT" then
            ItemChargeAssgntPurch."Unit Cost" :=
              ROUND(
                (PurchLine."Line Amount" - PurchLine."Inv. Discount Amount") / PurchLine.Quantity / (1 + PurchLine."VAT %" / 100),
                 Currency."Unit-Amount Rounding Precision")
        else
            ItemChargeAssgntPurch."Unit Cost" :=
              ROUND(
                (PurchLine."Line Amount" - PurchLine."Inv. Discount Amount") / PurchLine.Quantity,
                 Currency."Unit-Amount Rounding Precision");
        //11.06.2015 EB.P30 #T036 <<
        NextNo := PurchLine."Line No." - 10000;
        if InsertAssgnt then begin
            //20.08.2013 EDMS P8 >>
            if PurchHeader."Shipment Method Code" <> '' then
                ShipmentMethod.Get(PurchHeader."Shipment Method Code");
            //20.08.2013 EDMS P8 <<

            AssignItemChargePurch.InsertItemChargeAssignment(
              ItemChargeAssgntPurch, AplDocType,
              AplDocNo, AplLineNo, AplItemNo, PurchLine.Description, NextNo);
            //AssignItemChargePurch.SuggestAssgnt2(PurchLine, PurchLine.Quantity, ItemChargeAssgntPurch."Amount to Assign", 1);
            //AssignItemChargePurch.AssignItemCharges(PurchLine, PurchLine.Quantity, ItemChargeAssgntPurch."Amount to Assign", 1);
            AssignItemChargePurch.AssignItemCharges(PurchLine, PurchLine.Quantity, ItemChargeAssgntPurch."Amount to Assign", EquallyTok);      //03.01.2024 EB.KN
            Clear(AssignItemChargePurch);
        end;
    end;

    local procedure GetCurrency(CurrencyCode: Code[10])
    begin
        if CurrencyCode = '' then
            Currency.InitRoundingPrecision
        else begin
            Currency.Get(CurrencyCode);
            Currency.TestField("Amount Rounding Precision");
        end;
    end;

    procedure IncludeInVehSalesAmt(SalesLine: Record "Sales Line")
    var
        SalesSetup: Record "Sales & Receivables Setup";
        ItemLedgEntry: Record "Item Ledger Entry";
        OrigValueEntry: Record "Value Entry";
        ItemJnlLine: Record "Item Journal Line";
        InvtAdj: Codeunit "Inventory Adjustment";
        Text102: label 'Can''t find corresponding Item Ledger Entry to include sales amount.';
        Text103: label 'Can''t find corresponding Value Entry to include sales amount.';
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
        PostingDate: Date;
    begin
        SalesSetup.Get;
        ItemLedgEntry.Reset;
        ItemLedgEntry.SetRange("Entry Type", ItemLedgEntry."entry type"::Sale);
        ItemLedgEntry.SetRange("Document Profile", ItemLedgEntry."document profile"::"Vehicles Trade");
        ItemLedgEntry.SetRange("Serial No.", SalesLine."Vehicle Serial No.");
        ItemLedgEntry.SetRange("Vehicle Accounting Cycle No.", SalesLine."Vehicle Accounting Cycle No.");
        if not ItemLedgEntry.FindFirst then Error(Text102);
        OrigValueEntry.Reset;
        OrigValueEntry.SetRange("Item Ledger Entry No.", ItemLedgEntry."Entry No.");
        OrigValueEntry.SetRange("Entry Type", OrigValueEntry."entry type"::"Direct Cost");
        OrigValueEntry.SetRange(Adjustment, false);
        if not OrigValueEntry.FindFirst then Error(Text103);
        PostingDate := WorkDate;
        SalesSetup.TestField("Vehicle Sales Item Charge");
        SalesLine.TestField("Vehicle Serial No.");
        ItemJnlLine.Init;
        InvtAdj.SetProperties(false, true);
        ItemJnlLine."Item Charge No." := SalesSetup."Vehicle Sales Item Charge";
        ItemJnlLine."Item No." := OrigValueEntry."Item No.";
        ItemJnlLine."Location Code" := OrigValueEntry."Location Code";
        ItemJnlLine."Variant Code" := OrigValueEntry."Variant Code";
        ItemJnlLine."Vehicle Serial No." := SalesLine."Vehicle Serial No.";
        ItemJnlLine."Posting Date" := PostingDate;
        ItemJnlLine."Entry Type" := OrigValueEntry."Item Ledger Entry Type";
        ItemJnlLine."Document No." := OrigValueEntry."Document No.";
        ItemJnlLine."Source Code" := OrigValueEntry."Source Code";
        ItemJnlLine."Inventory Posting Group" := OrigValueEntry."Inventory Posting Group";
        ItemJnlLine."Gen. Bus. Posting Group" := OrigValueEntry."Gen. Bus. Posting Group";
        ItemJnlLine."Gen. Prod. Posting Group" := OrigValueEntry."Gen. Prod. Posting Group";
        if ItemJnlLine."Value Entry Type" = ItemJnlLine."value entry type"::"Direct Cost" then
            ItemJnlLine."Item Shpt. Entry No." := OrigValueEntry."Item Ledger Entry No.";

        ItemJnlLine."Applies-to Entry" := OrigValueEntry."Item Ledger Entry No.";
        ItemJnlLine.Amount := -SalesLine."Line Amount";

        ItemJnlLine."Shortcut Dimension 1 Code" := OrigValueEntry."Global Dimension 1 Code";
        ItemJnlLine."Shortcut Dimension 2 Code" := OrigValueEntry."Global Dimension 2 Code";

        //30.10.2012 EDMS >>
        ItemJnlPostLine.RunWithCheck(ItemJnlLine);
        //30.10.2012 EDMS <<
    end;



    procedure FillServJournalVariableFields(var ServJournalLine: Record "Serv. Journal Line"; SalesLine: Record "Sales Line")
    var
        VariableFieldUsage: Record "Variable Field Usage";
        VariableFieldUsage2: Record "Variable Field Usage";
        RecordRef: RecordRef;
        RecordRef2: RecordRef;
        FieldRef: FieldRef;
        FieldRef2: FieldRef;
    begin
        RecordRef.Open(Database::"Sales Line");
        RecordRef.GetTable(SalesLine);
        RecordRef2.Open(Database::"Serv. Journal Line");
        RecordRef2.GetTable(ServJournalLine);

        VariableFieldUsage.Reset;
        VariableFieldUsage.SetRange("Table No.", Database::"Sales Line");
        if VariableFieldUsage.FindFirst then
            repeat
                VariableFieldUsage2.Reset;
                VariableFieldUsage2.SetRange("Table No.", Database::"Serv. Journal Line");
                VariableFieldUsage2.SetRange("Variable Field Code", VariableFieldUsage."Variable Field Code");
                if VariableFieldUsage2.FindFirst then begin
                    FieldRef := RecordRef.Field(VariableFieldUsage."Field No.");
                    FieldRef2 := RecordRef2.Field(VariableFieldUsage2."Field No.");
                    FieldRef2.Value(FieldRef.Value);
                end;
            until VariableFieldUsage.Next = 0;
        RecordRef2.SetTable(ServJournalLine);
    end;

    procedure PostDealAppEntry(SalesLine: Record "Sales Line"; PostingDate: Date; DocType: Integer; DocNo: Code[20])
    var
        DCLedgEntryNo: Integer;
        DealApplType: Record "Deal Application Type";
        CustLedgEntryLink: Record "Cust. Ledg. Entry Link";
        DealApplEntry: Record "Deal Application Entry";
    begin
        if SalesLine."Vehicle Serial No." = '' then exit;

        CustLedgEntryLink.Reset;
        if DCLedgEntryNo = 0 then begin
            CustLedgEntryLink.LockTable;
            if CustLedgEntryLink.Find('+') then
                DCLedgEntryNo := CustLedgEntryLink."Entry No.";
        end;

        DCLedgEntryNo := DCLedgEntryNo + 1;

        CustLedgEntryLink.Init;
        CustLedgEntryLink."Entry No." := DCLedgEntryNo;
        CustLedgEntryLink."Entry Type" := CustLedgEntryLink."entry type"::Vehicle;
        CustLedgEntryLink."Posting Date" := PostingDate;
        CustLedgEntryLink."Document Type" := DocType;
        CustLedgEntryLink."Document No." := DocNo;
        CustLedgEntryLink."Document Line No." := SalesLine."Line No.";
        CustLedgEntryLink."Line Type" := SalesLine."Line Type";
        CustLedgEntryLink.Amount := -SalesLine."Amount Including VAT";
        CustLedgEntryLink."Vehicle Serial No." := SalesLine."Vehicle Serial No.";
        CustLedgEntryLink."Vehicle Accounting Cycle No." := SalesLine."Vehicle Accounting Cycle No.";
        CustLedgEntryLink.Description := SalesLine.Description;
        CustLedgEntryLink."Description 2" := SalesLine."Description 2";
        CustLedgEntryLink.Insert;

        DealApplType.SetRange("System Type", DealApplType."system type"::Leasing);
        if DealApplType.FindFirst then
            if DealApplEntry.Get(DealApplType."No.", 0, SalesLine."Document Type", SalesLine."Document No.", SalesLine."Line No.") then begin
                DealApplEntry."Det. Cust. Ledg. Entry EDMS" := DCLedgEntryNo;
                DealApplEntry.Modify;
            end
    end;




    //>>DELTA 01
    [IntegrationEvent(true, False)]
    local procedure OnBeforeInsertPurchaseInvoiceHeader(VAR PurchaseInvoiceHeader: Record "Purchase Header"; SalesHeader: Record "Sales Header")
    begin

    end;

    [IntegrationEvent(true, False)]
    LOCAL procedure OnBeforeInsertPurchaseInvoiceLine(VAR PurchaseInvoiceLine: Record "Purchase Line"; SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line")
    begin

    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateAutoReturnTransferOrder(var SalesHeader: Record "Sales Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var IsHandled: Boolean)
    begin
    end;

    //<<DELTA 01

    [EventSubscriber(ObjectType::codeunit, Codeunit::"Sales-Post", 'OnBeforeSalesInvLineInsert', '', false, false)]
    local procedure OnBeforeSalesInvLineInsert(var SalesInvLine: Record "Sales Invoice Line"; SalesInvHeader: Record "Sales Invoice Header"; SalesLine: Record "Sales Line"; CommitIsSuppressed: Boolean; var IsHandled: Boolean; PostingSalesLine: Record "Sales Line")
    Var
        SalesSetup: Record "Sales & Receivables Setup";
        SalesHeader: Record "Sales Header";
    begin
        SalesSetup.get;
        //23.01.2013 EDMS P8 >> //EDMS Upgrade to 2017
        FillPstSalesRscesFromSaleLine(SalesInvLine, SalesLine);
        //23.01.2013 EDMS P8 <<
        //08.11.2013 EDMS P8 >>
        SalesHeader.get(SalesLine."Document Type", SalesLine."Document No.");
        if (SalesHeader."Document Profile" = SalesHeader."document profile"::"Vehicles Trade") and (SalesSetup."Vehicle Sale Register on" = SalesSetup."Vehicle Sale Register on"::Invoice) then
            VehicleSetSalesDate(SalesHeader, SalesLine);
    end;

    procedure FillPstSalesRscesFromSaleLine(var SalesInvoiceLinePar: Record "Sales Invoice Line"; SalesLinePar: Record "Sales Line")
    var
        PostedServOrderLine: Record "Posted Serv. Order Line";
    begin
        if SalesLinePar."Service Order No. EDMS" <> '' then begin
            if PostedServOrderLine.Get(SalesLinePar."Service Order No. EDMS", SalesLinePar."Service Order Line No. EDMS") then begin
                SalesInvoiceLinePar."Resources (Serv.)" := PostedServOrderLine.Resources;
            end;
        end;
    end;


    procedure VehicleSetSalesDate(SalesHeaderPar: Record "Sales Header"; SalesLinePar: Record "Sales Line")
    var
        VehicleLoc: Record Vehicle;
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.get;
        //<<DELTA BHA 08/09/2022
        //if SalesLinePar.FindFirst then
        //  repeat
        //>>DELTA BHA 08/09/2022
        if VehicleLoc.Get(SalesLinePar."Vehicle Serial No.") then
            if VehicleLoc."Sales Date" = 0D then begin
                if SalesSetup."Vehicle Sale Register on" = SalesSetup."Vehicle Sale Register on"::Shipment then
                    VehicleLoc.Validate("Sales Date", SalesHeaderPar."Shipment Date");
                if SalesSetup."Vehicle Sale Register on" = SalesSetup."Vehicle Sale Register on"::Invoice then
                    VehicleLoc.Validate("Sales Date", SalesHeaderPar."Document Date");
                VehicleLoc.Modify(true);
            end;
        //<<DELTA BHA 08/09/2022
        // until SalesLinePar.Next = 0;
        //>>DELTA BHA 08/09/2022
    end;


    [EventSubscriber(ObjectType::codeunit, Codeunit::"Sales-Post", 'OnAfterSalesInvLineInsert', '', false, false)]
    local procedure OnAfterSalesInvLineInsert(var SalesInvLine: Record "Sales Invoice Line"; SalesInvHeader: Record "Sales Invoice Header"; SalesLine: Record "Sales Line"; ItemLedgShptEntryNo: Integer; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSuppressed: Boolean; var SalesHeader: Record "Sales Header"; var TempItemChargeAssgntSales: Record "Item Charge Assignment (Sales)" temporary; var TempWhseShptHeader: Record "Warehouse Shipment Header" temporary; var TempWhseRcptHeader: Record "Warehouse Receipt Header" temporary; PreviewMode: Boolean)
    var
        VehOptionManagement: Codeunit VehicleOptionManagement;
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.get;
        // 30.08.2017 EB.P30 Vehicle Assembly to Posted >>
        if SalesInvLine."Line Type" = SalesInvLine."line type"::Vehicle then
            VehOptionManagement.CopyVehAssemblyToPosted(Database::"Sales Invoice Header", SalesInvLine."Document No.", SalesLine."Vehicle Assembly ID");
        // 30.08.2017 EB.P30 Vehicle Assembly to Posted <<
        //EDMS1.0.00 >> //EDMS Upgrade 2017
        if (SalesInvLine."Line Type" = SalesInvLine."line type"::"G/L Account") and SalesInvLine."Vehicle Trade-In Line" then
            CreateTradeInEntry(SalesInvLine."Document No.", SalesInvLine."Line No.", 1);
        if (SalesInvLine."Line Type" = SalesInvLine."line type"::Vehicle) and (SalesSetup."Vehicle Sale Register on" = SalesSetup."Vehicle Sale Register on"::Invoice) then begin
            CreateVehicleWarranty(SalesLine);
            CreateVehicleServicePlan(SalesLine);  //20.03.2013 EDMS P8
        end;
        //EDMS1.0.00 <<
    end;


    [EventSubscriber(ObjectType::codeunit, Codeunit::"Sales-Post", 'OnAfterSalesShptLineInsert', '', false, false)]
    local procedure OnAfterSalesShptLineInsert(var SalesShipmentLine: Record "Sales Shipment Line"; SalesLine: Record "Sales Line"; ItemShptLedEntryNo: Integer; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSuppressed: Boolean; SalesInvoiceHeader: Record "Sales Invoice Header"; var TempWhseShptHeader: Record "Warehouse Shipment Header" temporary; var TempWhseRcptHeader: Record "Warehouse Receipt Header" temporary; SalesShptHeader: Record "Sales Shipment Header")
    var
        SalesSetup: Record "Sales & Receivables Setup";
        SalesHeader: Record "Sales Header";
    begin
        SalesSetup.get;
        SalesHeader.get(SalesLine."Document Type", SalesLine."Document No.");
        if SalesHeader.Ship then
            if SalesHeader."Document Type" in [SalesHeader."Document Type"::Order, SalesHeader."Document Type"::Invoice] then begin

                //08.11.2013 EDMS P8 >>
                if (SalesHeader."Document Profile" = SalesHeader."document profile"::"Vehicles Trade") and (SalesSetup."Vehicle Sale Register on" = SalesSetup."Vehicle Sale Register on"::Shipment) then
                    VehicleSetSalesDate(SalesHeader, SalesLine);
                if (SalesLine."Line Type" = SalesLine."Line type"::Vehicle) and (SalesSetup."Vehicle Sale Register on" = SalesSetup."Vehicle Sale Register on"::Shipment) then begin
                    CreateVehicleWarranty(SalesLine);
                    CreateVehicleServicePlan(SalesLine);  //20.03.2013 EDMS P8

                    //08.11.2013 EDMS P8 <<
                end;
            end;
    end;

    procedure CreateTradeInEntry(DocumentNo: Code[20]; DocumentLine: Integer; DocumentType: Integer)
    var
        VehTradeInMgt: Codeunit "Veh.Trade-In Mgt.";
    begin
        VehTradeInMgt.PostSalesEntry(DocumentNo, DocumentLine, DocumentType);
    end;

    procedure CreateVehicleWarranty(var SalesLine: Record "Sales Line")
    var
        VehicleWarrantyMgt: Codeunit "Vehicle Warranty Mgt.";
    begin
        VehicleWarrantyMgt.CreateWarrantyLines(SalesLine);
    end;

    procedure CreateVehicleServicePlan(var SalesLine: Record "Sales Line")
    var
        ServicePlanMgt: Codeunit "Service Plan Management";
    begin
        ServicePlanMgt.CreateServPlansDueToSaledLine(SalesLine);
    end;


    [EventSubscriber(ObjectType::codeunit, Codeunit::"Sales-Post", 'OnAfterUpdateSalesHeader', '', false, false)]
    local procedure OnAfterUpdateSalesHeader(var CustLedgerEntry: Record "Cust. Ledger Entry"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; GenJnlLineDocType: Integer)
    var
        ServJnlPostLine: Codeunit "Serv. Jnl.-Post Line";
        CustLedgEntryLink: Record "Cust. Ledg. Entry Link";
    begin
        //EDMS1.0.00 >> //EDMS upgrade 2017
        //>>Commenté par RC
        //FindCustLedgEntry(GenJnlLineDocType, GenJnlLineDocNo, CustLedgEntry);
        //<<CustLedgEntry.Find('+');

        ServJnlPostLine.UpdateCustLedgNo(CustLedgerEntry."Entry No.", CustLedgerEntry."Document Type".AsInteger(), CustLedgerEntry."Document No.", CustLedgerEntry."Posting Date");
        CustLedgEntryLink.UpdateCustLedgNo(CustLedgerEntry."Entry No.", GenJnlLineDocType,
                                            CustLedgerEntry."Document No.", CustLedgerEntry."Posting Date");
        //EDMS1.0.00 <<
    end;


    [EventSubscriber(ObjectType::Table, database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromSalesHeader', '', false, false)]
    local procedure OnAfterCopyItemJnlLineFromSalesHeader(var ItemJnlLine: Record "Item Journal Line"; SalesHeader: Record "Sales Header")
    begin
        ItemJnlLine."Deal Type Code" := SalesHeader."Deal Type Code";
    end;



    [EventSubscriber(ObjectType::Table, database::"Item Journal Line", 'OnAfterCopyItemJnlLineFromSalesLine', '', false, false)]
    local procedure OnAfterCopyItemJnlLineFromSalesLine(var ItemJnlLine: Record "Item Journal Line"; SalesLine: Record "Sales Line")
    var
        Item: Record item;

    begin
        //EDMS1.0.00 >> //EDMS Upgrade 2017
        if SalesLine.Type = SalesLine.Type::Item then begin
            Item.Get(ItemJnlLine."Item No.");
            ItemJnlLine."Item Type" := Item."Item Type";

        end;
        ItemJnlLine."Vehicle Accounting Cycle No." := SalesLine."Vehicle Accounting Cycle No.";
        ItemJnlLine."Document Profile" := SalesLine."Document Profile";
        ItemJnlLine."Make Code" := SalesLine."Make Code";
        ItemJnlLine."Model Code" := SalesLine."Model Code";
        ItemJnlLine."Model Version No." := SalesLine."Model Version No.";
        ItemJnlLine.VIN := SalesLine.VIN;
        ItemJnlLine."Campaign No." := SalesLine."Campaign No.";
        //EDMS1.0.00 <<

    end;


    [EventSubscriber(ObjectType::codeunit, Codeunit::"Sales-Post", 'OnBeforeDeleteAfterPosting', '', false, false)]
    local procedure OnBeforeDeleteAfterPosting(var SalesHeader: Record "Sales Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var SkipDelete: Boolean; CommitIsSuppressed: Boolean; EverythingInvoiced: Boolean; var TempSalesLineGlobal: Record "Sales Line" temporary)
    var
        ServiceSetupEDMS: Record "Service Mgt. Setup EDMS";
        ServiceTransferMgt: Codeunit "Service Transfer Mgt.";
        IsHandled: Boolean;
    begin
        //01.09.2008 EDMS P1 - Service Integration>>
        DeleteVehReservEntries(SalesHeader); //26.02.2008 EDMS P1
        //Processing Transfer Order
        OnBeforeCreateAutoReturnTransferOrder(SalesHeader, SalesInvoiceHeader, SalesCrMemoHeader, IsHandled);
        If IsHandled then
            exit;
        if (SalesHeader."Document Profile" = SalesHeader."document profile"::Service) and
         (SalesHeader."Document Type" = SalesHeader."document type"::"Credit Memo") then begin
            ServiceSetupEDMS.Get;
            case ServiceSetupEDMS."Transfer On Return" of
                ServiceSetupEDMS."transfer on return"::"Create Transfer Order":
                    ServiceTransferMgt.CreateAutoReturnTransferOrder(SalesHeader, false);
                ServiceSetupEDMS."transfer on return"::"Create&Post Transfer Order":
                    ServiceTransferMgt.CreateAutoReturnTransferOrder(SalesHeader, true);
            end;
        end;
        //01.09.2008 EDMS P1 - Service Integration<<
    end;

    local procedure DeleteVehReservEntries(var SalesHeader: Record "Sales Header")
    var
        ReservEntry: Record "Vehicle Reservation Entry";
        ReservMgt: Codeunit "Veh. Reservation Management";
        SalesLine: Record "Sales Line";
    begin
        ReservEntry.SetCurrentkey(
          "Source ID", "Source Ref. No.", "Source Type", "Source Subtype",
          "Source Batch Name");
        ReservEntry.SetRange("Source ID", SalesHeader."No.");
        ReservEntry.SetRange("Source Type", Database::"Sales Line");
        ReservEntry.SetRange("Source Subtype", SalesHeader."Document Type");
        ReservEntry.SetRange("Source Batch Name", '');
        if ReservEntry.IsEmpty then
            exit;

        SalesLine.Reset;
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindSet then
            repeat
                if (SalesLine.Quantity <> 0) and
                   (SalesLine.Type = SalesLine.Type::Item) and
                   (SalesLine."Line Type" = SalesLine."line type"::Vehicle)
                then begin
                    ReservMgt.SetSalesLine(SalesLine);
                    ReservMgt.DeleteReservEntries(true);
                end;
            until SalesLine.Next = 0;
    end;


    [EventSubscriber(ObjectType::codeunit, Codeunit::"Sales-Post", 'OnAfterUpdateAfterPosting', '', false, false)]
    local procedure OnAfterUpdateAfterPosting(var SalesHeader: Record "Sales Header"; var TempSalesLine: Record "Sales Line" temporary)
    var
        SalesLine2: Record "Sales Line";
        Vehicle: Record Vehicle;
        UserProfileMgt: Codeunit UserProfileManagement;
        UserProfile: Record "Branch Profile Setup";

    begin

        //24.01.2014 EDMS P15 >>
        SalesLine2.Reset;
        SalesLine2.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine2.SetRange("Document No.", SalesHeader."No.");
        if SalesLine2.FindFirst then
            repeat
                if (SalesLine2."Document Profile" = SalesLine2."document profile"::"Vehicles Trade") and
                    (SalesLine2."Line Type" = SalesLine2."line type"::Vehicle) and
                    (SalesLine2."Document Type" <> SalesLine2."document type"::"Credit Memo") then
                    if Vehicle.Get(SalesLine2."Vehicle Serial No.") then
                        if UserProfileMgt.CurrProfileID <> '' then
                            if UserProfile.Get(UserProfileMgt.CurrProfileID, UserProfileMgt.CurrBranchNo) then begin
                                Vehicle.Validate("Status Code", UserProfile."New Vehicle Stat. After Sale");
                                Vehicle.Modify(true);
                            end;
            until SalesLine2.Next = 0;
        //24.01.2014 EDMS P15 >>
    end;


    [EventSubscriber(ObjectType::codeunit, Codeunit::"Sales-Post", 'OnAfterFinalizePostingOnBeforeCommit', '', false, false)]
    local procedure OnAfterFinalizePostingOnBeforeCommit(var SalesHeader: Record "Sales Header"; var SalesShipmentHeader: Record "Sales Shipment Header"; var SalesInvoiceHeader: Record "Sales Invoice Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header"; var ReturnReceiptHeader: Record "Return Receipt Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; WhseShip: Boolean; WhseReceive: Boolean; var EverythingInvoiced: Boolean)
    var
        PurchPost: Codeunit "Purch.-Post";
        Text101: label 'Service Purchase Order was created but not posted.';
        PurchInvcHeader: Record "Purchase Header";
    begin
        //EDMS1.0.00 >>	      
        //Processing Linked Purchse INvoice
        PurchInvcHeader.SetRange("No.", SalesHeader."Purchase Doc No");
        IF PurchInvcHeader.FindFirst() Then
            if PurchInvcHeader."No." <> '' then begin
                if SalesHeader."Post Purchasing Invoice" then begin
                    Codeunit.Run(Codeunit::"Release Purchase Document", PurchInvcHeader);
                    PurchPost.Run(PurchInvcHeader);
                    OnAfterPostLinkedPurchaseInvoice(SalesHeader, PurchInvcHeader, SalesCrMemoHeader);
                end else
                    Message(Text101)
            end;
        //EDMS1.0.00 <<
    end;



    [EventSubscriber(ObjectType::codeunit, Codeunit::"Sales Post Invoice Events", 'OnPostLedgerEntryOnBeforeGenJnlPostLine', '', false, false)]
    local procedure OnBeforePostCustomerEntry(var GenJnlLine: Record "Gen. Journal Line"; var SalesHeader: Record "Sales Header"; var TotalSalesLine: Record "Sales Line"; var TotalSalesLineLCY: Record "Sales Line"; PreviewMode: Boolean; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line")
    begin
        GenJnlLine."Document Profile" := SalesHeader."Document Profile"; //21.06.2019 EDMS P30
                                                                         //23.01.2013 EDMS P8 >> //EDMS Upgrade 2017
        case SalesHeader."Document Profile" of
            SalesHeader."document profile"::Service:
                begin
                    GenJnlLine."Vehicle Serial No." := SalesHeader."Vehicle Serial No.";
                    GenJnlLine."Vehicle Accounting Cycle No." := SalesHeader."Vehicle Accounting Cycle No.";
                end;
            SalesHeader."document profile"::"Spare Parts Trade":
                begin
                    GenJnlLine."Vehicle Serial No." := SalesHeader."Vehicle Serial No.";
                    GenJnlLine."Vehicle Accounting Cycle No." := SalesHeader."Vehicle Accounting Cycle No.";
                end;
            else  //03.11.2014 EB.P8 #Exxx EDMS
              begin
                //18.03.2013 EDMS P8 >>
                if SalesHeader."Vehicle Serial No." = '' then begin
                    GenJnlLine.VIN := GenJnlLine.VIN;
                    GenJnlLine."Vehicle Serial No." := GenJnlLine."Vehicle Serial No.";
                    GenJnlLine."Vehicle Accounting Cycle No." := GenJnlLine."Vehicle Accounting Cycle No.";
                end else begin
                    GenJnlLine.VIN := SalesHeader.VIN;
                    GenJnlLine."Vehicle Serial No." := SalesHeader."Vehicle Serial No.";
                    GenJnlLine."Vehicle Accounting Cycle No." := SalesHeader."Vehicle Accounting Cycle No.";
                end;
                //18.03.2013 EDMS P8 <<
            end;
        end;
        //23.01.2013 EDMS P8 <<
    end;


    [EventSubscriber(ObjectType::codeunit, Codeunit::"Sales-Post", 'OnUpdateWonOpportunitiesOnBeforeOpportunityModify', '', false, false)]
    local procedure OnUpdateWonOpportunitiesOnBeforeOpportunityModify(var SalesHeader: Record "Sales Header"; SalesInvoiceHeader: Record "Sales Invoice Header"; var Opportunity: Record Opportunity)
    Var
        OpportunityEntry: Record "Opportunity Entry";
    begin
        OpportunityEntry.Reset();
        OpportunityEntry.SetCurrentKey(Active, "Opportunity No.");
        OpportunityEntry.SetRange(Active, true);
        OpportunityEntry.SetRange("Opportunity No.", Opportunity."No.");
        if OpportunityEntry.FindFirst() then begin
            OpportunityEntry."Calcd. Current Value" := OpportunityEntry.GetSalesDocValue2(SalesHeader); //25.10.2012. EDMS P2 EDMS Upgrade 2017
            OpportunityEntry.Modify();
        end;

    end;



    [EventSubscriber(ObjectType::codeunit, Codeunit::"Sales-Post", 'OnAfterSalesInvHeaderInsert', '', false, false)]
    local procedure OnAfterSalesInvHeaderInsert(var SalesInvHeader: Record "Sales Invoice Header"; SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; WhseShip: Boolean; WhseReceive: Boolean; var TempWhseShptHeader: Record "Warehouse Shipment Header"; var TempWhseRcptHeader: Record "Warehouse Receipt Header")
    begin
        ModifyProcessChecklist(SalesHeader, Database::"Sales Invoice Header", SalesInvHeader."No."); //07.11.2019 EDMS P7
    end;

    procedure ModifyProcessChecklist(SalesHeader: Record "Sales Header"; NewSourceType: Integer; NewSourceID: Code[20])
    var
        ProcessChecklistHdr: Record "Process Checklist Header";
    begin
        ProcessChecklistHdr.Reset;
        ProcessChecklistHdr.SetCurrentkey("Source Type", "Source Subtype", "Source ID");
        ProcessChecklistHdr.SetRange("Source Profile", SalesHeader."Document Profile");
        ProcessChecklistHdr.SetRange("Source Type", Database::"Sales Header");
        ProcessChecklistHdr.SetRange("Source Subtype", SalesHeader."Document Type");
        ProcessChecklistHdr.SetRange("Source ID", SalesHeader."No.");
        if ProcessChecklistHdr.FindFirst then
            repeat
                ProcessChecklistHdr."Source Type" := NewSourceType;
                ProcessChecklistHdr."Source Subtype" := 0;
                ProcessChecklistHdr."Source ID" := NewSourceID;
                ProcessChecklistHdr.Modify;
            until ProcessChecklistHdr.Next = 0;
    end;


    [EventSubscriber(ObjectType::codeunit, Codeunit::"Sales-Post", 'OnAfterInsertShipmentLine', '', false, false)]
    local procedure OnAfterInsertShipmentLine(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var SalesShptLine: record "Sales Shipment Line"; PreviewMode: Boolean; xSalesLine: Record "Sales Line")
    var
        cuVehSN: Codeunit "Vehicle Serial No. Mgt.";
        VehOptionManagement: Codeunit VehicleOptionManagement;
    begin
        //15.08.2017 EB.RC POD.DMS.Parts P439.DMSERR >>
        if SalesLine."Line Type" = SalesLine."line type"::Vehicle then
            cuVehSN.fDeleteSalesLineTracking(SalesLine);
        //15.08.2017 EB.RC POD.DMS.Parts P439.DMSERR <<

        // 30.08.2017 EB.P30 Vehicle Assembly to Posted >>
        if SalesLine."Line Type" = SalesLine."line type"::Vehicle then
            VehOptionManagement.CopyVehAssemblyToPosted(Database::"Sales Shipment Header", SalesShptLine."Document No.", SalesLine."Vehicle Assembly ID");
        // 30.08.2017 EB.P30 Vehicle Assembly to Posted <<

    end;




    [EventSubscriber(ObjectType::codeunit, Codeunit::"Sales-Post", 'OnAfterValidatePostingAndDocumentDate', '', false, false)]
    local procedure OnAfterValidatePostingAndDocumentDate(var SalesHeader: Record "Sales Header"; CommitIsSuppressed: Boolean; PreviewMode: Boolean; ReplacePostingDate: Boolean; ReplaceDocumentDate: Boolean)
    begin
        //EDMS1.0.00 >>
        UpdateVehicelSerialNo(SalesHeader);
        //EDMS1.0.00 <<

        // 25.10.2011 EDMS P8 >>
        UpdateVehicelServicePlan(SalesHeader);
        // 25.10.2011 EDMS P8 <<

    end;



    procedure UpdateVehicelSerialNo(var recSalesHeader: Record "Sales Header")
    var
        recSalesLine: Record "Sales Line";
        cuVehSN: Codeunit "Vehicle Serial No. Mgt.";
    begin
        if recSalesHeader."Document Profile" <> recSalesHeader."document profile"::"Vehicles Trade" then
            exit;
        Clear(cuVehSN);
        recSalesLine.Reset;
        recSalesLine.SetRange("Document Type", recSalesHeader."Document Type");
        recSalesLine.SetRange("Document No.", recSalesHeader."No.");
        if recSalesLine.Find('-') then
            repeat
                if recSalesLine."Line Type" = recSalesLine."line type"::Vehicle then begin
                    recSalesLine.TestField("Vehicle Serial No.");
                    cuVehSN.fDeleteSalesLineTracking(recSalesLine);
                    cuVehSN.fCreateSalesLineTracking(recSalesLine);
                end;
            until recSalesLine.Next = 0;
    end;


    procedure UpdateVehicelServicePlan(var SalesHeader: Record "Sales Header")
    var
        VehicleServicePlan: Record "Vehicle Service Plan";
        cuVehSN: Codeunit "Vehicle Serial No. Mgt.";
    begin
        if SalesHeader."Document Profile" <> SalesHeader."document profile"::"Vehicles Trade" then
            exit;
        VehicleServicePlan.SetRange("Vehicle Serial No.", SalesHeader."Vehicle Serial No.");
        if VehicleServicePlan.FindFirst then
            repeat
                if (VehicleServicePlan."Start Date" = 0D) or (VehicleServicePlan."Start Variable Field Run 1" = 0) then begin
                    if (VehicleServicePlan."Start Date" = 0D) then
                        VehicleServicePlan.Validate("Start Date", SalesHeader."Posting Date");
                    if VehicleServicePlan."Start Variable Field Run 1" = 0 then
                        VehicleServicePlan.Validate("Start Variable Field Run 1", SalesHeader."Variable Field Run 1");
                    VehicleServicePlan.Modify(true);
                end;
            until VehicleServicePlan.Next = 0;
        exit;
    end;

    [EventSubscriber(ObjectType::codeunit, Codeunit::"Sales-Post", 'OnCreatePrepaymentLinesOnBeforeGetSalesPrepmtAccount', '', false, false)]
    local procedure OnCreatePrepaymentLinesOnBeforeGetSalesPrepmtAccount(var GLAcc: Record "G/L Account"; var TempSalesLine: Record "Sales Line" temporary; SalesHeader: Record "Sales Header"; var GenPostingSetup: Record "General Posting Setup"; CompleteFunctionality: Boolean; var IsHandled: Boolean)
    begin
        if SalesHeader."Document Profile" = SalesHeader."document profile"::Service then Begin
            GenPostingSetup.TestField("Service Prepayments Account");
            GLAcc.Get(GenPostingSetup."Service Prepayments Account");
            IsHandled := true;
        end;

    end;

    [EventSubscriber(ObjectType::codeunit, Codeunit::"Sales-Post", 'OnBeforeTempPrepmtSalesLineInsert', '', false, false)]
    local procedure OnBeforeTempPrepmtSalesLineInsert(var TempPrepmtSalesLine: Record "Sales Line" temporary; var TempSalesLine: Record "Sales Line" temporary; SalesHeader: Record "Sales Header"; CompleteFunctionality: Boolean)
    begin

        TempPrepmtSalesLine."Document Profile" := SalesHeader."Document Profile";

    end;


    [EventSubscriber(ObjectType::codeunit, Codeunit::"Purch. Post Invoice Events", 'OnBeforePrepareLine', '', false, false)]
    local procedure OnBeforeFillInvoicePostBuffer(PurchHeader: Record "Purchase Header"; PurchLine: Record "Purchase Line"; PurchLineACY: Record "Purchase Line"; var IsHandled: Boolean)
    Var
        TempItemChargeAssgntPurch: record "Item Charge Assignment (Purch)";
        IsHandledDMS: Boolean;
    begin
        OnBeforeDMSOnBeforeFillInvoicePostBuffer(PurchHeader, PurchLine, IsHandledDMS);
        if IsHandledDMS then
            exit;
        if (PurchHeader."Document Profile" = PurchHeader."document profile"::"Vehicles Trade") and
                   (PurchLine.Type = PurchLine.Type::"Charge (Item)") then begin    // 21.06.2017 EB.P30 EDMS
            TempItemChargeAssgntPurch.Reset;
            TempItemChargeAssgntPurch.SetRange("Document Type", PurchLine."Document Type");
            TempItemChargeAssgntPurch.SetRange("Document No.", PurchLine."Document No.");
            TempItemChargeAssgntPurch.SetRange("Document Line No.", PurchLine."Line No.");
            IF TempItemChargeAssgntPurch.FindFirst() then Begin
                IF (TempItemChargeAssgntPurch."Vehicle Serial No." <> '') then Begin
                    //FillInvPostingBufferByChargeAssgnt(PurchHeader, PurchLine, PurchLineACY, TempItemChargeAssgntPurch, TempInvoicePostBuffer, InvoicePostBuffer);

                    IsHandled := true;
                End;
            End;
        end;
    End;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeDMSOnBeforeFillInvoicePostBuffer(PurchHeader: Record "Purchase Header"; PurchLine: Record "Purchase Line"; var IsHandledDMS: Boolean)
    begin
    end;

    local procedure FillInvPostingBufferByChargeAssgnt(PurchHeader: Record "Purchase Header"; PurchLine: Record "Purchase Line"; PurchLineACY: Record "Purchase Line"; var ItemChargeAssgntPurchPar: Record "Item Charge Assignment (Purch)"; var TempInvoicePostBuffer: Record "Invoice Posting Buffer" temporary; var InvoicePostBuffer: Record "Invoice Posting Buffer")
    var
        PurchLineLoc: Record "Purchase Line";
        PurchaseLineApplyTo: Record "Purchase Line";
        PurchLineACYLoc: Record "Purchase Line";
        PurchLineTmp: Record "Purchase Line" temporary;
        PurchLineACYTmp: Record "Purchase Line" temporary;
        Currency: Record Currency;
        LastChargeAsgntLineNo: Integer;
        PartPercent: Decimal;
        Usedate: Date;
        CurrExchRate: record "Currency Exchange Rate";
    begin
        if ItemChargeAssgntPurchPar.FindFirst then begin
            ItemChargeAssgntPurchPar.FindLast;
            LastChargeAsgntLineNo := ItemChargeAssgntPurchPar."Line No.";
            ItemChargeAssgntPurchPar.FindFirst;
            PurchLineLoc := PurchLine;
            PurchLineACYLoc := PurchLineACY;
            PurchLineTmp.Init;
            PurchLineACYTmp.Init;
            PurchLine."VAT Difference" := 0; // that will go into last record
            //>>DELTA XX
            IF PurchHeader."Currency Code" <> '' THEN BEGIN
                IF PurchHeader."Posting Date" = 0D THEN
                    Usedate := WORKDATE
                ELSE
                    Usedate := PurchHeader."Posting Date";
            END;
            //<<DELTA XX
            if PurchLineLoc."Currency Code" = '' then
                Currency.InitRoundingPrecision
            else begin
                Currency.Get(PurchLineLoc."Currency Code");
                Currency.TestField("Amount Rounding Precision");
            end;
            //"Amount Including VAT", Amount, "Inv. Discount Amount", "Line Discount Amount", "VAT Difference"
            repeat
                if (ItemChargeAssgntPurchPar."Applies-to Doc. Type".AsInteger() < ItemChargeAssgntPurchPar."applies-to doc. type"::Receipt.AsInteger()) then
                    if PurchaseLineApplyTo.Get(ItemChargeAssgntPurchPar."Applies-to Doc. Type", ItemChargeAssgntPurchPar."Applies-to Doc. No.", ItemChargeAssgntPurchPar."Applies-to Doc. Line No.") then begin
                        if ItemChargeAssgntPurchPar."Vehicle Serial No." <> PurchaseLineApplyTo."Vehicle Serial No." then begin
                            ItemChargeAssgntPurchPar."Vehicle Serial No." := PurchaseLineApplyTo."Vehicle Serial No.";
                            ItemChargeAssgntPurchPar."Vehicle Accounting Cycle No." := PurchaseLineApplyTo."Vehicle Accounting Cycle No.";
                            ItemChargeAssgntPurchPar."Make Code" := PurchaseLineApplyTo."Make Code";
                            ItemChargeAssgntPurchPar."Model Code" := PurchaseLineApplyTo."Model Code";
                            ItemChargeAssgntPurchPar."Model Version No." := PurchaseLineApplyTo."Model Version No.";
                        end;
                    end;
                if ItemChargeAssgntPurchPar."Vehicle Serial No." <> '' then begin
                    PurchLine."Vehicle Serial No." := ItemChargeAssgntPurchPar."Vehicle Serial No.";
                    //ItemChargeAssgntPurchPar.CALCFIELDS("Vehicle Accounting Cycle No.");  //17.02.2014 Elva Baltic P15 #S0003 MMG7.00
                    PurchLine."Vehicle Accounting Cycle No." := ItemChargeAssgntPurchPar."Vehicle Accounting Cycle No.";
                    PurchLine.Quantity := ItemChargeAssgntPurchPar."Qty. to Assign";
                    //PurchLine.VALIDATE(Amount, ItemChargeAssgntPurchPar."Amount to Assign");
                    IF PurchHeader."Currency Code" <> '' THEN
                        //>>DELTA XX
                        ItemChargeAssgntPurchPar."Amount to Assign" := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
          Usedate, PurchHeader."Currency Code", ItemChargeAssgntPurchPar."Amount to Assign", PurchHeader."Currency Factor"));
                    //<<DELTA XX
                    PurchLine.Amount := ItemChargeAssgntPurchPar."Amount to Assign";
                    PartPercent := PurchLine.Amount / PurchLineLoc.Amount;
                    PurchLine."Amount Including VAT" := ROUND(PurchLineLoc."Amount Including VAT" * PartPercent, Currency."Amount Rounding Precision");
                    PurchLine."Inv. Discount Amount" := ROUND(PurchLineLoc."Inv. Discount Amount" * PartPercent, Currency."Amount Rounding Precision");
                    PurchLine."Line Discount Amount" := ROUND(PurchLineLoc."Line Discount Amount" * PartPercent, Currency."Amount Rounding Precision");

                    PurchLineTmp.Quantity += PurchLine.Quantity;
                    PurchLineTmp.Amount += PurchLine.Amount;
                    PurchLineTmp."Amount Including VAT" += PurchLine."Amount Including VAT";
                    PurchLineTmp."Inv. Discount Amount" += PurchLine."Inv. Discount Amount";
                    PurchLineTmp."Line Discount Amount" += PurchLine."Line Discount Amount";
                    if LastChargeAsgntLineNo = ItemChargeAssgntPurchPar."Line No." then begin
                        PurchLine."VAT Difference" := PurchLineLoc."VAT Difference";
                        if PurchLineLoc.Quantity <> PurchLineTmp.Quantity then
                            PurchLine.Quantity += (PurchLineLoc.Quantity - PurchLineTmp.Quantity);
                        if PurchLineLoc.Amount <> PurchLineTmp.Amount then
                            PurchLine.Amount += (PurchLineLoc.Amount - PurchLineTmp.Amount);
                        if PurchLineLoc."Amount Including VAT" <> PurchLineTmp."Amount Including VAT" then
                            PurchLine."Amount Including VAT" += (PurchLineLoc."Amount Including VAT" - PurchLineTmp."Amount Including VAT");
                        if PurchLineLoc."Inv. Discount Amount" <> PurchLineTmp."Inv. Discount Amount" then
                            PurchLine."Inv. Discount Amount" += (PurchLineLoc."Inv. Discount Amount" - PurchLineTmp."Inv. Discount Amount");
                        if PurchLineLoc."Line Discount Amount" <> PurchLineTmp."Line Discount Amount" then
                            PurchLine."Line Discount Amount" += (PurchLineLoc."Line Discount Amount" - PurchLineTmp."Line Discount Amount");
                    end;

                    PurchLineACY := PurchLine;
                    FillInvoicePostBuffer(PurchHeader, PurchLine, PurchLineACY, TempInvoicePostBuffer, InvoicePostBuffer);
                end;
            until ItemChargeAssgntPurchPar.Next = 0;
        end;
    end;


    local procedure FillInvoicePostBuffer(PurchHeader: Record "Purchase Header"; PurchLine: Record "Purchase Line"; PurchLineACY: Record "Purchase Line"; var TempInvoicePostBuffer: Record "Invoice Posting Buffer" temporary; var InvoicePostBuffer: Record "Invoice Posting Buffer")
    var
        GenPostingSetup: Record "General Posting Setup";
        PurchSetup: Record "Purchases & Payables Setup";
        PurchPostInvoice: Codeunit "Purch. Post Invoice";
        TotalVAT: Decimal;
        TotalVATACY: Decimal;
        TotalAmount: Decimal;
        TotalAmountACY: Decimal;
        AmtToDefer: Decimal;
        AmtToDeferACY: Decimal;
        TotalVATBase: Decimal;
        TotalVATBaseACY: Decimal;
        DeferralAccount: Code[20];
        PurchAccount: Code[20];
    begin
        GenPostingSetup.Get(PurchLine."Gen. Bus. Posting Group", PurchLine."Gen. Prod. Posting Group");
        PurchPostInvoice.PrepareInvoicePostingBuffer(PurchLine, InvoicePostBuffer);
        InitAmounts(PurchLine, TotalVAT, TotalVATACY, TotalAmount, TotalAmountACY, AmtToDefer, AmtToDeferACY, DeferralAccount);
        InitVATBase(PurchLine, TotalVATBase, TotalVATBaseACY);



        if PurchSetup."Discount Posting" in
           [PurchSetup."Discount Posting"::"Invoice Discounts", PurchSetup."Discount Posting"::"All Discounts"]
        then begin
            CalcInvoiceDiscountPosting(PurchHeader, PurchLine, PurchLineACY, InvoicePostBuffer);

            if PurchLine."VAT Calculation Type" = PurchLine."VAT Calculation Type"::"Sales Tax" then
                PurchPostInvoice.SetSalesTax(PurchLine, InvoicePostBuffer);

            if (InvoicePostBuffer.Amount <> 0) or (InvoicePostBuffer."Amount (ACY)" <> 0) then begin
                GenPostingSetup.TestField("Purch. Inv. Disc. Account");

                InvoicePostBuffer.SetAccount(
                  GenPostingSetup.GetPurchInvDiscAccount, TotalVAT, TotalVATACY, TotalAmount, TotalAmountACY);
                InvoicePostBuffer.UpdateVATBase(TotalVATBase, TotalVATBaseACY);
                UpdateInvoicePostBuffer(TempInvoicePostBuffer, InvoicePostBuffer);

            end;
        end;

        if PurchSetup."Discount Posting" in
           [PurchSetup."Discount Posting"::"Line Discounts", PurchSetup."Discount Posting"::"All Discounts"]
        then begin
            CalcLineDiscountPosting(PurchHeader, PurchLine, PurchLineACY, InvoicePostBuffer);

            if PurchLine."VAT Calculation Type" = PurchLine."VAT Calculation Type"::"Sales Tax" then
                PurchPostInvoice.SetSalesTax(PurchLine, InvoicePostBuffer);

            if (InvoicePostBuffer.Amount <> 0) or (InvoicePostBuffer."Amount (ACY)" <> 0) then begin
                GenPostingSetup.TestField("Purch. Line Disc. Account");

                InvoicePostBuffer.SetAccount(
                  GenPostingSetup.GetPurchLineDiscAccount, TotalVAT, TotalVATACY, TotalAmount, TotalAmountACY);
                InvoicePostBuffer.UpdateVATBase(TotalVATBase, TotalVATBaseACY);
                UpdateInvoicePostBuffer(TempInvoicePostBuffer, InvoicePostBuffer);

            end;
        end;

        //        DeferralUtilities.AdjustTotalAmountForDeferralsNoBase(
        //          PurchLine."Deferral Code", AmtToDefer, AmtToDeferACY, TotalAmount, TotalAmountACY);



        if PurchLine."VAT Calculation Type" = PurchLine."VAT Calculation Type"::"Reverse Charge VAT" then begin
            if PurchLine."Deferral Code" <> '' then
                InvoicePostBuffer.SetAmounts(
                  TotalVAT, TotalVATACY, TotalAmount, TotalAmountACY, PurchLine."VAT Difference", TotalVATBase, TotalVATBaseACY)
            else
                InvoicePostBuffer.SetAmountsNoVAT(TotalAmount, TotalAmountACY, PurchLine."VAT Difference")
        end else
            if (not PurchLine."Use Tax") or (PurchLine."VAT Calculation Type" <> PurchLine."VAT Calculation Type"::"Sales Tax") then
                InvoicePostBuffer.SetAmounts(
                  TotalVAT, TotalVATACY, TotalAmount, TotalAmountACY, PurchLine."VAT Difference", TotalVATBase, TotalVATBaseACY)
            else
                InvoicePostBuffer.SetAmountsNoVAT(TotalAmount, TotalAmountACY, PurchLine."VAT Difference");

        if PurchLine."VAT Calculation Type" = PurchLine."VAT Calculation Type"::"Sales Tax" then
            PurchPostInvoice.SetSalesTax(PurchLine, InvoicePostBuffer);

        if (PurchLine.Type = PurchLine.Type::"G/L Account") or (PurchLine.Type = PurchLine.Type::"Fixed Asset") then
            PurchAccount := PurchLine."No."
        else
            if PurchLine.IsCreditDocType then
                PurchAccount := GenPostingSetup.GetPurchCrMemoAccount
            else
                PurchAccount := GenPostingSetup.GetPurchAccount;

        InvoicePostBuffer.SetAccount(PurchAccount, TotalVAT, TotalVATACY, TotalAmount, TotalAmountACY);
        InvoicePostBuffer.UpdateVATBase(TotalVATBase, TotalVATBaseACY);
        InvoicePostBuffer."Deferral Code" := PurchLine."Deferral Code";

        UpdateInvoicePostBuffer(TempInvoicePostBuffer, InvoicePostBuffer);



        //if PurchLine."Deferral Code" <> '' then begin
        //    OnBeforeFillDeferralPostingBuffer(
        //      PurchLine, InvoicePostBuffer, TempInvoicePostBuffer, Usedate, InvDefLineNo, DeferralLineNo, SuppressCommit);
        //    FillDeferralPostingBuffer(PurchHeader, PurchLine, InvoicePostBuffer, AmtToDefer, AmtToDeferACY, DeferralAccount, PurchAccount);
        //end;
    end;

    local procedure CalcInvoiceDiscountPosting(PurchHeader: Record "Purchase Header"; PurchLine: Record "Purchase Line"; PurchLineACY: Record "Purchase Line"; var InvoicePostBuffer: Record "Invoice Posting Buffer")
    begin
        case PurchLine."VAT Calculation Type" of
            PurchLine."VAT Calculation Type"::"Normal VAT", PurchLine."VAT Calculation Type"::"Full VAT":
                InvoicePostBuffer.CalcDiscount(
                  PurchHeader."Prices Including VAT", -PurchLine."Inv. Discount Amount", -PurchLineACY."Inv. Discount Amount");
            PurchLine."VAT Calculation Type"::"Reverse Charge VAT":
                InvoicePostBuffer.CalcDiscountNoVAT(-PurchLine."Inv. Discount Amount", -PurchLineACY."Inv. Discount Amount");
            PurchLine."VAT Calculation Type"::"Sales Tax":
                if not PurchLine."Use Tax" then // Use Tax is calculated later, based on totals
                    InvoicePostBuffer.CalcDiscount(
                      PurchHeader."Prices Including VAT", -PurchLine."Inv. Discount Amount", -PurchLineACY."Inv. Discount Amount")
                else
                    InvoicePostBuffer.CalcDiscountNoVAT(-PurchLine."Inv. Discount Amount", -PurchLineACY."Inv. Discount Amount");
        end;
    end;

    local procedure CalcLineDiscountPosting(PurchHeader: Record "Purchase Header"; PurchLine: Record "Purchase Line"; PurchLineACY: Record "Purchase Line"; var InvoicePostBuffer: Record "Invoice Posting Buffer")
    begin
        case PurchLine."VAT Calculation Type" of
            PurchLine."VAT Calculation Type"::"Normal VAT", PurchLine."VAT Calculation Type"::"Full VAT":
                InvoicePostBuffer.CalcDiscount(
                  PurchHeader."Prices Including VAT", -PurchLine."Line Discount Amount", -PurchLineACY."Line Discount Amount");
            PurchLine."VAT Calculation Type"::"Reverse Charge VAT":
                InvoicePostBuffer.CalcDiscountNoVAT(-PurchLine."Line Discount Amount", -PurchLineACY."Line Discount Amount");
            PurchLine."VAT Calculation Type"::"Sales Tax":
                if not PurchLine."Use Tax" then // Use Tax is calculated later, based on totals
                    InvoicePostBuffer.CalcDiscount(
                      PurchHeader."Prices Including VAT", -PurchLine."Line Discount Amount", -PurchLineACY."Line Discount Amount")
                else
                    InvoicePostBuffer.CalcDiscountNoVAT(-PurchLine."Line Discount Amount", -PurchLineACY."Line Discount Amount");
        end;
    end;

    local procedure UpdateInvoicePostBuffer(var TempInvoicePostBuffer: Record "Invoice Posting Buffer" temporary; InvoicePostBuffer: Record "Invoice Posting Buffer")
    Var
        InvDefLineNo: integer;
        DeferralLineNo: integer;

    begin


        TempInvoicePostBuffer.Update(InvoicePostBuffer, InvDefLineNo, DeferralLineNo);
    end;


    local procedure InitVATBase(PurchLine: Record "Purchase Line"; var TotalVATBase: Decimal; var TotalVATBaseACY: Decimal)
    begin
        TotalVATBase := PurchLine."VAT Base Amount";
        TotalVATBaseACY := PurchLineACY."VAT Base Amount";
    end;

    local procedure InitAmounts(PurchLine: Record "Purchase Line"; var TotalVAT: Decimal; var TotalVATACY: Decimal; var TotalAmount: Decimal; var TotalAmountACY: Decimal; var AmtToDefer: Decimal; var AmtToDeferACY: Decimal; var DeferralAccount: Code[20])
    begin
        InitVATAmounts(PurchLine, TotalVAT, TotalVATACY, TotalAmount, TotalAmountACY);
        //GetAmountsForDeferral(PurchLine, AmtToDefer, AmtToDeferACY, DeferralAccount);
    end;

    local procedure InitVATAmounts(PurchLine: Record "Purchase Line"; var TotalVAT: Decimal; var TotalVATACY: Decimal; var TotalAmount: Decimal; var TotalAmountACY: Decimal)
    begin
        TotalVAT := PurchLine."Amount Including VAT" - PurchLine.Amount;
        TotalVATACY := PurchLineACY."Amount Including VAT" - PurchLineACY.Amount;
        TotalAmount := PurchLine.Amount;
        TotalAmountACY := PurchLineACY.Amount;
    end;


    // [EventSubscriber(ObjectType::Table, database::"Invoice Posting Buffer", 'OnAfterInvPostBufferPreparePurchase', '', false, false)]
    // local procedure OnAfterInvPostBufferPreparePurchase(var PurchaseLine: Record "Purchase Line"; var InvoicePostBuffer: Record "Invoice Posting Buffer")
    // var
    //     PurchHeader: Record "Purchase Header";
    //     DealType: Record "Deal Type";
    //     VehicleNotMandatory: Boolean;
    // begin

    //     //EDMS >>
    //     If PurchaseLine."Vehicle Serial No." <> '' then Begin
    //         InvoicePostBuffer."Vehicle Serial No." := PurchaseLine."Vehicle Serial No.";
    //         InvoicePostBuffer."Vehicle Accounting Cycle No." := PurchaseLine."Vehicle Accounting Cycle No.";
    //         InvoicePostBuffer."Additional Grouping Identifier" := CopyStr(PurchaseLine."Vehicle Serial No." + Format(PurchaseLine."Line No."), 1, 20);

    //     End;
    //     //EDMS <<




    //     // end;

    // end;




    [IntegrationEvent(false, false)]
    local procedure VehTrackingMgtOnPostSalesLineOnBeforePostSalesLine(var IsHandled: Boolean; var SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeServJnlLineRunWithCheck(var ServJnlLine: Record "Serv. Journal Line"; var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckVehicleMandatory(var IsHandled: Boolean; var SalesHeader: Record "Sales Header"; var InvoicePostBuffer: Record "Invoice Posting Buffer");
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnAfterPostLinkedPurchaseInvoice(var SalesHeader: Record "Sales Header"; PurchInvcHeader: Record "Purchase Header"; var SalesCrMemoHeader: Record "Sales Cr.Memo Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeRentJnlLineRunWithCheck(var RentJnlLine: Record "Rent Journal Line"; var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterRentJnlLineRunWithCheck(var RentJnlLine: Record "Rent Journal Line"; var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    begin
    end;



}

