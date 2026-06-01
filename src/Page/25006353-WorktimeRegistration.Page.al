Page 25006353 "Worktime Registration"
{
    Caption = 'Worktime Registration';
    PageType = Card;
    SourceTable = Resource;

    layout
    {
        area(content)
        {
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
            field(DateTime; DatetimeMgt.Datetime2Text(CurrDateTime))
            {
                ApplicationArea = Basic;
                Caption = 'Date-Time';
            }
            field(Status; Status)
            {
                ApplicationArea = Basic;
                Caption = 'Operation';
                Editable = false;
            }
            field(SchedulePassword; SchedulePassword)
            {
                ApplicationArea = Basic;
                Caption = 'Password';
                ExtendedDatatype = Masked;
            }
        }
    }

    actions
    {
    }

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction in [Action::OK, Action::LookupOK] then begin
            ServSchedMgt.CompareSchedulePassword(Rec."No.", SchedulePassword);
            case Status of
                Status::Start:
                    ServSchedMgt.ProcessStartWorkday(Rec."No.", CurrDateTime);
                Status::Finish:
                    ServSchedMgt.ProcessEndWorkday(Rec."No.", CurrDateTime);
            end;
        end;
    end;

    var
        ServSchedMgt: Codeunit "Service Schedule Mgt.";
        DatetimeMgt: Codeunit "Datetime Mgt.";
        ResourceNo: Code[20];
        SchedulePassword: Text[20];
        Status: Option Start,Finish;
        FinishStatus: Option Finished,"On Hold";
        CurrDateTime: Decimal;


    procedure SetParam(ResourceNo1: Code[20]; CurrDateTime1: Decimal; Status1: Option Start,"End")
    begin
        Rec.SetRange("No.", ResourceNo1);
        CurrDateTime := CurrDateTime1;
        Status := Status1;
    end;
}

