/*
Codeunit 25006706 "OriLink SIE Jnl.-Post"
{
    TableNo = "SIE Journal Line";

    trigger OnRun()
    begin
        SIEJnlLine.Copy(Rec);
        Code;
        Rec.Copy(SIEJnlLine);
    end;

    var
        GLSetup: Record "General Ledger Setup";
        SIEJnlLine: Record "SIE Journal Line";
        SIEJnlLineB: Record "SIE Journal Line";
        SIEJnlLineL: Record "SIE Journal Line";
        DimMgt: Codeunit DimensionManagement;
        SamoaMgt: Codeunit "SAMOA 3d Party Mgt.";
        SIERegL: Record "SIE Register";
        NextEntryNoL: Integer;
        TempJnlBatchName: Code[10];
        GLSetupRead: Boolean;
        Txt001: label 'In Journal Line No. %1 are empty mandatory fields: %2';
        Txt002: label 'Can''t find SIE %1 with number %2.';
        SIEItem: Record "SIE Item";
        Text002: label 'There is nothing to post. In Codeunit %1 processing %2 record %3.';


    procedure "Code"()
    var
        Text000: label 'cannot be filtered when posting recurring journals';
        Text001: label 'Do you want to post the journal lines?';
        Text003: label 'The journal lines were successfully posted.';
        Text004: label 'The journal lines were successfully posted. You are now in the %1 journal.';
    begin
        with SIEJnlLine do begin

            if "To Validate Field" <> 0 then begin
                ValidateField(SIEJnlLine);
                "To Validate Field" := 0;
                exit
            end;

            if GuiAllowed then
                if not Confirm(Text001, false) then
                    exit;

            TempJnlBatchName := "Journal Batch Name";

            SIEPostBatchRun(SIEJnlLine);

            if "Line No." = 0 then
                Message(Text002, 'OriLink SIE Jnl.-Post', TableCaption, "SIE No." + ' ' + Format("Line No."))
            else
                if TempJnlBatchName = "Journal Batch Name" then
                    Message(Text003)
                else
                    Message(
                      Text004,
                        "Journal Batch Name");

            if not Find('=><') or (TempJnlBatchName <> "Journal Batch Name") then begin
                Reset;
                FilterGroup := 2;
                SetRange("Journal Template Name", "Journal Template Name");
                SetRange("Journal Batch Name", "Journal Batch Name");
                FilterGroup := 0;
                "Line No." := 1;
            end;
        end;
    end;


    procedure SIEPostLineRunWithCheck(var SIEJnlLine2: Record "SIE Journal Line")
    begin

        SIEJnlLineL.Copy(SIEJnlLine2);
        //EDMS 2013 >>
        // TempJnlLineDimL.RESET;
        // TempJnlLineDimL.DELETEALL;
        // DimMgt.CopyJnlLineDimToJnlLineDim(TempJnlLineDim2,TempJnlLineDimL);
        //EDMS 2013 <<

        if not SIEPostLineCode then
            if not GuiAllowed then
                Message(' NOT POSSIBLE TO POST JNL');
        SIEJnlLine2 := SIEJnlLineL;

    end;


    procedure SIEPostLineRunCheck(var JnlLine: Record "SIE Journal Line"): Boolean
    var
        SIEExchMgt: Codeunit "SIE Exchange Mgt.";
        ResVar: Text[150];
    begin
        JnlLine.TestField(Posted, false);
        if JnlLine."Not Passed Auto Check" then exit(false);
        ResVar := SIEExchMgt.CheckMandatoryFields(JnlLine);
        if ResVar <> '' then begin
            if GuiAllowed then
                Error(Txt001, JnlLine."Line No.", ResVar)
            else
                Message(Txt001, JnlLine."Line No.", ResVar);

            JnlLine."Not Passed Auto Check" := true;
            JnlLine.Modify;
            exit(false)
        end;

        exit(true);
    end;


    procedure SIEPostLineCode(): Boolean
    var
        SIELedgEntry: Record "SIE Ledger Entry";
    begin
        with SIEJnlLineL do begin
            if EmptyLine(SIEJnlLineL) then begin
                if not GuiAllowed then
                    Message('NASMSG: now is inside of SIEPostLineCode WITH SIEJnlLineL EmptyLine:' +
                      Format(SIEJnlLineL."Line No."));
                exit(false);
            end;

            if not SIEPostLineRunCheck(SIEJnlLineL) then begin
                if not GuiAllowed then
                    Message('NASMSG: not possible SIEPostLineRunCheck with No:' +
                      Format(SIEJnlLineL."Line No.") + ' and SIE:' + SIEJnlLineL."SIE No.");
                exit(false);
            end;

            SIELedgEntry.Reset;
            if NextEntryNoL = 0 then begin
                SIELedgEntry.LockTable;
                if SIELedgEntry.FindLast then
                    NextEntryNoL := SIELedgEntry."Entry No.";
                NextEntryNoL := NextEntryNoL + 1;
            end;

            if SIERegL."No." = 0 then begin
                SIERegL.LockTable;
                if (not SIERegL.Find('+')) or (SIERegL."To Entry No." <> 0) then begin
                    SIERegL.Init;
                    SIERegL."No." := SIERegL."No." + 1;
                    SIERegL."From Entry No." := NextEntryNoL;
                    SIERegL."To Entry No." := NextEntryNoL;
                    SIERegL."Creation Date" := Today;
                    SIERegL."Creation Time" := Time;
                    SIERegL."Source Code" := "Source Code";
                    SIERegL."Journal Batch Name" := "Journal Batch Name";
                    SIERegL."User ID" := UserId;
                    SIERegL.Insert;
                end;
            end;
            SIERegL."To Entry No." := NextEntryNoL;
            SIERegL.Modify;

            SIELedgEntry.Init;


            SIELedgEntry."Location Code" := "Location Code";

            SIELedgEntry."External Document No." := "Document No.";
            SIELedgEntry."Code20 3" := "Code20 3";    //User ID
            SIELedgEntry."Code10 1" := "Code10 1";    //Reel No
            SIELedgEntry."Code20 2" := "Code20 2";    //Part No
            SIELedgEntry."Text50 1" := "Text50 1";    //Name
            SIELedgEntry."Decimal 1" := "Decimal 1";  //Volume
            SIELedgEntry."Date 1" := "Date 1";    //Date
            SIELedgEntry."Time 1" := "Time 1";    //Time
            SIELedgEntry.Quantity := "Decimal 1";

            //SIELedgEntry."External Document No." := "Code20 1"; //Document No

            SIELedgEntry."SIE No." := "SIE No.";

            SIELedgEntry."Global Dimension 1 Code" := "Shortcut Dimension 1 Code";
            SIELedgEntry."Global Dimension 2 Code" := "Shortcut Dimension 2 Code";

            SIELedgEntry."Source Code" := "Source Code";
            SIELedgEntry."Journal Batch Name" := "Journal Batch Name";
            SIELedgEntry."Posting Date" := WorkDate;

            SIELedgEntry.Description := Description;

            SIELedgEntry."User ID" := UserId;
            SIELedgEntry."Entry No." := NextEntryNoL;

            SIELedgEntry.Insert;

            //EDMS 2013 >>
            //   DimMgt.MoveJnlLineDimToLedgEntryDim(
            //     TempJnlLineDimL,DATABASE::"SIE Ledger Entry",SIELedgEntry."Entry No.");
            //EDMS 2013 <<
            NextEntryNoL := NextEntryNoL + 1;
        end;
        exit(true);

    end;


    procedure SIEPostLineRun(var SIEJnlLine: Record "SIE Journal Line")
    begin
        //EDMS 2013 >>
        // WITH SIEJnlLine DO BEGIN
        //   GetGLSetup;
        //   TempJnlLineDim2.RESET;
        //   TempJnlLineDim2.DELETEALL;
        //   IF "Shortcut Dimension 1 Code" <> '' THEN BEGIN
        //     TempJnlLineDim2."Table ID" := DATABASE::"SIE Journal Line";
        //      TempJnlLineDim2."Journal Template Name" := "Journal Template Name";
        //     TempJnlLineDim2."Journal Batch Name" := "Journal Batch Name";
        //     TempJnlLineDim2."Journal Line No." := "Line No.";
        //     TempJnlLineDim2."Dimension Code" := GLSetup."Global Dimension 1 Code";
        //     TempJnlLineDim2."Dimension Value Code" := "Shortcut Dimension 1 Code";
        //     TempJnlLineDim2.INSERT;
        //   END;
        //   IF "Shortcut Dimension 2 Code" <> '' THEN BEGIN
        //     TempJnlLineDim2."Table ID" := DATABASE::"SIE Journal Line";
        //     TempJnlLineDim2."Journal Template Name" := "Journal Template Name";
        //     TempJnlLineDim2."Journal Batch Name" := "Journal Batch Name";
        //     TempJnlLineDim2."Journal Line No." := "Line No.";
        //     TempJnlLineDim2."Dimension Code" := GLSetup."Global Dimension 2 Code";
        //     TempJnlLineDim2."Dimension Value Code" := "Shortcut Dimension 2 Code";
        //     TempJnlLineDim2.INSERT;
        //   END;
        // END;
        //EDMS 2013 <<

        SIEPostLineRunWithCheck(SIEJnlLine);

    end;


    procedure EmptyLine(JnlLine: Record "SIE Journal Line"): Boolean
    begin
        exit(JnlLine."Decimal 1" = 0)
    end;

    local procedure GetGLSetup()
    begin
        if not GLSetupRead then
            GLSetup.Get;
        GLSetupRead := true;
    end;


    procedure SIEPostBatchRun(var SIEJnlLineBRec: Record "SIE Journal Line")
    begin
        SIEJnlLineB.Copy(SIEJnlLineBRec);
        SIEPostBatchCode;
        SIEJnlLineBRec := SIEJnlLineB;
    end;

    local procedure SIEPostBatchCode()
    var
        SIEJnlLine2: Record "SIE Journal Line";
        SIEJnlLine3: Record "SIE Journal Line";
        SIELedgEntry: Record "SIE Ledger Entry";
        SIEReg: Record "SIE Register";
        NoSeries: Record "No. Series" temporary;
        NoSeriesMgt: Codeunit NoSeriesManagement;
        NoSeriesMgt2: array[10] of Codeunit NoSeriesManagement;
        Window: Dialog;
        LineCount: Integer;
        StartLineNo: Integer;
        NoOfRecords: Integer;
        SIERegNo: Integer;
        LastDocNo: Code[20];
        LastDocNo2: Code[20];
        LastPostedDocNo: Code[20];
        NoOfPostingNoSeries: Integer;
        Text000: label 'cannot exceed %1 characters';
        Text001: label 'Journal Batch Name    #1##########\\';
        Text002: label 'Checking lines        #2######\';
        Text003: label 'Posting lines         #3###### @4@@@@@@@@@@@@@\';
        Text004: label 'Updating lines        #5###### @6@@@@@@@@@@@@@';
        Text005: label 'Posting lines         #3###### @4@@@@@@@@@@@@@';
        Text006: label 'A maximum of %1 posting number series can be used in each journal.';
        Text007: label '<Month Text>';
        PostingNoSeriesNo: Integer;
    begin
        with SIEJnlLineB do begin
            SetRange("Journal Template Name", "Journal Template Name");
            SetRange("Journal Batch Name", "Journal Batch Name");
            SetRange(Posted, false);
            SetRange("Not Passed Auto Check", false);
            if RECORDLEVELLOCKING then
                LockTable;
            if not FindFirst then begin
                "Line No." := 0;
                Commit;
                if not GuiAllowed then
                    Message('there is no record to post due to filter:' + GetFilters);  // TO BE INFO for SAP
                exit;
            end;
            if GuiAllowed then
                Window.Open(
                  Text001 +
                  Text002 +
                  Text005);
            if GuiAllowed then
                Window.Update(1, "Journal Batch Name");

            // Check lines
            LineCount := 0;
            StartLineNo := "Line No.";
            repeat
                LineCount := LineCount + 1;
                if GuiAllowed then Window.Update(2, LineCount);
                SIEPostBatchCheckRecurringLine(SIEJnlLineB);

                //EDMS 2013 >>
                    // JnlLineDim.SETRANGE("Table ID",DATABASE::"SIE Journal Line");
                    // JnlLineDim.SETRANGE("Journal Template Name","Journal Template Name");
                    // JnlLineDim.SETRANGE("Journal Batch Name","Journal Batch Name");
                    // JnlLineDim.SETRANGE("Journal Line No.","Line No.");
                    // JnlLineDim.SETRANGE("Allocation Line No.",0);
                    // TempJnlLineDim.DELETEALL;
                    // DimMgt.CopyJnlLineDimToJnlLineDim(JnlLineDim,TempJnlLineDim);
                //EDMS 2013 <<

                SIEPostLineRunCheck(SIEJnlLineB);
                if Next = 0 then
                    Find('-');
            until "Line No." = StartLineNo;
            NoOfRecords := LineCount;

            //  LedgEntryDim.LOCKTABLE; //EDMS 2013
            SIELedgEntry.LockTable;
            if RECORDLEVELLOCKING then
                if SIELedgEntry.Find('+') then;
            SIEReg.LockTable;
            if SIEReg.Find('+') and (SIEReg."To Entry No." = 0) then
                SIERegNo := SIEReg."No."
            else
                SIERegNo := SIEReg."No." + 1;

            // Post lines
            LineCount := 0;
            LastDocNo := '';
            LastDocNo2 := '';
            LastPostedDocNo := '';
            Find('-');
            Clear(SIERegL);  // Needed because of inexistence of post-line codeunit
            repeat
                LineCount := LineCount + 1;
                if GuiAllowed then Window.Update(3, LineCount);
                if GuiAllowed then Window.Update(4, ROUND(LineCount / NoOfRecords * 10000, 1));
                //LastDocNo2 := "Document No.";
                SIEPostBatchMakeRecurringTexts(SIEJnlLineB);
                if "Posting No. Series" = '' then
                    "Posting No. Series" := ''// SIEJnlBatch."No. Series"
                else
                    if not EmptyLine(SIEJnlLineB) then
                        if "Document No." = LastDocNo then
                            "Document No." := LastPostedDocNo
                        else begin
                            if not NoSeries.Get("Posting No. Series") then begin
                                NoOfPostingNoSeries := NoOfPostingNoSeries + 1;
                                if NoOfPostingNoSeries > ArrayLen(NoSeriesMgt2) then
                                    Error(
                                      Text006,
                                      ArrayLen(NoSeriesMgt2));
                                NoSeries.Code := "Posting No. Series";
                                NoSeries.Description := Format(NoOfPostingNoSeries);
                                NoSeries.Insert;
                            end;
                            LastDocNo := "Document No.";
                            Evaluate(PostingNoSeriesNo, NoSeries.Description);
                            "Document No." := NoSeriesMgt2[PostingNoSeriesNo].GetNextNo("Posting No. Series", "Posting Date", false);
                            LastPostedDocNo := "Document No.";
                        end;
                //EDMS 2013 >>
                    // JnlLineDim.SETRANGE("Table ID",DATABASE::"SIE Journal Line");
                    // JnlLineDim.SETRANGE("Journal Template Name","Journal Template Name");
                    // JnlLineDim.SETRANGE("Journal Batch Name","Journal Batch Name");
                    // JnlLineDim.SETRANGE("Journal Line No.","Line No.");
                    // JnlLineDim.SETRANGE("Allocation Line No.",0);
                    // TempJnlLineDim.DELETEALL;
                    // DimMgt.CopyJnlLineDimToJnlLineDim(JnlLineDim,TempJnlLineDim);
                //EDMS 2013 <<
                SIEPostLineRunWithCheck(SIEJnlLineB)
            until Next = 0;

            if not SIEReg.Find('+') or (SIEReg."No." <> SIERegNo) then
                SIERegNo := 0;

            Init;
            "Line No." := SIERegNo;

            // Update/delete lines
            if SIERegNo <> 0 then begin
                if not RECORDLEVELLOCKING then begin
                    //      JnlLineDim.LOCKTABLE(TRUE,TRUE);//EDMS 2013
                    LockTable(true, true);
                end;

                SIEJnlLine2.CopyFilters(SIEJnlLineB);
                SIEJnlLine2.SetFilter("SIE No.", '<>%1', '');
                if SIEJnlLine2.Find('+') then; // Remember the last line
                                               //EDMS 2013 >>
                                                    //  JnlLineDim.SETRANGE("Table ID",DATABASE::"SIE Journal Line");
                                                    //  JnlLineDim.COPYFILTER("Journal Template Name","Journal Template Name");
                                                    //  JnlLineDim.COPYFILTER("Journal Batch Name","Journal Batch Name");
                                                    //  JnlLineDim.SETRANGE("Allocation Line No.",0);
                                               //EDMS 2013 <<

                SIEJnlLine3.Copy(SIEJnlLineB);
                if SIEJnlLine3.Find('-') then
                    repeat
                        //EDMS 2013 >>
                                //   JnlLineDim.SETRANGE("Journal Line No.",SIEJnlLine3."Line No.");
                                //   JnlLineDim.DELETEALL;
                        //EDMS 2013 <<
                        SIEJnlLine3.Delete;
                    until SIEJnlLine3.Next = 0;
                SIEJnlLine3.Reset;
                SIEJnlLine3.SetRange("Journal Template Name", "Journal Template Name");
                SIEJnlLine3.SetRange("Journal Batch Name", "Journal Batch Name");

                //    END;
            end;
            Commit;
        end;

        Commit;

    end;

    local procedure SIEPostBatchCheckRecurringLine(var SIEJnlLine2: Record "SIE Journal Line")
    begin
    end;

    local procedure SIEPostBatchMakeRecurringTexts(var SIEJnlLine2: Record "SIE Journal Line")
    var
        Day: Integer;
        Month: Integer;
        Week: Integer;
        MonthText: Text[30];
        AccountingPeriod: Record "Accounting Period";
        Text007: label '<Month Text>';
    begin
        with SIEJnlLine2 do begin
            if ("SIE No." <> '') and ("Recurring Method" <> 0) then begin
                Day := Date2dmy("Posting Date", 1);
                Week := Date2dwy("Posting Date", 2);
                Month := Date2dmy("Posting Date", 2);
                MonthText := Format("Posting Date", 0, Text007);
                AccountingPeriod.SetRange("Starting Date", 0D, "Posting Date");
                if not AccountingPeriod.Find('+') then
                    AccountingPeriod.Name := '';
                "Document No." :=
                  DelChr(
                    PadStr(
                      StrSubstNo("Document No.", Day, Week, Month, MonthText, AccountingPeriod.Name),
                      MaxStrLen("Document No.")),
                    '>');
                Description :=
                  DelChr(
                    PadStr(
                      StrSubstNo(Description, Day, Week, Month, MonthText, AccountingPeriod.Name),
                      MaxStrLen(Description)),
                      '>');
            end;
        end;
    end;


    procedure ValidateField(var JnlLine: Record "SIE Journal Line")
    var
        SIEJnlLine: Record "SIE Journal Line";
        Item: Record Item;
        SIEObjCat: Record "SIE Object Category";
        SIEObject: Record "SIE Object";
        JournalBatch: Record "Item Journal Batch";
        Location: Record Location;
    begin
        with JnlLine do begin
            case "To Validate Field" of
                FieldNo("Int 4"):          //SIEBin
                    begin
                        GetLocBinBySIEBin("SIE No.", JnlLine."Int 4",
                        JnlLine."Code10 1",             //Location
                        JnlLine."Code20 2");           //Bin Code
                        GetItemByBin(JnlLine."Code10 1", JnlLine."Code20 2",
                        JnlLine."Code20 3");         //Item No.
                        if GuiAllowed then
                            Item.Get(JnlLine."Code20 2")
                        else
                            if not Item.Get(JnlLine."Code20 2") then exit;
                        Description := Item.Description
                    end;
                FieldNo("Code10 1"):          //ReelNo
                    if "Int 4" = 0 then begin
                        SIEObjCat.Reset;
                        SIEObjCat.SetRange("SIE No.", "SIE No.");  //15.03.2013 EDMS P8
                        SIEObjCat.SetRange(SYSType, SIEObjCat.Systype::" ");
                        if not SIEObjCat.FindFirst then
                            if GuiAllowed then
                                Error(Txt001, SIEObjCat.TableCaption)
                            else
                                exit;
                        if not JournalBatch.Get("Journal Template Name", "Journal Batch Name") then exit;
                        if "Location Code" = '' then begin
                            if not Location.Get(JournalBatch."Location Code") then exit;
                        end else
                            if not Location.Get("Location Code") then exit;

                        SIEObject.Reset;
                        SIEObject.SetCurrentkey("SIE No.", Category, "Location Code");
                        SIEObject.SetRange("SIE No.", "SIE No.");
                        SIEObject.SetRange(Category, SIEObjCat."No.");
                        SIEObject.SetRange("Location Code", Location.Code);
                        if not SIEObject.FindFirst then exit;
                        //SIE No.,Category,No.,Code20 1
                        if not SIEItem.Get("SIE No.", SIEObjCat."No.", SIEObject."No.", "Code10 1") then exit;
                        if not Item.Get(SIEItem."Item No.") then exit;
                        "Code20 2" := Item."No.";
                        Description := Item.Description;
                    end;
            end
        end
    end;


    procedure GetItemByBin(Loc: Code[10]; Bin: Code[20]; var ItemNo: Code[20])
    var
        BinCont: Record "Bin Content";
    begin
        with BinCont do begin
            Reset;
            SetCurrentkey(Default, "Location Code");
            SetRange("Location Code", Loc);
            SetRange("Bin Code", Bin);
            SetRange(Default, true);
            if FindFirst then;
            case true of
                Count > 1:
                    if not GuiAllowed then
                        ItemNo := '';
                Count = 0:
                    ItemNo := '';
                else
                    ItemNo := "Item No."
            end;
        end
    end;


    procedure GetLocBinBySIEBin(SIENo: Code[10]; SIEBin: Integer; var LocCode: Code[10]; var BinCode: Code[20])
    var
        SIEObjCat: Record "SIE Object Category";
        Bin: Record Bin;
        SIEObject: Record "SIE Object";
    begin
        SIEObjCat.Reset;
        SIEObjCat.SetRange(SYSType, SIEObjCat.Systype::Bin);
        if not SIEObjCat.FindFirst then
            if GuiAllowed then
                Error(Txt001, SIEObjCat.TableCaption)
            else
                exit;
        with SIEObject do begin
            Reset;
            SetRange("SIE No.", SIENo);
            SetRange(Category, SIEObjCat."No.");
            SetRange("No.", Format(SIEBin));
            if not FindFirst then
                if GuiAllowed then
                    Error(Txt002, SIEObjCat.SYSType, SIEBin)
                else
                    exit;
            if GuiAllowed then
                Bin.Get("NAV No.", "NAV No. 2")
            else
                if not Bin.Get("NAV No.", "NAV No. 2") then exit;
            LocCode := "NAV No.";
            BinCode := "NAV No. 2"
        end
    end;
}
*/