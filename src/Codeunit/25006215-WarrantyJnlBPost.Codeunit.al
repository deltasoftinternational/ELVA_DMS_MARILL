Codeunit 25006215 "Warranty Jnl.-B.Post"
{
    TableNo = "Warranty Journal Batch";

    trigger OnRun()
    begin
        WarrantyJnlBatch.Copy(Rec);
        Code;
        Rec := WarrantyJnlBatch;
    end;

    var
        Text000: label 'Do you want to post the journals?';
        Text001: label 'The journals were successfully posted.';
        Text002: label 'It was not possible to post all of the journals. ';
        Text003: label 'The journals that were not successfully posted are now marked.';
        WarrantyJnlTemplate: Record "Warranty Journal Template";
        WarrantyJnlBatch: Record "Warranty Journal Batch";
        WarrantyJnlLine: Record "Warranty Journal Line";
        WarrantyJnlPostBatch: Codeunit "Warranty Jnl.-Post Batch";
        JnlWithErrors: Boolean;

    local procedure "Code"()
    begin
        WarrantyJnlTemplate.Get(WarrantyJnlBatch."Journal Template Name");
        WarrantyJnlTemplate.TestField("Force Posting Report", false);

        if not Confirm(Text000) then
            exit;

        WarrantyJnlBatch.FindSet;
        repeat
            WarrantyJnlLine."Journal Template Name" := WarrantyJnlBatch."Journal Template Name";
            WarrantyJnlLine."Journal Batch Name" := WarrantyJnlBatch.Name;
            WarrantyJnlLine."Line No." := 1;
            Clear(WarrantyJnlPostBatch);
            if WarrantyJnlPostBatch.Run(WarrantyJnlLine) then
                WarrantyJnlBatch.Mark(false)
            else begin
                WarrantyJnlBatch.Mark(true);
                JnlWithErrors := true;
            end;
        until WarrantyJnlBatch.Next = 0;

        if not JnlWithErrors then
            Message(Text001)
        else
            Message(
              Text002 +
              Text003);

        if not WarrantyJnlBatch.FindSet then begin
            WarrantyJnlBatch.Reset;
            WarrantyJnlBatch.FilterGroup(2);
            WarrantyJnlBatch.SetRange("Journal Template Name", WarrantyJnlBatch."Journal Template Name");
            WarrantyJnlBatch.FilterGroup(0);
            WarrantyJnlBatch.Name := '';
        end;
    end;
}

