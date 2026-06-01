Codeunit 25006217 "Warranty Jnl.-Post+Print"
{
    TableNo = "Warranty Journal Line";

    trigger OnRun()
    begin
        WarrantyJnlLine.Copy(Rec);
        Code;
        Rec.Copy(WarrantyJnlLine);
    end;

    var
        WarrantyJnlTemplate: Record "Warranty Journal Template";
        WarrantyJnlLine: Record "Warranty Journal Line";
        WarrantyReg: Record "Warranty Reimb. Register";
        WarrantyJnlPostBatch: Codeunit "Warranty Jnl.-Post Batch";
        TempJnlBatchName: Code[10];
        Text001: label 'Do you want to post the journal lines and print the posting report?';
        Text002: label 'There is nothing to post.';
        Text003: label 'The journal lines were successfully posted.';
        Text004: label 'The journal lines were successfully posted. ';
        Text005: label 'You are now in the %1 journal.';

    local procedure "Code"()
    begin
        WarrantyJnlTemplate.Get(WarrantyJnlLine."Journal Template Name");
        WarrantyJnlTemplate.TestField("Posting Report ID");

        if not Confirm(Text001) then
            exit;

        TempJnlBatchName := WarrantyJnlLine."Journal Batch Name";

        WarrantyJnlPostBatch.Run(WarrantyJnlLine);

        if WarrantyReg.Get(WarrantyJnlLine."Line No.") then begin
            WarrantyReg.SetRecfilter;
            Report.Run(WarrantyJnlTemplate."Posting Report ID", false, false, WarrantyReg);
        end;

        if WarrantyJnlLine."Line No." = 0 then
            Message(Text002)
        else
            if TempJnlBatchName = WarrantyJnlLine."Journal Batch Name" then
                Message(Text003)
            else
                Message(
                  Text004 +
                  Text005,
                  WarrantyJnlLine."Journal Batch Name");

        if not WarrantyJnlLine.FindSet or (TempJnlBatchName <> WarrantyJnlLine."Journal Batch Name") then begin
            WarrantyJnlLine.Reset;
            WarrantyJnlLine.FilterGroup(2);
            WarrantyJnlLine.SetRange("Journal Template Name", WarrantyJnlLine."Journal Template Name");
            WarrantyJnlLine.SetRange("Journal Batch Name", WarrantyJnlLine."Journal Batch Name");
            WarrantyJnlLine.FilterGroup(0);
            WarrantyJnlLine."Line No." := 1;
        end;
    end;
}

