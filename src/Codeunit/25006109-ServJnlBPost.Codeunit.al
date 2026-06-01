Codeunit 25006109 "Serv. Jnl.-B.Post"
{
    TableNo = "Serv. Journal Batch";

    trigger OnRun()
    begin
        ServJnlBatch.Copy(Rec);
        Code;
        Rec := ServJnlBatch;
    end;

    var
        Text000: label 'Do you want to post the journals?';
        Text001: label 'The journals were successfully posted.';
        Text002: label 'It was not possible to post all of the journals. ';
        Text003: label 'The journals that were not successfully posted are now marked.';
        ServJnlTemplate: Record "Serv. Journal Template";
        ServJnlBatch: Record "Serv. Journal Batch";
        ServJnlLine: Record "Serv. Journal Line";
        ServJnlPostBatch: Codeunit "Serv. Jnl.-Post Batch";
        JnlWithErrors: Boolean;

    local procedure "Code"()
    begin
        ServJnlTemplate.Get(ServJnlBatch."Journal Template Name");
        ServJnlTemplate.TestField("Force Posting Report", false);

        if not Confirm(Text000) then
            exit;

        ServJnlBatch.FindSet;
        repeat
            ServJnlLine."Journal Template Name" := ServJnlBatch."Journal Template Name";
            ServJnlLine."Journal Batch Name" := ServJnlBatch.Name;
            ServJnlLine."Line No." := 1;
            Clear(ServJnlPostBatch);
            if ServJnlPostBatch.Run(ServJnlLine) then
                ServJnlBatch.Mark(false)
            else begin
                ServJnlBatch.Mark(true);
                JnlWithErrors := true;
            end;
        until ServJnlBatch.Next = 0;

        if not JnlWithErrors then
            Message(Text001)
        else
            Message(
              Text002 +
              Text003);

        if not ServJnlBatch.FindSet then begin
            ServJnlBatch.Reset;
            ServJnlBatch.FilterGroup(2);
            ServJnlBatch.SetRange("Journal Template Name", ServJnlBatch."Journal Template Name");
            ServJnlBatch.FilterGroup(0);
            ServJnlBatch.Name := '';
        end;
    end;
}

