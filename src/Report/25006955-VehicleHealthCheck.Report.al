Report 25006955 "Vehicle Health Check"
{
    // 26/02/2018 GP1 P30
    //   Added field PaymentTxt
    RDLCLayout = './Layouts/VehicleHealthCheck.rdlc';

    Caption = 'Vehicle Health Check';
    DefaultLayout = RDLC;
    EnableHyperlinks = true;
    WordMergeDataItem = "Service Header EDMS";

    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            CalcFields = Picture, "Invoice Header Picture", "Invoice Footer Picture", "Invoice Disclaimer Picture";
            DataItemTableView = sorting("Primary Key");
            column(ReportForNavId_25006083; 25006083)
            {
            }
            column(CompanyInformation_Name; Name)
            {
                IncludeCaption = true;
            }
            column(CompanyInformation_Name2; "Name 2")
            {
                IncludeCaption = true;
            }
            column(CompanyInformation_Address; Address)
            {
                IncludeCaption = true;
            }
            column(CompanyInformation_Address2; "Address 2")
            {
                IncludeCaption = true;
            }
            column(CompanyInformation_City; City)
            {
                IncludeCaption = true;
            }
            column(CompanyInformation_PostCode; "Post Code")
            {
                IncludeCaption = true;
            }
            column(CompanyInformation_County; County)
            {
                IncludeCaption = true;
            }
            column(CompanyInformation_CountryRegionCode; "Country/Region Code")
            {
                IncludeCaption = true;
            }
            column(CompanyInformation_HomePage; "Home Page")
            {
                IncludeCaption = true;
            }
            column(CompanyInformation_EMail; "E-Mail")
            {
                IncludeCaption = true;
            }
            column(CompanyInformation_PhoneNo; "Phone No.")
            {
                IncludeCaption = true;
            }
            column(CompanyInformation_PhoneNo2; "Phone No. 2")
            {
                IncludeCaption = true;
            }
            column(CompanyInformation_BankName; "Bank Name")
            {
                IncludeCaption = true;
            }
            column(CompanyInformation_BankBranchNo; "Bank Branch No.")
            {
                IncludeCaption = true;
            }
            column(CompanyInformation_BankAccountNo; "Bank Account No.")
            {
                IncludeCaption = true;
            }
            column(CompanyInformation_IBAN; Iban)
            {
                IncludeCaption = true;
            }
            column(CompanyInformationSWIFTCode; "SWIFT Code")
            {
                IncludeCaption = true;
            }
            column(CompanyInformation_VATRegistrationNo; "VAT Registration No.")
            {
                IncludeCaption = true;
            }
            column(CompanyInformation_RegistrationNo; "Registration No.")
            {
                IncludeCaption = true;
            }
            column(CompanyInformation_Picture; Picture)
            {
                IncludeCaption = true;
            }
            column(CompanyInformation_InvoiceHeaderPicture; "Invoice Header Picture")
            {
            }
            column(CompanyInformation_InvoiceFooterPicture; "Invoice Footer Picture")
            {
            }
            column(CompanyInformation_InvoiceDisclaimerPicture; "Invoice Disclaimer Picture")
            {
            }
        }
        dataitem("Service Header EDMS"; "Service Header EDMS")
        {
            CalcFields = Amount, "Amount Including VAT";
            RequestFilterFields = "No.";
            column(ReportForNavId_25006000; 25006000)
            {
            }
            column(DocumentNo; "No.")
            {
                IncludeCaption = true;
            }
            column(DocumentType; "Document Type")
            {
                IncludeCaption = true;
            }
            column(OrderDate; "Order Date")
            {
                IncludeCaption = true;
            }
            column(OrderTime; "Order Time")
            {
                IncludeCaption = true;
            }
            column(DocumentDate; DocumentDate)
            {
                AutoFormatType = 1;
            }
            column(PostingDate; "Posting Date")
            {
                IncludeCaption = true;
            }
            column(DueDate; "Due Date")
            {
                IncludeCaption = true;
            }
            column(PostingNo; "Posting No.")
            {
                IncludeCaption = true;
            }
            column(CurrencyCode; CurrencyCode)
            {
            }
            column(ServicePerson; "Service Advisor")
            {
                IncludeCaption = true;
            }
            column(HeaderDescription; Description)
            {
                IncludeCaption = true;
            }
            column(VIN; VIN)
            {
                IncludeCaption = true;
            }
            column(VehicleRegistrationNo; "Vehicle Registration No.")
            {
                IncludeCaption = true;
            }
            column(DocTitle; DocTitle)
            {
            }
            column(MakeCode; "Make Code")
            {
                IncludeCaption = true;
            }
            column(ModelCode; "Model Code")
            {
                IncludeCaption = true;
            }
            column(ModelVersionNo; "Model Version No.")
            {
                IncludeCaption = true;
            }
            column(ArrivalTime; "Arrival Time")
            {
                IncludeCaption = true;
            }
            column(ArrivalDate; "Arrival Date")
            {
                IncludeCaption = true;
            }
            column(VehicleSerialNo; "Vehicle Serial No.")
            {
                IncludeCaption = true;
            }
            column(ContractNo; "Contract No.")
            {
                IncludeCaption = true;
            }
            column(Comment; Comment)
            {
                IncludeCaption = true;
            }
            column(Amount; Amount)
            {
                IncludeCaption = true;
            }
            column(AmountIncludingVAT; "Amount Including VAT")
            {
                IncludeCaption = true;
            }
            column(ModelCommercialName; "Model Commercial Name")
            {
                IncludeCaption = true;
            }
            column(SellToCustomerNo; "Sell-to Customer No.")
            {
                IncludeCaption = true;
            }
            column(SellToCustomerName; "Sell-to Customer Name")
            {
                IncludeCaption = true;
            }
            column(SellToCustomerName2; "Sell-to Customer Name 2")
            {
                IncludeCaption = true;
            }
            column(SellToAddress; "Sell-to Address")
            {
                IncludeCaption = true;
            }
            column(SellToAddress2; "Sell-to Address 2")
            {
                IncludeCaption = true;
            }
            column(SellToCity; "Sell-to City")
            {
                IncludeCaption = true;
            }
            column(SellToCounty; "Sell-to County")
            {
                IncludeCaption = true;
            }
            column(SellToCountry_RegionCode; "Sell-to Country/Region Code")
            {
                IncludeCaption = true;
            }
            column(SellToPostCode; "Sell-to Post Code")
            {
                IncludeCaption = true;
            }
            column(SellToContact; "Sell-to Contact")
            {
                IncludeCaption = true;
            }
            column(SellToContactNo; "Sell-to Contact No.")
            {
                IncludeCaption = true;
            }
            column(BillToCustomerNo; "Bill-to Customer No.")
            {
                IncludeCaption = true;
            }
            column(BillToName; "Bill-to Name")
            {
                IncludeCaption = true;
            }
            column(BillToName2; "Bill-to Name 2")
            {
                IncludeCaption = true;
            }
            column(BillToAddress; "Bill-to Address")
            {
                IncludeCaption = true;
            }
            column(BillToAddress2; "Bill-to Address 2")
            {
                IncludeCaption = true;
            }
            column(BillToCity; "Bill-to City")
            {
                IncludeCaption = true;
            }
            column(BillToContact; "Bill-to Contact")
            {
                IncludeCaption = true;
            }
            column(BillToCounty; "Bill-to County")
            {
                IncludeCaption = true;
            }
            column(BillToCountry_RegionCode; "Bill-to Country/Region Code")
            {
                IncludeCaption = true;
            }
            column(BillToPostCode; "Bill-to Post Code")
            {
                IncludeCaption = true;
            }
            column(BillToContactNo; "Bill-to Contact No.")
            {
                IncludeCaption = true;
            }
            column(TotalVATBase; TotalVATBase)
            {
            }
            column(TotalVATAmount; TotalVATAmount)
            {
            }
            column(TotalVATDiscountAmount; TotalVATDiscountAmount)
            {
            }
            column(TotalAmountInclVAT; TotalAmountInclVAT)
            {
            }
            column(VariableFieldRun1_ServiceHeaderEDMS; "Variable Field Run 1")
            {
            }
            column(HideLaborQuantityandPrice; "Hide Labor Quantity and Price")
            {
            }
            column(ShowBranchDetails; "Show Branch Details")
            {
            }
            column(Location_Code; Location.Code)
            {
                IncludeCaption = true;
            }
            column(Location_Name; Location.Name)
            {
                IncludeCaption = true;
            }
            column(Location_Name2; Location."Name 2")
            {
                IncludeCaption = true;
            }
            column(Location_Address; Location.Address)
            {
                IncludeCaption = true;
            }
            column(Location_Address2; Location."Address 2")
            {
                IncludeCaption = true;
            }
            column(Location_City; Location.City)
            {
                IncludeCaption = true;
            }
            column(Location_PhoneNo; Location."Phone No.")
            {
                IncludeCaption = true;
            }
            column(Location_PhoneNo2; Location."Phone No. 2")
            {
                IncludeCaption = true;
            }
            column(Location_PostCode; Location."Post Code")
            {
                IncludeCaption = true;
            }
            column(Location_County; Location.County)
            {
                IncludeCaption = true;
            }
            column(Location_EMail; Location."E-Mail")
            {
                IncludeCaption = true;
            }
            column(Location_HomePage; Location."Home Page")
            {
                IncludeCaption = true;
            }
            column(Location_CountryRegionCode; Location."Country/Region Code")
            {
                IncludeCaption = true;
            }
            column(UseGrouping; UseGrouping)
            {
            }
            column(PaymentTxt; PaymentTxt)
            {
            }
            column(TotalVATBaseAuthorised; TotalVATBaseAuthorised)
            {
            }
            column(TotalVATAmountAuthorised; TotalVATAmountAuthorised)
            {
            }
            column(TotalAmountInclVATAuthorised; TotalAmountInclVATAuthorised)
            {
            }
            dataitem(Vehicle; Vehicle)
            {
                DataItemLink = "Serial No." = field("Vehicle Serial No.");
                DataItemTableView = sorting("Serial No.");
                column(ReportForNavId_25006056; 25006056)
                {
                }
                column(Vehicle_ProductionYear; "Production Year")
                {
                    IncludeCaption = true;
                }
                column(Vehicle_VariableFieldRun1; "Variable Field Run 1")
                {
                    IncludeCaption = true;
                }
                column(Vehicle_VariableFieldRun2; "Variable Field Run 2")
                {
                    IncludeCaption = true;
                }
                column(Vehicle_VariableFieldRun3; "Variable Field Run 3")
                {
                    IncludeCaption = true;
                }
                column(Vehicle_BodyColorCode; "Body Color Code")
                {
                    IncludeCaption = true;
                }
                column(Vehicle_InteriorCode; "Interior Code")
                {
                    IncludeCaption = true;
                }
                column(Vehicle_TypeCode; "Type Code")
                {
                    IncludeCaption = true;
                }
                column(Vehicle_FirstRegistrationDate; "First Registration Date")
                {
                    IncludeCaption = true;
                }
                column(Vehicle_NextVehicleInspectionDate; "Next Vehicle Inspection Date")
                {
                    IncludeCaption = true;
                }
                column(Vehicle_VariableField25006800; "Variable Field 25006800")
                {
                    IncludeCaption = true;
                }
                column(Vehicle_VariableField25006801; "Variable Field 25006801")
                {
                    IncludeCaption = true;
                }
                column(Vehicle_VariableField25006802; "Variable Field 25006802")
                {
                    IncludeCaption = true;
                }
                column(Vehicle_VariableField25006803; "Variable Field 25006803")
                {
                    IncludeCaption = true;
                }
                column(Vehicle_VariableField25006804; "Variable Field 25006804")
                {
                    IncludeCaption = true;
                }
                column(Vehicle_VariableField25006805; "Variable Field 25006805")
                {
                    IncludeCaption = true;
                }
                column(Vehicle_VariableField25006806; "Variable Field 25006806")
                {
                    IncludeCaption = true;
                }
                column(Vehicle_VariableField25006807; "Variable Field 25006807")
                {
                    IncludeCaption = true;
                }
                column(Vehicle_VariableField25006808; "Variable Field 25006808")
                {
                    IncludeCaption = true;
                }
                column(Vehicle_VariableField25006809; "Variable Field 25006809")
                {
                    IncludeCaption = true;
                }
                column(Vehicle_VariableField25006810; "Variable Field 25006810")
                {
                    IncludeCaption = true;
                }
                column(Vehicle_VariableField25006811; "Variable Field 25006811")
                {
                    IncludeCaption = true;
                }
                column(Vehicle_VariableField25006812; "Variable Field 25006812")
                {
                    IncludeCaption = true;
                }
                column(Vehicle_VariableField25006813; "Variable Field 25006813")
                {
                    IncludeCaption = true;
                }
                column(Vehicle_VariableField25006814; "Variable Field 25006814")
                {
                    IncludeCaption = true;
                }
                column(Vehicle_VariableField25006815; "Variable Field 25006815")
                {
                    IncludeCaption = true;
                }
                column(Vehicle_VariableField25006816; "Variable Field 25006816")
                {
                    IncludeCaption = true;
                }
                column(Vehicle_VariableField25006817; "Variable Field 25006817")
                {
                    IncludeCaption = true;
                }
                column(Vehicle_VariableField25006818; "Variable Field 25006818")
                {
                    IncludeCaption = true;
                }
                column(Vehicle_VariableField25006819; "Variable Field 25006819")
                {
                    IncludeCaption = true;
                }
                column(Vehicle_VariableField25006820; "Variable Field 25006820")
                {
                    IncludeCaption = true;
                }
                column(Vehicle_VariableField25006821; "Variable Field 25006821")
                {
                    IncludeCaption = true;
                }
                column(Vehicle_VariableField25006822; "Variable Field 25006822")
                {
                    IncludeCaption = true;
                }
                column(Vehicle_VariableField25006823; "Variable Field 25006823")
                {
                    IncludeCaption = true;
                }
                column(Vehicle_VariableField25006824; "Variable Field 25006824")
                {
                    IncludeCaption = true;
                }
                column(Vehicle_VariableField25006825; "Variable Field 25006825")
                {
                    IncludeCaption = true;
                }
            }
            dataitem(ServiceLine; "Service Line EDMS")
            {
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
                column(ReportForNavId_25006170; 25006170)
                {
                }
                column(ServiceLine_Type; Type)
                {
                    IncludeCaption = true;
                }
                column(ServiceLine_No; "No.")
                {
                    IncludeCaption = true;
                }
                column(ServiceLine_Description; Description)
                {
                    IncludeCaption = true;
                }
                column(ServiceLine_Description2; "Description 2")
                {
                    IncludeCaption = true;
                }
                column(ServiceLine_UnitofMeasureCode; "Unit of Measure Code")
                {
                    IncludeCaption = true;
                }
                column(ServiceLine_UnitofMeasure; "Unit of Measure")
                {
                    IncludeCaption = true;
                }
                column(ServiceLine_Quantity; Quantity)
                {
                    IncludeCaption = true;
                }
                column(ServiceLine_UnitPrice; "Unit Price")
                {
                    IncludeCaption = true;
                }
                column(ServiceLine_VATRate; "VAT %")
                {
                    IncludeCaption = true;
                }
                column(ServiceLine_LineDiscountRate; "Line Discount %")
                {
                    IncludeCaption = true;
                }
                column(ServiceLine_LineDiscountAmount; "Line Discount Amount")
                {
                    IncludeCaption = true;
                }
                column(ServiceLine_Amount; Amount)
                {
                    IncludeCaption = true;
                }
                column(ServiceLine_AmountIncludingVAT; "Amount Including VAT")
                {
                    IncludeCaption = true;
                }
                column(ServiceLine_LineAmount; "Line Amount")
                {
                    DecimalPlaces = 2 : 2;
                    IncludeCaption = true;
                }
                column(ServiceLine_VariantCode; "Variant Code")
                {
                    IncludeCaption = true;
                }
                column(ServiceLine_SymptomCode; "Symptom Code")
                {
                    IncludeCaption = true;
                }
                column(ItemTotalExclVAT; ItemTotalExclVAT)
                {
                }
                column(ServiceLine_GroupID; GroupID)
                {
                }
                column(ServiceLine_GroupDescription; GroupDescription)
                {
                }
                column(ServiceLine_LineNo; "Line No.")
                {
                    IncludeCaption = true;
                }
                column(ServiceLine_CustomerAuthorised; "Customer Authorised")
                {
                    IncludeCaption = true;
                }

                trigger OnAfterGetRecord()
                begin
                    ItemTotalExclVAT += Amount;
                    case Type of
                        Type::Labor:
                            begin
                                GroupDescription := LaborGroupText;
                                GroupID := 1;
                            end;
                        Type::Item:
                            begin
                                GroupDescription := ItemGroupText;
                                GroupID := 2;
                            end;
                        else begin
                            GroupDescription := OtherGroupText;
                            GroupID := 3;
                        end;
                    end;
                end;

                trigger OnPreDataItem()
                begin
                    ItemTotalExclVAT := 0;
                end;
            }
            dataitem(VATAmountLine; "VAT Amount Line")
            {
                DataItemTableView = sorting("VAT Identifier", "VAT Calculation Type", "Tax Group Code", "Use Tax", Positive);
                UseTemporary = true;
                column(ReportForNavId_25006135; 25006135)
                {
                }
                column(VATAmountLine_VATIdentifier; "VAT Identifier")
                {
                    IncludeCaption = true;
                }
                column(VATAmountLine_VATCalculationType; "VAT Calculation Type")
                {
                    IncludeCaption = true;
                }
                column(VATAmountLine_TaxGroupCode; "Tax Group Code")
                {
                    IncludeCaption = true;
                }
                column(VATAmountLine_VATRate; "VAT %")
                {
                    IncludeCaption = true;
                }
                column(VATAmountLine_VATBase; "VAT Base")
                {
                    IncludeCaption = true;
                }
                column(VATAmountLine_VATAmount; "VAT Amount")
                {
                    IncludeCaption = true;
                }
                column(VATAmountLine_AmountIncludingVAT; "Amount Including VAT")
                {
                    IncludeCaption = true;
                }
                column(VATAmountLine_LineAmount; "Line Amount")
                {
                    IncludeCaption = true;
                }
                column(VATAmountLine_InvDiscBaseAmount; "Inv. Disc. Base Amount")
                {
                    IncludeCaption = true;
                }
                column(VATAmountLineInvoiceDiscountAmount; "Invoice Discount Amount")
                {
                    IncludeCaption = true;
                }
                column(VATAmountLine_Quantity; Quantity)
                {
                    IncludeCaption = true;
                }
                column(VATAmountLine_CalculatedVATAmount; "Calculated VAT Amount")
                {
                    IncludeCaption = true;
                }
                column(VATAmountLine_VATClauseCode; "VAT Clause Code")
                {
                    IncludeCaption = true;
                }
                column(VATAmountLine_TaxCategory; "Tax Category")
                {
                    IncludeCaption = true;
                }
            }
            dataitem("Service Comment Line EDMS"; "Service Comment Line EDMS")
            {
                DataItemLink = "No." = field("No."), Type = field("Document Type");
                DataItemTableView = sorting(Type, "No.", "Line No.");
                column(ReportForNavId_25006171; 25006171)
                {
                }
                column(ServiceCommentLine_CommentTypeCode; "Comment Type Code")
                {
                    IncludeCaption = true;
                }
                column(ServiceCommentLineEDMS_Comment; Comment)
                {
                    IncludeCaption = true;
                }
            }
            dataitem(BillToCustomer; Customer)
            {
                DataItemLink = "No." = field("Bill-to Customer No.");
                DataItemTableView = sorting("No.");
                column(ReportForNavId_25006174; 25006174)
                {
                }
                column(BillllToCustomer_VATRegistrationNo; "VAT Registration No.")
                {
                    IncludeCaption = true;
                }
            }
            dataitem(SellToCustomer; Customer)
            {
                DataItemLink = "No." = field("Sell-to Customer No.");
                DataItemTableView = sorting("No.");
                column(ReportForNavId_25006177; 25006177)
                {
                }
                column(SellToCustomer_VATRegistrationNo; "VAT Registration No.")
                {
                    IncludeCaption = true;
                }
            }
            dataitem(BillToContact; Contact)
            {
                DataItemLink = "No." = field("Bill-to Contact No.");
                DataItemTableView = sorting("No.");
                column(ReportForNavId_25006178; 25006178)
                {
                }
                column(BillToContact_Name; Name)
                {
                    IncludeCaption = true;
                }
                column(BillToContact_PhoneNo; "Phone No.")
                {
                    IncludeCaption = true;
                }
                column(BillToContact_EMail; "E-Mail")
                {
                    IncludeCaption = true;
                }
            }
            dataitem(SellToContact; Contact)
            {
                DataItemLink = "No." = field("Sell-to Contact No.");
                DataItemTableView = sorting("No.");
                column(ReportForNavId_25006185; 25006185)
                {
                }
                column(SellToContact_Name; Name)
                {
                    IncludeCaption = true;
                }
                column(SellToContact_PhoneNo; "Phone No.")
                {
                    IncludeCaption = true;
                }
                column(SellToContact_EMail; "E-Mail")
                {
                    IncludeCaption = true;
                }
            }

            trigger OnAfterGetRecord()
            begin
                UseGrouping := "Service Header EDMS"."Group Lines";

                if "Currency Code" = '' then
                    CurrencyCode := GLSetup."LCY Code"
                else
                    CurrencyCode := "Currency Code";
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
                TotalVATAmount := VATAmountLine.GetTotalVATAmount;
                TotalVATBase := VATAmountLine.GetTotalVATBase;
                TotalVATDiscountAmount :=
                  VATAmountLine.GetTotalVATDiscount("Service Header EDMS"."Currency Code", "Service Header EDMS"."Prices Including VAT");
                TotalAmountInclVAT := VATAmountLine.GetTotalAmountInclVAT;

                // Calculate Customer Athorised Totals >>
                TempServLineDisc.SetRange("Customer Authorised", true);
                TempServLineDisc.CalcVATAmountLines(1, "Service Header EDMS", TempServLineDisc, VATAmountLineCustAuth);
                TotalVATAmountAuthorised := VATAmountLineCustAuth.GetTotalVATAmount;
                TotalVATBaseAuthorised := VATAmountLineCustAuth.GetTotalVATBase;
                TotalAmountInclVATAuthorised := VATAmountLineCustAuth.GetTotalAmountInclVAT;
                // <<

                DocumentDate := Format("Document Date", 9);

                DocTitle := VHCTitle;


                Clear(Location);
                if "Location Code" <> '' then
                    Location.Get("Location Code");

                PaymentTxt := '';
                Clear(DocumentPaymentLine);
                DocumentPaymentLine.Reset;
                DocumentPaymentLine.SetRange("Document Type", DocumentPaymentLine."document type"::"Service Order");
                DocumentPaymentLine.SetRange("Document No.", "No.");
                DocumentPaymentLine.SetFilter(Amount, '<>%1', 0);
                if DocumentPaymentLine.FindFirst then begin
                    repeat
                        if PaymentTxt = '' then
                            PaymentTxt := PaymentTitle + ' ' + DocumentPaymentLine.Description + ' ' + Format(DocumentPaymentLine.Amount, 0, '<Precision,2:2><Standard Format,0>') + ' ' + PaymentTitle2 + ' ' + Format("Document Date", 0, '<Closing><Day,2>/<Month,2>/<Year4>')
                        else
                            PaymentTxt += '; ' + DocumentPaymentLine.Description + ' ' + Format(DocumentPaymentLine.Amount, 0, '<Precision,2:2><Standard Format,0>') + ' ' + PaymentTitle2 + ' ' + Format("Document Date", 0, '<Closing><Day,2>/<Month,2>/<Year4>');
                    until DocumentPaymentLine.Next = 0;
                end;
            end;
        }
    }

    requestpage
    {
        Caption = 'Options';
        SaveValues = true;

        layout
        {
        }

        actions
        {
        }
    }

    labels
    {
        CurrencyCodeCaption = 'Currency Code';
    }

    trigger OnPreReport()
    begin
        GLSetup.Get;
    end;

    var
        CurrencyCode: Code[10];
        GLSetup: Record "General Ledger Setup";
        ServPost: Codeunit "Service-Post EDMS";
        TempServLine: Record "Service Line EDMS" temporary;
        TempServLineDisc: Record "Service Line EDMS" temporary;
        ServLine: Record "Service Line EDMS" temporary;
        TotalVATBase: Decimal;
        TotalVATAmount: Decimal;
        TotalVATDiscountAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        LaborTotalExclVAT: Decimal;
        ItemTotalExclVAT: Decimal;
        DocumentDate: Text;
        UseGrouping: Boolean;
        LaborGroupText: label 'Labour';
        ItemGroupText: label 'Parts';
        GroupDescription: Text;
        OtherGroupText: label 'Other';
        GroupID: Integer;
        ProformaInvoice: Boolean;
        DocTitle: Text;
        InvoiceTitle: label 'Invoice';
        ProformaInvoiceTitle: label 'Proforma - Invoice';
        Location: Record Location;
        PaymentTxt: Text;
        PaymentTitle: label 'Paid';
        PaymentTitle2: label 'on';
        DocumentPaymentLine: Record "Document Payment Line";
        VHCTitle: label 'Vehicle Health Check';
        VATAmountLineCustAuth: Record "VAT Amount Line" temporary;
        TotalVATBaseAuthorised: Decimal;
        TotalVATAmountAuthorised: Decimal;
        TotalAmountInclVATAuthorised: Decimal;


    procedure SetProformaMode()
    begin
        ProformaInvoice := true;
    end;
}

