Codeunit 25006309 "Vehicle Opt. Jnl.-Post"
{
    // //==================================================================================================================================
    // Mērķis: Žurnāla grāmatošanas pamata jeb sākuma koda bloks
    // //==================================================================================================================================

    TableNo = "Vehicle Opt. Jnl. Line";

    trigger OnRun()
    begin
        recVehOptJnlLine.Copy(Rec);
        fCode;
        Rec.Copy(recVehOptJnlLine);
    end;

    var
        Text001: label 'Do you want to post the journal lines?';
        Text002: label 'There is nothing to post.';
        Text003: label 'The journal lines were successfully posted.';
        Text004: label 'The journal lines were successfully posted. ';
        Text005: label 'You are now in the %1 journal.';
        recVehOptJnlTemplate: Record "Vehicle Opt. Jnl. Template";
        recVehOptJnlLine: Record "Vehicle Opt. Jnl. Line";
        cuVehOptJnlPostBatch: Codeunit "Vehicle Opt. Jnl.-Post Batch";
        codTempJnlBatchName: Code[10];

    local procedure fCode()
    begin
        recVehOptJnlTemplate.Get(recVehOptJnlLine."Journal Template Name");
        recVehOptJnlTemplate.TestField("Force Posting Report", false);

        if not Confirm(Text001, false) then
            exit;

        codTempJnlBatchName := recVehOptJnlLine."Journal Batch Name";

        cuVehOptJnlPostBatch.Run(recVehOptJnlLine);

        if recVehOptJnlLine."Line No." = 0 then
            Message(Text002)
        else
            if codTempJnlBatchName = recVehOptJnlLine."Journal Batch Name" then
                Message(Text003)
            else
                Message(
                  Text004 +
                  Text005,
                  recVehOptJnlLine."Journal Batch Name");

        if not recVehOptJnlLine.FindSet or (codTempJnlBatchName <> recVehOptJnlLine."Journal Batch Name") then begin
            recVehOptJnlLine.Reset;
            recVehOptJnlLine.FilterGroup(2);
            recVehOptJnlLine.SetRange("Journal Template Name", recVehOptJnlLine."Journal Template Name");
            recVehOptJnlLine.SetRange("Journal Batch Name", recVehOptJnlLine."Journal Batch Name");
            recVehOptJnlLine.FilterGroup(0);
            recVehOptJnlLine."Line No." := 1;
        end;
    end;
}

