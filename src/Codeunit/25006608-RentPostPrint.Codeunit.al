Codeunit 25006608 "Rent-Post+Print"
{
    TableNo = "Service Header EDMS";

    trigger OnRun()
    begin
        ServiceHeader.Copy(Rec);
        Code;
        Rec := ServiceHeader;
    end;

    var
        Text000: label '&Ship,&Invoice,Ship &and Invoice';
        Text001: label 'Do you want to post and print the %1?';
        Text002: label '&Receive,&Invoice,Receive &and Invoice';
        ServiceHeader: Record "Service Header EDMS";
        PostedServiceOrder: Record "Posted Serv. Order Header";
        PostedServiceRetOrder: Record "Posted Serv. Ret. Order Header";
        ReportSelection: Record "Report Selections";
        ServicePost: Codeunit "Service-Post EDMS";
        Selection: Integer;

    local procedure "Code"()
    begin
        case ServiceHeader."Document Type" of
            ServiceHeader."document type"::Order:
                begin
                end;
            ServiceHeader."document type"::"Return Order":
                begin
                end else
                        if not
                          Confirm(
                            Text001, false,
                            ServiceHeader."Document Type")
                        then
                            exit;
        end;
        //ServicePost.SetPrintInvoice(TRUE);

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
                    PrintReport(ReportSelection.Usage::"Serv. Order".AsInteger());
                end;
            ServiceHeader."document type"::"Return Order":
                begin
                    PostedServiceRetOrder."No." := ServiceHeader."Posting No.";
                    PostedServiceRetOrder.SetRecfilter;
                    PrintReport(ReportSelection.Usage::"Serv. Return Order".AsInteger());
                end;
        end;
    end;

    local procedure PrintReport(ReportUsage: Integer)
    begin
        ReportSelection.Reset;
        ReportSelection.SetRange(Usage, ReportUsage);
        if ReportSelection.FindFirst then
            repeat
                ReportSelection.TestField("Report ID");
                case ReportUsage of
                    ReportSelection.Usage::"Serv. Order".AsInteger():
                        Report.Run(ReportSelection."Report ID", false, false, PostedServiceOrder);
                    ReportSelection.Usage::"Serv. Return Order".AsInteger():
                        Report.Run(ReportSelection."Report ID", false, false, PostedServiceRetOrder);
                end;
            until ReportSelection.Next = 0;
    end;
}

