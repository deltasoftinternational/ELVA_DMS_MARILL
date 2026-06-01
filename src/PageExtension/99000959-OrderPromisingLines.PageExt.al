pageextension 25006472 "Order Promising Lines" extends "Order Promising Lines"//99000959
{
    var
        AvailabilityMgt: Codeunit AvailabilityManagement;
        DocumentManagementDMS: Codeunit "DocumentManagementDMS";
        CrntSourceType: Enum "Order Promising Line Source Type";
        CrntSourceID: Code[20];
        Accepted: Boolean;
        OrderPromisingCalculationDone: Boolean;
        AcceptButtonEnable: Boolean;


    trigger OnClosePage()
    var
        CapableToPromise: Codeunit "Capable to Promise";
        DocumentManagementDMS: Codeunit "DocumentManagementDMS";
    begin
        if not Accepted then begin
            //CapableToPromise.RemoveReqLines(CrntSourceID,0,0,TRUE); //EDMS
            DocumentManagementDMS.RemoveReqLines(CrntSourceType.AsInteger(), CrntSourceID, 0, 0, true); //EDMS
            AvailabilityMgt.CancelReservations();
        end;
    end;

    trigger OnOpenPage()
    var
        SalesHeader: Record "Sales Header";
        ServHeader: Record "Service Header";
        Job: Record Job;
        ServiceHeaderEDMS: Record "Service Header EDMS";
        ServAvailabilityMgt: Codeunit "Serv. Availability Mgt.";
        JobPlanningAvailabilityMgt: Codeunit "Job Planning Availability Mgt.";
        SalesAvailabilityMgt: Codeunit "Sales Availability Mgt.";
        CaptionText: Text;
    begin
        OrderPromisingCalculationDone := false;
        Accepted := false;
        if Rec.GetFilter("Source ID") <> '' then
            case Rec.GetRangeMin("Source Type") of //24.04.2013 EDMS P8
                Rec."Source Type"::"Service Order":
                    begin
                        ServHeader."Document Type" := ServHeader."Document Type"::Order;
                        ServHeader."No." := Rec.GetRangeMin("Source ID");
                        ServHeader.Find;
                        ServAvailabilityMgt.SetServiceHeader(Rec, ServHeader, CaptionText);
                    end;
                //EDMS >>
                Rec."source type"::"Service Order EDMS":
                    begin
                        ServiceHeaderEDMS."Document Type" := ServiceHeaderEDMS."document type"::Order;
                        ServiceHeaderEDMS."No." := rec.GetRangeMin("Source ID");
                        ServiceHeaderEDMS.Find;
                        SetServiceHeaderEDMS(ServiceHeaderEDMS);
                        AcceptButtonEnable := ServiceHeaderEDMS.Status = ServiceHeaderEDMS.Status::Open;
                    end;
                //EDMS<<
                Rec."Source Type"::Job:
                    begin
                        Job.Status := Job.Status::Open;
                        Job."No." := Rec.GetRangeMin("Source ID");
                        Job.Find;
                        JobPlanningAvailabilityMgt.SetJob(Rec, Job, CaptionText);
                    end;
                else
                    SalesHeader."Document Type" := SalesHeader."Document Type"::Order;
                    SalesHeader."No." := Rec.GetRangeMin("Source ID");
                    SalesHeader.Find;
                    SalesAvailabilityMgt.SetSalesHeader(Rec, SalesHeader, CaptionText);
                    AcceptButtonEnable := SalesHeader.Status = SalesHeader.Status::Open;
            end;
    end;

    procedure SetServiceHeaderEDMS(var CrntServiceHeader: Record "Service Header EDMS")
    begin
        DocumentManagementDMS.SetServHeaderEDMS(Rec, CrntServiceHeader);

        CrntSourceType := Crntsourcetype::"Service Order EDMS";
        CrntSourceID := CrntServiceHeader."No.";
    end;
}