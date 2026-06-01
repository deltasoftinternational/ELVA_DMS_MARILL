Codeunit 25006126 "Serv. Jnl.-Post"
{
    TableNo = "Serv. Journal Line";

    trigger OnRun()
    begin
        JnlLine.Copy(Rec);
        Code;
        Rec.Copy(JnlLine);
    end;

    var
        Text000: label 'cannot be filtered when posting recurring journals';
        Text001: label 'Do you want to post the journal lines?';
        Text002: label 'There is nothing to post.';
        Text003: label 'The journal lines were successfully posted.';
        Text004: label 'The journal lines were successfully posted. ';
        Text005: label 'You are now in the %1 journal.';
        JnlTemplate: Record "Serv. Journal Template";
        JnlLine: Record "Serv. Journal Line";
        JnlPostBatch: Codeunit "Serv. Jnl.-Post Batch";
        TempJnlBatchName: Code[10];

    local procedure "Code"()
    begin
        JnlTemplate.Get(JnlLine."Journal Template Name");
        JnlTemplate.TestField("Force Posting Report", false);
        if JnlTemplate.Recurring and (JnlLine.GetFilter("Posting Date") <> '') then
            JnlLine.FieldError("Posting Date", Text000);

        if not Confirm(Text001, false) then
            exit;

        TempJnlBatchName := JnlLine."Journal Batch Name";

        JnlPostBatch.Run(JnlLine);

        if JnlLine."Line No." = 0 then
            Message(Text002)
        else
            if TempJnlBatchName = JnlLine."Journal Batch Name" then
                Message(Text003)
            else
                Message(
                  Text004 +
                  Text005,
                  JnlLine."Journal Batch Name");

        if not JnlLine.FindSet or (TempJnlBatchName <> JnlLine."Journal Batch Name") then begin
            JnlLine.Reset;
            JnlLine.FilterGroup(2);
            JnlLine.SetRange("Journal Template Name", JnlLine."Journal Template Name");
            JnlLine.SetRange("Journal Batch Name", JnlLine."Journal Batch Name");
            JnlLine.FilterGroup(0);
            JnlLine."Line No." := 1;
        end;
    end;
}

