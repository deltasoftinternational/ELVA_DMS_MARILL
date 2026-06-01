Report 25006107 "Spare Parts Purch. Quote/Order"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/SparePartsPurchQuoteOrder.rdlc';
    Caption = 'Purchase Quote\Order';

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
        }
        dataitem("Purchase Header"; "Purchase Header")
        {
            column(ReportForNavId_25006011; 25006011)
            {
            }
            column(Buy_from_Vendor_No; "Buy-from Vendor No.")
            {
            }
            column(Buy_from_Vendor_Name; "Buy-from Vendor Name")
            {
            }
            column(Buy_from_Address; "Buy-from Address")
            {
            }
            column(Buy_from_Address_2; "Buy-from Address 2")
            {
            }
            column(Buy_from_City; "Buy-from City")
            {
            }
            column(Buy_from_County; "Buy-from County")
            {
            }
            column(Buy_from_Post_Code; "Buy-from Post Code")
            {
            }
            column(Buy_from_Country_Region_Code; "Buy-from Country/Region Code")
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
            column(No_; "No.")
            {
            }
            column(Order_Date; "Order Date")
            {
            }
            column(Expected_Receipt_Date; "Expected Receipt Date")
            {
            }
            column(Requested_Receipt_Date; "Requested Receipt Date")
            {
            }
            column(Shipment_Method_Description; ShipmentMethod.Description)
            {
            }
            column(Payment_Terms_Description; PaymentTerms.Description)
            {
            }
            column(Purchaser_Name; Purchaser.Name)
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
            column(DocumentName; DocumentName)
            {
            }
            column(LineNo; LineNo)
            {
            }
            dataitem("Purchase Line"; "Purchase Line")
            {
                DataItemLink = "Document Type" = field("Document Type"), "Document No." = field("No.");
                column(ReportForNavId_25006034; 25006034)
                {
                }
                column(Purchase_Line_No; "No.")
                {
                }
                column(Purchase_Line_Description; Description)
                {
                    IncludeCaption = true;
                }
                column(Purchase_Line_Description_2; "Description 2")
                {
                    IncludeCaption = true;
                }
                column(Purchase_Line_Quantity; Quantity)
                {
                    IncludeCaption = true;
                }
                column(Purchase_Line_Direct_Unit_Cost; "Direct Unit Cost")
                {
                    IncludeCaption = true;
                }
                column(Purchase_Line_Amount; Amount)
                {
                }
                column(Purchase_Line_Vendor_Item_No; "Vendor Item No.")
                {
                    IncludeCaption = true;
                }
                column(ShoVendorItemNo; ShoVendorItemNoTxt)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    DocumentName := StrSubstNo(DocumentNameTxt, Format("Document Type"));
                    LineNo += 1;
                    if ShoVendorItemNo then
                        ShoVendorItemNoTxt := 'T'
                    else
                        ShoVendorItemNoTxt := 'F';
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
                if PaymentTerms.Get("Payment Terms Code") then;
                if Purchaser.Get("Purchaser Code") then;
                if ShipmentMethod.Get("Shipment Method Code") then;
                if Country.Get(Location."Country/Region Code") then;

                if "Currency Code" = '' then
                    CurrencyCode := GLSetup."LCY Code"
                else
                    CurrencyCode := "Currency Code";
                VATAmountLine.DeleteAll;
                PurchaseLine.Reset;
                PurchaseLine.SetRange("Document Type", "Document Type");
                PurchaseLine.SetRange("Document No.", "No.");
                if PurchaseLine.FindFirst then;
                PurchaseLine.CalcVATAmountLines(0, "Purchase Header", PurchaseLine, VATAmountLine);
                TotalVATAmount := VATAmountLine.GetTotalVATAmount;
                TotalVATBase := VATAmountLine.GetTotalVATBase;
                TotalVATDiscountAmount :=
                  VATAmountLine.GetTotalVATDiscount("Purchase Header"."Currency Code", "Purchase Header"."Prices Including VAT");
                TotalAmountInclVAT := VATAmountLine.GetTotalAmountInclVAT;

                TotalExclVATTxt := StrSubstNo(TotalExclVATLbl, CurrencyCode);
                TotalInclVATTxt := StrSubstNo(TotalInclVATLbl, CurrencyCode);

                LineNo := 0;
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
                group(General)
                {
                    field(ShoVendorItemNo; ShoVendorItemNo)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Show Vendor Item No.';
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
        NoLbl = 'No';
        ContactLbl = 'Contact:';
        VendorLbl = 'Vendor';
        ShipToLbl = 'Ship to';
        ExternalDocNoLbl = 'Customer Order No.:';
        ShipmentMethodLbl = 'Shipment Method';
        PaymentMethodLbl = 'Delivery Terms';
        LineNoLbl = 'Line No.';
        ItemNoLbl = 'Part number';
        TelLbl = 'Tel:';
        EmailLbl = 'Email:';
        WebLbl = 'Web:';
        VATRegNoLbl = 'V.A.T. No.:';
        PageLbl = 'Page';
        ofLbl = 'of';
        IssueDateLbl = 'Date';
        LineValueLbl = 'Line Total';
        ExpectedReceiptDateLbl = 'Delivery Date';
        DirectUnitCostLbl = 'Unit Price';
        DocumentLbl = 'Document';
    }

    trigger OnPreReport()
    begin
        GLSetup.Get;
    end;

    var
        PaymentTerms: Record "Payment Terms";
        ShipmentMethod: Record "Shipment Method";
        Purchaser: Record "Salesperson/Purchaser";
        Location: Record Location;
        Country: Record "Country/Region";
        CurrencyCode: Code[10];
        GLSetup: Record "General Ledger Setup";
        PurchaseLine: Record "Purchase Line";
        TempPurchLineDisc: Record "Purchase Line Discount" temporary;
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
        DocumentNameTxt: label 'Purchase %1';
        DocumentName: Text;
        LineNo: Integer;
        ShoVendorItemNo: Boolean;
        ShoVendorItemNoTxt: Text;
}

