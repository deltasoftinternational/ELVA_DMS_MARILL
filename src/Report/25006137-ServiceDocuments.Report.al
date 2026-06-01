Report 25006137 "Service Documents"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ServiceDocuments.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(SLedg1; "Service Ledger Entry EDMS")
        {
            DataItemTableView = sorting("Document No.", "Posting Date") order(ascending) where("Document Type" = const(Order));
            RequestFilterFields = "Posting Date";
            column(ReportForNavId_1; 1)
            {
            }
            column(DocumentType_SLedg1; SLedg1."Document Type")
            {
                IncludeCaption = true;
            }
            column(ServOrderNo_Sledg1; SLedg1."Service Order No.")
            {
                IncludeCaption = true;
            }
            column(PostingDate_Sledg1; Format(SLedg1."Posting Date"))
            {
            }
            column(DealSum_Sledg1; DealSum)
            {
            }
            column(DealSumIncVAT_Sledg1; DealSumIncVAT)
            {
            }
            column(DealSumTotal_Sledg1; DealSumTotal)
            {
            }
            column(DealSumIncVATTotal_Sledg1; DealSumIncVatTotal)
            {
            }
            dataitem(SLedg2; "Service Ledger Entry EDMS")
            {
                DataItemLink = "Service Order No." = field("Document No.");
                DataItemTableView = sorting("Document No.", "Posting Date") order(ascending) where("Document Type" = const(Invoice));
                PrintOnlyIfDetail = false;
                column(ReportForNavId_2; 2)
                {
                }
                column(DocumentType_Sledg2; SLedg2."Document Type")
                {
                    IncludeCaption = true;
                }
                column(DocumentNo_Sledg2; SLedg2."Document No.")
                {
                    IncludeCaption = true;
                }
                column(PostingDate_Sledg2; Format(SLedg2."Posting Date"))
                {
                }
                column(BillToCustNo_Sledg2; SLedg2."Bill-to Customer No.")
                {
                    IncludeCaption = true;
                }
                column(CustName_Cust; Customer.Name)
                {
                    IncludeCaption = true;
                }
                column(Doksum_Sledg2; DokSum)
                {
                }
                column(DokSumIncVAT_Sledg2; DokSumIncVAT)
                {
                }
                column(RemainingAmount_Sledg2; SLedg2."Remaining Amount")
                {
                    IncludeCaption = true;
                }
                dataitem("Detailed Cust. Ledg. Entry"; "Detailed Cust. Ledg. Entry")
                {
                    DataItemLink = "Cust. Ledger Entry No." = field("Cust. Ledger Entry No.");
                    DataItemTableView = sorting("Cust. Ledger Entry No.", "Posting Date") order(ascending) where("Entry Type" = const(Application));
                    column(ReportForNavId_3; 3)
                    {
                    }
                    column(DocumentType_DCustLedgENtry; "Detailed Cust. Ledg. Entry"."Document Type")
                    {
                        IncludeCaption = true;
                    }
                    column(DocumentNo_DCustLedgENtry; "Detailed Cust. Ledg. Entry"."Document No.")
                    {
                        IncludeCaption = true;
                    }
                    column(PostingDate_DCustLedgENtry; Format("Detailed Cust. Ledg. Entry"."Posting Date"))
                    {
                    }
                    column(CustomerNo_DCustLedgENtry; "Detailed Cust. Ledg. Entry"."Customer No.")
                    {
                        IncludeCaption = true;
                    }
                    column(Amount_DCustLedgENtry; "Detailed Cust. Ledg. Entry".Amount)
                    {
                        IncludeCaption = true;
                    }
                    dataitem(CLedg2; "Cust. Ledger Entry")
                    {
                        DataItemLink = "Entry No." = field("Applied Cust. Ledger Entry No.");
                        DataItemTableView = sorting("Entry No.") order(ascending);
                        column(ReportForNavId_4; 4)
                        {
                        }
                        column(RemainingAmount_CLedg2; CLedg2."Remaining Amount")
                        {
                            IncludeCaption = true;
                        }

                        trigger OnAfterGetRecord()
                        begin
                            CalcFields(CLedg2."Remaining Amount")
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                begin
                    case SLedg2."Document Type" of
                        SLedg2."document type"::Invoice:
                            if SalesInvc.Get(SLedg2."Document No.") then
                                ;
                        SLedg2."document type"::"Credit Memo":
                            if SalesCrMemo.Get(SLedg2."Document No.") then
                                ;
                    end;
                    if Customer.Get(SLedg2."Bill-to Customer No.") then;

                    SetRange("Document No.", "Document No.");
                    SetRange("Document Type", "Document Type");
                    DokSum := 0;
                    DokSumIncVAT := 0;
                    repeat
                        DokSum := DokSum + Amount;
                        DokSumIncVAT := DokSumIncVAT + "Amount Including VAT"
                    until Next = 0;
                    SetRange("Document No.");
                    SetRange("Document Type");
                    CalcFields("Remaining Amount");
                end;
            }
            dataitem("Sales Header"; "Sales Header")
            {
                DataItemLink = "Service Document No." = field("Service Order No.");
                DataItemTableView = sorting("Document Type", "No.") order(ascending) where("Service Document No." = filter(<> ''));
                PrintOnlyIfDetail = true;
                column(ReportForNavId_5; 5)
                {
                }
                column(DocType_SalesHeader; "Sales Header"."Document Type")
                {
                    IncludeCaption = true;
                }
                column(No_SalesHeader; "Sales Header"."No.")
                {
                    IncludeCaption = true;
                }
                column(Amount_SalesHeader; "Sales Header".Amount)
                {
                    IncludeCaption = true;
                }
                column(AmountInclVAT_SalesHeader; "Sales Header"."Amount Including VAT")
                {
                    IncludeCaption = true;
                }

                trigger OnAfterGetRecord()
                begin
                    CalcFields(Amount, "Amount Including VAT")
                end;
            }

            trigger OnAfterGetRecord()
            begin
                SetRange("Document No.", "Document No.");
                DealSum := 0;
                DealSumIncVAT := 0;
                repeat
                    DealSum := DealSum + Amount;
                    DealSumIncVAT := DealSumIncVAT + "Amount Including VAT"
                until Next = 0;
                SetRange("Document No.");

                DealSumTotal += DealSum;
                DealSumIncVatTotal += DealSumIncVAT;
            end;

            trigger OnPreDataItem()
            begin
                DealSumTotal := 0;
                DealSumIncVatTotal := 0;
            end;
        }
    }

    requestpage
    {

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
        ReportTitleLbl = 'Service Documents';
        UnpostedDocsLbl = 'Unposted';
        TotalLbl = 'Total';
        PostingDateLbl = 'Posting Date';
        CustomerNameLbl = 'Customer Name';
    }

    var
        SalesCrMemo: Record "Sales Cr.Memo Header";
        SalesInvc: Record "Sales Invoice Header";
        Customer: Record Customer;
        DealSum: Decimal;
        DealSumIncVAT: Decimal;
        DealSumTotal: Decimal;
        DealSumIncVatTotal: Decimal;
        DokSum: Decimal;
        DokSumIncVAT: Decimal;
        OrdRemAMT: Decimal;
}

