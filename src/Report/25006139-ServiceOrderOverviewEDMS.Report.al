Report 25006139 "Service Order Overview EDMS"
{
    // 11.02.2014 Elva Baltic P7 #R117 MMG7.00
    //   * Missing columns added
    //   * Missing filter functionality added to request form
    // 
    // 27.03.2013 Elva Baltic P15
    //   * Created (adapted from NAV2009)
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ServiceOrderOverviewEDMS.rdl';

    Caption = 'Service Order Overview (Unposted)';
    ProcessingOnly = false;
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Service Header EDMS"; "Service Header EDMS")
        {
            RequestFilterFields = "Order Date", "Payment Method Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code";
            column(ReportForNavId_1; 1)
            {
            }
            dataitem("Service Line EDMS"; "Service Line EDMS")
            {
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
                column(ReportForNavId_2; 2)
                {
                }

                trigger OnAfterGetRecord()
                var
                    ReservEntry: Record "Reservation Entry";
                    ReservEntry2: Record "Reservation Entry";
                    Item: Record Item;
                    ReservedQty: Decimal;
                    ReservedCost: Decimal;
                begin

                    if Type = Type::Labor then begin
                        ReportDataBuffer."Decimal Field 3" += "Line Amount";

                    end else begin
                        if Type = Type::Item then
                            ReportDataBuffer."Decimal Field 4" += "Line Amount"
                        else
                            ReportDataBuffer."Decimal Field 5" += "Line Amount";
                    end;
                    if Type = Type::Item then begin
                        ReservedQty := 0;
                        ReservedCost := 0;
                        ReservEntry.Reset;
                        ReservEntry.SetCurrentkey("Source ID", "Source Ref. No.");
                        ReservEntry.SetRange("Source ID", "Document No.");
                        ReservEntry.SetRange("Source Ref. No.", "Line No.");
                        ReservEntry.SetRange("Source Type", Database::"Service Line EDMS");
                        ReservEntry.SetRange("Source Subtype", "Document Type");
                        if ReservEntry.FindFirst then
                            repeat
                                if ReservEntry2.Get(ReservEntry."Entry No.", not ReservEntry.Positive) then begin
                                    if ReservEntry2."Source Type" = Database::"Item Ledger Entry" then begin
                                        if ItemLedgEntry.Get(ReservEntry2."Source Ref. No.") then begin
                                            ReservedQty += ReservEntry2."Quantity (Base)";
                                            ItemLedgEntry.CalcFields("Cost Amount (Actual)");
                                            ReservedCost += ItemLedgEntry."Cost Amount (Actual)" / ItemLedgEntry.Quantity * ReservEntry2."Quantity (Base)";
                                        end;
                                    end;
                                end;
                            until ReservEntry.Next = 0;
                        if ReservedQty < Quantity then begin
                            if Item.Get("No.") then begin
                                ReservedCost += Item."Unit Cost" * (Quantity - ReservedQty);
                            end;
                        end;
                        ReportDataBuffer."Decimal Field 6" += ReservedCost;
                    end;

                    if "Service Header EDMS"."Prices Including VAT" then begin
                        ReportDataBuffer."Decimal Field 1" += "Line Amount" * (1 - "VAT %" / 100);
                        ReportDataBuffer."Decimal Field 2" += "Line Amount";
                    end else begin
                        ReportDataBuffer."Decimal Field 1" += "Line Amount";
                        ReportDataBuffer."Decimal Field 2" += "Line Amount" * (1 + "VAT %" / 100);
                    end;
                end;

                trigger OnPostDataItem()
                begin
                    ReportDataBuffer.Insert;
                end;
            }

            trigger OnAfterGetRecord()
            var
                IsStarted: Boolean;
            begin
                "Service Line EDMS".Reset;
                "Service Line EDMS".SetRange("Document Type", "Document Type");
                "Service Line EDMS".SetRange("Document No.", "No.");

                if ShowStarted or ShowNotStarted then begin
                    IsStarted := false;
                    "Service Line EDMS".SetRange(Type, "Service Line EDMS".Type::"External Service");
                    if "Service Line EDMS".FindFirst then begin
                        IsStarted := true;
                    end;

                    if not IsStarted then begin
                        "Service Line EDMS".SetRange(Type);
                        if "Service Line EDMS".FindFirst then begin
                            repeat
                                if "Service Line EDMS".GetResourceTextFieldValue <> '' then begin
                                    IsStarted := true;
                                end;
                            until ("Service Line EDMS".Next = 0) or IsStarted;
                        end;
                    end;

                    if not IsStarted then begin
                        "Service Line EDMS".SetRange(Type);
                        if "Service Line EDMS".FindFirst then
                            repeat
                                if "Service Line EDMS".CalcTransferedQuantity > 0 then begin
                                    IsStarted := true;
                                end;
                            until ("Service Line EDMS".Next = 0) or IsStarted;
                    end;

                    if IsStarted then begin
                        if not ShowStarted then
                            CurrReport.Skip;
                    end else begin
                        if not ShowNotStarted then
                            CurrReport.Skip;
                    end;

                end;


                EntryNo += 1;
                ReportDataBuffer.Init;
                ReportDataBuffer."Entry No." := EntryNo;
                ReportDataBuffer."Code Field 1" := "Payment Method Code";
                ReportDataBuffer."Text Field 1" := Format("Document Type");
                ReportDataBuffer."Text Field 2" := "No.";
                ReportDataBuffer."Date Field 1" := "Order Date";
                ReportDataBuffer."Text Field 3" := "Sell-to Customer No.";
                ReportDataBuffer."Text Field 4" := "Sell-to Customer Name";
                ReportDataBuffer."Text Field 5" := "Bill-to Customer No.";
                ReportDataBuffer."Text Field 6" := "Bill-to Name";
                ReportDataBuffer."Text Field 7" := "Currency Code";
                CalcFields("Model Commercial Name");
                ReportDataBuffer."Text Field 8" := "Model Commercial Name";
                ReportDataBuffer."Text Field 9" := "Service Advisor";
            end;

            trigger OnPreDataItem()
            begin
                ReportDataBuffer.DeleteAll; //for debugging (in case of Not Temp Table - Data Buffer)

                FilterTxt := GetFilters;
                EntryNo := 0;
            end;
        }
        dataitem(ReportDataBuffer; "Data Buffer")
        {
            UseTemporary = true;
            //DataItemTableView = sorting(Number);
            column(ReportForNavId_3; 3)
            {
            }
            column(PaymentMethodCode_ServiceHeaderCaption; "Service Header EDMS".FieldCaption("Payment Method Code"))
            {
            }
            column(No_ServiceHeaderCaption; "Service Header EDMS".FieldCaption("No."))
            {
            }
            column(OrderDate_ServiceHeaderCaption; "Service Header EDMS".FieldCaption("Order Date"))
            {
            }
            column(SelltoCustomerNo_ServiceHeaderCaption; "Service Header EDMS".FieldCaption("Sell-to Customer No."))
            {
            }
            column(SelltoCustomerName_ServiceHeaderCaption; "Service Header EDMS".FieldCaption("Sell-to Customer Name"))
            {
            }
            column(BilltoCustomerNo_ServiceHeaderCaption; "Service Header EDMS".FieldCaption("Bill-to Customer No."))
            {
            }
            column(BilltoName_ServiceHeaderCaption; "Service Header EDMS".FieldCaption("Bill-to Name"))
            {
            }
            column(CurrencyCode_ServiceHeaderCaption; "Service Header EDMS".FieldCaption("Currency Code"))
            {
            }
            column(LaborAmountCaption; LaborAmountLbl)
            {
            }
            column(SparePartsAmountCaption; SparePartsAmountLbl)
            {
            }
            column(SparePartsCostAmountCaption; SparePartsCostAmountLbl)
            {
            }
            column(OtherAmountCaption; OtherAmountLbl)
            {
            }
            column(AmountExclVATCaption; AmountExclVATLbl)
            {
            }
            column(AmountInclVATCaption; AmountInclVATLbl)
            {
            }
            column(FalseVar; FalseVar)
            {
            }
            column(PaymentMethodCode_RDB; ReportDataBuffer."Code Field 1")
            {
            }
            column(No_RDB; ReportDataBuffer."Text Field 2")
            {
            }
            column(OrderDate_RDB; Format(ReportDataBuffer."Date Field 1"))
            {
            }
            column(SellToCustNo_RDB; ReportDataBuffer."Text Field 3")
            {
            }
            column(SellToCusName_RDB; ReportDataBuffer."Text Field 4")
            {
            }
            column(BillToCust_RDB; ReportDataBuffer."Text Field 5")
            {
            }
            column(BillToCustName_RDB; ReportDataBuffer."Text Field 6")
            {
            }
            column(Curency_RDB; ReportDataBuffer."Text Field 7")
            {
            }
            column(LaborAmount_RDB; ReportDataBuffer."Decimal Field 3")
            {
            }
            column(SparePartsAmount_RDB; ReportDataBuffer."Decimal Field 4")
            {
            }
            column(SparePartsCostAmount_RDB; ReportDataBuffer."Decimal Field 6")
            {
            }
            column(OtherAmount_RDB; ReportDataBuffer."Decimal Field 5")
            {
            }
            column(AmountExclVAT_RDB; ReportDataBuffer."Decimal Field 1")
            {
            }
            column(AmountInclVAT_RDB; ReportDataBuffer."Decimal Field 2")
            {
            }
            column(TotalCaption; TotalLbl)
            {
            }
            column(ComercialNameCaption; "Service Header EDMS".FieldCaption("Model Commercial Name"))
            {
            }
            column(ComercialName; ReportDataBuffer."Text Field 8")
            {
            }
            column(ServicePersonCaption; "Service Header EDMS".FieldCaption("Service Advisor"))
            {
            }
            column(ServicePerson; ReportDataBuffer."Text Field 9")
            {
            }

            column(EntryNo; ReportDataBuffer."Entry No.")
            {
            }

            //trigger OnAfterGetRecord()
            //begin

            //    if Number = 1 then
            //        ReportDataBuffer.FindFirst
            //    else
            //        ReportDataBuffer.Next;
            //   ShowPaymentMethod := false;
            /*
            PaymentCode := ReportDataBuffer."Code Field 1";
            IF PaymentCode <> PaymentCode2 THEN
             BEGIN
               PaymentCode3 := PaymentCode2;
               PaymentCode2 := PaymentCode;
             END;
            
            
            PaymentMethod1 := ReportDataBuffer."Code Field 1";
            IF PaymentMethod1 <> PaymentMethod2 THEN
             BEGIN
              ShowPaymentMethod := TRUE;
              PaymentMethod2 := PaymentMethod1;
             END;
            
            IF ShowPaymentMethod THEN
             BEGIN
              TotalAmount := TotalAmount2;
              TotalAmountVAT := TotalAmountVAT2;
              TotalLabor := TotalLabor2;
              TotalSparePart := TotalSparePart2;
              TotalOther := TotalOther2;
              TotalSpareCost := TotalSpareCost2;
              TotalAmount2 := ReportDataBuffer."Decimal Field 1";
              TotalAmountVAT2 := ReportDataBuffer."Decimal Field 2";
              TotalLabor2 := ReportDataBuffer."Decimal Field 3";
              TotalSparePart2 := ReportDataBuffer."Decimal Field 4";
              TotalOther2 := ReportDataBuffer."Decimal Field 5";
              TotalSpareCost2 := ReportDataBuffer."Decimal Field 6";
             END
            ELSE
             BEGIN
              TotalAmount2 += ReportDataBuffer."Decimal Field 1";
              TotalAmountVAT2 += ReportDataBuffer."Decimal Field 2";
              TotalLabor2 += ReportDataBuffer."Decimal Field 3";
              TotalSparePart2 += ReportDataBuffer."Decimal Field 4";
              TotalOther2 += ReportDataBuffer."Decimal Field 5";
              TotalSpareCost2 += ReportDataBuffer."Decimal Field 6";
             END;
            */

            // end;

            //trigger OnPreDataItem()
            //begin

            //    ReportDataBuffer.Reset;
            //*CurrReport.CREATETOTALS(ReportDataBuffer."Decimal Field 1", ReportDataBuffer."Decimal Field 2",ReportDataBuffer."Decimal Field 3",
            //*                        ReportDataBuffer."Decimal Field 4", ReportDataBuffer."Decimal Field 5",ReportDataBuffer."Decimal Field 6");

            //* ReportDataBuffer.SETCURRENTKEY("Code Field 1");    //?

            //*PaymentMethod2 := 'to be different';

            //    SetRange(Number, 1, ReportDataBuffer.Count);
            // end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(ShowStarted; ShowStarted)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Started';
                }
                field(ShowNotStarted; ShowNotStarted)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Not Started';
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        ReportTitleLbl = 'Service Order Overview (Unposted)';

    }

    var
        //ReportDataBuffer: Record "Data Buffer" temporary;
        ItemLedgEntry: Record "Item Ledger Entry";
        PaymentCode: Code[20];
        PaymentCode2: Code[20];
        PaymentCode3: Code[20];
        PaymentMethod1: Code[20];
        PaymentMethod2: Code[20];
        FilterTxt: Text[250];
        TotalAmount: Decimal;
        TotalAmount2: Decimal;
        TotalAmountVAT: Decimal;
        TotalAmountVAT2: Decimal;
        TotalLabor: Decimal;
        TotalLabor2: Decimal;
        TotalSparePart: Decimal;
        TotalSparePart2: Decimal;
        TotalOther: Decimal;
        TotalOther2: Decimal;
        TotalSpareCost: Decimal;
        TotalSpareCost2: Decimal;
        LineAmount: Decimal;
        EntryNo: Integer;
        ShowPaymentMethod: Boolean;
        EDMS001: label 'Total by %1:';
        DocumentTypeLbl: label 'Document type';
        DocumentNoLbl: label 'Document No.';
        PostingDateLbl: label 'Posting Date';
        SellToCustNoLbl: label 'Sell-to Customer No.';
        SellToCustNameLbl: label 'Sell-to Customer Name';
        BillToCustNoLbl: label 'Bill-to Customer No.';
        BillToCustNameLbl: label 'Bill-to Customer Name';
        CurrencyLbl: label 'Currency';
        LaborAmountLbl: label 'Labor Amount';
        SparePartsAmountLbl: label 'Spare Part Amount';
        SparePartsCostAmountLbl: label 'Spare Part Cost Amount';
        OtherAmountLbl: label 'Other Amount';
        AmountExclVATLbl: label 'Amount Excl. VAT';
        AmountInclVATLbl: label 'Amount Incl. VAT';
        FalseVar: Boolean;
        TotalLbl: label 'Total';
        ShowStarted: Boolean;
        ShowNotStarted: Boolean;
}

