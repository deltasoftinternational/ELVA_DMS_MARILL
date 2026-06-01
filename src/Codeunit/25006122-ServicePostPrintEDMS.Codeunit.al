Codeunit 25006122 "Service-Post+Print EDMS"
{
    TableNo = "Service Header EDMS";

    trigger OnRun()
    begin
        ServiceHeader.Copy(Rec);
        Code;
        Rec := ServiceHeader;
    end;

    var
        Text001: label 'Do you want to post and print the %1?';
        ServiceHeader: Record "Service Header EDMS";
        PostedServiceOrder: Record "Posted Serv. Order Header";
        PostedServiceRetOrder: Record "Posted Serv. Ret. Order Header";
        ReportSelection: Record "Report Selections";
        ServicePost: Codeunit "Service-Post EDMS";
        Selection: Integer;

    local procedure "Code"()
    var
        ReleaseServDoc: Codeunit "Release Service Document EDMS";
    begin
        if not
  Confirm(
    Text001, false,
    ServiceHeader."Document Type")
then
            exit;

        ReleaseServDoc.PerformManualRelease(ServiceHeader);
        ServicePost.Run(ServiceHeader);

        GetReport(ServiceHeader);
        Commit;
    end;


    procedure GetReport(var ServiceHeader: Record "Service Header EDMS")
    begin
        case ServiceHeader."Document Type" of
            ServiceHeader."document type"::Order:
                begin
                    PostedServiceOrder."No." := ServiceHeader."Posting No.";
                    PostedServiceOrder.SetRecfilter;
                    PrintReport(ReportSelection.Usage::"Pst.Serv.Inv.Edms".AsInteger());
                end;
            ServiceHeader."document type"::"Return Order":
                begin
                    PostedServiceRetOrder."No." := ServiceHeader."Posting No.";
                    PostedServiceRetOrder.SetRecfilter;
                    PrintReport(ReportSelection.Usage::"Pst.Serv.Cr.M.Edms".AsInteger());
                end;
        end;
    end;

    local procedure PrintReport(ReportUsage: Integer)
    begin
        ReportSelection.Reset;
        ReportSelection.SetRange(Usage, ReportUsage);
        if not ReportSelection.FindSet then exit;
        repeat
            ReportSelection.TestField("Report ID");
            case ReportUsage of
                ReportSelection.Usage::"Asm.Order".AsInteger():
                    Report.Run(ReportSelection."Report ID", false, false, PostedServiceOrder);
                ReportSelection.Usage::"P.Asm.Order".AsInteger():
                    Report.Run(ReportSelection."Report ID", false, false, PostedServiceRetOrder);
            end;
        until ReportSelection.Next = 0;
    end;
    //---------------------------------- Code unit 365 "Format Address"
    var
        FormatAddress: Codeunit "Format Address";

    procedure ServiceHeaderSellToEDMS(var AddrArray: array[8] of Text[50]; var ServiceHeader: Record "Service Header EDMS")
    begin
        FormatAddress.FormatAddr(
  AddrArray, ServiceHeader."Sell-to Customer Name", ServiceHeader."Sell-to Customer Name 2", ServiceHeader."Sell-to Contact", ServiceHeader."Sell-to Address", ServiceHeader."Sell-to Address 2",
  ServiceHeader."Sell-to City", ServiceHeader."Sell-to Post Code", ServiceHeader."Sell-to County", ServiceHeader."Sell-to Country/Region Code");
    end;


    procedure ServiceHeaderBillToEDMS(var AddrArray: array[8] of Text[50]; var ServiceHeader: Record "Service Header EDMS")
    begin
        FormatAddress.FormatAddr(
  AddrArray, ServiceHeader."Bill-to Name", ServiceHeader."Bill-to Name 2", ServiceHeader."Bill-to Contact", ServiceHeader."Bill-to Address", ServiceHeader."Bill-to Address 2",
  ServiceHeader."Bill-to City", ServiceHeader."Bill-to Post Code", ServiceHeader."Bill-to County", ServiceHeader."Bill-to Country/Region Code");
    end;
}

