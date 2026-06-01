Codeunit 25006517 "BLS Jnl.-Post Batch"
{
    Permissions = TableData "BLS Journal Batch" = imd;
    TableNo = "BLS Journal Line";

    trigger OnRun()
    begin
        BLSJnlLine.Copy(Rec);
        Code;
        Rec := BLSJnlLine;
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
        BLSJnlTemplate: Record "BLS Journal Template";
        BLSJnlBatch: Record "BLS Journal Batch";
        BLSJnlLine: Record "BLS Journal Line";
        BLSJnlLine2: Record "BLS Journal Line";
        BLSJnlLine3: Record "BLS Journal Line";
        BLSLedgEntry: Record "BLS Ledger Entry";
        NoSeries: Record "No. Series" temporary;
        BLSJnlCheckLine: Codeunit "BLS Jnl.-Check Line";
        BLSJnlPostLine: Codeunit "BLS Jnl.-Post Line";
        NoSeriesBatch: Codeunit "No. Series - Batch";
        NoSeriesBatch2: array[10] of Codeunit "No. Series - Batch";
        Window: Dialog;
        ResRegNo: Integer;
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
        BLSJnlLine.SetRange("Journal Template Name", BLSJnlLine."Journal Template Name");
        BLSJnlLine.SetRange("Journal Batch Name", BLSJnlLine."Journal Batch Name");
        BLSJnlLine.LockTable;

        BLSJnlTemplate.Get(BLSJnlLine."Journal Template Name");
        BLSJnlBatch.Get(BLSJnlLine."Journal Template Name", BLSJnlLine."Journal Batch Name");
        if StrLen(IncStr(BLSJnlBatch.Name)) > MaxStrLen(BLSJnlBatch.Name) then
            BLSJnlBatch.FieldError(
              Name,
              StrSubstNo(
                Text000,
                MaxStrLen(BLSJnlBatch.Name)));

        if BLSJnlTemplate.Recurring then begin
            BLSJnlLine.SetRange("Posting Date", 0D, WorkDate);
            BLSJnlLine.SetFilter("Expiration Date", '%1 | %2..', 0D, WorkDate);
        end;

        if not BLSJnlLine.Find('=><') then begin
            BLSJnlLine."Line No." := 0;
            Commit;
            exit;
        end;

        if GuiAllowed then
            if BLSJnlTemplate.Recurring then
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

        if GuiAllowed then
            Window.Update(1, BLSJnlLine."Journal Batch Name");

        // Check lines
        LineCount := 0;
        StartLineNo := BLSJnlLine."Line No.";
        repeat
            LineCount := LineCount + 1;
            if GuiAllowed then // EB.VAS EBR V2
                Window.Update(2, LineCount);
            CheckRecurringLine(BLSJnlLine);
            BLSJnlCheckLine.RunCheck(BLSJnlLine);
            if BLSJnlLine.Next = 0 then
                BLSJnlLine.Find('-');
        until BLSJnlLine."Line No." = StartLineNo;
        NoOfRecords := LineCount;
        // Post lines
        LineCount := 0;
        LastDocNo := '';
        LastDocNo2 := '';
        LastPostedDocNo := '';
        BLSJnlLine.Find('-');
        repeat
            LineCount := LineCount + 1;
            if GuiAllowed then begin
                Window.Update(3, LineCount);
                Window.Update(4, ROUND(LineCount / NoOfRecords * 10000, 1));
            end;
            if not BLSJnlLine.EmptyLine and
               (BLSJnlBatch."No. Series" <> '') and
               (BLSJnlLine."Document No." <> LastDocNo2)
            then
                BLSJnlLine.TestField("Document No.", NoSeriesBatch.GetNextNo(BLSJnlBatch."No. Series", BLSJnlLine."Posting Date", false));
            if not BLSJnlLine.EmptyLine then
                LastDocNo2 := BLSJnlLine."Document No.";
            MakeRecurringTexts(BLSJnlLine);
            if BLSJnlLine."Posting No. Series" = '' then
                BLSJnlLine."Posting No. Series" := BLSJnlBatch."No. Series"
            else
                if not BLSJnlLine.EmptyLine then
                    if BLSJnlLine."Document No." = LastDocNo then
                        BLSJnlLine."Document No." := LastPostedDocNo
                    else begin
                        if not NoSeries.Get(BLSJnlLine."Posting No. Series") then begin
                            NoOfPostingNoSeries := NoOfPostingNoSeries + 1;
                            if NoOfPostingNoSeries > ArrayLen(NoSeriesBatch2) then
                                Error(
                                  Text006,
                                  ArrayLen(NoSeriesBatch2));
                            NoSeries.Code := BLSJnlLine."Posting No. Series";
                            NoSeries.Description := Format(NoOfPostingNoSeries);
                            NoSeries.Insert;
                        end;
                        LastDocNo := BLSJnlLine."Document No.";
                        Evaluate(PostingNoSeriesNo, NoSeries.Description);
                        BLSJnlLine."Document No." := NoSeriesBatch2[PostingNoSeriesNo].GetNextNo(BLSJnlLine."Posting No. Series", BLSJnlLine."Posting Date", false);
                        LastPostedDocNo := BLSJnlLine."Document No.";
                    end;
            BLSJnlPostLine.RunWithCheck(BLSJnlLine);
        until BLSJnlLine.Next = 0;

        // Copy register no. and current journal batch name to the res. journal
        // IF NOT ResReg.FIND('+') OR (ResReg."No." <> ResRegNo) THEN
        ResRegNo := 1;

        BLSJnlLine.Init;
        BLSJnlLine."Line No." := ResRegNo;

        // Update/delete lines
        if ResRegNo <> 0 then begin
            if BLSJnlTemplate.Recurring then begin
                // Recurring journal
                LineCount := 0;
                BLSJnlLine2.CopyFilters(BLSJnlLine);
                BLSJnlLine2.Find('-');
                repeat
                    LineCount := LineCount + 1;

                    if GuiAllowed then begin // EB.VAS EBR V2
                        Window.Update(5, LineCount);
                        Window.Update(6, ROUND(LineCount / NoOfRecords * 10000, 1));
                    end; // EB.VAS EBR V2
                    if BLSJnlLine2."Posting Date" <> 0D then
                        BLSJnlLine2.Validate("Posting Date", CalcDate(BLSJnlLine2."Recurring Frequency", BLSJnlLine2."Posting Date"));
                    if (BLSJnlLine2."Recurring Method" = BLSJnlLine2."recurring method"::Variable) and
                       (BLSJnlLine2."Service Code" <> '')
                    then begin
                        BLSJnlLine2.Quantity := 0;
                        BLSJnlLine2."Unit Price" := 0;
                        BLSJnlLine2."Total Price" := 0;
                    end;
                    BLSJnlLine2.Modify;
                until BLSJnlLine2.Next = 0;
            end else begin
                // Not a recurring journal
                BLSJnlLine2.CopyFilters(BLSJnlLine);
                BLSJnlLine2.SetFilter("Source Code", '<>%1', '');
                if BLSJnlLine2.Find('+') then; // Remember the last line
                BLSJnlLine3.Copy(BLSJnlLine);
                BLSJnlLine3.DeleteAll;
                BLSJnlLine3.Reset;
                BLSJnlLine3.SetRange("Journal Template Name", BLSJnlLine."Journal Template Name");
                BLSJnlLine3.SetRange("Journal Batch Name", BLSJnlLine."Journal Batch Name");
                if not BLSJnlTemplate."Do Not Increase Batch Name" then // EB.VAS EBR V2
                    if not BLSJnlLine3.FindLast then
                        if IncStr(BLSJnlLine."Journal Batch Name") <> '' then begin
                            BLSJnlBatch.Delete;
                            BLSJnlBatch.Name := IncStr(BLSJnlLine."Journal Batch Name");
                            if BLSJnlBatch.Insert then;
                            BLSJnlLine."Journal Batch Name" := BLSJnlBatch.Name;
                        end;

                BLSJnlLine3.SetRange("Journal Batch Name", BLSJnlLine."Journal Batch Name");
                if (BLSJnlBatch."No. Series" = '') and not BLSJnlLine3.FindLast then begin
                    BLSJnlLine3.Init;
                    BLSJnlLine3."Journal Template Name" := BLSJnlLine."Journal Template Name";
                    BLSJnlLine3."Journal Batch Name" := BLSJnlLine."Journal Batch Name";
                    BLSJnlLine3."Line No." := 10000;
                    BLSJnlLine3.Insert;
                    BLSJnlLine3.SetUpNewLine(BLSJnlLine2);
                    BLSJnlLine3.Modify;
                end;
            end;
        end;
        if BLSJnlBatch."No. Series" <> '' then
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

    local procedure CheckRecurringLine(var BLSJnlLine2: Record "BLS Journal Line")
    begin
        if BLSJnlLine2."Source Code" <> '' then
            if BLSJnlTemplate.Recurring then begin
                BLSJnlLine2.TestField("Recurring Method");
                BLSJnlLine2.TestField("Recurring Frequency");
                if BLSJnlLine2."Recurring Method" = BLSJnlLine2."recurring method"::Variable then
                    BLSJnlLine2.TestField(Quantity);
            end else begin
                BLSJnlLine2.TestField("Recurring Method", 0);
                BLSJnlLine2.TestField("Recurring Frequency", "0DF");
            end;
    end;

    local procedure MakeRecurringTexts(var BLSJnlLine2: Record "BLS Journal Line")
    begin
        if (BLSJnlLine2."Source Code" <> '') and (BLSJnlLine2."Recurring Method" <> 0) then begin // Not recurring
            Day := Date2dmy(BLSJnlLine2."Posting Date", 1);
            Week := Date2dwy(BLSJnlLine2."Posting Date", 2);
            Month := Date2dmy(BLSJnlLine2."Posting Date", 2);
            MonthText := Format(BLSJnlLine2."Posting Date", 0, Text007);
            AccountingPeriod.SetRange("Starting Date", 0D, BLSJnlLine2."Posting Date");
            if not AccountingPeriod.Find('+') then
                AccountingPeriod.Name := '';
            BLSJnlLine2."Document No." :=
              DelChr(
                PadStr(
                  StrSubstNo(BLSJnlLine2."Document No.", Day, Week, Month, MonthText, AccountingPeriod.Name),
                  MaxStrLen(BLSJnlLine2."Document No.")),
                '>');
            BLSJnlLine2.Description :=
              DelChr(
                PadStr(
                  StrSubstNo(BLSJnlLine2.Description, Day, Week, Month, MonthText, AccountingPeriod.Name),
                  MaxStrLen(BLSJnlLine2.Description)),
                '>');
        end;
    end;
}

