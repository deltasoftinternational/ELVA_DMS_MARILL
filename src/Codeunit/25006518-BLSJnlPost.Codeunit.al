Codeunit 25006518 "BLS Jnl.-Post"
{
    TableNo = "BLS Journal Line";

    trigger OnRun()
    begin
        BLSJnlLine.Copy(Rec);
        Code;
        Rec.Copy(BLSJnlLine);
    end;

    var
        BLSJnlTemplate: Record "BLS Journal Template";
        BLSJnlLine: Record "BLS Journal Line";
        BLSJnlPostBatch: Codeunit "BLS Jnl.-Post Batch";
        TempJnlBatchName: Code[10];
        Text000: label 'cannot be filtered when posting recurring journals';
        Text001: label 'Do you want to post the journal lines?';
        Text002: label 'There is nothing to post.';
        Text003: label 'The journal lines were successfully posted.';
        Text004: label 'The journal lines were successfully posted. ';
        Text005: label 'You are now in the %1 journal.';

    local procedure "Code"()
    begin
        BLSJnlTemplate.Get(BLSJnlLine."Journal Template Name");
        BLSJnlTemplate.TestField("Force Posting Report", false);
        if BLSJnlTemplate.Recurring and (BLSJnlLine.GetFilter("Posting Date") <> '') then
            BLSJnlLine.FieldError("Posting Date", Text000);

        if not Confirm(Text001) then
            exit;

        TempJnlBatchName := BLSJnlLine."Journal Batch Name";

        BLSJnlPostBatch.Run(BLSJnlLine);

        if BLSJnlLine."Line No." = 0 then
            Message(Text002)
        else
            if TempJnlBatchName = BLSJnlLine."Journal Batch Name" then
                Message(Text003)
            else
                Message(
                  Text004 +
                  Text005,
                  BLSJnlLine."Journal Batch Name");

        if not BLSJnlLine.Find('=><') or (TempJnlBatchName <> BLSJnlLine."Journal Batch Name") then begin
            BLSJnlLine.Reset;
            BLSJnlLine.FilterGroup(2);
            BLSJnlLine.SetRange("Journal Template Name", BLSJnlLine."Journal Template Name");
            BLSJnlLine.SetRange("Journal Batch Name", BLSJnlLine."Journal Batch Name");
            BLSJnlLine.FilterGroup(0);
            BLSJnlLine."Line No." := 1;
        end;
    end;
}

