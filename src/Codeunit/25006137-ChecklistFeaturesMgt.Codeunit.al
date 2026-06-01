Codeunit 25006137 "Checklist Features Mgt."
{
    // 17/08/2018 EB.P30 GH
    //   Added function:
    //     ChecklistReferenceDescription
    // 
    // 27/03/2018 GP1 P30
    //   Added functions:
    //     CopyVHCAuthorisedLinesToOrder
    //     GetServHeaderForVehAndCust
    // 
    // 23/04/2017 GP1 P1
    //  *Modified OnValidateVehicleCustomerAddVehicleContact


    trigger OnRun()
    begin
    end;

    var
        Text014: label 'Before you can use Online Map, you must fill in the Online Map Setup window.\See Setting Up Online Map in Help.';
        ConfirmNewServOrdTxt: label 'Service order for customer %1 vehicle %2 doesn''t exist. Do you want to create a new one?';
        QuestionMandatory: label 'Question %1 is mandatory. Please give the answer.';
        CopiedToTxt: label 'Process Checklist copied to %1.';


    [EventSubscriber(ObjectType::Table, Database::Vehicle, 'OnAfterValidateEvent', 'Customer No.', false, false)]
    local procedure OnValidateVehicleCustomerAddVehicleContact(var Rec: Record Vehicle; var xRec: Record Vehicle; CurrFieldNo: Integer)
    var
        Contact: Record Contact;
        VehicleContact: Record "Vehicle Contact";
        ContactBusinessRelation: Record "Contact Business Relation";
        ServiceMgtSetup: Record "Service Mgt. Setup EDMS";
        MarketingSetup: Record "Marketing Setup";
    begin
        //23/04/2017 GP1 P1 - commented>>
        //IF NOT (CurrFieldNo IN [Rec.FIELDNO("Customer No."), Rec.FIELDNO("Customer Name")]) THEN
        //  EXIT;
        //23/04/2017 GP1 P1 - commented<<

        ServiceMgtSetup.Get;
        MarketingSetup.Get;
        ContactBusinessRelation.SetRange("No.", Rec."Customer No.");
        ContactBusinessRelation.SetRange("Business Relation Code", MarketingSetup."Bus. Rel. Code for Customers");
        if ContactBusinessRelation.FindFirst then begin
            if not VehicleContact.Get(Rec."Serial No.", ServiceMgtSetup."Link Relationship Code", ContactBusinessRelation."Contact No.") then begin
                VehicleContact.Init;
                VehicleContact."Vehicle Serial No." := Rec."Serial No.";
                VehicleContact."Relationship Code" := ServiceMgtSetup."Link Relationship Code";
                VehicleContact."Contact No." := ContactBusinessRelation."Contact No.";
                VehicleContact.Insert;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vehicle Contact", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnInsertVehicleContactUpdateVehicleCustomer(var Rec: Record "Vehicle Contact"; RunTrigger: Boolean)
    var
        Contact: Record Contact;
        Vehicle: Record Vehicle;
        ContactBusinessRelation: Record "Contact Business Relation";
        ServiceMgtSetup: Record "Service Mgt. Setup EDMS";
        MarketingSetup: Record "Marketing Setup";
    begin
        if not RunTrigger then
            exit;
        ServiceMgtSetup.Get;
        if Rec."Relationship Code" <> ServiceMgtSetup."Link Relationship Code" then
            exit;

        Contact.Get(Rec."Contact No.");
        MarketingSetup.Get;
        if ContactBusinessRelation.Get(Contact."Company No.", MarketingSetup."Bus. Rel. Code for Customers") then begin
            Vehicle.Get(Rec."Vehicle Serial No.");
            if Vehicle."Customer No." = ContactBusinessRelation."No." then
                exit;
            Vehicle."Customer No." := ContactBusinessRelation."No.";
            Vehicle.Modify;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vehicle Contact", 'OnAfterRenameEvent', '', false, false)]
    local procedure OnRenameVehicleContactUpdateVehicleCustomer(var Rec: Record "Vehicle Contact"; var xRec: Record "Vehicle Contact"; RunTrigger: Boolean)
    var
        Contact: Record Contact;
        Vehicle: Record Vehicle;
        ContactBusinessRelation: Record "Contact Business Relation";
        ServiceMgtSetup: Record "Service Mgt. Setup EDMS";
        MarketingSetup: Record "Marketing Setup";
    begin
        ServiceMgtSetup.Get;
        MarketingSetup.Get;
        if Rec."Relationship Code" <> ServiceMgtSetup."Link Relationship Code" then
            exit;

        if Rec."Contact No." <> xRec."Contact No." then begin
            Contact.Get(Rec."Contact No.");
            if ContactBusinessRelation.Get(Contact."Company No.", MarketingSetup."Bus. Rel. Code for Customers") then begin
                Vehicle.Get(Rec."Vehicle Serial No.");
                Vehicle."Customer No." := ContactBusinessRelation."No.";
                Vehicle.Modify;
            end;
        end;
    end;


    procedure PickCustomer(var Customer: Record Customer): Code[20]
    var
        CustomerList: Page "Customer List";
    begin
        CustomerList.SetTableview(Customer);
        CustomerList.SetRecord(Customer);
        CustomerList.LookupMode := true;
        if CustomerList.RunModal = Action::LookupOK then
            CustomerList.GetRecord(Customer);

        exit(Customer."No.");
    end;


    procedure RecalculateServiceDocItemPrices(var ServiceHeader: Record "Service Header EDMS")
    var
        ServiceLine: Record "Service Line EDMS";
    begin
        ServiceLine.Reset;
        ServiceLine.SetRange("Document Type", ServiceHeader."Document Type");
        ServiceLine.SetRange("Document No.", ServiceHeader."No.");
        ServiceLine.SetRange(Type, ServiceLine.Type::Item);
        if ServiceLine.FindFirst then
            repeat
                ServiceLine.Validate(Quantity); //Call UpdatePrices
                ServiceLine.Modify(true);
            until ServiceLine.Next = 0;
    end;


    procedure ShowServiceAddressOnlineMap(var ServHeader: Record "Service Header EDMS")
    var
        MapPoint: Record "Online Map Setup";
        MapMgt: Codeunit "Online Map Management";
    begin
        if MapPoint.FindFirst then
            MapMgt.MakeSelection(Database::"Service Header EDMS", ServHeader.GetPosition)
        //MESSAGE(' ok')
        else
            Message(Text014);
    end;


    procedure WeekNo(InputDate: Date): Integer
    var
        Date: Record Date;
    begin
        if InputDate = 0D then
            exit(0);

        Date.Reset;
        Date.SetRange(Date."Period Type", Date."period type"::Week);
        Date.SetFilter(Date."Period Start", '<=%1', InputDate);
        Date.SetFilter(Date."Period End", '>=%1', InputDate);
        if Date.FindFirst then
            exit(Date."Period No.");
    end;


    procedure AddResourcesToServiceLines(var ServiceHeader: Record "Service Header EDMS")
    var
        AllocEntry: Record "Serv. Labor Alloc. Application";
    begin
        AllocEntry.Reset;
        AllocEntry.SetRange("Allocation Entry No.", 0);
        AllocEntry.SetRange("Document Type", ServiceHeader."Document Type");
        AllocEntry.SetRange("Document No.", ServiceHeader."No.");
        AllocEntry.SetFilter("Document Line No.", '<>0');
        if AllocEntry.FindFirst then
            if Confirm('Resource information already exists in Jobsheet lines.\Do you want to delete it?') then begin
                AllocEntry.DeleteAll(true);
                Commit;
            end;

        //Page in GH 25006682
        //AddResToServiceLinesPage.SetServHeader(ServiceHeader);
        //AddResToServiceLinesPage.LOOKUPMODE(TRUE);
        //IF AddResToServiceLinesPage.RUNMODAL = ACTION::OK THEN;
    end;


    procedure ShowVehicleInspectionFromServiceOrder(var ServHeader: Record "Service Header EDMS")
    var
        ProcessChecklistHeader: Record "Process Checklist Header";
        Template: Record "Questionary Template";
        ChecklistNo: Code[20];
    begin
        ProcessChecklistHeader.Reset;
        ProcessChecklistHeader.SetRange("Source Type", Database::"Service Header EDMS");
        ProcessChecklistHeader.SetRange("Source Subtype", ServHeader."Document Type");
        ProcessChecklistHeader.SetRange("Source ID", ServHeader."No.");
        if not ProcessChecklistHeader.FindFirst then begin
            if Confirm('Vehicle Inspection doesn''t exist. Do you want to create it now?', true) then begin
                Template.SetRange(Type, Template.Type::"Vehicle Inspection");
                ChecklistNo := NewChecklistFromTemplate(Template.GetFilter(Type),
                                ServHeader."Vehicle Serial No.",
                                Database::"Service Header EDMS",
                                ServHeader."Document Type",
                                ServHeader."No.");
                if ChecklistNo = '' then
                    exit;
                ProcessChecklistHeader.Get(ChecklistNo)
            end else
                exit;
        end;
        ProcessChecklistHeader.Reset;
        Page.Run(Page::"Checklist Card", ProcessChecklistHeader);
        //    //zzz
        //  ELSE
        //    EXIT;
    end;


    procedure ShowVehicleInspectionFromVHC(var ServHeader: Record "Service Header EDMS")
    var
        ProcessChecklistHeader: Record "Process Checklist Header";
        Template: Record "Questionary Template";
        ChecklistNo: Code[20];
    begin
        ProcessChecklistHeader.Reset;
        ProcessChecklistHeader.SetRange("VHC No.", ServHeader."No.");
        if ProcessChecklistHeader.FindFirst then begin
            ProcessChecklistHeader.Reset;
            Page.Run(Page::"Checklist Card", ProcessChecklistHeader);
        end else
            Message('Vehicle Inspection not found');
    end;


    procedure NewChecklistFromTemplate(TemplateFilterText: Text; VehicleSerialNo: Code[20]; SourceType: Integer; SourceSubType: Integer; SourceID: Code[20]): Code[20]
    var
        Template: Record "Questionary Template";
        Templates: Page "Questionary Templates";
        NewChecklistHeader: Record "Process Checklist Header";
    begin
        Template.SetFilter(Type, TemplateFilterText);
        Templates.SetTableview(Template);
        Templates.LookupMode(true);
        if Templates.RunModal = Action::LookupOK then begin
            Templates.GetRecord(Template);
            InsertChecklistFromTemplate(Template, NewChecklistHeader, VehicleSerialNo, SourceType, SourceSubType, SourceID);
        end else
            exit;

        exit(NewChecklistHeader."No.");
    end;

    local procedure InsertChecklistFromTemplate(var Template: Record "Questionary Template"; var NewChecklistHeader: Record "Process Checklist Header"; VehicleSerialNo: Code[20]; SourceType: Integer; SourceSubType: Integer; SourceID: Code[20])
    begin
        NewChecklistHeader.Insert(true);
        NewChecklistHeader.Validate("Template Code", Template.Code);
        NewChecklistHeader.Validate("Vehicle Serial No.", VehicleSerialNo);
        NewChecklistHeader."Source Type" := SourceType;
        NewChecklistHeader."Source Subtype" := SourceSubType;
        NewChecklistHeader."Source ID" := SourceID;
        NewChecklistHeader.Modify(true);
    end;


    procedure ConfirmChecklist(var ProcessChecklistHeader: Record "Process Checklist Header"; var xProcessChecklistHeader: Record "Process Checklist Header")
    var
        NewValue: Boolean;
        OldValue: Boolean;
    begin
        NewValue := ProcessChecklistHeader."Confirmed by Advisor";
        OldValue := xProcessChecklistHeader."Confirmed by Advisor";

        if NewValue = false then begin
            ProcessChecklistHeader.TestField("VHC No.", '');
        end else begin //=TRUE
            if OldValue = true then
                Message('The checklist is already confirmed')
            else begin
                if ProcessChecklistHeader.Type = ProcessChecklistHeader.Type::"Vehicle Inspection" then begin
                    CreateVHCfromChecklist(ProcessChecklistHeader);
                    Message('VHC created');
                end;
            end;
        end;
    end;

    local procedure CreateVHCfromChecklist(var ProcessChecklistHeader: Record "Process Checklist Header")
    var
        VHCHeader: Record "Service Header EDMS";
        ServiceOrderHeader: Record "Service Header EDMS";
    begin
        ProcessChecklistHeader.TestField("Source Type", Database::"Service Header EDMS");
        ProcessChecklistHeader.TestField("Source Subtype", ServiceOrderHeader."document type"::Order);
        ProcessChecklistHeader.TestField("Source ID");

        ServiceOrderHeader.Get(ProcessChecklistHeader."Source Subtype", ProcessChecklistHeader."Source ID");

        VHCHeader.Init;
        VHCHeader."Document Type" := VHCHeader."document type"::VHC;
        VHCHeader.Insert(true);
        VHCHeader.Validate("Sell-to Customer No.", ServiceOrderHeader."Sell-to Customer No.");
        VHCHeader.Validate("Vehicle Serial No.", ServiceOrderHeader."Vehicle Serial No.");
        VHCHeader.Modify(true);

        ProcessChecklistHeader.Validate("VHC No.", VHCHeader."No.");
        ProcessChecklistHeader.Modify(true);
    end;


    procedure CopyVHCAuthorisedLinesToOrder(VHCHeader: Record "Service Header EDMS")
    var
        VHCLine: Record "Service Line EDMS";
        ServiceOrderLine: Record "Service Line EDMS";
        ServiceOrderHeader: Record "Service Header EDMS";
        LineNo: Integer;
    begin
        /*
        IF GetServHeaderForVehAndCust(VHCHeader."Vehicle Serial No.", VHCHeader."Sell-to Customer No.", VHCHeader."Document Type"::Order, ServiceOrderHeader) THEN BEGIN
          VHCLine.RESET;
          VHCLine.SETRANGE("Document Type", VHCHeader."Document Type");
          VHCLine.SETRANGE("Document No.", VHCHeader."No.");
          VHCLine.SETRANGE("Customer Authorised", TRUE);
          VHCLine.SETFILTER("VHC Service Order No.", '=%1', '');
          IF VHCLine.FINDFIRST THEN BEGIN
            ServiceOrderLine.RESET;
            ServiceOrderLine.SETRANGE("Document Type", ServiceOrderHeader."Document Type");
            ServiceOrderLine.SETRANGE("Document No.", ServiceOrderHeader."No.");
            IF ServiceOrderLine.FINDLAST THEN
              LineNo := ServiceOrderLine."Line No."
            ELSE
              LineNo := 0;
            REPEAT
              LineNo += 10000;
              ServiceOrderLine.INIT;
              ServiceOrderLine."Document Type" := ServiceOrderHeader."Document Type";
              ServiceOrderLine."Document No." := ServiceOrderHeader."No.";
              ServiceOrderLine."Line No." := LineNo;
              ServiceOrderLine.INSERT(TRUE);
              ServiceOrderLine.VALIDATE(Type, VHCLine.Type);
              ServiceOrderLine.VALIDATE("No.", VHCLine."No.");
              ServiceOrderLine.VALIDATE(Description, VHCLine.Description);
              ServiceOrderLine.VALIDATE("Unit of Measure Code", VHCLine."Unit of Measure Code");
              ServiceOrderLine.VALIDATE(Quantity, VHCLine.Quantity);
              ServiceOrderLine.VALIDATE("Unit Price", VHCLine."Unit Price");
              ServiceOrderLine.VALIDATE("Line Discount %", VHCLine."Line Discount %");
              ServiceOrderLine.MODIFY(TRUE);
              VHCLine."VHC Service Order No." := ServiceOrderHeader."No.";
              VHCLine.MODIFY;
            UNTIL VHCLine.NEXT = 0;
          END;
        END;
        */

    end;

    local procedure GetServHeaderForVehAndCust(VehicleSerialNo: Code[20]; CustomerNo: Code[20]; ServiceDocType: Option; var ServiceHeader: Record "Service Header EDMS"): Boolean
    var
        Vehicle: Record Vehicle;
        Customer: Record Customer;
    begin
        Vehicle.Get(VehicleSerialNo);
        Customer.Get(CustomerNo);
        ServiceHeader.Reset;
        ServiceHeader.SetRange("Document Type", ServiceDocType);
        ServiceHeader.SetRange("Vehicle Serial No.", VehicleSerialNo);
        ServiceHeader.SetRange("Sell-to Customer No.", CustomerNo);
        if ServiceHeader.FindFirst then begin
            if Page.RunModal(Page::"Service Orders EDMS", ServiceHeader) = Action::LookupOK then
                exit(true)
            else
                exit(false);
        end else begin
            if Confirm(ConfirmNewServOrdTxt, false, Vehicle."Registration No.", Customer.Name) then begin
                ServiceHeader.Init;
                ServiceHeader."Document Type" := ServiceDocType;
                ServiceHeader.Insert(true);
                ServiceHeader.Validate("Sell-to Customer No.", CustomerNo);
                ServiceHeader.Validate("Vehicle Serial No.", VehicleSerialNo);
                ServiceHeader.Modify(true);
                exit(true);
            end else
                exit(false);
        end;
    end;


    procedure InsertQuestionGroupQuestionFromTemplate(var QuestionLineVar: Record "Quest. Subj. Group Question")
    var
        ReturnOpt: Integer;
        QuestionLine: Record "Quest. Subj. Group Question";
        LineNo: Integer;
    begin
        //Checklists..
        ReturnOpt := StrMenu('Checkbox,Radio Buttons: B.G.A.R,Textbox, 2 x Small Textboxes', 1, 'Select template');

        if ReturnOpt = 0 then
            exit;

        LineNo := 0;
        QuestionLine.SetRange("Questionary Subject Group Code", QuestionLineVar."Questionary Subject Group Code");
        if QuestionLine.FindLast then
            LineNo := QuestionLine."No.";

        case ReturnOpt of
            1: //Checkbox
                begin
                    LineNo += 10000;
                    QuestionLine.Init;
                    QuestionLine."Questionary Subject Group Code" := QuestionLineVar."Questionary Subject Group Code";
                    QuestionLine."No." := LineNo;
                    QuestionLine.Insert(true);
                    QuestionLine.Validate("Question Text", '[Question Text]');
                    QuestionLine.Validate(Type, QuestionLine.Type::Line);
                    QuestionLine.Modify(true);

                    LineNo += 10000;
                    QuestionLine.Init;
                    QuestionLine."Questionary Subject Group Code" := QuestionLineVar."Questionary Subject Group Code";
                    QuestionLine."No." := LineNo;
                    QuestionLine.Insert(true);
                    QuestionLine.Validate("Question Text", 'Checkbox');
                    QuestionLine.Validate(Type, QuestionLine.Type::Control);
                    QuestionLine.Validate(SubType, QuestionLine.Subtype::Checkbox);
                    QuestionLine.Validate("Control Color", '#dce8ed');
                    QuestionLine.Validate("Answer Type", QuestionLine."answer type"::Boolean);
                    QuestionLine.Modify(true);
                end;
            2: //Radio Buttons: B.G.A.R
                begin
                    LineNo += 10000;
                    QuestionLine.Init;
                    QuestionLine."Questionary Subject Group Code" := QuestionLineVar."Questionary Subject Group Code";
                    QuestionLine."No." := LineNo;
                    QuestionLine.Insert(true);
                    QuestionLine.Validate("Question Text", '[Question Text]');
                    QuestionLine.Validate(Type, QuestionLine.Type::Line);
                    QuestionLine.Modify(true);

                    LineNo += 10000;
                    QuestionLine.Init;
                    QuestionLine."Questionary Subject Group Code" := QuestionLineVar."Questionary Subject Group Code";
                    QuestionLine."No." := LineNo;
                    QuestionLine.Insert(true);
                    QuestionLine.Validate("Question Text", 'Blue (Not Checked)');
                    QuestionLine.Validate(Type, QuestionLine.Type::Control);
                    QuestionLine.Validate(SubType, QuestionLine.Subtype::"Radio Button");
                    QuestionLine.Validate("Control Color", '#3498DB');
                    QuestionLine.Validate("Answer Type", QuestionLine."answer type"::Boolean);
                    QuestionLine.Validate("Default Value", 'YES');
                    QuestionLine.Modify(true);

                    LineNo += 10000;
                    QuestionLine.Init;
                    QuestionLine."Questionary Subject Group Code" := QuestionLineVar."Questionary Subject Group Code";
                    QuestionLine."No." := LineNo;
                    QuestionLine.Insert(true);
                    QuestionLine.Validate("Question Text", 'Green');
                    QuestionLine.Validate(Type, QuestionLine.Type::Control);
                    QuestionLine.Validate(SubType, QuestionLine.Subtype::"Radio Button");
                    QuestionLine.Validate("Control Color", '#78e87a');
                    QuestionLine.Validate("Answer Type", QuestionLine."answer type"::Boolean);
                    QuestionLine.Modify(true);

                    LineNo += 10000;
                    QuestionLine.Init;
                    QuestionLine."Questionary Subject Group Code" := QuestionLineVar."Questionary Subject Group Code";
                    QuestionLine."No." := LineNo;
                    QuestionLine.Insert(true);
                    QuestionLine.Validate("Question Text", 'Amber');
                    QuestionLine.Validate(Type, QuestionLine.Type::Control);
                    QuestionLine.Validate(SubType, QuestionLine.Subtype::"Radio Button");
                    QuestionLine.Validate("Control Color", '#eda444');
                    QuestionLine.Validate("Answer Type", QuestionLine."answer type"::Boolean);
                    QuestionLine.Modify(true);

                    LineNo += 10000;
                    QuestionLine.Init;
                    QuestionLine."Questionary Subject Group Code" := QuestionLineVar."Questionary Subject Group Code";
                    QuestionLine."No." := LineNo;
                    QuestionLine.Insert(true);
                    QuestionLine.Validate("Question Text", 'Red');
                    QuestionLine.Validate(Type, QuestionLine.Type::Control);
                    QuestionLine.Validate(SubType, QuestionLine.Subtype::"Radio Button");
                    QuestionLine.Validate("Control Color", '#ff0000');
                    QuestionLine.Validate("Answer Type", QuestionLine."answer type"::Boolean);
                    QuestionLine.Modify(true);
                end;
            3: //Textbox
                begin
                    LineNo += 10000;
                    QuestionLine.Init;
                    QuestionLine."Questionary Subject Group Code" := QuestionLineVar."Questionary Subject Group Code";
                    QuestionLine."No." := LineNo;
                    QuestionLine.Insert(true);
                    QuestionLine.Validate("Question Text", '[Question Text]');
                    QuestionLine.Validate(Type, QuestionLine.Type::Line);
                    QuestionLine.Modify(true);

                    LineNo += 10000;
                    QuestionLine.Init;
                    QuestionLine."Questionary Subject Group Code" := QuestionLineVar."Questionary Subject Group Code";
                    QuestionLine."No." := LineNo;
                    QuestionLine.Insert(true);
                    QuestionLine.Validate("Question Text", '[Textbox Caption]');
                    QuestionLine.Validate(Type, QuestionLine.Type::Control);
                    QuestionLine.Validate(SubType, QuestionLine.Subtype::"Textbox-Standard");
                    QuestionLine.Validate("Answer Type", QuestionLine."answer type"::Dictionary);
                    QuestionLine.Modify(true);
                end;
            4: //2 x Small textboxes
                begin
                    LineNo += 10000;
                    QuestionLine.Init;
                    QuestionLine."Questionary Subject Group Code" := QuestionLineVar."Questionary Subject Group Code";
                    QuestionLine."No." := LineNo;
                    QuestionLine.Insert(true);
                    QuestionLine.Validate("Question Text", '[Question Text]');
                    QuestionLine.Validate(Type, QuestionLine.Type::Line);
                    QuestionLine.Modify(true);

                    LineNo += 10000;
                    QuestionLine.Init;
                    QuestionLine."Questionary Subject Group Code" := QuestionLineVar."Questionary Subject Group Code";
                    QuestionLine."No." := LineNo;
                    QuestionLine.Insert(true);
                    QuestionLine.Validate("Question Text", '[Textbox1 Caption]');
                    QuestionLine.Validate(Type, QuestionLine.Type::Control);
                    QuestionLine.Validate(SubType, QuestionLine.Subtype::"Textbox-Small");
                    QuestionLine.Validate("Answer Type", QuestionLine."answer type"::Dictionary);
                    QuestionLine.Modify(true);

                    LineNo += 10000;
                    QuestionLine.Init;
                    QuestionLine."Questionary Subject Group Code" := QuestionLineVar."Questionary Subject Group Code";
                    QuestionLine."No." := LineNo;
                    QuestionLine.Insert(true);
                    QuestionLine.Validate("Question Text", '[Textbox2 Caption]');
                    QuestionLine.Validate(Type, QuestionLine.Type::Control);
                    QuestionLine.Validate(SubType, QuestionLine.Subtype::"Textbox-Small");
                    QuestionLine.Validate("Answer Type", QuestionLine."answer type"::Dictionary);
                    QuestionLine.Modify(true);
                end
            else
                exit;
        end;
    end;


    procedure ChecklistReferenceDescription(SourceType: Integer; SourceSubType: Integer; SourceID: Code[20]): Text
    var
        ServiceHeaderEDMS: Record "Service Header EDMS";
        Vehicle: Record Vehicle;
    begin
        case SourceType of
            Database::"Service Header EDMS":
                begin
                    ServiceHeaderEDMS."Document Type" := SourceSubType;
                    exit(Format(ServiceHeaderEDMS."Document Type") + ' ' + SourceID);
                end;
            Database::Vehicle:
                begin
                    if Vehicle.Get(SourceID) then;
                    exit(Vehicle."Registration No." + ' ' + Vehicle."Make Code" + ' ' + Vehicle."Model Code");
                end;
        end;
        exit('');
    end;

    PROCEDURE ValidateChecklist(VAR ChecklistHeader: Record "Process Checklist Header");
    VAR
        ChecklistLine: Record "Process Checklist Line";
        ChecklistLineControl: Record "Process Checklist Line";
        AllControllsFilled: Boolean;
        RadiosFilled: Boolean;
    BEGIN
        ChecklistLine.RESET;
        ChecklistLine.SETRANGE("Process Checklist No.", ChecklistHeader."No.");
        ChecklistLine.SETRANGE("Line Type", ChecklistLine."Line Type"::Line);
        IF ChecklistLine.FINDFIRST THEN
            REPEAT
                AllControllsFilled := TRUE;
                RadiosFilled := FALSE;
                IF ChecklistLine.IsMandatory THEN BEGIN
                    ChecklistLineControl.RESET;
                    ChecklistLineControl.SETRANGE("Process Checklist No.", ChecklistLine."Process Checklist No.");
                    ChecklistLineControl.SETRANGE("Parent Line No.", ChecklistLine."Line No.");
                    ChecklistLineControl.SETRANGE("Line Type", ChecklistLineControl."Line Type"::Control);
                    IF ChecklistLineControl.FINDFIRST THEN BEGIN
                        REPEAT
                            CASE ChecklistLineControl.SubType OF
                                ChecklistLineControl.SubType::"Textbox-Small":
                                    BEGIN
                                        IF ChecklistLineControl."Value Description" = '' THEN
                                            AllControllsFilled := FALSE;
                                    END;
                                ChecklistLineControl.SubType::"Textbox-Standard":
                                    BEGIN
                                        IF ChecklistLineControl."Value Description" = '' THEN
                                            AllControllsFilled := FALSE;
                                    END;
                                ChecklistLineControl.SubType::"Radio Button":
                                    BEGIN
                                        IF ChecklistLineControl."Value Bool" = TRUE THEN
                                            RadiosFilled := TRUE;
                                    END;
                            //ChecklistLine.SubType::Checkbox:
                            //  BEGIN
                            //  END;
                            END;
                        UNTIL ChecklistLineControl.NEXT = 0;
                    END;
                    IF (ChecklistLine.GetLineControlType = ChecklistLine.SubType::"Radio Button") AND NOT RadiosFilled THEN
                        AllControllsFilled := FALSE;
                    IF NOT AllControllsFilled THEN BEGIN
                        MESSAGE(QuestionMandatory, ChecklistLine."Question Text");
                    END;
                END;
            UNTIL ChecklistLine.NEXT = 0;
    END;

    PROCEDURE CopyChecklist(ChecklistNo: Code[20]);
    VAR
        ProcessChecklistHeader: Record "Process Checklist Header";
        ProcessChecklistLine: Record "Process Checklist Line";
        ProcessChecklistHeaderCopy: Record "Process Checklist Header";
        ProcessChecklistLineCopy: Record "Process Checklist Line";
    BEGIN
        ProcessChecklistHeader.GET(ChecklistNo);

        ProcessChecklistHeaderCopy.INIT;
        ProcessChecklistHeaderCopy.COPY(ProcessChecklistHeader);
        ProcessChecklistHeaderCopy."No." := '';
        ProcessChecklistHeaderCopy.INSERT(TRUE);

        ProcessChecklistLine.SETRANGE("Process Checklist No.", ProcessChecklistHeader."No.");
        IF ProcessChecklistLine.FINDFIRST THEN
            REPEAT
                ProcessChecklistLineCopy.INIT;
                ProcessChecklistLineCopy.COPY(ProcessChecklistLine);
                ProcessChecklistLineCopy."Process Checklist No." := ProcessChecklistHeaderCopy."No.";
                ProcessChecklistLineCopy.INSERT;
            UNTIL ProcessChecklistLine.NEXT = 0;


        MESSAGE(CopiedToTxt, ProcessChecklistHeaderCopy."No.");
    END;

}

