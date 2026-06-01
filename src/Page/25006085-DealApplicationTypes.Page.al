Page 25006085 "Deal Application Types"
{
    ApplicationArea = Basic;
    Caption = 'Deal Application Types';
    PageType = List;
    SourceTable = "Deal Application Type";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1190000)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(SystemType; Rec."System Type")
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

