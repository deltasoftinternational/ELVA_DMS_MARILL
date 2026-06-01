Page 25006015 "Model Card"
{
    Caption = 'Model Card';
    DataCaptionFields = "Make Code", "Commercial Name";
    PageType = Card;
    SourceTable = Model;
    PopulateAllFields = True;

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
                    ToolTip = 'Specifies the make for the model code.';
                }
                field("Code"; rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code that will represent the model.';
                }
                field(CommercialName; rec."Commercial Name")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a commercial name for this model.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(OwnOptions)
            {
                ApplicationArea = Basic;
                Caption = 'Own Options';
                Image = CheckList;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Own Options";
                RunPageLink = "Make Code" = field("Make Code"),
                                  "Model Code" = field(Code);
            }
            action(ModelVersions)
            {
                ApplicationArea = Basic;
                Caption = 'Model Versions';
                Image = Versions;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Model Version List";
                RunPageLink = "Item Type" = const("Model Version"),
                                  "Make Code" = field("Make Code"),
                                  "Model Code" = field(Code);
                RunPageView = sorting("Item Type", "Make Code", "Model Code");
            }
        }
    }

    trigger OnOpenPage()
    begin
        rec.SetRange("Make Code");
        rec.SetRange(Code);
    end;
}

