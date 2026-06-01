Page 25006877 "Branch Profile Setup"
{
    ApplicationArea = Basic;
    CardPageID = "Branch Profile Setup Card";
    Editable = false;
    PageType = List;
    SourceTable = "Branch Profile Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(BranchCode; Rec."Branch Code")
                {
                    ApplicationArea = Basic;
                }
                field(ProfileID; Rec."Profile ID")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Profile ID';
                    DrillDown = false;
                    Editable = false;
                    LookupPageID = "Profile List";
                    ToolTip = 'Specifies the ID of the profile that is associated with the current user.';

                    trigger OnAssistEdit()
                    var
                        UserProfileManagement: Codeunit "UserProfileManagement";
                        TempAllProfile: Record "All Profile" temporary;
                    begin
                        UserProfileManagement.PopulateProfiles(TempAllProfile);
                        if Page.RunModal(Page::Roles, TempAllProfile) = Action::LookupOK then
                            Rec."Profile ID" := TempAllProfile."Profile ID";
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

