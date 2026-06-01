Codeunit 25006292 "Sales Post Event Management"
{

    trigger OnRun()
    begin
    end;

    var
        Text102: label 'Can''t find corresponding Item Ledger Entry to include sales amount.';
        Text103: label 'Can''t find corresponding Value Entry to include sales amount.';
        Text101: label 'Service Purchase Order was created but not posted.';
        Text100: label 'There are no lines with invoiced prepayment. Do you want to continue?';

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnAfterPostSalesDoc', '', false, false)]
    local procedure UpdateOnAfterPostSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; SalesShptHdrNo: Code[20]; RetRcpHdrNo: Code[20]; SalesInvHdrNo: Code[20]; SalesCrMemoHdrNo: Code[20])
    begin
        UpdateVehicleInHeader(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post", 'OnBeforePostCommitSalesDoc', '', false, false)]
    //local procedure UpdateOnBeforePostCommitSalesDoc(var SalesHeader: Record "Sales Header";var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line";PreviewMode: Boolean;ModifyHeader: Boolean;VehContactBusinessRelation: Record "Contact Business Relation";GenJnlLineDocNo: Code[20];GenJnlLineExtDocNo: Code[35];GenJnlLineDocType: Integer;SrcCode: Code[10];Currency: Record Currency;TempSalesLineGlobal: Record "Sales Line";UserProfileMgt: Codeunit UserProfileManagement;UserProfile: Record "Branch Profile Setup";ServiceTransferMgt: Codeunit "Service Transfer Mgt.";ServiceSetupEDMS: Record "Service Mgt. Setup EDMS";PurchPost: Codeunit "Purch.-Post")
    local procedure UpdateOnBeforePostCommitSalesDoc(var SalesHeader: Record "Sales Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PreviewMode: Boolean; var ModifyHeader: Boolean; var CommitIsSuppressed: Boolean; var TempSalesLineGlobal: Record "Sales Line" temporary)

    var
        SalesSetup: Record "Sales & Receivables Setup";
        PostPurchInvc: Boolean;
        ChApplyToDocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Receipt,"Transfer Receipt","Return Shipment","Sales Shipment","Return Receipt";
        ChApplyToDocNo: Code[20];
        ChApplyToLineNo: Integer;
        ChApplyToItemNo: Code[20];
        Vehicle: Record Vehicle;
        VehicleContact: Record "Vehicle Contact";
        SalesLine: Record "Sales Line";
        PurchInvcHeader: Record "Purchase Header";
    begin
        /* FIXME
        UpdateVehicelSerialNo(SalesHeader);
        UpdateVehicelServicePlan(SalesHeader);

        if SalesHeader."Document Profile" = SalesHeader."document profile"::Service then begin
            if SalesSetup."Payment Method Mandatory" then
                SalesHeader.TestField("Payment Method Code");
            if SalesHeader."Vehicle Item Charge No." <> '' then begin
                PostPurchInvc := FindItemEntryForApplyCh(SalesHeader."Vehicle Serial No.", SalesHeader."Vehicle Accounting Cycle No.",
                    ChApplyToDocType, ChApplyToDocNo, ChApplyToLineNo, ChApplyToItemNo);
                SalesHeader.TestField("Model Version No.")
            end;
        end;

        if SalesHeader."Document Profile" = SalesHeader."document profile"::"Vehicles Trade" then begin
            SalesLine.Reset;
            SalesLine.SetRange("Document Type", SalesHeader."Document Type");
            SalesLine.SetRange("Document No.", SalesHeader."No.");
            if SalesLine.FindFirst then
                repeat
                    if (SalesLine."Line Type" = SalesLine."line type"::Vehicle) and (SalesLine."Vehicle Serial No." <> '') then begin
                        if Vehicle.Get(SalesLine."Vehicle Serial No.") then begin
                            VehContactBusinessRelation.Reset;
                            VehContactBusinessRelation.SetRange("Link to Table", VehContactBusinessRelation."link to table"::Customer);
                            VehContactBusinessRelation.SetRange("Business Relation Code", 'CUST');
                            VehContactBusinessRelation.SetRange("No.", SalesHeader."Sell-to Customer No.");
                            if VehContactBusinessRelation.FindFirst then begin
                                VehicleContact.Init;
                                VehicleContact.Validate("Vehicle Serial No.", SalesLine."Vehicle Serial No.");
                                VehicleContact.Validate("Contact No.", VehContactBusinessRelation."Contact No.");
                                if SalesSetup."Def.Vehicle-Contact Rel." <> '' then
                                    VehicleContact.Validate("Relationship Code", SalesSetup."Def.Vehicle-Contact Rel.");
                                if VehicleContact.Insert(true) then;
                            end;
                        end;
                    end;
                until SalesLine.Next = 0;
        end;

        //EDMS1.0.00 >> //EDMS Upgrade 2017
        SalesHeader.CalcFields(Amount);
        if (SalesHeader."Document Profile" = SalesHeader."document profile"::Service) and
          (SalesHeader."Vehicle Item Charge No." <> '') and (SalesHeader.Amount <> 0) then
            CreatePurchInvcHeader(SalesHeader, PurchInvcHeader, GenJnlLineDocNo);
        //EDMS1.0.00 >>

        SalesLine.Reset;
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindFirst then
            repeat
                TestSalesLine(SalesLine);

                case SalesLine.Type of
                    SalesLine.Type::"External Service":
                        OnPostExternalService(SalesHeader, SalesLine, GenJnlLineDocNo, GenJnlLineExtDocNo, SrcCode);
                end;

                if SalesLine."Include In Veh. Sales Amt." then
                    IncludeInVehSalesAmt(SalesLine);

                CreatePurchInvcLine(PurchInvcHeader, SalesHeader, SalesLine, ChApplyToDocType, ChApplyToDocNo, ChApplyToLineNo, ChApplyToItemNo, PostPurchInvc, Currency);
                CreateServJnlLine(SalesHeader, SalesLine, TempSalesLineGlobal, GenJnlLineDocNo, GenJnlLineDocType, GenJnlLineExtDocNo, SrcCode);
                if SalesHeader.Invoice then
                    if SalesHeader."Document Type" in [SalesHeader."document type"::Order, SalesHeader."document type"::Invoice] then begin
                        VehicleSetSalesDate(SalesHeader, SalesLine);
                    end;

            until SalesLine.Next = 0;



        SalesLine.Reset;
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindFirst then
            repeat
                if (SalesLine."Document Profile" = SalesLine."document profile"::"Vehicles Trade") and
                    (SalesLine."Line Type" = SalesLine."line type"::Vehicle) and
                    (SalesLine."Document Type" <> SalesLine."document type"::"Credit Memo") then
                    if Vehicle.Get(SalesLine."Vehicle Serial No.") then
                        if UserProfileMgt.CurrProfileID <> '' then
                            if UserProfile.Get(UserProfileMgt.CurrProfileID, UserProfileMgt.CurrBranchNo) then begin
                                Vehicle.Validate("Status Code", UserProfile."Default Vehicle Sales Status");
                                Vehicle.Modify(true);
                            end;
            until SalesLine.Next = 0;

        DeleteVehReservEntries(SalesHeader);


        //Processing Transfer Order
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

        //Processing Linked Purchse INvoice
        if PurchInvcHeader."No." <> '' then begin
            if PostPurchInvc then begin
                Codeunit.Run(Codeunit::"Release Purchase Document", PurchInvcHeader);
                PurchPost.Run(PurchInvcHeader);
            end else
                Message(Text101)
        end;
        */
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


    procedure CreatePurchInvcHeader(SalesHeader: Record "Sales Header"; var PurchInvcHdr: Record "Purchase Header"; GenJnlLineDocNoPubGlobal: Code[20])
    var
        SalesLine3: Record "Sales Line";
        Customer: Record Customer;
        PurchSetup: Record "Purchases & Payables Setup";
        PostPurchInvHdr: Record "Purch. Inv. Header";
        NoSeriesMgt: Codeunit "No. Series";
        GenJnlLineDocNo: Code[20];
    begin
        if SalesHeader."Vehicle Item Charge No." = '' then exit;

        Customer.Get(SalesHeader."Sell-to Customer No.");
        if Customer."Corresponding Vendor No." = '' then begin
            Customer.Get(SalesHeader."Bill-to Customer No.");
            Customer.TestField("Corresponding Vendor No.")
        end;

        PurchInvcHdr.Init;
        PurchInvcHdr."Document Type" := SalesHeader."Document Type";
        PurchInvcHdr.Insert(true);

        PurchInvcHdr.TestField("Posting No. Series");
        PurchInvcHdr."Posting No." := NoSeriesMgt.GetNextNo(PurchInvcHdr."Posting No. Series", PurchInvcHdr."Posting Date", true);
        PurchInvcHdr."Auto Created Doc" := true;
        case PurchInvcHdr."Document Type" of
            PurchInvcHdr."document type"::Invoice:
                PurchInvcHdr."Vendor Invoice No." := GenJnlLineDocNoPubGlobal;
            PurchInvcHdr."document type"::"Credit Memo":
                begin
                    PurchInvcHdr."Vendor Cr. Memo No." := GenJnlLineDocNoPubGlobal;
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


    procedure CreatePurchInvcLine(var PurchInvcHeader: Record "Purchase Header"; var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; ChApplyToDocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Receipt,"Transfer Receipt","Return Shipment","Sales Shipment","Return Receipt"; ChApplyToDocNo: Code[20]; ChApplyToLineNo: Integer; ChApplyToItemNo: Code[20]; PostPurchInvc: Boolean; Currency: Record Currency)
    var
        PurchInvcLine: Record "Purchase Line";
        ItemCharge: Record "Item Charge";
    begin
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
            PurchInvcLine.Insert(true);
            CreateItemChargeAssgnt(PurchInvcHeader, PurchInvcLine, ChApplyToDocType, ChApplyToDocNo,
              ChApplyToLineNo, ChApplyToItemNo, PostPurchInvc, Currency);
        end;
    end;


    procedure TestSalesLine(var SalesLine: Record "Sales Line")
    var
        SalesLineVehReserve: Codeunit "Sales Line-Veh. Reserve";
    begin
        //26.02.2008 EDMS P1 // EDMS Upagrade 2017
        if SalesLine."Line Type" = SalesLine."line type"::Vehicle then
            SalesLineVehReserve.CheckReservation(SalesLine);
    end;


    procedure OnPostSalesLine(var SalesLine: Record "Sales Line")
    begin
    end;


    procedure OnPostExternalService(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; GenJnlLineDocNo: Code[20]; GenJnlLineExtDocNo: Code[20]; SrcCode: Code[20])
    var
        ExtServiceJnlLine: Record "External Serv. Journal Line";
        ExtServiceJnlPostLine: Codeunit "Ext. Service Jnl.-Post Line";
        ExternalServiceTrackingNo: Record "External Serv. Tracking No.";
    begin
        if (SalesLine."Qty. to Invoice" <> 0) and (SalesLine."Line Discount %" <> 100) then begin
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
            ExtServiceJnlPostLine.RunWithCheck(ExtServiceJnlLine);
        end;
    end;


    procedure IncludeInVehSalesAmt(SalesLine: Record "Sales Line")
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        OrigValueEntry: Record "Value Entry";
        ItemJnlLine: Record "Item Journal Line";
        InvtAdj: Codeunit "Inventory Adjustment";
        SalesSetup: Record "Sales & Receivables Setup";
        ItemJnlPostLine: Codeunit "Item Jnl.-Post Line";
    begin
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

        SalesSetup.TestField("Vehicle Sales Item Charge");
        SalesLine.TestField("Vehicle Serial No.");
        ItemJnlLine.Init;
        InvtAdj.SetProperties(false, true);
        ItemJnlLine."Item Charge No." := SalesSetup."Vehicle Sales Item Charge";
        ItemJnlLine."Item No." := OrigValueEntry."Item No.";
        ItemJnlLine."Location Code" := OrigValueEntry."Location Code";
        ItemJnlLine."Variant Code" := OrigValueEntry."Variant Code";
        ItemJnlLine."Vehicle Serial No." := SalesLine."Vehicle Serial No.";
        ItemJnlLine."Posting Date" := WorkDate;
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
        ItemJnlPostLine.RunWithCheck(ItemJnlLine);
    end;


    procedure CreateItemChargeAssgnt(PurchHeader: Record "Purchase Header"; PurchLine: Record "Purchase Line"; AplDocType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Receipt,"Transfer Receipt","Return Shipment","Sales Shipment","Return Receipt"; AplDocNo: Code[20]; AplLineNo: Integer; AplItemNo: Code[20]; InsertAssgnt: Boolean; var Currency: Record Currency)
    var
        ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
        ShipmentMethod: Record "Shipment Method";
        AssignItemChargePurch: Codeunit "Item Charge Assgnt. (Purch.)";
        NextNo: Integer;
        EquallyTok: Label 'Equally';
    begin
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
            AssignItemChargePurch.AssignItemCharges(PurchLine, PurchLine.Quantity, ItemChargeAssgntPurch."Amount to Assign", EquallyTok);      //03.01.2024 EB.KN
            Clear(AssignItemChargePurch);
        end;
    end;

    local procedure CreateServJnlLine(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; var TempSalesLine: Record "Sales Line"; GenJnlLineDocNo: Code[20]; GenJnlLineDocType: Integer; GenJnlLineExtDocNo: Code[20]; SrcCode: Code[10])
    var
        ServJnlLine: Record "Serv. Journal Line";
        ServJnlPostLine: Codeunit "Serv. Jnl.-Post Line";
        PostedServOrderLineEDMS: Record "Posted Serv. Order Line";
        PostedReturnServOrderLineEDMS: Record "Posted Serv. Return Order Line";
        ServicePostEDMS: Codeunit "Service-Post EDMS";
    begin
        //10.05.2014 EB.P8 EDMS >>
        if (SalesHeader."Document Profile" = SalesHeader."document profile"::Service) and IsServiceLine(TempSalesLine) then begin
            ServJnlLine.Init;
            ServJnlLine."Posting Date" := SalesHeader."Posting Date";
            ServJnlLine."Document Date" := SalesHeader."Document Date";
            ServJnlLine."Document Type" := TempSalesLine."Document Type";

            ServJnlLine."Vehicle Serial No." := SalesHeader."Vehicle Serial No.";
            ServJnlLine."Make Code" := SalesHeader."Make Code";
            ServJnlLine."Model Code" := SalesHeader."Model Code";
            ServJnlLine."Model Version No." := SalesHeader."Model Version No.";
            ServJnlLine."Vehicle Accounting Cycle No." := SalesHeader."Vehicle Accounting Cycle No.";

            ServJnlLine."Responsibility Center" := TempSalesLine."Responsibility Center";
            ServJnlLine.Description := TempSalesLine.Description;
            ServJnlLine."Job No." := TempSalesLine."Job No.";
            ServJnlLine."Unit of Measure Code" := TempSalesLine."Unit of Measure Code";
            ServJnlLine."Shortcut Dimension 1 Code" := TempSalesLine."Shortcut Dimension 1 Code";
            ServJnlLine."Shortcut Dimension 2 Code" := TempSalesLine."Shortcut Dimension 2 Code";
            ServJnlLine."Dimension Set ID" := TempSalesLine."Dimension Set ID";
            ServJnlLine."Gen. Bus. Posting Group" := TempSalesLine."Gen. Bus. Posting Group";
            ServJnlLine."Gen. Prod. Posting Group" := TempSalesLine."Gen. Prod. Posting Group";
            ServJnlLine."Entry Type" := ServJnlLine."entry type"::Sale;
            ServJnlLine."Pre-Assigned No." := TempSalesLine."Document No.";
            ServJnlLine."Document No." := GenJnlLineDocNo;
            ServJnlLine."Document Line No." := TempSalesLine."Line No.";                                              // 10.05.2014 Elva Baltic P21
            ServJnlLine."Service Order No." := TempSalesLine."Service Order No. EDMS";
            ServJnlLine."Warranty Claim No." := SalesHeader."Warranty Claim No.";
            ServJnlLine."External Document No." := GenJnlLineExtDocNo;
            ServJnlLine."Unit Cost" := TempSalesLine."Unit Cost (LCY)";
            if not SalesHeader."Prices Including VAT" then begin
                ServJnlLine."Line Discount Amount" := TempSalesLine."Line Discount Amount";
                ServJnlLine."Inv. Discount Amount" := TempSalesLine."Inv. Discount Amount";
                ServJnlLine."Unit Price" := TempSalesLine."Unit Price";
                ServJnlLine."Line Discount Amount (LCY)" := SalesLine."Line Discount Amount";
                ServJnlLine."Inv. Discount Amount (LCY)" := SalesLine."Inv. Discount Amount";
            end else begin
                ServJnlLine."Line Discount Amount" := ROUND(TempSalesLine."Line Discount Amount" / (1 + SalesLine."VAT %" / 100));
                ServJnlLine."Inv. Discount Amount" := ROUND(TempSalesLine."Inv. Discount Amount" / (1 + SalesLine."VAT %" / 100));
                ServJnlLine."Unit Price" := ROUND(SalesLine."Unit Price" / (1 + SalesLine."VAT %" / 100));
                ServJnlLine."Line Discount Amount (LCY)" := ROUND(SalesLine."Line Discount Amount" / (1 + SalesLine."VAT %" / 100));
                ServJnlLine."Inv. Discount Amount (LCY)" := ROUND(SalesLine."Inv. Discount Amount" / (1 + SalesLine."VAT %" / 100));
            end;
            if TempSalesLine."Document Type" = TempSalesLine."document type"::Invoice then begin
                ServJnlLine.Amount := TempSalesLine.Amount;
                ServJnlLine."Amount Including VAT" := -TempSalesLine."Amount Including VAT";
                ServJnlLine."Amount (LCY)" := SalesLine.Amount; //Sales Line Amount is transferred to amount in LCY
                ServJnlLine."Amount Including VAT (LCY)" := SalesLine."Amount Including VAT";
                ServJnlLine."Line Discount Amount" := -ServJnlLine."Line Discount Amount";
                ServJnlLine."Inv. Discount Amount" := -ServJnlLine."Inv. Discount Amount";
                ServJnlLine.Quantity := TempSalesLine."Qty. to Invoice";
                ServJnlLine."Total Cost" := TempSalesLine."Unit Cost (LCY)" * ServJnlLine.Quantity;
                //12.05.2015 EB.P30 #T030 >>
                if PostedServOrderLineEDMS.Get(TempSalesLine."Service Order No. EDMS", TempSalesLine."Service Order Line No. EDMS") then
                    ServJnlLine."Quantity (Hours)" := -PostedServOrderLineEDMS."Quantity (Hours)";
                //12.05.2015 EB.P30 #T030 <<
            end else begin
                ServJnlLine.Amount := -TempSalesLine.Amount;
                ServJnlLine."Amount Including VAT" := TempSalesLine."Amount Including VAT";
                ServJnlLine."Amount (LCY)" := SalesLine.Amount; //Sales Line Amount is transferred to amount in LCY
                ServJnlLine."Amount Including VAT (LCY)" := SalesLine."Amount Including VAT";
                ServJnlLine.Quantity := -TempSalesLine."Qty. to Invoice";
                ServJnlLine."Total Cost" := TempSalesLine."Unit Cost (LCY)" * ServJnlLine.Quantity;
                //12.05.2015 EB.P30 #T030 >>
                if PostedReturnServOrderLineEDMS.Get(TempSalesLine."Service Order No. EDMS", TempSalesLine."Service Order Line No. EDMS") then
                    ServJnlLine."Quantity (Hours)" := PostedReturnServOrderLineEDMS."Quantity (Hours)";
                //12.05.2015 EB.P30 #T030 <<
            end;
            ServJnlLine."Currency Code" := TempSalesLine."Currency Code";
            ServJnlLine."Source Code" := SrcCode;
            ServJnlLine.Type := TempSalesLine."Line Type";
            if SalesLine.Type = TempSalesLine.Type::"G/L Account" then begin
                if TempSalesLine."Order Line Type No." = '' then
                    ServJnlLine."No." := TempSalesLine."No."
                else
                    ServJnlLine."No." := TempSalesLine."Order Line Type No.";
            end else
                ServJnlLine."No." := TempSalesLine."No.";

            ServJnlLine."Customer No." := TempSalesLine."Sell-to Customer No.";
            ServJnlLine."Bill-to Customer No." := TempSalesLine."Bill-to Customer No.";
            ServJnlLine."Posting No. Series" := SalesHeader."Posting No. Series";
            ServJnlLine."Location Code" := TempSalesLine."Location Code";
            ServJnlLine."Discount %" := TempSalesLine."Line Discount %";
            ServJnlLine."Payment Method Code" := SalesHeader."Payment Method Code";
            ServJnlLine."Variable Field Run 1" := SalesHeader."Variable Field Run 1";
            ServJnlLine."Variable Field Run 2" := SalesHeader."Variable Field Run 2";
            ServJnlLine."Variable Field Run 3" := SalesHeader."Variable Field Run 3";
            ServJnlLine."Package No." := TempSalesLine."Package No.";
            ServJnlLine."Package Version No." := TempSalesLine."Package Version No.";
            ServJnlLine."Package Version Spec. Line No." := TempSalesLine."Package Version Spec. Line No.";
            ServJnlLine."Deal Type Code" := TempSalesLine."Deal Type Code";
            ServJnlLine."Standard Time" := TempSalesLine."Standard Time";
            ServJnlLine."Campaign No." := TempSalesLine."Campaign No.";
            //30.07.2015 EB.P30 #T045 >>
            ServJnlLine."Service Receiver" := SalesHeader."Salesperson Code";
            //30.07.2015 EB.P30 #T045 <<
            FillServJournalVariableFields(ServJnlLine, TempSalesLine);
            ServJnlLine."Service Order No." := SalesHeader."Service Document No.";
            //28.05.2015 EB.P30 #T030 >>
            //20.07.2016 EB.P7 #AMStoDMS Address >>
            ServJnlLine."Service Address Code" := SalesHeader."Ship-to Code";
            ServJnlLine."Service Address" := SalesHeader."Ship-to Address";
            //20.07.2016 EB.P7 #AMStoDMS Address <<
            if ServJnlLine."Document Type" = ServJnlLine."document type"::Invoice then
                ServicePostEDMS.FillDetServJnlByResource(ServJnlLine, 1,
                  ServJnlLine."Service Order No.", TempSalesLine."Service Order Line No. EDMS", '111')  //08.04.2013 EDMS P8
            else
                ServicePostEDMS.FillDetServJnlByResource(ServJnlLine, 2,
                  ServJnlLine."Service Order No.", TempSalesLine."Service Order Line No. EDMS", '111');  //08.04.2013 EDMS P8
                                                                                                         //28.05.2015 EB.P30 #T030 <<

            ServJnlPostLine.RunWithCheck(ServJnlLine);//30.10.2012 EDMS


        end;
        //10.05.2014 EB.P8 EDMS <<
        //EDMS1.0.00 <<

        ServicePostEDMS.ClearDetServJnlOfLine(ServJnlLine); //20.03.2013 EDMS
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


    procedure VehicleSetSalesDate(SalesHeaderPar: Record "Sales Header"; SalesLinePar: Record "Sales Line")
    var
        VehicleLoc: Record Vehicle;
    begin
        if SalesLinePar.FindFirst then
            repeat
                if VehicleLoc.Get(SalesLinePar."Vehicle Serial No.") then
                    if VehicleLoc."Sales Date" = 0D then begin
                        VehicleLoc.Validate("Sales Date", SalesHeaderPar."Document Date");
                        VehicleLoc.Modify(true);
                    end;
            until SalesLinePar.Next = 0;
    end;

    local procedure UpdateVehicleInHeader(var SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        SalesLineTmp: Record "Sales Line" temporary;
        isFound: Boolean;
    begin
        SalesLine.Reset;
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetFilter("Vehicle Serial No.", '<>%1', '');

        if SalesLine.FindFirst then begin
            SalesLineTmp.Init;
            SalesLineTmp.TransferFields(SalesLine);
            repeat
                if SalesLine."Vehicle Serial No." <> SalesLineTmp."Vehicle Serial No." then
                    isFound := true;
            until SalesLine.Next = 0;
            if isFound then begin
                SalesHeader.VIN := '';
                SalesHeader."Vehicle Serial No." := '';
                SalesHeader."Vehicle Accounting Cycle No." := '';
            end else begin
                SalesHeader.VIN := SalesLineTmp.VIN;
                SalesHeader."Vehicle Serial No." := SalesLineTmp."Vehicle Serial No.";
                SalesHeader."Vehicle Accounting Cycle No." := SalesLineTmp."Vehicle Accounting Cycle No.";
            end;
            SalesHeader.Modify;
        end;
    end;

    local procedure DeleteVehReservEntries(SalesHeader: Record "Sales Header")
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

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnBeforeReleaseSalesDoc', '', false, false)]
    local procedure OnBeforeReleaseSalesDoc(var SalesHeader: Record "Sales Header")
    Var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.Get;
        if SalesSetup."Deal Type Mandatory" then
            SalesHeader.TestField("Deal Type Code");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnBeforeTestSellToCustomerNo', '', false, false)]
    local procedure OnBeforeTestSellToCustomerNo(var SalesHeader: Record "Sales Header"; var IsHandled: Boolean)
    begin
        IF SalesHeader."Document Type" = SalesHeader."Document Type"::Quote THEN
            IsHandled := true;
    end;
    //------------------------------- codeunit 442 "Sales-Post Prepayments"
    procedure ChangeBillToCustomer(SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        CustomerList: Page "Customer List";
        Customer: Record Customer;
    begin
        //EDMS
        SalesHeader.TestField("Document Type", SalesHeader."document type"::Order);
        SalesHeader.TestField(Status, SalesHeader.Status::Open);

        SalesLine.Reset;
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetFilter("Prepmt. Amt. Inv.", '<>0');
        if not SalesLine.Find('-') then begin
            if not Confirm(Text100) then
                exit;
        end;


        Clear(CustomerList);
        Customer.Reset;
        if Customer.Get(SalesHeader."Bill-to Customer No.") then
            CustomerList.SetRecord(Customer);
        CustomerList.SetTableview(Customer);
        CustomerList.LookupMode(true);
        if CustomerList.RunModal = Action::LookupOK then
            CustomerList.GetRecord(Customer)
        else
            exit;

        if not Confirm(Text101, false,
             SalesHeader."Bill-to Customer No.", SalesHeader."Bill-to Name",
             Customer."No.", Customer.Name) then
            exit;

        ChangeBillToCustomerProcess(SalesHeader, Customer."No.");

        Message(Text102);
    end;


    procedure ChangeBillToCustomerProcess(var SalesHeader: Record "Sales Header"; NewBillToCust: Code[20])
    var
        Customer: Record Customer;
        SalesLine: Record "Sales Line";
        CustCheckCreditLimit: Codeunit "Cust-Check Cr. Limit";
        GLSetup: Record "General Ledger Setup";
        Dimsource: List of [Dictionary of [Integer, code[20]]];
        DimMgt: Codeunit DimensionManagement;
    begin
        Customer.Get(NewBillToCust);

        SalesHeader."Bill-to Customer No." := NewBillToCust;

        Customer.CheckBlockedCustOnDocs(Customer, SalesHeader."Document Type", false, false);
        Customer.TestField("Customer Posting Group");

        SalesHeader."Amount Including VAT" := 0;
        CustCheckCreditLimit.SalesHeaderCheck(SalesHeader);

        SalesHeader."Bill-to Customer Templ. Code" := '';
        SalesHeader."Bill-to Name" := Customer.Name;
        SalesHeader."Bill-to Name 2" := Customer."Name 2";
        SalesHeader."Bill-to Address" := Customer.Address;
        SalesHeader."Bill-to Address 2" := Customer."Address 2";
        SalesHeader."Bill-to City" := Customer.City;
        SalesHeader."Bill-to Post Code" := Customer."Post Code";
        SalesHeader."Bill-to County" := Customer.County;
        SalesHeader."Bill-to Country/Region Code" := Customer."Country/Region Code";
        SalesHeader."Bill-to Contact" := Customer.Contact;
        SalesHeader."Payment Terms Code" := Customer."Payment Terms Code";

        //SalesHeader."Gen. Bus. Posting Group" := Customer."Gen. Bus. Posting Group";
        //GLSetup.GET;
        //IF GLSetup."Bill-to/Sell-to VAT Calc." = GLSetup."Bill-to/Sell-to VAT Calc."::"Bill-to/Pay-to No." THEN
        //  SalesHeader."VAT Bus. Posting Group" := Customer."VAT Bus. Posting Group";
        //SalesHeader."Customer Posting Group" := Customer."Customer Posting Group";
        SalesHeader."VAT Registration No." := Customer."VAT Registration No.";


        //TempDocDim.GetDimensions(DATABASE::"Sales Header",SalesHeader."Document Type",SalesHeader."No.",0,TempDocDim); //30.10.2012 EDMS
        /*SalesHeader.CreateDim(
          Database::Customer, SalesHeader."Bill-to Customer No.",

          Database::"Salesperson/Purchaser", SalesHeader."Salesperson Code",
          Database::Campaign, SalesHeader."Campaign No.",
          Database::"Responsibility Center", SalesHeader."Responsibility Center",
          Database::"Customer Templ.", SalesHeader."Bill-to Customer Templ. Code");*/
        Clear(Dimsource);
        DimMgt.AddDimSource(Dimsource, DATABASE::Customer, SalesHeader."Bill-to Customer No.");
        DimMgt.AddDimSource(Dimsource, DATABASE::"Salesperson/Purchaser", SalesHeader."Salesperson Code");
        DimMgt.AddDimSource(Dimsource, Database::Campaign, SalesHeader."Campaign No.");
        DimMgt.AddDimSource(Dimsource, Database::"Responsibility Center", SalesHeader."Responsibility Center");
        DimMgt.AddDimSource(Dimsource, DATABASE::"Customer Templ.", SalesHeader."Bill-to Customer Templ. Code");
        SalesHeader.CreateDim(Dimsource);

        //Sales Line Modification
        SalesLine.Reset;
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        if SalesLine.FindFirst then
            repeat
                SalesLine."Bill-to Customer No." := NewBillToCust;
                SalesLine.Modify;
            until SalesLine.Next = 0;

        SalesHeader."Prepmt. Bill-to Cust. Changed" := true;
        SalesHeader.Modify;
    end;
}

