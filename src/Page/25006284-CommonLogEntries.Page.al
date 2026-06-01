Page 25006284 "Common Log Entries"
{
    PageType = List;
    SourceTable = "Common Log Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(DateandTime; Rec."Date and Time")
                {
                    ApplicationArea = Basic;
                }
                field(ProcessingInfo; Rec."Processing Info")
                {
                    ApplicationArea = Basic;
                }
                field(UserID; Rec."User ID")
                {
                    ApplicationArea = Basic;
                }
                field(FieldNo; Rec."Field No.")
                {
                    ApplicationArea = Basic;
                }
                field(FieldName; Rec."Field Name")
                {
                    ApplicationArea = Basic;
                }
                field(OldValue; Rec."Old Value")
                {
                    ApplicationArea = Basic;
                }
                field(NewValue; Rec."New Value")
                {
                    ApplicationArea = Basic;
                }
                field(PrimaryKey; Rec."Primary Key")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ObjectType; Rec."Object Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ObjectNo; Rec."Object No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1101901013; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}

