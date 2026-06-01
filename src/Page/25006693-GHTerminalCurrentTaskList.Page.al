Page 25006693 "GH Terminal CurrentTask List"
{
    PageType = List;
    SourceTable = "Serv. Labor Allocation Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Description; Description)
                {
                    ApplicationArea = Basic;
                }
                field(IsIdle; IsIdle)
                {
                    ApplicationArea = Basic;
                }
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(SourceType; Rec."Source Type")
                {
                    ApplicationArea = Basic;
                }
                field(SourceSubtype; Rec."Source Subtype")
                {
                    ApplicationArea = Basic;
                }
                field(SourceID; Rec."Source ID")
                {
                    ApplicationArea = Basic;
                }
                field(ResourceNo; Rec."Resource No.")
                {
                    ApplicationArea = Basic;
                }
                field(UserID; Rec."User ID")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field(Travel; Rec.Travel)
                {
                    ApplicationArea = Basic;
                }
                field(ReasonCode; Rec."Reason Code")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        Description := ServiceScheduleMgt.GetAllocRecDescr(Rec);

        IsIdle := 'False';
        ServiceSetup.Get;
        if ServStandardEvent.Get(ServiceSetup."Default Idle Event") then
            if Rec."Source ID" = ServStandardEvent.Code then
                IsIdle := 'True';
    end;

    trigger OnInit()
    begin

        // IF ServLaborAllocationEntry.FINDFIRST THEN
        //  REPEAT
        //    Rec.INIT;
        //    Rec := ServLaborAllocationEntry;
        //    Rec.INSERT;
        //  UNTIL ServLaborAllocationEntry.NEXT = 0;


        EasyClockingManagement.SetCurrentTaskListFilter(Rec);

        // Rec.RESET;
        // Rec.FILTERGROUP(3);
        // Rec.SETRANGE("Resource No.",ResourceTimeRegMgt.GetCurrentUserResourceNo);
        // Rec.SETFILTER(Status,'<>%1 & <>%2',Rec.Status::Finished,Rec.Status::Pending);
        // Rec.SETRANGE(Rec."Applies-to Entry No.",0);
        // Rec.FILTERGROUP(0);
    end;

    var
        Description: Text;
        IsIdle: Text;
        ResourceTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        ServStandardEvent: Record "Serv. Standard Event";
        ServiceScheduleMgt: Codeunit "Service Schedule Mgt.";
        EasyClockingManagement: Codeunit "Easy Clocking Management";

    [ServiceEnabled]
    procedure Test(TestParam: Text): Text
    begin
        exit('You passed: ' + TestParam);
    end;
}

