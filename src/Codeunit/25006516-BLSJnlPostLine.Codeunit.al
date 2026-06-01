Codeunit 25006516 "BLS Jnl.-Post Line"
{
    Permissions = TableData "BLS Ledger Entry" = imd;
    TableNo = "BLS Journal Line";

    trigger OnRun()
    begin
        GetGLSetup;
        RunWithCheck(Rec);
    end;

    var
        GLSetup: Record "General Ledger Setup";
        BLSJnlLine: Record "BLS Journal Line";
        BLSLedgEntry: Record "BLS Ledger Entry";
        GenPostingSetup: Record "General Posting Setup";
        BLSJnlCheckLine: Codeunit "BLS Jnl.-Check Line";
        NextEntryNo: Integer;
        GLSetupRead: Boolean;


    procedure RunWithCheck(var BLSJnlLine2: Record "BLS Journal Line")
    begin
        BLSJnlLine.Copy(BLSJnlLine2);
        Code;
        BLSJnlLine2 := BLSJnlLine;
    end;

    local procedure "Code"()
    begin
        if BLSJnlLine.EmptyLine then
            exit;

        BLSJnlCheckLine.RunCheck(BLSJnlLine);

        if NextEntryNo = 0 then begin
            BLSLedgEntry.LockTable;
            if BLSLedgEntry.FindLast then
                NextEntryNo := BLSLedgEntry."Entry No.";
            NextEntryNo := NextEntryNo + 1;
        end;

        if BLSJnlLine."Document Date" = 0D then
            BLSJnlLine."Document Date" := BLSJnlLine."Posting Date";

        BLSLedgEntry.Init;
        BLSLedgEntry."Entry No." := NextEntryNo;
        BLSLedgEntry."Journal Template Name" := BLSJnlLine."Journal Template Name";
        BLSLedgEntry."Journal Batch Name" := BLSJnlLine."Journal Batch Name";
        BLSLedgEntry."Line No." := BLSJnlLine."Line No.";
        BLSLedgEntry."Document No." := BLSJnlLine."Document No.";
        BLSLedgEntry."External Document No." := BLSJnlLine."External Document No.";
        BLSLedgEntry."Posting Date" := BLSJnlLine."Posting Date";
        BLSLedgEntry."Document Date" := BLSJnlLine."Document Date";
        BLSLedgEntry.Description := BLSJnlLine.Description;
        BLSLedgEntry."Entry Type" := BLSJnlLine."Entry Type";
        BLSLedgEntry."Contract No." := BLSJnlLine."Contract No.";
        BLSLedgEntry."Customer No." := BLSJnlLine."Customer No.";
        BLSLedgEntry."Customer Name" := BLSJnlLine."Customer Name";
        BLSLedgEntry."Customer Price Group" := BLSJnlLine."Customer Price Group";
        BLSLedgEntry."Customer Discount Group" := BLSJnlLine."Customer Discount Group";
        BLSLedgEntry."Service Code" := BLSJnlLine."Service Code";
        BLSLedgEntry."Service Variant Code" := BLSJnlLine."Service Variant Code";
        BLSLedgEntry."Service Description" := BLSJnlLine."Service Description";
        BLSLedgEntry."Unit of Measure Code" := BLSJnlLine."Unit of Measure Code";
        BLSLedgEntry."Service Group Code" := BLSJnlLine."Service Group Code";
        BLSLedgEntry."Object Code" := BLSJnlLine."Object Code";
        BLSLedgEntry."Object Name" := BLSJnlLine."Object Name";
        BLSLedgEntry."Currency Code" := BLSJnlLine."Currency Code";
        BLSLedgEntry.Quantity := BLSJnlLine.Quantity;
        BLSLedgEntry."Unit Price" := BLSJnlLine."Unit Price";
        BLSLedgEntry."Total Price" := BLSJnlLine."Total Price";
        BLSLedgEntry."Discount, %" := BLSJnlLine."Discount, %";
        BLSLedgEntry."Discount Amount" := BLSJnlLine."Discount Amount";
        BLSLedgEntry."Total Price Incl. Discount" := BLSJnlLine."Total Price Incl. Discount";
        BLSLedgEntry."Source Code" := BLSJnlLine."Source Code";
        BLSLedgEntry."Reason Code" := BLSJnlLine."Reason Code";
        BLSLedgEntry."Vehicle Serial No." := BLSJnlLine."Vehicle Serial No.";
        BLSLedgEntry.Correction := BLSJnlLine.Correction;
        BLSLedgEntry."System-Created Entry" := BLSJnlLine."System-Created Entry";
        BLSLedgEntry."User ID" := UserId;
        BLSLedgEntry."External Contract No." := BLSJnlLine."External Contract No.";

        BLSLedgEntry."Variable Field Run Start 1" := BLSJnlLine."Variable Field Run Start 1";
        BLSLedgEntry."Variable Field Run End 1" := BLSJnlLine."Variable Field Run End 1";

        BLSLedgEntry."Variable Field Run Start 2" := BLSJnlLine."Variable Field Run Start 2";
        BLSLedgEntry."Variable Field Run End 2" := BLSJnlLine."Variable Field Run End 2";

        BLSLedgEntry."Variable Field Run Start 3" := BLSJnlLine."Variable Field Run Start 3";
        BLSLedgEntry."Variable Field Run End 3" := BLSJnlLine."Variable Field Run End 3";

        case BLSLedgEntry."Entry Type" of
            BLSLedgEntry."entry type"::Sale:
                begin
                    BLSLedgEntry."Quantity (Balance)" := -BLSLedgEntry.Quantity;
                    BLSLedgEntry."Total Price (Balance)" := -BLSLedgEntry."Total Price";
                    BLSLedgEntry."Total Price Incl. Disc. (Bal.)" := -BLSLedgEntry."Total Price Incl. Discount";
                end;
            BLSLedgEntry."entry type"::Purchase:
                begin
                    BLSLedgEntry."Quantity (Balance)" := BLSLedgEntry.Quantity;
                    BLSLedgEntry."Total Price (Balance)" := BLSLedgEntry."Total Price";
                    BLSLedgEntry."Total Price Incl. Disc. (Bal.)" := BLSLedgEntry."Total Price Incl. Discount";
                end;
        end;

        BLSLedgEntry.Insert;

        NextEntryNo := NextEntryNo + 1;
    end;

    local procedure GetGLSetup()
    begin
        if not GLSetupRead then
            GLSetup.Get;
        GLSetupRead := true;
    end;
}

