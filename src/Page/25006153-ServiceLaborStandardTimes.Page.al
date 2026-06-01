Page 25006153 "Service Labor Standard Times"
{
    AutoSplitKey = true;
    Caption = 'Service Labor Standard Times';
    DataCaptionFields = "Labor No.";
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Service Labor Standard Time";

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field(LaborNo; Rec."Labor No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the labor for the service labor standard time entry.';
                }
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the line number of the service labor standard time entry.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description for the specified standard time entry.';
                }
                field(StandardTimeHours; Rec."Standard Time (Hours)")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the duration in hours for the standard time entry.';
                }
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the make of a vehicle to which this service labor standard time entry would apply to.';
                }
                field(ModelCode; Rec."Model Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the model of a vehicle to which this service labor standard time entry would apply to.';
                }
                field(ProdYearFrom; Rec."Prod. Year From")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the starting production year of a vehicle to which this service labor standard time entry would apply to.';
                }
                field(ProdYearTo; Rec."Prod. Year To")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ending production year of a vehicle to which this service labor standard time entry would apply to.';
                }
                field(VariableField25006800; Rec."Variable Field 25006800")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006800Visibl;
                    ToolTip = 'Specifies a vehicle characteristics of a vehicle to which this service labor standard time entry would apply to.';
                }
                field(VariableField25006801; Rec."Variable Field 25006801")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006801Visibl;
                    ToolTip = 'Specifies a vehicle characteristics of a vehicle to which this service labor standard time entry would apply to.';
                }
                field(VariableField25006802; Rec."Variable Field 25006802")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006802Visibl;
                    ToolTip = 'Specifies a vehicle characteristics of a vehicle to which this service labor standard time entry would apply to.';
                }
                field(VariableField25006803; Rec."Variable Field 25006803")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006803Visibl;
                    ToolTip = 'Specifies a vehicle characteristics of a vehicle to which this service labor standard time entry would apply to.';
                }
                field(VariableField25006804; Rec."Variable Field 25006804")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006804Visibl;
                    ToolTip = 'Specifies a vehicle characteristics of a vehicle to which this service labor standard time entry would apply to.';
                }
                field(VariableField25006805; Rec."Variable Field 25006805")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006805Visibl;
                    ToolTip = 'Specifies a vehicle characteristics of a vehicle to which this service labor standard time entry would apply to.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin
        DMSVariableField25006805Visibl := true;
        DMSVariableField25006804Visibl := true;
        DMSVariableField25006803Visibl := true;
        DMSVariableField25006802Visibl := true;
        DMSVariableField25006801Visibl := true;
        DMSVariableField25006800Visibl := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        fGetFilters;
        fSetVariableFields
    end;

    var
        txtFilter: array[12] of Text[250];
        [InDataSet]
        DMSVariableField25006800Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006801Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006802Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006803Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006804Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006805Visibl: Boolean;


    procedure fGetFilters()
    begin
        txtFilter[1] := Rec.GetFilter("Make Code");
        txtFilter[2] := Rec.GetFilter("Model Code");
        txtFilter[3] := Rec.GetFilter("Prod. Year From");
        txtFilter[4] := Rec.GetFilter("Prod. Year To");
    end;


    procedure fSetLookFilter(intFilterNo: Integer)
    var
        recMake: Record Make;
        recModel: Record Model;
    begin
        case intFilterNo of
            1:
                if Page.RunModal(Page::"Make List", recMake) = Action::LookupOK then
                    txtFilter[1] := recMake.Code;

            2:
                if Page.RunModal(Page::"Model List", recModel) = Action::LookupOK then
                    txtFilter[2] := recModel.Code;
        end;

        fSetValdateFilter(intFilterNo);
    end;


    procedure fSetValdateFilter(intFilterNo: Integer)
    var
        recMake: Record Make;
        recModel: Record Model;
    begin
        case intFilterNo of
            1:
                Rec.SetFilter("Make Code", txtFilter[intFilterNo]);
            2:
                Rec.SetFilter("Model Code", txtFilter[intFilterNo]);
            3:
                Rec.SetFilter("Prod. Year From", txtFilter[intFilterNo]);
            4:
                Rec.SetFilter("Prod. Year To", txtFilter[intFilterNo]);
        end;

        CurrPage.Update;
    end;


    procedure fSetVariableFields()
    begin
        //Variable Fields
        DMSVariableField25006800Visibl := Rec.IsVFActive(Rec.FieldNo("Variable Field 25006800"));
        DMSVariableField25006801Visibl := Rec.IsVFActive(Rec.FieldNo("Variable Field 25006801"));
        DMSVariableField25006802Visibl := Rec.IsVFActive(Rec.FieldNo("Variable Field 25006802"));
        DMSVariableField25006803Visibl := Rec.IsVFActive(Rec.FieldNo("Variable Field 25006803"));
        DMSVariableField25006804Visibl := Rec.IsVFActive(Rec.FieldNo("Variable Field 25006804"));
        DMSVariableField25006805Visibl := Rec.IsVFActive(Rec.FieldNo("Variable Field 25006805"));
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        fSetVariableFields;
    end;
}

