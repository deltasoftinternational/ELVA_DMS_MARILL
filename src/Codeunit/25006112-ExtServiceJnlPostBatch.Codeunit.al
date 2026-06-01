Codeunit 25006112 "Ext. Service Jnl.-Post Batch"
{
    TableNo = "External Serv. Journal Line";

    trigger OnRun()
    begin
        ExtServiceJnlLine.Copy(Rec);
        Code;
        Rec := ExtServiceJnlLine;
    end;

    var
        Text000: label 'cannot exceed %1 characters';
        Text001: label 'Journal Batch Name    #1##########\\';
        Text002: label 'Checking lines        #2######\';
        Text005: label 'Posting lines         #3###### @4@@@@@@@@@@@@@';
        Text006: label 'A maximum of %1 posting number series can be used in each journal.';
        ExtServiceJnlTemplate: Record "Ext. Service Journal Template";
        ExtServiceJnlBatch: Record "External Serv. Journal Batch";
        ExtServiceJnlLine: Record "External Serv. Journal Line";
        ExtServiceJnlLine2: Record "External Serv. Journal Line";
        ExtServiceJnlLine3: Record "External Serv. Journal Line";
        ExtServiceLedgEntry: Record "External Serv. Ledger Entry";
        ExtServiceReg: Record "External Service Register";
        NoSeries: Record "No. Series" temporary;
        ExtServiceJnlCheckLine: Codeunit "Ext. Service Jnl.-Check Line";
        ExtServiceJnlPostLine: Codeunit "Ext. Service Jnl.-Post Line";
        NoSeriesBatch: Codeunit "No. Series - Batch";
        NoSeriesBatch2: array[10] of Codeunit "No. Series - Batch";
        Window: Dialog;
        ExtServiceRegNo: Integer;
        StartLineNo: Integer;
        Month: Integer;
        LineCount: Integer;
        NoOfRecords: Integer;
        LastDocNo: Code[20];
        LastDocNo2: Code[20];
        LastPostedDocNo: Code[20];
        NoOfPostingNoSeries: Integer;
        PostingNoSeriesNo: Integer;

    local procedure "Code"()
    var
        UpdateAnalysisView: Codeunit "Update Analysis View";
    begin
        ExtServiceJnlLine.SetRange("Journal Template Name", ExtServiceJnlLine."Journal Template Name");
        ExtServiceJnlLine.SetRange("Journal Batch Name", ExtServiceJnlLine."Journal Batch Name");
        if ExtServiceJnlLine.RECORDLEVELLOCKING then
            ExtServiceJnlLine.LockTable;

        ExtServiceJnlTemplate.Get(ExtServiceJnlLine."Journal Template Name");
        ExtServiceJnlBatch.Get(ExtServiceJnlLine."Journal Template Name", ExtServiceJnlLine."Journal Batch Name");
        if StrLen(IncStr(ExtServiceJnlBatch.Name)) > MaxStrLen(ExtServiceJnlBatch.Name) then
            ExtServiceJnlBatch.FieldError(
              Name,
              StrSubstNo(
                Text000,
                MaxStrLen(ExtServiceJnlBatch.Name)));

        if not ExtServiceJnlLine.FindSet then begin
            ExtServiceJnlLine."Line No." := 0;
            Commit;
            exit;
        end;

        Window.Open(
          Text001 +
          Text002 +
          Text005);
        Window.Update(1, ExtServiceJnlLine."Journal Batch Name");

        // Check lines
        LineCount := 0;
        StartLineNo := ExtServiceJnlLine."Line No.";
        repeat
            LineCount := LineCount + 1;
            Window.Update(2, LineCount);

            // 30.10.2012 EDMS >>


            //    ExtServiceJnlCheckLine.RunCheck(ExtServiceJnlLine,TempJnlLineDim);
            ExtServiceJnlCheckLine.RunCheck(ExtServiceJnlLine);
            // 30.10.2012 EDMS <<
            if ExtServiceJnlLine.Next = 0 then
                ExtServiceJnlLine.FindSet;
        until ExtServiceJnlLine."Line No." = StartLineNo;
        NoOfRecords := LineCount;

        // Find next register no.
        //  LedgEntryDim.LOCKTABLE;  //30.10.2012 EDMS
        ExtServiceLedgEntry.LockTable;
        if ExtServiceJnlLine.RECORDLEVELLOCKING then
            if ExtServiceLedgEntry.FindLast then;
        ExtServiceReg.LockTable;
        if ExtServiceReg.FindLast and (ExtServiceReg."To Entry No." = 0) then
            ExtServiceRegNo := ExtServiceReg."No."
        else
            ExtServiceRegNo := ExtServiceReg."No." + 1;

        // Post lines
        LineCount := 0;
        LastDocNo := '';
        LastDocNo2 := '';
        LastPostedDocNo := '';
        ExtServiceJnlLine.FindSet;
        repeat
            LineCount := LineCount + 1;
            Window.Update(3, LineCount);
            Window.Update(4, ROUND(LineCount / NoOfRecords * 10000, 1));
            if not ExtServiceJnlLine.EmptyLine and
               (ExtServiceJnlBatch."No. Series" <> '') and
               (ExtServiceJnlLine."Document No." <> LastDocNo2)
            then
                ExtServiceJnlLine.TestField("Document No.", NoSeriesBatch.GetNextNo(ExtServiceJnlBatch."No. Series", ExtServiceJnlLine."Posting Date", false));
            LastDocNo2 := ExtServiceJnlLine."Document No.";
            if ExtServiceJnlLine."Posting No. Series" = '' then
                ExtServiceJnlLine."Posting No. Series" := ExtServiceJnlBatch."No. Series"
            else
                if not ExtServiceJnlLine.EmptyLine then
                    if ExtServiceJnlLine."Document No." = LastDocNo then
                        ExtServiceJnlLine."Document No." := LastPostedDocNo
                    else begin
                        if not NoSeries.Get(ExtServiceJnlLine."Posting No. Series") then begin
                            NoOfPostingNoSeries := NoOfPostingNoSeries + 1;
                            if NoOfPostingNoSeries > ArrayLen(NoSeriesBatch2) then
                                Error(
                                  Text006,
                                  ArrayLen(NoSeriesBatch2));
                            NoSeries.Code := ExtServiceJnlLine."Posting No. Series";
                            NoSeries.Description := Format(NoOfPostingNoSeries);
                            NoSeries.Insert;
                        end;
                        LastDocNo := ExtServiceJnlLine."Document No.";
                        Evaluate(PostingNoSeriesNo, NoSeries.Description);
                        ExtServiceJnlLine."Document No." := NoSeriesBatch2[PostingNoSeriesNo].GetNextNo(ExtServiceJnlLine."Posting No. Series", ExtServiceJnlLine."Posting Date", false);
                        LastPostedDocNo := ExtServiceJnlLine."Document No.";
                    end;

            //30.10.2012 EDMS >>
            ExtServiceJnlPostLine.RunWithCheck(ExtServiceJnlLine);
        //30.10.2012 EDMS <<

        until ExtServiceJnlLine.Next = 0;

        // Copy register no. and current journal batch name to the Ext. service journal
        if not ExtServiceReg.FindLast or (ExtServiceReg."No." <> ExtServiceRegNo) then
            ExtServiceRegNo := 0;

        ExtServiceJnlLine.Init;
        ExtServiceJnlLine."Line No." := ExtServiceRegNo;

        // Update/delete lines
        if ExtServiceRegNo <> 0 then begin
            if not ExtServiceJnlLine.RECORDLEVELLOCKING then begin
                //      JnlLineDim.LOCKTABLE(TRUE,TRUE); //30.10.2012 EDMS
                ExtServiceJnlLine.LockTable(true, true);
            end;
            // Not a recurring journal
            ExtServiceJnlLine2.CopyFilters(ExtServiceJnlLine);
            ExtServiceJnlLine2.SetFilter("Ext. Service No.", '<>%1', '');
            if ExtServiceJnlLine2.FindLast then; // Remember the last line

            ExtServiceJnlLine3.Copy(ExtServiceJnlLine);
            ExtServiceJnlLine3.DeleteAll;

            ExtServiceJnlLine3.Reset;
            ExtServiceJnlLine3.SetRange("Journal Template Name", ExtServiceJnlLine."Journal Template Name");
            ExtServiceJnlLine3.SetRange("Journal Batch Name", ExtServiceJnlLine."Journal Batch Name");
            if not ExtServiceJnlLine3.FindLast then
                if IncStr(ExtServiceJnlLine."Journal Batch Name") <> '' then begin
                    ExtServiceJnlBatch.Delete;
                    ExtServiceJnlBatch.Name := IncStr(ExtServiceJnlLine."Journal Batch Name");
                    if ExtServiceJnlBatch.Insert then;
                    ExtServiceJnlLine."Journal Batch Name" := ExtServiceJnlBatch.Name;
                end;

            ExtServiceJnlLine3.SetRange("Journal Batch Name", ExtServiceJnlLine."Journal Batch Name");
            if (ExtServiceJnlBatch."No. Series" = '') and not ExtServiceJnlLine3.FindLast then begin
                ExtServiceJnlLine3.Init;
                ExtServiceJnlLine3."Journal Template Name" := ExtServiceJnlLine."Journal Template Name";
                ExtServiceJnlLine3."Journal Batch Name" := ExtServiceJnlLine."Journal Batch Name";
                ExtServiceJnlLine3."Line No." := 10000;
                ExtServiceJnlLine3.Insert;
                ExtServiceJnlLine3.SetUpNewLine(ExtServiceJnlLine2);
                ExtServiceJnlLine3.Modify;
            end;
        end;
        if ExtServiceJnlBatch."No. Series" <> '' then
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
}

