Codeunit 25006115 "Ext. Service Jnl.-B.Post"
{
    TableNo = "External Serv. Journal Batch";

    trigger OnRun()
    begin
        ExtServiceJnlBatch.Copy(Rec);
        Code;
        Rec := ExtServiceJnlBatch;
    end;

    var
        ExtServiceJnlTemplate: Record "Ext. Service Journal Template";
        ExtServiceJnlBatch: Record "External Serv. Journal Batch";
        ExtServiceJnlLine: Record "External Serv. Journal Line";
        ExtServiceJnlPostBatch: Codeunit "Ext. Service Jnl.-Post Batch";
        JnlWithErrors: Boolean;
        Text000: label 'Do you want to post the journals?';
        Text001: label 'The journals were successfully posted.';
        Text002: label 'It was not possible to post all of the journals. ';
        Text003: label 'The journals that were not successfully posted are now marked.';

    local procedure "Code"()
    begin
        ExtServiceJnlTemplate.Get(ExtServiceJnlBatch."Journal Template Name");
        ExtServiceJnlTemplate.TestField("Force Posting Report", false);

        if not Confirm(Text000) then
            exit;

        ExtServiceJnlBatch.FindSet;
        repeat
            ExtServiceJnlLine."Journal Template Name" := ExtServiceJnlBatch."Journal Template Name";
            ExtServiceJnlLine."Journal Batch Name" := ExtServiceJnlBatch.Name;
            ExtServiceJnlLine."Line No." := 1;
            Clear(ExtServiceJnlPostBatch);
            if ExtServiceJnlPostBatch.Run(ExtServiceJnlLine) then
                ExtServiceJnlBatch.Mark(false)
            else begin
                ExtServiceJnlBatch.Mark(true);
                JnlWithErrors := true;
            end;
        until ExtServiceJnlBatch.Next = 0;

        if not JnlWithErrors then
            Message(Text001)
        else
            Message(
              Text002 +
              Text003);

        if not ExtServiceJnlBatch.FindSet then begin
            ExtServiceJnlBatch.Reset;
            ExtServiceJnlBatch.FilterGroup(2);
            ExtServiceJnlBatch.SetRange("Journal Template Name", ExtServiceJnlBatch."Journal Template Name");
            ExtServiceJnlBatch.FilterGroup(0);
            ExtServiceJnlBatch.Name := '';
        end;
    end;
}

