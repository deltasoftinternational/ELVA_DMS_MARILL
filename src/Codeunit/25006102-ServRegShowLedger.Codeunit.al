Codeunit 25006102 "Serv. Reg.-Show Ledger"
{
    TableNo = "Service Register EDMS";

    trigger OnRun()
    begin
        ServLedgEntryEDMS.SetRange("Entry No.", Rec."From Entry No.", Rec."To Entry No.");
        Page.Run(Page::"Service Ledger Entries EDMS", ServLedgEntryEDMS);
    end;

    var
        ServLedgEntryEDMS: Record "Service Ledger Entry EDMS";
}

