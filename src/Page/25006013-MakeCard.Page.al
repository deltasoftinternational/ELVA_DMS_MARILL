Page 25006013 "Make Card"
{
    // 25.02.2015 EDMS P21
    //   Added field:
    //     Picture

    Caption = 'Make Card';
    PageType = Card;
    SourceTable = Make;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
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
                field(Picture; rec.Picture)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'This field can be used to upload and store a small picture representing the make.';
                }
                field(Icon; rec.Icon)
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    ToolTip = 'This field can be used to upload and store a small icon representing the make.';
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
            action(VINDecoding)
            {
                ApplicationArea = Basic;
                Caption = 'VIN Decoding';
                Image = DesignCodeBehind;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction()
                begin
                    recVINDecoding.SetRange("Make Code", rec.Code);
                    Page.Run(Page::"VIN Decoding", recVINDecoding);
                end;
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
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
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
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Model List";
                RunPageLink = "Make Code" = field(Code);
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
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Model Version List";
                RunPageLink = "Item Type" = const("Model Version"),
                                  "Make Code" = field(Code);
                RunPageView = sorting("Item Type", "Make Code", "Model Code");
            }
        }
    }

    var
        recVINDecoding: Record "VIN Decoding";
}

