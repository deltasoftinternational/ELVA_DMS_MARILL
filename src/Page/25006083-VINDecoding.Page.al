Page 25006083 "VIN Decoding"
{
    Caption = 'VIN Decoding';
    PageType = List;
    SourceTable = "VIN Decoding";

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                }
                field(ParentEntryNo; Rec."Parent Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(PrimaryEntry; Rec."Primary Entry")
                {
                    ApplicationArea = Basic;
                }
                field(Position; Rec.Position)
                {
                    ApplicationArea = Basic;
                }
                field(Combination; Rec.Combination)
                {
                    ApplicationArea = Basic;
                }
                field(ModelCode; Rec."Model Code")
                {
                    ApplicationArea = Basic;
                }
                field(ModelVersionNo; Rec."Model Version No.")
                {
                    ApplicationArea = Basic;
                }
                field(ForbiddenSymbolsField; Rec."Forbidden Symbols Field")
                {
                    ApplicationArea = Basic;
                }
                field(VINLenght; Rec."VIN Lenght")
                {
                    ApplicationArea = Basic;
                }
                field(CombinationValueField; Rec."Combination Value Field")
                {
                    ApplicationArea = Basic;
                }
                field(VariableField25006800; Rec."Variable Field 25006800")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006800Visibl;
                }
                field(VariableField25006801; Rec."Variable Field 25006801")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006801Visibl;
                }
                field(VariableField25006802; Rec."Variable Field 25006802")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006802Visibl;
                }
                field(VariableField25006803; Rec."Variable Field 25006803")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006803Visibl;
                }
                field(VariableField25006804; Rec."Variable Field 25006804")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006804Visibl;
                }
                field(VariableField25006805; Rec."Variable Field 25006805")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006805Visibl;
                }
                field(VariableField25006806; Rec."Variable Field 25006806")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006806Visibl;
                }
                field(VariableField25006807; Rec."Variable Field 25006807")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006807Visibl;
                }
                field(VariableField25006808; Rec."Variable Field 25006808")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006808Visibl;
                }
                field(VariableField25006809; Rec."Variable Field 25006809")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006809Visibl;
                }
                field(VariableField25006810; Rec."Variable Field 25006810")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006810Visibl;
                }
                field(VariableField25006811; Rec."Variable Field 25006811")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006811Visibl;
                }
                field(VariableField25006812; Rec."Variable Field 25006812")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006812Visibl;
                }
                field(VariableField25006813; Rec."Variable Field 25006813")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006813Visibl;
                }
                field(VariableField25006814; Rec."Variable Field 25006814")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006814Visibl;
                }
                field(VariableField25006815; Rec."Variable Field 25006815")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006815Visibl;
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
        DMSVariableField25006815Visibl := true;
        DMSVariableField25006814Visibl := true;
        DMSVariableField25006813Visibl := true;
        DMSVariableField25006812Visibl := true;
        DMSVariableField25006811Visibl := true;
        DMSVariableField25006810Visibl := true;
        DMSVariableField25006809Visibl := true;
        DMSVariableField25006808Visibl := true;
        DMSVariableField25006807Visibl := true;
        DMSVariableField25006806Visibl := true;
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
        fSetVariableFields;
    end;

    var
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


    procedure fSetVariableFields()
    begin
        //Variable Fields
        DMSVariableField25006800Visibl := Rec.IsVFActive(Rec.FieldNo("Variable Field 25006800"));
        DMSVariableField25006801Visibl := Rec.IsVFActive(Rec.FieldNo("Variable Field 25006801"));
        DMSVariableField25006802Visibl := Rec.IsVFActive(Rec.FieldNo("Variable Field 25006802"));
        DMSVariableField25006803Visibl := Rec.IsVFActive(Rec.FieldNo("Variable Field 25006803"));
        DMSVariableField25006804Visibl := Rec.IsVFActive(Rec.FieldNo("Variable Field 25006804"));
        DMSVariableField25006805Visibl := Rec.IsVFActive(Rec.FieldNo("Variable Field 25006805"));
        DMSVariableField25006806Visibl := Rec.IsVFActive(Rec.FieldNo("Variable Field 25006806"));
        DMSVariableField25006807Visibl := Rec.IsVFActive(Rec.FieldNo("Variable Field 25006807"));
        DMSVariableField25006808Visibl := Rec.IsVFActive(Rec.FieldNo("Variable Field 25006808"));
        DMSVariableField25006809Visibl := Rec.IsVFActive(Rec.FieldNo("Variable Field 25006809"));
        DMSVariableField25006810Visibl := Rec.IsVFActive(Rec.FieldNo("Variable Field 25006810"));
        DMSVariableField25006811Visibl := Rec.IsVFActive(Rec.FieldNo("Variable Field 25006811"));
        DMSVariableField25006812Visibl := Rec.IsVFActive(Rec.FieldNo("Variable Field 25006812"));
        DMSVariableField25006813Visibl := Rec.IsVFActive(Rec.FieldNo("Variable Field 25006813"));
        DMSVariableField25006814Visibl := Rec.IsVFActive(Rec.FieldNo("Variable Field 25006814"));
        DMSVariableField25006815Visibl := Rec.IsVFActive(Rec.FieldNo("Variable Field 25006815"));
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        fSetVariableFields;
    end;
}

