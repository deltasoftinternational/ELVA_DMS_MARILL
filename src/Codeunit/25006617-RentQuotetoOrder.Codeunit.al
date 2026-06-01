Codeunit 25006617 "Rent-Quote to Order"
{
    // 02.10.2019 EB.P7 B3030DMS-14
    //   Modified OnRun trigger.

    TableNo = "Rent Header";

    trigger OnRun()
    var
        OldSalesCommentLine: Record "Sales Comment Line";
        Opp: Record Opportunity;
        OpportunityEntry: Record "Opportunity Entry";
        TempOpportunityEntry: Record "Opportunity Entry" temporary;
        Cust: Record Customer;
        ProcessChecklist: Record "Process Checklist Header";
        DocAttachMgtEDMS: Codeunit "Document Attachment Mgmt EDMS";
        RentDescription: Text;
    begin
        Rec.TestField("Document Type", Rec."document type"::Quote);
        IsMakeOrder := true;
        Cust.Get(Rec."Sell-to Customer No.");
        Cust.CheckBlockedCustOnDocs(Cust, Rec."document type"::Order, true, false);
        Rec.CalcFields("Amount Including VAT");
        RentOrderHeader := Rec;
        RentOrderHeader."Document Type" := RentOrderHeader."document type"::Order;
        RentOrderHeader.Status := RentOrderHeader.Status::Open;
        RentOrderHeader."No." := '';
        RentOrderHeader."Rent Quote No." := Rec."No.";
        RentSalesLine.LockTable;
        RentLine.LockTable;
        RentOrderHeader.Insert(true);


        RentOrderHeader."Order Date" := Rec."Order Date";
        if Rec."Posting Date" <> 0D then
            RentOrderHeader."Posting Date" := Rec."Posting Date";
        RentOrderHeader."Document Date" := Rec."Document Date";
        RentOrderHeader."Shipment Date" := Rec."Shipment Date";
        RentOrderHeader."Shortcut Dimension 1 Code" := Rec."Shortcut Dimension 1 Code";
        RentOrderHeader."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
        RentOrderHeader."Location Code" := Rec."Location Code";
        RentOrderHeader."Outbound Whse. Handling Time" := Rec."Outbound Whse. Handling Time";
        RentOrderHeader."Ship-to Name" := Rec."Ship-to Name";
        RentOrderHeader."Ship-to Name 2" := Rec."Ship-to Name 2";
        RentOrderHeader."Ship-to Address" := Rec."Ship-to Address";
        RentOrderHeader."Ship-to Address 2" := Rec."Ship-to Address 2";
        RentOrderHeader."Ship-to City" := Rec."Ship-to City";
        RentOrderHeader."Ship-to Post Code" := Rec."Ship-to Post Code";
        RentOrderHeader."Ship-to County" := Rec."Ship-to County";
        RentOrderHeader."Ship-to Country/Region Code" := Rec."Ship-to Country/Region Code";
        RentOrderHeader."Ship-to Contact" := Rec."Ship-to Contact";
        RentOrderHeader."Prepayment %" := Cust."Prepayment %";
        RentOrderHeader."Rent Description" := Rec."Rent Description";
        RentDescription := Rec.GetRentDescription();
        RentOrderHeader.SetRentDescription(RentDescription);
        RentOrderHeader.Modify;

        RentQuoteLine.Reset;
        RentQuoteLine.SetRange("Document Type", Rec."Document Type");
        RentQuoteLine.SetRange("Document No.", Rec."No.");
        if RentQuoteLine.FindSet then
            repeat
                RentLine := RentQuoteLine;
                RentLine."Document Type" := RentOrderHeader."Document Type";
                RentLine."Document No." := RentOrderHeader."No.";
                RentLine.Validate("Dimension Set ID");
                RentLine.Insert;
            until RentQuoteLine.Next = 0;

        RentSalesQuoteLine.Reset;
        RentSalesQuoteLine.SetRange("Document Type", Rec."Document Type");
        RentSalesQuoteLine.SetRange("Document No.", Rec."No.");

        if RentSalesQuoteLine.FindSet then
            repeat
                RentSalesLine := RentSalesQuoteLine;
                RentSalesLine."Document Type" := RentOrderHeader."Document Type";
                RentSalesLine."Document No." := RentOrderHeader."No.";
                if Cust."Prepayment %" <> 0 then
                    RentSalesLine."Prepayment %" := Cust."Prepayment %";
                RentSalesLine.Validate("Prepayment %");

                RentSalesLine.Insert;

            until RentSalesQuoteLine.Next = 0;

        RentOrderHeader.CopyLinks(Rec);

        DocAttachMgtEDMS.DocAttachFlowFormRentQuoteToRentOrder(Rec, RentOrderHeader);

        Rec.Delete;

        RentSalesQuoteLine.DeleteAll;
        RentQuoteLine.DeleteAll;

        Commit;

        Opp.Reset;
        Opp.SetCurrentkey("Sales Document Type", "Sales Document No.");
        Opp.SetRange("Sales Document Type", Opp."sales document type"::Quote);
        Opp.SetRange("Sales Document No.", Rec."No.");
        Opp.SetRange(Status, Opp.Status::"In Progress");
        Opp.SetRange(Type, Opp.Type::Rent);
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
                Page.RunModal(Page::"Close Opportunity", TempOpportunityEntry);
                Opp.Reset;
                Opp.SetCurrentkey("Sales Document Type", "Sales Document No.");
                Opp.SetRange("Sales Document Type", Opp."sales document type"::Quote);
                Opp.SetRange("Sales Document No.", Opp."No.");
                Opp.SetRange(Status, Opp.Status::"In Progress");
                Opp.SetRange(Type, Opp.Type::Rent);
                if Opp.FindFirst then
                    Error(Text003)
                else begin
                    Commit;
                end;
            end else
                Error(Text004);

        Opp.Reset;
        Opp.SetCurrentkey("Sales Document Type", "Sales Document No.");
        Opp.SetRange("Sales Document Type", Opp."sales document type"::Quote);
        Opp.SetRange("Sales Document No.", Opp."No.");
        Opp.SetRange(Type, Opp.Type::Rent);
        if Opp.FindFirst then begin
            if Opp.Status = Opp.Status::Won then begin
                Opp."Sales Document Type" := Opp."sales document type"::Order;
                Opp."Sales Document No." := RentOrderHeader."No.";
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

        // Checklists RC >>
        ProcessChecklist.Reset;
        ProcessChecklist.SetRange("Source Type", Database::"Rent Header");
        ProcessChecklist.SetRange("Source Subtype", Rec."Document Type");
        ProcessChecklist.SetRange("Source ID", Rec."No.");
        if ProcessChecklist.FindFirst then begin
            ProcessChecklist."Source Subtype" := RentOrderHeader."Document Type";
            ProcessChecklist."Source ID" := RentOrderHeader."No.";
            ProcessChecklist.Modify;
        end;
        // Checklists RC <<

        RentOrderHeader."Contract No." := Opp."Contact No.";
        RentOrderHeader.Modify;

        Clear(CustCheckCreditLimit);
        Clear(ItemCheckAvail);
    end;

    var
        Text000: label 'An Open Opportunity is linked to this quote.\';
        Text001: label 'It has to be closed before an Order can be made.\';
        Text002: label 'Do you wish to close this Opportunity now?';
        Text003: label 'Wizard Aborted';
        RentSalesQuoteLine: Record "Rent Sales Line";
        RentQuoteLine: Record "Rent Line";
        RentSalesLine: Record "Rent Sales Line";
        RentLine: Record "Rent Line";
        RentOrderHeader: Record "Rent Header";
        SalesCommentLine: Record "Sales Comment Line";
        ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
        CustCheckCreditLimit: Codeunit "Cust-Check Cr. Limit";
        ItemCheckAvail: Codeunit "Item-Check Avail.";
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
        DocDim: Codeunit DimensionManagement;
        PrepmtMgt: Codeunit "Prepayment Mgt.";
        HideValidationDialog: Boolean;
        Text004: label 'The Opportunity has not been closed. The program has aborted making the Order.';
        IsMakeOrder: Boolean;


    procedure GetRentOrderHeader(var RentHeader2: Record "Rent Header")
    begin
        RentHeader2 := RentOrderHeader;
    end;


    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;


    procedure CheckMakeOrder(): Boolean
    begin
        exit(IsMakeOrder);
    end;
}

