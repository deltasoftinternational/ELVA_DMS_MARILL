Page 25006021 "Process Checklist Lines"
{
    Caption = 'Process Checklist Lines';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Process Checklist Line";

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field(ProcessChecklistNo; rec."Process Checklist No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(LineNo; rec."Line No.")
                {
                    ApplicationArea = Basic;
                }
                field(TypeCode; rec."Type Code")
                {
                    ApplicationArea = Basic;
                }
                field(TypeDescription; rec."Type Description")
                {
                    ApplicationArea = Basic;
                }
                field(Value; rec.Value)
                {
                    ApplicationArea = Basic;
                }
                field(ValueDescription; rec."Value Description")
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

