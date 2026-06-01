Codeunit 25006881 "Token Management"
{

    trigger OnRun()
    begin
    end;

    var
        Text001: label 'Service is not available, token balance = %1;';


    procedure CheckTokens(Quantity: Integer; ServiceCode: Code[20]; var ErrorMsg: Text) ServiceAvailable: Boolean
    var
        ThirdPartiesService: Record "3rd Parties Services";
        TokenLedger: Record "Token Ledger";
    begin
        ServiceAvailable := false;
        ErrorMsg := '';
        ThirdPartiesService.Get(ServiceCode);
        if not ThirdPartiesService."Tokens Enabled" then begin
            ServiceAvailable := true;
            exit;
        end;
        TokenLedger.Reset;
        TokenLedger.CalcSums("Token Qty.");
        if (TokenLedger."Token Qty." - ThirdPartiesService.Price * Quantity) < 0 then begin
            ServiceAvailable := false;
            ErrorMsg := StrSubstNo(Text001, Format(TokenLedger."Token Qty."));
        end else
            ServiceAvailable := true;
    end;


    procedure RegisterSpentTokens(OperationCount: Integer; ServiceCode: Code[20]; OperationNo: Code[20])
    var
        n: Integer;
        ThirdPartiesService: Record "3rd Parties Services";
        TokenLedger: Record "Token Ledger";
    begin
        ThirdPartiesService.Get(ServiceCode);
        if not ThirdPartiesService."Tokens Enabled" then
            exit;

        TokenLedger.Reset;
        n := 1;
        if TokenLedger.FindLast then
            n := TokenLedger."Entry No." + 1;
        TokenLedger.Init;
        TokenLedger."Entry No." := n;
        TokenLedger."Service Code" := ServiceCode;
        TokenLedger."Operation No." := OperationNo;
        TokenLedger.Description := ThirdPartiesService.Description;
        TokenLedger."Operation Count" := -OperationCount;
        TokenLedger."Token Qty." := -OperationCount * ThirdPartiesService.Price;
        TokenLedger.Date := Today;
        TokenLedger.Time := Time;
        TokenLedger."User ID" := UserId;
        TokenLedger.Insert;
    end;
}

