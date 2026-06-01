Page 25006028 "Vehicle Warranty Usage"
{
    ApplicationArea = Basic;
    Caption = 'Vehicle Warranty Usage';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Vehicle Warranty Usage";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Control1101908000)
            {
                field(MakeCode; rec."Make Code")
                {
                    ApplicationArea = Basic;
                }
                field(ModelCode; rec."Model Code")
                {
                    ApplicationArea = Basic;
                }
                field(ModelVersionNo; rec."Model Version No.")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleStatusCode; rec."Vehicle Status Code")
                {
                    ApplicationArea = Basic;
                }
                field(WarrantyTypeCode; rec."Warranty Type Code")
                {
                    ApplicationArea = Basic;
                }
                field(TermDateFormula; rec."Term Date Formula")
                {
                    ApplicationArea = Basic;
                }
                field(VariableFieldRun1; rec."Variable Field Run 1")
                {
                    ApplicationArea = Basic;
                    Visible = VFRun1Visible;
                }
                field(VariableFieldRun2; rec."Variable Field Run 2")
                {
                    ApplicationArea = Basic;
                    Visible = VFRun2Visible;
                }
                field(VariableFieldRun3; rec."Variable Field Run 3")
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

    trigger OnAfterGetRecord()
    begin
        fSetVariableFields;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        fHideVariableFields;
    end;

    var
        [InDataSet]
        VFRun1Visible: Boolean;
        [InDataSet]
        VFRun2Visible: Boolean;
        [InDataSet]
        VFRun3Visible: Boolean;


    procedure fSetVariableFields()
    begin
        //Variable Fields
        VFRun1Visible := rec.IsVFActive(rec.FieldNo("Variable Field Run 1"));
        VFRun2Visible := rec.IsVFActive(rec.FieldNo("Variable Field Run 2"));
        VFRun3Visible := rec.IsVFActive(rec.FieldNo("Variable Field Run 3"));
    end;


    procedure fHideVariableFields()
    begin
        //Variable Fields
        VFRun1Visible := false;
        VFRun2Visible := false;
        VFRun3Visible := false;
    end;
}

