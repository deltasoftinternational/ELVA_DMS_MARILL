Page 25006625 "Rent Manager Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "Rent Manager Cue";

    layout
    {
        area(content)
        {
            cuegroup(Rent)
            {
                Caption = 'Rent';
                field(RentQuotes; Rec."Rent Quotes")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Rent Quote List";
                }
                field(RentOrders; Rec."Rent Orders")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Rent Order List";
                }
            }
            cuegroup(Documents)
            {
                Caption = 'Documents';
                field(RentInvoices; Rec."Rent Invoices")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Sales List";
                }
                field(RentCreditMemos; Rec."Rent Credit Memos")
                {
                    Caption = 'Rent Credit Memos';
                    ApplicationArea = Basic;
                    //DrillDownPageID = "Posted Rent Credit Memos";

                    trigger OnDrillDown()
                    var
                    begin
                        Page.Run(Page::"Posted Rent Credit Memos");
                    end;
                }
            }
            cuegroup(Transfers)
            {
                Caption = 'Transfers';
                field(RentTransferOrders; Rec."Rent Transfer Orders")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;
    end;
}

