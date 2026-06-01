Report 25006103 "Dispatch Note"
{
    DefaultLayout = RDLC;
    RDLCLayout = './Layouts/DispatchNote.rdlc';
    Caption = 'Dispatch Note';

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
                IncludeCaption = true;
            }
            column(Vehicle_Registration_No; "Vehicle Registration No.")
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
                }
                column(Sales_Line_Qty_to_Ship; "Qty. to Ship")
                {
                }
                column(Sales_Line_Quantity_Shipped; "Quantity Shipped")
                {
                }
                column(LineNo; LineNo)
                {
                }

                trigger OnAfterGetRecord()
                begin
                    LineNo += 1;
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
                LineNo := 0;
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
        DocumentNameTxt = 'Dispatch note';
        ContactLbl = 'Contact:';
        CustomerLbl = 'Customer';
        ShipToLbl = 'Delivery to';
        ExternalDocNoLbl = 'Cust. ref.:';
        ShipmentMethodLbl = 'Freight:';
        PaymentMethodLbl = 'Payment:';
        MakeLbl = 'Make:';
        ModelLbl = 'Model:';
        VehicleRegNoLbl = 'Vehicle Reg. No.:';
        LineNoLbl = 'Line No.';
        ItemNoLbl = 'Part number';
        QuantityLbl = 'Ordered';
        QtyToShipLbl = 'Alloc.';
        QtyOutstdLbl = 'Backorder';
        TelLbl = 'Tel:';
        EmailLbl = 'Email:';
        WebLbl = 'Web:';
        DeliveredLbl = 'Delivered';
        VATRegNoLbl = 'V.A.T. No.:';
        PageLbl = 'Page';
        ofLbl = 'of';
        LocationLbl = 'Delivery from';
    }

    var
        Make: Record Make;
        Model: Record Model;
        PaymentTerms: Record "Payment Terms";
        ShipmentMethod: Record "Shipment Method";
        Salesperson: Record "Salesperson/Purchaser";
        Location: Record Location;
        LineNo: Integer;
        Country: Record "Country/Region";
}

