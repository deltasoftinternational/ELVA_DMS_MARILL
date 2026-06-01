Page 25006016 "Model List"
{
    ApplicationArea = Basic;
    Caption = 'Model List';
    CardPageID = "Model Card";
    DataCaptionFields = "Make Code", "Code";
    DelayedInsert = true;
    Editable = false;
    PageType = List;
    SourceTable = Model;
    SourceTableView = sorting("View Sequence");
    UsageCategory = Administration;
    PopulateAllFields = True;

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field("Code"; rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code that will represent the model.';
                }
                field(MakeCode; rec."Make Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies the make for the model code.';
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
            group(Model)
            {
                Caption = 'Model';
                action(OwnOptions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Own Options';
                    Image = CheckList;
                    Promoted = true;
                    PromotedCategory = Process;
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
                    RunObject = Page "Model Version List";
                    RunPageLink = "Item Type" = const("Model Version"),
                                  "Make Code" = field("Make Code"),
                                  "Model Code" = field(Code);
                    RunPageView = sorting("Item Type", "Make Code", "Model Code");
                }
            }
        }
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;
}

