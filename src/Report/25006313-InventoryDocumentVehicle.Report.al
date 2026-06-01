Report 25006313 "Inventory Document Vehicle"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/InventoryDocumentVehicle.rdlc';

    dataset
    {
        dataitem(Vehicle; Vehicle)
        {
            column(ReportForNavId_25006000; 25006000)
            {
            }
            column(VIN; VIN)
            {
                IncludeCaption = true;
            }
            column(MakeCode; "Make Code")
            {
                IncludeCaption = true;
            }
            column(ModelCode; "Model Code")
            {
                IncludeCaption = true;
            }
            column(ModelVersionNo; "Model Version No.")
            {
                IncludeCaption = true;
            }
            column(PurchaseDate; PurchaseDate)
            {
            }
            column(Cost; Cost)
            {
            }
            column(Expenses; Expenses)
            {
            }
            column(CostInclExpenses; CostInclExpenses)
            {
            }
            column(GroupTxt; GroupTxt)
            {
            }
            column(GroupBy; Format(GroupBy))
            {
            }
            column(LineNo; LineNo)
            {
            }
            column(CompanyName; CompanyInfo.Name)
            {
            }
            column(Filters; Vehicle.GetFilters)
            {
            }
            column(OnDate; OnDate)
            {
            }

            trigger OnAfterGetRecord()
            begin
                CostInclExpenses := 0;
                Cost := 0;
                Expenses := 0;
                GroupTxt := '';
                PurchaseDate := 0D;
                ItemLedgerEntry.Reset;
                ItemLedgerEntry.SetCurrentkey("Serial No.");
                ItemLedgerEntry.SetRange("Serial No.", "Serial No.");
                CalcFields("Default Vehicle Acc. Cycle No.");
                ItemLedgerEntry.SetRange("Vehicle Accounting Cycle No.", "Default Vehicle Acc. Cycle No.");
                ItemLedgerEntry.SetFilter("Posting Date", '..%1', OnDate);
                ItemLedgerEntry.CalcSums(Quantity);
                if ItemLedgerEntry.Quantity = 0 then
                    CurrReport.Skip;
                if ItemLedgerEntry.FindFirst then begin
                    PurchaseDate := ItemLedgerEntry."Posting Date";
                    ValueEntry.Reset;
                    ValueEntry.SetCurrentkey("Item Ledger Entry No.");
                    ValueEntry.SetRange("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
                    if ValueEntry.FindFirst then
                        repeat
                            if InventoryPostingGroup.Get(ValueEntry."Inventory Posting Group") and InventoryPostingGroup."Vehicle Additional Expenses" then
                                Expenses += ValueEntry."Cost Amount (Actual)"
                            else
                                Cost += ValueEntry."Cost Amount (Actual)";
                        until ValueEntry.Next = 0;
                end;

                CostInclExpenses := Cost + Expenses;
                case GroupBy of
                    Groupby::Make:
                        GroupTxt := "Make Code";
                    Groupby::"Location Code":
                        GroupTxt := ItemLedgerEntry."Location Code";
                    Groupby::"Inventory Posting Group":
                        GroupTxt := ValueEntry."Inventory Posting Group";
                end;

                LineNo += 1;
            end;

            trigger OnPreDataItem()
            begin
                LineNo := 0;
                CompanyInfo.Get;
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
                group(Control25006003)
                {
                    Caption = 'Options';
                    field(GroupBy; GroupBy)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Group By';
                        OptionCaption = 'Make,Location Code,Inventory Posting Group';
                    }
                    field(OnDate; OnDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'As On Date';
                        ShowMandatory = true;
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
        CostLbl = 'Cost';
        ExpensesLbl = 'Expenses';
        CostInclExpensesLbl = 'Cost Including Expenses';
        LineNoLbl = 'No.';
        PurchaseDateLbl = 'Purchase Date';
        ReportNameLbl = 'Vehicle Inventory';
        DateLbl = 'On Date';
        FiltersLbl = 'Filters';
        PageLbl = 'Page';
        TotalLbl = 'Total';
        RportTotalLbl = 'Report Total';
    }

    trigger OnPreReport()
    begin
        if OnDate = 0D then
            Error(Error01);
    end;

    var
        PurchaseDate: Date;
        Cost: Decimal;
        Expenses: Decimal;
        CostInclExpenses: Decimal;
        GroupTxt: Text;
        ItemLedgerEntry: Record "Item Ledger Entry";
        ValueEntry: Record "Value Entry";
        InventoryPostingGroup: Record "Inventory Posting Group";
        OnDate: Date;
        GroupBy: Option Make,"Location Code","Inventory Posting Group";
        LineNo: Integer;
        Error01: label 'Please Specify "On Date"';
        CompanyInfo: Record "Company Information";
}

