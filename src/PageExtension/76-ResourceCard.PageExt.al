pageextension 25006017 "Resource Card" extends "Resource Card" //76
{
    layout
    {
        addafter("Base Unit of Measure")
        {
            field(ServSchedulePassword; Rec."Serv. Schedule Password")
            {
                ApplicationArea = Basic;
                ExtendedDatatype = Masked;
            }
            field(ServiceWorkGroupCode; Rec."Service Work Group Code")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Time Sheet Approver User ID")
        {
            field(AllowSimultaneousWork; Rec."Allow Simultaneous Work")
            {
                ApplicationArea = Basic;
            }
            field(OnTaskStart; Rec."On Task Start")
            {
                ApplicationArea = Basic;
            }
        }
    }
    actions
    {
        modify("S&kills")
        {
            Visible = false;
        }
        addafter("S&kills")
        {
            action(SkillsEDMS)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'S&kills';
                Image = Skills;
                Promoted = true;
                PromotedCategory = Category5;
                RunObject = Page "Resource Skills EDMS";
                RunPageLink = "Resource No." = field("No.");
                ToolTip = 'View the assignment of skills to the resource. You can use skill codes to allocate skilled resources to service items or items that need special skills for servicing.';
            }
        }
        addafter("Resource A&vailability")
        {
            action("Schedule Resource Links")
            {
                ApplicationArea = Basic;
                Caption = 'Schedule Resource Links';
                Image = Link;
                RunObject = Page "Schedule Resource Links";
            }
        }

    }
}