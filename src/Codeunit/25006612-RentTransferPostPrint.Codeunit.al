Codeunit 25006612 "RentTransfer-Post + Print"
{
    TableNo = "Transfer Header";

    trigger OnRun()
    begin
        TransHeader.Copy(Rec);
        Code;
        Rec := TransHeader;
    end;

    var
        Text000: label '&Ship,&Receive';
        TransHeader: Record "Transfer Header";
        TransShptHeader: Record "Transfer Shipment Header";
        TransRcptHeader: Record "Transfer Receipt Header";

    local procedure "Code"()
    var
        TransLine: Record "Transfer Line";
        DefaultNumber: Option " ",Shipment,Receipt;
        TransferPostShipment: Codeunit "TransferOrder-Post Shipment";
        TransferPostReceipt: Codeunit "TransferOrder-Post Receipt";
        Selection: Option " ",Shipment,Receipt;
    begin
        TransLine.SetRange("Document No.", TransHeader."No.");
        if TransLine.Find('-') then begin
            repeat
                if (TransLine."Quantity Shipped" < TransLine.Quantity) and
                   (DefaultNumber = Defaultnumber::" ") then
                    DefaultNumber := Defaultnumber::Shipment;
                if (TransLine."Quantity Received" < TransLine.Quantity) and
                   (DefaultNumber = Defaultnumber::" ") then
                    DefaultNumber := Defaultnumber::Receipt;
            until (TransLine.Next = 0) or (DefaultNumber > 0);
        end;
        if DefaultNumber = 0 then
            DefaultNumber := 1;
        Selection := StrMenu(Text000, DefaultNumber);
        case Selection of
            0:
                exit;
            1:
                begin
                    TransferPostShipment.Run(TransHeader);
                    TransShptHeader."No." := TransHeader."Last Shipment No.";
                    TransShptHeader.SetRecfilter;
                    TransShptHeader.PrintRecords(false);
                end;
            2:
                begin
                    TransferPostReceipt.Run(TransHeader);
                    TransRcptHeader."No." := TransHeader."Last Receipt No.";
                    TransRcptHeader.SetRecfilter;
                    TransRcptHeader.PrintRecords(false);
                end;
        end;
    end;
}

