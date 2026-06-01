Codeunit 25006019 "Serv.-Post Prepayment Yes/No"
{

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'Do you want to post the prepayments for %1 %2?';
        Text001: label 'Do you want to post a credit memo for the prepayments for %1 %2?';
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";


    procedure PostPrepmtInvoiceYN(var ServHeader2: Record "Service Header EDMS"; Print: Boolean)
    var
        ServHeader: Record "Service Header EDMS";
        ServPostPrepayments: Codeunit "Service-Post Prepayments";
    begin
        ServHeader.Copy(ServHeader2);
        if not Confirm(Text000, false, ServHeader."Document Type", ServHeader."No.") then
            exit;

        ServPostPrepayments.Invoice(ServHeader);

        if Print then
            GetReport(ServHeader, 0);

        Commit;
        ServHeader2 := ServHeader;
    end;


    procedure PostPrepmtCrMemoYN(var ServHeader2: Record "Service Header EDMS"; Print: Boolean)
    var
        ServHeader: Record "Service Header EDMS";
        ServPostPrepayments: Codeunit "Service-Post Prepayments";
    begin
        ServHeader.Copy(ServHeader2);
        if not Confirm(Text001, false, ServHeader."Document Type", ServHeader."No.") then
            exit;

        ServPostPrepayments.CreditMemo(ServHeader);

        if Print then
            GetReport(ServHeader, 1);

        Commit;
        ServHeader2 := ServHeader;
    end;


    procedure GetReport(var ServHeader: Record "Service Header EDMS"; DocumentType: Option Invoice,"Credit Memo")
    var
        ReportSelection: Record "Report Selections";
    begin
        case DocumentType of
            Documenttype::Invoice:
                begin
                    SalesInvHeader."No." := ServHeader."Last Prepayment No.";
                    SalesInvHeader.SetRecfilter;
                    PrintReport(ReportSelection.Usage::"S.Invoice".AsInteger());
                end;
            Documenttype::"Credit Memo":
                begin
                    SalesCrMemoHeader."No." := ServHeader."Last Prepmt. Cr. Memo No.";
                    SalesCrMemoHeader.SetRecfilter;
                    PrintReport(ReportSelection.Usage::"S.Cr.Memo".AsInteger());
                end;
        end;
    end;

    local procedure PrintReport(ReportUsage: Integer)
    var
        ReportSelection: Record "Report Selections";
    begin
        ReportSelection.SetRange(Usage, ReportUsage);
        ReportSelection.FindSet;
        repeat
            ReportSelection.TestField("Report ID");
            case ReportUsage of
                ReportSelection.Usage::"S.Invoice".AsInteger():
                    Report.Run(ReportSelection."Report ID", false, false, SalesInvHeader);
                ReportSelection.Usage::"S.Cr.Memo".AsInteger():
                    Report.Run(ReportSelection."Report ID", false, false, SalesCrMemoHeader);
            end;
        until ReportSelection.Next = 0;
    end;
}

