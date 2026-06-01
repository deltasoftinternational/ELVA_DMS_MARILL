Page 25006458 "Veh.Trade-In Apply to Purchase"
{
    Caption = 'Veh.Trade-In Apply to Purchase';
    PageType = CardPart;

    layout
    {
        area(content)
        {
            group(VehicleInformation)
            {
                Caption = 'Vehicle Information';
                fixed(Control1101904000)
                {
                    group(Sales)
                    {
                        Caption = 'Sales';
                        field(MakeCode; SalesLine."Make Code")
                        {
                            ApplicationArea = Basic;
                            Caption = 'Make Code';
                        }
                        field(ModelCode; SalesLine."Model Code")
                        {
                            ApplicationArea = Basic;
                            Caption = 'Model Code';
                        }
                        field(VIN; SalesLine.VIN)
                        {
                            ApplicationArea = Basic;
                            Caption = 'VIN';
                            Editable = false;
                        }
                    }
                    group(Purchase)
                    {
                        Caption = 'Purchase';
                        field(TradeInMakeCode; TradeInMakeCode)
                        {
                            ApplicationArea = Basic;
                        }
                        field(TradeInModelCode; TradeInModelCode)
                        {
                            ApplicationArea = Basic;
                        }
                        field(TradeInVIN; TradeInVIN)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Vehicle Trade In VIN';
                            Editable = false;
                        }
                    }
                }
            }
            group(Amounts)
            {
                Caption = 'Amounts';
                field(TradeInAmount; TradeInAmount)
                {
                    ApplicationArea = Basic;
                    Caption = 'Trade-In Amount';
                }
            }
        }
    }

    actions
    {
    }

    var
        TradeIn: Record "Trade-In Application Entry";
        SalesLine: Record "Sales Line";
        TradeInMakeCode: Code[20];
        TradeInModelCode: Code[20];
        TradeInVIN: Text[30];
        TradeInAmount: Decimal;


    procedure SetVariables(TradeIn1: Record "Trade-In Application Entry"; SalesLine1: Record "Sales Line")
    var
        Vehicle: Record Vehicle;
    begin
        SalesLine := SalesLine1;

        TradeIn.Reset;
        TradeIn.SetRange("Entry Type", TradeIn1."Entry Type");
        TradeIn.SetRange("Vehicle Serial No.", TradeIn1."Vehicle Serial No.");
        TradeIn.SetRange("Vehicle Accounting Cycle No.", TradeIn1."Vehicle Accounting Cycle No.");
        if TradeIn.FindFirst then
            repeat
                TradeInAmount += TradeIn."Amount (LCY)";
            until TradeIn.Next = 0;

        if Vehicle.Get(TradeIn1."Vehicle Serial No.") then;
        TradeInVIN := Vehicle.VIN;
        TradeInMakeCode := Vehicle."Make Code";
        TradeInModelCode := Vehicle."Model Code";
    end;


    procedure GetTradeInAmount(): Decimal
    begin
        exit(TradeInAmount);
    end;
}

