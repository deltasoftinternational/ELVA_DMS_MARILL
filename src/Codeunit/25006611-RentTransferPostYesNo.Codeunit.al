Codeunit 25006611 "RentTransfer-Post (Yes/No)"
{
    TableNo = "Rent Transfer Header";

    trigger OnRun()
    begin
        TransHeader.Copy(Rec);
        Code;
        Rec := TransHeader;
    end;

    var
        Text000: label '&Ship,&Receive';
        TransHeader: Record "Rent Transfer Header";
        Text101: label 'S&hip && Receive,&Ship,&Receive';
        Text001: label 'Do you want to post the %1?';
        Text002: label 'Rent Transfer Order';

    local procedure "Code"()
    var
        TransferPost: Codeunit "RentTransfer-Post";
        Selection: Option " ",Shipment,Receipt;
        DefaultNumber: Option " ",Shipment,Receipt;
    begin
        if Confirm(Text001, false, Text002) then begin
            TransferPost.Run(TransHeader);
        end;
    end;
}

