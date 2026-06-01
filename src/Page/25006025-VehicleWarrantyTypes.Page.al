Page 25006025 "Vehicle Warranty Types"
{
    // 12.06.2007. EDMS P2
    //   * Created form

    ApplicationArea = Basic;
    Caption = 'Vehicle Warranty Types';
    PageType = List;
    SourceTable = "Vehicle Warranty Type";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Control1101908000)
            {
                field("Code"; rec.Code)
                {
                    ApplicationArea = Basic;
                }
                field(Name; rec.Name)
                {
                    ApplicationArea = Basic;
                }
                field(Description2; rec."Description 2")
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

