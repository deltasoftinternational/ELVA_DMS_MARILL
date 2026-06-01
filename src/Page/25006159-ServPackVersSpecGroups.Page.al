Page 25006159 "Serv. Pack. Vers. Spec.-Groups"
{
    Caption = 'Serv. Pack. Vers. Spec.-Groups';
    PageType = List;
    SourceTable = "Service Package Version Line";

    layout
    {
        area(content)
        {
            repeater(Control1101908000)
            {
                field(PackageNo; Rec."Package No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VersionNo; Rec."Version No.")
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
                    Visible = false;
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

