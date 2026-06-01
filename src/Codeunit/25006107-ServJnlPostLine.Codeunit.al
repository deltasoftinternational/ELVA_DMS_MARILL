Codeunit 25006107 "Serv. Jnl.-Post Line"
{
    // 28.05.2015 EB.P30 #T030
    //   Modified procedure:
    //     FillDetServLE
    // 
    // 12.05.2015 EB.P30 #T030
    //   Modified procedure:
    //     FillDetServLE
    // 
    // 02.04.2013 EDMS P8
    //   * Fix for AdjustServPlanStageRuns
    // 
    // 27.02.2013 EDMS P8
    //   * Implement new dimension set
    // 
    // 2012.09.15 EDMS P8
    //   * Add support for fields: "Minutes Per UoM", "Quantity (Hours)"
    // 
    // 2012.07.31 EDMS P8
    //   * use of new fields: 'Variable Field Run 2', 'Variable Field Run 3', 'Document Line No.'
    //   * new function AdjustServPlanStageRuns
    // 
    // 2012.04.17 EDMS P8
    //   * Implemet use of "Det. Serv. Ledger Entry EDMS" table
    // 
    // 2012.03.07 EDMS P8
    //   * Implement Tire Management
    // 
    // 05.03.2008. EDMS P2
    //   * Added code Code

    Permissions = TableData "Service Ledger Entry EDMS" = imd,
                  TableData "Service Register" = imd;
    TableNo = "Serv. Journal Line";

    trigger OnRun()
    begin
        GetGLSetup;

        RunWithCheck(Rec);
    end;

    var
        GLSetup: Record "General Ledger Setup";
        ServJnlLine: Record "Serv. Journal Line";
        ServLedgEntry: Record "Service Ledger Entry EDMS";
        Veh: Record Vehicle;
        ServReg: Record "Service Register EDMS";
        GenPostingSetup: Record "General Posting Setup";
        ServJnlCheckLine: Codeunit "Serv. Jnl.-Check Line";
        NextEntryNo: Integer;
        GLSetupRead: Boolean;
        Text001: label 'Would you like to recalculate expected dates in plan?';


    procedure GetServReg(var NewServReg: Record "Service Register EDMS")
    begin
        NewServReg := ServReg;
    end;


    procedure RunWithCheck(var ServJnlLine2: Record "Serv. Journal Line")
    begin
        ServJnlLine.Copy(ServJnlLine2);

        Code;
        ServJnlLine2 := ServJnlLine;
    end;

    local procedure "Code"()
    var
        ServiceLabor: Record "Service Labor";
        VehicleServicePlan: Record "Vehicle Service Plan";
        ServicePlanDocumentLink: Record "Service Plan Document Link";
        ServicePlanManagement: Codeunit "Service Plan Management";
        VehicleServicePlanStageTmp: Record "Vehicle Service Plan Stage" temporary;
        DealType: Record "Deal Type";
        VehicleNotMandatory: Boolean;
    begin
        if ServJnlLine.EmptyLine and (ServJnlLine."Entry Type" <> ServJnlLine."entry type"::Info) then
            exit;

        //30.10.2012 EDMS >>
        ServJnlCheckLine.RunCheck(ServJnlLine);
        //30.10.2012 EDMS <<
        if NextEntryNo = 0 then begin
            ServLedgEntry.LockTable;
            if ServLedgEntry.FindLast then
                NextEntryNo := ServLedgEntry."Entry No.";
            NextEntryNo := NextEntryNo + 1;
        end;

        if ServJnlLine."Document Date" = 0D then
            ServJnlLine."Document Date" := ServJnlLine."Posting Date";

        InsertServReg(NextEntryNo);

        VehicleNotMandatory := false;
        if ServJnlLine."Deal Type Code" <> '' then begin
            if DealType.Get(ServJnlLine."Deal Type Code") then
                VehicleNotMandatory := DealType."Vehicle Not Mandatory";
        end;
        if not VehicleNotMandatory then begin
            Veh.Get(ServJnlLine."Vehicle Serial No.");
            Veh.TestField(Blocked, false);
        end;

        if (GenPostingSetup."Gen. Bus. Posting Group" <> ServJnlLine."Gen. Bus. Posting Group") or
           (GenPostingSetup."Gen. Prod. Posting Group" <> ServJnlLine."Gen. Prod. Posting Group")
        then
            GenPostingSetup.Get(ServJnlLine."Gen. Bus. Posting Group", ServJnlLine."Gen. Prod. Posting Group");


        ServLedgEntry.Init;
        ServLedgEntry."Entry Type" := ServJnlLine."Entry Type";
        ServLedgEntry."Document Type" := ServJnlLine."Document Type";
        ServLedgEntry."Document No." := ServJnlLine."Document No.";
        ServLedgEntry."Pre-Assigned No." := ServJnlLine."Pre-Assigned No.";
        ServLedgEntry."External Document No." := ServJnlLine."External Document No.";
        ServLedgEntry."Posting Date" := ServJnlLine."Posting Date";
        ServLedgEntry."Document Date" := ServJnlLine."Document Date";
        ServLedgEntry."Vehicle Serial No." := ServJnlLine."Vehicle Serial No.";
        ServLedgEntry."Make Code" := ServJnlLine."Make Code";
        ServLedgEntry."Model Code" := ServJnlLine."Model Code";
        ServLedgEntry."Model Version No." := ServJnlLine."Model Version No.";
        ServLedgEntry."Vehicle Accounting Cycle No." := ServJnlLine."Vehicle Accounting Cycle No.";
        ServLedgEntry.Description := ServJnlLine.Description;
        ServLedgEntry."Customer No." := ServJnlLine."Customer No.";
        ServLedgEntry."Bill-to Customer No." := ServJnlLine."Bill-to Customer No.";

        ServLedgEntry."Job No." := ServJnlLine."Job No.";
        ServLedgEntry."Unit of Measure Code" := ServJnlLine."Unit of Measure Code";
        ServLedgEntry.Quantity := ServJnlLine.Quantity;
        ServLedgEntry."Minutes Per UoM" := ServJnlLine."Minutes Per UoM";
        ServLedgEntry."Quantity (Hours)" := ServJnlLine."Quantity (Hours)";

        ServLedgEntry."Unit Cost" := ServJnlLine."Unit Cost";
        ServLedgEntry."Total Cost" := ServJnlLine."Total Cost";
        ServLedgEntry."Unit Price" := ServJnlLine."Unit Price";
        ServLedgEntry.Amount := ServJnlLine.Amount;
        ServLedgEntry."Amount Including VAT" := ServJnlLine."Amount Including VAT";
        ServLedgEntry."Amount (LCY)" := ServJnlLine."Amount (LCY)";
        ServLedgEntry."Amount Including VAT (LCY)" := ServJnlLine."Amount Including VAT (LCY)";
        ServLedgEntry."Global Dimension 1 Code" := ServJnlLine."Shortcut Dimension 1 Code";
        ServLedgEntry."Global Dimension 2 Code" := ServJnlLine."Shortcut Dimension 2 Code";
        ServLedgEntry."Dimension Set ID" := ServJnlLine."Dimension Set ID";
        ServLedgEntry."Source Code" := ServJnlLine."Source Code";
        ServLedgEntry."Warranty Claim No." := ServJnlLine."Warranty Claim No.";
        ServLedgEntry.Chargeable := ServJnlLine.Chargeable;
        ServLedgEntry."Journal Batch Name" := ServJnlLine."Journal Batch Name";
        ServLedgEntry."Reason Code" := ServJnlLine."Reason Code";
        ServLedgEntry."Gen. Bus. Posting Group" := ServJnlLine."Gen. Bus. Posting Group";
        ServLedgEntry."Gen. Prod. Posting Group" := ServJnlLine."Gen. Prod. Posting Group";
        ServLedgEntry."No. Series" := ServJnlLine."Posting No. Series";
        ServLedgEntry.Type := ServJnlLine.Type;
        ServLedgEntry."No." := ServJnlLine."No.";
        ServLedgEntry."Customer No." := ServJnlLine."Customer No.";
        ServLedgEntry."Bill-to Customer No." := ServJnlLine."Bill-to Customer No.";
        ServLedgEntry."Currency Code" := ServJnlLine."Currency Code";
        ServLedgEntry."Location Code" := ServJnlLine."Location Code";
        ServLedgEntry."Discount %" := ServJnlLine."Discount %";
        ServLedgEntry."Line Discount Amount" := ServJnlLine."Line Discount Amount";
        ServLedgEntry."Inv. Discount Amount" := ServJnlLine."Inv. Discount Amount";
        ServLedgEntry."Line Discount Amount (LCY)" := ServJnlLine."Line Discount Amount (LCY)";
        ServLedgEntry."Inv. Discount Amount (LCY)" := ServJnlLine."Inv. Discount Amount (LCY)";
        ServLedgEntry."Service Receiver" := ServJnlLine."Service Receiver";
        ServLedgEntry."Service Order Type" := ServJnlLine."Service Order Type";
        ServLedgEntry."Service Order No." := ServJnlLine."Service Order No.";
        ServLedgEntry."Cust. Ledger Entry No." := ServJnlLine."Cust. Ledger Entry No.";
        ServLedgEntry."Payment Method Code" := ServJnlLine."Payment Method Code";

        // 2012.07.31 EDMS P8 >>
        ServLedgEntry."Document Line No." := ServJnlLine."Document Line No.";
        ServLedgEntry."Plan No." := ServJnlLine."Plan No.";
        ServLedgEntry."Plan Stage Recurrence" := ServJnlLine."Plan Stage Recurrence";
        ServLedgEntry."Plan Stage Code" := ServJnlLine."Plan Stage Code";
        // 2012.07.31 EDMS P8 <<

        //05.03.2008. EDMS P2 >>
        ServLedgEntry."Package No." := ServJnlLine."Package No.";
        ServLedgEntry."Package Version No." := ServJnlLine."Package Version No.";
        ServLedgEntry."Package Version Spec. Line No." := ServJnlLine."Package Version Spec. Line No.";
        //05.03.2008. EDMS P2 <<

        ServLedgEntry."Service Address Code" := ServJnlLine."Service Address Code";
        ServLedgEntry."Service Address" := ServJnlLine."Service Address";

        ServLedgEntry."Deal Type Code" := ServJnlLine."Deal Type Code";

        FillServLedgerVariableFields(ServLedgEntry, ServJnlLine);
        Veh.CalcFields("Parent Component");
        ServLedgEntry."Parent Vehicle Serial No." := Veh."Parent Component";

        ServLedgEntry."Standard Time" := ServJnlLine."Standard Time";
        ServLedgEntry."Campaign No." := ServJnlLine."Campaign No.";
        if ServJnlLine.Type = ServJnlLine.Type::Labor then begin
            if ServiceLabor.Get(ServJnlLine."No.") then begin
                ServLedgEntry."Labor Group Code" := ServiceLabor."Group Code";
                ServLedgEntry."Labor Subgroup Code" := ServiceLabor."Subgroup Code";
            end;
        end;

        GetGLSetup;

        ServLedgEntry."Total Cost" := ROUND(ServLedgEntry."Total Cost");
        ServLedgEntry.Amount := ROUND(ServLedgEntry.Amount);
        if ServLedgEntry."Entry Type" = ServLedgEntry."entry type"::Sale then begin
            ServLedgEntry.Chargeable := true;
            ServLedgEntry.Quantity := -ServLedgEntry.Quantity;
            ServLedgEntry."Total Cost" := -ServLedgEntry."Total Cost";
            ServLedgEntry.Amount := -ServLedgEntry.Amount;
        end;

        if ServLedgEntry.Description = Veh."Model Commercial Name" then
            ServLedgEntry.Description := '';
        ServLedgEntry."User ID" := UserId;
        ServLedgEntry."Entry No." := NextEntryNo;

        AfterFillServiceLedgerEntry(ServLedgEntry, ServJnlLine);

        ServLedgEntry.Insert;

        if (ServLedgEntry."Document Type" in [ServLedgEntry."document type"::Order,
            ServLedgEntry."document type"::"Return Order"]) then begin

            ServicePlanDocumentLink.Reset;
            ServicePlanDocumentLink.SetCurrentkey("Document Type", "Document No.");
            case ServLedgEntry."Document Type" of
                ServLedgEntry."document type"::Order:
                    ServicePlanDocumentLink.SetRange("Document Type", ServicePlanDocumentLink."document type"::"Posted Order");
                ServLedgEntry."document type"::"Return Order":
                    ServicePlanDocumentLink.SetRange("Document Type", ServicePlanDocumentLink."document type"::"Posted Return Order");
            end;
            ServicePlanDocumentLink.SetRange("Document No.", ServLedgEntry."Document No.");
            VehicleServicePlanStageTmp.Init;
            if ServicePlanDocumentLink.FindFirst then
                repeat
                    VehicleServicePlan.Get(ServJnlLine."Vehicle Serial No.", ServicePlanDocumentLink."Serv. Plan No.");
                    ServicePlanManagement.PostServPlanStage(ServJnlLine."Vehicle Serial No.", ServicePlanDocumentLink."Serv. Plan No.",
                      ServicePlanDocumentLink."Plan Stage Recurrence", ServicePlanDocumentLink."Serv. Plan Stage Code", ServLedgEntry);

                    ServicePlanManagement.PlanRecurringByTemplate(VehicleServicePlan, 0);

                    if not ((VehicleServicePlanStageTmp."Vehicle Serial No." = ServJnlLine."Vehicle Serial No.") and
                        (VehicleServicePlanStageTmp."Plan No." = ServicePlanDocumentLink."Serv. Plan No.") and
                        (VehicleServicePlanStageTmp.Recurrence = ServicePlanDocumentLink."Plan Stage Recurrence") and
                        (VehicleServicePlanStageTmp.Code = ServicePlanDocumentLink."Serv. Plan Stage Code")) then begin
                        AdjustServPlanStageRuns(ServJnlLine."Vehicle Serial No.", ServicePlanDocumentLink."Serv. Plan No.",
                          ServicePlanDocumentLink."Plan Stage Recurrence", ServicePlanDocumentLink."Serv. Plan Stage Code",
                          ServLedgEntry."Variable Field Run 1", ServLedgEntry."Variable Field Run 2",
                          ServLedgEntry."Variable Field Run 3", false, false);

                        ServicePlanManagement.CalcExpectedServiceDate(ServJnlLine."Vehicle Serial No.", ServicePlanDocumentLink."Serv. Plan No.", 1);
                        VehicleServicePlanStageTmp."Vehicle Serial No." := ServJnlLine."Vehicle Serial No.";
                        VehicleServicePlanStageTmp."Plan No." := ServicePlanDocumentLink."Serv. Plan No.";
                        VehicleServicePlanStageTmp.Recurrence := ServicePlanDocumentLink."Plan Stage Recurrence";
                        VehicleServicePlanStageTmp.Code := ServicePlanDocumentLink."Serv. Plan Stage Code";
                    end;
                until ServicePlanDocumentLink.Next = 0;
        end;  //02.04.2013 EDMS P8

        //2012.06.12 EDMS P8 >>
        FillDetServLE(ServLedgEntry, ServJnlLine);
        //2012.06.12 EDMS P8 <<


        // 29.09.2011 EDMS P8 >>
        InsertTireEntryAdv(ServJnlLine);
        // 29.09.2011 EDMS P8 <<

        NextEntryNo := NextEntryNo + 1;
    end;

    local procedure GetGLSetup()
    begin
        if not GLSetupRead then
            GLSetup.Get;
        GLSetupRead := true;
    end;


    procedure UpdateCustLedgNo(CustEntryNo: Integer; DocType: Integer; DocNo: Code[20]; PostDate: Date)
    begin
        ServLedgEntry.SetCurrentkey("Document Type", "Document No.", "Posting Date");
        ServLedgEntry.SetRange("Document Type", DocType);
        ServLedgEntry.SetRange("Document No.", DocNo);
        ServLedgEntry.SetRange("Posting Date", PostDate);
        ServLedgEntry.ModifyAll("Cust. Ledger Entry No.", CustEntryNo);
        ServLedgEntry.Reset
    end;


    procedure FillServLedgerVariableFields(var ServLedgerEntry: Record "Service Ledger Entry EDMS"; ServJournalLine: Record "Serv. Journal Line")
    var
        VariableFieldUsage: Record "Variable Field Usage";
        VariableFieldUsage2: Record "Variable Field Usage";
        RecordRef: RecordRef;
        RecordRef2: RecordRef;
        FieldRef: FieldRef;
        FieldRef2: FieldRef;
    begin
        RecordRef.Open(Database::"Serv. Journal Line");
        RecordRef.GetTable(ServJournalLine);
        RecordRef2.Open(Database::"Service Ledger Entry EDMS");
        RecordRef2.GetTable(ServLedgerEntry);

        VariableFieldUsage.Reset;
        VariableFieldUsage.SetRange("Table No.", Database::"Serv. Journal Line");
        if VariableFieldUsage.FindFirst then
            repeat
                VariableFieldUsage2.Reset;
                VariableFieldUsage2.SetRange("Table No.", Database::"Service Ledger Entry EDMS");
                VariableFieldUsage2.SetRange("Variable Field Code", VariableFieldUsage."Variable Field Code");
                if VariableFieldUsage2.FindFirst then begin
                    FieldRef := RecordRef.Field(VariableFieldUsage."Field No.");
                    FieldRef2 := RecordRef2.Field(VariableFieldUsage2."Field No.");
                    FieldRef2.Value(FieldRef.Value);
                end;
            until VariableFieldUsage.Next = 0;
        RecordRef2.SetTable(ServLedgerEntry);
    end;

    local procedure InsertServReg(LedgEntryNo: Integer)
    begin
        if not (ServReg.FindLast and (ServReg."To Entry No." = 0)) then begin
            //  IF ServReg."No." = 0 THEN BEGIN
            ServReg.LockTable;
            if ServReg.FindLast then
                ServReg."No." := ServReg."No." + 1
            else
                ServReg."No." := 1;

            ServReg.Init;
            ServReg."No." := ServReg."No.";
            ServReg."From Entry No." := LedgEntryNo;
            ServReg."To Entry No." := LedgEntryNo;
            ServReg."Creation Date" := Today;
            ServReg."Creation Time" := Time;
            ServReg."Source Code" := ServJnlLine."Source Code";
            ServReg."Journal Batch Name" := ServJnlLine."Journal Batch Name";
            ServReg."User ID" := UserId;
            ServReg.Insert;
        end else begin
            if ((LedgEntryNo < ServReg."From Entry No.") and (LedgEntryNo <> 0)) or
               ((ServReg."From Entry No." = 0) and (LedgEntryNo > 0))
            then
                ServReg."From Entry No." := LedgEntryNo;
            if LedgEntryNo > ServReg."To Entry No." then
                ServReg."To Entry No." := LedgEntryNo;

            ServReg.Modify;
        end;
    end;


    procedure InsertTireEntry(ServJournalLine: Record "Serv. Journal Line")
    var
        TireEntry: Record "Tire Entry";
        TireEntry2: Record "Tire Entry";
        TextPlaceBusy: label 'That Tire placement is already used.';
        TextTireBusy: label 'That Tire is already used.';
        TireManagement: Codeunit "Tire Management";
        EntryNo: Integer;
        TireManagementSetup: Record "Tire Management Setup";
        VehicleTirePosition: Record "Vehicle Tire Position";
        TextFillFields: label 'For %1 to be posted in %2 must be filled all fields: %3';
        TireKilometers: Decimal;
    begin
        //2012.03.07 EDMS P8 >>
        if (ServJournalLine."Tire Code" = '') and (ServJournalLine."Vehicle Axle Code" = '') and
            (ServJournalLine."Tire Position Code" = '') then
            exit; // this is case then SERVICE ORDER post is going - after order is going to be posted invoice

        if (ServJournalLine."Tire Code" = '') or (ServJournalLine."Vehicle Axle Code" = '') or
            (ServJournalLine."Tire Position Code" = '') then
            Error(TextFillFields, TireEntry.TableCaption, ServJournalLine.TableCaption,
              ServJournalLine.FieldCaption("Vehicle Axle Code") + ',' + ServJournalLine.FieldCaption("Tire Position Code") + ',' +
              ServJournalLine.FieldCaption("Tire Code"));

        TireEntry.Init;
        TireEntry."Service Ledger Entry No." := ServLedgEntry."Entry No.";
        TireEntry."Document No." := ServLedgEntry."Document No.";
        TireEntry."Posting Date" := ServLedgEntry."Posting Date";
        TireEntry."Vehicle Serial No." := ServJournalLine."Vehicle Serial No.";
        TireEntry."Vehicle Axle Code" := ServJournalLine."Vehicle Axle Code";
        TireEntry."Tire Position Code" := ServJournalLine."Tire Position Code";
        TireEntry."Tire Code" := ServJournalLine."Tire Code";
        TireEntry."Entry Type" := ServJournalLine."Tire Operation Type" - 1;
        TireEntry."Variable Field Run 1" := ServJournalLine."Variable Field Run 1";

        TireEntry.TestField("Vehicle Serial No.");
        TireEntry.TestField("Vehicle Axle Code");
        TireEntry.TestField("Tire Code");
        if ServJournalLine."Tire Operation Type" = ServJournalLine."tire operation type"::"Put on" then begin
            VehicleTirePosition.Get(TireEntry."Vehicle Serial No.", TireEntry."Vehicle Axle Code", TireEntry."Tire Position Code");
            VehicleTirePosition.CalcFields(Available);
            if not VehicleTirePosition.Available then
                Error(TextPlaceBusy);
        end;
        TireManagementSetup.Get;
        if TireManagementSetup."Check Tire Unique" then
            if TireEntry."Entry Type" = TireEntry."entry type"::"Put on" then
                if (TireEntry."Tire Code" <> '') then begin
                    TireEntry2.Reset;
                    TireEntry2.SetRange("Tire Code", TireEntry."Tire Code");
                    TireEntry2.SetRange(Open, true);
                    TireEntry2.SetFilter("Entry No.", '<>%1', TireEntry."Entry No.");
                    if TireEntry2.FindFirst then
                        Error(TextTireBusy);
                end;
        if TireEntry."Posting Date" = 0D then
            TireEntry."Posting Date" := WorkDate;
        if TireEntry."Entry Type" = TireEntry."entry type"::"Take off" then
            TireEntry.Open := false
        else
            TireEntry.Open := true;
        if TireEntry."Entry Type" <> TireEntry."entry type"::"Put on" then begin
            // THen it supposed to be Tire take off and lets find last puton of that Tire on the possition
            TireEntry2.Reset;
            TireEntry2.SetRange("Vehicle Serial No.", TireEntry."Vehicle Serial No.");
            TireEntry2.SetRange("Vehicle Axle Code", TireEntry."Vehicle Axle Code");
            TireEntry2.SetRange("Tire Position Code", TireEntry."Tire Position Code");
            TireEntry2.SetRange("Tire Code", TireEntry."Tire Code");
            TireEntry2.SetRange("Entry Type", TireEntry."entry type"::"Put on");
            if TireEntry2.FindLast then begin
                TireEntry."Variable Field Tire Run" := TireEntry."Variable Field Run 1" - TireEntry2."Variable Field Run 1";
                TireKilometers := TireEntry."Variable Field Tire Run";
            end;
        end;

        TireManagement.CloseOpenedEntries(TireEntry);
        TireEntry.LockTable;
        TireEntry."Entry No." := TireManagement.GetNextTireEntryPrimaryNo;
        TireEntry.Insert(true);
        EntryNo := TireEntry."Entry No.";

        // adjust "Service Register EDMS"
        if ServReg."From Tire Entry No." = 0 then
            ServReg."From Tire Entry No." := EntryNo;
        ServReg."To Tire Entry No." := EntryNo;
        ServReg.Modify;

        //2012.03.07 EDMS P8 <<
    end;


    procedure InsertTireEntryAdv(ServJournalLine: Record "Serv. Journal Line")
    var
        TextPlaceBusy: label 'That Tire placement is already used.';
        TextTireBusy: label 'That Tire is already used.';
        TextFillFields: label 'For %1 to be posted in %2 must be filled all fields: %3';
        TireManagement: Codeunit "Tire Management";
        TireManagementSetup: Record "Tire Management Setup";
        VehicleAxleCode: Code[20];
        TirePositionCode: Code[20];
        TireCode: Code[20];
        VehicleAxleCode2: Code[20];
        TirePositionCode2: Code[20];
        TireCode2: Code[20];
    begin
        //2012.03.07 EDMS P8 >>
        if ServJournalLine."Tire Operation Type" = ServJournalLine."tire operation type"::"Position Change" then begin
            ServJournalLine.TestField("Vehicle Serial No.");
            ServJournalLine.TestField("Vehicle Axle Code");
            ServJournalLine.TestField("Tire Position Code");
            ServJournalLine.TestField("New Vehicle Axle Code");
            ServJournalLine.TestField("New Tire Position Code");

            VehicleAxleCode := ServJournalLine."Vehicle Axle Code";
            TirePositionCode := ServJournalLine."Tire Position Code";
            TireCode := TireManagement.GetTireOfPosition(ServJournalLine."Vehicle Serial No.", ServJournalLine."Vehicle Axle Code", ServJournalLine."Tire Position Code");
            if TireCode = '' then
                TireCode := ServJournalLine."Tire Code";
            VehicleAxleCode2 := ServJournalLine."New Vehicle Axle Code";
            TirePositionCode2 := ServJournalLine."New Tire Position Code";
            TireManagementSetup.Get;
            if TireManagementSetup."Check Tire Unique" then begin
                TireCode2 := TireManagement.GetTireOfPosition(ServJournalLine."Vehicle Serial No.", ServJournalLine."New Vehicle Axle Code", ServJournalLine."New Tire Position Code");
            end else begin
                TireCode2 := TireCode;
            end;

            ServJournalLine."Tire Operation Type" := ServJournalLine."tire operation type"::"Take off";
            ServJournalLine."Tire Code" := TireCode;
            InsertTireEntry(ServJournalLine);

            ServJournalLine."Tire Operation Type" := ServJournalLine."tire operation type"::"Take off";
            ServJournalLine."Vehicle Axle Code" := VehicleAxleCode2;
            ServJournalLine."Tire Position Code" := TirePositionCode2;
            ServJournalLine."Tire Code" := TireCode2;
            InsertTireEntry(ServJournalLine);

            ServJournalLine."Tire Operation Type" := ServJournalLine."tire operation type"::"Put on";
            ServJournalLine."Vehicle Axle Code" := VehicleAxleCode;
            ServJournalLine."Tire Position Code" := TirePositionCode;
            ServJournalLine."Tire Code" := TireCode2;
            InsertTireEntry(ServJournalLine);

            ServJournalLine."Tire Operation Type" := ServJournalLine."tire operation type"::"Put on";
            ServJournalLine."Vehicle Axle Code" := VehicleAxleCode2;
            ServJournalLine."Tire Position Code" := TirePositionCode2;
            ServJournalLine."Tire Code" := TireCode;
            InsertTireEntry(ServJournalLine);
        end else
            InsertTireEntry(ServJournalLine);

        //2012.03.07 EDMS P8 <<
    end;


    procedure FillDetServLE(ServLedgerEntry: Record "Service Ledger Entry EDMS"; ServJournalLine: Record "Serv. Journal Line")
    var
        DetServJournalLine: Record "Det. Serv. Journal Line";
        DetServLedgerEntryEDMS: Record "Det. Serv. Ledger Entry EDMS";
        EntryNo: Integer;
    begin
        //IF ServLedgerEntry."Entry Type" <> ServLedgerEntry."Entry Type"::Usage THEN
        //EXIT;
        DetServJournalLine.Reset;
        DetServJournalLine.SetRange("Journal Template Name", ServJournalLine."Journal Template Name");
        DetServJournalLine.SetRange("Journal Batch Name", ServJournalLine."Journal Batch Name");
        DetServJournalLine.SetRange("Journal Line No.", ServJournalLine."Line No.");
        DetServLedgerEntryEDMS.Reset;
        EntryNo := 0;
        if DetServLedgerEntryEDMS.FindLast then
            EntryNo := DetServLedgerEntryEDMS."Entry No.";
        if DetServJournalLine.FindFirst then
            repeat
                DetServLedgerEntryEDMS.Init;
                EntryNo += 1;
                DetServLedgerEntryEDMS."Entry No." := EntryNo;
                DetServLedgerEntryEDMS."Service Ledger Entry No." := ServLedgerEntry."Entry No.";
                ;
                DetServLedgerEntryEDMS."Document Type" := ServLedgerEntry."Document Type";
                DetServLedgerEntryEDMS."Document No." := ServLedgerEntry."Document No.";
                DetServLedgerEntryEDMS."Posting Date" := ServLedgerEntry."Posting Date";
                DetServLedgerEntryEDMS."Resource No." := DetServJournalLine."Resource No.";
                DetServLedgerEntryEDMS."Unit Cost" := DetServJournalLine."Unit Cost";                            //12.05.2015 EB.P30 #T030
                                                                                                                 //28.05.2015 EB.P30 #T030 >>
                if (ServLedgerEntry."Document Type" = ServLedgerEntry."document type"::Invoice) or
                   (ServLedgerEntry."Document Type" = ServLedgerEntry."document type"::"Return Order") then begin
                    DetServLedgerEntryEDMS."Finished Quantity (Hours)" := -DetServJournalLine."Finished Quantity (Hours)";
                    DetServLedgerEntryEDMS."Cost Amount" := -DetServJournalLine."Cost Amount";
                    DetServLedgerEntryEDMS."Quantity (Hours)" := -DetServJournalLine."Quantity (Hours)";
                end else begin
                    DetServLedgerEntryEDMS."Finished Quantity (Hours)" := DetServJournalLine."Finished Quantity (Hours)";
                    DetServLedgerEntryEDMS."Cost Amount" := DetServJournalLine."Cost Amount";
                    DetServLedgerEntryEDMS."Quantity (Hours)" := DetServJournalLine."Quantity (Hours)";
                end;
                //28.05.2015 EB.P30 #T030 <<
                DetServLedgerEntryEDMS.Insert;
            until DetServJournalLine.Next = 0;
    end;


    procedure AdjustServPlanStageRuns(VehSerNo: Code[20]; PlanNo: Code[20]; Recurrence: Integer; PlanStageCode: Code[20]; Run1: Decimal; Run2: Decimal; Run3: Decimal; DoChangeCurrRec: Boolean; DoChangeInitial: Boolean) RetValue: Integer
    var
        VehicleServicePlanStage: Record "Vehicle Service Plan Stage";
        VehicleServicePlan: Record "Vehicle Service Plan";
        DoCalcRun: Boolean;
        FixValueRun1: Decimal;
        FixValueRun2: Decimal;
        FixValueRun3: Decimal;
        CalcExpectedServiceDates: Report "Calc. Expected Service Dates";
    begin
        if PlanStageCode = '' then
            exit(1);
        if VehicleServicePlan.Get(VehSerNo, PlanNo) then
            if not VehicleServicePlan.Adjust then
                exit(2);
        if VehicleServicePlanStage.Get(VehSerNo, PlanNo, Recurrence, PlanStageCode) then begin
            DoCalcRun := true;
            if Run1 > 0 then
                FixValueRun1 := Run1 - VehicleServicePlanStage."VF Initial Run 1";
            if Run2 > 0 then
                FixValueRun2 := Run2 - VehicleServicePlanStage."VF Initial Run 2";
            if Run3 > 0 then
                FixValueRun3 := Run3 - VehicleServicePlanStage."VF Initial Run 3";
            if DoChangeCurrRec then begin  //02.04.2013 EDMS P8
                VehicleServicePlanStage."Variable Field Run 1" := Run1;
                VehicleServicePlanStage."Variable Field Run 2" := Run2;
                VehicleServicePlanStage."Variable Field Run 3" := Run3;
                VehicleServicePlanStage.Modify;
            end;
        end;
        VehicleServicePlanStage.SetRange("Vehicle Serial No.", VehSerNo);
        VehicleServicePlanStage.SetRange("Plan No.", PlanNo);
        VehicleServicePlanStage.SetRange(Status, VehicleServicePlanStage.Status::Pending);
        if VehicleServicePlanStage.FindFirst then
            repeat
                if DoCalcRun then
                    if (((VehicleServicePlanStage.Code = PlanStageCode) and (VehicleServicePlanStage.Recurrence = Recurrence) and
                         DoChangeCurrRec) or
                        (VehicleServicePlanStage.Code <> PlanStageCode) or (VehicleServicePlanStage.Recurrence <> Recurrence)) then begin
                        if (Run1 > 0) and (VehicleServicePlanStage."VF Initial Run 1" > 0) then begin
                            VehicleServicePlanStage."Variable Field Run 1" := VehicleServicePlanStage."VF Initial Run 1" + FixValueRun1;
                            if DoChangeInitial then  //02.04.2013 EDMS P8
                                VehicleServicePlanStage."VF Initial Run 1" := VehicleServicePlanStage."Variable Field Run 1";
                        end;
                        if (Run2 > 0) and (VehicleServicePlanStage."VF Initial Run 2" > 0) then begin
                            VehicleServicePlanStage."Variable Field Run 2" := VehicleServicePlanStage."VF Initial Run 2" + FixValueRun2;
                            if DoChangeInitial then  //02.04.2013 EDMS P8
                                VehicleServicePlanStage."VF Initial Run 2" := VehicleServicePlanStage."Variable Field Run 2";
                        end;
                        if (Run3 > 0) and (VehicleServicePlanStage."VF Initial Run 3" > 0) then begin
                            VehicleServicePlanStage."Variable Field Run 3" := VehicleServicePlanStage."VF Initial Run 3" + FixValueRun3;
                            if DoChangeInitial then  //02.04.2013 EDMS P8
                                VehicleServicePlanStage."VF Initial Run 3" := VehicleServicePlanStage."Variable Field Run 3";
                        end;
                        VehicleServicePlanStage.Modify;
                    end;
            until VehicleServicePlanStage.Next = 0;
        // 2012.08.14 EDMS P8 >>
        // COMMENTED for future
        /*
        IF CONFIRM(Text001, TRUE) THEN BEGIN
          CalcExpectedServiceDates.SETTABLEVIEW(VehicleServicePlanStage);
          CalcExpectedServiceDates.RUN;
        END;
        */
        // 2012.08.14 EDMS P8 <<
        exit(0);

    end;

    [IntegrationEvent(false, false)]
    local procedure AfterFillServiceLedgerEntry(var ServLedgEntry: Record "Service Ledger Entry EDMS"; var ServJnlLine: Record "Serv. Journal Line")
    begin
    end;
}

