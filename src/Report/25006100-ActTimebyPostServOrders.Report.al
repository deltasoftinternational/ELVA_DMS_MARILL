Report 25006100 "Act. Time by Post.Serv. Orders"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ActTimebyPostServOrders.rdlc';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Posted Serv. Order Header"; "Posted Serv. Order Header")
        {
            RequestFilterFields = "No.", "Posting Date";
            column(ReportForNavId_1; 1)
            {
            }
            column(SelltoCustomerNo_PostedServOrderHeader; "Posted Serv. Order Header"."Sell-to Customer No.")
            {
                IncludeCaption = true;
            }
            column(No_PostedServOrderHeader; "Posted Serv. Order Header"."No.")
            {
                IncludeCaption = true;
            }
            column(PostingDate_PostedServOrderHeader; Format("Posted Serv. Order Header"."Posting Date"))
            {
            }
            column(SelltoCustomerName_PostedServOrderHeader; "Posted Serv. Order Header"."Sell-to Customer Name")
            {
                IncludeCaption = true;
            }
            column(ServicePerson_PostedServOrderHeader; "Posted Serv. Order Header"."Service Advisor")
            {
                IncludeCaption = true;
            }
            column(PlannedHours_PostedServOrderHeader; PlannedHours)
            {
            }
            column(StandardTime_PostedServOrderHeader; StandardTime)
            {
            }
            column(RealHours_PostedServOrderHeader; RealHours)
            {
            }
            column(TotalPlannedHours_PostedServOrderHeader; TotalPlannedHours)
            {
            }
            column(TotalStandardTime_PostedServOrderHeader; TotalStandardTime)
            {
            }
            column(TotalRealHours_PostedServOrderHeader; TotalRealHours)
            {
            }
            column(ShowDetails; ShowDetails)
            {
            }
            dataitem("Service Ledger Entry EDMS"; "Service Ledger Entry EDMS")
            {
                CalcFields = "Finished Hours";
                DataItemLink = "Document No." = field("No."), "Posting Date" = field("Posting Date");
                DataItemTableView = sorting("Document Type", "Document No.", "Posting Date") order(ascending) where("Document Type" = const(Order), Type = const(Labor));
                PrintOnlyIfDetail = false;
                column(ReportForNavId_2; 2)
                {
                }
                column(Description_ServiceLedgerEntryEDMS; "Service Ledger Entry EDMS".Description)
                {
                    IncludeCaption = true;
                }
                column(Quantity_ServiceLedgerEntryEDMS; "Service Ledger Entry EDMS".Quantity)
                {
                    IncludeCaption = true;
                }
                column(StandardTime_ServiceLedgerEntryEDMS; "Service Ledger Entry EDMS"."Standard Time")
                {
                    IncludeCaption = true;
                }
                column(IsServLedgEntryRec; IsServLedgEntryRec)
                {
                }
                dataitem("Det. Serv. Ledger Entry EDMS"; "Det. Serv. Ledger Entry EDMS")
                {
                    DataItemLink = "Service Ledger Entry No." = field("Entry No.");
                    DataItemTableView = sorting("Service Ledger Entry No.") order(ascending);
                    RequestFilterFields = "Resource No.";
                    column(ReportForNavId_3; 3)
                    {
                    }
                    column(ResourceNo_DetServLedgerEntryEDMS; "Det. Serv. Ledger Entry EDMS"."Resource No.")
                    {
                        IncludeCaption = true;
                    }
                    column(FinishedQuantityHours_DetServLedgerEntryEDMS; "Det. Serv. Ledger Entry EDMS"."Finished Quantity (Hours)")
                    {
                        IncludeCaption = true;
                    }
                    column(StandardTimeDet; StandardTimeDet)
                    {
                    }
                    column(InvoicedQuantityDet; InvoicedQuantityDet)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin

                        if "Service Ledger Entry EDMS"."Finished Hours" <> 0 then begin
                            StandardTimeDet := ROUND(("Service Ledger Entry EDMS"."Standard Time" / "Service Ledger Entry EDMS"."Finished Hours") * "Finished Quantity (Hours)", 0.01);
                            InvoicedQuantityDet := ROUND(("Service Ledger Entry EDMS".Quantity / "Service Ledger Entry EDMS"."Finished Hours") * "Finished Quantity (Hours)", 0.01);
                        end else begin
                            if PreviosServLedgEntryNo <> "Service Ledger Entry No." then begin
                                StandardTimeDet := "Service Ledger Entry EDMS"."Standard Time";
                                InvoicedQuantityDet := "Service Ledger Entry EDMS".Quantity;
                            end else begin
                                StandardTimeDet := 0;
                                InvoicedQuantityDet := 0;
                            end;
                        end;
                        PreviosServLedgEntryNo := "Service Ledger Entry No.";
                    end;
                }

                trigger OnPreDataItem()
                begin
                    if not ShowDetails then
                        CurrReport.Break;
                end;
            }

            trigger OnAfterGetRecord()
            begin

                PlannedHours := 0;
                RealHours := 0;
                StandardTime := 0;
                DetServLedgerEntry.Reset;
                DetServLedgerEntry.SetCurrentkey("Document Type", "Document No.", "Posting Date");
                DetServLedgerEntry.SetRange("Document Type", DetServLedgerEntry."document type"::Order);
                DetServLedgerEntry.SetRange("Document No.", "No.");
                if DetServLedgerEntry.FindFirst then
                    repeat
                        RealHours += ROUND(DetServLedgerEntry."Finished Quantity (Hours)", 0.01);
                        TotalRealHours += ROUND(DetServLedgerEntry."Finished Quantity (Hours)", 0.01);
                    until DetServLedgerEntry.Next = 0;

                PostedServiceLine.Reset;
                PostedServiceLine.SetRange("Document No.", "No.");
                PostedServiceLine.SetRange(Type, PostedServiceLine.Type::Labor);

                GetFiltersExpr := GetFilters;
                IsServLedgEntryRec := false;

                if PostedServiceLine.FindFirst then begin
                    IsServLedgEntryRec := true;
                    repeat
                        StandardTime += PostedServiceLine."Standard Time";
                        PlannedHours += PostedServiceLine.Quantity;
                        TotalPlannedHours += PostedServiceLine.Quantity;
                        TotalStandardTime += PostedServiceLine."Standard Time";
                    until PostedServiceLine.Next = 0
                end else
                    CurrReport.Skip;
            end;

            trigger OnPreDataItem()
            begin

                TotalRealHours := 0;
                TotalPlannedHours := 0;
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
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        ReportTitleLbl = 'Actual Time by Posted Service Orders';
        Descriptionlbl = 'Description';
        ResourceNoLbl = 'Resource No.';
        StandardTimeLbl = 'Standard Time (Hours)';
        ActualTimeLbl = 'Actual Time (Hours)';
        PostingDateLbl = 'Posting Date';
    }

    var
        PostedServiceLine: Record "Posted Serv. Order Line";
        DetServLedgerEntry: Record "Det. Serv. Ledger Entry EDMS";
        PlannedHours: Decimal;
        RealHours: Decimal;
        TotalPlannedHours: Decimal;
        TotalRealHours: Decimal;
        StandardTime: Decimal;
        TotalStandardTime: Decimal;
        ShowDetails: Boolean;
        GetFiltersExpr: Text[250];
        IsServLedgEntryRec: Boolean;
        StandardTimeDet: Decimal;
        InvoicedQuantityDet: Decimal;
        PreviosServLedgEntryNo: Integer;
}

