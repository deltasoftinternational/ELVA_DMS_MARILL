Page 25006222 "Service Plan Document Link"
{
    AutoSplitKey = true;
    Caption = 'Service Plan Document Link';
    DataCaptionFields = "Vehicle Serial No.";
    PageType = List;
    PopulateAllFields = true;
    SourceTable = "Service Plan Document Link";

    layout
    {
        area(content)
        {
            repeater(Control1190000)
            {
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ServPlanNo; Rec."Serv. Plan No.")
                {
                    ApplicationArea = Basic;
                }
                field(PlanStageRecurrence; Rec."Plan Stage Recurrence")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ServPlanStageCode; Rec."Serv. Plan Stage Code")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentType; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentNo; Rec."Document No.")
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

