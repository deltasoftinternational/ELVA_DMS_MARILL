pageextension 25006032 "User Setup" extends "User Setup"//119
{
    layout
    {
        addafter(PhoneNo)
        {
            field(AllowUseServiceSchedule; Rec."Allow Use Service Schedule")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the user''s access rights to the service schedule. Blank means no access, View Only - means user can see allocations, Time Registration - designed for mechanics to see and change allocation by time clocking, Planning - can allocate and change, All - full access including changing of finished allocations.';
            }
            field(VehAccCycleChangeFunct; Rec."Veh. Acc. Cycle Change Funct.")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies if user is allowed to use function that changes vehicle accounting cycle on posted entries.';
            }
            field(ResourceNo; Rec."Resource No.")
            {
                ApplicationArea = Basic;
                //    Visible = false;
                ToolTip = 'Specifies the resource code that is related to this user and is used in service time clocking.';
            }
            field(BranchCode; Rec."Branch Code")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the branch code assigned to the user. Together with user profile it provides ability to define Branch Profile Setup.';
            }
            field(SignedDocumentPath; Rec."Signed Document Path")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies path to folder where system should save documents after signing. It usually should be a shared folder so that other users can access afterwards these documents.';
            }
            field(AskWorkFinished; Rec."Ask Work Finished")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies if for this user on finishing a task system should ask if all work is done or user would like to schedule next allocation for the same task.';
            }
        }

    }
    actions
    {
        addfirst(Navigation)
        {
            action(Setting)
            {
                ApplicationArea = Basic;
                Caption = 'Setting';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = page "User Setup Card";
                RunPageLink = "User ID" = field("User ID");
                /* trigger OnAction()
                 var
                     UserSetupCard: Page "User Setup Card";
                     UserSetup: Record "User Setup";
                 begin
                     UserSetup.Reset();
                     UserSetup.SetRange("User ID", Rec."User ID");
                     UserSetup.FindFirst();
                     UserSetupCard.SetTableView(UserSetup);
                     UserSetupCard.GetRecord(UserSetup);
                     UserSetupCard.Run();
                 end;*/
            }
        }
    }
}