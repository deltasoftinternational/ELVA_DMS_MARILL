Page 25006361 "MapView Vehicle Telematics"
{
    Caption = 'Vehicle Telematics';
    PageType = List;
    SourceTable = "Vehicle Telematics";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(ModelCode; Rec."Model Code")
                {
                    ApplicationArea = Basic;
                }
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field(DateStamp; Rec."Date Stamp")
                {
                    ApplicationArea = Basic;
                }
                field(Latitude; Rec.Latitude)
                {
                    ApplicationArea = Basic;
                }
                field(Longitude; Rec.Longitude)
                {
                    ApplicationArea = Basic;
                }
                field(FuelUsed; Rec."Fuel Used")
                {
                    ApplicationArea = Basic;
                }
                field(FuelUsedUnitCode; Rec."Fuel Used Unit Code")
                {
                    ApplicationArea = Basic;
                }
                field(VariableFieldRun1; Rec."Variable Field Run 1")
                {
                    ApplicationArea = Basic;
                    Visible = VFRun1Visible;
                }
                field(VariableFieldRun2; Rec."Variable Field Run 2")
                {
                    ApplicationArea = Basic;
                    Visible = VFRun2Visible;
                }
                field(VariableFieldRun3; Rec."Variable Field Run 3")
                {
                    ApplicationArea = Basic;
                    Visible = VFRun3Visible;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        SetVariableFields;
    end;

    var
        VFRun1Visible: Boolean;
        VFRun2Visible: Boolean;
        VFRun3Visible: Boolean;

    procedure SetVariableFields()
    begin
        VFRun1Visible := rec.IsVFActive(rec.FieldNo("Variable Field Run 1"));
        VFRun2Visible := rec.IsVFActive(rec.FieldNo("Variable Field Run 2"));
        VFRun3Visible := rec.IsVFActive(rec.FieldNo("Variable Field Run 3"));
    end;
}

