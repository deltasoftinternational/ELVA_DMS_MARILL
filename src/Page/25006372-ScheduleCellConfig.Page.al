Page 25006372 "Schedule Cell Config."
{
    ApplicationArea = Basic;
    Caption = 'Schedule Cell Config.';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Serv. Schedule Cell Config.";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1101908000)
            {
                field(SourceType; Rec."Source Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the table number from which information will be retrieved.';
                }
                field(SourceRefNo; Rec."Source Ref. No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the field number in the specified table from which information will be retrieved.';
                }
                field(Sequence; Rec.Sequence)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the order in which information is displayed for users.';
                }
                field(Prefix; Rec.Prefix)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies additional text that can be displayed before the value of the field to help users read information.';
                }
            }
        }
    }

    actions
    {
    }
}

