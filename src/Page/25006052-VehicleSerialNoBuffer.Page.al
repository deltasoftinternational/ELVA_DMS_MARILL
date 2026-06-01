Page 25006052 "Vehicle Serial No. Buffer"
{
    Caption = 'Vehicle Serial No. Buffer';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Vehicle Serial No. Buffer";

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field(SerialNo; Rec."Serial No.")
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
                field(CustomerNo; Rec."Customer No.")
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

