Codeunit 25006311 "Vehicle Opt. Jnl.-B.Post"
{
    // //==================================================================================================================================
    // Mērķis: Žrnāla grāmatošanas pamata jeb sākuma koda bloks - no žurnāla iedaļām
    // 
    // //==================================================================================================================================

    TableNo = "Vehicle Opt. Jnl. Batch";

    trigger OnRun()
    begin
        recVehOptJnlBatch.Copy(Rec);
        fCode;
        Rec.Copy(recVehOptJnlBatch);
    end;

    var
        Text000: label 'Do you want to post the journals?';
        Text001: label 'The journals were successfully posted.';
        Text002: label 'It was not possible to post all of the journals. ';
        Text003: label 'The journals that were not successfully posted are now marked.';
        recVehOptJnlTemplate: Record "Vehicle Opt. Jnl. Template";
        recVehOptJnlBatch: Record "Vehicle Opt. Jnl. Batch";
        recVehOptJnlLine: Record "Vehicle Opt. Jnl. Line";
        cuVehOptJnlPostBatch: Codeunit "Vehicle Opt. Jnl.-Post Batch";
        bJnlWithErrors: Boolean;

    local procedure fCode()
    begin
        recVehOptJnlTemplate.Get(recVehOptJnlBatch."Journal Template Name");
        recVehOptJnlTemplate.TestField("Force Posting Report", false);

        if not Confirm(Text000, false) then
            exit;

        recVehOptJnlBatch.FindSet;
        repeat
            recVehOptJnlLine."Journal Template Name" := recVehOptJnlBatch."Journal Template Name";
            recVehOptJnlLine."Journal Batch Name" := recVehOptJnlBatch.Name;
            recVehOptJnlLine."Line No." := 1;
            Clear(cuVehOptJnlPostBatch);
            if cuVehOptJnlPostBatch.Run(recVehOptJnlLine) then
                recVehOptJnlBatch.Mark(false)
            else begin
                recVehOptJnlBatch.Mark(true);
                bJnlWithErrors := true;
            end;
        until recVehOptJnlBatch.Next = 0;

        if not bJnlWithErrors then
            Message(Text001)
        else
            Message(
              Text002 +
              Text003);

        if not recVehOptJnlBatch.FindSet then begin
            recVehOptJnlBatch.Reset;
            recVehOptJnlBatch.FilterGroup(2);
            recVehOptJnlBatch.SetRange("Journal Template Name", recVehOptJnlBatch."Journal Template Name");
            recVehOptJnlBatch.FilterGroup(0);
            recVehOptJnlBatch.Name := '';
        end;
    end;
}

