Page 25006173 "External Service Card"
{
    // 15.07.2008. EDMS P2
    //   * Added button Comment

    Caption = 'External Service Card';
    PageType = Card;
    SourceTable = "External Service";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit then
                            CurrPage.Update;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(Description2; Rec."Description 2")
                {
                    ApplicationArea = Basic;
                }
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic;
                }
                field(LastDateModified; Rec."Last Date Modified")
                {
                    ApplicationArea = Basic;
                }
                field(SearchDescription; Rec."Search Description")
                {
                    ApplicationArea = Basic;
                }
                field(VendorNo; Rec."Vendor No.")
                {
                    ApplicationArea = Basic;
                }

            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field(PriceIncludesVAT; Rec."Price Includes VAT")
                {
                    ApplicationArea = Basic;
                }
                field(VATBusPostingGrPrice; Rec."VAT Bus. Posting Gr. (Price)")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        VATBusPostingGrPriceOnAfterVal;
                    end;
                }
                field(UnitPrice; Rec."Unit Price")
                {
                    ApplicationArea = Basic;
                }
                field(PriceProfitCalculation; Rec."Price/Profit Calculation")
                {
                    ApplicationArea = Basic;
                }
                field(Profit; Rec."Profit %")
                {
                    ApplicationArea = Basic;
                }
                field(UnitCost; Rec."Unit Cost")
                {
                    ApplicationArea = Basic;
                }
                field(GenProdPostingGroup; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field(VATProdPostingGroup; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        VATProdPostingGroupOnAfterVali;
                    end;
                }
            }
            group(Tracking)
            {
                Caption = 'Tracking';
                field(AllowTrackingNos; Rec."Allow Tracking Nos.")
                {
                    ApplicationArea = Basic;
                }
                field(Control1190000; Rec."Tracking Nos.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(ExternalService)
            {
                Caption = '&External Service';
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = const(25006133),
                                  "No." = field("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
                }
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Comments';
                    Image = Comment;
                    RunObject = Page "Service Comment Sheet EDMS";
                    RunPageLink = Type = const("External Service"),
                                  "No." = field("No.");
                }
                action(TrackingNos)
                {
                    ApplicationArea = Basic;
                    Caption = '&Tracking Nos.';
                    Image = Track;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        ExtServiceTrackingNo: Record "External Serv. Tracking No.";
                    begin
                        Rec.TestField(Rec."Allow Tracking Nos.");
                        ExtServiceTrackingNo.SetRange(ExtServiceTrackingNo."External Service No.", Rec."No.");
                        Page.RunModal(Page::"Ext. Service Tracking No. List", ExtServiceTrackingNo);
                    end;
                }
                action("<Action1190006>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Prices';
                    Image = SalesPrices;
                    RunObject = Page "Service Prices";
                    RunPageLink = Code = field("No."),
                                  Type = const("Ext.Serv.");
                }
            }
        }
    }

    local procedure VATBusPostingGrPriceOnAfterVal()
    begin
        CurrPage.Update
    end;

    local procedure VATProdPostingGroupOnAfterVali()
    begin
        CurrPage.Update
    end;
}

