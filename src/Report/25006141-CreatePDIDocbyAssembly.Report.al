Report 25006141 "Create PDI Doc. by Assembly"
{
    // I think algorithm should be
    //   gather data into temp tables by going through dataitem
    //   then loop it
    // Need to have option 'fill own options of one assembly header into one service document'

    Caption = 'Create PDI Doc. by Assembly';
    ProcessingOnly = true;

    dataset
    {
        dataitem(VehicleAssemblyLineFiltered; "Vehicle Assembly Line")
        {
            DataItemTableView = sorting("Serial No.", "Assembly ID", "Line No.") order(ascending);
            RequestFilterFields = "Serial No.", "Assembly ID", "Line No.";
            column(ReportForNavId_1425; 1425)
            {
            }

            trigger OnPreDataItem()
            begin
                EnforceAssemblyFilter(VehicleAssemblyLineFiltered, "Vehicle Assembly Line");
                EnforceAssemblyFilter(VehicleAssemblyLineFiltered, VehicleAssemblyLine2);
            end;
        }
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = where("Document Profile" = const("Vehicles Trade"));
            RequestFilterFields = "Document Type", "No.";
            column(ReportForNavId_6640; 6640)
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.") order(ascending) where("Vehicle Serial No." = const('<>'''''));
                column(ReportForNavId_2844; 2844)
                {
                }
                dataitem("Vehicle Assembly Line"; "Vehicle Assembly Line")
                {
                    DataItemLink = "Serial No." = field("Vehicle Serial No.");
                    DataItemTableView = sorting("Serial No.", "Assembly ID", "Line No.") where("Option Type" = const("Own Option"), "PDI Created" = const(false));
                    column(ReportForNavId_5648; 5648)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if ("Vehicle Assembly Line"."Assembly ID" <> AssemblyID_previous) then begin
                            InitNewAssemblyheader("Vehicle Assembly Line"."Assembly ID");
                        end;
                        MakeServDoc("Sales Line", "Vehicle Assembly Line", ServiceHeader);
                    end;

                    trigger OnPreDataItem()
                    begin
                        InitNewAssemblyheader('');
                    end;
                }
            }

            trigger OnPreDataItem()
            begin
                if OrderDate = 0D then
                    OrderDate := WorkDate;
                if PlanedDate = 0D then
                    PlanedDate := WorkDate;
                if CustomerNoBillTo = '' then
                    Error(Text001);
            end;
        }
        dataitem(VehicleAssemblyLine2; "Vehicle Assembly Line")
        {
            DataItemTableView = sorting("Serial No.", "Assembly ID", "Line No.") order(ascending);
            column(ReportForNavId_1372; 1372)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if ("Vehicle Assembly Line"."Assembly ID" <> AssemblyID_previous) then begin
                    InitNewAssemblyheader("Vehicle Assembly Line"."Assembly ID");
                end;
                MakeServDoc("Sales Line", VehicleAssemblyLine2, ServiceHeader);
            end;

            trigger OnPreDataItem()
            begin
                if CreatedInfo = '' then begin
                    InitNewAssemblyheader('');
                end else
                    CurrReport.Break;
                EnforceAssemblyFilter(VehicleAssemblyLineFiltered, VehicleAssemblyLine2);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(CustomerNoBillTo; CustomerNoBillTo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Bill-to Customer No.';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        Customer.Reset;
                        Customer.SetRange(Internal, true);
                        if not Customer.FindFirst then begin
                            Error(Text1004, Customer.TableCaption, Customer.FieldCaption(Internal));
                        end else begin
                            if (Page.RunModal(Page::"Customer List", Customer) = Action::LookupOK) then
                                CustomerNoBillTo := Customer."No.";
                        end;
                    end;
                }
                field(OrderDate; OrderDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Date';
                }
                field(PlanedDate; PlanedDate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Planned Date';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPostReport()
    begin
        if CreatedInfo = '' then
            Message(Text1005)
        else begin
            CreatedInfo := CopyStr(CreatedInfo, 1, StrLen(CreatedInfo) - 2);
            Message(Text1002, Text002 + ' ' + Format(ServiceHeader."Document Type"), CreatedInfo);
        end;
    end;

    var
        ServiceHeader: Record "Service Header EDMS";
        VehicleOptionManagement: Codeunit VehicleOptionManagement;
        OrderDate: Date;
        PlanedDate: Date;
        CustomerNoBillTo: Code[20];
        AssemblyID_previous: Code[20];
        Text001: label 'Please, choose internal customer to bill';
        Customer: Record Customer;
        Text002: label 'Service';
        Text1002: label '%1 %2 is created.';
        Text1004: label 'Is not able to find %1 with %2.';
        CreatedInfo: Text[100];
        Text1005: label 'Nothing is created, check parameters';


    procedure MakeServDoc(SalesLinePar: Record "Sales Line"; VehicleAssemblyLinePar: Record "Vehicle Assembly Line"; var ServiceHeaderPar: Record "Service Header EDMS")
    begin
        //if ServiceHeader has defined ServiceHeaderPar."Vehicle Serial No." that means do not create new document,
        // but Pdi lines to existing
        if ServiceHeaderPar."Vehicle Serial No." = '' then begin
            if ServiceHeaderPar."Sell-to Customer No." = '' then
                ServiceHeaderPar."Sell-to Customer No." := CustomerNoBillTo;
            VehicleOptionManagement.CreateServDocFromVehTrade(ServiceHeaderPar, SalesLinePar,
              OrderDate, PlanedDate,
              ServiceHeaderPar."Sell-to Customer No.", CustomerNoBillTo);
            ServiceHeaderPar.Validate("Vehicle Serial No.", VehicleAssemblyLinePar."Serial No.");
            OnMakeServDocOnBeforServiceHeaderParModif(ServiceHeaderPar, VehicleAssemblyLinePar);
            ServiceHeaderPar.Modify;
            CreatedInfo += ServiceHeaderPar."No." + ', ';
        end;
        Commit;
        VehicleOptionManagement.AddPDItoServDoc(VehicleAssemblyLinePar, ServiceHeaderPar);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnMakeServDocOnBeforServiceHeaderParModif(var ServiceHeaderPar: Record "Service Header EDMS"; var VehicleAssemblyLinePar: Record "Vehicle Assembly Line")
    begin
    end;

    procedure InitNewAssemblyheader(AssemblyID_new: Code[20])
    begin
        AssemblyID_previous := AssemblyID_new;
        ServiceHeader.Init;
        ServiceHeader."Vehicle Serial No." := '';
        exit;
    end;


    procedure EnforceAssemblyFilter(var VehicleAssemblyLineSrc: Record "Vehicle Assembly Line"; var VehicleAssemblyLineDst: Record "Vehicle Assembly Line")
    var
        SerialNoFilter: Text[1024];
        AssemblyIDFilter: Text[1024];
        LineNoFilter: Text[1024];
    begin
        VehicleAssemblyLineDst.CopyFilters(VehicleAssemblyLineSrc);
        /*WITH VehicleAssemblyLineSrc DO BEGIN
          IF FINDFIRST THEN BEGIN
            REPEAT
              SerialNoFilter += VehicleAssemblyLineSrc."Serial No." + '|';
              AssemblyIDFilter += VehicleAssemblyLineSrc."Assembly ID" + '|';
              LineNoFilter += FORMAT(VehicleAssemblyLineSrc."Line No.") + '|';
            UNTIL NEXT = 0;
            SerialNoFilter := COPYSTR(SerialNoFilter,1,STRLEN(SerialNoFilter)-1);
            AssemblyIDFilter := COPYSTR(AssemblyIDFilter,1,STRLEN(AssemblyIDFilter)-1);
            LineNoFilter := COPYSTR(LineNoFilter,1,STRLEN(LineNoFilter)-1);
            VehicleAssemblyLineDst.SETFILTER("Serial No.", SerialNoFilter);
            VehicleAssemblyLineDst.SETFILTER("Assembly ID", AssemblyIDFilter);
            VehicleAssemblyLineDst.SETFILTER("Line No.", LineNoFilter);
          END;
        END;*/

    end;
}

