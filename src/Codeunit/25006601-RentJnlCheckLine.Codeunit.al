Codeunit 25006601 "Rent Jnl.-Check Line"
{
    TableNo = "Rent Journal Line";

    trigger OnRun()
    begin
    end;

    var
        Text000: label 'cannot be a closing date';
        Text001: label 'is not within your range of allowed posting dates';
        Text002: label 'The combination of dimensions used in %1 %2, %3, %4 is blocked. %5';
        Text003: label 'A dimension used in %1 %2, %3, %4 has caused an error. %5';
        GLSetup: Record "General Ledger Setup";
        UserSetup: Record "User Setup";
        DimMgt: Codeunit DimensionManagement;
        AllowPostingFrom: Date;
        AllowPostingTo: Date;
        NotAvailableInLocationErr: label 'Rent Asset %1 Not Available in Location %2 %3 Units';
        Text004: Label 'For adjustment posting Entry Type must be Inventory. Line No.: %1';
        ErrAlreadyInStock: Label 'Rent Asset %1 is individual asset and it already has positive entry.';



    procedure RunCheck(var RentJnlLine: Record "Rent Journal Line")
    var
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        RentAsset: Record "Rent Asset";
        RentLedgerEntries: Record "Rent Ledger Entry";
    begin

        //>>DELTA RC
        OnBeforeRunCheckRentJnlLine(RentJnlLine);
        //<<DELTA RC

        CheckAvailability(RentJnlLine);

        if (RentJnlLine."Document Type" = RentJnlLine."Document Type"::"Positive Adjmt.") or (RentJnlLine."Document Type" = RentJnlLine."Document Type"::"Negative Adjmt.") then begin
            If RentJnlLine."Entry Type" <> RentJnlLine."Entry Type"::Inventory then
                Error(Text004, RentJnlLine."Line No.");
            RentJnlLine.Testfield("Location Code");
            RentJnlLine.TestField(Quantity);
            RentJnlLine.TestField("Rent Asset No.");
            RentJnlLine.TestField("Document Date");
            RentJnlLine.TestField("Posting Date");
        end;

        if (RentJnlLine."Document Type" = RentJnlLine."Document Type"::"Positive Adjmt.") and (RentJnlLine."Document Type" = RentJnlLine."Document Type"::Receipt) then begin
            If RentAsset.Get(RentJnlLine."Rent Asset No.") then
                if RentAsset."Asset Type" = RentAsset."Asset Type"::Individual then begin
                    RentLedgerEntries.Reset;
                    RentLedgerEntries.SetRange("Rent Asset No.", RentJnlLine."Rent Asset No.");
                    RentLedgerEntries.SetRange(Open, true);
                    If RentLedgerEntries.FindFirst then
                        Error(ErrAlreadyInStock, RentJnlLine."Rent Asset No.");
                end;
        end;
    end;

    local procedure CheckAvailability(RentJnlLine: Record "Rent Journal Line")
    var
        RentLedgerEntry: Record "Rent Ledger Entry";
    begin
        //DELTA RC
        //if RentJnlLine."Entry Type" <> RentJnlLine."entry type"::Cost then
        //    exit;
        if RentJnlLine."Entry Type" <> RentJnlLine."entry type"::Inventory then
            exit;
        if (RentJnlLine."Document Type" = RentJnlLine."Document Type"::"Negative Adjmt.") or
          (RentJnlLine."Document Type" = RentJnlLine."Document Type"::Shipment) then begin
            //<<DELTA RC

            RentLedgerEntry.Reset;
            RentLedgerEntry.SetRange(RentLedgerEntry."Entry Type", RentLedgerEntry."entry type"::Inventory);
            RentLedgerEntry.SetRange("Rent Asset No.", RentJnlLine."Rent Asset No.");
            RentLedgerEntry.SetRange("Location Code", RentJnlLine."Location Code");
            RentLedgerEntry.CalcSums(Quantity);
            if (RentLedgerEntry.Quantity - RentJnlLine.Quantity) < 0 then
                Error(NotAvailableInLocationErr, RentJnlLine."Rent Asset No.", RentJnlLine."Location Code", RentLedgerEntry.Quantity);
        end;
    end;


    //>>DELTA RC
    [IntegrationEvent(false, false)]
    local procedure OnBeforeRunCheckRentJnlLine(var RentJnlLine: Record "Rent Journal Line")
    begin
    end;
    //<<DELTA RC    
}

