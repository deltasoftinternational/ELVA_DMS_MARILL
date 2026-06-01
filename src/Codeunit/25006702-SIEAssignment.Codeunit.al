/*
Codeunit 25006702 "SIE Assignment"
{
    // 08.05.2013 EDMS P8
    //   * FIX new created line (when more than one line with the same item) should not correct existing reservation
    // 
    // 05.03.2013 EDMS P8
    //   * fix - now will not bring strmenu if automated
    // 
    // 31.03.2009 Karlo
    //   *New function AutoAsign


    trigger OnRun()
    begin
    end;

    var
        SIESetup: Record "SIE Setup";
        ServLine: Record "Service Line EDMS";
        ItemJnlLineTmp: Record "Item Journal Line" temporary;
        LookUpMgt: Codeunit LookUpManagement;
        Text001: label 'There is nothing to assign. %1 in %2';
        Text002: label 'You cannot %1 more than %2 units in %3 = %4.';
        PutInTakeOut: Codeunit "Service Transfer Mgt.";
        NextLine: Integer;
        SrcType: Option Service,Sale;
        TrnsfrType: Option " ","Take-out","Put-in";
        Text003: label 'Cannot find default bin.';
        Text004: label 'assign';
        Text005: label 'unassign';
        Text006: label 'Do you want to post the assignment lines?';
        Text007: label 'The assignment lines were successfully posted.';
        Text009: label 'Do you want to post the assignment cancelling line?';
        Text010: label 'The unassignment line was successfully posted.';
        Text012: label 'Qty. to Assign is 0. Are you sure you want to take-out all Qty. Assigned?';
        Text013: label 'You can''t transfer this type of lines.';
        Text014: label 'Do you want to join item %2 assignment line %1 with order line nr. %3?';
        Text015: label 'There is nothing to transfer.';


    procedure InsertAssgnt(SIEAssgnt: Record "SIE Assignment"; SIELedgEntry: Record "SIE Ledger Entry"; var NextLineNo: Integer)
    var
        SIEAssgnt2: Record "SIE Assignment";
    begin
        NextLineNo := NextLineNo + 10000;

        SIEAssgnt2.Init;
        SIEAssgnt2."Applies-to Type" := SIEAssgnt."Applies-to Type";
        SIEAssgnt2."Applies-to Doc. Type" := SIEAssgnt."Applies-to Doc. Type";
        SIEAssgnt2."Applies-to Doc. No." := SIEAssgnt."Applies-to Doc. No.";
        SIEAssgnt2."Applies-to Doc. Line No." := SIEAssgnt."Applies-to Doc. Line No.";
        SIEAssgnt2."Line No." := NextLineNo;
        SIEAssgnt2."Entry No." := SIELedgEntry."Entry No.";
        SIELedgEntry.CalcFields("Qty. to Assign", "Qty. Assigned");
        SIEAssgnt2."Qty. to Assign" := SIELedgEntry.Quantity - SIELedgEntry."Qty. Assigned" - SIELedgEntry."Qty. to Assign";
        SIEAssgnt2.Validate("Item No.", SIELedgEntry."Code20 2");
        SIEAssgnt2.Description := SIELedgEntry.Description;
        SIEAssgnt2."Unit Cost" := SIEAssgnt."Unit Cost";
        SIEAssgnt2."Assignment Date" := WorkDate;
        SIEAssgnt2.Insert;
    end;


    procedure SuggestAssgnt(FilterSIEAssgnt: Record "SIE Assignment")
    var
        SIELedgEntry: Record "SIE Ledger Entry";
        ByItem: Code[20];
        ByDocNo: Code[20];
        SIEObject: Record "SIE Object";
        SIEAssgnt2: Record "SIE Assignment";
        ItemDesc: Text[30];
        SIESystem: Code[10];
    begin
        //Here is possible to select sie system

        SIESystem := SelectSIESytem;
        if SIESystem = '' then exit;

        with FilterSIEAssgnt do begin
            if not RECORDLEVELLOCKING then
                LockTable(true, true);

            SIEAssgnt2.SetRange("Applies-to Type", "Applies-to Type");
            SIEAssgnt2.SetRange("Applies-to Doc. Type", "Applies-to Doc. Type");
            SIEAssgnt2.SetRange("Applies-to Doc. No.", "Applies-to Doc. No.");
            SIEAssgnt2.SetRange("Applies-to Doc. Line No.", "Applies-to Doc. Line No.");
            SIEAssgnt2.SetRange(Corrected, false);
            ByDocNo := "Applies-to Doc. No.";
            TruncDocNo(ByDocNo);
            case "Applies-to Type" of
                Database::"Service Line EDMS":
                    if "Applies-to Doc. Line No." <> 0 then
                        ByItem := "Item No.";
            end;
        end;
        with SIELedgEntry do begin
            Reset;
            SetCurrentkey("External Document No.", "Code20 2");
            SetRange("SIE No.", SIESystem);
            if ByDocNo <> '' then SetRange("External Document No.", ByDocNo);
            if ByItem <> '' then SetRange("Code20 2", ByItem);
            if FindFirst then
                repeat
                    NextLine := GetNextLineNo2(SIELedgEntry."Entry No.", FilterSIEAssgnt."Line No.");
                    SIEAssgnt2.SetRange("Entry No.", "Entry No.");
                    CalcFields("Qty. Assigned");
                    if (not SIEAssgnt2.FindFirst) and (Quantity - "Qty. Assigned" > 0) then
                        InsertAssgnt(FilterSIEAssgnt, SIELedgEntry, NextLine);
                until Next = 0;
        end
    end;


    procedure SetSIEFilter(FilterAssgnt: Record "SIE Assignment"; var SIEAssgnt: Record "SIE Assignment")
    begin
        with SIEAssgnt do begin
            Reset;
            SetCurrentkey("Applies-to Type", "Applies-to Doc. Type",
              "Applies-to Doc. No.", "Applies-to Doc. Line No.", "Line No.");
            SetRange("Applies-to Type", FilterAssgnt."Applies-to Type");
            SetRange("Applies-to Doc. Type", FilterAssgnt."Applies-to Doc. Type");
            SetRange("Applies-to Doc. No.", FilterAssgnt."Applies-to Doc. No.");
            if FilterAssgnt."Applies-to Doc. Line No." <> 0 then
                SetRange("Applies-to Doc. Line No.", FilterAssgnt."Applies-to Doc. Line No.");
            SetRange(Type, Type::Main);
        end
    end;


    procedure PostAssignment(FilterSIEAssgnt: Record "SIE Assignment"; RunModeFlags: Integer)
    var
        SIEAssgnt: Record "SIE Assignment";
        SIEAssgnt2: Record "SIE Assignment";
        SIELedgEntry: Record "SIE Ledger Entry";
        NextDocLineNo: Integer;
        JnlNewLineNoIN: Integer;
        JnlNewLineNoOUT: Integer;
        Qty: Decimal;
        FoundLineNo: Integer;
        FlagsArray: array[16] of Boolean;
    begin
        //RunModeFlags IF 0 MEANS not to run TransferAll
        AdjustFlagsToArray(RunModeFlags, FlagsArray);
        SIESetup.Get;
        with SIEAssgnt do begin
            if GuiAllowed then //!
                if not Confirm(Text006, false) then
                    exit;

            SetSIEFilter(FilterSIEAssgnt, SIEAssgnt);
            SetFilter("Qty. to Assign", '<>0');
            if not FindFirst then begin
                if GuiAllowed then
                    Message(Text001, SIEAssgnt."Applies-to Doc. No.", SIEAssgnt.TableCaption);
                exit;
            end;

            FindFirst;
            repeat
                SIEAssgnt2.Get("Entry No.", "Line No.");
                SIELedgEntry.Get("Entry No.");
                SIELedgEntry.CalcFields("Qty. Assigned");
                if "Qty. to Assign" > (SIELedgEntry.Quantity - SIELedgEntry."Qty. Assigned") then
                    Error(Text002, Text004, SIELedgEntry.Quantity - SIELedgEntry."Qty. Assigned",
                      FieldCaption("Line No."), "Line No.");

                if "Applies-to Doc. Line No." = 0 then
                    if FindSIEAppliedLine(SIEAssgnt2, FoundLineNo) then
                        if GuiAllowed then //!
                            if Confirm(Text014, true, SIEAssgnt2."Line No.", SIEAssgnt2."Item No.", FoundLineNo) then
                                SIEAssgnt2."Applies-to Doc. Line No." := FoundLineNo
                            else
                                CreateDocLine(SIEAssgnt2, NextDocLineNo)
                        else
                            CreateDocLine(SIEAssgnt2, NextDocLineNo) //05.03.2013 EDMS P8
                                                                     //SIEAssgnt2."Applies-to Doc. Line No." := FoundLineNo //!
                    else
                        CreateDocLine(SIEAssgnt2, NextDocLineNo)
                // 21.12.2012 EDMS P8 - is not working for now - qty do not updates ???
                //CreateDocLine(SIEAssgnt2,NextDocLineNo)
                else
                    NextDocLineNo := SIEAssgnt2."Applies-to Doc. Line No.";

                Qty := "Qty. to Assign";
                SIEAssgnt2."Qty. to Assign" := 0;
                SIEAssgnt2.Modify;

                SIEAssgnt2."Appl. To Entry" := "Entry No.";
                SIEAssgnt2."Appl. To Line No." := "Line No.";
                NextLine := GetNextLineNo2(SIELedgEntry."Entry No.", SIEAssgnt."Line No.");
                SIEAssgnt2."Line No." := NextLine + 10000;

                SIEAssgnt2."Qty. Assigned Det." := Qty;
                SIEAssgnt2.Type := Type::Detail;
                SIEAssgnt2.Insert;
            until Next = 0;

            DistributeTransfer(FilterSIEAssgnt);
            if SIESetup."Automatic PutInTakeOut" then
                if FlagsArray[1] then
                    TransferAll(FilterSIEAssgnt);

            if GuiAllowed then
                Message(Text007);
        end;
    end;


    procedure CreateDocLine(var NewSIEAssgnt: Record "SIE Assignment"; var NextLineNo: Integer)
    begin
        with NewSIEAssgnt do begin
            case "Applies-to Type" of
                Database::"Service Line EDMS":
                    begin
                        if NextLineNo = 0 then begin
                            ServLine.Reset;
                            ServLine.SetRange("Document Type", "Applies-to Doc. Type");
                            ServLine.SetRange("Document No.", "Applies-to Doc. No.");
                            if ServLine.FindLast then
                                NextLineNo := ServLine."Line No." + 10000
                            else
                                NextLineNo := 10000;
                        end else
                            NextLineNo := NextLineNo + 10000;
                        ServLine.Init;
                        ServLine."Document Type" := NewSIEAssgnt."Applies-to Doc. Type";
                        ServLine."Document No." := NewSIEAssgnt."Applies-to Doc. No.";
                        ServLine."Line No." := NextLineNo;
                        ServLine.Insert(true);  //08.05.2013 EDMS P8
                        ServLine.Validate(Type, ServLine.Type::Item);
                        ServLine.Validate("No.", "Item No.");
                        ServLine.Validate(Quantity, "Qty. to Assign");
                        ServLine.Modify(true);  //08.05.2013 EDMS P8
                        "Applies-to Doc. Line No." := NextLineNo;
                        Modify
                    end
            end
        end
    end;


    procedure AddUnassignedTran(FilterSIEAssgnt: Record "SIE Assignment")
    var
        SIELedgEntry: Record "SIE Ledger Entry";
        SIELedgEntry2: Record "SIE Ledger Entry" temporary;
        SIEAssgnt: Record "SIE Assignment";
        SIESystem: Code[10];
    begin
        SIESystem := SelectSIESytem;
        if SIESystem = '' then exit;

        with SIELedgEntry do begin
            if FilterSIEAssgnt."Applies-to Doc. Line No." <> 0 then
                SetRange("Code20 2", FilterSIEAssgnt."Item No.");
            SetRange("SIE No.", SIESystem);
            if FindFirst then
                repeat
                    CalcFields("Qty. Assigned");
                    if Quantity - SIELedgEntry."Qty. Assigned" > 0 then begin
                        SIELedgEntry2.TransferFields(SIELedgEntry);
                        SIELedgEntry2.Insert
                    end
                until Next = 0;
        end;
        if LookUpSIETrans(SIELedgEntry2) then begin
            NextLine := GetNextLineNo2(SIELedgEntry2."Entry No.", FilterSIEAssgnt."Line No.");
            with SIEAssgnt do begin
                SetRange("Applies-to Type", FilterSIEAssgnt."Applies-to Type");
                SetRange("Applies-to Doc. Type", FilterSIEAssgnt."Applies-to Doc. Type");
                SetRange("Applies-to Doc. No.", FilterSIEAssgnt."Applies-to Doc. No.");
                SetRange(Corrected, false);
                SetRange(Type, Type::Main);
                SetRange("Entry No.", SIELedgEntry2."Entry No.");
                if not FindFirst then
                    InsertAssgnt(FilterSIEAssgnt, SIELedgEntry2, NextLine)
            end
        end
    end;


    procedure LookUpSIETrans(var SIELedgEntry: Record "SIE Ledger Entry"): Boolean
    var
        SIELedgerEntries: Page "SIE Object List";
    begin
        Clear(SIELedgerEntries);
        SIELedgerEntries.SetTableview(SIELedgEntry);
        SIELedgerEntries.LookupMode(true);
        if Page.RunModal(Page::"SIE Ledger Entries", SIELedgEntry) = Action::LookupOK then
            exit(true)
        else
            exit(false)
    end;


    procedure PostUnAssignment(var SIEAssgnt: Record "SIE Assignment"; Auto: Boolean)
    var
        SrvLine: Record "Service Line EDMS" temporary;
        SlsLine: Record "Sales Line" temporary;
        SIELedgEntry: Record "SIE Ledger Entry";
        SIEAssgnt2: Record "SIE Assignment";
        SIEAssgnt3: Record "SIE Assignment";
        JnlNewLineNo: Integer;
        Qty: Decimal;
    begin
        SIESetup.Get;
        with SIEAssgnt do begin
            if not Auto then begin
                if not GuiAllowed then exit;
                if not Confirm(Text009, false) then
                    exit;
            end;
            //Test block
            CalcFields("Doc. Qty. Assigned");
            if "Doc. Qty. Assigned" = 0 then Error(Text001);

            if "Qty. to Assign" = 0 then begin
                if not Auto then begin
                    if not GuiAllowed then exit;
                    if not Confirm(Text012, true) then exit;
                end;
                Qty := "Doc. Qty. Assigned";
                Corrected := true;
            end else begin
                if "Qty. to Assign" > "Doc. Qty. Assigned" then
                    Error(Text002, Text005, "Qty. Assigned", FieldCaption("Line No."), "Line No.")
                else
                    if "Qty. to Assign" = "Doc. Qty. Assigned" then Corrected := true;
                Qty := "Qty. to Assign";
                "Qty. to Assign" := 0;
            end;
            Modify;
            if Corrected then begin
                SIEAssgnt3.SetRange("Entry No.", "Entry No.");
                SIEAssgnt3.SetRange(Type, Type::Detail);
                SIEAssgnt3.SetRange("Applies-to Type", "Applies-to Type");
                SIEAssgnt3.SetRange("Applies-to Doc. Type", SIEAssgnt."Applies-to Doc. Type");
                SIEAssgnt3.SetRange("Applies-to Doc. No.", SIEAssgnt."Applies-to Doc. No.");
                SIEAssgnt3.ModifyAll(Corrected, true);
            end;

            SIEAssgnt2.Copy(SIEAssgnt);

            SIELedgEntry.Get("Entry No.");

            "Qty. Assigned Det." := -Qty;

            "Appl. To Entry" := "Entry No.";
            "Appl. To Line No." := "Line No.";
            Type := Type::Detail;

            NextLine := GetNextLineNo2(SIELedgEntry."Entry No.", SIEAssgnt."Line No.");
            "Line No." := NextLine + 10000;

            Insert;

            DistributeTransfer(SIEAssgnt);
            if SIESetup."Automatic PutInTakeOut" and not Auto then
                TransferAll(SIEAssgnt);
            if not Auto then
                if GuiAllowed then
                    Message(Text010)
        end
    end;


    procedure SelectSIESytem(): Code[10]
    var
        SpecInvtEquip: Record "Special Inventory Equipment";
        Selection: Integer;
        SIESystems: Text[500];
        CommaPosition: Integer;
        CurrExpr: Code[10];
        i: Integer;
        RepeatedCount: Integer;
    begin
        SIESetup.Get;

        SpecInvtEquip.Reset;
        SpecInvtEquip.SetRange(Active, true);
        if SpecInvtEquip.FindFirst then begin
            SIESystems := SpecInvtEquip."No.";
            while SpecInvtEquip.Next <> 0 do begin
                SIESystems := SIESystems + ',' + SpecInvtEquip."No.";
            end
        end;

        CommaPosition := StrPos(SIESystems, ',');
        if (CommaPosition > 0) then begin
            //05.03.2013 EDMS P8 >>
            if GuiAllowed then begin
                if (SIESetup."Default SIE Sys" > 0) then
                    Selection := StrMenu(SIESystems, SIESetup."Default SIE Sys")
                else
                    Selection := StrMenu(SIESystems, 1);
            end else begin
                if (SIESetup."Default SIE Sys" > 0) then begin
                    Selection := SIESetup."Default SIE Sys";
                end else begin
                    Selection := 1;
                    SIESetup."Default SIE Sys" := Selection;
                    SIESetup.Modify;
                end;
            end;
            if Selection = 0 then
                exit;
            //05.03.2013 EDMS P8 <<
            //27.03.2013 EDMS P8 >>
            if SpecInvtEquip.FindFirst then;
            repeat
                Selection -= 1;
                if Selection > 0 then
                    SpecInvtEquip.Next;
            until Selection <= 0;
            //27.03.2013 EDMS P8 <<
            CurrExpr := SpecInvtEquip."No.";
            exit(CurrExpr)
        end else
            exit(SIESystems);
    end;


    procedure MoveAssgntToPostedDocLine(FromApplType: Integer; FromDocType: Option quote,"order",invoice; FromDocNo: Code[20]; FromLineNo: Integer; ToApplType: Integer; ToDocType: Option quote,"order",invoice; ToDocNo: Code[20]; ToLineNo: Integer)
    var
        SIEAssgnt: Record "SIE Assignment";
        SIEAssgnt2: Record "SIE Assignment";
        NextLineNo: Integer;
        CurrEntry: Integer;
    begin
        with SIEAssgnt do begin
            Reset;
            SetRange("Applies-to Type", FromApplType);
            SetRange("Applies-to Doc. Type", FromDocType);
            SetRange("Applies-to Doc. No.", FromDocNo);
            if FromLineNo <> 0 then
                SetRange("Applies-to Doc. Line No.", FromLineNo);
            if FindFirst then begin
                repeat
                    if CurrEntry <> "Entry No." then begin
                        NextLineNo := GetNextLineNo2("Entry No.", "Line No.");
                        CurrEntry := "Entry No."
                    end;
                    NextLineNo += 10000;
                    SIEAssgnt2.Init;
                    SIEAssgnt2.TransferFields(SIEAssgnt);
                    SIEAssgnt2."Applies-to Type" := ToApplType;
                    SIEAssgnt2."Applies-to Doc. Type" := ToDocType;
                    SIEAssgnt2."Applies-to Doc. No." := ToDocNo;
                    SIEAssgnt2."Line No." := NextLineNo;
                    if ToLineNo <> 0 then
                        SIEAssgnt2."Applies-to Doc. Line No." := ToLineNo;
                    SIEAssgnt2.Insert
                until Next = 0;
                DeleteAll
            end
        end
    end;


    procedure GetNextLineNo2(EntryNo: Integer; LineNo: Integer): Integer
    var
        SIEAssgnt: Record "SIE Assignment";
    begin
        with SIEAssgnt do begin
            Reset;
            SetRange("Entry No.", EntryNo);
            if FindLast then exit("Line No.") else exit(LineNo)
        end
    end;


    procedure InitTransfer(FilterSIEAssgnt: Record "SIE Assignment"; TrsfrType: Option " ","Take-out","Put-in"; var JnlNewLine: Integer)
    var
        SrvLine: Record "Service Line EDMS" temporary;
        SlsLine: Record "Sales Line" temporary;
    begin
        Clear(ItemJnlLineTmp);
        with FilterSIEAssgnt do begin
            case "Applies-to Type" of
                Database::"Service Line EDMS":
                    SrcType := Srctype::Service;
                Database::"Sales Line":
                    SrcType := Srctype::Sale;
                else
                    Error(Text013);
            end;

            SrvLine.SetRange("Document No.", "Applies-to Doc. No.");
            SrvLine.SetRange("Line No.", "Applies-to Doc. Line No.");
            SlsLine.SetRange("Document No.", "Applies-to Doc. No.");
            SlsLine.SetRange("Line No.", "Applies-to Doc. Line No.");

            Clear(PutInTakeOut);

            //PutInTakeOut.Initialize(ItemJnlLineTmp,SrcType,TrsfrType,1,"Applies-to Doc. No.",0,SrvLine,SlsLine);

            //JnlNewLine := PutInTakeOut.LinkTransferWithService(ItemJnlLineTmp);
        end
    end;


    procedure DistributeTransfer(FilterSIEAssgnt: Record "SIE Assignment") Result: Boolean
    var
        SIEAssgnt: Record "SIE Assignment";
        SIEAssgnt2: Record "SIE Assignment";
        CurrLineNo: Integer;
        QtyOnLine: Decimal;
        QtyToBe: Decimal;
    begin
        Result := false;
        with SIEAssgnt do begin
            SetSIEFilter(FilterSIEAssgnt, SIEAssgnt);
            ModifyAll("Qty. to Transfer", 0);
            SIEAssgnt2.Copy(SIEAssgnt);

            if FindFirst then
                repeat
                    if "Applies-to Doc. Line No." = 0 then begin   //New line - all clear to understand
                        if "Qty. to Assign" <> 0 then begin
                            "Qty. to Transfer" := "Qty. to Assign";
                            Modify;
                            Result := true;
                        end;
                    end else begin
                        if CurrLineNo <> "Applies-to Doc. Line No." then begin  //Next Line No - calculate sums for order line.
                            CurrLineNo := "Applies-to Doc. Line No.";
                            SIEAssgnt2.SetRange("Applies-to Doc. Line No.", "Applies-to Doc. Line No.");
                            SIEAssgnt2.CalcSums("Qty. to Assign");
                            QtyToBe := SIEAssgnt2."Qty. to Assign";
                            SIEAssgnt2.SetRange(Type, Type::Detail);
                            SIEAssgnt2.CalcSums("Qty. Assigned Det.");
                            QtyToBe += SIEAssgnt2."Qty. Assigned Det.";
                            SIEAssgnt2.SetRange(Type, Type::Main);
                            case "Applies-to Type" of
                                Database::"Service Line EDMS":
                                    begin
                                        ServLine.Get("Applies-to Doc. Type", "Applies-to Doc. No.", "Applies-to Doc. Line No.");
                                        QtyOnLine := ServLine.CalcTransferedQuantity;
                                    end
                                else
                                    exit(false)
                            end;
                            QtyToBe -= QtyOnLine;
                            Result := Result or (QtyToBe <> 0);
                        end;
                        CalcFields("Qty. Assigned");                             //Split sums by assignment lines
                        if QtyToBe <> 0 then
                            if Abs(QtyToBe) > "Qty. to Assign" + "Qty. Assigned" then begin
                                "Qty. to Transfer" := "Qty. to Assign" + "Qty. Assigned";
                                if QtyToBe < 0 then "Qty. to Transfer" := "Qty. to Transfer" * -1;
                                QtyToBe -= "Qty. to Transfer";
                            end else begin
                                "Qty. to Transfer" := QtyToBe;
                                QtyToBe := 0;
                            end;
                        if ("Qty. Assigned" = 0) and ("Qty. to Transfer" = 0) and ("Qty. to Assign" = 0) then
                            Corrected := true;
                        Modify
                    end
                until Next = 0;
            if QtyToBe <> 0 then begin
                Corrected := false;
                "Qty. to Transfer" += QtyToBe;
                Modify
            end
        end;
        exit(Result);
    end;


    procedure TransferAll(FilterSIEAssgnt: Record "SIE Assignment")
    var
        SIEAssgnt: Record "SIE Assignment";
        SIELedgEntry: Record "SIE Ledger Entry";
        ServiceHeader: Record "Service Header EDMS";
        JnlLine: Integer;
        ServiceTransferMgt: Codeunit "Service Transfer Mgt.";
        isFound: Boolean;
    begin
        isFound := false;
        if DistributeTransfer(FilterSIEAssgnt) then
            with SIEAssgnt do begin
                SetSIEFilter(FilterSIEAssgnt, SIEAssgnt);
                SetFilter("Applies-to Doc. Line No.", '<>0');
                SetFilter("Qty. to Transfer", '>0');
                if FindFirst then begin
                    isFound := true;
                    ServiceHeader.Get(SIEAssgnt."Applies-to Doc. Type", SIEAssgnt."Applies-to Doc. No.");
                    if not GuiAllowed then
                        Message('NASMSG: is going to ServiceTransferMgt.CreateTransferOrderBySIEAssign');
                    ServiceTransferMgt.CreateTransferOrderBySIEAssign(ServiceHeader, SIEAssgnt, true, 0);
                    Commit;
                    if not GuiAllowed then
                        Message('NASMSG: is going to PostTransferAll');
                    PostTransferAll(SIEAssgnt);
                end;
                SetFilter("Qty. to Transfer", '<0');
                if FindFirst then begin
                    isFound := true;
                    ServiceHeader.Get(SIEAssgnt."Applies-to Doc. Type", SIEAssgnt."Applies-to Doc. No.");
                    if not GuiAllowed then
                        Message('NASMSG: is going to ServiceTransferMgt.CreateTransferOrderBySIEAssign for negativ');
                    ServiceTransferMgt.CreateTransferOrderBySIEAssign(ServiceHeader, SIEAssgnt, false, 0);
                    Commit;
                    if not GuiAllowed then
                        Message('NASMSG: is going to PostTransferAll for negativ');
                    PostTransferAll(SIEAssgnt);
                end;

                DistributeTransfer(FilterSIEAssgnt);
            end;

        if not isFound then
            if GuiAllowed then
                Message(Text015);
    end;


    procedure PostTransferAll(FilterSIEAssgnt: Record "SIE Assignment")
    var
        SIEAssgnt: Record "SIE Assignment";
        SIELedgEntry: Record "SIE Ledger Entry";
        ServiceHeader: Record "Service Header EDMS";
        JnlLine: Integer;
        ServiceTransferMgt: Codeunit "Service Transfer Mgt.";
    begin
        //IF DistributeTransfer(FilterSIEAssgnt) THEN
        with SIEAssgnt do begin
            SetSIEFilter(FilterSIEAssgnt, SIEAssgnt);
            SetFilter("Applies-to Doc. Line No.", '<>0');
            SetFilter("Qty. to Transfer", '<>0');
            if FindFirst then begin
                if ServiceHeader.Get(ServiceHeader."document type"::Order, SIEAssgnt."Applies-to Doc. No.") then
                    ServiceTransferMgt.PostTransOrderHByServH(ServiceHeader, 0);
                //SETRANGE(Type);  // P8 ??? must be removed WHEN transfer post will be finished
                ModifyAll("Qty. to Transfer", 0);
            end;
        end
    end;


    procedure TruncDocNo(var DocNo: Code[20])
    var
        TmpStr: Text[20];
    begin
        //WHILE (DocNo <> '') AND (DocNo[1] IN ['A'..'Z','0']) DO BEGIN
        //  DocNo := COPYSTR(DocNo,2,STRLEN(DocNo)-1);
        //END;
    end;


    procedure FindSIEAppliedLine(SIEAssgnt: Record "SIE Assignment"; var FoundLine: Integer): Boolean
    begin
        with SIEAssgnt do
            case "Applies-to Type" of
                Database::"Service Line EDMS":
                    begin
                        ServLine.Reset;
                        ServLine.SetCurrentkey(Type, "No.");
                        ServLine.SetRange("Document Type", "Applies-to Doc. Type");
                        ServLine.SetRange("Document No.", "Applies-to Doc. No.");
                        ServLine.SetRange(Type, ServLine.Type::Item);
                        ServLine.SetRange("No.", "Item No.");
                        if ServLine.FindLast then begin
                            FoundLine := ServLine."Line No.";
                            exit(true)
                        end
                    end
            end;
        exit(false)
    end;


    procedure AddUnassignedTranSilent(FilterSIEAssgnt: Record "SIE Assignment"; EntryNo: Integer)
    var
        SIELedgEntry: Record "SIE Ledger Entry";
        SIELedgEntry2: Record "SIE Ledger Entry" temporary;
        SIEAssgnt: Record "SIE Assignment";
        SIESystem: Code[10];
    begin
        //05.03.2013 EDMS P8 >>
        with SIELedgEntry do begin
            Get(EntryNo);
            SIESystem := "SIE No.";
            if SIESystem = '' then
                SIESystem := SelectSIESytem;
            if SIESystem = '' then exit;
            //05.03.2013 EDMS P8 <<

            CalcFields("Qty. Assigned");
            if Quantity - SIELedgEntry."Qty. Assigned" > 0 then begin
                SIELedgEntry2.TransferFields(SIELedgEntry);
                SIELedgEntry2.Insert
            end else
                exit;
        end;


        NextLine := GetNextLineNo2(SIELedgEntry2."Entry No.", FilterSIEAssgnt."Line No.");

        with SIEAssgnt do begin
            SetRange("Applies-to Type", FilterSIEAssgnt."Applies-to Type");
            SetRange("Applies-to Doc. Type", FilterSIEAssgnt."Applies-to Doc. Type");
            SetRange("Applies-to Doc. No.", FilterSIEAssgnt."Applies-to Doc. No.");
            SetRange(Corrected, false);
            SetRange(Type, Type::Main);
            SetRange("Entry No.", SIELedgEntry2."Entry No.");
            if not FindFirst then
                InsertAssgnt(FilterSIEAssgnt, SIELedgEntry2, NextLine)
        end
    end;


    procedure "--SMALL TECHN--"()
    begin
    end;


    procedure CutNextBit(var Flags: Integer) RetValue: Boolean
    begin
        RetValue := ((Flags MOD 2) > 0);
        Flags := Flags DIV 2;
        exit(RetValue);
    end;


    procedure AdjustFlagsToArray(Flags: Integer; var ArrayEDMS: array[16] of Boolean)
    var
        i: Integer;
    begin
        for i := 1 to 16 do begin
            ArrayEDMS[i] := CutNextBit(Flags);
        end;
    end;
}
*/
