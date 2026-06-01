Report 25006315 "Sales - Quote Vehicle EDMS"
{
    // 04.02.2015 EDMS P11 #T019
    //   Function LogDocument replaced with LogDocumentEDMS
    //   Changed trigger:
    //     Sales Header - OnAfterGetRecord()
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/SalesQuoteVehicleEDMS.rdl';

    Caption = 'Sales - Quote Vehicle';

    dataset
    {
        dataitem("Sales Header"; "Sales Header")
        {
            DataItemTableView = sorting("Document Type", "No.");
            RequestFilterFields = "No.", "Sell-to Customer No.", "No. Printed";
            RequestFilterHeading = 'Sales Document';
            column(ReportForNavId_6640; 6640)
            {
            }
            column(DocType_SalesHeader; "Document Type")
            {
            }
            column(No_SalesHeader; "No.")
            {
            }
            column(SalesLineVATIdentifierCaption; SalesLineVATIdentifierCaptionLbl)
            {
            }
            column(PaymentTermsDescriptionCaption; PaymentTermsDescriptionCaptionLbl)
            {
            }
            column(ShipmentMethodDescriptionCaption; ShipmentMethodDescriptionCaptionLbl)
            {
            }
            column(CompanyInfoHomePageCaption; CompanyInfoHomePageCaptionLbl)
            {
            }
            column(CompanyInfoEmailCaption; CompanyInfoEmailCaptionLbl)
            {
            }
            column(DocumentDateCaption; DocumentDateCaptionLbl)
            {
            }
            column(SalesLineAllowInvoiceDiscCaption; SalesLineAllowInvoiceDiscCaptionLbl)
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
                    column(PaymentTermsDescription; PaymentTerms.Description)
                    {
                    }
                    column(ShipmentMethodDescription; ShipmentMethod.Description)
                    {
                    }
                    column(CompanyInfo3Picture; CompanyInfo3.Picture)
                    {
                    }
                    column(CompanyInfo1Picture; CompanyInfo1.Picture)
                    {
                    }
                    column(SalesCopyText; StrSubstNo(DocNameTxt, CopyText))
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
                    column(CompanyInfoEmail; CompanyInfo."E-Mail")
                    {
                    }
                    column(CompanyInfoHomePage; CompanyInfo."Home Page")
                    {
                    }
                    column(CompanyInfoPhoneNo; CompanyInfo."Phone No.")
                    {
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
                    column(CompanyInfoBankAccountNo; CompanyInfo."Bank Account No.")
                    {
                    }
                    column(BilltoCustNo_SalesHeader; "Sales Header"."Bill-to Customer No.")
                    {
                    }
                    column(DocDate_SalesHeader; Format("Sales Header"."Document Date", 0, 4))
                    {
                    }
                    column(VATNoText; VATNoText)
                    {
                    }
                    column(VATRegNo_SalesHeader; "Sales Header"."VAT Registration No.")
                    {
                    }
                    column(ShipmentDate_SalesHeader; Format("Sales Header"."Shipment Date"))
                    {
                    }
                    column(SalesPersonText; SalesPersonText)
                    {
                    }
                    column(SalesPurchPersonName; SalesPurchPerson.Name)
                    {
                    }
                    column(No1_SalesHeader; "Sales Header"."No.")
                    {
                    }
                    column(ReferenceText; ReferenceText)
                    {
                    }
                    column(YourReference_SalesHeader; "Sales Header"."Your Reference")
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
                    column(PricesIncludingVAT_SalesHdr; "Sales Header"."Prices Including VAT")
                    {
                    }
                    column(PageCaption; StrSubstNo(Text005, ''))
                    {
                    }
                    column(OutputNo; OutputNo)
                    {
                    }
                    column(PricesInclVATYesNo_SalesHdr; Format("Sales Header"."Prices Including VAT"))
                    {
                    }
                    column(CompanyInfoPhoneNoCaption; CompanyInfoPhoneNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoVATRegNoCaption; CompanyInfoVATRegNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoGiroNoCaption; CompanyInfoGiroNoCaptionLbl)
                    {
                    }
                    column(CompanyInfoBankNameCaption; CompanyInfoBankNameCaptionLbl)
                    {
                    }
                    column(CompanyInfoBankAccountNoCaption; CompanyInfoBankAccountNoCaptionLbl)
                    {
                    }
                    column(SalesHeaderShipmentDateCaption; SalesHeaderShipmentDateCaptionLbl)
                    {
                    }
                    column(SalesHeaderNoCaption; SalesHeaderNoCaptionLbl)
                    {
                    }
                    column(BilltoCustNo_SalesHeaderCaption; "Sales Header".FieldCaption("Bill-to Customer No."))
                    {
                    }
                    column(PricesIncludingVAT_SalesHdrCaption; "Sales Header".FieldCaption("Prices Including VAT"))
                    {
                    }
                    dataitem(DimensionLoop1; "Integer")
                    {
                        DataItemLinkReference = "Sales Header";
                        DataItemTableView = sorting(Number) where(Number = filter(1 ..));
                        column(ReportForNavId_7574; 7574)
                        {
                        }
                        column(DimText; DimText)
                        {
                        }
                        column(HeaderDimensionsCaption; HeaderDimensionsCaptionLbl)
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            if Number = 1 then begin
                                if not DimSetEntry1.FindSet then
                                    CurrReport.Break;
                            end else
                                if not Continue then
                                    CurrReport.Break;

                            Clear(DimText);
                            Continue := false;
                            repeat
                                OldDimText := DimText;
                                if DimText = '' then
                                    DimText := StrSubstNo('%1 %2', DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code")
                                else
                                    DimText :=
                                      StrSubstNo(
                                        '%1, %2 %3', DimText, DimSetEntry1."Dimension Code", DimSetEntry1."Dimension Value Code");
                                if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                    DimText := OldDimText;
                                    Continue := true;
                                    exit;
                                end;
                            until DimSetEntry1.Next = 0;
                        end;

                        trigger OnPreDataItem()
                        begin
                            if not ShowInternalInfo then
                                CurrReport.Break;
                        end;
                    }
                    dataitem("Sales Line"; "Sales Line")
                    {
                        DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                        DataItemLinkReference = "Sales Header";
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
                        column(MakeCode_SalesLine; "Sales Line"."Make Code")
                        {
                            IncludeCaption = true;
                        }
                        column(ModelCode_SalesLine; "Sales Line"."Model Code")
                        {
                            IncludeCaption = true;
                        }
                        column(VIN_SalesLine; "Sales Line".VIN)
                        {
                            IncludeCaption = true;
                        }
                        column(LineAmt_SalesLine; SalesLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(No_SalesLine; "Sales Line"."No.")
                        {
                        }
                        column(Desc_SalesLine; "Sales Line".Description)
                        {
                        }
                        column(Quantity_SalesLine; "Sales Line".Quantity)
                        {
                        }
                        column(UnitofMeasure_SalesLine; "Sales Line"."Unit of Measure")
                        {
                        }
                        column(LineAmt1_SalesLine; "Sales Line"."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(UnitPrice_SalesLine; "Sales Line"."Unit Price")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 2;
                        }
                        column(LineDiscount_SalesLine; "Sales Line"."Line Discount %")
                        {
                        }
                        column(AllowInvoiceDisc_SalesLine; "Sales Line"."Allow Invoice Disc.")
                        {
                            IncludeCaption = false;
                        }
                        column(VATIdentifier_SalesLine; "Sales Line"."VAT Identifier")
                        {
                        }
                        column(Type_SalesLine; Format("Sales Line".Type))
                        {
                        }
                        column(No1_SalesLine; "Sales Line"."Line No.")
                        {
                        }
                        column(AllowInvoiceDisYesNo; Format("Sales Line"."Allow Invoice Disc."))
                        {
                        }
                        column(InvDiscountAmount_SalesLine; -SalesLine."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalText; TotalText)
                        {
                        }
                        column(DiscountAmt_SalesLine; SalesLine."Line Amount" - SalesLine."Inv. Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmtLineVATAmtTxt; VATAmountLine.VATAmountText)
                        {
                        }
                        column(TotalExclVATText; TotalExclVATText)
                        {
                        }
                        column(TotalInclVATText; TotalInclVATText)
                        {
                        }
                        column(VATAmount; VATAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATDiscountAmount; -VATDiscountAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(TotalAmountInclVAT; TotalAmountInclVAT)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATBaseAmount; VATBaseAmount)
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(UnitPriceCaption; UnitPriceCaptionLbl)
                        {
                        }
                        column(SalesLineLineDiscCaption; SalesLineLineDiscCaptionLbl)
                        {
                        }
                        column(AmountCaption; AmountCaptionLbl)
                        {
                        }
                        column(SalesLineInvDiscAmtCaption; SalesLineInvDiscAmtCaptionLbl)
                        {
                        }
                        column(SubtotalCaption; SubtotalCaptionLbl)
                        {
                        }
                        column(VATDiscountAmountCaption; VATDiscountAmountCaptionLbl)
                        {
                        }
                        column(No_SalesLineCaption; "Sales Line".FieldCaption("No."))
                        {
                        }
                        column(Desc_SalesLineCaption; "Sales Line".FieldCaption(Description))
                        {
                        }
                        column(Quantity_SalesLineCaption; "Sales Line".FieldCaption(Quantity))
                        {
                        }
                        column(UnitofMeasure_SalesLineCaption; "Sales Line".FieldCaption("Unit of Measure"))
                        {
                        }
                        dataitem(PictureTbl; Picture)
                        {
                            DataItemLinkReference = "Sales Line";
                            column(ReportForNavId_100; 100)
                            {
                            }
                            column(No_Picture; PictureTbl."No.")
                            {
                            }
                            column(SourcePicture_Picture; PictureTbl.Blob)
                            {
                            }

                            trigger OnPreDataItem()
                            begin
                                if ShowPicture = Showpicture::No then
                                    CurrReport.Break;

                                Clear(PictureTbl);

                                case ShowPicture of
                                    Showpicture::"Model Version":
                                        begin
                                            PictureTbl.SetRange("Source Type", 27);
                                            PictureTbl.SetRange("Source Subtype", 2);  // Model Version
                                            PictureTbl.SetRange("Source ID", SalesLine."No.");
                                            PictureTbl.SetRange("Source Ref. No.", 0); // Not used
                                        end;
                                    Showpicture::Vehicle:
                                        begin
                                            PictureTbl.SetRange("Source Type", Database::Vehicle);
                                            PictureTbl.SetRange("Source Subtype", 0);  // Not used
                                            PictureTbl.SetRange("Source ID", SalesLine."Vehicle Serial No.");
                                            PictureTbl.SetRange("Source Ref. No.", 0); // Not used
                                        end;

                                    else
                                        ;
                                end;
                                PictureTbl.SetRange(Imported, true);
                                PictureTbl.SetRange(Default, true);

                                if PictureTbl.FindFirst then
                                    PictureTbl.CalcFields(Blob);
                            end;
                        }
                        dataitem(VehicleAssembly_Standard; "Vehicle Assembly Line")
                        {
                            DataItemLink = "Serial No." = field("Vehicle Serial No."), "Assembly ID" = field("Vehicle Assembly ID");
                            DataItemLinkReference = "Sales Line";
                            DataItemTableView = sorting("Serial No.", "Assembly ID", "Line No.") order(ascending) where("Option Type" = filter("Manufacturer Option" | "Own Option"), Standard = const(true));
                            column(ReportForNavId_152; 152)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin

                                i += 1;
                                if VehAssembly2."Option Code" <> PrevStdOpt then
                                    VehAssembly2.Next
                                else
                                    PrevStdOpt := '';

                                if StdCount2 < i then begin
                                    VehAssembly2."Option Code" := '';
                                    VehAssembly2.Description := '';
                                end;

                                if VehAssembly2."Option Code" <> '' then
                                    VehAssembly2.Description := VehOptionMgt.GetOptionText(VehAssembly2, "Sales Header"."Language Code");

                                if i > StdCount then
                                    CurrReport.Break;

                                Description := VehOptionMgt.GetOptionText(VehicleAssembly_Standard, "Sales Header"."Language Code");

                                VehicleAssemblyLineTmp.TransferFields(VehicleAssembly_Standard);
                                VehicleAssemblyLineTmp."Campaign No." := 'STANDARD'; // COPYSTR(StandardAssembliesLbl,1,20); //C 20
                                VehicleAssemblyLineTmp."Model Version No." := VehAssembly2."Option Code"; //C 20 - "Option Code 2"
                                VehicleAssemblyLineTmp."Description 2" := VehAssembly2.Description; //T 250 - "Description2"

                                VehicleAssemblyLineTmp.Insert;
                            end;

                            trigger OnPreDataItem()
                            begin
                                VehicleAssemblyLineTmp.DeleteAll;

                                VehAssembly2.Reset;
                                VehAssembly2.Copy(VehicleAssembly_Standard);

                                StdCount := ROUND(VehAssembly2.Count / 2, 1, '>');
                                StdCount2 := VehAssembly2.Count - StdCount;

                                i := 0;
                                VehAssembly2.ClearMarks;
                                if VehAssembly2.FindSet then
                                    repeat
                                        i += 1;
                                        if i > StdCount then
                                            VehAssembly2.Mark := true;
                                    until VehAssembly2.Next = 0;

                                VehAssembly2.MarkedOnly(true);
                                if VehAssembly2.Find('-') then
                                    PrevStdOpt := VehAssembly2."Option Code";

                                i := 0;
                            end;
                        }
                        dataitem(VehicleAssembly_Color; "Vehicle Assembly Line")
                        {
                            DataItemLink = "Serial No." = field("Vehicle Serial No."), "Assembly ID" = field("Vehicle Assembly ID");
                            DataItemLinkReference = "Sales Line";
                            DataItemTableView = sorting("Option Type", "Option Subtype", "Option Code") order(ascending) where("Option Type" = filter("Manufacturer Option" | "Own Option"), Standard = const(false), "Option Subtype" = const(Color));
                            column(ReportForNavId_149; 149)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                VehicleAssemblyLineTmp.TransferFields(VehicleAssembly_Color);
                                VehicleAssemblyLineTmp."Campaign No." := 'COLOR'; // COPYSTR(VehicleColorLbl,1,20);
                                VehicleAssemblyLineTmp."Model Version No." := ''; //C 20 - "Option Code 2"
                                VehicleAssemblyLineTmp."Description 2" := ''; //T 250 - "Description2"

                                VehicleAssemblyLineTmp.Insert;
                            end;
                        }
                        dataitem(VehicleAssembly_Upholstery; "Vehicle Assembly Line")
                        {
                            DataItemLink = "Serial No." = field("Vehicle Serial No."), "Assembly ID" = field("Vehicle Assembly ID");
                            DataItemLinkReference = "Sales Line";
                            DataItemTableView = sorting("Option Type", "Option Subtype", "Option Code") order(ascending) where("Option Type" = filter("Manufacturer Option" | "Own Option"), Standard = const(false), "Option Subtype" = const(Upholstery));
                            column(ReportForNavId_145; 145)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                VehicleAssemblyLineTmp.TransferFields(VehicleAssembly_Upholstery);
                                VehicleAssemblyLineTmp."Campaign No." := 'UPHOLSTERY'; //COPYSTR(InteriorUpholsteryLbl,1,20);
                                VehicleAssemblyLineTmp."Model Version No." := ''; //C 20 - "Option Code 2"
                                VehicleAssemblyLineTmp."Description 2" := ''; //T 250 - "Description2"

                                VehicleAssemblyLineTmp.Insert;
                            end;
                        }
                        dataitem(VehicleAssembly_Additional; "Vehicle Assembly Line")
                        {
                            DataItemLink = "Serial No." = field("Vehicle Serial No."), "Assembly ID" = field("Vehicle Assembly ID");
                            DataItemLinkReference = "Sales Line";
                            DataItemTableView = sorting("Option Type", "Option Subtype", "Option Code") order(ascending) where("Option Type" = filter("Manufacturer Option" | "Own Option"), Standard = const(false), "Option Subtype" = const(Option));
                            column(ReportForNavId_109; 109)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                VehicleAssemblyLineTmp.TransferFields(VehicleAssembly_Additional);
                                VehicleAssemblyLineTmp."Campaign No." := 'ADDITIONAL'; //COPYSTR(AdditionalAssemblieslbl,1,20);
                                VehicleAssemblyLineTmp."Model Version No." := ''; //C 20 - "Option Code 2"
                                VehicleAssemblyLineTmp."Description 2" := ''; //T 250 - "Description2"

                                VehicleAssemblyLineTmp.Insert;
                            end;
                        }
                        dataitem(VehicleAssemblies; "Integer")
                        {
                            column(ReportForNavId_122; 122)
                            {
                            }
                            column(Type_VehicleAssemblies; AssemblyType)
                            {
                            }
                            column(OptionCode_VehicleAssemblies; VehicleAssemblyLineTmp."Option Code")
                            {
                            }
                            column(Description_VehicleAssemlies; VehicleAssemblyLineTmp.Description)
                            {
                            }
                            column(OptionCode2_VehicleAssemblies; VehicleAssemblyLineTmp."Model Version No.")
                            {
                            }
                            column(Description2_VehicleAssemblies; VehicleAssemblyLineTmp."Description 2")
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if VehAssemblyIndex = 1 then
                                    VehicleAssemblyLineTmp.Find('-')
                                else
                                    VehicleAssemblyLineTmp.Next;

                                case VehicleAssemblyLineTmp."Campaign No." of
                                    'STANDARD':
                                        AssemblyType := StandardAssembliesLbl;
                                    'COLOR':
                                        AssemblyType := VehicleColorLbl;
                                    'UPHOLSTERY':
                                        AssemblyType := InteriorUpholsteryLbl;
                                    'ADDITIONAL':
                                        AssemblyType := AdditionalAssemblieslbl;

                                end;
                                VehAssemblyIndex += 1;
                            end;

                            trigger OnPreDataItem()
                            begin
                                VehAssemblyIndex := 1;
                                SetRange(Number, 1, VehicleAssemblyLineTmp.Count);
                            end;
                        }
                        dataitem(DimensionLoop2; "Integer")
                        {
                            DataItemTableView = sorting(Number) where(Number = filter(1 ..));
                            column(ReportForNavId_3591; 3591)
                            {
                            }
                            column(DimText_DimnLoop2; DimText)
                            {
                            }
                            column(LineDimensionsCaption; LineDimensionsCaptionLbl)
                            {
                            }

                            trigger OnAfterGetRecord()
                            begin
                                if Number = 1 then begin
                                    if not DimSetEntry2.FindSet then
                                        CurrReport.Break;
                                end else
                                    if not Continue then
                                        CurrReport.Break;

                                Clear(DimText);
                                Continue := false;
                                repeat
                                    OldDimText := DimText;
                                    if DimText = '' then
                                        DimText := StrSubstNo('%1 %2', DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code")
                                    else
                                        DimText :=
                                          StrSubstNo(
                                            '%1, %2 %3', DimText,
                                            DimSetEntry2."Dimension Code", DimSetEntry2."Dimension Value Code");
                                    if StrLen(DimText) > MaxStrLen(OldDimText) then begin
                                        DimText := OldDimText;
                                        Continue := true;
                                        exit;
                                    end;
                                until DimSetEntry2.Next = 0;
                            end;

                            trigger OnPreDataItem()
                            begin
                                if not ShowInternalInfo then
                                    CurrReport.Break;

                                DimSetEntry2.SetRange("Dimension Set ID", "Sales Line"."Dimension Set ID");
                            end;
                        }

                        trigger OnAfterGetRecord()
                        begin

                            if Number = 1 then
                                SalesLine.Find('-')
                            else
                                SalesLine.Next;
                            "Sales Line" := SalesLine;
                            "Sales Line".CalcFields(VIN);

                            if not "Sales Header"."Prices Including VAT" and
                               (SalesLine."VAT Calculation Type" = SalesLine."vat calculation type"::"Full VAT")
                            then
                                SalesLine."Line Amount" := 0;

                            if (SalesLine.Type = SalesLine.Type::"G/L Account") and (not ShowInternalInfo) then
                                "Sales Line"."No." := '';
                        end;

                        trigger OnPostDataItem()
                        begin
                            SalesLine.DeleteAll;
                        end;

                        trigger OnPreDataItem()
                        begin
                            MoreLines := SalesLine.Find('+');
                            while MoreLines and (SalesLine.Description = '') and (SalesLine."Description 2" = '') and
                                  (SalesLine."No." = '') and (SalesLine.Quantity = 0) and
                                  (SalesLine.Amount = 0)
                            do
                                MoreLines := SalesLine.Next(-1) <> 0;
                            if not MoreLines then
                                CurrReport.Break;
                            SalesLine.SetRange("Line No.", 0, SalesLine."Line No.");
                            SetRange(Number, 1, SalesLine.Count);
                            CurrReport.CreateTotals(SalesLine."Line Amount", SalesLine."Inv. Discount Amount");
                        end;
                    }
                    dataitem(VATCounter; "Integer")
                    {
                        DataItemTableView = sorting(Number);
                        column(ReportForNavId_6558; 6558)
                        {
                        }
                        column(VATBase_VATAmtLine; VATAmountLine."VAT Base")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VATAmt_VATAmtLine; VATAmountLine."VAT Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(LineAmount_VATAmtLine; VATAmountLine."Line Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(InvDiscBaseAmt_VATAmtLine; VATAmountLine."Inv. Disc. Base Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(InvoiceDiscAmt_VATAmtLine; VATAmountLine."Invoice Discount Amount")
                        {
                            AutoFormatExpression = "Sales Header"."Currency Code";
                            AutoFormatType = 1;
                        }
                        column(VAT_VATAmtLine; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATIdentifier_VATAmtLine; VATAmountLine."VAT Identifier")
                        {
                        }
                        column(VATAmountLineVATCaption; VATAmountLineVATCaptionLbl)
                        {
                        }
                        column(VATBaseCaption; VATBaseCaptionLbl)
                        {
                        }
                        column(VATAmtCaption; VATAmtCaptionLbl)
                        {
                        }
                        column(VATAmountSpecificationCaption; VATAmountSpecificationCaptionLbl)
                        {
                        }
                        column(LineAmtCaption; LineAmtCaptionLbl)
                        {
                        }
                        column(InvoiceDiscBaseAmtCaption; InvoiceDiscBaseAmtCaptionLbl)
                        {
                        }
                        column(InvoiceDiscAmtCaption; InvoiceDiscAmtCaptionLbl)
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
                        column(VATCtrl_VATAmtLine; VATAmountLine."VAT %")
                        {
                            DecimalPlaces = 0 : 5;
                        }
                        column(VATIdentifierCtrl_VATAmtLine; VATAmountLine."VAT Identifier")
                        {
                        }

                        trigger OnAfterGetRecord()
                        begin
                            VATAmountLine.GetLine(Number);

                            VALVATBaseLCY := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                                  "Sales Header"."Order Date", "Sales Header"."Currency Code",
                                  VATAmountLine."VAT Base", "Sales Header"."Currency Factor"));
                            VALVATAmountLCY := ROUND(CurrExchRate.ExchangeAmtFCYToLCY(
                                  "Sales Header"."Order Date", "Sales Header"."Currency Code",
                                  VATAmountLine."VAT Amount", "Sales Header"."Currency Factor"));
                        end;

                        trigger OnPreDataItem()
                        begin
                            if (not GLSetup."Print VAT specification in LCY") or
                               ("Sales Header"."Currency Code" = '') or
                               (VATAmountLine.GetTotalVATAmount = 0)
                            then
                                CurrReport.Break;

                            SetRange(Number, 1, VATAmountLine.Count);
                            CurrReport.CreateTotals(VALVATBaseLCY, VALVATAmountLCY);

                            if GLSetup."LCY Code" = '' then
                                VALSpecLCYHeader := Text008 + Text009
                            else
                                VALSpecLCYHeader := Text008 + Format(GLSetup."LCY Code");

                            CurrExchRate.FindCurrency("Sales Header"."Order Date", "Sales Header"."Currency Code", 1);
                            VALExchRate := StrSubstNo(Text010, CurrExchRate."Relational Exch. Rate Amount", CurrExchRate."Exchange Rate Amount");
                        end;
                    }
                    dataitem(Total; "Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number = const(1));
                        column(ReportForNavId_3476; 3476)
                        {
                        }
                    }
                    dataitem(Total2; "Integer")
                    {
                        DataItemTableView = sorting(Number) where(Number = const(1));
                        column(ReportForNavId_3363; 3363)
                        {
                        }
                        column(SelltoCustNo_SalesHeader; "Sales Header"."Sell-to Customer No.")
                        {
                        }
                        column(ShipToAddr1; ShipToAddr[1])
                        {
                        }
                        column(ShipToAddr2; ShipToAddr[2])
                        {
                        }
                        column(ShipToAddr3; ShipToAddr[3])
                        {
                        }
                        column(ShipToAddr4; ShipToAddr[4])
                        {
                        }
                        column(ShipToAddr5; ShipToAddr[5])
                        {
                        }
                        column(ShipToAddr6; ShipToAddr[6])
                        {
                        }
                        column(ShipToAddr7; ShipToAddr[7])
                        {
                        }
                        column(ShipToAddr8; ShipToAddr[8])
                        {
                        }
                        column(ShiptoAddressCaption; ShiptoAddressCaptionLbl)
                        {
                        }
                        column(SelltoCustNo_SalesHeaderCaption; "Sales Header".FieldCaption("Sell-to Customer No."))
                        {
                        }

                        trigger OnPreDataItem()
                        begin
                            if not ShowShippingAddr then
                                CurrReport.Break;
                        end;
                    }
                }

                trigger OnAfterGetRecord()
                var
                    SalesPost: Codeunit "Sales-Post";
                begin
                    Clear(SalesLine);
                    Clear(SalesPost);
                    SalesLine.DeleteAll;
                    VATAmountLine.DeleteAll;
                    SalesPost.GetSalesLines("Sales Header", SalesLine, 0);
                    SalesLine.CalcVATAmountLines(0, "Sales Header", SalesLine, VATAmountLine);
                    SalesLine.UpdateVATOnLines(0, "Sales Header", SalesLine, VATAmountLine);
                    VATAmount := VATAmountLine.GetTotalVATAmount;
                    VATBaseAmount := VATAmountLine.GetTotalVATBase;
                    VATDiscountAmount :=
                      VATAmountLine.GetTotalVATDiscount("Sales Header"."Currency Code", "Sales Header"."Prices Including VAT");
                    TotalAmountInclVAT := VATAmountLine.GetTotalAmountInclVAT;

                    if Number > 1 then begin
                        CopyText := Text003;
                        OutputNo += 1;
                    end;
                    CurrReport.PageNo := 1;
                end;

                trigger OnPostDataItem()
                begin
                    if Print then
                        SalesCountPrinted.Run("Sales Header");
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
                "Sell-to Country": Text[50];
                DocumentManagementDMS: Codeunit DocumentManagementDMS;
                Lang: Codeunit Language;
            begin
                CurrReport.Language := Lang.GetLanguageID("Language Code");

                if RespCenter.Get("Responsibility Center") then begin
                    FormatAddr.RespCenter(CompanyAddr, RespCenter);
                    CompanyInfo."Phone No." := RespCenter."Phone No.";
                    CompanyInfo."Fax No." := RespCenter."Fax No.";
                end else
                    FormatAddr.Company(CompanyAddr, CompanyInfo);

                DimSetEntry1.SetRange("Dimension Set ID", "Dimension Set ID");

                if "Salesperson Code" = '' then begin
                    SalesPurchPerson.Init;
                    SalesPersonText := '';
                end else begin
                    SalesPurchPerson.Get("Salesperson Code");
                    SalesPersonText := Text000;
                end;
                if "Your Reference" = '' then
                    ReferenceText := ''
                else
                    ReferenceText := FieldCaption("Your Reference");
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
                FormatAddr.SalesHeaderBillTo(CustAddr, "Sales Header");

                if "Payment Terms Code" = '' then
                    PaymentTerms.Init
                else begin
                    PaymentTerms.Get("Payment Terms Code");
                    PaymentTerms.TranslateDescription(PaymentTerms, "Language Code");
                end;
                if "Shipment Method Code" = '' then
                    ShipmentMethod.Init
                else begin
                    ShipmentMethod.Get("Shipment Method Code");
                    ShipmentMethod.TranslateDescription(ShipmentMethod, "Language Code");
                end;

                if Country.Get("Sell-to Country/Region Code") then
                    "Sell-to Country" := Country.Name;
                //Upgrade 2017 >>
                FormatAddr.SalesHeaderShipTo(ShipToAddr, ShipToAddr, "Sales Header");
                //Upgrade 2017 <<
                ShowShippingAddr := "Sell-to Customer No." <> "Bill-to Customer No.";
                for i := 1 to ArrayLen(ShipToAddr) do
                    if (ShipToAddr[i] <> CustAddr[i]) and (ShipToAddr[i] <> '') and (ShipToAddr[i] <> "Sell-to Country") then
                        ShowShippingAddr := true;

                if Print then begin
                    if ArchiveDocument then
                        ArchiveManagement.StoreSalesDocument("Sales Header", LogInteraction);

                    if LogInteraction then begin
                        CalcFields("No. of Archived Versions");
                        if "Bill-to Contact No." <> '' then
                            DocumentManagementDMS.LogDocumentEDMS( // 04.02.2015 EDMS P11 #T019
                              1, "No.", "Doc. No. Occurrence",
                              "No. of Archived Versions", Database::Contact, "Bill-to Contact No.",
                              "Salesperson Code", "Campaign No.", "Posting Description", "Opportunity No.", "Vehicle Serial No.") //EDMS - changed
                        else
                            DocumentManagementDMS.LogDocumentEDMS( // 04.02.2015 EDMS P11 #T019
                              1, "No.", "Doc. No. Occurrence",
                              "No. of Archived Versions", Database::Customer, "Bill-to Customer No.",
                              "Salesperson Code", "Campaign No.", "Posting Description", "Opportunity No.", "Vehicle Serial No.") //EDMS - changed
                    end;
                end;
                Mark(true);
                if "Document Type" = "document type"::Quote then
                    DocNameTxt := Text004
                else
                    DocNameTxt := Text0041;

                if ProformaInvoice then
                    DocNameTxt := text0042;

            end;

            trigger OnPostDataItem()
            var
                ToDo: Record "To-do";
            begin
                MarkedOnly := true;
                Commit;
                CurrReport.Language := GlobalLanguage;
                if Find('-') and ToDo.WritePermission then
                    if Print and (NoOfRecords = 1) then
                        if Confirm(Text007) then
                            CreateTask;
            end;

            trigger OnPreDataItem()
            begin
                NoOfRecords := Count;
                Print := Print or not CurrReport.Preview;           //?
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
                    field(ShowInternalInfo; ShowInternalInfo)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Internal Information';
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
                    field(ShowPicture; ShowPicture)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Picture';
                        OptionCaption = 'No,Model Version,Vehicle';
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

        trigger OnInit()
        begin
            LogInteractionEnable := true;
        end;

        trigger OnOpenPage()
        begin
            ArchiveDocument := (SalesSetup."Archive Quotes" = SalesSetup."Archive Quotes"::Always);
            LogInteraction := SegManagement.FindInteractionTemplateCode("Interaction Log Entry Document Type"::"Sales Qte.") <> '';

            LogInteractionEnable := LogInteraction;
        end;
    }

    labels
    {
        ReportTitleLbl = 'Sales - Quote Vehicle';
    }

    trigger OnInitReport()
    begin
        GLSetup.Get;
        CompanyInfo.Get;
        SalesSetup.Get;

        case SalesSetup."Logo Position on Documents" of
            SalesSetup."logo position on documents"::"No Logo":
                ;
            SalesSetup."logo position on documents"::Left:
                begin
                    CompanyInfo3.Get;
                    CompanyInfo3.CalcFields(Picture);
                end;
            SalesSetup."logo position on documents"::Center:
                begin
                    CompanyInfo1.Get;
                    CompanyInfo1.CalcFields(Picture);
                end;
            SalesSetup."logo position on documents"::Right:
                begin
                    CompanyInfo2.Get;
                    CompanyInfo2.CalcFields(Picture);
                end;
        end;
    end;

    var
        Text000: label 'Salesperson';
        Text001: label 'Total %1';
        Text002: label 'Total %1 Incl. VAT';
        Text003: label 'COPY';
        Text004: label 'Sales - Quote Vehicle %1';
        Text0041: label 'Sales - Order Vehicle %1';
        Text0042: label 'Sales - Proforma Invoice Vehicle %1';
        Text005: label 'Page %1';
        Text006: label 'Total %1 Excl. VAT';
        GLSetup: Record "General Ledger Setup";
        ShipmentMethod: Record "Shipment Method";
        PaymentTerms: Record "Payment Terms";
        SalesPurchPerson: Record "Salesperson/Purchaser";
        CompanyInfo: Record "Company Information";
        CompanyInfo1: Record "Company Information";
        CompanyInfo2: Record "Company Information";
        CompanyInfo3: Record "Company Information";
        SalesSetup: Record "Sales & Receivables Setup";
        VATAmountLine: Record "VAT Amount Line" temporary;
        SalesLine: Record "Sales Line" temporary;
        DimSetEntry1: Record "Dimension Set Entry";
        DimSetEntry2: Record "Dimension Set Entry";
        RespCenter: Record "Responsibility Center";
        VLanguage: Record Language;
        Country: Record "Country/Region";
        CurrExchRate: Record "Currency Exchange Rate";
        VehicleAssemblyLineTmp: Record "Vehicle Assembly Line" temporary;
        SalesCountPrinted: Codeunit "Sales-Printed";
        FormatAddr: Codeunit "Format Address";
        SegManagement: Codeunit SegManagement;
        ArchiveManagement: Codeunit ArchiveManagement;
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
        VehAssemblyIndex: Integer;
        DimText: Text[120];
        OldDimText: Text[75];
        ShowInternalInfo: Boolean;
        Continue: Boolean;
        ArchiveDocument: Boolean;
        LogInteraction: Boolean;
        VATAmount: Decimal;
        VATBaseAmount: Decimal;
        VATDiscountAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        Text007: label 'Do you want to create a follow-up to-do?';
        NoOfRecords: Integer;
        VALVATBaseLCY: Decimal;
        VALVATAmountLCY: Decimal;
        VALSpecLCYHeader: Text[80];
        VALExchRate: Text[50];
        Text008: label 'VAT Amount Specification in ';
        Text009: label 'Local Currency';
        Text010: label 'Exchange rate: %1/%2';
        OutputNo: Integer;
        Print: Boolean;
        [InDataSet]
        ArchiveDocumentEnable: Boolean;
        [InDataSet]
        LogInteractionEnable: Boolean;
        CompanyInfoPhoneNoCaptionLbl: label 'Phone No.';
        CompanyInfoVATRegNoCaptionLbl: label 'VAT Registration No.';
        CompanyInfoGiroNoCaptionLbl: label 'Giro No.';
        CompanyInfoBankNameCaptionLbl: label 'Bank';
        CompanyInfoBankAccountNoCaptionLbl: label 'Account No.';
        SalesHeaderShipmentDateCaptionLbl: label 'Shipment Date';
        SalesHeaderNoCaptionLbl: label 'Quote No.';
        HeaderDimensionsCaptionLbl: label 'Header Dimensions';
        UnitPriceCaptionLbl: label 'Unit Price';
        SalesLineLineDiscCaptionLbl: label 'Discount %';
        AmountCaptionLbl: label 'Amount';
        SalesLineInvDiscAmtCaptionLbl: label 'Invoice Discount Amount';
        SubtotalCaptionLbl: label 'Subtotal';
        VATDiscountAmountCaptionLbl: label 'Payment Discount on VAT';
        LineDimensionsCaptionLbl: label 'Line Dimensions';
        VATAmountLineVATCaptionLbl: label 'VAT %';
        VATBaseCaptionLbl: label 'VAT Base';
        VATAmtCaptionLbl: label 'VAT Amount';
        VATAmountSpecificationCaptionLbl: label 'VAT Amount Specification';
        LineAmtCaptionLbl: label 'Line Amount';
        InvoiceDiscBaseAmtCaptionLbl: label 'Invoice Discount Base Amount';
        InvoiceDiscAmtCaptionLbl: label 'Invoice Discount Amount';
        TotalCaptionLbl: label 'Total';
        ShiptoAddressCaptionLbl: label 'Ship-to Address';
        SalesLineVATIdentifierCaptionLbl: label 'VAT Identifier';
        PaymentTermsDescriptionCaptionLbl: label 'Payment Terms';
        ShipmentMethodDescriptionCaptionLbl: label 'Shipment Method';
        CompanyInfoHomePageCaptionLbl: label 'Home Page';
        CompanyInfoEmailCaptionLbl: label 'E-Mail';
        DocumentDateCaptionLbl: label 'Document Date';
        SalesLineAllowInvoiceDiscCaptionLbl: label 'Allow Invoice Discount';
        "---EDMS---": Integer;
        VehAssembly2: Record "Vehicle Assembly Line";
        VehOptionMgt: Codeunit VehicleOptionManagement;
        StdCount: Integer;
        PrevStdOpt: Code[20];
        StdCount2: Integer;
        StandardAssembliesLbl: label 'Standard Assemblies';
        VehicleColorLbl: label 'Vehicle Color';
        InteriorUpholsteryLbl: label 'Interior Upholstery';
        AdditionalAssemblieslbl: label 'Additional Assemblies';
        AssemblyType: Text[50];
        ShowPicture: Option No,"Model Version",Vehicle;
        DocNameTxt: Text;
        ProformaInvoice: Boolean;


    procedure InitializeRequest(NoOfCopiesFrom: Integer; ShowInternalInfoFrom: Boolean; ArchiveDocumentFrom: Boolean; LogInteractionFrom: Boolean; PrintFrom: Boolean)
    begin
        NoOfCopies := NoOfCopiesFrom;
        ShowInternalInfo := ShowInternalInfoFrom;
        ArchiveDocument := ArchiveDocumentFrom;
        LogInteraction := LogInteractionFrom;
        Print := PrintFrom;
    end;
}

