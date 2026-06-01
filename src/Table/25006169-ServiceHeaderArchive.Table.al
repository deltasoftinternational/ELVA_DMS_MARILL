//>>DELTA 01 RC (24/11/2021) Correction taille champ Registration No CODE [11] -- >CODE[20]
//Table 25006169  "Service Header Archive"

Table 25006287 "Service Header Archive EDMS"
{
    Caption = 'Service Header Archive';
    DataCaptionFields = "No.", "Sell-to Customer Name";
    DrillDownPageID = "Service List Archive";
    LookupPageID = "Service List Archive";

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Return Order,Booking';
            OptionMembers = Quote,"Order","Return Order",Booking;
        }
        field(2; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;
        }
        field(3; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(4; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            NotBlank = true;
            TableRelation = Customer;
        }
        field(5; "Bill-to Name"; Text[100])
        {
            Caption = 'Bill-to Name';
        }
        field(6; "Bill-to Name 2"; Text[100])
        {
            Caption = 'Bill-to Name 2';
        }
        field(7; "Bill-to Address"; Text[50])
        {
            Caption = 'Bill-to Address';
        }
        field(8; "Bill-to Address 2"; Text[50])
        {
            Caption = 'Bill-to Address 2';
        }
        field(9; "Bill-to City"; Text[50])
        {
            Caption = 'Bill-to City';

            trigger OnLookup()
            begin
                //PostCode.LookUpCity("Bill-to City","Bill-to Post Code",FALSE); // 26.10.2012 EDMS
            end;

            trigger OnValidate()
            begin
                //PostCode.ValidateCity("Bill-to City","Bill-to Post Code"); // 26.10.2012 EDMS
                PostCode.ValidateCity(
                  "Bill-to City", "Bill-to Post Code", "Bill-to County", "Bill-to Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(10; "Bill-to Contact"; Text[100])
        {
            Caption = 'Bill-to Contact';
        }
        field(19; "Order Date"; Date)
        {
            Caption = 'Order Date';
        }
        field(20; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(22; "Posting Description"; Text[50])
        {
            Caption = 'Posting Description';
        }
        field(23; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(24; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(25; "Payment Discount %"; Decimal)
        {
            Caption = 'Payment Discount %';
            DecimalPlaces = 0 : 5;
        }
        field(28; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location where("Use As In-Transit" = const(false));
        }
        field(29; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(30; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(31; "Customer Posting Group"; Code[20])
        {
            Caption = 'Customer Posting Group';
            TableRelation = "Customer Posting Group";
        }
        field(32; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(33; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;
        }
        field(34; "Customer Price Group"; Code[20])
        {
            Caption = 'Customer Price Group';
            TableRelation = "Customer Price Group";
        }
        field(35; "Prices Including VAT"; Boolean)
        {
            Caption = 'Prices Including VAT';
        }
        field(37; "Invoice Disc. Code"; Code[20])
        {
            Caption = 'Invoice Disc. Code';
        }
        field(40; "Customer Disc. Group"; Code[20])
        {
            Caption = 'Customer Disc. Group';
            TableRelation = "Customer Discount Group";
        }
        field(41; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            TableRelation = Language;
        }
        field(43; "Service Advisor"; Code[20])
        {
            Caption = 'Service Advisor';
            TableRelation = "Salesperson/Purchaser";
        }
        field(46; Comment; Boolean)
        {
            CalcFormula = exist("Serv. Comment Line Arch. EDMS" where(Type = field("Document Type"),
                                                                       "No." = field("No."),
                                                                       "Doc. No. Occurrence" = field("Doc. No. Occurrence"),
                                                                       "Version No." = field("Version No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(47; "No. Printed"; Integer)
        {
            Caption = 'No. Printed';
            Editable = false;
        }
        field(52; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = ' ,Order';
            OptionMembers = " ","Order";
        }
        field(53; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';
        }
        field(55; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            TableRelation = if ("Bal. Account Type" = const("G/L Account")) "G/L Account"
            else
            if ("Bal. Account Type" = const("Bank Account")) "Bank Account";
        }
        field(58; Invoice; Boolean)
        {
            Caption = 'Invoice';
        }
        field(60; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = sum("Service Line Archive".Amount where("Document Type" = field("Document Type"),
                                                                   "Document No." = field("No."),
                                                                   "Doc. No. Occurrence" = field("Doc. No. Occurrence"),
                                                                   "Version No." = field("Version No.")));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61; "Amount Including VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = sum("Service Line Archive"."Amount Including VAT" where("Document Type" = field("Document Type"),
                                                                                   "Document No." = field("No."),
                                                                                   "Doc. No. Occurrence" = field("Doc. No. Occurrence"),
                                                                                   "Version No." = field("Version No.")));
            Caption = 'Amount Including VAT';
            Editable = false;
            FieldClass = FlowField;
        }
        field(63; "Posting No."; Code[20])
        {
            Caption = 'Posting No.';
        }
        field(66; "Prepayment No."; Code[20])
        {
            Caption = 'Prepayment No.';
        }
        field(67; "Last Prepayment No."; Code[20])
        {
            Caption = 'Last Prepayment No.';
            TableRelation = "Sales Invoice Header";
        }
        field(68; "Prepmt. Cr. Memo No."; Code[20])
        {
            Caption = 'Prepmt. Cr. Memo No.';
        }
        field(69; "Last Prepmt. Cr. Memo No."; Code[20])
        {
            Caption = 'Last Prepmt. Cr. Memo No.';
            TableRelation = "Sales Invoice Header";
        }
        field(70; "VAT Registration No."; Text[20])
        {
            Caption = 'VAT Registration No.';
        }
        field(74; "Gen. Bus. Posting Group"; Code[20])
        {
            Caption = 'Gen. Bus. Posting Group';
            TableRelation = "Gen. Business Posting Group";
        }
        field(75; "EU 3-Party Trade"; Boolean)
        {
            Caption = 'EU 3-Party Trade';
        }
        field(76; "Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type';
            TableRelation = "Transaction Type";
        }
        field(77; "Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
            TableRelation = "Transport Method";
        }
        field(79; "Sell-to Customer Name"; Text[100])
        {
            Caption = 'Sell-to Customer Name';
        }
        field(80; "Sell-to Customer Name 2"; Text[50])
        {
            Caption = 'Sell-to Customer Name 2';
        }
        field(81; "Sell-to Address"; Text[50])
        {
            Caption = 'Sell-to Address';
        }
        field(82; "Sell-to Address 2"; Text[50])
        {
            Caption = 'Sell-to Address 2';
        }
        field(83; "Sell-to City"; Text[50])
        {
            Caption = 'Sell-to City';

            trigger OnLookup()
            begin
                //PostCode.LookUpCity("Sell-to City","Sell-to Post Code",FALSE);// 26.10.2012 EDMS
            end;

            trigger OnValidate()
            begin
                //PostCode.ValidateCity("Sell-to City","Sell-to Post Code"); // 26.10.2012 EDMS
                PostCode.ValidateCity(
                  "Sell-to City", "Sell-to Post Code", "Sell-to County", "Sell-to Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(84; "Sell-to Contact"; Text[100])
        {
            Caption = 'Sell-to Contact';
        }
        field(85; "Bill-to Post Code"; Code[20])
        {
            Caption = 'Bill-to Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                //PostCode.LookUpPostCode("Bill-to City","Bill-to Post Code",FALSE); // 26.10.2012 EDMS
            end;

            trigger OnValidate()
            begin
                //PostCode.ValidatePostCode("Bill-to City","Bill-to Post Code");// 26.10.2012 EDMS
                PostCode.ValidatePostCode(
                  "Bill-to City", "Bill-to Post Code", "Bill-to County", "Bill-to Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(86; "Bill-to County"; Text[30])
        {
            Caption = 'Bill-to County';
        }
        field(87; "Bill-to Country/Region Code"; Code[10])
        {
            Caption = 'Bill-to Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(88; "Sell-to Post Code"; Code[20])
        {
            Caption = 'Sell-to Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                //PostCode.LookUpPostCode("Sell-to City","Sell-to Post Code",FALSE); // 26.10.2012 EDMS
            end;

            trigger OnValidate()
            begin
                //PostCode.ValidatePostCode("Sell-to City","Sell-to Post Code");  // 26.10.2012 EDMS
                PostCode.ValidatePostCode(
                  "Sell-to City", "Sell-to Post Code", "Sell-to County", "Sell-to Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
            end;
        }
        field(89; "Sell-to County"; Text[30])
        {
            Caption = 'Sell-to County';
        }
        field(90; "Sell-to Country/Region Code"; Code[10])
        {
            Caption = 'Sell-to Country/Region Code';
            TableRelation = "Country/Region";
        }
        field(94; "Bal. Account Type"; Option)
        {
            Caption = 'Bal. Account Type';
            OptionCaption = 'G/L Account,Bank Account';
            OptionMembers = "G/L Account","Bank Account";
        }
        field(97; "Exit Point"; Code[10])
        {
            Caption = 'Exit Point';
            TableRelation = "Entry/Exit Point";
        }
        field(98; Correction; Boolean)
        {
            Caption = 'Correction';
        }
        field(99; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(100; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
        }
        field(101; "Area"; Code[10])
        {
            Caption = 'Area';
            TableRelation = Area;
        }
        field(102; "Transaction Specification"; Code[10])
        {
            Caption = 'Transaction Specification';
            TableRelation = "Transaction Specification";
        }
        field(104; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
        }
        field(107; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(108; "Posting No. Series"; Code[20])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
        field(114; "Tax Area Code"; Code[20])
        {
            Caption = 'Tax Area Code';
            TableRelation = "Tax Area";
        }
        field(115; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';
        }
        field(116; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";
        }
        field(117; Reserve; Option)
        {
            Caption = 'Reserve';
            OptionCaption = 'Never,Optional,Always';
            OptionMembers = Never,Optional,Always;
        }
        field(119; "VAT Base Discount %"; Decimal)
        {
            Caption = 'VAT Base Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(120; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Open,Released,Pending Approval,Pending Prepayment';
            OptionMembers = Open,Released,"Pending Approval","Pending Prepayment";
        }
        field(121; "Invoice Discount Calculation"; Option)
        {
            Caption = 'Invoice Discount Calculation';
            Editable = false;
            OptionCaption = 'None,%,Amount';
            OptionMembers = "None","%",Amount;
        }
        field(122; "Invoice Discount Value"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Invoice Discount Value';
            Editable = false;
        }
        field(130; "Prepayment %"; Decimal)
        {
            Caption = 'Prepayment %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(131; "Prepayment No. Series"; Code[20])
        {
            Caption = 'Prepayment No. Series';
            TableRelation = "No. Series";
        }
        field(132; "Compress Prepayment"; Boolean)
        {
            Caption = 'Compress Prepayment';
            InitValue = true;
        }
        field(133; "Prepayment Due Date"; Date)
        {
            Caption = 'Prepayment Due Date';
        }
        field(134; "Prepmt. Cr. Memo No. Series"; Code[20])
        {
            Caption = 'Prepmt. Cr. Memo No. Series';
            TableRelation = "No. Series";
        }
        field(135; "Prepmt. Posting Description"; Text[50])
        {
            Caption = 'Prepmt. Posting Description';
        }
        field(138; "Prepmt. Pmt. Discount Date"; Date)
        {
            Caption = 'Prepmt. Pmt. Discount Date';
        }
        field(139; "Prepmt. Payment Terms Code"; Code[10])
        {
            Caption = 'Prepmt. Payment Terms Code';
            TableRelation = "Payment Terms";
        }
        field(140; "Prepmt. Payment Discount %"; Decimal)
        {
            Caption = 'Prepmt. Payment Discount %';
            DecimalPlaces = 0 : 5;
        }
        field(150; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(160; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
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
        field(5043; "Interaction Exist"; Boolean)
        {
            Caption = 'Interaction Exist';
        }
        field(5044; "Time Archived"; Time)
        {
            Caption = 'Time Archived';
        }
        field(5045; "Date Archived"; Date)
        {
            Caption = 'Date Archived';
        }
        field(5046; "Archived By"; Code[50])
        {
            Caption = 'Archived By';
        }
        field(5047; "Version No."; Integer)
        {
            Caption = 'Version No.';
        }
        field(5048; "Doc. No. Occurrence"; Integer)
        {
            Caption = 'Doc. No. Occurrence';
        }
        field(5050; "Campaign No."; Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;
        }
        field(5051; "Sell-to Customer Template Code"; Code[10])
        {
            Caption = 'Sell-to Customer Template Code';
            TableRelation = "Customer Templ.";
        }
        field(5052; "Sell-to Contact No."; Code[20])
        {
            Caption = 'Sell-to Contact No.';
            TableRelation = Contact;
        }
        field(5053; "Bill-to Contact No."; Code[20])
        {
            Caption = 'Bill-to Contact No.';
            TableRelation = Contact;
        }
        field(5054; "Bill-to Customer Template Code"; Code[20])
        {
            Caption = 'Bill-to Customer Template Code';
            TableRelation = "Customer Templ.";
        }
        field(5700; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";
        }
        field(5754; "Location Filter"; Code[10])
        {
            Caption = 'Location Filter';
            FieldClass = FlowFilter;
            TableRelation = Location;
        }
        field(5790; "Requested Delivery Date"; Date)
        {
            Caption = 'Requested Delivery Date';
        }
        field(5791; "Promised Delivery Date"; Date)
        {
            Caption = 'Promised Delivery Date';
        }
        field(5796; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(5801; "Pst. Return Order No."; Code[20])
        {
            Caption = 'Posted Return Order No.';
        }
        field(5802; "Pst. Return Order No. Series"; Code[20])
        {
            Caption = 'Return Order No. Series';
            TableRelation = "No. Series";
        }
        field(6210; "Login ID"; Code[30])
        {
            Caption = 'Login ID';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(7001; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Line Disc.';
        }
        field(80200; "Quote No."; Code[20])
        {
            Caption = 'Quote No.';
        }
        field(80220; "Date Sent"; Date)
        {
            Caption = 'Date Sent';
        }
        field(80230; "Time Sent"; Time)
        {
            Caption = 'Time Sent';
        }
        field(90200; "Planned Service Date"; Date)
        {
            Caption = 'Planned Service Date';
        }
        field(25006001; "Deal Type"; Code[10])
        {
            Caption = 'Deal Type';
            TableRelation = "Deal Type";
        }
        field(25006160; VIN; Code[20])
        {
            Caption = 'VIN';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(25006170; "Vehicle Registration No."; Code[20])
        {
            Caption = 'Vehicle Registration No.';
        }
        field(25006180; "Variable Field Run 1"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006287,25006180';
            DecimalPlaces = 0 : 0;
        }
        field(25006181; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            Editable = false;
            TableRelation = Make;
        }
        field(25006190; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            Editable = false;
            TableRelation = Model.Code;
        }
        field(25006196; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            Editable = false;
            TableRelation = Item."No." where("Item Type" = const("Model Version"),
                                              "Make Code" = field("Make Code"),
                                              "Model Code" = field("Model Code"));
        }
        field(25006200; "Model Commercial Name"; Text[50])
        {
            CalcFormula = lookup(Model."Commercial Name" where("Make Code" = field("Make Code"),
                                                                Code = field("Model Code")));
            Caption = 'Model Commercial Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006250; "Gen. Prod. Posting Group"; Code[20])
        {
            Caption = 'Gen. Prod. Posting Group';
            TableRelation = "Gen. Product Posting Group";
        }
        field(25006255; "Variable Field Run 2"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006287,25006255';
        }
        field(25006260; "Variable Field Run 3"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006287,25006260';
        }
        field(25006270; "Arrival Time"; Time)
        {
            Caption = 'Arrival Time';
        }
        field(25006271; "Arrival Date"; Date)
        {
            Caption = 'Arrival Date';
        }
        field(25006273; "Requested Finishing Date"; Date)
        {
            Caption = 'Requested Finishing Date';
        }
        field(25006275; "Requested Finishing Time"; Time)
        {
            Caption = 'Requested Finishing Time';
        }
        field(25006276; "Warranty Claim No."; Code[20])
        {
            Caption = 'Warranty Claim No.';
        }
        field(25006280; "Return Date"; Date)
        {
            Caption = 'Return Date';
        }
        field(25006290; "Requested Starting Date"; Date)
        {
            Caption = 'Requested Starting Date';
        }
        field(25006295; "Requested Starting Time"; Time)
        {
            Caption = 'Requested Starting Time';
        }
        field(25006300; "Planning Policy"; Option)
        {
            Caption = 'Planning Policy';
            OptionCaption = 'Appointment,Queue';
            OptionMembers = Appointment,Queue;
        }
        field(25006378; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
        }
        field(25006379; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Editable = false;
            TableRelation = "Vehicle Accounting Cycle"."No.";
        }
        field(25006390; "Vehicle Item Charge No."; Code[20])
        {
            Caption = 'Vehicle Item Charge No.';
            TableRelation = "Item Charge";
        }
        field(25006630; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = Contract."Contract No.";
        }
        field(25006650; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;
        }
        field(25006655; "Key Tag"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(25006656; "VHC Status"; Option)
        {
            DataClassification = ToBeClassified;
            OptionMembers = "Awaiting Action","Awaiting Parts","Awaiting Advisor","Awaiting Authorisation",Completed;
        }
        field(25006657; "GDPR Consent Form Signed"; Boolean)
        {
            CalcFormula = lookup(Customer."GDPR Consent Form Signed" where("No." = field("Sell-to Customer No.")));
            Caption = 'GDPR Consent Form Signed';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006800; "Variable Field 25006800"; Code[20])
        {
            CaptionClass = '7,25006287,25006800';
        }
        field(25006801; "Variable Field 25006801"; Code[20])
        {
            CaptionClass = '7,25006287,25006801';
        }
        field(25006802; "Variable Field 25006802"; Code[20])
        {
            CaptionClass = '7,25006287,25006802';
        }
        field(25006860; "Work Status Code"; Code[20])
        {
            Caption = 'Work Status Code';
            TableRelation = "Service Work Status EDMS";
        }
        field(25007010; "Order Time"; Time)
        {
            Caption = 'Order Time';
        }
        field(25007020; "Return Time"; Time)
        {
            Caption = 'Return Time';
        }
        field(25007100; "Bill-to Contact Phone No."; Text[30])
        {
            Caption = 'Bill-to Contact Phone No.';
        }
        field(25007200; "Finished Quantity (Hours)"; Decimal)
        {
            CalcFormula = sum("Serv. Labor Alloc. Application"."Finished Quantity (Hours)" where("Document Type" = field("Document Type"),
                                                                                                  "Document No." = field("No.")));
            Caption = 'Finished Quantity (Hours)';
            Description = 'Service Schedule';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25007210; "Remaining Quantity (Hours)"; Decimal)
        {
            CalcFormula = sum("Serv. Labor Alloc. Application"."Remaining Quantity (Hours)" where("Document Type" = field("Document Type"),
                                                                                                   "Document No." = field("No.")));
            Caption = 'Remaining Quantity (Hours)';
            Description = 'Service Schedule';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25007300; "Vehicle Status Code"; Code[20])
        {
            Caption = 'Vehicle Status Code';
            TableRelation = "Vehicle Status".Code;
        }
        field(25007310; "Vehicle Comment"; Boolean)
        {
            CalcFormula = exist("Service Comment Line EDMS" where(Type = const(Vehicle),
                                                                   "No." = field("Vehicle Serial No.")));
            Caption = 'Vehicle Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25007320; "Sell-to Customer Comment"; Boolean)
        {
            CalcFormula = exist("Comment Line" where("Table Name" = const(Customer),
                                                      "No." = field("Sell-to Customer No.")));
            Caption = 'Sell-to Customer Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25007330; "Bill-to Customer Comment"; Boolean)
        {
            CalcFormula = exist("Comment Line" where("Table Name" = const(Customer),
                                                      "No." = field("Bill-to Customer No.")));
            Caption = 'Bill-to Customer Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25007340; "To Whom Place Items"; Option)
        {
            Caption = 'To Whom Place Items';
            Description = '1:To Sell-to Customer bill 2: To Bill-to Customer bill';
            OptionCaption = 'Not Defined,Sell-to Customer,Bill-to Customer';
            OptionMembers = ND,SellTo,BillTo;
        }
        field(25007380; "Initiator Code"; Code[20])
        {
            Caption = 'Initiator Code';
            TableRelation = "Salesperson/Purchaser";
        }
        field(25007390; "Schedule Start Date Time"; Decimal)
        {
            CalcFormula = min("Serv. Labor Allocation Entry"."Start Date-Time" where("Source Type" = const("Service Document"),
                                                                                      "Source Subtype" = field("Document Type"),
                                                                                      "Source ID" = field("No.")));
            Editable = false;
            FieldClass = FlowField;
        }
        field(25007391; "Schedule End Date Time"; Decimal)
        {
            CalcFormula = max("Serv. Labor Allocation Entry"."End Date-Time" where("Source Type" = const("Service Document"),
                                                                                    "Source Subtype" = field("Document Type"),
                                                                                    "Source ID" = field("No.")));
            FieldClass = FlowField;
        }
        field(25007392; "Prep Perc To Sell-To"; Decimal)
        {
        }
        field(25007393; "Mobile Phone No."; Text[30])
        {
            ExtendedDatatype = PhoneNo;
        }
        field(25007394; "TCard Container Entry No."; Integer)
        {
            TableRelation = "TCard Container";
        }
        field(25007395; "Booking No."; Code[20])
        {
        }
        field(25007396; "Booking Resource No."; Code[20])
        {
            TableRelation = Resource;
        }
        field(25007398; "Service Address Code"; Code[10])
        {
            Caption = 'Service Address Code';
            TableRelation = "Ship-to Address".Code where("Customer No." = field("Sell-to Customer No."));
        }
        field(25007400; "Service Address"; Text[50])
        {
            Caption = 'Service Address';
        }
        field(25007406; "Work Description"; Blob)
        {
            Caption = 'Work Description';
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.", "Doc. No. Occurrence", "Version No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        ServiceLineArchive: Record "Service Line Archive";
        ServiceCommentLineArch: Record "Serv. Comment Line Arch. EDMS";
    begin
        ServiceLineArchive.SetRange("Document Type", "Document Type");
        ServiceLineArchive.SetRange("Document No.", "No.");
        ServiceLineArchive.SetRange("Doc. No. Occurrence", "Doc. No. Occurrence");
        ServiceLineArchive.SetRange("Version No.", "Version No.");
        ServiceLineArchive.DeleteAll;

        // 26.10.2012 EDMS >>
        /*
        DocDimensionArchive.SETRANGE("Table ID",DATABASE::"Service Header EDMS");
        DocDimensionArchive.SETRANGE("Document Type","Document Type");
        DocDimensionArchive.SETRANGE("Document No.","No.");
        DocDimensionArchive.SETRANGE("Doc. No. Occurrence","Doc. No. Occurrence");
        DocDimensionArchive.SETRANGE("Version No.","Version No.");
        DocDimensionArchive.DELETEALL;
        DocDimensionArchive.SETRANGE("Table ID",DATABASE::"Service Line EDMS");
        DocDimensionArchive.DELETEALL;
        */
        // 26.10.2012 EDMS <<

        case "Document Type" of
            "document type"::Quote:
                ServiceCommentLineArch.SetRange(Type, ServiceCommentLineArch.Type::"Service Quote");
            "document type"::Order:
                ServiceCommentLineArch.SetRange(Type, ServiceCommentLineArch.Type::"Service Order");
            "document type"::"Return Order":
                ServiceCommentLineArch.SetRange(Type, ServiceCommentLineArch.Type::"Service Return Order");
        end;
        ServiceCommentLineArch.SetRange("No.", "No.");
        ServiceCommentLineArch.SetRange("Doc. No. Occurrence", "Doc. No. Occurrence");
        ServiceCommentLineArch.SetRange("Version No.", "Version No.");
        ServiceCommentLineArch.DeleteAll;

    end;

    var
        cuVFMgt: Codeunit "Variable Field Management";
        PostCode: Record "Post Code";
        DimMgt: Codeunit DimensionManagement;


    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        Clear(cuVFMgt);
        exit(cuVFMgt.IsVFActive(Database::"Service Header EDMS", intFieldNo));
    end;


    procedure ShowDimensions()
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', "Document Type", "No."));
    end;


    procedure SetWorkDescription(NewWorkDescription: Text)
    var
        OutStreamData: OutStream;
    begin
        Clear("Work Description");
        if NewWorkDescription = '' then
            exit;

        "Work Description".CreateOutStream(OutStreamData, TextEncoding::WINDOWS);
        OutStreamData.WriteText(NewWorkDescription);
        Modify;
    end;


    procedure GetWorkDescription(): Text
    var
        //TempBlob: Record TempBlob temporary;
        InStreamData: InStream;
        Description: Text;
    begin
        CalcFields("Work Description");
        if not "Work Description".Hasvalue then
            exit('');
        "Work Description".CreateInstream(InStreamData, Textencoding::Windows);
        InStreamData.ReadText(Description);
        exit(Description);
    end;
}

