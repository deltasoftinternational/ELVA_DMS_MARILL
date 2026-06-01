Table 25006627 "Posted Rent Transfer Header"
{
    LookupPageID = "Posted Rent Transfer List";

    fields
    {
        field(20; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(30; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(40; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(50; "Order Date"; Date)
        {
            Caption = 'Order Date';
        }
        field(60; "Posting Date"; Date)
        {
            Caption = 'Posting Date';

            trigger OnValidate()
            var
                NoSeries: Record "No. Series";
            begin
            end;
        }
        field(70; "Posting Description"; Text[50])
        {
            Caption = 'Posting Description';
        }
        field(80; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(85; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(90; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(95; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Released';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment";
        }
        field(100; "Payment Discount %"; Decimal)
        {
            Caption = 'Payment Discount %';
            DecimalPlaces = 0 : 5;
        }
        field(110; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        field(120; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(130; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(140; "Posting No."; Code[20])
        {
            Caption = 'Posting No.';
        }
        field(150; "Posting No. Series"; Code[20])
        {
            Caption = 'Posting No. Series';
        }
        field(160; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;
        }
        field(170; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            NotBlank = true;
            TableRelation = Customer;
        }
        field(180; "Bill-to Name"; Text[100])
        {
            Caption = 'Bill-to Name';
        }
        field(190; "Bill-to Name 2"; Text[50])
        {
            Caption = 'Bill-to Name 2';
        }
        field(200; "Bill-to Address"; Text[50])
        {
            Caption = 'Bill-to Address';
        }
        field(210; "Bill-to Address 2"; Text[50])
        {
            Caption = 'Bill-to Address 2';
        }
        field(220; "Bill-to City"; Text[30])
        {
            Caption = 'Bill-to City';
        }
        field(230; "Bill-to Contact"; Text[100])
        {
            Caption = 'Bill-to Contact';
        }
        field(240; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code where("Customer No." = field("Sell-to Customer No."));
        }
        field(250; "Ship-to Name"; Text[100])
        {
            Caption = 'Ship-to Name';
        }
        field(260; "Ship-to Name 2"; Text[50])
        {
            Caption = 'Ship-to Name 2';
        }
        field(270; "Ship-to Address"; Text[100])
        {
            Caption = 'Ship-to Address';
        }
        field(280; "Ship-to Address 2"; Text[50])
        {
            Caption = 'Ship-to Address 2';
        }
        field(290; "Ship-to City"; Text[30])
        {
            Caption = 'Ship-to City';
        }
        field(300; "Ship-to Contact"; Text[100])
        {
            Caption = 'Ship-to Contact';
        }
        field(310; "Sell-to Customer Name"; Text[100])
        {
            Caption = 'Sell-to Customer Name';
        }
        field(320; "Sell-to Customer Name 2"; Text[50])
        {
            Caption = 'Sell-to Customer Name 2';
        }
        field(330; "Sell-to Address"; Text[100])
        {
            Caption = 'Sell-to Address';
        }
        field(340; "Sell-to Address 2"; Text[50])
        {
            Caption = 'Sell-to Address 2';
        }
        field(350; "Sell-to City"; Text[30])
        {
            Caption = 'Sell-to City';
        }
        field(360; "Sell-to Contact"; Text[100])
        {
            Caption = 'Sell-to Contact';
        }
        field(370; "Bill-to Post Code"; Code[20])
        {
            Caption = 'Bill-to Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(380; "Bill-to County"; Text[30])
        {
            Caption = 'Bill-to County';
        }
        field(390; "Bill-to Country/Region Code"; Code[10])
        {
            Caption = 'Bill-to Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(400; "Sell-to Post Code"; Code[20])
        {
            Caption = 'Sell-to Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(410; "Sell-to County"; Text[30])
        {
            Caption = 'Sell-to County';
        }
        field(420; "Sell-to Country/Region Code"; Code[10])
        {
            Caption = 'Sell-to Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(430; "Ship-to Post Code"; Code[20])
        {
            Caption = 'Ship-to Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(440; "Ship-to County"; Text[30])
        {
            Caption = 'Ship-to County';
        }
        field(450; "Ship-to Country/Region Code"; Code[10])
        {
            Caption = 'Ship-to Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(460; "Sell-to Customer Template Code"; Code[10])
        {
            Caption = 'Sell-to Customer Template Code';
            TableRelation = "Customer Templ.";

            trigger OnValidate()
            var
                SellToCustTemplate: Record "Customer Templ.";
            begin
            end;
        }
        field(470; "Sell-to Contact No."; Code[20])
        {
            Caption = 'Sell-to Contact No.';
            TableRelation = Contact;

            trigger OnLookup()
            var
                Cont: Record Contact;
                ContBusinessRelation: Record "Contact Business Relation";
            begin
            end;

            trigger OnValidate()
            var
                ContBusinessRelation: Record "Contact Business Relation";
                Cont: Record Contact;
                Opportunity: Record Opportunity;
            begin
            end;
        }
        field(475; "Bill-to Contact No."; Code[20])
        {
            Caption = 'Bill-to Contact No.';
            TableRelation = Contact;

            trigger OnLookup()
            var
                Cont: Record Contact;
                ContBusinessRelation: Record "Contact Business Relation";
            begin
            end;

            trigger OnValidate()
            var
                ContBusinessRelation: Record "Contact Business Relation";
                Cont: Record Contact;
            begin
            end;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDimensions;
            end;
        }
        field(490; "Bill-to Customer Template Code"; Code[20])
        {
            Caption = 'Bill-to Customer Template Code';
            TableRelation = "Customer Templ.";
        }
        field(500; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(510; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(520; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(530; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
        }
        field(540; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
        }
        field(550; "Shipping Advice"; Option)
        {
            Caption = 'Shipping Advice';
            OptionCaption = 'Partial,Complete';
            OptionMembers = Partial,Complete;
        }
        field(560; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(570; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(580; "Bank Account No."; Text[30])
        {
            Caption = 'Bank Account No.';
            TableRelation = "Bank Account"."No.";
        }
        field(590; "Customer Posting Group"; Code[10])
        {
            Caption = 'Customer Posting Group';
            Editable = false;
            TableRelation = "Customer Posting Group";
        }
        field(600; "Customer Price Group"; Code[20])
        {
            Caption = 'Customer Price Group';
            TableRelation = "Customer Price Group";
        }
        field(610; "Prices Including VAT"; Boolean)
        {
            Caption = 'Prices Including VAT';

            trigger OnValidate()
            var
                SalesLine: Record "Sales Line";
                Currency: Record Currency;
                JobPostLine: Codeunit "Job Post-Line";
                RecalculatePrice: Boolean;
            begin
            end;
        }
        field(620; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Line Disc.';
        }
        field(630; "Invoice Disc. Code"; Code[20])
        {
            Caption = 'Invoice Disc. Code';
        }
        field(640; "Customer Disc. Group"; Code[20])
        {
            Caption = 'Customer Disc. Group';
            TableRelation = "Customer Discount Group";
        }
        field(650; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(660; "Salesperson Code"; Code[10])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(670; "Combine Shipments"; Boolean)
        {
            Caption = 'Combine Shipments';
        }
        field(680; Reserve; Option)
        {
            Caption = 'Reserve';
            OptionCaption = 'Never,Optional,Always';
            OptionMembers = Never,Optional,Always;
        }
        field(690; "Prepayment %"; Decimal)
        {
            Caption = 'Prepayment %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(700; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
        }
        field(710; "Shipment Method Code"; Code[10])
        {
            Caption = 'Shipment Method Code';
            TableRelation = "Shipment Method";
        }
        field(720; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";
        }
        field(730; "Shipping Agent Service Code"; Code[10])
        {
            Caption = 'Shipping Agent Service Code';
            TableRelation = "Shipping Agent Services".Code where("Shipping Agent Code" = field("Shipping Agent Code"));
        }
        field(740; "VAT Country/Region Code"; Code[10])
        {
            Caption = 'VAT Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(750; "Shipping No."; Code[20])
        {
            Caption = 'Shipping No.';
        }
        field(770; "Last Shipping No."; Code[20])
        {
            Caption = 'Last Shipping No.';
            Editable = false;
            TableRelation = "Sales Shipment Header";
        }
        field(780; "Last Posting No."; Code[20])
        {
            Caption = 'Last Posting No.';
            Editable = false;
            TableRelation = "Sales Invoice Header";
        }
        field(790; "Shipping No. Series"; Code[20])
        {
            Caption = 'Shipping No. Series';
            TableRelation = "No. Series";
        }
        field(800; "Return Receipt No."; Code[20])
        {
            Caption = 'Return Receipt No.';
        }
        field(810; "Return Receipt No. Series"; Code[20])
        {
            Caption = 'Return Receipt No. Series';
            TableRelation = "No. Series";
        }
        field(820; "Prepayment No."; Code[20])
        {
            Caption = 'Prepayment No.';
        }
        field(840; "Prepmt. Cr. Memo No."; Code[20])
        {
            Caption = 'Prepmt. Cr. Memo No.';
        }
        field(850; "Prepayment No. Series"; Code[20])
        {
            Caption = 'Prepayment No. Series';
            TableRelation = "No. Series";
        }
        field(860; "Prepmt. Cr. Memo No. Series"; Code[20])
        {
            Caption = 'Prepmt. Cr. Memo No. Series';
            TableRelation = "No. Series";
        }
        field(870; "Opportunity No."; Code[20])
        {
            Caption = 'Opportunity No.';
            TableRelation = Opportunity."No." where("Contact No." = field("Sell-to Contact No."),
                                                     Closed = const(false));

            trigger OnValidate()
            var
                Opportunity: Record Opportunity;
                SalesHeader: Record "Sales Header";
            begin
            end;
        }
        field(880; "Assigned User ID"; Code[20])
        {
            Caption = 'Assigned User ID';
            TableRelation = "User Setup";
        }
        field(890; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(900; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';
        }
        field(910; "VAT Base Discount %"; Decimal)
        {
            Caption = 'VAT Base Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(920; "Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type';
            TableRelation = "Transaction Type";
        }
        field(930; "Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
            TableRelation = "Transport Method";
        }
        field(940; "Exit Point"; Code[10])
        {
            Caption = 'Exit Point';
            TableRelation = "Entry/Exit Point";
        }
        field(950; "Area"; Code[10])
        {
            Caption = 'Area';
            TableRelation = Area;
        }
        field(960; "Transaction Specification"; Code[10])
        {
            Caption = 'Transaction Specification';
            TableRelation = "Transaction Specification";
        }
        field(970; "Shipping Time"; DateFormula)
        {
            Caption = 'Shipping Time';
        }
        field(980; "Requested Delivery Date"; Date)
        {
            Caption = 'Requested Delivery Date';
        }
        field(990; "Promised Delivery Date"; Date)
        {
            Caption = 'Promised Delivery Date';
        }
        field(1000; "Outbound Whse. Handling Time"; DateFormula)
        {
            Caption = 'Outbound Whse. Handling Time';
        }
        field(1010; "Sale Quote No."; Code[10])
        {
            Caption = 'Sale Quote No.';
            Editable = false;
        }
        field(1020; "Transfer-from Code"; Code[10])
        {
            Caption = 'Transfer-from Code';
            TableRelation = Location where("Use As In-Transit" = const(false));

            trigger OnValidate()
            var
                Location: Record Location;
                Confirmed: Boolean;
            begin
            end;
        }
        field(1030; "Transfer-to Code"; Code[10])
        {
            Caption = 'Transfer-to Code';
            TableRelation = Location where("Use As In-Transit" = const(false));

            trigger OnValidate()
            var
                Location: Record Location;
                Confirmed: Boolean;
            begin
            end;
        }
        field(1040; "In-Transit Code"; Code[10])
        {
            Caption = 'In-Transit Code';
            TableRelation = Location where("Use As In-Transit" = const(true));
        }
        field(1050; "Rent Order No."; Code[20])
        {
            Caption = 'Rent Order No.';
            //TableRelation = Table25006622;
        }
        field(1060; "Rent Order Type"; Option)
        {
            Caption = 'Rent Order Type';
            OptionMembers = Quote,"Order","Return Order";
        }
        field(1070; "Transfer Type"; Option)
        {
            Caption = 'Transfer Type';
            OptionMembers = Shipment,Receipt,Internal;
        }
        field(1080; "Bill-to Mobile Phone No."; Text[30])
        {
            Caption = 'Bill-to Mobile Phone No.';
        }
        field(1090; "Ship-to Mobile Phone No."; Text[30])
        {
            Caption = 'Ship-to Mobile Phone No.';
        }
        field(1100; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = Contract."Contract No." where("Bill-to Customer No." = field("Bill-to Customer No."));
        }
        field(99008500; "Date Received"; Date)
        {
            Caption = 'Date Received';
        }
        field(99008501; "Time Received"; Time)
        {
            Caption = 'Time Received';
        }
        field(1200; "Shipment Time"; Time)
        {
            Caption = 'Shipment Time';
            DataClassification = ToBeClassified;
        }
        field(25006393; "Customer Signature Image"; Blob)
        {
            Caption = 'Signature Image';
        }
        field(25006394; "Customer Signature Text"; Text[100])
        {
            Caption = 'Signature Text';
        }
        field(25006395; "Employee Signature Image"; Blob)
        {
            Caption = 'Signature Image';
        }
        field(25006396; "Employee Signature Text"; Text[100])
        {
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        RentSetup.Get;
        if "No." = '' then begin
            "No. Series" := RentSetup."Rent Shipment Nos.";
            "No." := NoSeriesMgt.GetNextNo("No. Series", "Posting Date", true);
        end;
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        RentSetup: Record "Rent Mgt. Setup";
        RentShipmentHeader: Record "Rent Transfer Header";
        RentShipmentLine: Record "Rent Transfer Line";
        CustLedgEntry: Record "Cust. Ledger Entry";
        Cust: Record Customer;
        ReservEntry: Record "Reservation Entry";
        TempReservEntry: Record "Reservation Entry" temporary;
        TempReqLine: Record "Requisition Line" temporary;
        PostCode: Record "Post Code";
        ShipToAddr: Record "Ship-to Address";
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        RespCenter: Record "Responsibility Center";
        Location: Record Location;
        CompanyInfo: Record "Company Information";
        CurrExchRate: Record "Currency Exchange Rate";
        SalesLineReserve: Codeunit "Sales Line-Reserve";
        NoSeriesMgt: Codeunit "No. Series";
        DimMgt: Codeunit DimensionManagement;
        TransferExtendedText: Codeunit "Transfer Extended Text";
        GLSetup: Record "General Ledger Setup";
        HideValidationDialog: Boolean;
        Confirmed: Boolean;
        Text000: label 'Do you want to print shipment %1?';
        Text001: label 'Do you want to print invoice %1?';
        Text002: label 'Do you want to print credit memo %1?';
        Text003: label 'You cannot rename a %1.';
        Text004: label 'Do you want to change %1?';
        Text005: label 'You cannot reset %1 because the document still has one or more lines.';
        Text006: label 'You cannot change %1 because the order is associated with one or more purchase orders.';
        Text007: label '%1 cannot be greater than %2 in the %3 table.';
        Text008: label 'Deleting this document will cause a gap in the number series for shipments. ';
        Text009: label 'An empty shipment %1 will be created to fill this gap in the number series.\\';
        Text010: label 'Do you want to continue?';
        Text011: label 'Deleting this document will cause a gap in the number series for posted invoices. ';
        Text012: label 'An empty posted invoice %1 will be created to fill this gap in the number series.\\';
        Text013: label 'Deleting this document will cause a gap in the number series for posted credit memos. ';
        Text014: label 'An empty posted credit memo %1 will be created to fill this gap in the number series.\\';
        Text015: label 'If you change %1, the existing sales lines will be deleted and new sales lines based on the new information on the header will be created.\\';
        Text017: label 'You must delete the existing sales lines before you can change %1.';
        Text018: label 'You have changed %1 on the sales header, but it has not been changed on the existing sales lines.\';
        Text019: label 'You must update the existing sales lines manually.';
        Text020: label 'The change may affect the exchange rate used in the price calculation of the sales lines.';
        Text021: label 'Do you want to update the exchange rate?';
        Text022: label 'You cannot delete this document. Your identification is set up to process from %1 %2 only.';
        Text023: label 'Do you want to print return receipt %1?';
        Text024: label 'You have modified the %1 field. Note that the recalculation of VAT may cause penny differences, so you must check the amounts afterwards. ';
        Text026: label 'Do you want to update the %2 field on the lines to reflect the new value of %1?';
        Text027: label 'Your identification is set up to process from %1 %2 only.';
        Text028: label 'You cannot change the %1 when the %2 has been filled in.';
        Text029: label 'Deleting this document will cause a gap in the number series for return receipts. ';
        Text030: label 'An empty return receipt %1 will be created to fill this gap in the number series.\\';
        Text031: label 'You have modified %1.\\';
        Text032: label 'Do you want to update the lines?';
        Text035: label 'You cannot Release Quote or Make Order unless you specify a customer on the quote.\\Do you want to create customer(s) now?';
        Text037: label 'Contact %1 %2 is not related to customer %3.';
        Text038: label 'Contact %1 %2 is related to a different company than customer %3.';
        Text039: label 'Contact %1 %2 is not related to a customer.';
        Text040: label 'A won opportunity is linked to this order.\';
        Text041: label 'It has to be changed to status Lost before the Order can be deleted.\';
        Text042: label 'Do you want to change the status for this opportunity now?';
        Text043: label 'Wizard Aborted';
        Text044: label 'The status of the opportunity has not been changed. The program has aborted deleting the order.';
        Text045: label 'You can not change the %1 field because %2 %3 has %4 = %5 and the %6 has already been assigned %7 %8.';
        Text046: label 'You cannot delete invoice %1 because one or more service ledger entries exist for this invoice.';
        Text047: label 'You cannot change %1 because reservation, item tracking, or order tracking exists on the sales order.';
        Text048: label 'Sales quote %1 has already been assigned to opportunity %2. Would you like to reassign this quote?';
        Text049: label 'The %1 field cannot be blank because this quote is linked to an opportunity.';
        Text050: label 'If %1 is %2 in sales order no. %3, then all sales lines where type is %4 must use the same location.';
        Text051: label 'The sales %1 %2 already exists.';
        Text052: label 'The sales %1 %2 has item tracking. Do you want to delete it anyway?';
        Text053: label 'You must cancel the approval process if you wish to change the %1.';
        Text054: label 'The sales %1 %2 has item tracking. Do you want to delete it anyway?';
        Text055: label 'Deleting this document will cause a gap in the number series for prepayment invoices. ';
        Text056: label 'An empty prepayment invoice %1 will be created to fill this gap in the number series.\\';
        Text057: label 'Deleting this document will cause a gap in the number series for prepayment credit memos. ';
        Text058: label 'An empty prepayment credit memo %1 will be created to fill this gap in the number series.\\';
        Text059: label 'Do you want to print prepayment invoice %1?';
        Text060: label 'Do you want to print prepayment credit memo %1?';
        Text061: label '%1 is set up to process from %2 %3 only.';
        Text199: label 'You cannot delete %1 %2 because one or more transfers exist.';
        Text062: label 'Promotion Code %1 is not in the valid period of promotion code %2.';
        Text063: label 'Promotion Code %1 is not released.';
        Text125: label 'Do You want to link this vehice to contact No. %1?';
        Text200: label 'Model version No. %1 cost is not adjusted. Do you want to continue?';
        VehicleConfirm: label 'There is a vehicle linked to this contact.\%1 %2\%3 %4\%5 %6\Do you want to apply this vehicle?';
        COntactConfirm: label 'There is a customer linked to this vehicle.\%1 %2\Do you want to apply this customer?';
        SkipSellToContact: Boolean;
        SkipBillToContact: Boolean;
        HideSubConfirmDialog: Boolean;
        InsertMode: Boolean;
        UserMgt: Codeunit "User Setup Management";
        CurrencyDate: Date;

    local procedure GetCust(CustNo: Code[20])
    begin
        if CustNo <> '' then begin
            if CustNo <> Cust."No." then
                Cust.Get(CustNo);
        end else
            Clear(Cust);
    end;

    procedure ShowDimensions()
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', TableCaption, "No."));
    end;
}

