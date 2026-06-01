Report 25006307 "Vehicle Purch. Overview - 1"
{
    // 20.03.2014 Elva Baltic P7 #R005 MMG7.00
    //   * Latvian translation correctet. Docuemnt type - Rēķins
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/VehiclePurchOverview1.rdlc';

    Caption = 'Vehicle Purch. Overview - 1';
    UsageCategory = ReportsAndAnalysis;

    dataset
    {
        dataitem("Purch. Inv. Header"; "Purch. Inv. Header")
        {
            DataItemTableView = sorting("Document Profile") where("Document Profile" = const("Vehicles Trade"));
            RequestFilterFields = "Shortcut Dimension 1 Code";
            column(ReportForNavId_3733; 3733)
            {
            }
            column(FORMAT_TODAY_0_4_; Format(Today, 0, 4))
            {
            }
            column(COMPANYNAME; COMPANYNAME)
            {
            }
            column(HeaderText; HeaderText)
            {
            }
            column(Page_Caption; PageLbl)
            {
            }
            column(PostingDate_Caption; PostingDateLbl)
            {
            }
            column(DocumentType_Caption; DocumentTypeLbl)
            {
            }
            column(DocumentNo_Caption; DocumentNoLbl)
            {
            }
            column(OrderNo_Caption; OrderNoLbl)
            {
            }
            column(Currency_Caption; CurrencyLbl)
            {
            }
            column(AmountExclVAT_Caption; AmountExclVAT)
            {
            }
            column(AmountInclVAT_Caption; AmountInclVAT)
            {
            }
            column(AmountLCYInclVAT_Caption; StrSubstNo(AmountLCYInclVAT, GLSetup."LCY Code"))
            {
            }
            column(AmountLCYExclVAT_Caption; StrSubstNo(AmountLCYExclVAT, GLSetup."LCY Code"))
            {
            }
            column(PayToName_Caption; PayToNameLbl)
            {
            }
            column(Model_Caption; ModelLbl)
            {
            }
            column(Make_Caption; MakeLbl)
            {
            }
            column(VIN_Caption; VINLbl)
            {
            }
            column(EDMS001; StrSubstNo(EDMS001, GLSetup."LCY Code"))
            {
            }
            column(EDMS005; StrSubstNo(EDMS005, GLSetup."LCY Code"))
            {
            }
            column(EDMS006; StrSubstNo(EDMS006, GLSetup."LCY Code"))
            {
            }
            dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.") where("Line Type" = const(Vehicle));
                column(ReportForNavId_5707; 5707)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    recVehicle.Get("Vehicle Serial No.");

                    if "Purch. Inv. Header"."Currency Code" = '' then begin
                        PurchAmount := Amount;
                        PurchAmountVAT := "Amount Including VAT";
                        PurchAmountTotal += PurchAmount;
                        PurchAmountVATTotal += PurchAmountVAT;
                        ReportDataBuffer.SetRange("Code Field 1", GLSetup."LCY Code");
                        if ReportDataBuffer.FindFirst then begin
                            ReportDataBuffer."Decimal Field 1" += "Amount Including VAT";
                            ReportDataBuffer.Modify;
                        end
                        else begin
                            EntryNo += 1;
                            ReportDataBuffer."Entry No." := EntryNo;
                            ReportDataBuffer."Code Field 1" := GLSetup."LCY Code";
                            ReportDataBuffer."Decimal Field 1" := "Amount Including VAT";
                            ReportDataBuffer.Insert;
                        end;
                    end
                    else begin
                        PurchAmount := Amount / "Purch. Inv. Header"."Currency Factor";
                        PurchAmountVAT := "Amount Including VAT" / "Purch. Inv. Header"."Currency Factor";
                        PurchAmountTotal += PurchAmount;
                        PurchAmountVATTotal += PurchAmountVAT;
                        ReportDataBuffer.SetRange("Code Field 1", "Purch. Inv. Header"."Currency Code");
                        if ReportDataBuffer.FindFirst then begin
                            ReportDataBuffer."Decimal Field 1" += "Amount Including VAT";
                            ReportDataBuffer.Modify;
                        end
                        else begin
                            EntryNo += 1;
                            ReportDataBuffer."Entry No." := EntryNo;
                            ReportDataBuffer."Code Field 1" := "Purch. Inv. Header"."Currency Code";
                            ReportDataBuffer."Decimal Field 1" := "Amount Including VAT";
                            ReportDataBuffer.Insert;
                        end;
                    end;

                    EntryNo2 += 1;
                    ReportDataBuffer2.Init;
                    ReportDataBuffer2."Entry No." := EntryNo2;
                    CalcFields(VIN);
                    ReportDataBuffer2."Code Field 1" := VIN;
                    ReportDataBuffer2."Date Field 1" := "Purch. Inv. Header"."Posting Date";
                    ReportDataBuffer2."Text Field 1" := EDMS002;
                    if "Purch. Inv. Header".Correction then
                        ReportDataBuffer2."Text Field 1" += ' ' + EDMS004;
                    ReportDataBuffer2."Text Field 2" := "Document No.";
                    ReportDataBuffer2."Text Field 3" := "Purch. Inv. Header"."Vendor Invoice No.";
                    ReportDataBuffer2."Text Field 4" := "Purch. Inv. Header"."Currency Code";
                    ReportDataBuffer2."Decimal Field 1" := Amount;
                    ReportDataBuffer2."Decimal Field 2" := "Amount Including VAT";
                    ReportDataBuffer2."Decimal Field 3" := PurchAmount;
                    ReportDataBuffer2."Decimal Field 4" := PurchAmountVAT;
                    ReportDataBuffer2."Code Field 2" := "Make Code";
                    if Model.Get("Make Code", "Model Code") then
                        ReportDataBuffer2."Text Field 6" := Model."Commercial Name";
                    ReportDataBuffer2."Text Field 5" := "Purch. Inv. Header"."Pay-to Name";
                    ReportDataBuffer2.Insert;
                end;
            }

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals(PurchAmount, PurchAmountVAT);
                SetRange("Posting Date", datStartingDate, datFinishingDate);
                EntryNo := 0;
            end;
        }
        dataitem("Purch. Cr. Memo Hdr."; "Purch. Cr. Memo Hdr.")
        {
            DataItemTableView = sorting("No.") where("Document Profile" = const("Vehicles Trade"));
            column(ReportForNavId_9869; 9869)
            {
            }
            dataitem("Purch. Cr. Memo Line"; "Purch. Cr. Memo Line")
            {
                DataItemLink = "Document No." = field("No.");
                DataItemTableView = sorting("Document No.", "Line No.") where("Line Type" = const(Vehicle));
                column(ReportForNavId_7507; 7507)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if recVehicle.Get("Vehicle Serial No.") then;

                    if "Purch. Cr. Memo Hdr."."Currency Code" = '' then begin
                        PurchAmount2 := Amount;
                        PurchAmountVAT2 := "Amount Including VAT";
                        PurchAmountTotal2 += PurchAmount2;
                        PurchAmountVATTotal2 += PurchAmountVAT2;
                        ReportDataBuffer.SetRange("Code Field 1", GLSetup."LCY Code");
                        if ReportDataBuffer.FindFirst then begin
                            ReportDataBuffer."Decimal Field 2" += "Amount Including VAT";
                            ReportDataBuffer.Modify;
                        end else begin
                            EntryNo += 1;
                            ReportDataBuffer."Entry No." := EntryNo;
                            ReportDataBuffer."Code Field 1" := GLSetup."LCY Code";
                            ReportDataBuffer."Decimal Field 2" := "Amount Including VAT";
                            ReportDataBuffer.Insert;
                        end;
                    end else begin
                        PurchAmount2 := Amount / "Purch. Cr. Memo Hdr."."Currency Factor";
                        PurchAmountVAT2 := "Amount Including VAT" / "Purch. Cr. Memo Hdr."."Currency Factor";
                        PurchAmountTotal2 += PurchAmount2;
                        PurchAmountVATTotal2 += PurchAmountVAT2;
                        ReportDataBuffer.SetRange("Code Field 1", "Purch. Cr. Memo Hdr."."Currency Code");
                        if ReportDataBuffer.FindFirst then begin
                            ReportDataBuffer."Decimal Field 2" += "Amount Including VAT";
                            ReportDataBuffer.Modify;
                        end else begin
                            EntryNo += 1;
                            ReportDataBuffer."Entry No." := EntryNo;
                            ReportDataBuffer."Code Field 1" := "Purch. Cr. Memo Hdr."."Currency Code";
                            ReportDataBuffer."Decimal Field 2" := "Amount Including VAT";
                            ReportDataBuffer.Insert;
                        end;
                    end;

                    EntryNo2 += 1;
                    ReportDataBuffer2.Init;
                    ReportDataBuffer2."Entry No." := EntryNo2;
                    CalcFields(VIN);
                    ReportDataBuffer2."Code Field 1" := VIN;
                    ReportDataBuffer2."Date Field 1" := "Purch. Cr. Memo Hdr."."Posting Date";
                    ReportDataBuffer2."Text Field 1" := EDMS003;
                    if "Purch. Cr. Memo Hdr.".Correction then
                        ReportDataBuffer2."Text Field 1" += ' ' + EDMS004;
                    ReportDataBuffer2."Text Field 2" := "Document No.";
                    ReportDataBuffer2."Text Field 3" := "Purch. Cr. Memo Hdr."."Vendor Cr. Memo No.";
                    ReportDataBuffer2."Text Field 4" := "Purch. Cr. Memo Hdr."."Currency Code";
                    ReportDataBuffer2."Decimal Field 1" := Amount;
                    ReportDataBuffer2."Decimal Field 2" := "Amount Including VAT";
                    ReportDataBuffer2."Decimal Field 3" := PurchAmount2;
                    ReportDataBuffer2."Decimal Field 4" := PurchAmountVAT2;
                    ReportDataBuffer2."Code Field 2" := "Make Code";
                    if Model.Get("Make Code", "Model Code") then
                        ReportDataBuffer2."Text Field 6" := Model."Commercial Name";
                    ReportDataBuffer2."Text Field 5" := "Purch. Cr. Memo Hdr."."Pay-to Name";
                    ReportDataBuffer2.Insert;
                end;
            }

            trigger OnAfterGetRecord()
            begin
                //ERROR(GETFILTERS);
            end;

            trigger OnPreDataItem()
            begin
                CurrReport.CreateTotals(PurchAmount2, PurchAmountVAT2);
                SetRange("Posting Date", datStartingDate, datFinishingDate);
                SetFilter("Shortcut Dimension 1 Code", "Purch. Inv. Header".GetFilter("Shortcut Dimension 1 Code"));
            end;
        }
        dataitem("Integer"; "Integer")
        {
            DataItemTableView = sorting(Number);
            column(ReportForNavId_5444; 5444)
            {
            }
            column(ReportDataBuffer2__Text_Field_5_; ReportDataBuffer2."Text Field 5")
            {
            }
            column(ReportDataBuffer2__Text_Field_6_; ReportDataBuffer2."Text Field 6")
            {
            }
            column(ReportDataBuffer2__Code_Field_2_; ReportDataBuffer2."Code Field 2")
            {
            }
            column(ReportDataBuffer2__Code_Field_1_; ReportDataBuffer2."Code Field 1")
            {
            }
            column(ReportDataBuffer2__Decimal_Field_4_; ReportDataBuffer2."Decimal Field 4")
            {
            }
            column(ReportDataBuffer2__Decimal_Field_3_; ReportDataBuffer2."Decimal Field 3")
            {
            }
            column(ReportDataBuffer2__Decimal_Field_2_; ReportDataBuffer2."Decimal Field 2")
            {
            }
            column(ReportDataBuffer2__Decimal_Field_1_; ReportDataBuffer2."Decimal Field 1")
            {
            }
            column(ReportDataBuffer2__Text_Field_4_; ReportDataBuffer2."Text Field 4")
            {
            }
            column(ReportDataBuffer2__Text_Field_3_; ReportDataBuffer2."Text Field 3")
            {
            }
            column(ReportDataBuffer2__Text_Field_2_; ReportDataBuffer2."Text Field 2")
            {
            }
            column(ReportDataBuffer2__Date_Field_1_; ReportDataBuffer2."Date Field 1")
            {
            }
            column(ReportDataBuffer2__Text_Field_1_; ReportDataBuffer2."Text Field 1")
            {
            }
            column(Integer_Number; Number)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if Number = 1 then
                    ReportDataBuffer2.FindFirst
                else
                    ReportDataBuffer2.Next;
            end;

            trigger OnPreDataItem()
            begin
                ReportDataBuffer2.Reset;
                ReportDataBuffer2.SetCurrentkey("Date Field 1");
                SetRange(Number, 1, ReportDataBuffer2.Count);

                CurrReport.CreateTotals(ReportDataBuffer2."Decimal Field 3", ReportDataBuffer2."Decimal Field 4");
            end;
        }
        dataitem(TotalsLoop; "Integer")
        {
            DataItemTableView = sorting(Number) order(ascending) where(Number = const(1));
            column(ReportForNavId_31; 31)
            {
            }
            column(PurchAmountVATTotal___PurchAmountVATTotal2; PurchAmountVATTotal - PurchAmountVATTotal2)
            {
            }
            column(PurchAmountTotal___PurchAmountTotal2; PurchAmountTotal - PurchAmountTotal2)
            {
            }
            column(PurchAmountVATTotal; PurchAmountVATTotal)
            {
            }
            column(PurchAmountTotal; PurchAmountTotal)
            {
            }
            column(PurchAmountVATTotal2; PurchAmountVATTotal2)
            {
            }
            column(PurchAmountTotal2; PurchAmountTotal2)
            {
            }

            trigger OnPreDataItem()
            begin
                SetRange(Number, 1);
            end;
        }
        dataitem(TotalsByInvoice; "Integer")
        {
            DataItemTableView = sorting(Number);
            column(ReportForNavId_19; 19)
            {
            }
            column(CurrencyInvoice; ReportDataBuffer."Code Field 1")
            {
            }
            column(AmountInvoice; ReportDataBuffer."Decimal Field 1")
            {
            }

            trigger OnAfterGetRecord()
            begin

                if Number = 1 then
                    ReportDataBuffer.Find('-')
                else
                    ReportDataBuffer.Next;
            end;

            trigger OnPreDataItem()
            begin

                ReportDataBuffer.Reset;
                ReportDataBuffer.SetFilter("Decimal Field 1", '<>0');

                SetRange(Number, 1, ReportDataBuffer.Count);

                if ReportDataBuffer.Count = 0 then
                    CurrReport.Skip;
            end;
        }
        dataitem(TotalsByCreditMemo; "Integer")
        {
            DataItemTableView = sorting(Number);
            column(ReportForNavId_22; 22)
            {
            }
            column(CurrencyCreditMemo; ReportDataBuffer."Code Field 1")
            {
            }
            column(AmountCreditmemo; ReportDataBuffer."Decimal Field 2")
            {
            }

            trigger OnAfterGetRecord()
            begin

                if Number = 1 then
                    ReportDataBuffer.Find('-')
                else
                    ReportDataBuffer.Next;
            end;

            trigger OnPreDataItem()
            begin

                ReportDataBuffer.Reset;
                ReportDataBuffer.SetFilter("Decimal Field 2", '<>0');

                SetRange(Number, 1, ReportDataBuffer.Count);

                if ReportDataBuffer.Count = 0 then
                    CurrReport.Skip;
            end;
        }
        dataitem(TotalsByCurrencies; "Integer")
        {
            DataItemTableView = sorting(Number);
            column(ReportForNavId_25; 25)
            {
            }
            column(CurrencyTotal; ReportDataBuffer."Code Field 1")
            {
            }
            column(AmountTotal; ReportDataBuffer."Decimal Field 1" - ReportDataBuffer."Decimal Field 2")
            {
            }

            trigger OnAfterGetRecord()
            begin

                if Number = 1 then
                    ReportDataBuffer.Find('-')
                else
                    ReportDataBuffer.Next;
            end;

            trigger OnPreDataItem()
            begin

                ReportDataBuffer.Reset;

                if ReportDataBuffer.Count = 0 then
                    CurrReport.Skip;

                SetRange(Number, 1, ReportDataBuffer.Count);
            end;
        }
    }

    requestpage
    {

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
                    field(datFinishingDate; datFinishingDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Date To';
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
        TotalLbl = 'Total';
        TotalByInvLbl = 'Total by Invoice';
        TotalByCrMemoLbl = 'Total by Credit Memo';
    }

    trigger OnPreReport()
    begin
        GLSetup.Get;
    end;

    var
        recVehicle: Record Vehicle;
        ReportDataBuffer: Record "Data Buffer" temporary;
        ReportDataBuffer2: Record "Data Buffer" temporary;
        Model: Record Model;
        GLSetup: Record "General Ledger Setup";
        datFinishingDate: Date;
        datStartingDate: Date;
        EDMS001: label 'Total %1';
        PurchAmount: Decimal;
        PurchAmount2: Decimal;
        PurchAmountTotal: Decimal;
        PurchAmountTotal2: Decimal;
        PurchAmountVAT: Decimal;
        PurchAmountVAT2: Decimal;
        PurchAmountVATTotal: Decimal;
        PurchAmountVATTotal2: Decimal;
        EntryNo: Integer;
        EntryNo2: Integer;
        EDMS002: label 'Invoice';
        EDMS003: label 'Credit Memo';
        EDMS004: label '(Correction)';
        EDMS005: label 'Total by Invoice %1';
        EDMS006: label 'Total by Credit Memo %1';
        HeaderText: label 'Vehicle Purchase Overview - 1';
        PayToNameLbl: label 'Pay-to Name';
        ModelLbl: label 'Model';
        MakeLbl: label 'Make Code';
        VINLbl: label 'VIN';
        AmountLCYInclVAT: label 'Amount %1 Including VAT';
        AmountLCYExclVAT: label 'Amount %1 Excl. VAT';
        AmountInclVAT: label 'Amount Incl. VAT';
        AmountExclVAT: label 'Amount Excl. VAT';
        CurrencyLbl: label 'Currency';
        OrderNoLbl: label 'Vendor Order/Cr.Memo No.';
        DocumentNoLbl: label 'Document No.';
        PostingDateLbl: label 'Posting Date';
        DocumentTypeLbl: label 'Document Type';
        PageLbl: label 'Page';
        ShowInv: Boolean;
        ShowCrMemo: Boolean;
}

