Page 25006366 "Serv. Workplace Resources List"
{
    Caption = 'Serv. Workplace Resources List';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Serv. Workplace Resource";

    layout
    {
        area(content)
        {
            repeater(Control1101908000)
            {
                field(WorkplaceCode; Rec."Workplace Code")
                {
                    ApplicationArea = Basic;
                }
                field(ResourceNo; Rec."Resource No.")
                {
                    ApplicationArea = Basic;
                }
                field(StartingDate; Rec."Starting Date")
                {
                    ApplicationArea = Basic;
                }
                field(EndingDate; Rec."Ending Date")
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

