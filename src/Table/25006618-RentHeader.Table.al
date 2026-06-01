Table 25006618 "Rent Header"
{
    LookupPageID = "Rent Order List";
    DataCaptionFields = "No.", "Sell-to Customer Name";

    fields
    {
        field(10; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionMembers = Quote,"Order","Return Order";
        }
        field(20; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if RentSetup."PstDoc. Num. equal Doc. Num." then
                    case "Document Type" of
                        "document type"::Order:
                            "Posting No." := "No.";
                        "document type"::"Return Order":
                            "Posting No." := "No.";
                    end
            end;
        }
        field(25; "Rent Type"; Option)
        {
            Caption = 'Rent Type';
            OptionCaption = 'Set End Date,Open End Date';
            OptionMembers = "Set End Date","Open End Date";
            trigger OnValidate()
            var
                RentLine: Record "Rent Line";
            begin
                if "Rent Type" = "Rent Type"::"Open End Date" then begin
                    RentLine.Reset();
                    RentLine.SetRange("Document Type", "Document Type");
                    RentLine.SetRange("Document No.", "No.");
                    if RentLine.FindFirst() then
                        repeat
                            RentLine."Rent End Date" := 0D;
                            RentLine."Planned Return Date" := 0D;
                            RentLine.Modify();
                        until RentLine.Next() = 0;
                end;
            end;
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
                Validate("Document Date", "Posting Date");
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

            trigger OnValidate()
            begin
                Validate("Payment Terms Code");
            end;
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
        field(97; "Document Status"; Code[20])
        {
            Caption = 'Document Status';
            TableRelation = "Document Status".Code where("Document Type" = field("Document Type"),
                                                          "Document Profile" = const(Rent));
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

            trigger OnValidate()
            begin
                CreateDim(
                  Database::Customer, "Bill-to Customer No.",
                  Database::"Salesperson/Purchaser", "Salesperson Code",
                  Database::"Responsibility Center", "Responsibility Center",
                  Database::"Deal Type", "Deal Type",
                  Database::Location, "Location Code"
                  );
            end;
        }
        field(120; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
                Modify;
            end;
        }
        field(130; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
                Modify;
            end;
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

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if ("Sell-to Customer No." <> xRec."Sell-to Customer No.") and
                   (xRec."Sell-to Customer No." <> '')
                then begin
                    if HideValidationDialog or not GuiAllowed then
                        Confirmed := true
                    else
                        Confirmed := Confirm(Text004, false, FieldCaption("Sell-to Customer No."));
                    if Confirmed then begin
                        RentLine.SetRange("Document Type", "Document Type");
                        RentLine.SetRange("Document No.", "No.");
                        if "Sell-to Customer No." = '' then begin
                            if RentLine.FindFirst then
                                Error(
                                  Text005,
                                  FieldCaption("Sell-to Customer No."));
                            Init;
                            RentSetup.Get;
                            "No. Series" := xRec."No. Series";
                            InitRecord;
                            if xRec."Posting No." <> '' then begin
                                "Posting No. Series" := xRec."Posting No. Series";
                                "Posting No." := xRec."Posting No.";
                            end;
                            exit;
                        end;
                        RentLine.Reset
                    end else begin
                        Rec := xRec;
                        exit;
                    end;
                end;

                GetCust("Sell-to Customer No.");

                Cust.CheckBlockedCustOnDocs(Cust, "Document Type", false, false);
                Cust.TestField("Gen. Bus. Posting Group");
                "Sell-to Customer Template Code" := '';
                "Sell-to Customer Name" := Cust.Name;
                "Sell-to Customer Name 2" := Cust."Name 2";
                "Sell-to Address" := Cust.Address;
                "Sell-to Address 2" := Cust."Address 2";
                "Sell-to City" := Cust.City;
                "Sell-to Post Code" := Cust."Post Code";
                "Sell-to County" := Cust.County;

                if not SkipSellToContact then
                    "Sell-to Contact" := Cust.Contact;
                "Gen. Bus. Posting Group" := Cust."Gen. Bus. Posting Group";
                "VAT Bus. Posting Group" := Cust."VAT Bus. Posting Group";
                "Tax Area Code" := Cust."Tax Area Code";
                "Tax Liable" := Cust."Tax Liable";
                "VAT Registration No." := Cust."VAT Registration No.";
                "Shipping Advice" := Cust."Shipping Advice";
                "Responsibility Center" := UserMgt.GetRespCenter(0, Cust."Responsibility Center");

                if Cust."Bill-to Customer No." <> '' then
                    Validate("Bill-to Customer No.", Cust."Bill-to Customer No.")
                else begin
                    if "Bill-to Customer No." = "Sell-to Customer No." then
                        SkipBillToContact := true;
                    Validate("Bill-to Customer No.", "Sell-to Customer No.");
                    SkipBillToContact := false;
                end;
                Validate("Ship-to Code", '');

                if (xRec."Sell-to Customer No." <> "Sell-to Customer No.") or
                   (xRec."Currency Code" <> "Currency Code") or
                   (xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group") or
                   (xRec."VAT Bus. Posting Group" <> "VAT Bus. Posting Group")
                then
                    RecreateSalesLines(FieldCaption("Sell-to Customer No."));
            end;
        }
        field(170; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            NotBlank = true;
            TableRelation = Customer;

            trigger OnValidate()
            var
                RentItemLine: Record "Rent Sales Line";
            begin
                TestField(Status, Status::Open);
                if (xRec."Bill-to Customer No." <> "Bill-to Customer No.") and
                   (xRec."Bill-to Customer No." <> '')
                then begin
                    BilltoCustomerNoChanged := xRec."Bill-to Customer No." <> "Bill-to Customer No.";
                    if HideValidationDialog or not GuiAllowed then
                        Confirmed := true
                    else
                        Confirmed := Confirm(Text004, false, FieldCaption("Bill-to Customer No."));
                    if Confirmed then begin
                        RentSalesLine.SetRange("Document Type", "Document Type");
                        RentSalesLine.SetRange("Document No.", "No.");
                        if "Document Type" = "document type"::Order then
                            RentSalesLine.SetFilter("Quantity Shipped", '<>0');

                        if RentSalesLine.FindFirst then
                            if "Document Type" = "document type"::Order then
                                RentSalesLine.TestField("Quantity Shipped", 0)
                            else
                                RentSalesLine.TestField("Shipment No.", '');
                        RentSalesLine.SetRange("Shipment No.");
                        RentSalesLine.SetRange("Quantity Shipped");

                        if "Document Type" = "document type"::"Return Order" then
                            RentSalesLine.SetFilter("Return Qty. Received", '<>0');

                        if RentSalesLine.FindFirst then
                            if "Document Type" = "document type"::"Return Order" then
                                RentSalesLine.TestField("Return Qty. Received", 0)
                            else
                                RentSalesLine.TestField("Return Receipt No.", '');
                        RentSalesLine.Reset
                    end else begin
                        "Bill-to Customer No." := xRec."Bill-to Customer No.";
                    end;
                end;

                GetCust("Bill-to Customer No.");
                Cust.CheckBlockedCustOnDocs(Cust, "Document Type", false, false);
                Cust.TestField("Customer Posting Group");

                CheckCrLimit;

                if GuiAllowed and (CurrFieldNo <> 0) then begin
                    "Amount Including VAT" := 0;
                    case "Document Type" of
                        //"Document Type"::Quote:
                        //CustCheckCreditLimit.RentHeaderCheck(Rec,FALSE);
                        "document type"::Order:
                            begin
                                if "Bill-to Customer No." <> xRec."Bill-to Customer No." then begin
                                    RentItemLine.SetRange("Document Type", RentItemLine."document type"::Order);
                                    RentItemLine.SetRange("Document No.", "No.");
                                    RentItemLine.CalcSums("Outstanding Amount", "Dimension Set ID");
                                    "Amount Including VAT" := RentItemLine."Outstanding Amount" + RentItemLine."Dimension Set ID";
                                end;
                                //CustCheckCreditLimit.RentHeaderCheck(Rec,FALSE);
                            end;
                    end;
                    CalcFields("Amount Including VAT");
                end;

                "Bill-to Customer Template Code" := '';
                "Bill-to Name" := Cust.Name;
                "Bill-to Name 2" := Cust."Name 2";
                "Bill-to Address" := Cust.Address;
                "Bill-to Address 2" := Cust."Address 2";
                "Bill-to City" := Cust.City;
                "Bill-to Post Code" := Cust."Post Code";
                "Bill-to County" := Cust.County;
                "Bill-to Country/Region Code" := Cust."Country/Region Code";
                if not SkipBillToContact then
                    "Bill-to Contact" := Cust.Contact;
                "Payment Terms Code" := Cust."Payment Terms Code";

                "Gen. Bus. Posting Group" := Cust."Gen. Bus. Posting Group";
                GLSetup.Get;
                if GLSetup."Bill-to/Sell-to VAT Calc." = GLSetup."bill-to/sell-to vat calc."::"Bill-to/Pay-to No." then
                    "VAT Bus. Posting Group" := Cust."VAT Bus. Posting Group";
                "Customer Posting Group" := Cust."Customer Posting Group";
                "Currency Code" := Cust."Currency Code";
                "Customer Price Group" := Cust."Customer Price Group";
                "Prices Including VAT" := Cust."Prices Including VAT";
                "Allow Line Disc." := Cust."Allow Line Disc.";
                "Invoice Disc. Code" := Cust."Invoice Disc. Code";
                "Customer Disc. Group" := Cust."Customer Disc. Group";
                "Language Code" := Cust."Language Code";
                "Salesperson Code" := Cust."Salesperson Code";
                "Combine Shipments" := Cust."Combine Shipments";
                Reserve := Cust.Reserve;
                "VAT Registration No." := Cust."VAT Registration No.";
                if "Document Type" = "document type"::Order then
                    "Prepayment %" := Cust."Prepayment %";

                Validate("Payment Terms Code");
                Validate("Payment Method Code");
                Validate("Currency Code");

                if (xRec."Sell-to Customer No." = "Sell-to Customer No.") and
                   (xRec."Bill-to Customer No." <> "Bill-to Customer No.")
                then
                    RecreateSalesLines(FieldCaption("Bill-to Customer No."));

                if not SkipBillToContact then
                    UpdateBillToCont("Bill-to Customer No.");

                //>>DELTA XX
                OnAfterValidateBillToCustomerNo(rec, Cust);
                //<<DELTA XX
                CreateDim(
                  Database::Customer, "Bill-to Customer No.",
                  Database::"Salesperson/Purchaser", "Salesperson Code",
                  Database::"Responsibility Center", "Responsibility Center",
                  Database::"Deal Type", "Deal Type",
                  Database::Location, "Location Code"
                  );
            end;
        }
        field(180; "Bill-to Name"; Text[100])
        {
            Caption = 'Bill-to Name';
            TableRelation = Customer.Name;
            ValidateTableRelation = false;
            trigger OnLookup()
            var
                Customer: Record Customer;
            begin
                if "Bill-to Customer No." <> '' then
                    Customer.Get("Bill-to Customer No.");

                //if Customer.LookupCustomer(Customer) then begin
                if Customer.SelectCustomer(Customer) then begin
                    "Bill-to Name" := Customer.Name;
                    Validate("Bill-to Customer No.", Customer."No.");
                end;
            end;

            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                if ShouldLookForCustomerByName("Bill-to Customer No.") then
                    Validate("Bill-to Customer No.", Customer.GetCustNo("Bill-to Name"));
            end;
        }
        field(190; "Bill-to Name 2"; Text[100])
        {
            Caption = 'Bill-to Name 2';
        }
        field(200; "Bill-to Address"; Text[100])
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

            trigger OnValidate()
            begin
                if "Date Received" = 0D then
                    PostCode.ValidateCity("Bill-to City", "Bill-to Post Code", "Bill-to County", "Bill-to Country/Region Code", true);
            end;
        }
        field(230; "Bill-to Contact"; Text[100])
        {
            Caption = 'Bill-to Contact';
            trigger OnLookup()
            var
                Contact: Record Contact;
            begin
                LookupContact("Bill-to Customer No.", "Bill-to Contact No.", Contact);
                if PAGE.RunModal(0, Contact) = ACTION::LookupOK then
                    Validate("Bill-to Contact No.", Contact."No.");
            end;
        }
        field(240; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code where("Customer No." = field("Sell-to Customer No."));

            trigger OnValidate()
            begin
                if ("Document Type" = "document type"::Order) and
                   (xRec."Ship-to Code" <> "Ship-to Code")
                then begin
                    RentSalesLine.SetRange("Document Type", RentSalesLine."document type"::Order);
                    RentSalesLine.SetRange("Document No.", "No.");
                    RentSalesLine.SetFilter("Purch. Order Line No.", '<>0');
                    if not RentSalesLine.IsEmpty then
                        Error(
                          Text006,
                          FieldCaption("Ship-to Code"));
                    RentSalesLine.Reset;
                end;

                if ("Document Type" <> "document type"::"Return Order") then begin
                    if "Ship-to Code" <> '' then begin
                        if xRec."Ship-to Code" <> '' then begin
                            GetCust("Sell-to Customer No.");
                            "Tax Area Code" := Cust."Tax Area Code";
                        end;
                        ShipToAddr.Get("Sell-to Customer No.", "Ship-to Code");
                        "Ship-to Name" := ShipToAddr.Name;
                        "Ship-to Name 2" := ShipToAddr."Name 2";
                        "Ship-to Address" := ShipToAddr.Address;
                        "Ship-to Address 2" := ShipToAddr."Address 2";
                        "Ship-to City" := ShipToAddr.City;
                        "Ship-to Post Code" := ShipToAddr."Post Code";
                        "Ship-to County" := ShipToAddr.County;
                        Validate("Ship-to Country/Region Code", ShipToAddr."Country/Region Code");
                        "Ship-to Contact" := ShipToAddr.Contact;
                        "Shipment Method Code" := ShipToAddr."Shipment Method Code";
                        "Shipping Agent Code" := ShipToAddr."Shipping Agent Code";
                        "Shipping Agent Service Code" := ShipToAddr."Shipping Agent Service Code";
                        if ShipToAddr."Tax Area Code" <> '' then
                            "Tax Area Code" := ShipToAddr."Tax Area Code";
                        "Tax Liable" := ShipToAddr."Tax Liable";
                    end else
                        if "Sell-to Customer No." <> '' then begin
                            GetCust("Sell-to Customer No.");
                            "Ship-to Name" := Cust.Name;
                            "Ship-to Name 2" := Cust."Name 2";
                            "Ship-to Address" := Cust.Address;
                            "Ship-to Address 2" := Cust."Address 2";
                            "Ship-to City" := Cust.City;
                            "Ship-to Post Code" := Cust."Post Code";
                            "Ship-to County" := Cust.County;
                            Validate("Ship-to Country/Region Code", Cust."Country/Region Code");
                            "Ship-to Contact" := Cust.Contact;
                            "Shipment Method Code" := Cust."Shipment Method Code";
                            "Tax Area Code" := Cust."Tax Area Code";
                            "Tax Liable" := Cust."Tax Liable";
                            "Shipping Agent Code" := Cust."Shipping Agent Code";
                            "Shipping Agent Service Code" := Cust."Shipping Agent Service Code";
                        end;
                end;

                if (xRec."Sell-to Customer No." = "Sell-to Customer No.") and
                   (xRec."Ship-to Code" <> "Ship-to Code")
                then
                    if (xRec."VAT Country/Region Code" <> "VAT Country/Region Code") or
                       (xRec."Tax Area Code" <> "Tax Area Code")
                    then
                        RecreateSalesLines(FieldCaption("Ship-to Code"))
                    else begin
                        if xRec."Shipping Agent Code" <> "Shipping Agent Code" then
                            MessageIfSalesLinesExist(FieldCaption("Shipping Agent Code"));
                        if xRec."Shipping Agent Service Code" <> "Shipping Agent Service Code" then
                            MessageIfSalesLinesExist(FieldCaption("Shipping Agent Service Code"));
                        if xRec."Tax Liable" <> "Tax Liable" then
                            Validate("Tax Liable");
                    end;
            end;
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

            trigger OnValidate()
            begin
                if "Date Received" = 0D then
                    PostCode.ValidateCity("Ship-to City", "Ship-to Post Code", "Ship-to County", "Ship-to Country/Region Code", true);
            end;
        }
        field(300; "Ship-to Contact"; Text[100])
        {
            Caption = 'Ship-to Contact';
        }
        field(310; "Sell-to Customer Name"; Text[100])
        {
            Caption = 'Sell-to Customer Name';
            TableRelation = Customer.Name;
            ValidateTableRelation = false;
            trigger OnLookup()
            var
                Customer: Record Customer;
            begin
                if "Sell-to Customer No." <> '' then
                    Customer.Get("Sell-to Customer No.");

                //if Customer.LookupCustomer(Customer) then begin
                if Customer.SelectCustomer(Customer) then begin
                    "Sell-to Customer Name" := Customer.Name;
                    Validate("Sell-to Customer No.", Customer."No.");
                end;
            end;

            trigger OnValidate()
            var
                Customer: Record Customer;
            begin
                if ShouldLookForCustomerByName("Sell-to Customer No.") then
                    Validate("Sell-to Customer No.", Customer.GetCustNo("Sell-to Customer Name"));
            end;
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

            trigger OnValidate()
            begin
                if "Date Received" = 0D then
                    PostCode.ValidateCity("Sell-to City", "Sell-to Post Code", "Sell-to County", "Sell-to Country/Region Code", true);
            end;
        }
        field(360; "Sell-to Contact"; Text[100])
        {
            Caption = 'Sell-to Contact';
            trigger OnLookup()
            var
                Contact: Record Contact;
            begin
                if "Document Type" <> "Document Type"::Quote then
                    if "Sell-to Customer No." = '' then
                        exit;

                LookupContact("Sell-to Customer No.", "Sell-to Contact No.", Contact);
                if PAGE.RunModal(0, Contact) = ACTION::LookupOK then
                    Validate("Sell-to Contact No.", Contact."No.");
            end;

        }
        field(370; "Bill-to Post Code"; Code[20])
        {
            Caption = 'Bill-to Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                if "Date Received" = 0D then
                    PostCode.ValidatePostCode("Bill-to City", "Bill-to Post Code", "Bill-to County", "Bill-to Country/Region Code", true);
            end;
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

            trigger OnValidate()
            begin
                if "Date Received" = 0D then
                    PostCode.ValidatePostCode("Sell-to City", "Sell-to Post Code", "Sell-to County", "Sell-to Country/Region Code", true);
            end;
        }
        field(410; "Sell-to County"; Text[30])
        {
            Caption = 'Sell-to County';
        }
        field(420; "Sell-to Country/Region Code"; Code[10])
        {
            Caption = 'Sell-to Country/Region Code';
            TableRelation = "Country/Region";

            trigger OnValidate()
            begin
                Validate("Ship-to Country/Region Code");
            end;
        }
        field(430; "Ship-to Post Code"; Code[20])
        {
            Caption = 'Ship-to Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            begin
                if "Date Received" = 0D then
                    PostCode.ValidatePostCode("Ship-to City", "Ship-to Post Code", "Ship-to County", "Ship-to Country/Region Code", true);
            end;
        }
        field(440; "Ship-to County"; Text[30])
        {
            Caption = 'Ship-to County';
        }
        field(450; "Ship-to Country/Region Code"; Code[10])
        {
            Caption = 'Ship-to Country/Region Code';
            TableRelation = "Country/Region";

            trigger OnValidate()
            begin
                if "Ship-to Country/Region Code" <> '' then
                    "VAT Country/Region Code" := "Ship-to Country/Region Code"
                else
                    "VAT Country/Region Code" := "Sell-to Country/Region Code"
            end;
        }
        field(460; "Sell-to Customer Template Code"; Code[10])
        {
            Caption = 'Sell-to Customer Template Code';
            TableRelation = "Customer Templ.";

            trigger OnValidate()
            var
                SellToCustTemplate: Record "Customer Templ.";
            begin
                TestField("Document Type", "document type"::Quote);
                TestField(Status, Status::Open);

                if not InsertMode and
                   ("Sell-to Customer Template Code" <> xRec."Sell-to Customer Template Code") and
                   (xRec."Sell-to Customer Template Code" <> '')
                then begin
                    if HideValidationDialog then
                        Confirmed := true
                    else
                        Confirmed := Confirm(Text004, false, FieldCaption("Sell-to Customer Template Code"));
                    if Confirmed then begin
                        RentSalesLine.Reset;
                        RentSalesLine.SetRange("Document Type", "Document Type");
                        RentSalesLine.SetRange("Document No.", "No.");
                        if "Sell-to Customer Template Code" = '' then begin
                            if not RentSalesLine.IsEmpty then
                                Error(Text005, FieldCaption("Sell-to Customer Template Code"));
                            Init;
                            SalesSetup.Get;
                            InitRecord;
                            "No. Series" := xRec."No. Series";
                            if xRec."Shipping No." <> '' then begin
                                "Shipping No. Series" := xRec."Shipping No. Series";
                                "Shipping No." := xRec."Shipping No.";
                            end;
                            if xRec."Posting No." <> '' then begin
                                "Posting No. Series" := xRec."Posting No. Series";
                                "Posting No." := xRec."Posting No.";
                            end;
                            if xRec."Return Receipt No." <> '' then begin
                                "Return Receipt No. Series" := xRec."Return Receipt No. Series";
                                "Return Receipt No." := xRec."Return Receipt No.";
                            end;

                            if xRec."Prepayment No." <> '' then begin
                                "Prepayment No. Series" := xRec."Prepayment No. Series";
                                "Prepayment No." := xRec."Prepayment No.";
                            end;
                            if xRec."Prepmt. Cr. Memo No." <> '' then begin
                                "Prepmt. Cr. Memo No. Series" := xRec."Prepmt. Cr. Memo No. Series";
                                "Prepmt. Cr. Memo No." := xRec."Prepmt. Cr. Memo No.";
                            end;

                            exit;
                        end;
                    end else begin
                        "Sell-to Customer Template Code" := xRec."Sell-to Customer Template Code";
                        exit;
                    end;
                end;

                if SellToCustTemplate.Get("Sell-to Customer Template Code") then begin
                    SellToCustTemplate.TestField("Gen. Bus. Posting Group");
                    "Gen. Bus. Posting Group" := SellToCustTemplate."Gen. Bus. Posting Group";
                    "VAT Bus. Posting Group" := SellToCustTemplate."VAT Bus. Posting Group";
                    if "Bill-to Customer No." = '' then
                        Validate("Bill-to Customer Template Code", "Sell-to Customer Template Code");
                end;

                if not InsertMode and
                   ((xRec."Sell-to Customer Template Code" <> "Sell-to Customer Template Code") or
                    (xRec."Currency Code" <> "Currency Code"))
                then
                    RecreateSalesLines(FieldCaption("Sell-to Customer Template Code"));
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
                if ("Sell-to Customer No." <> '') and Cont.Get("Sell-to Contact No.") then
                    Cont.SetRange("Company No.", Cont."Company No.")
                else
                    if "Sell-to Customer No." <> '' then begin
                        ContBusinessRelation.Reset;
                        ContBusinessRelation.SetCurrentkey("Link to Table", "No.");
                        ContBusinessRelation.SetRange("Link to Table", ContBusinessRelation."link to table"::Customer);
                        ContBusinessRelation.SetRange("No.", "Sell-to Customer No.");
                        if ContBusinessRelation.FindFirst then
                            Cont.SetRange("Company No.", ContBusinessRelation."Contact No.");
                    end else
                        Cont.SetFilter("Company No.", '<>''''');

                if "Sell-to Contact No." <> '' then
                    if Cont.Get("Sell-to Contact No.") then;
                if Page.RunModal(0, Cont) = Action::LookupOK then begin
                    xRec := Rec;
                    Validate("Sell-to Contact No.", Cont."No.");
                end;
            end;

            trigger OnValidate()
            var
                ContBusinessRelation: Record "Contact Business Relation";
                Cont: Record Contact;
                Opportunity: Record Opportunity;
            begin
                TestField(Status, Status::Open);

                if ("Sell-to Contact No." <> xRec."Sell-to Contact No.") and
                   (xRec."Sell-to Contact No." <> '')
                then begin
                    if ("Sell-to Contact No." = '') and ("Opportunity No." <> '') then
                        Error(Text049, FieldCaption("Sell-to Contact No."));
                    if HideValidationDialog then
                        Confirmed := true
                    else
                        Confirmed := Confirm(Text004, false, FieldCaption("Sell-to Contact No."));
                    if Confirmed then begin
                        RentSalesLine.Reset;
                        RentSalesLine.SetRange("Document Type", "Document Type");
                        RentSalesLine.SetRange("Document No.", "No.");
                        if ("Sell-to Contact No." = '') and ("Sell-to Customer No." = '') then begin
                            if not RentSalesLine.IsEmpty then
                                Error(Text005, FieldCaption("Sell-to Contact No."));
                            Init;
                            SalesSetup.Get;
                            InitRecord;
                            "No. Series" := xRec."No. Series";
                            if xRec."Shipping No." <> '' then begin
                                "Shipping No. Series" := xRec."Shipping No. Series";
                                "Shipping No." := xRec."Shipping No.";
                            end;
                            if xRec."Posting No." <> '' then begin
                                "Posting No. Series" := xRec."Posting No. Series";
                                "Posting No." := xRec."Posting No.";
                            end;
                            if xRec."Return Receipt No." <> '' then begin
                                "Return Receipt No. Series" := xRec."Return Receipt No. Series";
                                "Return Receipt No." := xRec."Return Receipt No.";
                            end;

                            if xRec."Prepayment No." <> '' then begin
                                "Prepayment No. Series" := xRec."Prepayment No. Series";
                                "Prepayment No." := xRec."Prepayment No.";
                            end;
                            if xRec."Prepmt. Cr. Memo No." <> '' then begin
                                "Prepmt. Cr. Memo No. Series" := xRec."Prepmt. Cr. Memo No. Series";
                                "Prepmt. Cr. Memo No." := xRec."Prepmt. Cr. Memo No.";
                            end;

                            exit;
                        end;
                        if "Opportunity No." <> '' then begin
                            Opportunity.Get("Opportunity No.");
                            if Opportunity."Contact No." <> "Sell-to Contact No." then begin
                                Modify;
                                Opportunity.Validate("Contact No.", "Sell-to Contact No.");
                                Opportunity.Modify;
                            end
                        end;
                    end else begin
                        Rec := xRec;
                        exit;
                    end;
                end;

                if ("Sell-to Customer No." <> '') and ("Sell-to Contact No." <> '') then begin
                    Cont.Get("Sell-to Contact No.");
                    ContBusinessRelation.Reset;
                    ContBusinessRelation.SetCurrentkey("Link to Table", "No.");
                    ContBusinessRelation.SetRange("Link to Table", ContBusinessRelation."link to table"::Customer);
                    ContBusinessRelation.SetRange("No.", "Sell-to Customer No.");
                    if ContBusinessRelation.FindFirst then
                        if ContBusinessRelation."Contact No." <> Cont."Company No." then
                            Error(Text038, Cont."No.", Cont.Name, "Sell-to Customer No.");
                end;

                UpdateSellToCust("Sell-to Contact No.");
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
                if ("Bill-to Customer No." <> '') and Cont.Get("Bill-to Contact No.") then
                    Cont.SetRange("Company No.", Cont."Company No.")
                else
                    if Cust.Get("Bill-to Customer No.") then begin
                        ContBusinessRelation.Reset;
                        ContBusinessRelation.SetCurrentkey("Link to Table", "No.");
                        ContBusinessRelation.SetRange("Link to Table", ContBusinessRelation."link to table"::Customer);
                        ContBusinessRelation.SetRange("No.", "Bill-to Customer No.");
                        if ContBusinessRelation.FindFirst then
                            Cont.SetRange("Company No.", ContBusinessRelation."Contact No.");
                    end else
                        Cont.SetFilter("Company No.", '<>''''');

                if "Bill-to Contact No." <> '' then
                    if Cont.Get("Bill-to Contact No.") then;
                if Page.RunModal(0, Cont) = Action::LookupOK then begin
                    xRec := Rec;
                    Validate("Bill-to Contact No.", Cont."No.");
                end;
            end;

            trigger OnValidate()
            var
                ContBusinessRelation: Record "Contact Business Relation";
                Cont: Record Contact;
            begin
                TestField(Status, Status::Open);

                if ("Bill-to Contact No." <> xRec."Bill-to Contact No.") and
                   (xRec."Bill-to Contact No." <> '')
                then begin
                    if HideValidationDialog then
                        Confirmed := true
                    else
                        Confirmed := Confirm(Text004, false, FieldCaption("Bill-to Contact No."));
                    if Confirmed then begin
                        RentSalesLine.Reset;
                        RentSalesLine.SetRange("Document Type", "Document Type");
                        RentSalesLine.SetRange("Document No.", "No.");
                        if ("Bill-to Contact No." = '') and ("Bill-to Customer No." = '') then begin
                            if not RentSalesLine.IsEmpty then
                                Error(Text005, FieldCaption("Bill-to Contact No."));
                            Init;
                            SalesSetup.Get;
                            InitRecord;
                            "No. Series" := xRec."No. Series";
                            if xRec."Shipping No." <> '' then begin
                                "Shipping No. Series" := xRec."Shipping No. Series";
                                "Shipping No." := xRec."Shipping No.";
                            end;
                            if xRec."Posting No." <> '' then begin
                                "Posting No. Series" := xRec."Posting No. Series";
                                "Posting No." := xRec."Posting No.";
                            end;
                            if xRec."Return Receipt No." <> '' then begin
                                "Return Receipt No. Series" := xRec."Return Receipt No. Series";
                                "Return Receipt No." := xRec."Return Receipt No.";
                            end;

                            if xRec."Prepayment No." <> '' then begin
                                "Prepayment No. Series" := xRec."Prepayment No. Series";
                                "Prepayment No." := xRec."Prepayment No.";
                            end;
                            if xRec."Prepmt. Cr. Memo No." <> '' then begin
                                "Prepmt. Cr. Memo No. Series" := xRec."Prepmt. Cr. Memo No. Series";
                                "Prepmt. Cr. Memo No." := xRec."Prepmt. Cr. Memo No.";
                            end;

                            exit;
                        end;
                    end else begin
                        "Bill-to Contact No." := xRec."Bill-to Contact No.";
                        exit;
                    end;
                end;

                if ("Bill-to Customer No." <> '') and ("Bill-to Contact No." <> '') then begin
                    Cont.Get("Bill-to Contact No.");
                    ContBusinessRelation.Reset;
                    ContBusinessRelation.SetCurrentkey("Link to Table", "No.");
                    ContBusinessRelation.SetRange("Link to Table", ContBusinessRelation."link to table"::Customer);
                    ContBusinessRelation.SetRange("No.", "Bill-to Customer No.");
                    if ContBusinessRelation.FindFirst then
                        if ContBusinessRelation."Contact No." <> Cont."Company No." then
                            Error(Text038, Cont."No.", Cont.Name, "Bill-to Customer No.");
                end;

                UpdateBillToCust("Bill-to Contact No.");
            end;
        }
        field(480; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            Editable = false;
            TableRelation = "Dimension Set Entry";

            trigger OnLookup()
            begin
                ShowDocDim;
            end;

            trigger OnValidate()
            begin
                DimMgt.UpdateGlobalDimFromDimSetID("Dimension Set ID", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
            end;
        }
        field(490; "Bill-to Customer Template Code"; Code[20])
        {
            Caption = 'Bill-to Customer Template Code';
            TableRelation = "Customer Templ.";

            trigger OnValidate()
            var
                BillToCustTemplate: Record "Customer Templ.";
            begin
                TestField("Document Type", "document type"::Quote);
                TestField(Status, Status::Open);

                if not InsertMode and
                   ("Bill-to Customer Template Code" <> xRec."Bill-to Customer Template Code") and
                   (xRec."Bill-to Customer Template Code" <> '')
                then begin
                    if HideValidationDialog then
                        Confirmed := true
                    else
                        Confirmed := Confirm(Text004, false, FieldCaption("Bill-to Customer Template Code"));
                    if Confirmed then begin
                        RentSalesLine.Reset;
                        RentSalesLine.SetRange("Document Type", "Document Type");
                        RentSalesLine.SetRange("Document No.", "No.");
                        if "Bill-to Customer Template Code" = '' then begin
                            if not RentSalesLine.IsEmpty then
                                Error(Text005, FieldCaption("Bill-to Customer Template Code"));
                            Init;
                            SalesSetup.Get;
                            InitRecord;
                            "No. Series" := xRec."No. Series";
                            if xRec."Shipping No." <> '' then begin
                                "Shipping No. Series" := xRec."Shipping No. Series";
                                "Shipping No." := xRec."Shipping No.";
                            end;
                            if xRec."Posting No." <> '' then begin
                                "Posting No. Series" := xRec."Posting No. Series";
                                "Posting No." := xRec."Posting No.";
                            end;
                            if xRec."Return Receipt No." <> '' then begin
                                "Return Receipt No. Series" := xRec."Return Receipt No. Series";
                                "Return Receipt No." := xRec."Return Receipt No.";
                            end;

                            if xRec."Prepayment No." <> '' then begin
                                "Prepayment No. Series" := xRec."Prepayment No. Series";
                                "Prepayment No." := xRec."Prepayment No.";
                            end;
                            if xRec."Prepmt. Cr. Memo No." <> '' then begin
                                "Prepmt. Cr. Memo No. Series" := xRec."Prepmt. Cr. Memo No. Series";
                                "Prepmt. Cr. Memo No." := xRec."Prepmt. Cr. Memo No.";
                            end;

                            exit;
                        end;
                    end else begin
                        "Bill-to Customer Template Code" := xRec."Bill-to Customer Template Code";
                        exit;
                    end;
                end;

                Validate("Ship-to Code", '');
                if BillToCustTemplate.Get("Bill-to Customer Template Code") then begin
                    BillToCustTemplate.TestField("Customer Posting Group");
                    "Customer Posting Group" := BillToCustTemplate."Customer Posting Group";
                    "Invoice Disc. Code" := BillToCustTemplate."Invoice Disc. Code";
                    "Customer Price Group" := BillToCustTemplate."Customer Price Group";
                    "Customer Disc. Group" := BillToCustTemplate."Customer Disc. Group";
                    "Allow Line Disc." := BillToCustTemplate."Allow Line Disc.";
                    Validate("Payment Terms Code", BillToCustTemplate."Payment Terms Code");
                    Validate("Payment Method Code", BillToCustTemplate."Payment Method Code");
                    "Shipment Method Code" := BillToCustTemplate."Shipment Method Code";
                end;

                if not InsertMode and
                   (xRec."Sell-to Customer Template Code" = "Sell-to Customer Template Code") and
                   (xRec."Bill-to Customer Template Code" <> "Bill-to Customer Template Code")
                then
                    RecreateSalesLines(FieldCaption("Bill-to Customer Template Code"));
            end;
        }
        field(500; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" then
                    if GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp, "Gen. Bus. Posting Group") then begin
                        "VAT Bus. Posting Group" := GenBusPostingGrp."Def. VAT Bus. Posting Group";
                        RecreateSalesLines(FieldCaption("Gen. Bus. Posting Group"));
                    end;
            end;
        }
        field(510; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if xRec."VAT Bus. Posting Group" <> "VAT Bus. Posting Group" then
                    RecreateSalesLines(FieldCaption("VAT Bus. Posting Group"));
            end;
        }
        field(520; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                MessageIfSalesLinesExist(FieldCaption("Tax Area Code"));
            end;
        }
        field(530; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                MessageIfSalesLinesExist(FieldCaption("Tax Liable"));
            end;
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

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(560; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if not UserMgt.CheckRespCenter(0, "Responsibility Center") then
                    Error(
                      Text027,
                      RespCenter.TableCaption, UserMgt.GetSalesFilter);

                UpdateShipToAddress;

                if xRec."Responsibility Center" <> "Responsibility Center" then begin
                    RecreateSalesLines(FieldCaption("Responsibility Center"));
                    "Assigned User ID" := '';
                end;

                CreateDim(
                  Database::Customer, "Bill-to Customer No.",
                  Database::"Salesperson/Purchaser", "Salesperson Code",
                  Database::"Responsibility Center", "Responsibility Center",
                  Database::"Deal Type", "Deal Type",
                  Database::Location, "Location Code"
                  );
            end;
        }
        field(570; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                if not (CurrFieldNo in [0, FieldNo("Posting Date")]) then
                    TestField(Status, Status::Open);
                if CurrFieldNo <> FieldNo("Currency Code") then
                    UpdateCurrencyFactor
                else begin
                    if "Currency Code" <> xRec."Currency Code" then begin
                        UpdateCurrencyFactor;
                        RecreateSalesLines(FieldCaption("Currency Code"));
                    end else
                        if "Currency Code" <> '' then begin
                            UpdateCurrencyFactor;
                            if "Currency Factor" <> xRec."Currency Factor" then
                                ConfirmUpdateCurrencyFactor;
                        end;
                end;
            end;
        }
        field(580; "Bank Account No."; Text[30])
        {
            Caption = 'Bank Account No.';
            TableRelation = "Bank Account"."No.";
        }
        field(590; "Customer Posting Group"; Code[20])
        {
            Caption = 'Customer Posting Group';
            Editable = false;
            TableRelation = "Customer Posting Group";
        }
        field(600; "Customer Price Group"; Code[20])
        {
            Caption = 'Customer Price Group';
            TableRelation = "Customer Price Group";

            trigger OnValidate()
            begin
                MessageIfSalesLinesExist(FieldCaption("Customer Price Group"));
            end;
        }
        field(610; "Prices Including VAT"; Boolean)
        {
            Caption = 'Prices Including VAT';

            trigger OnValidate()
            var
                RentSalesLine: Record "Rent Sales Line";
                Currency: Record Currency;
                RecalculatePrice: Boolean;
            begin
                TestField(Status, Status::Open);

                //Update Rent Sales Lines
                if "Prices Including VAT" <> xRec."Prices Including VAT" then begin
                    RentSalesLine.SetRange("Document Type", "Document Type");
                    RentSalesLine.SetRange("Document No.", "No.");
                    RentSalesLine.SetFilter("Unit Price", '<>%1', 0);
                    RentSalesLine.SetFilter("VAT %", '<>%1', 0);

                    RentLine.SetRange("Document Type", "Document Type");
                    RentLine.SetRange("Document No.", "No.");
                    RentLine.SetFilter("Unit Price", '<>%1', 0);
                    RentLine.SetFilter("VAT %", '<>%1', 0);


                    if RentSalesLine.FindFirst or RentLine.FindFirst then begin
                        RecalculatePrice :=
                          Confirm(
                            StrSubstNo(
                              Text024 +
                              Text026,
                              FieldCaption("Prices Including VAT"), RentSalesLine.FieldCaption("Unit Price")),
                            true);
                        RentSalesLine.SetRentHeader(Rec);

                        if "Currency Code" = '' then
                            Currency.InitRoundingPrecision
                        else
                            Currency.Get("Currency Code");

                        //-----------------------------------
                        // Rent Sales Lines
                        //-----------------------------------
                        if RentSalesLine.FindFirst then begin
                            RentSalesLine.LockTable;
                            LockTable;
                            RentSalesLine.FindSet;
                            repeat
                                RentSalesLine.TestField("Quantity Invoiced", 0);
                                if not RecalculatePrice then begin
                                    RentSalesLine."VAT Difference" := 0;
                                end else begin
                                    if "Prices Including VAT" then begin
                                        RentSalesLine."Unit Price" :=
                                          ROUND(
                                            RentSalesLine."Unit Price" * (1 + (RentSalesLine."VAT %" / 100)),
                                            Currency."Unit-Amount Rounding Precision");
                                        if RentSalesLine.Quantity <> 0 then begin
                                            RentSalesLine."Line Discount Amount" :=
                                              ROUND(
                                                RentSalesLine.Quantity * RentSalesLine."Unit Price" * RentSalesLine."Line Discount %" / 100,
                                                Currency."Amount Rounding Precision");
                                            RentSalesLine.Validate("Inv. Discount Amount",
                                              ROUND(
                                                RentSalesLine."Inv. Discount Amount" * (1 + (RentSalesLine."VAT %" / 100)),
                                                Currency."Amount Rounding Precision"));
                                        end;
                                    end else begin
                                        RentSalesLine."Unit Price" :=
                                          ROUND(
                                            RentSalesLine."Unit Price" / (1 + (RentSalesLine."VAT %" / 100)),
                                            Currency."Unit-Amount Rounding Precision");
                                        if RentSalesLine.Quantity <> 0 then begin
                                            RentSalesLine."Line Discount Amount" :=
                                              ROUND(
                                                RentSalesLine.Quantity * RentSalesLine."Unit Price" * RentSalesLine."Line Discount %" / 100,
                                                Currency."Amount Rounding Precision");
                                            RentSalesLine.Validate("Inv. Discount Amount",
                                              ROUND(
                                                RentSalesLine."Inv. Discount Amount" / (1 + (RentSalesLine."VAT %" / 100)),
                                                Currency."Amount Rounding Precision"));
                                        end;
                                    end;
                                end;
                                RentSalesLine.Modify;
                                RentSalesLine.UpdateAmounts;
                            until RentSalesLine.Next = 0;
                        end;
                        //-----------------------------------
                        // Rent Lines
                        //-----------------------------------
                        if RentLine.FindFirst then begin
                            RentLine.SetRentHeader(Rec);
                            RentLine.LockTable;
                            LockTable;
                            RentLine.FindSet;
                            repeat
                                RentLine.TestField("Quantity Invoiced", 0);
                                if not RecalculatePrice then begin
                                    RentLine."VAT Difference" := 0;
                                end else begin
                                    if "Prices Including VAT" then begin
                                        RentLine."Unit Price" :=
                                          ROUND(
                                            RentLine."Unit Price" * (1 + (RentLine."VAT %" / 100)),
                                            Currency."Unit-Amount Rounding Precision");
                                        if RentLine.Quantity <> 0 then begin
                                            RentLine."Line Discount Amount" :=
                                              ROUND(
                                                RentLine.Quantity * RentLine."Unit Price" * RentLine."Line Discount %" / 100,
                                                Currency."Amount Rounding Precision");
                                            RentLine.Validate("Inv. Discount Amount",
                                              ROUND(
                                                RentLine."Inv. Discount Amount" * (1 + (RentLine."VAT %" / 100)),
                                                Currency."Amount Rounding Precision"));
                                        end;
                                    end else begin
                                        RentLine."Unit Price" :=
                                          ROUND(
                                            RentLine."Unit Price" / (1 + (RentLine."VAT %" / 100)),
                                            Currency."Unit-Amount Rounding Precision");
                                        if RentLine.Quantity <> 0 then begin
                                            RentLine."Line Discount Amount" :=
                                              ROUND(
                                                RentLine.Quantity * RentLine."Unit Price" * RentLine."Line Discount %" / 100,
                                                Currency."Amount Rounding Precision");
                                            RentLine.Validate("Inv. Discount Amount",
                                              ROUND(
                                                RentLine."Inv. Discount Amount" / (1 + (RentLine."VAT %" / 100)),
                                                Currency."Amount Rounding Precision"));
                                        end;
                                    end;
                                end;
                                RentLine.Modify;
                            until RentLine.Next = 0;
                        end;
                    end; //If renline or rentsales line
                end;
                //Update Rent Lines
            end;
        }
        field(620; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Line Disc.';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                MessageIfSalesLinesExist(FieldCaption("Allow Line Disc."));
            end;
        }
        field(630; "Invoice Disc. Code"; Code[20])
        {
            Caption = 'Invoice Disc. Code';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                MessageIfSalesLinesExist(FieldCaption("Invoice Disc. Code"));
            end;
        }
        field(640; "Customer Disc. Group"; Code[20])
        {
            Caption = 'Customer Disc. Group';
            TableRelation = "Customer Discount Group";

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                MessageIfSalesLinesExist(FieldCaption("Customer Disc. Group"));
            end;
        }
        field(650; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;

            trigger OnValidate()
            begin
                MessageIfSalesLinesExist(FieldCaption("Language Code"));
            end;
        }
        field(660; "Salesperson Code"; Code[10])
        {
            Caption = 'Salesperson Code';
            TableRelation = "Salesperson/Purchaser";

            trigger OnValidate()
            var
                ApprovalEntry: Record "Approval Entry";
            begin
                ApprovalEntry.SetRange("Table ID", Database::"Sales Header");
                ApprovalEntry.SetRange("Document Type", "Document Type");
                ApprovalEntry.SetRange("Document No.", "No.");
                ApprovalEntry.SetFilter(Status, '<>%1&<>%2', ApprovalEntry.Status::Canceled, ApprovalEntry.Status::Rejected);
                if ApprovalEntry.Find('-') then
                    Error(Text053, FieldCaption("Salesperson Code"));

                CreateDim(
                  Database::Customer, "Bill-to Customer No.",
                  Database::"Salesperson/Purchaser", "Salesperson Code",
                  Database::"Responsibility Center", "Responsibility Center",
                  Database::"Deal Type", "Deal Type",
                  Database::Location, "Location Code"
                  );
            end;
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

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(720; "Shipping Agent Code"; Code[10])
        {
            Caption = 'Shipping Agent Code';
            TableRelation = "Shipping Agent";

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if xRec."Shipping Agent Code" = "Shipping Agent Code" then
                    exit;

                "Shipping Agent Service Code" := '';
                UpdateSalesLines(FieldCaption("Shipping Agent Code"), CurrFieldNo <> 0);
            end;
        }
        field(730; "Shipping Agent Service Code"; Code[10])
        {
            Caption = 'Shipping Agent Service Code';
            TableRelation = "Shipping Agent Services".Code where("Shipping Agent Code" = field("Shipping Agent Code"));

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                UpdateSalesLines(FieldCaption("Shipping Agent Service Code"), CurrFieldNo <> 0);
            end;
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

            trigger OnLookup()
            begin
                RentHeader := Rec;
                SalesSetup.Get;
                SalesSetup.TestField("Posted Shipment Nos.");
                if NoSeriesMgt.LookupRelatedNoSeries(SalesSetup."Posted Shipment Nos.", RentHeader."Shipping No. Series") then
                    RentHeader.Validate("Shipping No. Series");
                Rec := RentHeader;
            end;

            trigger OnValidate()
            begin
                if "Shipping No. Series" <> '' then begin
                    SalesSetup.Get;
                    SalesSetup.TestField("Posted Shipment Nos.");
                    NoSeriesMgt.TestAreRelated(SalesSetup."Posted Shipment Nos.", "Shipping No. Series");
                end;
                TestField("Shipping No.", '');
            end;
        }
        field(800; "Return Receipt No."; Code[20])
        {
            Caption = 'Return Receipt No.';
        }
        field(810; "Return Receipt No. Series"; Code[20])
        {
            Caption = 'Return Receipt No. Series';
            TableRelation = "No. Series";

            trigger OnLookup()
            begin
                RentHeader := Rec;
                SalesSetup.Get;
                SalesSetup.TestField("Posted Return Receipt Nos.");
                if NoSeriesMgt.LookupRelatedNoSeries(SalesSetup."Posted Return Receipt Nos.", RentHeader."Return Receipt No. Series") then
                    RentHeader.Validate("Return Receipt No. Series");
                Rec := RentHeader;
            end;

            trigger OnValidate()
            begin
                if "Return Receipt No. Series" <> '' then begin
                    SalesSetup.Get;
                    SalesSetup.TestField("Posted Return Receipt Nos.");
                    NoSeriesMgt.TestAreRelated(SalesSetup."Posted Return Receipt Nos.", "Return Receipt No. Series");
                end;
                TestField("Return Receipt No.", '');
            end;
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

            trigger OnLookup()
            begin
                RentHeader := Rec;
                SalesSetup.Get;
                SalesSetup.TestField("Posted Prepmt. Inv. Nos.");
                if NoSeriesMgt.LookupRelatedNoSeries(SalesSetup."Posted Prepmt. Inv. Nos.", RentHeader."Prepayment No. Series") then
                    RentHeader.Validate("Prepayment No. Series");
                Rec := RentHeader;
            end;

            trigger OnValidate()
            begin
                if "Prepayment No. Series" <> '' then begin
                    SalesSetup.Get;
                    SalesSetup.TestField("Posted Prepmt. Inv. Nos.");
                    NoSeriesMgt.TestAreRelated(SalesSetup."Posted Prepmt. Inv. Nos.", "Prepayment No. Series");
                end;
                TestField("Prepayment No.", '');
            end;
        }
        field(860; "Prepmt. Cr. Memo No. Series"; Code[20])
        {
            Caption = 'Prepmt. Cr. Memo No. Series';
            TableRelation = "No. Series";

            trigger OnLookup()
            begin
                RentHeader := Rec;
                SalesSetup.Get;
                SalesSetup.TestField("Posted Prepmt. Cr. Memo Nos.");
                if NoSeriesMgt.LookupRelatedNoSeries(GetPostingNoSeriesCode(), RentHeader."Prepmt. Cr. Memo No.") then
                    RentHeader.Validate("Prepmt. Cr. Memo No.");
                Rec := RentHeader;
            end;

            trigger OnValidate()
            begin
                if "Prepmt. Cr. Memo No." <> '' then begin
                    SalesSetup.Get;
                    SalesSetup.TestField("Posted Prepmt. Cr. Memo Nos.");
                    NoSeriesMgt.TestAreRelated(SalesSetup."Posted Prepmt. Cr. Memo Nos.", "Prepmt. Cr. Memo No.");
                end;
                TestField("Prepmt. Cr. Memo No.", '');
            end;
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
                if xRec."Opportunity No." <> "Opportunity No." then begin
                    if "Opportunity No." <> '' then
                        if Opportunity.Get("Opportunity No.") then begin
                            Opportunity.TestField(Status, Opportunity.Status::"In Progress");
                            if Opportunity."Sales Document No." <> '' then begin
                                if Confirm(Text048, false, Opportunity."Sales Document No.", Opportunity."No.") then begin
                                    if SalesHeader.Get("document type"::Quote, Opportunity."Sales Document No.") then begin
                                        SalesHeader."Opportunity No." := '';
                                        SalesHeader.Modify;
                                    end;
                                    Opportunity."Sales Document Type" := Opportunity."sales document type"::Quote;
                                    Opportunity."Sales Document No." := "No.";
                                    Opportunity.Modify;
                                end else
                                    "Opportunity No." := xRec."Opportunity No.";
                            end else begin
                                Opportunity."Sales Document Type" := Opportunity."sales document type"::Quote;
                                Opportunity."Sales Document No." := "No.";
                                Opportunity.Modify;
                            end
                        end;
                    if xRec."Opportunity No." <> '' then
                        if Opportunity.Get(xRec."Opportunity No.") then begin
                            Opportunity."Sales Document No." := '';
                            Opportunity."Sales Document Type" := Opportunity."sales document type"::" ";
                            Opportunity.Modify;
                        end;
                end;
            end;
        }
        field(880; "Assigned User ID"; Code[50])
        {
            Caption = 'Assigned User ID';
            TableRelation = "User Setup";

            trigger OnValidate()
            begin
                if not UserMgt.CheckRespCenter(0, "Responsibility Center", "Assigned User ID") then
                    Error(
                      Text061, "Assigned User ID",
                      RespCenter.TableCaption, UserMgt.GetSalesFilter("Assigned User ID"));
            end;
        }
        field(890; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin
                if "Currency Factor" <> xRec."Currency Factor" then
                    UpdateSalesLines(FieldCaption("Currency Factor"), false);
            end;
        }
        field(900; "Shipment Date"; Date)
        {
            Caption = 'Rent Start Date';

            trigger OnValidate()
            begin
                UpdateRentLines(FieldCaption("Shipment Date"), CurrFieldNo <> 0);
            end;
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

            trigger OnValidate()
            begin
                UpdateSalesLines(FieldCaption("Transaction Type"), false);
            end;
        }
        field(930; "Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
            TableRelation = "Transport Method";

            trigger OnValidate()
            begin
                UpdateSalesLines(FieldCaption("Transport Method"), false);
            end;
        }
        field(940; "Exit Point"; Code[10])
        {
            Caption = 'Exit Point';
            TableRelation = "Entry/Exit Point";

            trigger OnValidate()
            begin
                UpdateSalesLines(FieldCaption("Exit Point"), false);
            end;
        }
        field(950; "Area"; Code[10])
        {
            Caption = 'Area';
            TableRelation = Area;

            trigger OnValidate()
            begin
                UpdateSalesLines(FieldCaption(Area), false);
            end;
        }
        field(960; "Transaction Specification"; Code[10])
        {
            Caption = 'Transaction Specification';
            TableRelation = "Transaction Specification";

            trigger OnValidate()
            begin
                UpdateSalesLines(FieldCaption("Transaction Specification"), false);
            end;
        }
        field(970; "Shipping Time"; DateFormula)
        {
            Caption = 'Shipping Time';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if "Shipping Time" <> xRec."Shipping Time" then
                    UpdateSalesLines(FieldCaption("Shipping Time"), CurrFieldNo <> 0);
            end;
        }
        field(980; "Requested Delivery Date"; Date)
        {
            Caption = 'Requested Delivery Date';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if "Promised Delivery Date" <> 0D then
                    Error(
                      Text028,
                      FieldCaption("Requested Delivery Date"),
                      FieldCaption("Promised Delivery Date"));

                if "Requested Delivery Date" <> xRec."Requested Delivery Date" then
                    UpdateSalesLines(FieldCaption("Requested Delivery Date"), CurrFieldNo <> 0);
            end;
        }
        field(990; "Promised Delivery Date"; Date)
        {
            Caption = 'Promised Delivery Date';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if "Promised Delivery Date" <> xRec."Promised Delivery Date" then
                    UpdateSalesLines(FieldCaption("Promised Delivery Date"), CurrFieldNo <> 0);
            end;
        }
        field(1000; "Outbound Whse. Handling Time"; DateFormula)
        {
            Caption = 'Outbound Whse. Handling Time';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if ("Outbound Whse. Handling Time" <> xRec."Outbound Whse. Handling Time") and
                   (xRec."Sell-to Customer No." = "Sell-to Customer No.")
                then
                    UpdateSalesLines(FieldCaption("Outbound Whse. Handling Time"), CurrFieldNo <> 0);
            end;
        }
        field(1010; "Rent Quote No."; Code[10])
        {
            Caption = 'Rent Quote No.';
            Editable = false;
        }
        field(1020; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = sum("Rent Sales Line".Amount where("Document Type" = field("Document Type"),
                                                              "Document No." = field("No.")));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1030; "Amount Including VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = sum("Rent Sales Line"."Amount Including VAT" where("Document Type" = field("Document Type"),
                                                                              "Document No." = field("No.")));
            Caption = 'Amount Including VAT';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1040; "Deal Type"; Code[10])
        {
            Caption = 'Deal Type';
            TableRelation = "Deal Type";

            trigger OnValidate()
            var
                recServiceLine: Record "Service Line EDMS";
                tcDMS001: label 'Do you want to change lines too?';
            begin
                TestField(Status, Status::Open);
                UpdateSalesLines(FieldCaption("Deal Type"), false);

                CreateDim(
                  Database::Customer, "Bill-to Customer No.",
                  Database::"Salesperson/Purchaser", "Salesperson Code",
                  Database::"Responsibility Center", "Responsibility Center",
                  Database::"Deal Type", "Deal Type",
                  Database::Location, "Location Code"
                  );
            end;
        }
        field(1050; "Outstanding Payments"; Decimal)
        {
            Caption = 'Outstanding Payments';
        }
        field(1060; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = Contract."Contract No." where("Bill-to Customer No." = field("Bill-to Customer No."));

            trigger OnValidate()
            var
                Contract: record Contract;
            begin
                if Contract.Get("Contract No.") and ("Contract No." <> xRec."Contract No.") then
                    if Contract."Payment Terms Code" <> '' then
                        Validate("Payment Terms Code", Contract."Payment Terms Code");
            end;
        }
        field(1070; "Rent Amount Including VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = sum("Rent Line"."Line Amount" where("Document Type" = field("Document Type"),
                                                               "Document No." = field("No.")));
            Caption = 'Amount Including VAT';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1080; "Deposit Amount"; Decimal)
        {
            Caption = 'Deposit Amount';
        }

        field(1090; "Overtime Calculation"; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Total Period,Current Period';
            OptionMembers = " ","Total Period","Current Period";
        }
        field(1200; "External Document No."; Code[35])
        {
            DataClassification = ToBeClassified;
        }
        field(1210; "Rent Description"; Blob)
        {
            Caption = 'Rent Description';
        }
        field(1220; "Next Review Date"; Date)
        {
            Caption = 'Next Review Date';
        }
        field(5000; Closed; Boolean)
        {
            Caption = 'Closed';
            DataClassification = ToBeClassified;
        }
        field(99008500; "Date Received"; Date)
        {
            Caption = 'Date Received';
        }
        field(99008501; "Time Received"; Time)
        {
            Caption = 'Time Received';
        }


    }

    keys
    {
        key(Key1; "Document Type", "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "No.", "Sell-to Customer Name")
        {
        }
        fieldgroup(Brick; "No.", "Sell-to Customer Name")
        {
        }
    }

    trigger OnDelete()
    var
        SalesLine: Record "Sales Line";
        SalesInvoiceLine: Record "Sales Invoice Line";
        SalesCrMemoLine: Record "Sales Cr.Memo Line";
        RentTransferLine: Record "Rent Transfer Line";
        PostedRentTransferLine: Record "Posted Rent Transfer Line";
        RentLine: Record "Rent Line";
        RentSalesLine: Record "Rent Sales Line";
    begin
        SalesLine.Reset;
        SalesLine.SetRange("Rent Order No.", "No.");
        if SalesLine.FindFirst then
            Error(RentSalesDocExistsErr, Format(SalesLine."Document Type"), SalesLine."Document No.");

        SalesInvoiceLine.Reset;
        SalesInvoiceLine.SetRange("Rent Order No.", "No.");
        if SalesInvoiceLine.FindFirst then
            Error(RentPostedSalesDocExistsErr, Format(SalesLine."document type"::Invoice), SalesInvoiceLine."Document No.");

        SalesCrMemoLine.Reset;
        SalesCrMemoLine.SetRange("Rent Order No.", "No.");
        if SalesCrMemoLine.FindFirst then
            Error(RentPostedSalesDocExistsErr, Format(SalesLine."document type"::"Credit Memo"), SalesCrMemoLine."Document No.");

        RentTransferLine.Reset;
        RentTransferLine.SetRange("Rent Order No.", "No.");
        if RentTransferLine.FindFirst then
            Error(RentTransferExistsErr, RentTransferLine."Document No.");

        PostedRentTransferLine.Reset;
        PostedRentTransferLine.SetRange("Rent Order No.", "No.");
        if PostedRentTransferLine.FindFirst then
            Error(RentPostedTransferExistsErr, PostedRentTransferLine."Document No.");

        RentLine.SetRange("Document No.", "No.");
        RentLine.DeleteAll(true);

        RentSalesLine.SetRange("Document No.", "No.");
        RentSalesLine.DeleteAll(true);

    end;

    trigger OnInsert()
    begin
        RentSetup.Get;
        if "No." = '' then begin
            TestNoSeries;
            "No. Series" := GetNoSeriesCode();
            "No." := NoSeriesMgt.GetNextNo("No. Series", "Posting Date", true);
        end;

        if "Overtime Calculation" = "Overtime Calculation"::" " then
            "Overtime Calculation" := RentSetup."Overtime Calculation";

        InitRecord;
    end;

    trigger OnRename()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeRename(Rec, IsHandled, xRec);
        if IsHandled then
            exit;

        Error(Text065, TableCaption);
    end;

    var
        GLSetup: Record "General Ledger Setup";
        SalesSetup: Record "Sales & Receivables Setup";
        RentSetup: Record "Rent Mgt. Setup";
        RentHeader: Record "Rent Header";
        RentLine: Record "Rent Line";
        RentSalesLine: Record "Rent Sales Line";
        RentSalesLineTmp: Record "Rent Sales Line" temporary;
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
        UserMgt: Codeunit "User Setup Management";
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
        Text064: label 'You may have changed a dimension.\\Do you want to update the lines?';
        Text065: Label 'You cannot rename a %1.';
        Text125: label 'Do You want to link this vehice to contact No. %1?';
        Text200: label 'Model version No. %1 cost is not adjusted. Do you want to continue?';
        VehicleConfirm: label 'There is a vehicle linked to this contact.\%1 %2\%3 %4\%5 %6\Do you want to apply this vehicle?';
        COntactConfirm: label 'There is a customer linked to this vehicle.\%1 %2\Do you want to apply this customer?';
        SkipSellToContact: Boolean;
        SkipBillToContact: Boolean;
        HideSubConfirmDialog: Boolean;
        InsertMode: Boolean;
        CurrencyDate: Date;
        CustCheckCreditLimit: Codeunit "Cust-Check Cr. Limit";
        UserSetup: Record "User Setup";
        Month: Integer;
        HideCreditCheckDialogue: Boolean;
        BilltoCustomerNoChanged: Boolean;
        Text132: label 'Do you want to update the rent lines?';
        Text032: label 'Do you want to update the lines?';
        RentSalesDocExistsErr: label 'Sales %1 %2 for rent order exists!';
        RentPostedSalesDocExistsErr: label 'Posted sales %1 %2 for rent order exists!';
        RentTransferExistsErr: label 'Transfer order %1 for rent order exists!';
        RentPostedTransferExistsErr: label 'Posted transfer order %1 for rent order exists!';
        CloseCheckRentLineNotInvoiced: label 'Rent Line %1 Rent Asset %2 Rent Item %3 not fully invoiced!';
        CloseCheckRentSalesLineNotInvoiced: label 'Rent Sales Line %1  %2 not invoiced!';
        CloseCheckTransferExists: label 'There are open transfer order %1 !';
        CloseCheckNotReturned: label 'Rent Asset %1 not returned!';
        RenStatusReturned: label 'Rent status must be Returned. Rent line: %1, Rent Item: %2, Rent Asset: %3';


    procedure AssistEdit(OldRentHeader: Record "Rent Header"): Boolean
    begin
        RentHeader := Rec;
        RentSetup.Get;
        RentSetup.TestField("Order Nos.");
        if NoSeriesMgt.LookupRelatedNoSeries(RentSetup."Order Nos.", OldRentHeader."No. Series", RentHeader."No. Series") then begin
            if (RentHeader."Sell-to Customer No." = '') and (RentHeader."Sell-to Contact No." = '') then begin
                HideCreditCheckDialogue := false;
                RentHeader.CheckCreditMaxBeforeInsert;
                HideCreditCheckDialogue := true;
            end;
            RentSetup.Get;
            RentSetup.TestField("Rent Item Nos.");
            RentHeader."No." := NoSeriesMgt.GetNextNo(RentHeader."No. Series", WorkDate(), true);
            Rec := RentHeader;
            exit(true);
        end;
    end;

    local procedure GetNoSeriesCode(): Code[10]
    begin
        case "Document Type" of
            "document type"::Quote:
                exit(RentSetup."Quote Nos.");
            "document type"::Order:
                exit(RentSetup."Order Nos.");
            "document type"::"Return Order":
                exit(RentSetup."Return Order Nos.");
        end;
    end;

    local procedure TestNoSeries(): Boolean
    begin
        case "Document Type" of
            "document type"::Quote:
                RentSetup.TestField("Quote Nos.");
            "document type"::Order:
                RentSetup.TestField("Order Nos.");
            "document type"::"Return Order":
                RentSetup.TestField("Return Order Nos.");
        end;
    end;


    procedure InitRecord()
    begin
        case "Document Type" of
            "document type"::Order:
                begin
                    if RentSetup."PstDoc. Num. equal Doc. Num." then begin
                        "Posting No." := "No.";
                        "Posting No. Series" := "No. Series"
                    end else begin
                        if NoSeriesMgt.IsAutomatic(RentSetup."Posted Order Nos.") then
                            "Posting No. Series" := RentSetup."Posted Order Nos.";
                    end;
                end;
            "document type"::"Return Order":
                begin
                    if RentSetup."PstDoc. Num. equal Doc. Num." then begin
                        "Posting No." := "No.";
                        "Posting No. Series" := "No. Series"
                    end else begin
                        if NoSeriesMgt.IsAutomatic(RentSetup."Posted Return Order Nos.") then
                            "Posting No. Series" := RentSetup."Posted Return Order Nos.";
                    end;
                end;
        end;

        "Order Date" := WorkDate;

        if "Posting Date" = 0D then
            "Posting Date" := WorkDate;

        if "Document Date" = 0D then
            "Document Date" := WorkDate;

        if "Shipment Date" = 0D then
            "Shipment Date" := WorkDate;

        "Posting Description" := Format("Document Type") + ' ' + "No.";
        "Responsibility Center" := UserMgt.GetRespCenter(0, "Responsibility Center");

        GetUserSetup;

        RentSetup.Get();
        "Rent Type" := RentSetup."Default Rent Type";

        //UserSetup.GET(USERID);
        //IF UserSetup."Default Rent Location Code" <> '' THEN
        //  "Location Code" := UserSetup."Default Rent Location Code";
    end;

    local procedure GetCust(CustNo: Code[20])
    begin
        if not (("Document Type" = "document type"::Quote) and (CustNo = '')) then begin
            if CustNo <> Cust."No." then
                Cust.Get(CustNo);
        end else
            Clear(Cust);
    end;


    procedure RecreateSalesLines(ChangedFieldName: Text[100])
    var
        RentSalesLineTmp: Record "Rent Sales Line" temporary;
        ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
        TempItemChargeAssgntSales: Record "Item Charge Assignment (Sales)" temporary;
        TempInteger: Record "Integer" temporary;
        ServDocReg: Record "Service Document Register";
        TempServDocReg: Record "Service Document Register" temporary;
        ExtendedTextAdded: Boolean;
    begin
        if SalesLinesExist then begin
            if HideValidationDialog or not GuiAllowed then
                Confirmed := true
            else
                Confirmed :=
                  Confirm(
                    Text015 +
                    Text004, false, ChangedFieldName);
            if Confirmed then begin
                RentSalesLine.LockTable;
                ItemChargeAssgntSales.LockTable;
                ReservEntry.LockTable;
                Modify;

                RentSalesLine.Reset;
                RentSalesLine.SetRange("Document Type", "Document Type");
                RentSalesLine.SetRange("Document No.", "No.");
                if RentSalesLine.FindSet then begin
                    repeat
                        RentSalesLine.TestField("Job No.", '');
                        RentSalesLine.TestField("Job Contract Entry No.", 0);
                        RentSalesLine.TestField("Quantity Shipped", 0);
                        RentSalesLine.TestField("Quantity Invoiced", 0);
                        RentSalesLine.TestField("Return Qty. Received", 0);
                        RentSalesLine.TestField("Shipment No.", '');
                        RentSalesLine.TestField("Return Receipt No.", '');
                        RentSalesLine.TestField("Prepmt. Amt. Inv.", 0);
                        RentSalesLineTmp := RentSalesLine;
                        if RentSalesLine.Nonstock then begin
                            RentSalesLine.Nonstock := false;
                            RentSalesLine.Modify;
                        end;
                        RentSalesLineTmp.Insert;
                        RecreateReservEntry(RentSalesLine, 0, true);
                        RecreateReqLine(RentSalesLine, 0, true);
                    until RentSalesLine.Next = 0;

                    if "Location Code" <> xRec."Location Code" then
                        if not TempReservEntry.IsEmpty then
                            Error(Text047, FieldCaption("Location Code"));

                    ItemChargeAssgntSales.SetRange("Document Type", "Document Type");
                    ItemChargeAssgntSales.SetRange("Document No.", "No.");
                    if ItemChargeAssgntSales.FindSet then begin
                        repeat
                            TempItemChargeAssgntSales.Init;
                            TempItemChargeAssgntSales := ItemChargeAssgntSales;
                            TempItemChargeAssgntSales.Insert;
                        until ItemChargeAssgntSales.Next = 0;
                        ItemChargeAssgntSales.DeleteAll;
                    end;

                    RentSalesLine.DeleteAll(true);
                    RentSalesLine.Init;
                    RentSalesLine."Line No." := 0;
                    RentSalesLineTmp.FindSet;
                    ExtendedTextAdded := false;
                    repeat
                        //if RentSalesLineTmp."Attached to Line No." = 0 then begin
                        RentSalesLine.Init;
                        RentSalesLine."Line No." := RentSalesLine."Line No." + 10000;
                        RentSalesLine.Validate(Type, RentSalesLineTmp.Type);

                        RentSalesLine."Attached to Rent Line No." := RentSalesLineTmp."Attached to Rent Line No.";
                        RentSalesLine."To Invoice" := RentSalesLineTmp."To Invoice";
                        RentSalesLine."Rent Item No." := RentSalesLineTmp."Rent Item No.";
                        RentSalesLine."Location Code" := RentSalesLineTmp."Location Code";
                        RentSalesLine."Deal Type" := RentSalesLineTmp."Deal Type";


                        if RentSalesLineTmp."No." = '' then begin
                            RentSalesLine.Validate(Description, RentSalesLineTmp.Description);
                        end else begin
                            RentSalesLine.Validate("No.", RentSalesLineTmp."No.");
                            if RentSalesLine.Type <> RentSalesLine.Type::" " then begin
                                RentSalesLine.Validate("Unit of Measure Code", RentSalesLineTmp."Unit of Measure Code");
                                RentSalesLine.Validate("Variant Code", RentSalesLineTmp."Variant Code");
                                if RentSalesLineTmp.Quantity <> 0 then
                                    RentSalesLine.Validate(Quantity, RentSalesLineTmp.Quantity);
                                RentSalesLine.Validate("Line Discount %", RentSalesLineTmp."Line Discount %");
                                RentSalesLine."Purchase Order No." := RentSalesLineTmp."Purchase Order No.";
                                RentSalesLine."Purch. Order Line No." := RentSalesLineTmp."Purch. Order Line No.";
                                RentSalesLine."Drop Shipment" := RentSalesLine."Purch. Order Line No." <> 0;
                            end;
                        end;


                        RentSalesLine.Insert;
                        ExtendedTextAdded := false;

                        if RentSalesLine.Type = RentSalesLine.Type::Item then begin
                            ClearItemAssgntSalesFilter(TempItemChargeAssgntSales);
                            TempItemChargeAssgntSales.SetRange("Applies-to Doc. Type", RentSalesLineTmp."Document Type");
                            TempItemChargeAssgntSales.SetRange("Applies-to Doc. No.", RentSalesLineTmp."Document No.");
                            TempItemChargeAssgntSales.SetRange("Applies-to Doc. Line No.", RentSalesLineTmp."Line No.");
                            if TempItemChargeAssgntSales.FindSet then begin
                                repeat
                                    if not TempItemChargeAssgntSales.Mark then begin
                                        TempItemChargeAssgntSales."Applies-to Doc. Line No." := RentSalesLine."Line No.";
                                        TempItemChargeAssgntSales.Description := RentSalesLine.Description;
                                        TempItemChargeAssgntSales.Modify;
                                        TempItemChargeAssgntSales.Mark(true);
                                    end;
                                until TempItemChargeAssgntSales.Next = 0;
                            end;
                        end;
                        if RentSalesLine.Type = RentSalesLine.Type::"Charge (Item)" then begin
                            TempInteger.Init;
                            TempInteger.Number := RentSalesLine."Line No.";
                            TempInteger.Insert;
                        end;
                        //end else
                        //    if not ExtendedTextAdded then begin
                        //        RentSalesLine.FindLast;
                        //        ExtendedTextAdded := true;
                        //    end;
                        RecreateReservEntry(RentSalesLineTmp, RentSalesLine."Line No.", false);
                        RecreateReqLine(RentSalesLineTmp, RentSalesLine."Line No.", false);
                    until RentSalesLineTmp.Next = 0;

                    ClearItemAssgntSalesFilter(TempItemChargeAssgntSales);
                    RentSalesLineTmp.SetRange(Type, RentSalesLine.Type::"Charge (Item)");
                    if RentSalesLineTmp.FindSet then
                        repeat
                            TempItemChargeAssgntSales.SetRange("Document Line No.", RentSalesLineTmp."Line No.");
                            if TempItemChargeAssgntSales.FindSet then begin
                                repeat
                                    TempInteger.FindFirst;
                                    ItemChargeAssgntSales.Init;
                                    ItemChargeAssgntSales := TempItemChargeAssgntSales;
                                    ItemChargeAssgntSales."Document Line No." := TempInteger.Number;
                                    ItemChargeAssgntSales.Validate("Unit Cost", 0);
                                    ItemChargeAssgntSales.Insert;
                                until TempItemChargeAssgntSales.Next = 0;
                                TempInteger.Delete;
                            end;
                        until RentSalesLineTmp.Next = 0;

                    RentSalesLineTmp.SetRange(Type);
                    RentSalesLineTmp.DeleteAll;
                    ClearItemAssgntSalesFilter(TempItemChargeAssgntSales);
                    TempItemChargeAssgntSales.DeleteAll;
                end;
            end else
                Error(
                  Text017, ChangedFieldName);
        end;
    end;


    procedure SalesLinesExist(): Boolean
    begin
        RentSalesLine.Reset;
        RentSalesLine.SetRange("Document Type", "Document Type");
        RentSalesLine.SetRange("Document No.", "No.");
        exit(RentSalesLine.FindFirst);
    end;


    procedure RecreateReservEntry(OldRentSalesLine: Record "Rent Sales Line"; NewSourceRefNo: Integer; ToTemp: Boolean)
    begin
        if ToTemp then begin
            Clear(ReservEntry);
            ReservEntry.SetCurrentkey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
            ReservEntry.SetRange("Source ID", OldRentSalesLine."Document No.");
            ReservEntry.SetRange("Source Ref. No.", OldRentSalesLine."Line No.");
            ReservEntry.SetRange("Source Type", Database::"Sales Line");
            ReservEntry.SetRange("Source Subtype", OldRentSalesLine."Document Type");
            if ReservEntry.FindSet then
                repeat
                    TempReservEntry := ReservEntry;
                    TempReservEntry.Insert;
                until ReservEntry.Next = 0;
            ReservEntry.DeleteAll;
        end else begin
            Clear(TempReservEntry);
            TempReservEntry.SetCurrentkey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
            TempReservEntry.SetRange("Source Type", Database::"Sales Line");
            TempReservEntry.SetRange("Source Subtype", OldRentSalesLine."Document Type");
            TempReservEntry.SetRange("Source ID", OldRentSalesLine."Document No.");
            TempReservEntry.SetRange("Source Ref. No.", OldRentSalesLine."Line No.");
            if TempReservEntry.FindSet then
                repeat
                    ReservEntry := TempReservEntry;
                    ReservEntry."Source Ref. No." := NewSourceRefNo;
                    ReservEntry.Insert;
                until TempReservEntry.Next = 0;
            TempReservEntry.DeleteAll;
        end;
    end;


    procedure RecreateReqLine(OldRentSalesLine: Record "Rent Sales Line"; NewSourceRefNo: Integer; ToTemp: Boolean)
    var
        ReqLine: Record "Requisition Line";
    begin
        if ToTemp then begin
            ReqLine.SetCurrentkey("Order Promising ID", "Order Promising Line ID", "Order Promising Line No.");
            ReqLine.SetRange("Order Promising ID", OldRentSalesLine."Document No.");
            ReqLine.SetRange("Order Promising Line ID", OldRentSalesLine."Line No.");
            if ReqLine.FindSet then
                repeat
                    TempReqLine := ReqLine;
                    TempReqLine.Insert;
                until ReqLine.Next = 0;
            ReqLine.DeleteAll;
        end else begin
            Clear(TempReqLine);
            TempReqLine.SetCurrentkey("Order Promising ID", "Order Promising Line ID", "Order Promising Line No.");
            TempReqLine.SetRange("Order Promising ID", OldRentSalesLine."Document No.");
            TempReqLine.SetRange("Order Promising Line ID", OldRentSalesLine."Line No.");
            if TempReqLine.FindSet then
                repeat
                    ReqLine := TempReqLine;
                    ReqLine."Order Promising Line ID" := NewSourceRefNo;
                    ReqLine.Insert;
                until TempReqLine.Next = 0;
            TempReqLine.DeleteAll;
        end;
    end;

    local procedure ClearItemAssgntSalesFilter(var TempItemChargeAssgntSales: Record "Item Charge Assignment (Sales)")
    begin
        TempItemChargeAssgntSales.SetRange("Document Line No.");
        TempItemChargeAssgntSales.SetRange("Applies-to Doc. Type");
        TempItemChargeAssgntSales.SetRange("Applies-to Doc. No.");
        TempItemChargeAssgntSales.SetRange("Applies-to Doc. Line No.");
    end;


    procedure UpdateSellToCont(CustomerNo: Code[20])
    var
        ContBusRel: Record "Contact Business Relation";
        Cust: Record Customer;
    begin
        if Cust.Get(CustomerNo) then begin
            if Cust."Primary Contact No." <> '' then
                "Sell-to Contact No." := Cust."Primary Contact No."
            else begin
                ContBusRel.Reset;
                ContBusRel.SetCurrentkey("Link to Table", "No.");
                ContBusRel.SetRange("Link to Table", ContBusRel."link to table"::Customer);
                ContBusRel.SetRange("No.", "Sell-to Customer No.");
                if ContBusRel.FindFirst then begin
                    "Sell-to Contact No." := ContBusRel."Contact No.";
                end;
            end;
            "Sell-to Contact" := Cust.Contact;
        end;
    end;


    procedure UpdateBillToCont(CustomerNo: Code[20])
    var
        ContBusRel: Record "Contact Business Relation";
        Cust: Record Customer;
    begin
        if Cust.Get(CustomerNo) then begin
            if Cust."Primary Contact No." <> '' then
                "Bill-to Contact No." := Cust."Primary Contact No."
            else begin
                ContBusRel.Reset;
                ContBusRel.SetCurrentkey("Link to Table", "No.");
                ContBusRel.SetRange("Link to Table", ContBusRel."link to table"::Customer);
                ContBusRel.SetRange("No.", "Bill-to Customer No.");
                if ContBusRel.FindFirst then
                    "Bill-to Contact No." := ContBusRel."Contact No.";
            end;
            "Bill-to Contact" := Cust.Contact;
        end;
    end;


    procedure UpdateSellToCust(ContactNo: Code[20])
    var
        ContBusinessRelation: Record "Contact Business Relation";
        Customer: Record Customer;
        Cont: Record Contact;
        CustTemplate: Record "Customer Templ.";
        ContComp: Record Contact;
    begin
        if Cont.Get(ContactNo) then
            "Sell-to Contact No." := Cont."No."
        else begin
            "Sell-to Contact" := '';
            exit;
        end;

        ContBusinessRelation.Reset;
        ContBusinessRelation.SetCurrentkey("Link to Table", "Contact No.");
        ContBusinessRelation.SetRange("Link to Table", ContBusinessRelation."link to table"::Customer);
        ContBusinessRelation.SetRange("Contact No.", Cont."Company No.");
        if ContBusinessRelation.FindFirst then begin
            if ("Sell-to Customer No." <> '') and
               ("Sell-to Customer No." <> ContBusinessRelation."No.")
            then
                Error(Text037, Cont."No.", Cont.Name, "Sell-to Customer No.")
            else
                if "Sell-to Customer No." = '' then begin
                    SkipSellToContact := true;
                    Validate("Sell-to Customer No.", ContBusinessRelation."No.");
                    SkipSellToContact := false;
                end;
        end else begin
            if "Document Type" = "document type"::Quote then begin
                Cont.TestField("Company No.");
                ContComp.Get(Cont."Company No.");
                "Sell-to Customer Name" := ContComp."Company Name";
                "Sell-to Customer Name 2" := ContComp."Name 2";
                "Ship-to Name" := ContComp."Company Name";
                "Ship-to Name 2" := ContComp."Name 2";
                "Ship-to Address" := ContComp.Address;
                "Ship-to Address 2" := ContComp."Address 2";
                "Ship-to City" := ContComp.City;
                "Ship-to Post Code" := ContComp."Post Code";
                "Ship-to County" := ContComp.County;
                Validate("Ship-to Country/Region Code", ContComp."Country/Region Code");
                if ("Sell-to Customer Template Code" = '') and (not CustTemplate.IsEmpty) then
                    Validate("Sell-to Customer Template Code", Cont.FindNewCustomerTemplate);
            end else
                Error(Text039, Cont."No.", Cont.Name);
        end;

        if Cont.Type = Cont.Type::Person then
            "Sell-to Contact" := Cont.Name
        else
            if Customer.Get("Sell-to Customer No.") then
                "Sell-to Contact" := Customer.Contact
            else
                "Sell-to Contact" := '';

        if "Document Type" = "document type"::Quote then begin
            if Customer.Get("Sell-to Customer No.") or Customer.Get(ContBusinessRelation."No.") then begin
                if Customer."Copy Sell-to Addr. to Qte From" = Customer."copy sell-to addr. to qte from"::Company then begin
                    Cont.TestField("Company No.");
                    Cont.Get(Cont."Company No.");
                end;
            end else begin
                Cont.TestField("Company No.");
                Cont.Get(Cont."Company No.");
            end;
            "Sell-to Address" := Cont.Address;
            "Sell-to Address 2" := Cont."Address 2";
            "Sell-to City" := Cont.City;
            "Sell-to Post Code" := Cont."Post Code";
            "Sell-to County" := Cont.County;
            "Sell-to Country/Region Code" := Cont."Country/Region Code";
        end;
        if ("Sell-to Customer No." = "Bill-to Customer No.") or
           ("Bill-to Customer No." = '')
        then
            Validate("Bill-to Contact No.", "Sell-to Contact No.");
    end;


    procedure UpdateBillToCust(ContactNo: Code[20])
    var
        ContBusinessRelation: Record "Contact Business Relation";
        Cust: Record Customer;
        Cont: Record Contact;
        CustTemplate: Record "Customer Templ.";
        ContComp: Record Contact;
    begin
        if Cont.Get(ContactNo) then begin
            "Bill-to Contact No." := Cont."No.";
            if Cont.Type = Cont.Type::Person then
                "Bill-to Contact" := Cont.Name
            else
                if Cust.Get("Bill-to Customer No.") then
                    "Bill-to Contact" := Cust.Contact
                else
                    "Bill-to Contact" := '';
        end else begin
            "Bill-to Contact" := '';
            exit;
        end;

        ContBusinessRelation.Reset;
        ContBusinessRelation.SetCurrentkey("Link to Table", "Contact No.");
        ContBusinessRelation.SetRange("Link to Table", ContBusinessRelation."link to table"::Customer);
        ContBusinessRelation.SetRange("Contact No.", Cont."Company No.");
        if ContBusinessRelation.FindFirst then begin
            if "Bill-to Customer No." = '' then begin
                SkipBillToContact := true;
                Validate("Bill-to Customer No.", ContBusinessRelation."No.");
                SkipBillToContact := false;
                "Bill-to Customer Template Code" := '';
            end else
                if "Bill-to Customer No." <> ContBusinessRelation."No." then
                    Error(Text037, Cont."No.", Cont.Name, "Bill-to Customer No.");
        end else begin
            if "Document Type" = "document type"::Quote then begin
                Cont.TestField("Company No.");
                ContComp.Get(Cont."Company No.");
                "Bill-to Name" := ContComp."Company Name";
                "Bill-to Name 2" := ContComp."Name 2";
                "Bill-to Address" := ContComp.Address;
                "Bill-to Address 2" := ContComp."Address 2";
                "Bill-to City" := ContComp.City;
                "Bill-to Post Code" := ContComp."Post Code";
                "Bill-to County" := ContComp.County;
                "Bill-to Country/Region Code" := ContComp."Country/Region Code";
                "VAT Registration No." := ContComp."VAT Registration No.";
                Validate("Currency Code", ContComp."Currency Code");
                "Language Code" := ContComp."Language Code";
                if ("Bill-to Customer Template Code" = '') and (not CustTemplate.IsEmpty) then
                    Validate("Bill-to Customer Template Code", Cont.FindNewCustomerTemplate);
            end else
                Error(Text039, Cont."No.", Cont.Name);
        end;
    end;


    procedure MessageIfSalesLinesExist(ChangedFieldName: Text[100])
    begin
        if SalesLinesExist and not HideValidationDialog then
            Message(
              Text018 +
              Text019,
              ChangedFieldName);
    end;

    local procedure UpdateShipToAddress()
    begin
        if "Document Type" in ["document type"::"Return Order"] then begin
            if "Location Code" <> '' then begin
                Location.Get("Location Code");
                "Ship-to Name" := Location.Name;
                "Ship-to Name 2" := Location."Name 2";
                "Ship-to Address" := Location.Address;
                "Ship-to Address 2" := Location."Address 2";
                "Ship-to City" := Location.City;
                "Ship-to Post Code" := Location."Post Code";
                "Ship-to County" := Location.County;
                "Ship-to Country/Region Code" := Location."Country/Region Code";
                "Ship-to Contact" := Location.Contact;
            end else begin
                CompanyInfo.Get;
                "Ship-to Code" := '';
                "Ship-to Name" := CompanyInfo."Ship-to Name";
                "Ship-to Name 2" := CompanyInfo."Ship-to Name 2";
                "Ship-to Address" := CompanyInfo."Ship-to Address";
                "Ship-to Address 2" := CompanyInfo."Ship-to Address 2";
                "Ship-to City" := CompanyInfo."Ship-to City";
                "Ship-to Post Code" := CompanyInfo."Ship-to Post Code";
                "Ship-to County" := CompanyInfo."Ship-to County";
                "Ship-to Country/Region Code" := CompanyInfo."Ship-to Country/Region Code";
                "Ship-to Contact" := CompanyInfo."Ship-to Contact";
            end;
            "VAT Country/Region Code" := "Sell-to Country/Region Code";
        end;
    end;


    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20]; Type3: Integer; No3: Code[20]; Type4: Integer; No4: Code[20]; Type5: Integer; No5: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        OldDimSetID: Integer;
        Dimsource: List of [Dictionary of [Integer, code[20]]];
    begin
        OldDimSetID := "Dimension Set ID";
        SourceCodeSetup.Get;
        /* TableID[1] := Type1;
        No[1] := No1;
        TableID[2] := Type2;
        No[2] := No2;
        TableID[3] := Type3;
        No[3] := No3;
        TableID[4] := Type4;
        No[4] := No4;
        TableID[5] := Type5;
        No[5] := No5;*/
        Clear(Dimsource);
        DimMgt.AddDimSource(Dimsource, Type1, No1);
        DimMgt.AddDimSource(Dimsource, Type2, No2);
        DimMgt.AddDimSource(Dimsource, Type3, No3);
        DimMgt.AddDimSource(Dimsource, Type4, No4);
        DimMgt.AddDimSource(Dimsource, Type5, No5);

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        "Dimension Set ID" :=
          DimMgt.GetRecDefaultDimID(
            Rec, CurrFieldNo, Dimsource, SourceCodeSetup."Rent Management", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);

        UpdateAllLineDim("Dimension Set ID", OldDimSetID);
    end;

    local procedure UpdateCurrencyFactor()
    begin
        if "Currency Code" <> '' then begin
            if ("Document Type" in ["document type"::Quote]) and
               ("Posting Date" = 0D)
            then
                CurrencyDate := WorkDate
            else
                CurrencyDate := "Posting Date";

            "Currency Factor" := CurrExchRate.ExchangeRate(CurrencyDate, "Currency Code");
        end else
            "Currency Factor" := 0;
    end;

    local procedure ConfirmUpdateCurrencyFactor()
    begin
        if HideValidationDialog then
            Confirmed := true
        else
            Confirmed := Confirm(Text021, false);
        if Confirmed then
            Validate("Currency Factor")
        else
            "Currency Factor" := xRec."Currency Factor";
    end;


    procedure UpdateSalesLines(ChangedFieldName: Text[100]; AskQuestion: Boolean)
    var
        JobTransferLine: Codeunit "Job Transfer Line";
        Question: Text[250];
        UpdateLines: Boolean;
    begin
        if SalesLinesExist and AskQuestion then begin
            Question := StrSubstNo(
                Text031 +
                Text032, ChangedFieldName);
            if GuiAllowed and not Dialog.Confirm(Question, true) then
                exit
            else
                UpdateLines := true;
        end;
        if SalesLinesExist then begin
            RentSalesLine.LockTable;
            Modify;

            RentSalesLine.Reset;
            RentSalesLine.SetRange("Document Type", "Document Type");
            RentSalesLine.SetRange("Document No.", "No.");
            if RentSalesLine.FindSet then
                repeat
                    case ChangedFieldName of
                        FieldCaption("Shipment Date"):
                            if RentSalesLine."No." <> '' then
                                RentSalesLine.Validate("Shipment Date", "Shipment Date");
                        FieldCaption("Currency Factor"):
                            if RentSalesLine.Type <> RentSalesLine.Type::" " then begin
                                RentSalesLine.Validate("Unit Price");
                                RentSalesLine.Validate("Unit Cost (LCY)");
                            end;
                        FieldCaption("Transaction Type"):
                            RentSalesLine.Validate("Transaction Type", "Transaction Type");
                        FieldCaption("Transport Method"):
                            RentSalesLine.Validate("Transport Method", "Transport Method");
                        FieldCaption("Exit Point"):
                            RentSalesLine.Validate("Exit Point", "Exit Point");
                        FieldCaption(Area):
                            RentSalesLine.Validate(Area, Area);
                        FieldCaption("Transaction Specification"):
                            RentSalesLine.Validate("Transaction Specification", "Transaction Specification");
                        FieldCaption("Shipping Agent Code"):
                            RentSalesLine.Validate("Shipping Agent Code", "Shipping Agent Code");
                        FieldCaption("Shipping Agent Service Code"):
                            if RentSalesLine."No." <> '' then
                                RentSalesLine.Validate("Shipping Agent Service Code", "Shipping Agent Service Code");
                        FieldCaption("Shipping Time"):
                            if RentSalesLine."No." <> '' then
                                RentSalesLine.Validate("Shipping Time", "Shipping Time");
                        FieldCaption("Prepayment %"):
                            if RentSalesLine."No." <> '' then
                                RentSalesLine.Validate("Prepayment %", "Prepayment %");
                        FieldCaption("Requested Delivery Date"):
                            if RentSalesLine."No." <> '' then
                                RentSalesLine.Validate("Requested Delivery Date", "Requested Delivery Date");
                        FieldCaption("Promised Delivery Date"):
                            if RentSalesLine."No." <> '' then
                                RentSalesLine.Validate("Promised Delivery Date", "Promised Delivery Date");
                        FieldCaption("Outbound Whse. Handling Time"):
                            if RentSalesLine."No." <> '' then
                                RentSalesLine.Validate("Outbound Whse. Handling Time", "Outbound Whse. Handling Time");
                        FieldCaption("Deal Type"):
                            if RentSalesLine."No." <> '' then
                                RentSalesLine.Validate("Deal Type", "Deal Type");
                    end;
                    RentSalesLine.Modify(false);
                until RentSalesLine.Next = 0;
        end;
    end;

    local procedure GetPostingNoSeriesCode(): Code[10]
    begin
        if "Document Type" in ["document type"::"Return Order"] then
            exit(SalesSetup."Posted Credit Memo Nos.");
        exit(SalesSetup."Posted Invoice Nos.");
    end;


    procedure CheckCustomerCreated(Prompt: Boolean): Boolean
    var
        Cont: Record Contact;
    begin
        if ("Bill-to Customer No." <> '') and ("Sell-to Customer No." <> '') then
            exit(true);

        if Prompt then
            if not Confirm(Text035, true) then
                exit(false);

        if "Sell-to Customer No." = '' then begin
            TestField("Sell-to Contact No.");
            TestField("Sell-to Customer Template Code");
            Cont.Get("Sell-to Contact No.");
            Cont.CreateCustomerFromTemplate("Sell-to Customer Template Code");
            Commit;
            Get("document type"::Quote, "No.");
        end;

        if "Bill-to Customer No." = '' then begin
            TestField("Bill-to Contact No.");
            TestField("Bill-to Customer Template Code");
            Cont.Get("Bill-to Contact No.");
            Cont.CreateCustomerFromTemplate("Bill-to Customer Template Code");
            Commit;
            Get("document type"::Quote, "No.");
        end;

        exit(("Bill-to Customer No." <> '') and ("Sell-to Customer No." <> ''));
    end;


    procedure CreatePrepaymentLines()
    var
        Window: Dialog;
        PrepaymentAmount: Decimal;
        RentHeader1: Record "Rent Header";
        RentSalesLine: Record "Rent Sales Line";
        Resource1: Record Resource;
        iLineNo: Integer;
        InvPostBuffer: Record "Invoice Posting Buffer";
        Proportion: Decimal;
        InsertedAmount: Decimal;
        ReleaseRentDocument: Codeunit "Release Rent Document";
        PrepaymentResource: Code[20];
        DialogText: label 'Amount Including VAT';
        PositiveLineText: label 'Rent Advance Payment';
        NegativeLineText: label 'Recieved Advance Payment';
        AmtInput: Page "Rent Input Amount";
    begin
        ReleaseRentDocument.Run(Rec);
        Commit;
        CalcFields("Rent Amount Including VAT");
        PrepaymentAmount := "Rent Amount Including VAT";
        AmtInput.SetAdvanceAmt(PrepaymentAmount);
        AmtInput.SetRentAmt("Rent Amount Including VAT");
        if AmtInput.RunModal = Action::OK then begin
            PrepaymentAmount := AmtInput.GetAdvanceAmt;
            Clear(AmtInput);
            Clear(ReleaseRentDocument);
            ReleaseRentDocument.Reopen(Rec);
            if PrepaymentAmount > 0 then begin
                RentSetup.Get;
                RentSetup.TestField("Advance Payment Resource Code");
                PrepaymentResource := RentSetup."Advance Payment Resource Code";
                Resource1.Get(PrepaymentResource);

                InvPostBuffer.Reset;
                InvPostBuffer.DeleteAll;

                InvPostBuffer.Reset;
                InvPostBuffer.Init;
                InvPostBuffer."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
                InvPostBuffer."Gen. Prod. Posting Group" := Resource1."Gen. Prod. Posting Group";
                InvPostBuffer."VAT Bus. Posting Group" := "VAT Bus. Posting Group";
                InvPostBuffer."VAT Prod. Posting Group" := Resource1."VAT Prod. Posting Group";
                InvPostBuffer.Amount := "Amount Including VAT";
                InvPostBuffer.Insert;

                InvPostBuffer.Reset;
                if InvPostBuffer.Count > 0 then begin
                    iLineNo := 0;
                    RentSalesLine.Reset;
                    RentSalesLine.SetRange("Document Type", "Document Type");
                    RentSalesLine.SetRange("Document No.", "No.");
                    if RentSalesLine.FindLast then
                        iLineNo := RentSalesLine."Line No.";

                    if InvPostBuffer.FindFirst then begin
                        repeat
                            //Positive line
                            iLineNo := iLineNo + 10000;
                            RentSalesLine.Init;
                            RentSalesLine."Document Type" := "Document Type";
                            RentSalesLine."Document No." := "No.";
                            RentSalesLine."Line No." := iLineNo;
                            RentSalesLine.Type := RentSalesLine.Type::Resource;
                            RentSalesLine.Validate("No.", PrepaymentResource);
                            //RentSalesLine.Validate(Description, PositiveLineText);
                            RentSalesLine.Validate(Quantity, 1);
                            RentSalesLine.Validate("Unit Price", PrepaymentAmount);
                            RentSalesLine."Gen. Bus. Posting Group" := InvPostBuffer."Gen. Bus. Posting Group";
                            RentSalesLine."Gen. Prod. Posting Group" := InvPostBuffer."Gen. Prod. Posting Group";
                            RentSalesLine."VAT Bus. Posting Group" := InvPostBuffer."VAT Bus. Posting Group";
                            RentSalesLine.Validate("VAT Prod. Posting Group", InvPostBuffer."VAT Prod. Posting Group");
                            RentSalesLine.Prepayment := true;
                            RentSalesLine.Insert(true);

                            //Negative line
                            iLineNo := iLineNo + 10000;
                            RentSalesLine.Init;
                            RentSalesLine."Document Type" := "Document Type";
                            RentSalesLine."Document No." := "No.";
                            RentSalesLine."Line No." := iLineNo;
                            RentSalesLine.Type := RentSalesLine.Type::Resource;
                            RentSalesLine.Validate("No.", PrepaymentResource);
                            //RentSalesLine.Validate(Description, NegativeLineText);
                            RentSalesLine.Validate(Quantity, -1);
                            RentSalesLine.Validate("Qty. to Ship", 0);
                            RentSalesLine.Validate("Unit Price", PrepaymentAmount);
                            RentSalesLine."Gen. Bus. Posting Group" := InvPostBuffer."Gen. Bus. Posting Group";
                            RentSalesLine."Gen. Prod. Posting Group" := InvPostBuffer."Gen. Prod. Posting Group";
                            RentSalesLine."VAT Bus. Posting Group" := InvPostBuffer."VAT Bus. Posting Group";
                            RentSalesLine.Validate("VAT Prod. Posting Group", InvPostBuffer."VAT Prod. Posting Group");
                            RentSalesLine.Prepayment := true;
                            RentSalesLine.Insert(true);
                            RentSalesLine."To Invoice" := false;
                            RentSalesLine.Modify();
                        until InvPostBuffer.Next = 0;
                    end;
                end;
            end;
            Clear(ReleaseRentDocument);
            ReleaseRentDocument.Run(Rec);
        end;
    end;


    procedure CreateDepositLines()
    var
        Window: Dialog;
        PrepaymentAmount: Decimal;
        RentHeader1: Record "Rent Header";
        RentSalesLine: Record "Rent Sales Line";
        Resource1: Record Resource;
        iLineNo: Integer;
        InvPostBuffer: Record "Invoice Posting Buffer";
        Proportion: Decimal;
        InsertedAmount: Decimal;
        ReleaseRentDocument: Codeunit "Release Rent Document";
        PrepaymentResource: Code[20];
        DialogText: label 'Amount Without VAT #1######\Deposit Amount Without VAT #2######';
        PositiveLineText: label 'Rent Deposit';
        NegativeLineText: label 'Recieved Deposit';
        RentLine: Record "Rent Line";
        AmtInput: Page "Rent Input Amount";
    begin
        ReleaseRentDocument.Run(Rec);
        RentLine.Reset;
        RentLine.SetRange("Document No.", "No.");
        if RentLine.FindFirst then
            repeat
                if "Prices Including VAT" then
                    PrepaymentAmount += ROUND(RentLine."Line Amount" / (1 + RentLine."VAT %" / 100), 0.01)
                else
                    PrepaymentAmount += RentLine."Line Amount";
            until RentLine.Next = 0;

        AmtInput.SetDepositAmt(PrepaymentAmount);
        AmtInput.SetRentAmt(PrepaymentAmount);
        if AmtInput.RunModal = Action::OK then begin
            PrepaymentAmount := AmtInput.GetDepositAmt;
            Clear(AmtInput);
            Clear(ReleaseRentDocument);
            ReleaseRentDocument.Reopen(Rec);
            if PrepaymentAmount > 0 then begin
                RentSetup.Get;
                RentSetup.TestField("Advance Payment Resource Code");
                PrepaymentResource := RentSetup."Deposit Resource Code";
                Resource1.Get(PrepaymentResource);

                InvPostBuffer.Reset;
                InvPostBuffer.DeleteAll;

                InvPostBuffer.Reset;
                InvPostBuffer.Init;
                InvPostBuffer."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
                InvPostBuffer."Gen. Prod. Posting Group" := Resource1."Gen. Prod. Posting Group";
                InvPostBuffer."VAT Bus. Posting Group" := "VAT Bus. Posting Group";
                InvPostBuffer."VAT Prod. Posting Group" := Resource1."VAT Prod. Posting Group";
                InvPostBuffer.Amount := "Amount Including VAT";
                InvPostBuffer.Insert;

                InvPostBuffer.Reset;
                if InvPostBuffer.Count > 0 then begin
                    iLineNo := 0;
                    RentSalesLine.Reset;
                    RentSalesLine.SetRange("Document Type", "Document Type");
                    RentSalesLine.SetRange("Document No.", "No.");
                    if RentSalesLine.FindLast then
                        iLineNo := RentSalesLine."Line No.";

                    if InvPostBuffer.FindFirst then begin
                        repeat
                            //Positive line
                            iLineNo := iLineNo + 10000;
                            RentSalesLine.Init;
                            RentSalesLine."Document Type" := "Document Type";
                            RentSalesLine."Document No." := "No.";
                            RentSalesLine."Line No." := iLineNo;
                            RentSalesLine."Gen. Bus. Posting Group" := InvPostBuffer."Gen. Bus. Posting Group";
                            RentSalesLine."VAT Bus. Posting Group" := InvPostBuffer."VAT Bus. Posting Group";
                            RentSalesLine.Type := RentSalesLine.Type::Resource;
                            RentSalesLine.Validate("No.", PrepaymentResource);
                            //RentSalesLine.Validate(Description, PositiveLineText);
                            RentSalesLine.Validate(Quantity, 1);
                            RentSalesLine.Validate("Unit Price", PrepaymentAmount);
                            RentSalesLine."Gen. Prod. Posting Group" := InvPostBuffer."Gen. Prod. Posting Group";
                            RentSalesLine.Validate("VAT Prod. Posting Group", InvPostBuffer."VAT Prod. Posting Group");
                            RentSalesLine.Deposit := true;
                            RentSalesLine.Insert(true);

                            //Negative line
                            iLineNo := iLineNo + 10000;
                            RentSalesLine.Init;
                            RentSalesLine."Document Type" := "Document Type";
                            RentSalesLine."Document No." := "No.";
                            RentSalesLine."Line No." := iLineNo;
                            RentSalesLine."Gen. Bus. Posting Group" := InvPostBuffer."Gen. Bus. Posting Group";
                            RentSalesLine."VAT Bus. Posting Group" := InvPostBuffer."VAT Bus. Posting Group";
                            RentSalesLine.Type := RentSalesLine.Type::Resource;
                            RentSalesLine.Validate("No.", PrepaymentResource);
                            //RentSalesLine.Validate(Description, NegativeLineText);
                            RentSalesLine.Validate(Quantity, -1);
                            RentSalesLine.Validate("Qty. to Ship", 0);
                            RentSalesLine.Validate("Unit Price", PrepaymentAmount);
                            RentSalesLine."Gen. Prod. Posting Group" := InvPostBuffer."Gen. Prod. Posting Group";
                            RentSalesLine.Validate("VAT Prod. Posting Group", InvPostBuffer."VAT Prod. Posting Group");
                            RentSalesLine.Deposit := true;
                            RentSalesLine.Insert(true);
                            RentSalesLine."To Invoice" := false;
                            RentSalesLine.Modify();
                        until InvPostBuffer.Next = 0;
                    end;
                end;
            end;
            "Deposit Amount" := PrepaymentAmount;
            Modify;
            Clear(ReleaseRentDocument);
            ReleaseRentDocument.Run(Rec);
        end;
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
    end;

    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "Dimension Set ID", StrSubstNo('%1 %2', "Document Type", "No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
        if OldDimSetID <> "Dimension Set ID" then begin
            Modify;
            UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    local procedure CheckCreditLimitIfLineNotInsertedYet()
    begin
        if "No." = '' then begin
            HideCreditCheckDialogue := false;
            CheckCreditMaxBeforeInsert;
            HideCreditCheckDialogue := true;
        end;
    end;


    procedure CheckCreditMaxBeforeInsert()
    var
        RentHeader: Record "Rent Header";
        ContBusinessRelation: Record "Contact Business Relation";
        Cont: Record Contact;
        //CustCheckCreditLimit: Codeunit "Cust-Check Cr. Limit";
        ItemSalesDocMgtEDMS: Codeunit "Item Sales Doc. Mgt. EDMS";
    begin
        if HideCreditCheckDialogue then
            exit;
        if (GetFilterCustNo <> '') or ("Sell-to Customer No." <> '') then begin
            if "Sell-to Customer No." <> '' then
                Cust.Get("Sell-to Customer No.")
            else
                Cust.Get(GetFilterCustNo);
            if Cust."Bill-to Customer No." <> '' then
                RentHeader."Bill-to Customer No." := Cust."Bill-to Customer No."
            else
                RentHeader."Bill-to Customer No." := Cust."No.";
            ItemSalesDocMgtEDMS.RentHeaderCheck(RentHeader);
        end else
            if GetFilterContNo <> '' then begin
                Cont.Get(GetFilterContNo);
                if ContBusinessRelation.FindByContact(ContBusinessRelation."link to table"::Customer, Cont."Company No.") then begin
                    Cust.Get(ContBusinessRelation."No.");
                    if Cust."Bill-to Customer No." <> '' then
                        RentHeader."Bill-to Customer No." := Cust."Bill-to Customer No."
                    else
                        RentHeader."Bill-to Customer No." := Cust."No.";
                    ItemSalesDocMgtEDMS.RentHeaderCheck(RentHeader);
                end;
            end;
    end;

    local procedure GetFilterCustNo(): Code[20]
    var
        MinValue: Code[20];
        MaxValue: Code[20];
    begin
        if GetFilter("Sell-to Customer No.") <> '' then begin
            if TryGetFilterCustNoRange(MinValue, MaxValue) then
                if MinValue = MaxValue then
                    exit(MaxValue);
        end;
    end;

    local procedure GetFilterContNo(): Code[20]
    begin
        if GetFilter("Sell-to Contact No.") <> '' then
            if GetRangeMin("Sell-to Contact No.") = GetRangemax("Sell-to Contact No.") then
                exit(GetRangemax("Sell-to Contact No."));
    end;

    [TryFunction]
    local procedure TryGetFilterCustNoRange(var MinValue: Code[20]; var MaxValue: Code[20])
    begin
        MinValue := GetRangeMin("Sell-to Customer No.");
        MaxValue := GetRangemax("Sell-to Customer No.");
    end;

    local procedure CheckCrLimit()
    var
        RentHeader: Record "Rent Header";
        RentLine: Record "Rent Line";
        ItemSalesDocMgtEDMS: Codeunit "Item Sales Doc. Mgt. EDMS";
    begin
        RentHeader := Rec;

        if GuiAllowed and
           (CurrFieldNo <> 0) and
           RentHeader.Find
        then begin
            "Amount Including VAT" := 0;
            if "Document Type" = "document type"::Order then
                if BilltoCustomerNoChanged then begin
                    RentLine.Reset;
                    RentLine.SetRange("Document Type", RentLine."document type"::Order);
                    RentLine.SetRange("Document No.", "No.");
                    RentLine.CalcSums("Amount Including VAT");
                    "Amount Including VAT" := "Amount Including VAT";
                end;
            ItemSalesDocMgtEDMS.RentHeaderCheck(Rec);
            CalcFields("Amount Including VAT");
        end;
    end;

    local procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        NewDimSetID: Integer;
        RentLine: Record "Rent Line";
        RentSalesLine: Record "Rent Sales Line";
    begin
        // Update all lines with changed dimensions.

        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if "No." = '' then
            exit;
        if not (RentLinesExist() or SalesLinesExist()) then
            exit;
        if not Confirm(Text064) then
            exit;

        RentLine.Reset;
        RentLine.SetRange("Document Type", "Document Type");
        RentLine.SetRange("Document No.", "No.");
        RentLine.LockTable;
        if RentLine.FindSet(true, false) then
            repeat
                NewDimSetID := DimMgt.GetDeltaDimSetID(RentLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if RentLine."Dimension Set ID" <> NewDimSetID then begin
                    RentLine."Dimension Set ID" := NewDimSetID;
                    DimMgt.UpdateGlobalDimFromDimSetID(
                      RentLine."Dimension Set ID", RentLine."Shortcut Dimension 1 Code", RentLine."Shortcut Dimension 2 Code");
                    RentLine.Modify;
                end;
            until RentLine.Next = 0;

        RentSalesLine.Reset;
        RentSalesLine.SetRange("Document Type", "Document Type");
        RentSalesLine.SetRange("Document No.", "No.");
        RentSalesLine.LockTable;
        if RentSalesLine.FindSet(true, false) then
            repeat
                NewDimSetID := DimMgt.GetDeltaDimSetID(RentSalesLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if RentSalesLine."Dimension Set ID" <> NewDimSetID then begin
                    RentSalesLine."Dimension Set ID" := NewDimSetID;
                    DimMgt.UpdateGlobalDimFromDimSetID(
                      RentSalesLine."Dimension Set ID", RentSalesLine."Shortcut Dimension 1 Code", RentSalesLine."Shortcut Dimension 2 Code");
                    RentSalesLine.Modify;
                end;
            until RentSalesLine.Next = 0;
    end;


    procedure UpdateRentLines(ChangedFieldName: Text[100]; AskQuestion: Boolean)
    var
        Question: Text[250];
        UpdateLines: Boolean;
    begin
        if RentLinesExist and AskQuestion then begin
            Question := StrSubstNo(
                Text031 +
                Text132, ChangedFieldName);
            if GuiAllowed and not Dialog.Confirm(Question, true) then
                exit
            else
                UpdateLines := true;
        end;
        if RentLinesExist then begin
            RentLine.LockTable;
            Modify;

            RentLine.Reset;
            RentLine.SetRange("Document Type", "Document Type");
            RentLine.SetRange("Document No.", "No.");
            if RentLine.FindSet then
                repeat
                    case ChangedFieldName of
                        FieldCaption("Shipment Date"):
                            begin
                                if RentLine."Planned Shipment Date" = 0D then
                                    RentLine.Validate("Planned Shipment Date", "Shipment Date");
                            end;
                        FieldCaption("Currency Factor"):
                            RentLine.Validate("Unit Price");
                    end;
                    RentLine.Modify(true);
                until RentLine.Next = 0;
        end;
    end;


    procedure RentLinesExist(): Boolean
    begin
        RentLine.Reset;
        RentLine.SetRange("Document Type", "Document Type");
        RentLine.SetRange("Document No.", "No.");
        exit(RentLine.FindFirst);
    end;


    procedure GetUserSetup()
    var
        UserSetup: Record "User Setup";
        SingleInstanceMgt: Codeunit SingleInstanceManagement;
        UserProfileMgt: Codeunit UserProfileManagement;
        UserProfile: Record "Branch Profile Setup";
        ServSetup: Record "Service Mgt. Setup EDMS";
        ServLocation: Code[20];
    begin
        if UserSetup.Get(UserId) then begin
            if UserSetup."Salespers./Purch. Code" <> '' then
                Validate("Salesperson Code", UserSetup."Salespers./Purch. Code");
        end;

        if UserProfileMgt.CurrProfileID <> '' then begin
            if UserProfile.Get(UserProfileMgt.CurrProfileID, UserProfileMgt.CurrBranchNo) then begin
                if UserProfile."Default Location Code" <> '' then
                    Validate("Location Code", UserProfile."Default Location Code");
                if UserProfile."Default Deal Type Code" <> '' then
                    Validate("Deal Type", UserProfile."Default Deal Type Code");
            end;
        end;
    end;


    procedure CloseRentOrder()
    var
        RentLineToCheck: Record "Rent Line";
        RentSalesLineToCheck: Record "Rent Sales Line";
        RentTransferLineToCheck: Record "Rent Transfer Line";
        RentLedgerEntryToCheck: Record "Rent Ledger Entry";
    begin
        RentLineToCheck.Reset;
        RentLineToCheck.SetRange("Document Type", "Document Type");
        RentLineToCheck.SetRange("Document No.", "No.");
        if RentLineToCheck.FindSet then
            repeat
                if RentLineToCheck.Status <> RentLineToCheck.Status::Returned then
                    Error(RenStatusReturned, RentLineToCheck."Line No.", RentLineToCheck."Rent Item No.", RentLineToCheck."Rent Asset No.");
                if RentLineToCheck."Unit Price" > 0 then
                    if RentLineToCheck."Manual Invoicing End Date" <> 0D then begin
                        if RentLineToCheck."Manual Invoicing End Date" > RentLineToCheck."Last Date Invoiced" then
                            Error(CloseCheckRentLineNotInvoiced, RentLineToCheck."Line No.", RentLineToCheck."Rent Asset No.", RentLineToCheck."Rent Item No.")
                    end else begin
                        RentLineToCheck.CalcFields("Actual Return Date");
                        if RentLineToCheck."Actual Return Date" > RentLineToCheck."Last Date Invoiced" then
                            Error(CloseCheckRentLineNotInvoiced, RentLineToCheck."Line No.", RentLineToCheck."Rent Asset No.", RentLineToCheck."Rent Item No.");
                    end;

            //if RentLineToCheck.Quantity > RentLineToCheck."Quantity Invoiced" then
            //    Error(CloseCheckRentLineNotInvoiced, Format(RentLineToCheck."Line No."), RentLineToCheck."Rent Asset No.", RentLineToCheck."Rent Item No.");
            until RentLineToCheck.Next = 0;

        RentSalesLineToCheck.Reset;
        RentSalesLineToCheck.SetRange("Document Type", "Document Type");
        RentSalesLineToCheck.SetRange("Document No.", "No.");
        RentSalesLineToCheck.SetRange("Rent Ledger Entry No.", 0);
        RentSalesLineToCheck.SetRange("Extra Charge Line", false);
        if RentSalesLineToCheck.FindFirst then
            Error(CloseCheckRentSalesLineNotInvoiced, Format(RentSalesLineToCheck."Line No."), RentSalesLineToCheck.Description);

        RentTransferLineToCheck.Reset;
        RentTransferLineToCheck.SetRange("Rent Order No.", "No.");
        if RentTransferLineToCheck.FindFirst then
            Error(CloseCheckTransferExists, RentTransferLineToCheck."Document No.");

        RentLedgerEntryToCheck.Reset;
        RentLedgerEntryToCheck.SetRange("Rent Order No.", "No.");
        RentLedgerEntryToCheck.SetFilter("Outstanding Qty.", '>0');
        if RentLedgerEntryToCheck.FindFirst then
            Error(CloseCheckNotReturned, RentLedgerEntryToCheck."Rent Asset No.");

        Closed := true;
        RentLine.Reset();
        RentLine.SetRange("Document No.", "No.");
        if RentLine.FindFirst() then
            repeat
                RentLine.Closed := true;
                RentLine.Modify(false);
            until RentLine.Next = 0;
    end;

    procedure GetRentAmtLCY(): Decimal
    begin

    end;

    local procedure ShouldLookForCustomerByName(CustomerNo: Code[20]): Boolean
    var
        Customer: Record Customer;
    begin
        if CustomerNo = '' then
            exit(true);

        if not Customer.Get(CustomerNo) then
            exit(true);

        exit(not Customer."Disable Search by Name");
    end;

    local procedure LookupContact(CustomerNo: Code[20]; ContactNo: Code[20]; var Contact: Record Contact)
    var
        ContactBusinessRelation: Record "Contact Business Relation";
        FilterByContactCompany: Boolean;
    begin
        if ContactBusinessRelation.FindByRelation(ContactBusinessRelation."Link to Table"::Customer, CustomerNo) then
            Contact.SetRange("Company No.", ContactBusinessRelation."Contact No.")
        else
            if "Document Type" = "Document Type"::Quote then
                FilterByContactCompany := true
            else
                Contact.SetRange("Company No.", '');
        if ContactNo <> '' then
            if Contact.Get(ContactNo) then
                if FilterByContactCompany then
                    Contact.SetRange("Company No.", Contact."Company No.");
    end;

    procedure CopySellToAddressToShipToAddress()
    begin
        "Ship-to Address" := "Sell-to Address";
        "Ship-to Address 2" := "Sell-to Address 2";
        "Ship-to City" := "Sell-to City";
        "Ship-to Contact" := "Sell-to Contact";
        "Ship-to Country/Region Code" := "Sell-to Country/Region Code";
        "Ship-to County" := "Sell-to County";
        "Ship-to Post Code" := "Sell-to Post Code";

    end;

    procedure CopySellToAddressToBillToAddress()
    begin
        if "Bill-to Customer No." = "Sell-to Customer No." then begin
            "Bill-to Address" := "Sell-to Address";
            "Bill-to Address 2" := "Sell-to Address 2";
            "Bill-to Post Code" := "Sell-to Post Code";
            "Bill-to Country/Region Code" := "Sell-to Country/Region Code";
            "Bill-to City" := "Sell-to City";
            "Bill-to County" := "Sell-to County";

        end;
    end;

    procedure SetRentDescription(NewWorkDescription: Text)
    var
        OutStream: OutStream;
    begin
        Clear("Rent Description");
        "Rent Description".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewWorkDescription);
        Modify;
    end;

    procedure GetRentDescription(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields("Rent Description");
        "Rent Description".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
    end;



    [IntegrationEvent(false, false)]
    local procedure OnBeforeRename(var RentHeader: Record "Rent Header"; var IsHandled: Boolean; xRentHeader: Record "Rent Header")
    begin
    end;
    //>>DELTA XX
    [IntegrationEvent(false, false)]
    local procedure OnAfterValidateBillToCustomerNo(var RentHeader: Record "Rent Header"; var Cust: Record Customer)
    begin
    end;
    //<<DELTA XX    

}

