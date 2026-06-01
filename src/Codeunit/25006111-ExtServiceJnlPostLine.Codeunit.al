Codeunit 25006111 "Ext. Service Jnl.-Post Line"
{
    // 27.02.2013 EDMS P8
    //   * Implement new dimension set

    TableNo = "External Serv. Journal Line";

    trigger OnRun()
    begin
        GetGLSetup;

        RunWithCheck(Rec);
    end;

    var
        GLSetup: Record "General Ledger Setup";
        ExtServiceJnlLine: Record "External Serv. Journal Line";
        ExtServiceLedgEntry: Record "External Serv. Ledger Entry";
        ExtService: Record "External Service";
        ExtServiceReg: Record "External Service Register";
        ExtServiceJnlCheckLine: Codeunit "Ext. Service Jnl.-Check Line";
        NextEntryNo: Integer;
        GLSetupRead: Boolean;
        Error100: label 'Tracking Number is required for External Service %1.';


    procedure RunWithCheck(var ExtServiceJnlLine2: Record "External Serv. Journal Line")
    begin
        ExtServiceJnlLine.Copy(ExtServiceJnlLine2);


        Code;
        ExtServiceJnlLine2 := ExtServiceJnlLine;
    end;

    local procedure "Code"()
    begin
        //  ExtServiceJnlCheckLine.RunCheck(ExtServiceJnlLine,TempJnlLineDim);//30.10.2012 EDMS
        ExtServiceJnlCheckLine.RunCheck(ExtServiceJnlLine);//30.10.2012 EDMS

        if NextEntryNo = 0 then begin
            ExtServiceLedgEntry.LockTable;
            if ExtServiceLedgEntry.FindLast then
                NextEntryNo := ExtServiceLedgEntry."Entry No.";
            NextEntryNo := NextEntryNo + 1;
        end;

        if ExtServiceReg."No." = 0 then begin
            ExtServiceReg.LockTable;
            if (not ExtServiceReg.FindLast) or (ExtServiceReg."To Entry No." <> 0) then begin
                ExtServiceReg.Init;
                ExtServiceReg."No." := ExtServiceReg."No." + 1;
                ExtServiceReg."From Entry No." := NextEntryNo;
                ExtServiceReg."To Entry No." := NextEntryNo;
                ExtServiceReg."Creation Date" := Today;
                ExtServiceReg."Source Code" := ExtServiceJnlLine."Source Code";
                ExtServiceReg."Journal Batch Name" := ExtServiceJnlLine."Journal Batch Name";
                ExtServiceReg."User ID" := UserId;
                ExtServiceReg.Insert;
            end;
        end;
        ExtServiceReg."To Entry No." := NextEntryNo;
        ExtServiceReg.Modify;

        ExtService.Get(ExtServiceJnlLine."Ext. Service No.");
        ExtService.TestField(Blocked, false);

        if ExtService."Allow Tracking Nos." then
            if ExtServiceJnlLine."Ext. Service Tracking No." = '' then
                Error(Error100, ExtServiceJnlLine."Ext. Service No.");

        ExtServiceLedgEntry.Init;
        ExtServiceLedgEntry."Entry No." := NextEntryNo;
        ExtServiceLedgEntry."External Serv. No." := ExtServiceJnlLine."Ext. Service No.";
        ExtServiceLedgEntry."External Serv. Tracking No." := ExtServiceJnlLine."Ext. Service Tracking No.";
        ExtServiceLedgEntry."Posting Date" := ExtServiceJnlLine."Posting Date";
        ExtServiceLedgEntry."Entry Type" := ExtServiceJnlLine."Entry Type";
        ExtServiceLedgEntry."Source Type" := ExtServiceJnlLine."Source Type";
        ExtServiceLedgEntry."Source No." := ExtServiceJnlLine."Source No.";
        ExtServiceLedgEntry."Document No." := ExtServiceJnlLine."Document No.";
        ExtServiceLedgEntry."External Document No." := ExtServiceJnlLine."External Document No.";
        ExtServiceLedgEntry.Description := ExtServiceJnlLine.Description;
        ExtServiceLedgEntry."Location Code" := ExtServiceJnlLine."Location Code";
        ExtServiceLedgEntry."Journal Batch Name" := ExtServiceJnlLine."Journal Batch Name";
        ExtServiceLedgEntry.Quantity := ExtServiceJnlLine.Quantity;
        ExtServiceLedgEntry.Amount := ExtServiceJnlLine.Amount;
        ExtServiceLedgEntry."Dimension Set ID" := ExtServiceJnlLine."Dimension Set ID";

        //08.05.2021 EDMS.P7 BUG78 >>
        ExtServiceLedgEntry."Service Order No." := ExtServiceJnlLine."Service Order No.";
        ExtServiceLedgEntry."Vehicle Serial No." := ExtServiceJnlLine."Vehicle Serial No.";
        ExtServiceLedgEntry."Vehicle Registration No." := ExtServiceJnlLine."Vehicle Registration No.";
        ExtServiceLedgEntry.VIN := ExtServiceJnlLine.VIN;
        ExtServiceLedgEntry."Make Code" := ExtServiceJnlLine."Make Code";
        ExtServiceLedgEntry."Model Code" := ExtServiceJnlLine."Model Code";
        //08.05.2021 EDMS.P7 BUG78 <<

        ExtServiceLedgEntry.Insert;


        NextEntryNo := NextEntryNo + 1;
    end;

    local procedure GetGLSetup()
    begin
        if not GLSetupRead then
            GLSetup.Get;
        GLSetupRead := true;
    end;
}

