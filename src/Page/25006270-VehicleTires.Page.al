Page 25006270 "Vehicle Tires"
{
    Caption = 'Vehicle Tires';
    PageType = List;
    SourceTable = "Tire Entry";
    SourceTableView = where(Open = const(true));

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(TireCode; Rec."Tire Code")
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

