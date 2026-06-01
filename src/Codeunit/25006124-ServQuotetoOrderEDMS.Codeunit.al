Codeunit 25006124 "Serv-Quote to Order EDMS"
{
    // 02.10.2019 EB.P7 B3030DMS-14
    //   Modified OnRun Trigger
    // 
    // 18.02.2015 EB.P7 #S0010
    //   Removed Autoreserv functionality for Quote
    // 
    // 27.02.2013 EDMS P8
    //   * Implement new dimension set

    TableNo = "Service Header EDMS";

    trigger OnRun()
    var
        OldServCommentLine: Record "Service Comment Line EDMS";
        Opp: Record Opportunity;
        OpportunityEntry: Record "Opportunity Entry";
        TempOpportunityEntry: Record "Opportunity Entry" temporary;
        Cust: Record Customer;
        WorkDesc: Text;
        ProcessChecklist: Record "Process Checklist Header";
        ExtServTrackNo: Record "External Serv. Tracking No.";
        ServiceHeaderArchive: Record "Service Header Archive";
        "ItemSalesDocEDMS": Codeunit "Item Sales Doc. Mgt. EDMS";
    begin
        rec.TestField("Document Type", rec."document type"::Quote);
        Cust.Get(rec."Sell-to Customer No.");
        Cust.CheckBlockedCustOnDocs(Cust, rec."document type"::Order, true, false);
        OnRunOnAfterCheckCustBlocked(Rec);
        rec.CalcFields("Amount Including VAT");
        ServiceOrderHeader := Rec;
        if GuiAllowed and not HideValidationDialog then
            "ItemSalesDocEDMS".ServiceHeaderCheckEDMS(ServiceOrderHeader);
        ServiceOrderHeader."Document Type" := ServiceOrderHeader."document type"::Order;

        ServiceQuoteLine.SetRange("Document Type", rec."Document Type");
        ServiceQuoteLine.SetRange("Document No.", rec."No.");
        ServiceQuoteLine.SetRange(Type, ServiceQuoteLine.Type::Item);
        ServiceQuoteLine.SetFilter("No.", '<>%1', '');
        if ServiceQuoteLine.FindSet then
            repeat
                if (ServiceQuoteLine."Outstanding Quantity" > 0) then begin
                    ServiceLine := ServiceQuoteLine;
                    ServiceLine.Validate("Reserved Qty. (Base)", 0);
                    ServiceLine."Line No." := 0;
                end;
            until ServiceQuoteLine.Next = 0;


        ServiceOrderHeader."No. Printed" := 0;
        ServiceOrderHeader.Status := ServiceOrderHeader.Status::Open;
        ServiceOrderHeader."No." := '';
        ServiceOrderHeader."Quote No." := rec."No.";
        ServiceOrderLine.LockTable;
        //>>DELTA
        OnBeforeInsertServiceOrderHeader(ServiceOrderHeader, rec);
        //<<DELTA
        ServiceOrderHeader.Insert(true);

        WorkDesc := Rec.GetWorkDescription();
        ServiceOrderHeader.SetWorkDescription(WorkDesc);

        ServiceOrderHeader."Order Date" := rec."Order Date";
        if rec."Posting Date" <> 0D then
            ServiceOrderHeader."Posting Date" := rec."Posting Date";
        ServiceOrderHeader."Document Date" := rec."Document Date";
        ServiceOrderHeader."Shortcut Dimension 1 Code" := rec."Shortcut Dimension 1 Code";
        ServiceOrderHeader."Shortcut Dimension 2 Code" := rec."Shortcut Dimension 2 Code";
        ServiceOrderHeader."Dimension Set ID" := rec."Dimension Set ID";
        ServiceOrderHeader."Date Sent" := 0D;
        ServiceOrderHeader."Time Sent" := 0T;

        ServiceOrderHeader."Location Code" := rec."Location Code";

        ServiceOrderHeader."Prepayment %" := Cust."Prepayment %";

        ServiceOrderHeader.Modify;

        ModifyScheduleEntries(Rec, ServiceOrderHeader);

        ServiceQuoteLine.Reset;
        ServiceQuoteLine.SetRange("Document Type", rec."Document Type");
        ServiceQuoteLine.SetRange("Document No.", rec."No.");


        if ServiceQuoteLine.FindSet then
            repeat
                ServiceOrderLine := ServiceQuoteLine;
                ServiceOrderLine."Document Type" := ServiceOrderHeader."Document Type";
                ServiceOrderLine."Document No." := ServiceOrderHeader."No.";
                ReserveServLine.TransServLineToServLine(
                  ServiceQuoteLine, ServiceOrderLine, ServiceQuoteLine."Outstanding Qty. (Base)");
                ServiceOrderLine."Shortcut Dimension 1 Code" := ServiceQuoteLine."Shortcut Dimension 1 Code";
                ServiceOrderLine."Shortcut Dimension 2 Code" := ServiceQuoteLine."Shortcut Dimension 2 Code";
                ServiceOrderLine."Dimension Set ID" := ServiceQuoteLine."Dimension Set ID";

                if Cust."Prepayment %" <> 0 then
                    ServiceOrderLine."Prepayment %" := Cust."Prepayment %";

                ServiceOrderLine.Validate("Prepayment %");

                ServiceOrderLine."Quote No." := ServiceQuoteLine."Document No.";

                ServiceOrderLine.Insert(true);

                ServiceQuoteLine."Quantity (Base)" := 0;
                ReserveServLine.VerifyQuantity(ServiceOrderLine, ServiceQuoteLine);

                //Exteral Service Tracking No update >>
                if ServiceOrderLine.Type = ServiceOrderLine.Type::"External Service" then begin
                    ExtServTrackNo.RESET;
                    ExtServTrackNo.SETRANGE("External Serv. Tracking No.", ServiceOrderLine."External Serv. Tracking No.");
                    if ExtServTrackNo.FindSet() then begin
                        ExtServTrackNo.MODIFYALL("Service Order No.", ServiceOrderLine."Document No.");
                    end;
                end;
            //Exteral Service Tracking No update <<              

            until ServiceQuoteLine.Next = 0;

        ServSetup.Get;
        if ServSetup."Archive Quotes and Orders" then begin
            Vehmgnt.ArchServDocumentNoConfirm(Rec);
            ServiceHeaderArchive.RESET;
            ServiceHeaderArchive.SetRange("Document Type", ServiceHeaderArchive."Document Type"::Quote);
            ServiceHeaderArchive.SetRange("No.", Rec."No.");
            if ServiceHeaderArchive.FindLast() then
                ServiceOrderHeader."Confirmed Quote Version No." := ServiceHeaderArchive."Version No.";
        end;

        ServiceCommentLine.SetRange(Type, rec."Document Type");
        ServiceCommentLine.SetRange("No.", rec."No.");
        if not ServiceCommentLine.IsEmpty then begin
            ServiceCommentLine.LockTable;
            if ServiceCommentLine.FindSet then
                repeat
                    OldServCommentLine := ServiceCommentLine;
                    ServiceCommentLine.Delete;
                    ServiceCommentLine.Type := ServiceOrderHeader."Document Type";
                    ServiceCommentLine."No." := ServiceOrderHeader."No.";
                    ServiceCommentLine.Insert;
                    ServiceCommentLine := OldServCommentLine;
                until ServiceCommentLine.Next = 0;
        end;
        ServiceOrderHeader.CopyLinks(Rec);

        // change doclink
        ServicePlanDocumentLink.Reset;
        ServicePlanDocumentLink.SetCurrentkey("Document Type", "Document No.");
        ServicePlanDocumentLink.SetRange("Document Type", ServicePlanDocumentLink."document type"::Quote);
        ServicePlanDocumentLink.SetRange("Document No.", rec."No.");
        ServicePlanDocumentLink.ModifyAll("Document Type", ServicePlanDocumentLink."document type"::Order, false);
        ServicePlanDocumentLink.SetRange("Document Type", ServicePlanDocumentLink."document type"::Order);
        ServicePlanDocumentLink.ModifyAll("Document No.", ServiceOrderHeader."No.", false);



        // Opportunity RC >>
        Opp.Reset;
        Opp.SetCurrentkey("Sales Document Type", "Sales Document No.");
        Opp.SetRange("Sales Document Type", Opp."sales document type"::Quote);
        Opp.SetRange("Sales Document No.", rec."No.");
        Opp.SetRange(Status, Opp.Status::"In Progress");
        if Opp.FindFirst then
            if Confirm(Text000 + Text001 + Text002, true) then begin
                TempOpportunityEntry.DeleteAll;
                TempOpportunityEntry.Init;
                TempOpportunityEntry.Validate("Opportunity No.", Opp."No.");
                TempOpportunityEntry."Sales Cycle Code" := Opp."Sales Cycle Code";
                TempOpportunityEntry."Contact No." := Opp."Contact No.";
                TempOpportunityEntry."Contact Company No." := Opp."Contact Company No.";
                TempOpportunityEntry."Salesperson Code" := Opp."Salesperson Code";
                TempOpportunityEntry."Campaign No." := Opp."Campaign No.";
                TempOpportunityEntry."Action Taken" := TempOpportunityEntry."action taken"::Won;
                TempOpportunityEntry.Insert;
                TempOpportunityEntry.SetRange("Action Taken", TempOpportunityEntry."action taken"::Won);
                Commit;
                TempOpportunityEntry.UpdateEstimates();
                Page.RunModal(Page::"Close Opportunity", TempOpportunityEntry);
                Opp.Reset;
                Opp.SetCurrentkey("Sales Document Type", "Sales Document No.");
                Opp.SetRange("Sales Document Type", Opp."sales document type"::Quote);
                Opp.SetRange("Sales Document No.", rec."No.");
                Opp.SetRange(Status, Opp.Status::"In Progress");
                if Opp.FindFirst then
                    Error(Text003)
                else begin
                    Commit;
                    rec.Get(rec."Document Type", rec."No.");
                end;
            end else
                Error(Text004);

        Opp.Reset;
        Opp.SetCurrentkey("Sales Document Type", "Sales Document No.");
        Opp.SetRange("Sales Document Type", Opp."sales document type"::Quote);
        Opp.SetRange("Sales Document No.", rec."No.");
        Opp.SetRange(Type, Opp.Type::Service);
        if Opp.FindFirst then begin
            if Opp.Status = Opp.Status::Won then begin
                Opp."Sales Document Type" := Opp."sales document type"::Order;
                Opp."Sales Document No." := ServiceOrderHeader."No.";
                Opp.Modify;
                OpportunityEntry.Reset;
                OpportunityEntry.SetCurrentkey(Active, "Opportunity No.");
                OpportunityEntry.SetRange(Active, true);
                OpportunityEntry.SetRange("Opportunity No.", Opp."No.");
                if OpportunityEntry.FindFirst then begin
                    OpportunityEntry.Modify;
                end;
            end else
                if Opp.Status = Opp.Status::Lost then begin
                    Opp."Sales Document Type" := Opp."sales document type"::" ";
                    Opp."Sales Document No." := '';
                    Opp.Modify;
                end;
        end;

        ServiceOrderHeader."Contract No." := Opp."Contact No.";
        ServiceOrderHeader.Modify;
        // Opportunity RC <<

        // Checklists RC >>
        ProcessChecklist.Reset;
        ProcessChecklist.SetRange("Source Type", Database::"Service Header EDMS");
        ProcessChecklist.SetRange("Source Subtype", rec."Document Type");
        ProcessChecklist.SetRange("Source ID", rec."No.");
        if ProcessChecklist.FindFirst then begin
            ProcessChecklist."Source Subtype" := ServiceOrderHeader."Document Type";
            ProcessChecklist."Source ID" := ServiceOrderHeader."No.";
            ProcessChecklist.Modify;
        end;
        // Checklists RC <<




        OnBeforeDeleteServiceQuote(Rec, ServiceOrderHeader);

        rec.
        Delete;

        ServiceQuoteLine.DeleteAll;

        Commit;
        Clear(CustCheckCreditLimit);
        Clear(ItemCheckAvail);
    end;

    var
        ServiceQuoteLine: Record "Service Line EDMS";
        ServiceLine: Record "Service Line EDMS";
        ServiceOrderHeader: Record "Service Header EDMS";
        ServiceOrderLine: Record "Service Line EDMS";
        ServiceCommentLine: Record "Service Comment Line EDMS";
        ServicePlanDocumentLink: Record "Service Plan Document Link";
        CustCheckCreditLimit: Codeunit "Cust-Check Cr. Limit";
        ItemCheckAvail: Codeunit "Item-Check Avail.";
        ReserveServLine: Codeunit "Service Line EDMS-Reserve";
        DocDim: Codeunit DimensionManagement;
        HideValidationDialog: Boolean;
        ServSetup: Record "Service Mgt. Setup EDMS";
        ArchiveManagement: Codeunit ArchiveManagement;
        Vehmgnt: Codeunit "Vehicle Proposal Mgt. EDMS";
        Text000: label 'An Open Opportunity is linked to this quote.\';
        Text001: label 'It has to be closed before an Order can be made.\';
        Text002: label 'Do you wish to close this Opportunity now?';
        Text003: label 'Wizard Aborted';
        Text004: label 'The Opportunity has not been closed. The program has aborted making the Order.';


    procedure GetSalesOrderHeader(var ServiceHeader2: Record "Service Header EDMS")
    begin
        ServiceHeader2 := ServiceOrderHeader;
    end;


    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;


    procedure ModifyScheduleEntries(ServiceQoute: Record "Service Header EDMS"; ServiceOrder: Record "Service Header EDMS")
    var
        ServAllocationEntry: Record "Serv. Labor Allocation Entry";
        ServLaborApplication: Record "Serv. Labor Alloc. Application";
        ServLaborApplication2: Record "Serv. Labor Alloc. Application";
    begin
        ServAllocationEntry.Reset;
        ServAllocationEntry.SetRange("Source Type", ServAllocationEntry."source type"::"Service Document");
        ServAllocationEntry.SetRange("Source Subtype", ServAllocationEntry."source subtype"::Quote);
        ServAllocationEntry.SetRange("Source ID", ServiceQoute."No.");
        if ServAllocationEntry.FindFirst then
            repeat
                ServAllocationEntry."Source Subtype" := ServAllocationEntry."source subtype"::Order;
                ServAllocationEntry."Source ID" := ServiceOrder."No.";
                ServAllocationEntry.Modify;
            until ServAllocationEntry.Next = 0;

        ServLaborApplication.Reset;
        ServLaborApplication.SetRange("Document Type", ServiceQoute."Document Type");
        ServLaborApplication.SetRange("Document No.", ServiceQoute."No.");
        if ServLaborApplication.FindFirst then
            repeat
                ServLaborApplication2 := ServLaborApplication;
                ServLaborApplication2."Document Type" := ServiceOrder."Document Type";
                ServLaborApplication2."Document No." := ServiceOrder."No.";
                ServLaborApplication2.Insert;
                ServLaborApplication.Delete;
            until ServLaborApplication.Next = 0;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeDeleteServiceQuote(var QuoteServiceHeader: Record "Service Header EDMS"; var OrderServiceHeader: Record "Service Header EDMS")
    begin

    end;

    Procedure AddToExistingOrder(ServiceQoute: Record "Service Header EDMS"; ServiceOrder: Code[20])
    var
        OldServCommentLine: Record "Service Comment Line EDMS";
        Opp: Record Opportunity;
        OpportunityEntry: Record "Opportunity Entry";
        TempOpportunityEntry: Record "Opportunity Entry" temporary;
        Cust: Record Customer;
        WorkDesc: Text;
        ProcessChecklist: Record "Process Checklist Header";
        ExtServTrackNo: Record "External Serv. Tracking No.";
        ServiceHeaderArchive: Record "Service Header Archive";
        NewServiceOrder: Record "Service Header EDMS";
        NewServiceOrderLine: Record "Service Line EDMS";
        LineNo: integer;
    begin
        ServiceQoute.TestField("Document Type", ServiceQoute."document type"::Quote);

        NewServiceOrder.Reset();
        NewServiceOrder.Get(NewServiceOrder."Document Type"::Order, ServiceOrder);
        ServiceOrderHeader.Get(NewServiceOrder."Document Type"::Order, ServiceOrder);

        NewServiceOrderLine.Reset();
        NewServiceOrderLine.SetRange("Document Type", NewServiceOrder."Document Type");
        NewServiceOrderLine.SetRange("Document No.", NewServiceOrder."No.");
        IF NewServiceOrderLine.FindLast() then
            LineNo := NewServiceOrderLine."Line No.";

        ServiceOrderLine.LockTable;

        ServiceQuoteLine.Reset;
        ServiceQuoteLine.SetRange("Document Type", ServiceQoute."Document Type");
        ServiceQuoteLine.SetRange("Document No.", ServiceQoute."No.");

        if ServiceQuoteLine.FindSet then
            repeat
                ServiceOrderLine.Init();
                ServiceOrderLine."Document Type" := NewServiceOrder."Document Type";
                ServiceOrderLine."Document No." := NewServiceOrder."No.";
                LineNo := LineNo + 10000;
                ServiceOrderLine."Line No." := LineNo;
                ServiceOrderLine.Validate(Type, ServiceQuoteLine.Type);
                ServiceOrderLine.Validate("No.", ServiceQuoteLine."No.");
                ServiceOrderLine."Location Code" := ServiceQuoteLine."Location Code";
                ServiceOrderLine."Transfer From Location Code" := ServiceQuoteLine."Transfer From Location Code";
                ServiceOrderLine.Validate(Quantity, ServiceQuoteLine.Quantity);
                ServiceOrderLine.Validate("Unit Price", ServiceQuoteLine."Unit Price");
                ServiceOrderLine.Validate("Line Discount %", ServiceQuoteLine."Line Discount %");
                ReserveServLine.TransServLineToServLine(
                  ServiceQuoteLine, ServiceOrderLine, ServiceQuoteLine."Outstanding Qty. (Base)");

                ServiceOrderLine."Quote No." := ServiceQuoteLine."Document No.";

                ServiceOrderLine.Insert(true);

                ServiceQuoteLine."Quantity (Base)" := 0;
                ReserveServLine.VerifyQuantity(ServiceOrderLine, ServiceQuoteLine);

                //Exteral Service Tracking No update >>
                if ServiceOrderLine.Type = ServiceOrderLine.Type::"External Service" then begin
                    ExtServTrackNo.RESET;
                    ExtServTrackNo.SETRANGE("External Serv. Tracking No.", ServiceOrderLine."External Serv. Tracking No.");
                    if ExtServTrackNo.FindSet() then begin
                        ExtServTrackNo.MODIFYALL("Service Order No.", ServiceOrderLine."Document No.");
                    end;
                end;
                //Exteral Service Tracking No update <<   

                OnAfterAddLineServiceQuoteToOrder(ServiceQuoteLine, ServiceOrderLine);

            until ServiceQuoteLine.Next = 0;

        ServSetup.Get;
        if ServSetup."Archive Quotes and Orders" then begin
            Vehmgnt.ArchServDocumentNoConfirm(ServiceQoute);
        end;

        ServiceCommentLine.SetRange(Type, ServiceQoute."Document Type");
        ServiceCommentLine.SetRange("No.", ServiceQoute."No.");
        if not ServiceCommentLine.IsEmpty then begin
            ServiceCommentLine.LockTable;
            if ServiceCommentLine.FindSet then
                repeat
                    OldServCommentLine := ServiceCommentLine;
                    ServiceCommentLine.Delete;
                    ServiceCommentLine.Type := ServiceOrderHeader."Document Type";
                    ServiceCommentLine."No." := ServiceOrderHeader."No.";
                    ServiceCommentLine.Insert;
                    ServiceCommentLine := OldServCommentLine;
                until ServiceCommentLine.Next = 0;
        end;
        ServiceOrderHeader.CopyLinks(ServiceQoute);

        // change doclink
        ServicePlanDocumentLink.Reset;
        ServicePlanDocumentLink.SetCurrentkey("Document Type", "Document No.");
        ServicePlanDocumentLink.SetRange("Document Type", ServicePlanDocumentLink."document type"::Quote);
        ServicePlanDocumentLink.SetRange("Document No.", ServiceQoute."No.");
        ServicePlanDocumentLink.ModifyAll("Document Type", ServicePlanDocumentLink."document type"::Order, false);
        ServicePlanDocumentLink.SetRange("Document Type", ServicePlanDocumentLink."document type"::Order);
        ServicePlanDocumentLink.ModifyAll("Document No.", ServiceOrderHeader."No.", false);



        // Opportunity RC >>
        Opp.Reset;
        Opp.SetCurrentkey("Sales Document Type", "Sales Document No.");
        Opp.SetRange("Sales Document Type", Opp."sales document type"::Quote);
        Opp.SetRange("Sales Document No.", ServiceQoute."No.");
        Opp.SetRange(Status, Opp.Status::"In Progress");
        if Opp.FindFirst then
            if Confirm(Text000 + Text001 + Text002, true) then begin
                TempOpportunityEntry.DeleteAll;
                TempOpportunityEntry.Init;
                TempOpportunityEntry.Validate("Opportunity No.", Opp."No.");
                TempOpportunityEntry."Sales Cycle Code" := Opp."Sales Cycle Code";
                TempOpportunityEntry."Contact No." := Opp."Contact No.";
                TempOpportunityEntry."Contact Company No." := Opp."Contact Company No.";
                TempOpportunityEntry."Salesperson Code" := Opp."Salesperson Code";
                TempOpportunityEntry."Campaign No." := Opp."Campaign No.";
                TempOpportunityEntry."Action Taken" := TempOpportunityEntry."action taken"::Won;
                TempOpportunityEntry.Insert;
                TempOpportunityEntry.SetRange("Action Taken", TempOpportunityEntry."action taken"::Won);
                Commit;
                TempOpportunityEntry.UpdateEstimates();
                Page.RunModal(Page::"Close Opportunity", TempOpportunityEntry);
                Opp.Reset;
                Opp.SetCurrentkey("Sales Document Type", "Sales Document No.");
                Opp.SetRange("Sales Document Type", Opp."sales document type"::Quote);
                Opp.SetRange("Sales Document No.", ServiceQoute."No.");
                Opp.SetRange(Status, Opp.Status::"In Progress");
                if Opp.FindFirst then
                    Error(Text003)
                else begin
                    Commit;
                    ServiceQoute.Get(ServiceQoute."Document Type", ServiceQoute."No.");
                end;
            end else
                Error(Text004);

        Opp.Reset;
        Opp.SetCurrentkey("Sales Document Type", "Sales Document No.");
        Opp.SetRange("Sales Document Type", Opp."sales document type"::Quote);
        Opp.SetRange("Sales Document No.", ServiceQoute."No.");
        Opp.SetRange(Type, Opp.Type::Service);
        if Opp.FindFirst then begin
            if Opp.Status = Opp.Status::Won then begin
                Opp."Sales Document Type" := Opp."sales document type"::Order;
                Opp."Sales Document No." := ServiceOrderHeader."No.";
                Opp.Modify;
                OpportunityEntry.Reset;
                OpportunityEntry.SetCurrentkey(Active, "Opportunity No.");
                OpportunityEntry.SetRange(Active, true);
                OpportunityEntry.SetRange("Opportunity No.", Opp."No.");
                if OpportunityEntry.FindFirst then begin
                    OpportunityEntry.Modify;
                end;
            end else
                if Opp.Status = Opp.Status::Lost then begin
                    Opp."Sales Document Type" := Opp."sales document type"::" ";
                    Opp."Sales Document No." := '';
                    Opp.Modify;
                end;
        end;

        // Opportunity RC <<

        // Checklists RC >>
        ProcessChecklist.Reset;
        ProcessChecklist.SetRange("Source Type", Database::"Service Header EDMS");
        ProcessChecklist.SetRange("Source Subtype", ServiceQoute."Document Type");
        ProcessChecklist.SetRange("Source ID", ServiceQoute."No.");
        if ProcessChecklist.FindFirst then begin
            ProcessChecklist."Source Subtype" := NewServiceOrder."Document Type";
            ProcessChecklist."Source ID" := NewServiceOrder."No.";
            ProcessChecklist.Modify;
        end;
        // Checklists RC <<




        OnBeforeDeleteServiceQuote(ServiceQoute, NewServiceOrder);

        ServiceQoute.Delete;

        ServiceQuoteLine.DeleteAll;

        Commit;
        Clear(CustCheckCreditLimit);
        Clear(ItemCheckAvail);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAddLineServiceQuoteToOrder(var QuoteServiceLine: Record "Service Line EDMS"; var OrderServiceLine: Record "Service Line EDMS")
    begin

    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertServiceOrderHeader(var SalesOrderHeader: Record "Service Header EDMS"; var ServiceQuoteHeader: Record "Service Header EDMS")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnRunOnAfterCheckCustBlocked(var ServiceHeaderEDMS: Record "Service Header EDMS")
    begin
    end;
}

