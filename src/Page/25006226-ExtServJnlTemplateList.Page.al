Page 25006226 "Ext. Serv. Jnl. Template List"
{
    Caption = 'External Service Journal Template List';
    PageType = List;
    SourceTable = "Ext. Service Journal Template";

    layout
    {
        area(content)
        {
            repeater(Control1190000)
            {
                field(Name; Rec.Name)
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(TestReportID; Rec."Test Report ID")
                {
                    ApplicationArea = Basic;
                }
                //field(FormID;"Form ID")
                //{
                //    ApplicationArea = Basic;
                //}
            }
        }
    }

    actions
    {
    }
}

