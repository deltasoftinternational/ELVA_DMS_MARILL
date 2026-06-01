Page 25006006 "Variable Field Usage"
{
    ApplicationArea = Basic;
    Caption = 'Variable Field Usage';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Variable Field Usage";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field(TableNo; rec."Table No.")
                {
                    ApplicationArea = Basic;
                }
                field("Table Name"; Rec."Table Name")
                {
                    ApplicationArea = Basic;
                }
                field(FieldNo; rec."Field No.")
                {
                    ApplicationArea = Basic;
                }
                field(VariableFieldGroupCode; rec."Variable Field Group Code")
                {
                    ApplicationArea = Basic;
                }
                field(VariableFieldCode; rec."Variable Field Code")
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

