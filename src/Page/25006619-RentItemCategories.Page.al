Page 25006619 "Rent Item Categories"
{
    Caption = 'Rent Item Categories';
    PageType = List;
    SourceTable = "Rent Item Category";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the rent item category.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the rent item category.';
                }
                field(DefGenProdPostingGroup; Rec."Def. Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the General Product Posting Group if alternative should be used instead of the one coming from resource card.';
                }
                field(DefVATProdPostingGroup; Rec."Def. VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the VAT Product Posting Group if alternative should be used instead of the one coming from resource card.';
                }
                field("Only as Main Asset"; Rec."Only as Main Asset")
                {
                    ApplicationArea = All;
                }
                field("Only as Child Asset"; Rec."Only as Child Asset")
                {
                    ApplicationArea = All;
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
        area(navigation)
        {
            action(ProdGroups)
            {
                ApplicationArea = Basic;
                Caption = 'Prod. Groups';
                Image = Hierarchy;
                Promoted = true;
                PromotedCategory = "Report";
                PromotedIsBig = true;
                RunObject = Page "Rent Product Groups";
                RunPageLink = "Rent Item Category Code" = field(Code);
            }
        }
    }
    trigger OnInit()
    begin
        IsVFRun1Visible := Rec.IsVFActive(Rec.FieldNo("Check VF Run 1 on Release"));
        IsVFRun2Visible := Rec.IsVFActive(Rec.FieldNo("Check VF Run 2 on Release"));
        IsVFRun3Visible := Rec.IsVFActive(Rec.FieldNo("Check VF Run 3 on Release"));
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
        IsVFRun1Visible := Rec.IsVFActive(Rec.FieldNo("Check VF Run 1 on Release"));
        IsVFRun2Visible := Rec.IsVFActive(Rec.FieldNo("Check VF Run 2 on Release"));
        IsVFRun3Visible := Rec.IsVFActive(Rec.FieldNo("Check VF Run 3 on Release"));
    end;

}

