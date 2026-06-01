Codeunit 25006128 "Service Jnl.-Post+Print"
{
    TableNo = "Serv. Journal Line";

    trigger OnRun()
    begin
        ServiceJnlLine.Copy(Rec);
        Code;
        Rec.Copy(ServiceJnlLine);
    end;

    var
        ServiceJnlTemplate: Record "Serv. Journal Template";
        ServiceJnlLine: Record "Serv. Journal Line";
        ServiceReg: Record "Service Register";
        ServiceJnlPostBatch: Codeunit "Serv. Jnl.-Post Batch";
        TempJnlBatchName: Code[10];
        Text001: label 'Do you want to post the journal lines and print the posting report?';
        Text002: label 'There is nothing to post.';
        Text003: label 'The journal lines were successfully posted.';
        Text004: label 'The journal lines were successfully posted. ';
        Text005: label 'You are now in the %1 journal.';

    local procedure "Code"()
    begin
        ServiceJnlTemplate.Get(ServiceJnlLine."Journal Template Name");
        ServiceJnlTemplate.TestField("Posting Report ID");

        if not Confirm(Text001) then
            exit;

        TempJnlBatchName := ServiceJnlLine."Journal Batch Name";

        ServiceJnlPostBatch.Run(ServiceJnlLine);

        if ServiceReg.Get(ServiceJnlLine."Line No.") then begin
            ServiceReg.SetRecfilter;
            Report.Run(ServiceJnlTemplate."Posting Report ID", false, false, ServiceReg);
        end;

        if ServiceJnlLine."Line No." = 0 then
            Message(Text002)
        else
            if TempJnlBatchName = ServiceJnlLine."Journal Batch Name" then
                Message(Text003)
            else
                Message(
                  Text004 +
                  Text005,
                  ServiceJnlLine."Journal Batch Name");

        if not ServiceJnlLine.FindSet or (TempJnlBatchName <> ServiceJnlLine."Journal Batch Name") then begin
            ServiceJnlLine.Reset;
            ServiceJnlLine.FilterGroup(2);
            ServiceJnlLine.SetRange("Journal Template Name", ServiceJnlLine."Journal Template Name");
            ServiceJnlLine.SetRange("Journal Batch Name", ServiceJnlLine."Journal Batch Name");
            ServiceJnlLine.FilterGroup(0);
            ServiceJnlLine."Line No." := 1;
        end;
    end;
}

