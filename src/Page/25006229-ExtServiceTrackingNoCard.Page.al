Page 25006229 "Ext. Service Tracking No. Card"
{
    // 15.07.2008. EDMS P2
    //   * Add code Form - OnOpenForm
    //   * Opened fields "Purchase Amount", "Sale Amount"

    Caption = 'External Serv. Tracking No. Card';
    PageType = Card;
    RefreshOnActivate = true;
    SourceTable = "External Serv. Tracking No.";
    PopulateAllFields = True;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(ExternalServTrackingNo; Rec."External Serv. Tracking No.")
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
    }

    trigger OnAfterGetRecord()
    begin
        Rec.SetRange("External Service No.", Rec."External Service No.");
        Rec.SetRange("External Serv. Tracking No.");
    end;

    trigger OnOpenPage()
    begin
        Rec.SetRange("External Serv. Tracking No.");
    end;
}

