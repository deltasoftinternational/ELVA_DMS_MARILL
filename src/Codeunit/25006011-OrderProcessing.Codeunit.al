Codeunit 25006011 "Order Processing"
{
    // 15.04.2015 EDMS P21
    //   Modified function:
    //     PurchaseLine3
    // 
    // 23.04.2013 Elva Baltic P15
    //   * Added function DimensionChange


    trigger OnRun()
    begin
    end;

    var
        EDMS001: label 'Document do not exist.';
        Text001: label 'Nonstock Item %1 does not exist.';
        Text002: label 'You have to pick one document.';
        SortNo: Code[20];


    procedure ImportBuffer(DocumentNo: Code[20]; PurchInvImportBuf: Record "Purch. Invoice Import Buffer"; var DataBuffer: Record "Data Buffer"; Preview: Boolean)
    var
        PurchHdr: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        PurchLine2: Record "Purchase Line";
        PurchLine3: Record "Purchase Line";
        TotalTransfer: Decimal;
        UnitPrice: Decimal;
        QtyToTransfer: Decimal;
        EntryNo: Integer;
        LineNo: Integer;
        WhichLine: Integer;
        LineCount: Integer;
        LastOne: Boolean;
        PartialTransfer: Boolean;
        DifferentPartNo: Boolean;
    begin
        PurchInvImportBuf.Reset;
        PurchInvImportBuf.SetRange("Document Type", PurchInvImportBuf."document type"::"Purch. Header");
        if PurchInvImportBuf.Count > 1 then begin
            Commit;
            if Page.RunModal(Page::"Purch. Invoice Import Buffer", PurchInvImportBuf) = Action::LookupOK then
                PurchInvImportBuf.SetRange("Invoice No.", PurchInvImportBuf."Invoice No.")
            else
                Error(Text002);
        end;

        PurchaseHeader(PurchHdr, PurchLine2, PurchLine3, DocumentNo);

        //PurchInvImportBuf.RESET;
        PurchInvImportBuf.SetRange("Document Type", PurchInvImportBuf."document type"::"Purch. Line");
        if PurchInvImportBuf.FindFirst then begin
            if PurchHdr."Vendor Invoice No." = '' then begin
                PurchHdr."Vendor Invoice No." := PurchInvImportBuf."Invoice No.";
                PurchHdr.Modify;
            end;
            repeat
                SortNo := '';
                SortNo := PurchInvImportBuf."DeliveredPart No.";
                DifferentPartNo := false;
                if (PurchInvImportBuf."DeliveredPart No." <> PurchInvImportBuf."Odered Part No.") then
                    DifferentPartNo := true;
                ChangeItemNo(PurchInvImportBuf."DeliveredPart No.");
                TotalTransfer := 0;
                PurchLine.Reset;
                PurchLine.SetRange("Document Type", PurchLine."document type"::Order);
                PurchLine.SetFilter("Document No.", '<>%1', PurchHdr."No.");
                PurchLine.SetCurrentkey(Type, "No.");
                PurchLine.SetRange(Type, PurchLine.Type::Item);
                PurchLine.SetRange("No.", PurchInvImportBuf."DeliveredPart No.");
                PurchLine.SetRange("Vendor Order No.", PurchInvImportBuf."Order No.");
                LineCount := PurchLine.Count;
                WhichLine := 0;
                UnitPrice := PurchInvImportBuf."Unit Price";
                if PurchLine.FindFirst and not DifferentPartNo then
                    repeat
                        PurchLine.TestField("Document Type");
                        PurchLine.TestField("Document No.");
                        PurchLine.TestField("Quantity Received", 0);
                        PurchLine.TestField("Buy-from Vendor No.", PurchLine3."Buy-from Vendor No.");
                        PurchLine.TestField("Pay-to Vendor No.", PurchLine3."Pay-to Vendor No.");
                        WhichLine += 1;
                        LastOne := true;
                        PartialTransfer := false;
                        QtyToTransfer := TotalTransfer;
                        if QtyToTransfer = 0 then
                            QtyToTransfer := PurchInvImportBuf."Invoiced Quantity";
                        if ((PurchLine.Quantity < QtyToTransfer) and (LineCount > 1) and (LineCount <> WhichLine)) then begin
                            TotalTransfer := QtyToTransfer - PurchLine.Quantity;
                            QtyToTransfer := PurchLine.Quantity;
                            LastOne := false;
                        end;
                        if PurchLine.Quantity > QtyToTransfer then
                            PartialTransfer := true;

                        if Preview then
                            PreviewLine(DataBuffer, PurchLine, QtyToTransfer, EntryNo, PurchInvImportBuf."Odered Part No.")
                        else
                            MovePurchLine(PurchHdr, PurchLine, PurchLine2, PurchLine3, QtyToTransfer,
                                          PurchInvImportBuf."Unit Price", PartialTransfer);

                    until (PurchLine.Next = 0) or LastOne
                else begin
                    if not Preview then begin
                        PartialTransfer := false;
                        CheckItem(PurchInvImportBuf."DeliveredPart No.");
                        QtyToTransfer := PurchInvImportBuf."Invoiced Quantity";
                        PurchLine3.Validate(Type, PurchLine3.Type::Item);
                        PurchLine3.Validate("No.", PurchInvImportBuf."DeliveredPart No.");
                        //PurchLine3."Vendor Invoice No." := PurchInvImportBuf."Invoice No.";
                        PurchLine3."Vendor Order No." := PurchInvImportBuf."Order No.";
                        LineNo := PurchaseLine2(PurchLine, PurchLine2, PurchLine3,
                                             QtyToTransfer, PartialTransfer, PurchHdr, UnitPrice);
                    end else begin
                        PurchLine.Init;
                        PurchLine."Document Type" := PurchHdr."Document Type";
                        PurchLine."Document No." := DocumentNo;
                        PurchLine."Line No." := 0;
                        PurchLine.Type := PurchLine.Type::Item;
                        PurchLine."No." := PurchInvImportBuf."DeliveredPart No.";
                        PurchLine.Quantity := PurchInvImportBuf."Invoiced Quantity";
                        PreviewLine(DataBuffer, PurchLine, PurchInvImportBuf."Invoiced Quantity", EntryNo,
                                     PurchInvImportBuf."Odered Part No.");
                    end;
                end;
            until PurchInvImportBuf.Next = 0;
        end;
    end;


    procedure PurchaseHeader(var PurchHdr: Record "Purchase Header"; var PurchLine: Record "Purchase Line"; var PurchLine2: Record "Purchase Line"; PurchOrderNo: Code[20])
    begin
        PurchHdr.Reset;
        if not PurchHdr.Get(PurchHdr."document type"::Order, PurchOrderNo) then
            Error(EDMS001);

        PurchLine.Reset;
        PurchLine.SetRange("Document Type", PurchHdr."Document Type");
        PurchLine.SetRange("Document No.", PurchOrderNo);
        if not PurchLine.FindFirst then begin
            PurchLine.Init;
            PurchLine."Document Type" := PurchHdr."Document Type";
            PurchLine."Document No." := PurchOrderNo;
            PurchLine."Buy-from Vendor No." := PurchHdr."Buy-from Vendor No.";
            PurchLine."Pay-to Vendor No." := PurchHdr."Pay-to Vendor No.";
        end;

        PurchLine2.TransferFields(PurchLine);
    end;


    procedure PurchaseLine(PurchLine: Record "Purchase Line"; var PurchLine2: Record "Purchase Line"; PurchLine3: Record "Purchase Line"; QtyToTransfer: Integer; PartialTransfer: Boolean): Integer
    var
        Item: Record Item;
        ItemPriceGroup: Record "Item Price Group";
        DiscountPercent: Decimal;
        LineNo: Integer;
    begin
        LineNo := 0;
        PurchLine2.SetRange("Document Type", PurchLine2."Document Type");
        PurchLine2.SetRange("Document No.", PurchLine2."Document No.");
        if PurchLine2.FindLast then
            LineNo := PurchLine2."Line No.";

        LineNo := LineNo + 10000;

        DiscountPercent := PurchLine."Line Discount %";
        Item.Get(PurchLine2."No.");
        ItemPriceGroup.SetRange(Code, Item."Item Price Group Code");
        if ItemPriceGroup.FindFirst then
            DiscountPercent := ItemPriceGroup."Purchase Discount Percent";

        PurchLine2.Init;
        PurchLine2.TransferFields(PurchLine);
        PurchLine2."Document Type" := PurchLine3."Document Type";
        PurchLine2."Document No." := PurchLine3."Document No.";
        PurchLine2."Line No." := LineNo;

        if PartialTransfer then begin
            PurchLine2.Validate(Quantity, QtyToTransfer);
            if DiscountPercent <> 0 then
                PurchLine2.Validate("Line Discount %", DiscountPercent);
        end;

        PurchLine2.Insert;

        exit(LineNo);
    end;


    procedure PurchaseLine2(PurchLine: Record "Purchase Line"; var PurchLine2: Record "Purchase Line"; PurchLine3: Record "Purchase Line"; QtyToTransfer: Integer; ClearLine: Boolean; PurchHdr: Record "Purchase Header"; UnitCost: Decimal): Integer
    var
        Item: Record Item;
        ItemPriceGroup: Record "Item Price Group";
        WMSManagement: Codeunit "WMS Management";
        LineNo: Integer;
        DiscountPercent: Decimal;
    begin
        LineNo := 0;
        PurchLine2.SetRange("Document Type", PurchLine2."Document Type");
        PurchLine2.SetRange("Document No.", PurchLine2."Document No.");

        if PurchLine2.FindLast then
            LineNo := PurchLine2."Line No.";

        if ClearLine then
            Item.Get(PurchLine3."No.")
        else
            Item.Get(PurchLine."No.");
        ItemPriceGroup.SetRange(Code, Item."Item Price Group Code");
        if ItemPriceGroup.FindFirst then
            DiscountPercent := ItemPriceGroup."Purchase Discount Percent";

        LineNo := LineNo + 10000;
        if not ClearLine then begin
            PurchLine2.Init;
            PurchLine2.TransferFields(PurchLine);
            PurchLine2."Document Type" := PurchLine3."Document Type";
            PurchLine2."Document No." := PurchLine3."Document No.";
            PurchLine2."Line No." := LineNo;
            PurchLine2.Validate(Quantity, QtyToTransfer);
            PurchLine2.Validate("Direct Unit Cost", UnitCost);
            if DiscountPercent <> 0 then
                PurchLine2.Validate("Line Discount %", DiscountPercent);
            PurchLine2.Insert(true);
        end
        else begin
            PurchLine2.Init;
            PurchLine2.TransferFields(PurchLine3);
            PurchLine2."Line No." := LineNo;
            PurchLine2.Validate(Quantity, QtyToTransfer);
            PurchLine2.Insert;
            if PurchLine2."Location Code" <> PurchHdr."Location Code" then
                PurchLine2.Validate("Location Code", PurchHdr."Location Code");
            if PurchLine2."Bin Code" = '' then
                WMSManagement.GetDefaultBin(PurchLine2."No.", PurchLine2."Variant Code",
                                            PurchLine2."Location Code", PurchLine2."Bin Code");
            PurchLine2.Validate("Direct Unit Cost", UnitCost);
            if DiscountPercent <> 0 then
                PurchLine2.Validate("Line Discount %", DiscountPercent);
            PurchLine2.Modify(true);
        end;
        exit(LineNo);
    end;


    procedure PurchaseLine3(PurchLine: Record "Purchase Line"; var PurchLine2: Record "Purchase Line"; PurchLine3: Record "Purchase Line"; QtyToTransfer: Decimal; UnitPrice: Decimal; Discount: Decimal; ClearLine: Boolean; PurchHdr: Record "Purchase Header"; LineDescription: Text[30]; LocationCode: Text[30]; BinCode: Text[30]): Integer
    var
        Item: Record Item;
        ItemPriceGroup: Record "Item Price Group";
        BinContent: Record "Bin Content";
        LineNo: Integer;
    begin
        LineNo := 0;
        PurchLine2.SetRange("Document Type", PurchLine2."Document Type");
        PurchLine2.SetRange("Document No.", PurchLine2."Document No.");
        if PurchLine2.FindLast then
            LineNo := PurchLine2."Line No.";

        if ClearLine then
            Item.Get(PurchLine3."No.")
        else
            Item.Get(PurchLine."No.");
        ItemPriceGroup.SetRange(Code, Item."Item Price Group Code");
        if ItemPriceGroup.FindFirst then
            Discount := ItemPriceGroup."Purchase Discount Percent";

        LineNo := LineNo + 10000;
        if not ClearLine then begin
            PurchLine2.Init;
            PurchLine2.TransferFields(PurchLine);
            PurchLine2."Document Type" := PurchLine3."Document Type";
            PurchLine2."Document No." := PurchLine3."Document No.";
            PurchLine2."Line No." := LineNo;
            if LocationCode <> '' then
                PurchLine2.Validate("Location Code", LocationCode);
            if BinCode <> '' then
                PurchLine2.Validate("Bin Code", BinCode);
            PurchLine2.Validate(Quantity, QtyToTransfer);
            if UnitPrice <> 0 then     // 15.04.2015 EDMS P21
                PurchLine2.Validate("Direct Unit Cost", UnitPrice);
            PurchLine2.Validate("Line Discount %", Discount);
            if LineDescription <> '' then
                PurchLine2.Validate(Description, LineDescription);
            PurchLine2.Insert(true);
        end
        else begin
            PurchLine2.Init;
            PurchLine2.TransferFields(PurchLine3);
            PurchLine2."Line No." := LineNo;
            PurchLine2.Validate(Quantity, QtyToTransfer);
            PurchLine2.Insert(true);
            if LocationCode <> '' then
                PurchLine2.Validate("Location Code", LocationCode)
            else
                PurchLine2.Validate("Location Code", PurchHdr."Location Code");
            if BinCode <> '' then
                PurchLine2.Validate("Bin Code", BinCode);
            if UnitPrice <> 0 then     // 15.04.2015 EDMS P21
                PurchLine2.Validate("Direct Unit Cost", UnitPrice);
            PurchLine2.Validate("Line Discount %", Discount);
            if LineDescription <> '' then
                PurchLine2.Validate(Description, LineDescription);
            if PurchLine2."Bin Code" = '' then
                FillBin(PurchLine2);
            PurchLine2."Expected Receipt Date" := PurchLine3."Expected Receipt Date";
            PurchLine2.Modify(true);
        end;
        exit(LineNo);
    end;


    procedure ReservationTransfer(PurchLine: Record "Purchase Line"; PurchLine2: Record "Purchase Line")
    var
        ReservEntry: Record "Reservation Entry";
    begin
        PurchLine.CalcFields("Reserved Quantity");
        if PurchLine."Reserved Quantity" > 0 then begin
            ReservEntry.Reset;
            ReservEntry.SetRange("Source Type", Database::"Purchase Line");
            ReservEntry.SetRange("Source Subtype", PurchLine."Document Type");
            ReservEntry.SetRange("Source ID", PurchLine."Document No.");
            ReservEntry.SetRange("Source Ref. No.", PurchLine."Line No.");
            ReservEntry.SetRange("Reservation Status", ReservEntry."reservation status"::Reservation);
            if ReservEntry.FindSet then
                repeat
                    ChangeReservationSource(ReservEntry."Entry No.", PurchLine2);
                until ReservEntry.Next = 0;
        end;
    end;


    procedure ReservationTransferItemChange(PurchLine: Record "Purchase Line"; ItemNo: Code[20])
    var
        ReservEntry: Record "Reservation Entry";
    begin
        PurchLine.CalcFields("Reserved Quantity");
        if PurchLine."Reserved Quantity" > 0 then begin
            ReservEntry.Reset;
            ReservEntry.SetRange("Source Type", Database::"Purchase Line");
            ReservEntry.SetRange("Source Subtype", PurchLine."Document Type");
            ReservEntry.SetRange("Source ID", PurchLine."Document No.");
            ReservEntry.SetRange("Source Ref. No.", PurchLine."Line No.");
            ReservEntry.SetRange("Reservation Status", ReservEntry."reservation status"::Reservation);
            if ReservEntry.FindSet then
                repeat
                    ChangeReservationSourceItem(ReservEntry."Entry No.", ItemNo, PurchLine."No.", PurchLine);
                until ReservEntry.Next = 0;
        end;
    end;


    procedure PartialReservationTransfer(PurchLine: Record "Purchase Line"; PurchLine2: Record "Purchase Line"; var QtyToTransfer: Decimal)
    var
        ReservEntry: Record "Reservation Entry";
        QtyToTransferR: Decimal;
    begin
        PurchLine.CalcFields("Reserved Quantity");
        if PurchLine."Reserved Quantity" > 0 then begin
            QtyToTransferR := QtyToTransfer;
            ReservEntry.Reset;
            ReservEntry.SetRange("Source Type", Database::"Purchase Line");
            ReservEntry.SetRange("Source Subtype", PurchLine."Document Type");
            ReservEntry.SetRange("Source ID", PurchLine."Document No.");
            ReservEntry.SetRange("Source Ref. No.", PurchLine."Line No.");
            ReservEntry.SetRange("Reservation Status", ReservEntry."reservation status"::Reservation);
            if ReservEntry.FindSet then
                repeat
                    if QtyToTransferR <> 0 then begin
                        if ReservEntry.Quantity <= QtyToTransferR then begin
                            ChangeReservationSource(ReservEntry."Entry No.", PurchLine2);
                            QtyToTransferR -= ReservEntry.Quantity;
                        end
                        else //recReservEntry.quantity > QtyToTransferR
                         begin
                            SplitReservation(ReservEntry."Entry No.", ReservEntry.Quantity - QtyToTransferR, PurchLine2);
                            QtyToTransferR := 0;
                        end;
                    end;
                until ReservEntry.Next = 0;
        end;
    end;


    procedure PartialReservationTransferItem(PurchLine: Record "Purchase Line"; PurchLineNew: Record "Purchase Line"; var QtyToTransfer: Decimal)
    var
        ReservEntry: Record "Reservation Entry";
        QtyToTransferR: Decimal;
    begin
        PurchLine.CalcFields("Reserved Quantity");
        if PurchLine."Reserved Quantity" > 0 then begin
            QtyToTransferR := QtyToTransfer;
            ReservEntry.Reset;
            ReservEntry.SetRange("Source Type", Database::"Purchase Line");
            ReservEntry.SetRange("Source Subtype", PurchLine."Document Type");
            ReservEntry.SetRange("Source ID", PurchLine."Document No.");
            ReservEntry.SetRange("Source Ref. No.", PurchLine."Line No.");
            ReservEntry.SetRange("Reservation Status", ReservEntry."reservation status"::Reservation);
            if ReservEntry.FindSet then
                repeat
                    if QtyToTransferR <> 0 then begin
                        if ReservEntry.Quantity <= QtyToTransferR then begin
                            ChangeReservationSourceItem(ReservEntry."Entry No.", PurchLineNew."No.", PurchLine."No.", PurchLineNew);
                            QtyToTransferR -= ReservEntry.Quantity;
                        end
                        else //recReservEntry.quantity > QtyToTransferR
                         begin
                            SplitReservationItemChange(ReservEntry."Entry No.", PurchLine.Quantity - QtyToTransferR, PurchLineNew);
                            QtyToTransferR := 0;
                        end;
                    end;
                until ReservEntry.Next = 0;
        end;
    end;


    procedure ChangeReservationSource(ResEntryNo: Integer; PurchLine: Record "Purchase Line")
    var
        ReservEntry: Record "Reservation Entry";
    begin
        ReservEntry.Reset;
        ReservEntry.Get(ResEntryNo, true);
        ReservEntry."Source Subtype" := PurchLine."Document Type";
        ReservEntry."Source ID" := PurchLine."Document No.";
        ReservEntry."Source Ref. No." := PurchLine."Line No.";
        ReservEntry.Modify;
    end;


    procedure ChangeReservationSourceItem(ResEntryNo: Integer; NewItemNo: Code[20]; ItemNo: Code[20]; PurchLine: Record "Purchase Line")
    var
        ReservEntry: Record "Reservation Entry";
        ReservEntry2: Record "Reservation Entry" temporary;
        ReservEntry3: Record "Reservation Entry";
        SalesLine: Record "Sales Line";
        VendorOrderNo: Text[30];
        BaseQty: Integer;
    begin
        VendorOrderNo := PurchLine."Vendor Order No.";
        CheckReservationEntries(ResEntryNo);

        ReservEntry.Get(ResEntryNo, true);
        ReservEntry.Validate("Item No.", NewItemNo);
        BaseQty := ReservEntry."Quantity (Base)";
        ReservEntry.Validate("Quantity (Base)", 0);
        ReservEntry.Modify;

        PurchLine.Validate("No.", NewItemNo);
        PurchLine.Validate("Vendor Order No.", VendorOrderNo);
        PurchLine.Modify;

        ReservEntry.Validate("Quantity (Base)", BaseQty);
        ReservEntry.Modify;

        if ReservEntry.Get(ResEntryNo, false) then begin
            ReservEntry.Validate("Item No.", NewItemNo);
            ReservEntry2.TransferFields(ReservEntry);
            ReservEntry.Delete;

            SalesLine.Reset;
            SalesLine.SetRange("Document Type", SalesLine."document type"::Order);
            SalesLine.SetRange("Document No.", ReservEntry."Source ID");
            SalesLine.SetRange(Type, SalesLine.Type::Item);
            SalesLine.SetRange("No.", ItemNo);
            //SalesLine.SETRANGE(Quantity, ABS(ReservEntry."Quantity (Base)"));
            if SalesLine.FindFirst then begin
                SalesLine.Validate("No.", NewItemNo);
                SalesLine.Modify;
            end;
            ReservEntry.TransferFields(ReservEntry2);
            ReservEntry.Insert;
        end;
    end;


    procedure CheckReservationEntries(ResEntryNo: Integer)
    var
        ReservEntry: Record "Reservation Entry";
        ReservEntry2: Record "Reservation Entry";
        ReservEntry3: Record "Reservation Entry";
        SalesLine: Record "Sales Line";
        SalesLineNew: Record "Sales Line";
        ExistQty: Integer;
        SalesLineNo: Integer;
    begin
        ExistQty := 0;
        ReservEntry.Reset;
        if ReservEntry.Get(ResEntryNo, false) then begin
            SalesLine.Reset;
            SalesLine.SetRange("Document Type", SalesLine."document type"::Order);
            SalesLine.SetRange("Document No.", ReservEntry."Source ID");
            if SalesLine.FindLast then
                SalesLineNo := SalesLine."Line No." + 10000
            else
                SalesLineNo := 10000;

            ReservEntry2.Reset;
            ReservEntry2.SetRange("Item No.", ReservEntry."Item No.");
            ReservEntry2.SetRange("Location Code", ReservEntry."Location Code");
            ReservEntry2.SetRange("Reservation Status", ReservEntry2."reservation status"::Reservation);
            ReservEntry2.SetRange("Source ID", ReservEntry."Source ID");
            ReservEntry2.SetRange("Source Ref. No.", ReservEntry."Source Ref. No.");
            ReservEntry2.SetFilter("Entry No.", '<>%1', ReservEntry."Entry No.");
            if ReservEntry2.FindFirst then
                repeat
                    ReservEntry3.Reset;
                    ReservEntry3.Get(ReservEntry2."Entry No.", true);
                    ExistQty += ReservEntry3."Quantity (Base)";
                    ReservEntry2."Source Ref. No." := SalesLineNo;
                    ReservEntry2.Modify;
                // END;
                until ReservEntry2.Next = 0;
        end;

        if ExistQty = 0 then
            exit;
        SalesLine.Reset;
        SalesLine.SetRange("Document Type", SalesLine."document type"::Order);
        SalesLine.SetRange("Document No.", ReservEntry."Source ID");
        SalesLine.SetRange("Line No.", ReservEntry."Source Ref. No.");
        if SalesLine.FindFirst then begin
            SalesLineNew.Init;
            SalesLineNew.TransferFields(SalesLine);
            SalesLineNew.Validate("Line No.", SalesLineNo);
            SalesLineNew.Validate(Quantity, ExistQty);
            SalesLineNew.Insert(true);
            //  DimensionChangeSalesLine(SalesLine, SalesLineNo);//30.10.2012 EDMS
            SalesLine.Validate(Quantity, SalesLine.Quantity - ExistQty);
            SalesLine.Modify(true);
        end;
    end;


    procedure SplitReservation(ResEntryNo: Integer; QtyToLeave: Decimal; PurchLine: Record "Purchase Line")
    var
        ReservEntry: Record "Reservation Entry";
        ReservEntry2: Record "Reservation Entry";
        ReservEntry3: Record "Reservation Entry";
        NewEntryNo: Integer;
    begin
        ReservEntry.LockTable;
        ReservEntry.Reset;
        ReservEntry.FindLast;
        NewEntryNo := ReservEntry."Entry No." + 1;

        ReservEntry2.Reset;
        ReservEntry2.SetRange("Entry No.", ResEntryNo);
        if ReservEntry2.FindFirst then
            repeat
                ReservEntry3.Init;
                ReservEntry3.TransferFields(ReservEntry2);
                ReservEntry3."Entry No." := NewEntryNo;

                if ReservEntry2.Positive then begin
                    ReservEntry3."Source Subtype" := PurchLine."Document Type";
                    ReservEntry3."Source ID" := PurchLine."Document No.";
                    ReservEntry3."Source Ref. No." := PurchLine."Line No.";

                    ReservEntry3."Quantity (Base)" := ReservEntry3."Quantity (Base)" - QtyToLeave;
                    ReservEntry3.Quantity := ReservEntry3.Quantity - QtyToLeave;
                    ReservEntry3."Qty. to Handle (Base)" := ReservEntry3."Qty. to Handle (Base)" - QtyToLeave;
                    ReservEntry3."Qty. to Invoice (Base)" := ReservEntry3."Qty. to Invoice (Base)" - QtyToLeave;

                    ReservEntry2."Quantity (Base)" := QtyToLeave;
                    ReservEntry2.Quantity := QtyToLeave;
                    ReservEntry2."Qty. to Handle (Base)" := QtyToLeave;
                    ReservEntry2."Qty. to Invoice (Base)" := QtyToLeave;
                    ReservEntry2.Modify;
                end
                else begin
                    ReservEntry3."Quantity (Base)" := ReservEntry3."Quantity (Base)" + QtyToLeave;
                    ReservEntry3.Quantity := ReservEntry3.Quantity + QtyToLeave;
                    ReservEntry3."Qty. to Handle (Base)" := ReservEntry3."Qty. to Handle (Base)" + QtyToLeave;
                    ReservEntry3."Qty. to Invoice (Base)" := ReservEntry3."Qty. to Invoice (Base)" + QtyToLeave;

                    ReservEntry2."Quantity (Base)" := -QtyToLeave;
                    ReservEntry2.Quantity := -QtyToLeave;
                    ReservEntry2."Qty. to Handle (Base)" := -QtyToLeave;
                    ReservEntry2."Qty. to Invoice (Base)" := -QtyToLeave;
                    ReservEntry2.Modify;

                end;
                ReservEntry3.Insert;
            until ReservEntry2.Next = 0;
    end;


    procedure SplitReservationItemChange(ResEntryNo: Integer; QtyToLeave: Decimal; PurchLine: Record "Purchase Line")
    var
        ReservEntry: Record "Reservation Entry";
        ReservEntry2: Record "Reservation Entry";
        ReservEntry3: Record "Reservation Entry";
        SalesLine: Record "Sales Line";
        NewSalesLine: Record "Sales Line";
        StartQty: Decimal;
        NewEntryNo: Integer;
        SalesLineNo: Integer;
    begin
        CheckReservationEntries(ResEntryNo);

        ReservEntry.LockTable;
        ReservEntry.Reset;
        ReservEntry.FindLast;
        NewEntryNo := ReservEntry."Entry No." + 1;

        ReservEntry2.Reset;
        ReservEntry2.SetRange("Entry No.", ResEntryNo);
        if ReservEntry2.FindFirst then begin
            StartQty := Abs(ReservEntry2."Quantity (Base)");
            repeat
                ReservEntry3.Init;
                ReservEntry3.TransferFields(ReservEntry2);
                ReservEntry3."Entry No." := NewEntryNo;
                ReservEntry3."Item No." := PurchLine."No.";

                if ReservEntry2.Positive then begin
                    ReservEntry3."Source Ref. No." := PurchLine."Line No.";
                    ReservEntry3."Quantity (Base)" := StartQty - QtyToLeave;
                    ReservEntry3.Quantity := StartQty - QtyToLeave;
                    ReservEntry3."Qty. to Handle (Base)" := StartQty - QtyToLeave;
                    ReservEntry3."Qty. to Invoice (Base)" := StartQty - QtyToLeave;

                    ReservEntry2."Quantity (Base)" := QtyToLeave;
                    ReservEntry2.Quantity := QtyToLeave;
                    ReservEntry2."Qty. to Handle (Base)" := QtyToLeave;
                    ReservEntry2."Qty. to Invoice (Base)" := QtyToLeave;
                    ReservEntry2.Modify;
                end
                else begin
                    SalesLine.Reset;
                    SalesLine.SetRange("Document Type", SalesLine."document type"::Order);
                    SalesLine.SetRange("Document No.", ReservEntry2."Source ID");
                    if SalesLine.FindLast then
                        SalesLineNo := SalesLine."Line No."
                    else
                        SalesLineNo := 0;
                    SalesLine.SetRange(Type, SalesLine.Type::Item);
                    SalesLine.SetRange("No.", ReservEntry2."Item No.");
                    SalesLine.SetRange(Quantity, Abs(ReservEntry2."Quantity (Base)"));
                    if SalesLine.FindFirst then begin
                        SalesLineNo += 10000;
                        NewSalesLine.TransferFields(SalesLine);
                        NewSalesLine."Line No." := SalesLineNo;
                        NewSalesLine.Validate("No.", PurchLine."No.");
                        NewSalesLine.Validate(Quantity, SalesLine.Quantity - QtyToLeave);
                        NewSalesLine.Insert(true);

                        SalesLine.Validate(Quantity, QtyToLeave);
                        SalesLine.Modify(true);
                    end;
                    ReservEntry3."Source Ref. No." := SalesLineNo;
                    ReservEntry3."Quantity (Base)" := ReservEntry3."Quantity (Base)" + QtyToLeave;
                    ReservEntry3.Quantity := ReservEntry3.Quantity + QtyToLeave;
                    ReservEntry3."Qty. to Handle (Base)" := ReservEntry3."Qty. to Handle (Base)" + QtyToLeave;
                    ReservEntry3."Qty. to Invoice (Base)" := ReservEntry3."Qty. to Invoice (Base)" + QtyToLeave;

                    ReservEntry2."Quantity (Base)" := -QtyToLeave;
                    ReservEntry2.Quantity := -QtyToLeave;
                    ReservEntry2."Qty. to Handle (Base)" := -QtyToLeave;
                    ReservEntry2."Qty. to Invoice (Base)" := -QtyToLeave;
                    ReservEntry2.Modify;
                end;
                ReservEntry3.Insert;
            until ReservEntry2.Next = 0;
        end;
    end;


    procedure FillBin(var PurchaseLine: Record "Purchase Line")
    var
        BinContent: Record "Bin Content";
    begin
        BinContent.Reset;
        BinContent.SetCurrentkey("Item No.");
        BinContent.SetRange("Item No.", PurchaseLine."No.");
        BinContent.SetRange("Location Code", PurchaseLine."Location Code");
        if not BinContent.FindFirst then
            exit;

        BinContent.SetRange(Default, true);
        if BinContent.FindFirst then begin
            PurchaseLine.Validate("Bin Code", BinContent."Bin Code");
            exit;
        end;

        BinContent.SetRange(Default);
        if BinContent.FindFirst then
            PurchaseLine.Validate("Bin Code", BinContent."Bin Code");
    end;


    procedure PreviewLine(var DataBuffer: Record "Data Buffer"; PurchLine: Record "Purchase Line"; QtyToTransfer: Decimal; var EntryNo: Integer; OderedSortNo: Code[25])
    begin
        EntryNo += 1;
        DataBuffer.Init;
        DataBuffer."Entry No." := EntryNo;
        DataBuffer."Text Field 1" := Format(PurchLine."Document Type");
        DataBuffer."Code Field 1" := PurchLine."Document No.";
        DataBuffer."Code Field 2" := Format(PurchLine."Line No.");
        DataBuffer."Text Field 2" := PurchLine."No.";
        DataBuffer."Text Field 3" := PurchLine.Description;
        DataBuffer."Text Field 4" := SortNo;
        DataBuffer."Text Field 5" := OderedSortNo;
        ChangeItemNo(OderedSortNo);
        DataBuffer."Text Field 6" := OderedSortNo;
        DataBuffer."Decimal Field 1" := PurchLine.Quantity;
        DataBuffer."Decimal Field 2" := PurchLine.Quantity - QtyToTransfer;
        DataBuffer."Decimal Field 3" := QtyToTransfer;
        DataBuffer.Insert;
    end;


    procedure CheckItem(var ItemCode: Code[25])
    var
        Item: Record Item;
        NonstockItem: Record "Nonstock Item";
        NonstockItemEntryRef: Record "Nonstock Item Entry Reference";
        NonstockItemMgt: Codeunit "Catalog Item Management";
    begin
        if Item.Get(ItemCode) then
            exit;

        if not NonstockItem.Get(CopyStr(ItemCode, 1, 20)) then begin
            NonstockItem.SetCurrentkey("Vendor Item No.");
            NonstockItem.SetRange("Vendor Item No.", ItemCode);
            if not NonstockItem.FindFirst then
                Error(StrSubstNo(Text001, ItemCode));
        end;

        if NonstockItem."Item No." <> '' then begin
            ItemCode := NonstockItem."Item No.";
            exit;
        end;

        NonstockItemMgt.NonstockAutoItem(NonstockItem);

        NonstockItem.Get(NonstockItem."Entry No.");
        ItemCode := NonstockItem."Item No.";
    end;


    procedure ChangeItemNo(var ItemCode: Code[25])
    var
        Item: Record Item;
        NonstockItem: Record "Nonstock Item";
        NonstockItemEntryRef: Record "Nonstock Item Entry Reference";
        NonstockItemMgt: Codeunit "Catalog Item Management";
    begin
        NonstockItemEntryRef.Reset;
        NonstockItemEntryRef.Get(ItemCode);

        ItemCode := NonstockItemEntryRef."Entry Format Item No.";

        if Item.Get(ItemCode) then
            exit;

        Item.SetCurrentkey("Vendor Item No.");
        Item.SetRange("Vendor Item No.", ItemCode);
        if Item.FindFirst then begin
            ItemCode := Item."No.";
            exit;
        end;

        if not NonstockItem.Get(CopyStr(ItemCode, 1, 20)) then begin
            NonstockItem.SetCurrentkey("Vendor Item No.");
            NonstockItem.SetRange("Vendor Item No.", ItemCode);
            if NonstockItem.FindFirst then;
        end;

        if NonstockItem."Item No." <> '' then begin
            ItemCode := NonstockItem."Item No.";
            exit;
        end;
    end;


    procedure ChangeLines(PurchInvImportBuf: Record "Purch. Invoice Import Buffer"; PurchLine3: Record "Purchase Line")
    var
        PurchLine: Record "Purchase Line";
        PurchLine2: Record "Purchase Line";
        PurchLineNew: Record "Purchase Line";
        QtyToTransfer: Decimal;
        totalTransfer: Decimal;
        PurchLineNo: Integer;
        PartialTransfer: Boolean;
        LastOne: Boolean;
    begin
        PurchLine.Reset;
        PurchLine.SetRange("Document Type", PurchLine."document type"::Order);
        PurchLine.SetCurrentkey(Type, "No.");
        PurchLine.SetRange(Type, PurchLine.Type::Item);
        PurchLine.SetRange("No.", PurchInvImportBuf."Odered Part No.");
        if PurchLine.FindFirst then
            repeat
                CheckItem(PurchInvImportBuf."DeliveredPart No.");
                PurchLine.TestField("Document Type");
                PurchLine.TestField("Document No.");
                PurchLine.TestField("Quantity Received", 0);
                PurchLine.TestField("Buy-from Vendor No.", PurchLine3."Buy-from Vendor No.");
                PurchLine.TestField("Pay-to Vendor No.", PurchLine3."Pay-to Vendor No.");

                PurchLine2.Reset;
                PurchLine2.SetRange("Document Type", PurchLine."Document Type");
                PurchLine2.SetRange("Document No.", PurchLine."Document No.");
                if PurchLine2.FindLast then
                    PurchLineNo := PurchLine2."Line No."
                else
                    PurchLineNo := 0;

                PartialTransfer := false;
                QtyToTransfer := totalTransfer;
                LastOne := true;
                if QtyToTransfer = 0 then
                    QtyToTransfer := PurchInvImportBuf."Invoiced Quantity";
                if (PurchLine.Quantity < QtyToTransfer) then begin
                    totalTransfer := QtyToTransfer - PurchLine.Quantity;
                    QtyToTransfer := PurchLine.Quantity;
                    LastOne := false;
                end;
                if PurchLine.Quantity > QtyToTransfer then
                    PartialTransfer := true;

                if PartialTransfer then begin
                    PurchLineNo += 10000;
                    PurchLineNew.Init;
                    PurchLineNew.TransferFields(PurchLine);
                    PurchLineNew."Line No." := PurchLineNo;
                    PurchLineNew.Validate("No.", PurchInvImportBuf."DeliveredPart No.");
                    PurchLineNew.Validate(Quantity, QtyToTransfer);
                    PurchLineNew.Insert(true);
                    //      DimensionChangeItemChange(PurchLine, PurchLineNo);//30.10.2012 EDMS
                end;

                if PartialTransfer then
                    PartialReservationTransferItem(PurchLine, PurchLineNew, QtyToTransfer)
                else
                    ReservationTransferItemChange(PurchLine, PurchInvImportBuf."DeliveredPart No.");

                if PartialTransfer then begin
                    PurchLine.Validate(Quantity, PurchLine.Quantity - QtyToTransfer);
                    PurchLine.Modify(true);
                end;

            until (PurchLine.Next = 0) or LastOne;
    end;


    procedure MovePurchLine(PurchHdr: Record "Purchase Header"; PurchLine: Record "Purchase Line"; PurchLine2: Record "Purchase Line"; PurchLine3: Record "Purchase Line"; QtyToTransfer: Decimal; UnitPrice: Decimal; PartialTransfer: Boolean)
    var
        LineNo: Integer;
    begin
        LineNo := PurchaseLine2(PurchLine, PurchLine2, PurchLine3, QtyToTransfer,
                                PartialTransfer, PurchHdr, UnitPrice);
        if PartialTransfer then
            PartialReservationTransfer(PurchLine, PurchLine2, QtyToTransfer)
        else
            ReservationTransfer(PurchLine, PurchLine2);

        //DimensionChange(PurchLine, PurchLine3, LineNo, PartialTransfer);//30.10.2012 EDMS
        if PartialTransfer then begin
            PurchLine.Validate(Quantity, PurchLine.Quantity - QtyToTransfer);
            PurchLine.Modify(true);
        end
        else
            PurchLine.Delete(true);
    end;


    procedure DimensionChange(PurchLinePar: Record "Purchase Line"; var PurchLine3Par: Record "Purchase Line"; LineNoPar: Integer)
    begin
        // 23.04.2013 Elva Baltic P15
        if PurchLine3Par.Get(PurchLine3Par."Document Type", PurchLine3Par."Document No.", LineNoPar) then   //just in case - to set the cursor correctly
            PurchLine3Par."Dimension Set ID" := PurchLinePar."Dimension Set ID";
    end;
}

