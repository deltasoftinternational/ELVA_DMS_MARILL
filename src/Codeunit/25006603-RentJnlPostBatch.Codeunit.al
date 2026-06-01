Codeunit 25006603 "Rent Jnl.-Post Batch"
{
    Permissions = TableData "Rent Journal Batch" = imd;
    TableNo = "Rent Journal Line";

    trigger OnRun()
    begin
        RentJnlLine.Copy(Rec);
        Code;
        Rec := RentJnlLine;
    end;

    var
        Text000: label 'cannot exceed %1 characters';
        Text001: label 'Journal Batch Name    #1##########\\';
        Text002: label 'Checking lines        #2######\';
        Text003: label 'Posting lines         #3###### @4@@@@@@@@@@@@@\';
        Text004: label 'Updating lines        #5###### @6@@@@@@@@@@@@@';
        Text005: label 'Posting lines         #3###### @4@@@@@@@@@@@@@';
        Text006: label 'A maximum of %1 posting number series can be used in each journal.';
        Text007: label '<Month Text>';
        RentJnlTemplate: Record "Rent Journal Template";
        RentJnlBatch: Record "Rent Journal Batch";
        RentJnlLine: Record "Rent Journal Line";
        RentJnlLine2: Record "Rent Journal Line";
        RentJnlLine3: Record "Rent Journal Line";
        LedgEntryDim: Record "Dimension Set ID Filter Line";
        RentLedgEntry: Record "Rent Ledger Entry";
        RentReg: Record "Rent Register";
        NoSeries: Record "No. Series" temporary;
        RentJnlCheckLine: Codeunit "Rent Jnl.-Check Line";
        RentJnlPostLine: Codeunit "Rent Jnl.-Post Line";
        NoSeriesBatch: Codeunit "No. Series - Batch";
        NoSeriesBatch2: array[10] of Codeunit "No. Series - Batch";
        DimMgt: Codeunit DimensionManagement;
        Window: Dialog;
        RentRegNo: Integer;
        StartLineNo: Integer;
        Day: Integer;
        Week: Integer;
        Month: Integer;
        MonthText: Text[30];
        AccountingPeriod: Record "Accounting Period";
        LineCount: Integer;
        NoOfRecords: Integer;
        LastDocNo: Code[20];
        LastDocNo2: Code[20];
        LastPostedDocNo: Code[20];
        NoOfPostingNoSeries: Integer;
        PostingNoSeriesNo: Integer;
        "0DF": DateFormula;

    local procedure "Code"()
    var
        UpdateAnalysisView: Codeunit "Update Analysis View";
    begin
        RentJnlLine.SetRange("Journal Template Name", RentJnlLine."Journal Template Name");
        RentJnlLine.SetRange("Journal Batch Name", RentJnlLine."Journal Batch Name");
        if RentJnlLine.RECORDLEVELLOCKING then
            RentJnlLine.LockTable;

        RentJnlTemplate.Get(RentJnlLine."Journal Template Name");
        RentJnlBatch.Get(RentJnlLine."Journal Template Name", RentJnlLine."Journal Batch Name");
        if StrLen(IncStr(RentJnlBatch.Name)) > MaxStrLen(RentJnlBatch.Name) then
            RentJnlBatch.FieldError(
              Name,
              StrSubstNo(
                Text000,
                MaxStrLen(RentJnlBatch.Name)));

        if not RentJnlLine.Find('=><') then begin
            RentJnlLine."Line No." := 0;
            Commit;
            exit;
        end;

        if RentJnlTemplate.Recurring then
            Window.Open(
              Text001 +
              Text002 +
              Text003 +
              Text004)
        else
            Window.Open(
              Text001 +
              Text002 +
              Text005);
        Window.Update(1, RentJnlLine."Journal Batch Name");

        // Check lines
        LineCount := 0;
        StartLineNo := RentJnlLine."Line No.";
        repeat
            LineCount := LineCount + 1;
            Window.Update(2, LineCount);
            //CheckRecurringLine(RentJnlLine);
            RentJnlCheckLine.RunCheck(RentJnlLine);
            if RentJnlLine.Next = 0 then
                RentJnlLine.Find('-');
        until RentJnlLine."Line No." = StartLineNo;
        NoOfRecords := LineCount;

        // Find next register no.
        LedgEntryDim.LockTable;
        RentLedgEntry.LockTable;
        if RentJnlLine.RECORDLEVELLOCKING then
            if RentLedgEntry.Find('+') then;
        RentReg.LockTable;
        if RentReg.Find('+') and (RentReg."To Entry No." = 0) then
            RentRegNo := RentReg."No."
        else
            RentRegNo := RentReg."No." + 1;

        // Post lines
        LineCount := 0;
        LastDocNo := '';
        LastDocNo2 := '';
        LastPostedDocNo := '';
        RentJnlLine.Find('-');
        repeat
            LineCount := LineCount + 1;
            Window.Update(3, LineCount);
            Window.Update(4, ROUND(LineCount / NoOfRecords * 10000, 1));
            if /*NOT EmptyLine AND*/
               (RentJnlBatch."No. Series" <> '') and
               (RentJnlLine."Document No." <> LastDocNo2)
            then
                RentJnlLine.TestField("Document No.", NoSeriesBatch.GetNextNo(RentJnlBatch."No. Series", RentJnlLine."Posting Date", false));
            LastDocNo2 := RentJnlLine."Document No.";
            //MakeRecurringTexts(RentJnlLine);
            if RentJnlLine."Posting No. Series" = '' then
                RentJnlLine."Posting No. Series" := RentJnlBatch."No. Series"
            else
                if not /*EmptyLine*/ true then
                    if RentJnlLine."Document No." = LastDocNo then
                        RentJnlLine."Document No." := LastPostedDocNo
                    else begin
                        if not NoSeries.Get(RentJnlLine."Posting No. Series") then begin
                            NoOfPostingNoSeries := NoOfPostingNoSeries + 1;
                            if NoOfPostingNoSeries > ArrayLen(NoSeriesBatch2) then
                                Error(
                                  Text006,
                                  ArrayLen(NoSeriesBatch2));
                            NoSeries.Code := RentJnlLine."Posting No. Series";
                            NoSeries.Description := Format(NoOfPostingNoSeries);
                            NoSeries.Insert;
                        end;
                        LastDocNo := RentJnlLine."Document No.";
                        Evaluate(PostingNoSeriesNo, NoSeries.Description);
                        RentJnlLine."Document No." := NoSeriesBatch2[PostingNoSeriesNo].GetNextNo(RentJnlLine."Posting No. Series", RentJnlLine."Posting Date", false);
                        LastPostedDocNo := RentJnlLine."Document No.";
                    end;
            RentJnlPostLine.RunWithCheck(RentJnlLine);
        until RentJnlLine.Next = 0;

        // Copy register no. and current journal batch name to the res. journal
        if not RentReg.Find('+') or (RentReg."No." <> RentRegNo) then
            RentRegNo := 0;

        RentJnlLine.Init;
        RentJnlLine."Line No." := RentRegNo;

        // Update/delete lines
        if RentRegNo <> 0 then begin
            if not RentJnlLine.RECORDLEVELLOCKING then begin
                RentJnlLine.LockTable(true, true);
            end;
            if RentJnlTemplate.Recurring then begin
            end else begin

                // Not a recurring journal
                RentJnlLine2.CopyFilters(RentJnlLine);
                if RentJnlLine2.Find('+') then; // Remember the last line
                RentJnlLine3.Copy(RentJnlLine);
                if RentJnlLine3.Find('-') then
                    repeat
                        RentJnlLine3.Delete;
                    until RentJnlLine3.Next = 0;
                RentJnlLine3.Reset;
                RentJnlLine3.SetRange("Journal Template Name", RentJnlLine."Journal Template Name");
                RentJnlLine3.SetRange("Journal Batch Name", RentJnlLine."Journal Batch Name");
                if not RentJnlLine3.Find('+') then
                    if IncStr(RentJnlLine."Journal Batch Name") <> '' then begin
                        RentJnlBatch.Delete;
                        RentJnlBatch.Name := IncStr(RentJnlLine."Journal Batch Name");
                        if RentJnlBatch.Insert then;
                        RentJnlLine."Journal Batch Name" := RentJnlBatch.Name;
                    end;

                RentJnlLine3.SetRange("Journal Batch Name", RentJnlLine."Journal Batch Name");
                if (RentJnlBatch."No. Series" = '') and not RentJnlLine3.Find('+') then begin
                    RentJnlLine3.Init;
                    RentJnlLine3."Journal Template Name" := RentJnlLine."Journal Template Name";
                    RentJnlLine3."Journal Batch Name" := RentJnlLine."Journal Batch Name";
                    RentJnlLine3."Line No." := 10000;
                    RentJnlLine3.Insert;
                end;

            end;
        end;
        if RentJnlBatch."No. Series" <> '' then
            NoSeriesBatch.SaveState();
        if NoSeries.Find('-') then
            repeat
                Evaluate(PostingNoSeriesNo, NoSeries.Description);
                NoSeriesBatch2[PostingNoSeriesNo].SaveState();
            until NoSeries.Next = 0;

        Commit;
        UpdateAnalysisView.UpdateAll(0, true);
        Commit;

    end;
}

