Codeunit 25006519 "BLS Jnl.-B.Post"
{
    TableNo = "BLS Journal Batch";

    trigger OnRun()
    begin
        BLSJnlBatch.Copy(Rec);
        Code;
        Rec := BLSJnlBatch;
    end;

    var
        BLSJnlTemplate: Record "BLS Journal Template";
        BLSJnlBatch: Record "BLS Journal Batch";
        BLSJnlLine: Record "BLS Journal Line";
        BLSJnlPostBatch: Codeunit "BLS Jnl.-Post Batch";
        JnlWithErrors: Boolean;
        Text000: label 'Do you want to post the journals?';
        Text001: label 'The journals were successfully posted.';
        Text002: label 'It was not possible to post all of the journals. ';
        Text003: label 'The journals that were not successfully posted are now marked.';

    local procedure "Code"()
    begin
        BLSJnlTemplate.Get(BLSJnlBatch."Journal Template Name");
        BLSJnlTemplate.TestField("Force Posting Report", false);

        if not Confirm(Text000) then
            exit;

        BLSJnlBatch.Find('-');
        repeat
            BLSJnlLine."Journal Template Name" := BLSJnlBatch."Journal Template Name";
            BLSJnlLine."Journal Batch Name" := BLSJnlBatch.Name;
            BLSJnlLine."Line No." := 1;
            Clear(BLSJnlPostBatch);
            if BLSJnlPostBatch.Run(BLSJnlLine) then
                BLSJnlBatch.Mark(false)
            else begin
                BLSJnlBatch.Mark(true);
                JnlWithErrors := true;
            end;
        until BLSJnlBatch.Next = 0;

        if not JnlWithErrors then
            Message(Text001)
        else
            Message(
              Text002 +
              Text003);

        if not BLSJnlBatch.Find('=><') then begin
            BLSJnlBatch.Reset;
            BLSJnlBatch.FilterGroup(2);
            BLSJnlBatch.SetRange("Journal Template Name", BLSJnlBatch."Journal Template Name");
            BLSJnlBatch.FilterGroup(0);
            BLSJnlBatch.Name := '';
        end;
    end;
}

