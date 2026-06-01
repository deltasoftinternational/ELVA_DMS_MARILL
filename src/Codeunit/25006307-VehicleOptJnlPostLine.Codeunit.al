Codeunit 25006307 "Vehicle Opt. Jnl.-Post Line"
{
    // 21.03.2013 EDMS P8
    //   * FIX
    // 
    // //==================================================================================================================================
    // MŌĆ░r├®is: Veikt ├śurnŲÆla rindas grŲÆmato├Ģanu
    // //==================================================================================================================================

    Permissions = TableData "Item Register" = imd;
    TableNo = "Vehicle Opt. Jnl. Line";

    trigger OnRun()
    var
        iTVehOptRegNo: Integer;
    begin
        fGetGLSetup;
        fRunWithCheck(Rec, iTVehOptRegNo);
    end;

    var
        Text000: label 'cannot be less than zero';
        Text001: label 'Item Tracking is signed wrongly.';
        Text003: label 'Reserved item %1 is not on inventory.';
        Text004: label 'is too low';
        Text005: label 'Item %1 is not on inventory.';
        Text008: label 'Item tracking must be defined for item %1 %2.';
        Text011: label 'Tracking Specification is missing.';
        Text012: label 'Item %1 must be reserved.';
        Text013: label '%1 in %2 for item %3 %4 is %5 it must be %6.';
        Text014: label 'Serial No. %1 is already on inventory.';
        Text015: label 'Serial Number is required for Item %1.';
        Text016: label 'Lot Number is required for Item %1.';
        Text017: label ' is before the posting date.';
        Text018: label 'Item Tracking Serial No. %1 Lot No. %2 for Item No. %3 Variant %4 cannot be fully applied.';
        Text019: label 'Order Tracking and Item Tracking conflict detected for Item %1.';
        Text020: label 'The Item Tracking on the %1 does not match with the Item Tracking on the %2.  ';
        Text021: label 'You must not define item tracking on %1 %2';
        Text022: label 'You cannot apply %1 to %2 on the same item %3 on Production Order %4';
        Text99000000: label 'must not be filled out when reservations exist';
        recGLSetup: Record "General Ledger Setup";
        recInvtSetup: Record "Inventory Setup";
        recItem: Record Item;
        recGlobalVehOptLedgEntry: Record "Vehicle Opt. Ledger Entry";
        recOldVehOptLedgEntry: Record "Vehicle Opt. Ledger Entry";
        recVehOptReg: Record "Vehicle Option Register";
        recVehOptJnlLine: Record "Vehicle Opt. Jnl. Line";
        recVehOptJnlLineOrigin: Record "Vehicle Opt. Jnl. Line";
        recSourceCodeSetup: Record "Source Code Setup";
        recGenPostingSetup: Record "General Posting Setup";
        recTempSplitVehOptJnlLine: Record "Vehicle Opt. Jnl. Line" temporary;
        cuVehOptJnlCheckLine: Codeunit "Vehicle Opt. Jnl.-Check Line";
        iVehOptLedgEntryNo: Integer;
        recInvtSetupRead: Boolean;
        bGLSetupRead: Boolean;
        iGlobalLastEntryNo: Integer;
        iGlobalVehOptRegNo: Integer;


    procedure fRunWithCheck(var recVehOptJnlLinePar: Record "Vehicle Opt. Jnl. Line"; var iVehOptRegNo: Integer)
    var
        bPostVehOptJnlLine: Boolean;
        recVehOptLedgEntry55: Record "Vehicle Opt. Ledger Entry";
    begin
        iGlobalVehOptRegNo := iVehOptRegNo; //Ieg├Śstam reŌĆ”istra Nr.

        recVehOptJnlLine.Copy(recVehOptJnlLinePar);

        bPostVehOptJnlLine := true;

        fSetupSplitJnlLine(recVehOptJnlLinePar, bPostVehOptJnlLine);

        bPostVehOptJnlLine := true;

        //Pamatcikls
        while fSplitJnlLine(recVehOptJnlLine, bPostVehOptJnlLine) do begin
            if bPostVehOptJnlLine then begin
                fCode; //Pamatkods
            end
        end;

        recVehOptJnlLinePar := recVehOptJnlLine;

        iVehOptRegNo := iGlobalVehOptRegNo;
    end;

    local procedure fCode()
    begin

        cuVehOptJnlCheckLine.fRunCheck(recVehOptJnlLine); //Veicam rindas pamatpŲÆrbaudi

        if recVehOptJnlLine."Document Date" = 0D then
            recVehOptJnlLine."Document Date" := recVehOptJnlLine."Posting Date";

        //Ieg├Śstam pŌĆ░dŌĆ░jo grŲÆmatas ieraksta Nr.
        if iVehOptLedgEntryNo = 0 then begin
            recGlobalVehOptLedgEntry.LockTable;
            if recGlobalVehOptLedgEntry.FindLast then
                iVehOptLedgEntryNo := recGlobalVehOptLedgEntry."Entry No.";
        end;

        fPostVehOptLine;//GrŲÆmato├Ģana
    end;

    local procedure fPostVehOptLine()
    begin
        //MŌĆ░r├®is: Veikt aizvieto├Ģanas rindas grŲÆmato├Ģanu
        //PŲÆrbaudam vai prece nav blo├®ŌĆ░ta
        //InicializŌĆ░jam un iesprau├śam grŲÆmatas ierakstu
        if recVehOptJnlLine."Update Sales Amounts" then begin
            fUpdateSalesAmounts(recGlobalVehOptLedgEntry);
        end
        else begin
            fInitVehOptLedgEntry(recGlobalVehOptLedgEntry);
            fInsertVehOptLedgEntry(recGlobalVehOptLedgEntry);
        end;
    end;

    local procedure fInitVehOptLedgEntry(var recVehOptLedgEntry: Record "Vehicle Opt. Ledger Entry")
    begin
        //MŌĆ░r├®is: Veikt aizvieto├Ģanas grŲÆmatas ieraksta inicializŲÆciju

        iVehOptLedgEntryNo := iVehOptLedgEntryNo + 1; //Ieg├Śstam jaunu ieraksta Nr.
                                                      //Veidojam ieraksta pamatdatus
                                                      //AttiecinŲÆ├Ģana
        if recVehOptJnlLine."Applies-to Entry" <> 0 then begin
            //recVehOptJnlLine.TESTFIELD("Applies-to Entry");
            recVehOptLedgEntry.Get(recVehOptJnlLine."Applies-to Entry");
            recVehOptLedgEntry.TestField(Open, true);
            recVehOptLedgEntry.Open := false;
            recVehOptLedgEntry."Closed by Entry No." := iVehOptLedgEntryNo;
            recVehOptLedgEntry.Modify;
        end;

        recVehOptLedgEntry.Init;
        recVehOptLedgEntry."Entry No." := iVehOptLedgEntryNo;
        recVehOptLedgEntry."Posting Date" := recVehOptJnlLine."Posting Date";
        recVehOptLedgEntry."Document No." := recVehOptJnlLine."Document No.";
        recVehOptLedgEntry."Document Date" := recVehOptJnlLine."Document Date";
        recVehOptLedgEntry."External Document No." := recVehOptJnlLine."External Document No.";
        recVehOptLedgEntry."Vehicle Serial No." := recVehOptJnlLine."Vehicle Serial No.";
        recVehOptLedgEntry."Option Type" := recVehOptJnlLine."Option Type";
        recVehOptLedgEntry."Option Code" := recVehOptJnlLine."Option Code";
        recVehOptLedgEntry."Make Code" := recVehOptJnlLine."Make Code";
        recVehOptLedgEntry."Model Code" := recVehOptJnlLine."Model Code";
        recVehOptLedgEntry."Model Version No." := recVehOptJnlLine."Model Version No.";
        recVehOptLedgEntry.Standard := recVehOptJnlLine.Standard;
        recVehOptLedgEntry."Option Subtype" := recVehOptJnlLine."Option Subtype";
        recVehOptLedgEntry.Description := recVehOptJnlLine.Description;
        recVehOptLedgEntry."Description 2" := recVehOptJnlLine."Description 2";
        recVehOptLedgEntry."External Code" := recVehOptJnlLine."External Code";
        recVehOptLedgEntry."Cost Amount (LCY)" := recVehOptJnlLine."Cost Amount (LCY)";
        recVehOptLedgEntry."User ID" := UserId;
        recVehOptLedgEntry."Entry Type" := recVehOptJnlLine."Entry Type";
        recVehOptLedgEntry.Correction := recVehOptJnlLine.Correction;
        recVehOptLedgEntry.Open := not recVehOptLedgEntry.Correction;
        if recVehOptJnlLine."Entry Type" = recVehOptJnlLine."entry type"::Disassemble then
            recVehOptLedgEntry.Open := false;
        recVehOptLedgEntry."Assembly ID" := recVehOptJnlLine."Assembly ID";
        iGlobalLastEntryNo := recVehOptLedgEntry."Entry No.";
        OnAfterInitVehOptLedgEntry(recVehOptLedgEntry, recVehOptJnlLine);
    end;

    local procedure fInsertVehOptLedgEntry(var recVehOptLedgEntry: Record "Vehicle Opt. Ledger Entry")
    begin
        //MŌĆ░r├®is: Veikt aizvieto├Ģanas grŲÆmatas ieraksta iesprau├Ģanu
        //Isprau├śam grŲÆmatas ierakstu
        recVehOptLedgEntry.Insert;
        //Papildinam pre├æu reŌĆ”istru
        fInsertVehOptReg(recVehOptLedgEntry."Entry No.");
    end;

    local procedure fSplitJnlLine(var recVehOptJnlLine2: Record "Vehicle Opt. Jnl. Line"; bPostVehOptJnlLine: Boolean): Boolean
    var
        FreeEntryNo: Integer;
        JnlLineNo: Integer;
        SignFactor: Integer;
    begin
        if recTempSplitVehOptJnlLine.FindFirst then begin
            JnlLineNo := recVehOptJnlLine2."Line No.";
            recVehOptJnlLine2 := recTempSplitVehOptJnlLine;
            recVehOptJnlLine2."Line No." := JnlLineNo;
            recTempSplitVehOptJnlLine.Delete;
            exit(true);
        end else begin
            exit(false);
        end
    end;

    local procedure fGetGLSetup()
    begin
        if not bGLSetupRead then begin
            recGLSetup.Get;
        end;
        bGLSetupRead := true;
    end;

    local procedure fGetVehOptSetup()
    begin
        if not recInvtSetupRead then begin
            recInvtSetup.Get;
            recSourceCodeSetup.Get;
        end;
        recInvtSetupRead := true;
    end;

    local procedure fSetupSplitJnlLine(var recVehOptJnlLine2: Record "Vehicle Opt. Jnl. Line"; var bPostVehOptJnlLine: Boolean)
    var
        Text100: label 'Fatal error when retrieving Tracking Specification';
        decFactor: Decimal;
        decFloatingFactor: Decimal;
        decNonDistrQuantity: Decimal;
        decNonDistrAmount: Decimal;
        decNonDistrAmountACY: Decimal;
        decNonDistrDiscountAmount: Decimal;
        iSignFactor: Integer;
        datCalcWarrantyDate: Date;
        datCalcExpirationDate: Date;
        bInvoice: Boolean;
        bSNInfoRequired: Boolean;
        bLotInfoRequired: Boolean;
        bItemTrackingOK: Boolean;
    begin

        recVehOptJnlLineOrigin := recVehOptJnlLine2;
        recTempSplitVehOptJnlLine.Reset;
        recTempSplitVehOptJnlLine.DeleteAll;

        fGetGLSetup;
        fGetVehOptSetup;


        recTempSplitVehOptJnlLine := recVehOptJnlLine2;
        recTempSplitVehOptJnlLine.Insert;
    end;

    local procedure fInsertVehOptReg(iItemReplmtLedgEntryNo: Integer)
    var
        recSourceCodeSetup: Record "Source Code Setup";
    begin
        //MŌĆ░r├®is: Veikt aizvieto├Ģanas ieraksta ierakst┼Æ├Ģanu pre├æu reŌĆ”istrŲÆ
        if recVehOptReg."No." = 0 then begin //Ja reŌĆ”istra ieraksts neeksistŌĆ░
            recVehOptReg.LockTable;
            //Ieg├Śstam reŌĆ”istra Nr.
            if recVehOptReg.FindLast then
                recVehOptReg."No." := recVehOptReg."No." + 1
            else
                recVehOptReg."No." := 1;

            iGlobalVehOptRegNo := recVehOptReg."No.";

            recVehOptReg.Init;
            recVehOptReg."From Entry No." := iVehOptLedgEntryNo;
            recVehOptReg."To Entry No." := iVehOptLedgEntryNo;
            recVehOptReg."Creation Date" := Today;
            recVehOptReg."Source Code" := recVehOptJnlLine."Source Code";
            recVehOptReg."Journal Batch Name" := recVehOptJnlLine."Journal Batch Name";
            recVehOptReg."User ID" := UserId;
            recVehOptReg.Insert;
        end else begin
            if ((iVehOptLedgEntryNo < recVehOptReg."From Entry No.") and (iVehOptLedgEntryNo <> 0)) or
               ((recVehOptReg."From Entry No." = 0) and (iVehOptLedgEntryNo > 0))
            then
                recVehOptReg."From Entry No." := iVehOptLedgEntryNo;
            if iVehOptLedgEntryNo > recVehOptReg."To Entry No." then
                recVehOptReg."To Entry No." := iVehOptLedgEntryNo;

            recVehOptReg.Modify;
        end;
    end;

    local procedure fUpdateSalesAmounts(var recVehOptLedgEntry: Record "Vehicle Opt. Ledger Entry")
    begin
        //Atjauninam pŲÆrdo├Ģans summas
        recVehOptJnlLine.TestField("Vehicle Serial No.");
        if recVehOptJnlLine."Option Type" <> recVehOptJnlLine."option type"::"Vehicle Base" then
            recVehOptJnlLine.TestField("Option Code");

        recVehOptLedgEntry.Reset;
        recVehOptLedgEntry.SetCurrentkey("Vehicle Serial No.", "Entry Type", "Option Type", "Option Code", Open);
        recVehOptLedgEntry.SetRange("Vehicle Serial No.", recVehOptJnlLine."Vehicle Serial No.");
        recVehOptLedgEntry.SetRange("Option Type", recVehOptJnlLine."Option Type");
        recVehOptLedgEntry.SetRange("Option Code", recVehOptJnlLine."Option Code");
        if recVehOptLedgEntry.FindSet(true, false) then
            repeat
                recVehOptLedgEntry."Sales Price (LCY)" := recVehOptJnlLine."Sales Price (LCY)";
                recVehOptLedgEntry."Sales Discount %" := recVehOptJnlLine."Sales Discount %";
                recVehOptLedgEntry."Sales Discount Amount (LCY)" := recVehOptJnlLine."Sales Discount Amount (LCY)";
                recVehOptLedgEntry."Sales Amount (LCY)" := recVehOptJnlLine."Sales Amount (LCY)";
                recVehOptLedgEntry.Modify;
            until recVehOptLedgEntry.Next = 0;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInitVehOptLedgEntry(var recVehOptLedgEntry: Record "Vehicle Opt. Ledger Entry"; recVehOptJnlLine: Record "Vehicle Opt. Jnl. Line")
    begin
    end;
}

