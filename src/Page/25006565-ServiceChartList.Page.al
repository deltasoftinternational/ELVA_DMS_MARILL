Page 25006565 "Service Chart List"
{
    ApplicationArea = Basic;
    Caption = 'Service Chart List';
    PageType = List;
    SourceTable = "Service Chart Definition";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ProfileID; Rec."Profile ID")
                {
                    ApplicationArea = Basic;
                }
                field(CodeunitID; Rec."Codeunit ID")
                {
                    ApplicationArea = Basic;
                }
                field(ChartName; Rec."Chart Name")
                {
                    ApplicationArea = Basic;
                }
                field(Enabled; Rec.Enabled)
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

