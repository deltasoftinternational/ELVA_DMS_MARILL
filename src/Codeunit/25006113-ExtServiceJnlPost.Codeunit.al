Codeunit 25006113 "Ext. Service Jnl.-Post"
{
    TableNo = "External Serv. Journal Line";

    trigger OnRun()
    begin
        ExtServiceJnlLine.Copy(Rec);
        Code;
        Rec.Copy(ExtServiceJnlLine);
    end;

    var
        ExtServiceJnlTemplate: Record "Ext. Service Journal Template";
        ExtServiceJnlLine: Record "External Serv. Journal Line";
        ExtServiceJnlPostBatch: Codeunit "Ext. Service Jnl.-Post Batch";
        TempJnlBatchName: Code[10];
        Text001: label 'Do you want to post the journal lines?';
        Text002: label 'There is nothing to post.';
        Text003: label 'The journal lines were successfully posted.';
        Text004: label 'The journal lines were successfully posted. ';
        Text005: label 'You are now in the %1 journal.';

    local procedure "Code"()
    begin
        ExtServiceJnlTemplate.Get(ExtServiceJnlLine."Journal Template Name");
        ExtServiceJnlTemplate.TestField("Force Posting Report", false);

        if not Confirm(Text001) then
            exit;

        TempJnlBatchName := ExtServiceJnlLine."Journal Batch Name";

        ExtServiceJnlPostBatch.Run(ExtServiceJnlLine);

        if ExtServiceJnlLine."Line No." = 0 then
            Message(Text002)
        else
            if TempJnlBatchName = ExtServiceJnlLine."Journal Batch Name" then
                Message(Text003)
            else
                Message(
                  Text004 +
                  Text005,
                  ExtServiceJnlLine."Journal Batch Name");

        if not ExtServiceJnlLine.FindSet or (TempJnlBatchName <> ExtServiceJnlLine."Journal Batch Name") then begin
            ExtServiceJnlLine.Reset;
            ExtServiceJnlLine.FilterGroup(2);
            ExtServiceJnlLine.SetRange("Journal Template Name", ExtServiceJnlLine."Journal Template Name");
            ExtServiceJnlLine.SetRange("Journal Batch Name", ExtServiceJnlLine."Journal Batch Name");
            ExtServiceJnlLine.FilterGroup(0);
            ExtServiceJnlLine."Line No." := 1;
        end;
    end;
}

