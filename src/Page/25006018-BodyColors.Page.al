Page 25006018 "Body Colors"
{
    ApplicationArea = Basic;
    Caption = 'Body Colors';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Body Color";
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
                field(MakeCode; rec."Make Code")
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

