Page 25006418 "BLS Contract Categories"
{
    ApplicationArea = Basic;
    Caption = 'Contract Categories';
    PageType = List;
    SourceTable = "BLS Contract Category";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(UseForBilling; Rec."Use For Billing")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1000000006; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Control1000000005; Notes)
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    {
    }
}

