Page 25006070 "Segment Sublines"
{
    AutoSplitKey = true;
    DelayedInsert = true;
    MultipleNewLines = true;
    PageType = List;
    SourceTable = "Segment SubLine";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(SegmentNo; Rec."Segment No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ContactNo; Rec."Contact No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SubLineNo; Rec."SubLine No.")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                }
                field(ModelCode; Rec."Model Code")
                {
                    ApplicationArea = Basic;
                }
                field(ModelVersionNo; Rec."Model Version No.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control9; Notes)
            {
                ApplicationArea = All;
            }
            systempart(Control10; Outlook)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
    }
}

