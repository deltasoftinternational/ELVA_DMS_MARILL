Codeunit 25006500 "Item Order Overview Mgt."
{
    // 10.06.2014 Elva Baltic P8 #F0003 EDMS7.10
    //   * ADDED "Quantity Shipped" use
    // 
    // 13.05.2010 EBMSM01 P2
    //   * Added function SetrangeSaleOrderDate, SetrangeServiceOrderDate
    //   * Changed code FindRec, FillSalesEntries, FillServiceEntries


    trigger OnRun()
    begin
    end;

    var
        Text001: label 'Mixed';
        Text005: label 'Outbound,Inbound';
        PlannedDate: Date;
        PlannedDateNull: Boolean;


    procedure FindRec(var ItemOrderEntry: Record "Item Order Overview Entry"; SourceTypeFilter: Option " ",Sale,Service,Transfer; DocNoFilter: Text[250]; SellToCustomerFilter: Code[20]; BillToCustomerFilter: Code[20]; ItemNoFilter: Code[20]; VehSerialNoFilter: Code[20]; DateFilter: Text[100])
    begin
        ItemOrderEntry.Reset;
        ItemOrderEntry.DeleteAll;

        case SourceTypeFilter of
            Sourcetypefilter::" ":
                begin
                    FillSalesEntries(ItemOrderEntry, DocNoFilter, SellToCustomerFilter, BillToCustomerFilter, ItemNoFilter, DateFilter);
                    FillServiceEntries(ItemOrderEntry, DocNoFilter, SellToCustomerFilter, BillToCustomerFilter,
                                     ItemNoFilter, VehSerialNoFilter, DateFilter);
                    FillTransferEntries(ItemOrderEntry, DocNoFilter, ItemNoFilter, DateFilter);

                end;

            Sourcetypefilter::Sale:
                FillSalesEntries(ItemOrderEntry, DocNoFilter, SellToCustomerFilter, BillToCustomerFilter, ItemNoFilter, DateFilter);

            Sourcetypefilter::Service:
                FillServiceEntries(ItemOrderEntry, DocNoFilter, SellToCustomerFilter, BillToCustomerFilter,
                                 ItemNoFilter, VehSerialNoFilter, DateFilter);

            Sourcetypefilter::Transfer:
                FillTransferEntries(ItemOrderEntry, DocNoFilter, ItemNoFilter, DateFilter);
        end
    end;


    procedure FillSalesEntries(var ItemOrderEntry: Record "Item Order Overview Entry"; DocNoFilter: Text[250]; SellToCustomerFilter: Code[20]; BillToCustomerFilter: Code[20]; ItemNoFilter: Code[20]; DateFilter: Text[100])
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
        EntryNo: Integer;
    begin
        SalesHeader.Reset;
        SalesHeader.SetCurrentkey("Document Profile");
        SalesHeader.SetRange("Document Type", SalesHeader."document type"::Order);
        SalesHeader.SetRange("Document Profile", SalesLine."document profile"::"Spare Parts Trade");

        SetrangeSaleDocNo(SalesHeader, DocNoFilter);
        SetrangeSaleSellToCustomer(SalesHeader, SellToCustomerFilter);
        SetrangeSaleBillToCustomer(SalesHeader, BillToCustomerFilter);
        SetrangeSaleOrderDate(SalesHeader, DateFilter);

        if SalesHeader.FindFirst then
            repeat
                SalesLine.Reset;
                SalesLine.SetRange("Document Type", SalesHeader."Document Type");
                SalesLine.SetRange("Document No.", SalesHeader."No.");
                SalesLine.SetRange(Type, SalesLine.Type::Item);
                SetrangeSaleItem(SalesLine, ItemNoFilter);

                if SalesLine.FindFirst then begin
                    ItemOrderEntry.Reset;
                    if ItemOrderEntry.FindLast then
                        EntryNo := ItemOrderEntry."Entry No."
                    else
                        EntryNo := 0;

                    repeat
                        EntryNo += 1;
                        ItemOrderEntry.TransferFields(SalesLine);
                        ItemOrderEntry."Entry No." := EntryNo;
                        ItemOrderEntry."Document Profile" := 37;
                        ItemOrderEntry.Insert;
                        SalesLine.CalcFields("Reserved Quantity");
                        if SalesLine."Reserved Quantity" = SalesLine.Quantity then begin
                            PlannedDate := 0D;
                            PlannedDateNull := false;
                            GetPlannedAvailDate(Database::"Sales Line", SalesLine."Document Type".AsInteger(), SalesLine."Document No.",
                                                SalesLine."Line No.");
                            if PlannedDateNull then
                                PlannedDate := 0D;
                            ItemOrderEntry."Planned Avail. Date" := PlannedDate;
                            ItemOrderEntry.Modify;
                        end;
                    until SalesLine.Next = 0;
                end;
            until SalesHeader.Next = 0;
    end;


    procedure FillServiceEntries(var ItemOrderEntry: Record "Item Order Overview Entry"; DocNoFilter: Text[250]; SellToCustomerFilter: Code[20]; BillToCustomerFilter: Code[20]; ItemNoFilter: Code[20]; VehSerialNoFilter: Code[20]; DateFilter: Text[100])
    var
        ServiceHeader: Record "Service Header EDMS";
        ServiceLine: Record "Service Line EDMS";
        EntryNo: Integer;
    begin
        ServiceHeader.Reset;
        SetrangeServiceDocNo(ServiceHeader, DocNoFilter);
        SetrangeServiceSellToCustomer(ServiceHeader, SellToCustomerFilter);
        SetrangeServiceBillToCustomer(ServiceHeader, BillToCustomerFilter);
        SetrangeServiceVehicle(ServiceHeader, VehSerialNoFilter);
        SetrangeServiceOrderDate(ServiceHeader, DateFilter);

        if ServiceHeader.FindFirst then
            repeat
                ServiceLine.Reset;
                ServiceLine.SetRange("Document Type", ServiceHeader."Document Type");
                ServiceLine.SetRange("Document No.", ServiceHeader."No.");
                ServiceLine.SetRange(Type, ServiceLine.Type::Item);
                SetrangeServiceItem(ServiceLine, ItemNoFilter);

                if ServiceLine.FindFirst then begin
                    ItemOrderEntry.Reset;
                    if ItemOrderEntry.FindLast then
                        EntryNo := ItemOrderEntry."Entry No."
                    else
                        EntryNo := 0;

                    repeat
                        EntryNo += 1;
                        ItemOrderEntry.TransferFields(ServiceLine);
                        ItemOrderEntry."Quantity Shipped" := 0; //10.06.2014 Elva Baltic P8 #F0003 EDMS7.10
                        ItemOrderEntry."Entry No." := EntryNo;
                        ItemOrderEntry."Document Profile" := 25006146;
                        ItemOrderEntry.Insert;
                        ServiceLine.CalcFields("Reserved Quantity");
                        if ServiceLine."Reserved Quantity" = ServiceLine.Quantity then begin
                            PlannedDate := 0D;
                            PlannedDateNull := false;
                            GetPlannedAvailDate(Database::"Service Line EDMS", ServiceLine."Document Type", ServiceLine."Document No.",
                                                ServiceLine."Line No.");
                            if PlannedDateNull then
                                PlannedDate := 0D;
                            ItemOrderEntry."Planned Avail. Date" := PlannedDate;
                            ItemOrderEntry.Modify;
                        end;
                    until ServiceLine.Next = 0;
                end;
            until ServiceHeader.Next = 0;
    end;


    procedure FillTransferEntries(var ItemOrderEntry: Record "Item Order Overview Entry"; DocNoFilter: Text[250]; ItemNoFilter: Code[20]; DateFilter: Text[100])
    var
        TransferLine: Record "Transfer Line";
        EntryNo: Integer;
    begin
        TransferLine.Reset;
        SetrangeTransferDocNo(TransferLine, DocNoFilter);
        SetrangeTransferItem(TransferLine, ItemNoFilter);
        SetrangeTransferShipmentDate(TransferLine, DateFilter);

        if TransferLine.FindFirst then begin
            ItemOrderEntry.Reset;
            if ItemOrderEntry.FindLast then
                EntryNo := ItemOrderEntry."Entry No."
            else
                EntryNo := 0;

            repeat
                EntryNo += 1;
                ItemOrderEntry."Entry No." := EntryNo;
                ItemOrderEntry."Document Profile" := Database::"Transfer Line";
                ItemOrderEntry."Document No." := TransferLine."Document No.";
                ItemOrderEntry."Line No." := TransferLine."Line No.";
                ItemOrderEntry.Description := TransferLine.Description;
                ItemOrderEntry."Description 2" := TransferLine."Description 2";
                ItemOrderEntry."Item No." := TransferLine."Item No.";
                ItemOrderEntry."Unit of Measure" := TransferLine."Unit of Measure";
                ItemOrderEntry.Quantity := TransferLine.Quantity;
                ItemOrderEntry."Shortcut Dimension 1 Code" := TransferLine."Shortcut Dimension 1 Code";
                ItemOrderEntry."Shortcut Dimension 2 Code" := TransferLine."Shortcut Dimension 2 Code";
                ItemOrderEntry."Location Code" := TransferLine."Transfer-from Code";
                ItemOrderEntry."Planned Shipment Date" := TransferLine."Shipment Date";
                ItemOrderEntry."Planned Delivery Date" := TransferLine."Receipt Date";
                TransferLine.CalcFields("Reserved Quantity Outbnd.");
                if TransferLine."Reserved Quantity Outbnd." = TransferLine.Quantity then begin
                    PlannedDate := 0D;
                    PlannedDateNull := false;
                    GetPlannedAvailDate(Database::"Transfer Line", 0, TransferLine."Document No.",
                                        TransferLine."Line No.");
                    if PlannedDateNull then
                        PlannedDate := 0D;
                    ItemOrderEntry."Planned Avail. Date" := PlannedDate;
                end;
                ItemOrderEntry.Insert;
            until TransferLine.Next = 0;
        end;
    end;


    procedure SetrangeSaleDocNo(var SalesHeader: Record "Sales Header"; DocNoFilter: Text[250])
    begin
        if DocNoFilter <> '' then
            SalesHeader.SetRange("No.", DocNoFilter);
    end;


    procedure SetrangeSaleSellToCustomer(var Salesheader: Record "Sales Header"; SellToCustomerFilter: Code[20])
    begin
        if SellToCustomerFilter <> '' then
            Salesheader.SetRange("Sell-to Customer No.", SellToCustomerFilter);
    end;


    procedure SetrangeSaleBillToCustomer(var Salesheader: Record "Sales Header"; BillToCustomerFilter: Code[20])
    begin
        if BillToCustomerFilter <> '' then
            Salesheader.SetRange("Bill-to Customer No.", BillToCustomerFilter);
    end;


    procedure SetrangeSaleItem(var SalesLine: Record "Sales Line"; ItemNoFilter: Code[20])
    begin
        if ItemNoFilter <> '' then
            SalesLine.SetRange("No.", ItemNoFilter);
    end;


    procedure SetrangeSaleOrderDate(var SalesHeader: Record "Sales Header"; DateFilter: Text[100])
    begin
        if DateFilter <> '' then
            SalesHeader.SetFilter("Order Date", DateFilter);
    end;


    procedure SetrangeServiceDocNo(var ServiceHeader: Record "Service Header EDMS"; DocNoFilter: Text[250])
    begin
        if DocNoFilter <> '' then
            ServiceHeader.SetRange("No.", DocNoFilter);
    end;


    procedure SetrangeServiceSellToCustomer(var ServiceHeader: Record "Service Header EDMS"; SellToCustomerFilter: Code[20])
    begin
        if SellToCustomerFilter <> '' then
            ServiceHeader.SetRange("Sell-to Customer No.", SellToCustomerFilter);
    end;


    procedure SetrangeServiceBillToCustomer(var ServiceHeader: Record "Service Header EDMS"; BillToCustomerFilter: Code[20])
    begin
        if BillToCustomerFilter <> '' then
            ServiceHeader.SetRange("Bill-to Customer No.", BillToCustomerFilter);
    end;


    procedure SetrangeServiceItem(var ServiceLine: Record "Service Line EDMS"; ItemNoFilter: Code[20])
    begin
        if ItemNoFilter <> '' then
            ServiceLine.SetRange("No.", ItemNoFilter);
    end;


    procedure SetrangeServiceVehicle(var ServiceHeader: Record "Service Header EDMS"; VehSerialNoFilter: Code[20])
    begin
        if VehSerialNoFilter <> '' then
            ServiceHeader.SetRange("Vehicle Serial No.", VehSerialNoFilter);
    end;


    procedure SetrangeServiceOrderDate(var ServiceHeader: Record "Service Header EDMS"; DateFilter: Text[100])
    begin
        if DateFilter <> '' then
            ServiceHeader.SetFilter("Order Date", DateFilter);
    end;


    procedure SetrangeTransferDocNo(var TransferLine: Record "Transfer Line"; DocNoFilter: Text[250])
    begin
        if DocNoFilter <> '' then
            TransferLine.SetRange("Document No.", DocNoFilter);
    end;


    procedure SetrangeTransferItem(var TransferLine: Record "Transfer Line"; ItemNoFilter: Code[20])
    begin
        if ItemNoFilter <> '' then
            TransferLine.SetRange("Item No.", ItemNoFilter);
    end;


    procedure SetrangeTransferShipmentDate(var TransferLine: Record "Transfer Line"; DateFilter: Text[100])
    begin
        if DateFilter <> '' then
            TransferLine.SetFilter("Shipment Date", DateFilter);
    end;


    procedure CreateText(SourceTypeID: Integer): Text[80]
    var
        DocProfile: Option " ","Spare Part Sale",Service;
        SourceTypeText: label ' Spare Part Sale,Service';
    begin
        case SourceTypeID of
            Database::"Sales Line":
                begin
                    DocProfile := Docprofile::"Spare Part Sale";
                    exit(StrSubstNo('%1', SelectStr(DocProfile, SourceTypeText)));
                end;
            Database::"Service Line EDMS":
                begin
                    DocProfile := Docprofile::Service;
                    exit(StrSubstNo('%1', SelectStr(DocProfile, SourceTypeText)));
                end;
        end;

        exit('');
    end;


    procedure GetSourceDescription(ItemOrderEntry: Record "Item Order Overview Entry"): Text[30]
    var
        ReservationEntry: Record "Reservation Entry";
        ReservationEntry2: Record "Reservation Entry";
        SourceType: Integer;
    begin
        ItemOrderEntry.CalcFields("Reserved Qty. (Base)");
        if ItemOrderEntry."Reserved Qty. (Base)" = 0 then
            exit('');

        SourceType := -1;

        ReservationEntry.Reset;
        ReservationEntry.SetCurrentkey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
        ReservationEntry.SetRange("Source ID", ItemOrderEntry."Document No.");
        ReservationEntry.SetRange("Source Ref. No.", ItemOrderEntry."Line No.");
        ReservationEntry.SetRange("Source Type", ItemOrderEntry."Document Profile");
        ReservationEntry.SetRange("Source Subtype", ItemOrderEntry."Document Type");
        ReservationEntry.SetRange("Reservation Status", ReservationEntry."reservation status"::Reservation);
        if ReservationEntry.Count = 1 then begin
            ReservationEntry.FindFirst;
            exit(CreateSourceText(ReservationEntry));
        end;
        if ReservationEntry.FindFirst then
            repeat
                if ReservationEntry2.Get(ReservationEntry."Entry No.", true) then begin
                    if SourceType = -1 then
                        SourceType := ReservationEntry2."Source Type";
                    if SourceType <> ReservationEntry2."Source Type" then
                        exit(Text001);
                end;
            until ReservationEntry.Next = 0;

        if ReservationEntry.FindFirst then
            exit(CreateSourceText(ReservationEntry))
        else
            exit('');
    end;


    procedure GetSourceDescription2(ItemOrderEntry: Record "Item Order Overview Entry"): Text[30]
    var
        ReservationEntry: Record "Reservation Entry";
        ReservationEntry2: Record "Reservation Entry";
        ReservationEntry3: Record "Reservation Entry";
        ReservationEntry4: Record "Reservation Entry";
        SourceType: Integer;
        EntryNo: Integer;
    begin
        ItemOrderEntry.CalcFields("Reserved Qty. (Base)");
        if ItemOrderEntry."Reserved Qty. (Base)" = 0 then
            exit('');

        SourceType := -1;

        ReservationEntry.Reset;
        ReservationEntry.SetCurrentkey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
        ReservationEntry.SetRange("Source ID", ItemOrderEntry."Document No.");
        ReservationEntry.SetRange("Source Ref. No.", ItemOrderEntry."Line No.");
        ReservationEntry.SetRange("Source Type", ItemOrderEntry."Document Profile");
        ReservationEntry.SetRange("Source Subtype", ItemOrderEntry."Document Type");
        ReservationEntry.SetRange("Reservation Status", ReservationEntry."reservation status"::Reservation);
        if ReservationEntry.FindFirst then
            repeat
                if ReservationEntry2.Get(ReservationEntry."Entry No.", true) then begin
                    if ReservationEntry2."Source Type" = Database::"Transfer Line" then begin
                        ReservationEntry3.Reset;
                        ReservationEntry3.SetCurrentkey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
                        ReservationEntry3.SetRange("Source ID", ReservationEntry2."Source ID");
                        ReservationEntry3.SetRange("Source Ref. No.", ReservationEntry2."Source Ref. No.");
                        ReservationEntry3.SetRange("Source Type", ReservationEntry2."Source Type");
                        ReservationEntry3.SetRange("Reservation Status", ReservationEntry3."reservation status"::Reservation);
                        ReservationEntry3.SetRange(Positive, false);

                        if ReservationEntry3.FindFirst then
                            repeat
                                if ReservationEntry4.Get(ReservationEntry3."Entry No.", true) then begin
                                    if SourceType = -1 then begin
                                        SourceType := ReservationEntry4."Source Type";
                                        EntryNo := ReservationEntry4."Entry No.";
                                    end;
                                    if SourceType <> ReservationEntry4."Source Type" then
                                        exit(Text001);
                                end;
                            until ReservationEntry3.Next = 0;
                    end;
                end;
            until ReservationEntry.Next = 0;

        if EntryNo <> 0 then begin
            ReservationEntry4.Get(EntryNo, true);
            exit(CreateSourceText(ReservationEntry4));
        end else
            exit('');
    end;


    procedure GetSourceColor(ItemOrderEntry: Record "Item Order Overview Entry"): Integer
    var
        ReservationEntry: Record "Reservation Entry";
        ReservationEntry2: Record "Reservation Entry";
        SourceType: Integer;
        IOOSetup: Record "Item Order Overview Setup";
    begin
        if not IOOSetup.Get then
            exit(0);
        if not IOOSetup."Highlight Statuses" then
            exit(0);

        ItemOrderEntry.CalcFields("Reserved Qty. (Base)");
        if ItemOrderEntry."Reserved Qty. (Base)" = 0 then
            exit(IOOSetup."Not Reserved Color");

        SourceType := -1;

        ReservationEntry.Reset;
        ReservationEntry.SetCurrentkey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
        ReservationEntry.SetRange("Source ID", ItemOrderEntry."Document No.");
        ReservationEntry.SetRange("Source Ref. No.", ItemOrderEntry."Line No.");
        ReservationEntry.SetRange("Source Type", ItemOrderEntry."Document Profile");
        ReservationEntry.SetRange("Source Subtype", ItemOrderEntry."Document Type");
        ReservationEntry.SetRange("Reservation Status", ReservationEntry."reservation status"::Reservation);
        if ReservationEntry.Count = 1 then begin
            ReservationEntry.FindFirst;
            if ReservationEntry2.Get(ReservationEntry."Entry No.", true) then begin
                case ReservationEntry2."Source Type" of
                    Database::"Item Ledger Entry":
                        exit(IOOSetup."Item Ledger Entry Color");
                    Database::"Transfer Line":
                        exit(IOOSetup."Transfer Line Color");
                    Database::"Purchase Line":
                        exit(IOOSetup."Purchase Line Color");
                    Database::"Requisition Line":
                        exit(IOOSetup."Requisition Line Color");
                end;
            end;
        end;

        if ReservationEntry.FindFirst then
            repeat
                if ReservationEntry2.Get(ReservationEntry."Entry No.", true) then begin
                    if SourceType = -1 then
                        SourceType := ReservationEntry2."Source Type";
                    if SourceType <> ReservationEntry2."Source Type" then
                        exit(IOOSetup."Mixed Color");
                end;
            until ReservationEntry.Next = 0;
        case ReservationEntry2."Source Type" of
            Database::"Item Ledger Entry":
                exit(IOOSetup."Item Ledger Entry Color");
            Database::"Transfer Line":
                exit(IOOSetup."Transfer Line Color");
            Database::"Purchase Line":
                exit(IOOSetup."Purchase Line Color");
            Database::"Requisition Line":
                exit(IOOSetup."Requisition Line Color");
        end;
    end;


    procedure GetSourceColor2(ItemOrderEntry: Record "Item Order Overview Entry"): Integer
    var
        ReservationEntry: Record "Reservation Entry";
        ReservationEntry2: Record "Reservation Entry";
        ReservationEntry3: Record "Reservation Entry";
        ReservationEntry4: Record "Reservation Entry";
        SourceType: Integer;
        EntryNo: Integer;
        IOOSetup: Record "Item Order Overview Setup";
    begin
        if not IOOSetup.Get then
            exit(16777215);
        if not IOOSetup."Highlight Statuses" then
            exit(16777215);

        ItemOrderEntry.CalcFields("Reserved Qty. (Base)");
        if ItemOrderEntry."Reserved Qty. (Base)" = 0 then
            exit(16777215);

        SourceType := -1;

        ReservationEntry.Reset;
        ReservationEntry.SetCurrentkey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
        ReservationEntry.SetRange("Source ID", ItemOrderEntry."Document No.");
        ReservationEntry.SetRange("Source Ref. No.", ItemOrderEntry."Line No.");
        ReservationEntry.SetRange("Source Type", ItemOrderEntry."Document Profile");
        ReservationEntry.SetRange("Source Subtype", ItemOrderEntry."Document Type");
        ReservationEntry.SetRange("Reservation Status", ReservationEntry."reservation status"::Reservation);
        if ReservationEntry.FindFirst then
            repeat
                if ReservationEntry2.Get(ReservationEntry."Entry No.", true) then begin
                    if ReservationEntry2."Source Type" = Database::"Transfer Line" then begin
                        ReservationEntry3.Reset;
                        ReservationEntry3.SetCurrentkey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
                        ReservationEntry3.SetRange("Source ID", ReservationEntry2."Source ID");
                        ReservationEntry3.SetRange("Source Ref. No.", ReservationEntry2."Source Ref. No.");
                        ReservationEntry3.SetRange("Source Type", ReservationEntry2."Source Type");
                        ReservationEntry3.SetRange("Reservation Status", ReservationEntry3."reservation status"::Reservation);
                        ReservationEntry3.SetRange(Positive, false);

                        if ReservationEntry3.FindFirst then
                            repeat
                                if ReservationEntry4.Get(ReservationEntry3."Entry No.", true) then begin
                                    if SourceType = -1 then begin
                                        SourceType := ReservationEntry4."Source Type";
                                        EntryNo := ReservationEntry4."Entry No.";
                                    end;
                                    if SourceType <> ReservationEntry4."Source Type" then
                                        exit(IOOSetup."Mixed Color");
                                end;
                            until ReservationEntry3.Next = 0;
                    end;
                end;
            until ReservationEntry.Next = 0;

        if EntryNo <> 0 then begin
            ReservationEntry4.Get(EntryNo, true);
            case ReservationEntry4."Source Type" of
                Database::"Item Ledger Entry":
                    exit(IOOSetup."Item Ledger Entry Color");
                Database::"Transfer Line":
                    exit(IOOSetup."Transfer Line Color");
                Database::"Purchase Line":
                    exit(IOOSetup."Purchase Line Color");
                Database::"Requisition Line":
                    exit(IOOSetup."Requisition Line Color");
            end;
        end else
            exit(16777215);
    end;


    procedure CreateSourceText(ReservEntry: Record "Reservation Entry"): Text[80]
    begin
        if ReservEntry.Get(ReservEntry."Entry No.", true) then
            exit(CreateSource(ReservEntry))
        else
            exit('');
    end;


    procedure CreateSource(ReservEntry: Record "Reservation Entry"): Text[80]
    var
        CalcSalesLine: Record "Sales Line";
        CalcPurchLine: Record "Purchase Line";
        CalcItemJnlLine: Record "Item Journal Line";
        CalcProdOrderLine: Record "Prod. Order Line";
        CalcJobJnlLine: Record "Job Journal Line";
        SourceType: Option " ",Sales,"Requisition Line",Purchase,"Item Journal","BOM Journal","Item Ledger Entry","Prod. Order Line","Prod. Order Component","Planning Line","Planning Component",Transfer,"Service Order","Job Journal";
        SourceTypeText: label 'Sales,Requisition Line,Purchase,Item Journal,BOM Journal,Item Ledger Entry,Prod. Order Line,Prod. Order Component,Planning Line,Planning Component,Transfer,Service Order';
    begin
        case ReservEntry."Source Type" of
            Database::"Sales Line":
                begin
                    SourceType := Sourcetype::Sales;
                    CalcSalesLine."Document Type" := ReservEntry."Source Subtype";
                    exit(StrSubstNo('%1 %2', SelectStr(SourceType, SourceTypeText),
                      CalcSalesLine."Document Type"));
                end;
            Database::"Purchase Line":
                begin
                    SourceType := Sourcetype::Purchase;
                    CalcPurchLine."Document Type" := ReservEntry."Source Subtype";
                    exit(StrSubstNo('%1 %2', SelectStr(SourceType, SourceTypeText),
                      CalcPurchLine."Document Type"));
                end;
            Database::"Requisition Line":
                begin
                    SourceType := Sourcetype::"Requisition Line";
                    exit(StrSubstNo('%1', SelectStr(SourceType, SourceTypeText)));
                end;
            Database::"Planning Component":
                begin
                    SourceType := Sourcetype::"Planning Component";
                    exit(StrSubstNo('%1', SelectStr(SourceType, SourceTypeText)));
                end;
            Database::"Item Journal Line":
                begin
                    SourceType := Sourcetype::"Item Journal";
                    CalcItemJnlLine."Entry Type" := ReservEntry."Source Subtype";
                    exit(StrSubstNo('%1 %2', SelectStr(SourceType, SourceTypeText),
                      CalcItemJnlLine."Entry Type"));
                end;
            Database::"Job Journal Line":
                begin
                    SourceType := Sourcetype::"Job Journal";
                    exit(StrSubstNo('%1 %2', SelectStr(SourceType, SourceTypeText),
                      CalcJobJnlLine."Entry Type"));
                end;
            Database::"Item Ledger Entry":
                begin
                    SourceType := Sourcetype::"Item Ledger Entry";
                    exit(StrSubstNo('%1', SelectStr(SourceType, SourceTypeText)));
                end;
            Database::"Prod. Order Line":
                begin
                    SourceType := Sourcetype::"Prod. Order Line";
                    CalcProdOrderLine.Status := ReservEntry."Source Subtype";
                    exit(StrSubstNo('%1 %2', SelectStr(SourceType, SourceTypeText),
                      CalcProdOrderLine.Status));
                end;
            Database::"Prod. Order Component":
                begin
                    SourceType := Sourcetype::"Prod. Order Component";
                    CalcProdOrderLine.Status := ReservEntry."Source Subtype";
                    exit(StrSubstNo('%1 %2', SelectStr(SourceType, SourceTypeText),
                      CalcProdOrderLine.Status));
                end;
            Database::"Transfer Line":
                begin
                    SourceType := Sourcetype::Transfer;
                    exit(StrSubstNo('%1, %2', SelectStr(SourceType, SourceTypeText),
                      SelectStr(ReservEntry."Source Subtype" + 1, Text005)));
                end;
            Database::"Service Line":
                begin
                    SourceType := Sourcetype::"Service Order";
                    exit(StrSubstNo('%1', SelectStr(SourceType, SourceTypeText)));
                end;
            Database::"Service Line EDMS": //08.07.08 EDMS P1
                begin
                    SourceType := Sourcetype::"Service Order";
                    exit(StrSubstNo('%1', SelectStr(SourceType, SourceTypeText)));
                end;
        end;

        exit('');
    end;


    procedure ShowRec(ItemOrderEntry: Record "Item Order Overview Entry")
    var
        SalesHeader: Record "Sales Header";
        ServiceHeader: Record "Service Header EDMS";
    begin
        case ItemOrderEntry."Document Profile" of
            Database::"Sales Line":
                begin
                    if SalesHeader.Get(ItemOrderEntry."Document Type", ItemOrderEntry."Document No.") then;
                    case ItemOrderEntry."Document Type" of
                        ItemOrderEntry."document type"::Quote:
                            Page.Run(Page::"Sales Quote", SalesHeader);
                        ItemOrderEntry."document type"::Order:
                            Page.Run(Page::"Sales Order", SalesHeader);
                        ItemOrderEntry."document type"::"Return Order":
                            Page.Run(Page::"Sales Return Order", SalesHeader);
                        ItemOrderEntry."document type"::Invoice:
                            Page.Run(Page::"Sales Invoice", SalesHeader);
                    end;
                end;
            Database::"Service Line EDMS":
                begin
                    if ServiceHeader.Get(ItemOrderEntry."Document Type", ItemOrderEntry."Document No.") then;
                    case ItemOrderEntry."Document Type" of
                        ItemOrderEntry."document type"::Quote:
                            Page.Run(Page::"Service Quote EDMS", ServiceHeader);
                        ItemOrderEntry."document type"::Order:
                            Page.Run(Page::"Service Order EDMS", ServiceHeader);
                        ItemOrderEntry."document type"::"Return Order":
                            Page.Run(Page::"Service Return Order EDMS", ServiceHeader);
                    end;
                end;
        end;
    end;


    procedure GetPlannedAvailDate(SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceRefNo: Integer)
    var
        ReservationEntry1: Record "Reservation Entry";
        ReservationEntry2: Record "Reservation Entry";
        PurchLine: Record "Purchase Line";
        TransferLine: Record "Transfer Line";
    begin
        ReservationEntry1.SetCurrentkey("Source ID");
        ReservationEntry1.SetRange("Source ID", SourceID);
        ReservationEntry1.SetRange("Source Type", SourceType);
        if SourceType <> Database::"Transfer Line" then
            ReservationEntry1.SetRange("Source Subtype", SourceSubtype);
        ReservationEntry1.SetRange("Source Ref. No.", SourceRefNo);
        if ReservationEntry1.FindFirst then begin
            repeat
                if ReservationEntry2.Get(ReservationEntry1."Entry No.", not ReservationEntry1.Positive) then begin
                    case ReservationEntry2."Source Type" of
                        Database::"Item Ledger Entry":
                            if (PlannedDate = 0D) or (PlannedDate < Today) then
                                PlannedDate := Today;
                        Database::"Transfer Line":
                            if TransferLine.Get(ReservationEntry2."Source ID", ReservationEntry2."Source Ref. No.") then begin
                                TransferLine.CalcFields("Reserved Quantity Outbnd.");
                                if TransferLine."Reserved Quantity Outbnd." < TransferLine.Quantity then begin
                                    PlannedDateNull := true;
                                    exit;
                                end;
                                GetPlannedAvailDate(ReservationEntry2."Source Type", ReservationEntry2."Source Subtype",
                                                    ReservationEntry2."Source ID", ReservationEntry2."Source Ref. No.");
                            end;
                        Database::"Purchase Line":
                            begin
                                if PurchLine.Get(ReservationEntry2."Source Subtype", ReservationEntry2."Source ID",
                                                 ReservationEntry2."Source Ref. No.") then
                                    ;
                                if (PlannedDate = 0D) or (PlannedDate < PurchLine."Expected Receipt Date") then
                                    PlannedDate := PurchLine."Expected Receipt Date";
                            end;
                    end;
                end;
            until ReservationEntry1.Next = 0;
        end
    end;
}

