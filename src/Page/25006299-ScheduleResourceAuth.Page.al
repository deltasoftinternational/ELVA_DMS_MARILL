Page 25006299 "Schedule Resource Auth."
{
    SourceTable = Resource;

    layout
    {
        area(content)
        {
            group(Control25006001)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Password; SchedulePassword)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    var
        SchedulePassword: Text[20];
        ServSchedMgt: Codeunit "Service Schedule Mgt.";


    procedure SetParam(ResourceNo1: Code[20])
    begin
        Rec.SetRange("No.", ResourceNo1);
    end;


    procedure GetSchedulePassword(): Text[20]
    begin
        exit(SchedulePassword);
    end;
}

