Codeunit 25006604 "Rent Jnl.-Post"
{
    TableNo = "Rent Journal Line";

    trigger OnRun()
    begin
        RentJnlLine.Copy(Rec);
        Code;
        Rec.Copy(RentJnlLine);
    end;

    var
        Text000: label 'cannot be filtered when posting recurring journals';
        Text001: label 'Do you want to post the journal lines?';
        Text002: label 'There is nothing to post.';
        Text003: label 'The journal lines were successfully posted.';
        Text004: label 'The journal lines were successfully posted. ';
        Text005: label 'You are now in the %1 journal.';
        RentJnlTemplate: Record "Rent Journal Template";
        RentJnlLine: Record "Rent Journal Line";
        RentJnlPostBatch: Codeunit "Rent Jnl.-Post Batch";
        TempJnlBatchName: Code[10];

    local procedure "Code"()
    begin
        RentJnlTemplate.Get(RentJnlLine."Journal Template Name");
        RentJnlTemplate.TestField("Force Posting Report", false);
        if RentJnlTemplate.Recurring and (RentJnlLine.GetFilter("Posting Date") <> '') then
            RentJnlLine.FieldError("Posting Date", Text000);

        if not Confirm(Text001) then
            exit;

        TempJnlBatchName := RentJnlLine."Journal Batch Name";

        RentJnlPostBatch.Run(RentJnlLine);

        if RentJnlLine."Line No." = 0 then
            Message(Text002)
        else
            if TempJnlBatchName = RentJnlLine."Journal Batch Name" then
                Message(Text003)
            else
                Message(
                  Text004 +
                  Text005,
                  RentJnlLine."Journal Batch Name");

        if not RentJnlLine.Find('=><') or (TempJnlBatchName <> RentJnlLine."Journal Batch Name") then begin
            RentJnlLine.Reset;
            RentJnlLine.FilterGroup(2);
            RentJnlLine.SetRange("Journal Template Name", RentJnlLine."Journal Template Name");
            RentJnlLine.SetRange("Journal Batch Name", RentJnlLine."Journal Batch Name");
            RentJnlLine.FilterGroup(0);
            RentJnlLine."Line No." := 1;
        end;
    end;
}

