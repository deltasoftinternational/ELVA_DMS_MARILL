Page 25006053 "Vehicle Insurance"
{
    AutoSplitKey = true;
    Caption = 'Vehicle Insurances';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Vehicle Insurance";

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
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field(InsurancePolicyNo; Rec."Insurance Policy No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(InsurerNo; Rec."Insurer No.")
                {
                    ApplicationArea = Basic;
                }
                field(StartingDate; Rec."Starting Date")
                {
                    ApplicationArea = Basic;
                }
                field(EndingDate; Rec."Ending Date")
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

