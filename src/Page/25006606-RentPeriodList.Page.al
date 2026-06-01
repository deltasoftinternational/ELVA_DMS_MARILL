Page 25006606 "Rent Period List"
{
    Caption = 'Rent Period List';
    PageType = List;
    SourceTable = "Rent Period";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the rent period.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the rent period.';
                }
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the unit of measure code of the rent period.';
                }
                field(Duration; Rec.Duration)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the duration of the rent period.';
                }
                field(VariableFieldRun1; Rec."Variable Field Run 1")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies included usage of the rent asset in the rent period based on the first counter field.';
                    Visible = VFRun1Visible;
                }
                field(VariableFieldRun2; Rec."Variable Field Run 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies included usage of the rent asset in the rent period based on the second counter field.';
                    Visible = VFRun2Visible;
                }
                field(VariableFieldRun3; Rec."Variable Field Run 3")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies included usage of the rent asset in the rent period based on the third counter field.';
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

