Page 25006774 "Integration Connector Mapping"
{
    // #Owner EDMS.Integration

    Caption = 'Integration Connector Setup';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Integration Connector Mapping";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ConnectorCode; Rec."Connector Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                }
                field(ExternalCode; Rec."External Code")
                {
                    ApplicationArea = Basic;
                }
                field(Default; Rec.Default)
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

