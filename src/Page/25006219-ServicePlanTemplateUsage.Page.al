Page 25006219 "Service Plan Template Usage"
{
    Caption = 'Service Plan Template Usage';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Service Plan Template Usage";

    layout
    {
        area(content)
        {
            repeater(Control1190000)
            {
                field(TemplateCode; Rec."Template Code")
                {
                    ApplicationArea = Basic;
                }
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                }
                field(ModelCode; Rec."Model Code")
                {
                    ApplicationArea = Basic;
                }
                field(ModelVersionNo; Rec."Model Version No.")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleStatus; Rec."Vehicle Status")
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

