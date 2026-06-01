Report 25006138 "Service Ledger Entry Overview"
{
    // 25.02.2015 EDMS P21
    //   Modified report
    // 
    // 28.03.2013 Elva Baltic P15
    //   * Created (based on NAV2009 respective report)
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ServiceLedgerEntryOverview.rdlc';

    Caption = 'Service Ledger Entry Overview';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Service Ledger Entry EDMS"; "Service Ledger Entry EDMS")
        {
            DataItemTableView = sorting("Payment Method Code", "Entry Type", "Document Type", "Document No.") where("Entry Type" = const(Sale));
            RequestFilterFields = "Payment Method Code", "Posting Date", "Global Dimension 1 Code", "Global Dimension 2 Code";
            column(ReportForNavId_1; 1)
            {
            }
            column(Filters; GetFilters)
            {
            }
            column(DocumentType_ServLedgEntry; "Document Type")
            {
                IncludeCaption = true;
            }
            column(DocumentNo_ServLedgEntry; "Document No.")
            {
                IncludeCaption = true;
            }
            column(VIN_ServLedgEntry; VIN)
            {
            }
            column(PostingDate_ServLedgEntryCaption; FieldCaption("Posting Date"))
            {
            }
            column(PostingDate_ServLedgEntry; Format("Service Ledger Entry EDMS"."Posting Date"))
            {
                IncludeCaption = false;
            }
            column(CustomerNo_ServLedgEntry; "Customer No.")
            {
                IncludeCaption = true;
            }
            column(CustomerNameCaption; CustomerNameLbl)
            {
            }
            column(CustomerName; CustomerName)
            {
            }
            column(BillToCustNo_ServLedgEntry; "Bill-to Customer No.")
            {
                IncludeCaption = true;
            }
            column(BillToNameCaption; BillNameLbl)
            {
            }
            column(BillToName; BillName)
            {
            }
            column(Currency_ServLedgEntry; "Currency Code")
            {
                IncludeCaption = true;
            }
            column(LaborAmountCaption; LaborAmountLbl)
            {
            }
            column(LaborAmount; LaborAmount)
            {
            }
            column(SparePartAmountCaption; SparePartAmountLbl)
            {
            }
            column(SparePartAmount; SparePartAmount)
            {
            }
            column(OtherAmountCaption; OtherAmountLbl)
            {
            }
            column(OtherAmount; OtherAmount)
            {
            }
            column(AmountExclVAT_ServLedgEntry; Amount)
            {
                IncludeCaption = true;
            }
            column(AmountInclVAT_ServLedgEntry; CustomAmountIncVAT)
            {
            }
            column(AmountInclVATCaption; FieldCaption("Amount Including VAT"))
            {
            }
            column(TotalEntries; TotalEntries)
            {
            }
            column(TotalEntriesCaption; TotalEntriesLbl)
            {
            }
            column(ReportTitleCaption; ReportTitleLbl)
            {
            }
            column(TotalCaption; TotalLbl)
            {
            }
            column(PaymentMethodCode; "Payment Method Code")
            {
            }
            column(ExternalServiceAmount; ExternalServiceAmount)
            {
            }
            column(CustomAmountIncVAT; "Amount Including VAT")
            {
            }
            column(ExternalDocumentNo; "External Document No.")
            {
            }
            column(ExternalDocumenNoCaption; FieldCaption("External Document No."))
            {
            }
            column(ShowPmtMthSums; ShowPmtMthSums)
            {
            }

            trigger OnAfterGetRecord()
            var
                Customer: Record Customer;
                SalesInvHdr: Record "Sales Invoice Header";
                SalesCrMemo: Record "Sales Cr.Memo Header";
            begin
                LaborAmount := 0;
                SparePartAmount := 0;
                ExternalServiceAmount := 0;
                OtherAmount := 0;
                OtherAmountInclVAT := 0;
                CustomAmountIncVAT := 0;

                case Type of
                    Type::Labor:
                        LaborAmount := -Amount;
                    Type::Item:
                        SparePartAmount := -Amount;
                    Type::"Ext. Service":
                        ExternalServiceAmount := -Amount;
                    else begin
                        OtherAmount := -Amount;
                        OtherAmountInclVAT := -"Amount Including VAT";
                    end;
                end;
                CustomAmountIncVAT := "Amount Including VAT" - OtherAmountInclVAT;

                if Customer.Get("Customer No.") then
                    CustomerName := Customer.Name;
                if Customer.Get("Bill-to Customer No.") then
                    BillName := Customer.Name;

                DocumentType := Format("Document Type");
                if "Document Type" = "document type"::Invoice then begin
                    if SalesInvHdr.Get("Document No.") then
                        if SalesInvHdr.Correction then
                            DocumentType += '(' + Text001 + ')';
                end;
                if "Document Type" = "document type"::"Credit Memo" then begin
                    if SalesCrMemo.Get("Document No.") then
                        if SalesCrMemo.Correction then
                            DocumentType += '(' + Text001 + ')';
                end;

                if "Document Type" = "document type"::"Credit Memo" then
                    TotalEntries := TotalEntries - 1
                else
                    TotalEntries := TotalEntries + 1;

                if Type = Type::"G/L Account" then begin
                    if Quantity > 0 then begin
                        CustomAmountIncVAT := "Amount Including VAT";
                        Amount := 0;
                        "Amount Including VAT" := 0;
                    end else begin
                        CustomAmountIncVAT := "Amount Including VAT";
                        Amount := 0;
                        "Amount Including VAT" := 0;
                    end;
                end;
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(ShowPmtMthSums; ShowPmtMthSums)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show only sums';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        PaumentMethodLbl = 'Payment Method';
        PaymentAmountLbl = 'Payment Amount';
        ExternalAmountLbl = 'External Service';
        PPRNoLbl = 'Blank form No.';
    }

    var
        SalesInvoiceHeader: Record "Sales Invoice Header";
        ServiceItem: Record Item;
        BillName: Text[100];
        DocumentType: Text[30];
        LaborAmount: Decimal;
        SparePartAmount: Decimal;
        ExternalServiceAmount: Decimal;
        OtherAmount: Decimal;
        OtherAmountInclVAT: Decimal;
        TotalAmount: Decimal;
        TotalEntries: Integer;
        Text001: label 'correction';
        TotalEntriesLbl: label 'Total entries';
        LaborAmountLbl: label 'Labor Amount';
        SparePartAmountLbl: label 'Spare Part Amount';
        OtherAmountLbl: label 'Other Amount';
        CustomerNameLbl: label 'Customer Name';
        BillNameLbl: label 'Bill-to Customer Name';
        ReportTitleLbl: label 'Service Ledger Entry Overview';
        TotalLbl: label 'Total';
        CustomAmountIncVAT: Decimal;
        CustomerName: Text;
        ShowPmtMthSums: Boolean;
}

