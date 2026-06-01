Page 25006250 "Service Labor Texts"
{
    Caption = 'Service Labor Texts';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Service Labor Text";

    layout
    {
        area(content)
        {
            repeater(Control1190000)
            {
                field(ServiceLaborNo; Rec."Service Labor No.")
                {
                    ApplicationArea = Basic;
                }
                field("DMS Variable Field 25006800"; Rec."Variable Field 25006800")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006800Visibl;
                }
                field("DMS Variable Field 25006801"; Rec."Variable Field 25006801")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006801Visibl;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(Description2; Rec."Description 2")
                {
                    ApplicationArea = Basic;
                }
                field(Description3; Rec."Description 3")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        DMSVariableField25006801Visibl := true;
        DMSVariableField25006800Visibl := true;
    end;

    trigger OnOpenPage()
    begin
        fSetVariableFields
    end;

    var
        [InDataSet]
        DMSVariableField25006800Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006801Visibl: Boolean;


    procedure fSetVariableFields()
    begin
        //Variable Fields
        DMSVariableField25006800Visibl := Rec.IsVFActive(Rec.FieldNo("Variable Field 25006800"));
        DMSVariableField25006801Visibl := Rec.IsVFActive(Rec.FieldNo("Variable Field 25006801"));
    end;
}

