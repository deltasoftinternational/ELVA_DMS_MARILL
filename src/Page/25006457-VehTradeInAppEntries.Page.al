Page 25006457 "Veh.Trade-In App.Entries"
{
    Caption = 'Veh.Trade-In App.Entries';
    Editable = false;
    PageType = List;
    SourceTable = "Trade-In Application Entry";

    layout
    {
        area(content)
        {
            repeater(Control1190000)
            {
                field(EntryType; Rec."Entry Type")
                {
                    ApplicationArea = Basic;
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentType; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(AmountLCY; Rec."Amount (LCY)")
                {
                    ApplicationArea = Basic;
                }
                field(AmountFCY; Rec."Amount (FCY)")
                {
                    ApplicationArea = Basic;
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleAccountingCycleNo; Rec."Vehicle Accounting Cycle No.")
                {
                    ApplicationArea = Basic;
                }
                field(AppliestoVehicleSerialNo; Rec."Applies-to Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field(AppliestoVehAccCycleNo; Rec."Applies-to Veh. Acc. Cycle No.")
                {
                    ApplicationArea = Basic;
                }
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleRegistrationNo; Rec."Vehicle Registration No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(Functions)
            {
                Caption = 'Functions';
                action(LinkPurchaseOrder)
                {
                    ApplicationArea = Basic;
                    Caption = 'Link Purchase Order';
                    Image = Purchase;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        PurchaseLine: Record "Purchase Line";
                        PurchaseLine2: Record "Purchase Line";
                    begin
                        SaleSetup.Get;
                        PurchaseLine.Reset;
                        Clear(PurchaseLines);

                        PurchaseLine.SetRange("Line Type", PurchaseLine."line type"::Vehicle);
                        PurchaseLine.SetRange("Link Trade-In Entry", 0);
                        PurchaseLines.LookupMode(true);
                        PurchaseLines.SetTableview(PurchaseLine);
                        if PurchaseLines.RunModal = Action::LookupOK then begin
                            PurchaseLines.GetRecord(PurchaseLine);
                            VehTradeInMgt.InsertPurchaseLineEntry(PurchaseLine."Document No.", PurchaseLine."Line No.",
                                                                  PurchaseLine."Document Type".asinteger());
                        end;

                        if Rec.FindLast then;
                    end;
                }
            }
        }
    }

    trigger OnInit()
    begin
        CurrPage.LookupMode := true;
    end;

    var
        SaleSetup: Record "Sales & Receivables Setup";
        VehTradeInMgt: Codeunit "Veh.Trade-In Mgt.";
        PurchaseLines: Page "Purchase Lines";
}

