Page 25006022 "Vehicle Change Log"
{
    Caption = 'Vehicle Change Log';
    DataCaptionFields = "Vehicle Serial No.";
    Editable = false;
    PageType = List;
    SourceTable = "Vehicle Change Log";

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ChangeNo; Rec."Change No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(UserID; Rec."User ID")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(DateofChange; Rec."Date of Change")
                {
                    ApplicationArea = Basic;
                }
                field(TimeofChange; Rec."Time of Change")
                {
                    ApplicationArea = Basic;
                }
                field(FieldNo; Rec."Field No.")
                {
                    ApplicationArea = Basic;
                }
                field(FieldDescription; Rec."Field Description")
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
                field(TypeofChange; Rec."Type of Change")
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

