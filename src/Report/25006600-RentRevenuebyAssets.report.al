report 25006600 "Rent Revenue by Assets"
{
    ApplicationArea = All;
    Caption = 'Rent Revenue by Assets';
    UsageCategory = ReportsAndAnalysis;
    RDLCLayout = './Layouts/RentRevenuebyAssets.rdlc';
    dataset
    {
        dataitem(AssetFilter; "Rent Asset")
        {
            RequestFilterFields = "No.", "Rent Item Category Code";
            column(ReportForNavId_41; 41)
            {
            }

            trigger OnPreDataItem()
            begin
                CurrReport.Break;
            end;
        }
        dataitem(RentLedgerEntry; "Rent Ledger Entry")
        {
            DataItemTableView = sorting("Rent Asset No.") order(ascending) where("Document Type" = filter("Posted Sales Invoice" | "Posted Sales Cr.Memo"));
            PrintOnlyIfDetail = true;
            column(ReportForNavId_1; 1)
            {
            }
            column(CompName; COMPANYNAME)
            {
            }
            column(AssetFilters; AssetFilter.GetFilters)
            {
            }
            column(DocumentNo; RentLedgerEntry."Document No.")
            {
            }
            column(DocumentDate; RentLedgerEntry."Document Date")
            {
            }
            column(RentOrderNo; RentLedgerEntry."Rent Order No.")
            {
            }
            column(Amount; RentLedgerEntry.Amount)
            {
            }
            column(AmountIncludingVAT; RentLedgerEntry."Amount Including VAT")
            {
            }
            column(RentItemNo; RentLedgerEntry."Rent Item No.")
            {
            }
            column(RentAssetNo; RentLedgerEntry."Rent Asset No.")
            {
            }
            trigger OnAfterGetRecord()
            begin
                RentAssetText := StrSubstNo(Text001, "Rent Asset No.");

                RentAsset.SetRange("No.", "Rent Asset No.");

                if not RentAsset.FindFirst then
                    CurrReport.Skip;

                if PrevAssetNo <> "Rent Asset No." then begin
                    Clear(AssetValueArray);
                    PrevAssetNo := "Rent Asset No.";
                end;


            end;

            trigger OnPreDataItem()
            begin
                RentAsset.Reset;
                RentAsset.FilterGroup(0);
                RentAsset.CopyFilters(AssetFilter);
                RentAsset.FilterGroup(2);
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
                group("<Control2>")
                {
                    Caption = 'Options';
                    field(ShowDetails; ShowDetails)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Details';
                    }
                    field(HideZeroLines; HideZeroLines)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Hide Zero Lines';
                        Visible = false;
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
    trigger OnInitReport()
    begin
        HideZeroLines := true;
    end;

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
        RentAsset: Record "Rent Asset";
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
