Report 25006321 "Vehicle Sales"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/VehicleSales.rdlc';
    Caption = 'Vehicle Sales';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Value Entry"; "Value Entry")
        {
            DataItemTableView = sorting("Item Ledger Entry Type", "Item Category Code", "Product Group Code", "Location Code", "Global Dimension 1 Code", "Global Dimension 2 Code", "Posting Date") where("Item Ledger Entry Type" = const(Sale));
            RequestFilterFields = "Posting Date", "Location Code", "Global Dimension 1 Code";
            column(ReportForNavId_1; 1)
            {
            }
            column(CompanyName; COMPANYNAME)
            {
            }
            column(HeaderText; HeaderTxt)
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
            column(VINCaption; VINLbl)
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
            column(CostAmountCaption; CostAmountLbl)
            {
            }
            column(SalesAmountCaption; SalesAmountLbl)
            {
            }
            column(ProfitCaption; ProfitLbl)
            {
            }
            column(DateCaption; DateLbl)
            {
            }
            column(SalespersonCaption; SalespersonLbl)
            {
            }
            column(DescriptionCaption; DescriptionLbl)
            {
            }
            column(SellToCaption; SellToNameLbl)
            {
            }
            column(BillToCaption; BillToNameLbl)
            {
            }
            column(EntryTypeCaption; EntryTypeLbl)
            {
            }
            column(TotalCaption; TotalLbl)
            {
            }
            column(ShowDetails; Detailed)
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

                //Getting the item ledger entry
                ItemLedgerEntry.Reset;
                ItemLedgerEntry.Get("Item Ledger Entry No.");

                ReportDataBuffer.Reset;
                ReportDataBuffer.SetRange("Code Field 1", ItemLedgerEntry."Serial No.");
                ReportDataBuffer.SetRange("Code Field 2", ItemLedgerEntry."Vehicle Accounting Cycle No.");

                if ReportDataBuffer.FindFirst then
                    RecordExists := true
                else
                    RecordExists := false;


                if not RecordExists then begin
                    ReportDataBuffer.Reset;
                    ReportDataBuffer.Init;
                    EntryNo += 1;
                    ReportDataBuffer."Entry No." := EntryNo;
                    ReportDataBuffer."Integer Field 1" := 1;
                    ReportDataBuffer."Code Field 1" := ItemLedgerEntry."Serial No.";
                    ReportDataBuffer."Code Field 2" := ItemLedgerEntry."Vehicle Accounting Cycle No.";
                    if Vehicle.Get(ReportDataBuffer."Code Field 1") then begin
                        ReportDataBuffer."Code Field 3" := Vehicle.VIN;
                        ReportDataBuffer."Code Field 9" := Vehicle."Make Code";
                        ReportDataBuffer."Code Field 10" := Vehicle."Model Code";
                        if Model.Get(Vehicle."Make Code", Vehicle."Model Code") then
                            ReportDataBuffer."Text Field 10" := Model."Commercial Name";
                        //ReportDataBuffer."Code Field 7" := Vehicle.VIN;
                    end;
                end;

                //----------------------------->
                if "Invoiced Quantity" <> 0 then begin
                    ReportDataBuffer."Date Field 1" := ItemLedgerEntry."Posting Date";
                    //Find SalesPerson & Customer
                    SalesInvHeader.Reset;
                    if SalesInvHeader.Get("Document No.") and
                       (SalesInvHeader."Document Profile" = SalesInvHeader."document profile"::"Vehicles Trade")
                    then begin
                        ReportDataBuffer."Code Field 5" := SalesInvHeader."Salesperson Code";
                        Salesperson.Reset;
                        if Salesperson.Get(ReportDataBuffer."Code Field 5") then
                            ReportDataBuffer."Text Field 5" := Salesperson.Name;
                        ReportDataBuffer."Code Field 4" := SalesInvHeader."Sell-to Customer No.";
                        ReportDataBuffer."Code Field 6" := SalesInvHeader."Bill-to Customer No.";
                    end
                end;
                ReportDataBuffer."Decimal Field 1" += -"Invoiced Quantity";
                ReportDataBuffer."Decimal Field 2" += -"Cost Amount (Actual)";
                ReportDataBuffer."Decimal Field 3" += "Sales Amount (Actual)";
                ReportDataBuffer."Decimal Field 4" := ReportDataBuffer."Decimal Field 3" - ReportDataBuffer."Decimal Field 2";
                //-----------------------------<

                if (ReportDataBuffer."Code Field 5" = '') and ("Item Ledger Entry Type" = "item ledger entry type"::Sale) then begin
                    ReportDataBuffer."Code Field 5" := "Salespers./Purch. Code";
                    if Salesperson.Get(ReportDataBuffer."Code Field 5") then
                        ReportDataBuffer."Text Field 5" := Salesperson.Name;
                end;

                //09.07.2007. EDMS P2 >>
                SalesInvHdr.Reset;
                SalesCrMemoHdr.Reset;
                Customer.Reset;
                if SalesInvHdr.Get("Document No.") and (ReportDataBuffer."Text Field 9" = '') then begin
                    if Customer.Get(SalesInvHdr."Sell-to Customer No.") then
                        ReportDataBuffer."Text Field 6" := Customer.Name + Customer."Name 2";
                    if Customer.Get(SalesInvHdr."Bill-to Customer No.") then
                        ReportDataBuffer."Text Field 7" := Customer.Name + Customer."Name 2";
                end;
                if SalesCrMemoHdr.Get("Document No.") and (ReportDataBuffer."Text Field 9" = '') then begin
                    if Customer.Get(SalesCrMemoHdr."Sell-to Customer No.") then
                        ReportDataBuffer."Text Field 6" := Customer.Name + Customer."Name 2";
                    if Customer.Get(SalesCrMemoHdr."Bill-to Customer No.") then
                        ReportDataBuffer."Text Field 7" := Customer.Name + Customer."Name 2";
                end;
                //09.07.2007. EDMS P2 <<

                if RecordExists then
                    ReportDataBuffer.Modify
                else
                    ReportDataBuffer.Insert;
            end;

            trigger OnPostDataItem()
            begin

                if Detailed then
                    FillDetailedBuffer;
                AddMarginalVAT;
            end;

            trigger OnPreDataItem()
            begin
                SetRange("Item Type", "item type"::"Model Version");
                if bPremiumSet then
                    SetRange("Posting Date", datStartingDate, datEndingDate);

                TotalQuantity := 0;
                TotalCost := 0;
                TotalSales := 0;
                TotalProfit := 0;
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
            column(VIN; ReportDataBuffer."Code Field 3")
            {
            }
            column(MakeCode; ReportDataBuffer."Code Field 9")
            {
            }
            column(ModelCode; ReportDataBuffer."Text Field 10")
            {
            }
            column(Quantity; ReportDataBuffer."Decimal Field 1")
            {
            }
            column(CostAmount; ReportDataBuffer."Decimal Field 2")
            {
            }
            column(SalesAmount; ReportDataBuffer."Decimal Field 3")
            {
            }
            column(GrossProfit; ReportDataBuffer."Decimal Field 4")
            {
            }
            column(PostingDate; Format(ReportDataBuffer."Date Field 1", 0, '<Day>.<Month,2>.<Year4>'))
            {
            }
            column(SalesPerson; ReportDataBuffer."Text Field 5")
            {
            }
            column(SellToName; ReportDataBuffer."Text Field 6")
            {
            }
            column(BillToName; ReportDataBuffer."Text Field 7")
            {
            }
            dataitem(Integer2; "Integer")
            {
                DataItemTableView = sorting(Number) order(ascending);
                column(ReportForNavId_3; 3)
                {
                }
                column(DetPostingDate; Format(ReportDataBuffer2."Date Field 1", 0, '<Day>.<Month,2>.<Year4>'))
                {
                }
                column(DetDescription; ReportDataBuffer2."Text Field 1")
                {
                }
                column(DetCostAmount; ReportDataBuffer2."Decimal Field 1")
                {
                }
                column(DetEntryType; ReportDataBuffer2."Text Field 2")
                {
                }

                trigger OnAfterGetRecord()
                begin

                    if Number = 1 then
                        ReportDataBuffer2.Find('-')
                    else
                        ReportDataBuffer2.Next;
                end;

                trigger OnPreDataItem()
                begin
                    if not Detailed then
                        CurrReport.Break;

                    ReportDataBuffer2.Reset;
                    ReportDataBuffer2.SetCurrentkey("Integer Field 1");
                    ReportDataBuffer2.SetRange("Integer Field 1", ReportDataBuffer."Entry No.");
                    ReportDataBuffer2.SetCurrentkey("Code Field 1");
                    SetRange(Number, 1, ReportDataBuffer2.Count);
                end;
            }

            trigger OnAfterGetRecord()
            begin

                if Number = 1 then
                    ReportDataBuffer.Find('-')
                else
                    ReportDataBuffer.Next;

                TotalQuantity += ReportDataBuffer."Decimal Field 1";
                TotalCost += ReportDataBuffer."Decimal Field 2";
                TotalSales += ReportDataBuffer."Decimal Field 3";
                TotalProfit += ReportDataBuffer."Decimal Field 4";
            end;

            trigger OnPreDataItem()
            begin

                //CurrReport.CreateTotals(ReportDataBuffer."Decimal Field 1", ReportDataBuffer."Decimal Field 2",
                //                        ReportDataBuffer."Decimal Field 3", ReportDataBuffer."Decimal Field 4");
                ReportDataBuffer.Reset;
                ReportDataBuffer.SetCurrentkey("Date Field 1", "Code Field 3");
                SetRange(Number, 1, ReportDataBuffer.Count);
            end;
        }
        dataitem(GroupingBySalesperson; "Integer")
        {
            DataItemTableView = sorting(Number) order(ascending);
            column(ReportForNavId_4; 4)
            {
            }
            column(TotalQuantity; TotalQuantity)
            {
            }
            column(TotalCost; TotalCost)
            {
            }
            column(TotalSales; TotalSales)
            {
            }
            column(TotalProfit; TotalProfit)
            {
            }
            column(GroupSalesPerson; ReportDataBuffer3."Text Field 5")
            {
            }
            column(GroupQuantity; ReportDataBuffer3."Decimal Field 1")
            {
            }
            column(GroupCostAmount; ReportDataBuffer3."Decimal Field 2")
            {
            }
            column(GroupSalesAmount; ReportDataBuffer3."Decimal Field 3")
            {
            }
            column(GroupProfit; ReportDataBuffer3."Decimal Field 4")
            {
            }

            trigger OnAfterGetRecord()
            begin

                if Number = 1 then
                    ReportDataBuffer3.Find('-')
                else
                    ReportDataBuffer3.Next;
            end;

            trigger OnPreDataItem()
            begin

                //CurrReport.CreateTotals(ReportDataBuffer3."Decimal Field 1", ReportDataBuffer3."Decimal Field 2",
                //                        ReportDataBuffer3."Decimal Field 3", ReportDataBuffer3."Decimal Field 4");
                GroupBySalespersons;
                ReportDataBuffer3.Reset;
                if ReportDataBuffer3.Count = 0 then
                    CurrReport.Break;

                SetRange(Number, 1, ReportDataBuffer3.Count);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(Detailed; Detailed)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Detail';
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
    }

    var
        ReportDataBuffer: Record "Data Buffer" temporary;
        ReportDataBuffer2: Record "Data Buffer" temporary;
        ReportDataBuffer3: Record "Data Buffer" temporary;
        recSalesperson: Record "Salesperson/Purchaser";
        Model: Record Model;
        recEmpl: Record Employee;
        bPreDeliveryFromGL: Boolean;
        Detailed: Boolean;
        bPremium: Boolean;
        bPremiumSet: Boolean;
        EntryNo: Integer;
        LineCount: Integer;
        "----": Integer;
        codDocNo: Code[20];
        codDocNo1: Code[20];
        datStartingDate: Date;
        datEndingDate: Date;
        HeaderTxt: label 'Vehicle Sales';
        NoLbl: label 'No.';
        VINLbl: label 'VIN';
        MakeCodeLbl: label 'Make Code';
        ModelCodeLbl: label 'Model Code';
        QuantityLbl: label 'Quantity';
        CostAmountLbl: label 'Cost Amount (Actual)';
        SalesAmountLbl: label 'Sales Amount (Actual)';
        ProfitLbl: label 'Gross Profit';
        DateLbl: label 'Posting Date';
        SalespersonLbl: label 'Salesperson';
        SellToNameLbl: label 'Sell-To Name';
        BillToNameLbl: label 'Bill-To Name';
        DescriptionLbl: label 'Description';
        EntryTypeLbl: label 'Item Ledger Entry Type';
        TotalLbl: label 'Total';
        PageLbl: label 'Page';
        TotalQuantity: Decimal;
        TotalCost: Decimal;
        TotalSales: Decimal;
        TotalProfit: Decimal;


    procedure FillDetailedBuffer()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        EntryNo2: Integer;
        GroupNumber: Integer;
    begin
        ReportDataBuffer.Reset;
        if ReportDataBuffer.FindFirst then
            repeat
                ItemLedgerEntry.Reset;
                ItemLedgerEntry.SetCurrentkey("Serial No.", "Vehicle Accounting Cycle No.", "Item Type");
                ItemLedgerEntry.SetRange("Serial No.", ReportDataBuffer."Code Field 1");
                ItemLedgerEntry.SetRange("Vehicle Accounting Cycle No.", ReportDataBuffer."Code Field 2");
                ItemLedgerEntry.SetRange("Item Type", ItemLedgerEntry."item type"::"Model Version");
                if ItemLedgerEntry.FindFirst then
                    repeat
                        ValueEntry.Reset;
                        ValueEntry.SetCurrentkey("Item Ledger Entry No.");
                        ValueEntry.SetRange("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
                        ValueEntry.SetFilter("Location Code", "Value Entry".GetFilter("Location Code"));
                        if ValueEntry.FindFirst then
                            repeat

                                ReportDataBuffer2.Reset;
                                ReportDataBuffer2.SetRange("Integer Field 1", ReportDataBuffer."Entry No.");
                                ReportDataBuffer2.SetRange("Text Field 1", ValueEntry.Description);
                                ReportDataBuffer2.SetRange("Text Field 2", Format(ValueEntry."Item Ledger Entry Type"));
                                if ReportDataBuffer2.FindFirst then begin
                                    ReportDataBuffer2."Decimal Field 1" += ValueEntry."Cost Amount (Actual)";
                                    ReportDataBuffer2.Modify;
                                end
                                else begin

                                    EntryNo2 += 1;
                                    ReportDataBuffer2.Reset;
                                    ReportDataBuffer2.Init;
                                    ReportDataBuffer2."Entry No." := EntryNo2;
                                    ReportDataBuffer2."Integer Field 1" := ReportDataBuffer."Entry No.";
                                    ReportDataBuffer2."Date Field 1" := ValueEntry."Posting Date";
                                    GroupNumber := ValueEntry."Item Ledger Entry Type".asinteger();
                                    ReportDataBuffer2."Code Field 1" := Format(GroupNumber);
                                    ReportDataBuffer2."Text Field 1" := ValueEntry.Description;
                                    ReportDataBuffer2."Text Field 2" := Format(ValueEntry."Item Ledger Entry Type");
                                    ReportDataBuffer2."Decimal Field 1" := ValueEntry."Cost Amount (Actual)";
                                    ReportDataBuffer2.Insert;
                                end;
                            until ValueEntry.Next = 0;
                    until ItemLedgerEntry.Next = 0;
            until ReportDataBuffer.Next = 0;
        //ERROR(FORMAT(ReportDataBuffer2.COUNT));
    end;


    procedure GroupBySalespersons()
    var
        EntryNo: Integer;
    begin

        ReportDataBuffer.Reset;
        ReportDataBuffer.SetCurrentkey("Code Field 5"); //Salesperson
        if ReportDataBuffer.FindFirst then
            repeat
                ReportDataBuffer3.Reset;
                ReportDataBuffer3.SetRange("Code Field 5", ReportDataBuffer."Code Field 5");
                if ReportDataBuffer3.FindFirst then begin
                    ReportDataBuffer3."Decimal Field 1" += ReportDataBuffer."Decimal Field 1";
                    ReportDataBuffer3."Decimal Field 2" += ReportDataBuffer."Decimal Field 2";
                    ReportDataBuffer3."Decimal Field 3" += ReportDataBuffer."Decimal Field 3";
                    ReportDataBuffer3."Decimal Field 4" += ReportDataBuffer."Decimal Field 4";
                    ReportDataBuffer3.Modify;
                end
                else begin
                    EntryNo := EntryNo + 1;
                    ReportDataBuffer3.Init;
                    ReportDataBuffer3."Entry No." := EntryNo;
                    ReportDataBuffer3."Code Field 5" := ReportDataBuffer."Code Field 5";
                    ReportDataBuffer3."Text Field 5" := ReportDataBuffer."Text Field 5";
                    ReportDataBuffer3."Decimal Field 1" := ReportDataBuffer."Decimal Field 1";
                    ReportDataBuffer3."Decimal Field 2" := ReportDataBuffer."Decimal Field 2";
                    ReportDataBuffer3."Decimal Field 3" := ReportDataBuffer."Decimal Field 3";
                    ReportDataBuffer3."Decimal Field 4" := ReportDataBuffer."Decimal Field 4";
                    ReportDataBuffer3."Code Field 9" := ReportDataBuffer."Code Field 9";
                    ReportDataBuffer3."Code Field 10" := ReportDataBuffer."Code Field 10";
                    ReportDataBuffer3.Insert;
                end;
            until ReportDataBuffer.Next = 0;
    end;


    procedure AddMarginalVAT()
    var
        SalesSetup: Record "Sales & Receivables Setup";
        GLEntry: Record "G/L Entry";
    begin
        SalesSetup.Get;
        if SalesSetup."Veh. Marginal VAT Account No." = '' then
            exit;
        GLEntry.Reset;
        GLEntry.SetCurrentkey("G/L Account No.", "Posting Date");
        GLEntry.SetRange("G/L Account No.", SalesSetup."Veh. Marginal VAT Account No.");
        "Value Entry".Copyfilter("Posting Date", GLEntry."Posting Date");
        if GLEntry.FindFirst then
            repeat
                ReportDataBuffer.Reset;
                ReportDataBuffer.SetRange("Code Field 1", GLEntry."Vehicle Serial No.");
                ReportDataBuffer.SetRange("Code Field 2", GLEntry."Vehicle Accounting Cycle No.");
                if ReportDataBuffer.FindFirst then begin
                    //IF ReportDataBuffer."Integer Field 5" <> 1 THEN //EDMS 21.12.2007 P1
                    // ReportDataBuffer."Decimal Field 3" := 0;      //EDMS 21.12.2007 P1
                    //ReportDataBuffer."Integer Field 5" := 1;       //EDMS 21.12.2007 P1

                    ReportDataBuffer."Decimal Field 3" += -GLEntry.Amount;
                    ReportDataBuffer."Decimal Field 4" := ReportDataBuffer."Decimal Field 3" - ReportDataBuffer."Decimal Field 2";
                    ReportDataBuffer.Modify;
                end;
            until GLEntry.Next = 0;
    end;


    procedure fSetPrem(codAKRNoParam: Code[20]; dat1: Date; dat2: Date)
    begin
        codDocNo1 := codAKRNoParam;
        bPremiumSet := true;
        datStartingDate := dat1;
        datEndingDate := dat2;
    end;
}

