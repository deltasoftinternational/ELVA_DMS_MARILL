Page 25006558 "Aftersales CRM Activities"
{
    PageType = CardPart;
    SourceTable = "Aftersales CRM Cue";

    layout
    {
        area(content)
        {
            cuegroup(ToDoes)
            {
                Caption = 'To-Does';
                field(CampaignActive; Rec."Campaign Active")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Campaign List";
                }
                field(MyTodoThisWeek; Rec."My To-do This Week")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Task List";
                }
                field(MyTodoNextWeek; Rec."My To-do Next Week")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Task List";
                }
                field(MyTodo; Rec."My To-do")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Task List";
                    Visible = true;
                }
            }
            cuegroup(MyCatalogs)
            {
                Caption = 'My Catalogs';
                field(MySegments; Rec."My Segments")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Segment List";
                }
                field(MyContacts; Rec."My Contacts")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Contact List";
                }
                field(MyCustomers; Rec."My Customers")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Customer List";
                }
                field(MyContracts; Rec."My Contracts")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Contract List EDMS";
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;

        Rec.SetFilter("Date Filter 1", Format(CalcDate('<-WD1>', WorkDate)) + '..' + Format(CalcDate('<WD7>', WorkDate)));
        Rec.SetFilter("Date Filter 2", Format(CalcDate('<-WD1>', WorkDate + 7)) + '..' + Format(CalcDate('<+WD7>', WorkDate + 7)));
        if UserSetup.Get(UserId) then
            Rec.SetFilter("Salesperson Code", UserSetup."Salespers./Purch. Code");
    end;

    var
        UserSetup: Record "User Setup";
}

