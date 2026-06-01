Page 25006007 "Variable Field Options"
{
    Caption = 'Variable Field Options';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Variable Field Options";

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field(MakeCode; rec."Make Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VariableFieldCode; rec."Variable Field Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
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

