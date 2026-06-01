Codeunit 25006212 "Warranty Jnl.-Post Line"
{
    // 06.10.2017 EB.AKR Warranty
    //   Modified procedure:
    //     Code

    TableNo = "Warranty Journal Line";

    trigger OnRun()
    begin
        GetGLSetup;

        RunWithCheck(Rec);
    end;

    var
        GLSetup: Record "General Ledger Setup";
        WarrantyJnlLine: Record "Warranty Journal Line";
        WarrantyLedgEntry: Record "Warranty Reimbursment Entry";
        Veh: Record Vehicle;
        WarrantyReg: Record "Warranty Reimb. Register";
        GenPostingSetup: Record "General Posting Setup";
        WarrantyJnlCheckLine: Codeunit "Warranty Jnl.-Check Line";
        NextEntryNo: Integer;
        GLSetupRead: Boolean;
        Text001: label 'Would you like to recalculate expected dates in plan?';


    procedure GetWarrantyReg(var NewWarrantyReg: Record "Warranty Reimb. Register")
    begin
        NewWarrantyReg := WarrantyReg;
    end;


    procedure RunWithCheck(var WarrantyJnlLine2: Record "Warranty Journal Line")
    begin
        WarrantyJnlLine.Copy(WarrantyJnlLine2);

        Code;
        WarrantyJnlLine2 := WarrantyJnlLine;
    end;

    local procedure "Code"()
    var
        ServiceLabor: Record "Service Labor";
        VehicleServicePlan: Record "Vehicle Service Plan";
        ServicePlanDocumentLink: Record "Service Plan Document Link";
        ServicePlanManagement: Codeunit "Service Plan Management";
        VehicleServicePlanStageTmp: Record "Vehicle Service Plan Stage" temporary;
    begin
        //if EmptyLine then
        //  exit;
        WarrantyJnlLine.TestField("Document No.");

        WarrantyJnlCheckLine.RunCheck(WarrantyJnlLine);

        if NextEntryNo = 0 then begin
            WarrantyLedgEntry.LockTable;
            if WarrantyLedgEntry.FindLast then
                NextEntryNo := WarrantyLedgEntry."Entry No.";
            NextEntryNo := NextEntryNo + 1;
        end;

        if WarrantyJnlLine."Document Date" = 0D then
            WarrantyJnlLine."Document Date" := WarrantyJnlLine."Posting Date";

        InsertWarrantyReg(NextEntryNo);

        //Veh.GET("Vehicle Serial No.");
        //Veh.TESTFIELD(Blocked,FALSE);

        WarrantyLedgEntry.Init;
        WarrantyLedgEntry.Amount := WarrantyJnlLine.Amount;
        WarrantyLedgEntry."Currency Code" := WarrantyJnlLine."Currency Code";
        WarrantyLedgEntry."Document No." := WarrantyJnlLine."Document No.";
        WarrantyLedgEntry."Document Date" := WarrantyJnlLine."Document Date";
        WarrantyLedgEntry."Debit Code" := WarrantyJnlLine."Debit Code";
        WarrantyLedgEntry."Debit Description" := WarrantyJnlLine."Debit Description";
        WarrantyLedgEntry."Entry No." := NextEntryNo;
        WarrantyLedgEntry."Reject Code" := WarrantyJnlLine."Reject Code";
        WarrantyLedgEntry."Reject Description" := WarrantyJnlLine."Reject Description";
        WarrantyLedgEntry.Status := WarrantyJnlLine.Status;
        WarrantyLedgEntry."Warranty Document Line No." := WarrantyJnlLine."Warranty Document Line No.";
        WarrantyLedgEntry."Warranty Document No." := WarrantyJnlLine."Warranty Document No.";

        WarrantyLedgEntry."Posting Date" := WarrantyJnlLine."Posting Date";
        WarrantyLedgEntry.VIN := WarrantyJnlLine.VIN;
        WarrantyLedgEntry."Vehicle Serial No." := WarrantyJnlLine."Vehicle Serial No.";
        WarrantyLedgEntry."Make Code" := WarrantyJnlLine."Make Code";
        WarrantyLedgEntry."Model Code" := WarrantyJnlLine."Model Code";
        WarrantyLedgEntry."Model Version No." := WarrantyJnlLine."Model Version No.";
        WarrantyLedgEntry."Vehicle Accounting Cycle No." := WarrantyJnlLine."Vehicle Accounting Cycle No.";
        WarrantyLedgEntry.Type := WarrantyJnlLine.Type;

        //06.10.2017 EB.AKR Warranty >>
        WarrantyLedgEntry."Debit Code Type" := WarrantyJnlLine."Debit Code Type";
        WarrantyLedgEntry.CoverageId := WarrantyJnlLine.CoverageId;
        WarrantyLedgEntry."Labor Type" := WarrantyJnlLine."Labor Type";
        WarrantyLedgEntry."No." := WarrantyJnlLine."No.";
        WarrantyLedgEntry.Description := WarrantyJnlLine.Description;
        //06.10.2017 EB.AKR Warranty <<

        WarrantyLedgEntry.Insert;
        NextEntryNo := NextEntryNo + 1;
    end;

    local procedure GetGLSetup()
    begin
        if not GLSetupRead then
            GLSetup.Get;
        GLSetupRead := true;
    end;

    local procedure InsertWarrantyReg(LedgEntryNo: Integer)
    begin
        if not (WarrantyReg.FindLast and (WarrantyReg."To Entry No." = 0)) then begin
            //  IF WarrantyReg."No." = 0 THEN BEGIN
            WarrantyReg.LockTable;
            if WarrantyReg.FindLast then
                WarrantyReg."No." := WarrantyReg."No." + 1
            else
                WarrantyReg."No." := 1;

            WarrantyReg.Init;
            WarrantyReg."No." := WarrantyReg."No.";
            WarrantyReg."From Entry No." := LedgEntryNo;
            WarrantyReg."To Entry No." := LedgEntryNo;
            WarrantyReg."Creation Date" := Today;
            WarrantyReg."Creation Time" := Time;
            WarrantyReg."Journal Batch Name" := WarrantyJnlLine."Journal Batch Name";
            WarrantyReg."User ID" := UserId;
            WarrantyReg.Insert;
        end else begin
            if ((LedgEntryNo < WarrantyReg."From Entry No.") and (LedgEntryNo <> 0)) or
               ((WarrantyReg."From Entry No." = 0) and (LedgEntryNo > 0))
            then
                WarrantyReg."From Entry No." := LedgEntryNo;
            if LedgEntryNo > WarrantyReg."To Entry No." then
                WarrantyReg."To Entry No." := LedgEntryNo;

            WarrantyReg.Modify;
        end;
    end;
}

