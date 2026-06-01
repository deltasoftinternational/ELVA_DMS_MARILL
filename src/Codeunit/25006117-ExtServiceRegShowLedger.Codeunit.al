Codeunit 25006117 "Ext. Service Reg.-Show Ledger"
{
    TableNo = "External Service Register";

    trigger OnRun()
    begin

        ExtServiceLedgEntry.SetRange("Entry No.", Rec."From Entry No.", Rec."To Entry No.");

        Page.Run(Page::"Ext. Service Ledger Entries", ExtServiceLedgEntry);
    end;

    var
        ExtServiceLedgEntry: Record "External Serv. Ledger Entry";
}

