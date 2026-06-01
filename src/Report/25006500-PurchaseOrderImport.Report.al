Report 25006500 "Purchase Order Import"
{
    // 15.04.2015 EDMS P21
    //   Modified procedure:
    //     ProceedLine
    //   Added to Request Page:
    //     Don't move lines
    // 
    // 12.03.2015 EDMS P21
    //   Modified procedure:
    //     ProceedLine (don't need to delete spaces)
    // 
    // 23.04.2013 Elva Baltic P15
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/PurchaseOrderImport.rdlc';


    dataset
    {
        dataitem("Purchase Header"; "Purchase Header")
        {
            RequestFilterFields = "Document Type", "No.";
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                PurchOrderNo := "Purchase Header"."No.";
                ImportFromExcel
            end;
        }
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = sorting(Number);
            PrintOnlyIfDetail = false;
            column(ReportForNavId_2; 2)
            {
            }
            column(DocumentType_Integer; ReportDataBuffer1."Text Field 1")
            {
            }
            column(DocumentNo_Integer; ReportDataBuffer1."Code Field 1")
            {
            }
            column(DocumentLineNo_Integer; ReportDataBuffer1."Code Field 2")
            {
            }
            column(No_Integer; ReportDataBuffer1."Text Field 2")
            {
            }
            column(Description_Integer; ReportDataBuffer1."Text Field 6")
            {
            }
            column(OriginalQty_Integer; ReportDataBuffer1."Decimal Field 1")
            {
            }
            column(RestQty_Integer; ReportDataBuffer1."Decimal Field 2")
            {
            }
            column(QtyInNewOrder_Integer; ReportDataBuffer1."Decimal Field 3")
            {
            }
            column(EntryType_Integer; ReportDataBuffer1."Text Field 4")
            {
            }
            column(BuyFromVendorNo_Integer; ReportDataBuffer1."Text Field 5")
            {
            }
            column(OrderDate_Integer; Format(ReportDataBuffer1."Date Field 1"))
            {
            }
            column(Amount_Integer; ReportDataBuffer1."Decimal Field 4")
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then
                    ReportDataBuffer1.FindFirst
                else
                    ReportDataBuffer1.Next;
            end;

            trigger OnPreDataItem()
            begin
                if not Preview_ then
                    CurrReport.Break;
                ReportDataBuffer1.Reset;
                SetRange(Number, 1, ReportDataBuffer1.Count);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field("<Control3>"; FileName)
                    {
                        ApplicationArea = Basic;
                        Caption = 'File Name';

                        trigger OnAssistEdit()
                        begin
                            //FileName := CommonDialogMgt.OpenFile(Text001,'',2,'',0);
                            RequestFile;
                            // SheetName := ExcelBuf.SelectSheetsName(ServerFileName);
                            TempBlob.CreateInStream(ExcelStream);
                            SheetName := ExcelBuf.SelectSheetsNameStream(ExcelStream)
                        end;

                        trigger OnValidate()
                        begin
                            FileNameOnAfterValidate;
                        end;
                    }
                    field("<Control2>"; SheetName)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Sheet Name';

                        trigger OnAssistEdit()
                        begin
                            if ServerFileName = '' then
                                RequestFile;
                            TempBlob.CreateInStream(ExcelStream);
                            SheetName := ExcelBuffer.SelectSheetsNameStream(ExcelStream);
                        end;
                    }
                    field(OrderTypePriceCode; OrderTypePriceCode)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Order Type Price Code';
                        TableRelation = "Ordering Price Type";
                    }
                    field(Preview; Preview_)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show  Preview';
                    }
                    field(StartLineNo; StartLineNo)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Start Line No.';
                    }
                    field(DontMoveLines; DontMoveLines)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Don''t move lines';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            FileName := '';
            SheetName := '';
        end;
    }

    labels
    {
        DocTypeLbl = 'Document Type';
        DocNoLbl = 'Document No.';
        DocLineNoLbl = 'Document Line No.';
        NoLbl = 'No.';
        DescrLbl = 'Description';
        OrigQtyLbl = 'Original Qty';
        RestQtyLbl = 'Rest Qty';
        QtyInNewOrdLbl = 'Qty in New Order';
        EntryTypeLbl = 'Entry Type';
        BuyFrVendNoLbl = 'Buy-From Vendor No.';
        OrderDateLbl = 'Order Date';
        AmtLbl = 'Amount';
    }

    var
        ExcelBuffer: Record "Excel Buffer" temporary;
        ExcelBuf: Record "Excel Buffer" temporary;
        SalesHdr: Record "Sales Header";
        SalesLine: Record "Sales Line";
        SalesInvHdr: Record "Sales Invoice Header";
        SalesInvLine: Record "Sales Invoice Line";
        PurchHdr: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        PurchLine2: Record "Purchase Line";
        PurchLine3: Record "Purchase Line";
        PurchLineTemp: Record "Purchase Line" temporary;
        ReportDataBuffer1: Record "Data Buffer" temporary;
        OrderProcessing: Codeunit "Order Processing";
        FileMgt: Codeunit "File Management";
        PurchOrderNo: Code[20];
        ServerFileName: Text;
        FileName: Text[300];
        SheetName: Text[300];
        LineDescription: Text[30];
        OrderTypePriceCode: Text[250];
        BinCode: Text[30];
        LocationCode: Text[30];
        UnitPrice: Decimal;
        LineAmount: Decimal;
        Discount: Decimal;
        QtyToTransfer: Decimal;
        ReportEntryNo: Integer;
        RowNo: Integer;
        Export: Boolean;
        PartialTransfer: Boolean;
        Preview_: Boolean;
        StartLineNo: Integer;
        DataMasive: array[11] of Text[30];
        PurchDate: Date;
        TotalTransfer: Decimal;
        LineCount: Integer;
        WhichLine: Integer;
        LineNo: Integer;
        LastOne: Boolean;
        CurrRowNo: Integer;
        PrevRowNo: Integer;
        EDMS001: label 'Data';
        EDMS002: label 'Item %1 doesn''t exist!';
        EDMS003: label '<''>';
        Text001: label 'Import from file';
        Text002: label 'Import completed';
        Text006: label 'Import Excel File';
        Text022: label 'You must enter a file name.';
        DontMoveLines: Boolean;
        FileManagement: Codeunit "File Management";
        ExcelStream: InStream;
        TempBlob: Codeunit "Temp Blob";

    procedure ImportFromExcel()
    begin
        ReadExcelSheet;
        OrderProcessing.PurchaseHeader(PurchHdr, PurchLine2, PurchLine3, PurchOrderNo);

        if ExcelBuffer.FindFirst then
            if StartLineNo > ExcelBuffer."Row No." then
                repeat
                    ExcelBuffer.Next;
                until not (StartLineNo > ExcelBuffer."Row No.");
        CurrRowNo := ExcelBuffer."Row No.";
        PrevRowNo := CurrRowNo;
        Clear(DataMasive);
        repeat
            CurrRowNo := ExcelBuffer."Row No.";
            if PrevRowNo = CurrRowNo then
                DataMasive[ExcelBuffer."Column No."] := ExcelBuffer."Cell Value as Text";
            if PrevRowNo <> CurrRowNo then begin
                ProceedLine;
            end;
        until ExcelBuffer.Next = 0;
        ProceedLine; //last row
    end;


    procedure ReadExcelSheet()
    begin
        ExcelBuffer.OpenBookStream(ExcelStream, SheetName);
        ExcelBuffer.ReadSheet;
    end;


    procedure CheckItem(ItemCode: Code[20])
    var
        Item: Record Item;
        NonstockItem: Record "Nonstock Item";
        NonstockItemMgt: Codeunit "Catalog Item Management";
    begin
        if Item.Get(ItemCode) then
            exit;

        if not NonstockItem.Get(ItemCode) then
            Error(StrSubstNo(EDMS002, ItemCode));

        NonstockItemMgt.NonstockAutoItem(NonstockItem);
    end;


    procedure RealMode()
    var
        LineNo: Integer;
    begin
        //23.04.2013 Elva Baltic P15 >>
        //LineNo := OrderProcessing.PurchaseLine3(PurchLine, PurchLine2, PurchLine3, QtyToTransfer, PartialTransfer,
        //          UnitPrice, Discount, FALSE, PurchHdr, LineDescription, LocationCode, BinCode);

        LineNo := OrderProcessing.PurchaseLine3(PurchLine, PurchLine2, PurchLine3, QtyToTransfer,
                  UnitPrice, Discount, false, PurchHdr, LineDescription, LocationCode, BinCode);
        //23.04.2013 Elva Baltic P15 <<

        if PartialTransfer then
            OrderProcessing.PartialReservationTransfer(PurchLine, PurchLine2, QtyToTransfer)
        else
            OrderProcessing.ReservationTransfer(PurchLine, PurchLine2);

        //23.04.2013 Elva Baltic P15 >>
        //OrderProcessing.DimensionChange(PurchLine, PurchLine3, LineNo, PartialTransfer);
        OrderProcessing.DimensionChange(PurchLine, PurchLine3, LineNo);
        //23.04.2013 Elva Baltic P15 <<
        if PartialTransfer then begin
            PurchLine.Validate(Quantity, PurchLine.Quantity - QtyToTransfer);
            PurchLine.Modify(true);

        end
        else
            PurchLine.Delete(true);
    end;


    procedure TempMode()
    begin
        PurchLineTemp.TransferFields(PurchLine);
        ReportEntryNo += 1;
        ReportDataBuffer1.Init;
        ReportDataBuffer1."Entry No." := ReportEntryNo;
        ReportDataBuffer1."Text Field 1" := Format(PurchLineTemp."Document Type");
        ReportDataBuffer1."Code Field 1" := PurchLineTemp."Document No.";
        ReportDataBuffer1."Code Field 2" := Format(PurchLineTemp."Line No.");
        ReportDataBuffer1."Text Field 2" := PurchLineTemp."No.";
        ReportDataBuffer1."Decimal Field 1" := PurchLineTemp.Quantity;
        ReportDataBuffer1."Text Field 5" := PurchLineTemp."Buy-from Vendor No.";
        ReportDataBuffer1."Decimal Field 2" := PurchLineTemp.Quantity - QtyToTransfer;
        ReportDataBuffer1."Decimal Field 3" := QtyToTransfer;
        ReportDataBuffer1."Date Field 1" := PurchLineTemp."Order Date";
        ReportDataBuffer1."Text Field 6" := LineDescription;
        ReportDataBuffer1."Decimal Field 4" := LineAmount;
        ReportDataBuffer1.Insert;
    end;


    procedure PreviewNewLine(No: Code[20]; Qty: Text[30]; OrderDate: Date)
    var
        ItemLoc: Record Item;
        Quantity: Decimal;
    begin
        ReportEntryNo += 1;
        ReportDataBuffer1.Init;
        ReportDataBuffer1."Entry No." := ReportEntryNo;
        ReportDataBuffer1."Text Field 1" := 'Order';  //'Pasūtījums';
        ReportDataBuffer1."Text Field 2" := No;
        Evaluate(Quantity, Qty);
        ReportDataBuffer1."Decimal Field 1" := Quantity;
        ReportDataBuffer1."Text Field 4" := 'New List'; //'Jauns ieraksts';
        ReportDataBuffer1."Date Field 1" := OrderDate;
        ReportDataBuffer1."Text Field 5" := PurchHdr."Buy-from Vendor No.";
        ReportDataBuffer1."Text Field 6" := LineDescription;
        ReportDataBuffer1."Decimal Field 4" := LineAmount;
        ReportDataBuffer1.Insert;
    end;


    procedure ProceedLine()
    var
        VendorOrderNo: Code[20];
    begin
        // 15.04.2015 EDMS P21 >>
        Clear(UnitPrice);
        Clear(Discount);
        Clear(LineAmount);
        // 15.04.2015 EDMS P21 <<
        // DataMasive[3] := DELCHR(DataMasive[3]);    // 12.03.2015 EDMS P21
        PurchLine.Reset;
        PurchLine.SetRange("Document Type", PurchLine."document type"::Order);
        PurchLine.SetCurrentkey(Type, "No.");
        PurchLine.SetRange(Type, PurchLine.Type::Item);
        PurchLine.SetRange("Buy-from Vendor No.", PurchHdr."Buy-from Vendor No.");
        PurchLine.SetRange("No.", DataMasive[3]);
        if OrderTypePriceCode <> '' then
            PurchLine.SetFilter(PurchLine."Ordering Price Type Code", OrderTypePriceCode);
        VendorOrderNo := DataMasive[1];
        PurchLine.SetFilter("Document No.", '<>%1', PurchOrderNo);
        if VendorOrderNo <> '' then begin
            PurchLine.SetRange("Vendor Order No.", VendorOrderNo);
            if not PurchLine.FindFirst then
                PurchLine.SetRange("Vendor Order No.");
        end;
        PurchLine.SetCurrentkey("Order Date");
        Evaluate(PurchDate, DataMasive[2]);
        LineCount := PurchLine.Count;
        WhichLine := 0;
        if Evaluate(UnitPrice, DataMasive[6]) then;
        if Evaluate(Discount, DataMasive[7]) then;
        LineDescription := DataMasive[4];
        if Evaluate(LineAmount, DataMasive[8]) then;
        LocationCode := DataMasive[9];
        BinCode := DataMasive[10];

        Evaluate(TotalTransfer, DataMasive[5]);
        QtyToTransfer := 0;

        if not DontMoveLines then begin     // 15.04.2015 EDMS P21
                                            // AT FIRST LOOP IN SOURCE DOCUMENT
            PurchLinesLoop;
            // When received amount is bigger than in source document then look in other documents
            if not LastOne then begin
                PurchLine.SetRange("Vendor Order No.");
                PurchLinesLoop;
            end;
        end;                                // 15.04.2015 EDMS P21

        // When received amount is bigger than in all existing documents then do create simply
        if not LastOne then begin
            if Preview_ then
                PreviewNewLine(DataMasive[3], DataMasive[5], PurchDate)
            else begin
                PartialTransfer := false;
                CheckItem(DataMasive[3]);
                QtyToTransfer := TotalTransfer;
                PurchLine3.Validate("Buy-from Vendor No.", PurchHdr."Buy-from Vendor No.");
                PurchLine3.Validate(Type, PurchLine3.Type::Item);
                PurchLine3.Validate("No.", DataMasive[3]);
                //23.04.2013 Elva Baltic P15 >>
                //LineNo := OrderProcessing.PurchaseLine3(PurchLine, PurchLine2, PurchLine3, QtyToTransfer, PartialTransfer,
                //           UnitPrice, Discount, TRUE, PurchHdr, LineDescription, LocationCode, BinCode);
                LineNo := OrderProcessing.PurchaseLine3(PurchLine, PurchLine2, PurchLine3, QtyToTransfer,
                           UnitPrice, Discount, true, PurchHdr, LineDescription, LocationCode, BinCode);

                //23.04.2013 Elva Baltic P15 <<
            end;
        end;
        Clear(DataMasive);
        DataMasive[ExcelBuffer."Column No."] := ExcelBuffer."Cell Value as Text";
        PrevRowNo := CurrRowNo;
    end;


    procedure PurchLinesLoop()
    begin
        if PurchLine.FindFirst then
            repeat
                CheckItem(DataMasive[3]);
                PurchLine.TestField("Document Type");
                PurchLine.TestField("Document No.");
                PurchLine.TestField("Quantity Received", 0);
                if not Preview_ then begin
                    PurchLine.TestField("Buy-from Vendor No.", PurchLine3."Buy-from Vendor No.");
                    PurchLine.TestField("Pay-to Vendor No.", PurchLine3."Pay-to Vendor No.");
                end;
                WhichLine += 1;
                LastOne := true;
                PartialTransfer := false;
                QtyToTransfer := TotalTransfer;
                if QtyToTransfer = 0 then
                    exit;
                if ((PurchLine.Quantity < QtyToTransfer) and (LineCount > 1) and (LineCount <> WhichLine)) then begin
                    TotalTransfer := QtyToTransfer - PurchLine.Quantity;
                    QtyToTransfer := PurchLine.Quantity;
                    LastOne := false;
                end;
                if PurchLine.Quantity > QtyToTransfer then
                    PartialTransfer := true;
                if Preview_ then
                    TempMode
                else
                    RealMode;
            until (PurchLine.Next = 0) or LastOne;
    end;


    procedure RequestFile()
    var
        xlsxFile: Text[300];
    begin
        if FileName <> '' then begin
            // ServerFileName := FileMgt.UploadFile(Text006, FileName)
            UploadIntoStream(Text006, '', FileManagement.GetToFilterText('', FileName), FileName, ExcelStream);
            ServerFileName := FileName;
        end else begin
            // ServerFileName := FileMgt.UploadFile(Text006, '.xlsx');
            xlsxFile := '.xlsx';
            UploadIntoStream(Text006, '', FileManagement.GetToFilterText('', xlsxFile), xlsxFile, ExcelStream);
            ServerFileName := xlsxFile;
        end;

        ValidateServerFileName;
        FileName := FileMgt.GetFileName(ServerFileName);
    end;

    local procedure FileNameOnAfterValidate()
    begin
        RequestFile;
    end;

    local procedure ValidateServerFileName()
    begin
        if ServerFileName = '' then begin
            FileName := '';
            SheetName := '';
            Error(Text022);
        end;
    end;
}

