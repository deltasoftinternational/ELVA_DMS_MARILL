Page 25006027 "Vehicle Warranty List"
{
    Caption = 'Vehicle Warranty List';
    CardPageID = "Vehicle Warranty Card";
    PageType = List;
    SourceTable = "Vehicle Warranty";

    layout
    {
        area(content)
        {
            repeater(Control1101908000)
            {
                field(VehicleSerialNo; rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VIN; rec.VIN)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(No; rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(WarrantyTypeCode; rec."Warranty Type Code")
                {
                    ApplicationArea = Basic;
                }
                field(StartingDate; rec."Starting Date")
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
                field(Status; rec.Status)
                {
                    ApplicationArea = Basic;
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
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Warranty)
            {
                Caption = 'Warranty';
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = Card;
                    Promoted = true;
                    PromotedCategory = New;
                    PromotedIsBig = true;
                    ShortCutKey = 'Shift+F5';

                    trigger OnAction()
                    begin
                        Page.Run(Page::"Vehicle Warranty Card", Rec);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        fSetVariableFields;
        OnAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin
        fHideVariableFields;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        fHideVariableFields;
        OnAfterGetCurrRecord;
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
        VFRun1Visible: Boolean;
        [InDataSet]
        VFRun2Visible: Boolean;
        [InDataSet]
        VFRun3Visible: Boolean;


    procedure fSetVariableFields()
    begin
        //Variable Fields
        DMSVariableField25006800Visibl := rec.IsVFActive(rec.FieldNo("Variable Field 25006800"));
        DMSVariableField25006801Visibl := rec.IsVFActive(rec.FieldNo("Variable Field 25006801"));
        DMSVariableField25006802Visibl := rec.IsVFActive(rec.FieldNo("Variable Field 25006802"));
        DMSVariableField25006803Visibl := rec.IsVFActive(rec.FieldNo("Variable Field 25006803"));
        DMSVariableField25006804Visibl := rec.IsVFActive(rec.FieldNo("Variable Field 25006804"));
        DMSVariableField25006805Visibl := rec.IsVFActive(rec.FieldNo("Variable Field 25006805"));
        DMSVariableField25006806Visibl := rec.IsVFActive(rec.FieldNo("Variable Field 25006806"));
        DMSVariableField25006807Visibl := rec.IsVFActive(rec.FieldNo("Variable Field 25006807"));
        DMSVariableField25006808Visibl := rec.IsVFActive(rec.FieldNo("Variable Field 25006808"));
        DMSVariableField25006809Visibl := rec.IsVFActive(rec.FieldNo("Variable Field 25006809"));
        VFRun1Visible := rec.IsVFActive(rec.FieldNo("Variable Field Run 1"));
        VFRun2Visible := rec.IsVFActive(rec.FieldNo("Variable Field Run 2"));
        VFRun3Visible := rec.IsVFActive(rec.FieldNo("Variable Field Run 3"));
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
        VFRun1Visible := false;
        VFRun2Visible := false;
        VFRun3Visible := false;
    end;


    procedure SetRange(VehSerialNo: Code[20])
    begin
        Rec.SetRange(Rec."Vehicle Serial No.", VehSerialNo);
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        fSetVariableFields;
    end;
}

