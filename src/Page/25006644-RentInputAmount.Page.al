Page 25006644 "Rent Input Amount"
{
    Caption = 'Rent Amount';
    PageType = StandardDialog;

    layout
    {
        area(content)
        {
            group(Control2)
            {
                field(RentAmt; RentAmt)
                {
                    ApplicationArea = Basic;
                    Caption = 'Rent Amount';
                    Editable = false;
                }
                field(DepositAmt; DepositAmt)
                {
                    ApplicationArea = Basic;
                    Caption = 'Deposit Amount';
                    Visible = IsDeposit;
                }
                field(AdvanceAmt; AdvanceAmt)
                {
                    ApplicationArea = Basic;
                    Caption = 'Advance Amount';
                    Visible = IsAdvance;
                }
            }
        }
    }

    actions
    {
    }

    var
        DepositAmt: Decimal;
        AdvanceAmt: Decimal;
        RentAmt: Decimal;
        IsDeposit: Boolean;
        IsAdvance: Boolean;

    procedure SetDepositAmt(DepositAmtPar: Decimal)
    begin
        DepositAmt := DepositAmtPar;
        IsDeposit := true;
    end;

    procedure SetAdvanceAmt(AdvanceAmtPar: Decimal)
    begin
        AdvanceAmt := AdvanceAmtPar;
        IsAdvance := true;
    end;

    procedure GetDepositAmt(): Decimal
    begin
        exit(DepositAmt);
    end;

    procedure GetAdvanceAmt(): Decimal
    begin
        exit(AdvanceAmt);
    end;

    procedure SetRentAmt(RentAmtPar: Decimal)
    begin
        RentAmt := RentAmtPar;
    end;
}

