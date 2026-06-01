Codeunit 25006313 "Vehicle Opt. Reg.-Show Ledger"
{
    // 12.07.2004 EDMS P1
    //   * created

    TableNo = "Vehicle Option Register";

    trigger OnRun()
    begin
        recVehOptLedger.SetRange("Entry No.", Rec."From Entry No.", Rec."To Entry No.");
        Page.Run(Page::"Vehicle Opt. Ledger Entries", recVehOptLedger);
    end;

    var
        recVehOptLedger: Record "Vehicle Opt. Ledger Entry";
}

