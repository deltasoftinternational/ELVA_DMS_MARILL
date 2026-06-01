Codeunit 25006323 "Item Ledger Entry-Veh. Reserve"
{
    Permissions = TableData "Reservation Entry" = rimd;

    trigger OnRun()
    begin
    end;


    procedure FilterReservFor(var FilterReservEntry: Record "Reservation Entry"; ItemLedgEntry: Record "Item Ledger Entry")
    begin
        FilterReservEntry.SetRange("Source Type", Database::"Item Ledger Entry");
        FilterReservEntry.SetRange("Source Subtype", 0);
        FilterReservEntry.SetRange("Source ID", '');
        FilterReservEntry.SetRange("Source Batch Name", '');
        FilterReservEntry.SetRange("Source Ref. No.", ItemLedgEntry."Entry No.");
    end;
}

