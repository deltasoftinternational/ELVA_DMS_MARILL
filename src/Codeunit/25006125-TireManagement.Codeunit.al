Codeunit 25006125 "Tire Management"
{

    trigger OnRun()
    begin
    end;

    var
        TireManagementSetup: Record "Tire Management Setup";


    procedure ShowCreateAxleFromTmpl(VehicleAxlePar: Record "Vehicle Axle"): Boolean
    var
        PlatformTemplate: Record "Platform Template";
        PlatformTemplateAxle: Record "Platform Template Axle";
        VehicleAxle: Record "Vehicle Axle";
        VehicleTirePosition: Record "Vehicle Tire Position";
        PlatformTemplTirePosition: Record "Platform Templ. Tire Position";
        PlatformTemplates: Page "Platform Templates";
    begin
        PlatformTemplates.LookupMode(true);
        if PlatformTemplates.RunModal in [Action::LookupOK, Action::OK] then begin
            PlatformTemplates.GetRecord(PlatformTemplate);
            if PlatformTemplate.Code <> '' then begin
                AsignPlatformToVehicle(VehicleAxlePar."Vehicle Serial No.", PlatformTemplate.Code);
            end;
        end;
    end;


    procedure GetVehicleAxleToEntry(VehicleNo: Code[20]; AxleCode: Code[10]) RetValue: Code[10]
    var
        VehicleAxle: Record "Vehicle Axle";
    begin
        if (VehicleNo <> '') and (AxleCode <> '') then begin
            VehicleAxle.Reset;
            if VehicleAxle.Get(VehicleNo, AxleCode) then
                if not VehicleAxle.Available then begin
                    RetValue := GetNextAvailableAxle(VehicleNo);
                end else
                    RetValue := AxleCode;
        end else
            RetValue := GetNextAvailableAxle(VehicleNo);
        exit(RetValue);
    end;


    procedure GetNextAvailableAxle(VehicleNo: Code[20]) RetValue: Code[10]
    var
        VehicleAxle: Record "Vehicle Axle";
    begin
        if (VehicleNo <> '') then begin
            VehicleAxle.Reset;
            VehicleAxle.SetRange("Vehicle Serial No.", VehicleNo);
            VehicleAxle.SetRange(Available, true);
            if not VehicleAxle.FindFirst then
                if TireManagementSetup.Get then
                    if TireManagementSetup."Default Platform Template" <> '' then
                        AsignPlatformToVehicle(VehicleNo, TireManagementSetup."Default Platform Template");
            if VehicleAxle.FindFirst then
                RetValue := VehicleAxle.Code;
        end;
        exit(RetValue);
    end;


    procedure CloseOpenedEntries(TireEntryPar: Record "Tire Entry")
    var
        TireEntry: Record "Tire Entry";
    begin
        if (TireEntryPar."Tire Code" <> '') then begin
            TireEntry.Reset;
            TireManagementSetup.Get;
            if TireManagementSetup."Check Tire Unique" then begin
                TireEntry.SetRange("Tire Code", TireEntryPar."Tire Code");
                TireEntry.SetRange(Open, true);
            end else begin
                TireEntry.SetRange("Vehicle Serial No.", TireEntryPar."Vehicle Serial No.");
                TireEntry.SetRange("Vehicle Axle Code", TireEntryPar."Vehicle Axle Code");
                TireEntry.SetRange("Tire Position Code", TireEntryPar."Tire Position Code");
                TireEntry.SetRange(Open, true);
            end;
            if TireEntry.FindFirst then
                repeat
                    TireEntry.Open := false;
                    TireEntry.Modify(false);
                until TireEntry.Next = 0;
        end;
        exit;
    end;


    procedure AddTireEntry(ServLENo: Integer; DocumentNo: Code[20]; PostingDate: Date; VehicleSerialNo: Code[20]; VehicleAxleCode: Code[10]; TirePositionCode: Code[10]; TireCode: Code[20]; EntryType: Integer; MileagePar: Decimal) RetEntryNo: Integer
    var
        TireEntry: Record "Tire Entry";
        TireEntry2: Record "Tire Entry";
        TextPlaceBusy: label 'That Tire placement is already used.';
        TextTireBusy: label 'That Tire is already used.';
    begin
        //"Vehicle Serial No.", "Vehicle Axle Code", "Tire Position Code", "Tire Code", "Entry Type", Mileage
        TireEntry.Init;
        TireEntry."Service Ledger Entry No." := ServLENo;
        TireEntry."Document No." := DocumentNo;
        TireEntry."Posting Date" := PostingDate;
        TireEntry."Vehicle Serial No." := VehicleSerialNo;
        TireEntry."Vehicle Axle Code" := VehicleAxleCode;
        TireEntry."Tire Position Code" := TirePositionCode;
        TireEntry."Tire Code" := TireCode;
        TireEntry."Entry Type" := EntryType;
        TireEntry."Variable Field Run 1" := MileagePar;

        TireEntry.TestField("Vehicle Serial No.");
        TireEntry.TestField("Vehicle Axle Code");
        TireEntry.TestField("Tire Code");
        if TireEntry."Entry Type" = TireEntry."entry type"::"Put on" then
            if (TireEntry."Vehicle Serial No." <> '') and (TireEntry."Vehicle Axle Code" <> '') and (TireEntry."Tire Position Code" <> '') then begin
                TireEntry2.Reset;
                TireEntry2.SetRange("Vehicle Serial No.", TireEntry."Vehicle Serial No.");
                TireEntry2.SetRange("Vehicle Axle Code", TireEntry."Vehicle Axle Code");
                TireEntry2.SetRange("Tire Position Code", TireEntry."Tire Position Code");
                TireEntry2.SetRange(Open, true);
                //TireEntry2.SETFILTER("Entry No.", '<>%1', "Entry No.");
                if TireEntry2.FindFirst then
                    Error(TextPlaceBusy);
            end;
        TireManagementSetup.Get;
        if TireManagementSetup."Check Tire Unique" then
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
            if TireEntry2.FindLast then
                TireEntry."Variable Field Tire Run" := TireEntry."Variable Field Run 1" - TireEntry2."Variable Field Run 1";
        end;

        CloseOpenedEntries(TireEntry);
        TireEntry.LockTable;
        GetNextTireEntryPrimaryNo;
        TireEntry.Insert(true);
        RetEntryNo := TireEntry."Entry No.";
        exit(RetEntryNo);
    end;


    procedure AsignPlatformToVehicle(VehicleNo: Code[20]; PlatformCode: Code[10])
    var
        PlatformTemplateAxle: Record "Platform Template Axle";
        VehicleAxle: Record "Vehicle Axle";
        PlatformTemplTirePosition: Record "Platform Templ. Tire Position";
        VehicleTirePosition: Record "Vehicle Tire Position";
    begin
        if PlatformCode = '' then
            exit;

        PlatformTemplateAxle.Reset;
        PlatformTemplateAxle.SetRange("Template Code", PlatformCode);
        if PlatformTemplateAxle.FindFirst then
            repeat
                VehicleAxle.Init;
                VehicleAxle.Validate(Code, PlatformTemplateAxle.Code);
                VehicleAxle."Vehicle Serial No." := VehicleNo;
                VehicleAxle.Insert(true);
                PlatformTemplTirePosition.Reset;
                PlatformTemplTirePosition.SetRange("Template Code", PlatformTemplateAxle."Template Code");
                PlatformTemplTirePosition.SetRange("Template Axle Code", PlatformTemplateAxle.Code);
                if PlatformTemplTirePosition.FindFirst then
                    repeat
                        VehicleTirePosition.Init;
                        VehicleTirePosition.Validate(Code, PlatformTemplTirePosition.Code);
                        VehicleTirePosition.Validate(Description, PlatformTemplTirePosition.Description);
                        VehicleTirePosition."Vehicle Serial No." := VehicleNo;
                        VehicleTirePosition.Validate("Axle Code", VehicleAxle.Code);
                        VehicleTirePosition.Insert(true);
                    until PlatformTemplTirePosition.Next = 0;
            until PlatformTemplateAxle.Next = 0;
    end;


    procedure GetNextTireEntryPrimaryNo() RetValue: Integer
    var
        TireEntry: Record "Tire Entry";
    begin
        TireEntry.Reset;
        if TireEntry.FindLast then
            RetValue := TireEntry."Entry No."
        else
            RetValue := 0;
        exit(RetValue + 1);
    end;


    procedure ChangeVehicleInServiceHeader(ServiceHeader: Record "Service Header EDMS"; VehicleNoFrom: Code[20]; VehicleNoTo: Code[20])
    var
        ServiceLine: Record "Service Line EDMS";
        TextDoAutoAdjust: label 'Do you allow adjust Tire data in lines by program?';
        TextErrorStop: label 'Process is interrupted, do it manually first.';
        VehicleFrom: Record Vehicle;
        VehicleTo: Record Vehicle;
        VehicleTirePosition: Record "Vehicle Tire Position";
    begin
        ServiceLine.Reset;
        ServiceLine.SetRange("Document Type", ServiceHeader."Document Type");
        ServiceLine.SetRange("Document No.", ServiceHeader."No.");
        ServiceLine.SetFilter("Vehicle Axle Code", '<>%1', '');
        if ServiceLine.FindFirst then
            if Confirm(TextDoAutoAdjust, true) then begin
                if VehicleFrom.Get(VehicleNoFrom) then begin
                    if VehicleTo.Get(VehicleNoTo) then begin
                        VehicleTirePosition.Reset;
                        VehicleTirePosition.SetCurrentkey("Vehicle Serial No.", "Axle Code", Code);
                        repeat
                            // IN future it could be redone like trying to do real adjustment, but simply check
                            if not VehicleTirePosition.Get(VehicleNoTo, ServiceLine."Vehicle Axle Code", ServiceLine."Tire Position Code") then
                                Error(TextErrorStop);
                        until ServiceLine.Next = 0;
                    end else
                        Error(TextErrorStop);
                end else
                    Error(TextErrorStop);
            end else
                Error(TextErrorStop);
    end;


    procedure GetTireOfPosition(VehicleSerialNo: Code[20]; AxleCode: Code[20]; PositionCode: Code[20]): Code[20]
    var
        TireEntry: Record "Tire Entry";
    begin
        TireEntry.SetRange("Vehicle Serial No.", VehicleSerialNo);
        TireEntry.SetRange("Vehicle Axle Code", AxleCode);
        TireEntry.SetRange("Tire Position Code", PositionCode);
        TireEntry.SetRange(Open, true);
        if TireEntry.FindLast then
            exit(TireEntry."Tire Code")
        else
            exit('');
    end;
}

