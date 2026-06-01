Page 25006004 "Vehicle Tracking Codes"
{
    ApplicationArea = Basic;
    Caption = 'Vehicle Tracking Codes';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Vehicle Tracking Code";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field("Code"; rec.Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description; rec.Description)
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

