Report 25006105 "Spare Parts Proforma Invoice"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/SparePartsProformaInvoice.rdlc';
    Caption = 'Proforma Invoice';

    dataset
    {
        dataitem("Company Information"; "Company Information")
        {
            CalcFields = "Invoice Header Picture", "Invoice Footer Picture";
            DataItemTableView = sorting("Primary Key");
            column(ReportForNavId_25006000; 25006000)
            {
            }
            column(Company_Name; Name)
            {
            }
            column(Company_Address; Address)
            {
            }
            column(Company_Address_2; "Address 2")
            {
            }
            column(Company_City; City)
            {
            }
            column(Company_Post_Code; "Post Code")
            {
            }
            column(Company_VAT_Registration_No; "VAT Registration No.")
            {
            }
            column(Company_Phone_No; "Phone No.")
            {
            }
            column(Company_E_Mail; "E-Mail")
            {
            }
            column(Company_Home_Page; "Home Page")
            {
            }
            column(Company_Invoice_Header_Picture; "Invoice Header Picture")
            {
            }
            column(Company_Invoice_Footer_Picture; "Invoice Footer Picture")
            {
            }
            column(ShowDiscount; ShowDiscount)
            {
            }
        }
        dataitem("Sales Header"; "Sales Header")
        {
            column(ReportForNavId_25006011; 25006011)
            {
            }
            column(Sell_to_Customer_No; "Sell-to Customer No.")
            {
            }
            column(Sell_to_Customer_Name; "Sell-to Customer Name")
            {
            }
            column(Sell_to_Address; "Sell-to Address")
            {
            }
            column(Sell_to_Address_2; "Sell-to Address 2")
            {
            }
            column(Sell_to_City; "Sell-to City")
            {
            }
            column(Sell_to_County; "Sell-to County")
            {
            }
            column(Sell_to_Post_Code; "Sell-to Post Code")
            {
            }
            column(Sell_to_Country_Region_Code; "Sell-to Country/Region Code")
            {
            }
            column(Ship_to_Name; "Ship-to Name")
            {
            }
            column(Ship_to_Address; "Ship-to Address")
            {
            }
            column(Ship_to_Address_2; "Ship-to Address 2")
            {
            }
            column(Ship_to_City; "Ship-to City")
            {
            }
            column(External_Document_No_; "External Document No.")
            {
            }
            column(No_; "No.")
            {
            }
            column(Order_Date; "Order Date")
            {
            }
            column(Vehicle_Registration_No; "Vehicle Registration No.")
            {
            }
            column(Due_Date; "Due Date")
            {
            }
            column(Make_Name; Make.Name)
            {
            }
            column(Model_Commercial_Name; Model."Commercial Name")
            {
            }
            column(Payment_Terms_Description; PaymentTerms.Description)
            {
            }
            column(Shipment_Method_Description; ShipmentMethod.Description)
            {
            }
            column(Salesperson_Name; Salesperson.Name)
            {
            }
            column(Location_Name; Location.Name)
            {
            }
            column(Location_Address; Location.Address)
            {
            }
            column(Location_Address_2; Location."Address 2")
            {
            }
            column(Location_City; Location.City)
            {
            }
            column(Location_County; Location.County)
            {
            }
            column(Location_Country_Region_Code; Location."Country/Region Code")
            {
            }
            column(Country_Name; Country.Name)
            {
            }
            column(TotalAmountInclVAT; TotalAmountInclVAT)
            {
            }
            column(TotalVATBase; TotalVATBase)
            {
            }
            column(TotalExclVATTxt; TotalExclVATTxt)
            {
            }
            column(TotalInclVATTxt; TotalInclVATTxt)
            {
            }
            dataitem("Sales Line"; "Sales Line")
            {
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                column(ReportForNavId_25006034; 25006034)
                {
                }
                column(Sales_Line_No; "No.")
                {
                }
                column(Sales_Line_Bin_Code; "Bin Code")
                {
                    IncludeCaption = true;
                }
                column(Sales_Line_Description; Description)
                {
                    IncludeCaption = true;
                }
                column(Sales_Line_Quantity; Quantity)
                {
                    IncludeCaption = true;
                }
                column(Sales_Line_Unit_Price; "Unit Price")
                {
                    IncludeCaption = true;
                }
                column(Sales_Line_Discount_Pr; "Line Discount %")
                {
                }
                column(Sales_Line_Amount; Amount)
                {
                }
                column(NetPrice; NetPrice)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    if Quantity <> 0 then
                        NetPrice := Amount / Quantity
                    else
                        NetPrice := 0;
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
                column(VATTxt; VATTxt)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    VATTxt := StrSubstNo(VATLbl, "VAT %");
                end;
            }

            trigger OnAfterGetRecord()
            begin
                if Make.Get("Make Code") then;
                if Model.Get("Make Code", "Model Code") then;
                if PaymentTerms.Get("Payment Terms Code") then;
                if Location.Get("Location Code") then;
                if Salesperson.Get("Salesperson Code") then;
                if ShipmentMethod.Get("Shipment Method Code") then;
                if Country.Get(Location."Country/Region Code") then;

                if "Currency Code" = '' then
                    CurrencyCode := GLSetup."LCY Code"
                else
                    CurrencyCode := "Currency Code";
                VATAmountLine.DeleteAll;
                SalesLine.Reset;
                SalesLine.SetRange("Document Type", "Document Type");
                SalesLine.SetRange("Document No.", "No.");
                if SalesLine.FindFirst then;
                SalesLine.CalcVATAmountLines(1, "Sales Header", SalesLine, VATAmountLine);
                TotalVATAmount := VATAmountLine.GetTotalVATAmount;
                TotalVATBase := VATAmountLine.GetTotalVATBase;
                TotalVATDiscountAmount :=
                  VATAmountLine.GetTotalVATDiscount("Sales Header"."Currency Code", "Sales Header"."Prices Including VAT");
                TotalAmountInclVAT := VATAmountLine.GetTotalAmountInclVAT;

                TotalExclVATTxt := StrSubstNo(TotalExclVATLbl, CurrencyCode);
                TotalInclVATTxt := StrSubstNo(TotalInclVATLbl, CurrencyCode);
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
                    field(ShowDiscount; ShowDiscount)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Discount';
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
        DocumentNameTxt = 'Invoice';
        NoLbl = 'No.';
        ContactLbl = 'Contact:';
        CustomerLbl = 'Customer';
        ShipToLbl = 'Delivery Address';
        ExternalDocNoLbl = 'Customer Order No.:';
        ShipmentMethodLbl = 'Freight:';
        PaymentMethodLbl = 'Payment:';
        MakeLbl = 'Make:';
        ModelLbl = 'Model:';
        VehicleRegNoLbl = 'Vehicle Reg. No.:';
        LineNoLbl = 'Line No.';
        ItemNoLbl = 'Part number';
        TelLbl = 'Tel:';
        EmailLbl = 'Email:';
        WebLbl = 'Web:';
        VATRegNoLbl = 'V.A.T. No.:';
        PageLbl = 'Page';
        ofLbl = 'of';
        DiscountLbl = 'Discount %';
        IssueDateLbl = 'Issue date';
        CustomerNoLbl = 'Customer No.';
        NetPriceLbl = 'Net Price';
        LineValueLbl = 'Line Value';
        DueDateLbl = 'Due';
    }

    trigger OnPreReport()
    begin
        GLSetup.Get;
    end;

    var
        Make: Record Make;
        Model: Record Model;
        PaymentTerms: Record "Payment Terms";
        ShipmentMethod: Record "Shipment Method";
        Salesperson: Record "Salesperson/Purchaser";
        Location: Record Location;
        Country: Record "Country/Region";
        ShowDiscount: Boolean;
        CurrencyCode: Code[10];
        GLSetup: Record "General Ledger Setup";
        SalesLine: Record "Sales Line";
        TempSalesLineDisc: Record "Sales Line Discount" temporary;
        TotalVATAmount: Decimal;
        TotalVATBase: Decimal;
        TotalVATDiscountAmount: Decimal;
        TotalAmountInclVAT: Decimal;
        TotalExclVATLbl: label 'Total %1 Excl. VAT';
        TotalInclVATLbl: label 'Total %1 Incl. VAT';
        VATLbl: label 'Total VAT %1 %';
        TotalExclVATTxt: Text;
        TotalInclVATTxt: Text;
        VATTxt: Text;
        NetPrice: Decimal;
}

