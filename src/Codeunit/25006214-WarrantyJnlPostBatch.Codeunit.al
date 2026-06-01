Codeunit 25006214 "Warranty Jnl.-Post Batch"
{
    TableNo = "Warranty Journal Line";

    trigger OnRun()
    begin
        WarrantyJnlLine.Copy(Rec);
        Code;
        Rec := WarrantyJnlLine;
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
        WarrantyJnlTemplate: Record "Warranty Journal Template";
        WarrantyJnlBatch: Record "Warranty Journal Batch";
        WarrantyJnlLine: Record "Warranty Journal Line";
        WarrantyJnlLine2: Record "Warranty Journal Line";
        WarrantyJnlLine3: Record "Warranty Journal Line";
        WarrantyLedgEntry: Record "Warranty Reimbursment Entry";
        WarrantyReg: Record "Warranty Reimb. Register";
        NoSeries: Record "No. Series" temporary;
        WarrantyJnlCheckLine: Codeunit "Warranty Jnl.-Check Line";
        WarrantyJnlPostLine: Codeunit "Warranty Jnl.-Post Line";
        NoSeriesBatch: Codeunit "No. Series - Batch";
        NoSeriesBatch2: array[10] of Codeunit "No. Series - Batch";
        Window: Dialog;
        WarrantyRegNo: Integer;
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
        DF0: DateFormula;

    local procedure "Code"()
    var
        UpdateAnalysisView: Codeunit "Update Analysis View";
    begin
        WarrantyJnlLine.SetRange("Journal Template Name", WarrantyJnlLine."Journal Template Name");
        WarrantyJnlLine.SetRange("Journal Batch Name", WarrantyJnlLine."Journal Batch Name");
        if WarrantyJnlLine.RECORDLEVELLOCKING then
            WarrantyJnlLine.LockTable;

        WarrantyJnlTemplate.Get(WarrantyJnlLine."Journal Template Name");
        WarrantyJnlBatch.Get(WarrantyJnlLine."Journal Template Name", WarrantyJnlLine."Journal Batch Name");
        if StrLen(IncStr(WarrantyJnlBatch.Name)) > MaxStrLen(WarrantyJnlBatch.Name) then
            WarrantyJnlBatch.FieldError(
              Name,
              StrSubstNo(
                Text000,
                MaxStrLen(WarrantyJnlBatch.Name)));

        if WarrantyJnlTemplate.Recurring then begin
            WarrantyJnlLine.SetRange("Posting Date", 0D, WorkDate);
        end;

        if not WarrantyJnlLine.FindSet then begin
            WarrantyJnlLine."Line No." := 0;
            Commit;
            exit;
        end;

        if WarrantyJnlTemplate.Recurring then
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
        Window.Update(1, WarrantyJnlLine."Journal Batch Name");

        // Check lines
        LineCount := 0;
        StartLineNo := WarrantyJnlLine."Line No.";
        repeat
            LineCount := LineCount + 1;
            Window.Update(2, LineCount);
            //CheckRecurringLine(WarrantyJnlLine);
            WarrantyJnlCheckLine.RunCheck(WarrantyJnlLine);

            if WarrantyJnlLine.Next = 0 then
                WarrantyJnlLine.FindFirst;
        until WarrantyJnlLine."Line No." = StartLineNo;
        NoOfRecords := LineCount;

        // Find next register no.
        //  LedgEntryDim.LOCKTABLE; //30.10.2012 EDMS
        WarrantyLedgEntry.LockTable;
        if WarrantyJnlLine.RECORDLEVELLOCKING then
            if WarrantyLedgEntry.FindLast then;
        WarrantyReg.LockTable;
        if WarrantyReg.FindLast and (WarrantyReg."To Entry No." = 0) then
            WarrantyRegNo := WarrantyReg."No."
        else
            WarrantyRegNo := WarrantyReg."No." + 1;

        // Post lines
        LineCount := 0;
        LastDocNo := '';
        LastDocNo2 := '';
        LastPostedDocNo := '';
        WarrantyJnlLine.FindSet;
        repeat
            LineCount := LineCount + 1;
            Window.Update(3, LineCount);
            Window.Update(4, ROUND(LineCount / NoOfRecords * 10000, 1));
            if not WarrantyJnlLine.EmptyLine and
               (WarrantyJnlBatch."No. Series" <> '') and
               (WarrantyJnlLine."Document No." <> LastDocNo2)
            then
                WarrantyJnlLine.TestField("Document No.", NoSeriesBatch.GetNextNo(WarrantyJnlBatch."No. Series", WarrantyJnlLine."Posting Date", false));
            LastDocNo2 := WarrantyJnlLine."Document No.";
            MakeRecurringTexts(WarrantyJnlLine);
            if WarrantyJnlLine."Posting No. Series" = '' then
                WarrantyJnlLine."Posting No. Series" := WarrantyJnlBatch."No. Series"
            else
                if not WarrantyJnlLine.EmptyLine then
                    if WarrantyJnlLine."Document No." = LastDocNo then
                        WarrantyJnlLine."Document No." := LastPostedDocNo
                    else begin
                        if not NoSeries.Get(WarrantyJnlLine."Posting No. Series") then begin
                            NoOfPostingNoSeries := NoOfPostingNoSeries + 1;
                            if NoOfPostingNoSeries > ArrayLen(NoSeriesBatch2) then
                                Error(
                                  Text006,
                                  ArrayLen(NoSeriesBatch2));
                            NoSeries.Code := WarrantyJnlLine."Posting No. Series";
                            NoSeries.Description := Format(NoOfPostingNoSeries);
                            NoSeries.Insert;
                        end;
                        LastDocNo := WarrantyJnlLine."Document No.";
                        Evaluate(PostingNoSeriesNo, NoSeries.Description);
                        WarrantyJnlLine."Document No." := NoSeriesBatch2[PostingNoSeriesNo].GetNextNo(WarrantyJnlLine."Posting No. Series", WarrantyJnlLine."Posting Date", false);
                        LastPostedDocNo := WarrantyJnlLine."Document No.";
                    end;

            //30.10.2012 EDMS >>
            //    WarrantyJnlPostLine.RunWithCheck(WarrantyJnlLine,TempJnlLineDim);
            WarrantyJnlPostLine.RunWithCheck(WarrantyJnlLine);
        //30.10.2012 EDMS <<

        until WarrantyJnlLine.Next = 0;

        // Copy register no. and current journal batch name to the Serv. journal
        if WarrantyReg.FindLast then begin
            if WarrantyReg."No." > WarrantyRegNo then
                WarrantyRegNo := WarrantyReg."No."
            else begin
                if WarrantyReg."No." = WarrantyRegNo then begin
                    if WarrantyReg."To Entry No." = 0 then
                        WarrantyRegNo := 0
                    else
                        WarrantyRegNo := WarrantyReg."No.";
                end else
                    WarrantyRegNo := 0;
            end;
        end else
            WarrantyRegNo := 0;

        WarrantyJnlLine.Init;
        WarrantyJnlLine."Line No." := WarrantyRegNo;
        //  "Line No." := 10000;

        // Update/delete lines
        if WarrantyRegNo <> 0 then begin
            if not WarrantyJnlLine.RECORDLEVELLOCKING then begin
                //      JnlLineDim.LOCKTABLE(TRUE,TRUE); //30.10.2012 EDMS
                WarrantyJnlLine.LockTable(true, true);
            end;
            if WarrantyJnlTemplate.Recurring then begin
                // Recurring journal
                LineCount := 0;
                WarrantyJnlLine2.CopyFilters(WarrantyJnlLine);
                WarrantyJnlLine2.FindSet(true, false);
                repeat
                    LineCount := LineCount + 1;
                    Window.Update(5, LineCount);
                    Window.Update(6, ROUND(LineCount / NoOfRecords * 10000, 1));
                    if WarrantyJnlLine2."Posting Date" <> 0D then
                        WarrantyJnlLine2.Validate("Posting Date", CalcDate(WarrantyJnlLine2."Recurring Frequency", WarrantyJnlLine2."Posting Date"));
                    if (WarrantyJnlLine2."Recurring Method" = WarrantyJnlLine2."recurring method"::Variable) and
                       (WarrantyJnlLine2."Vehicle Serial No." <> '')
                    then begin
                        //WarrantyJnlLine2.Quantity := 0;
                        //WarrantyJnlLine2."Total Cost" := 0;
                        //WarrantyJnlLine2.Amount := 0;
                    end;
                    WarrantyJnlLine2.Modify;
                until WarrantyJnlLine2.Next = 0;
            end else begin
                // Not a recurring journal
                WarrantyJnlLine2.CopyFilters(WarrantyJnlLine);
                WarrantyJnlLine2.SetFilter("Debit Description", '<>%1', '');
                if WarrantyJnlLine2.FindLast then; // Remember the last line


                WarrantyJnlLine3.Copy(WarrantyJnlLine);
                if WarrantyJnlLine3.Find('-') then
                    repeat


                        WarrantyJnlLine3.Delete;
                    until WarrantyJnlLine3.Next = 0;

                WarrantyJnlLine3.Reset;
                WarrantyJnlLine3.SetRange("Journal Template Name", WarrantyJnlLine."Journal Template Name");
                WarrantyJnlLine3.SetRange("Journal Batch Name", WarrantyJnlLine."Journal Batch Name");
                if not WarrantyJnlLine3.FindLast then
                    if IncStr(WarrantyJnlLine."Journal Batch Name") <> '' then begin
                        WarrantyJnlBatch.Delete;
                        WarrantyJnlBatch.Name := IncStr(WarrantyJnlLine."Journal Batch Name");
                        if WarrantyJnlBatch.Insert then;
                        WarrantyJnlLine."Journal Batch Name" := WarrantyJnlBatch.Name;
                    end;

                WarrantyJnlLine3.SetRange("Journal Batch Name", WarrantyJnlLine."Journal Batch Name");
                if (WarrantyJnlBatch."No. Series" = '') and not WarrantyJnlLine3.FindLast then begin
                    WarrantyJnlLine3.Init;
                    WarrantyJnlLine3."Journal Template Name" := WarrantyJnlLine."Journal Template Name";
                    WarrantyJnlLine3."Journal Batch Name" := WarrantyJnlLine."Journal Batch Name";
                    WarrantyJnlLine3."Line No." := 10000;
                    WarrantyJnlLine3.Insert;
                    WarrantyJnlLine3.SetUpNewLine(WarrantyJnlLine2);
                    WarrantyJnlLine3.Modify;
                end;
            end;
        end;
        if WarrantyJnlBatch."No. Series" <> '' then
            NoSeriesBatch.SaveState();
        if NoSeries.FindSet then
            repeat
                Evaluate(PostingNoSeriesNo, NoSeries.Description);
                NoSeriesBatch2[PostingNoSeriesNo].SaveState();
            until NoSeries.Next = 0;

        Commit;
        UpdateAnalysisView.UpdateAll(0, true);
        Commit;
    end;

    local procedure CheckRecurringLine(var WarrantyJnlLine2: Record "Warranty Journal Line")
    begin
        if WarrantyJnlLine2."Debit Description" <> '' then
            if WarrantyJnlTemplate.Recurring then begin
                WarrantyJnlLine2.TestField("Recurring Method");
                WarrantyJnlLine2.TestField("Recurring Frequency");
                if WarrantyJnlLine2."Recurring Method" = WarrantyJnlLine2."recurring method"::Variable then
                    WarrantyJnlLine2.TestField("Vehicle Serial No.");
            end else begin
                WarrantyJnlLine2.TestField("Recurring Method", 0);
                WarrantyJnlLine2.TestField("Recurring Frequency", DF0);
            end;
    end;

    local procedure MakeRecurringTexts(var WarrantyJnlLine2: Record "Warranty Journal Line")
    begin
        if (WarrantyJnlLine2."Vehicle Serial No." <> '') and (WarrantyJnlLine2."Recurring Method" <> 0) then begin // Not recurring
            Day := Date2dmy(WarrantyJnlLine2."Posting Date", 1);
            Week := Date2dwy(WarrantyJnlLine2."Posting Date", 2);
            Month := Date2dmy(WarrantyJnlLine2."Posting Date", 2);
            MonthText := Format(WarrantyJnlLine2."Posting Date", 0, Text007);
            AccountingPeriod.SetRange("Starting Date", 0D, WarrantyJnlLine2."Posting Date");
            if not AccountingPeriod.FindLast then
                AccountingPeriod.Name := '';
            WarrantyJnlLine2."Document No." :=
              DelChr(
                PadStr(
                  StrSubstNo(WarrantyJnlLine2."Document No.", Day, Week, Month, MonthText, AccountingPeriod.Name),
                  MaxStrLen(WarrantyJnlLine2."Document No.")),
                '>');
            //Description :=
            //  DELCHR(
            //    PADSTR(
            //      STRSUBSTNO(Description,Day,Week,Month,MonthText,AccountingPeriod.Name),
            //      MAXSTRLEN(Description)),
            //    '>');
        end;
    end;
}

