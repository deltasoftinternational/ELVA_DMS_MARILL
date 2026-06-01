Report 25006005 "Service Prepmt. Document Test"
{
    // 08.05.2013 Elva Baltic P15
    //   * adaptation from R212
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ServicePrepmtDocumentTest.rdlc';

    Caption = 'Service Prepmt. Document Test';

    dataset
    {
        dataitem("Service Header EDMS"; "Service Header EDMS")
        {
            DataItemTableView = where("Document Type" = const(Order));
            RequestFilterFields = "No.";
            RequestFilterHeading = 'Prepayment Sales Document';
            column(ReportForNavId_6640; 6640)
            {
            }
            column(DocType_ServiceHeader; "Document Type")
            {
            }
            column(No_ServiceHeader; "No.")
            {
            }
            dataitem(PageCounter; "Integer")
            {
                DataItemTableView = sorting(Number) where(Number = const(1));
                column(ReportForNavId_8098; 8098)
                {
                }
                column(CompanyName; COMPANYNAME)
                {
                }
                column(TodayFormatted; Format(Today, 0, 4))
                {
                }
                column(ServiceHeaderServiceDocFilter; StrSubstNo(Text001, ServiceHeaderFilter))
                {
                }
                column(ServiceHeaderFilter; ServiceHeaderFilter)
                {
                }
                column(PrepmtDocText; PrepmtDocText)
                {
                }
                column(ServiceHdrDocTypeServiceHdrNo; Format("Service Header EDMS"."Document Type") + ' ' + "Service Header EDMS"."No.")
                {
                }
                column(SelltoCustNo_ServiceHeader; "Service Header EDMS"."Sell-to Customer No.")
                {
                }
                column(SellToAddr1; SellToAddr[1])
                {
                }
                column(SellToAddr2; SellToAddr[2])
                {
                }
                column(SellToAddr3; SellToAddr[3])
                {
                }
                column(SellToAddr4; SellToAddr[4])
                {
                }
                column(SellToAddr5; SellToAddr[5])
                {
                }
                column(ShipToAddr5; ShipToAddr[5])
                {
                }
                column(ShipToAddr4; ShipToAddr[4])
                {
                }
                column(ShipToAddr3; ShipToAddr[3])
                {
                }
                column(ShipToAddr2; ShipToAddr[2])
                {
                }
                column(ShipToAddr1; ShipToAddr[1])
                {
                }
                column(ShipToAddr6; ShipToAddr[6])
                {
                }
                column(SellToAddr6; SellToAddr[6])
                {
                }
                column(ShipToAddr7; ShipToAddr[7])
                {
                }
                column(SellToAddr7; SellToAddr[7])
                {
                }
                column(ShipToAddr8; ShipToAddr[8])
                {
                }
                column(SellToAddr8; SellToAddr[8])
                {
                }
                column(ShowDim; ShowDim)
                {
                }
                column(DocumentType; DocumentType)
                {
                }
                column(BillToAddr8; BillToAddr[8])
                {
                }
                column(BillToAddr7; BillToAddr[7])
                {
                }
                column(BillToAddr6; BillToAddr[6])
                {
                }
                column(BillToAddr5; BillToAddr[5])
                {
                }
                column(BillToAddr4; BillToAddr[4])
                {
                }
                column(BillToAddr3; BillToAddr[3])
                {
                }
                column(BillToAddr2; BillToAddr[2])
                {
                }
                column(BillToAddr1; BillToAddr[1])
                {
                }
                column(BilltoCustNo_ServiceHeader; "Service Header EDMS"."Bill-to Customer No.")
                {
                }
                column(ServicePerson_ServiceHeader; "Service Header EDMS"."Service Advisor")
                {
                    IncludeCaption = true;
                }
                column(PricesIncludVAT_ServiceHeader; "Service Header EDMS"."Prices Including VAT")
                {
                }
                column(PostDate_ServiceHeader; Format("Service Header EDMS"."Posting Date"))
                {
                }
                column(DocDate_ServiceHeader; Format("Service Header EDMS"."Document Date"))
                {
                }
                column(ShipmentDate_ServiceHeader; Format("Service Header EDMS"."Shipment Date"))
                {
                }
                column(OrderDate_ServiceHeader; Format("Service Header EDMS"."Order Date"))
                {
                }
                column(PrepmtPmtTermsCode_ServiceHeader; "Service Header EDMS"."Prepmt. Payment Terms Code")
                {
                }
                column(PmtMethodCode_ServiceHeader; "Service Header EDMS"."Payment Method Code")
                {
                }
                column(PrepmtDueDate_ServiceHeader; Format("Service Header EDMS"."Prepayment Due Date"))
                {
                }
                column(PrepmtPmtDiscDate_ServiceHeader; Format("Service Header EDMS"."Prepmt. Pmt. Discount Date"))
                {
                }
                column(PrepmtPmtDisc_ServiceHeader; "Service Header EDMS"."Prepmt. Payment Discount %")
                {
                }
                column(CustPostGroup_ServiceHeader; "Service Header EDMS"."Customer Posting Group")
                {
                }
                column(ServiceHdrPricesIncludingVATFmt; Format("Service Header EDMS"."Prices Including VAT"))
                {
                }
                column(ServicePrepmtDocTestCaption; ServicePrepmtDocTestCaptionLbl)
                {
                }
                column(CurrReportPageNoCaption; CurrReportPageNoCaptionLbl)
                {
                }
                column(SelltoCustNo_ServiceHeaderCaption; "Service Header EDMS".FieldCaption("Sell-to Customer No."))
                {
                }
                column(SelltoCaption; SelltoCaptionLbl)
                {
                }
                column(ShiptoCaption; ShiptoCaptionLbl)
                {
                }
                column(BilltoCaption; BilltoCaptionLbl)
                {
                }
                column(BilltoCustNo_ServiceHeaderCaption; "Service Header EDMS".FieldCaption("Bill-to Customer No."))
                {
                }
                column(ServicepersonCode_ServiceHeaderCaption; "Service Header EDMS"."Service Advisor")
                {
                }
                column(PricesIncludVAT_ServiceHeaderCaption; "Service Header EDMS".FieldCaption("Prices Including VAT"))
                {
                }
                column(PostDate_ServiceHeaderCaption; PostDateServiceHeaderCaptionLbl)
                {
                }
                column(DocDate_ServiceHeaderCaption; DocDateServiceHeaderCaptionLbl)
                {
                }
                column(ShipmentDate_ServiceHeaderCaption; ShipmentDateServiceHeaderCaptionLbl)
                {
                }
                column(OrderDate_ServiceHeaderCaption; OrderDateServiceHeaderCaptionLbl)
                {
                }
                column(PrepmtPmtTermsCode_ServiceHeaderCaption; "Service Header EDMS".FieldCaption("Prepmt. Payment Terms Code"))
                {
                }
                column(PrepmtPmtDisc_ServiceHeaderCaption; "Service Header EDMS".FieldCaption("Prepmt. Payment Discount %"))
                {
                }
                column(PrepmtDueDate_ServiceHeaderCaption; PrepmtDueDateServiceHeaderCaptionLbl)
                {
                }
                column(PrepmtPmtDiscDate_ServiceHeaderCaption; PrepmtPmtDiscDateServiceHeaderCaptionLbl)
                {
                }
                column(PmtMethodCode_ServiceHeaderCaption; "Service Header EDMS".FieldCaption("Payment Method Code"))
                {
                }
                column(CustPostGroup_ServiceHeaderCaption; "Service Header EDMS".FieldCaption("Customer Posting Group"))
                {
                }
                dataitem(HeaderDimLoop; "Integer")
                {
                    DataItemTableView = sorting(Number) where(Number = filter(1 ..));
                    column(ReportForNavId_2562; 2562)
                    {
                    }
                    column(DimText; DimText)
                    {
                    }
                    column(HeaderDimLoop_Number; Number)
                    {
                    }
                    column(Header_DimensionsCaption; HeaderDimensionsCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        if Number = 1 then begin
                            if not DimSetEntry.Find('-') then
                                CurrReport.Break;
                        end else
                            if not Continue then
                                CurrReport.Break;

                        DimText := '';

                        Continue := false;

                        repeat
                            Continue := MergeText(DimSetEntry);
                            if Continue then
                                exit;
                        until DimSetEntry.Next = 0;
                    end;

                    trigger OnPreDataItem()
                    begin
                        if not ShowDim then
                            CurrReport.Break;
                    end;
                }
                dataitem(HeaderErrorCounter; "Integer")
                {
                    DataItemTableView = sorting(Number);
                    column(ReportForNavId_3850; 3850)
                    {
                    }
                    column(ErrorText_HeaderErrorCounter; ErrorText[Number])
                    {
                    }
                    column(ErrorText_HeaderErrorCounterCaption; ErrorTextHeaderErrorCounterCaptionLbl)
                    {
                    }

                    trigger OnPostDataItem()
                    begin
                        ErrorCounter := 0
                    end;

                    trigger OnPreDataItem()
                    begin
                        SetRange(Number, 1, ErrorCounter);
                    end;
                }
                dataitem(CopyLoop; "Integer")
                {
                    DataItemTableView = sorting(Number) where(Number = const(1));
                    column(ReportForNavId_5701; 5701)
                    {
                    }
                    dataitem("Service Line EDMS"; "Service Line EDMS")
                    {
                        DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
                        column(ReportForNavId_2844; 2844)
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            CurrReport.Break;
                        end;
                    }
                    dataitem(ServiceLineLoop; "Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number = filter(1 ..));
                        column(ReportForNavId_2858; 2858)
                        {
                        }
                        column(PrepmtAmtInv_ServiceLine; "Service Line EDMS"."Prepmt. Amt. Inv.")
                        {
                        }
                        column(PrepmtLineAmt_ServiceLine; "Service Line EDMS"."Prepmt. Line Amount")
                        {
                        }
                        column(Prepayment_ServiceLine; "Service Line EDMS"."Prepayment %")
                        {
                        }
                        column(LineAmt_ServiceLine; "Service Line EDMS"."Line Amount")
                        {
                        }
                        column(Quantity_ServiceLine; "Service Line EDMS".Quantity)
                        {
                        }
                        column(Desc_ServiceLine; "Service Line EDMS".Description)
                        {
                        }
                        column(No_ServiceLine; "Service Line EDMS"."No.")
                        {
                        }
                        column(Type_ServiceLine; "Service Line EDMS".Type)
                        {
                        }
                        column(LineNo_ServiceLine; "Service Line EDMS"."Line No.")
                        {
                        }
                        column(PrepmtAmtInv_ServiceLineCaption; "Service Line EDMS".FieldCaption("Prepmt. Amt. Inv."))
                        {
                        }
                        column(PrepmtLineAmt_ServiceLineCaption; "Service Line EDMS".FieldCaption("Prepmt. Line Amount"))
                        {
                        }
                        column(Prepayment_ServiceLineCaption; "Service Line EDMS".FieldCaption("Prepayment %"))
                        {
                        }
                        column(LineAmt_ServiceLineCaption; "Service Line EDMS".FieldCaption("Line Amount"))
                        {
                        }
                        column(Quantity_ServiceLineCaption; "Service Line EDMS".FieldCaption(Quantity))
                        {
                        }
                        column(Desc_ServiceLineCaption; "Service Line EDMS".FieldCaption(Description))
                        {
                        }
                        column(No_ServiceLineCaption; "Service Line EDMS".FieldCaption("No."))
                        {
                        }
                        column(Type_ServiceLineCaption; "Service Line EDMS".FieldCaption(Type))
                        {
                        }
                        dataitem(LineErrorCounter; "Integer")
                        {
                            DataItemTableView = sorting(Number);
                            column(ReportForNavId_2217; 2217)
                            {
                            }
                            column(ErrorText_LineErrorCounter; ErrorText[Number])
                            {
                            }

                            trigger OnPostDataItem()
                            begin
                                ErrorCounter := 0;
                            end;

                            trigger OnPreDataItem()
                            begin
                                SetRange(Number, 1, ErrorCounter);
                            end;
                        }

                        trigger OnAfterGetRecord()
                        var
                            GLAcc: Record "G/L Account";
                            CurrentErrorCount: Integer;
                        begin
                            if Number = 1 then begin
                                if not TempServiceLine.Find('-') then
                                    CurrReport.Break;
                            end else
                                if TempServiceLine.Next = 0 then
                                    CurrReport.Break;
                            "Service Line EDMS" := TempServiceLine;

                            CurrentErrorCount := ErrorCounter;

                            if ("Service Line EDMS"."Gen. Bus. Posting Group" <> GenPostingSetup."Gen. Bus. Posting Group") or
                               ("Service Line EDMS"."Gen. Prod. Posting Group" <> GenPostingSetup."Gen. Prod. Posting Group")
                            then
                                if not GenPostingSetup.Get(
                                     "Service Line EDMS"."Gen. Bus. Posting Group", "Service Line EDMS"."Gen. Prod. Posting Group")
                                then
                                    AddError(
                                      StrSubstNo(
                                        Text006,
                                        GenPostingSetup.TableCaption,
                                        "Service Line EDMS"."Gen. Bus. Posting Group", "Service Line EDMS"."Gen. Prod. Posting Group"));

                            if GenPostingSetup."Service Prepayments Account" = '' then
                                AddError(StrSubstNo(Text005, GenPostingSetup.FieldCaption("Service Prepayments Account")))
                            else begin
                                if GLAcc.Get(GenPostingSetup."Service Prepayments Account") then begin
                                    if GLAcc.Blocked then
                                        AddError(
                                          StrSubstNo(
                                            Text008, GLAcc.FieldCaption(Blocked), false, GLAcc.TableCaption, "Service Line EDMS"."No."));
                                end else
                                    AddError(StrSubstNo(Text007, GLAcc.TableCaption, GenPostingSetup."Service Prepayments Account"));
                            end;

                            if ErrorCounter = CurrentErrorCount then
                                if ServicePostPrepmt.PrepmtAmount("Service Line EDMS", DocumentType) <> 0 then begin
                                    // 08.05.2013 Elva Baltic P15
                                    //ServicePostPrepmt.FillInvLineBuffer("Service Header EDMS","Service Line EDMS",PrepmtInvBuf2);
                                    ServicePostPrepmt.FillInvLineBuffer("Service Header EDMS", "Service Line EDMS", GLAcc, PrepmtInvBuf2);
                                    PrepmtInvBuf.InsertInvLineBuffer(PrepmtInvBuf2);
                                end;
                        end;
                    }

                    trigger OnPreDataItem()
                    var
                        TempServiceLineToDeduct: Record "Service Line EDMS" temporary;
                    begin
                        // 08.05.2013 Elva Baltic P15
                        // Taken from NAV2009
                        TempServiceLine.Reset;
                        TempServiceLine.DeleteAll;

                        Clear(ServicePostPrepmt);
                        VATAmountLine.DeleteAll;
                        ServicePostPrepmt.GetServiceLines("Service Header EDMS", DocumentType, TempServiceLine);
                        ServicePostPrepmt.CalcVATAmountLines("Service Header EDMS", TempServiceLine, VATAmountLine, DocumentType);
                        ServicePostPrepmt.UpdateVATOnLines("Service Header EDMS", TempServiceLine, VATAmountLine, DocumentType);

                        VATAmount := VATAmountLine.GetTotalVATAmount;
                        VATBaseAmount := VATAmountLine.GetTotalVATBase;
                        TotalAmountInclVAT := VATAmountLine.GetTotalAmountInclVAT;

                        /*
                        TempServiceLine.RESET;
                        TempServiceLine.DELETEALL;
                        
                        CLEAR(ServicePostPrepmt);
                        VATAmountLine.DELETEALL;
                        ServicePostPrepmt.GetServiceLines("Service Header EDMS",DocumentType,TempServiceLine);
                        IF DocumentType = DocumentType::Invoice THEN BEGIN
                          ServicePostPrepmt.GetServiceLinesToDeduct("Service Header EDMS",TempServiceLineToDeduct);
                          IF NOT TempServiceLineToDeduct.ISEMPTY THEN
                            ServicePostPrepmt.CalcVATAmountLines("Service Header EDMS",TempServiceLineToDeduct,VATAmountLineDeduct,DocumentType::"Credit Memo");
                        END;
                        ServicePostPrepmt.CalcVATAmountLines("Service Header EDMS",TempServiceLine,VATAmountLine,DocumentType);
                        IF VATAmountLine.FINDSET THEN
                          REPEAT
                            VATAmountLineDeduct := VATAmountLine;
                            IF VATAmountLineDeduct.FIND THEN BEGIN
                              VATAmountLine."VAT Base" := VATAmountLine."VAT Base" - VATAmountLineDeduct."VAT Base";
                              VATAmountLine."VAT Amount" := VATAmountLine."VAT Amount" - VATAmountLineDeduct."VAT Amount";
                              VATAmountLine."Amount Including VAT" := VATAmountLine."Amount Including VAT" - VATAmountLineDeduct."Amount Including VAT";
                              VATAmountLine."Line Amount" := VATAmountLine."Line Amount" - VATAmountLineDeduct."Line Amount";
                              VATAmountLine."Inv. Disc. Base Amount" := VATAmountLine."Inv. Disc. Base Amount" -
                                VATAmountLineDeduct."Inv. Disc. Base Amount";
                              VATAmountLine."Invoice Discount Amount" := VATAmountLine."Invoice Discount Amount" -
                                VATAmountLineDeduct."Invoice Discount Amount";
                              VATAmountLine."Calculated VAT Amount" :=
                                VATAmountLine."Calculated VAT Amount" - VATAmountLineDeduct."Calculated VAT Amount";
                              VATAmountLine.MODIFY;
                            END;
                          UNTIL VATAmountLine.NEXT = 0;
                        ServicePostPrepmt.UpdateVATOnLines("Service Header EDMS",TempServiceLine,VATAmountLine,DocumentType);
                        VATAmount := VATAmountLine.GetTotalVATAmount;
                        VATBaseAmount := VATAmountLine.GetTotalVATBase;
                        TotalAmountInclVAT := VATAmountLine.GetTotalAmountInclVAT;
                        */

                    end;
                }
                dataitem(Blank; "Integer")
                {
                    DataItemTableView = sorting(Number) where(Number = const(1));
                    column(ReportForNavId_9410; 9410)
                    {
                    }
                }
                dataitem(PrepmtLoop; "Integer")
                {
                    DataItemTableView = sorting(Number) where(Number = filter(1 ..));
                    column(ReportForNavId_1849; 1849)
                    {
                    }
                    column(PrepmtInvLineBuffGLAccNo; "Prepayment Inv. Line Buffer"."G/L Account No.")
                    {
                    }
                    column(PrepmtInvLineBuffAmt; "Prepayment Inv. Line Buffer".Amount)
                    {
                    }
                    column(PrepmtInvLineBuffDesc; "Prepayment Inv. Line Buffer".Description)
                    {
                    }
                    column(PrepmtInvLineBuffVATAmt; "Prepayment Inv. Line Buffer"."VAT Amount")
                    {
                    }
                    column(PrepmtInvLineBuffVAT; "Prepayment Inv. Line Buffer"."VAT %")
                    {
                    }
                    column(PrepmtInvLineBuffVATIdentifier; "Prepayment Inv. Line Buffer"."VAT Identifier")
                    {
                    }
                    column(PrepmtLoopNumber; Number)
                    {
                    }
                    column(TotalText; TotalText)
                    {
                    }
                    column(ServiceHeaderCurrCode; "Prepayment Inv. Line Buffer".Amount)
                    {
                        AutoFormatExpression = "Service Header EDMS"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(TotalExclVATText; TotalExclVATText)
                    {
                    }
                    column(VATAmtLineVATAmtText; VATAmountLine.VATAmountText)
                    {
                    }
                    column(TotalInclVATText; TotalInclVATText)
                    {
                    }
                    column(VATAmount; VATAmount)
                    {
                        AutoFormatExpression = "Service Header EDMS"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(PrepmtInvLineBuffAmtVATAmt; "Prepayment Inv. Line Buffer".Amount + VATAmount)
                    {
                        AutoFormatExpression = "Service Header EDMS"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(SumPrepaymInvLineBufferAmount; SumPrepaymInvLineBufferAmount)
                    {
                    }
                    column(VATBaseAmtVATAmt; VATBaseAmount + VATAmount)
                    {
                        AutoFormatExpression = "Service Header EDMS"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(VATBaseAmount; VATBaseAmount)
                    {
                        AutoFormatExpression = "Service Header EDMS"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(PrepmtInvLineBuffGLAccNoCaption; "Prepayment Inv. Line Buffer".FieldCaption("G/L Account No."))
                    {
                    }
                    column(PrepmtInvLineBuffAmtCaption; "Prepayment Inv. Line Buffer".FieldCaption(Amount))
                    {
                    }
                    column(PrepmtInvLineBuffDescCaption; "Prepayment Inv. Line Buffer".FieldCaption(Description))
                    {
                    }
                    column(PrepmtInvLineBuffVATAmtCaption; "Prepayment Inv. Line Buffer".FieldCaption("VAT Amount"))
                    {
                    }
                    column(PrepmtInvLineBuffVATCaption; "Prepayment Inv. Line Buffer".FieldCaption("VAT %"))
                    {
                    }
                    column(PrepmtInvLineBuffVATIdentifierCaption; "Prepayment Inv. Line Buffer".FieldCaption("VAT Identifier"))
                    {
                    }
                    dataitem("Prepayment Inv. Line Buffer"; "Prepayment Inv. Line Buffer")
                    {
                        DataItemTableView = sorting("G/L Account No.", "Dimension Set ID", "Job No.", "Tax Area Code", "Tax Liable", "Tax Group Code", "Invoice Rounding", Adjustment, "Line No.");
                        column(ReportForNavId_4627; 4627)
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            CurrReport.Break;
                        end;
                    }
                    dataitem(LineDimLoop; "Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number = filter(1 ..));
                        column(ReportForNavId_2690; 2690)
                        {
                        }
                        column(DimText_LineDimLoop; DimText)
                        {
                        }
                        column(LineDimLoop_Number; Number)
                        {
                        }
                        column(Line_DimensionsCaption; LineDimensionsCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then begin
                                if not LineDimSetEntry.FindSet then
                                    CurrReport.Break;
                            end else
                                if not Continue then
                                    CurrReport.Break;

                            DimText := '';

                            Continue := false;

                            repeat
                                Continue := MergeText(LineDimSetEntry);
                                if Continue then
                                    exit;
                            until LineDimSetEntry.Next = 0;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if not ShowDim then
                                CurrReport.Break;
                        end;
                    }
                    dataitem(PrepmtErrorCounter; "Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_1979; 1979)
                        {
                        }
                        column(ErrorText_PrepmtErrorCounter; ErrorText[Number])
                        {
                        }

                        trigger OnPostDataItem()
                        begin
                            ErrorCounter := 0;
                        end;

                        trigger OnPreDataItem()
                        begin
                            SetRange(Number, 1, ErrorCounter);
                        end;
                    }

                    trigger OnAfterGetRecord()
                    var
                        TableID: array[10] of Integer;
                        No: array[10] of Code[20];
                    begin
                        if Number = 1 then begin
                            if not PrepmtInvBuf.Find('-') then
                                CurrReport.Break;
                        end else
                            if PrepmtInvBuf.Next = 0 then
                                CurrReport.Break;

                        LineDimSetEntry.SetRange("Dimension Set ID", PrepmtInvBuf."Dimension Set ID");
                        "Prepayment Inv. Line Buffer" := PrepmtInvBuf;

                        if not DimMgt.CheckDimIDComb(PrepmtInvBuf."Dimension Set ID") then
                            AddError(DimMgt.GetDimCombErr);
                        TableID[1] := DimMgt.SalesLineTypeToTableID(TempServiceLine.Type::"G/L Account");
                        No[1] := "Prepayment Inv. Line Buffer"."G/L Account No.";
                        TableID[2] := Database::Job;
                        No[2] := "Prepayment Inv. Line Buffer"."Job No.";
                        if not DimMgt.CheckDimValuePosting(TableID, No, PrepmtInvBuf."Dimension Set ID") then
                            AddError(DimMgt.GetDimValuePostingErr);
                        SumPrepaymInvLineBufferAmount := SumPrepaymInvLineBufferAmount + "Prepayment Inv. Line Buffer".Amount;
                    end;

                    trigger OnPreDataItem()
                    begin
                        CurrReport.CreateTotals("Prepayment Inv. Line Buffer".Amount);
                        SumPrepaymInvLineBufferAmount := 0;
                    end;
                }
                dataitem(VATCounter; "Integer")
                {
                    DataItemTableView = sorting(Number);
                    column(ReportForNavId_6558; 6558)
                    {
                    }
                    column(VATAmtLineVATAmt; VATAmountLine."VAT Amount")
                    {
                        AutoFormatExpression = "Service Header EDMS"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(VATAmtLineVATBase; VATAmountLine."VAT Base")
                    {
                        AutoFormatExpression = "Service Header EDMS"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(VATAmtLineLineAmt; VATAmountLine."Line Amount")
                    {
                        AutoFormatExpression = "Service Header EDMS"."Currency Code";
                        AutoFormatType = 1;
                    }
                    column(VATAmtLineVAT; VATAmountLine."VAT %")
                    {
                        DecimalPlaces = 0 : 5;
                    }
                    column(VATAmtLineVATIdentifier; VATAmountLine."VAT Identifier")
                    {
                    }
                    column(VATAmtLineVATAmtCaption; VATAmtLineVATAmtCaptionLbl)
                    {
                    }
                    column(VATAmtLineVATBaseCaption; VATAmtLineVATBaseCaptionLbl)
                    {
                    }
                    column(VATAmtLineLineAmtCaption; VATAmtLineLineAmtCaptionLbl)
                    {
                    }
                    column(VATAmtLineVATCaption; VATAmtLineVATCaptionLbl)
                    {
                    }
                    column(VATAmtLineVATIdentifierCaption; VATAmtLineVATIdentifierCaptionLbl)
                    {
                    }
                    column(VATAmtSpecificationCaption; VATAmtSpecificationCaptionLbl)
                    {
                    }
                    column(TotalCaption; TotalCaptionLbl)
                    {
                    }

                    trigger OnAfterGetRecord()
                    begin
                        VATAmountLine.GetLine(Number);
                    end;

                    trigger OnPreDataItem()
                    begin
                        if VATAmount = 0 then
                            CurrReport.Break;
                        SetRange(Number, 1, VATAmountLine.Count);
                        CurrReport.CreateTotals(
                          VATAmountLine."VAT Base", VATAmountLine."VAT Amount", VATAmountLine."Amount Including VAT",
                          VATAmountLine."Line Amount", VATAmountLine."Invoice Discount Amount");
                    end;
                }
            }

            trigger OnAfterGetRecord()
            var
                FormatAddr: Codeunit "Format Address";
                FormatAddrEDMS: Codeunit "Service-Post+Print EDMS";
                TableID: array[10] of Integer;
                No: array[10] of Code[20];
            begin
                FormatAddrEDMS.ServiceHeaderSellToEDMS(SellToAddr, "Service Header EDMS");
                FormatAddrEDMS.ServiceHeaderBillToEDMS(BillToAddr, "Service Header EDMS");
                //08.05.2013 Elva Baltic P15
                //FormatAddr.ServiceHeaderShipToEDMS(ShipToAddr,"Service Header EDMS");

                if "Currency Code" = '' then begin
                    GLSetup.TestField("LCY Code");
                    TotalText := StrSubstNo(Text002, GLSetup."LCY Code");
                    TotalExclVATText := StrSubstNo(Text003, GLSetup."LCY Code");
                    TotalInclVATText := StrSubstNo(Text004, GLSetup."LCY Code");
                end else begin
                    TotalText := StrSubstNo(Text002, "Currency Code");
                    TotalExclVATText := StrSubstNo(Text003, "Currency Code");
                    TotalInclVATText := StrSubstNo(Text004, "Currency Code");
                end;

                if "Document Type" <> "document type"::Order then
                    AddError(StrSubstNo(Text000, FieldCaption("Document Type")));

                if not ServicePostPrepmt.CheckOpenPrepaymentLines("Service Header EDMS", DocumentType) then
                    AddError(Text011);

                case DocumentType of
                    Documenttype::Invoice:
                        begin
                            if "Prepayment Due Date" = 0D then
                                AddError(StrSubstNo(Text005, FieldCaption("Prepayment Due Date")));
                            if ("Prepayment No." = '') and ("Prepayment No. Series" = '') then
                                AddError(StrSubstNo(Text005, FieldCaption("Posting No. Series")));
                        end;
                    Documenttype::"Credit Memo":
                        if ("Prepmt. Cr. Memo No." = '') and ("Prepmt. Cr. Memo No. Series" = '') then
                            AddError(StrSubstNo(Text012, FieldCaption("Prepmt. Cr. Memo No.")));
                end;
                if ServiceSetup."Ext. Doc. No. Mandatory" and ("External Document No." = '') then
                    AddError(StrSubstNo(Text005, FieldCaption("External Document No.")));

                CheckCust("Sell-to Customer No.", FieldCaption("Sell-to Customer No."));
                CheckCust("Bill-to Customer No.", FieldCaption("Bill-to Customer No."));

                case true of
                    "Posting Date" = 0D:
                        AddError(StrSubstNo(Text005, FieldCaption("Posting Date")));
                    "Posting Date" <> NormalDate("Posting Date"):
                        AddError(StrSubstNo(Text009, FieldCaption("Posting Date")));
                    GenJnlCheckLine.DateNotAllowed("Posting Date"):
                        AddError(StrSubstNo(Text010, FieldCaption("Posting Date")));
                end;

                DimSetEntry.SetRange("Dimension Set ID", "Dimension Set ID");
                if not DimMgt.CheckDimIDComb("Dimension Set ID") then
                    AddError(DimMgt.GetDimCombErr);

                TableID[1] := Database::Customer;
                No[1] := "Bill-to Customer No.";
                TableID[2] := Database::Job;
                // No[2] := "Job No.";
                TableID[3] := Database::"Salesperson/Purchaser";
                No[3] := "Service Advisor";
                TableID[4] := Database::Campaign;
                No[4] := "Campaign No.";
                TableID[5] := Database::"Responsibility Center";
                No[5] := "Responsibility Center";
                if not DimMgt.CheckDimValuePosting(TableID, No, "Dimension Set ID") then
                    AddError(DimMgt.GetDimValuePostingErr);
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
                group(Options)
                {
                    Caption = 'Options';
                    field(DocumentType; DocumentType)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Prepayment Document Type';
                        OptionCaption = 'Invoice,Credit Memo';
                    }
                    field(ShowDim; ShowDim)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Dimensions';
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
        ErrorTextHeaderLbl = 'Warning!';
    }

    trigger OnPreReport()
    begin
        ServiceHeaderFilter := "Service Header EDMS".GetFilters;

        GLSetup.Get;
        ServiceSetup.Get;    //*

        if DocumentType = Documenttype::Invoice then
            PrepmtDocText := Text013
        else
            PrepmtDocText := Text014;
    end;

    var
        GLSetup: Record "General Ledger Setup";
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        GenPostingSetup: Record "General Posting Setup";
        TempServiceLine: Record "Service Line EDMS" temporary;
        VATAmountLine: Record "VAT Amount Line" temporary;
        VATAmountLineDeduct: Record "VAT Amount Line" temporary;
        PrepmtInvBuf: Record "Prepayment Inv. Line Buffer" temporary;
        PrepmtInvBuf2: Record "Prepayment Inv. Line Buffer" temporary;
        DimSetEntry: Record "Dimension Set Entry";
        LineDimSetEntry: Record "Dimension Set Entry";
        ServicePostPrepmt: Codeunit "Service-Post Prepayments";
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
        DimMgt: Codeunit DimensionManagement;
        ServiceHeaderFilter: Text[250];
        Text000: label '%1 must be Order.';
        Text001: label 'Service Document: %1';
        SellToAddr: array[8] of Text[50];
        BillToAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        PrepmtDocText: Text[50];
        TotalText: Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        Text002: label 'Total %1';
        Text003: label 'Total %1 Excl. VAT';
        Text004: label 'Total %1 Incl. VAT';
        DimText: Text[120];
        ErrorText: array[99] of Text[250];
        DocumentType: Option Invoice,"Credit Memo";
        VATAmount: Decimal;
        VATBaseAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        ErrorCounter: Integer;
        Text005: label '%1 must be specified.';
        Text006: label '%1 %2 %3 does not exist.';
        Text007: label '%1 %2 does not exist.';
        Text008: label '%1 must not be %2 for %3 %4.';
        Text009: label '%1 must not be a closing date.';
        Text010: label '%1 is not within your allowed range of posting dates.';
        Text011: label 'There is nothing to post.';
        ShowDim: Boolean;
        Continue: Boolean;
        Text012: label '%1 must be entered.';
        Text013: label 'Prepayment Invoice';
        Text014: label 'Prepayment Credit Memo';
        SumPrepaymInvLineBufferAmount: Decimal;
        ServicePrepmtDocTestCaptionLbl: label 'Service Prepayment Document - Test';
        CurrReportPageNoCaptionLbl: label 'Page';
        SelltoCaptionLbl: label 'Sell-to';
        ShiptoCaptionLbl: label 'Ship-to';
        BilltoCaptionLbl: label 'Bill-to';
        PostDateServiceHeaderCaptionLbl: label 'Posting Date';
        DocDateServiceHeaderCaptionLbl: label 'Document Date';
        ShipmentDateServiceHeaderCaptionLbl: label 'Shipment Date';
        OrderDateServiceHeaderCaptionLbl: label 'Order Date';
        PrepmtDueDateServiceHeaderCaptionLbl: label 'Prepayment Due Date';
        PrepmtPmtDiscDateServiceHeaderCaptionLbl: label 'Prepmt. Pmt. Discount Date';
        HeaderDimensionsCaptionLbl: label 'Header Dimensions';
        ErrorTextHeaderErrorCounterCaptionLbl: label 'Warning!';
        LineDimensionsCaptionLbl: label 'Line Dimensions';
        VATAmtLineVATAmtCaptionLbl: label 'VAT Amount';
        VATAmtLineVATBaseCaptionLbl: label 'VAT Base';
        VATAmtLineLineAmtCaptionLbl: label 'Line Amount';
        VATAmtLineVATCaptionLbl: label 'VAT %';
        VATAmtLineVATIdentifierCaptionLbl: label 'VAT Identifier';
        VATAmtSpecificationCaptionLbl: label 'VAT Amount Specification';
        TotalCaptionLbl: label 'Total';

    local procedure AddError(Text: Text[250])
    begin
        ErrorCounter := ErrorCounter + 1;
        ErrorText[ErrorCounter] := Text;
    end;

    local procedure CheckCust(CustNo: Code[20]; FieldCaption: Text[30])
    var
        Cust: Record Customer;
    begin
        if CustNo = '' then begin
            AddError(StrSubstNo(Text005, FieldCaption));
            exit;
        end;
        if not Cust.Get(CustNo) then begin
            AddError(StrSubstNo(Text007, Cust.TableCaption, CustNo));
            exit;
        end;
        if Cust.Blocked in [Cust.Blocked::All, Cust.Blocked::Invoice] then
            AddError(
              StrSubstNo(Text008, Cust.FieldCaption(Blocked), Cust.Blocked, Cust.TableCaption, CustNo));
    end;


    procedure MergeText(DimSetEntry: Record "Dimension Set Entry"): Boolean
    begin
        if StrLen(DimText) + StrLen(StrSubstNo('%1 - %2', DimSetEntry."Dimension Code", DimSetEntry."Dimension Value Code")) + 2 >
           MaxStrLen(DimText)
        then
            exit(true);

        if DimText = '' then
            DimText := StrSubstNo('%1 - %2', DimSetEntry."Dimension Code", DimSetEntry."Dimension Value Code")
        else
            DimText :=
              StrSubstNo('%1; %2', DimText, StrSubstNo('%1 - %2', DimSetEntry."Dimension Code", DimSetEntry."Dimension Value Code"));

        exit(false);
    end;
}

