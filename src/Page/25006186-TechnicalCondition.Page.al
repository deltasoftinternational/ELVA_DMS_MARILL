Page 25006186 "Technical Condition"
{
    AutoSplitKey = true;
    Caption = 'Technical Condition';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Technical Condition";

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
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

