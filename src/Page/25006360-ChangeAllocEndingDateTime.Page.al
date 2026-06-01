Page 25006360 "Change Alloc.Ending Date/Time"
{
    Caption = 'Change Alloc.Ending Date/Time';
    PageType = Card;
    SourceTable = Resource;

    layout
    {
        area(content)
        {
            field(SourceID; ServLaborAllocation."Source ID")
            {
                ApplicationArea = Basic;
                Caption = 'Source ID';
                Editable = false;
            }
            field(ResourceNo; Rec."No.")
            {
                ApplicationArea = Basic;
                Caption = 'Resource No.';
                Editable = false;
            }
            field(Name; Rec.Name)
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field(StartDateTime; DateTimeMgt.Datetime2Text(ServLaborAllocation."Start Date-Time"))
            {
                ApplicationArea = Basic;
                Caption = 'Start Date-Time';
            }
            field(EndDateTime; DateTimeMgt.Datetime2Text(ServLaborAllocation."End Date-Time"))
            {
                ApplicationArea = Basic;
                Caption = 'End Date-Time';
            }
            field(EndDate; EndDate)
            {
                ApplicationArea = Basic;
                Caption = 'New End Date';
            }
            field(EndTime; EndTime)
            {
                ApplicationArea = Basic;
                Caption = 'New End Time';
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        EndDate := DateTimeMgt.Datetime2Date(ServLaborAllocation."End Date-Time");
        EndTime := DateTimeMgt.Datetime2Time(ServLaborAllocation."End Date-Time");
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    var
        AllocApplication: Record "Serv. Labor Alloc. Application";
    begin
        if CloseAction in [Action::OK, Action::LookupOK] then begin
            ServLaborAllocation2.Get(ServLaborAllocation."Entry No.");
            ServLaborAllocation2."End Date-Time" := DateTimeMgt.Datetime(EndDate, EndTime);
            ServLaborAllocation2."Quantity (Hours)" := ServiceScheduleMgt.CalcHourDifference(ServLaborAllocation2."Start Date-Time",
                                                      ServLaborAllocation2."End Date-Time");
            ServLaborAllocation2.Modify;

            AllocApplication.Reset;
            AllocApplication.SetRange("Allocation Entry No.", ServLaborAllocation2."Entry No.");
            AllocApplication.SetRange("Time Line", true);
            if AllocApplication.FindFirst then begin
                AllocApplication."Finished Quantity (Hours)" := ServLaborAllocation2."Quantity (Hours)";
                AllocApplication.Modify;
            end;
        end;
    end;

    var
        ServLaborAllocation: Record "Serv. Labor Allocation Entry";
        ServLaborAllocation2: Record "Serv. Labor Allocation Entry";
        DateTimeMgt: Codeunit "Datetime Mgt.";
        ServiceScheduleMgt: Codeunit "Service Schedule Mgt.";
        EndDate: Date;
        EndTime: Time;


    procedure GetServLaborAllocation(ServLaborAllocation1: Record "Serv. Labor Allocation Entry")
    begin
        ServLaborAllocation := ServLaborAllocation1;
    end;
}

