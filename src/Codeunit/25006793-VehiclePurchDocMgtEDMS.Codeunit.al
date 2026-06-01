Codeunit 25006793 "Vehicle Purch. Doc. Mgt. EDMS"
{
    // #Owner EDMS.Integration


    trigger OnRun()
    begin
    end;


    procedure SubmitPurchOrder(PurchHeader: Record "Purchase Header")
    var
        PurchLine: Record "Purchase Line";
        UserIntegrationSession: Record "User Integr. Session Header";
        DMSIntegrationMgt: Codeunit "Integration Management EDMS";
    begin
        PurchHeader.TestField("No.");
        PurchHeader.TestField("Document Type", PurchHeader."document type"::Order);

        PurchLine.Reset;
        PurchLine.SetRange("Document Type", PurchHeader."Document Type");
        PurchLine.SetRange("Document No.", PurchHeader."No.");
        PurchLine.SetRange(Type, PurchLine.Type::Item);
        PurchLine.SetFilter("No.", '<>%1', '');
        PurchLine.FindFirst;
    end;
}

