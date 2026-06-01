Page 25006023 "Vehicle Types"
{
    ApplicationArea = Basic;
    Caption = 'Vehicle Types';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Vehicle Type";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field("Code"; rec.Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description; rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field("Check VF Run 1 on Release"; Rec."Check VF Run 1 on Release")
                {
                    ToolTip = 'Specifies if the vehicle counter is mandatory.';
                    ApplicationArea = All;
                    Visible = IsVFRun1Visible;
                }
                field("Check VF Run 2 on Release"; Rec."Check VF Run 2 on Release")
                {
                    ToolTip = 'Specifies if the vehicle counter is mandatory.';
                    ApplicationArea = All;
                    Visible = IsVFRun2Visible;
                }
                field("Check VF Run 3 on Release"; Rec."Check VF Run 3 on Release")
                {
                    ToolTip = 'Specifies if the vehicle counter is mandatory.';
                    ApplicationArea = All;
                    Visible = IsVFRun3Visible;
                }
            }
        }
    }

    actions
    {
    }
    trigger OnInit()
    begin
        IsVFRun1Visible := rec.IsVFActive(rec.FieldNo("Check VF Run 1 on Release"));
        IsVFRun2Visible := rec.IsVFActive(rec.FieldNo("Check VF Run 2 on Release"));
        IsVFRun3Visible := rec.IsVFActive(rec.FieldNo("Check VF Run 3 on Release"));
    end;

    trigger OnOpenPage()
    begin
        SetVariableFields;
    end;

    var
        [InDataSet]
        IsVFRun1Visible: Boolean;
        [InDataSet]
        IsVFRun2Visible: Boolean;
        [InDataSet]
        IsVFRun3Visible: Boolean;


    procedure SetVariableFields()
    begin
        //Variable Fields
        IsVFRun1Visible := rec.IsVFActive(rec.FieldNo("Check VF Run 1 on Release"));
        IsVFRun2Visible := rec.IsVFActive(rec.FieldNo("Check VF Run 2 on Release"));
        IsVFRun3Visible := rec.IsVFActive(rec.FieldNo("Check VF Run 3 on Release"));
    end;
}

