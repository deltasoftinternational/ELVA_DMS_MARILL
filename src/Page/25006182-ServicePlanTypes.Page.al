Page 25006182 "Service Plan Types"
{
    ApplicationArea = Basic;
    Caption = 'Service Plan Types';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Service Plan Type";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Control1190000)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
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

