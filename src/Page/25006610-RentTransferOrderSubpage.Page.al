Page 25006610 "Rent Transfer Order Subpage"
{
    AutoSplitKey = true;
    Caption = 'Rent Transfer Order Lines';
    PageType = ListPart;
    SourceTable = "Rent Transfer Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                }
                field(RentItemNo; Rec."Rent Item No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(RentAssetNo; Rec."Rent Asset No.")
                {
                    ApplicationArea = Basic;
                }
                field("Rent Asset Description"; Rec."Rent Asset Description")
                {
                    ApplicationArea = All;
                }
                field("Make Code"; Rec."Make Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field("Model Code"; Rec."Model Code")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    Editable = IsQuantityEditable;
                }
                field(VariableFieldRun1; Rec."Variable Field Run 1")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun1Visible;
                }
                field(VariableFieldRun2; Rec."Variable Field Run 2")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun2Visible;
                }
                field(VariableFieldRun3; Rec."Variable Field Run 3")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun3Visible;
                }
                field("Variable Field 25006800"; Rec."Variable Field 25006800")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = VF25006800Visible;
                }
                field("Variable Field 25006801"; Rec."Variable Field 25006801")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = VF25006801Visible;
                }
                field("Variable Field 25006802"; Rec."Variable Field 25006802")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = VF25006802Visible;
                }
                field("Variable Field 25006803"; Rec."Variable Field 25006803")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = VF25006803Visible;
                }
                field("Variable Field 25006804"; Rec."Variable Field 25006804")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = VF25006804Visible;
                }
                field("Variable Field 25006805"; Rec."Variable Field 25006805")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = VF25006805Visible;
                }
                field("Variable Field 25006806"; Rec."Variable Field 25006806")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = VF25006806Visible;
                }
                field("Variable Field 25006807"; Rec."Variable Field 25006807")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = VF25006807Visible;
                }
                field("Variable Field 25006808"; Rec."Variable Field 25006808")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = VF25006808Visible;
                }
                field("Variable Field 25006809"; Rec."Variable Field 25006809")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = VF25006809Visible;
                }
                field("Variable Field 25006810"; Rec."Variable Field 25006810")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = VF25006810Visible;
                }
                field("Variable Field 25006811"; Rec."Variable Field 25006811")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = VF25006811Visible;
                }
                field("Variable Field 25006812"; Rec."Variable Field 25006812")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = VF25006812Visible;
                }
                field("Variable Field 25006813"; Rec."Variable Field 25006813")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = VF25006813Visible;
                }
                field("Variable Field 25006814"; Rec."Variable Field 25006814")
                {
                    ApplicationArea = All;
                    Editable = false;
                    Visible = VF25006814Visible;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
        }
    }

    trigger OnOpenPage()
    begin
        IsVFRun1Visible := Rec.IsVFActive(Rec.FieldNo("Variable Field Run 1"));
        IsVFRun2Visible := Rec.IsVFActive(Rec.FieldNo("Variable Field Run 2"));
        IsVFRun3Visible := Rec.IsVFActive(Rec.FieldNo("Variable Field Run 3"));
        VF25006800Visible := Rec.IsVFActive(25006800);
        VF25006801Visible := Rec.IsVFActive(25006801);
        VF25006802Visible := Rec.IsVFActive(25006802);
        VF25006803Visible := Rec.IsVFActive(25006803);
        VF25006804Visible := Rec.IsVFActive(25006804);
        VF25006805Visible := Rec.IsVFActive(25006805);
        VF25006806Visible := Rec.IsVFActive(25006806);
        VF25006807Visible := Rec.IsVFActive(25006807);
        VF25006808Visible := Rec.IsVFActive(25006808);
        VF25006809Visible := Rec.IsVFActive(25006809);
        VF25006810Visible := Rec.IsVFActive(25006810);
        VF25006811Visible := Rec.IsVFActive(25006811);
        VF25006812Visible := Rec.IsVFActive(25006812);
        VF25006813Visible := Rec.IsVFActive(25006813);
        VF25006814Visible := Rec.IsVFActive(25006814);
    end;

    trigger OnAfterGetCurrRecord()
    begin
        UpdateRentAssetQtyEditable;
    end;

    var
        IsVFRun1Visible: Boolean;
        IsVFRun2Visible: Boolean;
        IsVFRun3Visible: Boolean;
        IsQuantityEditable: Boolean;
        RentAsset: Record "Rent Asset";
        VF25006800Visible: Boolean;
        VF25006801Visible: Boolean;
        VF25006802Visible: Boolean;
        VF25006803Visible: Boolean;
        VF25006804Visible: Boolean;
        VF25006805Visible: Boolean;
        VF25006806Visible: Boolean;
        VF25006807Visible: Boolean;
        VF25006808Visible: Boolean;
        VF25006809Visible: Boolean;
        VF25006810Visible: Boolean;
        VF25006811Visible: Boolean;
        VF25006812Visible: Boolean;
        VF25006813Visible: Boolean;
        VF25006814Visible: Boolean;

    local procedure UpdateRentAssetQtyEditable()
    begin
        IsQuantityEditable := false;
        if Rec."Rent Asset No." <> '' then begin
            RentAsset.Get(Rec."Rent Asset No.");
            if RentAsset."Asset Type" = RentAsset."Asset Type"::Multiple then
                IsQuantityEditable := true;
        end;
    end;
}

