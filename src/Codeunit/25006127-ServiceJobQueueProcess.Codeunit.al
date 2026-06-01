Codeunit 25006127 "Service Job Queue Process"
{
    TableNo = "Job Queue Entry";

    trigger OnRun()
    begin
        ProceedParameters(Rec."Parameter String");
        case RunMode of
            1:
                CalcPlanExpectedDate;
            2:
                //CreateOrdersBySLEntry;
                begin
                    ServicePlanMgt.CreateOrdersByFiltered(0D, 0);
                end;
        //3:
        //Codeunit.Run(Codeunit::"OriLink Auto Asignment");
        end;
    end;

    var
        RunMode: Integer;
        ServicePlanMgt: Codeunit "Service Plan Management";


    procedure ProceedParameters(ParamString: Text[1024])
    var
        ParamName: Text[30];
        ParamValue: Text[30];
    begin
        repeat
            ParamValue := CutNextParam(ParamString, ParamName);
            case UpperCase(ParamName) of
                'RUNMODE':
                    Evaluate(RunMode, ParamValue);
            end;
        until ParamString = '';
    end;


    procedure CutNextParam(var ParamString: Text[1024]; var Name: Text[30]) RetValue: Text[30]
    var
        Currpos: Integer;
        ParamStringTmp: Text[30];
    begin
        Name := '';
        Currpos := StrPos(ParamString, ';');
        if Currpos > 0 then begin
            Name := CopyStr(ParamString, 1, Currpos - 1);
            ParamString := CopyStr(ParamString, Currpos + 1, StrLen(ParamString) - Currpos);
        end else begin
            Name := ParamString;
            ParamString := '';
        end;
        Currpos := StrPos(Name, '=');
        if Currpos > 0 then begin
            ParamStringTmp := Name;
            Name := CopyStr(ParamStringTmp, 1, Currpos - 1);
            RetValue := CopyStr(ParamStringTmp, Currpos + 1, StrLen(ParamStringTmp) - Currpos);
        end else begin
            RetValue := '';
        end;
        exit(RetValue);
    end;


    procedure CalcPlanExpectedDate()
    var
        CalcExpectedServiceDates: Report "Calc. Expected Service Dates";
    begin
        Report.Run(Report::"Calc. Expected Service Dates", false, false);
    end;


    procedure CreateOrdersByPlan()
    var
        VehicleContact: Record "Vehicle Contact";
        ContactBusinessRelation: Record "Contact Business Relation";
        ServiceMgtSetup: Record "Service Mgt. Setup EDMS";
        ServiceHeader: Record "Service Header EDMS";
        ServiceHeaderTmp: Record "Service Header EDMS" temporary;
        VehicleServicePlanStage: Record "Vehicle Service Plan Stage";
        ServicePackage: Record "Service Package";
        ServicePackageVersion: Record "Service Package Version";
        CustomerToCurrent: Record Customer;
        ServicePlanMgt: Codeunit "Service Plan Management";
        OrderDate: Date;
        DefContRelationshipCode: Code[10];
    begin
        ServiceHeaderTmp.DeleteAll;
        ServiceMgtSetup.Get;
        VehicleContact.SetRange("Relationship Code", ServiceMgtSetup."Serv. Plan Cont. Relationship");
        VehicleServicePlanStage.SetCurrentkey(Status, "Expected Service Date");
        VehicleServicePlanStage.SetRange(Status, VehicleServicePlanStage.Status::Pending);
        VehicleServicePlanStage.SetRange("Expected Service Date", Today);
        repeat
            if ServicePackage.Get(VehicleServicePlanStage."Package No.") then begin
                ServicePackageVersion.SetRange("Package No.", ServicePackage."No.");
                if ServicePackageVersion.FindFirst then begin
                    VehicleContact.SetRange("Vehicle Serial No.", VehicleServicePlanStage."Vehicle Serial No.");
                    if VehicleContact.FindFirst then begin
                        ContactBusinessRelation.SetRange("Contact No.", VehicleContact."Contact No.");
                        if ContactBusinessRelation.FindFirst then
                            if CustomerToCurrent.Get(ContactBusinessRelation."No.") then begin
                                Clear(ServicePlanMgt);
                                ServicePlanMgt.SetVehicleServicePlanStage(VehicleServicePlanStage);
                                ServicePlanMgt.SetSPVersion(ServicePackageVersion);

                                ServicePlanMgt.SetCustomer(CustomerToCurrent);
                                ServiceHeader.Reset;
                                ServiceHeaderTmp.Reset;
                                ServiceHeaderTmp.SetRange("Vehicle Serial No.", VehicleServicePlanStage."Vehicle Serial No.");
                                if ServiceHeaderTmp.FindFirst then begin
                                    ServiceHeader.Get(ServiceHeaderTmp."Document Type", ServiceHeaderTmp."No.");
                                end else begin
                                    ServiceHeader.Init;
                                end;
                                ServicePlanMgt.CreateServOrderForVehBy(ServiceHeader, 41, '');
                                ServiceHeaderTmp.TransferFields(ServiceHeader);
                                ServiceHeaderTmp.Insert;
                            end;
                    end;
                end;
            end;
        until VehicleServicePlanStage.Next = 0;
    end;


    procedure CreateOrdersBySLEntry()
    var
        Vehicle: Record Vehicle;
        VehicleContact: Record "Vehicle Contact";
        ContactBusinessRelation: Record "Contact Business Relation";
        ServiceMgtSetup: Record "Service Mgt. Setup EDMS";
        MarketingSetup: Record "Marketing Setup";
        ServiceHeader: Record "Service Header EDMS";
        ServiceHeaderTmp: Record "Service Header EDMS" temporary;
        VehicleServicePlanStage: Record "Vehicle Service Plan Stage";
        ServicePackage: Record "Service Package";
        ServicePackageVersion: Record "Service Package Version";
        CustomerToCurrent: Record Customer;
        ServiceLedgerEntry: Record "Service Ledger Entry EDMS";
        ServicePlanMgt: Codeunit "Service Plan Management";
        OrderDate: Date;
        DefContRelationshipCode: Code[10];
        FilterStr: Text[30];
        IsFound: Boolean;
        RecExists: Boolean;
    begin
        OrderDate := Today;
        ServiceHeaderTmp.DeleteAll;

        ServiceMgtSetup.Get;
        MarketingSetup.Get;

        VehicleContact.Reset;
        VehicleContact.SetCurrentkey("Vehicle Serial No.", "Relationship Code", "Contact No.");
        VehicleContact.SetRange("Relationship Code", ServiceMgtSetup."Serv. Plan Cont. Relationship");

        ContactBusinessRelation.Reset;
        ContactBusinessRelation.SetRange("Business Relation Code", MarketingSetup."Bus. Rel. Code for Customers");

        Vehicle.Reset;
        Vehicle.FindFirst;
        repeat
            ServiceHeader.Reset;
            ServiceHeader.Init;
            ServiceHeader."Vehicle Serial No." := Vehicle."Serial No.";
            ServiceLedgerEntry.SetCurrentkey("Vehicle Serial No.", "Posting Date", "Entry Type");
            ServiceLedgerEntry.SetRange("Vehicle Serial No.", Vehicle."Serial No.");
            FilterStr := StrSubstNo('%1|%2', ServiceLedgerEntry."entry type"::Usage, ServiceLedgerEntry."entry type"::Info);
            ServiceLedgerEntry.SetFilter("Entry Type", FilterStr);
            if ServiceLedgerEntry.FindLast then begin
                ServiceHeader."Order Date" := OrderDate;
                ServiceHeader."Variable Field Run 1" := ServiceLedgerEntry."Variable Field Run 1";
                ServiceHeader."Variable Field Run 2" := ServiceLedgerEntry."Variable Field Run 2";
                ServiceHeader."Variable Field Run 3" := ServiceLedgerEntry."Variable Field Run 3";
                IsFound := ServiceHeader.IsAchievedServPlanStageByField(ServiceHeader.FieldNo("Variable Field Run 1"),
                  VehicleServicePlanStage);
                if not IsFound then
                    IsFound := ServiceHeader.IsAchievedServPlanStageByField(ServiceHeader.FieldNo("Variable Field Run 2"),
                      VehicleServicePlanStage);
                if not IsFound then
                    IsFound := ServiceHeader.IsAchievedServPlanStageByField(ServiceHeader.FieldNo("Variable Field Run 3"),
                      VehicleServicePlanStage);
                if not IsFound then
                    IsFound := ServiceHeader.IsAchievedServStageByInterval(VehicleServicePlanStage);
                if IsFound then begin
                    VehicleServicePlanStage.FindFirst;
                    repeat
                        ServicePackageVersion.SetRange("Package No.", VehicleServicePlanStage."Package No.");
                        if ServicePackageVersion.FindFirst then;
                        VehicleContact.SetRange("Vehicle Serial No.", VehicleServicePlanStage."Vehicle Serial No.");
                        if VehicleContact.FindFirst then begin
                            ContactBusinessRelation.SetRange("Contact No.", VehicleContact."Contact No.");
                            if ContactBusinessRelation.FindFirst then
                                if CustomerToCurrent.Get(ContactBusinessRelation."No.") then begin
                                    ServicePlanMgt.SetVehicleServicePlanStage(VehicleServicePlanStage);
                                    ServicePlanMgt.SetSPVersion(ServicePackageVersion);

                                    ServicePlanMgt.SetCustomer(CustomerToCurrent);
                                    ServiceHeader.Reset;
                                    ServiceHeaderTmp.Reset;
                                    ServiceHeaderTmp.SetRange("Vehicle Serial No.", VehicleServicePlanStage."Vehicle Serial No.");
                                    if ServiceHeaderTmp.FindFirst then begin
                                        ServiceHeader.Get(ServiceHeaderTmp."Document Type", ServiceHeaderTmp."No.");
                                        RecExists := true;
                                    end else begin
                                        RecExists := false;
                                        ServiceHeader.Init;
                                        ServiceHeader."No." := '';
                                        ServiceHeader."Order Date" := Today;
                                        ServiceHeader."Variable Field Run 1" := ServiceLedgerEntry."Variable Field Run 1";
                                        ServiceHeader."Variable Field Run 2" := ServiceLedgerEntry."Variable Field Run 2";
                                        ServiceHeader."Variable Field Run 3" := ServiceLedgerEntry."Variable Field Run 3";
                                    end;
                                    if ServicePackageVersion.FindFirst then
                                        ServicePlanMgt.CreateServOrderForVehBy(ServiceHeader, 41, '')
                                    else
                                        ServicePlanMgt.CreateServOrderForVehBy(ServiceHeader, 9, '');
                                    if not RecExists then begin
                                        ServiceHeaderTmp.Init;
                                        ServiceHeaderTmp.TransferFields(ServiceHeader);
                                        ServiceHeaderTmp.Insert;
                                    end;
                                end;
                        end;
                    until VehicleServicePlanStage.Next = 0;
                end;
            end;
        until Vehicle.Next = 0;
    end;
}

