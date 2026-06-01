Codeunit 25006119 "Release Service Document EDMS"
{
    // 12.05.2016 EB.P30 GH
    //   Modified procedure:
    //     Reopen
    // 
    // 22.10.2015 NAV2016 Merge
    //   Removed approvals
    // 
    // 04.04.2014 Elva Baltic P1 #RX MMG7.00
    //   * Modified trigger OnRun
    // 
    // 03.04.2014 Elva Baltic P1 #RX MMG7.00
    //   * Modified trigger OnRun
    // 
    // 2012.03.07 EDMS P8
    //   * Tire management
    // 
    // 19.01.2009. EDMS P2
    //   * Added code PerformManualRelease
    // 
    // 07.11.2007. EDMS P2
    //   * Added code OnRun
    // 
    // 23.10.2007 EDMS P2
    //   * Added code OnRun
    // 
    // 26.07.2007. EDMS P2
    //   * Added code in function TestServPrepayment(ServHeader : Record "Service Header EDMS") : Boolean

    TableNo = "Service Header EDMS";

    trigger OnRun()
    var
        ServLine: Record "Service Line EDMS";
        TempVATAmountLine0: Record "VAT Amount Line" temporary;
        TempVATAmountLine1: Record "VAT Amount Line" temporary;
        NotOnlyDropShipment: Boolean;
    begin
        if rec.Status = rec.Status::Released then
            exit;

        if rec."Document Type" = rec."document type"::Quote then
            if rec.CheckContactCreated(true) and
               rec.CheckCustomerCreated(true) and
               rec.CheckVehicleCreated(true) then
                rec.Get(rec."document type"::Quote, rec."No.")
            else
                exit;


        rec.TestField("Sell-to Customer No.");
        //03.04.2014 Elva Baltic P1 #RX MMG7.00 >>
        VehicleNotMandatory := false;
        if rec."Deal Type" <> '' then begin
            if DealType.Get(rec."Deal Type") then
                VehicleNotMandatory := DealType."Vehicle Not Mandatory";
        end;
        if not VehicleNotMandatory then begin
            rec.TestField("Make Code");
            rec.TestField("Model Code");
            rec.TestField("Vehicle Status Code");
            rec.TestField("Vehicle Serial No.");
            rec.TestField("Vehicle Accounting Cycle No.");
        end;
        //03.04.2014 Elva Baltic P1 #RX MMG7.00 <<

        //07.11.2007. EDMS P2 >>
        ServiceSetup.Get;
        if (Rec."Document Type" = Rec."document type"::Order)
         and (ServiceSetup."Payment Method Mandatory") then
            Rec.TestField("Payment Method Code");
        //07.11.2007. EDMS P2 <<

        //>>Delta MGR 
        OnBeforeCheckDealTypeMandatory(Rec);
        //<<Delta MGR

        //04.04.2014 Elva Baltic P1 #RX MMG7.00
        if ServiceSetup."Deal Type Mandatory" then
            rec.TestField("Deal Type");
        //04.04.2014 Elva Baltic P1 #RX MMG7.00

        ServLine.SetRange("Document Type", rec."Document Type");
        ServLine.SetRange("Document No.", rec."No.");
        ServLine.SetFilter(Type, '>0');
        ServLine.SetFilter(Quantity, '<>0');
        if ServLine.IsEmpty then
            Error(Text001, rec."Document Type", rec."No.");

        //23.10.2007. EDMS P2 >>
        ServLine.Reset;
        ServLine.SetRange("Document Type", rec."Document Type");
        ServLine.SetRange("Document No.", rec."No.");
        ServLine.SetRange(Type, ServLine.Type::Item);
        if ServLine.FindFirst then
            repeat
                ServLine.ApplyMarkupRestrictions(1);
            until ServLine.Next = 0;
        //23.10.2007. EDMS P2 <<

        //2012.03.07 EDMS P8 >>
        if ServLine.FindFirst then
            repeat
                if ServLine."Tire Operation Type" > 0 then begin
                    ServLine.TestField("Vehicle Axle Code");
                    ServLine.TestField("Tire Position Code");
                    ServLine.TestField("Tire Code");
                end;
            until ServLine.Next = 0;
        //2012.03.07 EDMS P8 <<

        InvtSetup.Get;
        if InvtSetup."Location Mandatory" then begin
            ServLine.SetRange(Type, ServLine.Type::Item);
            if ServLine.FindSet then
                repeat
                    ServLine.TestField("Location Code");
                until ServLine.Next = 0;
            ServLine.SetFilter(Type, '>0');
        end;
        ServLine.Reset;

        if TestPrepayment(Rec) and (rec."Document Type" = rec."document type"::Order) then
            rec.Status := rec.Status::"Pending Prepayment"
        else
            rec.Status := rec.Status::Released;

        ServLine.SetServHeader(Rec);
        ServLine.CalcVATAmountLines(0, Rec, ServLine, TempVATAmountLine0);
        ServLine.CalcVATAmountLines(1, Rec, ServLine, TempVATAmountLine1);
        ServLine.UpdateVATOnLines(0, Rec, ServLine, TempVATAmountLine0);
        ServLine.UpdateVATOnLines(1, Rec, ServLine, TempVATAmountLine1);

        rec.Modify(true);
    end;

    var
        Text001: label 'There is nothing to release for %1 %2.';
        Text002: label 'This document can only be released when the approval process is complete.';
        Text003: label 'The approval process must be cancelled or completed to reopen this document.';
        InvtSetup: Record "Inventory Setup";
        Text100: label '%1 cannot be less than last posted.';
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        Approved: Boolean;
        Text101: label '%1 must not be 0 in Service Document.';
        DealType: Record "Deal Type";
        VehicleNotMandatory: Boolean;
        Text102: Label 'Mandatory checklist of category %1 is missing.';


    procedure PerformManualRelease(var ServHeader: Record "Service Header EDMS")
    var
        ApprovalEntry: Record "Approval Entry";
        VehicleLoc: Record Vehicle;
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        ServOrdInfoPaneMgt: Codeunit "Service Info-Pane Mgt. EDMS";
        ApprovedOnly: Boolean;
        AppMgt: Codeunit DocumentManagementDMS;
        AppEventMgt: Codeunit "Application Event Management";
        VehicleType: Record "Vehicle Type";
        CheckVF1: Boolean;
        CheckVF2: Boolean;
        CheckVF3: Boolean;
        OrderChecklists: Record "Process Checklist Header";
        IsHandled: Boolean;

    begin
        OnBeforePerformManualReleaseServiceDocEDMS(ServHeader);
        //26.07.2007. EDMS P2>>
        VehicleNotMandatory := false;
        if ServHeader."Deal Type" <> '' then begin
            if DealType.Get(ServHeader."Deal Type") then begin
                VehicleNotMandatory := DealType."Vehicle Not Mandatory";
                if DealType."Mandatory Checklist Category" <> '' then begin
                    OrderChecklists.reset;
                    OrderChecklists.SetRange("Source Type", 25006145);
                    OrderChecklists.SetRange("Source Subtype", OrderChecklists."Source Subtype"::"1");
                    OrderChecklists.SetRange("Source ID", ServHeader."No.");
                    OrderChecklists.SetRange("Checklist Category", DealType."Mandatory Checklist Category");
                    OrderChecklists.SetRange("Process Status", OrderChecklists."Process Status"::Completed);
                    if not OrderChecklists.FindFirst then
                        error(Text102, DealType."Mandatory Checklist Category");
                end;
                if DealType."Mandatory Checklist Category 2" <> '' then begin
                    OrderChecklists.reset;
                    OrderChecklists.SetRange("Source Type", 25006145);
                    OrderChecklists.SetRange("Source Subtype", OrderChecklists."Source Subtype"::"1");
                    OrderChecklists.SetRange("Source ID", ServHeader."No.");
                    OrderChecklists.SetRange("Checklist Category", DealType."Mandatory Checklist Category 2");
                    OrderChecklists.SetRange("Process Status", OrderChecklists."Process Status"::Completed);
                    if not OrderChecklists.FindFirst then
                        error(Text102, DealType."Mandatory Checklist Category 2");
                end;
                if DealType."Mandatory Checklist Category 3" <> '' then begin
                    OrderChecklists.reset;
                    OrderChecklists.SetRange("Source Type", 25006145);
                    OrderChecklists.SetRange("Source Subtype", OrderChecklists."Source Subtype"::"1");
                    OrderChecklists.SetRange("Source ID", ServHeader."No.");
                    OrderChecklists.SetRange("Checklist Category", DealType."Mandatory Checklist Category 3");
                    OrderChecklists.SetRange("Process Status", OrderChecklists."Process Status"::Completed);
                    if not OrderChecklists.FindFirst then
                        error(Text102, DealType."Mandatory Checklist Category 3");
                end;
            end;
        end;
        ServiceSetup.Get;
        if ServHeader."Vehicle Serial No." <> '' then begin
            VehicleLoc.Get(ServHeader."Vehicle Serial No.");
            if VehicleLoc."Type Code" <> '' then begin
                VehicleType.Get(VehicleLoc."Type Code");
                CheckVF1 := VehicleType."Check VF Run 1 on Release";
                CheckVF2 := VehicleType."Check VF Run 2 on Release";
                CheckVF3 := VehicleType."Check VF Run 3 on Release";
            end;
        end;
        IsHandled := true;
        OnBeforeCkeckVariableFields(ServHeader, IsHandled);
        If IsHandled then begin
            if (ServiceSetup."Check VF Run 1 on Release" or CheckVF1) and (not VehicleNotMandatory) then begin
                ServHeader.TestField("Vehicle Serial No.");
                if ServHeader."Variable Field Run 1" = 0 then
                    Error(Text101, AppEventMgt.VFCaptionClassTranslate(GlobalLanguage, '25006145,25006180'));

                if ServHeader."Variable Field Run 1" < ServOrdInfoPaneMgt.CalcLastVFRun1(ServHeader."Vehicle Serial No.") then
                    Error(Text100, AppEventMgt.VFCaptionClassTranslate(GlobalLanguage, '25006145,25006180'));
            end;

            if (ServiceSetup."Check VF Run 2 on Release" or CheckVF2) and (not VehicleNotMandatory) then begin
                ServHeader.TestField("Vehicle Serial No.");
                if ServHeader."Variable Field Run 2" = 0 then
                    Error(Text101, AppEventMgt.VFCaptionClassTranslate(GlobalLanguage, '25006145,25006255'));
                if ServHeader."Variable Field Run 2" < ServOrdInfoPaneMgt.CalcLastVFRun2(ServHeader."Vehicle Serial No.") then
                    Error(Text100, AppEventMgt.VFCaptionClassTranslate(GlobalLanguage, '25006145,25006255'));
            end;

            if (ServiceSetup."Check VF Run 3 on Release" or CheckVF3) and (not VehicleNotMandatory) then begin
                ServHeader.TestField("Vehicle Serial No.");
                if ServHeader."Variable Field Run 3" = 0 then
                    Error(Text101, AppEventMgt.VFCaptionClassTranslate(GlobalLanguage, '25006145,25006260'));
                if ServHeader."Variable Field Run 3" < ServOrdInfoPaneMgt.CalcLastVFRun3(ServHeader."Vehicle Serial No.") then
                    Error(Text100, AppEventMgt.VFCaptionClassTranslate(GlobalLanguage, '25006145,25006260'));
            end;
        End;

        //26.07.2007. EDMS P2 <<

        //19.01.2009. EDMS P2 >>
        if ServiceSetup."Check Vehicle Sales Date" and (not VehicleNotMandatory) then begin
            VehicleLoc.Get(ServHeader."Vehicle Serial No.");
            VehicleLoc.CalcFields(Inventory);
            if VehicleLoc.Inventory = 0 then
                VehicleLoc.TestField("Sales Date");
        end;
        //19.01.2009. EDMS P2 <<

        if ServiceSetup."Make and Model Mandatory" and (not VehicleNotMandatory) then begin
            ServHeader.TestField("Make Code");
            ServHeader.TestField("Model Code");
        end;

        //22.10.2015 NAV2016 Merge >>
        //Approved := ApprovalManagement.CheckApprServDocument(ServHeader);
        //22.10.2015 NAV2016 Merge <<

        OnCheckServHeaderPendingApproval(ServHeader);

        if Approved then begin
            case ServHeader.Status of
                ServHeader.Status::"Pending Approval":
                    Error(Text002);
                ServHeader.Status::Released:
                    Codeunit.Run(Codeunit::"Release Service Document EDMS", ServHeader);
                ServHeader.Status::Open:
                    begin
                        ApprovedOnly := true;
                        ApprovalEntry.SetCurrentkey("Table ID", "Document Type", "Document No.", "Sequence No.");
                        ApprovalEntry.SetRange("Table ID", Database::"Sales Header");
                        ApprovalEntry.SetRange("Document Type", ServHeader."Document Type");
                        ApprovalEntry.SetRange("Document No.", ServHeader."No.");
                        ApprovalEntry.SetFilter(Status, '<>%1&<>%2', ApprovalEntry.Status::Rejected, ApprovalEntry.Status::Canceled);
                        if ApprovalEntry.FindSet then begin
                            repeat
                                if (ApprovedOnly = true) and (ApprovalEntry.Status <> ApprovalEntry.Status::Approved) then
                                    ApprovedOnly := false;
                            until ApprovalEntry.Next = 0;

                            if ApprovedOnly = true and TestApprovalLimit(ServHeader) then
                                Codeunit.Run(Codeunit::"Release Service Document EDMS", ServHeader)
                            else
                                Error(Text002);
                        end else
                            Error(Text002);
                    end;
            end;
        end else
            Codeunit.Run(Codeunit::"Release Service Document EDMS", ServHeader);
    end;


    procedure PerformManualReopen(var ServHeader: Record "Service Header EDMS")
    begin
        //22.10.2015 NAV2016 Merge >>
        //Approved := ApprovalManagement.CheckApprServDocument(ServHeader);
        //22.10.2015 NAV2016 Merge <
        OnCheckReopenStatus(ServHeader);
        if Approved then begin
            case ServHeader.Status of
                ServHeader.Status::"Pending Approval":
                    Error(Text003);
                ServHeader.Status::Open, ServHeader.Status::Released, ServHeader.Status::"Pending Prepayment":
                    Reopen(ServHeader);
            end;
        end else
            Reopen(ServHeader);
    end;


    procedure TestApprovalLimit(ServHeader: Record "Service Header EDMS"): Boolean
    var
        UserSetup: Record "User Setup";
        AppAmount: Decimal;
        AppAmountLCY: Decimal;
    begin
        //22.10.2015 NAV2016 Merge >>
        //AppManagement.CalcServEDMSDocAmount(ServHeader,AppAmount,AppAmountLCY);
        //22.10.2015 NAV2016 Merge <<
        UserSetup.Get(UserId);
        if UserSetup."Unlimited Sales Approval" then
            exit(true)
        else begin
            if AppAmountLCY > UserSetup."Sales Amount Approval Limit" then
                Error(Text002)
            else
                exit(true);
        end;
    end;


    procedure Reopen(var ServHeader: Record "Service Header EDMS")
    var
        ServLine: Record "Service Line EDMS";
    begin

        if ServHeader.Status = ServHeader.Status::Open then
            exit;
        ServHeader.Status := ServHeader.Status::Open;

        // 12.05.2016 EB.P30 GH >>
        /*
        ServLine.SetServHeader(ServHeader);
        ServLine.SETRANGE("Document Type","Document Type");
        ServLine.SETRANGE("Document No.","No.");
        ServLine.SETFILTER(Type,'>0');
        ServLine.SETFILTER(Quantity,'<>0');
        IF RECORDLEVELLOCKING THEN
          ServLine.LOCKTABLE;
        IF ServLine.FINDSET THEN
          REPEAT
            ServLine.Amount := 0;
            ServLine."Amount Including VAT" := 0;
            ServLine."VAT Base Amount" := 0;
            ServLine.MODIFY;
          UNTIL ServLine.NEXT = 0;
        ServLine.RESET;
        */
        // << 12.05.2016 EB.P30 GH

        ServHeader.Modify(true);

    end;


    procedure TestPrepayment(ServHeader: Record "Service Header EDMS"): Boolean
    var
        ServLines: Record "Service Line EDMS";
    begin
        ServLines.SetRange("Document Type", ServHeader."Document Type");
        ServLines.SetRange("Document No.", ServHeader."No.");
        ServLines.SetFilter("Prepmt. Line Amount", '<>%1', 0);
        if ServLines.FindSet then begin
            repeat
                if ServLines."Prepmt. Amt. Inv." <> ServLines."Prepmt. Line Amount" then
                    exit(true);
            until ServLines.Next = 0;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCheckServHeaderPendingApproval(var ServiceHeaderEDMS: Record "Service Header EDMS")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCheckReopenStatus(var ServiceHeaderEDMS: Record "Service Header EDMS")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCkeckVariableFields(ServiceHeaderEDMS: Record "Service Header EDMS"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckDealTypeMandatory(var ServiceHeaderEDMS: Record "Service Header EDMS")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforePerformManualReleaseServiceDocEDMS(var ServHeader: Record "Service Header EDMS")
    begin
    end;


}

