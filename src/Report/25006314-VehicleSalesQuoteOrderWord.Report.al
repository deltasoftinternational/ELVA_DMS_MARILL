Report 25006314 "Vehicle Sales Quote/Order Word"
{
    RDLCLayout = './Layouts/VehicleSalesQuoteOrderWord.rdlc';
    WordLayout = './Layouts/VehicleSalesQuoteOrderWord.docx';
    DefaultLayout = Word;
    WordMergeDataItem = "Sales Header";

    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            CalcFields = Picture;
            DataItemTableView = sorting("Primary Key") order(ascending);
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
        dataitem("Sales Header"; "Sales Header")
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
            column(VIN; VIN)
            {
                IncludeCaption = true;
            }
            column(VehicleRegistrationNo; "Vehicle Registration No.")
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
            dataitem(Location; Location)
            {
                DataItemLink = Code = field("Location Code");
                DataItemTableView = sorting(Code) order(ascending);
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
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                column(ReportForNavId_25006170; 25006170)
                {
                }
                column(SalesLine_Type; Type)
                {
                    IncludeCaption = true;
                }
                column(SalesLine_No; "No.")
                {
                    IncludeCaption = true;
                }
                column(SalesLine_Description; Description)
                {
                    IncludeCaption = true;
                }
                column(SalesLine_Description2; "Description 2")
                {
                    IncludeCaption = true;
                }
                column(SalesLine_UnitofMeasureCode; "Unit of Measure Code")
                {
                    IncludeCaption = true;
                }
                column(SalesLine_UnitofMeasure; "Unit of Measure")
                {
                    IncludeCaption = true;
                }
                column(SalesLine_Quantity; Quantity)
                {
                    IncludeCaption = true;
                }
                column(SalesLine_UnitPrice; "Unit Price")
                {
                    IncludeCaption = true;
                }
                column(SalesLine_VATRate; "VAT %")
                {
                    IncludeCaption = true;
                }
                column(SalesLine_LineDiscountRate; "Line Discount %")
                {
                    IncludeCaption = true;
                }
                column(SalesLine_LineDiscountAmount; "Line Discount Amount")
                {
                    IncludeCaption = true;
                }
                column(SalesLine_Amount; Amount)
                {
                    IncludeCaption = true;
                }
                column(SalesLine_AmountIncludingVAT; "Amount Including VAT")
                {
                    IncludeCaption = true;
                }
                column(SalesLine_LineAmount; "Line Amount")
                {
                    DecimalPlaces = 2 : 2;
                    IncludeCaption = true;
                }
                column(SalesLine_VariantCode; "Variant Code")
                {
                    IncludeCaption = true;
                }
                dataitem(Vehicle; Vehicle)
                {
                    DataItemLink = "Serial No." = field("Vehicle Serial No.");
                    DataItemTableView = sorting("Serial No.") order(ascending);
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
                    column(SerialNo; "Serial No.")
                    {
                        IncludeCaption = true;
                    }
                }
                dataitem(VehicleAssemblyLine; "Vehicle Assembly Line")
                {
                    DataItemLink = "Serial No." = field("Vehicle Serial No."), "Assembly ID" = field("Vehicle Assembly ID");
                    DataItemTableView = order(ascending) where("Option Type" = filter(<> "Vehicle Base"));
                    column(ReportForNavId_25006008; 25006008)
                    {
                    }
                    column(VehicleAssemblyOptionType; "Option Type")
                    {
                        IncludeCaption = true;
                    }
                    column(VehicleAssemblyDescription; Description)
                    {
                        IncludeCaption = true;
                    }
                    column(VehicleAssemblyLineOptionCode; "Option Code")
                    {
                        IncludeCaption = true;
                    }
                }
            }
            dataitem(VATAmountLine; "VAT Amount Line")
            {
                DataItemTableView = sorting("VAT Identifier", "VAT Calculation Type", "Tax Group Code", "Use Tax", Positive) order(ascending);
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
                DataItemTableView = sorting(Type, "No.", "Line No.") order(ascending);
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
                DataItemTableView = sorting("No.") order(ascending);
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
                DataItemTableView = sorting("No.") order(ascending);
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
                DataItemTableView = sorting("No.") order(ascending);
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
                DataItemTableView = sorting("No.") order(ascending);
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

                Clear(SalesLine);
                Clear(SalesPost);
                SalesLine.DeleteAll;
                VATAmountLine.DeleteAll;
                SalesPost.GetSalesLines("Sales Header", SalesLine, 0);
                SalesLine.CalcVATAmountLines(0, "Sales Header", SalesLine, VATAmountLine);
                SalesLine.UpdateVATOnLines(0, "Sales Header", SalesLine, VATAmountLine);

                TotalVATAmount := VATAmountLine.GetTotalVATAmount;
                TotalVATBase := VATAmountLine.GetTotalVATBase;
                TotalVATDiscountAmount :=
                  VATAmountLine.GetTotalVATDiscount("Sales Header"."Currency Code", "Sales Header"."Prices Including VAT");
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
    }

    var
        CurrencyCode: Code[10];
        GLSetup: Record "General Ledger Setup";
        TotalVATBase: Decimal;
        TotalVATAmount: Decimal;
        TotalVATDiscountAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        DocumentDate: Text;
        SalesLine: Record "Sales Line" temporary;
        SalesPost: Codeunit "Sales-Post";
}

