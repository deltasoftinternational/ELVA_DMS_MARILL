Codeunit 25006003 "LookUpManagement"
{
    // 02.03.2015 EDMS P21
    //   Modified local variable in procedure:
    //     LookUpNonstockItemByItem
    // 
    // 13.02.2015 EDMS P21
    //   Modified procedure:
    //     VariableFieldObjectNoList
    // 
    // 14.05.2014 Elva Baltic P8 #F036.2 MMG7.00
    //   * Fix to show correct lookup pages from vehicle card
    // 
    // 14.05.2014 Elva Baltic P21 #S0103 MMG7.00
    //   Added function:
    //     LookUpResource
    // 
    // 13.05.2014 Elva Baltic P21 #S0102 MMG7.00
    //   Modified function:
    //     LookUpObject
    // 
    // 01.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Fix Error in function:
    //     LookUpLaborStandardTime
    // 
    // 01.07.2013 EDMS P8
    //   * fix
    // 
    // 10.05.2008. EDMS P2
    //   * Created function LookUpReport
    // 
    // 20.12.2007 EDMS P5
    //   * Created function LookUpExtService


    trigger OnRun()
    begin
    end;


    procedure LookUpVehicleAMT(var recVehicle: Record Vehicle; codSerialNo: Code[20]): Boolean
    var
        frmVehicleList: Page "Vehicle List";
    begin
        Clear(frmVehicleList);
        if codSerialNo <> '' then
            if recVehicle.Get(codSerialNo) then
                frmVehicleList.SetRecord(recVehicle);
        frmVehicleList.SetTableview(recVehicle);
        frmVehicleList.LookupMode(true);
        if frmVehicleList.RunModal = Action::LookupOK then begin
            frmVehicleList.GetRecord(recVehicle);
            exit(true)
        end;
        exit(false)
    end;


    procedure LookUpStandardText(var recStandardText: Record "Standard Text"; codCode: Code[20]): Boolean
    var
        frmStandardTextCodes: Page "Standard Text Codes";
    begin
        Clear(frmStandardTextCodes);
        if codCode <> '' then
            if recStandardText.Get(codCode) then
                frmStandardTextCodes.SetRecord(recStandardText);
        frmStandardTextCodes.SetTableview(recStandardText);
        frmStandardTextCodes.LookupMode(true);
        if frmStandardTextCodes.RunModal = Action::LookupOK then begin
            frmStandardTextCodes.GetRecord(recStandardText);
            exit(true)
        end;
        exit(false)
    end;


    procedure LookUpModelVersion(var recItem: Record Item; No: Code[20]; codMakeCode: Code[20]; codModelCode: Code[20]): Boolean
    var
        frmModelVersions: Page "Model Version List";
        ModelVersionListPage: Page "Model Version List";
    begin
        Clear(frmModelVersions);
        Clear(ModelVersionListPage);
        recItem.SetCurrentkey("Item Type", "Make Code");
        recItem.SetRange("Item Type", recItem."item type"::"Model Version");
        if codMakeCode <> '' then
            recItem.SetRange("Make Code", codMakeCode);
        if codModelCode <> '' then
            recItem.SetRange("Model Code", codModelCode);
        if No <> '' then
            if recItem.Get(No) then
                ModelVersionListPage.SetRecord(recItem);


        ModelVersionListPage.SetTableview(recItem);
        ModelVersionListPage.LookupMode(true);
        if ModelVersionListPage.RunModal = Action::LookupOK then begin
            ModelVersionListPage.GetRecord(recItem);
            exit(true)
        end;
        exit(false)
    end;


    procedure LookUpItemREZ(var recItem: Record Item; No: Code[20]): Boolean
    var
        ItemList: Page "Item List";
    begin
        Clear(ItemList);
        recItem.SetCurrentkey("Item Type");
        recItem.SetRange("Item Type", recItem."item type"::Item);
        if No <> '' then
            if recItem.Get(No) then
                ItemList.SetRecord(recItem);
        ItemList.SetTableview(recItem);
        ItemList.LookupMode(true);
        if ItemList.RunModal = Action::LookupOK then begin
            ItemList.GetRecord(recItem);
            exit(true)
        end;
        exit(false)
    end;


    procedure LookUpItem(var recItem: Record Item; No: Code[20]): Boolean
    var
        frmItemList: Page "Item List";
    begin
        Clear(frmItemList);
        if No <> '' then
            if recItem.Get(No) then
                frmItemList.SetRecord(recItem);
        frmItemList.SetTableview(recItem);
        frmItemList.LookupMode(true);
        if frmItemList.RunModal = Action::LookupOK then begin
            frmItemList.GetRecord(recItem);
            exit(true)
        end;
        exit(false)
    end;


    procedure LookUpGLAccount(var recGLAccount: Record "G/L Account"; No: Code[20]): Boolean
    var
        frmGLAccountList: Page "G/L Account List";
    begin
        Clear(frmGLAccountList);
        if No <> '' then
            if recGLAccount.Get(No) then
                frmGLAccountList.SetRecord(recGLAccount);
        frmGLAccountList.SetTableview(recGLAccount);
        frmGLAccountList.LookupMode(true);
        if frmGLAccountList.RunModal = Action::LookupOK then begin
            frmGLAccountList.GetRecord(recGLAccount);
            exit(true)
        end;
        exit(false)
    end;


    procedure LookUpFixedAsset(var recFixedAsset: Record "Fixed Asset"; No: Code[20]): Boolean
    var
        frmFAList: Page "Fixed Asset List";
    begin
        Clear(frmFAList);
        if No <> '' then
            if recFixedAsset.Get(No) then
                frmFAList.SetRecord(recFixedAsset);
        frmFAList.SetTableview(recFixedAsset);
        frmFAList.LookupMode(true);
        if frmFAList.RunModal = Action::LookupOK then begin
            frmFAList.GetRecord(recFixedAsset);
            exit(true)
        end;
        exit(false)
    end;


    procedure LookUpChargeItem_Purch(var recChargeItem: Record "Item Charge"; No: Code[20]): Boolean
    var
        frmItemCharges: Page "Item Charges";
    begin
        Clear(frmItemCharges);
        if No <> '' then
            if recChargeItem.Get(No) then
                frmItemCharges.SetRecord(recChargeItem);
        frmItemCharges.SetTableview(recChargeItem);
        frmItemCharges.LookupMode(true);
        if frmItemCharges.RunModal = Action::LookupOK then begin
            frmItemCharges.GetRecord(recChargeItem);
            exit(true)
        end;
        exit(false)
    end;


    procedure LookUpItemCharges_Sale(var recChargeItem: Record "Item Charge"; No: Code[20]): Boolean
    var
        frmItemCharges: Page "Item Charges";
    begin
        Clear(frmItemCharges);
        if No <> '' then
            if recChargeItem.Get(No) then
                frmItemCharges.SetRecord(recChargeItem);
        frmItemCharges.SetTableview(recChargeItem);
        frmItemCharges.LookupMode(true);
        if frmItemCharges.RunModal = Action::LookupOK then begin
            frmItemCharges.GetRecord(recChargeItem);
            exit(true)
        end;
        exit(false)
    end;


    procedure LookUpNonstockItem(var recNonstockItem: Record "Nonstock Item"; No: Code[20]): Boolean
    var
        frmNonstockItemList: Page "Catalog Item List";
    begin
        Clear(frmNonstockItemList);
        if No <> '' then
            if recNonstockItem.Get(No) then
                frmNonstockItemList.SetRecord(recNonstockItem);
        frmNonstockItemList.SetTableview(recNonstockItem);
        frmNonstockItemList.LookupMode(true);
        if frmNonstockItemList.RunModal = Action::LookupOK then begin
            frmNonstockItemList.GetRecord(recNonstockItem);
            exit(true)
        end;
        exit(false)
    end;


    procedure LookUpNonstockItemByItem(var NonstockItem: Record "Nonstock Item"; codItemNo: Code[20]): Boolean
    var
        frmNonstockItemList: Page "Catalog Item List";
        NonstockItem2: Record "Nonstock Item";
    begin
        Clear(frmNonstockItemList);
        if codItemNo <> '' then begin
            NonstockItem2.Reset;
            NonstockItem2.SetCurrentkey("Item No.");
            NonstockItem2.SetRange("Item No.", codItemNo);
            if NonstockItem2.FindFirst then begin
                NonstockItem.SetCurrentkey("Entry No.");
                if NonstockItem.Get(NonstockItem2."Entry No.") then
                    frmNonstockItemList.SetRecord(NonstockItem);
            end;
        end;
        frmNonstockItemList.SetTableview(NonstockItem);
        frmNonstockItemList.LookupMode(true);
        if frmNonstockItemList.RunModal = Action::LookupOK then begin
            frmNonstockItemList.GetRecord(NonstockItem);
            exit(true)
        end;
        exit(false)
    end;


    procedure LookUpItemDiscountGroup(var recItemDiscGroup: Record "Item Discount Group"; codCode: Code[20]): Boolean
    var
        frmItemDiscGroup: Page "Item Disc. Groups";
    begin
        Clear(frmItemDiscGroup);
        if codCode <> '' then
            if recItemDiscGroup.Get(codCode) then
                frmItemDiscGroup.SetRecord(recItemDiscGroup);
        frmItemDiscGroup.SetTableview(recItemDiscGroup);
        frmItemDiscGroup.LookupMode(true);
        if frmItemDiscGroup.RunModal = Action::LookupOK then begin
            frmItemDiscGroup.GetRecord(recItemDiscGroup);
            exit(true)
        end;
        exit(false)
    end;


    procedure LookUpVehicleAccCycle(var recVehAccCycle: Record "Vehicle Accounting Cycle"; codSerialNo: Code[20]; codAccCycle: Code[20]): Boolean
    var
        frmVehAccCycle: Page "Vehicle Accounting Cycles";
    begin
        Clear(frmVehAccCycle);
        if (codAccCycle <> '') then
            if recVehAccCycle.Get(codAccCycle) then
                frmVehAccCycle.SetRecord(recVehAccCycle);

        if codSerialNo <> '' then begin
            recVehAccCycle.SetCurrentkey("Vehicle Serial No.");
            recVehAccCycle.SetRange("Vehicle Serial No.", codSerialNo);
        end;

        frmVehAccCycle.SetTableview(recVehAccCycle);
        frmVehAccCycle.LookupMode(true);
        if frmVehAccCycle.RunModal = Action::LookupOK then begin
            frmVehAccCycle.GetRecord(recVehAccCycle);
            exit(true)
        end;
        exit(false)
    end;


    procedure LookUpVariableField(var VFOption: Record "Variable Field Options"; TableNo: Integer; FieldNo: Integer; MakeCode: Code[20]; VFValue: Code[20]): Boolean
    var
        VFOptions: Page "Variable Field Options";
        VFUsage: Record "Variable Field Usage";
        VFCode: Code[10];
        VF: Record "Variable Field";
    begin
        VFUsage.Reset;

        if VFUsage.Get(TableNo, FieldNo) then
            VFCode := VFUsage."Variable Field Code"
        else
            exit(false);

        VF.Reset;
        VF.Get(VFCode);
        if VF."Make Dependent Lookup" then
            VFOption.SetRange("Make Code", MakeCode);
        VFOption.SetRange("Variable Field Code", VFCode);

        Clear(VFOptions);
        VFOptions.SetRecord(VFOption);
        VFOptions.SetTableview(VFOption);
        VFOptions.LookupMode(true);
        if VFOptions.RunModal = Action::LookupOK then begin
            VFOptions.GetRecord(VFOption);
            exit(true)
        end;
        exit(false)
    end;


    procedure LookUpExternalService(var recExternalService: Record "External Service"; codCode: Code[20]): Boolean
    var
        frmExternalServices: Page "External Service List";
    begin
        Clear(frmExternalServices);
        if codCode <> '' then
            if recExternalService.Get(codCode) then
                frmExternalServices.SetRecord(recExternalService);
        frmExternalServices.SetTableview(recExternalService);
        frmExternalServices.LookupMode(true);
        if frmExternalServices.RunModal = Action::LookupOK then begin
            frmExternalServices.GetRecord(recExternalService);
            exit(true)
        end;
        exit(false)
    end;


    procedure LookUpLabor(var recServLabor: Record "Service Labor"; codCode: Code[20]): Boolean
    var
        frmServiceLabor: Page "Service Labor List";
    begin
        Clear(frmServiceLabor);
        if codCode <> '' then
            if recServLabor.Get(codCode) then
                frmServiceLabor.SetRecord(recServLabor);
        frmServiceLabor.SetTableview(recServLabor);
        frmServiceLabor.LookupMode(true);
        if frmServiceLabor.RunModal = Action::LookupOK then begin
            frmServiceLabor.GetRecord(recServLabor);
            exit(true)
        end;
        exit(false)
    end;


    procedure LookUpLaborStandardTime(var recServLaborST: Record "Service Labor Standard Time"; codMakeCode: Code[20]; codLaborCode: Code[20]; intLineNo: Integer): Boolean
    var
        frmServiceLaborST: Page "Service Labor Standard Times";
    begin
        Clear(frmServiceLaborST);
        if intLineNo <> 0 then
            // IF recServLaborST.GET(codMakeCode,codLaborCode,intLineNo) THEN       // 01.04.2014 Elva Baltic P21
            if recServLaborST.Get(codLaborCode, intLineNo) then                      // 01.04.2014 Elva Baltic P21
                frmServiceLaborST.SetRecord(recServLaborST);
        frmServiceLaborST.SetTableview(recServLaborST);
        frmServiceLaborST.LookupMode(true);
        if frmServiceLaborST.RunModal = Action::LookupOK then begin
            frmServiceLaborST.GetRecord(recServLaborST);
            exit(true)
        end;
        exit(false)
    end;


    procedure LookUpVehBodyColor(var VehBodyColor: Record "Body Color"; codCode: Code[20]): Boolean
    var
        VehBodyColors: Page "Body Colors";
    begin
        Clear(VehBodyColors);
        if codCode <> '' then
            if VehBodyColor.Get(codCode) then
                VehBodyColors.SetRecord(VehBodyColor);
        VehBodyColors.SetTableview(VehBodyColor);
        VehBodyColors.LookupMode(true);
        if VehBodyColors.RunModal = Action::LookupOK then begin
            VehBodyColors.GetRecord(VehBodyColor);
            exit(true)
        end;
        exit(false)
    end;


    procedure LookUpVehInterior(var VehInterior: Record "Vehicle Interior"; codCode: Code[20]): Boolean
    var
        VehInteriors: Page "Vehicle Interiors";
    begin
        Clear(VehInteriors);
        if codCode <> '' then
            if VehInterior.Get(codCode) then
                VehInteriors.SetRecord(VehInterior);
        VehInteriors.SetTableview(VehInterior);
        VehInteriors.LookupMode(true);
        if VehInteriors.RunModal = Action::LookupOK then begin
            VehInteriors.GetRecord(VehInterior);
            exit(true)
        end;
        exit(false)
    end;


    procedure LookUpExtService(var ExternalService: Record "External Service"; No: Code[20]): Boolean
    var
        ExtServiceList: Page "External Service List";
    begin
        Clear(ExtServiceList);
        if No <> '' then
            if ExternalService.Get(No) then
                ExtServiceList.SetRecord(ExternalService);
        ExtServiceList.SetTableview(ExternalService);
        ExtServiceList.LookupMode(true);
        if ExtServiceList.RunModal = Action::LookupOK then begin
            ExtServiceList.GetRecord(ExternalService);
            exit(true)
        end;
        exit(false)
    end;


    procedure LookUpServLineGroup(var ServiceLine: Record "Service Line EDMS"; var GroupID: Integer): Boolean
    var
        GroupingServiceLine: Record "Service Line EDMS" temporary;
        LookupServiceLine: Record "Service Line EDMS" temporary;
    begin
        ServiceLine.SetRange(Group, true);
        if ServiceLine.FindFirst then
            repeat
                LookupServiceLine := ServiceLine;
                LookupServiceLine.Insert;
            until ServiceLine.Next = 0;
        if LookupServiceLine.FindFirst then
            if Page.RunModal(Page::"Service Lines - Groups", LookupServiceLine) = Action::LookupOK then
                GroupID := LookupServiceLine."Line No.";
    end;


    procedure LookUpServPackSpecGroup(var PackVersionSpec: Record "Service Package Version Line"; var GroupID: Integer): Boolean
    var
        LookupPackVersionSpec: Record "Service Package Version Line" temporary;
    begin
        PackVersionSpec.SetRange(Group, true);
        if PackVersionSpec.FindFirst then
            repeat
                LookupPackVersionSpec := PackVersionSpec;
                LookupPackVersionSpec.Insert;
            until PackVersionSpec.Next = 0;
        if LookupPackVersionSpec.FindFirst then
            if Page.RunModal(Page::"Serv. Pack. Vers. Spec.-Groups", LookupPackVersionSpec) = Action::LookupOK then
                GroupID := LookupPackVersionSpec."Line No.";
    end;


    procedure LookUpServLineAllocationEntry(ServiceLine: Record "Service Line EDMS")
    var
        LaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        LaborAllocApplication: Record "Serv. Labor Alloc. Application";
    begin
        LaborAllocationEntry.Reset;
        LaborAllocationEntry.ClearMarks;
        LaborAllocApplication.Reset;
        LaborAllocApplication.SetRange("Document Type", ServiceLine."Document Type");
        LaborAllocApplication.SetRange("Document No.", ServiceLine."Document No.");
        LaborAllocApplication.SetRange("Document Line No.", ServiceLine."Line No.");

        if LaborAllocApplication.FindFirst then
            repeat
                LaborAllocationEntry.Get(LaborAllocApplication."Allocation Entry No.");
                LaborAllocationEntry.Mark(true);
            until LaborAllocApplication.Next = 0;

        LaborAllocationEntry.MarkedOnly(true);
        Page.RunModal(Page::"Serv. Labor Allocation Entries", LaborAllocationEntry);
    end;


    procedure LookUpObject(var SourceType: Integer)
    var
        "Object": Record AllObjWithCaption;
        Objects: Page Objects;
    begin
        /*
        Object.RESET;
        Object.SETRANGE(Type, Object.Type::TableData);
        Object.SETRANGE("Company Name", COMPANYNAME);
        */
        //Here can place manual filter for available tables.
        Object.Reset;
        Object.SetRange("Object Type", Object."object type"::TableData);

        if SourceType <> 0 then
            if Object.Get(Object."object type"::TableData, SourceType) then
                Objects.SetRecord(Object);

        Objects.SetTableview(Object);
        Objects.LookupMode(true);
        if Objects.RunModal = Action::LookupOK then begin
            Objects.GetRecord(Object);
            SourceType := Object."Object ID";
        end

    end;
    /*
       
        procedure LookUpReport(var ReportID: Integer)
        var
            "Object": Record "Object";
            Objects: Page Objects;
        begin
            Object.Reset;
            Object.SetRange(Type, Object.Type::Report);

            Objects.LookupMode(true);
            Objects.SetTableview(Object);
            if Objects.RunModal = Action::LookupOK then begin
              Objects.GetRecord(Object);
              ReportID := Object.ID;
            end
        end;
    */

    procedure LookUpReport(var ReportID: Integer)
    var
        "Object": Record "AllObjWithCaption";
        Objects: Page "All Objects with Caption";
    begin
        Object.Reset;
        Object.SetRange("Object Type", Object."Object Type"::Report);

        Objects.LookupMode(true);
        Objects.SetTableview(Object);
        if Objects.RunModal = Action::LookupOK then begin
            Objects.GetRecord(Object);
            ReportID := Object."Object ID";
        end
    end;


    procedure LookUpField(SourceType: Integer; var SourceRef: Integer)
    var
        "Field": Record "Field";
        "Fields": Page "Fields EDMS";
    begin
        Field.SetRange(TableNo, SourceType);
        if SourceRef <> 0 then
            if Field.Get(SourceType, SourceRef) then
                Fields.SetRecord(Field);
        Fields.SetTableview(Field);
        Fields.LookupMode(true);
        if Fields.RunModal = Action::LookupOK then begin
            Fields.GetRecord(Field);
            SourceRef := Field."No.";
        end;
    end;


    procedure LookUpVariableUsageObject(var ObjectID: Integer)
    var
        TempObject: Record "AllObjWithCaption" temporary;
        TempField: Record "Field" temporary;
        WhatToFind: Option "Object","Field";
    begin
        TempObject.Reset;
        TempObject.DeleteAll;

        WhatToFind := Whattofind::Object;
        VariableFieldObjectNoList(TempObject, TempField, WhatToFind);

        if Page.RunModal(Page::Objects, TempObject) = Action::LookupOK then
            ObjectID := TempObject."Object ID";
    end;


    procedure LookUpVariableUsageField(var FieldID: Integer; TableID: Integer)
    var
        TempObject: Record AllObjWithCaption temporary;
        TempField: Record "Field" temporary;
        "Object": Record AllObjWithCaption;
        WhatToFind: Option "Object","Field";
    begin
        TempField.Reset;
        TempField.DeleteAll;

        Object.SetRange("Object Type", Object."Object Type"::Table);
        Object.SetRange("Object ID", TableID);
        if Object.FindFirst then
            TempObject := Object;

        WhatToFind := Whattofind::Field;
        VariableFieldObjectNoList(TempObject, TempField, WhatToFind);

        if Page.RunModal(Page::"Fields EDMS", TempField) = Action::LookupOK then
            FieldID := TempField."No.";
    end;


    procedure VariableFieldObjectNoList(var TempObject: Record AllObjWithCaption temporary; var TempField: Record "Field" temporary; WhatToFind: Option "Object","Field")
    var
        "Object": Record AllObjWithCaption;
        "Field": Record "Field";
        NumberOfObjects: Integer;
        NumberOfFields: Integer;
        TableIDArray: array[60] of Integer;
        FieldIDArray: array[60, 33] of Integer;
        Index: Integer;
        TableIndex: Integer;
    begin
        NumberOfObjects := 60;
        NumberOfFields := 33;
        Clear(TableIDArray);

        TableIDArray[1] := Database::"Sales Header";
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 1, 3, 25006800, 1, 1);
            FillFieldIDArray(FieldIDArray, 1, 3, 25006995, 1, 4);
        end;

        TableIDArray[2] := Database::"Sales Line";
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 2, 3, 25006800, 1, 1);
            FillFieldIDArray(FieldIDArray, 2, 1, 25006389, 1, 4);
            FillFieldIDArray(FieldIDArray, 2, 2, 25006996, 1, 5);  //01.07.2013 EDMS P8
        end;

        TableIDArray[3] := Database::Vehicle;
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 3, 26, 25006800, 1, 1);
            FillFieldIDArray(FieldIDArray, 3, 3, 330, 1, 27);  //01.07.2013 EDMS P8
        end;

        TableIDArray[4] := Database::"VIN Decoding";
        if WhatToFind = Whattofind::Field then
            FillFieldIDArray(FieldIDArray, 4, 16, 25006800, 1, 1);

        TableIDArray[5] := Database::"Model Version Specification";
        if WhatToFind = Whattofind::Field then
            FillFieldIDArray(FieldIDArray, 5, 21, 25006800, 1, 1);

        TableIDArray[6] := Database::"Vehicle Warranty";
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 6, 10, 25006800, 1, 1);
            FillFieldIDArray(FieldIDArray, 6, 3, 70, 1, 11);
        end;

        TableIDArray[7] := Database::"Service Labor";
        if WhatToFind = Whattofind::Field then
            FillFieldIDArray(FieldIDArray, 7, 3, 25006800, 1, 1);

        TableIDArray[8] := Database::"Service Labor Standard Time";
        if WhatToFind = Whattofind::Field then
            FillFieldIDArray(FieldIDArray, 8, 6, 25006800, 1, 1);

        TableIDArray[9] := Database::"Service Price";
        if WhatToFind = Whattofind::Field then
            FillFieldIDArray(FieldIDArray, 9, 1, 25006800, 1, 1);

        TableIDArray[10] := 0; //Database::"SIE Journal Line";
        //if WhatToFind = Whattofind::Field then
        //    FillFieldIDArray(FieldIDArray, 10, 33, 30, 10, 1);

        TableIDArray[11] := 0; //Database::"Recall Campaign Types";
        //if WhatToFind = Whattofind::Field then
        //    FillFieldIDArray(FieldIDArray, 11, 3, 25006800, 1, 1);

        TableIDArray[12] := Database::"Service Labor Text";
        if WhatToFind = Whattofind::Field then
            FillFieldIDArray(FieldIDArray, 12, 2, 25006800, 1, 1);

        TableIDArray[13] := Database::"Service Line EDMS";
        if WhatToFind = Whattofind::Field then
            FillFieldIDArray(FieldIDArray, 13, 3, 25006800, 1, 1);

        TableIDArray[14] := Database::"Posted Serv. Order Line";
        if WhatToFind = Whattofind::Field then
            FillFieldIDArray(FieldIDArray, 14, 3, 25006800, 1, 1);

        TableIDArray[15] := Database::"Posted Serv. Return Order Line";
        if WhatToFind = Whattofind::Field then
            FillFieldIDArray(FieldIDArray, 15, 3, 25006800, 1, 1);

        TableIDArray[16] := Database::"Sales Invoice Header";
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 16, 3, 25006800, 1, 1);
            FillFieldIDArray(FieldIDArray, 16, 3, 25006995, 1, 4);
        end;

        TableIDArray[17] := Database::"Sales Cr.Memo Header";
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 17, 3, 25006800, 1, 1);
            FillFieldIDArray(FieldIDArray, 17, 3, 25006995, 1, 4);
        end;

        TableIDArray[18] := Database::"Service Header EDMS";
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 18, 3, 25006800, 1, 1);
            FillFieldIDArray(FieldIDArray, 18, 1, 25006180, 1, 4);
            FillFieldIDArray(FieldIDArray, 18, 2, 25006255, 5, 5);  //01.07.2013 EDMS P8
        end;

        TableIDArray[19] := Database::"Posted Serv. Order Header";
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 19, 3, 25006800, 1, 1);
            FillFieldIDArray(FieldIDArray, 19, 1, 25006180, 1, 4);
            FillFieldIDArray(FieldIDArray, 19, 2, 25006255, 5, 5);
        end;

        TableIDArray[20] := Database::"Posted Serv. Ret. Order Header";
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 20, 3, 25006800, 1, 1);
            FillFieldIDArray(FieldIDArray, 20, 1, 25006180, 1, 4);
            FillFieldIDArray(FieldIDArray, 20, 2, 25006255, 5, 5);
        end;

        TableIDArray[21] := Database::"Serv. Journal Line";
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 21, 3, 25006800, 1, 1);
            FillFieldIDArray(FieldIDArray, 21, 3, 570, 10, 4);
        end;

        TableIDArray[22] := Database::"Service Ledger Entry EDMS";
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 22, 3, 25006800, 1, 1);
            FillFieldIDArray(FieldIDArray, 22, 3, 570, 10, 4);
        end;

        TableIDArray[23] := Database::"Service Package Version Line";
        if WhatToFind = Whattofind::Field then
            FillFieldIDArray(FieldIDArray, 23, 3, 25006800, 1, 1);

        TableIDArray[24] := Database::"Service Package Version";
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 24, 3, 70, 1, 1);
            FillFieldIDArray(FieldIDArray, 24, 5, 25006800, 1, 4);
        end;

        TableIDArray[25] := Database::"Sales Price";
        if WhatToFind = Whattofind::Field then
            FillFieldIDArray(FieldIDArray, 25, 1, 25006800, 1, 1);

        TableIDArray[26] := Database::"Sales Header Archive";
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 26, 3, 25006800, 1, 1);
            FillFieldIDArray(FieldIDArray, 26, 3, 25006995, 1, 4);
        end;

        TableIDArray[27] := Database::"Service Header Archive";
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 27, 3, 25006800, 1, 1);
            FillFieldIDArray(FieldIDArray, 27, 1, 25006180, 1, 4);
            FillFieldIDArray(FieldIDArray, 27, 2, 25006255, 5, 5);
        end;

        TableIDArray[28] := Database::"Transfer Line";
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 28, 1, 25006390, 1, 1);
            FillFieldIDArray(FieldIDArray, 28, 2, 25006996, 1, 2);
        end;

        TableIDArray[29] := Database::"Vehicle Service Plan Stage";
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 29, 1, 36, 1, 1);
            FillFieldIDArray(FieldIDArray, 29, 5, 250, 10, 2);
        end;

        TableIDArray[30] := Database::"Sales Shipment Line";
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 30, 1, 25006389, 1, 1);
            FillFieldIDArray(FieldIDArray, 30, 2, 25006996, 1, 2);
        end;

        TableIDArray[31] := Database::"Sales Invoice Line";
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 31, 1, 25006389, 1, 1);
            FillFieldIDArray(FieldIDArray, 31, 2, 25006996, 1, 2);
        end;

        TableIDArray[32] := Database::"Sales Cr.Memo Line";
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 32, 1, 25006389, 1, 1);
            FillFieldIDArray(FieldIDArray, 32, 2, 25006996, 1, 2);
            FillFieldIDArray(FieldIDArray, 32, 3, 25006800, 1, 4);
        end;

        TableIDArray[33] := Database::"Sales Line Archive";
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 33, 1, 25006389, 1, 1);
            FillFieldIDArray(FieldIDArray, 33, 2, 25006996, 1, 2);
            FillFieldIDArray(FieldIDArray, 33, 3, 25006800, 1, 4);
        end;

        TableIDArray[34] := Database::"Transfer Shipment Line";
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 34, 1, 25006390, 1, 1);
            FillFieldIDArray(FieldIDArray, 34, 2, 25006996, 1, 2);  //01.07.2013 EDMS P8
        end;

        TableIDArray[35] := Database::"Vehicle Service Plan";
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 35, 1, 161, 1, 1);
            FillFieldIDArray(FieldIDArray, 35, 2, 170, 10, 2);
        end;

        TableIDArray[36] := Database::"Service Splitting Line";
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 36, 3, 25006800, 1, 1);
        end;

        TableIDArray[37] := Database::"Service Plan Template Stage";
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 37, 1, 36, 1, 1);
            FillFieldIDArray(FieldIDArray, 37, 2, 250, 10, 2);
        end;

        TableIDArray[38] := Database::Tire;
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 38, 1, 30, 1, 1);
        end;

        TableIDArray[39] := Database::"Tire Entry";
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 39, 3, 90, 1, 1);
            FillFieldIDArray(FieldIDArray, 39, 1, 120, 1, 4);
        end;

        // 13.02.2015 EDMS P21 >>
        TableIDArray[40] := Database::"Vehicle Warranty Usage";
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 40, 3, 40, 1, 1);
        end;
        // 13.02.2015 EDMS P21 <<

        TableIDArray[41] := Database::"Service Mgt. Setup EDMS"; //25006120
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 41, 3, 25006390, 1, 1);
            FillFieldIDArray(FieldIDArray, 41, 3, 25006310, 1, 4);
        end;

        TableIDArray[42] := Database::"Rent Journal Line"; //25006617
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 42, 3, 570, 10, 1);
        end;

        TableIDArray[43] := Database::"Rent Line"; //25006619
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 43, 6, 1100, 10, 1);
        end;

        TableIDArray[44] := Database::"Rent Sales Line"; //25006620
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 44, 6, 1100, 10, 1);
        end;

        TableIDArray[45] := Database::"Rent Transfer Line"; //25006626
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 45, 3, 570, 10, 1);
            FillFieldIDArray(FieldIDArray, 45, 15, 25006800, 1, 4);
        end;

        TableIDArray[46] := Database::"Vehicle Telematics"; //25006293
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 46, 3, 110, 10, 1);
        end;

        TableIDArray[47] := Database::"Vehicle Type"; //25006032
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 47, 3, 25006310, 1, 1);
        end;

        TableIDArray[48] := Database::"Rent Asset";   //25006630
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 48, 15, 25006800, 1, 1);
        end;

        TableIDArray[49] := Database::"Rent Mgt. Setup";   //25006600
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 49, 3, 243, 1, 1);
            FillFieldIDArray(FieldIDArray, 49, 3, 25006310, 1, 4);
        end;

        TableIDArray[50] := Database::"Rent Item Sales Price"; //25006606
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 50, 2, 130, 1, 1);
            FillFieldIDArray(FieldIDArray, 50, 2, 140, 1, 3);
            FillFieldIDArray(FieldIDArray, 50, 2, 150, 1, 5);
        end;

        TableIDArray[51] := Database::"Rent Period"; //25006608
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 51, 3, 60, 10, 1);
        end;

        TableIDArray[52] := Database::"Posted Rent Transfer Line"; //25006628
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 52, 3, 570, 10, 1);
        end;

        TableIDArray[53] := Database::"Warranty Document Header"; //25006405
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 53, 3, 120, 10, 1);
        end;

        TableIDArray[54] := Database::"Rent Ledger Entry"; //25006612
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 54, 3, 570, 10, 1);
        end;

        TableIDArray[55] := Database::"DMS Contract Line"; //25006218
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 55, 3, 8000, 10, 1);
        end;

        TableIDArray[56] := Database::"BLS Ledger Entry"; //25006222
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 56, 3, 4000, 10, 1);
            FillFieldIDArray(FieldIDArray, 56, 3, 4100, 10, 4);
        end;

        TableIDArray[57] := Database::"BLS Journal Line"; //25006221
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 57, 3, 4000, 10, 1);
            FillFieldIDArray(FieldIDArray, 57, 3, 4100, 10, 4);
        end;

        TableIDArray[58] := Database::"Rent Item Category"; //25006602
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 58, 3, 25006310, 1, 1);
        end;

        TableIDArray[59] := Database::"Rent Billing Worksheet Line"; //25006230
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 59, 6, 1100, 10, 1);
        end;

        TableIDArray[60] := Database::"Vehicle Warranty Type"; //25006035
        if WhatToFind = Whattofind::Field then begin
            FillFieldIDArray(FieldIDArray, 60, 3, 70, 1, 1);
        end;

        if WhatToFind = Whattofind::Object then begin
            Object.SetRange("Object Type", Object."Object Type"::Table);
            for Index := 1 to NumberOfObjects do begin
                Object.SetRange(Object."Object ID", TableIDArray[Index]);
                if Object.FindFirst then begin
                    TempObject := Object;
                    TempObject.Insert;
                end;
            end;
        end else begin
            TableIndex := 0;
            for Index := 1 to NumberOfObjects do
                if TableIDArray[Index] = TempObject."Object ID" then
                    TableIndex := Index;
            if TableIndex = 0 then
                exit;
            Field.SetRange(TableNo, TempObject."Object ID");
            for Index := 1 to NumberOfFields do begin
                if (FieldIDArray[TableIndex] [Index] <> 0) then begin
                    Field.SetRange("No.", FieldIDArray[TableIndex] [Index]);
                    if Field.FindFirst then begin
                        TempField := Field;
                        TempField.Insert;
                    end;
                end;
            end;
        end;
    end;


    procedure FillFieldIDArray(var FieldIDArray: array[50, 33] of Integer; TableID: Integer; FieldQty: Integer; StartNumber: Integer; FieldStep: Integer; StartNrInArray: Integer)
    var
        i: Integer;
        j: Integer;
    begin
        if StartNrInArray < 1 then
            StartNrInArray := 1;
        j := 0;
        for i := StartNrInArray to (FieldQty + StartNrInArray - 1) do begin
            FieldIDArray[TableID] [i] := StartNumber + j * FieldStep;
            j += 1;
        end;
    end;


    procedure ShowSalesDocOfVehicle(DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; VehicleSerialNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        SalesHeader.Reset;
        SalesHeader.SetRange("Document Profile", SalesHeader."document profile"::"Vehicles Trade");

        SalesLine.Reset;
        SalesLine.SetRange("Vehicle Serial No.", VehicleSerialNo);
        SalesLine.SetRange("Document Type", DocumentType);
        SalesLine.SetRange("Document Profile", SalesLine."document profile"::"Vehicles Trade");
        if SalesLine.Find('-') then
            repeat
                if SalesLine."Line Type" = SalesLine."line type"::Vehicle then begin
                    if SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then
                        SalesHeader.Mark := true;
                end;
            until SalesLine.Next = 0;

        SalesHeader.MarkedOnly(true);
        if SalesHeader.Count = 1 then begin
            case DocumentType of  //14.05.2014 Elva Baltic P8 #F036.2 MMG7.00
                                  //Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order
                SalesHeader."document type"::Quote:
                    if Page.RunModal(Page::"Sales Quote", SalesHeader) = Action::None then
                        ;
                SalesHeader."document type"::Order:
                    if Page.RunModal(Page::"Sales Order", SalesHeader) = Action::None then
                        ;
                SalesHeader."document type"::Invoice:
                    if Page.RunModal(Page::"Sales Invoice", SalesHeader) = Action::None then
                        ;
            end;
        end else begin
            case DocumentType of  //14.05.2014 Elva Baltic P8 #F036.2 MMG7.00
                                  //Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order
                SalesHeader."document type"::Quote:
                    if Page.RunModal(Page::"Sales Quotes", SalesHeader) = Action::None then
                        ;
                SalesHeader."document type"::Order:
                    if Page.RunModal(Page::"Sales Order List", SalesHeader) = Action::None then
                        ;
                SalesHeader."document type"::Invoice:
                    if Page.RunModal(Page::"Sales Invoice List", SalesHeader) = Action::None then
                        ;
            end;
        end;
    end;


    procedure ShowSPartsSalesDocOfVehicle(DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; VehicleSerialNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        SalesHeader.Reset;
        SalesHeader.SetRange("Document Profile", SalesHeader."document profile"::"Spare Parts Trade");
        SalesHeader.SetRange("Document Type", DocumentType);  //14.05.2014 Elva Baltic P8 #F036.2 MMG7.00
        SalesHeader.SetRange("Vehicle Serial No.", VehicleSerialNo);
        if SalesHeader.Count = 1 then begin
            case DocumentType of  //14.05.2014 Elva Baltic P8 #F036.2 MMG7.00
                                  //Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order
                SalesHeader."document type"::Quote:
                    if Page.RunModal(Page::"Sales Quote", SalesHeader) = Action::None then
                        ;
                SalesHeader."document type"::Order:
                    if Page.RunModal(Page::"Sales Order", SalesHeader) = Action::None then
                        ;
                SalesHeader."document type"::Invoice:
                    if Page.RunModal(Page::"Sales Invoice", SalesHeader) = Action::None then
                        ;
            end;
        end else begin
            case DocumentType of  //14.05.2014 Elva Baltic P8 #F036.2 MMG7.00
                                  //Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order
                SalesHeader."document type"::Quote:
                    if Page.RunModal(Page::"Sales Quotes", SalesHeader) = Action::None then
                        ;
                SalesHeader."document type"::Order:
                    if Page.RunModal(Page::"Sales Order List", SalesHeader) = Action::None then
                        ;
                SalesHeader."document type"::Invoice:
                    if Page.RunModal(Page::"Sales Invoice List", SalesHeader) = Action::None then
                        ;
            end;
        end;
    end;


    procedure ShowPostedSalesDocOfVehicle(DocumentType: Option Invoice,"Credit Memo",Shipment,"Return Receipt"; VehicleSerialNo: Code[20])
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesShipmentLine: Record "Sales Shipment Line";
        ReturnReceiptHeader: Record "Return Receipt Header";
        ReturnReceiptLine: Record "Return Receipt Line";
    begin
        case DocumentType of
            Documenttype::Invoice:
                begin
                    SalesInvoiceHeader.Reset;
                    SalesInvoiceHeader.SetRange("Document Profile", SalesInvoiceHeader."document profile"::"Vehicles Trade");

                    SalesInvoiceLine.Reset;
                    SalesInvoiceLine.SetRange("Vehicle Serial No.", VehicleSerialNo);
                    SalesInvoiceLine.SetRange("Document Profile", SalesInvoiceLine."document profile"::"Vehicles Trade");
                    if SalesInvoiceLine.FindFirst then
                        repeat
                            if SalesInvoiceLine."Line Type" = SalesInvoiceLine."line type"::Vehicle then begin
                                if SalesInvoiceHeader.Get(SalesInvoiceLine."Document No.") then
                                    SalesInvoiceHeader.Mark := true;
                            end;
                        until SalesInvoiceLine.Next = 0;

                    SalesInvoiceHeader.MarkedOnly(true);
                    if SalesInvoiceHeader.Count = 1 then begin
                        if Page.RunModal(Page::"Posted Sales Invoice", SalesInvoiceHeader) = Action::None then;
                    end else
                        if Page.RunModal(Page::"Posted Sales Invoices", SalesInvoiceHeader) = Action::None then;
                end;
            Documenttype::"Credit Memo":
                begin
                    SalesCrMemoHeader.Reset;
                    SalesCrMemoHeader.SetRange("Document Profile", SalesCrMemoHeader."document profile"::"Vehicles Trade");

                    SalesCrMemoLine.Reset;
                    SalesCrMemoLine.SetRange("Vehicle Serial No.", VehicleSerialNo);
                    SalesCrMemoLine.SetRange("Document Profile", SalesCrMemoLine."document profile"::"Vehicles Trade");
                    if SalesCrMemoLine.FindFirst then
                        repeat
                            if SalesCrMemoLine."Line Type" = SalesCrMemoLine."line type"::Vehicle then begin
                                if SalesCrMemoHeader.Get(SalesCrMemoLine."Document No.") then
                                    SalesCrMemoHeader.Mark := true;
                            end;
                        until SalesCrMemoLine.Next = 0;

                    SalesCrMemoHeader.MarkedOnly(true);
                    if SalesCrMemoHeader.Count = 1 then begin
                        if Page.RunModal(Page::"Posted Sales Credit Memo", SalesCrMemoHeader) = Action::None then;
                    end else
                        if Page.RunModal(Page::"Posted Sales Credit Memos", SalesCrMemoHeader) = Action::None then;
                end;
            Documenttype::Shipment:
                begin
                    SalesShipmentHeader.Reset;
                    SalesShipmentHeader.SetRange("Document Profile", SalesShipmentHeader."document profile"::"Vehicles Trade");

                    SalesShipmentLine.Reset;
                    SalesShipmentLine.SetRange("Vehicle Serial No.", VehicleSerialNo);
                    SalesShipmentLine.SetRange("Document Profile", SalesShipmentLine."document profile"::"Vehicles Trade");
                    if SalesShipmentLine.FindFirst then
                        repeat
                            if SalesShipmentLine."Line Type" = SalesShipmentLine."line type"::Vehicle then begin
                                if SalesShipmentHeader.Get(SalesShipmentLine."Document No.") then
                                    SalesShipmentHeader.Mark := true;
                            end;
                        until SalesShipmentLine.Next = 0;

                    SalesShipmentHeader.MarkedOnly(true);
                    if SalesShipmentHeader.Count = 1 then begin
                        if Page.RunModal(Page::"Posted Sales Shipment", SalesShipmentHeader) = Action::None then;
                    end else
                        if Page.RunModal(Page::"Posted Sales Shipments", SalesShipmentHeader) = Action::None then;
                end;
            Documenttype::"Return Receipt":
                begin
                    ReturnReceiptHeader.Reset;
                    ReturnReceiptHeader.SetRange("Document Profile", ReturnReceiptHeader."document profile"::"Vehicles Trade");

                    ReturnReceiptLine.Reset;
                    ReturnReceiptLine.SetRange("Vehicle Serial No.", VehicleSerialNo);
                    ReturnReceiptLine.SetRange("Document Profile", ReturnReceiptLine."document profile"::"Vehicles Trade");
                    if ReturnReceiptLine.FindFirst then
                        repeat
                            if ReturnReceiptLine."Line Type" = ReturnReceiptLine."line type"::Vehicle then begin
                                if ReturnReceiptHeader.Get(ReturnReceiptLine."Document No.") then
                                    ReturnReceiptHeader.Mark := true;
                            end;
                        until ReturnReceiptLine.Next = 0;

                    ReturnReceiptHeader.MarkedOnly(true);
                    if ReturnReceiptHeader.Count = 1 then begin
                        if Page.RunModal(Page::"Posted Return Receipt", ReturnReceiptHeader) = Action::None then;
                    end else
                        if Page.RunModal(Page::"Posted Return Receipts", ReturnReceiptHeader) = Action::None then;
                end;
        end;
    end;


    procedure ShowSPartsPostedSalesDocOfVehicle(DocumentType: Option Invoice,"Credit Memo",Shipment,"Return Receipt"; VehicleSerialNo: Code[20])
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesShipmentLine: Record "Sales Shipment Line";
        ReturnReceiptHeader: Record "Return Receipt Header";
        ReturnReceiptLine: Record "Return Receipt Line";
    begin
        case DocumentType of
            Documenttype::Invoice:
                begin
                    SalesInvoiceHeader.Reset;
                    SalesInvoiceHeader.SetRange("Document Profile", SalesInvoiceHeader."document profile"::"Spare Parts Trade");
                    SalesInvoiceHeader.SetRange("Vehicle Serial No.", VehicleSerialNo);
                    if SalesInvoiceHeader.Count = 1 then begin
                        if Page.RunModal(Page::"Posted Sales Invoice", SalesInvoiceHeader) = Action::None then;
                    end else
                        if Page.RunModal(Page::"Posted Sales Invoices", SalesInvoiceHeader) = Action::None then;
                end;
            Documenttype::"Credit Memo":
                begin
                    SalesCrMemoHeader.Reset;
                    SalesCrMemoHeader.SetRange("Document Profile", SalesCrMemoHeader."document profile"::"Spare Parts Trade");
                    SalesCrMemoHeader.SetRange("Vehicle Serial No.", VehicleSerialNo);
                    if SalesCrMemoHeader.Count = 1 then begin
                        if Page.RunModal(Page::"Posted Sales Credit Memo", SalesCrMemoHeader) = Action::None then;
                    end else
                        if Page.RunModal(Page::"Posted Sales Credit Memos", SalesCrMemoHeader) = Action::None then;
                end;
            Documenttype::Shipment:
                begin
                    SalesShipmentHeader.Reset;
                    SalesShipmentHeader.SetRange("Document Profile", SalesShipmentHeader."document profile"::"Spare Parts Trade");
                    SalesShipmentHeader.SetRange("Vehicle Serial No.", VehicleSerialNo);
                    if SalesShipmentHeader.Count = 1 then begin
                        if Page.RunModal(Page::"Posted Sales Shipment", SalesShipmentHeader) = Action::None then;
                    end else
                        if Page.RunModal(Page::"Posted Sales Shipments", SalesShipmentHeader) = Action::None then;
                end;
            Documenttype::"Return Receipt":
                begin
                    ReturnReceiptHeader.Reset;
                    ReturnReceiptHeader.SetRange("Document Profile", ReturnReceiptHeader."document profile"::"Spare Parts Trade");
                    ReturnReceiptHeader.SetRange("Vehicle Serial No.", VehicleSerialNo);
                    if ReturnReceiptHeader.Count = 1 then begin
                        if Page.RunModal(Page::"Posted Return Receipt", ReturnReceiptHeader) = Action::None then;
                    end else
                        if Page.RunModal(Page::"Posted Return Receipts", ReturnReceiptHeader) = Action::None then;
                end;
        end;
    end;


    procedure ShowPurchaseDocOfVehicle(DocumentType: Option Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order"; VehicleSerialNo: Code[20])
    var
        PurchaseHeader: Record "Purchase Header";
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseHeader.Reset;
        PurchaseHeader.SetRange("Document Profile", PurchaseHeader."document profile"::"Vehicles Trade");
        PurchaseHeader.SetRange("Document Type", DocumentType);  //14.05.2014 Elva Baltic P8 #F036.2 MMG7.00

        PurchaseLine.Reset;
        PurchaseLine.SetRange("Vehicle Serial No.", VehicleSerialNo);
        PurchaseLine.SetRange("Document Type", DocumentType);
        PurchaseLine.SetRange("Document Profile", PurchaseLine."document profile"::"Vehicles Trade");
        if PurchaseLine.Find('-') then
            repeat
                if PurchaseLine."Line Type" = PurchaseLine."line type"::Vehicle then begin
                    if PurchaseHeader.Get(PurchaseLine."Document Type", PurchaseLine."Document No.") then
                        PurchaseHeader.Mark := true;
                end;
            until PurchaseLine.Next = 0;

        PurchaseHeader.MarkedOnly(true);
        if PurchaseHeader.Count = 1 then begin
            case DocumentType of  //14.05.2014 Elva Baltic P8 #F036.2 MMG7.00
                                  //Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order
                PurchaseHeader."document type"::Quote:
                    if Page.RunModal(Page::"Purchase Quote", PurchaseHeader) = Action::None then
                        ;
                PurchaseHeader."document type"::Order:
                    if Page.RunModal(Page::"Purchase Order", PurchaseHeader) = Action::None then
                        ;
                PurchaseHeader."document type"::Invoice:
                    if Page.RunModal(Page::"Purchase Invoice", PurchaseHeader) = Action::None then
                        ;
            end;
        end else begin
            case DocumentType of  //14.05.2014 Elva Baltic P8 #F036.2 MMG7.00
                                  //Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order
                PurchaseHeader."document type"::Quote:
                    if Page.RunModal(Page::"Purchase Quotes", PurchaseHeader) = Action::None then
                        ;
                PurchaseHeader."document type"::Order:
                    if Page.RunModal(Page::"Purchase Order List", PurchaseHeader) = Action::None then
                        ;
                PurchaseHeader."document type"::Invoice:
                    if Page.RunModal(Page::"Purchase Invoices", PurchaseHeader) = Action::None then
                        ;
            end;
        end;
    end;


    procedure ShowPostedPurchaseDocOfVehicle(DocumentType: Option Invoice,"Credit Memo","Return Shipment",Receipt; VehicleSerialNo: Code[20])
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchInvLine: Record "Purch. Inv. Line";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        PurchCrMemoLine: Record "Purch. Cr. Memo Line";
        ReturnShipmentHeader: Record "Return Shipment Header";
        ReturnShipmentLine: Record "Return Shipment Line";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
        PurchRcptLine: Record "Purch. Rcpt. Line";
    begin
        case DocumentType of
            Documenttype::Invoice:
                begin
                    PurchInvHeader.Reset;
                    PurchInvHeader.SetRange("Document Profile", PurchInvHeader."document profile"::"Vehicles Trade");

                    PurchInvLine.Reset;
                    PurchInvLine.SetRange("Vehicle Serial No.", VehicleSerialNo);
                    PurchInvLine.SetRange("Document Profile", PurchInvHeader."document profile"::"Vehicles Trade");
                    if PurchInvLine.FindFirst then
                        repeat
                            if PurchInvLine."Line Type" = PurchInvLine."line type"::Vehicle then begin
                                if PurchInvHeader.Get(PurchInvLine."Document No.") then
                                    PurchInvHeader.Mark := true;
                            end;
                        until PurchInvLine.Next = 0;

                    PurchInvHeader.MarkedOnly(true);
                    if PurchInvHeader.Count = 1 then begin
                        if Page.RunModal(Page::"Posted Purchase Invoice", PurchInvHeader) = Action::None then;
                    end else
                        if Page.RunModal(Page::"Posted Purchase Invoices", PurchInvHeader) = Action::None then;
                end;
            Documenttype::"Credit Memo":
                begin
                    PurchCrMemoHdr.Reset;
                    PurchCrMemoHdr.SetRange("Document Profile", PurchCrMemoHdr."document profile"::"Vehicles Trade");

                    PurchCrMemoLine.Reset;
                    PurchCrMemoLine.SetRange("Vehicle Serial No.", VehicleSerialNo);
                    PurchCrMemoLine.SetRange("Document Profile", PurchCrMemoHdr."document profile"::"Vehicles Trade");
                    if PurchCrMemoLine.FindFirst then
                        repeat
                            if PurchCrMemoLine."Line Type" = PurchCrMemoLine."line type"::Vehicle then begin
                                if PurchCrMemoHdr.Get(PurchCrMemoLine."Document No.") then
                                    PurchCrMemoHdr.Mark := true;
                            end;
                        until PurchCrMemoLine.Next = 0;

                    PurchCrMemoHdr.MarkedOnly(true);
                    if PurchCrMemoHdr.Count = 1 then begin
                        if Page.RunModal(Page::"Posted Purchase Credit Memo", PurchCrMemoHdr) = Action::None then;
                    end else
                        if Page.RunModal(Page::"Posted Purchase Credit Memos", PurchCrMemoHdr) = Action::None then;
                end;
            Documenttype::"Return Shipment":
                begin
                    ReturnShipmentHeader.Reset;
                    ReturnShipmentHeader.SetRange("Document Profile", ReturnShipmentHeader."document profile"::"Vehicles Trade");

                    ReturnShipmentLine.Reset;
                    ReturnShipmentLine.SetRange("Vehicle Serial No.", VehicleSerialNo);
                    ReturnShipmentLine.SetRange("Document Profile", ReturnShipmentHeader."document profile"::"Vehicles Trade");
                    if ReturnShipmentLine.FindFirst then
                        repeat
                            if ReturnShipmentLine."Line Type" = ReturnShipmentLine."line type"::Vehicle then begin
                                if ReturnShipmentHeader.Get(ReturnShipmentLine."Document No.") then
                                    ReturnShipmentHeader.Mark := true;
                            end;
                        until ReturnShipmentLine.Next = 0;

                    ReturnShipmentHeader.MarkedOnly(true);
                    if ReturnShipmentHeader.Count = 1 then begin
                        if Page.RunModal(Page::"Posted Return Shipment", ReturnShipmentHeader) = Action::None then;
                    end else
                        if Page.RunModal(Page::"Posted Return Shipments", ReturnShipmentHeader) = Action::None then;
                end;
            Documenttype::Receipt:
                begin
                    PurchRcptHeader.Reset;
                    PurchRcptHeader.SetRange("Document Profile", PurchRcptHeader."document profile"::"Vehicles Trade");

                    PurchRcptLine.Reset;
                    PurchRcptLine.SetRange("Vehicle Serial No.", VehicleSerialNo);
                    PurchRcptLine.SetRange("Document Profile", PurchRcptHeader."document profile"::"Vehicles Trade");
                    if PurchRcptLine.FindFirst then
                        repeat
                            if PurchRcptLine."Line Type" = PurchRcptLine."line type"::Vehicle then begin
                                if PurchRcptHeader.Get(PurchRcptLine."Document No.") then
                                    PurchRcptHeader.Mark := true;
                            end;
                        until PurchRcptLine.Next = 0;

                    PurchRcptHeader.MarkedOnly(true);
                    if PurchRcptHeader.Count = 1 then begin
                        if Page.RunModal(Page::"Posted Purchase Receipt", PurchRcptHeader) = Action::None then;
                    end else
                        if Page.RunModal(Page::"Posted Purchase Receipts", PurchRcptHeader) = Action::None then;
                end;
        end;
    end;


    procedure ShowSPartsPostedPurchaseDocOfVehicle(DocumentType: Option Invoice,"Credit Memo","Return Shipment",Receipt; VehicleSerialNo: Code[20])
    var
        PurchInvHeader: Record "Purch. Inv. Header";
        PurchCrMemoHdr: Record "Purch. Cr. Memo Hdr.";
        ReturnShipmentHeader: Record "Return Shipment Header";
        PurchRcptHeader: Record "Purch. Rcpt. Header";
    begin
        /*
        CASE DocumentType OF
          DocumentType::Invoice:
            WITH PurchInvHeader DO BEGIN
              RESET;
              SETRANGE("Document Profile", "Document Profile"::"Spare Parts Trade");
              SETRANGE("Vehicle Serial No.", VehicleSerialNo);
              IF COUNT = 1 THEN BEGIN
                IF PAGE.RUNMODAL(PAGE::"Posted Purchase Invoice", PurchInvHeader) = ACTION::None THEN;
              END ELSE
                IF PAGE.RUNMODAL(PAGE::"Posted Purchase Invoices SP", PurchInvHeader) = ACTION::None THEN;
            END;
          DocumentType::"Credit Memo":
            WITH PurchCrMemoHdr DO BEGIN
              RESET;
              SETRANGE("Document Profile", "Document Profile"::"Spare Parts Trade");
              SETRANGE("Vehicle Serial No.", VehicleSerialNo);
              IF COUNT = 1 THEN BEGIN
                IF PAGE.RUNMODAL(PAGE::"Posted Purchase Cr. Memo", PurchCrMemoHdr) = ACTION::None THEN;
              END ELSE
                IF PAGE.RUNMODAL(PAGE::"Posted Purchase Cr. Memos SP", PurchCrMemoHdr) = ACTION::None THEN;
            END;
          DocumentType::"Return Shipment":
            WITH ReturnShipmentHeader DO BEGIN
              RESET;
              SETRANGE("Document Profile", "Document Profile"::"Spare Parts Trade");
              SETRANGE("Vehicle Serial No.", VehicleSerialNo);
              IF COUNT = 1 THEN BEGIN
                IF PAGE.RUNMODAL(PAGE::"Posted Return Shipment", ReturnShipmentHeader) = ACTION::None THEN;
              END ELSE
                IF PAGE.RUNMODAL(PAGE::"Posted Return Shipments SP", ReturnShipmentHeader) = ACTION::None THEN;
            END;
          DocumentType::Receipt:
            WITH PurchRcptHeader DO BEGIN
              RESET;
              SETRANGE("Document Profile", "Document Profile"::"Spare Parts Trade");
              SETRANGE("Vehicle Serial No.", VehicleSerialNo);
              IF COUNT = 1 THEN BEGIN
                IF PAGE.RUNMODAL(PAGE::"Posted Purchase Receipt", PurchRcptHeader) = ACTION::None THEN;
              END ELSE
                IF PAGE.RUNMODAL(PAGE::"Posted Purchase Receipts SP", PurchRcptHeader) = ACTION::None THEN;
            END;
        END;
        */

    end;


    procedure ShowServiceDocOfVehicle(DocumentType: Option Quote,"Order","Return Order",Invoice; VehicleSerialNo: Code[20])
    var
        SalesHeader: Record "Sales Header";
        ServiceHeader: Record "Service Header EDMS";
    begin
        if DocumentType = Documenttype::Invoice then begin
            SalesHeader.Reset;
            SalesHeader.SetRange("Vehicle Serial No.", VehicleSerialNo);
            SalesHeader.SetRange("Document Type", SalesHeader."document type"::Invoice);
            SalesHeader.SetRange("Document Profile", SalesHeader."document profile"::Service);
            if SalesHeader.Count = 1 then begin
                if Page.RunModal(Page::"Sales Invoice", SalesHeader) = Action::None then;
            end else begin
                if Page.RunModal(Page::"Sales Invoice List (Service)", SalesHeader) = Action::None then;
            end;
        end else begin
            ServiceHeader.Reset;
            ServiceHeader.SetRange("Vehicle Serial No.", VehicleSerialNo);
            ServiceHeader.SetRange("Document Type", DocumentType);
            if ServiceHeader.Count = 1 then begin
                case ServiceHeader."Document Type" of
                    //Quote,Order,Return Order
                    ServiceHeader."document type"::Quote:
                        if Page.RunModal(Page::"Service Quote EDMS", ServiceHeader) = Action::None then
                            ;
                    ServiceHeader."document type"::Order:
                        if Page.RunModal(Page::"Service Order EDMS", ServiceHeader) = Action::None then
                            ;
                end;
            end else begin
                case ServiceHeader."Document Type" of
                    //Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order
                    ServiceHeader."document type"::Quote:
                        if Page.RunModal(Page::"Service Quotes EDMS", ServiceHeader) = Action::None then
                            ;
                    ServiceHeader."document type"::Order:
                        if Page.RunModal(Page::"Service Orders EDMS", ServiceHeader) = Action::None then
                            ;
                end;
            end;
        end;
    end;


    procedure ShowPostedServiceDocOfVehicle(DocumentType: Option "Order",Invoice,"Credit Memo","Return Order","Transfer Shipment","Transfer Receipt"; VehicleSerialNo: Code[20])
    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        SalesInvoiceLine: Record "Sales Invoice Line";
        PostedServOrderHeader: Record "Posted Serv. Order Header";
        PostedServOrderLine: Record "Posted Serv. Order Line";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        PostedServRetOrderHeader: Record "Posted Serv. Ret. Order Header";
        TransferShipmentHeader: Record "Transfer Shipment Header";
        TransferShipmentLine: Record "Transfer Shipment Line";
        TransferReceiptHeader: Record "Transfer Receipt Header";
        TransferReceiptLine: Record "Transfer Receipt Line";
    begin
        case DocumentType of
            Documenttype::Order:
                begin
                    PostedServOrderHeader.Reset;
                    PostedServOrderHeader.SetRange("Vehicle Serial No.", VehicleSerialNo);
                    if PostedServOrderHeader.Count = 1 then begin
                        if Page.RunModal(Page::"Posted Service Order EDMS", PostedServOrderHeader) = Action::None then;
                    end else
                        if Page.RunModal(Page::"Posted Service Orders EDMS", PostedServOrderHeader) = Action::None then;
                end;
            Documenttype::Invoice:
                begin
                    SalesInvoiceHeader.Reset;
                    SalesInvoiceHeader.SetRange("Document Profile", SalesInvoiceHeader."document profile"::Service);
                    SalesInvoiceHeader.SetRange("Vehicle Serial No.", VehicleSerialNo);
                    if SalesInvoiceHeader.Count = 1 then begin
                        if Page.RunModal(Page::"Posted Sales Invoice", SalesInvoiceHeader) = Action::None then;
                    end else
                        if Page.RunModal(Page::"Posted Sales Invoices (Serv.)", SalesInvoiceHeader) = Action::None then;
                end;
            Documenttype::"Credit Memo":
                begin
                    SalesCrMemoHeader.Reset;
                    SalesCrMemoHeader.SetRange("Document Profile", SalesCrMemoHeader."document profile"::Service);
                    SalesCrMemoHeader.SetRange("Vehicle Serial No.", VehicleSerialNo);
                    if SalesCrMemoHeader.Count = 1 then begin
                        if Page.RunModal(Page::"Posted Sales Credit Memo", SalesCrMemoHeader) = Action::None then;
                    end else
                        if Page.RunModal(Page::"Posted Sales Cr.Memos (Serv.)", SalesCrMemoHeader) = Action::None then;
                end;
            Documenttype::"Return Order":
                begin
                    PostedServRetOrderHeader.Reset;
                    PostedServRetOrderHeader.SetRange("Vehicle Serial No.", VehicleSerialNo);
                    if PostedServRetOrderHeader.Count = 1 then begin
                        if Page.RunModal(Page::"Posted Service Ret.Order EDMS", PostedServRetOrderHeader) = Action::None then;
                    end else
                        if Page.RunModal(Page::"Posted Service Ret.Orders EDMS", PostedServRetOrderHeader) = Action::None then;
                end;
            Documenttype::"Transfer Shipment":
                begin
                    TransferShipmentHeader.Reset;
                    TransferShipmentHeader.SetRange("Document Profile", TransferShipmentHeader."document profile"::Service);

                    TransferShipmentLine.Reset;
                    TransferShipmentLine.SetRange("Vehicle Serial No.", VehicleSerialNo);
                    TransferShipmentLine.SetRange("Document Profile", TransferShipmentLine."document profile"::Service);
                    if TransferShipmentLine.FindFirst then
                        repeat
                            if TransferShipmentHeader.Get(TransferShipmentLine."Document No.") then
                                TransferShipmentHeader.Mark := true;
                        until TransferShipmentLine.Next = 0;

                    TransferShipmentHeader.MarkedOnly(true);
                    if TransferShipmentHeader.Count = 1 then begin
                        if Page.RunModal(Page::"Posted Transfer Shipment", TransferShipmentHeader) = Action::None then;
                    end else
                        if Page.RunModal(Page::"Posted Transf. Shpmnts (Serv.)", TransferShipmentHeader) = Action::None then;
                end;
            Documenttype::"Transfer Receipt":
                begin
                    TransferReceiptHeader.Reset;
                    TransferReceiptHeader.SetRange("Document Profile", TransferReceiptHeader."document profile"::Service);

                    TransferReceiptLine.Reset;
                    TransferReceiptLine.SetRange("Vehicle Serial No.", VehicleSerialNo);
                    TransferReceiptLine.SetRange("Document Profile", TransferShipmentLine."document profile"::Service);
                    if TransferReceiptLine.FindFirst then
                        repeat
                            if TransferReceiptHeader.Get(TransferReceiptLine."Document No.") then
                                TransferReceiptHeader.Mark := true;
                        until TransferReceiptLine.Next = 0;

                    TransferReceiptHeader.MarkedOnly(true);
                    if TransferReceiptHeader.Count = 1 then begin
                        if Page.RunModal(Page::"Posted Transfer Receipt", TransferReceiptHeader) = Action::None then;
                    end else
                        if Page.RunModal(Page::"Posted Transf. Rcpts (Serv.)", TransferReceiptHeader) = Action::None then;
                end;
        end;
    end;


    procedure LookUpResource(var Resource: Record Resource; No: Code[20]): Boolean
    var
        ResourceList: Page "Resource List";
    begin
        Clear(ResourceList);
        if No <> '' then
            if Resource.Get(No) then
                ResourceList.SetRecord(Resource);
        ResourceList.SetTableview(Resource);
        ResourceList.LookupMode(true);
        if ResourceList.RunModal = Action::LookupOK then begin
            ResourceList.GetRecord(Resource);
            exit(true)
        end;
        exit(false)
    end;
}

