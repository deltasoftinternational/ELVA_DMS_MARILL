Codeunit 25006103 "Service Plan Management"
{
    // 04.09.2018 EDMS
    //   * FIX for adding service plan info in service lines
    // 
    // 08.05.2013 EDMS P8
    //   * FIX for recurring - look for adjust
    // 
    // 25.03.2013 EDMS P8
    //   * FIX FOR THE FILTERS


    trigger OnRun()
    begin
    end;

    var
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        VehicleServicePlan: Record "Vehicle Service Plan";
        xVehicleServicePlanTmp: Record "Vehicle Service Plan" temporary;
        VehicleServicePlanStage: Record "Vehicle Service Plan Stage";
        xVehicleServicePlanStageTmp: Record "Vehicle Service Plan Stage" temporary;
        Vehicle: Record Vehicle;
        Customer: Record Customer;
        SPVersion: Record "Service Package Version";
        ServicePackage: Record "Service Package";
        ServiceInfoPaneMgt: Codeunit "Service Info-Pane Mgt. EDMS";
        "//--Calc Exp Date vars--------": Integer;
        StageLastTmp: Record "Vehicle Service Plan Stage" temporary;
        Text001: label 'Automatically created by %1.';
        "//--CreateOrdersByFiltered var": Integer;
        VehicleGlob: Record Vehicle;
        VehicleContactGlob: Record "Vehicle Contact";
        ContactBusinessRelationGlob: Record "Contact Business Relation";
        CustomerGlob: Record Customer;
        VehicleServicePlanGlob: Record "Vehicle Service Plan";
        VehicleServicePlanStageGlob: Record "Vehicle Service Plan Stage";
        ServicePackageGlob: Record "Service Package";
        ServicePackageVersionGlob: Record "Service Package Version";
        TextLog001: label 'CalcExpectedServiceDate begin for: %1, %2, %3';
        TextLog002: label 'Important values: %1=%2, %3=%4, %5=%6, %7=%8';
        TextLogUpdateField: label 'Value of field %2 in %1 is updated to %3.';
        TextLogEnd: label 'CalcExpectedServiceDate finished for: %1, %2, %3';
        TextLogCalcByInterval: label 'GetExpectedDateByInterval processed, date is: %1';
        TextLogInterrupt: label 'CalcExpectedServiceDate interrupted for: %1, %2. Due to empty %3.';
        TextLogAvgValues: label 'Result of CalcStageAvgPerDay are values: %1, %2, %3, %4.';
        TextLogAvgValuesPlan: label 'Result of CalcStageAvgByPlan are values: %1, %2, %3, %4.';
        TextLogLastSLEValues: label 'Are found last SLE values: %1, %2, %3, %4.';
        TextLogCalcValue: label 'Is calculated %1 = %2';
        TextTableFilter: label 'Table %1 is filtered: %2.';
        TextSkip: label 'Value of field %2 in %1 is not updated to %3 due to %4.';
        TextLogAvgCalcPars: label 'CalcStageAvgPerDay for field %5 pars: (%1 - %2)/(%3 - %4)';
        TextLogAvgCalcPlanPars: label 'CalcStageAvgByPlan for field %5 pars: (%1 - %2)/(%3 - %4)';
        TextLogAvgValueOfPlan: label 'CalcStageAvgPerDay for field %1 taken from plan calc: %2';


    procedure ApplyTemplate(var VehServicePlan: Record "Vehicle Service Plan")
    var
        ServicePlanTemplate: Record "Service Plan Template";
        ServicePlanTemplateStage: Record "Service Plan Template Stage";
        VehServicePlan1: Record "Vehicle Service Plan";
        VehServicePlanStage: Record "Vehicle Service Plan Stage";
        VehServicePlanStage1: Record "Vehicle Service Plan Stage";
        ServDate: Date;
        Run1: Decimal;
        Run2: Decimal;
        Run3: Decimal;
        InitRun1: Decimal;
        InitRun2: Decimal;
        InitRun3: Decimal;
    begin
        ServicePlanTemplate.Reset;
        if not (Page.RunModal(Page::"Service Plan Templates", ServicePlanTemplate) = Action::LookupOK) then
            exit;
        ApplyTemplateToPlan(ServicePlanTemplate, VehServicePlan);
    end;


    procedure ApplyTemplateToPlan(ServicePlanTemplate: Record "Service Plan Template"; var VehServicePlan: Record "Vehicle Service Plan")
    var
        ServicePlanTemplateStage: Record "Service Plan Template Stage";
        VehServicePlan1: Record "Vehicle Service Plan";
        VehServicePlanStage: Record "Vehicle Service Plan Stage";
        VehServicePlanStage1: Record "Vehicle Service Plan Stage";
        ServDate: Date;
        Run1: Decimal;
        Run2: Decimal;
        Run3: Decimal;
        InitRun1: Decimal;
        InitRun2: Decimal;
        InitRun3: Decimal;
    begin
        if VehServicePlan."No." = '' then begin
            if VehServicePlan1.Get(VehServicePlan."Vehicle Serial No.", ServicePlanTemplate.Code) then
                if VehServicePlan.Get(VehServicePlan."Vehicle Serial No.", ServicePlanTemplate.Code) then
                    exit;
            VehServicePlan."No." := ServicePlanTemplate.Code;
            VehServicePlan.Insert(true);
            VehServicePlan.Validate(Description, ServicePlanTemplate.Description);
            VehServicePlan.Validate("Template Code", ServicePlanTemplate.Code);
            VehServicePlan.Validate("Service Plan Type", ServicePlanTemplate."Service Plan Type");
            VehServicePlan.Validate(Adjust, ServicePlanTemplate.Adjust);
            VehServicePlan.Validate(Recurring, ServicePlanTemplate.Recurring);
            VehServicePlan.Modify(true);
        end;
        VehServicePlanStage1.Reset;
        VehServicePlanStage1.SetRange("Vehicle Serial No.", VehServicePlan."Vehicle Serial No.");
        VehServicePlanStage1.SetRange("Plan No.", VehServicePlan."No.");
        ServicePlanTemplateStage.Reset;
        ServicePlanTemplateStage.SetRange("Template Code", ServicePlanTemplate.Code);
        if ServicePlanTemplateStage.FindFirst then
            repeat
                VehServicePlanStage.Init;
                VehServicePlanStage."Vehicle Serial No." := VehServicePlan."Vehicle Serial No.";
                VehServicePlanStage."Plan No." := VehServicePlan."No.";
                Run1 := 0;
                Run2 := 0;
                Run3 := 0;
                InitRun1 := 0;
                InitRun2 := 0;
                InitRun3 := 0;

                VehServicePlanStage1.SetRange(Code, ServicePlanTemplateStage.Code);
                if VehServicePlanStage1.FindLast then begin
                    VehServicePlanStage.Recurrence := VehServicePlanStage1.Recurrence + 1;
                    if VehServicePlan.Recurring then begin
                        Run1 := VehServicePlanStage1."Variable Field Run 1";
                        Run2 := VehServicePlanStage1."Variable Field Run 2";
                        Run3 := VehServicePlanStage1."Variable Field Run 3";
                        InitRun1 := VehServicePlanStage1."VF Initial Run 1";
                        InitRun2 := VehServicePlanStage1."VF Initial Run 2";
                        InitRun3 := VehServicePlanStage1."VF Initial Run 3";
                    end;
                end;

                VehServicePlanStage.Code := ServicePlanTemplateStage.Code;
                VehServicePlanStage.Description := ServicePlanTemplateStage.Description;
                VehServicePlanStage."Service Interval" := ServicePlanTemplateStage."Service Interval";
                VehServicePlanStage."Package No." := ServicePlanTemplateStage."Package No.";
                if ServicePlanTemplateStage."Variable Field Run 1" > 0 then begin
                    VehServicePlanStage."Variable Field Run 1" := ServicePlanTemplateStage."Variable Field Run 1" + Run1;
                    VehServicePlanStage."VF Initial Run 1" := ServicePlanTemplateStage."Variable Field Run 1" + InitRun1;
                end;
                if ServicePlanTemplateStage."Variable Field Run 2" > 0 then begin
                    VehServicePlanStage."Variable Field Run 2" := ServicePlanTemplateStage."Variable Field Run 2" + Run2;
                    VehServicePlanStage."VF Initial Run 2" := ServicePlanTemplateStage."Variable Field Run 2" + InitRun2;
                end;
                if ServicePlanTemplateStage."Variable Field Run 3" > 0 then begin
                    VehServicePlanStage."Variable Field Run 3" := ServicePlanTemplateStage."Variable Field Run 3" + Run3;
                    VehServicePlanStage."VF Initial Run 3" := ServicePlanTemplateStage."Variable Field Run 3" + InitRun3;
                end;
                VehServicePlanStage."Expected Service Date" := 0D;
                VehServicePlanStage.Insert;
            until ServicePlanTemplateStage.Next = 0;
    end;


    procedure UpdateDocLinkDocNo(OldDocType: Option "Order","Return Order","Posted Order","Posted Return Order"; OldDocNo: Code[20]; NewDocType: Option "Order","Return Order","Posted Order","Posted Return Order"; NewDocNo: Code[20])
    var
        DocLink: Record "Service Plan Document Link";
        DocLink2: Record "Service Plan Document Link";
    begin
        DocLink.Reset;
        DocLink.SetCurrentkey("Document Type", "Document No.");
        DocLink.SetRange("Document Type", OldDocType);
        DocLink.SetRange("Document No.", OldDocNo);
        if DocLink.FindFirst then
            repeat
                DocLink2.Get(DocLink."Vehicle Serial No.", DocLink."Serv. Plan No.", DocLink."Plan Stage Recurrence",
                   DocLink."Serv. Plan Stage Code", DocLink."Line No.");
                DocLink2."Document Type" := NewDocType;
                DocLink2."Document No." := NewDocNo;
                DocLink2.Modify;
            until DocLink.Next = 0;
    end;


    procedure DocLinkApply(ServicePlanDocumentLink: Record "Service Plan Document Link")
    var
        ServDate: Date;
        ServiceHeader: Record "Service Header EDMS";
        PstServHeader: Record "Posted Serv. Order Header";
        PstRetServHeader: Record "Posted Serv. Ret. Order Header";
        ServicePlanTemplate: Record "Service Plan Template";
        VehicleServicePlan: Record "Vehicle Service Plan";
    begin
        VehicleServicePlanStage.Reset;
        VehicleServicePlanStage.SetRange("Vehicle Serial No.", ServicePlanDocumentLink."Vehicle Serial No.");
        VehicleServicePlanStage.SetRange("Plan No.", ServicePlanDocumentLink."Serv. Plan No.");
        VehicleServicePlanStage.SetRange(Recurrence, ServicePlanDocumentLink."Plan Stage Recurrence");
        VehicleServicePlanStage.SetRange(Code, ServicePlanDocumentLink."Serv. Plan Stage Code");
        if VehicleServicePlanStage.FindFirst then begin
            ServDate := 0D;
            case ServicePlanDocumentLink."Document Type" of
                ServicePlanDocumentLink."document type"::Quote:
                    begin
                        if ServiceHeader.Get(ServiceHeader."document type"::Quote, ServicePlanDocumentLink."Document No.") then
                            ServDate := GetServDateFromServHeader(ServiceHeader);
                    end;
                ServicePlanDocumentLink."document type"::Order:
                    begin
                        if ServiceHeader.Get(ServiceHeader."document type"::Order, ServicePlanDocumentLink."Document No.") then
                            ServDate := GetServDateFromServHeader(ServiceHeader);
                    end;
                ServicePlanDocumentLink."document type"::"Return Order":
                    begin
                        if ServiceHeader.Get(ServiceHeader."document type"::"Return Order", ServicePlanDocumentLink."Document No.") then
                            ServDate := GetServDateFromServHeader(ServiceHeader);
                    end;
                ServicePlanDocumentLink."document type"::"Posted Order":
                    begin
                        if PstServHeader.Get(ServicePlanDocumentLink."Document No.") then
                            ServDate := GetServDateFromPostedOrder(PstServHeader);
                    end;
                ServicePlanDocumentLink."document type"::"Posted Return Order":
                    begin
                        if PstRetServHeader.Get(ServicePlanDocumentLink."Document No.") then
                            ServDate := GetServDateFromPstRetOrder(PstRetServHeader);
                    end;
            end;
            if ServDate <> 0D then begin
                VehicleServicePlanStage.Validate("Service Date", ServDate);
                VehicleServicePlanStage.Validate(Status, VehicleServicePlanStage.Status::"In Process");
                VehicleServicePlanStage.Modify;
            end;
        end;
    end;


    procedure PlanRecurringByTemplate(var VehServicePlan: Record "Vehicle Service Plan"; MinCountOfPending: Integer): Integer
    var
        ServicePlanTemplate: Record "Service Plan Template";
        ServicePlanTemplateStage: Record "Service Plan Template Stage";
        VehServicePlan1: Record "Vehicle Service Plan";
        VehServicePlanStage: Record "Vehicle Service Plan Stage";
        ServDate: Date;
        Run1: Decimal;
        Run2: Decimal;
        Run3: Decimal;
        InitRun1: Decimal;
        InitRun2: Decimal;
        InitRun3: Decimal;
        CurrRecurrence: Integer;
    begin
        if not VehServicePlan.Recurring then //22.04.2016 EB.P7 #T051
            exit;                              //22.04.2016 EB.P7 #T051

        //NEED to be sure that plan has finished
        VehServicePlanStage.Reset;
        VehServicePlanStage.SetRange("Vehicle Serial No.", VehServicePlan."Vehicle Serial No.");
        VehServicePlanStage.SetRange("Plan No.", VehServicePlan."No.");
        VehServicePlanStage.SetRange(Status, VehServicePlanStage.Status::Pending);
        if VehServicePlanStage.Count > MinCountOfPending then
            exit(1);

        //plan should had template assigned
        ServicePlanTemplate.Reset;
        if not ServicePlanTemplate.Get(VehServicePlan."Template Code") then
            exit(2);

        //find last finished stage
        VehServicePlanStage.SetRange(Status);
        if not VehServicePlanStage.FindLast then
            exit(3);

        Run1 := VehServicePlanStage."Variable Field Run 1";
        Run2 := VehServicePlanStage."Variable Field Run 2";
        Run3 := VehServicePlanStage."Variable Field Run 3";
        InitRun1 := VehServicePlanStage."VF Initial Run 1";
        InitRun2 := VehServicePlanStage."VF Initial Run 2";
        InitRun3 := VehServicePlanStage."VF Initial Run 3";
        CurrRecurrence := VehServicePlanStage.Recurrence + 1;

        //
        ServicePlanTemplateStage.Reset;
        VehServicePlanStage.Reset;
        ServicePlanTemplateStage.SetRange("Template Code", ServicePlanTemplate.Code);
        if ServicePlanTemplateStage.FindFirst then
            repeat
                VehServicePlanStage.Init;
                VehServicePlanStage."Vehicle Serial No." := VehServicePlan."Vehicle Serial No.";
                VehServicePlanStage."Plan No." := VehServicePlan."No.";
                VehServicePlanStage.Recurrence := CurrRecurrence;
                VehServicePlanStage.Code := ServicePlanTemplateStage.Code;
                VehServicePlanStage.Description := ServicePlanTemplateStage.Description;
                VehServicePlanStage."Service Interval" := ServicePlanTemplateStage."Service Interval";
                VehServicePlanStage."Package No." := ServicePlanTemplateStage."Package No.";
                //08.05.2013 EDMS P8 >>
                if ServicePlanTemplateStage."Variable Field Run 1" > 0 then begin
                    VehServicePlanStage."VF Initial Run 1" := ServicePlanTemplateStage."Variable Field Run 1" + InitRun1;
                    if VehServicePlan.Adjust then
                        VehServicePlanStage."Variable Field Run 1" := ServicePlanTemplateStage."Variable Field Run 1" + Run1
                    else
                        VehServicePlanStage."Variable Field Run 1" := VehServicePlanStage."VF Initial Run 1";
                end;
                if ServicePlanTemplateStage."Variable Field Run 2" > 0 then begin
                    VehServicePlanStage."VF Initial Run 2" := ServicePlanTemplateStage."Variable Field Run 2" + InitRun2;
                    if VehServicePlan.Adjust then
                        VehServicePlanStage."Variable Field Run 2" := ServicePlanTemplateStage."Variable Field Run 2" + Run2
                    else
                        VehServicePlanStage."Variable Field Run 2" := VehServicePlanStage."VF Initial Run 2";
                end;
                if ServicePlanTemplateStage."Variable Field Run 3" > 0 then begin
                    VehServicePlanStage."Variable Field Run 3" := ServicePlanTemplateStage."Variable Field Run 3" + Run3;
                    VehServicePlanStage."VF Initial Run 3" := ServicePlanTemplateStage."Variable Field Run 3" + InitRun3;
                    if VehServicePlan.Adjust then
                        VehServicePlanStage."Variable Field Run 3" := ServicePlanTemplateStage."Variable Field Run 3" + Run3
                    else
                        VehServicePlanStage."Variable Field Run 3" := VehServicePlanStage."VF Initial Run 3";
                end;
                //08.05.2013 EDMS P8 <<
                VehServicePlanStage."Expected Service Date" := 0D;
                VehServicePlanStage.Insert;
            until ServicePlanTemplateStage.Next = 0;

        //need to adjust VehServicePlanStage."Expected Service Date"
        exit(0);
    end;


    procedure SetVehicle(var VehiclePar: Record Vehicle)
    begin
        Vehicle := VehiclePar;
        //Vehicle.COPYFILTERS(VehiclePar);
    end;


    procedure SetVehicleServicePlanStage(var VehicleServicePlanStagePar: Record "Vehicle Service Plan Stage")
    begin
        VehicleServicePlanStage := VehicleServicePlanStagePar;
    end;


    procedure SetSPVersion(var SPVersionPar: Record "Service Package Version")
    begin
        SPVersion := SPVersionPar;
        SPVersion.CopyFilters(SPVersionPar)
    end;


    procedure SetCustomer(var CustomerPar: Record Customer)
    begin
        Customer := CustomerPar;
    end;


    procedure GetVehicleCustomer(VehSerNo: Code[20]) RetValue: Code[20]
    var
        Vehicle: Record Vehicle;
        CustomerCount: Integer;
        Contact: Record Contact;
        VehicleContact: Record "Vehicle Contact";
        ContBusRelation: Record "Contact Business Relation";
        Customer: Record Customer;
        ServiceHeader: Record "Service Header EDMS";
    begin
        if VehSerNo = '' then
            exit('');
        ServiceSetup.Get;

        Contact.Reset;
        Customer.Reset;

        MarkVehicleContacts(Contact, VehSerNo, ServiceSetup."Serv. Plan Cont. Relationship");
        Contact.MarkedOnly(true);
        if Contact.FindFirst then begin
            repeat
                ContBusRelation.SetRange("Contact No.", Contact."No.");
                if ContBusRelation.FindFirst then
                    repeat
                        if Customer.Get(ContBusRelation."No.") then
                            Customer.Mark(true);
                    until ContBusRelation.Next = 0;
            until Contact.Next = 0;
        end;
        Customer.MarkedOnly(true);

        if Customer.FindFirst then
            RetValue := Customer."No.";

        exit(RetValue);
    end;


    procedure MarkVehicleContacts(var Contact: Record Contact; VehSerialNo: Code[20]; RelationshipCode: Code[20])
    var
        VehicleContact: Record "Vehicle Contact";
    begin
        VehicleContact.Reset;
        VehicleContact.SetCurrentkey("Vehicle Serial No.");
        VehicleContact.SetRange("Vehicle Serial No.", VehSerialNo);
        if RelationshipCode <> '' then
            VehicleContact.SetRange("Relationship Code", RelationshipCode);
        if VehicleContact.FindFirst then
            repeat
                if Contact.Get(VehicleContact."Contact No.") then
                    Contact.Mark := true;
            until VehicleContact.Next = 0;
    end;


    procedure PostServPlanStage(VehSerNo: Code[20]; PlanNo: Code[20]; Recurrence: Integer; PlanStageCode: Code[20]; ServLedgEntry: Record "Service Ledger Entry EDMS")
    var
        ServicePlanManagement: Codeunit "Service Plan Management";
        StageLoc: Record "Vehicle Service Plan Stage";
    begin
        //StageLoc.RESET;
        if StageLoc.Get(VehSerNo, PlanNo, Recurrence, PlanStageCode) then begin
            StageLoc.Validate(Status, StageLoc.Status::Serviced);
            StageLoc.Validate("Service Date", ServicePlanManagement.GetServDateFromSLE(ServLedgEntry));
            StageLoc."Variable Field Run 1" := ServLedgEntry."Variable Field Run 1";
            StageLoc."Variable Field Run 2" := ServLedgEntry."Variable Field Run 2";
            StageLoc."Variable Field Run 3" := ServLedgEntry."Variable Field Run 3";
            StageLoc.Modify(true);
            StageLoc.Reset;
            StageLoc.SetRange("Vehicle Serial No.", VehSerNo);
            StageLoc.SetRange("Plan No.", PlanNo);
            StageLoc.SetRange(Recurrence, StageLoc.Recurrence);
            StageLoc.SetFilter(Code, '<=%1', PlanStageCode);
            StageLoc.SetRange(Status, StageLoc.Status::Pending);
            StageLoc.ModifyAll(Status, StageLoc.Status::Skipped, true);
        end;
    end;


    procedure CreateServPlansDueToSaledLine(SalesLine: Record "Sales Line")
    var
        SalesSetup: Record "Sales & Receivables Setup";
        ServicePlanTemplateUsage: Record "Service Plan Template Usage";
        VehicleLoc: Record Vehicle;
        VehicleServicePlanLoc: Record "Vehicle Service Plan";
        ServicePlanTemplateLoc: Record "Service Plan Template";
        SalesHeaderLoc: Record "Sales Header";
    begin
        SalesSetup.Get;
        if not SalesSetup."Vehicle Service Plan on Sales" then
            exit;
        if not VehicleLoc.Get(SalesLine."Vehicle Serial No.") then
            exit;
        ServicePlanTemplateUsage.SetFilter("Make Code", '%1|%2', '', VehicleLoc."Make Code");
        ServicePlanTemplateUsage.SetFilter("Model Code", '%1|%2', '', VehicleLoc."Model Code");
        ServicePlanTemplateUsage.SetFilter("Model Version No.", '%1|%2', '', VehicleLoc."Model Version No.");
        ServicePlanTemplateUsage.SetFilter("Vehicle Status", '%1|%2', '', SalesLine."Vehicle Status Code");
        if ServicePlanTemplateUsage.FindFirst then
            repeat
                VehicleServicePlanLoc.Reset;
                VehicleServicePlanLoc.SetRange("Vehicle Serial No.", VehicleLoc."Serial No.");
                VehicleServicePlanLoc.Init;
                VehicleServicePlanLoc."Vehicle Serial No." := VehicleLoc."Serial No.";
                if ServicePlanTemplateLoc.Get(ServicePlanTemplateUsage."Template Code") then begin
                    ApplyTemplateToPlan(ServicePlanTemplateLoc, VehicleServicePlanLoc);
                    if SalesHeaderLoc.Get(SalesLine."Document Type", SalesLine."Document No.") then begin
                        if SalesSetup."Vehicle Sale Register on" = SalesSetup."Vehicle Sale Register on"::Invoice then
                            VehicleServicePlanLoc.Validate("Start Date", SalesHeaderLoc."Document Date");
                        if SalesSetup."Vehicle Sale Register on" = SalesSetup."Vehicle Sale Register on"::Shipment then
                            VehicleServicePlanLoc.Validate("Start Date", SalesHeaderLoc."Shipment Date");
                        VehicleServicePlanLoc.Modify(true);
                    end;
                end;
            until ServicePlanTemplateUsage.Next = 0;
    end;


    procedure "//--Common Use--"()
    begin
    end;


    procedure GetLastServLEntryDate(VehicleSerialNo: Code[20]; PlanNo: Code[10]; var ServVFRun1: Decimal; var ServVFRun2: Decimal; var ServVFRun3: Decimal): Date
    var
        ServLedgerEntry: Record "Service Ledger Entry EDMS";
        FillerStr: Text[30];
    begin
        // the main difference from GetServiceDate is that here not only documents...
        ServLedgerEntry.Reset;
        ServLedgerEntry.SetCurrentkey("Vehicle Serial No.", "Posting Date", "Entry Type");
        ServLedgerEntry.SetRange("Vehicle Serial No.", VehicleSerialNo);
        FillerStr := StrSubstNo('%1|%2', ServLedgerEntry."entry type"::Usage, ServLedgerEntry."entry type"::Info);
        ServLedgerEntry.SetFilter("Entry Type", FillerStr);
        if ServLedgerEntry.FindLast then begin
            ServVFRun1 := ServLedgerEntry."Variable Field Run 1";
            ServVFRun2 := ServLedgerEntry."Variable Field Run 2";
            ServVFRun3 := ServLedgerEntry."Variable Field Run 3";
            exit(GetServDateFromSLE(ServLedgerEntry));
        end else begin
            exit(0D);
        end;
    end;


    procedure GetServiceDate(VehSerNo: Code[20]; ServPlanNo: Code[10]; PlanStageRecurrence: Integer; ServPlanStageCode: Code[10]): Date
    var
        ServicePlanDocumentLink: Record "Service Plan Document Link";
        PostedServiceHeader: Record "Posted Serv. Order Header";
    begin
        ServicePlanDocumentLink.Reset;
        ServicePlanDocumentLink.SetRange("Vehicle Serial No.", VehSerNo);
        ServicePlanDocumentLink.SetRange("Serv. Plan No.", ServPlanNo);
        ServicePlanDocumentLink.SetRange("Plan Stage Recurrence", PlanStageRecurrence);
        ServicePlanDocumentLink.SetRange("Serv. Plan Stage Code", ServPlanStageCode);
        ServicePlanDocumentLink.SetRange("Document Type", ServicePlanDocumentLink."document type"::"Posted Order");
        if ServicePlanDocumentLink.FindLast then
            if PostedServiceHeader.Get(ServicePlanDocumentLink."Document No.") then
                exit(GetServDateFromPostedOrder(PostedServiceHeader));
        exit(0D);
    end;


    procedure GetDateOfStage(VehicleServicePlanStagePar: Record "Vehicle Service Plan Stage"; AdjustInfluence: Boolean): Date
    begin
        VehicleServicePlan.Get(VehicleServicePlanStagePar."Vehicle Serial No.", VehicleServicePlanStagePar."Plan No.");
        if AdjustInfluence then begin
            if not VehicleServicePlan.Adjust then
                exit(VehicleServicePlanStagePar."Expected Service Date")
            else
                if VehicleServicePlanStagePar."Service Date" > 0D then
                    exit(VehicleServicePlanStagePar."Service Date")
                else
                    exit(VehicleServicePlanStagePar."Expected Service Date");
        end else
            if VehicleServicePlanStagePar."Expected Service Date" > 0D then
                exit(VehicleServicePlanStagePar."Expected Service Date")
            else
                exit(VehicleServicePlanStagePar."Service Date");
    end;


    procedure GetDateOfPrevStage(VehicleServicePlanStagePar: Record "Vehicle Service Plan Stage"; AdjustInfluence: Boolean): Date
    var
        VehicleServicePlanStageLoc: Record "Vehicle Service Plan Stage";
    begin
        VehicleServicePlan.Get(VehicleServicePlanStagePar."Vehicle Serial No.", VehicleServicePlanStagePar."Plan No.");
        VehicleServicePlanStageLoc.Reset;
        VehicleServicePlanStageLoc.Ascending(false);
        VehicleServicePlanStageLoc.SetRange("Vehicle Serial No.", VehicleServicePlanStagePar."Vehicle Serial No.");
        VehicleServicePlanStageLoc.SetRange("Plan No.", VehicleServicePlanStagePar."Plan No.");
        VehicleServicePlanStageLoc.SetRange(Recurrence, VehicleServicePlanStagePar.Recurrence);
        VehicleServicePlanStageLoc.SetRange(Code, VehicleServicePlanStagePar.Code);
        VehicleServicePlanStageLoc.FindFirst;
        VehicleServicePlanStageLoc.SetRange(Recurrence);
        VehicleServicePlanStageLoc.SetRange(Code);
        if VehicleServicePlanStageLoc.Next <> 0 then
            exit(GetDateOfStage(VehicleServicePlanStageLoc, AdjustInfluence))
        else
            exit(0D);
    end;


    procedure GetServDateFromPostedOrder(PostedServiceHeader: Record "Posted Serv. Order Header"): Date
    begin
        exit(PostedServiceHeader."Document Date");
    end;


    procedure GetServDateFromSLE(ServLedgerEntry: Record "Service Ledger Entry EDMS"): Date
    begin
        exit(ServLedgerEntry."Document Date");
    end;


    procedure GetServDateFromServHeader(ServiceHeaderPar: Record "Service Header EDMS"): Date
    begin
        exit(ServiceHeaderPar."Document Date");
    end;


    procedure GetServDateFromPstRetOrder(PstRetServHeader: Record "Posted Serv. Ret. Order Header"): Date
    begin
        exit(PstRetServHeader."Document Date");
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


    procedure AdjustFlagsToArray(Flags: Integer; var Arr: array[16] of Boolean)
    var
        i: Integer;
    begin
        for i := 1 to 16 do begin
            Arr[i] := CutNextBit(Flags);
        end;
    end;


    procedure "//--Calc Expected Date--------"()
    begin
    end;


    procedure CalcExpectedServiceDate(VehSerialNo: Code[20]; PlanNo: Code[10]; RunModeFlags: Integer): Integer
    var
        FlagsArray: array[16] of Boolean;
        Stage: Record "Vehicle Service Plan Stage";
        StageAvgTmp: Record "Vehicle Service Plan Stage" temporary;
        NewExpDate: Date;
        NewExpDate1: Date;
        NewExpDate2: Date;
        NewExpDate3: Date;
        NewExpDateByInterval: Date;
        LastServDate: Date;
        ServicePlanDocumentLink: Record "Service Plan Document Link";
        ServiceHeader: Record "Service Header EDMS";
        AdjustFlagInfluence: Boolean;
        StageRecurrence: Integer;
        StageCodeToBegin: Code[10];
    begin
        AdjustFlagsToArray(RunModeFlags, FlagsArray);
        AdjustFlagInfluence := FlagsArray[1];
        if not VehicleServicePlan.Get(VehSerialNo, PlanNo) then
            exit(1);
        xVehicleServicePlanTmp := VehicleServicePlan;
        AddLogEntryForCalcESDofPlan(VehicleServicePlan, xVehicleServicePlanTmp, StrSubstNo(TextLog001, VehSerialNo, PlanNo), 0, 0);
        AddLogEntryForCalcESDofPlan(VehicleServicePlan, xVehicleServicePlanTmp, StrSubstNo(TextLog002,
          'AdjustFlagInfluence', AdjustFlagInfluence,
          VehicleServicePlan.FieldCaption(Adjust), VehicleServicePlan.Adjust,
          VehicleServicePlan.FieldCaption("Creation Date"), VehicleServicePlan."Creation Date",
          VehicleServicePlan.FieldCaption("Start Date"), VehicleServicePlan."Start Date"),
          0, 0);

        Clear(StageLastTmp);
        StageLastTmp.DeleteAll;
        StageLastTmp."Vehicle Serial No." := VehSerialNo;
        StageLastTmp."Plan No." := PlanNo;
        Clear(StageAvgTmp);
        StageAvgTmp.DeleteAll;
        StageAvgTmp."Vehicle Serial No." := VehSerialNo;
        StageAvgTmp."Plan No." := PlanNo;

        if ((VehicleServicePlan."Creation Date" = 0D) or
          (VehicleServicePlan."Start Date" = 0D)) then begin
            if VehicleServicePlan."Creation Date" = 0D then begin
                VehicleServicePlan."Creation Date" := WorkDate;  // just to be filled
                AddLogEntryForCalcESDofPlan(VehicleServicePlan, xVehicleServicePlanTmp,
                  StrSubstNo(TextLogUpdateField, VehicleServicePlan.TableCaption, VehicleServicePlan.FieldCaption("Creation Date"),
                  VehicleServicePlan."Creation Date"), VehicleServicePlan.FieldNo("Creation Date"), 0);
            end;

            if VehicleServicePlan."Start Date" = 0D then begin
                VehicleServicePlan."Start Date" := GetVehicleSellDate(VehSerialNo);
                AddLogEntryForCalcESDofPlan(VehicleServicePlan, xVehicleServicePlanTmp,
                  StrSubstNo(TextLogUpdateField, VehicleServicePlan.TableCaption, VehicleServicePlan.FieldCaption("Start Date"),
                  VehicleServicePlan."Start Date"), VehicleServicePlan.FieldNo("Start Date"), 0);
            end;
            VehicleServicePlan.Modify(true);
        end;
        if VehicleServicePlan."Start Date" = 0D then begin
            AddLogEntryForCalcESDofPlan(VehicleServicePlan, xVehicleServicePlanTmp, StrSubstNo(TextLogInterrupt, VehSerialNo, PlanNo,
              VehicleServicePlan.FieldCaption("Start Date")), 0, 0);
            exit(1);
        end;
        Stage.Reset;
        Stage.SetRange("Vehicle Serial No.", VehSerialNo);
        Stage.SetRange("Plan No.", PlanNo);
        // find last finished stage
        Stage.SetFilter(Status, '%1|%2', Stage.Status::"In Process", Stage.Status::Serviced);
        if Stage.FindFirst then begin
            StageRecurrence := Stage.Recurrence;
            StageCodeToBegin := Stage.Code;
            // that filter is set for meaning: not to proceed stages before Serviced (in the past)
            //Stage.SETRANGE(Recurrence, StageRecurrence);
            Stage.SetFilter(Code, '>=%1', StageCodeToBegin);
        end;
        Stage.SetRange(Status);
        Stage.SetRange(Code);
        AddLogEntryForCalcESDofStage(Stage, Stage,
          CopyStr(StrSubstNo(TextTableFilter, Stage.TableCaption, Stage.GetFilters), 1, 250), 0, 0);

        //Stage.SETRANGE(Stage.Status,Stage.Status::Pending);
        if Stage.FindFirst then
            repeat
                xVehicleServicePlanStageTmp := Stage;
                if Stage.Status in [Stage.Status::Serviced, Stage.Status::"In Process", Stage.Status::Skipped] then begin
                    if (Stage."Service Date" = 0D) and not (Stage.Status = Stage.Status::Skipped) then begin
                        Stage."Service Date" := GetServiceDate(VehSerialNo, PlanNo, Stage.Recurrence, Stage.Code);
                        AddLogEntryForCalcESDofStage(Stage, xVehicleServicePlanStageTmp,
                          StrSubstNo(TextLogUpdateField, Stage.TableCaption, Stage.FieldCaption("Service Date"),
                          Stage."Service Date"), Stage.FieldNo("Service Date"), 0);
                    end;
                end else begin
                    if (not AdjustFlagInfluence) or (AdjustFlagInfluence and (Stage."Expected Service Date" = 0D)) or
                        (AdjustFlagInfluence and VehicleServicePlan.Adjust) then begin
                        NewExpDateByInterval := GetExpectedDateByInterval(Stage);
                        AddLogEntryForCalcESDofStage(Stage, xVehicleServicePlanStageTmp,
                          StrSubstNo(TextLogCalcByInterval, Format(NewExpDateByInterval)),
                          0, 0);
                        StageLastFillByLastSLE;  //02.04.2013 EDMS P8
                        AddLogEntryForCalcESDofStage(Stage, xVehicleServicePlanStageTmp,
                          StrSubstNo(TextLogLastSLEValues, StageLastTmp."Service Date", StageLastTmp."Variable Field Run 1",
                            StageLastTmp."Variable Field Run 2", StageLastTmp."Variable Field Run 3"),
                          0, 0);
                        NewExpDate := NewExpDateByInterval;
                        NewExpDate1 := 0D;
                        NewExpDate2 := 0D;
                        NewExpDate3 := 0D;
                        if (Stage."VF Initial Run 1" > 0) or (Stage."VF Initial Run 2" > 0) or (Stage."VF Initial Run 3" > 0) then begin
                            //ExpectedPerDay
                            CalcStageAvgPerDay(StageAvgTmp);
                            AddLogEntryForCalcESDofStage(Stage, xVehicleServicePlanStageTmp,
                              StrSubstNo(TextLogAvgValues, StageAvgTmp."Service Date", StageAvgTmp."Variable Field Run 1",
                              StageAvgTmp."Variable Field Run 2", StageAvgTmp."Variable Field Run 3"),
                              0, 0);

                            if not ((StageAvgTmp."Variable Field Run 1" = 0) and (StageAvgTmp."Variable Field Run 2" = 0) and
                                (StageAvgTmp."Variable Field Run 3" = 0)) then begin
                                LastServDate := StageLastTmp."Service Date";
                                if StageAvgTmp."Variable Field Run 1" > 0 then begin
                                    NewExpDate1 := LastServDate +
                                      ROUND((Stage."Variable Field Run 1" - StageLastTmp."Variable Field Run 1") /
                                        StageAvgTmp."Variable Field Run 1", 1);
                                    AddLogEntryForCalcESDofStage(Stage, xVehicleServicePlanStageTmp,
                                      StrSubstNo(TextLogCalcValue, 'NewExpDate1', NewExpDate1),
                                      0, 0);
                                end;
                                if StageAvgTmp."Variable Field Run 2" > 0 then begin
                                    NewExpDate2 := LastServDate +
                                      ROUND((Stage."Variable Field Run 2" - StageLastTmp."Variable Field Run 2") /
                                        StageAvgTmp."Variable Field Run 2", 1);
                                    AddLogEntryForCalcESDofStage(Stage, xVehicleServicePlanStageTmp,
                                      StrSubstNo(TextLogCalcValue, 'NewExpDate2', NewExpDate2),
                                      0, 0);
                                end;
                                if StageAvgTmp."Variable Field Run 3" > 0 then begin
                                    NewExpDate3 := LastServDate +
                                      ROUND((Stage."Variable Field Run 3" - StageLastTmp."Variable Field Run 3") /
                                        StageAvgTmp."Variable Field Run 3", 1);
                                    AddLogEntryForCalcESDofStage(Stage, xVehicleServicePlanStageTmp,
                                      StrSubstNo(TextLogCalcValue, 'NewExpDate3', NewExpDate3),
                                      0, 0);
                                end;

                                NewExpDate := NewExpDateByInterval;
                                if ((NewExpDate1 < NewExpDate) and (NewExpDate1 > LastServDate)) or (NewExpDate = 0D) then
                                    NewExpDate := NewExpDate1;
                                if ((NewExpDate2 < NewExpDate) and (NewExpDate2 > LastServDate)) or (NewExpDate = 0D) then
                                    NewExpDate := NewExpDate2;
                                if ((NewExpDate3 < NewExpDate) and (NewExpDate3 > LastServDate)) or (NewExpDate = 0D) then
                                    NewExpDate := NewExpDate3;
                            end;
                        end;
                        Stage."Expected Service Date" := NewExpDate;
                        AddLogEntryForCalcESDofStage(Stage, xVehicleServicePlanStageTmp,
                          StrSubstNo(TextLogUpdateField, Stage.TableName, Stage.FieldCaption("Expected Service Date"),
                          Stage."Expected Service Date"),
                          Stage.FieldNo("Expected Service Date"), 0);
                    end;
                end;
                AssignStageLast(GetDateOfStage(Stage, AdjustFlagInfluence), Stage."Variable Field Run 1",
                  Stage."Variable Field Run 2", Stage."Variable Field Run 3");
                Stage.Modify;

            until Stage.Next = 0;
        AddLogEntryForCalcESDofPlan(VehicleServicePlan, VehicleServicePlan, StrSubstNo(TextLogEnd, VehSerialNo, PlanNo), 0, 0);
    end;


    procedure CalcStageAvgPerDay(var StageAvg: Record "Vehicle Service Plan Stage" temporary)
    var
        ServLedgerEntry: Record "Service Ledger Entry EDMS";
        StageAvgByPlanTmp: Record "Vehicle Service Plan Stage" temporary;
        MinRun: Decimal;
        MinRun2: Decimal;
        MinRun3: Decimal;
        MaxRun: Decimal;
        MaxRun2: Decimal;
        MaxRun3: Decimal;
        MinDate: Date;
        MaxDate: Date;
    begin
        ServLedgerEntry.Reset;
        ServLedgerEntry.SetCurrentkey("Vehicle Serial No.", "Posting Date", "Entry Type");
        //ServLedgerEntry.SETCURRENTKEY("Vehicle Serial No.","Entry Type","Variable Field Run 1");
        ServLedgerEntry.SetRange("Vehicle Serial No.", StageAvg."Vehicle Serial No.");
        ServLedgerEntry.SetFilter("Entry Type", '%1|%2', ServLedgerEntry."entry type"::Usage, ServLedgerEntry."entry type"::Info);
        if ServLedgerEntry.Count > 1 then begin
            //Getting min values
            if ServLedgerEntry.FindFirst then begin
                MinRun := ServLedgerEntry."Variable Field Run 1";
                MinRun2 := ServLedgerEntry."Variable Field Run 2";
                MinRun3 := ServLedgerEntry."Variable Field Run 3";
                MinDate := ServLedgerEntry."Posting Date";
            end;
            //Getting max values
            if ServLedgerEntry.FindLast then begin
                MaxRun := ServLedgerEntry."Variable Field Run 1";
                MaxRun2 := ServLedgerEntry."Variable Field Run 2";
                MaxRun3 := ServLedgerEntry."Variable Field Run 3";
                MaxDate := ServLedgerEntry."Posting Date";
            end;
            if MaxDate <= MinDate then begin
                MaxDate := MinDate;
                MinDate := 0D;
                if MaxRun <= MinRun then
                    MaxRun := MinRun;
                MinRun := 0;
                if MaxRun2 <= MinRun2 then
                    MaxRun2 := MinRun2;
                MinRun2 := 0;
                if MaxRun3 <= MinRun3 then
                    MaxRun3 := MinRun3;
                MinRun3 := 0;
            end;
        end else
            if ServLedgerEntry.Count = 1 then begin
                if ServLedgerEntry.FindLast then begin
                    MaxRun := ServLedgerEntry."Variable Field Run 1";
                    MaxRun2 := ServLedgerEntry."Variable Field Run 2";
                    MaxRun3 := ServLedgerEntry."Variable Field Run 3";
                    MaxDate := ServLedgerEntry."Posting Date";
                end;
            end;

        if (MinDate = 0D) then begin
            MinDate := VehicleServicePlan."Start Date";
            MinRun := GetStartRun1;
            MinRun2 := GetStartRun2;
            MinRun3 := GetStartRun3;
        end;
        if (MaxDate = 0D) then begin
            MaxDate := MinDate;
            MaxRun := MinRun;
            MaxRun2 := MinRun2;
            MaxRun3 := MinRun3;
        end;
        StageAvgByPlanTmp.DeleteAll;
        StageAvgByPlanTmp.TransferFields(StageAvg);
        CalcStageAvgByPlan(StageAvgByPlanTmp);
        if (MaxRun - MinRun <= 0) or (MaxDate - MinDate <= 0) then begin
            StageAvg."Variable Field Run 1" := StageAvgByPlanTmp."Variable Field Run 1";
            AddLogEntryForCalcESDofStage(StageAvg, StageAvg,
              StrSubstNo(TextLogAvgValueOfPlan,
              StageAvg.FieldCaption("Variable Field Run 1"),
              StageAvg."Variable Field Run 1"),
              0, 0);
        end else begin
            StageAvg."Variable Field Run 1" := (MaxRun - MinRun) / (MaxDate - MinDate);
            AddLogEntryForCalcESDofStage(StageAvg, StageAvg,
              StrSubstNo(TextLogAvgCalcPars, MaxRun, MinRun, MaxDate, MinDate,
              StageAvg.FieldCaption("Variable Field Run 1")),
              0, 0);
        end;
        if (MaxRun2 - MinRun2 <= 0) or (MaxDate - MinDate <= 0) then begin
            StageAvg."Variable Field Run 2" := StageAvgByPlanTmp."Variable Field Run 2";
            AddLogEntryForCalcESDofStage(StageAvg, StageAvg,
              StrSubstNo(TextLogAvgValueOfPlan,
              StageAvg.FieldCaption("Variable Field Run 2"),
              StageAvg."Variable Field Run 2"),
              0, 0);
        end else begin
            StageAvg."Variable Field Run 2" := (MaxRun2 - MinRun2) / (MaxDate - MinDate);
            AddLogEntryForCalcESDofStage(StageAvg, StageAvg,
              StrSubstNo(TextLogAvgCalcPars, MaxRun2, MinRun2, MaxDate, MinDate,
              StageAvg.FieldCaption("Variable Field Run 2")),
              0, 0);
        end;
        if (MaxRun3 - MinRun3 <= 0) or (MaxDate - MinDate <= 0) then begin
            StageAvg."Variable Field Run 3" := StageAvgByPlanTmp."Variable Field Run 3";
            AddLogEntryForCalcESDofStage(StageAvg, StageAvg,
              StrSubstNo(TextLogAvgValueOfPlan,
              StageAvg.FieldCaption("Variable Field Run 3"),
              StageAvg."Variable Field Run 3"),
              0, 0);
        end else begin
            StageAvg."Variable Field Run 3" := (MaxRun3 - MinRun3) / (MaxDate - MinDate);
            AddLogEntryForCalcESDofStage(StageAvg, StageAvg,
              StrSubstNo(TextLogAvgCalcPars, MaxRun3, MinRun3, MaxDate, MinDate,
              StageAvg.FieldCaption("Variable Field Run 3")),
              0, 0);
        end;
    end;


    procedure CalcStageAvgByPlan(StageAvg: Record "Vehicle Service Plan Stage")
    var
        Stage: Record "Vehicle Service Plan Stage";
        MinRun: Decimal;
        MinRun2: Decimal;
        MinRun3: Decimal;
        MaxRun: Decimal;
        MaxRun2: Decimal;
        MaxRun3: Decimal;
        MinDate: Date;
        MaxDate: Date;
    begin
        Stage.Reset;
        Stage.SetRange("Vehicle Serial No.", StageAvg."Vehicle Serial No.");
        Stage.SetRange("Plan No.", StageAvg."Plan No.");
        Stage.SetFilter(Status, '%1|%2', Stage.Status::Serviced, Stage.Status::"In Process");
        if Stage.Count > 1 then begin
            //Getting min values
            if Stage.FindFirst then begin
                MinRun := Stage."Variable Field Run 1";
                MinRun2 := Stage."Variable Field Run 2";
                MinRun3 := Stage."Variable Field Run 3";
                MinDate := Stage."Service Date";
            end;
            //Getting max values
            if Stage.FindLast then begin
                MaxRun := Stage."Variable Field Run 1";
                MaxRun2 := Stage."Variable Field Run 2";
                MaxRun3 := Stage."Variable Field Run 3";
                MaxDate := Stage."Service Date";
            end;
            if MaxDate <= MinDate then begin
                MaxDate := MinDate;
                MinDate := 0D;
                if MaxRun <= MinRun then
                    MaxRun := MinRun;
                MinRun := 0;
                if MaxRun2 <= MinRun2 then
                    MaxRun2 := MinRun2;
                MinRun2 := 0;
                if MaxRun3 <= MinRun3 then
                    MaxRun3 := MinRun3;
                MinRun3 := 0;
            end;
        end else
            if Stage.Count = 1 then begin
                if Stage.FindLast then begin
                    MaxRun := Stage."Variable Field Run 1";
                    MaxRun2 := Stage."Variable Field Run 2";
                    MaxRun3 := Stage."Variable Field Run 3";
                    MaxDate := Stage."Service Date";
                end;
            end;
        if (MinDate = 0D) then begin
            MinDate := VehicleServicePlan."Start Date";
            MinRun := GetStartRun1;
            MinRun2 := GetStartRun2;
            MinRun3 := GetStartRun3;
        end;
        if (MaxDate = 0D) then begin
            MaxDate := MinDate;
            MaxRun := MinRun;
            MaxRun2 := MinRun2;
            MaxRun3 := MinRun3;
        end;
        if MaxDate - MinDate <= 0 then begin
            StageAvg."Variable Field Run 1" := 0;
            StageAvg."Variable Field Run 2" := 0;
            StageAvg."Variable Field Run 3" := 0;
        end;

        if (MaxRun - MinRun <= 0) or (MaxDate - MinDate <= 0) then
            StageAvg."Variable Field Run 1" := 0
        else
            StageAvg."Variable Field Run 1" := (MaxRun - MinRun) / (MaxDate - MinDate);
        if (MaxRun2 - MinRun2 <= 0) or (MaxDate - MinDate <= 0) then
            StageAvg."Variable Field Run 2" := 0
        else
            StageAvg."Variable Field Run 2" := (MaxRun2 - MinRun2) / (MaxDate - MinDate);
        if (MaxRun3 - MinRun3 <= 0) or (MaxDate - MinDate <= 0) then
            StageAvg."Variable Field Run 3" := 0
        else
            StageAvg."Variable Field Run 3" := (MaxRun3 - MinRun3) / (MaxDate - MinDate);

        AddLogEntryForCalcESDofStage(StageAvg, StageAvg,
  StrSubstNo(TextLogAvgCalcPlanPars, MaxRun, MinRun, MaxDate, MinDate,
  StageAvg.FieldCaption("Variable Field Run 1")),
  0, 0);
        AddLogEntryForCalcESDofStage(StageAvg, StageAvg,
          StrSubstNo(TextLogAvgCalcPlanPars, MaxRun2, MinRun2, MaxDate, MinDate,
          StageAvg.FieldCaption("Variable Field Run 2")),
          0, 0);
        AddLogEntryForCalcESDofStage(StageAvg, StageAvg,
          StrSubstNo(TextLogAvgCalcPlanPars, MaxRun3, MinRun3, MaxDate, MinDate,
          StageAvg.FieldCaption("Variable Field Run 3")),
          0, 0);
        AddLogEntryForCalcESDofStage(StageAvg, StageAvg,
          StrSubstNo(TextLogAvgValuesPlan, StageAvg."Service Date", StageAvg."Variable Field Run 1",
          StageAvg."Variable Field Run 2", StageAvg."Variable Field Run 3"),
          0, 0);
    end;


    procedure GetExpectedDateByInterval(VehicleServicePlanStage: Record "Vehicle Service Plan Stage"): Date
    var
        ServLedgerEntry: Record "Service Ledger Entry EDMS";
        MinRun: Integer;
        MaxRun: Integer;
        MinDate: Date;
        MaxDate: Date;
        VFRun1: Decimal;
        VFRun2: Decimal;
        VFRun3: Decimal;
        ServiceIntervalFormat: Text[30];
    begin
        ServiceIntervalFormat := Format(VehicleServicePlanStage."Service Interval");
        InitialiseStageLast;
        if (ServiceIntervalFormat = ' ') or (ServiceIntervalFormat = '') then
            exit(0D);
        MinDate := StageLastTmp."Service Date";
        exit(CalcDate(VehicleServicePlanStage."Service Interval", MinDate));
    end;


    procedure GetExpectedDateByIntervalGlob(VehicleSerialNo: Code[20]; PlanNo: Code[10]; VehicleServicePlanStage: Record "Vehicle Service Plan Stage") RetDate: Date
    var
        ServLedgerEntry: Record "Service Ledger Entry EDMS";
        MinRun: Integer;
        MaxRun: Integer;
        MinDate: Date;
        MaxDate: Date;
        VFRun1: Decimal;
        VFRun2: Decimal;
        VFRun3: Decimal;
        ServiceIntervalFormat: Text[30];
    begin
        VehicleServicePlan.Get(VehicleSerialNo, PlanNo);
        if ((VehicleServicePlanStage."Expected Service Date" > 0D) and (not VehicleServicePlan.Adjust)) then begin
            RetDate := VehicleServicePlanStage."Expected Service Date";
        end else begin
            ServiceIntervalFormat := Format(VehicleServicePlanStage."Service Interval");
            if (ServiceIntervalFormat = ' ') or (ServiceIntervalFormat = '') then
                exit(0D);
            MinDate := GetDateOfPrevStage(VehicleServicePlanStage, true);
            if (MinDate = 0D) then begin
                VehicleServicePlan.Get(VehicleServicePlanStage."Vehicle Serial No.", VehicleServicePlanStage."Plan No.");
                MinDate := VehicleServicePlan."Start Date";
            end;
            RetDate := CalcDate(VehicleServicePlanStage."Service Interval", MinDate);
        end;
        exit(RetDate);
    end;


    procedure GetStartRun1(): Decimal
    var
        Vehicle: Record Vehicle;
    begin
        exit(VehicleServicePlan."Start Variable Field Run 1");
    end;


    procedure GetStartRun2(): Decimal
    var
        Vehicle: Record Vehicle;
    begin
        exit(VehicleServicePlan."Start Variable Field Run 2");
    end;


    procedure GetStartRun3(): Decimal
    var
        Vehicle: Record Vehicle;
    begin
        exit(VehicleServicePlan."Start Variable Field Run 3");
    end;


    procedure InitialiseStageLast()
    var
        ServLedgerEntry: Record "Service Ledger Entry EDMS";
    begin
        if StageLastTmp."Service Date" = 0D then begin
            StageLastTmp."Variable Field Run 1" := GetStartRun1;
            StageLastTmp."Variable Field Run 2" := GetStartRun2;
            StageLastTmp."Variable Field Run 3" := GetStartRun3;
            StageLastTmp."Service Date" := VehicleServicePlan."Start Date";
        end;
    end;


    procedure AssignStageLast(ServDate: Date; ServVFRun1: Decimal; ServVFRun2: Decimal; ServVFRun3: Decimal): Date
    var
        ServLedgerEntry: Record "Service Ledger Entry EDMS";
    begin
        StageLastTmp."Variable Field Run 1" := ServVFRun1;
        StageLastTmp."Variable Field Run 2" := ServVFRun2;
        StageLastTmp."Variable Field Run 3" := ServVFRun3;
        StageLastTmp."Service Date" := ServDate;
    end;


    procedure StageLastFillByLastSLE()
    var
        ServDate: Date;
        ServVFRun1: Decimal;
        ServVFRun2: Decimal;
        ServVFRun3: Decimal;
    begin
        // that function is not optimal! cause use of SLE, for future need to redo to use "Service Plan Document Link"
        ServDate := GetLastServLEntryDate(VehicleServicePlan."Vehicle Serial No.", VehicleServicePlan."No.", ServVFRun1, ServVFRun2,
          ServVFRun3);
        AssignStageLast(ServDate, ServVFRun1, ServVFRun2, ServVFRun3);
    end;


    procedure GetVehicleSellDate(VehSerialNo: Code[20]): Date
    begin
        if Vehicle.Get(VehSerialNo) then;
        exit(Vehicle."Sales Date");
    end;


    procedure AddLogEntryForCalcESD(RecordRef: RecordRef; xRecordRef: RecordRef; FieldIDChanges: Integer; CommonLogEntryTmp: Record "Common Log Entry" temporary; RunModeFlags: Integer)
    var
        CommonLogEntry: Record "Common Log Entry";
        FieldRef: FieldRef;
        xFieldRef: FieldRef;
    begin
        //AdjustFlagsToArray(RunModeFlags, FlagsArray);
        if FieldIDChanges > 0 then begin
            xFieldRef := xRecordRef.Field(FieldIDChanges);
            FieldRef := RecordRef.Field(FieldIDChanges);
            RunModeFlags := 1;
        end else
            RunModeFlags := 0;

        CommonLogEntry.InsertLogEntry(5, 25006103, CommonLogEntryTmp, FieldRef, xFieldRef, RecordRef,
          CommonLogEntryTmp."type of change"::Modification, RunModeFlags);
    end;


    procedure AddLogEntryForCalcESDofPlan(VehicleServicePlanPar: Record "Vehicle Service Plan"; xVehicleServicePlanPar: Record "Vehicle Service Plan"; LogText: Text[250]; FieldIDChanges: Integer; RunModeFlags: Integer)
    var
        CommonLogEntry: Record "Common Log Entry";
        CommonLogEntryTmp: Record "Common Log Entry" temporary;
        FlagsArray: array[16] of Boolean;
        RecordRef: RecordRef;
        xRecordRef: RecordRef;
        FieldRef: FieldRef;
        xFieldRef: FieldRef;
    begin
        //AdjustFlagsToArray(RunModeFlags, FlagsArray);
        ServiceSetup.Get;
        if not ServiceSetup."Log Service Plan Mgt. Process" then
            exit;
        RecordRef.Open(Database::"Vehicle Service Plan");
        RecordRef.GetTable(VehicleServicePlanPar);
        xRecordRef.Open(Database::"Vehicle Service Plan");
        xRecordRef.GetTable(xVehicleServicePlanPar);

        CommonLogEntryTmp."Processing Info" := LogText;
        AddLogEntryForCalcESD(RecordRef, xRecordRef, FieldIDChanges, CommonLogEntryTmp, 0);
    end;


    procedure AddLogEntryForCalcESDofStage(VehicleServicePlanStagePar: Record "Vehicle Service Plan Stage"; xVehicleServicePlanStagePar: Record "Vehicle Service Plan Stage"; LogText: Text[250]; FieldIDChanges: Integer; RunModeFlags: Integer)
    var
        CommonLogEntry: Record "Common Log Entry";
        CommonLogEntryTmp: Record "Common Log Entry" temporary;
        FlagsArray: array[16] of Boolean;
        RecordRef: RecordRef;
        xRecordRef: RecordRef;
        FieldRef: FieldRef;
        xFieldRef: FieldRef;
    begin
        //AdjustFlagsToArray(RunModeFlags, FlagsArray);
        ServiceSetup.Get;
        if not ServiceSetup."Log Service Plan Mgt. Process" then
            exit;
        RecordRef.Open(Database::"Vehicle Service Plan Stage");
        RecordRef.GetTable(VehicleServicePlanStagePar);
        xRecordRef.Open(Database::"Vehicle Service Plan Stage");
        xRecordRef.GetTable(xVehicleServicePlanStagePar);

        CommonLogEntryTmp."Processing Info" := LogText;
        AddLogEntryForCalcESD(RecordRef, xRecordRef, FieldIDChanges, CommonLogEntryTmp, 0);
    end;


    procedure "//--Universal CreateOrdersBy"()
    begin
    end;


    procedure SetVehicleG(var VehiclePar: Record Vehicle)
    begin
        //VehicleGlob := VehiclePar;
        VehicleGlob.Reset;
        if VehiclePar.GetFilters <> '' then  //25.03.2013 EDMS P8
            VehicleGlob.CopyFilters(VehiclePar);
    end;


    procedure SetVehicleContactG(var VehicleContactPar: Record "Vehicle Contact")
    begin
        //VehicleContactGlob := VehicleContactPar;
        VehicleContactGlob.Reset;
        if VehicleContactPar.GetFilters <> '' then
            VehicleContactGlob.CopyFilters(VehicleContactPar);
    end;


    procedure SetContactBusinessRelationG(var ContactBusinessRelationPar: Record "Contact Business Relation")
    begin
        //ContactBusinessRelationGlob := ContactBusinessRelationPar;
        ContactBusinessRelationGlob.Reset;
        if ContactBusinessRelationPar.GetFilters <> '' then
            ContactBusinessRelationGlob.CopyFilters(ContactBusinessRelationPar);
    end;


    procedure SetCustomerG(var CustomerPar: Record Customer)
    begin
        //CustomerGlob := CustomerPar;
        CustomerGlob.Reset;
        if CustomerPar.GetFilters <> '' then
            CustomerGlob.CopyFilters(CustomerPar);
    end;


    procedure SetVehicleServicePlanG(var VehicleServicePlanPar: Record "Vehicle Service Plan")
    begin
        //VehicleServicePlanGlob := VehicleServicePlanPar;
        VehicleServicePlanGlob.Reset;
        if VehicleServicePlanPar.GetFilters <> '' then
            VehicleServicePlanGlob.CopyFilters(VehicleServicePlanPar);
    end;


    procedure SetVehicleServicePlanStageG(var VehicleServicePlanStagePar: Record "Vehicle Service Plan Stage")
    begin
        //VehicleServicePlanStageGlob := VehicleServicePlanStagePar;
        VehicleServicePlanStageGlob.Reset;
        if VehicleServicePlanStagePar.GetFilters <> '' then
            VehicleServicePlanStageGlob.CopyFilters(VehicleServicePlanStagePar);
    end;


    procedure SetServicePackageG(var ServicePackagePar: Record "Service Package")
    begin
        //ServicePackageGlob := ServicePackagePar;
        ServicePackageGlob.Reset;
        if ServicePackagePar.GetFilters <> '' then
            ServicePackageGlob.CopyFilters(ServicePackagePar);
    end;


    procedure SetServicePackageVersionG(var ServicePackageVersionPar: Record "Service Package Version")
    begin
        //ServicePackageVersionGlob := ServicePackageVersionPar;
        ServicePackageVersionGlob.Reset;
        if ServicePackageVersionPar.GetFilters <> '' then
            ServicePackageVersionGlob.CopyFilters(ServicePackageVersionPar);
    end;


    procedure CreateOrdersByFiltered(OrderDate: Date; RunModeFlags: Integer) RetValue: Integer
    var
        FlagsArray: array[16] of Boolean;
        Vehicle: Record Vehicle;
        VehicleContact: Record "Vehicle Contact";
        ContactBusinessRelation: Record "Contact Business Relation";
        ServiceMgtSetup: Record "Service Mgt. Setup EDMS";
        MarketingSetup: Record "Marketing Setup";
        ServiceHeader: Record "Service Header EDMS";
        ServiceHeaderTmp: Record "Service Header EDMS" temporary;
        VehicleServicePlanStageTmp: Record "Vehicle Service Plan Stage" temporary;
        VehicleServicePlanStage: Record "Vehicle Service Plan Stage";
        VehicleServicePlanStage2: Record "Vehicle Service Plan Stage";
        VehicleServicePlanStage3: Record "Vehicle Service Plan Stage";
        VehicleServicePlan: Record "Vehicle Service Plan";
        ServicePackageLoc: Record "Service Package";
        ServicePackageVersionLoc: Record "Service Package Version";
        CustomerToCurrent: Record Customer;
        ServiceLedgerEntry: Record "Service Ledger Entry EDMS";
        ServicePlanMgt: Codeunit "Service Plan Management";
        DefContRelationshipCode: Code[10];
        FilterStr: Text[30];
        IsFound: Boolean;
        RecExists: Boolean;
        I: Integer;
        IsPlanFilter: Boolean;
        IsPlanStagesFilter: Boolean;
        DoContinue: Boolean;
        OneCarOneDoc: Boolean;
    begin
        AdjustFlagsToArray(RunModeFlags, FlagsArray);
        OneCarOneDoc := false;
        if OrderDate = 0D then
            OrderDate := WorkDate;
        ServiceHeaderTmp.DeleteAll;
        VehicleServicePlanStageTmp.DeleteAll;

        ServiceMgtSetup.Get;
        MarketingSetup.Get;

        VehicleContact.Reset;
        VehicleContact.SetCurrentkey("Vehicle Serial No.", "Relationship Code", "Contact No.");
        VehicleContact.FilterGroup(2);
        VehicleContact.CopyFilters(VehicleContactGlob);
        if VehicleContact.GetFilter("Relationship Code") = '' then begin
            VehicleContact.FilterGroup(0);
            VehicleContact.SetRange("Relationship Code", ServiceMgtSetup."Serv. Plan Cont. Relationship");
        end;

        Vehicle.Reset;
        Vehicle.FilterGroup(2);
        Vehicle.CopyFilters(VehicleGlob);
        Vehicle.FilterGroup(0);
        VehicleServicePlan.Reset;
        VehicleServicePlan.FilterGroup(2);
        VehicleServicePlan.CopyFilters(VehicleServicePlanGlob);
        IsPlanFilter := (VehicleServicePlan.GetFilters <> '');
        VehicleServicePlan.FilterGroup(0);
        ServicePackageLoc.Reset;
        ServicePackageLoc.FilterGroup(2);
        ServicePackageLoc.CopyFilters(ServicePackageGlob);
        ServicePackageLoc.FilterGroup(0);
        if ServicePackageGlob.GetFilters = '' then
            ServicePackageLoc.Reset;
        ServicePackageVersionLoc.Reset;
        //FILTERGROUP(2);  //25.03.2013 EDMS P8
        if ServicePackageVersionGlob.GetFilters <> '' then
            ServicePackageVersionLoc.CopyFilters(ServicePackageVersionGlob);
            //FILTERGROUP(0);
        ContactBusinessRelation.Reset;
        ContactBusinessRelation.FilterGroup(2);
        ContactBusinessRelation.CopyFilters(ContactBusinessRelationGlob);
        ContactBusinessRelation.FilterGroup(0);
        ContactBusinessRelation.SetRange("Business Relation Code", MarketingSetup."Bus. Rel. Code for Customers");
        CustomerToCurrent.Reset;
        CustomerToCurrent.FilterGroup(2);
        CustomerToCurrent.CopyFilters(CustomerGlob);
        CustomerToCurrent.FilterGroup(0);
        VehicleServicePlanStage3.Reset;
        VehicleServicePlanStage3.FilterGroup(2);
        VehicleServicePlanStage3.CopyFilters(VehicleServicePlanStageGlob);
        IsPlanStagesFilter := (VehicleServicePlanStageGlob.GetFilters <> '');
        VehicleServicePlanStage3.FilterGroup(0);


        Vehicle.FindFirst;
        repeat
            for I := 1 to 4 do begin
                ServiceHeader.Reset;
                ServiceHeader.SetHideValidationDialog(true);
                ServiceHeader.Init;
                ServiceHeader."Vehicle Serial No." := Vehicle."Serial No.";
                ServiceHeader.SetDatesSchema1(OrderDate, OrderDate, 0D, 0D);
                if I = 1 then begin
                    ServiceLedgerEntry.SetCurrentkey("Vehicle Serial No.", "Posting Date", "Entry Type");
                    ServiceLedgerEntry.SetRange("Vehicle Serial No.", Vehicle."Serial No.");
                    FilterStr := StrSubstNo('%1|%2', ServiceLedgerEntry."entry type"::Usage, ServiceLedgerEntry."entry type"::Info);
                    ServiceLedgerEntry.SetFilter("Entry Type", FilterStr);
                end;
                if ServiceLedgerEntry.FindLast then begin
                    ServiceHeader."Variable Field Run 1" := ServiceLedgerEntry."Variable Field Run 1";
                    ServiceHeader."Variable Field Run 2" := ServiceLedgerEntry."Variable Field Run 2";
                    ServiceHeader."Variable Field Run 3" := ServiceLedgerEntry."Variable Field Run 3";
                end;
                case I of
                    1:
                        begin
                            IsFound := ServiceHeader.IsAchievedServPlanStageByField(ServiceHeader.FieldNo("Variable Field Run 1"),
                              VehicleServicePlanStage);
                        end;
                    2:
                        begin
                            IsFound := ServiceHeader.IsAchievedServPlanStageByField(ServiceHeader.FieldNo("Variable Field Run 2"),
                              VehicleServicePlanStage);
                        end;
                    3:
                        begin
                            IsFound := ServiceHeader.IsAchievedServPlanStageByField(ServiceHeader.FieldNo("Variable Field Run 3"),
                              VehicleServicePlanStage);
                        end;
                    4:
                        begin
                            IsFound := ServiceHeader.IsAchievedServStageByInterval(VehicleServicePlanStage);
                        end;
                end;
                if IsFound then begin
                    IsFound := VehicleServicePlanStage.FindFirst;
                    if IsPlanStagesFilter then begin
                        VehicleServicePlanStage3.SetRange("Vehicle Serial No.", VehicleServicePlanStage."Vehicle Serial No.");
                        VehicleServicePlanStage3.SetRange("Plan No.", VehicleServicePlanStage."Plan No.");
                        VehicleServicePlanStage3.SetRange(Recurrence, VehicleServicePlanStage.Recurrence);
                        VehicleServicePlanStage3.SetRange(Code, VehicleServicePlanStage.Code);
                        if not VehicleServicePlanStage3.FindFirst then
                            IsFound := false;
                    end;
                end;
                if IsFound then begin
                    //VehicleServicePlanStage.FINDFIRST;
                    repeat
                        DoContinue := true;
                        if IsPlanFilter then begin
                            VehicleServicePlan.SetRange("Vehicle Serial No.", VehicleServicePlanStage."Vehicle Serial No.");
                            VehicleServicePlan.SetRange("No.", VehicleServicePlanStage."Plan No.");
                            if not VehicleServicePlan.FindFirst then
                                DoContinue := false;
                        end;
                        if DoContinue then begin
                            // FOR now it is agreed that for one plan could be one document AT ONCE
                            VehicleServicePlanStage2.Reset;
                            VehicleServicePlanStage2.SetRange("Vehicle Serial No.", VehicleServicePlanStage."Vehicle Serial No.");
                            VehicleServicePlanStage2.SetRange("Plan No.", VehicleServicePlanStage."Plan No.");
                            VehicleServicePlanStage2.SetRange(Recurrence, VehicleServicePlanStage.Recurrence);
                            VehicleServicePlanStage2.SetRange(Status, VehicleServicePlanStage.Status::"In Process");
                            if VehicleServicePlanStage2.FindFirst then
                                DoContinue := false
                            else begin
                                VehicleServicePlanStageTmp.SetRange("Vehicle Serial No.", VehicleServicePlanStage."Vehicle Serial No.");
                                VehicleServicePlanStageTmp.SetRange("Plan No.", VehicleServicePlanStage."Plan No.");
                                if VehicleServicePlanStageTmp.FindFirst then
                                    DoContinue := false;
                            end;
                        end;
                        if DoContinue then begin
                            ServicePackageLoc.SetRange("No.", VehicleServicePlanStage."Package No.");
                            ServicePackageVersionLoc.SetRange("Package No.", VehicleServicePlanStage."Package No.");
                            if ServicePackageLoc.FindFirst then;
                            if ServicePackageVersionLoc.FindFirst then;
                            VehicleContact.SetRange("Vehicle Serial No.", VehicleServicePlanStage."Vehicle Serial No.");
                            if VehicleContact.FindFirst then begin
                                ContactBusinessRelation.SetRange("Contact No.", VehicleContact."Contact No.");
                                if ContactBusinessRelation.FindFirst then begin
                                    CustomerToCurrent.SetRange("No.", ContactBusinessRelation."No.");
                                    if CustomerToCurrent.FindFirst then begin
                                        ServicePlanMgt.SetVehicleServicePlanStage(VehicleServicePlanStage);
                                        ServicePlanMgt.SetSPVersion(ServicePackageVersionLoc);

                                        ServicePlanMgt.SetCustomer(CustomerToCurrent);
                                        ServiceHeader.Reset;
                                        ServiceHeaderTmp.Reset;
                                        ServiceHeaderTmp.SetRange("Vehicle Serial No.", VehicleServicePlanStage."Vehicle Serial No.");
                                        if ServiceHeaderTmp.FindFirst and OneCarOneDoc then begin
                                            ServiceHeader.Get(ServiceHeaderTmp."Document Type", ServiceHeaderTmp."No.");
                                            RecExists := true;
                                        end else begin
                                            RecExists := false;
                                            ServiceHeader.Init;
                                            ServiceHeader."No." := '';
                                            ServiceHeader.SetDatesSchema1(OrderDate, VehicleServicePlanStage."Expected Service Date", 0D, 0D);
                                            ServiceHeader."Variable Field Run 1" := ServiceLedgerEntry."Variable Field Run 1";
                                            ServiceHeader."Variable Field Run 2" := ServiceLedgerEntry."Variable Field Run 2";
                                            ServiceHeader."Variable Field Run 3" := ServiceLedgerEntry."Variable Field Run 3";
                                        end;
                                        VehicleServicePlanStage3.Get(VehicleServicePlanStage."Vehicle Serial No.", VehicleServicePlanStage."Plan No.",
                                          VehicleServicePlanStage.Recurrence, VehicleServicePlanStage.Code);
                                        if ServicePackageVersionLoc.FindFirst then
                                            ServicePlanMgt.CreateServOrderForVehBy(ServiceHeader, 41, '')
                                        else
                                            ServicePlanMgt.CreateServOrderForVehBy(ServiceHeader, 9, '');
                                        if not RecExists then begin
                                            ServiceHeaderTmp.Init;
                                            ServiceHeaderTmp.TransferFields(ServiceHeader);
                                            ServiceHeaderTmp.Insert;
                                            RetValue += 1;
                                        end;
                                        VehicleServicePlanStageTmp.Reset;
                                        VehicleServicePlanStageTmp.Init;
                                        VehicleServicePlanStageTmp.TransferFields(VehicleServicePlanStage);
                                        VehicleServicePlanStageTmp.Insert;

                                    end;
                                end;  // IF ContactBusinessRelation.FINDFIRST
                            end;  // IF VehicleContact.FINDFIRST
                        end;  // IF DoContinue
                    until VehicleServicePlanStage.Next = 0;
                end;
            end;
        until Vehicle.Next = 0;
        exit(RetValue);
    end;


    procedure "//--Old version"()
    begin
    end;


    procedure CreateServOrderForVehBy(var ServiceHeaderPar: Record "Service Header EDMS"; RunModeFlags: Integer; RunModeSpecs: Text[30]): Integer
    var
        ServiceLine: Record "Service Line EDMS";
        FlagsArray: array[16] of Boolean;
        CustNo: Code[20];
        RetStatus: Option OK,NotFoundVehicle,NotFoundCustomer,NotFoundSP,NotFoundSPVersion,UnsupportedFlagsSequence;
        ServiceHeaderTmp: Record "Service Header EDMS" temporary;
        OrderDate: Date;
    begin
        // that is function for general creation/modification of service document by addding lines from service package
        // to obtain sets/parameters need to use subfunctions: SetVehicleServicePlanStage, SetVehicle etc.
        //  So it supposed that record that is given by subfunction should be filtered and general function proceed first or all records
        //   in a range.
        // RunModeFlags - full of digits integer, imitation of two bytes parameter, there 0 means "no" 1 - "yes"' from right to left:
        //   1st digit - is it customer record defined
        //   2nd - is it Vehicle record defined
        //   3rd - is it VehicleServicePlan record defined
        //   4th - is it VehicleServicePlanStage record defined
        //   5th - is it ServicePackage record defined
        //   6th - is it SPVersion record defined
        // so to call that function need carefully organize Flags = 1+2+4+8+16+0+64+0 = 95 (means in byte 01011111)
        //for now it is allowed: 41 = 1+0+0+8+0+32+0+0 (bin 00101001)
        //                       9 = 1+0+0+8+0+0+0+0 (bin 00001001)
        AdjustFlagsToArray(RunModeFlags, FlagsArray);
        if not (FlagsArray[1] and not FlagsArray[2] and not FlagsArray[3] and FlagsArray[4] and
            not FlagsArray[5] and not FlagsArray[7] and not FlagsArray[8]) then
            exit(Retstatus::UnsupportedFlagsSequence);  // FIRST error

        //at first must be defined vehicle
        if not FlagsArray[2] then begin
            if ServiceHeaderPar."Vehicle Serial No." = '' then begin
                if not FlagsArray[3] then begin
                    if not FlagsArray[4] then begin
                        exit(Retstatus::NotFoundVehicle);  // FIRST error
                    end else
                        Vehicle.Get(VehicleServicePlanStage."Vehicle Serial No.");
                end else
                    Vehicle.Get(VehicleServicePlan."Vehicle Serial No.");
            end else
                Vehicle.Get(ServiceHeaderPar."Vehicle Serial No.");
        end;
        //then define customer
        if not FlagsArray[1] then begin
            if ServiceHeaderPar."Sell-to Customer No." = '' then begin
                if FlagsArray[4] then
                    CustNo := GetVehicleCustomer(VehicleServicePlanStage."Vehicle Serial No.");
                if CustNo = '' then begin
                    exit(Retstatus::NotFoundCustomer);  //error
                end else
                    Customer.Get(CustNo);
            end else
                Customer.Get(ServiceHeaderPar."Sell-to Customer No.");
        end;

        if ServiceHeaderPar."No." = '' then begin
            // means need create document
            ServiceHeaderTmp.TransferFields(ServiceHeaderPar);
            if ServiceHeaderTmp."Order Date" > 0D then
                OrderDate := ServiceHeaderTmp."Order Date"
            else
                if ServiceHeaderTmp."Planned Service Date" > 0D then
                    OrderDate := ServiceHeaderTmp."Planned Service Date"
                else
                    OrderDate := WorkDate;
            ServiceHeaderPar.CreateServHeader(ServiceHeaderPar."document type"::Order, OrderDate, ServiceHeaderTmp."Planned Service Date",
              VehicleServicePlanStage.Description, Customer."No.", Customer."No.", Vehicle."Serial No.");
            //      STRSUBSTNO(Text001, VehicleServicePlanStage."Plan No."), Customer."No.", Customer."No.", Vehicle."Serial No.");
            ServiceHeaderPar."Variable Field Run 1" := ServiceHeaderTmp."Variable Field Run 1";
            ServiceHeaderPar."Variable Field Run 2" := ServiceHeaderTmp."Variable Field Run 2";
            ServiceHeaderPar."Variable Field Run 3" := ServiceHeaderTmp."Variable Field Run 3";
            ServiceHeaderPar.Modify;
        end;
        if FlagsArray[6] then begin
            ServiceHeaderPar.SPVersionAssignFilter(SPVersion);
            if SPVersion.FindFirst then begin
                ServiceHeaderPar.SetCurrPlanStage(VehicleServicePlanStage);    //04.09.2018 EDMS
                ServiceHeaderPar.InsertSPVersion(SPVersion)
            end else
                exit(Retstatus::NotFoundSPVersion);  //error
        end;

        if FlagsArray[4] then begin
            ServiceHeaderPar.InsertServPlanDocLink(VehicleServicePlanStage);
        end;


        exit(Retstatus::OK);  //success
    end;
}

