Codeunit 25006880 "Token API"
{

    trigger OnRun()
    begin
    end;


    procedure TopUpTokens(Amount: Decimal; DocumentNo: Code[20]) Balance: Decimal
    var
        CommunicationTokenLedger: Record "Token Ledger";
        n: Integer;
    begin
        CommunicationTokenLedger.Reset;

        n := 1;
        if CommunicationTokenLedger.FindLast then
            n := CommunicationTokenLedger."Entry No." + 1;

        CommunicationTokenLedger.Init;
        CommunicationTokenLedger."Entry No." := n;
        CommunicationTokenLedger."Token Qty." := Amount;
        CommunicationTokenLedger.Description := 'Top-up';
        CommunicationTokenLedger.Date := Today;
        CommunicationTokenLedger.Time := Time;
        CommunicationTokenLedger."Operation Count" := 1;
        CommunicationTokenLedger."Service Code" := 'TOP-UP';
        CommunicationTokenLedger."Operation No." := DocumentNo;
        CommunicationTokenLedger."User ID" := UserId;
        CommunicationTokenLedger.Insert;

        CommunicationTokenLedger.Reset;
        CommunicationTokenLedger.CalcSums("Token Qty.");
        Balance := CommunicationTokenLedger."Token Qty.";
    end;


    procedure GetCurrentBalance() Balance: Decimal
    var
        CommunicationTokenLedger: Record "Token Ledger";
    begin
        CommunicationTokenLedger.Reset;
        CommunicationTokenLedger.CalcSums("Token Qty.");
        Balance := CommunicationTokenLedger."Token Qty.";
    end;
}

