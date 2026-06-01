Report 25006006 "Resource Service Times"
{
    // 02.06.2014 Elva Baltic P21 #R120 MMG7.00
    //   Set PrintOnlyIfDetail Property to Yes for:
    //     Det. Serv. Ledger Entry EDMS
    //   Added Filters to Layout
    //   Modified trigger (Fixed error with double amounts):
    //     Service Ledger Entry EDMS - OnAfterGetRecord()
    //   Set Visible false for:
    //     HideZeroLines
    // 
    // 09.05.2014 Elva Baltic P15 #R120 MMG7.00
    //   * Changed TimeFactor calculation:
    //     - old: TimeFactor := ROUND(ResourceValueArray[3]/ResourceValueArray[2], 0.01)
    //     - new: TimeFactor := (ROUND(ResourceValueArray[1]/ResourceValueArray[3], 0.01)) * 100
    // 
    // 07.05.2014 Elva Baltic P8 #R120 MMG7.00
    //   * JobNo changed from "Job No." became "No."
    // 
    // 06.05.2014 Elva Baltic P8 #R120 MMG7.00
    //   * Added Resource as dataitem - to be filtered
    // 
    // 21.03.2014 Elva Baltic P18 #R120
    //   Added Code to
    //     OnPreReport()
    //     Det. Serv. Ledger Entry EDMS - OnAfterGetRecord()
    //   Modified layout
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ResourceServiceTimes.rdlc';

    Caption = 'Resource Service Times';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem(ResourceUserFilter; Resource)
        {
            RequestFilterFields = "No.", "Resource Group No.";
            column(ReportForNavId_41; 41)
            {
            }

            trigger OnPreDataItem()
            begin
                CurrReport.Break;
            end;
        }
        dataitem("Det. Serv. Ledger Entry EDMS"; "Det. Serv. Ledger Entry EDMS")
        {
            DataItemTableView = sorting("Resource No.") order(ascending) where("Document Type" = filter(Order | "Return Order"));
            PrintOnlyIfDetail = true;
            column(ReportForNavId_1; 1)
            {
            }
            column(CompName; COMPANYNAME)
            {
            }
            column(ResourceNo_DetServLedgerEntryEDMS; "Det. Serv. Ledger Entry EDMS"."Resource No.")
            {
                IncludeCaption = true;
            }
            column(ResourceName; Resource.Name)
            {
            }
            column(ShowDetails; ShowDetails)
            {
            }
            column(LedgerEntryFilters; "Det. Serv. Ledger Entry EDMS".GetFilters)
            {
            }
            column(HideZeroLines; HideZeroLines)
            {
            }
            column(ServiceLedgerEntryEDMSFilters; "Service Ledger Entry EDMS".GetFilters)
            {
            }
            column(ResourceFilters; ResourceUserFilter.GetFilters)
            {
            }
            dataitem("Service Ledger Entry EDMS"; "Service Ledger Entry EDMS")
            {
                DataItemLink = "Entry No." = field("Service Ledger Entry No.");
                DataItemTableView = sorting("Entry Type", Type, "Payment Method Code", "No.", "Posting Date") where(Type = const(Labor));
                PrintOnlyIfDetail = false;
                RequestFilterFields = "Posting Date", "Location Code";
                column(ReportForNavId_2; 2)
                {
                }
                column(StandardTime_ServiceLedgerEntryEDMS; "Service Ledger Entry EDMS"."Standard Time")
                {
                    IncludeCaption = true;
                }
                column(DocumentNo_ServiceLedgerEntryEDMS; "Service Ledger Entry EDMS"."Document No.")
                {
                    IncludeCaption = true;
                }
                column(PostingDate_ServiceLedgerEntryEDMS; Format("Service Ledger Entry EDMS"."Posting Date"))
                {
                }
                column(VehicleSerialNo_ServiceLedgerEntryEDMS; "Service Ledger Entry EDMS"."Vehicle Serial No.")
                {
                    IncludeCaption = true;
                }
                column(MakeCode_ServiceLedgerEntryEDMS; "Service Ledger Entry EDMS"."Make Code")
                {
                    IncludeCaption = true;
                }
                column(ModelCode_ServiceLedgerEntryEDMS; "Service Ledger Entry EDMS"."Model Code")
                {
                    IncludeCaption = true;
                }
                column(CustomerNo_ServiceLedgerEntryEDMS; "Service Ledger Entry EDMS"."Customer No.")
                {
                    IncludeCaption = true;
                }
                column(Quantity_ServiceLedgerEntryEDMS; "Service Ledger Entry EDMS".Quantity)
                {
                    IncludeCaption = true;
                }
                column(VehicleProdYear; Vehicle."Production Year")
                {
                    IncludeCaption = true;
                }
                column(ActualTime_ServiceLedgerEntryEDMS; ActualTime)
                {
                    DecimalPlaces = 2 : 2;
                }
                column(TimeFactor_ServiceLedgerEntryEDMS; TimeFactor)
                {
                    DecimalPlaces = 2 : 2;
                }
                column(LineDiscountAmountLCY_ServiceLedgerEntryEDMS; "Service Ledger Entry EDMS"."Line Discount Amount (LCY)")
                {
                    IncludeCaption = true;
                }
                column(AmountLCY_ServiceLedgerEntryEDMS; "Service Ledger Entry EDMS"."Amount (LCY)")
                {
                    IncludeCaption = true;
                }
                column(AmountIncludingVATLCY_ServiceLedgerEntryEDMS; "Service Ledger Entry EDMS"."Amount Including VAT (LCY)")
                {
                    IncludeCaption = true;
                }
                column(JobDescription; "Service Ledger Entry EDMS".Description)
                {
                    IncludeCaption = true;
                }
                column(JobNo; "Service Ledger Entry EDMS"."No.")
                {
                    IncludeCaption = true;
                }
                column(PresenceTime; PresenceTime)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    // KP
                    Vehicle.Get("Service Ledger Entry EDMS"."Vehicle Serial No.");
                    /// KP

                    // 02.06.2014 Elva Baltic P21 #R120 MMG7.00 >>
                    if (PrevEntryNo <> 0) and (PrevEntryNo = "Entry No.") then
                        "Amount (LCY)" := 0;
                    PrevEntryNo := "Entry No.";
                    // 02.06.2014 Elva Baltic P21 #R120 MMG7.00 <<

                    QuantityTotal += Quantity;
                    StandardTimeTotal += "Standard Time";
                    AmountIncludingVATtotal += "Amount Including VAT (LCY)";
                    AmountLCYTotal += "Amount (LCY)";
                    LineDiscountAmountLCYTotal += "Line Discount Amount (LCY)";

                    //09.05.2014 Elva Baltic P15 #R120 MMG7.00 >>

                    //ResourceValueArray[1] += Quantity;
                    //ResourceValueArray[2] += "Standard Time";
                    //ResourceValueArray[3] += ActualTime;
                    //ResourceValueArray[5] += "Line Discount Amount (LCY)";
                    //ResourceValueArray[6] += "Amount (LCY)";
                    //ResourceValueArray[7] += "Amount Including VAT (LCY)";

                    ResourceValueArray[1] := Quantity;
                    ResourceValueArray[2] := "Standard Time";
                    ResourceValueArray[3] := ActualTime;
                    ResourceValueArray[5] := "Line Discount Amount (LCY)";
                    ResourceValueArray[6] := "Amount (LCY)";
                    ResourceValueArray[7] := "Amount Including VAT (LCY)";

                    if ResourceValueArray[3] <> 0 then
                        TimeFactor := (ROUND(ResourceValueArray[1] / ResourceValueArray[3], 0.01)) * 100
                    else
                        //TimeFactor := ROUND(ResourceValueArray[3], 0.01);
                        TimeFactor := 0;

                    //09.05.2014 Elva Baltic P15 #R120 MMG7.00 <<
                    ResourceValueArray[4] := TimeFactor;
                end;

                trigger OnPreDataItem()
                begin

                    ServLaborAllocationEntry.Reset;
                    ServLaborAllocationEntry.SetCurrentkey("Source Type", "Source Subtype", "Source ID");
                    ServLaborAllocationEntry.SetRange("Source Type", ServLaborAllocationEntry."source type"::"Service Document");
                    Clear(PrevDocNo);
                end;
            }

            trigger OnAfterGetRecord()
            begin
                ResourceText := StrSubstNo(Text001, "Resource No.");

                Resource.SetRange("No.", "Resource No.");  //06.05.2014 Elva Baltic P8 #R120 MMG7.00

                if not Resource.FindFirst then
                    CurrReport.Skip;

                if PrevResourceNo <> "Resource No." then begin
                    Clear(ResourceValueArray);
                    PrevResourceNo := "Resource No.";
                end;
                ActualTime := "Det. Serv. Ledger Entry EDMS"."Finished Quantity (Hours)";
                // 21.03.2014 Elva Baltic P18 #R120 >>
                PresenceTime := 0;
                if "Det. Serv. Ledger Entry EDMS".GetFilter("Posting Date") <> '' then begin
                    ResWorkTime.Reset;
                    ResWorkTime.SetRange("Resource No.", "Resource No.");
                    ResWorkTime.SetFilter("Worktime Begin", '>=%1', StartDtTm);
                    ResWorkTime.SetFilter("Worktime End", '<=%1', EndDtTm);
                    ResWorkTime.CalcSums("Worked Hours");
                    PresenceTime := ResWorkTime."Worked Hours";
                end;
                // 21.03.2014 Elva Baltic P18 #R120 <<
            end;

            trigger OnPreDataItem()
            begin
                //06.05.2014 Elva Baltic P8 #R120 MMG7.00 >>
                Resource.Reset;
                Resource.FilterGroup(0);
                Resource.CopyFilters(ResourceUserFilter);
                Resource.FilterGroup(2);
                //06.05.2014 Elva Baltic P8 #R120 MMG7.00 <<
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
        }
    }

    labels
    {
        ReportTitleLbl = 'Resource Service Times';
        TotalLbl = 'Total';
        TotalByLbl = 'Total by';
        ResourceNoLbl = 'Resource No.';
        ActualTimeLbl = 'Actual Time';
        PostingDateLbl = 'Posting Date';
        NameSurnameLbl = 'Name, Surname';
        AverageHourlyRateLbl = 'Avg. Hourly Cost';
        ProductibityLbl = 'Productivity';
        TimePresentLbl = 'Time Present';
        LunchTimeLbl = 'Lunch Time';
        InvoicedQuantLbl = 'Invoiced Quantity';
        ProdYearLbl = 'Prod. Year';
        PostDateLbl = 'Post. Date';
        PageLbl = 'Page';
    }

    trigger OnInitReport()
    begin
        HideZeroLines := true;
    end;

    trigger OnPreReport()
    begin
        Clear(ResourceValueArray);
        Clear(TotalValueArray);
        Clear(PrevResourceNo);
        Clear(PrevDocResourceNo);

        // 21.03.2014 Elva Baltic P18 #R120 >>
        if "Det. Serv. Ledger Entry EDMS".GetFilter("Posting Date") <> '' then begin
            StartDate := "Det. Serv. Ledger Entry EDMS".GetRangeMin("Posting Date");
            EndDate := "Det. Serv. Ledger Entry EDMS".GetRangemax("Posting Date");
            StartDtTm := DateTimeMgt.Datetime(StartDate, 0T);
            EndDtTm := DateTimeMgt.Datetime(EndDate, 235959T);
        end;
        // 21.03.2014 Elva Baltic P18 #R120 <<
    end;

    var
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        Resource: Record Resource;
        ResWorkTime: Record "Resource Work Time Entry";
        Vehicle: Record Vehicle;
        DateTimeMgt: Codeunit "Datetime Mgt.";
        ActualTime: Decimal;
        ResourceActualTime: Decimal;
        TotalActualTime: Decimal;
        TimeFactor: Decimal;
        LastFieldNo: Integer;
        FooterPrinted: Boolean;
        ShowDetails: Boolean;
        QuantityTotal: Decimal;
        StandardTimeTotal: Decimal;
        AmountIncludingVATtotal: Decimal;
        AmountLCYTotal: Decimal;
        LineDiscountAmountLCYTotal: Decimal;
        ResourceText: Text[100];
        ResourceValueArray: array[10] of Decimal;
        PrevDocNo: Code[20];
        PrevDocResourceNo: Code[20];
        PrevResourceNo: Code[20];
        TotalValueArray: array[10] of Decimal;
        i: Integer;
        Text001: label 'Total by %1';
        Text002: label 'Total';
        Effectivity: Decimal;
        PresenceTime: Decimal;
        LunchTime: Decimal;
        StartDate: Date;
        EndDate: Date;
        StartDtTm: Decimal;
        EndDtTm: Decimal;
        HideZeroLines: Boolean;
        PrevEntryNo: Integer;
}

