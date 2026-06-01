Page 25006001 "Model Version Specification"
{
    // 04.06.2007. EDMS P2
    //   * Created this form

    Caption = 'Model Version Specification';
    PageType = Card;
    PopulateAllFields = true;
    SourceTable = "Model Version Specification";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(MakeCode; rec."Make Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(ModelCode; rec."Model Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(ModelVersionNo; rec."Model Version No.")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(VariableField25006800; rec."Variable Field 25006800")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006800Visibl;
                }
                field(VariableField25006801; rec."Variable Field 25006801")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006801Visibl;
                }
                field(VariableField25006802; rec."Variable Field 25006802")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006802Visibl;
                }
                field(VariableField25006803; rec."Variable Field 25006803")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006803Visibl;
                }
                field(VariableField25006804; rec."Variable Field 25006804")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006804Visibl;
                }
                field(VariableField25006805; rec."Variable Field 25006805")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006805Visibl;
                }
                field(VariableField25006806; rec."Variable Field 25006806")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006806Visibl;
                }
                field(VariableField25006807; rec."Variable Field 25006807")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006807Visibl;
                }
                field(VariableField25006808; rec."Variable Field 25006808")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006808Visibl;
                }
                field(VariableField25006809; rec."Variable Field 25006809")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006809Visibl;
                }
                field(VariableField25006810; rec."Variable Field 25006810")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006810Visibl;
                }
                field(VariableField25006811; rec."Variable Field 25006811")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006811Visibl;
                }
                field(VariableField25006812; rec."Variable Field 25006812")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006812Visibl;
                }
                field(VariableField25006813; rec."Variable Field 25006813")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006813Visibl;
                }
                field(VariableField25006814; rec."Variable Field 25006814")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006814Visibl;
                }
                field(VariableField25006815; rec."Variable Field 25006815")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006815Visibl;
                }
                field(VariableField25006816; rec."Variable Field 25006816")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006816Visibl;
                }
                field(VariableField25006817; rec."Variable Field 25006817")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006817Visibl;
                }
                field(VariableField25006818; rec."Variable Field 25006818")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006818Visibl;
                }
                field(VariableField25006819; rec."Variable Field 25006819")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006819Visibl;
                }
                field(VariableField25006820; rec."Variable Field 25006820")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006820Visibl;
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
        OnAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        fHideVariableFields;
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        ModelVersionSpecification.CopyFilters(Rec);
        if not ModelVersionSpecification.FindSet then begin
            SetGeneral(ModelVersionSpecification.GetRangeMin("Make Code"), ModelVersionSpecification.GetRangeMin("Model Code"),
                ModelVersionSpecification.GetRangeMin("Model Version No."));
        end;
    end;

    var
        ModelVersionSpecification: Record "Model Version Specification";
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
        [InDataSet]
        DMSVariableField25006806Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006807Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006808Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006809Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006810Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006811Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006812Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006813Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006814Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006815Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006816Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006817Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006818Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006819Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006820Visibl: Boolean;
        Text001: label 'Would you like to create a specification?';


    procedure fSetVariableFields()
    begin
        //Variable Fields
        DMSVariableField25006800Visibl := rec.IsVFActive(rec.FieldNo("Variable Field 25006800"));
        DMSVariableField25006801Visibl := rec.IsVFActive(rec.FieldNo("Variable Field 25006801"));
        DMSVariableField25006802Visibl := rec.IsVFActive(rec.fieldNo("Variable Field 25006802"));
        DMSVariableField25006803Visibl := rec.IsVFActive(rec.FieldNo("Variable Field 25006803"));
        DMSVariableField25006804Visibl := rec.IsVFActive(rec.FieldNo("Variable Field 25006804"));
        DMSVariableField25006805Visibl := rec.IsVFActive(rec.FieldNo("Variable Field 25006805"));
        DMSVariableField25006806Visibl := rec.IsVFActive(rec.FieldNo("Variable Field 25006806"));
        DMSVariableField25006807Visibl := rec.IsVFActive(rec.FieldNo("Variable Field 25006807"));
        DMSVariableField25006808Visibl := rec.IsVFActive(rec.FieldNo("Variable Field 25006808"));
        DMSVariableField25006809Visibl := rec.IsVFActive(rec.FieldNo("Variable Field 25006809"));
        DMSVariableField25006810Visibl := rec.IsVFActive(rec.FieldNo("Variable Field 25006810"));
        DMSVariableField25006811Visibl := rec.IsVFActive(rec.FieldNo("Variable Field 25006811"));
        DMSVariableField25006812Visibl := rec.IsVFActive(rec.FieldNo("Variable Field 25006812"));
        DMSVariableField25006813Visibl := rec.IsVFActive(rec.FieldNo("Variable Field 25006813"));
        DMSVariableField25006814Visibl := rec.IsVFActive(rec.FieldNo("Variable Field 25006814"));
        DMSVariableField25006815Visibl := rec.IsVFActive(rec.FieldNo("Variable Field 25006815"));
        DMSVariableField25006816Visibl := rec.IsVFActive(rec.FieldNo("Variable Field 25006816"));
        DMSVariableField25006817Visibl := rec.IsVFActive(rec.FieldNo("Variable Field 25006817"));
        DMSVariableField25006818Visibl := rec.IsVFActive(rec.FieldNo("Variable Field 25006818"));
        DMSVariableField25006819Visibl := rec.IsVFActive(rec.FieldNo("Variable Field 25006819"));
        DMSVariableField25006820Visibl := rec.IsVFActive(rec.FieldNo("Variable Field 25006820"));
    end;


    procedure fHideVariableFields()
    begin
        //Variable Fields
        DMSVariableField25006800Visibl := false;
        DMSVariableField25006801Visibl := false;
        DMSVariableField25006802Visibl := false;
        DMSVariableField25006803Visibl := false;
        DMSVariableField25006804Visibl := false;
        DMSVariableField25006805Visibl := false;
        DMSVariableField25006806Visibl := false;
        DMSVariableField25006807Visibl := false;
        DMSVariableField25006808Visibl := false;
        DMSVariableField25006809Visibl := false;
        DMSVariableField25006810Visibl := false;
        DMSVariableField25006811Visibl := false;
        DMSVariableField25006812Visibl := false;
        DMSVariableField25006813Visibl := false;
        DMSVariableField25006814Visibl := false;
        DMSVariableField25006815Visibl := false;
        DMSVariableField25006816Visibl := false;
        DMSVariableField25006817Visibl := false;
        DMSVariableField25006818Visibl := false;
        DMSVariableField25006819Visibl := false;
        DMSVariableField25006820Visibl := false;
    end;


    procedure SetGeneral(MakeCode: Code[20]; ModelCode: Code[20]; ModelVersion: Code[20])
    begin
        if Confirm(Text001, true) then begin
            rec."Make Code" := MakeCode;
            rec."Model Code" := ModelCode;
            rec."Model Version No." := ModelVersion;
            rec.Insert;
        end;
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        fSetVariableFields;
    end;
}

