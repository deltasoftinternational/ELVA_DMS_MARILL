Codeunit 25006108 "Serv. Jnl.-Post Batch"
{
    Permissions = TableData "Serv. Journal Batch" = imd;
    TableNo = "Serv. Journal Line";

    trigger OnRun()
    begin
        ServJnlLine.Copy(Rec);
        Code;
        Rec := ServJnlLine;
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
        ServJnlTemplate: Record "Serv. Journal Template";
        ServJnlBatch: Record "Serv. Journal Batch";
        ServJnlLine: Record "Serv. Journal Line";
        ServJnlLine2: Record "Serv. Journal Line";
        ServJnlLine3: Record "Serv. Journal Line";
        ServLedgEntry: Record "Service Ledger Entry EDMS";
        ServReg: Record "Service Register EDMS";
        NoSeries: Record "No. Series" temporary;
        ServJnlCheckLine: Codeunit "Serv. Jnl.-Check Line";
        ServJnlPostLine: Codeunit "Serv. Jnl.-Post Line";
        NoSeriesBatch: Codeunit "No. Series - Batch";
        NoSeriesBatch2: array[10] of Codeunit "No. Series - Batch";
        Window: Dialog;
        ServRegNo: Integer;
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
        ServJnlLine.SetRange("Journal Template Name", ServJnlLine."Journal Template Name");
        ServJnlLine.SetRange("Journal Batch Name", ServJnlLine."Journal Batch Name");
        if ServJnlLine.RECORDLEVELLOCKING then
            ServJnlLine.LockTable;

        ServJnlTemplate.Get(ServJnlLine."Journal Template Name");
        ServJnlBatch.Get(ServJnlLine."Journal Template Name", ServJnlLine."Journal Batch Name");
        if StrLen(IncStr(ServJnlBatch.Name)) > MaxStrLen(ServJnlBatch.Name) then
            ServJnlBatch.FieldError(
              Name,
              StrSubstNo(
                Text000,
                MaxStrLen(ServJnlBatch.Name)));

        if ServJnlTemplate.Recurring then begin
            ServJnlLine.SetRange("Posting Date", 0D, WorkDate);
            ServJnlLine.SetFilter("Expiration Date", '%1 | %2..', 0D, WorkDate);
        end;

        if not ServJnlLine.FindSet then begin
            ServJnlLine."Line No." := 0;
            Commit;
            exit;
        end;

        if ServJnlTemplate.Recurring then
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
        Window.Update(1, ServJnlLine."Journal Batch Name");

        // Check lines
        LineCount := 0;
        StartLineNo := ServJnlLine."Line No.";
        repeat
            LineCount := LineCount + 1;
            Window.Update(2, LineCount);
            CheckRecurringLine(ServJnlLine);
            //30.10.2012 EDMS >>
            ServJnlCheckLine.RunCheck(ServJnlLine);
            //30.10.2012 EDMS <<

            if ServJnlLine.Next = 0 then
                ServJnlLine.FindFirst;
        until ServJnlLine."Line No." = StartLineNo;
        NoOfRecords := LineCount;

        // Find next register no.
        //  LedgEntryDim.LOCKTABLE; //30.10.2012 EDMS
        ServLedgEntry.LockTable;
        if ServJnlLine.RECORDLEVELLOCKING then
            if ServLedgEntry.FindLast then;
        ServReg.LockTable;
        if ServReg.FindLast and (ServReg."To Entry No." = 0) then
            ServRegNo := ServReg."No."
        else
            ServRegNo := ServReg."No." + 1;

        // Post lines
        LineCount := 0;
        LastDocNo := '';
        LastDocNo2 := '';
        LastPostedDocNo := '';
        ServJnlLine.FindSet;
        repeat
            LineCount := LineCount + 1;
            Window.Update(3, LineCount);
            Window.Update(4, ROUND(LineCount / NoOfRecords * 10000, 1));
            if not ServJnlLine.EmptyLine and
               (ServJnlBatch."No. Series" <> '') and
               (ServJnlLine."Document No." <> LastDocNo2)
            then
                ServJnlLine.TestField("Document No.", NoSeriesBatch.GetNextNo(ServJnlBatch."No. Series", ServJnlLine."Posting Date", false));
            LastDocNo2 := ServJnlLine."Document No.";
            MakeRecurringTexts(ServJnlLine);
            if ServJnlLine."Posting No. Series" = '' then
                ServJnlLine."Posting No. Series" := ServJnlBatch."No. Series"
            else
                if not ServJnlLine.EmptyLine then
                    if ServJnlLine."Document No." = LastDocNo then
                        ServJnlLine."Document No." := LastPostedDocNo
                    else begin
                        if not NoSeries.Get(ServJnlLine."Posting No. Series") then begin
                            NoOfPostingNoSeries := NoOfPostingNoSeries + 1;
                            if NoOfPostingNoSeries > ArrayLen(NoSeriesBatch2) then
                                Error(
                                  Text006,
                                  ArrayLen(NoSeriesBatch2));
                            NoSeries.Code := ServJnlLine."Posting No. Series";
                            NoSeries.Description := Format(NoOfPostingNoSeries);
                            NoSeries.Insert;
                        end;
                        LastDocNo := ServJnlLine."Document No.";
                        Evaluate(PostingNoSeriesNo, NoSeries.Description);
                        ServJnlLine."Document No." := NoSeriesBatch2[PostingNoSeriesNo].GetNextNo(ServJnlLine."Posting No. Series", ServJnlLine."Posting Date", false);
                        LastPostedDocNo := ServJnlLine."Document No.";
                    end;

            //30.10.2012 EDMS >>
            //    ServJnlPostLine.RunWithCheck(ServJnlLine,TempJnlLineDim);
            ServJnlPostLine.RunWithCheck(ServJnlLine);
        //30.10.2012 EDMS <<

        until ServJnlLine.Next = 0;

        // Copy register no. and current journal batch name to the Serv. journal
        if ServReg.FindLast then begin
            if ServReg."No." > ServRegNo then
                ServRegNo := ServReg."No."
            else begin
                if ServReg."No." = ServRegNo then begin
                    if ServReg."To Entry No." = 0 then
                        ServRegNo := 0
                    else
                        ServRegNo := ServReg."No.";
                end else
                    ServRegNo := 0;
            end;
        end else
            ServRegNo := 0;

        ServJnlLine.Init;
        ServJnlLine."Line No." := ServRegNo;
        //  "Line No." := 10000;

        // Update/delete lines
        if ServRegNo <> 0 then begin
            if not ServJnlLine.RECORDLEVELLOCKING then begin
                //      JnlLineDim.LOCKTABLE(TRUE,TRUE); //30.10.2012 EDMS
                ServJnlLine.LockTable(true, true);
            end;
            if ServJnlTemplate.Recurring then begin
                // Recurring journal
                LineCount := 0;
                ServJnlLine2.CopyFilters(ServJnlLine);
                ServJnlLine2.FindSet(true, false);
                repeat
                    LineCount := LineCount + 1;
                    Window.Update(5, LineCount);
                    Window.Update(6, ROUND(LineCount / NoOfRecords * 10000, 1));
                    if ServJnlLine2."Posting Date" <> 0D then
                        ServJnlLine2.Validate("Posting Date", CalcDate(ServJnlLine2."Recurring Frequency", ServJnlLine2."Posting Date"));
                    if (ServJnlLine2."Recurring Method" = ServJnlLine2."recurring method"::Variable) and
                       (ServJnlLine2."Vehicle Serial No." <> '')
                    then begin
                        ServJnlLine2.Quantity := 0;
                        ServJnlLine2."Total Cost" := 0;
                        ServJnlLine2.Amount := 0;
                    end;
                    ServJnlLine2.Modify;
                until ServJnlLine2.Next = 0;
            end else begin
                // Not a recurring journal
                ServJnlLine2.CopyFilters(ServJnlLine);
                ServJnlLine2.SetFilter("Vehicle Serial No.", '<>%1', '');
                if ServJnlLine2.FindLast then; // Remember the last line


                ServJnlLine3.Copy(ServJnlLine);
                if ServJnlLine3.Find('-') then
                    repeat


                        ServJnlLine3.Delete;
                    until ServJnlLine3.Next = 0;

                ServJnlLine3.Reset;
                ServJnlLine3.SetRange("Journal Template Name", ServJnlLine."Journal Template Name");
                ServJnlLine3.SetRange("Journal Batch Name", ServJnlLine."Journal Batch Name");
                if not ServJnlLine3.FindLast then
                    if IncStr(ServJnlLine."Journal Batch Name") <> '' then begin
                        ServJnlBatch.Delete;
                        ServJnlBatch.Name := IncStr(ServJnlLine."Journal Batch Name");
                        if ServJnlBatch.Insert then;
                        ServJnlLine."Journal Batch Name" := ServJnlBatch.Name;
                    end;

                ServJnlLine3.SetRange("Journal Batch Name", ServJnlLine."Journal Batch Name");
                if (ServJnlBatch."No. Series" = '') and not ServJnlLine3.FindLast then begin
                    ServJnlLine3.Init;
                    ServJnlLine3."Journal Template Name" := ServJnlLine."Journal Template Name";
                    ServJnlLine3."Journal Batch Name" := ServJnlLine."Journal Batch Name";
                    ServJnlLine3."Line No." := 10000;
                    ServJnlLine3.Insert;
                    ServJnlLine3.SetUpNewLine(ServJnlLine2);
                    ServJnlLine3.Modify;
                end;
            end;
        end;
        if ServJnlBatch."No. Series" <> '' then
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

    local procedure CheckRecurringLine(var ServJnlLine2: Record "Serv. Journal Line")
    begin
        if ServJnlLine2."Vehicle Serial No." <> '' then
            if ServJnlTemplate.Recurring then begin
                ServJnlLine2.TestField("Recurring Method");
                ServJnlLine2.TestField("Recurring Frequency");
                if ServJnlLine2."Recurring Method" = ServJnlLine2."recurring method"::Variable then
                    ServJnlLine2.TestField(Quantity);
            end else begin
                ServJnlLine2.TestField("Recurring Method", 0);
                ServJnlLine2.TestField("Recurring Frequency", DF0);
            end;
    end;

    local procedure MakeRecurringTexts(var ServJnlLine2: Record "Serv. Journal Line")
    begin
        if (ServJnlLine2."Vehicle Serial No." <> '') and (ServJnlLine2."Recurring Method" <> 0) then begin // Not recurring
            Day := Date2dmy(ServJnlLine2."Posting Date", 1);
            Week := Date2dwy(ServJnlLine2."Posting Date", 2);
            Month := Date2dmy(ServJnlLine2."Posting Date", 2);
            MonthText := Format(ServJnlLine2."Posting Date", 0, Text007);
            AccountingPeriod.SetRange("Starting Date", 0D, ServJnlLine2."Posting Date");
            if not AccountingPeriod.FindLast then
                AccountingPeriod.Name := '';
            ServJnlLine2."Document No." :=
              DelChr(
                PadStr(
                  StrSubstNo(ServJnlLine2."Document No.", Day, Week, Month, MonthText, AccountingPeriod.Name),
                  MaxStrLen(ServJnlLine2."Document No.")),
                '>');
            ServJnlLine2.Description :=
              DelChr(
                PadStr(
                  StrSubstNo(ServJnlLine2.Description, Day, Week, Month, MonthText, AccountingPeriod.Name),
                  MaxStrLen(ServJnlLine2.Description)),
                '>');
        end;
    end;
}

