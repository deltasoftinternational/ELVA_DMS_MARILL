Table 25006149 "Posted Serv. Order Header"
{
    // 06.10.2017 EB.AKR Warranty
    //   Added field:
    //     51240 "Initial Service Order No."
    // 
    // 12.02.2016 EB.P7
    //   Added field Mobile Phone No.
    // 
    // 23.02.2015 EDMS P21
    //   Added field:
    //     25006196 "Model Version No."
    // 
    // 19.06.2014 Elva Baltic P8 #F0005 EDMS7.10
    //   * Increased size of Resources field
    // 
    // 05.08.2008. EDMS P2
    //   * Added function LookupAdjmtValueEntries
    // 
    // 26.05.2008. EDMS P2
    //   * Added field Description
    // 
    // 25.03.2008. EDMS P2
    //   * Added new fields Requested Starting Date
    //                      Requested Starting Time
    // 
    // //09-02-2007 EDMS P3
    //   Added new fields: Vehicle Serial No.
    // //15-02-2007 EDMS P3
    //   Deleted fields: 140 "Vehicle Notes"
    //                  25006205 "Short Description"
    //                  25007250 "Sales Version Code"
    //                  25007230 "Sub Series"
    //                  25007220 "Series"
    //                  25007040 "Last Visit Date"
    //                  25006480 "Number of Doors"
    //                  25006210 "Prod. year"
    //                  340 "Sold Date"
    //                  25006240 "Initial Registration Date"

    Caption = 'Posted Serv. Order Header';
    DataCaptionFields = "No.", "Sell-to Customer Name";
    DrillDownPageID = "Posted Service Orders EDMS";
    LookupPageID = "Posted Service Orders EDMS";

    fields
    {
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
        }
        field(10; "Bill-to Contact"; Text[100])
        {
            Caption = 'Bill-to Contact';
        }
        field(11; "Your Reference"; Text[35])
        {
            Caption = 'Your Reference';
            DataClassification = ToBeClassified;
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
            Editable = false;
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
        field(44; "Order No."; Code[20])
        {
            Caption = 'Order No.';
        }
        field(46; Comment; Boolean)
        {
            CalcFormula = exist("Service Comment Line EDMS" where(Type = const("Service Order"),
                                                                   "No." = field("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(47; "No. Printed"; Integer)
        {
            Caption = 'No. Printed';
            Editable = false;
        }
        field(58; Invoice; Boolean)
        {
            Caption = 'Invoice';
        }
        field(60; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = sum("Posted Serv. Order Line".Amount where("Document No." = field("No.")));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61; "Amount Including VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = sum("Posted Serv. Order Line"."Amount Including VAT" where("Document No." = field("No.")));
            Caption = 'Amount Including VAT';
            Editable = false;
            FieldClass = FlowField;
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
        field(80; "Sell-to Customer Name 2"; Text[100])
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
        }
        field(84; "Sell-to Contact"; Text[50])
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
        field(110; "Order No. Series"; Code[20])
        {
            Caption = 'Order No. Series';
            TableRelation = "No. Series";
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
        field(150; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(160; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
            ExtendedDatatype = PhoneNo;
        }
        field(200; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = EndUserIdentifiableInformation;
            Editable = false;
            TableRelation = User."User Name";
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
        field(6210; "Login ID"; Code[30])
        {
            Caption = 'Login ID';
            Editable = false;
            TableRelation = Location;
        }
        field(7001; "Allow Line Disc."; Boolean)
        {
            Caption = 'Allow Line Disc.';
        }
        field(51240; "Initial Service Order No."; Code[20])
        {
            Caption = 'Initial Service Order No.';
        }
        field(25006001; "Deal Type Code"; Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";
        }
        field(25006160; VIN; Code[20])
        {
            Caption = 'VIN';
        }
        field(25006170; "Vehicle Registration No."; Code[20])
        {
            Caption = 'Vehicle Registration No.';

            trigger OnLookup()
            var
                Vehicle: Record Vehicle;
            begin
                Vehicle.Reset;
                if Vehicle.Get("Vehicle Serial No.") then;
                if LookupMgt.LookUpVehicleAMT(Vehicle, "Vehicle Serial No.") then;
            end;
        }
        field(25006180; "Variable Field Run 1"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006149,25006180';
            DecimalPlaces = 0 : 0;
        }
        field(25006181; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
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
            CalcFormula = lookup(Vehicle."Model Commercial Name" where("Serial No." = field("Vehicle Serial No.")));
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
            CaptionClass = '7,25006145,25006255';
        }
        field(25006260; "Variable Field Run 3"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006145,25006180';
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
        field(25006400; Resources; Code[250])
        {
        }
        field(25006630; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = Contract."Contract No.";
        }
        field(25006800; "Variable Field 25006800"; Code[20])
        {
            CaptionClass = '7,25006149,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::Vehicle, FieldNo("Variable Field 25006800"),
                  "Make Code", "Variable Field 25006800") then begin
                    Validate("Variable Field 25006800", VFOptions.Code);
                end;
            end;
        }
        field(25006801; "Variable Field 25006801"; Code[20])
        {
            CaptionClass = '7,25006149,25006801';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::Vehicle, FieldNo("Variable Field 25006801"),
                  "Make Code", "Variable Field 25006801") then begin
                    Validate("Variable Field 25006801", VFOptions.Code);
                end;
            end;
        }
        field(25006802; "Variable Field 25006802"; Code[20])
        {
            CaptionClass = '7,25006149,25006802';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::Vehicle, FieldNo("Variable Field 25006802"),
                  "Make Code", "Variable Field 25006802") then begin
                    Validate("Variable Field 25006802", VFOptions.Code);
                end;
            end;
        }
        field(25006860; "Work Status"; Code[20])
        {
            Caption = 'Work Status';
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
            CalcFormula = sum("Serv. Labor Alloc. Application"."Finished Quantity (Hours)" where("Document No." = field("No."),
                                                                                                  "Document Type" = const(Order)));
            Caption = 'Finished Quantity (Hours)';
            Description = 'Service Schedule';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25007210; "Remaining Quantity (Hours)"; Decimal)
        {
            CalcFormula = sum("Serv. Labor Alloc. Application"."Remaining Quantity (Hours)" where("Document No." = field("No.")));
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
                                                                                      "Source ID" = field("No."),
                                                                                      "Source Subtype" = const(Order)));
            Editable = false;
            FieldClass = FlowField;
        }
        field(25007391; "Schedule End Date Time"; Decimal)
        {
            CalcFormula = max("Serv. Labor Allocation Entry"."End Date-Time" where("Source Type" = const("Service Document"),
                                                                                    "Source ID" = field("No."),
                                                                                    "Source Subtype" = const(Order)));
            FieldClass = FlowField;
        }
        field(25007393; "Mobile Phone No."; Text[30])
        {
            ExtendedDatatype = PhoneNo;
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
        field(25007408; "Opportunity No."; Code[20])
        {
            Caption = 'Opportunity No.';
            DataClassification = ToBeClassified;
            TableRelation = Opportunity."No." where("Contact No." = field("Sell-to Contact No."),
                                                     Closed = const(false));
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Posting Date")
        {
        }
        key(Key3; "Vehicle Serial No.")
        {
        }
        key(Key4; "Order No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        Opp: Record Opportunity;
        Opp2: Record Opportunity;
        TempOpportunityEntry: Record "Opportunity Entry" temporary;
    begin
    end;

    var
        DimMgt: Codeunit DimensionManagement;
        Comment: Record "Service Comment Line EDMS";
        VFMgt: Codeunit "Variable Field Management";
        LookupMgt: Codeunit LookUpManagement;


    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::"Posted Serv. Order Header", intFieldNo));
    end;


    procedure LookupAdjmtValueEntries()
    var
        ValueEntry: Record "Value Entry";
        SalesInvHdr: Record "Sales Invoice Header";
    begin
        SalesInvHdr.Reset;
        SalesInvHdr.SetCurrentkey("Service Order No.", "Service Document");
        SalesInvHdr.SetRange("Service Order No.", "No.");
        SalesInvHdr.SetRange("Service Document", true);
        if SalesInvHdr.FindFirst then;

        ValueEntry.SetCurrentkey("Document No.");
        ValueEntry.SetRange("Document No.", SalesInvHdr."No.");
        ValueEntry.SetRange("Document Type", ValueEntry."document type"::"Sales Invoice");
        ValueEntry.SetRange(Adjustment, true);
        Page.RunModal(0, ValueEntry);
    end;


    procedure Navigate()
    var
        NavigateForm: Page Navigate;
    begin
        NavigateForm.SetDoc("Posting Date", "No.");
        NavigateForm.Run;
    end;


    procedure ShowDimensions()
    begin
        DimMgt.ShowDimensionSet("Dimension Set ID", StrSubstNo('%1 %2', TableCaption, "No."));
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

