Page 25006453 "Option Classes"
{
    ApplicationArea = Basic;
    Caption = 'Option Classes';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Option Class";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(Description2; Rec."Description 2")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }
}

