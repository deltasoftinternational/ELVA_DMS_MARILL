//>>DELTA 03 (02/09/2022) Add Variant
//>>DELTA 02 (05/01/2022) Correction Fonction CreateAutoReturnTransferOrder exclusion des services
//>>DELTA 01 (25/11/2021) Ajout d'un controle sur le transfert lorsqu'il n'existe aucune ligne à transferer
Codeunit 25006010 "Service Transfer Mgt."
{
    // 28.11.2023 EB.KN
    //   Modified CreateReqLinesFromTransfer
    //     Set Accept Action Message
    //
    // 16.03.2016 EB.P7 Branch Profile Setup
    //   Modified CreateAutoReturnTransferOrder(),CreateTransOrderHByServH() Usert Profile Setup to Branch Profile Setup
    // 
    // 10.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added code to:
    //     CreateAutoReturnTransferOrder
    // 
    // 09.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added code to:
    //     CreateAutoReturnTransferOrder
    // 
    // 01.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added function:
    //     CheckServiceLocation
    //   Added code to:
    //     CreateTransOrderHByServH
    // 
    // 31.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified function:
    //     CreateAutoReturnTransferOrder
    // 
    // 28.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified function:
    //     DeleteTransferLine
    // 
    // 19.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added AutoReserveOutbndQty parameter to function:
    //     FillTransfLinesFromService
    //   Modified functions:
    //     FillTransfLinesFromService
    //     CreateTransferOrder
    //   Added function:
    //     CreateTransferOrderForSplit
    //     DeleteTransferLine
    //     FindTransferLine
    // 
    // 07.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added code to:
    //     CreateTransOrderHByServH (to add Transfer Lines to existing Transfer Order)
    //     CreateTransferOrder
    //   Added function:
    //     ReserveTransfOrderQtyOutbnd
    // 
    // 15.01.2014 EDMS P8
    //   * Only return lines with quantity to return


    trigger OnRun()
    var
        SrvLine: Record "Service Line EDMS";
        SlsLine: Record "Sales Line";
        ItemLedgerEntryTr: Record "Item Ledger Entry";
        decQtyToTakeAway: Decimal;
    begin
    end;

    var
        Text011: label 'To Service (Inbound),From Service (Outbound)';
        Text015: label 'Do you want to fill transfer order lines?';
        GlobalServLine: Record "Service Line EDMS";
        UserProfileMgt: Codeunit UserProfileManagement;
        UserProfile: Record "Branch Profile Setup";
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        ChangedService: Boolean;
        Text016: label 'Transfer Order No. %1 is successfully created!';
        Text017: label 'Transfer Lines added to Transfer Order No. %1!';
        ReserveTransferLine: Codeunit "Transfer Line-Reserve";
        ReleaseTransferDoc: Codeunit "Release Transfer Document";
        Text018: label 'Exist Shipped Transfer Line!';
        OrderPromisingType: Integer;
        OrderPromisingID: Code[20];
        SourceLineNo: Integer;
        OrderPromisingLineNo: Integer;
        ReturnValue: Option CustomerNo,VIN,DealType,CustomerName,OrderingPriceType;


    procedure FillTransfLinesFromService(TransferHeader: Record "Transfer Header"; AutoReserveOutbndQty: Boolean; SparePartLocation: Code[20])
    var
        TransferLine: Record "Transfer Line";
        LineNo: Integer;
        ServiceLine: Record "Service Line EDMS";
        //  ReservationMgt: Codeunit "Reservation Management";
        ReservationMgtEDMS: Codeunit "Reservation Management EDMS";
        QtyTransfered: Decimal;
        Item: Record Item;
        IsHandled: Boolean;
    begin
        // LineNo := 10000;                                                              // 19.03.2014 Elva Baltic P21
        LineNo := 0;                                                                     // 19.03.2014 Elva Baltic P21
        TransferLine.Reset;
        TransferLine.SetRange("Document No.", TransferHeader."No.");
        if TransferLine.FindLast then
            LineNo += TransferLine."Line No.";

        if IsServiceLocation(TransferHeader."Transfer-from Code") then begin
            //Taking global service line variable to handle only selected lines
            GlobalServLine.SetRange("Document Type", TransferHeader."Source Subtype");
            GlobalServLine.SetRange("Document No.", TransferHeader."Source No.");
            GlobalServLine.SetRange(Type, GlobalServLine.Type::Item);
            //<< BHA 26/12/20222
            OnBeforeCreateTransferFromLine(GlobalServLine, TransferHeader);
            //>> BHA 26/12/2022
            if GlobalServLine.FindFirst then
                repeat
                    Item.get(GlobalServLine."No.");
                    if Item.type = Item.type::Inventory then begin
                        GlobalServLine.CalcFields("Reserved Quantity");
                        if GlobalServLine."Reserved Quantity" > 0 then begin
                            LineNo += 10000;
                            if GlobalServLine."Qty. to Return" <> 0 then begin  //15.01.2014 EDMS P8
                                CreateTransferLine(TransferHeader,
                                                TransferLine,
                                                LineNo,
                                                GlobalServLine."No.",
                                                //>>DELTA 03
                                                GlobalServLine."Variant Code",
                                                GlobalServLine."Qty. to Return");
                                //<< BHA 13/03/2023
                                TransferLine.Validate("Unit of Measure Code", ServiceLine."Unit of Measure Code"); // ADD BY DELT BUG MEASURE CODE
                                OnAfterCreateTransferFromLine(TransferLine, GlobalServLine);
                                //>> BHA 13/03/2023
                                //Changing reservations in 4 steps
                                //Step 1: Saving the initial Quantity Transfered
                                QtyTransfered := GlobalServLine.CalcTransferedQuantity;
                                //Step 2: Canceling all Service Line reservations to Item Ledger Entries (Transfered Qty.)
                                ReservationMgtEDMS.CancelServLineRresILE(GlobalServLine);
                                //Step 3: Reserving Service Line to ILE (decreased by Qty.to Return)
                                GlobalServLine.AutoReserveToILE(QtyTransfered - GlobalServLine."Qty. to Return");
                                //Step 4: Auto-Reserve return Transfer Line (Outb.) to Item Ledger Entry
                                TransferLine.AutoReserveSilent(0); //0=Outbound

                                GlobalServLine."Qty. to Return" := 0;
                                GlobalServLine."Transfer From Location Code" := SparePartLocation;
                                GlobalServLine.Modify;
                            end;
                        end;
                    end;
                until GlobalServLine.Next = 0;
        end
        else
            if IsServiceLocation(TransferHeader."Transfer-to Code") then begin
                ServiceSetup.Get;
                ServiceLine.Reset;
                ServiceLine.SetRange("Document Type", TransferHeader."Source Subtype");
                ServiceLine.SetRange("Document No.", TransferHeader."Source No.");
                ServiceLine.SetRange(Type, ServiceLine.Type::Item);
                ServiceLine.SetRange("Location Code", TransferHeader."Transfer-to Code");
                ServiceLine.SetRange("Transfer From Location Code", SparePartLocation);
                //<< BHA 26/12/20222
                OnBeforeCreateTransferToLine(ServiceLine);
                //>> BHA 26/12/2022
                if ServiceLine.FindFirst then
                    repeat
                        Item.get(ServiceLine."No.");
                        if Item.type = Item.type::Inventory then begin
                            ServiceLine.CalcFields("Reserved Quantity");
                            if ServiceLine."Reserved Quantity" < ServiceLine.Quantity then begin
                                IsHandled := false;
                                OnAfterCheckReservedQuantity(ServiceLine, IsHandled);
                                if not ishandled then begin
                                    IsHandled := false;
                                    OnBeforeCreateTransferLine(TransferHeader, TransferLine, LineNo, ServiceLine, IsHandled);
                                    if not IsHandled then begin
                                        LineNo += 10000;
                                        CreateTransferLine(TransferHeader,
                                                        TransferLine,
                                                        LineNo,
                                                        ServiceLine."No.",
                                                        //>>DELTA 03
                                                        ServiceLine."Variant Code",
                                                        ServiceLine.Quantity - ServiceLine."Reserved Quantity");
                                    end;
                                    //<< BHA 13/03/2023
                                    OnAfterCreateTransferToLine(TransferLine, ServiceLine);
                                    //>> BHA 13/03/2023
                                    CheckLineReservation(TransferLine, ServiceLine);
                                    TransferLine.AutoReserveServ(1);
                                    // IF ServiceSetup."Inbound Transf. Auto-Reserve" THEN                            // 19.03.2014 Elva Baltic P21
                                    if ServiceSetup."Inbound Transf. Auto-Reserve" and AutoReserveOutbndQty then      // 19.03.2014 Elva Baltic P21
                                        TransferLine.AutoReserveSilent(0); //Automatically reserves outbound qty. to ILE, PO, etc on Spare Parts Location
                                end;
                            end;
                        end;
                    until ServiceLine.Next = 0;
            end
    end;


    procedure IsServiceLocation(LocationCode: Code[20]): Boolean
    var
        Location: Record Location;
    begin
        if not Location.Get(LocationCode) then
            exit(false);
        exit(Location."Use As Service Location")
    end;


    procedure CreateServLineForTransf(TransferLine: Record "Transfer Line")
    var
        ServLine: Record "Service Line EDMS";
        LineNo: Integer;
    begin
        TransferLine.TestField("Source Type", Database::"Service Line EDMS");
        TransferLine.TestField("Source Subtype");
        TransferLine.TestField("Source No.");

        LineNo := 0;
        ServLine.Reset;
        ServLine.SetRange("Document Type", TransferLine."Source Subtype");
        ServLine.SetRange("Document No.", TransferLine."Source No.");
        if ServLine.FindLast then
            LineNo := ServLine."Line No.";

        ServLine.Init;
        ServLine."Document Type" := TransferLine."Source Subtype";
        ServLine."Document No." := TransferLine."Source No.";
        LineNo += 10000;
        ServLine."Line No." := LineNo;
        ServLine.Insert(true);
        ServLine.Type := ServLine.Type::Item;
        ServLine.Validate("No.", TransferLine."Item No.");
        TransferLine.CalcFields("Reserved Quantity Inbnd.", "Reserved Quantity Outbnd.");
        if IsServiceLocation(TransferLine."Transfer-from Code") then
            ServLine.Validate(Quantity, TransferLine.Quantity - TransferLine."Reserved Quantity Outbnd.")
        else
            if IsServiceLocation(TransferLine."Transfer-to Code") then
                ServLine.Validate(Quantity, TransferLine.Quantity - TransferLine."Reserved Quantity Inbnd.");
        ServLine.Modify(true);
    end;


    procedure LinkTransferWithService(TransferHeader: Record "Transfer Header")
    var
        TransferLine: Record "Transfer Line";
        TransferLine2: Record "Transfer Line";
        LineNo: Integer;
        Direction: Option Outbound,Inbound;
    begin
        TransferLine.Reset;
        TransferLine.SetRange("Document No.", TransferHeader."No.");
        if TransferLine.FindFirst then
            repeat
                TransferLine.CalcFields("Reserved Quantity Inbnd.", "Reserved Quantity Outbnd.");
                if IsServiceLocation(TransferLine."Transfer-from Code") then begin
                    if TransferLine."Reserved Quantity Outbnd." <> TransferLine.Quantity then
                        if not TransferLine.AutoReserveServ(Direction::Outbound) then begin
                            CreateServLineForTransf(TransferLine);
                            TransferLine.AutoReserveServ(Direction::Outbound);
                        end;
                end
                else
                    if IsServiceLocation(TransferLine."Transfer-to Code") then begin
                        if TransferLine."Reserved Quantity Inbnd." <> TransferLine.Quantity then
                            if not TransferLine.AutoReserveServ(Direction::Inbound) then begin
                                CreateServLineForTransf(TransferLine);
                                TransferLine.AutoReserveServ(Direction::Inbound);
                            end
                    end;
            until TransferLine.Next = 0;
    end;


    procedure CreateTransferOrder(ServiceHeader: Record "Service Header EDMS"): Boolean
    var
        TransferHeader: Record "Transfer Header";
        FromLocationCode: Code[20];
        ToLocationCode: Code[20];
        OptionNumber: Integer;
        FromLocation: Code[20];
        ToLocation: Code[20];
        ServLocation: Code[20];
        SparePartLocation: Code[20];
        FillLines: Boolean;
        ServiceLineTmp: Record "Service Line EDMS" temporary;
        TransferCreated: Boolean;
        IsHandled: boolean;
        IsHandledLine: Boolean;
        Err001: Label 'Il n'' y a rien à transférer';
    begin
        OnBeforeFillOptionNumber(OptionNumber, ServiceHeader, IsHandled);
        if not IsHandled then
            OptionNumber := StrMenu(Text011);
        if OptionNumber = 0 then
            exit(false);

        if OptionNumber = 1 then begin
            GetAllSparePartLocations(ServiceHeader, ServiceLineTmp);
            ServiceLineTmp.Reset;
            if ServiceLineTmp.FindFirst then
                repeat
                    SparePartLocation := ServiceLineTmp."Transfer From Location Code";
                    if SparePartLocation = '' then
                        SparePartLocation := GetDefaultSparePartLocation;
                    Clear(TransferHeader);
                    FillLines := CreateTransOrderHByServH(ServiceHeader, TransferHeader, (OptionNumber = 1), SparePartLocation, '', ServiceLineTmp."Location Code", TransferCreated);
                    if FillLines then
                        FillTransfLinesFromService(TransferHeader, true, SparePartLocation);
                until ServiceLineTmp.Next = 0;
        end else begin
            GetDocumentSparePartLocations(ServiceHeader, ServiceLineTmp);
            OnafterGetDocumentSparePartLocations(ServiceHeader, ServiceLineTmp);
            SparePartLocation := GetDefaultSparePartLocation;
            ServiceLineTmp.Reset;
            if ServiceLineTmp.FindFirst then
                repeat
                    Clear(TransferHeader);
                    //FillLines := CreateTransOrderHByServH(ServiceHeader, TransferHeader, (OptionNumber = 1), SparePartLocation, ServiceLineTmp."Location Code", ServiceLineTmp."Location Code", TransferCreated);
                    OnBeforeFillTransfLinesFromService(ServiceHeader, TransferHeader, ServiceLineTmp, TransferCreated, OptionNumber, IsHandledLine);
                    if not IsHandledLine then begin
                        FillLines := CreateTransOrderHByServH(ServiceHeader, TransferHeader, (OptionNumber = 1), SparePartLocation, ServiceLineTmp."Location Code", ServiceLineTmp."Transfer From Location Code", TransferCreated);       //26.04.2024 EB.KN
                        if FillLines then
                            FillTransfLinesFromService(TransferHeader, true, SparePartLocation);
                    end;
                until ServiceLineTmp.Next = 0;
        end;


        Commit;
        //>>DELTA 01
        IF ServiceLineTmp.Count = 0 then
            ERROR(Err001);
        //<<DELTA 01
        IsHandled := false;
        OnBeforeOpenTransferOrder(ServiceHeader, IsHandled);
        if not IsHandled then
            Page.RunModal(Page::"Transfer Order", TransferHeader);


        exit(true)
    end;


    procedure SetTransferLineSelection(var ServLine: Record "Service Line EDMS")
    var
        Item: Record Item;
    begin
        if ServLine.FindFirst then
            repeat
                if ServLine.Type = ServLine.Type::Item then begin
                    if Item.GET(ServLine."No.") and (Item.Type = Item.Type::Inventory) then begin
                        GlobalServLine.Get(ServLine."Document Type", ServLine."Document No.", ServLine."Line No.");
                        GlobalServLine.Mark(true);
                    end;
                end;
            until ServLine.Next = 0;
        GlobalServLine.MarkedOnly(true);
    end;


    //>>DELTA XX
    //procedure CreateTransferLine(var TransferHeader: Record "Transfer Header"; var TransferLine: Record "Transfer Line"; NewLineNo: Integer; ItemNo: Code[20]; Quantity: Decimal)
    //<<DELTA XX

    procedure CreateTransferLine(var TransferHeader: Record "Transfer Header"; var TransferLine: Record "Transfer Line"; NewLineNo: Integer; ItemNo: Code[20]; VariantCode: Code[10]; Quantity: Decimal)
    begin
        TransferLine.Init;
        TransferLine."Document No." := TransferHeader."No.";
        TransferLine."Line No." := NewLineNo;
        TransferLine."Document Profile" := TransferLine."document profile"::Service;
        TransferLine.Validate("Item No.", ItemNo);
        TransferLine."Variant Code" := VariantCode;
        if IsServiceLocation(TransferHeader."Transfer-to Code") then
            CalcAvailability(TransferLine, Quantity);
        TransferLine.Validate(Quantity, Quantity);
        TransferLine.Insert(true);
    end;


    procedure MoveServLineResToTransfOrder(var ServLine: Record "Service Line EDMS"; var TransfLine: Record "Transfer Line")
    var
        ResEntry: Record "Reservation Entry";
        ResEntry2: Record "Reservation Entry";
    begin
        ResEntry.Reset;
        ResEntry.SetCurrentkey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype",
                               "Source Batch Name", "Source Prod. Order Line", "Reservation Status");
        ResEntry.SetRange("Reservation Status", ResEntry."reservation status"::Reservation);
        ResEntry.SetRange("Source Type", Database::"Service Line EDMS");
        ResEntry.SetRange("Source Subtype", ServLine."Document Type");
        ResEntry.SetRange("Source ID", ServLine."Document No.");
        ResEntry.SetRange("Source Ref. No.", ServLine."Line No.");
        if ResEntry.FindFirst then
            repeat
                ResEntry2.Reset;
                ResEntry2.Get(ResEntry."Entry No.", ResEntry.Positive);
                ResEntry2."Source Type" := Database::"Transfer Line";
                ResEntry2."Source Subtype" := 0; //Outbound
                ResEntry2."Source ID" := TransfLine."Document No.";
                ResEntry2."Source Ref. No." := TransfLine."Line No.";
                ResEntry2."Source Prod. Order Line" := 0;
                ResEntry2.Modify;
            until ResEntry.Next = 0;
    end;


    procedure ServLineQtyResToILE(ServLine: Record "Service Line EDMS"): Decimal
    var
        ResEntry: Record "Reservation Entry";
        ResEntry2: Record "Reservation Entry";
        ResQuantity: Decimal;
    begin
        ResEntry.Reset;
        ResEntry.SetCurrentkey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype",
                               "Source Batch Name", "Source Prod. Order Line", "Reservation Status");
        ResEntry.SetRange("Reservation Status", ResEntry."reservation status"::Reservation);
        ResEntry.SetRange("Source Type", Database::"Service Line EDMS");
        ResEntry.SetRange("Source Subtype", ServLine."Document Type");
        ResEntry.SetRange("Source ID", ServLine."Document No.");
        ResEntry.SetRange("Source Ref. No.", ServLine."Line No.");
        if ResEntry.FindFirst then
            repeat
                ResEntry2.Reset;
                ResEntry2.Get(ResEntry."Entry No.", not ResEntry.Positive);
                if ResEntry2."Source Type" = Database::"Item Ledger Entry" then
                    ResQuantity += ResEntry2.Quantity;
            until ResEntry.Next = 0;

        exit(ResQuantity);
    end;


    procedure CreateAutoReturnTransferOrder(var SalesHeader: Record "Sales Header"; Post: Boolean)
    var
        SparePartLocation: Code[20];
        SalesLine: Record "Sales Line";
        FromLocation: Code[20];
        ToLocation: Code[20];
        TransferHeader: Record "Transfer Header";
        TransferLine: Record "Transfer Line";
        LineNo: Integer;
        TransferPostShipment: Codeunit "TransferOrder-Post Shipment";
        TransferPostReceipt: Codeunit "TransferOrder-Post Receipt";
        Item: Record Item;
        TransHeaderInserted: Boolean;
        PostedServiceLine: record "Posted Serv. Order Line";
        LocationBuffer: record Location temporary;
    begin
        ServiceSetup.Get;
        if UserProfile.Get(UserProfileMgt.CurrProfileID, UserProfileMgt.CurrBranchNo) then
            SparePartLocation := UserProfile."Def. Spare Part Location Code";
        if SparePartLocation = '' then
            SparePartLocation := ServiceSetup."Def. Spare Part Location Code";


        //>>DELTA 03
        PostedServiceLine.SetRange("Document No.", SalesHeader."Service Document No.");
        //DELTA 20.11.25
        PostedServiceLine.SetRange(Type, PostedServiceLine.Type::Item);
        //
        IF PostedServiceLine.FindSet() then
            repeat
                if PostedServiceLine."Transfer From Location Code" <> '' then
                    //DELTA 20.11.25
                    if item.Get(PostedServiceLine."No.") then
                        if item.Type = item.Type::Inventory then Begin
                            //
                            LocationBuffer.Init();
                            LocationBuffer.code := PostedServiceLine."Transfer From Location Code";
                            if LocationBuffer.Insert() then;
                        end;
            until PostedServiceLine.Next() = 0;
        if LocationBuffer.Count = 0 then begin
            LocationBuffer.Init();
            LocationBuffer.code := SparePartLocation;
            ;
            if LocationBuffer.Insert() then;

        end;
        //<<DELTA 03

        // 31.03.2014 Elva Baltic P21 >>
        // FromLocation := SparePartLocation;
        // ToLocation := SalesHeader."Location Code";

        FromLocation := SalesHeader."Location Code";
        ToLocation := SparePartLocation;
        if LocationBuffer.FindSet() then begin

            FromLocation := SalesHeader."Location Code";
            ToLocation := LocationBuffer.Code;
            repeat
                // 31.03.2014 Elva Baltic P21 <<

                // 10.04.2014 Elva Baltic P21 >>
                /*
                TransferHeader.RESET;
                TransferHeader.INIT;
                TransferHeader.INSERT(TRUE);
                TransferHeader.VALIDATE("Transfer-from Code",FromLocation);
                TransferHeader.VALIDATE("Transfer-to Code",ToLocation);
                TransferHeader."Document Profile" := TransferHeader."Document Profile"::Service;
                TransferHeader."Source Type" := DATABASE::"Sales Line";
                TransferHeader."Source Subtype" := SalesHeader."Document Type";
                TransferHeader."Source No." := SalesHeader."No.";
                TransferHeader."Posting Date" := SalesHeader."Posting Date";                          // 09.04.2014 Elva Baltic P21
                TransferHeader.MODIFY(TRUE);
                */

                TransHeaderInserted := false;
                // 10.04.2014 Elva Baltic P21 <<

                SalesLine.Reset;
                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                SalesLine.SetRange(Type, SalesLine.Type::Item);
                SalesLine.SetFilter("No.", '<>''''');
                if SalesLine.FindFirst then
                    repeat
                        // 10.04.2014 Elva Baltic P21 >>
                        Item.Get(SalesLine."No.");
                        //DELTA 02
                        //if not TransHeaderInserted then begin
                        if ((not TransHeaderInserted) AND (item.Type = item.Type::Inventory)) then begin
                            TransferHeader.Reset;
                            TransferHeader.Init;
                            TransferHeader.Insert(true);
                            TransferHeader.Validate("Transfer-from Code", FromLocation);
                            TransferHeader.Validate("Transfer-to Code", ToLocation);
                            TransferHeader."Document Profile" := TransferHeader."document profile"::Service;
                            TransferHeader."Source Type" := Database::"Sales Line";
                            TransferHeader."Source Subtype" := SalesHeader."Document Type".AsInteger();
                            TransferHeader."Source No." := SalesHeader."No.";
                            TransferHeader.Validate("Transfer-to Customer No.", SalesHeader."Sell-to Customer No.");
                            if SalesHeader."Vehicle Serial No." <> '' then
                                TransferHeader.Validate("Transfer-to Vehicle Serial No.", SalesHeader."Vehicle Serial No.");
                            TransferHeader."Posting Date" := SalesHeader."Posting Date";
                            TransferHeader.Modify(true);
                            TransHeaderInserted := true;
                        end;
                        // 10.04.2014 Elva Baltic P21 <<
                        //>>DELTA 02 
                        If item.Type = item.Type::Inventory then begin
                            //<<DELTA 02    
                            //>>DELTA 03
                            PostedServiceLine.SetRange("Document No.", SalesHeader."Service Document No.");
                            PostedServiceLine.SetRange("Transfer From Location Code", LocationBuffer.code);
                            PostedServiceLine.SetRange("No.", SalesLine."No.");
                            IF PostedServiceLine.FindSet() then Begin
                                LineNo += 10000;
                                TransferLine.Init;
                                TransferLine."Document No." := TransferHeader."No.";
                                TransferLine."Line No." := LineNo;
                                TransferLine.Validate("Item No.", SalesLine."No.");
                                //>>DELTA 03
                                TransferLine."Variant Code" := SalesLine."Variant Code";
                                //<<DELTA 03
                                TransferLine.Validate(Quantity, SalesLine.Quantity);
                                TransferLine.Insert(true);
                                //>>DELTA 02    
                            end;
                            //<<DELTA 02
                        End;
                    until SalesLine.Next = 0;

                // IF Post THEN BEGIN                                                                        // 10.04.2014 Elva Baltic P21
                if Post and TransHeaderInserted then begin                                                   // 10.04.2014 Elva Baltic P21
                    Clear(TransferPostReceipt);
                    Clear(TransferPostShipment);
                    TransferPostShipment.Run(TransferHeader);
                    TransferPostReceipt.Run(TransferHeader);
                end;

            until LocationBuffer.Next() = 0;
        end;
    end;


    procedure GetServiceChangeInfo(): Boolean
    begin
        exit(ChangedService)
    end;


    procedure CheckLineReservation(TransferLine: Record "Transfer Line"; var ServiceLine: Record "Service Line EDMS")
    var
        TransferHeader: Record "Transfer Header";
        TransferDate: Date;
    begin
        TransferHeader.Get(TransferLine."Document No.");
        if IsServiceLocation(TransferHeader."Transfer-from Code") then
            TransferDate := TransferLine."Shipment Date"
        else
            TransferDate := TransferLine."Receipt Date";

        if (TransferDate > ServiceLine."Planned Service Date") then begin
            ChangedService := true;
            ServiceLine.Validate("Planned Service Date", TransferLine."Receipt Date");
            ServiceLine.Modify;
        end;
    end;


    procedure CalcAvailability(var TransferLine: Record "Transfer Line"; Quantity: Decimal): Decimal
    var
        Item: Record Item;
        Vendor: Record Vendor;
        AvailableToPromise: Codeunit "Available to Promise";
        GrossRequirement: Decimal;
        ScheduledReceipt: Decimal;
        AvailableQty: Decimal;
        PeriodType: Enum "Analysis Period Type";
        AvailabilityDate: Date;
        LookaheadDateformula: DateFormula;
        EmptyDateFormula: DateFormula;
    begin
        if Item.Get(TransferLine."Item No.") then begin
            if TransferLine."Shipment Date" <> 0D then
                AvailabilityDate := TransferLine."Shipment Date"
            else
                AvailabilityDate := WorkDate;

            Item.Reset;
            Item.SetRange("Date Filter", 0D, AvailabilityDate);
            Item.SetRange("Variant Filter", TransferLine."Variant Code");
            Item.SetRange("Location Filter", TransferLine."Transfer-from Code");
            Item.SetRange("Drop Shipment Filter", false);
            if Vendor.Get(Item."Vendor No.") and (Vendor."Lead Time Calculation" <> EmptyDateFormula) then begin
                AvailableQty := AvailableToPromise.CalcQtyAvailableToPromise(Item, GrossRequirement, ScheduledReceipt, AvailabilityDate,
                                          PeriodType, LookaheadDateformula);

                if (Quantity > AvailableQty) then begin
                    TransferLine.Validate("Shipment Date", CalcDate(Vendor."Lead Time Calculation", TransferLine."Shipment Date"));
                end;
            end;

        end;
    end;


    procedure "//--SIE------"()
    begin
    end;


    procedure CreateTransOrderHByServH(ServiceHeader: Record "Service Header EDMS"; var TransferHeader: Record "Transfer Header"; ToServiceLocation: Boolean; SparePartLocation: Code[20]; FromServiceLocation: Code[20]; ToLocationCodeLine: Code[20]; var TransferCreated: Boolean): Boolean
    var
        FromLocationCode: Code[20];
        ToLocationCode: Code[20];
        OptionNumber: Integer;
        FromLocation: Code[20];
        ToLocation: Code[20];
        ServLocation: Code[20];
        FillLines: Boolean;
    begin
        ServiceSetup.Get;
        //UserProfile.GET(UserProfileMgt.CurrProfileID,UserProfileMgt.CurrBranchNo);
        //UserProfile.TESTFIELD("Def. Spare Part Location Code");  //27.03.2013 EDMS P8
        //SparePartLocation := UserProfile."Def. Spare Part Location Code";
        //IF SparePartLocation = '' THEN
        //  SparePartLocation := ServiceSetup."Def. Spare Part Location Code";

        ServiceHeader.TestField("Location Code");                                                     // 01.04.2014 Elva Baltic P21
        CheckServiceLocation(ServiceHeader."Location Code");                                          // 01.04.2014 Elva Baltic P21
        //<<DELTA BCH 07/03/2022
        OnBeforeCreateTransferOrderHByServHeader(ServiceHeader, ToServiceLocation);
        //>>DELTA BCH 07/03/2022

        if ToServiceLocation then begin
            FromLocation := SparePartLocation;
            ToLocation := ToLocationCodeLine;

            case ServiceSetup."Inbound Transfer Line Filling" of
                ServiceSetup."inbound transfer line filling"::Manual:
                    FillLines := false;
                ServiceSetup."inbound transfer line filling"::Prompt:
                    begin
                        if Confirm(Text015, true) then
                            FillLines := true
                        else
                            FillLines := false;
                    end;
                ServiceSetup."inbound transfer line filling"::Automatic:
                    FillLines := true;
            end;
        end
        else begin
            FromLocation := ServiceHeader."Location Code";
            //ToLocation := SparePartLocation; // 20.09.2023 EB.RC
            ToLocation := ToLocationCodeLine;

            case ServiceSetup."Outbound Transfer Line Filling" of
                ServiceSetup."outbound transfer line filling"::Manual:
                    FillLines := false;
                ServiceSetup."outbound transfer line filling"::Prompt:
                    begin
                        if Confirm(Text015, true) then
                            FillLines := true
                        else
                            FillLines := false;
                    end;
                ServiceSetup."outbound transfer line filling"::Automatic:
                    FillLines := true;
            end;

        end;

        // 07.03.2014 Elva Baltic P21 >>
        TransferCreated := false;
        TransferHeader.Reset;
        TransferHeader.SetCurrentkey("Source Type", "Source Subtype", "Source No.", "Document Profile");
        TransferHeader.SetRange("Source Type", Database::"Service Header EDMS");
        TransferHeader.SetRange("Source Subtype", 1);
        TransferHeader.SetRange("Source No.", ServiceHeader."No.");
        TransferHeader.SetRange("Document Profile", TransferHeader."document profile"::Service);
        TransferHeader.SetRange("Transfer-from Code", FromLocation);
        TransferHeader.SetRange("Transfer-to Code", ToLocation);
        if not TransferHeader.FindFirst then begin
            // 07.03.2014 Elva Baltic P21 <<
            TransferHeader.Reset;
            TransferHeader.Init;
            TransferHeader."Document Profile" := TransferHeader."document profile"::Service;//Delta 26.01.2026
            TransferHeader.Insert(true);
            TransferHeader.Validate("Transfer-from Code", FromLocation);
            TransferHeader.Validate("Transfer-to Code", ToLocation);
            // 30.03.2023 Elva DMS KN >>
            if (TransferHeader."In-Transit Code" = '') and (ServiceSetup."Def. In-Transit Location Code" <> '') then
                TransferHeader.Validate("In-Transit Code", ServiceSetup."Def. In-Transit Location Code");
            // 30.03.2023 Elva DMS KN <<
            // TransferHeader."Document Profile" := TransferHeader."document profile"::Service;//Delta 26.01.2026 Moved up before insert
            TransferHeader."Source Type" := Database::"Service Header EDMS";
            TransferHeader."Source Subtype" := ServiceHeader."Document Type";
            TransferHeader."Source No." := ServiceHeader."No.";
            TransferHeader.Validate("Transfer-to Customer No.", ServiceHeader."Sell-to Customer No.");
            if ServiceHeader."Vehicle Serial No." <> '' then
                TransferHeader.Validate("Transfer-to Vehicle Serial No.", ServiceHeader."Vehicle Serial No.");
            TransferHeader.Modify(true);
            // 07.03.2014 Elva Baltic P21 >>
            TransferCreated := true;
        end else
            if TransferHeader.Status = TransferHeader.Status::Released then
                ReleaseTransferDoc.Reopen(TransferHeader);
        // 07.03.2014 Elva Baltic P21 <<

        exit(FillLines)
    end;


    procedure DeleteTransOrderHeadIfEmpty(var TransferHeader: Record "Transfer Header")
    var
        TransferLine: Record "Transfer Line";
    begin
        TransferLine.Reset;
        TransferLine.SetRange("Document No.", TransferHeader."No.");
        if not TransferLine.FindFirst then
            TransferHeader.Delete;
    end;

    /*
        procedure CreateTransferOrderBySIEAssign(ServiceHeader: Record "Service Header EDMS"; var SIEAssignment: Record "SIE Assignment"; ToServiceLocation: Boolean; RunModeFlags: Integer): Boolean
        var
            TransferHeader: Record "Transfer Header";
            FromLocationCode: Code[20];
            ToLocationCode: Code[20];
            OptionNumber: Integer;
            FromLocation: Code[20];
            ToLocation: Code[20];
            ServLocation: Code[20];
            SparePartLocation: Code[20];
            FillLines: Boolean;
            FlagsArray: array[16] of Boolean;
        begin
            //Not used
            AdjustFlagsToArray(RunModeFlags, FlagsArray);
            FillLines := CreateTransOrderHByServH(ServiceHeader, TransferHeader, ToServiceLocation);
            IF FillLines THEN
              FillTransfLinesFromSIEAssign(TransferHeader, SIEAssignment);
            DeleteTransOrderHeadIfEmpty(TransferHeader);  //27.03.2013 EDMS P8
            EXIT(TRUE)


        end;


    procedure FillTransfLinesFromSIEAssign(TransferHeader: Record "Transfer Header"; var SIEAssignment: Record "SIE Assignment")
    var
        TransferLine: Record "Transfer Line";
        LineNo: Integer;
        ServiceLine: Record "Service Line EDMS";
        //ReservationMgt: Codeunit "Reservation Management";
        ReservationMgtEDMS: Codeunit "Reservation Management EDMS";
        QtyTransfered: Decimal;
    begin
        LineNo := 10000;
        TransferLine.Reset;
        TransferLine.SetRange("Document No.", TransferHeader."No.");
        if TransferLine.FindLast then
            LineNo += TransferLine."Line No.";

        if IsServiceLocation(TransferHeader."Transfer-from Code") then begin
            //Taking global service line variable to handle only selected lines
            GlobalServLine.SetRange("Document Type", TransferHeader."Source Subtype");
            GlobalServLine.SetRange("Document No.", TransferHeader."Source No.");
            GlobalServLine.SetRange(Type, GlobalServLine.Type::Item);
            if GlobalServLine.FindFirst then
                if SIEAssignment.FindFirst then;
            repeat
                GlobalServLine.CalcFields("Reserved Quantity");
                if GlobalServLine."Reserved Quantity" > 0 then begin
                    LineNo += 10000;
                    CreateTransferLine(TransferHeader,
                                       TransferLine,
                                       LineNo,
                                       GlobalServLine."No.",
                                       //>>DELTA 03
                                       GlobalServLine."Variant Code",
                                       //<<DELTA 03
                                       GlobalServLine."Qty. to Return");
                    //Changing reservations in 4 steps
                    //Step 1: Saving the initial Quantity Transfered
                    QtyTransfered := GlobalServLine.CalcTransferedQuantity;
                    //Step 2: Canceling all Service Line reservations to Item Ledger Entries (Transfered Qty.)
                    ReservationMgtEDMS.CancelServLineRresILE(GlobalServLine);
                    //Step 3: Reserving Service Line to ILE (decreased by Qty.to Return)
                    GlobalServLine.AutoReserveToILE(QtyTransfered - GlobalServLine."Qty. to Return");
                    //Step 4: Auto-Reserve return Transfer Line (Outb.) to Item Ledger Entry
                    TransferLine.AutoReserveSilent(0); //0=Outbound

                    if GlobalServLine."Qty. to Return" <> 0 then begin
                        GlobalServLine."Qty. to Return" := 0;
                        GlobalServLine.Modify;
                    end;

                end;
            until GlobalServLine.Next = 0;
        end
        else
            if IsServiceLocation(TransferHeader."Transfer-to Code") then begin
                ServiceSetup.Get;
                ServiceLine.Reset;
                ServiceLine.SetRange("Document Type", TransferHeader."Source Subtype");
                ServiceLine.SetRange("Document No.", TransferHeader."Source No.");
                ServiceLine.SetRange(Type, ServiceLine.Type::Item);
                if SIEAssignment.FindFirst then
                    repeat
                        ServiceLine.Get(SIEAssignment."Applies-to Doc. Type", SIEAssignment."Applies-to Doc. No.",
                          SIEAssignment."Applies-to Doc. Line No.");
                        ServiceLine.CalcFields("Reserved Quantity");
                        if ServiceLine."Reserved Quantity" < SIEAssignment."Qty. to Transfer" then begin
                            LineNo += 10000;
                            CreateTransferLine(TransferHeader,
                                               TransferLine,
                                               LineNo,
                                               ServiceLine."No.",
                                               //>>DELTA 03
                                               ServiceLine."Variant Code",
                                               SIEAssignment."Qty. to Transfer" - ServiceLine."Reserved Quantity");
                            CheckLineReservation(TransferLine, ServiceLine);
                            TransferLine.AutoReserveServ(1);
                            if ServiceSetup."Inbound Transf. Auto-Reserve" then
                                TransferLine.AutoReserveSilent(0); //Automatically reserves outbound qty. to ILE, PO, etc on Spare Parts Location
                        end;
                    until SIEAssignment.Next = 0;
            end
    end;
    */

    procedure PostTransOrderHByServH(ServiceHeader: Record "Service Header EDMS"; RunModeFlags: Integer)
    var
        TransHeader: Record "Transfer Header";
        TransferPostShipment: Codeunit "TransferOrder-Post Shipment";
        TransferPostReceipt: Codeunit "TransferOrder-Post Receipt";
    begin
        //AdjustFlagsToArray(RunModeFlags, FlagsArray);
        TransHeader.Reset;
        TransHeader.SetCurrentkey("Source Type", "Source Subtype", "Source No.", "Document Profile");
        TransHeader.SetRange("Source Type", Database::"Service Header EDMS");
        TransHeader.SetRange("Source Subtype", 1);
        TransHeader.SetRange("Source No.", ServiceHeader."No.");
        TransHeader.SetRange("Document Profile", TransHeader."document profile"::Service);
        if TransHeader.FindFirst then
            repeat
                Clear(TransferPostShipment);
                Clear(TransferPostReceipt);
                if not GuiAllowed then
                    Message('NASMSG: is going to TransferPostShipment');
                TransferPostShipment.Run(TransHeader);
                if not GuiAllowed then
                    Message('NASMSG: is going to TransferPostReceipt.');
                TransferPostReceipt.Run(TransHeader);
            until TransHeader.Next = 0;
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


    procedure AdjustFlagsToArray(Flags: Integer; var ArrayEDMS: array[16] of Boolean)
    var
        i: Integer;
    begin
        for i := 1 to 16 do begin
            ArrayEDMS[i] := CutNextBit(Flags);
        end;
    end;


    procedure ReserveTransfOrderQtyOutbnd(TransHeader: Record "Transfer Header")
    var
        TransLine: Record "Transfer Line";
    //ReservationMgt: Codeunit "Reservation Management";
    begin
        TransLine.Reset;
        TransLine.SetRange("Document No.", TransHeader."No.");
        TransLine.SetRange("Derived From Line No.", 0);
        if TransLine.FindSet then
            repeat
                TransLine.CalcFields("Reserved Quantity Outbnd.");
                if TransLine."Reserved Quantity Outbnd." < TransLine.Quantity - TransLine."Quantity Shipped" then
                    TransLine.AutoReserveSilent(0);  //Automatically reserves outbound qty. to ILE, PO, etc on Spare Parts Location
            until TransLine.Next = 0;
    end;


    procedure CreateTransferOrderForSplit(ServiceHeader: Record "Service Header EDMS")
    var
        TransferHeader: Record "Transfer Header";
        OptionNumber: Integer;
        SparePartLocation: Code[20];
        TransferCreated: Boolean;
    begin
        if SparePartLocation = '' then
            SparePartLocation := GetDefaultSparePartLocation;
        CreateTransOrderHByServH(ServiceHeader, TransferHeader, true, SparePartLocation, '', '', TransferCreated);
        FillTransfLinesFromService(TransferHeader, false, SparePartLocation);
    end;


    procedure DeleteTransferLine(ServiceLine: Record "Service Line EDMS")
    var
        ResEntryNegative: Record "Reservation Entry";
        ResEntryPositive: Record "Reservation Entry";
        TransfLine: Record "Transfer Line";
        TransfHeader: Record "Transfer Header";
    begin
        if FindTransferLine(ServiceLine, TransfLine) then begin
            TransfLine.TestField("Quantity Shipped", 0);
            TransfLine.TestField("Quantity Received", 0);
            if TransfLine."Derived From Line No." <> 0 then
                Error(Text018);
            TransfHeader.Get(TransfLine."Document No.");
            if TransfHeader.Status = TransfHeader.Status::Released then begin
                ReleaseTransferDoc.Reopen(TransfHeader);
                TransfLine.Get(TransfLine."Document No.", TransfLine."Line No.");                   // 28.03.2014 Elva Baltic P21
            end;
            ReserveTransferLine.DeleteLine(TransfLine);
            TransfLine.Delete(true);
        end;
    end;


    procedure FindTransferLine(ServiceLine: Record "Service Line EDMS"; var TransfLine: Record "Transfer Line"): Boolean
    var
        ResEntryNegative: Record "Reservation Entry";
        ResEntryPositive: Record "Reservation Entry";
    begin
        ResEntryNegative.Reset;
        ResEntryNegative.SetCurrentkey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
        ResEntryNegative.SetRange("Source ID", ServiceLine."Document No.");
        ResEntryNegative.SetRange("Source Ref. No.", ServiceLine."Line No.");
        ResEntryNegative.SetRange("Source Type", Database::"Service Line EDMS");
        ResEntryNegative.SetRange("Source Subtype", ServiceLine."Document Type");
        ResEntryNegative.SetRange("Reservation Status", ResEntryNegative."reservation status"::Reservation);
        if ResEntryNegative.FindFirst then
            repeat
                if ResEntryPositive.Get(ResEntryNegative."Entry No.", true) then begin
                    if ResEntryPositive."Source Type" = Database::"Transfer Line" then begin
                        if TransfLine.Get(ResEntryPositive."Source ID", ResEntryPositive."Source Ref. No.") then
                            exit(true)
                    end;
                end;
            until ResEntryNegative.Next = 0;
        exit(false);
    end;


    procedure CheckServiceLocation(LocationCode: Code[20]): Boolean
    var
        Location: Record Location;
    begin
        Location.Get(LocationCode);
        Location.TestField("Use As Service Location");
    end;


    procedure GetItemAvailableQtyOnLocation(var SalesLine: Record "Sales Line"; LocationCode: Code[20]) ItemAvailabilityQty: Decimal
    var
        GrossRequirement: Decimal;
        ScheduledReceipt: Decimal;
        PeriodType: Option Day,Week,Month,Quarter,Year;
        LookaheadDateformula: DateFormula;
        SalesInfoPaneMgm: Codeunit "Sales Info-Pane Management";
        AvailableToPromise: Codeunit "Available to Promise";
        Item: Record Item;
        AvailabilityDate: Date;
    begin
        if LocationCode = '' then
            exit;
        if (SalesLine.Type = SalesLine.Type::Item) and (SalesLine."No." <> '') then
            if Item.Get(SalesLine."No.") then begin
                if SalesLine."Shipment Date" <> 0D then
                    AvailabilityDate := SalesLine."Shipment Date"
                else
                    AvailabilityDate := WorkDate;

                Item.Reset;
                Item.SetRange("No.", SalesLine."No.");
                Item.SetRange("Date Filter", 0D, AvailabilityDate);
                Item.SetRange("Variant Filter", SalesLine."Variant Code");
                Item.SetRange("Location Filter", LocationCode);
                //Item.SETRANGE("Drop Shipment Filter",FALSE);
                if Item.FindFirst then begin
                    Item.CalcFields(Inventory, "Reserved Qty. on Inventory");
                    ItemAvailabilityQty := Item.Inventory - Item."Reserved Qty. on Inventory";
                end;
            end;

        /*
        ItemAvailabilityQty := ConvertQty(
            AvailableToPromise.QtyAvailabletoPromise(
              Item,
              GrossRequirement,
              ScheduledReceipt,
              AvailabilityDate,
              PeriodType,
              LookaheadDateformula),
            SalesLine."Qty. per Unit of Measure");
        */

    end;


    procedure GetItemAvailableQtyOnLocationPurchase(var PurchaseLine: Record "Purchase Line"; LocationCode: Code[20]) ItemAvailabilityQty: Decimal
    var
        GrossRequirement: Decimal;
        ScheduledReceipt: Decimal;
        PeriodType: Option Day,Week,Month,Quarter,Year;
        LookaheadDateformula: DateFormula;
        SalesInfoPaneMgm: Codeunit "Sales Info-Pane Management";
        AvailableToPromise: Codeunit "Available to Promise";
        Item: Record Item;
        AvailabilityDate: Date;
    begin
        if LocationCode = '' then
            exit;
        if (PurchaseLine.Type = PurchaseLine.Type::Item) and (PurchaseLine."No." <> '') then
            if Item.Get(PurchaseLine."No.") then begin

                AvailabilityDate := WorkDate;

                Item.Reset;
                Item.SetRange("No.", PurchaseLine."No.");
                Item.SetRange("Date Filter", 0D, AvailabilityDate);
                Item.SetRange("Variant Filter", PurchaseLine."Variant Code");
                Item.SetRange("Location Filter", LocationCode);
                //Item.SETRANGE("Drop Shipment Filter",FALSE);
                if Item.FindFirst then begin
                    Item.CalcFields(Inventory, "Reserved Qty. on Inventory");
                    ItemAvailabilityQty := Item.Inventory - Item."Reserved Qty. on Inventory";
                end;
            end;
    end;


    procedure GetItemAvailableQtyOnLocationService(var ServiceLine: Record "Service Line EDMS"; LocationCode: Code[20]) ItemAvailabilityQty: Decimal
    var
        GrossRequirement: Decimal;
        ScheduledReceipt: Decimal;
        PeriodType: Option Day,Week,Month,Quarter,Year;
        LookaheadDateformula: DateFormula;
        SalesInfoPaneMgm: Codeunit "Sales Info-Pane Management";
        AvailableToPromise: Codeunit "Available to Promise";
        Item: Record Item;
        AvailabilityDate: Date;
    begin
        if LocationCode = '' then
            exit;
        if (ServiceLine.Type = ServiceLine.Type::Item) and (ServiceLine."No." <> '') then
            if Item.Get(ServiceLine."No.") then begin
                if ServiceLine."Shipment Date" <> 0D then
                    AvailabilityDate := ServiceLine."Shipment Date"
                else
                    AvailabilityDate := WorkDate;

                Item.Reset;
                Item.SetRange("No.", ServiceLine."No.");
                Item.SetRange("Date Filter", 0D, AvailabilityDate);
                Item.SetRange("Variant Filter", ServiceLine."Variant Code");
                Item.SetRange("Location Filter", LocationCode);
                //Item.SETRANGE("Drop Shipment Filter",FALSE);
                if Item.FindFirst then begin
                    Item.CalcFields(Inventory, "Reserved Qty. on Inventory");
                    ItemAvailabilityQty := Item.Inventory - Item."Reserved Qty. on Inventory";
                end;
            end;

        /*
        ItemAvailabilityQty := ConvertQty(
            AvailableToPromise.QtyAvailabletoPromise(
              Item,
              GrossRequirement,
              ScheduledReceipt,
              AvailabilityDate,
              PeriodType,
              LookaheadDateformula),
            ServiceLine."Qty. per Unit of Measure");
        */

    end;

    local procedure GetAllSparePartLocations(ServiceHeader: Record "Service Header EDMS"; var ServiceLineTmp: Record "Service Line EDMS")
    var
        ServiceLine: Record "Service Line EDMS";
        LineNo: Integer;
        IsHandled: Boolean;
    begin
        ServiceLine.SetRange("Document No.", ServiceHeader."No.");
        ServiceLine.SetRange("Document Type", ServiceHeader."Document Type");
        ServiceLine.SetRange(Type, ServiceLine.Type::Item);
        //ServiceLine.SETFILTER("Transfer From Location Code",'<>%1',''); //28.03.2018 EB.RC POD
        OnBeforeFindServiceLine(ServiceLine);

        ServiceLineTmp.DeleteAll;

        if ServiceLine.FindFirst then
            repeat
                ServiceLine.CalcFields("Reserved Quantity");
                if (ServiceLine."Transfer From Location Code" <> '') and (ServiceLine."Location Code" <> '') then begin
                    ServiceLineTmp.Reset;
                    ServiceLineTmp.SetRange("Transfer From Location Code", ServiceLine."Transfer From Location Code");
                    ServiceLineTmp.SetRange("Location Code", ServiceLine."Location Code"); //28.03.2018 EB.RC POD
                    if not ServiceLineTmp.FindFirst then begin
                        if ServiceLine.Quantity > ServiceLine."Reserved Quantity" then begin
                            IsHandled := false;
                            OnBeforeInsertServiceLineTmp(ServiceLineTmp, ServiceLine, IsHandled);
                            IF not IsHandled then begin
                                ServiceLineTmp.Init;
                                ServiceLineTmp := ServiceLine;
                                ServiceLineTmp.Insert;
                            end;

                        end;
                    end;
                end;
            until ServiceLine.Next = 0;
    end;

    local procedure GetDocumentSparePartLocations(ServiceHeader: Record "Service Header EDMS"; var ServiceLineTmp: Record "Service Line EDMS")
    var
        ServiceLine: Record "Service Line EDMS";
    begin
        ServiceLine.SetRange("Document No.", ServiceHeader."No.");
        ServiceLine.SetRange("Document Type", ServiceHeader."Document Type");
        ServiceLine.SetRange(Type, ServiceLine.Type::Item);
        ServiceLine.SetFilter("Location Code", '<>%1', '');
        ServiceLine.SetFilter("Qty. to Return", '>0');         // 31.08.2017 EB.AMU POD.DMS.Service
        onBeforeFilterGetDocumentSparePartLocations(ServiceLine);
        ServiceLineTmp.DeleteAll;

        if ServiceLine.FindFirst then
            repeat
                ServiceLineTmp.Reset;
                ServiceLineTmp.SetRange("Location Code", ServiceLine."Location Code");
                if not ServiceLineTmp.FindFirst then begin
                    ServiceLineTmp.Init;
                    ServiceLineTmp := ServiceLine;
                    ServiceLineTmp.Insert;
                end;
            until ServiceLine.Next = 0;
    end;

    local procedure GetDefaultSparePartLocation() SparePartLocation: Code[20]
    var
        UserProfileMgt: Codeunit UserProfileManagement;
        UserProfile: Record "Branch Profile Setup";
        ServiceSetup: Record "Service Mgt. Setup EDMS";
    begin
        ServiceSetup.Get;
        if UserProfile.Get(UserProfileMgt.CurrProfileID, UserProfileMgt.CurrBranchNo) then
            SparePartLocation := UserProfile."Def. Spare Part Location Code";
        if SparePartLocation = '' then
            SparePartLocation := ServiceSetup."Def. Spare Part Location Code";
    end;


    procedure CreateTransferOrderForce(ServiceLine: Record "Service Line EDMS"): Boolean
    var
        TransferHeader: Record "Transfer Header";
        SparePartLocation: Code[20];
        CapabletoPromise: Codeunit "Capable to Promise";
        ReleaseTransferDocument: Codeunit "Release Transfer Document";
        ServiceLineParts: Record "Service Line EDMS";
        PartItem: Record Item;
        PartItemCategory: Record "Item Category";
        ServiceHeader: Record "Service Header EDMS";
        TransferLine: Record "Transfer Line";
        NewLineNo: Integer;
        QuantityToReq: Decimal;
    begin
        ServiceLine.TestField("Location Code");
        ServiceHeader.Get(ServiceLine."Document Type", ServiceLine."Document No.");

        SparePartLocation := ServiceLine."Transfer From Location Code";
        if SparePartLocation = '' then
            SparePartLocation := GetDefaultSparePartLocation;

        ServiceLine.CalcFields("Reserved Quantity");
        QuantityToReq := ServiceLine.Quantity - ServiceLine."Reserved Quantity";
        if (QuantityToReq > 0) then begin
            Clear(TransferHeader);
            TransferHeader.Reset;
            TransferHeader.Init;
            TransferHeader.Insert(true);
            TransferHeader.Validate("Transfer-from Code", SparePartLocation);
            TransferHeader.Validate("Transfer-to Code", ServiceHeader."Location Code");
            TransferHeader."Document Profile" := TransferHeader."document profile"::Service;
            TransferHeader."Source Type" := Database::"Service Header EDMS";
            TransferHeader."Source Subtype" := ServiceHeader."Document Type";
            TransferHeader."Source No." := ServiceHeader."No.";
            TransferHeader.Modify(true);
            TransferLine.Reset;
            TransferLine.SetRange("Document No.", TransferHeader."No.");
            CreateTransferLine(TransferHeader, TransferLine, 10000, ServiceLine."No.", ServiceLine."Variant Code",
            QuantityToReq);
            TransferLine.AutoReserveSilent(1);
            CreateReqLinesFromTransfer(TransferHeader, false, 0);
            ReleaseTransferDocument.Run(TransferHeader);
        end;

        Commit;

        exit(true);
    end;
    // For codeunit 5706 "TransferOrder-Post (Yes/No)"
    procedure GetPostingOptions(var TransHeader: Record "Transfer Header"; var DefaultNumber: Integer; var Selection: Option " ",Shipment,Receipt; var PostShipment: boolean; var PostReceipt: boolean; var PostTransfer: boolean; var PostBatch: Boolean)
    var
        InventorySetup: Record "Inventory Setup";
        TransferOrderPost: enum "Transfer Order Post";
        Text000: Label '&Ship,&Receive';
        Text101: label 'S&hip && Receive,&Ship,&Receive';
        DefaultNumberEDMS: Option " ","Shipment&Receipt",Shipment,Receipt;
    begin
        InventorySetup.Get();

        case true of
            (TransHeader."Direct Transfer") and (InventorySetup."Direct Transfer Posting" = InventorySetup."Direct Transfer Posting"::"Receipt and Shipment"):
                begin
                    PostShipment := true;
                    PostReceipt := true;
                end;
            (TransHeader."Direct Transfer") and (InventorySetup."Direct Transfer Posting" = InventorySetup."Direct Transfer Posting"::"Direct Transfer"):
                PostTransfer := true;
            PostBatch:
                begin
                    PostShipment := TransferOrderPost = TransferOrderPost::Ship;
                    PostReceipt := TransferOrderPost = TransferOrderPost::Receive;
                end;
            else begin
                if DefaultNumber = 0 then
                    DefaultNumber := 1;
                //EDMS>> - Service Management Integration >>
                if TransHeader."Document Profile" = TransHeader."document profile"::Service then begin
                    if DefaultNumber = 2 then
                        DefaultNumberEDMS := Defaultnumberedms::Receipt
                    else
                        DefaultNumberEDMS := Defaultnumberedms::"Shipment&Receipt";
                    Selection := StrMenu(Text101, DefaultNumberEDMS);
                    case Selection of
                        0:
                            exit;
                        1:
                            begin
                                PostShipment := true;
                                PostReceipt := true;
                                //PostTransfer := true;
                            end;
                        2:
                            PostShipment := true;
                        3:
                            PostReceipt := true;
                    end;
                end
                else Begin
                    // 01.09.2008 EDMS P1 - Service Management Integration <<
                    Selection := StrMenu(Text000, DefaultNumber);
                    PostShipment := Selection = Selection::Shipment;
                    PostReceipt := Selection = Selection::Receipt;
                End;

            end;
        end;
    END;
    // For codeunit 5706 "TransferOrder-Post (Yes/No)"
    procedure PostTransferOrder(var TransHeader: Record "Transfer Header"; PostShipment: boolean; PostReceipt: boolean; PostTransfer: boolean; var PostBatch: Boolean)
    var
        GenJnlPostPreview: Codeunit "Gen. Jnl.-Post Preview";
        TransferOrderPostReceipt: Codeunit "TransferOrder-Post Receipt";
        TransferOrderPostShipment: Codeunit "TransferOrder-Post Shipment";
        TransferOrderPostTransfer: Codeunit "TransferOrder-Post Transfer";
    begin
        if PostShipment then begin
            TransferOrderPostShipment.SetHideValidationDialog(PostBatch);
            TransferOrderPostShipment.Run(TransHeader);
        end;

        if PostReceipt then begin
            TransferOrderPostReceipt.SetHideValidationDialog(PostBatch);
            TransferOrderPostReceipt.Run(TransHeader);
        end;

        if PostTransfer then begin
            TransferOrderPostTransfer.Run(TransHeader);
        end;
    end;



    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateTransferOrderHByServHeader(ServiceHeader: Record "Service Header EDMS"; ToServiceLocation: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateTransferToLine(Var ServiceLine: Record "Service Line EDMS")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateTransferFromLine(Var ServiceLine: Record "Service Line EDMS"; TransferHeader: Record "Transfer Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateTransferToLine(Var TransferLine: Record "Transfer Line"; Var ServiceLine: Record "Service Line EDMS")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCreateTransferFromLine(Var TransferLine: Record "Transfer Line"; Var ServiceLine: Record "Service Line EDMS")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFillOptionNumber(Var OptionNumber: Integer; ServiceHeader: Record "Service Header EDMS"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeOpenTransferOrder(ServiceHeader: Record "Service Header EDMS"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertServiceLineTmp(var ServiceLineTmp: Record "Service Line EDMS"; ServiceLine: Record "Service Line EDMS"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateTransferLine(TransferHeader: Record "Transfer Header"; Var TransferLine: Record "Transfer Line"; Var LineNo: Integer; ServiceLine: Record "Service Line EDMS"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCheckReservedQuantity(ServiceLine: Record "Service Line EDMS"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFindServiceLine(var ServiceLine: Record "Service Line EDMS")
    begin
    end;
    //------------------------------- codeunit 378 "Transfer Extended Text"
    var
        MakeUpdateRequired: Boolean;
        AutoText: boolean;
        GLAcc: Record "G/L Account";
        Item: record Item;
        Text000: Label 'There is not enough space to insert extended text lines.';
        LineSpacing: Integer;
        NextLineNo: Integer;
        TempExtTextLine: Record "Extended Text Line" temporary;
        OrderPromisingSetup: Record "Order Promising Setup";

        CapabletoPromise: Codeunit "Capable to Promise";

    procedure ServCheckIfAnyExtTextEDMS(var ServiceLine: Record "Service Line EDMS"; Unconditionally: Boolean): Boolean
    var
        ServiceHeader: Record "Service Header EDMS";
        ExtTextHeader: Record "Extended Text Header";
    begin
        MakeUpdateRequired := false;
        if ServiceLine."Line No." <> 0 then
            MakeUpdateRequired := DeleteServiceLinesEDMS(ServiceLine);

        AutoText := false;

        if Unconditionally then
            AutoText := true
        else
            case ServiceLine.Type of
                ServiceLine.Type::Comment:
                    AutoText := true;
                ServiceLine.Type::"G/L Account":
                    begin
                        if GLAcc.Get(ServiceLine."No.") then
                            AutoText := GLAcc."Automatic Ext. Texts";
                    end;
                ServiceLine.Type::Item:
                    begin
                        if Item.Get(ServiceLine."No.") then
                            AutoText := Item."Automatic Ext. Texts";
                    end;
            end;

        if AutoText then begin
            ServiceLine.TestField("Document No.");
            ServiceHeader.Get(ServiceLine."Document Type", ServiceLine."Document No.");
            ExtTextHeader.SetRange("Table Name", ServiceLine.Type);
            ExtTextHeader.SetRange("No.", ServiceLine."No.");
            case ServiceLine."Document Type" of
                ServiceLine."document type"::Quote:
                    ExtTextHeader.SetRange("Service Quote", true);
                ServiceLine."document type"::Order:
                    ExtTextHeader.SetRange("Service Order", true);
            end;
            exit(ReadExtTextLines(ExtTextHeader, ServiceHeader."Document Date", ServiceHeader."Language Code"));
        end;
    end;

    procedure InsertServExtTextEDMS(var ServiceLine: Record "Service Line EDMS")
    var
        ToServiceLine: Record "Service Line EDMS";
    begin
        ToServiceLine.Reset;
        ToServiceLine.SetRange("Document Type", ServiceLine."Document Type");
        ToServiceLine.SetRange("Document No.", ServiceLine."Document No.");
        ToServiceLine := ServiceLine;
        if ToServiceLine.Find('>') then begin
            LineSpacing :=
              (ToServiceLine."Line No." - ServiceLine."Line No.") DIV
              (1 + TempExtTextLine.Count);
            if LineSpacing = 0 then
                Error(Text000);
        end else
            LineSpacing := 10000;

        NextLineNo := ServiceLine."Line No." + LineSpacing;

        TempExtTextLine.Reset;
        if TempExtTextLine.Find('-') then begin
            repeat
                ToServiceLine.Init;
                ToServiceLine."Document Type" := ServiceLine."Document Type";
                ToServiceLine."Document No." := ServiceLine."Document No.";
                ToServiceLine."Line No." := NextLineNo;
                NextLineNo := NextLineNo + LineSpacing;
                ToServiceLine.Description := TempExtTextLine.Text;
                ToServiceLine."Attached to Line No." := ServiceLine."Line No.";
                ToServiceLine.Insert;
            until TempExtTextLine.Next = 0;
            MakeUpdateRequired := true;
        end;
        TempExtTextLine.DeleteAll;
    end;


    procedure DeleteServiceLinesEDMS(var ServiceLine: Record "Service Line EDMS"): Boolean
    var
        ServiceLine2: Record "Service Line EDMS";
    begin
        ServiceLine2.SetRange("Document Type", ServiceLine."Document Type");
        ServiceLine2.SetRange("Document No.", ServiceLine."Document No.");
        ServiceLine2.SetRange("Attached to Line No.", ServiceLine."Line No.");
        ServiceLine2 := ServiceLine;
        if ServiceLine2.Find('>') then begin
            repeat
                ServiceLine2.Delete(true);
            until ServiceLine2.Next = 0;
            exit(true);
        end;
    end;

    procedure DeleteSalesLines(var SalesLine: Record "Sales Line"): Boolean
    var
        SalesLine2: Record "Sales Line";
    begin
        SalesLine2.SetRange("Document Type", SalesLine."Document Type");
        SalesLine2.SetRange("Document No.", SalesLine."Document No.");
        SalesLine2.SetRange("Attached to Line No.", SalesLine."Line No.");

        SalesLine2 := SalesLine;
        if SalesLine2.Find('>') then begin
            repeat
                SalesLine2.Delete(true);
            until SalesLine2.Next() = 0;
            exit(true);
        end;
    end;

    procedure ReadExtTextLines(var ExtTextHeader: Record "Extended Text Header"; DocDate: Date; LanguageCode: Code[10]) Result: Boolean
    var
        ExtTextLine: Record "Extended Text Line";
        IsHandled: Boolean;
    begin

        ExtTextHeader.SetCurrentKey(
          "Table Name", "No.", "Language Code", "All Language Codes", "Starting Date", "Ending Date");
        ExtTextHeader.SetRange("Starting Date", 0D, DocDate);

        ExtTextHeader.SetFilter("Ending Date", '%1..|%2', DocDate, 0D);
        if LanguageCode = '' then begin
            ExtTextHeader.SetRange("Language Code", '');
            if not ExtTextHeader.FindSet() then
                exit;
        end else begin
            ExtTextHeader.SetRange("Language Code", LanguageCode);
            if not ExtTextHeader.FindSet() then begin
                ExtTextHeader.SetRange("All Language Codes", true);
                ExtTextHeader.SetRange("Language Code", '');
                if not ExtTextHeader.FindSet() then
                    exit;
            end;
        end;
        TempExtTextLine.DeleteAll();
        repeat
            ExtTextLine.SetRange("Table Name", ExtTextHeader."Table Name");
            ExtTextLine.SetRange("No.", ExtTextHeader."No.");
            ExtTextLine.SetRange("Language Code", ExtTextHeader."Language Code");
            ExtTextLine.SetRange("Text No.", ExtTextHeader."Text No.");
            if ExtTextLine.FindSet() then begin
                repeat
                    TempExtTextLine := ExtTextLine;
                    TempExtTextLine.Insert();
                until ExtTextLine.Next() = 0;
                Result := true;
            end;
        until ExtTextHeader.Next() = 0;
    end;


    procedure CreateReqLinesFromTransfer(TransHeader: Record "Transfer Header"; ShowMessage: Boolean; LineNo: Integer)
    var
        TransLine: Record "Transfer Line";
        TrackingSpecification: Record "Tracking Specification";
        ReqQty: Decimal;
        ReqLine: Record "Requisition Line";
        ReservMgt: Codeunit "Reservation Management EDMS";
        ReserveTransferLine: Codeunit "Transfer Line-Reserve EDMS";
        ReservEntry: Record "Reservation Entry";
        CreateReservEntry: Codeunit "Create Reserv. Entry";
        LineCount: Integer;
        SKU: Record "Stockkeeping Unit";
        GetPlanningParameters: Codeunit "Planning-Get Parameters";
        Text001: label '%1 Requisition Line was created! %2 %3, %4 %5.';
        Text002: label 'Do you want to create order promising?';
        TransferDirection: Enum "Transfer Direction";
    begin
        if ShowMessage then
            if not Confirm(Text002) then
                exit;

        OrderPromisingSetup.Get;
        OrderPromisingSetup.TestField("Order Promising Template");
        OrderPromisingSetup.TestField("Order Promising Worksheet");

        TransLine.Reset;
        TransLine.SetRange("Document No.", TransHeader."No.");
        TransLine.SetRange("Derived From Line No.", 0);
        if LineNo <> 0 then                                                                                              // 27.03.2014 Elva Baltic P21
            TransLine.SetRange("Line No.", LineNo);                                                                                  // 27.03.2014 Elva Baltic P21
        if TransLine.FindSet then begin
            repeat
                // Need to check if possible to reserve from ILE, PO, etc. (autoreserve) before creating Requisition Line
                TransLine.CalcFields("Reserved Quantity Outbnd.");
                ReqQty := TransLine.Quantity - TransLine."Reserved Quantity Outbnd." - TransLine."Quantity Shipped";
                if ReqQty > 0 then begin
                    CreateReqLine(TransLine."Item No.", TransLine."Variant Code", TransLine."Transfer-from Code", ReqQty, TransLine."Unit of Measure Code", TransLine."Shipment Date", 1, ReqLine);
                    ReqLine."Ref. Order No." := TransLine."Document No.";
                    ReqLine."Ref. Order Type" := ReqLine."ref. order type"::Transfer;
                    ReqLine."Ref. Line No." := TransLine."Line No.";
                    // ReqLine."Accept Action Message" := TRUE;                                                                // 07.04.2014 Elva Baltic P21
                    ReqLine."Accept Action Message" := TRUE;                                                                   // 28.11.2023 EB.KN
                    ReqLine.Modify;

                    ReservMgt.SetReqLine(ReqLine);
                    ReserveTransferLine.SetBinding(ReservEntry.Binding::"Order-to-Order");
                    ReservEntry."Source Type" := Database::"Transfer Line";
                    //22.05.2014 EDMS P8 >>
                    TrackingSpecification.Init;
                    //TrackingSpecification."Source Type" := 2;  //' ,Sales,Requisition Line,Purchase,Item Journal,BOM Journal,Item Ledger Entry,Service,Job'
                    TrackingSpecification."Source Type" := Database::"Requisition Line";  //01.09.2014 EDMS P8
                    TrackingSpecification."Source Subtype" := 0;
                    TrackingSpecification."Source ID" := ReqLine."Worksheet Template Name";
                    TrackingSpecification."Source Batch Name" := ReqLine."Journal Batch Name";
                    TrackingSpecification."Source Prod. Order Line" := 0;
                    TrackingSpecification."Source Ref. No." := ReqLine."Line No.";
                    TrackingSpecification."Variant Code" := ReqLine."Variant Code";
                    TrackingSpecification."Location Code" := ReqLine."Location Code";
                    TrackingSpecification."Serial No." := '';
                    TrackingSpecification."Lot No." := '';
                    TrackingSpecification."Qty. per Unit of Measure" := ReqLine."Qty. per Unit of Measure";

                    ReserveTransferLine.CreateReservationSetFrom(
                      TrackingSpecification);
                    //22.05.2014 EDMS P8 <<

                    ReserveTransferLine.CreateReservation(
                      TransLine,
                      ReqLine.Description,
                      ReqLine."Due Date",
                      ReqQty,
                      ReqLine."Quantity (Base)", ReservEntry, TransferDirection::Outbound);

                    LineCount += 1;
                    // 14.02.2019 EB.P30 >>
                    ReqLine.Validate("Ordering Price Type Code", ReqLine.GetReservForInfo(Returnvalue::OrderingPriceType));
                    ReqLine.Modify;
                    // 14.02.2019 EB.P30 <<
                end;
            until TransLine.Next = 0;
            if ShowMessage then
                Message(Text001, LineCount, ReqLine.FieldCaption(ReqLine."Worksheet Template Name"), OrderPromisingSetup."Order Promising Template",
                  ReqLine.FieldCaption(ReqLine."Journal Batch Name"), OrderPromisingSetup."Order Promising Worksheet");
        end;
    end;

    local procedure CreateReqLine(ItemNo: Code[20]; VariantCode: Code[10]; LocationCode: Code[10]; Quantity: Decimal; Unit: Code[10]; DueDate: Date; Direction: Option Forward,Backward; var ReqLine: Record "Requisition Line")
    var
        SalesLine: Record "Sales Line";
        LeadTimeMgt: Codeunit "Lead-Time Management";
        PlngLnMgt: Codeunit "Planning Line Management";
        ReqWkshTemplate: Record "Req. Wksh. Template";
        ReturnValue: Option CustomerNo,VIN,DealType,CustomerName,OrderingPriceType;
    begin
        ReqLine.Init();
        ReqLine."Order Promising Type" := OrderPromisingType; //06.08.2008 EDMS P1
        ReqLine."Order Promising ID" := OrderPromisingID;
        ReqLine."Order Promising Line ID" := SourceLineNo;

        ReqLine."Order Promising Line No." := OrderPromisingLineNo;
        ReqLine."Worksheet Template Name" := OrderPromisingSetup."Order Promising Template";
        ReqLine."Journal Batch Name" := OrderPromisingSetup."Order Promising Worksheet";
        GetNextReqLineNo(ReqLine);
        ReqLine.Type := ReqLine.Type::Item;
        ReqLine."Location Code" := LocationCode;
        ReqLine.Validate("No.", ItemNo);
        ReqLine.Validate("Variant Code", VariantCode);
        ReqWkshTemplate.Get(OrderPromisingSetup."Order Promising Template");//10.11.2011 EDMS P8
        ReqLine."Document Profile" := ReqWkshTemplate."Document Profile"; //10.11.2011 EDMS P8

        ReqLine."Ordering Price Type Code" := ReqLine.GetReservForInfo(Returnvalue::OrderingPriceType); // 07.09.2018 EB.P30 EDMS

        //17.10.2007. EDMS P2 >>
        GetDefaultBin(ReqLine);
        //17.10.2007. EDMS P2 <<

        ReqLine."Action Message" := ReqLine."Action Message"::New;
        ReqLine."Accept Action Message" := false;
        ReqLine.Validate("Ending Date",
         LeadTimeMgt.GetPlannedEndingDate(ItemNo, LocationCode, VariantCode, DueDate, ReqLine."Vendor No.", ReqLine."Ref. Order Type"));
        ReqLine."Ending Time" := 235959T;
        ReqLine.Validate(Quantity, Quantity);
        ReqLine.Validate("Unit of Measure Code", Unit);
        if ReqLine."Starting Date" = 0D then
            ReqLine."Starting Date" := WorkDate;

        ReqLine.Insert(true);
        PlngLnMgt.Calculate(ReqLine, Direction, true, true, 0);
        if ReqLine."Order Promising Type" = ReqLine."order promising type"::Sales then //06.08.2008 EDMS P1
            if SalesLine.Get(SalesLine."Document Type"::Order, ReqLine."Order Promising ID", ReqLine."Order Promising Line ID") then
                ReqLine.Validate("Ordering Price Type Code", SalesLine."Ordering Price Type Code");       // 04.03.2019 EB.P30 EDMS
        if SalesLine."Drop Shipment" then begin
            ReqLine."Sales Order No." := SalesLine."Document No.";
            ReqLine."Sales Order Line No." := SalesLine."Line No.";
            ReqLine."Sell-to Customer No." := SalesLine."Sell-to Customer No.";
            ReqLine."Purchasing Code" := SalesLine."Purchasing Code";
        end;

        ReqLine.Modify();
    end;


    local procedure GetNextReqLineNo(var ReqLine: Record "Requisition Line")
    var
        ReqLine2: Record "Requisition Line";
    begin
        ReqLine2.SetRange("Worksheet Template Name", ReqLine."Worksheet Template Name");
        ReqLine2.SetRange("Journal Batch Name", ReqLine."Journal Batch Name");
        if ReqLine2.FindLast then
            ReqLine."Line No." := ReqLine2."Line No." + 10000
        else
            ReqLine."Line No." := 10000;
    end;

    local procedure GetDefaultBin(var ReqLine: Record "Requisition Line")
    var
        WMSManagement: Codeunit "WMS Management";
        SalesSetup: Record "Sales & Receivables Setup";
        Location: Record Location;
    begin
        if ReqLine.Type <> ReqLine.Type::Item then
            exit;

        ReqLine."Bin Code" := '';

        if (ReqLine."Location Code" <> '') and (ReqLine."No." <> '') then begin
            GetLocation(ReqLine."Location Code", Location);
            if Location."Bin Mandatory" and not Location."Directed Put-away and Pick" then
                WMSManagement.GetDefaultBin(ReqLine."No.", ReqLine."Variant Code", ReqLine."Location Code", ReqLine."Bin Code");
        end;
    end;

    local procedure GetLocation(LocationCode: Code[10]; var Location: Record Location)
    begin
        if LocationCode = '' then
            Clear(Location)
        else
            if Location.Code <> LocationCode then
                Location.Get(LocationCode);
    end;

    [IntegrationEvent(false, false)]
    procedure OnBeforeFillTransfLinesFromService(var ServiceHeader: Record "Service Header EDMS"; var TransferHeader: record "Transfer Header"; ServiceLineTmp: record "Service line EDMS" Temporary; TransferCreated: Boolean; OptionNumber: integer; var IsHandledLine: Boolean)
    begin

    end;

    [IntegrationEvent(false, false)]
    procedure OnafterGetDocumentSparePartLocations(var ServiceHeader: Record "Service Header EDMS"; var ServiceLineTmp: record "Service line EDMS" Temporary)
    begin

    end;

    [IntegrationEvent(false, false)]
    procedure onBeforeFilterGetDocumentSparePartLocations(var ServiceLine: record "Service line EDMS")
    begin

    end;

}






