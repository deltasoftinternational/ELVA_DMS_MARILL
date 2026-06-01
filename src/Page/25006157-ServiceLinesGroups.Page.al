Page 25006157 "Service Lines - Groups"
{
    Caption = 'Service Lines - Groups';
    Editable = false;
    PageType = List;
    SourceTable = "Service Line EDMS";

    layout
    {
        area(content)
        {
            repeater(Control1101908000)
            {
                field(DocumentType; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(Group; Rec.Group)
                {
                    ApplicationArea = Basic;
                }
                field(GroupID; Rec."Group ID")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(GroupDescription; Rec."Group Description")
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

