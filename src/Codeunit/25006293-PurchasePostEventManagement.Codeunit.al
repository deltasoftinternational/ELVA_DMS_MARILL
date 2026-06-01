//>>DELTA 01 RC (09/06/2020) Correction probleme tracabilité lors de la facture Achat
Codeunit 25006293 "Purchase Post Event Management"
{

    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostPurchaseDoc', '', false, false)]
    local procedure UpdateOnBeforePostPurchaseDoc(var PurchaseHeader: Record "Purchase Header")
    begin
        //EDMS1.0.00 >> //EDMD Upgrade 2017
        fUpdateVehicelSerialNo(PurchaseHeader);
        //EDMS1.0.00 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostCommitPurchaseDoc', '', false, false)]
    local procedure UpdateOnBeforePostCommitPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PreviewMode: Boolean; ModifyHeader: Boolean)
    var
        PurchLine: Record "Purchase Line";
        Vehicle: Record Vehicle;
        ColorAssmbl: Code[20];
        UpholsteryAssmbl: Code[20];
        ColorCode: Code[20];
        InteriorCode: Code[20];
        VehoptMgt: Codeunit VehicleOptionManagement;
    begin
        PurchLine.Reset;
        PurchLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchLine.SetRange("Document No.", PurchaseHeader."No.");
        if PurchLine.FindFirst then
            repeat
                case PurchLine.Type of
                    PurchLine.Type::Item:
                        begin
                            if (PurchaseHeader."Document Profile" = PurchaseHeader."document profile"::"Vehicles Trade") and
                                (PurchLine."Line Type" = PurchLine."line type"::Vehicle) and
                                (PurchLine."Qty. to Receive" > 0) then begin  //06.02.2013 EDMS P8
                                                                              //10.03.2008 EDMS P3 >>
                                Vehicle.Get(PurchLine."Vehicle Serial No.");
                                //31.05.2013 Elva Baltic P15 >>
                                if PurchLine."Vehicle Assembly ID" <> '' then begin
                                    ColorAssmbl := '';
                                    UpholsteryAssmbl := '';
                                    VehoptMgt.GetVehColorUpholstFromAssemblyLine(PurchLine."Vehicle Serial No.", PurchLine."Vehicle Assembly ID", ColorAssmbl, UpholsteryAssmbl)
                                end;
                                if ColorAssmbl <> '' then
                                    ColorCode := ColorAssmbl
                                else
                                    ColorCode := PurchLine."Vehicle Body Color Code";

                                if ColorCode <> Vehicle."Body Color Code" then begin
                                    Vehicle."Body Color Code" := ColorCode;
                                    Vehicle.Modify
                                end;

                                if PurchLine."Vehicle Status Code" <> Vehicle."Status Code" then begin
                                    Vehicle."Status Code" := PurchLine."Vehicle Status Code";
                                    Vehicle.Modify
                                end;

                                if UpholsteryAssmbl <> '' then
                                    InteriorCode := UpholsteryAssmbl
                                else
                                    InteriorCode := PurchLine."Vehicle Interior Code";

                                if InteriorCode <> Vehicle."Interior Code" then begin
                                    Vehicle."Interior Code" := InteriorCode;
                                    Vehicle.Modify
                                end;
                                //31.05.2013 Elva Baltic P15 <<
                                //10.03.2008 EDMS P3 <<
                                if (PurchLine."Vehicle Assembly ID" <> '') and PurchaseHeader.Receive then
                                    VehoptMgt.PostVehOptPurchLine(PurchaseHeader, PurchLine);
                            end
                            //05.12.2007 EDMS P3 <<
                        end;
                end;
            until PurchLine.Next = 0;
    end;


    procedure fUpdateVehicelSerialNo(var recPurchHeader: Record "Purchase Header")
    var
        recPurchLine: Record "Purchase Line";
        cuVehSN: Codeunit "Vehicle Serial No. Mgt.";
    begin
        onBeforeUpdateVehicleSerialNo(recPurchHeader);
        if recPurchHeader."Document Profile" <> recPurchHeader."document profile"::"Vehicles Trade" then
            exit;
        Clear(cuVehSN);
        recPurchLine.Reset;
        recPurchLine.SetRange("Document Type", recPurchHeader."Document Type");
        recPurchLine.SetRange("Document No.", recPurchHeader."No.");
        //>>DELTA 01
        recPurchLine.SETRANGE("Line Type", recPurchLine."Line Type"::Vehicle);
        recPurchLine.SETFILTER("Receipt No.", '%1', '');
        //<<DELTA 01
        if recPurchLine.Find('-') then
            repeat
                if (recPurchLine."Line Type" = recPurchLine."line type"::Vehicle) and (((recPurchLine."Qty. to Receive" <> 0) and recPurchHeader.Receive) or
                    ((recPurchLine."Qty. to Invoice" <> 0) and recPurchHeader.Invoice)) then //06.02.2013 EDMS P8
                 begin
                    recPurchLine.CalcFields("Vehicle Exists");
                    recPurchLine.TestField("Vehicle Exists", true);
                    recPurchLine.TestField("Vehicle Serial No.");
                    cuVehSN.fDeletePurchLineTracking(recPurchLine);
                    cuVehSN.fCreatePurchLineTracking(recPurchLine);
                end;
            until recPurchLine.Next = 0;
    end;

    // ---------------------------------------------- codeunit 330 ReqJnlManagement --------------------------------------------------- //
    procedure TemplateSelection(PageID: Integer; RecurringJnl: Boolean; Type: Option "Req.","For. Labor",Planning; var ReqLine: Record "Requisition Line"; var JnlSelected: Boolean)
    var
        ReqWkshTmpl: Record "Req. Wksh. Template";
        LocalText100: label 'Veh. Req.';
        OpenFromBatch: Boolean;
        Text99000000: Label '%1 Worksheet';
    begin
        JnlSelected := true;

        ReqWkshTmpl.Reset();
        ReqWkshTmpl.SetRange("Page ID", PageID);
        ReqWkshTmpl.SetRange(Recurring, RecurringJnl);
        ReqWkshTmpl.SetRange(Type, Type);
        case ReqWkshTmpl.Count of
            0:
                begin
                    ReqWkshTmpl.Init();
                    ReqWkshTmpl.Recurring := RecurringJnl;
                    ReqWkshTmpl.Type := Type;
                    ReqWkshTmpl.Name := LocalText100;
                    ReqWkshTmpl.Description := StrSubstNo(Text99000000, LocalText100);
                    ReqWkshTmpl.Validate("Page ID", Page::"Vehicle Req. Worksheet");
                    ReqWkshTmpl."Document Profile" := ReqWkshTmpl."document profile"::"Vehicles Trade";
                    ReqWkshTmpl.Insert();
                    Commit();
                end;
            1:
                ReqWkshTmpl.FindFirst;
            else
                JnlSelected := PAGE.RunModal(0, ReqWkshTmpl) = ACTION::LookupOK;
        end;
        if JnlSelected then begin
            ReqLine.FilterGroup := 2;
            ReqLine.SetRange("Worksheet Template Name", ReqWkshTmpl.Name);
            ReqLine.FilterGroup := 0;
            if OpenFromBatch then begin
                ReqLine."Worksheet Template Name" := '';
                PAGE.Run(ReqWkshTmpl."Page ID", ReqLine);
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnBeforeReleasePurchaseDoc', '', false, false)]
    local procedure OnBeforeReleasePurchaseDoc(var PurchaseHeader: Record "Purchase Header")
    Var
        PurchaseSetup: Record "Purchases & Payables Setup";
    begin
        PurchaseSetup.Get;
        if PurchaseSetup."Deal Type Mandatory" then
            PurchaseHeader.TestField("Deal Type Code");
    end;

    [IntegrationEvent(false, false)]
    local procedure onBeforeUpdateVehicleSerialNo(var recPurchHeader: Record "Purchase Header")
    begin
    end;

    // ---------------------------------------------- codeunit 90 --------------------------------------------------- //
    //>>ADDED For CU 90
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeCommitAndUpdateAnalysisVeiw', '', false, false)]
    local procedure OnBeforeCommitAndUpdateAnalysisVeiw(InvtPickPutaway: Boolean; SuppressCommit: Boolean; PreviewMode: Boolean; var IsHandled: Boolean);
    begin
        IsHandled := true;
    end;

    //>>ADDED For CU 90
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPostPurchaseDoc', '', false, false)]
    local procedure OnAfterPostPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PurchRcpHdrNo: Code[20]; RetShptHdrNo: Code[20]; PurchInvHdrNo: Code[20]; PurchCrMemoHdrNo: Code[20]; CommitIsSupressed: Boolean);
    var
        UpdateAnalysisView: Codeunit "Update Analysis View";
        UpdateItemAnalysisView: Codeunit "Update Item Analysis View";
        InvtPickPutaway: Boolean;
    begin
        InvtPickPutaway := PurchaseHeader."Posting from Whse. Ref." <> 0;
        if not (InvtPickPutaway or CommitIsSupressed) then begin
            if PurchaseHeader."Document Profile" <> PurchaseHeader."document profile"::Service then
                Commit();
            UpdateAnalysisView.UpdateAll(0, true);
            UpdateItemAnalysisView.UpdateAll(0, true);
        end;
    end;

    //>>ADDED For CU 90
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforePostCommitPurchaseDoc', '', false, false)]
    local procedure OnBeforePostCommitPurchaseDoc(var PurchaseHeader: Record "Purchase Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PreviewMode: Boolean; ModifyHeader: Boolean; var CommitIsSupressed: Boolean; var TempPurchLineGlobal: Record "Purchase Line" temporary);
    begin
        if PurchaseHeader."Document Profile" = PurchaseHeader."Document Profile"::Service then
            CommitIsSupressed := true;
    end;

    //>>ADDED for CU 90
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnPostPurchLineOnAfterPostByType', '', false, false)]
    local procedure OnPostPurchLineOnAfterPostByType(PurchHeader: Record "Purchase Header"; var PurchLine: Record "Purchase Line"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; GenJnlLineDocNo: Code[20]; GenJnlLineExtDocNo: Code[35]; GenJnlLineDocType: Enum "Gen. Journal Document Type"; SrcCode: Code[10]);
    var
        ExtServiceJnlLine: Record "External Serv. Journal Line";
        ExtServiceJnlPostLine: Codeunit "Ext. Service Jnl.-Post Line";
        VehOptionManagement: Codeunit VehicleOptionManagement;
        ExternalServiceTrackingNo: Record "External Serv. Tracking No.";
    begin

        //EDMS1.0.00 P5 >> //EDMS Upgrade 2017
        if PurchLine.Type = PurchLine.Type::"External Service" then begin
            if (PurchLine."Qty. to Invoice" <> 0) and (PurchLine."Line Discount %" <> 100) then begin
                ExtServiceJnlLine.Init;
                ExtServiceJnlLine."Posting Date" := PurchHeader."Posting Date";
                ExtServiceJnlLine."Entry Type" := ExtServiceJnlLine."entry type"::Purchase;
                ExtServiceJnlLine."Reason Code" := PurchHeader."Reason Code";
                ExtServiceJnlLine."Ext. Service No." := PurchLine."No.";
                ExtServiceJnlLine."Ext. Service Tracking No." := PurchLine."External Serv. Tracking No.";
                ExtServiceJnlLine.Description := PurchLine.Description;
                ExtServiceJnlLine."Source Type" := ExtServiceJnlLine."source type"::Vendor;
                ExtServiceJnlLine."Source No." := PurchLine."Buy-from Vendor No.";
                ExtServiceJnlLine."Shortcut Dimension 1 Code" := PurchLine."Shortcut Dimension 1 Code";
                ExtServiceJnlLine."Shortcut Dimension 2 Code" := PurchLine."Shortcut Dimension 2 Code";
                ExtServiceJnlLine."Location Code" := PurchLine."Location Code";
                ExtServiceJnlLine."Document No." := GenJnlLineDocNo;
                ExtServiceJnlLine."External Document No." := GenJnlLineExtDocNo;
                ExtServiceJnlLine.Quantity := PurchLine."Qty. to Invoice";
                ExtServiceJnlLine.Amount := PurchLine.Amount;
                ExtServiceJnlLine."Source Code" := SrcCode;
                ExtServiceJnlLine."Posting No. Series" := PurchHeader."Posting No. Series";
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
        //EDMS1.0.00 P5 <<
    end;

    /* [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnBeforeFillInvoicePostBuffer', '', false, false)]
     local procedure OnBeforeFillInvoicePostBuffer(PurchHeader: Record "Purchase Header"; PurchLine: Record "Purchase Line"; PurchLineACY: Record "Purchase Line"; InvoicePostBuffer: Record "Invoice Post. Buffer" temporary; var IsHandled: Boolean; var TempInvoicePostBuffer: Record "Invoice Post. Buffer" temporary);
     var
         lPurchline: Record "Purchase Line";
         ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
         TempItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)" temporary;

     begin

         if not ((PurchHeader."Document Profile" = PurchHeader."document profile"::"Vehicles Trade") and (PurchLine.Type = PurchLine.Type::"Charge (Item)")) then
             exit;
         //>> générer TempItemChargeAssgntPurch aprés ce pointer sur la ligne 
         lPurchline.Reset();
         lPurchline.SetRange("Document Type", PurchHeader."Document Type");
         lPurchline.SetRange("Document No.", PurchHeader."No.");
         lPurchline.SetRange(Type, lPurchline.Type::"Charge (Item)");
         if lPurchline.IsEmpty() then
             exit
         else begin
             TempItemChargeAssgntPurch.Reset();
             TempItemChargeAssgntPurch.SetRange("Document Type", lPurchline."Document Type");
             TempItemChargeAssgntPurch.SetRange("Document No.", lPurchline."Document No.");
             if not TempItemChargeAssgntPurch.IsEmpty() then
                 TempItemChargeAssgntPurch.DeleteAll();

             ItemChargeAssgntPurch.Reset();
             ItemChargeAssgntPurch.SetRange("Document Type", lPurchline."Document Type");
             ItemChargeAssgntPurch.SetRange("Document No.", lPurchline."Document No.");
             ItemChargeAssgntPurch.SetFilter("Qty. to Assign", '<>0');
             if ItemChargeAssgntPurch.FindSet() then
                 repeat
                     TempItemChargeAssgntPurch.Init();
                     TempItemChargeAssgntPurch := ItemChargeAssgntPurch;
                     TempItemChargeAssgntPurch.Insert();
                 until ItemChargeAssgntPurch.Next() = 0;

             TempItemChargeAssgntPurch.SetCurrentKey("Applies-to Doc. Type");
             TempItemChargeAssgntPurch.SetFilter("Applies-to Doc. Type", '<>%1', PurchLine."Document Type");
             TempItemChargeAssgntPurch.SetRange("Document Line No.", PurchLine."Line No.");
             if TempItemChargeAssgntPurch.FindSet() then
                 if (TempItemChargeAssgntPurch."Vehicle Serial No." <> '') then begin    // 21.06.2017 EB.P30 EDMSthen begin    // 21.06.2017 EB.P30 EDMS
                     TempItemChargeAssgntPurch.Reset;
                     TempItemChargeAssgntPurch.SetRange("Document Type", PurchLine."Document Type");
                     TempItemChargeAssgntPurch.SetRange("Document No.", PurchLine."Document No.");
                     TempItemChargeAssgntPurch.SetRange("Document Line No.", PurchLine."Line No.");
                     FillInvPostingBufferByChargeAssgnt(PurchHeader, PurchLine, PurchLineACY, TempItemChargeAssgntPurch, TempInvoicePostBuffer, InvoicePostBuffer);
                     IsHandled := true;
                 end
         end;
     end;


     local procedure FillInvPostingBufferByChargeAssgnt(PurchHeader: Record "Purchase Header"; PurchLine: Record "Purchase Line"; PurchLineACY: Record "Purchase Line"; var ItemChargeAssgntPurchPar: Record "Item Charge Assignment (Purch)"; var TempInvoicePostBuffer: Record "Invoice Post. Buffer" temporary; var InvoicePostBuffer: Record "Invoice Post. Buffer")
     var
         PurchLineLoc: Record "Purchase Line";
         PurchaseLineApplyTo: Record "Purchase Line";
         PurchLineACYLoc: Record "Purchase Line";
         PurchLineTmp: Record "Purchase Line" temporary;
         PurchLineACYTmp: Record "Purchase Line" temporary;
         Currency: Record Currency;
         LastChargeAsgntLineNo: Integer;
         PartPercent: Decimal;
         "Purch.-Post": codeunit "Purch.-Post";
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
             if PurchLineLoc."Currency Code" = '' then
                 Currency.InitRoundingPrecision
             else begin
                 Currency.Get(PurchLineLoc."Currency Code");
                 Currency.TestField("Amount Rounding Precision");
             end;
             //"Amount Including VAT", Amount, "Inv. Discount Amount", "Line Discount Amount", "VAT Difference"
             repeat
                 if (ItemChargeAssgntPurchPar."Applies-to Doc. Type" < ItemChargeAssgntPurchPar."applies-to doc. type"::Receipt) then
                     if PurchaseLineApplyTo.Get(ItemChargeAssgntPurchPar."Applies-to Doc. Type", ItemChargeAssgntPurchPar."Applies-to Doc. No.", ItemChargeAssgntPurchPar."Applies-to Doc. Line No.") then
                         with ItemChargeAssgntPurchPar do begin
                             if "Vehicle Serial No." <> PurchaseLineApplyTo."Vehicle Serial No." then begin
                                 "Vehicle Serial No." := PurchaseLineApplyTo."Vehicle Serial No.";
                                 "Vehicle Accounting Cycle No." := PurchaseLineApplyTo."Vehicle Accounting Cycle No.";
                                 "Make Code" := PurchaseLineApplyTo."Make Code";
                                 "Model Code" := PurchaseLineApplyTo."Model Code";
                                 "Model Version No." := PurchaseLineApplyTo."Model Version No.";
                             end;
                         end;
                 if ItemChargeAssgntPurchPar."Vehicle Serial No." <> '' then begin
                     PurchLine."Vehicle Serial No." := ItemChargeAssgntPurchPar."Vehicle Serial No.";
                     //ItemChargeAssgntPurchPar.CALCFIELDS("Vehicle Accounting Cycle No.");  //17.02.2014 Elva Baltic P15 #S0003 MMG7.00
                     PurchLine."Vehicle Accounting Cycle No." := ItemChargeAssgntPurchPar."Vehicle Accounting Cycle No.";
                     PurchLine.Quantity := ItemChargeAssgntPurchPar."Qty. to Assign";
                     //PurchLine.VALIDATE(Amount, ItemChargeAssgntPurchPar."Amount to Assign");
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
     end;*/



    //>>ADDED For CU 90
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchInvLineInsert', '', false, false)]
    local procedure OnAfterPurchInvLineInsert(var PurchInvLine: Record "Purch. Inv. Line"; PurchInvHeader: Record "Purch. Inv. Header"; PurchLine: Record "Purchase Line"; ItemLedgShptEntryNo: Integer; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSupressed: Boolean; PurchHeader: Record "Purchase Header"; PurchRcptHeader: Record "Purch. Rcpt. Header"; TempWhseRcptHeader: Record "Warehouse Receipt Header");
    var
        VehOptionManagement: Codeunit VehicleOptionManagement;
    begin
        if PurchLine."Line Type" = PurchLine."line type"::Vehicle then
            VehOptionManagement.CopyVehAssemblyToPosted(Database::"Purch. Inv. Header", PurchInvLine."Document No.", PurchLine."Vehicle Assembly ID");
    end;
    //>>ADDED For CU 90
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnPostItemJnlLineOnBeforeCopyDocumentFields', '', false, false)]
    local procedure OnPostItemJnlLineOnBeforeCopyDocumentFields(var ItemJournalLine: Record "Item Journal Line"; PurchaseHeader: Record "Purchase Header"; PurchaseLine: Record "Purchase Line"; WhseReceive: Boolean; WhseShip: Boolean; InvtPickPutaway: Boolean);
    var
        recitem: Record item;
    begin
        case PurchaseLine.Type of
            PurchaseLine.Type::Item:
                begin
                    recItem.Get(ItemJournalLine."Item No.");
                    ItemJournalLine."Item Type" := recItem."Item Type";
                end;
            PurchaseLine.Type::"Charge (Item)":
                if (PurchaseLine."Line Type" = PurchaseLine."line type"::"Charge (Item)") then
                    ItemJournalLine."Item Type" := ItemJournalLine."item type"::"Model Version"
        end;
        ItemJournalLine."Document Profile" := PurchaseLine."Document Profile";
        ItemJournalLine."Make Code" := PurchaseLine."Make Code";
        ItemJournalLine."Model Code" := PurchaseLine."Model Code";
        ItemJournalLine."Model Version No." := PurchaseLine."Model Version No.";
        ItemJournalLine.VIN := PurchaseLine.VIN;
        ItemJournalLine."Vehicle Serial No." := PurchaseLine."Vehicle Serial No.";
        ItemJournalLine."Vehicle Accounting Cycle No." := PurchaseLine."Vehicle Accounting Cycle No.";
        ItemJournalLine."External Document No. 2" := PurchaseLine."Vendor Order No.";
        //EDMS1.0.00 <<

        ItemJournalLine."Deal Type Code" := PurchaseHeader."Deal Type Code";    //20.08.2018 EB EDMS
    end;

    //>>ADDED For CU 90
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Line-Reserve", 'OnBeforeTransferPurchLineToItemJnlLineReservEntry', '', false, false)]
    local procedure OnBeforeTransferPurchLineToItemJnlLineReservEntry(var OldReservEntry: Record "Reservation Entry"; PurchLine: Record "Purchase Line"; ItemJnlLine: Record "Item Journal Line"; var TransferQty: Decimal; var IsHandled: Boolean);
    var
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        VehReservePurchLine: Codeunit "Purch. Line-Veh. Reserve";
    begin

        /* Ce code pour remplacer ce fonctionnement on CU 90  
           begin //EDMS Upgrade 2017
                    PurchLineReserve.TransferPurchLineToItemJnlLine(
                      PurchLine, ItemJnlLine, QtyToBeReceivedBase, CheckApplToItemEntry);
                    if PurchLine."Line Type" = PurchLine."line type"::Vehicle then //25.02.2008 EDMS P1
                        VehReservePurchLine.TransferPurchLineToItemJnlLine(PurchLine, ItemJnlLine); //25.02.2008 EDMS P1
            end;
        */
        if PurchLine."Line Type" = PurchLine."line type"::Vehicle then begin
            TransferQty :=
            CreateReservEntry.TransferReservEntry(
                DATABASE::"Item Journal Line",
                ItemJnlLine."Entry Type".AsInteger(), ItemJnlLine."Journal Template Name",
                ItemJnlLine."Journal Batch Name", 0, ItemJnlLine."Line No.",
                ItemJnlLine."Qty. per Unit of Measure", OldReservEntry, TransferQty);
            VehReservePurchLine.TransferPurchLineToItemJnlLine(PurchLine, ItemJnlLine); //25.02.2008 EDMS P1
            IsHandled := true;
        end;

    end;
    //>>ADDED For CU 90
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnPostItemChargePerOrderOnAfterCopyToItemJnlLine', '', false, false)]
    local procedure OnPostItemChargePerOrderOnAfterCopyToItemJnlLine(var ItemJournalLine: Record "Item Journal Line"; var PurchaseLine: Record "Purchase Line"; GeneralLedgerSetup: Record "General Ledger Setup"; QtyToInvoice: Decimal; var TempItemChargeAssignmentPurch: Record "Item Charge Assignment (Purch)" temporary; PurchLine: Record "Purchase Line");
    var
        InventoryPostingGroup: Record "Inventory Posting Group";
    begin
        // 07.12.2011 EDMS P2 >> //EDMS Upgrade 2017
        if PurchaseLine."Posting Group" <> '' then begin
            InventoryPostingGroup.Get(PurchaseLine."Posting Group");
            if InventoryPostingGroup."Split Value Entries" then
                ItemJournalLine."Inventory Posting Group" := PurchaseLine."Posting Group";
        end;
        // 07.12.2011 EDMS P2 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterFinalizePostingOnBeforeCommit', '', false, false)]
    local procedure OnAfterFinalizePostingOnBeforeCommit(var PurchHeader: Record "Purchase Header"; var PurchRcptHeader: Record "Purch. Rcpt. Header"; var PurchInvHeader: Record "Purch. Inv. Header"; var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var ReturnShptHeader: Record "Return Shipment Header"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PreviewMode: Boolean; CommitIsSupressed: Boolean; EverythingInvoiced: Boolean);
    begin
        if PurchHeader."Document Profile" = PurchHeader."Document Profile"::Service then
            CommitIsSupressed := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchInvHeaderInsert', '', false, false)]
    local procedure OnAfterPurchInvHeaderInsert(var PurchInvHeader: Record "Purch. Inv. Header"; var PurchHeader: Record "Purchase Header"; PreviewMode: Boolean);
    begin
        //13.05.2008. EDMS P2 >> //EDMS Upgrade 2017
        ModifyProcessChecklist(PurchHeader, Database::"Purch. Inv. Header", PurchInvHeader."No.");
        //13.05.2008. EDMS P2 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchCrMemoHeaderInsert', '', false, false)]
    local procedure OnAfterPurchCrMemoHeaderInsert(var PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr."; var PurchHeader: Record "Purchase Header"; CommitIsSupressed: Boolean; PreviewMode: Boolean);
    begin
        //13.05.2008. EDMS P2 >> //EDMS Upgrade 2017
        ModifyProcessChecklist(PurchHeader, Database::"Purch. Cr. Memo Hdr.", PurchCrMemoHdr."No.");
        //13.05.2008. EDMS P2 <<
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch. Post Invoice Events", 'OnPostLinesOnBeforeGenJnlLinePost', '', false, false)]
    local procedure OnBeforePostInvPostBuffer(var GenJnlLine: Record "Gen. Journal Line"; PurchHeader: Record "Purchase Header"; TempInvoicePostingBuffer: Record "Invoice Posting Buffer"; var GenJnlPostLine: Codeunit "Gen. Jnl.-Post Line"; PreviewMode: Boolean; SuppressCommit: Boolean);
    begin
        //EDMS1.0.00 >> //EDMS Upgrade 2017
        GenJnlLine."Vehicle Serial No." := TempInvoicePostingBuffer."Vehicle Serial No.";
        GenJnlLine."Vehicle Accounting Cycle No." := TempInvoicePostingBuffer."Vehicle Accounting Cycle No.";
        //EDMS1.0.00 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnAfterPurchRcptLineInsert', '', false, false)]
    local procedure OnAfterPurchRcptLineInsert(PurchaseLine: Record "Purchase Line"; var PurchRcptLine: Record "Purch. Rcpt. Line"; ItemLedgShptEntryNo: Integer; WhseShip: Boolean; WhseReceive: Boolean; CommitIsSupressed: Boolean; PurchInvHeader: Record "Purch. Inv. Header"; var TempTrackingSpecification: Record "Tracking Specification" temporary; PurchRcptHeader: Record "Purch. Rcpt. Header"; TempWhseRcptHeader: Record "Warehouse Receipt Header"; xPurchLine: Record "Purchase Line"; var TempPurchLineGlobal: Record "Purchase Line" temporary);
    var
        VehOptionManagement: Codeunit VehicleOptionManagement;
    begin
        // 30.08.2017 EB.P30 Vehicle Assembly to Posted >>
        if PurchaseLine."Line Type" = PurchaseLine."line type"::Vehicle then
            VehOptionManagement.CopyVehAssemblyToPosted(Database::"Purch. Rcpt. Header", PurchRcptLine."Document No.", PurchaseLine."Vehicle Assembly ID");
        // 30.08.2017 EB.P30 Vehicle Assembly to Posted <<
    end;


    procedure ModifyProcessChecklist(PurchaseHdr: Record "Purchase Header"; NewSourceType: Integer; NewSourceID: Code[20])
    var
        ProcessChecklistHdr: Record "Process Checklist Header";
    begin
        ProcessChecklistHdr.Reset;
        ProcessChecklistHdr.SetCurrentkey("Source Type", "Source Subtype", "Source ID");
        ProcessChecklistHdr.SetRange("Source Type", Database::"Purchase Header");
        ProcessChecklistHdr.SetRange("Source Subtype", PurchaseHdr."Document Type");
        ProcessChecklistHdr.SetRange("Source ID", PurchaseHdr."No.");
        if ProcessChecklistHdr.FindFirst then
            repeat
                ProcessChecklistHdr."Source Type" := NewSourceType;
                ProcessChecklistHdr."Source Subtype" := 0;
                ProcessChecklistHdr."Source ID" := NewSourceID;
                ProcessChecklistHdr.Modify;
            until ProcessChecklistHdr.Next = 0;
    end;

}

