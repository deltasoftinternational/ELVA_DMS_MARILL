Page 25006228 "Ext. Service Tracking No. List"
{
    // 15.07.2008. EDMS P2
    //   * Opened field "Purchase Amount", "Sale Amount"

    Caption = 'Ext. Service Tracking No. List';
    CardPageID = "Ext. Service Tracking No. Card";
    DataCaptionFields = "External Service No.";
    PageType = List;
    SourceTable = "External Serv. Tracking No.";
    PopulateAllFields = True;

    layout
    {
        area(content)
        {
            repeater(Control1190000)
            {
                Editable = false;

                field(Control1190001; Rec."External Serv. Tracking No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(PurchaseAmount; Rec."Purchase Amount")
                {
                    ApplicationArea = Basic;
                }
                field(SalesAmount; Rec."Sales Amount")
                {
                    ApplicationArea = Basic;
                }
                field("Service Order No."; Rec."Service Order No.")
                {
                    ApplicationArea = All;
                }
                field("Vehicle Serial No."; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = All;
                }
                field("Vehicle Registration No."; Rec."Vehicle Registration No.")
                {
                    ApplicationArea = All;
                    Editable = False;
                }
                field(VIN; Rec.VIN)
                {
                    ApplicationArea = All;
                    Editable = False;
                }
                field("Make Code"; Rec."Make Code")
                {
                    ApplicationArea = All;
                    Editable = False;
                }
                field("Model Code"; Rec."Model Code")
                {
                    ApplicationArea = All;
                    Editable = False;
                }
                field("Purchase Lines"; Rec."Purchase Lines")
                {
                    ApplicationArea = All;
                    Editable = False;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(ExternalServTrackingNo)
            {
                Caption = '&External Serv. Tracking No.';
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = Card;
                    Promoted = true;
                    RunObject = Page "Ext. Service Tracking No. Card";
                    RunPageLink = "External Service No." = field("External Service No."),
                                  "External Serv. Tracking No." = field("External Serv. Tracking No.");
                    ShortCutKey = 'Shift+F5';
                }
            }
        }
    }
}

