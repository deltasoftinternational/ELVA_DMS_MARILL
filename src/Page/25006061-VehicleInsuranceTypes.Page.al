Page 25006061 "Vehicle Insurance Types"
{
    ApplicationArea = Basic;
    Caption = 'Vehicle Insurance Types';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Vehicle Insurance Type";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
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

