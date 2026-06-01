Report 25006027 "Vehicle Sales TOP"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/VehicleSalesTOP.rdlc';
    Caption = 'Vehicle Sales TOP';

    dataset
    {
        dataitem("Value Entry"; "Value Entry")
        {
            DataItemTableView = sorting("Item Ledger Entry Type", "Item Category Code", "Product Group Code", "Location Code", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date") where("Item Ledger Entry Type" = const(Sale));
            column(ReportForNavId_1; 1)
            {
            }
            column(SortingVehicleSalesDateFilter; StrSubstNo(Text001, StartingDate, EndingDate))
            {
            }
            column(CompanyName; COMPANYNAME)
            {
            }
            column(HeaderText; HeaderTxt)
            {
            }
            column(RankedAccordingShowType; StrSubstNo(Text002, SelectStr(ShowType + 1, Text004)))
            {
            }
            column(ReportDate; Format(Today, 0, 4))
            {
            }
            column(ValueEntryFilters; GetFilters)
            {
            }
            column(PageCaption; PageLbl)
            {
            }
            column(NoCaption; NoLbl)
            {
            }
            column(MakeCodeCaption; MakeCodeLbl)
            {
            }
            column(ModelCodeCaption; ModelCodeLbl)
            {
            }
            column(QuantityCaption; QuantityLbl)
            {
            }
            column(SalesAmountCaption; SalesAmountLbl)
            {
            }
            column(DateCaption; DateLbl)
            {
            }
            column(DescriptionCaption; DescriptionLbl)
            {
            }
            column(VehicleTop10ListCaption; VehicleTop10ListCaptionLbl)
            {
            }
            column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
            {
            }
            column(StartingDate; StartingDate)
            {
            }
            column(EndingDate; EndingDate)
            {
            }

            trigger OnAfterGetRecord()
            var
                ItemLedgerEntry: Record "Item Ledger Entry";
                RecordExists: Boolean;
                Vehicle: Record Vehicle;
                SalesInvHeader: Record "Sales Invoice Header";
                Salesperson: Record "Salesperson/Purchaser";
                SalesInvHdr: Record "Sales Invoice Header";
                SalesCrMemoHdr: Record "Sales Cr.Memo Header";
                Customer: Record Customer;
            begin
                ItemLedgerEntry.Reset;
                ItemLedgerEntry.Get("Item Ledger Entry No.");
                begin
                    ReportDataBuffer.Reset;
                    ReportDataBuffer.SetRange("Code Field 1", ItemLedgerEntry."Make Code");      //pieliek pie esoša modeļa un markas
                    ReportDataBuffer.SetRange("Code Field 2", ItemLedgerEntry."Model Code");

                    if ReportDataBuffer.FindFirst then
                        RecordExists := true
                    else
                        RecordExists := false;

                    if not RecordExists then begin
                        ReportDataBuffer.Reset;
                        ReportDataBuffer.Init;
                        EntryNo += 1;
                        ReportDataBuffer."Entry No." := EntryNo;
                        ReportDataBuffer."Code Field 1" := ItemLedgerEntry."Make Code";
                        ReportDataBuffer."Code Field 2" := ItemLedgerEntry."Model Code";
                        ReportDataBuffer."Decimal Field 1" := -"Invoiced Quantity";
                        ReportDataBuffer."Decimal Field 2" := "Sales Amount (Actual)";
                    end
                    else begin
                        ReportDataBuffer."Decimal Field 1" += -"Invoiced Quantity";
                        ReportDataBuffer."Decimal Field 2" += "Sales Amount (Actual)";
                    end;

                    if not RecordExists then
                        ReportDataBuffer.Insert
                    else
                        ReportDataBuffer.Modify;
                end;

                TotalQuantity += -"Invoiced Quantity";
                TotalSales += "Sales Amount (Actual)";

                //ChartTypeNo := ChartType;
                //ShowTypeNo := ShowType;

                //MESSAGE('%1 %2 %3 %4 %5 %6 Total Quantity %7 Total Sales %8',ReportDataBuffer."Entry No.",ReportDataBuffer."Code Field 1",ReportDataBuffer."Code Field 2",
                //    ReportDataBuffer."Decimal Field 1",ReportDataBuffer."Decimal Field 2",ItemLedgerEntry."Entry No.",TotalQuantity, TotalSales);
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Item Type", "item type"::"Model Version");
                SetRange("Posting Date", StartingDate, EndingDate);
                SetRange("Document Type", "document type"::"Sales Invoice");
                SetRange("Gen. Prod. Posting Group", 'VEHICLES');
                SetRange("Source Code", 'SALES');

                TotalQuantity := 0;
                TotalSales := 0;
            end;
        }
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = sorting(Number) order(ascending);
            column(ReportForNavId_2; 2)
            {
            }
            column(Number; Number)
            {
            }
            column(MakeCode; ReportDataBuffer."Code Field 1")
            {
            }
            column(ModelCode; ReportDataBuffer."Code Field 2")
            {
            }
            column(Quantity; ReportDataBuffer."Decimal Field 1")
            {
            }
            column(SalesAmount; ReportDataBuffer."Decimal Field 2")
            {
            }
            column(TotalQuantity; ReportDataBuffer2."Decimal Field 1")
            {
            }
            column(TotalSales; ReportDataBuffer2."Decimal Field 2")
            {
            }
            column(FiltredMakeCode; ReportDataBuffer3."Code Field 1")
            {
            }
            column(FiltrredModelCode; ReportDataBuffer3."Code Field 2")
            {
            }
            column(FiltredQuantity; ReportDataBuffer3."Decimal Field 1")
            {
            }
            column(FiltredSalesAmount; ReportDataBuffer3."Decimal Field 2")
            {
            }

            trigger OnPreDataItem()
            var
                MakeExists: Boolean;
            begin
                ReportDataBuffer.Reset;
                ReportDataBuffer.SetCurrentkey("Code Field 1", "Code Field 2");
                SetRange(Number, 1, "Value Entry".Count);

                ReportDataBuffer2."Decimal Field 1" := TotalQuantity;
                ReportDataBuffer2."Decimal Field 2" := TotalSales;

                case ShowType of
                    Showtype::"Sales (LCY)":
                        ReportDataBuffer.SetCurrentkey("Decimal Field 2", "Decimal Field 1");

                    Showtype::"Sales Quantity":
                        ReportDataBuffer.SetCurrentkey("Decimal Field 1", "Decimal Field 2");
                end;

                case GroupingType of
                    Groupingtype::Make:   //Ja make, tad iekopē tikai make un sasummē visus, tāpat kā sākumā
                        begin
                            EntryNo := 0;
                            RecordCount := 0;
                            begin
                                repeat
                                    ReportDataBuffer.Reset;
                                    ReportDataBuffer.SetRange("Code Field 1", MakeCode);

                                    if ReportDataBuffer.FindFirst then
                                        MakeExists := true
                                    else
                                        MakeExists := false;

                                    if not MakeExists then begin
                                        ReportDataBuffer3.Reset;
                                        ReportDataBuffer3.Init;
                                        EntryNo += 1;
                                        RecordCount += 1;
                                        ReportDataBuffer3."Entry No." := EntryNo;
                                        ReportDataBuffer3."Code Field 1" := ReportDataBuffer."Code Field 1";
                                        ReportDataBuffer3."Decimal Field 1" := ReportDataBuffer."Decimal Field 1";
                                        ReportDataBuffer3."Decimal Field 2" := ReportDataBuffer."Decimal Field 2";
                                    end
                                    else begin
                                        ReportDataBuffer3."Decimal Field 1" += ReportDataBuffer."Decimal Field 1";
                                        ReportDataBuffer3."Decimal Field 2" += ReportDataBuffer."Decimal Field 2";
                                    end;

                                    if not MakeExists then
                                        ReportDataBuffer3.Insert
                                    else
                                        ReportDataBuffer3.Modify;

                                until (ReportDataBuffer.Next(-1) = 0) or (RecordCount = NoOfRecordsToPrint);
                            end;
                            Message('EntryNo - %1, Make - %2, Model - %3, Quantity - %4, Sales - %5', ReportDataBuffer3."Entry No.", ReportDataBuffer3."Code Field 1", ReportDataBuffer3."Code Field 2", ReportDataBuffer3."Decimal Field 1", ReportDataBuffer3."Decimal Field 2")

                        end;

                    Groupingtype::Model:   //Ja model, tad parāda konkrēta make modeļus, vai arī visus modeļus.
                        begin
                            ReportDataBuffer.SetFilter("Code Field 1", MakeCode);
                            EntryNo := 0;
                            RecordCount := 0;
                            begin
                                if ReportDataBuffer.FindLast then
                                    repeat
                                    begin
                                        ReportDataBuffer3.Init;
                                        RecordCount += 1;
                                        EntryNo += 1;
                                        ReportDataBuffer3."Entry No." := EntryNo;
                                        ReportDataBuffer3."Code Field 1" := ReportDataBuffer."Code Field 1";
                                        ReportDataBuffer3."Code Field 2" := ReportDataBuffer."Code Field 2";
                                        ReportDataBuffer3."Decimal Field 1" := ReportDataBuffer."Decimal Field 1";
                                        ReportDataBuffer3."Decimal Field 2" := ReportDataBuffer."Decimal Field 2";
                                        ReportDataBuffer3.Insert;
                                        Message('EntryNo - %1, Make - %2, Model - %3, Quantity - %4, Sales - %5', ReportDataBuffer3."Entry No.", ReportDataBuffer3."Code Field 1", ReportDataBuffer3."Code Field 2", ReportDataBuffer3."Decimal Field 1", ReportDataBuffer3."Decimal Field 2");
                                    end;
                                    until (ReportDataBuffer.Next(-1) = 0) or (RecordCount = NoOfRecordsToPrint);
                                CurrReport.CreateTotals(ReportDataBuffer3."Decimal Field 1", ReportDataBuffer3."Decimal Field 2");
                            end;
                        end;

                //  GroupingType::"Vehicle Type":;
                end;
            end;
        }
    }

    requestpage
    {
        AutoSplitKey = true;
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(NoOfRecordsToPrint; NoOfRecordsToPrint)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Quantity';
                        ToolTip = 'Specifies the number of customers that will be included in the report.';
                    }
                    field(ChartType; ChartType)
                    {
                        ApplicationArea = All;
                        Caption = 'Chart Type';
                        OptionCaption = 'Bar chart,Pie chart';
                        ToolTip = 'Specifies the chart type.';
                        Visible = ChartTypeVisible;
                    }
                    field(GroupingType; GroupingType)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Grouping Type';
                        OptionCaption = 'Make, Model, Vehicle Type ';
                    }
                    field(MakeCode; MakeCode)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Make';
                        Lookup = true;
                        LookupPageID = "Make List";
                        TableRelation = Make.Code;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            if Page.RunModal(0, Make) = Action::LookupOK then begin
                                if MakeCode = '' then
                                    MakeCode := Text + Make.Code
                                else
                                    MakeCode := Text + '|' + Make.Code;
                            end;
                        end;
                    }
                    field(Show; ShowType)
                    {
                        ApplicationArea = Basic, Suite;
                        Caption = 'Show';
                        OptionCaption = 'Sales (LCY),Sales Quantity';
                        //The property 'ToolTip' cannot be empty.
                        //ToolTip = '';
                    }
                }
                group(Period)
                {
                    Caption = 'Period';
                    field("Starting Date"; StartingDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Starting Date';
                    }
                    field("Ending Date"; EndingDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Ending Date';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnInit()
        begin
            ChartTypeVisible := true;
        end;

        trigger OnOpenPage()
        begin
            if NoOfRecordsToPrint = 0 then
                NoOfRecordsToPrint := 10;

            if EndingDate = 0D then
                EndingDate := Today;
        end;
    }

    labels
    {
    }

    var
        CaptionManagement: Codeunit "Caption Class";
        ReportDataBuffer: Record "Data Buffer" temporary;
        ReportDataBuffer2: Record "Data Buffer" temporary;
        ReportDataBuffer3: Record "Data Buffer" temporary;
        Model: Record Model;
        EntryNo: Integer;
        LineCount: Integer;
        HeaderTxt: label 'Vehicle Sales';
        NoLbl: label 'No.';
        MakeCodeLbl: label 'Make Code';
        ModelCodeLbl: label 'Model Code';
        QuantityLbl: label 'Quantity';
        SalesAmountLbl: label 'Sales Amount (Actual)';
        DateLbl: label 'Posting Date';
        DescriptionLbl: label 'Description';
        TotalLbl: label 'Total';
        PageLbl: label 'Page';
        TotalQuantity: Decimal;
        TotalSales: Decimal;
        NoOfRecordsToPrint: Integer;
        ChartType: Option "Bar chart","Pie chart";
        ChartTypeNo: Integer;
        ShowTypeNo: Integer;
        [InDataSet]
        ChartTypeVisible: Boolean;
        Make: Record Make;
        StartingDate: Date;
        EndingDate: Date;
        ShowType: Option "Sales (LCY)","Sales Quantity";
        ValueEntryCount: Integer;
        MakeCode: Code[150];
        Text000: label 'Sorting Vehicle Sales    #1##########';
        Text001: label 'Period: %1 .. %2';
        Text002: label 'Ranked according to %1';
        Text004: label 'Sales (LCY), Quantity';
        VehicleTop10ListCaptionLbl: label 'Vehicle - Top 10 List';
        CurrReportPageNoCaptionLbl: label 'Page';
        TotalCaptionLbl: label 'Total';
        TotalSalesCaptionLbl: label 'Total Sales';
        RecordCount: Integer;
        GroupingType: Option Make,Model,"Vehicle Type";


    procedure InitializeRequest(SetChartType: Option; SetShowType: Option; NoOfRecords: Integer)
    begin
        ChartType := SetChartType;
        ShowType := SetShowType;
        NoOfRecordsToPrint := NoOfRecords;
    end;
}

