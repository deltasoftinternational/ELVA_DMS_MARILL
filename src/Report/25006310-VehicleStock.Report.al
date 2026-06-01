Report 25006310 "Vehicle Stock"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/VehicleStock.rdlc';
    Caption = 'Vehicle Stock';
    UsageCategory = ReportsAndAnalysis;
    ApplicationArea = All;
    dataset
    {
        dataitem(Vehicle; Vehicle)
        {
            column(ReportForNavId_25006029; 25006029)
            {
            }
            column(ReportForNavId_4; 4)
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(HeaderText; HeaderText)
            {
            }
            column(PeriodValue; Format(datEndingDate))
            {
            }
            column(Show; Show)
            {
            }
            column(ShowChart; ShowChart)
            {
            }
            column(VehicleRun1Lbl; VehicleRun1Lbl)
            {
            }
            dataitem("Data Buffer"; "Data Buffer")
            {
                DataItemLink = "Code Field 2" = field("Serial No.");
                DataItemTableView = sorting("Entry No.") where("Decimal Field 2" = filter(> 0));
                UseTemporary = true;

                column(LocationCode; "Code Field 1")
                {
                }
                column(SerialNo; "Code Field 2")
                {
                }
                column(ProductionYear; "Code Field 3")
                {
                }
                column(EntryType; "Code Field 4")
                {
                }
                column(VIN; "Code Field 5")
                {
                }
                column(MakeCode; "Code Field 6")
                {
                }
                column(ModelCode; "Code Field 7")
                {
                }
                column(BodyColorCode; "Code Field 9")
                {
                }
                column(Status_Code; "Code Field 10")
                {
                }
                column(SumCostAmountActual; "Decimal Field 1")
                {
                }
                column(SumItemLedgerQuantity; "Decimal Field 2")
                {
                }
                column(CostAmountActual; "Decimal Field 3")
                {
                }
                column(Description; "Text Field 1")
                {
                }
                column(Name; "Text Field 2")
                {
                }
                column(ModelVersionNo; "Text Field 3")
                {
                }
                column(PostingDate; "Date Field 1")
                {
                }
                column(PostingDatePurchase; "Date Field 2")
                {
                }
                column(DaysInStock; "Integer Field 1")
                {
                }
                column(VehicleRun1; "Integer Field 2")
                {
                }
                column(VehicleSalesPrice; "Decimal Field 4")
                {
                }
                column(PurchaserName; "Text Field 4")
                {
                }
            }
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
                    field(datEndingDate; datEndingDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Date To';
                    }
                    field(Show; Show)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Details';
                    }
                    field(ShowChart; ShowChart)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Chart';
                    }
                }
                group("Filter")
                {
                    Caption = 'Filter';
                    field(LocationCode; LocationCode)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Location';
                        TableRelation = Location;
                    }
                    field(StatusCode; StatusCode)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Vehicle Status';
                        TableRelation = "Vehicle Status";
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        PageLbl = 'Page';
        PeriodLbl = 'Period';
        CodeLbl = 'Code';
        VINLbl = 'VIN';
        MakeLbl = 'Make';
        ModelLbl = 'Model';
        StartRemainLbl = 'Start Remaining';
        PurchaseDateLbl = 'Purchase Date';
        SalesInvNoLbl = 'Sales Invoice No.';
        LocationCodeLbl = 'Location Code';
        PurchaserNameLbl = 'Purchaser';
        DaysInStockLbl = 'Days In Stock';
        ProductionYearLbl = 'Production Year';
        AmountLbl = 'Amount';
        QuantityLbl = 'Quantity';
        DescriptionLbl = 'Description';
        DateLbl = 'Date';
        TypeLbl = 'Type';
        ActualCostLbl = 'Actual Cost';
        NameLbl = 'Name';
        SerialNoLbl = 'Serial No.';
        TotalLbl = 'Total';
        StatusLbl = 'Status';
        DetailsLbl = 'Details';
        TotalQtyLbl = 'Total Quantity';
        TotalAmountLbl = 'Total Amount';
        VehicleSalesPriceLbl = 'Sales Price';
    }

    trigger OnPreReport()
    begin
        VehicleRun1Lbl := '';
        if VariableFieldUsage.Get(Database::Vehicle, 330) then
            if VariableField.Get(VariableFieldUsage."Variable Field Code") then
                VehicleRun1Lbl := VariableField.Caption;

        if datEndingDate = 0D then
            Error(StrSubstNo(Text001, Text003));

        "Data Buffer".Reset;
        "Data Buffer".DeleteAll;
        QueryVehicleInvOverview2.SetFilter(Posting_Date, '..%1', datEndingDate);
        if LocationCode <> '' then
            QueryVehicleInvOverview2.SetFilter(Location_Code, '%1', LocationCode);
        if StatusCode <> '' then
            QueryVehicleInvOverview2.SetFilter(Status_Code, '%1', StatusCode);
        QueryVehicleInvOverview2.Open;
        while QueryVehicleInvOverview2.Read do begin
            if (QueryVehicleInvOverview2.Sum_Cost_Amount_Actual <> 0) or (QueryVehicleInvOverview2.Sum_Item_Ledger_Entry_Quantity <> 0) then begin
                if (getTotalInventoryQty(QueryVehicleInvOverview2.Serial_No) > 0) then begin
                    PurchaseDate := 0D;
                    PurchaserName := '';
                    ItemLedgerEntry.Reset;
                    ItemLedgerEntry.SetRange("Entry Type", ItemLedgerEntry."entry type"::Purchase);
                    ItemLedgerEntry.SetRange("Serial No.", QueryVehicleInvOverview2.Serial_No);
                    ItemLedgerEntry.SetRange("Item No.", QueryVehicleInvOverview2.Item_No);
                    ItemLedgerEntry.SetFilter("Posting Date", '..%1', datEndingDate);
                    ItemLedgerEntry.SetCurrentkey("Item No.", "Posting Date");
                    if ItemLedgerEntry.FindLast then begin
                        PurchaseDate := ItemLedgerEntry."Posting Date";
                        ItemLedgerEntry.CalcFields("Value Entry Salespers. Code");
                        if Purchaser.Get(ItemLedgerEntry."Value Entry Salespers. Code") then
                            PurchaserName := Purchaser.Name;
                    end;

                    VehicleSalesPrice := 0;
                    if VehiclePrice.Get(QueryVehicleInvOverview2.Serial_No) then begin
                        SalesPrice.SetRange("Item No.", VehiclePrice."Model Version No.");
                        SalesPrice.SetRange("Make Code", VehiclePrice."Make Code");
                        SalesPrice.SetRange("Model Code", VehiclePrice."Model Code");
                        SalesPrice.SetRange("Vehicle Serial No.", VehiclePrice."Serial No.");
                        SalesPrice.SetRange("Document Profile", SalesPrice."document profile"::"Vehicles Trade");
                        SalesPrice.SetRange("Sales Type", SalesPrice."sales type"::"All Customers");
                        SalesPrice.SetFilter("Starting Date", '<=%1', WorkDate);
                        SalesPrice.SetFilter("Ending Date", '''''|>=%1', WorkDate);
                        SalesPrice.SetRange("Currency Code", '');
                        if SalesPrice.FindLast then
                            VehicleSalesPrice := SalesPrice."Unit Price";
                    end;


                    QueryVehicleInvOverview3.SetFilter(Serial_No, QueryVehicleInvOverview2.Serial_No);
                    QueryVehicleInvOverview3.SetFilter(Item_Ledger_Entry_Type, '<>%1', ValueEntry."item ledger entry type"::Transfer);
                    QueryVehicleInvOverview3.Open;

                    while QueryVehicleInvOverview3.Read do begin
                        iEntryNo := iEntryNo + 1;
                        "Data Buffer".Init;
                        "Data Buffer"."Entry No." := iEntryNo;
                        "Data Buffer"."Code Field 1" := QueryVehicleInvOverview2.Location_Code;
                        "Data Buffer"."Code Field 2" := QueryVehicleInvOverview2.Serial_No;
                        "Data Buffer"."Code Field 4" := Format(QueryVehicleInvOverview3.Item_Ledger_Entry_Type);
                        "Data Buffer"."Code Field 5" := QueryVehicleInvOverview2.VIN;
                        "Data Buffer"."Code Field 6" := QueryVehicleInvOverview2.Make_Code;
                        "Data Buffer"."Code Field 7" := QueryVehicleInvOverview2.Model_Code;
                        "Data Buffer"."Code Field 9" := QueryVehicleInvOverview2.Body_Color_Code;
                        "Data Buffer"."Code Field 10" := QueryVehicleInvOverview2.Status_Code;
                        "Data Buffer"."Decimal Field 1" := QueryVehicleInvOverview2.Sum_Cost_Amount_Actual;
                        "Data Buffer"."Decimal Field 2" := QueryVehicleInvOverview2.Sum_Item_Ledger_Entry_Quantity;
                        "Data Buffer"."Decimal Field 3" := QueryVehicleInvOverview3.Cost_Amount_Actual;
                        "Data Buffer"."Text Field 1" := QueryVehicleInvOverview3.Description;
                        if Format(QueryVehicleInvOverview3.Source_Type) = Format(ValueEntry."source type"::Vendor) then
                            recReportDataBuffer."Text Field 2" := QueryVehicleInvOverview3.Vendor_Name;
                        if Format(QueryVehicleInvOverview3.Source_Type) = Format(ValueEntry."source type"::Customer) then
                            recReportDataBuffer."Text Field 2" := QueryVehicleInvOverview3.Customer_Name;
                        "Data Buffer"."Text Field 3" := QueryVehicleInvOverview2.Model_Version_No;
                        "Data Buffer"."Date Field 1" := QueryVehicleInvOverview3.Posting_Date;
                        "Data Buffer"."Date Field 2" := PurchaseDate;
                        if PurchaseDate <> 0D then
                            "Data Buffer"."Integer Field 1" := datEndingDate - PurchaseDate
                        else
                            "Data Buffer"."Integer Field 1" := 0;
                        "Data Buffer"."Text Field 4" := PurchaserName;
                        "Data Buffer"."Integer Field 2" := QueryVehicleInvOverview2.Variable_Field_Run_1;
                        "Data Buffer"."Code Field 3" := QueryVehicleInvOverview2.Production_Year;
                        "Data Buffer"."Decimal Field 4" := VehicleSalesPrice;
                        "Data Buffer".Insert;
                    end;
                end
            end;
        end;

        if "Data Buffer".FindFirst then;
    end;

    var
        recReportDataBuffer: Record "Data Buffer" temporary;
        datEndingDate: Date;
        Show: Boolean;
        Text001: label 'You must define %1';
        Text002: label 'Start Date';
        Text003: label 'End Date';
        HeaderText: label 'Vehicle Stock';
        TextSale: label 'Sale';
        QueryVehicleInvOverview2: Query "Vehicle Inventory Overview 2";
        QueryVehicleInvOverview3: Query "Vehicle Inventory Overview 3";
        iEntryNo: Integer;
        ValueEntry: Record "Value Entry";
        LocationCode: Code[10];
        StatusCode: Code[20];
        ShowChart: Boolean;
        ItemLedgerEntry: Record "Item Ledger Entry";
        PurchaseDate: Date;
        PurchaserName: Text;
        Purchaser: Record "Salesperson/Purchaser";
        SalesPrice: Record "Sales Price";
        VehicleSalesPrice: Decimal;
        VehiclePrice: Record Vehicle;
        VehicleRun1Lbl: Text;
        VariableField: Record "Variable Field";
        VariableFieldUsage: Record "Variable Field Usage";

    protected procedure getTotalInventoryQty(SerialNo: Code[50]) Qty: Decimal
    var
        QueryVehicleInvOverviewSum: Query "Vehicle Inventory Overview 3";
    begin
        QueryVehicleInvOverviewSum.SetFilter(Serial_No, SerialNo);
        QueryVehicleInvOverviewSum.SetFilter(Item_Ledger_Entry_Type, '<>%1', ValueEntry."item ledger entry type"::Transfer);
        QueryVehicleInvOverviewSum.Open;
        while QueryVehicleInvOverviewSum.Read do begin
            Qty += QueryVehicleInvOverviewSum.Item_Ledger_Entry_Quantity;
        end;
    end;
}

