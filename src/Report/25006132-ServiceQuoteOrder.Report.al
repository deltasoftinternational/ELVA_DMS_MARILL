Report 25006132 "Service Quote/Order"
{
    // 04.02.2015 EDMS P11 #T019
    //   Function LogDocument replaced with LogDocumentEDMS
    //   Changed trigger:
    //     Service Header EDMS - OnAfterGetRecord()
    // 
    // 08.04.2013 Elva Baltic P15
    //   * Correction regarding changed ServPostPrepmt.BuildInvLineBuffer(2) function
    // 
    // 21.03.2013 Elva Baltic P15
    //   * Adjustment
    // 
    // 17.10.2012 EDMS P8
    //   * Added request page
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ServiceQuoteOrder.rdl';

    Caption = 'Service Document';

    dataset
    {
        dataitem("Service Header EDMS"; "Service Header EDMS")
        {
            DataItemTableView = sorting("Document Type", "No.") where("Document Type" = const(Order));
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Sales Order';
            column(ReportForNavId_6640; 6640)
            {
            }
            column(DocType_ServHeader; "Service Header EDMS"."Document Type")
            {
            }
            column(No_ServHeader; "Service Header EDMS"."No.")
            {
            }
            column(OrderDate_ServHeaderCaption; "Service Header EDMS".FieldCaption("Order Date"))
            {
            }
            column(OrderDate_ServHeader; Format("Service Header EDMS"."Order Date"))
            {
            }
            column(OrderTime_ServHeader; Format("Service Header EDMS"."Order Time"))
            {
            }
            column(SellToCustomerName_ServHeaderCaption; "Service Header EDMS".FieldCaption("Sell-to Customer Name"))
            {
            }
            column(SellToCustomerName_ServHeader; "Service Header EDMS"."Sell-to Customer Name")
            {
            }
            column(SellToCustomerName2_ServHeader; "Service Header EDMS"."Sell-to Customer Name 2")
            {
            }
            column(SellToContact_ServHeaderCaption; "Service Header EDMS".FieldCaption("Sell-to Contact"))
            {
            }
            column(SellToContact_ServHeader; "Service Header EDMS"."Sell-to Contact")
            {
            }
            column(SellToAddress_ServHeaderCaption; "Service Header EDMS".FieldCaption("Sell-to Address"))
            {
            }
            column(VIN_ServHeaderCaption; "Service Header EDMS".FieldCaption(VIN))
            {
            }
            column(VIN_ServHeader; "Service Header EDMS".VIN)
            {
            }
            column(VehicleRegistrationNo_ServHeaderCaption; "Service Header EDMS".FieldCaption("Vehicle Registration No."))
            {
            }
            column(VehicleRegistrationNo_ServHeader; "Service Header EDMS"."Vehicle Registration No.")
            {
            }
            column(MakeCode_ServHeaderCaption; "Service Header EDMS".FieldCaption("Make Code"))
            {
            }
            column(MakeCode_ServHeader; "Service Header EDMS"."Make Code")
            {
            }
            column(ModelCode_ServHeaderCaption; "Service Header EDMS".FieldCaption("Model Code"))
            {
            }
            column(ModelCode_ServHeader; "Service Header EDMS"."Model Code")
            {
            }
            column(ProductionYear_VehicleCaption; Vehicle.FieldCaption("Production Year"))
            {
            }
            column(ProductionYear_Vehicle; Vehicle."Production Year")
            {
            }
            column(VariableFieldRun1_ServHeaderCaption; "Service Header EDMS".FieldCaption("Variable Field Run 1"))
            {
            }
            column(VariableFieldRun1_ServHeader; "Service Header EDMS"."Variable Field Run 1")
            {
            }
            column(PricesInclVAT_ServHeaderCaption; "Service Header EDMS".FieldCaption("Prices Including VAT"))
            {
            }
            column(PricesInclVAT_ServHeader; "Service Header EDMS"."Prices Including VAT")
            {
            }
            column(PricesInclVATYesNo_ServHeader; Format("Service Header EDMS"."Prices Including VAT"))
            {
            }
            column(ServicePersonNameCaption; ServicePesronNameLbl)
            {
            }
            column(ServicePersonName_SalesPerson; SalesPerson.Name)
            {
            }
            column(ServicePersonSignatureCaption; ServicePersonSignatureLbl)
            {
            }
            column(CustomerNameCaption; CustomerNameLbl)
            {
            }
            column(CustomerSignatureCaption; CustomerSignatureLbl)
            {
            }
            column(InvDiscAmtCaption; InvDiscAmtCaptionLbl)
            {
            }
            column(AmountCaption; AmountCaptionLbl)
            {
            }
            column(VATPercentageCaption; VATPercentageCaptionLbl)
            {
            }
            column(VATBaseCaption; VATBaseCaptionLbl)
            {
            }
            column(VATAmtCaption; VATAmtCaptionLbl)
            {
            }
            column(VATAmtSpecCaption; VATAmtSpecCaptionLbl)
            {
            }
            column(LineAmtCaption; LineAmtCaptionLbl)
            {
            }
            column(TotalCaption; TotalCaptionLbl)
            {
            }
            column(UnitPriceCaption; UnitPriceCaptionLbl)
            {
            }
            column(PaymentTermsCaption; PaymentTermsCaptionLbl)
            {
            }
            column(AllowInvDiscCaption; AllowInvDiscCaptionLbl)
            {
            }
            column(ShipmentMethodCaption; ShipmentMethodCaptionLbl)
            {
            }
            column(DocumentDateCaption; DocumentDateCaptionLbl)
            {
            }
            column(ShowExtraLinesVar; ShowExtraLines)
            {
            }
            column(ShowAmountsVar; ShowAmounts)
            {
            }
            column(ExtraLaborsCaption; ExtraLaborsLbl)
            {
            }
            column(SparePartsCaption; SparePartsLbl)
            {
            }
            column(CustomerSignatureImage; "Customer Signature Image")
            {
            }
            column(CustomerSignatureName; "Customer Signature Text")
            {
            }
            column(EmployeeSignatureImage; "Employee Signature Image")
            {
            }
            column(EmployeeSignatureName; "Employee Signature Text")
            {
            }
            column(WorkDescrLbl; WorkDescrLbl)
            {
            }
            column(WorkDescription; WorkDescription)
            {
            }
            dataitem(CopyLoop; "Integer")
            {
                DataItemTableView = sorting(Number);
                column(ReportForNavId_5701; 5701)
                {
                }
                dataitem(PageLoop; "Integer")
                {
                    DataItemTableView = sorting(Number) where(Number = const(1));
                    column(ReportForNavId_6455; 6455)
                    {
                    }
                    column(CompanyInfo2Picture; CompanyInfo2.Picture)
                    {
                    }
                    column(CompanyInfo3Picture; CompanyInfo3.Picture)
                    {
                    }
                    column(CompanyInfo1Picture; CompanyInfo1.Picture)
                    {
                    }
                    column(ServDocCopyCaptionLbl; ServDocCopyCaptionLbl)
                    {
                    }
                    column(CustAddr1; CustAddr[1])
                    {
                    }
                    column(CompanyAddr1; CompanyAddr[1])
                    {
                    }
                    column(CustAddr2; CustAddr[2])
                    {
                    }
                    column(CompanyAddr2; CompanyAddr[2])
                    {
                    }
                    column(CustAddr3; CustAddr[3])
                    {
                    }
                    column(CompanyAddr3; CompanyAddr[3])
                    {
                    }
                    column(CustAddr4; CustAddr[4])
                    {
                    }
                    column(CompanyAddr4; CompanyAddr[4])
                    {
                    }
                    column(CustAddr5; CustAddr[5])
                    {
                    }
                    column(CompanyInfoPhNo; CompanyInfo."Phone No.")
                    {
                        IncludeCaption = false;
                    }
                    column(CustAddr6; CustAddr[6])
                    {
                    }
                    column(CompanyInfoVATRegNo; CompanyInfo."VAT Registration No.")
                    {
                    }
                    column(CompanyInfoGiroNo; CompanyInfo."Giro No.")
                    {
                    }
                    column(CompanyInfoBankName; CompanyInfo."Bank Name")
                    {
                    }
                    column(CompanyInfoHomePage; CompanyInfo."Home Page")
                    {
                    }
                    column(CompanyInfoEmail; CompanyInfo."E-Mail")
                    {
                    }
                    column(CompanyInfoBankAccNo; CompanyInfo."Bank Account No.")
                    {
                    }
                    column(BilltoCustNo_ServHeader; "Service Header EDMS"."Bill-to Customer No.")
                    {
                    }
                    column(DocDate_ServHeader; Format("Service Header EDMS"."Document Date"))
                    {
                    }
                    column(VATNoText; VATNoText)
                    {
                    }
                    column(VATRegNo_ServHeader; "Service Header EDMS"."VAT Registration No.")
                    {
                    }
                    column(ReferenceText; ReferenceText)
                    {
                    }
                    column(CustAddr7; CustAddr[7])
                    {
                    }
                    column(CustAddr8; CustAddr[8])
                    {
                    }
                    column(CompanyAddr5; CompanyAddr[5])
                    {
                    }
                    column(CompanyAddr6; CompanyAddr[6])
                    {
                    }
                    column(PageCaption; StrSubstNo(Text005, ''))
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(PmntTermsDesc; PaymentTerms.Description)
                    {
                    }
                    column(ShptMethodDesc; ShipmentMethod.Description)
                    {
                    }
                    column(VATRegNoCaption; VATRegNoCaptionLbl)
                    {
                    }
                    column(GiroNoCaption; GiroNoCaptionLbl)
                    {
                    }
                    column(BankCaption; BankCaptionLbl)
                    {
                    }
                    column(AccountNoCaption; AccountNoCaptionLbl)
                    {
                    }
                    column(ShipmentDateCaption; ShipmentDateCaptionLbl)
                    {
                    }
                    column(OrderNoCaption; OrderNoCaptionLbl)
                    {
                    }
                    column(HomePageCaption; HomePageCaptionLbl)
                    {
                    }
                    column(EmailCaption; EmailCaptionLbl)
                    {
                    }
                    column(BilltoCustNo_ServHeaderCaption; "Service Header EDMS".FieldCaption("Bill-to Customer No."))
                    {
                    }
                    dataitem("Service Comment Line EDMS"; "Service Comment Line EDMS")
                    {
                        DataItemLink = "No." = field("No.");
                        DataItemLinkReference = "Service Header EDMS";
                        DataItemTableView = sorting(Type, "No.", "Line No.");
                        column(ReportForNavId_135; 135)
                        {
                        }
                        column(IsCommentLines; IsCommentLines)
                        {
                        }
                        column(CommentCaption; CommentLbl)
                        {
                        }
                        column(Comment_ServCommentLine; "Service Comment Line EDMS".Comment)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            // 21.03.2013 Elva Baltic P15
                            IsCommentLines := true;
                        end;
                    }
                    dataitem("Service Line EDMS"; "Service Line EDMS")
                    {
                        DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                        DataItemLinkReference = "Service Header EDMS";
                        DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
                        column(ReportForNavId_2844; 2844)
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            CurrReport.Break;
                        end;
                    }
                    dataitem(RoundLoop; "Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_7551; 7551)
                        {
                        }
                        column(Desc_ServLine; "Service Line EDMS".Description)
                        {
                        }
                        column(NNCServLineLineAmt; NNCServLineLineAmt)
                        {
                        }
                        column(NNCServLineInvDiscAmt; NNCServLineInvDiscAmt)
                        {
                        }
                        column(NNCTotalLCY; NNCTotalLCY)
                        {
                        }
                        column(NNCTotalExclVAT; NNCTotalExclVAT)
                        {
                        }
                        column(NNCVATAmt; NNCVATAmt)
                        {
                        }
                        column(NNCTotalInclVAT; NNCTotalInclVAT)
                        {
                        }
                        column(NNCPmtDiscOnVAT; NNCPmtDiscOnVAT)
                        {
                        }
                        column(NNCTotalInclVAT2; NNCTotalInclVAT2)
                        {
                        }
                        column(NNCVATAmt2; NNCVATAmt2)
                        {
                        }
                        column(NNCTotalExclVAT2; NNCTotalExclVAT2)
                        {
                        }
                        column(DisplayAssemblyInfo; DisplayAssemblyInformation)
                        {
                        }
                        column(ShowInternalInfo; ShowInternalInfo)
                        {
                        }
                        column(No2_ServLine; "Service Line EDMS"."No.")
                        {
                        }
                        column(Qty_ServLine; "Service Line EDMS".Quantity)
                        {
                        }
                        column(UOM_ServLine; "Service Line EDMS"."Unit of Measure")
                        {
                        }
                        column(UnitPrice_ServLine; "Service Line EDMS"."Unit Price")
                        {
                            AutoFormatExpression = "Service Header EDMS"."Currency Code";
                            AutoFormatType = 2;
                        }
                        column(LineDisc_ServLine; "Service Line EDMS"."Line Discount %")
                        {
                        }
                        column(LineAmt_ServLine; "Service Line EDMS"."Line Amount")
                        {
                            AutoFormatExpression = "Service Header EDMS"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(AllowInvDisc_ServLine; "Service Line EDMS"."Allow Invoice Disc.")
                        {
                        }
                        column(VATIdentifier_ServLine; "Service Line EDMS"."VAT Identifier")
                        {
                        }
                        column(Type_ServLine; Format("Service Line EDMS".Type))
                        {
                        }
                        column(No_ServLine; "Service Line EDMS"."Line No.")
                        {
                        }
                        column(AllowInvDiscountYesNo_ServLine; Format("Service Line EDMS"."Allow Invoice Disc."))
                        {
                        }
                        column(AsmInfoExistsForLine; AsmInfoExistsForLine)
                        {
                        }
                        column(ServLineInvDiscAmt; VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Service Header EDMS"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalText; TotalText)
                        {
                        }
                        column(ServLinAmtExclLineDiscAmt; ServLine."Line Amount" - VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Service Header EDMS"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalExclVATText; TotalExclVATText)
                        {
                        }
                        column(VATAmtLineVATAmtText3; VATAmountLine.VATAmountText)
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
                        column(ServLineAmtExclLineDisc; ServLine."Line Amount" - VATAmountLine."Invoice Discount Amount" + VATAmount)
                        {
                            AutoFormatExpression = "Service Header EDMS"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATDiscountAmount; VATDiscountAmount)
                        {
                            AutoFormatExpression = "Service Header EDMS"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATBaseAmount; VATBaseAmount)
                        {
                            AutoFormatExpression = "Service Header EDMS"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmountInclVAT; TotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Service Header EDMS"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(DiscountPercentCaption; DiscountPercentCaptionLbl)
                        {
                        }
                        column(SubtotalCaption; SubtotalCaptionLbl)
                        {
                        }
                        column(PaymentDiscountVATCaption; PaymentDiscountVATCaptionLbl)
                        {
                        }
                        column(Type_ServLineCaption; "Service Line EDMS".FieldCaption(Type))
                        {
                        }
                        column(Desc_ServLineCaption; "Service Line EDMS".FieldCaption(Description))
                        {
                        }
                        column(No2_ServLineCaption; "Service Line EDMS".FieldCaption("No."))
                        {
                        }
                        column(Qty_ServLineCaption; "Service Line EDMS".FieldCaption(Quantity))
                        {
                        }
                        column(UOM_ServLineCaption; "Service Line EDMS".FieldCaption("Unit of Measure"))
                        {
                        }
                        column(VATIdentifier_ServLineCaption; "Service Line EDMS".FieldCaption("VAT Identifier"))
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin

                            if Number = 1 then
                                ServLine.Find('-')
                            else
                                ServLine.Next;
                            "Service Line EDMS" := ServLine;
                            //* because Assembly isn't used
                            //IF DisplayAssemblyInformation THEN
                            //  AsmInfoExistsForLine := ServLine.AsmToOrderExists(AsmHeader);

                            if not "Service Header EDMS"."Prices Including VAT" and
                               (ServLine."VAT Calculation Type" = ServLine."vat calculation type"::"Full VAT")
                            then
                                ServLine."Line Amount" := 0;

                            if (ServLine.Type = ServLine.Type::"G/L Account") and (not ShowInternalInfo) then
                                "Service Line EDMS"."No." := '';

                            NNCServLineLineAmt += ServLine."Line Amount";
                            NNCServLineInvDiscAmt += ServLine."Inv. Discount Amount";

                            NNCTotalLCY := NNCServLineLineAmt - NNCServLineInvDiscAmt;

                            NNCTotalExclVAT := NNCTotalLCY;
                            NNCVATAmt := VATAmount;
                            NNCTotalInclVAT := NNCTotalLCY - NNCVATAmt;

                            NNCPmtDiscOnVAT := -VATDiscountAmount;

                            NNCTotalInclVAT2 := TotalAmountInclVAT;

                            NNCVATAmt2 := VATAmount;
                            NNCTotalExclVAT2 := VATBaseAmount;
                        end;

                        trigger OnPostDataItem()
                        begin

                            ServLine.DeleteAll;
                        end;

                        trigger OnPreDataItem()
                        begin
                            MoreLines := ServLine.Find('+');
                            while MoreLines and (ServLine.Description = '') and (ServLine."Description 2" = '') and
                                  (ServLine."No." = '') and (ServLine.Quantity = 0) and
                                  (ServLine.Amount = 0)
                            do
                                MoreLines := ServLine.Next(-1) <> 0;
                            if not MoreLines then
                                CurrReport.Break;
                            ServLine.SetRange("Line No.", 0, ServLine."Line No.");
                            SetRange(Number, 1, ServLine.Count);
                            CurrReport.CreateTotals(ServLine."Line Amount", ServLine."Inv. Discount Amount");
                        end;
                    }
                    dataitem(VATCounter; "Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_6558; 6558)
                        {
                        }
                        column(VATAmountLineVATBase; VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Service Header EDMS"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmt; VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Service Header EDMS"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineLineAmt; VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Service Header EDMS"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscBaseAmt; VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Service Header EDMS"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineInvDiscAmt; VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Service Header EDMS"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATPercentage; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATAmtLineVATIdentifier; VATAmountLine."VAT Identifier")
                        {
                        }
                        column(InvDiscBaseAmtCaption; InvDiscBaseAmtCaptionLbl)
                        {
                        }
                        column(VATIdentifierCaption; VATIdentifierCaptionLbl)
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
                              VATAmountLine."Line Amount", VATAmountLine."Inv. Disc. Base Amount",
                              VATAmountLine."Invoice Discount Amount", VATAmountLine."VAT Base", VATAmountLine."VAT Amount");
                        end;
                    }
                    dataitem(VATCounterLCY; "Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_2038; 2038)
                        {
                        }
                        column(VALExchRate; VALExchRate)
                        {
                        }
                        column(VALSpecLCYHeader; VALSpecLCYHeader)
                        {
                        }
                        column(VALVATBaseLCY; VALVATBaseLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VALVATAmountLCY; VALVATAmountLCY)
                        {
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATPercentage2; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATAmtLineVATIdentifier2; VATAmountLine."VAT Identifier")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);

                            VALVATBaseLCY := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                                  "Service Header EDMS"."Posting Date", "Service Header EDMS"."Currency Code",
                                  VATAmountLine."VAT Base", "Service Header EDMS"."Currency Factor"));
                            VALVATAmountLCY := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                                  "Service Header EDMS"."Posting Date", "Service Header EDMS"."Currency Code",
                                  VATAmountLine."VAT Amount", "Service Header EDMS"."Currency Factor"));
                        end;

                        trigger OnPreDataItem()
                        begin
                            if (not GLSetup."Print VAT specification in LCY") or
                               ("Service Header EDMS"."Currency Code" = '') or
                               (VATAmountLine.GetTotalVATAmount = 0)
                            then
                                CurrReport.Break;

                            SetRange(Number, 1, VATAmountLine.Count);
                            CurrReport.CreateTotals(VALVATBaseLCY, VALVATAmountLCY);

                            if GLSetup."LCY Code" = '' then
                                VALSpecLCYHeader := Text007 + Text008
                            else
                                VALSpecLCYHeader := Text007 + Format(GLSetup."LCY Code");

                            CurrExchRate.FindCurrency("Service Header EDMS"."Posting Date", "Service Header EDMS"."Currency Code", 1);
                            VALExchRate := StrSubstNo(Text009, CurrExchRate."Relational Exch. Rate Amount", CurrExchRate."Exchange Rate Amount");
                        end;
                    }
                    dataitem(Total2; "Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number = const(1));
                        column(ReportForNavId_3363; 3363)
                        {
                        }
                        column(SelltoCustNo_ServHeader; "Service Header EDMS"."Sell-to Customer No.")
                        {
                        }
                        column(ShipToAddr8; ShipToAddr[8])
                        {
                        }
                        column(ShipToAddr7; ShipToAddr[7])
                        {
                        }
                        column(ShipToAddr6; ShipToAddr[6])
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
                        column(ShiptoAddrCaption; ShiptoAddrCaptionLbl)
                        {
                        }
                        column(SelltoCustNo_ServHeaderCaption; "Service Header EDMS".FieldCaption("Sell-to Customer No."))
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            if not ShowShippingAddr then
                                CurrReport.Break;
                        end;
                    }
                    dataitem(PrepmtLoop; "Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number = filter(1 ..));
                        column(ReportForNavId_1849; 1849)
                        {
                        }
                        column(PrepmtLineAmount; PrepmtLineAmount)
                        {
                            AutoFormatExpression = "Service Header EDMS"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtInvBufDesc; PrepmtInvBuf.Description)
                        {
                        }
                        column(PrepmtInvBufGLAccNo; PrepmtInvBuf."G/L Account No.")
                        {
                        }
                        column(TotalExclVATText2; TotalExclVATText)
                        {
                        }
                        column(PrepmtVATAmtLineVATAmtTxt; PrepmtVATAmountLine.VATAmountText)
                        {
                        }
                        column(TotalInclVATText2; TotalInclVATText)
                        {
                        }
                        column(PrepmtInvAmount; PrepmtInvBuf.Amount)
                        {
                            AutoFormatExpression = "Service Header EDMS"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtVATAmount; PrepmtVATAmount)
                        {
                            AutoFormatExpression = "Service Header EDMS"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtInvAmtInclVATAmt; PrepmtInvBuf.Amount + PrepmtVATAmount)
                        {
                            AutoFormatExpression = "Service Header EDMS"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmtText2; VATAmountLine.VATAmountText)
                        {
                        }
                        column(PrepmtTotalAmountInclVAT; PrepmtTotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Service Header EDMS"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtVATBaseAmount; PrepmtVATBaseAmount)
                        {
                            AutoFormatExpression = "Service Header EDMS"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtLoopNumber; Number)
                        {
                        }
                        column(DescriptionCaption; DescriptionCaptionLbl)
                        {
                        }
                        column(GLAccountNoCaption; GLAccountNoCaptionLbl)
                        {
                        }
                        column(PrepaymentSpecCaption; PrepaymentSpecCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then begin
                                if not PrepmtInvBuf.Find('-') then
                                    CurrReport.Break;
                            end else
                                if PrepmtInvBuf.Next = 0 then
                                    CurrReport.Break;

                            if ShowInternalInfo then
                                DimMgt.GetDimensionSet(TempPrepmtDimSetEntry, PrepmtInvBuf."Dimension Set ID");

                            if "Service Header EDMS"."Prices Including VAT" then
                                PrepmtLineAmount := PrepmtInvBuf."Amount Incl. VAT"
                            else
                                PrepmtLineAmount := PrepmtInvBuf.Amount;
                        end;

                        trigger OnPreDataItem()
                        begin
                            CurrReport.CreateTotals(
                              PrepmtInvBuf.Amount, PrepmtInvBuf."Amount Incl. VAT",
                              PrepmtVATAmountLine."Line Amount", PrepmtVATAmountLine."VAT Base",
                              PrepmtVATAmountLine."VAT Amount",
                              PrepmtLineAmount);
                        end;
                    }
                    dataitem(PrepmtVATCounter; "Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_3388; 3388)
                        {
                        }
                        column(PrepmtVATAmtLineVATAmt; PrepmtVATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Service Header EDMS"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtVATAmtLineVATBase; PrepmtVATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Service Header EDMS"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtVATAmtLineLineAmt; PrepmtVATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Service Header EDMS"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(PrepmtVATAmtLineVATPerc; PrepmtVATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(PrepmtVATAmtLineVATIdent; PrepmtVATAmountLine."VAT Identifier")
                        {
                        }
                        column(PrepmtVATCounterNumber; Number)
                        {
                        }
                        column(PrepaymentVATAmtSpecCap; PrepaymentVATAmtSpecCapLbl)
                        {
                        }
                        column(ExtraLaborsLbl; ExtraLaborsLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            PrepmtVATAmountLine.GetLine(Number);
                        end;

                        trigger OnPreDataItem()
                        begin
                            SetRange(Number, 1, PrepmtVATAmountLine.Count);
                        end;
                    }
                    dataitem(PrepmtTotal; "Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number = const(1));
                        column(ReportForNavId_7808; 7808)
                        {
                        }
                        column(PrepmtPmtTermsDesc; PrepmtPaymentTerms.Description)
                        {
                        }
                        column(PrepmtPmtTermsDescCaption; PrepmtPmtTermsDescCaptionLbl)
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            if not PrepmtInvBuf.Find('-') then
                                CurrReport.Break;
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                var
                    PrepmtServLine: Record "Service Line EDMS" temporary;
                    ServPost: Codeunit "Service-Post EDMS";
                    TempServLine: Record "Service Line EDMS" temporary;
                    TempServLineDisc: Record "Service Line EDMS" temporary;
                    SalesSetup: Record "Sales & Receivables Setup";
                begin
                    Clear(ServLine);
                    Clear(ServPost);
                    Clear(TempServLineDisc);
                    VATAmountLine.DeleteAll;
                    ServLine.DeleteAll;
                    TempServLineDisc.DeleteAll;
                    ServPost.GetServiceLines("Service Header EDMS", ServLine, 0);
                    ServLine.CalcVATAmountLines(0, "Service Header EDMS", ServLine, VATAmountLine);
                    ServLine.UpdateVATOnLines(0, "Service Header EDMS", ServLine, VATAmountLine);
                    ServPost.GetServiceLines("Service Header EDMS", TempServLineDisc, 1);
                    TempServLineDisc.CalcVATAmountLines(1, "Service Header EDMS", TempServLineDisc, VATAmountLine);
                    TempServLineDisc.UpdateVATOnLines(1, "Service Header EDMS", TempServLineDisc, VATAmountLine);
                    ServLine."Inv. Discount Amount" := VATAmountLine."Invoice Discount Amount";
                    VATAmount := VATAmountLine.GetTotalVATAmount;
                    VATBaseAmount := VATAmountLine.GetTotalVATBase;
                    VATDiscountAmount :=
                      VATAmountLine.GetTotalVATDiscount("Service Header EDMS"."Currency Code", "Service Header EDMS"."Prices Including VAT");
                    TotalAmountInclVAT := VATAmountLine.GetTotalAmountInclVAT;

                    PrepmtInvBuf.DeleteAll;
                    ServPostPrepmt.GetServiceLines("Service Header EDMS", 0, PrepmtServLine);

                    /** for a further investigation
                    IF NOT PrepmtServLine.ISEMPTY THEN BEGIN
                      ServPostPrepmt.GetServiceLinesToDeduct("Service Header EDMS",TempServLine);
                      IF NOT TempServLine.ISEMPTY THEN
                        ServPostPrepmt.CalcVATAmountLines("Service Header EDMS",TempServLine,PrepmtVATAmountLineDeduct,1);
                    END;
                    */
                    ServPostPrepmt.CalcVATAmountLines("Service Header EDMS", PrepmtServLine, PrepmtVATAmountLine, 0);
                    if PrepmtVATAmountLine.FindSet then
                        repeat
                            PrepmtVATAmountLineDeduct := PrepmtVATAmountLine;
                            if PrepmtVATAmountLineDeduct.Find then begin
                                PrepmtVATAmountLine."VAT Base" := PrepmtVATAmountLine."VAT Base" - PrepmtVATAmountLineDeduct."VAT Base";
                                PrepmtVATAmountLine."VAT Amount" := PrepmtVATAmountLine."VAT Amount" - PrepmtVATAmountLineDeduct."VAT Amount";
                                PrepmtVATAmountLine."Amount Including VAT" := PrepmtVATAmountLine."Amount Including VAT" -
                                  PrepmtVATAmountLineDeduct."Amount Including VAT";
                                PrepmtVATAmountLine."Line Amount" := PrepmtVATAmountLine."Line Amount" - PrepmtVATAmountLineDeduct."Line Amount";
                                PrepmtVATAmountLine."Inv. Disc. Base Amount" := PrepmtVATAmountLine."Inv. Disc. Base Amount" -
                                  PrepmtVATAmountLineDeduct."Inv. Disc. Base Amount";
                                PrepmtVATAmountLine."Invoice Discount Amount" := PrepmtVATAmountLine."Invoice Discount Amount" -
                                  PrepmtVATAmountLineDeduct."Invoice Discount Amount";
                                PrepmtVATAmountLine."Calculated VAT Amount" := PrepmtVATAmountLine."Calculated VAT Amount" -
                                  PrepmtVATAmountLineDeduct."Calculated VAT Amount";
                                PrepmtVATAmountLine.Modify;
                            end;
                        until PrepmtVATAmountLine.Next = 0;

                    ServPostPrepmt.UpdateVATOnLines("Service Header EDMS", PrepmtServLine, PrepmtVATAmountLine, 0);
                    //08.04.2013 Elva Baltic P15 >>
                    SalesSetup.Get;
                    ServPostPrepmt.BuildInvLineBuffer("Service Header EDMS", PrepmtServLine, 0, PrepmtInvBuf, SalesSetup."Invoice Rounding");
                    //08.04.2013 Elva Baltic P15 <<
                    PrepmtVATAmount := PrepmtVATAmountLine.GetTotalVATAmount;
                    PrepmtVATBaseAmount := PrepmtVATAmountLine.GetTotalVATBase;
                    PrepmtTotalAmountInclVAT := PrepmtVATAmountLine.GetTotalAmountInclVAT;

                    if Number > 1 then begin
                        CopyText := Text003;
                        OutputNo += 1;
                    end;
                    CurrReport.PageNo := 1;

                    NNCTotalLCY := 0;
                    NNCTotalExclVAT := 0;
                    NNCVATAmt := 0;
                    NNCTotalInclVAT := 0;
                    NNCPmtDiscOnVAT := 0;
                    NNCTotalInclVAT2 := 0;
                    NNCVATAmt2 := 0;
                    NNCTotalExclVAT2 := 0;
                    NNCServLineLineAmt := 0;
                    NNCServLineInvDiscAmt := 0;

                end;

                trigger OnPostDataItem()
                begin
                    if Print then;
                end;

                trigger OnPreDataItem()
                begin
                    NoOfLoops := Abs(NoOfCopies) + 1;
                    CopyText := '';
                    SetRange(Number, 1, NoOfLoops);
                    OutputNo := 1;
                end;
            }

            trigger OnAfterGetRecord()
            var
                FormatAddrEDMS: Codeunit "Service-Post+Print EDMS";
                DocumentManagementDMS: Codeunit DocumentManagementDMS;
                Lang: Codeunit Language;
            begin
                CompanyInfo.Get;
                //CurrReport.Language := Language.GetLanguageID("Language Code");

                if RespCenter.Get("Responsibility Center") then begin
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                end else
                    FormatAddr.Company(CompanyAddr, CompanyInfo);

                DimSetEntry1.SetRange("Dimension Set ID", "Dimension Set ID");

                /**
                IF "Salesperson Code" = '' THEN BEGIN
                  CLEAR(SalesPurchPerson);
                  SalesPersonText := '';
                END ELSE BEGIN
                  SalesPurchPerson.GET("Salesperson Code");
                  SalesPersonText := Text000;
                END;
                IF "Your Reference" = '' THEN
                  ReferenceText := ''
                ELSE
                  ReferenceText := FIELDCAPTION("Your Reference");
                **/

                if "VAT Registration No." = '' then
                    VATNoText := ''
                else
                    VATNoText := FieldCaption("VAT Registration No.");
                if "Currency Code" = '' then begin
                    GLSetup.TestField("LCY Code");
                    TotalText := StrSubstNo(Text001, GLSetup."LCY Code");
                    TotalInclVATText := StrSubstNo(Text002, GLSetup."LCY Code");
                    TotalExclVATText := StrSubstNo(Text006, GLSetup."LCY Code");
                end else begin
                    TotalText := StrSubstNo(Text001, "Currency Code");
                    TotalInclVATText := StrSubstNo(Text002, "Currency Code");
                    TotalExclVATText := StrSubstNo(Text006, "Currency Code");
                end;
                FormatAddrEDMS.ServiceHeaderSellToEDMS(CustAddr, "Service Header EDMS");


                if "Payment Terms Code" = '' then
                    PaymentTerms.Init
                else begin
                    PaymentTerms.Get("Payment Terms Code");
                    PaymentTerms.TranslateDescription(PaymentTerms, "Language Code");
                end;
                if "Prepmt. Payment Terms Code" = '' then
                    PrepmtPaymentTerms.Init
                else begin
                    PrepmtPaymentTerms.Get("Prepmt. Payment Terms Code");
                    PrepmtPaymentTerms.TranslateDescription(PrepmtPaymentTerms, "Language Code");
                end;
                if "Prepmt. Payment Terms Code" = '' then
                    PrepmtPaymentTerms.Init
                else begin
                    PrepmtPaymentTerms.Get("Prepmt. Payment Terms Code");
                    PrepmtPaymentTerms.TranslateDescription(PrepmtPaymentTerms, "Language Code");
                end;

                //FormatAddr.ServiceOrderShipTo(ShipToAddr,"Service Header EDMS");
                LogInteraction := false;
                ShowShippingAddr := "Sell-to Customer No." <> "Bill-to Customer No.";
                for i := 1 to ArrayLen(ShipToAddr) do
                    if ShipToAddr[i] <> CustAddr[i] then
                        ShowShippingAddr := true;

                if Print then begin
                    if ArchiveDocument then
                        DocumentManagementDMS.StoreServiceDocument("Service Header EDMS", LogInteraction);

                    if LogInteraction then begin
                        CalcFields("No. of Archived Versions");
                        //*P15
                        if "Bill-to Contact No." <> '' then
                            DocumentManagementDMS.LogDocumentEDMS( // 04.02.2015 EDMS P11 #T019
                              4, "No.", "Doc. No. Occurrence",
                              "No. of Archived Versions", Database::Contact, "Bill-to Contact No.",
                              "Service Advisor", "Campaign No.", "Posting Description", '', "Vehicle Serial No.")
                        else
                            DocumentManagementDMS.LogDocumentEDMS( // 04.02.2015 EDMS P11 #T019
                              4, "No.", "Doc. No. Occurrence",
                              "No. of Archived Versions", Database::Customer, "Bill-to Customer No.",
                              "Service Advisor", "Campaign No.", "Posting Description", '', "Vehicle Serial No.");
                    end;
                end;

                //21.03.2013 Elva Baltic P15 >>
                if "Document Type" = "document type"::Quote then
                    ServDocCopyCaptionLbl := EDMS_ServQuote
                else
                    ServDocCopyCaptionLbl := EDMS_ServOrder;

                if ProformaInvoice then
                    ServDocCopyCaptionLbl := EDMS_ServInvoice;

                if not Vehicle.Get("Service Header EDMS"."Vehicle Serial No.") then
                    Clear(Vehicle);

                if not SalesPerson.Get("Service Header EDMS"."Service Advisor") then
                    Clear(SalesPerson);

                //21.03.2013 Elva Baltic P15 <<

                WorkDescription := GetWorkDescription();

            end;

            trigger OnPreDataItem()
            begin
                Print := Print or not CurrReport.Preview;
                AsmInfoExistsForLine := false;
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
                    field(NoOfCopies; NoOfCopies)
                    {
                        ApplicationArea = Basic;
                        Caption = 'No. of Copies';
                    }
                    field("Print Extra Lines"; ShowExtraLines)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Print Extra Lines';
                    }
                    field("Show Amount"; ShowAmounts)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Amount';
                    }
                    field(ArchiveDocument; ArchiveDocument)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Archive Document';

                        trigger OnValidate()
                        begin
                            if not ArchiveDocument then
                                LogInteraction := false;
                        end;
                    }
                    field(LogInteraction; LogInteraction)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Log Interaction';
                        Enabled = LogInteractionEnable;

                        trigger OnValidate()
                        begin
                            if LogInteraction then
                                ArchiveDocument := ArchiveDocumentEnable;
                        end;
                    }
                    field(ProformaInvoice; ProformaInvoice)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Print Proforma Invoice';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            ArchiveDocument := ServSetup."Archive Quotes and Orders";
            //LogInteraction := SegManagement.FindInteractTmplCode(3) <> '';
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        GLSetup.Get;

        ServSetup.Get;
        /*//*
        CASE ServSetup."Logo Position on Documents" OF
          ServSetup."Logo Position on Documents"::"No Logo":
            ;
          ServSetup."Logo Position on Documents"::Left:
            BEGIN
              CompanyInfo3.GET;
              CompanyInfo3.CALCFIELDS(Picture);
            END;
          ServSetup."Logo Position on Documents"::Center:
            BEGIN
              CompanyInfo1.GET;
              CompanyInfo1.CALCFIELDS(Picture);
            END;
          ServSetup."Logo Position on Documents"::Right:
            BEGIN
              CompanyInfo2.GET;
              CompanyInfo2.CALCFIELDS(Picture);
            END;
        END;
        //**/

    end;

    var
        EDMS_ServQuote: label 'Service Quote No.';
        EDMS_ServOrder: label 'Service Order No.';
        EDMS_ServInvoice: label 'Invoice No.';
        ProformaInvoice: Boolean;
        Text000: label 'Salesperson';
        Text001: label 'Total %1';
        Text002: label 'Total %1 Incl. VAT';
        Text003: label 'COPY';
        Text004: label 'Service Order %1';
        Text005: label 'Page %1';
        Text006: label 'Total %1 Excl. VAT';
        GLSetup: Record "General Ledger Setup";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        PrepmtPaymentTerms: Record "Payment Terms";
        SalesPurchPsaleslierson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        ServSetup: Record "Service Mgt. Setup EDMS";
        VATAmountLine: Record "VAT Amount Line" temporary;
        PrepmtVATAmountLine: Record "VAT Amount Line" temporary;
        PrepmtVATAmountLineDeduct: Record "VAT Amount Line" temporary;
        ServLine: Record "Service Line EDMS" temporary;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        TempPrepmtDimSetEntry: Record "Dimension Set Entry" temporary;
        PrepmtInvBuf: Record "Prepayment Inv. Line Buffer" temporary;
        RespCenter: Record "Responsibility Center";
        CurrExchRate: Record "Currency Exchange Rate";
        AsmHeader: Record "Assembly Header";
        AsmLine: Record "Assembly Line";
        Vehicle: Record Vehicle;
        SalesPerson: Record "Salesperson/Purchaser";
        ServCountPrinted: Codeunit "Service-Printed";
        FormatAddr: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        ArchiveManagement: Codeunit ArchiveManagement;
        ServPostPrepmt: Codeunit "Service-Post Prepayments";
        DimMgt: Codeunit DimensionManagement;
        CustAddr: array[8] of Text[50];
        ShipToAddr: array[8] of Text[50];
        CompanyAddr: array[8] of Text[50];
        SalesPersonText: Text[30];
        VATNoText: Text[80];
        ReferenceText: Text[80];
        TotalText: Text[50];
        TotalExclVATText: Text[50];
        TotalInclVATText: Text[50];
        MoreLines: Boolean;
        NoOfCopies: Integer;
        NoOfLoops: Integer;
        CopyText: Text[30];
        ShowShippingAddr: Boolean;
        i: Integer;
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        ArchiveDocument: Boolean;
        LogInteraction: Boolean;
        IsHeader: Boolean;
        ShowExtraLines: Boolean;
        ShowAmounts: Boolean;
        VATAmount: Decimal;
        VATBaseAmount: Decimal;
        VATDiscountAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        Text007: label 'VAT Amount Specification in ';
        Text008: label 'Local Currency';
        Text009: label 'Exchange rate: %1/%2';
        VALExchRate: Text[50];
        PrepmtVATAmount: Decimal;
        PrepmtVATBaseAmount: Decimal;
        PrepmtTotalAmountInclVAT: Decimal;
        PrepmtLineAmount: Decimal;
        OutputNo: Integer;
        NNCTotalLCY: Decimal;
        NNCTotalExclVAT: Decimal;
        NNCVATAmt: Decimal;
        NNCTotalInclVAT: Decimal;
        NNCPmtDiscOnVAT: Decimal;
        NNCTotalInclVAT2: Decimal;
        NNCVATAmt2: Decimal;
        NNCTotalExclVAT2: Decimal;
        NNCServLineLineAmt: Decimal;
        NNCServLineInvDiscAmt: Decimal;
        Print: Boolean;
        [InDataSet]
        ArchiveDocumentEnable: Boolean;
        [InDataSet]
        LogInteractionEnable: Boolean;
        DisplayAssemblyInformation: Boolean;
        AsmInfoExistsForLine: Boolean;
        InvDiscAmtCaptionLbl: label 'Order Discount Amount';
        VATRegNoCaptionLbl: label 'VAT Registration No.';
        GiroNoCaptionLbl: label 'Giro No.';
        BankCaptionLbl: label 'Bank';
        AccountNoCaptionLbl: label 'Account No.';
        ShipmentDateCaptionLbl: label 'Shipment Date';
        OrderNoCaptionLbl: label 'Order No.';
        HomePageCaptionLbl: label 'Home Page';
        EmailCaptionLbl: label 'E-Mail';
        HeaderDimCaptionLbl: label 'Header Dimensions';
        DiscountPercentCaptionLbl: label 'Discount %';
        SubtotalCaptionLbl: label 'Subtotal';
        PaymentDiscountVATCaptionLbl: label 'Payment Discount on VAT';
        LineDimCaptionLbl: label 'Line Dimensions';
        InvDiscBaseAmtCaptionLbl: label 'Invoice Discount Base Amount';
        VATIdentifierCaptionLbl: label 'VAT Identifier';
        ShiptoAddrCaptionLbl: label 'Ship-to Address';
        DescriptionCaptionLbl: label 'Description';
        GLAccountNoCaptionLbl: label 'G/L Account No.';
        PrepaymentSpecCaptionLbl: label 'Prepayment Specification';
        PrepaymentVATAmtSpecCapLbl: label 'Prepayment VAT Amount Specification';
        PrepmtPmtTermsDescCaptionLbl: label 'Prepmt. Payment Terms';
        PhoneNoCaptionLbl: label 'Phone No.';
        AmountCaptionLbl: label 'Amount';
        VATPercentageCaptionLbl: label 'VAT %';
        VATBaseCaptionLbl: label 'VAT Base';
        VATAmtCaptionLbl: label 'VAT Amount';
        VATAmtSpecCaptionLbl: label 'VAT Amount Specification';
        LineAmtCaptionLbl: label 'Line Amount';
        TotalCaptionLbl: label 'Total';
        UnitPriceCaptionLbl: label 'Unit Price';
        PaymentTermsCaptionLbl: label 'Payment Terms';
        ShipmentMethodCaptionLbl: label 'Shipment Method';
        DocumentDateCaptionLbl: label 'Document Date';
        AllowInvDiscCaptionLbl: label 'Allow Invoice Discount';
        "--Adjustment--": Integer;
        ServDocCopyCaptionLbl: Text[100];
        ExtraLaborsLbl: label 'Extra Labors';
        SparePartsLbl: label 'Extra Spare Parts & Materials';
        ServicePesronNameLbl: label 'Service Person Name, Surname';
        ServicePersonSignatureLbl: label 'Service Person Signature';
        CustomerNameLbl: label 'Customer Name, Surname';
        CustomerSignatureLbl: label 'Customer Person Signature';
        CommentLbl: label 'Comment';
        WorkDescrLbl: label 'Work Description';
        IsCommentLines: Boolean;
        WorkDescription: Text;



    procedure InitializeRequest(NoOfCopiesFrom: Integer; ShowInternalInfoFrom: Boolean; ArchiveDocumentFrom: Boolean; LogInteractionFrom: Boolean; PrintFrom: Boolean; DisplayAsmInfo: Boolean)
    begin
        NoOfCopies := NoOfCopiesFrom;
        ShowInternalInfo := ShowInternalInfoFrom;
        ArchiveDocument := ArchiveDocumentFrom;
        //FIXME 11.06.2021 RC KN Temporary fix
        //LogInteraction := LogInteractionFrom;
        LogInteraction := False;
        Print := PrintFrom;
        DisplayAssemblyInformation := DisplayAsmInfo;
    end;


    procedure GetUnitOfMeasureDescr(UOMCode: Code[10]): Text[10]
    var
        UnitOfMeasure: Record "Unit of Measure";
    begin
        if not UnitOfMeasure.Get(UOMCode) then
            exit(UOMCode);
        exit(UnitOfMeasure.Description);
    end;


    procedure BlanksForIndent(): Text[10]
    begin
        exit(PadStr('', 2, ' '));
    end;
}

