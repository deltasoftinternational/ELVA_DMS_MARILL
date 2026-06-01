Table 25006625 "Rent Transfer Header"
{
    DrillDownPageID = "Rent Transfer List";
    LookupPageID = "Rent Transfer List";

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
                        RentShipmentLine.SetRange("Document No.", "No.");
                        if "Sell-to Customer No." = '' then begin
                            if RentShipmentLine.FindFirst then
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
                        RentShipmentLine.Reset
                    end else begin
                        Rec := xRec;
                        exit;
                    end;
                end;

                GetCust("Sell-to Customer No.");

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
                Validate("Location Code", UserMgt.GetLocation(0, Cust."Location Code", "Responsibility Center"));

                if Cust."Bill-to Customer No." <> '' then
                    Validate("Bill-to Customer No.", Cust."Bill-to Customer No.")
                else begin
                    if "Bill-to Customer No." = "Sell-to Customer No." then
                        SkipBillToContact := true;
                    Validate("Bill-to Customer No.", "Sell-to Customer No.");
                    SkipBillToContact := false;
                end;

                Validate("Ship-to Code", '');
            end;
        }
        field(170; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            NotBlank = true;
            TableRelation = Customer;

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                GetCust("Bill-to Customer No.");
                Cust.TestField("Customer Posting Group");

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
                "Bill-to Mobile Phone No." := Cust."Phone No.";

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

                Validate("Payment Terms Code");
                Validate("Payment Method Code");
                Validate("Currency Code");


                if not SkipBillToContact then
                    UpdateBillToCont("Bill-to Customer No.");
            end;
        }
        field(180; "Bill-to Name"; Text[100])
        {
            Caption = 'Bill-to Name';
        }
        field(190; "Bill-to Name 2"; Text[50])
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
        }
        field(240; "Ship-to Code"; Code[10])
        {
            Caption = 'Ship-to Code';
            TableRelation = "Ship-to Address".Code where("Customer No." = field("Sell-to Customer No."));

            trigger OnValidate()
            begin
                if "Ship-to Code" <> '' then begin
                    if xRec."Ship-to Code" <> '' then begin
                        GetCust("Sell-to Customer No.");
                        if Cust."Location Code" <> '' then
                            if ("Location Code" = '') then
                                Validate("Location Code", Cust."Location Code");
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
                    "Ship-to Mobile Phone No." := ShipToAddr."Phone No.";
                    "Shipment Method Code" := ShipToAddr."Shipment Method Code";
                    if ShipToAddr."Location Code" <> '' then
                        Validate("Location Code", ShipToAddr."Location Code");
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
                        if Cust."Location Code" <> '' then
                            if ("Location Code" = '') then
                                Validate("Location Code", Cust."Location Code");
                        "Shipping Agent Code" := Cust."Shipping Agent Code";
                        "Shipping Agent Service Code" := Cust."Shipping Agent Service Code";
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
                        if "Sell-to Customer Template Code" = '' then begin
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
                        if ("Sell-to Contact No." = '') and ("Sell-to Customer No." = '') then begin
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
                        if ("Bill-to Contact No." = '') and ("Bill-to Customer No." = '') then begin
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
                        if "Bill-to Customer Template Code" = '' then begin
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
            end;
        }
        field(500; "Gen. Bus. Posting Group"; Code[10])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" then
                    if GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp, "Gen. Bus. Posting Group") then begin
                        "VAT Bus. Posting Group" := GenBusPostingGrp."Def. VAT Bus. Posting Group";
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
            end;
        }
        field(520; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(530; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
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

                "Location Code" := UserMgt.GetLocation(0, '', "Responsibility Center");

                UpdateShipToAddress;

                if xRec."Responsibility Center" <> "Responsibility Center" then begin
                    "Assigned User ID" := '';
                end;
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

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(630; "Invoice Disc. Code"; Code[20])
        {
            Caption = 'Invoice Disc. Code';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(640; "Customer Disc. Group"; Code[20])
        {
            Caption = 'Customer Disc. Group';
            TableRelation = "Customer Discount Group";

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
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

            trigger OnValidate()
            var
                ApprovalEntry: Record "Approval Entry";
            begin
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
            end;
        }
        field(730; "Shipping Agent Service Code"; Code[10])
        {
            Caption = 'Shipping Agent Service Code';
            TableRelation = "Shipping Agent Services".Code where("Shipping Agent Code" = field("Shipping Agent Code"));

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
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
                RentShipmentHeader := Rec;
                SalesSetup.Get;
                SalesSetup.TestField("Posted Shipment Nos.");
                if NoSeriesMgt.LookupRelatedNoSeries(SalesSetup."Posted Shipment Nos.", RentShipmentHeader."Shipping No. Series") then
                    RentShipmentHeader.Validate("Shipping No. Series");
                Rec := RentShipmentHeader;
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
                RentShipmentHeader := Rec;
                SalesSetup.Get;
                SalesSetup.TestField("Posted Return Receipt Nos.");
                if NoSeriesMgt.LookupRelatedNoSeries(SalesSetup."Posted Return Receipt Nos.", RentShipmentHeader."Return Receipt No. Series") then
                    RentShipmentHeader.Validate("Return Receipt No. Series");
                Rec := RentShipmentHeader;
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
                RentShipmentHeader := Rec;
                SalesSetup.Get;
                SalesSetup.TestField("Posted Prepmt. Inv. Nos.");
                if NoSeriesMgt.LookupRelatedNoSeries(SalesSetup."Posted Prepmt. Inv. Nos.", RentShipmentHeader."Prepayment No. Series") then
                    RentShipmentHeader.Validate("Prepayment No. Series");
                Rec := RentShipmentHeader;
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

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
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

            end;
        }
        field(990; "Promised Delivery Date"; Date)
        {
            Caption = 'Promised Delivery Date';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(1000; "Outbound Whse. Handling Time"; DateFormula)
        {
            Caption = 'Outbound Whse. Handling Time';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
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
            TableRelation = "Rent Header";
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
        field(25007407; "Document Status"; Code[20])
        {
            Caption = 'Document Status';
            DataClassification = ToBeClassified;
            TableRelation = "Document Status".Code where("Document Type" = const("Transfer Order"),
                                                          "Document Profile" = const(Rent));
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

        InitRecord;
    end;

    trigger OnDelete()
    var
        RentTransLine: Record "Rent Transfer Line";
    begin
        TestField(Status, Status::Open);

        RentTransLine.SetRange("Document No.", "No.");
        RentTransLine.DeleteAll(true);

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
        Text300: label 'The transfer order %1 has been deleted.';


    procedure AssistEdit(OldRentShipmentHeader: Record "Rent Transfer Header"): Boolean
    begin
        RentShipmentHeader := Rec;
        RentSetup.Get;
        RentSetup.TestField("Order Nos.");
        if NoSeriesMgt.LookupRelatedNoSeries(RentSetup."Order Nos.", OldRentShipmentHeader."No. Series", RentShipmentHeader."No. Series") then begin
            RentSetup.Get;
            RentSetup.TestField("Rent Item Nos.");
            RentShipmentHeader."No." := NoSeriesMgt.GetNextNo(RentShipmentHeader."No. Series", WorkDate(), true);
            Rec := RentShipmentHeader;
            exit(true);
        end;
    end;


    procedure InitRecord()
    begin
        if NoSeriesMgt.IsAutomatic(RentSetup."Posted Rent Shpt. Nos.") then
            "Posting No. Series" := RentSetup."Posted Rent Shpt. Nos.";

        Validate("Order Date", WorkDate);

        if "Posting Date" = 0D then
            "Posting Date" := WorkDate;

        if "Document Date" = 0D then
            "Document Date" := WorkDate;

        "Posting Description" := "No.";
    end;

    local procedure GetCust(CustNo: Code[20])
    begin
        if CustNo <> '' then begin
            if CustNo <> Cust."No." then
                Cust.Get(CustNo);
        end else
            Clear(Cust);
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
        end;

        if Cont.Type = Cont.Type::Person then
            "Sell-to Contact" := Cont.Name
        else
            if Customer.Get("Sell-to Customer No.") then
                "Sell-to Contact" := Customer.Contact
            else
                "Sell-to Contact" := '';


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
        end;
    end;

    local procedure UpdateShipToAddress()
    begin
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
        "VAT Country/Region Code" := "Sell-to Country/Region Code";
    end;


    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20]; Type3: Integer; No3: Code[20]; Type4: Integer; No4: Code[20]; Type5: Integer; No5: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        Dimsource: List of [Dictionary of [Integer, code[20]]];
    begin
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
        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        Clear(Dimsource);
        DimMgt.AddDimSource(Dimsource, Type1, No1);
        DimMgt.AddDimSource(Dimsource, Type2, No2);
        DimMgt.AddDimSource(Dimsource, Type3, No3);
        DimMgt.AddDimSource(Dimsource, Type4, No4);
        DimMgt.AddDimSource(Dimsource, Type5, No5);
        DimMgt.GetRecDefaultDimID(
            Rec, CurrFieldNo, Dimsource, SourceCodeSetup."Rent Journal", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);
    end;

    local procedure UpdateCurrencyFactor()
    begin
        if "Currency Code" <> '' then begin
            if ("Posting Date" = 0D)
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
            Get("No.");
        end;

        if "Bill-to Customer No." = '' then begin
            TestField("Bill-to Contact No.");
            TestField("Bill-to Customer Template Code");
            Cont.Get("Bill-to Contact No.");
            Cont.CreateCustomerFromTemplate("Bill-to Customer Template Code");
            Commit;
            Get("No.");
        end;

        exit(("Bill-to Customer No." <> '') and ("Sell-to Customer No." <> ''));
    end;


    procedure DeleteOneTransferOrder(var TransHeader2: Record "Rent Transfer Header"; var TransLine2: Record "Rent Transfer Line"): Boolean
    var
        No: Code[20];
        DoNotDelete: Boolean;
    begin
        No := TransHeader2."No.";
        if TransLine2.Find('-') then begin
            repeat
                TransLine2.Delete;
            until TransLine2.Next = 0;
        end;
        TransHeader2.Delete;
        if not HideValidationDialog then
            Message(Text300, No);
        exit(true);
    end;

    procedure ShowDocDim()
    var
        OldDimSetID: Integer;
    begin
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.EditDimensionSet(
            "Dimension Set ID", StrSubstNo('%1', "No."),
            "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code");
    end;
}

