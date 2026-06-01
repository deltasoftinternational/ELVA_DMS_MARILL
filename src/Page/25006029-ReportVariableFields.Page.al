Page 25006029 "Report Variable Fields"
{
    Caption = 'Report Variable Fields';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Report Variable Fields";

    layout
    {
        area(content)
        {
            repeater(Control1190000)
            {
                field(ReportID; rec."Report ID")
                {
                    ApplicationArea = Basic;
                }
                field(FieldPositionID; rec."Field Position ID")
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

