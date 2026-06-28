Codeunit 25006872 "Service Booking to Order"
{
    TableNo = "Service Header EDMS";

    trigger OnRun()
    var
        OldServCommentLine: Record "Service Comment Line EDMS";
        Cust: Record Customer;
        IsHandled: boolean;
    begin
        Rec.TestField("Document Type", Rec."document type"::Booking);
        OnBeforeTestfieldResourceNo(Rec, IsHandled);
        if not IsHandled then
            Rec.TestField("Booking Resource No.");

        Cust.Get(Rec."Sell-to Customer No.");
        Cust.CheckBlockedCustOnDocs(Cust, Rec."document type"::Order, true, false);
        Rec.CalcFields("Amount Including VAT");

        ServiceOrderHeader := Rec;
        if GuiAllowed and not HideValidationDialog then
            SalesMgt.ServiceHeaderCheckEDMS(ServiceOrderHeader);
        ServiceOrderHeader."Document Type" := ServiceOrderHeader."document type"::Order;

        ServiceOrderHeader."No. Printed" := 0;
        ServiceOrderHeader.Status := ServiceOrderHeader.Status::Open;
        ServiceOrderHeader."No." := '';
        ServiceOrderHeader."Booking No." := Rec."No.";
        ServiceOrderLine.LockTable;
        ServiceOrderHeader.Insert(true);


        ServiceOrderHeader."Order Date" := Rec."Order Date";
        if Rec."Posting Date" <> 0D then
            ServiceOrderHeader."Posting Date" := Rec."Posting Date";
        ServiceOrderHeader."Document Date" := Rec."Document Date";
        ServiceOrderHeader."Shortcut Dimension 1 Code" := Rec."Shortcut Dimension 1 Code";
        ServiceOrderHeader."Shortcut Dimension 2 Code" := Rec."Shortcut Dimension 2 Code";
        ServiceOrderHeader."Dimension Set ID" := Rec."Dimension Set ID";
        ServiceOrderHeader."Date Sent" := 0D;
        ServiceOrderHeader."Time Sent" := 0T;

        ServiceOrderHeader."Location Code" := Rec."Location Code";

        ServiceOrderHeader."Prepayment %" := Cust."Prepayment %";

        ServiceOrderHeader.Modify;


        ServiceBookingLine.Reset;
        ServiceBookingLine.SetRange("Document Type", Rec."Document Type");
        ServiceBookingLine.SetRange("Document No.", Rec."No.");


        if ServiceBookingLine.FindSet then
            repeat
                ServiceOrderLine := ServiceBookingLine;
                ServiceOrderLine."Document Type" := ServiceOrderHeader."Document Type";
                ServiceOrderLine."Document No." := ServiceOrderHeader."No.";
                ServiceOrderLine."Shortcut Dimension 1 Code" := ServiceBookingLine."Shortcut Dimension 1 Code";
                ServiceOrderLine."Shortcut Dimension 2 Code" := ServiceBookingLine."Shortcut Dimension 2 Code";
                ServiceOrderLine."Dimension Set ID" := ServiceBookingLine."Dimension Set ID";

                if Cust."Prepayment %" <> 0 then
                    ServiceOrderLine."Prepayment %" := Cust."Prepayment %";

                ServiceOrderLine.Validate("Prepayment %");

                ServiceOrderLine.Insert;

                ServiceBookingLine."Quantity (Base)" := 0;
            until ServiceBookingLine.Next = 0;

        ServSetup.Get;
        if ServSetup."Archive Quotes and Orders" then
            Vehmgnt.ArchServDocumentNoConfirm(Rec);

        ServiceCommentLine.SetRange(Type, Rec."Document Type");
        ServiceCommentLine.SetRange("No.", Rec."No.");
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
        ServicePlanDocumentLink.SetRange("Document Type", ServicePlanDocumentLink."document type"::Booking);
        ServicePlanDocumentLink.SetRange("Document No.", rec."No.");
        ServicePlanDocumentLink.ModifyAll("Document Type", ServicePlanDocumentLink."document type"::Order, false);
        ServicePlanDocumentLink.SetRange("Document Type", ServicePlanDocumentLink."document type"::Order);
        ServicePlanDocumentLink.ModifyAll("Document No.", ServiceOrderHeader."No.", false);

        Rec.Delete;

        ServiceBookingLine.DeleteAll;

        Commit;
        Clear(CustCheckCreditLimit);
        Clear(ItemCheckAvail);
    end;

    var
        ServiceBookingLine: Record "Service Line EDMS";
        ServiceOrderHeader: Record "Service Header EDMS";
        ServiceOrderLine: Record "Service Line EDMS";
        ServiceCommentLine: Record "Service Comment Line EDMS";
        ServicePlanDocumentLink: Record "Service Plan Document Link";
        CustCheckCreditLimit: Codeunit "Cust-Check Cr. Limit";
        SalesMgt: Codeunit "Item Sales Doc. Mgt. EDMS";
        ItemCheckAvail: Codeunit "Item-Check Avail.";
        DocDim: Codeunit DimensionManagement;
        HideValidationDialog: Boolean;
        ServSetup: Record "Service Mgt. Setup EDMS";
        ArchiveManagement: Codeunit ArchiveManagement;
        Vehmgnt: Codeunit "Vehicle Proposal Mgt. EDMS";


    procedure GetSalesOrderHeader(var ServiceHeader2: Record "Service Header EDMS")
    begin
        ServiceHeader2 := ServiceOrderHeader;
    end;


    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestfieldResourceNo(Rec: Record "Service Header EDMS"; var IsHandled: Boolean)
    begin
    end;
}

