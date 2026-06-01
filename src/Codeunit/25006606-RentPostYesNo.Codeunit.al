Codeunit 25006606 "Rent-Post (Yes/No)"
{
    TableNo = "Rent Header";

    trigger OnRun()
    begin
        RentHeader.Copy(Rec);
        Code;
        Rec := RentHeader;
    end;

    var
        RentPost: Codeunit "Rent-Post";
        RentHeader: Record "Rent Header";
        Text001: label 'Do you want to post the %1?';


    procedure "Code"()
    var
        ReleaseServDoc: Codeunit "Release Service Document EDMS";
    begin
        case RentHeader."Document Type" of
            RentHeader."document type"::Order:
                if Confirm(Text001, false, RentHeader."Document Type") then begin
                    RentPost.Run(RentHeader);
                end;
            RentHeader."document type"::"Return Order":
                if Confirm(Text001, false, RentHeader."Document Type") then begin
                    RentPost.Run(RentHeader);
                end;
        end
    end;
}

