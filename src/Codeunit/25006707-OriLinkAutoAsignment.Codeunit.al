/*
Codeunit 25006707 "OriLink Auto Asignment"
{

    trigger OnRun()
    begin
        Code
    end;

    var
        Text030: label 'Is going to AutoAssign via C %1 with %2 record No: %3.';


    procedure "Code"()
    var
        SIERegister: Record "SIE Register";
        OriLinkAutoAsignment: Codeunit "OriLink Auto Asignment";
    begin
        SIERegister.Reset;
        SIERegister.SetCurrentkey("Auto Asigned", "Creation Date");
        SIERegister.SetRange("Auto Asigned", false);
        SIERegister.SetRange("Creation Date", Today);
        if SIERegister.FindFirst then
            repeat
                //IF NOT GUIALLOWED THEN
                //MESSAGE('NASMSG: is going to MarkRegister');
                MarkRegister(SIERegister);
                //IF NOT GUIALLOWED THEN
                //MESSAGE('NASMSG: is going to FillSIEAssignment for SIERegister:'+ FORMAT(SIERegister."No."));
                FillSIEAssignment(SIERegister);
            until SIERegister.Next = 0;
        //IF NOT GUIALLOWED THEN
        //MESSAGE('NASMSG: HAS FINISHED AutoAsignUnit');
    end;


    procedure MarkRegister(var SIERegister: Record "SIE Register")
    var
        SIERegister2: Record "SIE Register";
    begin
        SIERegister2.Get(SIERegister."No.");
        SIERegister2."Auto Asigned" := true;
        SIERegister2.Modify;
    end;


    procedure FillSIEAssignment(var SIERegister: Record "SIE Register")
    var
        SIELedgerEntry: Record "SIE Ledger Entry";
        SIEAssignment: Record "SIE Assignment";
        SIEAssignmentCU: Codeunit "SIE Assignment";
        FilterSIEAssgnt: Record "SIE Assignment";
        SIESetup: Record "SIE Setup";
    begin
        SIESetup.Get;
        SIELedgerEntry.Reset;
        SIELedgerEntry.SetRange("Entry No.", SIERegister."From Entry No.", SIERegister."To Entry No.");
        if SIELedgerEntry.FindFirst then begin
            if SIESetup."Automatic Assign" then begin
                repeat
                    CreateAssignmentFilter(FilterSIEAssgnt, SIELedgerEntry."External Document No.", 0);
                    //IF NOT GUIALLOWED THEN
                    //MESSAGE('NASMSG: is going to ReopenServOrder:'+ SIELedgerEntry."External Document No.");
                    ReopenServOrder(SIELedgerEntry."External Document No.");
                    //IF NOT GUIALLOWED THEN
                    //MESSAGE('NASMSG: is going to SIEAssignmentCU.AddUnassignedTranSilent for SLE:'+
                    //FORMAT(SIELedgerEntry."Entry No."));
                    SIEAssignmentCU.AddUnassignedTranSilent(FilterSIEAssgnt, SIELedgerEntry."Entry No.");
                    //IF NOT GUIALLOWED THEN
                    //MESSAGE('NASMSG: is going to SIEAssignmentCU.PostAssignment for FilterSIEAssgnt:'+
                    //FORMAT(FilterSIEAssgnt."Entry No."));
                    SIEAssignmentCU.PostAssignment(FilterSIEAssgnt, 0);
                until SIELedgerEntry.Next = 0;
            end;

            if SIESetup."Automatic PutInTakeOut" then begin
                SIELedgerEntry.FindFirst;
                repeat
                    //IF NOT GUIALLOWED THEN
                    //MESSAGE('NASMSG: is going to CreateAssignmentFilter for SIELedgerEntry."External Document No."='+
                    //SIELedgerEntry."External Document No.");
                    CreateAssignmentFilter(FilterSIEAssgnt, SIELedgerEntry."External Document No.", 0);
                    //IF NOT GUIALLOWED THEN
                    //MESSAGE('NASMSG: is going to SIEAssignmentCU.TransferAll for FilterSIEAssgnt:'+
                    //FORMAT(FilterSIEAssgnt."Entry No."));
                    SIEAssignmentCU.TransferAll(FilterSIEAssgnt);
                    //SIEAssignmentCU.PostTransferAll(FilterSIEAssgnt);  // 21.12.2012 P8
                    Commit;
                until SIELedgerEntry.Next = 0;
            end;
        end;
    end;


    procedure CreateAssignmentFilter(var FilterSIEAssgnt: Record "SIE Assignment"; DocNo: Code[20]; LineNo: Integer)
    begin
        Clear(FilterSIEAssgnt);
        with FilterSIEAssgnt do begin
            SetRange("Applies-to Type", Database::"Service Line EDMS");
            SetRange("Applies-to Doc. Type", "applies-to doc. type"::Order);
            SetRange("Applies-to Doc. No.", DocNo);
            if not FindLast then begin
                FilterSIEAssgnt."Applies-to Type" := Database::"Service Line EDMS";
                FilterSIEAssgnt."Applies-to Doc. Type" := "applies-to doc. type"::Order;
                FilterSIEAssgnt."Applies-to Doc. No." := DocNo;
            end;
            FilterSIEAssgnt."Applies-to Doc. Line No." := 0;
        end;
    end;


    procedure ReopenServOrder(DocNo: Code[20])
    var
        ServHeader: Record "Service Header EDMS";
        ReleaseServDoc: Codeunit "Release Service Document EDMS";
    begin
        ServHeader.Reset;
        if not ServHeader.Get(ServHeader."document type"::Order, DocNo) then
            exit;

        if ServHeader.Status = ServHeader.Status::Released then
            ReleaseServDoc.PerformManualReopen(ServHeader);
    end;
}
*/