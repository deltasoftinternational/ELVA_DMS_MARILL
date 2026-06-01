Report 25006131 "Resource Usage EDMS"
{
    // 2015.05.20 EB.P30 #T038
    //   * Modified "Service Ledger Entry EDMS" data item
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ResourceUsageEDMS.rdlc';

    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Det. Serv. Ledger Entry EDMS"; "Det. Serv. Ledger Entry EDMS")
        {
            DataItemTableView = sorting("Resource No.") where("Document Type" = filter(Order | "Return Order"));
            RequestFilterFields = "Resource No.";
            column(ReportForNavId_1; 1)
            {
            }
            column(ResourceNo_DetServLedgerEntryEDMS; "Det. Serv. Ledger Entry EDMS"."Resource No.")
            {
                IncludeCaption = true;
            }
            column(ResourceName_DetServLedgerEntryEDMS; Resource.Name)
            {
            }
            column(GetFiltersExpr; GetFiltersExpr)
            {
            }
            dataitem("Service Ledger Entry EDMS"; "Service Ledger Entry EDMS")
            {
                DataItemLink = "Entry No." = field("Service Ledger Entry No.");
                DataItemTableView = sorting("Entry Type", Type, "Payment Method Code", "No.", "Posting Date") where(Type = const(Labor));
                RequestFilterFields = "Posting Date";
                column(ReportForNavId_2; 2)
                {
                }
                column(DocumentNo_ServiceLedgerEntryEDMS; "Service Ledger Entry EDMS"."Document No.")
                {
                    IncludeCaption = true;
                }
                column(PostingDate_ServiceLedgerEntryEDMS; Format("Service Ledger Entry EDMS"."Posting Date"))
                {
                }
                column(Amount_ServiceLedgerEntryEDMS; "Service Ledger Entry EDMS".Amount)
                {
                    IncludeCaption = true;
                }
                column(AmountIncludingVAT_ServiceLedgerEntryEDMS; "Service Ledger Entry EDMS"."Amount Including VAT")
                {
                    IncludeCaption = true;
                }
                column(Quantity_ServiceLedgerEntryEDMS; "Service Ledger Entry EDMS".Quantity)
                {
                    IncludeCaption = true;
                }
                column(Description_ServiceLedgerEntryEDMS; "Service Ledger Entry EDMS".Description)
                {
                    IncludeCaption = true;
                }
                column(PaymentMethodCode_ServiceLedgerEntryEDMS; "Service Ledger Entry EDMS"."Payment Method Code")
                {
                    IncludeCaption = true;
                }

                trigger OnAfterGetRecord()
                begin
                    // 2015.05.20 EB.P30 #T038  >>
                    //Amount *= -1;
                    //"Amount Including VAT" *= -1;
                    //Quantity *= -1;
                    // 2015.05.20 EB.P30 #T038  <<

                    if "Discount %" <> 100 then begin
                        AmountExclDisc := Amount / (1 - "Discount %" / 100);
                        AmountExclDiscVAT := "Amount Including VAT" / (1 - "Discount %" / 100);
                    end
                    else begin
                        AmountExclDisc := Amount;
                        AmountExclDiscVAT := "Amount Including VAT";
                    end;
                    ResourceValueArray[1] += Quantity;
                    ResourceValueArray[2] += Amount;
                    ResourceValueArray[3] += "Amount Including VAT";
                end;

                trigger OnPreDataItem()
                begin
                    if bPremiumSet then
                        SetRange("Posting Date", datStartingDate, datEndingDate);
                    Clear(PrevDocNo);
                end;
            }

            trigger OnAfterGetRecord()
            begin

                if Resource.Get("Resource No.") then;
                if PrevResourceNo <> "Resource No." then begin
                    Clear(ResourceValueArray);
                    PrevResourceNo := "Resource No.";
                end;
            end;

            trigger OnPreDataItem()
            begin
                GetFiltersExpr := GetFilters;
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
        ReportTitleLbl = 'Resource Usage';
        TotalByLbl = 'Total by';
        TotalQuantityLbl = 'Total Quantity';
        PostingDateLbl = 'Posting Date';
        ResourceNameLbl = 'Resource Name';
    }

    var
        Resource: Record Resource;
        AmountExclDisc: Decimal;
        AmountExclDiscVAT: Decimal;
        "---": Integer;
        recEmpl: Record Employee;
        codDocNo: Code[20];
        codDocNo1: Code[20];
        datStartingDate: Date;
        datEndingDate: Date;
        bPremium: Boolean;
        bPremiumSet: Boolean;
        ResourceValueArray: array[10] of Decimal;
        TotalValueArray: array[10] of Decimal;
        PrevDocNo: Code[20];
        PrevResourceNo: Code[20];
        i: Integer;
        EDMS001: label 'Total by';
        GetFiltersExpr: Text[250];


    procedure fSetPrem(codAKRNoParam: Code[20]; dat1: Date; dat2: Date)
    begin
        codDocNo1 := codAKRNoParam;
        bPremiumSet := true;
        datStartingDate := dat1;
        datEndingDate := dat2;
    end;
}

