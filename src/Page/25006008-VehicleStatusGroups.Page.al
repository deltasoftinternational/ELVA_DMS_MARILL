Page 25006008 "Vehicle Status Groups"
{
    ApplicationArea = Basic;
    Caption = 'Vehicle Status Groups';
    PageType = List;
    SourceTable = "Vehicle Status Group";
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

