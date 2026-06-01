Page 25006174 "External Service List"
{
    ApplicationArea = Basic;
    Caption = 'External Service List';
    CardPageID = "External Service Card";
    Editable = false;
    PageType = List;
    SourceTable = "External Service";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(Description2; Rec."Description 2")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SearchDescription; Rec."Search Description")
                {
                    ApplicationArea = Basic;
                }
                field(LastDateModified; Rec."Last Date Modified")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(GenProdPostingGroup; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VATBusPostingGrPrice; Rec."VAT Bus. Posting Gr. (Price)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VATProdPostingGroup; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VendorNo; Rec."Vendor No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
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
                Caption = 'External Service';
                action("<Action1190002>")
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
                action("<Action1190000>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Prices';
                    Image = SalesPrices;
                    Promoted = true;
                    RunObject = Page "Service Prices";
                    RunPageLink = Code = field("No."),
                                  Type = const("Ext.Serv.");
                }
            }
        }
    }
}

