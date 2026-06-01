Codeunit 25006308 "Vehicle Opt. Jnl.-Post Batch"
{
    // 21.03.2013 EDMS P8
    //   * fix of modify series no

    Permissions = TableData "Item Journal Batch" = imd;
    TableNo = "Vehicle Opt. Jnl. Line";

    trigger OnRun()
    begin
        recVehOptJnlLine.Copy(Rec);
        fCode;
        Rec := recVehOptJnlLine;
    end;

    var
        Text000: label 'cannot exceed %1 characters';
        Text001: label 'Journal Batch Name    #1##########\\';
        Text002: label 'Checking lines        #2######\';
        Text005: label 'Posting lines         #3###### @4@@@@@@@@@@@@@';
        Text006: label 'A maximum of %1 posting number series can be used in each journal.';
        recVehOptJnlTemplate: Record "Vehicle Opt. Jnl. Template";
        recVehOptJnlBatch: Record "Vehicle Opt. Jnl. Batch";
        recVehOptJnlLine: Record "Vehicle Opt. Jnl. Line";
        recVehOptJnlLine2: Record "Vehicle Opt. Jnl. Line";
        recVehOptJnlLine3: Record "Vehicle Opt. Jnl. Line";
        recGLSetup: Record "General Ledger Setup";
        recNoSeries: Record "No. Series" temporary;
        cuVehOptJnlCheckLine: Codeunit "Vehicle Opt. Jnl.-Check Line";
        cuVehOptJnlPostLine: Codeunit "Vehicle Opt. Jnl.-Post Line";
        NoSeriesBatch: Codeunit "No. Series - Batch";
        NoSeriesBatch2: array[10] of Codeunit "No. Series - Batch";
        dlgWindow: Dialog;
        iStartLineNo: Integer;
        iNoOfRecords: Integer;
        iLineCount: Integer;
        codLastDocNo: Code[20];
        codLastDocNo2: Code[20];
        codLastPostedDocNo: Code[20];
        iNoOfPostingNoSeries: Integer;
        iPostingNoSeriesNo: Integer;
        recVehOptJnlLine9: Record "Vehicle Opt. Jnl. Line";
        recVehOptJnlLine6: Record "Vehicle Opt. Jnl. Line";
        iGlobalVehOptRegNo: Integer;

    local procedure fCode()
    var
        recVehOptJnlLine6a: Record "Vehicle Opt. Jnl. Line";
    begin
        if recVehOptJnlLine.RECORDLEVELLOCKING then
            recVehOptJnlLine.LockTable;

        recVehOptJnlLine.SetRange("Journal Template Name", recVehOptJnlLine."Journal Template Name");
        recVehOptJnlLine.SetRange("Journal Batch Name", recVehOptJnlLine."Journal Batch Name");

        recVehOptJnlTemplate.Get(recVehOptJnlLine."Journal Template Name");
        recVehOptJnlBatch.Get(recVehOptJnlLine."Journal Template Name", recVehOptJnlLine."Journal Batch Name");
        if StrLen(IncStr(recVehOptJnlBatch.Name)) > MaxStrLen(recVehOptJnlBatch.Name) then
            recVehOptJnlBatch.FieldError(
              Name,
              StrSubstNo(
                Text000,
                MaxStrLen(recVehOptJnlBatch.Name)));

        if not recVehOptJnlLine.FindSet then begin
            recVehOptJnlLine."Line No." := 0;
            Commit;
            exit;
        end;

        dlgWindow.Open(
          Text001 +
          Text002 +
          Text005);

        dlgWindow.Update(1, recVehOptJnlLine."Journal Batch Name");

        // Check Lines
        iLineCount := 0;
        iStartLineNo := recVehOptJnlLine."Line No.";
        repeat
            iLineCount := iLineCount + 1;
            dlgWindow.Update(2, iLineCount);

            fMakeLineCorrectnessCheck(recVehOptJnlLine); //PŲÆrbaudes, kas attiecas tikai uz rindu

            if recVehOptJnlLine.Next = 0 then
                recVehOptJnlLine.FindFirst;
        until recVehOptJnlLine."Line No." = iStartLineNo;
        iNoOfRecords := iLineCount;


        recGLSetup.Get;

        // Post lines
        iLineCount := 0;
        codLastDocNo := '';
        codLastDocNo2 := '';
        codLastPostedDocNo := '';

        //GrŲÆmato├Ģanas grupŌĆ░├Ģanas cikls - pa aizvieto├ĢanŲÆm
        recVehOptJnlLine9.Reset; //PrimŲÆrie ieraksti
        recVehOptJnlLine9.CopyFilters(recVehOptJnlLine);

        recVehOptJnlLine6.Reset; //Pak├½autie ieraksti
        recVehOptJnlLine6.CopyFilters(recVehOptJnlLine);


        recVehOptJnlLine9.FindSet;
        repeat
            // GrŲÆmatojam primŲÆro rindu
            fPrePostLine(recVehOptJnlLine);
            iLineCount := iLineCount + 1;
            dlgWindow.Update(3, iLineCount);
            dlgWindow.Update(4, ROUND(iLineCount / iNoOfRecords * 10000, 1));

            //GrŲÆmatojam primŲÆro rindu
            cuVehOptJnlPostLine.fRunWithCheck(recVehOptJnlLine, iGlobalVehOptRegNo);
            //21.03.2013 EDMS P8 >>
            if recVehOptJnlBatch."No. Series" <> '' then
                NoSeriesBatch.SaveState();
            if recNoSeries.Find('-') then
                repeat
                    Evaluate(iPostingNoSeriesNo, recNoSeries.Description);
                    NoSeriesBatch2[iPostingNoSeriesNo].SaveState();
                until recNoSeries.Next = 0;
        //21.03.2013 EDMS P8 <<
        until recVehOptJnlLine.Next = 0;
        recVehOptJnlLine.FindLast;

        recVehOptJnlLine.Init;

        // Update/delete lines
        if recVehOptJnlLine."Line No." <> 0 then begin
            if not recVehOptJnlLine.RECORDLEVELLOCKING then begin
                recVehOptJnlLine.LockTable(true, true);
            end;
            begin
                recVehOptJnlLine2.CopyFilters(recVehOptJnlLine);
                if recVehOptJnlLine2.FindLast then; // Remember the last line

                recVehOptJnlLine3.Copy(recVehOptJnlLine);
                recVehOptJnlLine3.DeleteAll;

                recVehOptJnlLine3.Reset;
                recVehOptJnlLine3.SetRange("Journal Template Name", recVehOptJnlLine."Journal Template Name");
                recVehOptJnlLine3.SetRange("Journal Batch Name", recVehOptJnlLine."Journal Batch Name");
                if not recVehOptJnlLine3.FindLast then
                    if IncStr(recVehOptJnlLine."Journal Batch Name") <> '' then begin
                        recVehOptJnlBatch.Delete;
                        recVehOptJnlBatch.Name := IncStr(recVehOptJnlLine."Journal Batch Name");
                        if recVehOptJnlBatch.Insert then;
                        recVehOptJnlLine."Journal Batch Name" := recVehOptJnlBatch.Name;
                    end;

                recVehOptJnlLine3.SetRange("Journal Batch Name", recVehOptJnlLine."Journal Batch Name");
                if (recVehOptJnlBatch."No. Series" = '') and not recVehOptJnlLine3.FindLast then begin
                    recVehOptJnlLine3.Init;
                    recVehOptJnlLine3."Journal Template Name" := recVehOptJnlLine."Journal Template Name";
                    recVehOptJnlLine3."Journal Batch Name" := recVehOptJnlLine."Journal Batch Name";
                    recVehOptJnlLine3."Line No." := 10000;
                    recVehOptJnlLine3.Insert;
                    recVehOptJnlLine3.fSetUpNewLine(recVehOptJnlLine2);
                    recVehOptJnlLine3.Modify;
                end;
            end;
        end;
        if recVehOptJnlBatch."No. Series" <> '' then
            NoSeriesBatch.SaveState();
        if recNoSeries.FindSet then
            repeat
                Evaluate(iPostingNoSeriesNo, recNoSeries.Description);
                NoSeriesBatch2[iPostingNoSeriesNo].SaveState();
            until recNoSeries.Next = 0;

        dlgWindow.Close;
        Commit;
        Clear(cuVehOptJnlCheckLine);
        Clear(cuVehOptJnlPostLine);

        Commit;
    end;


    procedure fPrePostLine(var recVehOptJnlLine: Record "Vehicle Opt. Jnl. Line")
    begin
        //MŌĆ░r├®is: Veikt pirms grŲÆmato├Ģanas pasŲÆkumus - pŲÆrbaudes
        if (recVehOptJnlBatch."No. Series" <> '') and
  (recVehOptJnlLine."Document No." <> codLastDocNo2)
then
            recVehOptJnlLine.TestField("Document No.", NoSeriesBatch.GetNextNo(recVehOptJnlBatch."No. Series", recVehOptJnlLine."Posting Date", false));

        codLastDocNo2 := recVehOptJnlLine."Document No.";

        if recVehOptJnlLine."Posting No. Series" = '' then begin
            recVehOptJnlLine."Posting No. Series" := recVehOptJnlBatch."No. Series";
            codLastDocNo := recVehOptJnlLine."Document No.";  //21.03.2013 EDMS P8
            codLastPostedDocNo := recVehOptJnlLine."Document No.";
        end else begin
            if recVehOptJnlLine."Document No." = codLastDocNo then
                recVehOptJnlLine."Document No." := codLastPostedDocNo
            else begin
                if not recNoSeries.Get(recVehOptJnlLine."Posting No. Series") then begin
                    iNoOfPostingNoSeries := iNoOfPostingNoSeries + 1;
                    if iNoOfPostingNoSeries > ArrayLen(NoSeriesBatch2) then
                        Error(
                          Text006,
                          ArrayLen(NoSeriesBatch2));
                    recNoSeries.Code := recVehOptJnlLine."Posting No. Series";
                    recNoSeries.Description := Format(iNoOfPostingNoSeries);
                    recNoSeries.Insert;
                end;
                codLastDocNo := recVehOptJnlLine."Document No.";
                Evaluate(iPostingNoSeriesNo, recNoSeries.Description);
                recVehOptJnlLine."Document No." := NoSeriesBatch2[iPostingNoSeriesNo].GetNextNo(recVehOptJnlLine."Posting No. Series", recVehOptJnlLine."Posting Date", false);
                codLastPostedDocNo := recVehOptJnlLine."Document No.";
            end;
        end;
    end;


    procedure fMakeLineCorrectnessCheck(var recVehOptJnlLine71: Record "Vehicle Opt. Jnl. Line")
    var
        recVehOptJnlLine5: Record "Vehicle Opt. Jnl. Line";
        recVehOptJnlLine53: Record "Vehicle Opt. Jnl. Line";
    begin

        if recVehOptJnlLine71."Document No." = '' then
            recVehOptJnlLine71.FieldError("Document No.");
    end;
}

