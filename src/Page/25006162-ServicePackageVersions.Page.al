Page 25006162 "Service Package Versions"
{
    AutoSplitKey = true;
    Caption = 'Service Package Version List';
    DelayedInsert = true;
    PageType = ListPart;
    SourceTable = "Service Package Version";

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field(PackageNo; Rec."Package No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VersionNo; Rec."Version No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ModelCode; Rec."Model Code")
                {
                    ApplicationArea = Basic;
                }
                field(ProdYearFrom; Rec."Prod. Year From")
                {
                    ApplicationArea = Basic;
                }
                field(ProdYearTo; Rec."Prod. Year To")
                {
                    ApplicationArea = Basic;
                }
                field(VINFrom; Rec."VIN From")
                {
                    ApplicationArea = Basic;
                }
                field(VINTo; Rec."VIN To")
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
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;

                    trigger OnDrillDown()
                    var
                        VersionSpec: Record "Service Package Version Line";
                    begin
                        VersionSpec.Reset;
                        VersionSpec.SetRange("Package No.", Rec."Package No.");
                        VersionSpec.SetRange("Version No.", Rec."Version No.");
                        Page.RunModal(Page::"Service Package Version Lines", VersionSpec);
                    end;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(VersionLines)
            {
                ApplicationArea = Basic;
                Caption = 'Version Lines';
                Image = Versions;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Service Package Version Lines";
                RunPageLink = "Package No." = field("Package No."),
                              "Version No." = field("Version No.");
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        SetVariableFields;
    end;

    trigger OnInit()
    begin
        DMSVariableField25006804Visibl := true;
        DMSVariableField25006803Visibl := true;
        DMSVariableField25006802Visibl := true;
        DMSVariableField25006801Visibl := true;
        DMSVariableField25006800Visibl := true;
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
        VFRun1Visible: Boolean;
        [InDataSet]
        VFRun2Visible: Boolean;
        [InDataSet]
        VFRun3Visible: Boolean;


    procedure SetVariableFields()
    begin
        //Variable Fields
        DMSVariableField25006800Visibl := Rec.IsVFActive(Rec.FieldNo("Variable Field 25006800"));
        DMSVariableField25006801Visibl := Rec.IsVFActive(Rec.FieldNo("Variable Field 25006801"));
        DMSVariableField25006802Visibl := Rec.IsVFActive(Rec.FieldNo("Variable Field 25006802"));
        DMSVariableField25006803Visibl := Rec.IsVFActive(Rec.FieldNo("Variable Field 25006803"));
        DMSVariableField25006804Visibl := Rec.IsVFActive(Rec.FieldNo("Variable Field 25006804"));
        VFRun1Visible := Rec.IsVFActive(Rec.FieldNo("Variable Field Run 1"));
        VFRun2Visible := Rec.IsVFActive(Rec.FieldNo("Variable Field Run 2"));
        VFRun3Visible := Rec.IsVFActive(Rec.FieldNo("Variable Field Run 3"));
    end;
}

