Page 25006014 "Make List"
{
    ApplicationArea = Basic;
    Caption = 'Make List';
    CardPageID = "Make Card";
    DataCaptionFields = "Code";
    DelayedInsert = true;
    Editable = false;
    PageType = List;
    SourceTable = Make;
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field("Code"; rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code that that will represent the make in the system.';
                }
                field(Name; rec.Name)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the name of the make.';
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Dimensions)
            {
                ApplicationArea = Basic;
                Caption = 'Dimensions';
                Image = Dimensions;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Default Dimensions";
                RunPageLink = "Table ID" = const(25006000),
                                  "No." = field(Code);
                ShortCutKey = 'Shift+Ctrl+D';
            }
            action(Setup)
            {
                ApplicationArea = Basic;
                Caption = 'Setup';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Make Setup";
                RunPageLink = "Make Code" = field(Code);
            }
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
                RunPageLink = "Make Code" = field(Code);
            }
            action(Models)
            {
                ApplicationArea = Basic;
                Caption = 'Models';
                Image = ListPage;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Model List";
                RunPageLink = "Make Code" = field(Code);
            }
            action(ModelVersions)
            {
                ApplicationArea = Basic;
                Caption = 'Model Versions';
                Image = ListPage;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                RunObject = Page "Model Version List";
                RunPageLink = "Item Type" = const("Model Version"),
                                  "Make Code" = field(Code);
                RunPageView = sorting("Item Type", "Make Code", "Model Code");
            }
        }
    }
}

