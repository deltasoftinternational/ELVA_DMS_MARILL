Report 25006309 "Vehicle Inventory Overview"
{
    // 10.06.2015 EB.P21 #T0041
    //   Modified trigger:
    //     Value Entry - OnAfterGetRecord
    // 
    // 27.04.2015 EDMS P21
    //   Modified function:
    //     GetStartQty
    // 
    // 06.05.2014 Elva Baltic P8 #R003 MMG7.00
    //   * Fix in filters
    // 
    // 05.02.2014 Elva Baltic P7 #R003 MMG7.00
    //   * Report modified. Added new colum PPR nr
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/VehicleInventoryOverview.rdlc';

    Caption = 'Vehicle Inventory Overview';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(Location; Location)
        {
            DataItemTableView = sorting(Code);
            RequestFilterFields = "Code";
            column(ReportForNavId_1; 1)
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(HeaderText; HeaderText)
            {
            }
            column(PeriodValue; Format(datStartingDate) + '..' + Format(datEndingDate))
            {
            }
            dataitem("Value Entry"; "Value Entry")
            {
                DataItemLink = "Location Code" = field(Code);
                DataItemTableView = sorting("Location Code", "Posting Date");
                RequestFilterFields = "Item No.", "Global Dimension 1 Code", "Global Dimension 2 Code";
                column(ReportForNavId_2; 2)
                {
                }

                trigger OnAfterGetRecord()
                var
                    Vehicle: Record Vehicle;
                    RecordExists: Boolean;
                    Model: Record Model;
                    SalesInvHdr: Record "Sales Invoice Header";
                begin

                    if NotShowAdditionalExpenses then begin
                        if InventoryPostingGroup.Get("Inventory Posting Group") then
                            if InventoryPostingGroup."Vehicle Additional Expenses" then
                                CurrReport.Skip;
                    end;

                    ItemLedgerEntry1.Reset;
                    ItemLedgerEntry1.Get("Item Ledger Entry No.");

                    recReportDataBuffer.Reset;
                    recReportDataBuffer.SetCurrentkey("Code Field 1", "Code Field 2", "Code Field 3", "Code Field 4", "Code Field 5");
                    recReportDataBuffer.SetRange("Code Field 1", "Location Code");
                    recReportDataBuffer.SetRange("Code Field 2", ItemLedgerEntry1."Serial No.");
                    recReportDataBuffer.SetRange("Code Field 3", ItemLedgerEntry1."Vehicle Accounting Cycle No.");

                    if recReportDataBuffer.FindFirst then
                        RecordExists := true
                    else
                        RecordExists := false;

                    //Create entry
                    if not RecordExists then begin
                        iEntryNo := iEntryNo + 1;

                        recReportDataBuffer.Init;
                        recReportDataBuffer."Entry No." := iEntryNo;
                        recReportDataBuffer."Code Field 1" := "Location Code";
                        recReportDataBuffer."Code Field 2" := ItemLedgerEntry1."Serial No.";
                        recReportDataBuffer."Code Field 3" := ItemLedgerEntry1."Vehicle Accounting Cycle No.";
                        recReportDataBuffer."Code Field 4" := Format("Item Ledger Entry Type");

                        if Vehicle.Get(ItemLedgerEntry1."Serial No.") then;

                        recReportDataBuffer."Code Field 5" := Vehicle.VIN;
                        recReportDataBuffer."Code Field 6" := Vehicle."Make Code";

                        if Model.Get(Vehicle."Make Code", Vehicle."Model Code") then
                            recReportDataBuffer."Text Field 7" := Model."Commercial Name";

                        recReportDataBuffer.Insert;
                    end;

                    //Izmaiņas periodā
                    case "Item Ledger Entry Type" of
                        "item ledger entry type"::Purchase:
                            begin
                                if not bShowAsAmounts then
                                    recReportDataBuffer."Decimal Field 2" += "Item Ledger Entry Quantity"
                                else
                                    recReportDataBuffer."Decimal Field 2" += "Cost Amount (Actual)";
                            end;
                        "item ledger entry type"::"Positive Adjmt.":
                            begin
                                if not bShowAsAmounts then
                                    recReportDataBuffer."Decimal Field 3" += "Item Ledger Entry Quantity"
                                else
                                    recReportDataBuffer."Decimal Field 3" += "Cost Amount (Actual)";
                            end;
                        "item ledger entry type"::Sale:
                            begin
                                if not bShowAsAmounts then
                                    recReportDataBuffer."Decimal Field 4" += "Item Ledger Entry Quantity"
                                else
                                    recReportDataBuffer."Decimal Field 4" += "Cost Amount (Actual)";
                                // EB.P21 #T0041 >>
                                if "External Document No." <> '' then
                                    recReportDataBuffer."Text Field 8" := "External Document No."
                                else
                                    recReportDataBuffer."Text Field 8" := "Document No.";
                                // EB.P21 #T0041 <<
                            end;
                        "item ledger entry type"::"Negative Adjmt.":
                            begin
                                if not bShowAsAmounts then
                                    recReportDataBuffer."Decimal Field 5" += "Item Ledger Entry Quantity"
                                else
                                    recReportDataBuffer."Decimal Field 5" += "Cost Amount (Actual)";
                            end;
                        "item ledger entry type"::Transfer:
                            begin
                                if "Valued Quantity" < 0 then begin
                                    if not bShowAsAmounts then
                                        recReportDataBuffer."Decimal Field 6" += "Item Ledger Entry Quantity"
                                    else
                                        recReportDataBuffer."Decimal Field 6" += "Cost Amount (Actual)";
                                end
                                else begin
                                    if not bShowAsAmounts then
                                        recReportDataBuffer."Decimal Field 7" += "Item Ledger Entry Quantity"
                                    else
                                        recReportDataBuffer."Decimal Field 7" += "Cost Amount (Actual)";
                                end
                            end;
                    end;

                    if bShowAsAmounts then
                        recReportDataBuffer."Decimal Field 8" += "Cost Amount (Actual)"
                    else
                        recReportDataBuffer."Decimal Field 8" += "Item Ledger Entry Quantity";
                    recReportDataBuffer.Modify;

                    //Iepirkuma vērtība
                    if (("Item Ledger Entry Type" = "item ledger entry type"::Purchase) or
                       ("Item Ledger Entry Type" = "item ledger entry type"::"Positive Adjmt.")) and ("Valued Quantity" > 0)
                      then
                        recReportDataBuffer."Decimal Field 9" += "Cost Amount (Actual)";

                    recReportDataBuffer.Modify;
                end;

                trigger OnPostDataItem()
                begin
                    GetStartQty();
                end;

                trigger OnPreDataItem()
                begin

                    SetRange("Posting Date", datStartingDate, datEndingDate);
                    SetRange("Item Type", "item type"::"Model Version");
                end;
            }
        }
        dataitem(Location2; Location)
        {
            DataItemTableView = sorting(Code);
            column(ReportForNavId_3; 3)
            {
            }
            column(LocationCode; Code)
            {
            }
            column(LocationName; Name)
            {
            }
            dataitem("Integer"; "Integer")
            {
                DataItemTableView = sorting(Number) order(ascending);
                column(ReportForNavId_4; 4)
                {
                }
                column(VehcileCode; recReportDataBuffer."Code Field 5")
                {
                }
                column(VehicleMake; recReportDataBuffer."Code Field 6")
                {
                }
                column(VehicleModel; recReportDataBuffer."Text Field 7")
                {
                }
                column(VehicleStartRemaining; recReportDataBuffer."Decimal Field 1")
                {
                }
                column(VehiclePurchase; recReportDataBuffer."Decimal Field 2")
                {
                }
                column(VehiclePosAdj; recReportDataBuffer."Decimal Field 3")
                {
                }
                column(VehicleSale; recReportDataBuffer."Decimal Field 4")
                {
                }
                column(VehicleNegAdj; recReportDataBuffer."Decimal Field 5")
                {
                }
                column(VehicleOutboundTransf; recReportDataBuffer."Decimal Field 6")
                {
                }
                column(VehicleInboundTransf; recReportDataBuffer."Decimal Field 7")
                {
                }
                column(VehicleTotalRemaining; recReportDataBuffer."Decimal Field 8")
                {
                }
                column(SalesInvNo; recReportDataBuffer."Text Field 8")
                {
                }

                trigger OnAfterGetRecord()
                begin

                    if Number = 1 then
                        recReportDataBuffer.Find('-')
                    else
                        recReportDataBuffer.Next;

                    //MK start

                    if ToDelete then begin
                        Clear(DecField);
                        ToDelete := false;
                    end;

                    DecField[1] += recReportDataBuffer."Decimal Field 1";
                    DecField[2] += recReportDataBuffer."Decimal Field 2";
                    DecField[3] += recReportDataBuffer."Decimal Field 3";
                    DecField[4] += recReportDataBuffer."Decimal Field 4";
                    DecField[5] += recReportDataBuffer."Decimal Field 5";
                    DecField[6] += recReportDataBuffer."Decimal Field 6";
                    DecField[7] += recReportDataBuffer."Decimal Field 7";
                    DecField[8] += recReportDataBuffer."Decimal Field 8";
                    DecField[9] += recReportDataBuffer."Decimal Field 9";

                    DecFieldTotal[1] += recReportDataBuffer."Decimal Field 1";
                    DecFieldTotal[2] += recReportDataBuffer."Decimal Field 2";
                    DecFieldTotal[3] += recReportDataBuffer."Decimal Field 3";
                    DecFieldTotal[4] += recReportDataBuffer."Decimal Field 4";
                    DecFieldTotal[5] += recReportDataBuffer."Decimal Field 5";
                    DecFieldTotal[6] += recReportDataBuffer."Decimal Field 6";
                    DecFieldTotal[7] += recReportDataBuffer."Decimal Field 7";
                    DecFieldTotal[8] += recReportDataBuffer."Decimal Field 8";
                    DecFieldTotal[9] += recReportDataBuffer."Decimal Field 9";


                    //MK end
                end;

                trigger OnPreDataItem()
                begin

                    //MK start
                    recReportDataBuffer.Reset;
                    recReportDataBuffer.SetCurrentkey("Code Field 1", "Code Field 3", "Code Field 2", "Date Field 1", "Code Field 5");
                    recReportDataBuffer.SetRange("Code Field 1", Location2.Code);

                    SetRange(Number, 1, recReportDataBuffer.Count);

                    Clear(DecField);
                    Clear(DecFieldTotal);
                    ToDelete := false;
                    //MK end
                end;
            }

            trigger OnAfterGetRecord()
            begin
                recReportDataBuffer.Reset;
                recReportDataBuffer.SetCurrentkey("Code Field 1", "Code Field 3", "Code Field 2", "Date Field 1", "Code Field 5");
                recReportDataBuffer.SetRange("Code Field 1", Location2.Code);
                if recReportDataBuffer.Count = 0 then
                    CurrReport.Skip;
            end;

            trigger OnPreDataItem()
            begin
                Reset;
                CopyFilters(Location);

                //CurrReport.CREATETOTALS(DecFieldTotal[1], DecFieldTotal[2], DecFieldTotal[3], DecFieldTotal[4], DecFieldTotal[5],
                //                      DecFieldTotal[6], DecFieldTotal[7], DecFieldTotal[8], DecFieldTotal[9]);
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
                    field(datStartingDate; datStartingDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Date From';
                    }
                    field(datEndingDate; datEndingDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Date To';
                    }
                    field(bShowAsAmounts; bShowAsAmounts)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Amount Mode';
                    }
                    field(NotShowAdditionalExpenses; NotShowAdditionalExpenses)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Don''t Show Additional Expenses';
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
        PurchaseLbl = 'Purchase';
        PosAdjLbl = 'Positive Adjustment';
        SaleLbl = 'Sale';
        NegAdjLbl = 'Negative Adjustment';
        OutbTransferLbl = 'Outbound Transfer';
        InboundTransfLbl = 'Inbound Transfer';
        TotalRemainLbl = 'Total Remaining';
        TotalLbl = 'Total';
        SalesInvNoLbl = 'Sales Invoice No.';
    }

    trigger OnPreReport()
    begin

        if datStartingDate = 0D then
            Error(StrSubstNo(Text001, Text002));
        if datEndingDate = 0D then
            Error(StrSubstNo(Text001, Text003));

        recReportDataBuffer.Reset;
        recReportDataBuffer.DeleteAll;
    end;

    var
        recReportDataBuffer: Record "Data Buffer";
        ItemLedgerEntry1: Record "Item Ledger Entry";
        InventoryPostingGroup: Record "Inventory Posting Group";
        recVehicleMark: Record Vehicle;
        Code3: Code[20];
        Code3_2: Code[20];
        codMakeCode: Code[20];
        codGlobalDim1Code: Code[20];
        datStartingDate: Date;
        datEndingDate: Date;
        c: Integer;
        iEntryNo: Integer;
        iExceLineNo: Integer;
        DecField: array[9] of Decimal;
        DecFieldTotal: array[9] of Decimal;
        ToDelete: Boolean;
        NotShowEmptyLine: Boolean;
        SkipIt: Boolean;
        NotShowAdditionalExpenses: Boolean;
        bGroupByVehType: Boolean;
        bShowAsAmounts: Boolean;
        Show: Boolean;
        Text001: label 'You must define %1';
        Text002: label 'Start Date';
        Text003: label 'End Date';
        Text004: label 'Location';
        Text005: label 'Total by Vehicle Type';
        HeaderText: label 'Vehicle Inventory Movement Overview';
        TextBeginBalance: label 'Begin Balance';
        TextEndBalance: label 'End Balance';
        TextPurchase: label 'Purchase';
        TextPositiveCorrections: label 'Positive Corrections';
        TextNegativeCorrections: label 'Negative Corrections';
        TextSale: label 'Sale';
        TextMoveOut: label 'Transfer Out';
        TextMoveIn: label 'Transfer In';
        TextPurchaseValue: label 'Purchase Value';


    procedure GetStartQty()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        Vehicle: Record Vehicle;
        Model: Record Model;
        SkipEntry: Boolean;
    begin
        //Start saldo
        recReportDataBuffer.Reset;
        recReportDataBuffer.SetCurrentkey("Code Field 1", "Code Field 2", "Code Field 3", "Code Field 4", "Code Field 5");
        recReportDataBuffer.SetRange("Code Field 1", Location.Code);
        ValueEntry.Reset;
        ValueEntry.SetCurrentkey("Location Code", "Posting Date");
        ValueEntry.CopyFilters("Value Entry");
        ValueEntry.SetRange("Location Code", Location.Code);
        // ValueEntry.SETFILTER("Posting Date", '..%1',CALCDATE('-1D',datStartingDate));
        ValueEntry.SetFilter("Posting Date", '..%1', CalcDate('<-1D>', datStartingDate));   // 27.04.2015 EDMS P21
        ValueEntry.SetRange("Item Type", ValueEntry."item type"::"Model Version");
        if ValueEntry.FindFirst then
            repeat
                SkipEntry := false;
                if NotShowAdditionalExpenses then begin
                    if InventoryPostingGroup.Get(ValueEntry."Inventory Posting Group") then
                        if InventoryPostingGroup."Vehicle Additional Expenses" then
                            SkipEntry := true;
                end;
                if not SkipEntry then begin
                    ItemLedgerEntry.Reset;
                    ItemLedgerEntry.Get(ValueEntry."Item Ledger Entry No.");
                    recReportDataBuffer.SetRange("Code Field 2", ItemLedgerEntry."Serial No.");
                    recReportDataBuffer.SetRange("Code Field 3", ItemLedgerEntry."Vehicle Accounting Cycle No.");
                    //recReportDataBuffer.SETRANGE("Code Field 4", FORMAT(ValueEntry."Item Ledger Entry Type"));
                    if recReportDataBuffer.FindFirst then begin
                        if not bShowAsAmounts then begin
                            recReportDataBuffer."Decimal Field 1" += ValueEntry."Item Ledger Entry Quantity";
                            recReportDataBuffer."Decimal Field 8" += ValueEntry."Item Ledger Entry Quantity";
                        end
                        else begin
                            recReportDataBuffer."Decimal Field 1" += ValueEntry."Cost Amount (Actual)";
                            recReportDataBuffer."Decimal Field 8" += ValueEntry."Cost Amount (Actual)";
                        end;
                        if ((ValueEntry."Item Ledger Entry Type" = ValueEntry."item ledger entry type"::Purchase) or
                            (ValueEntry."Item Ledger Entry Type" = ValueEntry."item ledger entry type"::"Positive Adjmt.")) and
                            (ValueEntry."Item Ledger Entry Quantity" > 0) and (recReportDataBuffer."Integer Field 10" = 1)
                          then
                            recReportDataBuffer."Decimal Field 9" += ValueEntry."Cost Amount (Actual)";
                        recReportDataBuffer.Modify;
                    end
                    else begin
                        iEntryNo += 1;
                        recReportDataBuffer.Init;
                        recReportDataBuffer."Entry No." := iEntryNo;
                        recReportDataBuffer."Code Field 1" := Location.Code;
                        recReportDataBuffer."Code Field 2" := ItemLedgerEntry."Serial No.";
                        recReportDataBuffer."Code Field 3" := ItemLedgerEntry."Vehicle Accounting Cycle No.";
                        recReportDataBuffer."Code Field 4" := Format(ValueEntry."Item Ledger Entry Type");
                        Vehicle.Get(ItemLedgerEntry."Serial No.");
                        recReportDataBuffer."Code Field 5" := Vehicle.VIN;
                        recReportDataBuffer."Code Field 6" := Vehicle."Make Code";
                        if Model.Get(Vehicle."Make Code", Vehicle."Model Code") then
                            recReportDataBuffer."Text Field 7" := Model."Commercial Name";

                        if not bShowAsAmounts then begin
                            recReportDataBuffer."Decimal Field 1" := ValueEntry."Item Ledger Entry Quantity";
                            recReportDataBuffer."Decimal Field 8" := ValueEntry."Item Ledger Entry Quantity";
                        end
                        else begin
                            recReportDataBuffer."Decimal Field 1" := ValueEntry."Cost Amount (Actual)";
                            recReportDataBuffer."Decimal Field 8" := ValueEntry."Cost Amount (Actual)";
                        end;
                        if ((ValueEntry."Item Ledger Entry Type" = ValueEntry."item ledger entry type"::Purchase) or
                            (ValueEntry."Item Ledger Entry Type" = ValueEntry."item ledger entry type"::"Positive Adjmt.")) and
                            (ValueEntry."Item Ledger Entry Quantity" > 0)
                          then
                            recReportDataBuffer."Decimal Field 9" := ValueEntry."Cost Amount (Actual)";
                        recReportDataBuffer."Integer Field 10" := 1;
                        recReportDataBuffer.Insert;
                    end;
                end;
            until ValueEntry.Next = 0;
    end;


    procedure CorrectSums()
    begin
        recReportDataBuffer.Reset;
        if recReportDataBuffer.FindFirst then
            repeat
                recReportDataBuffer."Decimal Field 1" *= recReportDataBuffer."Decimal Field 9";
                recReportDataBuffer."Decimal Field 2" *= recReportDataBuffer."Decimal Field 9";
                recReportDataBuffer."Decimal Field 3" *= recReportDataBuffer."Decimal Field 9";
                recReportDataBuffer."Decimal Field 4" *= recReportDataBuffer."Decimal Field 9";
                recReportDataBuffer."Decimal Field 5" *= recReportDataBuffer."Decimal Field 9";
                recReportDataBuffer."Decimal Field 6" *= recReportDataBuffer."Decimal Field 9";
                recReportDataBuffer."Decimal Field 7" *= recReportDataBuffer."Decimal Field 9";
                recReportDataBuffer."Decimal Field 8" *= recReportDataBuffer."Decimal Field 9";
                recReportDataBuffer.Modify;
            until recReportDataBuffer.Next = 0;
    end;
}

