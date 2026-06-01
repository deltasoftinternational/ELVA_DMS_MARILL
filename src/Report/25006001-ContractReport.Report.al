Report 25006001 "Contract Report"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/ContractReport.rdlc';
    Caption = 'Contract Report';

    dataset
    {
        dataitem(Contract; Contract)
        {
            RequestFilterFields = "Contract No.", "Bill-to Customer No.";
            column(ReportForNavId_1461; 1461)
            {
            }
            column(HeaderText; HeaderText)
            {
            }
            column(ContractNo_Contract; "Contract No.")
            {
                IncludeCaption = true;
            }
            column(Name_CompanyInfo; CompanyInfo.Name)
            {
                IncludeCaption = true;
            }
            column(Name2_CompanyInfo; CompanyInfo."Name 2")
            {
            }
            column(Address_CompanyInfo; CompanyAddress)
            {
            }
            column(VATRegNo_CompanyInfo; CompanyInfo."VAT Registration No.")
            {
                IncludeCaption = true;
            }
            column(BillToCustNo_Contract; "Bill-to Customer No.")
            {
                IncludeCaption = true;
            }
            column(BillToName_Contract; "Bill-to Name")
            {
                IncludeCaption = true;
            }
            column(BillToName2_Contract; "Bill-to Name 2")
            {
            }
            column(BillToCustAddress_Contract; BillToCustAddress)
            {
            }
            column(VATRegNo_Customer; Customer."VAT Registration No.")
            {
                IncludeCaption = true;
            }
            column(Description_Contract; Description)
            {
                IncludeCaption = true;
            }
            column(Description2_Contract; "Description 2")
            {
            }
            column(Status_Contract; Status)
            {
                IncludeCaption = true;
            }
            column(StartingDate_Contract; "Starting Date")
            {
                IncludeCaption = true;
            }
            column(ExpirationDate_Contract; "Expiration Date")
            {
                IncludeCaption = true;
            }
            column(CurrencyCode_Contract; "Currency Code")
            {
                IncludeCaption = true;
            }
            column(CancelReasonCode_Contract; "Cancel Reason Code")
            {
                IncludeCaption = true;
            }
            dataitem("Contract Signer"; "Contract Signer")
            {
                DataItemLink = "Contract No." = field("Contract No.");
                DataItemTableView = sorting("Contract Type", "Contract No.", "Contract Line No.");
                PrintOnlyIfDetail = false;
                column(ReportForNavId_1689; 1689)
                {
                }
                column(Contract_Signer_Contract_Type; "Contract Type")
                {
                }
                column(Contract_Signer_Contract_No; "Contract No.")
                {
                }
                column(Contract_Signer_Contract_Line_No; "Contract Line No.")
                {
                }
                column(Contract_Signer__Contact_No; "Contact No.")
                {
                    IncludeCaption = true;
                }
                column(Contract_Signer__Signer_Name; "Signer Name")
                {
                    IncludeCaption = true;
                }
                column(Contract_Signer__Signer_Social_Security_No; "Signer Social Security No.")
                {
                    IncludeCaption = true;
                }
                column(Contract_Signer__Signer_Phone_No; "Signer Phone No.")
                {
                    IncludeCaption = true;
                }
                column(Contract_Signer__Signer_E_Mail; "Signer E-Mail")
                {
                    IncludeCaption = true;
                }
            }
            dataitem("Contract Sales Price"; "Contract Sales Price")
            {
                DataItemLink = "Contract No." = field("Contract No.");
                DataItemTableView = sorting("Contract Type", "Contract No.", Type, Code, "Starting Date", "Currency Code", "Variant Code", "Unit of Measure Code", "Minimum Quantity", "Ordering Price Type Code", "Location Code", "Document Profile", "Vehicle Serial No.");
                column(ReportForNavId_2844; 2844)
                {
                }
                column(Contract_Sales_Price_Contract_Type; "Contract Type")
                {
                    IncludeCaption = true;
                }
                column(Contract_Sales_Price_Contract_No_; "Contract No.")
                {
                    IncludeCaption = true;
                }
                column(Contract_Sales_Price_Code; Code)
                {
                    IncludeCaption = true;
                }
                column(Contract_Sales_Price__Currency_Code_; "Currency Code")
                {
                    IncludeCaption = true;
                }
                column(Contract_Sales_Price__UOM_Code_; "Unit of Measure Code")
                {
                    IncludeCaption = true;
                }
                column(Contract_Sales_Price__Minimum_Quantity_; "Minimum Quantity")
                {
                    IncludeCaption = true;
                }
                column(Contract_Sales_Price__Ordering_Price_Type_Code_; "Ordering Price Type Code")
                {
                    IncludeCaption = true;
                }
                column(Contract_Sales_Price__Location_Code_; "Location Code")
                {
                    IncludeCaption = true;
                }
                column(Contract_Sales_Price__Unit_Price_; "Unit Price")
                {
                    IncludeCaption = true;
                }
                column(Contract_Sales_Price__Price_Includes_VAT_; Format("Price Includes VAT"))
                {
                }
                column(Contract_Sales_Price_Type; Type)
                {
                    IncludeCaption = true;
                }
                column(Contract_Sales_Price_Starting_Date; "Starting Date")
                {
                }
                column(Contract_Sales_Price_Ending_Date; "Ending Date")
                {
                }
                column(Contract_Sales_Price_Variant_Code; "Variant Code")
                {
                }
                column(Contract_Sales_Price_Document_Profile; "Document Profile")
                {
                }
                column(Contract_Sales_Price_Vehicle_Serial_No_; "Vehicle Serial No.")
                {
                }
            }
            dataitem("Contract Sales Line Discount"; "Contract Sales Line Discount")
            {
                DataItemLink = "Contract No." = field("Contract No.");
                DataItemTableView = sorting("Contract Type", "Contract No.", "Line No.");
                column(ReportForNavId_4511; 4511)
                {
                }
                column(Contract_Sales_Line_Discount_Contract_Type; "Contract Type")
                {
                }
                column(Contract_Sales_Line_Discount_Contract_No_; "Contract No.")
                {
                }
                column(Contract_Sales_Line_Discount_Line_No_; "Line No.")
                {
                }
                column(Contract_Sales_Line_Discount_Type; Type)
                {
                    IncludeCaption = true;
                }
                column(Contract_Sales_Line_Discount__No; "No.")
                {
                    IncludeCaption = true;
                }
                column(Contract_Sales_Line_Discount_Description; Description)
                {
                    IncludeCaption = true;
                }
                column(Contract_Sales_Line_Discount__Line_Discount; "Line Discount %")
                {
                    IncludeCaption = true;
                }
                column(Contract_Sales_Line_Discount_VIN; VIN)
                {
                    IncludeCaption = true;
                }

                trigger OnAfterGetRecord()
                begin
                    CalcFields(VIN);
                end;
            }

            trigger OnAfterGetRecord()
            begin

                CalcFields("Bill-to Name", "Bill-to Name 2", "Bill-to Address", "Bill-to Address 2", "Bill-to Post Code");
                CalcFields("Bill-to City", "Bill-to County");

                Customer.Get(Contract."Bill-to Customer No.");

                if "Bill-to Address" <> '' then
                    BillToCustAddress := "Bill-to Address";
                if "Bill-to Address 2" <> '' then
                    BillToCustAddress := BillToCustAddress + ', ' + "Bill-to Address 2";
                if "Bill-to City" <> '' then
                    BillToCustAddress := BillToCustAddress + ', ' + "Bill-to City";
                if "Bill-to Post Code" <> '' then
                    BillToCustAddress := BillToCustAddress + ', ' + "Bill-to Post Code";
                if "Bill-to County" <> '' then
                    BillToCustAddress := BillToCustAddress + ', ' + "Bill-to County";

                if CompanyInfo.Address <> '' then
                    CompanyAddress := CompanyInfo.Address;
                if CompanyInfo."Address 2" <> '' then
                    BillToCustAddress := CompanyAddress + ', ' + CompanyInfo."Address 2";
                if CompanyInfo.City <> '' then
                    CompanyAddress := CompanyAddress + ', ' + CompanyInfo.City;
                if CompanyInfo."Post Code" <> '' then
                    CompanyAddress := CompanyAddress + ', ' + CompanyInfo."Post Code";
                if CompanyInfo.County <> '' then
                    CompanyAddress := CompanyAddress + ', ' + CompanyInfo.County;

                if "Document Profile" = "document profile"::" " then
                    HeaderText := StrSubstNo(Text001, "Contract No.")
                else
                    HeaderText := Format("Document Profile") + ' ' + StrSubstNo(Text001, "Contract No.");
            end;

            trigger OnPreDataItem()
            begin
                CompanyInfo.Get;
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
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
        ReportTitleLbl = 'Service Contract No.';
        ContractSalesPriceLbl = 'Contract Sales Price(s)';
        ContractSignerLbl = 'Contract Signer(s)';
        ContractSalesPricesLbl = 'Contract Sales Price(s)';
        ContractSaleLineDiscLbl = 'Contract Sales Line Discount(s)';
        CustNameLbl = 'Customer Name';
        CustSignatureLbl = 'Customer Signature';
        VendorNameLbl = 'Vendor Name';
        VendorSignatureLbl = 'Vendor Signature';
        CompanyAddressLbl = 'Address';
        BillToCustNoLbl = 'Customer No.';
        BillToAddreLbl = 'Address';
        BillToNameLbl = 'Name';
        VATRegNoLbl = 'VAT Registration No.';
        PriceInclVATlbl = 'Price Includes VAT';
    }

    var
        Text001: label 'Contract No. %1';
        CompanyInfo: Record "Company Information";
        Customer: Record Customer;
        BillToCustAddress: Text[250];
        CompanyAddress: Text[250];
        HeaderText: Text[250];
        RowNr: Integer;
        RowNr2: Integer;
}

