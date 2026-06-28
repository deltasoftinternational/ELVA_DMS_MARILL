report 25006601 "Rent Revenue by Customers"
{
    ApplicationArea = All;
    Caption = 'Rent Revenue by Customers';
    UsageCategory = ReportsAndAnalysis;
    PreviewMode = PrintLayout;
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/RentRevenuebyCustomers.rdlc';
    DataAccessIntent = ReadOnly;

    dataset
    {
        dataitem(Customer; Customer)
        {
            RequestFilterFields = "No.", "Gen. Bus. Posting Group";
            PrintOnlyIfDetail = true;
            column(ReportForNavId_41; 41)
            {
            }
            column(CustomerFilters; GetFilters)
            {
            }
            column(No; "No.")
            {
                IncludeCaption = true;
            }
            column(Name; Name)
            {
                IncludeCaption = true;
            }
            column(VATRegistrationNo; "VAT Registration No.")
            {
                IncludeCaption = true;
            }
            dataitem(RentHeader; "Rent Header")
            {
                DataItemLink = "Sell-To Customer No." = field("No.");
                PrintOnlyIfDetail = false;
                RequestFilterFields = "Deal Type";
                column(ReportForNavId_1; 1)
                {
                }
                column(RentHeaderFilters; GetFilters)
                {
                }
                column(No_RentHeader; "No.")
                {
                    IncludeCaption = true;
                }
                column(ContractNo_RentHeader; "Contract No.")
                {
                    IncludeCaption = true;
                }
                column(RentType_RentHeader; "Rent Type")
                {
                    IncludeCaption = true;
                }
                column(DealType_RentHeader; "Deal Type")
                {
                    IncludeCaption = true;
                }
                column(DocumentDate_RentHeader; "Document Date")
                {
                    IncludeCaption = true;
                }
                column(ShowDetails; ShowDetails)
                {
                }
                dataitem(RentLedgerEntry; "Rent Ledger Entry")
                {
                    DataItemLink = "Rent Order No." = field("No.");
                    DataItemTableView = sorting("Rent Order No.") order(ascending) where("Document Type" = filter("Posted Sales Invoice" | "Posted Sales Cr.Memo"));
                    PrintOnlyIfDetail = false;
                    RequestFilterFields = "Posting Date";
                    column(ReportForNavId_2; 1)
                    {
                    }
                    column(CompName; COMPANYNAME)
                    {
                    }
                    column(RentLedgerFilters; GetFilters)
                    {
                    }
                    column(DocumentNo; RentLedgerEntry."Document No.")
                    {
                        IncludeCaption = true;
                    }
                    column(DocumentDate; RentLedgerEntry."Document Date")
                    {
                        IncludeCaption = true;
                    }
                    column(RentOrderNo; RentLedgerEntry."Rent Order No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Amount; RentLedgerEntry.Amount)
                    {
                        IncludeCaption = true;
                    }
                    column(AmountIncludingVAT; RentLedgerEntry."Amount Including VAT")
                    {
                        IncludeCaption = true;
                    }
                    column(RentItemNo; RentLedgerEntry."Rent Item No.")
                    {
                        IncludeCaption = true;
                    }
                    column(RentAssetNo; RentLedgerEntry."Rent Asset No.")
                    {
                        IncludeCaption = true;
                    }
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
                group("<Control2>")
                {
                    Caption = 'Options';
                    field(ShowDetails; ShowDetails)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Details';
                    }
                }
            }
        }
        actions
        {
            area(processing)
            {
            }
        }
    }
    labels
    {
        ReportTitleLbl = 'Rent Revenue by Assets';
        TotalLbl = 'Total';
        TotalByLbl = 'Total by';
        AssetNoLbl = 'Asset No.';
        PostingDateLbl = 'Posting Date';
        AssetDescriptionLbl = 'Asset Description';
        PostDateLbl = 'Post. Date';
        PageLbl = 'Page';
    }
    trigger OnPreReport()
    begin
        Clear(AssetValueArray);
        Clear(TotalValueArray);
        Clear(PrevAssetNo);
        Clear(PrevDocAsset);

        if RentLedgerEntry.GetFilter("Posting Date") <> '' then begin
            StartDate := RentLedgerEntry.GetRangeMin("Posting Date");
            EndDate := RentLedgerEntry.GetRangemax("Posting Date");
        end;
    end;

    var
        ShowDetails: Boolean;
        HideZeroLines: Boolean;
        RentAssetText: Text[100];
        Text001: label 'Total by %1';
        PrevAssetNo: Code[20];
        AssetValueArray: array[10] of Decimal;
        PrevDocNo: Code[20];
        PrevDocAsset: Code[20];
        TotalValueArray: array[10] of Decimal;
        StartDate: Date;
        EndDate: Date;
}
