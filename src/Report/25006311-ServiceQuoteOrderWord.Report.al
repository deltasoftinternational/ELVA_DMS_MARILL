Report 25006311 "Service Quote/Order Word"
{
    RDLCLayout = './Layouts/ServiceQuoteOrderWord.rdlc';
    WordLayout = './Layouts/ServiceQuoteOrderWord.docx';
    Caption = 'Service Quote/Order';
    DefaultLayout = Word;
    WordMergeDataItem = "Service Header EDMS";

    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            CalcFields = Picture;
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
        }
        dataitem("Service Header EDMS"; "Service Header EDMS")
        {
            CalcFields = Amount, "Amount Including VAT";
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
            dataitem(Vehicle; Vehicle)
            {
                DataItemLink = "Serial No." = field("Vehicle Serial No.");
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
            dataitem(Location; Location)
            {
                DataItemLink = Code = field("Location Code");
                column(ReportForNavId_25006104; 25006104)
                {
                }
                column(Location_Code; Code)
                {
                    IncludeCaption = true;
                }
                column(Location_Name; Name)
                {
                    IncludeCaption = true;
                }
                column(Location_Name2; "Name 2")
                {
                    IncludeCaption = true;
                }
                column(Location_Address; Address)
                {
                    IncludeCaption = true;
                }
                column(Location_Address2; "Address 2")
                {
                    IncludeCaption = true;
                }
                column(Location_City; City)
                {
                    IncludeCaption = true;
                }
                column(Location_PhoneNo; "Phone No.")
                {
                    IncludeCaption = true;
                }
                column(Location_PhoneNo2; "Phone No. 2")
                {
                    IncludeCaption = true;
                }
                column(Location_PostCode; "Post Code")
                {
                    IncludeCaption = true;
                }
                column(Location_County; County)
                {
                    IncludeCaption = true;
                }
                column(Location_EMail; "E-Mail")
                {
                    IncludeCaption = true;
                }
                column(Location_HomePage; "Home Page")
                {
                    IncludeCaption = true;
                }
                column(Location_CountryRegionCode; "Country/Region Code")
                {
                    IncludeCaption = true;
                }
            }
            dataitem(ServiceLineLabor; "Service Line EDMS")
            {
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                DataItemTableView = sorting(Type, "No.") order(ascending) where(Type = const(Labor));
                column(ReportForNavId_25006118; 25006118)
                {
                }
                column(ServiceLineLabor_Type; Type)
                {
                    IncludeCaption = true;
                }
                column(ServiceLineLabor_No; "No.")
                {
                    IncludeCaption = true;
                }
                column(ServiceLineLabor_Description; Description)
                {
                    IncludeCaption = true;
                }
                column(ServiceLineLabor_Description2; "Description 2")
                {
                    IncludeCaption = true;
                }
                column(ServiceLineLabor_UnitofMeasureCode; "Unit of Measure Code")
                {
                    IncludeCaption = true;
                }
                column(ServiceLineLabor_UnitofMeasure; "Unit of Measure")
                {
                    IncludeCaption = true;
                }
                column(ServiceLineLabor_Quantity; Quantity)
                {
                    IncludeCaption = true;
                }
                column(ServiceLineLabor_UnitPrice; "Unit Price")
                {
                    IncludeCaption = true;
                }
                column(ServiceLineLabor_VATRate; "VAT %")
                {
                    IncludeCaption = true;
                }
                column(ServiceLineLabor_LineDiscountRate; "Line Discount %")
                {
                    IncludeCaption = true;
                }
                column(ServiceLineLabor_LineDiscountAmount; "Line Discount Amount")
                {
                    IncludeCaption = true;
                }
                column(ServiceLineLabor_Amount; Amount)
                {
                    IncludeCaption = true;
                }
                column(ServiceLineLabor_AmountIncludingVAT; "Amount Including VAT")
                {
                    IncludeCaption = true;
                }
                column(ServiceLineLabor_LineAmount; "Line Amount")
                {
                    AutoFormatType = 0;
                    DecimalPlaces = 2 : 2;
                    IncludeCaption = true;
                }
                column(ServiceLineLabor_VariantCode; "Variant Code")
                {
                    IncludeCaption = true;
                }
                column(ServiceLineLabor_SymptomCode; "Symptom Code")
                {
                    IncludeCaption = true;
                }
                column(LaborTotalExclVAT; LaborTotalExclVAT)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    LaborTotalExclVAT += Amount;
                end;

                trigger OnPreDataItem()
                begin
                    LaborTotalExclVAT := 0;
                end;
            }
            dataitem(ServiceLineItem; "Service Line EDMS")
            {
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                DataItemTableView = sorting(Type, "No.") order(ascending) where(Type = filter(<> Labor));
                column(ReportForNavId_25006170; 25006170)
                {
                }
                column(ServiceLineItem_Type; Type)
                {
                    IncludeCaption = true;
                }
                column(ServiceLineItem_No; "No.")
                {
                    IncludeCaption = true;
                }
                column(ServiceLineItem_Description; Description)
                {
                    IncludeCaption = true;
                }
                column(ServiceLineItem_Description2; "Description 2")
                {
                    IncludeCaption = true;
                }
                column(ServiceLineItem_UnitofMeasureCode; "Unit of Measure Code")
                {
                    IncludeCaption = true;
                }
                column(ServiceLineItem_UnitofMeasure; "Unit of Measure")
                {
                    IncludeCaption = true;
                }
                column(ServiceLineItem_Quantity; Quantity)
                {
                    IncludeCaption = true;
                }
                column(ServiceLineItem_UnitPrice; "Unit Price")
                {
                    IncludeCaption = true;
                }
                column(ServiceLineItem_VATRate; "VAT %")
                {
                    IncludeCaption = true;
                }
                column(ServiceLineItem_LineDiscountRate; "Line Discount %")
                {
                    IncludeCaption = true;
                }
                column(ServiceLineItem_LineDiscountAmount; "Line Discount Amount")
                {
                    IncludeCaption = true;
                }
                column(ServiceLineItem_Amount; Amount)
                {
                    IncludeCaption = true;
                }
                column(ServiceLineItem_AmountIncludingVAT; "Amount Including VAT")
                {
                    IncludeCaption = true;
                }
                column(ServiceLineItem_LineAmount; "Line Amount")
                {
                    DecimalPlaces = 2 : 2;
                    IncludeCaption = true;
                }
                column(ServiceLineItem_VariantCode; "Variant Code")
                {
                    IncludeCaption = true;
                }
                column(ServiceLineItem_SymptomCode; "Symptom Code")
                {
                    IncludeCaption = true;
                }
                column(ItemTotalExclVAT; ItemTotalExclVAT)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    ItemTotalExclVAT += Amount;
                end;

                trigger OnPreDataItem()
                begin
                    ItemTotalExclVAT := 0;
                end;
            }
            dataitem(VATAmountLine; "VAT Amount Line")
            {
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
                //ServPost.GetServiceLines("Service Header EDMS",ServLine,0);
                ServLine.CalcVATAmountLines(0, "Service Header EDMS", ServLine, VATAmountLine);
                ServLine.UpdateVATOnLines(0, "Service Header EDMS", ServLine, VATAmountLine);
                //ServPost.GetServiceLines("Service Header EDMS",TempServLineDisc,1);
                TempServLineDisc.CalcVATAmountLines(1, "Service Header EDMS", TempServLineDisc, VATAmountLine);
                TempServLineDisc.UpdateVATOnLines(1, "Service Header EDMS", TempServLineDisc, VATAmountLine);
                ServLine."Inv. Discount Amount" := VATAmountLine."Invoice Discount Amount";
                TotalVATAmount := VATAmountLine.GetTotalVATAmount;
                TotalVATBase := VATAmountLine.GetTotalVATBase;
                TotalVATDiscountAmount :=
                  VATAmountLine.GetTotalVATDiscount("Service Header EDMS"."Currency Code", "Service Header EDMS"."Prices Including VAT");
                TotalAmountInclVAT := VATAmountLine.GetTotalAmountInclVAT;

                DocumentDate := Format("Document Date", 9);
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
}

