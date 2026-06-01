Codeunit 25006870 "TCard Management"
{

    trigger OnRun()
    begin
    end;

    var
        CantMoveOrderToBookingErr: label 'It''s not possible to convert Order to Booking.';
        ValidateResourceWorktimeErr: label 'Resource %1 have to start work time first.';
        LocationCode: Code[20];
        EditMode: Boolean;
        NewContainerTxt: label 'New Container';


    procedure ItemToContainerChange(ContainerEntryNo: Integer; ItemEntryNo: Code[20]; ItemEntryType: Option; ItemSortIndex: Integer)
    var
        ServiceBooking: Record "Service Header EDMS";
        ServiceOrder: Record "Service Header EDMS";
        TCardContainer: Record "TCard Container";
        ServiceBookingToOrder: Codeunit "Service Booking to Order (Y/N)";
        ResourceTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
    begin
        if TCardContainer.Get(ContainerEntryNo) then begin
            if ServiceBooking.Get(ItemEntryType, ItemEntryNo) then begin
                if (TCardContainer.Type = TCardContainer.Type::Booking) and
                  (ServiceBooking."Document Type" <> ServiceBooking."document type"::Booking) then begin
                    Error(CantMoveOrderToBookingErr);
                end;
                if (TCardContainer.Type = TCardContainer.Type::Order) and
                  (ServiceBooking."Document Type" <> ServiceBooking."document type"::Order) then begin
                    //Convert Booking to order
                    ServiceBooking."TCard Container Entry No." := ContainerEntryNo;
                    if ServiceBookingToOrder.ServiceBookingToOrderYN(ServiceBooking, ServiceOrder) then begin
                        ServiceOrder."TCard Container Entry No." := ContainerEntryNo;
                        ServiceOrder.Modify;
                        //Create allocation
                        AddAllocationForOrder(ServiceOrder);
                    end;
                end else begin
                    ServiceBooking."TCard Container Entry No." := ContainerEntryNo;
                    ServiceBooking.Modify;
                end;
                if (TCardContainer.Type = TCardContainer.Type::Order) and
                 (ServiceBooking."Document Type" <> ServiceBooking."document type"::Order) then
                    UpdateItemSortIndex(ContainerEntryNo, ServiceOrder."No.", ServiceOrder."Document Type", ItemSortIndex)
                ELSE
                    UpdateItemSortIndex(ContainerEntryNo, ItemEntryNo, ItemEntryType, ItemSortIndex);
            end;
        end;
    end;


    procedure FillAddInData(var AddInDataToFill: Text)
    var
        OutStreamData: OutStream;
        InStreamData: InStream;
        ExportXmlPort: XmlPort "Export TCard Data";
        //TempBlob: Record TempBlob temporary;
        TempBlob: Codeunit "Temp Blob";
    // StreamReader: dotnet StreamReader;
    begin
        Clear(AddInDataToFill);
        //TempBlob.Init;
        //TempBlob.Insert;
        //TempBlob.Blob.CreateOutstream(OutStreamData);
        TempBlob.CreateOutStream(OutStreamData);
        ExportXmlPort.SetEditMode(EditMode);
        ExportXmlPort.SetLocationCode(LocationCode);
        ExportXmlPort.SetDestination(OutStreamData);
        ExportXmlPort.SetRefreshInterval(4000);
        ExportXmlPort.SetStartRefresh(True);
        if ExportXmlPort.Export then begin
            //TempBlob.CalcFields(Blob);
            //TempBlob.Blob.CreateInstream(InStreamData);
            //   TempBlob.CreateInstream(InStreamData);
            InStreamData := TempBlob.CreateInstream(TextEncoding::UTF8);
            // StreamReader := StreamReader.StreamReader(InStreamData, true);
            // AddInDataToFill.AddText(StreamReader.ReadToEnd());
            InStreamData.Read(AddInDataToFill);
        end;
    end;


    procedure AddAllocationForOrder(ServiceHeader: Record "Service Header EDMS")
    var
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        ServLaborAllocationApp: Record "Serv. Labor Alloc. Application";
        ServiceLine: Record "Service Line EDMS" temporary;
        ResourceNo: Code[20];
        StartDateTime: Decimal;
        QtyToAllocate: Decimal;
        Duration: Duration;
        DivideIntoLines: Boolean;
        WhatAllocation: Option Header,Line;
        SourceType: Option ,"Service Document","Standard Event";
        Mode: Option "New Allocation","Move Existing","Split Existing","Break";
        LineNo: Integer;
        SourceSubType: Option Qoute,"Order";
        SourceID: Code[20];
        EntryNo: Integer;
        AllocationForm: Page Allocation;
        AllocatedEntryNo: Integer;
        WorkTimeEntry: Record "Resource Work Time Entry";
        ServiceScheduleSetup: Record "Service Schedule Setup";
        DateTimeMgt: Codeunit "Datetime Mgt.";
        ServiceScheduleMgt: Codeunit "Service Schedule Mgt.";
    begin
        ServiceScheduleSetup.Get;
        ResourceNo := ServiceHeader."Booking Resource No.";

        /*
        WorkTimeEntry.RESET;
        WorkTimeEntry.SETCURRENTKEY("Resource No.",Closed);
        WorkTimeEntry.SETRANGE("Resource No.", ResourceNo);
        WorkTimeEntry.SETRANGE(Closed,FALSE);
        IF NOT WorkTimeEntry.FINDLAST THEN
          ERROR(STRSUBSTNO(ValidateResourceWorktimeErr, ResourceNo));
        */

        StartDateTime := DateTimeMgt.Datetime(WorkDate, Time);
        DivideIntoLines := false;
        SourceType := ServLaborAllocationEntry."source type"::"Service Document";
        Mode := Mode::"New Allocation";
        SourceSubType := ServiceHeader."Document Type";
        SourceID := ServiceHeader."No.";
        Clear(ServiceScheduleMgt);

        //ServiceScheduleMgt.CheckForCorrectServHeaderLine(ServiceHeader, ServiceLine, WhatAllocation::Header);
        ServiceLine.SetRange("Document Type", ServiceHeader."Document Type");
        ServiceLine.SetRange("Document No.", ServiceHeader."No.");
        ServiceLine.SetRange("Line No.", 0);

        Clear(AllocationForm);
        AllocationForm.SetParam(0, ResourceNo, StartDateTime, 0, SourceType, SourceSubType, SourceID, 0, ServiceLine, 0);
        AllocationForm.SetInvisibles(1);
        AllocatedEntryNo := AllocationForm.Allocate;
        //IF ServLaborAllocationEntry.GET(AllocatedEntryNo) THEN
        //  AddTimeRegEntry('Start',ServLaborAllocationEntry,ResourceNo);

    end;

    [EventSubscriber(Objecttype::Page, 25006355, 'OnAllocationChangeStatus', '', false, false)]

    procedure ProcessTCardItemOnAllocationsStatusChange(Status: Option Pending,"In Process","Finish All","Finish Part","On Hold"; AllocEntryNo: Integer)
    var
        LaborAllocEntry: Record "Serv. Labor Allocation Entry";
        ServiceOrder: Record "Service Header EDMS";
        TCardContainer: Record "TCard Container";
        ResourceTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
        CurrentUserResourceNo: Code[20];
        MoveToContainerNo: Integer;
    begin
        if LaborAllocEntry.Get(AllocEntryNo) then
            if (LaborAllocEntry."Source ID" <> '') and (LaborAllocEntry."Source Subtype" = LaborAllocEntry."source subtype"::Order) then
                if ServiceOrder.Get(ServiceOrder."document type"::Order, LaborAllocEntry."Source ID") then begin
                    case Status of
                        Status::"In Process":
                            begin
                                //Change Order to TCards Container Resource
                                if LaborAllocEntry."Resource No." <> '' then begin
                                    //CurrentUserResourceNo := ResourceTimeRegMgt.GetCurrentUserResourceNo;
                                    CurrentUserResourceNo := LaborAllocEntry."Resource No.";
                                    MoveToContainerNo := GetResourceContainerNo(CurrentUserResourceNo, ServiceOrder."Location Code");
                                    if MoveToContainerNo <> 0 then begin
                                        ServiceOrder."TCard Container Entry No." := MoveToContainerNo;
                                        ServiceOrder.Modify;
                                    end;
                                end;
                            end;
                        Status::"Finish All":
                            begin
                                //Change Order to TCards Container Service Person
                                if ServiceOrder."Service Advisor" <> '' then begin
                                    MoveToContainerNo := GetServPersContainerNo(ServiceOrder."Service Advisor", ServiceOrder."Location Code");
                                    ServiceOrder."TCard Container Entry No." := MoveToContainerNo;
                                    ServiceOrder.Modify;
                                end;
                            end;
                    end;
                end;
    end;

    local procedure GetResourceContainerNo(ResourceNo: Code[20]; LocationCode: Code[20]): Integer
    var
        TCardContainer: Record "TCard Container";
    begin
        TCardContainer.Reset;
        TCardContainer.SetRange(Enabled, true);
        TCardContainer.SetRange(Subtype, TCardContainer.Subtype::"In Progress");
        TCardContainer.SetRange(Type, TCardContainer.Type::Order);
        TCardContainer.SetRange("Resource No.", ResourceNo);
        TCardContainer.SetRange("Location Code", LocationCode);
        if not TCardContainer.FindFirst then begin
            TCardContainer.SetRange("Resource No.", '');
            if TCardContainer.FindFirst then;
        end;
        exit(TCardContainer."No.");
    end;

    local procedure GetServPersContainerNo(ServPersNo: Code[20]; LocationCode: Code[20]): Integer
    var
        TCardContainer: Record "TCard Container";
    begin
        TCardContainer.Reset;
        TCardContainer.SetRange(Enabled, true);
        TCardContainer.SetRange(Subtype, TCardContainer.Subtype::"In Progress");
        TCardContainer.SetRange(Type, TCardContainer.Type::Order);
        TCardContainer.SetRange("Service Advisor", ServPersNo);
        TCardContainer.SetRange("Location Code", LocationCode);
        if not TCardContainer.FindFirst then begin
            TCardContainer.SetRange("Service Advisor", '');
            if TCardContainer.FindFirst then;
        end;
        exit(TCardContainer."No.");
    end;


    procedure GetInitialContainerNo(LocationCode: Code[20]): Integer
    var
        TCardContainer: Record "TCard Container";
    begin
        TCardContainer.Reset;
        TCardContainer.SetRange(Enabled, true);
        TCardContainer.SetRange(Type, TCardContainer.Type::Booking);
        TCardContainer.SetRange(Subtype, TCardContainer.Subtype::Initial);
        TCardContainer.SetRange("Location Code", LocationCode);
        if TCardContainer.FindFirst then
            exit(TCardContainer."No.");
    end;


    procedure GetDefaultLocationCode(): Code[20]
    var
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        UserProfile: Record "Branch Profile Setup";
        ServiceLocation: Code[20];
        UserProfileMgt: Codeunit UserProfileManagement;
    begin
        ServiceSetup.Get;
        if UserProfile.Get(UserProfileMgt.CurrProfileID, UserProfileMgt.CurrBranchNo) then begin
            if UserProfile.Get(UserProfile."Spec. Servic Branch Profile", UserProfile."Spec. Branch Code") then begin
                ServiceLocation := UserProfile."Def. Service Location Code";
                if ServiceLocation = '' then
                    ServiceLocation := ServiceSetup."Def. Service Location Code";
            end else begin
                ServiceLocation := UserProfile."Def. Service Location Code";
                if ServiceLocation = '' then
                    ServiceLocation := ServiceSetup."Def. Service Location Code";
            end;
        end else
            ServiceLocation := ServiceSetup."Def. Service Location Code";
        exit(ServiceLocation);
    end;


    procedure SetLocationCode(LocationCodeToSet: Code[20])
    begin
        LocationCode := LocationCodeToSet;
    end;


    procedure SetEditMode(EditModeToSet: Boolean)
    begin
        EditMode := EditModeToSet
    end;


    procedure GetContainerColorCodes(ColorName: Option Blue,Green,Orange,Gray,Yellow; var HeaderColorCode: Text[8]; var BodyColorCode: Text[8])
    begin
        case ColorName of
            Colorname::Blue:
                begin
                    HeaderColorCode := '#99c8e9';
                    BodyColorCode := '#cde6f7';
                end;
            Colorname::Green:
                begin
                    HeaderColorCode := '#9cb56e';
                    BodyColorCode := '#c6dd9d';
                end;
            Colorname::Orange:
                begin
                    HeaderColorCode := '#f6a56b';
                    BodyColorCode := '#f7c7a5';
                end;
            Colorname::Gray:
                begin
                    HeaderColorCode := '#9b9b9b';
                    BodyColorCode := '#e6e6e6';
                end;
            Colorname::Yellow:
                begin
                    HeaderColorCode := '';
                    BodyColorCode := '';
                end;
        end;
    end;


    procedure GetContainerDefaultSize(SizeName: Option Small,Medium,Large,Setup) ContainerSize: Integer
    begin
        case SizeName of
            Sizename::Small:
                ContainerSize := 150;
            Sizename::Medium:
                ContainerSize := 330;
            Sizename::Large:
                ContainerSize := 670;
            Sizename::Setup:
                ContainerSize := 0;
        end;
    end;


    procedure CreateNewContainer()
    var
        Container: Record "TCard Container";
        LineNo: Integer;
    begin
        Container.Reset;
        Container.FindLast;
        LineNo := Container."No." + 100;

        Container.Init;
        Container."No." := LineNo;
        Container."Location Code" := LocationCode;
        Container.Type := Container.Type::Booking;
        Container.Subtype := Container.Subtype::Standard;
        Container.Name := NewContainerTxt;
        Container.Enabled := true;
        Container."Container Size" := Container."container size"::Small;
        Container."Container Color" := Container."container color"::Gray;
        Container.Insert;
    end;


    procedure FormatItemNo(ServiceHeader: Record "Service Header EDMS"): Text
    begin
        exit(Format(ServiceHeader."No."));
    end;


    procedure FormatItemType(ServiceHeader: Record "Service Header EDMS"): Text
    begin
        exit(Format(ServiceHeader."Document Type", 0, 2));
    end;


    procedure FormatItemContainerNo(ServiceHeader: Record "Service Header EDMS"): Text
    begin
        exit(Format(ServiceHeader."TCard Container Entry No."));
    end;


    procedure FormatItemLabel1(ServiceHeader: Record "Service Header EDMS"): Text
    begin
        exit(Format(ServiceHeader."Sell-to Customer Name"));
    end;


    procedure FormatItemText1(ServiceHeader: Record "Service Header EDMS"): Text
    var
        Vehicle: Record Vehicle;
    begin
        if Vehicle.Get(ServiceHeader."Vehicle Serial No.") then
            exit(Format(Vehicle."Make Code"));
    end;


    procedure FormatItemText2(ServiceHeader: Record "Service Header EDMS"): Text
    begin
        exit(Format(ServiceHeader."Vehicle Registration No."));
    end;


    procedure FormatItemText3(ServiceHeader: Record "Service Header EDMS"): Text
    begin
        exit(Format(''));//Te:vienalga kas
    end;

    procedure FormatItemText4(ServiceHeader: Record "Service Header EDMS"): Text
    begin
        exit(Format(ServiceHeader.TCardContSortIdx));
    end;


    procedure FormatItemImage1(ServiceHeader: Record "Service Header EDMS"; var ItemImage1: Text)
    var
        VehiclePicture: Record Picture;
        Data: InStream;
        // MemoryStream: dotnet MemoryStream;
        // Bytes: dotnet Array;
        // Convert: dotnet Convert;
        Vehicle: Record Vehicle;
        VehicleMake: Record Make;
    begin
        exit;
        Clear(ItemImage1);
        if Vehicle.Get(ServiceHeader."Vehicle Serial No.") then begin
            if VehicleMake.Get(Vehicle."Make Code") then begin
                VehicleMake.CalcFields(Icon);
                if not VehicleMake.Icon.Hasvalue then
                    exit;
                VehicleMake.Icon.CreateInstream(Data);
                // MemoryStream := MemoryStream.MemoryStream();
                // CopyStream(MemoryStream, Data);
                // Bytes := MemoryStream.GetBuffer();
                // ItemImage1.AddText(Convert.ToBase64String(Bytes));
            end;
        end;
    end;

    procedure ReindexContainerSortIndex(ContainerEntryNo: Integer)
    var
        ServiceHeader: Record "Service Header EDMS";
        ServiceHeaderTemp: Record "Service Header EDMS" temporary;
        i: Decimal;
    begin
        ServiceHeader.Reset();
        ServiceHeader.SetCurrentKey("TCard Container Entry No.", TCardContSortIdx);
        //ServiceHeader.SetRange("Document Type", ServiceHeader."Document Type"::Jobsheet);
        ServiceHeader.SetRange("TCard Container Entry No.", ContainerEntryNo);
        if ServiceHeader.FindSet() then begin
            repeat
                i := i + 1;
                ServiceHeaderTemp := ServiceHeader;
                ServiceHeaderTemp.TCardContSortIdx := i;
                ServiceHeaderTemp.insert(false);
            until ServiceHeader.next() = 0;
        end;

        If ServiceHeaderTemp.FindSet() then
            repeat
                ServiceHeader.Get(ServiceHeaderTemp."Document Type", ServiceHeaderTemp."No.");
                ServiceHeader.TCardContSortIdx := ServiceHeaderTemp.TCardContSortIdx;
                ServiceHeader.Modify(false);
            until ServiceHeaderTemp.Next() = 0;
    end;


    procedure ResetContainerSortIndex(ContainerEntryNo: Integer)
    var
        ServiceHeader: Record "Service Header EDMS";
    begin
        ServiceHeader.Reset();
        ServiceHeader.SetCurrentKey(TCardContSortIdx, "Document Type", "No.");
        ServiceHeader.SetRange("TCard Container Entry No.", ContainerEntryNo);
        ServiceHeader.SetFilter("Document Type", '%1|%2', ServiceHeader."Document Type"::Booking, ServiceHeader."Document Type"::Order);
        if ServiceHeader.FindFirst() then begin
            repeat
                ServiceHeader.TCardContSortIdx := 0;
                ServiceHeader.Modify();
            until ServiceHeader.next() = 0;
        end;
    end;



    procedure UpdateItemSortIndex(ContainerEntryNo: Integer; ItemEntryNo: Code[20]; ItemEntryType: Option; ItemSortIndex: Integer)
    var
        ServiceHeader: Record "Service Header EDMS";
        CurrServiceHeader: Record "Service Header EDMS";
        TCardContainer: Record "TCard Container";
        PrevIndex: decimal;
        CurrIndex: decimal;
        NextIndex: decimal;
        i: Integer;
        NextRec: integer;
    begin
        if TCardContainer.Get(ContainerEntryNo) then begin
            CurrServiceHeader.get(ItemEntryType, ItemEntryNo);
            ServiceHeader.Reset();
            ServiceHeader.SetCurrentKey(TCardContSortIdx, "Document Type", "No.");
            ServiceHeader.SetRange("TCard Container Entry No.", ContainerEntryNo);
            ServiceHeader.SetFilter("Document Type", '%1|%2', ServiceHeader."Document Type"::Booking, ServiceHeader."Document Type"::Order);
            if ServiceHeader.FindFirst() then begin
                repeat
                    i := i + 1;
                    PrevIndex := CurrIndex;
                    CurrIndex := ServiceHeader.TCardContSortIdx;

                    NextRec := ServiceHeader.Next();
                    if (NextRec <> 0) then
                        NextIndex := ServiceHeader.TCardContSortIdx
                    else
                        NextIndex := CurrIndex + 1;

                    if i = ItemSortIndex then begin
                        if CurrServiceHeader.TCardContSortIdx > CurrIndex then begin
                            CurrServiceHeader.TCardContSortIdx := (CurrIndex - PrevIndex) / 2 + PrevIndex;
                        end else begin
                            CurrServiceHeader.TCardContSortIdx := (NextIndex - CurrIndex) / 2 + CurrIndex;
                        end;
                    end;
                until NextRec = 0;
                CurrServiceHeader.Modify();
            end;
        end;
    end;
}

