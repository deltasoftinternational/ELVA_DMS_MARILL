codeunit 25006883 "Document Profile Mgt. EDMS"
{
    trigger OnRun()
    begin
    end;

    var
        TextErr001: Label 'Document profile %1 is not enabled for user %2.';

    procedure IsDocProfileEnabled(DocProfile: Option " ","Spare Parts Trade","Vehicle Trade",Service,Rent): boolean
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then begin
            Case DocProfile of
                DocProfile::" ":
                    begin
                        if UserSetup."Empty Doc. Profile Enabled" then
                            exit(true)
                        else
                            exit(false);
                    end;
                DocProfile::Rent:
                    begin
                        if UserSetup."Rent Doc. Profile Enabled" then
                            exit(true)
                        else
                            exit(false);
                    end;
                DocProfile::Service:
                    begin
                        if UserSetup."Serv. Doc. Profile Enabled" then
                            exit(true)
                        else
                            exit(false);
                    end;
                DocProfile::"Spare Parts Trade":
                    begin
                        if UserSetup."SP Doc. Profile Enabled" then
                            exit(true)
                        else
                            exit(false);
                    end;
                DocProfile::"Vehicle Trade":
                    begin
                        if UserSetup."Veh. Doc. Profile Enabled" then
                            exit(true)
                        else
                            exit(false);
                    end;
            end;
        end else
            exit(true);
    end;

    procedure GetDocProfileFilter(): Text
    var
        UserSetup: Record "User Setup";
        DocProfFilter: Text;
    begin
        if UserSetup.Get(UserId) then begin
            if UserSetup."Empty Doc. Profile Enabled" then
                DocProfFilter := '0';
            if UserSetup."Rent Doc. Profile Enabled" then
                if StrLen(DocProfFilter) > 0 then
                    DocProfFilter := DocProfFilter + '|4'
                else
                    DocProfFilter := '4';
            if UserSetup."Serv. Doc. Profile Enabled" then
                if StrLen(DocProfFilter) > 0 then
                    DocProfFilter := DocProfFilter + '|3'
                else
                    DocProfFilter := '3';
            if UserSetup."SP Doc. Profile Enabled" then
                if StrLen(DocProfFilter) > 0 then
                    DocProfFilter := DocProfFilter + '|1'
                else
                    DocProfFilter := '1';
            if UserSetup."Veh. Doc. Profile Enabled" then
                if StrLen(DocProfFilter) > 0 then
                    DocProfFilter := DocProfFilter + '|2'
                else
                    DocProfFilter := '2';
            exit(DocProfFilter);
        end else
            exit(DocProfFilter);
    end;

    procedure GetDefaultDocProfile(): Integer
    var
        UserSetup: Record "User Setup";
    begin
        if UserSetup.Get(UserId) then
            exit(UserSetup."Default Doc. Profile");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeInsertEvent', '', false, false)]
    local procedure SetSalesHeaderDocProfileOnInsert(var Rec: Record "Sales Header"; RunTrigger: Boolean)
    var

    begin
        SetSalesHeaderDocProfile(Rec, true);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeModifyEvent', '', false, false)]
    local procedure SetSalesHeaderDocProfileOnModify(var Rec: Record "Sales Header"; RunTrigger: Boolean)
    var

    begin
        SetSalesHeaderDocProfile(Rec, false);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnBeforeRenameEvent', '', false, false)]
    local procedure SetSalesHeaderDocProfileOnRename(var Rec: Record "Sales Header"; RunTrigger: Boolean)
    var

    begin
        SetSalesHeaderDocProfile(Rec, false);
    end;

    procedure SetSalesHeaderDocProfile(var Rec: Record "Sales Header"; SetDefaultDocProf: Boolean)
    var

    begin
        if SetDefaultDocProf then
            if Rec."Document Profile" = Rec."Document Profile"::" " then
                Rec."Document Profile" := GetDefaultDocProfile;
        if not IsDocProfileEnabled(Rec."Document Profile") then
            Error(TextErr001, Format(Rec."Document Profile"), UserId);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Order List", 'OnOpenPageEvent', '', false, false)]
    local procedure SetSalesOrderListDocProfileFilter(var Rec: Record "Sales Header")
    var

    begin
        SetSalesHeaderDocProfileFilter(Rec);
    end;

    procedure SetSalesHeaderDocProfileFilter(var Rec: Record "Sales Header")
    var

    begin
        Rec.FilterGroup(2);
        Rec.SetFilter("Document Profile", GetDocProfileFilter());
        Rec.FilterGroup(0);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Return Order List", 'OnOpenPageEvent', '', false, false)]
    local procedure SetSalesReturnOrderListDocProfileFilter(var Rec: Record "Sales Header")
    var

    begin
        SetSalesHeaderDocProfileFilter(Rec);
    end;

    procedure SetSalesArchiveHeaderDocProfileFilter(var Rec: Record "Sales Header Archive")
    var

    begin
        Rec.FilterGroup(2);
        Rec.SetFilter("Document Profile", GetDocProfileFilter());
        Rec.FilterGroup(0);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Quote Archives", 'OnOpenPageEvent', '', false, false)]
    local procedure SetSalesQuoteArchiveListDocProfileFilter(var Rec: Record "Sales Header Archive")
    var

    begin
        SetSalesArchiveHeaderDocProfileFilter(Rec);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Order Archives", 'OnOpenPageEvent', '', false, false)]
    local procedure SetSalesOrderArchiveListDocProfileFilter(var Rec: Record "Sales Header Archive")
    var

    begin
        SetSalesArchiveHeaderDocProfileFilter(Rec);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Sales Return Order Archive", 'OnOpenPageEvent', '', false, false)]
    local procedure SetSalesReturnOrderArchiveDocProfileFilter(var Rec: Record "Sales Header Archive")
    var

    begin
        SetSalesArchiveHeaderDocProfileFilter(Rec);
    end;

    procedure SetPostedSalesInvoiceHeaderDocProfileFilter(var Rec: Record "Sales Invoice Header")
    var

    begin
        Rec.FilterGroup(2);
        Rec.SetFilter("Document Profile", GetDocProfileFilter());
        Rec.FilterGroup(0);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Posted Sales Invoices", 'OnOpenPageEvent', '', false, false)]
    local procedure SetSalesInvoicesDocProfileFilter(var Rec: Record "Sales Invoice Header")
    var

    begin
        SetPostedSalesInvoiceHeaderDocProfileFilter(Rec);
    end;

    procedure SetPostedSalesShipmentHeaderDocProfileFilter(var Rec: Record "Sales Shipment Header")
    var

    begin
        Rec.FilterGroup(2);
        Rec.SetFilter("Document Profile", GetDocProfileFilter());
        Rec.FilterGroup(0);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Posted Sales Shipments", 'OnOpenPageEvent', '', false, false)]
    local procedure SetSalesShipmentDocProfileFilter(var Rec: Record "Sales Shipment Header")
    var

    begin
        SetPostedSalesShipmentHeaderDocProfileFilter(Rec);
    end;

    procedure SetPostedSalesCrMemoHeaderDocProfileFilter(var Rec: Record "Sales Cr.Memo Header")
    var

    begin
        Rec.FilterGroup(2);
        Rec.SetFilter("Document Profile", GetDocProfileFilter());
        Rec.FilterGroup(0);
    end;

    [EventSubscriber(ObjectType::Page, Page::"Posted Sales Credit Memos", 'OnOpenPageEvent', '', false, false)]
    local procedure SetSalesCrMemoDocProfileFilter(var Rec: Record "Sales Cr.Memo Header")
    var

    begin
        SetPostedSalesCrMemoHeaderDocProfileFilter(Rec);
    end;

    procedure SetPurchaseHeaderDocProfile(var Rec: Record "Purchase Header"; SetDefaultDocProf: Boolean)
    var

    begin
        if SetDefaultDocProf then
            if Rec."Document Profile" = Rec."Document Profile"::" " then
                Rec."Document Profile" := GetDefaultDocProfile;
        if not IsDocProfileEnabled(Rec."Document Profile") then
            Error(TextErr001, Format(Rec."Document Profile"), UserId);
    end;


    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeInsertEvent', '', false, false)]
    local procedure SetPurchaseHeaderDocProfileOnInsert(var Rec: Record "Purchase Header"; RunTrigger: Boolean)
    var

    begin
        SetPurchaseHeaderDocProfile(Rec, true);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeModifyEvent', '', false, false)]
    local procedure SetPurchaseHeaderDocProfileOnModify(var Rec: Record "Purchase Header"; RunTrigger: Boolean)
    var

    begin
        SetPurchaseHeaderDocProfile(Rec, false);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnBeforeRenameEvent', '', false, false)]
    local procedure SetPurchaseHeaderDocProfileOnRename(var Rec: Record "Purchase Header"; RunTrigger: Boolean)
    var

    begin
        SetPurchaseHeaderDocProfile(Rec, false);
    end;

}
