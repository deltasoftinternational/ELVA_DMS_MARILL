//>>DELTA 02 RC (23/12/2021) Add Publisher
//>>DELTA 01 RC (19/12/2021) Correction de la fonction GetDescription
Table 25006145 "Service Header EDMS"
{
    // 07.04.2022 EDMS EB.KN
    //   Added Field:
    //      Customer Vehicle ID
    //
    // 02.10.2019 EB.P7 B3030DMS-14
    //   Added field "Opportunity No."
    // 
    // 04.10.2017 EB.AKR Warranty
    //   Added fields:
    //     51240:"Initial Service Order No."
    //   Modified functions:
    //     InitRecord
    // 
    // 02.05.2017 EB.P7
    //   Added fields:
    //     "Customer Signature Image"
    //     "Customer Signature Text"
    //     "Employee Signature Image"
    //     "Employee Signature Text"
    // 
    // 30.08.2016 EB.P7 WSH16
    //   Field added:
    //     25007405"Finished Travel Qty (Hours)"
    //   Modified flow field formula Finished Quantity (Hours)
    // 
    // 16.03.2016 EB.P7 Branch Profile Setup
    //   Modified GetUserSetup(), Usert Profile Setup to Branch Profile Setup
    // 
    // 12.02.2016 EB.P7
    //   Added field Mobile Phone No.
    // 
    // 23.04.2015 EDMS P21
    //   Added function:
    //     OnLookupVIN
    //   Modified functions:
    //     RecreateDmsServLines
    //   Modified triggers:
    //     VIN - OnLookup
    //     Vehicle Serial No. - OnValidate
    //     Deal Type - OnValidate
    // 
    // 16.04.2015 EB.P7 #S0150 MMG7.00
    //   Fixed rename record problem. Posting No. copies only in init procedure.
    // 
    // 16.03.2015 EDMS P21
    //   Modified triggers:
    //     Make Code - OnValidate
    //     Vehicle Serial No. - OnValidate
    //   Modified functions:
    //     CheckVehicleCreated
    //     RecreateDmsServLines
    // 
    // 10.03.2015 EDMS P21
    //   Modified procedure:
    //     CreateDim
    //   Modified CreateDim calls because of added parameter
    //   Modified trigger:
    //     Location Code - OnValidate
    // 
    // 09.03.2015 EB.P7 #Serv. Sched. Setup
    //   New message added Text138, when Schedule Setup Entry does not exist.
    // 
    // 20.02.2015 EDMS P21
    //   Set Editable property to Yes for field:
    //     "Model Version No."
    //   Modified triggers:
    //     Model Version No. - OnLookup
    //     VIN - OnValidate
    //     Vehicle Registration No. - OnValidate
    //     Vehicle Serial No. - OnValidate
    // 
    // 19.02.2015 EDMS P21
    //   Modified trigger:
    //     Sell-to Contact No. - OnValidate
    //   Modified function:
    //     UpdateSellToCont
    // 
    // 27.01.2015 EB.P7 #E0062 MMG7.00
    //   Updated vehicle search after customer choose
    // 
    // 27.10.2014 EB.P8 #S0218 MMG7.00
    //   Removed error when change sell to customer system went in loop.
    // 
    // 19.05.2014 Elva Baltic P21 #S0108 MMG7.00
    //   Added function:
    //     CalcAmountIncVAT
    // 
    // 10.05.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified OptionString for field:
    //     "Applies-to Doc. Type"
    //   Modified triggers:
    //     Applies-to Doc. No. - OnValidate()
    //   Deleted code in trigger:
    //     Applies-to Doc. No. - OnLookup()
    // 
    // 08.05.2014 Elva Baltic P8 #S0084 MMG7.00
    //   * Do not allow to set blocked vehicle
    // 
    // 17.04.2014 Elva Baltic P1 #RX MMG7.00
    //   *Modified OnDelete trigger
    // 
    // 16.04.2014 Elva Baltic P7 # MMG7.00
    //   * Field "Shipping Agent Code" added
    // 
    // 15.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified procedure:
    //     RecreateDmsServLines
    //   Added field:
    //     Contract No.
    // 
    // 04.04.2014 Elva Baltic P8 E0011 MMG7.00
    //   * Fix in bahavior of vehicle change
    //   * Modified Vehicle Status Code-OnValidate
    // 
    //   Added code to:
    //     Bill-to Customer No. - OnValidate()
    // 
    //   Added Code to trigger
    //     OnDelete()
    // 
    // 29.05.2013 Elva Baltic P15
    //   * Show Vehicle Contact table instead of Customer
    // 
    // 08.05.2013 EDMS P8
    //   * Implement use of T25006126."Auto Order By Exp. Date"
    // 14.03.2013 EDMS P8
    //   * Added fields: "Prepayment Share Sell-To %"
    // 25.02.2013 EDMS P8
    //   * Implement new dimensions
    // 
    // 2012.07.31 EDMS P8
    //   * added fields: Variable Field Run 2, Variable Field Run 3
    //   * added functions: TestVFRun2, TestVFRun3
    //   * new variable VehicleServicePlanStageTmp_CS - temporarely stores current/last selected plan stage
    // 
    // 29.09.2011 EDMS P8
    //   * Implement Tire Management

    Caption = 'Service Document';
    DataCaptionFields = "No.", "Sell-to Customer Name";
    DrillDownPageID = "Service Document List";
    LookupPageID = "Service Document List";

    fields
    {
        field(1; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Return Order,Booking,VHC';
            OptionMembers = Quote,"Order","Return Order",Booking,VHC;
        }
        field(2; "Sell-to Customer No."; Code[20])
        {
            Caption = 'Sell-to Customer No.';
            TableRelation = Customer;

            trigger OnValidate()
            var
                DocumentMgt: Codeunit DocumentManagementDMS;
                codVin: Code[20];
                recVeh: Record Vehicle;
            begin
                if ("Sell-to Customer No." <> xRec."Sell-to Customer No.") and (xRec."Sell-to Customer No." <> '') then begin
                    Confirmed := ConfirmLoc(StrSubstNo(Text004, FieldCaption("Sell-to Customer No.")), false, '');
                    if Confirmed then begin
                        ServLine.SetRange("Document Type", "Document Type");
                        ServLine.SetRange("Document No.", "No.");
                        if "Sell-to Customer No." = '' then begin
                            if ServLine.FindFirst then
                                Error(Text005, FieldCaption("Sell-to Customer No."));
                            Init;
                            ServiceSetup.Get;
                            InitRecord;
                            "No. Series" := xRec."No. Series";
                            if xRec."Posting No." <> '' then begin
                                "Posting No. Series" := xRec."Posting No. Series";
                                "Posting No." := xRec."Posting No.";
                            end;
                            //08-05-2007 EDMS P3 PREPMT >>
                            if xRec."Prepayment No." <> '' then begin
                                "Prepayment No. Series" := xRec."Prepayment No. Series";
                                "Prepayment No." := xRec."Prepayment No.";
                            end;
                            if xRec."Prepmt. Cr. Memo No." <> '' then begin
                                "Prepmt. Cr. Memo No. Series" := xRec."Prepmt. Cr. Memo No. Series";
                                "Prepmt. Cr. Memo No." := xRec."Prepmt. Cr. Memo No.";
                            end;
                            //08-05-2007 EDMS P3 PREPMT <<
                            exit;
                        end;
                        //08-05-2007 EDMS P3 PREPMT >>
                        if "Document Type" = "document type"::Order then begin
                            ServLine.SetFilter("Prepmt. Amt. Inv.", '<>0');
                            if ServLine.FindFirst then
                                ServLine.TestField("Prepmt. Amt. Inv.", 0);
                            ServLine.SetRange("Prepmt. Amt. Inv.");
                        end;
                        //08-05-2007 EDMS P3 PREPMT <<
                        ServLine.Reset
                    end
                    else begin
                        Rec := xRec;
                        exit;
                    end;
                end;

                if ("Document Type" = "document type"::Order) and (xRec."Sell-to Customer No." <> "Sell-to Customer No.") then begin
                    ServLine.SetRange("Document Type", ServLine."document type"::Order);
                    ServLine.SetRange("Document No.", "No.");
                    ServLine.SetFilter("Purch. Order Line No.", '<>0');
                    if ServLine.FindFirst then
                        Error(Text006, FieldCaption("Sell-to Customer No."));
                    ServLine.Reset;
                end;

                GetCust("Sell-to Customer No.");
                Cust.CheckBlockedCustOnDocs(Cust, "Document Type", false, false);
                Cust.TestField("Gen. Bus. Posting Group");

                "Sell-to Customer Template Code" := '';
                "Sell-to Customer Name" := CopyStr(Cust.Name, 1, MaxStrLen("Sell-to Customer Name"));
                "Sell-to Customer Name 2" := CopyStr(Cust."Name 2", 1, MaxStrLen("Sell-to Customer Name 2"));
                ;
                "Sell-to Address" := CopyStr(Cust.Address, 1, MaxStrLen("Sell-to Address"));
                ;
                "Sell-to Address 2" := CopyStr(Cust."Address 2", 1, MaxStrLen("Sell-to Address 2"));
                ;
                "Sell-to City" := Cust.City;
                "Sell-to Post Code" := Cust."Post Code";
                "Sell-to County" := Cust.County;
                "Sell-to Country/Region Code" := Cust."Country/Region Code";
                //"Prices Including VAT" :=  Cust."Prices Including VAT";
                if not SkipSellToContact then
                    "Sell-to Contact" := Cust.Contact;
                "Gen. Bus. Posting Group" := Cust."Gen. Bus. Posting Group";
                "VAT Bus. Posting Group" := Cust."VAT Bus. Posting Group";
                "VAT Registration No." := Cust."VAT Registration No.";
                "Responsibility Center" := UserMgt.GetRespCenter(3, Cust."Responsibility Center");
                "Responsibility Center" := UserMgtELVA.GetRespCenterEDMS(Cust."Responsibility Center");
                VALIDATE("Location Code", UserMgt.GetLocation(3, Cust."Location Code", "Responsibility Center"));


                Validate("Vehicle Item Charge No.", Cust."Default Service Item Charge");

                if Cust."Bill-to Customer No." <> '' then
                    Validate("Bill-to Customer No.", Cust."Bill-to Customer No.")
                else begin
                    if "Bill-to Customer No." = "Sell-to Customer No." then
                        SkipBillToContact := true;
                    Validate("Bill-to Customer No.", "Sell-to Customer No.");
                    SkipBillToContact := false;
                end;

                if not SkipSellToContact then begin  //27.10.2014 EB.P8 #S0218 MMG7.00
                    SkipSellToContact := true;
                    UpdateSellToCont("Sell-to Customer No.");
                    SkipSellToContact := false;
                end;

                GetUserSetup;


                if (xRec."Sell-to Customer No." <> "Sell-to Customer No.") or
                   (xRec."Currency Code" <> "Currency Code") or
                   (xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group") or
                   (xRec."VAT Bus. Posting Group" <> "VAT Bus. Posting Group") then
                    RecreateDmsServLines(FieldCaption("Sell-to Customer No."));

                if (xRec."Sell-to Customer No." <> "Sell-to Customer No.") and ("Sell-to Customer No." <> '') then
                    DocumentMgt.ShowCustomerComments("Sell-to Customer No.");

                UpdateServiceAddressCode;
                if "Service Address Code" = '' then
                    CopySellToAddressToShipToAddress;
            end;
        }
        field(3; "No."; Code[20])
        {
            Caption = 'No.';

            trigger OnValidate()
            begin
                if "No." <> xRec."No." then begin
                    ServiceSetup.Get;
                    NoSeriesMgt.TestManual(GetNoSeriesCode);
                    "No. Series" := '';
                end;

                //16.04.2015 EB.P7 #S0150 MMG7.00 >>
                //IF ServiceSetup."Use Order No. as Posting No." THEN
                //  CASE "Document Type" OF
                //    "Document Type"::Order:
                //      "Posting No." := "No.";
                //    "Document Type"::"Return Order":
                //      "Pst. Return Order No." := "No."
                //  END
                //16.04.2015 EB.P7 #S0150 MMG7.00 <<
            end;
        }
        field(4; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            NotBlank = true;
            TableRelation = Customer;

            trigger OnValidate()
            var
                ContBusRel: Record "Contact Business Relation";
                Cont: Record Contact;
                recServContract: Record Contract;
            begin
                if (xRec."Bill-to Customer No." <> "Bill-to Customer No.") and (xRec."Bill-to Customer No." <> '') then begin
                    Confirmed := ConfirmLoc(StrSubstNo(Text004, FieldCaption("Bill-to Customer No.")), false, '');
                    if Confirmed then begin
                        ServLine.SetRange("Document Type", "Document Type");
                        ServLine.SetRange("Document No.", "No.");
                        //08-05-2007 EDMS P3 PREPMT >>
                        if "Document Type" = "document type"::Order then begin
                            ServLine.SetFilter("Prepmt. Amt. Inv.", '<>0');
                            if ServLine.FindFirst then
                                ServLine.TestField("Prepmt. Amt. Inv.", 0);
                            ServLine.SetRange("Prepmt. Amt. Inv.");
                        end;
                        //08-05-2007 EDMS P3 PREPMT <<
                        ServLine.Reset
                    end else
                        "Bill-to Customer No." := xRec."Bill-to Customer No.";
                end;

                GetCust("Bill-to Customer No.");
                Cust.CheckBlockedCustOnDocs(Cust, "Document Type", false, false);
                Cust.TestField("Customer Posting Group");

                if GuiAllowed and (CurrFieldNo <> 0) then begin
                    "Amount Including VAT" := 0;
                end;

                if GuiAllowed and (CurrFieldNo <> 0) then
                    SalesMgt.ServiceHeaderCheckEDMS(Rec);

                Validate("Vehicle Item Charge No.", Cust."Default Service Item Charge");  //07-09-2007 EDMS P3

                "Bill-to Customer Template Code" := '';
                "Bill-to Name" := CopyStr(Cust.Name, 1, MaxStrLen("Bill-to Name"));
                "Bill-to Name 2" := CopyStr(Cust."Name 2", 1, MaxStrLen("Bill-to Name 2"));
                ;
                "Bill-to Address" := CopyStr(Cust.Address, 1, MaxStrLen("Bill-to Address"));
                ;
                "Bill-to Address 2" := CopyStr(Cust."Address 2", 1, MaxStrLen("Bill-to Address 2"));
                ;
                "Bill-to City" := Cust.City;
                "Bill-to Post Code" := Cust."Post Code";
                "Bill-to County" := Cust.County;
                "Bill-to Country/Region Code" := Cust."Country/Region Code";
                if not SkipBillToContact then
                    "Bill-to Contact" := Cust.Contact;
                "Payment Terms Code" := Cust."Payment Terms Code";
                //22.08.2008. EDMS P2 >>
                if Cust."Payment Method Code" <> '' then
                    //22.08.2008. EDMS P2 <<
                    "Payment Method Code" := Cust."Payment Method Code";
                "Gen. Bus. Posting Group" := Cust."Gen. Bus. Posting Group";
                "VAT Bus. Posting Group" := Cust."VAT Bus. Posting Group";
                "Customer Posting Group" := Cust."Customer Posting Group";
                "Currency Code" := Cust."Currency Code";
                "Customer Price Group" := Cust."Customer Price Group";
                "Prices Including VAT" := Cust."Prices Including VAT";
                "Allow Line Disc." := Cust."Allow Line Disc.";
                "Invoice Disc. Code" := Cust."Invoice Disc. Code";
                "Customer Disc. Group" := Cust."Customer Disc. Group";
                "Customer Price Group" := Cust."Customer Price Group";
                "Language Code" := Cust."Language Code";
                Reserve := Cust.Reserve;
                "VAT Registration No." := Cust."VAT Registration No.";
                if "Document Type" = "document type"::Order then
                    "Prepayment %" := Cust."Prepayment %";  //08-05-2007 EDMS P3 PREPMT

                //>>DELTA MGR
                OnBeforeCreateDimBillToCustNo(Rec);
                //<<DELTA MGR

                CreateDim(
                  Database::"Vehicle Status", "Vehicle Status Code",
                  Database::Customer, "Bill-to Customer No.",
                  Database::"Salesperson/Purchaser", "Service Advisor",
                  Database::"Responsibility Center", "Responsibility Center",
                  Database::"Deal Type", "Deal Type",
                  //DATABASE::Vehicle,VIN,
                  Database::Make, "Make Code",
                  Database::Vehicle, "Vehicle Serial No.", //25.10.2013 EDMS P8
                  Database::"Payment Method", "Payment Method Code",
                  Database::Location, "Location Code"      // 10.03.2015 EDMS P21
                  );


                Validate("Payment Terms Code");
                Validate("Payment Method Code");
                Validate("Currency Code");

                if (xRec."Sell-to Customer No." = "Sell-to Customer No.") and
                   (xRec."Bill-to Customer No." <> "Bill-to Customer No.")
                then
                    RecreateDmsServLines(FieldCaption("Bill-to Customer No."));

                if not SkipBillToContact then
                    UpdateBillToCont("Bill-to Customer No.");

                if xRec."Bill-to Customer No." <> "Bill-to Customer No." then                 // 15.04.2014 Elva Baltic P21
                    FindContract;                                                               // 15.04.2014 Elva Baltic P21
            end;
        }
        field(5; "Bill-to Name"; Text[100])
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
                //PostCode.LookUpCity("Bill-to City","Bill-to Post Code",TRUE); //30.10.2012 EDMS
            end;

            trigger OnValidate()
            begin
                //30.10.2012 EDMS >>
                PostCode.ValidateCity(
                  "Bill-to City", "Bill-to Post Code", "Bill-to County", "Bill-to Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
                //30.10.2012 EDMS <<
            end;
        }
        field(10; "Bill-to Contact"; Text[100])
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
        field(11; "Your Reference"; Text[35])
        {
            Caption = 'Your Reference';
            DataClassification = ToBeClassified;
        }
        field(19; "Order Date"; Date)
        {
            Caption = 'Order Date';

            trigger OnValidate()
            begin
                Validate("Planned Service Date", "Order Date");

                CheckServicePlan(FieldNo("Order Date"));
            end;
        }
        field(20; "Posting Date"; Date)
        {
            Caption = 'Posting Date';

            trigger OnValidate()
            var
                NoSeries: Record "No. Series";
            begin
                TestNoSeriesDate(
                  "Posting No.", "Posting No. Series",
                  FieldCaption("Posting No."), FieldCaption("Posting No. Series"));
                TestNoSeriesDate(
                  "Prepayment No.", "Prepayment No. Series",
                  FieldCaption("Prepayment No."), FieldCaption("Prepayment No. Series"));
                TestNoSeriesDate(
                  "Prepmt. Cr. Memo No.", "Prepmt. Cr. Memo No. Series",
                  FieldCaption("Prepmt. Cr. Memo No."), FieldCaption("Prepmt. Cr. Memo No. Series"));

                Validate("Document Date", "Posting Date");

                if ("Document Type" in ["document type"::"Return Order", "document type"::Booking]) and not ("Posting Date" = xRec."Posting Date")
                then
                    PriceMessageIfServLinesExist(FieldCaption("Posting Date"));

                if "Currency Code" <> '' then begin
                    UpdateCurrencyFactor;
                    if "Currency Factor" <> xRec."Currency Factor" then
                        ConfirmUpdateCurrencyFactor;
                end;
            end;
        }
        field(21; "Shipment Date"; Date)
        {
            Caption = 'Shipment Date';

            trigger OnValidate()
            begin
                UpdateDMSServLines(FieldCaption("Shipment Date"), CurrFieldNo <> 0);
            end;
        }
        field(22; "Posting Description"; Text[50])
        {
            Caption = 'Posting Description';
        }
        field(23; "Payment Terms Code"; Code[10])
        {
            Caption = 'Payment Terms Code';
            TableRelation = "Payment Terms";

            trigger OnValidate()
            begin
                if ("Payment Terms Code" <> '') and ("Document Date" <> 0D) then begin
                    PaymentTerms.Get("Payment Terms Code");
                    //if (("Document Type" in ["document type"::"5", "document type"::Booking]) and
                    if (("Document Type" = "Document Type"::Booking) and
                      not (PaymentTerms."Calc. Pmt. Disc. on Cr. Memos"))
                    then
                        Validate("Due Date", "Document Date")
                    else
                        "Due Date" := CalcDate(PaymentTerms."Due Date Calculation", "Document Date");
                end
                else
                    Validate("Due Date", "Document Date");
                //08-05-2007 EDMS P3 PREPMT >>
                if xRec."Payment Terms Code" = "Prepmt. Payment Terms Code" then begin
                    if xRec."Prepayment Due Date" = 0D then
                        "Prepayment Due Date" := CalcDate(PaymentTerms."Due Date Calculation", "Document Date");
                    Validate("Prepmt. Payment Terms Code", "Payment Terms Code");
                end;
                //08-05-2007 EDMS P3 PREPMT <<
            end;
        }
        field(24; "Due Date"; Date)
        {
            Caption = 'Due Date';
        }
        field(25; "Payment Discount %"; Decimal)
        {
            Caption = 'Payment Discount %';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                GLSetup.Get;
                if "Payment Discount %" < GLSetup."VAT Tolerance %" then
                    "VAT Base Discount %" := "Payment Discount %"
                else
                    "VAT Base Discount %" := GLSetup."VAT Tolerance %";
                Validate("VAT Base Discount %");
            end;
        }
        field(28; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location where("Use As In-Transit" = const(false));

            trigger OnValidate()
            begin
                if ("Location Code" <> xRec."Location Code") and (xRec."Sell-to Customer No." = "Sell-to Customer No.") then
                    MessageIfServLinesExist(FieldCaption("Location Code"));

                // 10.03.2015 EDMS P21 >>
                CreateDim(
                  Database::"Vehicle Status", "Vehicle Status Code",
                  Database::Customer, "Bill-to Customer No.",
                  Database::Location, "Location Code",
                  Database::"Salesperson/Purchaser", "Service Advisor",
                  Database::"Responsibility Center", "Responsibility Center",
                  Database::"Deal Type", "Deal Type",
                  Database::Make, "Make Code",
                  Database::Vehicle, "Vehicle Serial No.",
                  Database::"Payment Method", "Payment Method Code"
                  );
                // 10.03.2015 EDMS P21 <<

                if "Document Type" = "document type"::Booking then begin
                    "TCard Container Entry No." := TCardMgt.GetInitialContainerNo("Location Code");
                end;
            end;
        }
        field(29; "Shortcut Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1';
            Caption = 'Shortcut Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(1, "Shortcut Dimension 1 Code");
                //MODIFY;  //25.02.2013 EDMS P8
            end;
        }
        field(30; "Shortcut Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2';
            Caption = 'Shortcut Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));

            trigger OnValidate()
            begin
                ValidateShortcutDimCode(2, "Shortcut Dimension 2 Code");
                //MODIFY;  //25.02.2013 EDMS P8
            end;
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

            trigger OnValidate()
            begin
                if CurrFieldNo <> FieldNo("Currency Code") then
                    UpdateCurrencyFactor
                else begin
                    if "Currency Code" <> xRec."Currency Code" then begin
                        UpdateCurrencyFactor;
                        RecreateDmsServLines(FieldCaption("Currency Code"));
                    end
                    else
                        if "Currency Code" <> '' then begin
                            UpdateCurrencyFactor;
                            if "Currency Factor" <> xRec."Currency Factor" then
                                ConfirmUpdateCurrencyFactor;
                        end;
                end;
            end;
        }
        field(33; "Currency Factor"; Decimal)
        {
            Caption = 'Currency Factor';
            DecimalPlaces = 0 : 15;
            Editable = false;
            MinValue = 0;

            trigger OnValidate()
            begin
                if "Currency Factor" <> xRec."Currency Factor" then
                    UpdateDMSServLines(FieldCaption("Currency Factor"), false);
            end;
        }
        field(34; "Customer Price Group"; Code[20])
        {
            Caption = 'Customer Price Group';
            TableRelation = "Customer Price Group";
        }
        field(35; "Prices Including VAT"; Boolean)
        {
            Caption = 'Prices Including VAT';

            trigger OnValidate()
            var
                Currency: Record Currency;
                RecalculatePrice: Boolean;
                SalesHeader: Record "Sales Header";
                ServLine: Record "Service Line EDMS";
                ServLineCopy: Record "Service Line EDMS";
            begin
                TestField(Status, Status::Open);

                if "Prices Including VAT" <> xRec."Prices Including VAT" then begin

                    SalesHeader.Reset;
                    SalesHeader.SetCurrentkey("Service Document No.");
                    SalesHeader.SetFilter("Document Type", '%1|%2', SalesHeader."document type"::Invoice, SalesHeader."document type"::"Credit Memo");
                    SalesHeader.SetRange("Service Document No.", "No.");
                    if SalesHeader.FindFirst then
                        Error(Text101);

                    ServLine.SetRange("Document Type", "Document Type");
                    ServLine.SetRange("Document No.", "No.");
                    ServLine.SetFilter("Unit Price", '<>%1', 0);
                    ServLine.SetFilter("VAT %", '<>%1', 0);
                    if ServLine.FindFirst then begin
                        RecalculatePrice :=
                          ConfirmLoc(
                            StrSubstNo(
                              Text024 +
                              Text026,
                              FieldCaption("Prices Including VAT"), ServLine.FieldCaption("Unit Price")),
                            true, '');
                        ServLine.SetServHeader(Rec);

                        if "Currency Code" = '' then
                            Currency.InitRoundingPrecision
                        else
                            Currency.Get("Currency Code");
                        ServLine.LockTable;
                        LockTable;
                        ServLine.FindSet;
                        repeat
                            //27.08.2007. EDMS P2 >>
                            ServLine.TestField("Prepayment %", 0);
                            //27.08.2007. EDMS P2 <<

                            ServLineCopy := ServLine;
                            ServLine.TestField("Prepmt. Amt. Inv.", 0); //08-05-2007 EDMS P3 PREPMT
                            if not RecalculatePrice then begin
                                ServLine."VAT Difference" := 0;
                                ServLine.InitOutstandingAmount;
                            end else
                                if "Prices Including VAT" then begin
                                    ServLine."Unit Price" :=
                                      ROUND(
                                        ServLine."Unit Price" * (1 + (ServLine."VAT %" / 100)),
                                        Currency."Unit-Amount Rounding Precision");
                                    if ServLine.Quantity <> 0 then begin
                                        ServLine."Line Discount Amount" :=
                                          ROUND(
                                            ServLine.Quantity * ServLine."Unit Price" * ServLine."Line Discount %" / 100,
                                            Currency."Amount Rounding Precision");
                                        ServLine.Validate("Inv. Discount Amount",
                                          ROUND(
                                            ServLine."Inv. Discount Amount" * (1 + (ServLine."VAT %" / 100)),
                                            Currency."Amount Rounding Precision"));
                                        ServLine.UpdateAmounts

                                    end;
                                end else begin
                                    ServLine."Unit Price" :=
                                      ROUND(
                                        ServLine."Unit Price" / (1 + (ServLine."VAT %" / 100)),
                                        Currency."Unit-Amount Rounding Precision");
                                    if ServLine.Quantity <> 0 then begin
                                        ServLine."Line Discount Amount" :=
                                          ROUND(
                                            ServLine.Quantity * ServLine."Unit Price" * ServLine."Line Discount %" / 100,
                                            Currency."Amount Rounding Precision");
                                        ServLine.Validate("Inv. Discount Amount",
                                          ROUND(
                                            ServLine."Inv. Discount Amount" / (1 + (ServLine."VAT %" / 100)),
                                            Currency."Amount Rounding Precision"));
                                        ServLine.UpdateAmounts
                                    end;
                                end;
                            ServLine.Modify;
                        until ServLine.Next = 0;
                    end;
                end;
            end;
        }
        field(37; "Invoice Disc. Code"; Code[20])
        {
            Caption = 'Invoice Disc. Code';

            trigger OnValidate()
            begin
                MessageIfServLinesExist(FieldCaption("Invoice Disc. Code"));
            end;
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

            trigger OnValidate()
            begin
                MessageIfServLinesExist(FieldCaption("Language Code"));
            end;
        }
        field(43; "Service Advisor"; Code[20])
        {
            Caption = 'Service Advisor';
            TableRelation = "Salesperson/Purchaser";

            trigger OnValidate()
            begin
                Commit;

                CreateDim(
                  Database::"Vehicle Status", "Vehicle Status Code",
                  Database::Customer, "Bill-to Customer No.",
                  Database::"Salesperson/Purchaser", "Service Advisor",
                  Database::"Responsibility Center", "Responsibility Center",
                  Database::"Deal Type", "Deal Type",
                  //DATABASE::Vehicle,VIN,
                  Database::Make, "Make Code",
                  Database::Vehicle, "Vehicle Serial No.", //25.10.2013 EDMS P8
                  Database::"Payment Method", "Payment Method Code",
                  Database::Location, "Location Code"      // 10.03.2015 EDMS P21
                  );

                ServLine.Reset;
                ServLine.SetRange("Document Type", "Document Type");
                ServLine.SetRange("Document No.", "No.");
                if ServLine.FindSet then
                    repeat
                        ServLine.CallCreateDim;
                    until ServLine.Next = 0;
            end;
        }
        field(46; Comment; Boolean)
        {
            CalcFormula = exist("Service Comment Line EDMS" where(Type = field("Document Type"),
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
        field(52; "Applies-to Doc. Type"; Option)
        {
            Caption = 'Applies-to Doc. Type';
            OptionCaption = ' ,Order,Return Order';
            OptionMembers = " ","Order","Return Order";
        }
        field(53; "Applies-to Doc. No."; Code[20])
        {
            Caption = 'Applies-to Doc. No.';
            TableRelation = if ("Applies-to Doc. Type" = filter(Order)) "Posted Serv. Order Header"."No."
            else
            if ("Applies-to Doc. Type" = filter("Return Order")) "Posted Serv. Ret. Order Header"."No.";

            trigger OnValidate()
            begin

                // 10.05.2014 Elva Baltic P21 >>
                /*
                IF "Applies-to Doc. No." <> '' THEN
                  TESTFIELD("Bal. Account No.",'');
                
                IF ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") AND (xRec."Applies-to Doc. No." <> '') AND
                   ("Applies-to Doc. No." <> '')
                THEN BEGIN
                  SetAmountToApply("Applies-to Doc. No.","Bill-to Customer No.");
                  SetAmountToApply(xRec."Applies-to Doc. No.","Bill-to Customer No.");
                END ELSE
                  IF ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") AND (xRec."Applies-to Doc. No." = '') THEN
                    SetAmountToApply("Applies-to Doc. No.","Bill-to Customer No.")
                  ELSE IF ("Applies-to Doc. No." <> xRec."Applies-to Doc. No.") AND ("Applies-to Doc. No." = '') THEN
                      SetAmountToApply(xRec."Applies-to Doc. No.","Bill-to Customer No.");
                */
                // 10.05.2014 Elva Baltic P21 <<

            end;
        }
        field(55; "Bal. Account No."; Code[20])
        {
            Caption = 'Bal. Account No.';
            TableRelation = if ("Bal. Account Type" = const("G/L Account")) "G/L Account"
            else
            if ("Bal. Account Type" = const("Bank Account")) "Bank Account";

            trigger OnValidate()
            begin
                if "Bal. Account No." <> '' then
                    case "Bal. Account Type" of
                        "bal. account type"::"G/L Account":
                            begin
                                GLAcc.Get("Bal. Account No.");
                                GLAcc.CheckGLAcc;
                                GLAcc.TestField("Direct Posting", true);
                            end;
                        "bal. account type"::"Bank Account":
                            begin
                                BankAcc.Get("Bal. Account No.");
                                BankAcc.TestField(Blocked, false);
                                BankAcc.TestField("Currency Code", "Currency Code");
                            end;
                    end;
            end;
        }
        field(58; Invoice; Boolean)
        {
            Caption = 'Invoice';
        }
        field(60; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = sum("Service Line EDMS".Amount where("Document Type" = field("Document Type"),
                                                                "Document No." = field("No.")));
            Caption = 'Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(61; "Amount Including VAT"; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            CalcFormula = sum("Service Line EDMS"."Amount Including VAT" where("Document Type" = field("Document Type"),
                                                                                "Document No." = field("No.")));
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

            trigger OnValidate()
            begin
                if xRec."Gen. Bus. Posting Group" <> "Gen. Bus. Posting Group" then
                    if GenBusPostingGrp.ValidateVatBusPostingGroup(GenBusPostingGrp, "Gen. Bus. Posting Group") then begin
                        "VAT Bus. Posting Group" := GenBusPostingGrp."Def. VAT Bus. Posting Group";
                        RecreateDmsServLines(FieldCaption("Gen. Bus. Posting Group"));
                    end;
            end;
        }
        field(75; "EU 3-Party Trade"; Boolean)
        {
            Caption = 'EU 3-Party Trade';
        }
        field(76; "Transaction Type"; Code[10])
        {
            Caption = 'Transaction Type';
            TableRelation = "Transaction Type";

            trigger OnValidate()
            begin
                UpdateDMSServLines(FieldCaption("Transaction Type"), false);
            end;
        }
        field(77; "Transport Method"; Code[10])
        {
            Caption = 'Transport Method';
            TableRelation = "Transport Method";

            trigger OnValidate()
            begin
                UpdateDMSServLines(FieldCaption("Transport Method"), false);
            end;
        }
        field(79; "Sell-to Customer Name"; Text[100])
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

                if Customer.SelectCustomer(Customer) then begin
                    "Sell-to Customer Name" := Customer.Name;
                    Validate("Sell-to Customer No.", Customer."No.");
                end;
            end;

            trigger OnValidate()
            var
                Customer: Record Customer;
                //EnvInfoProxy: Codeunit "Env. Info Proxy";
                EnvironmentInformation: Codeunit "Environment Information";
            begin

                if ShouldLookForCustomerByName("Sell-to Customer No.") then
                    Validate("Sell-to Customer No.", Customer.GetCustNo("Sell-to Customer Name"));

            end;
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

            trigger OnLookup()
            begin
                //PostCode.LookUpCity("Sell-to City","Sell-to Post Code",TRUE); //30.10.2012 EDMS
            end;

            trigger OnValidate()
            begin
                //30.10.2012 EDMS >>
                PostCode.ValidateCity(
                  "Sell-to City", "Sell-to Post Code", "Sell-to County", "Sell-to Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
                //30.10.2012 EDMS <<
            end;
        }
        field(84; "Sell-to Contact"; Text[100])
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
        field(85; "Bill-to Post Code"; Code[20])
        {
            Caption = 'Bill-to Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            begin
                //PostCode.LookUpPostCode("Bill-to City","Bill-to Post Code",TRUE);//30.10.2012 EDMS
            end;

            trigger OnValidate()
            begin
                //30.10.2012 EDMS >>
                PostCode.ValidatePostCode(
                  "Bill-to City", "Bill-to Post Code", "Bill-to County", "Bill-to Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
                //30.10.2012 EDMS <<
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
                //PostCode.LookUpPostCode("Sell-to City","Sell-to Post Code",TRUE);//30.10.2012 EDMS
            end;

            trigger OnValidate()
            begin
                //30.10.2012 EDMS >>
                PostCode.ValidatePostCode(
                  "Sell-to City", "Sell-to Post Code", "Sell-to County", "Sell-to Country/Region Code", (CurrFieldNo <> 0) and GuiAllowed);
                //30.10.2012 EDMS <<
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

            trigger OnValidate()
            begin
                UpdateDMSServLines(FieldCaption("Exit Point"), false);
            end;
        }
        field(98; Correction; Boolean)
        {
            Caption = 'Correction';
        }
        field(99; "Document Date"; Date)
        {
            Caption = 'Document Date';

            trigger OnValidate()
            begin
                Validate("Payment Terms Code");
                Validate("Prepmt. Payment Terms Code"); //08-05-2007 EDMS P3 PREPMT
            end;
        }
        field(100; "External Document No."; Code[20])
        {
            Caption = 'External Document No.';
        }
        field(101; "Area"; Code[10])
        {
            Caption = 'Area';
            TableRelation = Area;

            trigger OnValidate()
            begin
                UpdateDMSServLines(FieldCaption(Area), false);
            end;
        }
        field(102; "Transaction Specification"; Code[10])
        {
            Caption = 'Transaction Specification';
            TableRelation = "Transaction Specification";

            trigger OnValidate()
            begin
                UpdateDMSServLines(FieldCaption("Transaction Specification"), false);
            end;
        }
        field(104; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";

            trigger OnValidate()
            var
                recServiceLine: Record "Service Line EDMS";
                tcDMS001: label 'Do you want to change lines too?';
            begin
                TestField(Status, Status::Open);

                CreateDim(
                  Database::"Vehicle Status", "Vehicle Status Code",
                  Database::Customer, "Bill-to Customer No.",
                  Database::"Salesperson/Purchaser", "Service Advisor",
                  Database::"Responsibility Center", "Responsibility Center",
                  Database::"Deal Type", "Deal Type",
                  //DATABASE::Vehicle,VIN,
                  Database::Make, "Make Code",
                  Database::Vehicle, "Vehicle Serial No.", //25.10.2013 EDMS P8
                  Database::"Payment Method", "Payment Method Code",
                  Database::Location, "Location Code"      // 10.03.2015 EDMS P21
                  );

                PaymentMethod.Init;
                if "Payment Method Code" <> '' then
                    PaymentMethod.Get("Payment Method Code");
                "Bal. Account Type" := PaymentMethod."Bal. Account Type";
                "Bal. Account No." := PaymentMethod."Bal. Account No.";

                if "Bal. Account No." <> '' then begin
                    TestField("Applies-to Doc. No.", '');
                end;
            end;
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

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                MessageIfServLinesExist(FieldCaption("Tax Area Code"));
            end;
        }
        field(115; "Tax Liable"; Boolean)
        {
            Caption = 'Tax Liable';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                MessageIfServLinesExist(FieldCaption("Tax Liable"));
            end;
        }
        field(116; "VAT Bus. Posting Group"; Code[20])
        {
            Caption = 'VAT Bus. Posting Group';
            TableRelation = "VAT Business Posting Group";

            trigger OnValidate()
            begin
                if xRec."VAT Bus. Posting Group" <> "VAT Bus. Posting Group" then
                    RecreateDmsServLines(FieldCaption("VAT Bus. Posting Group"));
            end;
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

            trigger OnValidate()
            begin
                UpdateDMSServLines(FieldCaption("Prepayment %"), CurrFieldNo <> 0);
            end;
        }
        field(131; "Prepayment No. Series"; Code[20])
        {
            Caption = 'Prepayment No. Series';
            TableRelation = "No. Series";

            trigger OnLookup()
            begin
                ServiceHeader := Rec;
                ServiceSetup.Get;
                ServiceSetup.TestField("Posted Prepmt. Inv. Nos.");
                if NoSeriesMgt.LookupRelatedNoSeries(ServiceSetup."Posted Prepmt. Inv. Nos.", ServiceHeader."Prepayment No. Series") then
                    ServiceHeader.Validate("Prepayment No. Series");
                Rec := ServiceHeader;
            end;

            trigger OnValidate()
            begin
                if "Prepayment No. Series" <> '' then begin
                    ServiceSetup.Get;
                    ServiceSetup.TestField("Posted Prepmt. Inv. Nos.");
                    NoSeriesMgt.TestAreRelated(ServiceSetup."Posted Prepmt. Inv. Nos.", "Prepayment No. Series");
                end;
                TestField("Prepayment No.", '');
            end;
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

            trigger OnLookup()
            begin
                ServiceHeader := Rec;
                ServiceSetup.Get;
                ServiceSetup.TestField("Posted Prepmt. Cr. Memo Nos.");
                if NoSeriesMgt.LookupRelatedNoSeries(GetPostingNoSeriesCode(), ServiceHeader."Prepmt. Cr. Memo No.") then
                    ServiceHeader.Validate("Prepmt. Cr. Memo No.");
                Rec := ServiceHeader;
            end;

            trigger OnValidate()
            begin
                if "Prepmt. Cr. Memo No." <> '' then begin
                    ServiceSetup.Get;
                    ServiceSetup.TestField("Posted Prepmt. Cr. Memo Nos.");
                    NoSeriesMgt.TestAreRelated(ServiceSetup."Posted Prepmt. Cr. Memo Nos.", "Prepmt. Cr. Memo No.");
                end;
                TestField("Prepmt. Cr. Memo No.", '');
            end;
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

            trigger OnValidate()
            var
                PaymentTerms: Record "Payment Terms";
            begin
                if ("Prepmt. Payment Terms Code" <> '') and ("Document Date" <> 0D) then begin
                    PaymentTerms.Get("Prepmt. Payment Terms Code");
                    if (("Document Type" in ["document type"::"Return Order"]) and
                       not PaymentTerms."Calc. Pmt. Disc. on Cr. Memos")
                    then begin
                        Validate("Prepayment Due Date", "Document Date");
                        Validate("Prepmt. Pmt. Discount Date", 0D);
                        Validate("Prepmt. Payment Discount %", 0);
                    end else begin
                        "Prepayment Due Date" := CalcDate(PaymentTerms."Due Date Calculation", "Document Date");
                        "Prepmt. Pmt. Discount Date" := CalcDate(PaymentTerms."Discount Date Calculation", "Document Date");
                        Validate("Prepmt. Payment Discount %", PaymentTerms."Discount %")
                    end;
                end else begin
                    Validate("Prepayment Due Date", "Document Date");
                    Validate("Prepmt. Pmt. Discount Date", 0D);
                    Validate("Prepmt. Payment Discount %", 0);
                end;
            end;
        }
        field(140; "Prepmt. Payment Discount %"; Decimal)
        {
            Caption = 'Prepmt. Payment Discount %';
            DecimalPlaces = 0 : 5;

            trigger OnValidate()
            begin
                if not (CurrFieldNo in [0, FieldNo("Posting Date"), FieldNo("Document Date")]) then
                    TestField(Status, Status::Open);
                GLSetup.Get;
                if "Payment Discount %" < GLSetup."VAT Tolerance %" then
                    "VAT Base Discount %" := "Payment Discount %"
                else
                    "VAT Base Discount %" := GLSetup."VAT Tolerance %";
                Validate("VAT Base Discount %");
            end;
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
                ShowDocDim;
            end;
        }
        field(1305; "Invoice Discount Amount"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Service Line EDMS"."Inv. Discount Amount" where("Document No." = field("No."),
                                                                                "Document Type" = field("Document Type")));
            Caption = 'Invoice Discount Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5043; "No. of Archived Versions"; Integer)
        {
            CalcFormula = max("Service Header Archive"."Version No." where("Document Type" = field("Document Type"),
                                                                            "No." = field("No."),
                                                                            "Doc. No. Occurrence" = field("Doc. No. Occurrence")));
            Caption = 'No. of Archived Versions';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5048; "Doc. No. Occurrence"; Integer)
        {
            Caption = 'Doc. No. Occurrence';
        }
        field(5050; "Campaign No."; Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;

            trigger OnValidate()
            begin
                Modify;

                CreateDim(
                  Database::Campaign, "Campaign No.",
                  Database::Customer, "Bill-to Customer No.",
                  Database::"Salesperson/Purchaser", "Service Advisor",
                  Database::"Responsibility Center", "Responsibility Center",
                  Database::"Deal Type", "Deal Type",
                  //DATABASE::Vehicle,VIN,
                  Database::Make, "Make Code",
                  Database::Vehicle, "Vehicle Serial No.", //25.10.2013 EDMS P8
                  Database::"Payment Method", "Payment Method Code",
                  Database::Location, "Location Code"      // 10.03.2015 EDMS P21
                  );
            end;
        }
        field(5051; "Sell-to Customer Template Code"; Code[10])
        {
            Caption = 'Sell-to Customer Template Code';
            TableRelation = "Customer Templ.";

            trigger OnValidate()
            var
                SellToCustTemplate: Record "Customer Templ.";
            begin
                TestField("Document Type", "document type"::Quote);

                if ("Sell-to Customer Template Code" <> xRec."Sell-to Customer Template Code") and
                   (xRec."Sell-to Customer Template Code" <> '')
                then begin
                    Confirmed := ConfirmLoc(StrSubstNo(Text004, FieldCaption("Sell-to Customer Template Code")), false, '');
                    if Confirmed then begin
                        ServLine.Reset;
                        ServLine.SetRange("Document Type", "Document Type");
                        ServLine.SetRange("Document No.", "No.");
                        if "Sell-to Customer Template Code" = '' then begin
                            if not ServLine.IsEmpty then
                                Error(Text005, FieldCaption("Sell-to Customer Template Code"));
                            Init;
                            ServiceSetup.Get;
                            InitRecord;
                            "No. Series" := xRec."No. Series";
                            if xRec."Posting No." <> '' then begin
                                "Posting No. Series" := xRec."Posting No. Series";
                                "Posting No." := xRec."Posting No.";
                            end;
                            //08-05-2007 EDMS P3 PREPMT >>
                            if xRec."Prepayment No." <> '' then begin
                                "Prepayment No. Series" := xRec."Prepayment No. Series";
                                "Prepayment No." := xRec."Prepayment No.";
                            end;
                            if xRec."Prepmt. Cr. Memo No." <> '' then begin
                                "Prepmt. Cr. Memo No. Series" := xRec."Prepmt. Cr. Memo No. Series";
                                "Prepmt. Cr. Memo No." := xRec."Prepmt. Cr. Memo No.";
                            end;
                            //08-05-2007 JEDMS P3 PREPMT <<
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

                if (xRec."Sell-to Customer Template Code" <> "Sell-to Customer Template Code") or
                  (xRec."Currency Code" <> "Currency Code") then
                    RecreateDmsServLines(FieldCaption("Sell-to Customer Template Code"));
            end;
        }
        field(5052; "Sell-to Contact No."; Code[20])
        {
            Caption = 'Sell-to Contact No.';
            TableRelation = Contact;

            trigger OnLookup()
            var
                Cont: Record Contact;
                ContBusinessRelation: Record "Contact Business Relation";
            begin
                if ("Sell-to Customer No." <> '') and (Cont.Get("Sell-to Contact No.")) then
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
                Vehicle: Record Vehicle;
            begin
                TestField(Status, Status::Open);
                HideValidationDialog := true;
                if ("Sell-to Contact No." <> xRec."Sell-to Contact No.") and
                   (xRec."Sell-to Contact No." <> '')
                then begin
                    Confirmed := ConfirmLoc(StrSubstNo(Text004, FieldCaption("Sell-to Contact No.")), false, '');
                    if Confirmed then begin
                        ServLine.Reset;
                        ServLine.SetRange("Document Type", "Document Type");
                        ServLine.SetRange("Document No.", "No.");
                        if ("Sell-to Contact No." = '') and ("Sell-to Customer No." = '') then begin
                            if not ServLine.IsEmpty then
                                Error(Text005, FieldCaption("Sell-to Contact No."));
                            Init;
                            ServiceSetup.Get;
                            InitRecord;
                            "No. Series" := xRec."No. Series";
                            if xRec."Posting No." <> '' then begin
                                "Posting No. Series" := xRec."Posting No. Series";
                                "Posting No." := xRec."Posting No.";
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
                    // IF ContBusinessRelation.FINDFIRST THEN               // 19.02.2015 EDMS P21
                    ContBusinessRelation.FindFirst;                         // 19.02.2015 EDMS P21
                                                                            //04.04.2014 Elva Baltic P8 E0011 MMG7.00 >>
                    if ContBusinessRelation."Contact No." <> Cont."Company No." then begin
                        ContBusinessRelation.Reset;
                        ContBusinessRelation.SetRange("Link to Table", ContBusinessRelation."link to table"::Customer);
                        ContBusinessRelation.SetRange("Contact No.", Cont."Company No.");
                        if ContBusinessRelation.FindFirst then begin
                            Confirmed := ConfirmLoc(StrSubstNo(Text004, FieldCaption("Sell-to Customer No.")), false, '');
                            if not Confirmed then
                                Error(Text038, Cont."No.", Cont.Name, "Sell-to Customer No.");
                            Validate("Sell-to Customer No.", ContBusinessRelation."No.");
                        end else
                            Error(Text038, Cont."No.", Cont.Name, "Sell-to Customer No.");
                    end;
                    //04.04.2014 Elva Baltic P8 E0011 MMG7.00 <<
                    Rec."Mobile Phone No." := Cont."Mobile Phone No.";
                end;

                UpdateSellToCust("Sell-to Contact No.");

                //if (Rec."Vehicle Registration No." = xRec."Vehicle Registration No.")
                // and ("Vehicle Serial No." = xRec."Vehicle Serial No.") and not FindCustomer then
                //    FindContVehicle;
            end;
        }
        field(5053; "Bill-to Contact No."; Code[20])
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
                    Confirmed := ConfirmLoc(StrSubstNo(Text004, FieldCaption("Bill-to Contact No.")), false, '');
                    if Confirmed then begin
                        ServLine.Reset;
                        ServLine.SetRange("Document Type", "Document Type");
                        ServLine.SetRange("Document No.", "No.");
                        if ("Bill-to Contact No." = '') and ("Bill-to Customer No." = '') then begin
                            if not ServLine.IsEmpty then
                                Error(Text005, FieldCaption("Bill-to Contact No."));
                            Init;
                            ServiceSetup.Get;
                            InitRecord;
                            "No. Series" := xRec."No. Series";
                            if xRec."Posting No." <> '' then begin
                                "Posting No. Series" := xRec."Posting No. Series";
                                "Posting No." := xRec."Posting No.";
                            end;
                            //08-05-2007 EDMS P3 PREPMT >>
                            if xRec."Prepayment No." <> '' then begin
                                "Prepayment No. Series" := xRec."Prepayment No. Series";
                                "Prepayment No." := xRec."Prepayment No.";
                            end;
                            if xRec."Prepmt. Cr. Memo No." <> '' then begin
                                "Prepmt. Cr. Memo No. Series" := xRec."Prepmt. Cr. Memo No. Series";
                                "Prepmt. Cr. Memo No." := xRec."Prepmt. Cr. Memo No.";
                            end;
                            //08-05-2007 EDMS P3 PREPMT <<
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
        field(5054; "Bill-to Customer Template Code"; Code[20])
        {
            Caption = 'Bill-to Customer Template Code';
            TableRelation = "Customer Templ.";

            trigger OnValidate()
            var
                BillToCustTemplate: Record "Customer Templ.";
            begin
                TestField("Document Type", "document type"::Quote);
                TestField(Status, Status::Open);

                if ("Bill-to Customer Template Code" <> xRec."Bill-to Customer Template Code") and
                   (xRec."Bill-to Customer Template Code" <> '')
                then begin
                    Confirmed := ConfirmLoc(StrSubstNo(Text004, FieldCaption("Bill-to Customer Template Code")), false, '');
                    if Confirmed then begin
                        ServLine.Reset;
                        ServLine.SetRange("Document Type", "Document Type");
                        ServLine.SetRange("Document No.", "No.");
                        if "Bill-to Customer Template Code" = '' then begin
                            if not ServLine.IsEmpty then
                                Error(Text005, FieldCaption("Bill-to Customer Template Code"));
                            Init;
                            ServiceSetup.Get;
                            InitRecord;
                            "No. Series" := xRec."No. Series";
                            if xRec."Posting No." <> '' then begin
                                "Posting No. Series" := xRec."Posting No. Series";
                                "Posting No." := xRec."Posting No.";
                            end;
                            //08-05-2007 EDMS P3 PREPMT >>
                            if xRec."Prepayment No." <> '' then begin
                                "Prepayment No. Series" := xRec."Prepayment No. Series";
                                "Prepayment No." := xRec."Prepayment No.";
                            end;
                            if xRec."Prepmt. Cr. Memo No." <> '' then begin
                                "Prepmt. Cr. Memo No. Series" := xRec."Prepmt. Cr. Memo No. Series";
                                "Prepmt. Cr. Memo No." := xRec."Prepmt. Cr. Memo No.";
                            end;
                            //08-05-2007 EDMS P3 PREPMT <<
                            exit;
                        end;
                    end else begin
                        "Bill-to Customer Template Code" := xRec."Bill-to Customer Template Code";
                        exit;
                    end;
                end;

                if BillToCustTemplate.Get("Bill-to Customer Template Code") then begin
                    BillToCustTemplate.TestField("Customer Posting Group");
                    "Customer Posting Group" := BillToCustTemplate."Customer Posting Group";
                    "Invoice Disc. Code" := BillToCustTemplate."Invoice Disc. Code";
                    "Customer Price Group" := BillToCustTemplate."Customer Price Group";
                    "Customer Disc. Group" := BillToCustTemplate."Customer Disc. Group";
                    "Allow Line Disc." := BillToCustTemplate."Allow Line Disc.";
                    Validate("Payment Terms Code", BillToCustTemplate."Payment Terms Code");
                    Validate("Payment Method Code", BillToCustTemplate."Payment Method Code");
                end;

                CreateDim(
                  Database::"Vehicle Status", "Vehicle Status Code",
                  Database::Customer, "Bill-to Customer No.",
                  Database::"Salesperson/Purchaser", "Service Advisor",
                  Database::"Responsibility Center", "Responsibility Center",
                  Database::"Deal Type", "Deal Type",
                  //DATABASE::Vehicle,VIN,
                  Database::Make, "Make Code",
                  Database::Vehicle, "Vehicle Serial No.", //25.10.2013 EDMS P8
                  Database::"Payment Method", "Payment Method Code",
                  Database::Location, "Location Code"      // 10.03.2015 EDMS P21
                  );

                if (xRec."Sell-to Customer Template Code" = "Sell-to Customer Template Code") and
                   (xRec."Bill-to Customer Template Code" <> "Bill-to Customer Template Code")
                then
                    RecreateDmsServLines(FieldCaption("Bill-to Customer Template Code"));
            end;
        }
        field(5700; "Responsibility Center"; Code[10])
        {
            Caption = 'Responsibility Center';
            TableRelation = "Responsibility Center";

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                /* if not UserMgt.CheckRespCenter(3, "Responsibility Center") then
                     Error(
                       Text027,
                        RespCenter.TableCaption, UserMgt.GetServiceFilterEDMS);*/
                if not UserMgtELVA.CheckRespCenterEDMS("Responsibility Center") then
                    Error(
                      Text027,
                       RespCenter.TableCaption, UserMgtELVA.GetServiceFilterEDMS());

                CreateDim(
                  Database::"Vehicle Status", "Vehicle Status Code",
                  Database::Customer, "Bill-to Customer No.",
                  Database::"Salesperson/Purchaser", "Service Advisor",
                  Database::"Responsibility Center", "Responsibility Center",
                  Database::"Deal Type", "Deal Type",
                  //DATABASE::Vehicle,VIN,
                  Database::Make, "Make Code",
                  Database::Vehicle, "Vehicle Serial No.", //25.10.2013 EDMS P8
                  Database::"Payment Method", "Payment Method Code",
                  Database::Location, "Location Code"      // 10.03.2015 EDMS P21
                  );

                if (xRec."Responsibility Center" <> "Responsibility Center") then
                    RecreateDmsServLines(FieldCaption("Responsibility Center"));
            end;
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

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if "Promised Delivery Date" <> 0D then
                    Error(
                      Text028,
                      FieldCaption("Requested Delivery Date"),
                      FieldCaption("Promised Delivery Date"));

                if "Requested Delivery Date" <> xRec."Requested Delivery Date" then
                    UpdateDMSServLines(FieldCaption("Requested Delivery Date"), CurrFieldNo <> 0);
            end;
        }
        field(5791; "Promised Delivery Date"; Date)
        {
            Caption = 'Promised Delivery Date';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if "Promised Delivery Date" <> xRec."Promised Delivery Date" then
                    UpdateDMSServLines(FieldCaption("Promised Delivery Date"), CurrFieldNo <> 0);
            end;
        }
        field(5792; "Shipping Time"; DateFormula)
        {
            Caption = 'Shipping Time';

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
                if "Shipping Time" <> xRec."Shipping Time" then
                    UpdateDMSServLines(FieldCaption("Shipping Time"), CurrFieldNo <> 0);
            end;
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

            trigger OnValidate()
            begin

                MessageIfServLinesExist(FieldCaption("Allow Line Disc."));
            end;
        }
        field(51240; "Initial Service Order No."; Code[20])
        {
            Caption = 'Initial Service Order No.';
        }
        field(80200; "Quote No."; Code[20])
        {
            Caption = 'Quote No.';
        }
        field(80201; "Confirmed Quote Version No."; Integer)
        {
            Caption = 'Confirmed Quote Version No.';

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

            trigger OnValidate()
            begin
                if ("Planned Service Date" <> xRec."Planned Service Date") and (xRec."Sell-to Customer No." = "Sell-to Customer No.") then
                    MessageIfServLinesExist(FieldCaption("Planned Service Date"));
            end;
        }
        field(25006001; "Deal Type"; Code[10])
        {
            Caption = 'Deal Type';
            TableRelation = "Deal Type";

            trigger OnValidate()
            var
                recServiceLine: Record "Service Line EDMS";
                tcDMS001: label 'Do you want to change Deal Type in lines too?';
            begin
                TestField(Status, Status::Open);

                CreateDim(
                  Database::"Vehicle Status", "Vehicle Status Code",
                  Database::Customer, "Bill-to Customer No.",
                  Database::"Deal Type", "Deal Type",
                  Database::"Salesperson/Purchaser", "Service Advisor",
                  Database::"Responsibility Center", "Responsibility Center",
                  //DATABASE::Vehicle,VIN,
                  Database::Make, "Make Code",
                  Database::Vehicle, "Vehicle Serial No.", //25.10.2013 EDMS P8
                  Database::"Payment Method", "Payment Method Code",
                  Database::Location, "Location Code"      // 10.03.2015 EDMS P21
                  );

                //04.04.2014 Elva Baltic P1 #RX MMG7.00 >>
                //IF xRec."Deal Type" <> "Deal Type" THEN
                //  RecreateDmsServLines(FIELDCAPTION("Deal Type"));
                //04.04.2014 Elva Baltic P1 #RX MMG7.00 <<

                if xRec."Deal Type" <> "Deal Type" then begin           // 23.04.2015 EDMS P21
                    recServiceLine.Reset;
                    recServiceLine.SetRange("Document Type", "Document Type");
                    recServiceLine.SetRange("Document No.", "No.");
                    if recServiceLine.FindSet(true, false) then begin
                        Confirmed := ConfirmLoc(tcDMS001, true, '');
                        if Confirmed then begin
                            repeat
                                recServiceLine.Validate("Deal Type Code", "Deal Type");
                                recServiceLine.Modify;
                            until recServiceLine.Next = 0;
                        end;
                    end;                                                 // 23.04.2015 EDMS P21
                end;
            end;
        }
        field(25006160; VIN; Code[20])
        {
            Caption = 'VIN';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;

            trigger OnLookup()
            var
                Vehicle: Record Vehicle;
            begin
                // 23.04.2015 EDMS P21 >>
                // IF LookUpMgt.LookUpVehicleAMT(Vehicle,"Vehicle Serial No.") THEN
                //  VALIDATE("Vehicle Serial No.",Vehicle."Serial No.");
                OnLookupVIN;
                // 23.04.2015 EDMS P21 <<
            end;

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);

                // 20.02.2015 EDMS P21 >>
                if VIN = '' then begin
                    Validate("Vehicle Serial No.", '');
                    exit;
                end;

                Vehicle.Reset;
                Vehicle.SetCurrentkey(VIN);
                Vehicle.SetRange(VIN, VIN);
                if Vehicle.FindFirst then begin
                    if "Vehicle Serial No." <> Vehicle."Serial No." then
                        Validate("Vehicle Serial No.", Vehicle."Serial No.")
                end else begin
                    MessageLoc(StrSubstNo(Text137, Vehicle.TableCaption, FieldCaption(VIN), VIN), '');
                    if "Document Type" <> "document type"::Quote then
                        VIN := xRec.VIN;
                end;
                // 20.02.2015 EDMS P21 <<
            end;
        }
        field(25006170; "Vehicle Registration No."; Code[20])
        {
            Caption = 'Vehicle Registration No.';

            trigger OnLookup()
            begin
                OnLookupVehicleRegistrationNo;
            end;

            trigger OnValidate()
            var
                Vehicle: Record Vehicle;
            begin
                if "Vehicle Registration No." = '' then begin
                    Validate("Vehicle Serial No.", '');
                    exit;
                end;

                Vehicle.Reset;
                Vehicle.SetCurrentkey("Registration No.");
                Vehicle.SetRange("Registration No.", "Vehicle Registration No.");
                if Vehicle.FindFirst then begin
                    if "Vehicle Serial No." <> Vehicle."Serial No." then
                        Validate("Vehicle Serial No.", Vehicle."Serial No.")
                end else begin
                    MessageLoc(StrSubstNo(Text131, "Vehicle Registration No."), '');
                    // 20.02.2015 EDMS P21 >>
                    if "Document Type" <> "document type"::Quote then
                        "Vehicle Registration No." := xRec."Vehicle Registration No.";
                    // 20.02.2015 EDMS P21 <<
                end;
            end;
        }
        field(25006180; "Variable Field Run 1"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006145,25006180';
            DecimalPlaces = 0 : 0;

            trigger OnValidate()
            begin
                TestVFRun1;
                CheckServicePlan(FieldNo("Variable Field Run 1"));
            end;
        }
        field(25006181; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);

                // 16.03.2015 EDMS P21 >>
                if ("Make Code" <> xRec."Make Code") and ("Model Code" <> '') then
                    Validate("Model Code", '');
                // 16.03.2015 EDMS P21 <<
            end;
        }
        field(25006190; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(25006196; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item."No." where("Item Type" = const("Model Version"),
                                              "Make Code" = field("Make Code"),
                                              "Model Code" = field("Model Code"));

            trigger OnLookup()
            var
                Item: Record Item;
            begin
                // 20.02.2015 EDMS P21 >>
                if LookUpMgt.LookUpModelVersion(Item, "Model Version No.", "Make Code", "Model Code") then
                    Validate("Model Version No.", Item."No.");
                // 20.02.2015 EDMS P21 <<
            end;

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
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
            CaptionClass = '7,25006145,25006255';

            trigger OnValidate()
            begin
                TestVFRun2;
                CheckServicePlan(FieldNo("Variable Field Run 2"));
            end;
        }
        field(25006260; "Variable Field Run 3"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006145,25006260';

            trigger OnValidate()
            begin
                TestVFRun3;
                CheckServicePlan(FieldNo("Variable Field Run 3"));
            end;
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

            trigger OnValidate()
            begin
                if Rec."Requested Finishing Date" < Rec."Requested Starting Date" then
                    Error(FinishDateBeforeStartErr);
            end;
        }
        field(25006275; "Requested Finishing Time"; Time)
        {
            Caption = 'Requested Finishing Time';

            trigger OnValidate()
            begin
                if Rec."Requested Finishing Time" < Rec."Requested Starting Time" then
                    Error(FinishTimeBeforeStartErr);
            end;
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

            trigger OnValidate()
            var
                DateDiff: Integer;
            begin
                if xRec."Requested Finishing Date" <> 0D then begin
                    DateDiff := xRec."Requested Finishing Date" - xRec."Requested Starting Date";
                    if DateDiff > -1 then
                        "Requested Finishing Date" := "Requested Starting Date" + DateDiff
                    else
                        "Requested Finishing Date" := "Requested Starting Date";
                end else begin
                    "Requested Finishing Date" := "Requested Starting Date";
                end;
            end;
        }
        field(25006295; "Requested Starting Time"; Time)
        {
            Caption = 'Requested Starting Time';

            trigger OnValidate()
            var
                TimeDiff: Integer;
            begin
                if xRec."Requested Finishing Time" <> 0T then begin
                    TimeDiff := xRec."Requested Finishing Time" - xRec."Requested Starting Time";
                    if TimeDiff > -1 then
                        "Requested Finishing Time" := "Requested Starting Time" + TimeDiff
                    else
                        "Requested Finishing Time" := "Requested Starting Time";
                end else begin
                    "Requested Finishing Time" := "Requested Starting Time";
                end;
            end;
        }
        field(25006300; "Planning Policy"; Option)
        {
            Caption = 'Planning Policy';
            OptionCaption = 'Appointment,Queue';
            OptionMembers = Appointment,Queue;

            trigger OnValidate()
            begin
                if "Planning Policy" <> xRec."Planning Policy" then begin
                    if "Document Type" in ["document type"::Quote, "document type"::Order] then
                        ServiceScheduleMgt.ChangePlanningPolicy(Rec);
                end;
            end;
        }
        field(25006377; "Quote Applicable To Date"; Date)
        {
            Caption = 'Quote Applicable To Date';
        }
        field(25006378; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;

            trigger OnValidate()
            var
                Vehicle: Record Vehicle;
                Model: Record Model;
                DocumentMgt: Codeunit DocumentManagementDMS;
                FillCustomer: Boolean;
                PictureManagement: Codeunit "Picture Management";
            begin
                if "Vehicle Serial No." = '' then begin
                    "Vehicle Registration No." := '';
                    "Make Code" := '';
                    "Model Code" := '';
                    "Model Version No." := '';                                // 20.02.2015 EDMS P21
                    VIN := '';
                    "Vehicle Accounting Cycle No." := '';
                    "Vehicle Status Code" := '';
                    "Model Commercial Name" := '';
                    Validate("Contract No.", '');                             // 15.04.2014 Elva Baltic P21
                    exit;
                end;

                Vehicle.Get("Vehicle Serial No.");
                Vehicle.CalcFields("Default Vehicle Acc. Cycle No.");
                Vehicle.TestField(Blocked, false);  //08.05.2014 Elva Baltic P8 #S0084 MMG7.00


                VIN := Vehicle.VIN;
                Validate("Vehicle Accounting Cycle No.", Vehicle."Default Vehicle Acc. Cycle No.");
                "Vehicle Registration No." := Vehicle."Registration No.";
                "Make Code" := Vehicle."Make Code";
                "Model Code" := Vehicle."Model Code";
                "Model Version No." := Vehicle."Model Version No.";         // 20.02.2015 EDMS P21
                "Vehicle Status Code" := Vehicle."Status Code";
                "Customer Vehicle ID" := Vehicle."Customer Vehicle ID";         //07.04.2022 EDMS EB.KN

                if Model.Get("Make Code", "Model Code") then
                    "Model Commercial Name" := Model."Commercial Name"
                else
                    "Model Commercial Name" := Vehicle."Model Commercial Name";

                UpdVehicleInfo("Vehicle Serial No.", Vehicle);

                if (Rec."Sell-to Customer No." = xRec."Sell-to Customer No.") and not FindVehicle then
                    FindVehicleCont;

                UpdateVehicleContact;

                DocumentMgt.ShowVehicleComments("Vehicle Serial No.");

                CheckRecallCampaigns("Vehicle Serial No.");

                //29.09.2011 EDMS P8 >>
                if ("Vehicle Serial No." <> xRec."Vehicle Serial No.") and (xRec."Vehicle Serial No." <> '') then
                    TireManagement.ChangeVehicleInServiceHeader(Rec, xRec."Vehicle Serial No.", "Vehicle Serial No.");
                //29.09.2011 EDMS P8 <<

                // 26.03.2014 Elva Baltic P18 #F011 MMG7.00 >>
                CreateDim(
                  Database::"Vehicle Status", "Vehicle Status Code",
                  Database::Customer, "Bill-to Customer No.",
                  Database::"Salesperson/Purchaser", "Service Advisor",
                  Database::"Responsibility Center", "Responsibility Center",
                  Database::"Deal Type", "Deal Type",
                  Database::Make, "Make Code",
                  Database::Vehicle, "Vehicle Serial No.", //25.10.2013 EDMS P8
                  Database::"Payment Method", "Payment Method Code",
                  Database::Location, "Location Code"      // 10.03.2015 EDMS P21
                  );
                // 26.03.2014 Elva Baltic P18 #F011 MMG7.00 <<

                if xRec."Vehicle Serial No." <> "Vehicle Serial No." then begin               // 15.04.2014 Elva Baltic P21
                    FindContract;                                                               // 15.04.2014 Elva Baltic P21
                    SetHideValidationDialog(false);                                             // 23.04.2015 EDMS P21
                    RecreateDmsServLines(FieldCaption("Vehicle Serial No."));                   // 16.03.2015 EDMS P21
                    PictureManagement.UpdateVehicleSerialNo(Database::"Service Header EDMS", "Document Type", "No.", "Vehicle Serial No.");
                    UpdateRentOrderInfo("Vehicle Serial No.");
                end;

                UpdateServiceAddressCode;
            end;
        }
        field(25006379; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Editable = false;
            TableRelation = "Vehicle Accounting Cycle"."No.";
        }
        field(25006380; "Customer Vehicle ID"; Code[20])
        {
            Caption = 'Customer Vehicle ID';
            DataClassification = ToBeClassified;
        }
        field(25006390; "Vehicle Item Charge No."; Code[20])
        {
            Caption = 'Vehicle Item Charge No.';
            TableRelation = "Item Charge";
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
        field(25006630; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = Contract."Contract No.";

            trigger OnLookup()
            var
                ContractList: Page "Contract List EDMS";
                ContractVehicle: Record "Contract Vehicle";
                ContractTemp: Record Contract temporary;
                Customer: Record Customer;
            begin
                if Customer.Get("Bill-to Customer No.") then;
                Customer.SetContractFilter(ContractTemp, Contract.Status::Active, false, Contract."document profile"::Service, "Order Date", "Vehicle Serial No.");
                if ContractTemp.Get("Contract No.") then;
                if Page.RunModal(0, ContractTemp) = Action::LookupOK then
                    Validate("Contract No.", ContractTemp."Contract No.");


            end;

            trigger OnValidate()
            var
                IsHandled: boolean;
            begin
                if Contract.Get("Contract No.") and ("Contract No." <> xRec."Contract No.") then
                    if Contract."Payment Terms Code" <> '' then
                        Validate("Payment Terms Code", Contract."Payment Terms Code");

                if xRec."Contract No." <> "Contract No." then Begin
                    //>>DELTA XX
                    OnAfterSetFieldsContractNo(Rec, Contract, IsHandled);
                    If IsHandled = False then
                        //<<DELTA XX
                        RecreateDmsServLines(FieldCaption("Contract No."));
                End;
            end;
        }
        field(25006650; "E-Mail"; Text[80])
        {
            Caption = 'E-Mail';
            DataClassification = ToBeClassified;
            ExtendedDatatype = EMail;

            trigger OnValidate()
            begin
                //30/01/18 GH  P1 >>
                if "Sell-to Customer No." <> '' then begin
                    if Confirm(GHText001, true, FieldCaption("E-Mail")) then begin
                        Cust.Get("Sell-to Customer No.");
                        Cust."E-Mail" := "E-Mail";
                        Cust.Modify(true);
                    end;
                end;
                //30/01/18 GH  P1 <<
            end;
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
            CaptionClass = '7,25006145,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookUpMgt.LookUpVariableField(VFOptions, Database::"Service Header EDMS", FieldNo("Variable Field 25006800"),
                  "Make Code", "Variable Field 25006800") then begin
                    Validate("Variable Field 25006800", VFOptions.Code);
                end;
            end;
        }
        field(25006801; "Variable Field 25006801"; Code[20])
        {
            CaptionClass = '7,25006145,25006801';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookUpMgt.LookUpVariableField(VFOptions, Database::"Service Header EDMS", FieldNo("Variable Field 25006801"),
                  "Make Code", "Variable Field 25006801") then begin
                    Validate("Variable Field 25006801", VFOptions.Code);
                end;
            end;
        }
        field(25006802; "Variable Field 25006802"; Code[20])
        {
            CaptionClass = '7,25006145,25006802';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookUpMgt.LookUpVariableField(VFOptions, Database::"Service Header EDMS", FieldNo("Variable Field 25006802"),
                  "Make Code", "Variable Field 25006802") then begin
                    Validate("Variable Field 25006802", VFOptions.Code);
                end;
            end;
        }
        field(25006860; "Work Status Code"; Code[20])
        {
            Caption = 'Work Status Code';
            TableRelation = "Service Work Status EDMS";

            trigger OnValidate()
            var
                ServiceWorkStatus: Record "Service Work Status EDMS";
            begin
                if ServiceWorkStatus.Get("Work Status Code") then
                    "Work Status (System)" := ServiceWorkStatus."Service Order Status" + 1
                else
                    "Work Status (System)" := "work status (system)"::" ";
            end;
        }
        field(25006861; "Work Status (System)"; Option)
        {
            Caption = 'Work Status (System)';
            Editable = false;
            OptionCaption = ' ,Pending,In Process,Finished,On Hold';
            OptionMembers = " ",Pending,"In Process",Finished,"On Hold";
        }
        field(25006950; "Work Finish Notification"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(25006955; "Hide Labor Quantity and Price"; Boolean)
        {
            Caption = 'Hide Labor Quantity and Price';
            DataClassification = ToBeClassified;
        }
        field(25006956; "Show Branch Details"; Boolean)
        {
            Caption = 'Show Branch Details';
            DataClassification = ToBeClassified;
        }
        field(25006957; "Group Lines"; Boolean)
        {
            DataClassification = ToBeClassified;
        }
        field(25006960; "Comment First Line Text"; Text[80])
        {
            CalcFormula = lookup("Service Comment Line EDMS".Comment where(Type = field("Document Type"),
                                                                            "No." = field("No.")));
            FieldClass = FlowField;
        }
        field(25006970; Paid; Boolean)
        {
            Caption = 'Paid';
            DataClassification = ToBeClassified;
        }
        field(25006980; "Correction Type"; Option)
        {
            Caption = 'Correction Type';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Canceled,Canceling';
            OptionMembers = " ",Canceled,Canceling;
        }
        field(25006981; "Correction Applies to/from"; Code[20])
        {
            Caption = 'Correction Applies to/from';
            DataClassification = ToBeClassified;
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
                                                                                                  "Document No." = field("No."),
                                                                                                  Travel = const(false)));
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

            trigger OnValidate()
            var
                recDimValue: Record "Dimension Value";
            begin
                CreateDim(
                  Database::"Vehicle Status", "Vehicle Status Code",
                  Database::Customer, "Bill-to Customer No.",
                  Database::"Salesperson/Purchaser", "Service Advisor",
                  Database::"Responsibility Center", "Responsibility Center",
                  Database::"Deal Type", "Deal Type",
                  //DATABASE::Vehicle,VIN,
                  Database::Make, "Make Code",
                  Database::Vehicle, "Vehicle Serial No.", //25.10.2013 EDMS P8
                  Database::"Payment Method", "Payment Method Code",
                  Database::Location, "Location Code"      // 10.03.2015 EDMS P21
                  );

                //04.04.2014 Elva Baltic P1 #RX MMG7.00 >>
                //RecreateDmsServLines(FIELDCAPTION("Vehicle Status Code"));
                //04.04.2014 Elva Baltic P1 #RX MMG7.00 <<
            end;
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
            BlankZero = true;
            TableRelation = "TCard Container"."No." where("Location Code" = field("Location Code"));

            trigger OnValidate()
            var
                TCardContainer: Record "TCard Container";
            begin
                if "TCard Container Entry No." <> 0 then begin
                    TCardContainer.Get("TCard Container Entry No.");
                    case Rec."Document Type" of
                        Rec."document type"::Booking:
                            begin
                                if TCardContainer.Type <> TCardContainer.Type::Booking then
                                    Error(DocTypeContainerErr);
                            end;
                        Rec."document type"::Order:
                            begin
                                if TCardContainer.Type <> TCardContainer.Type::Order then
                                    Error(DocTypeContainerErr);
                            end;
                        else
                            Error(DocTypeContainerErr);
                    end;
                end;
            end;
        }
        field(25007395; "Booking No."; Code[20])
        {
        }
        field(25007396; "Booking Resource No."; Code[20])
        {
            TableRelation = Resource;
        }
        field(25007397; "Total Work (Hours)"; Decimal)
        {
        }
        field(25007398; "Service Address Code"; Code[20])
        {
            Caption = 'Service Address Code';
            TableRelation = "Ship-to Address".Code where("Customer No." = field("Sell-to Customer No."));

            trigger OnValidate()
            begin
                if ShipToAddr.Get("Sell-to Customer No.", "Service Address Code") then begin
                    "Service Address Name" := ShipToAddr.Name;
                    "Service Address" := ShipToAddr.Address;
                    "Service Address 2" := ShipToAddr."Address 2";
                    "Service Address Post Code" := ShipToAddr."Post Code";
                    "Service Address City" := ShipToAddr.City;
                    "Service Address Contact" := ShipToAddr.Contact;
                    Modify;
                end;
            end;
        }
        field(25007399; "Service Address Name"; Text[50])
        {
            Caption = 'Service Address Name';
        }
        field(25007400; "Service Address"; Text[50])
        {
            Caption = 'Service Address';
        }
        field(25007401; "Service Address 2"; Text[50])
        {
            Caption = 'Service Address 2';
        }
        field(25007402; "Service Address Post Code"; Code[20])
        {
            Caption = 'Service Address Post Code';
            TableRelation = "Post Code";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;
        }
        field(25007403; "Service Address City"; Text[30])
        {
            Caption = 'Service Address City';
        }
        field(25007404; "Service Address Contact"; Text[50])
        {
            Caption = 'Service Address Contact';
        }
        field(25007405; "Finished Travel Qty (Hours)"; Decimal)
        {
            CalcFormula = sum("Serv. Labor Alloc. Application"."Finished Quantity (Hours)" where("Document Type" = field("Document Type"),
                                                                                                  "Document No." = field("No."),
                                                                                                  Travel = const(true)));
            Caption = 'Finished Travel Quantity (Hours)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25007406; "Work Description"; Blob)
        {
            Caption = 'Work Description';
        }
        field(25007407; "Document Status"; Code[20])
        {
            Caption = 'Document Status';
            TableRelation = "Document Status".Code where("Document Type" = field("Document Type"),
                                                          "Document Profile" = const(Service));
        }
        field(25007408; "Opportunity No."; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Opportunity."No." where("Contact No." = field("Sell-to Contact No."),
                                                     Closed = const(false));
        }
        field(25007409; "TCardContSortIdx"; Decimal)
        {
            Caption = 'TCard Container Sort Index';
        }
        field(25007410; "Rent Order No."; Code[20])
        {
            Caption = 'Rent Order No.';
            TableRelation = "Rent Header"."No.";
        }
        field(25007411; "Rent Customer"; Text[100])
        {
            Caption = 'Rent Customer';
        }
    }

    keys
    {
        key(Key1; "Document Type", "No.")
        {
            Clustered = true;
        }
        key(Key2; "Document Type", "Order Date")
        {
        }
        key(Key3; "Sell-to Customer No.")
        {
        }
        key(Key4; "Bill-to Customer No.")
        {
        }
        key(Key5; "Vehicle Serial No.")
        {
        }
        key(Key6; "Document Type", "Sell-to Contact No.")
        {
        }
        key(Key7; "Bill-to Contact No.")
        {
        }
        key(Key8; "Document Type", "Sell-to Customer No.")
        {
        }
        key(Key9; "TCardContSortIdx", "Document Type", "No.")
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
        SalesHeader: Record "Sales Header";
        PictureManagement: Codeunit "Picture Management";
    begin
        /* if not UserMgt.CheckRespCenter(3, "Responsibility Center") then
             Error(Text022, RespCenter.TableCaption, UserMgt.GetSalesFilter);*/
        if not UserMgtELVA.CheckRespCenterEDMS("Responsibility Center") then
            Error(Text022, RespCenter.TableCaption, UserMgtELVA.GetServiceFilterEDMS);

        DmsServCommentLine.SetRange(Type, "Document Type");
        DmsServCommentLine.SetRange("No.", "No.");
        DmsServCommentLine.DeleteAll;

        //17.04.2014 Elva Baltic P1 #RX MMG7.00 >>
        ServLine.Reset;
        ServLine.SetRange("Document Type", "Document Type");
        ServLine.SetRange("Document No.", "No.");
        ServLine.SetRange(Type, ServLine.Type::Item);
        if ServLine.FindFirst then
            repeat
                ServLine.CheckReservationCancelation
            until ServLine.Next = 0;
        //17.04.2014 Elva Baltic P1 #RX MMG7.00 <<

        //23.02.2010 EDMS P2 >>
        if ("Document Type" in ["document type"::Quote, "document type"::Order]) then begin
            ServiceScheduleMgt.DontModifySalesLine(true);
            ServiceScheduleMgt.DeleteAllocationFromServHdr(Rec);
        end;
        //23.02.2010 EDMS P2 <<

        DeleteServLines;

        ServicePlanDocumentLink.Reset;
        ServicePlanDocumentLink.SetCurrentkey("Document Type", "Document No.");
        case Rec."Document Type" of
            "document type"::Quote:
                ServicePlanDocumentLink.SetRange("Document Type", ServicePlanDocumentLink."document type"::Quote);
            "document type"::Order:
                ServicePlanDocumentLink.SetRange("Document Type", ServicePlanDocumentLink."document type"::Order);
            "document type"::"Return Order":
                ServicePlanDocumentLink.SetRange("Document Type", ServicePlanDocumentLink."document type"::"Return Order");
        end;
        ServicePlanDocumentLink.SetRange("Document No.", Rec."No.");
        ServicePlanDocumentLink.DeleteAll(true);

        PictureManagement.DeleteRelatedPictures(Database::"Service Header EDMS", "Document Type", "No.", "Vehicle Serial No.");
    end;

    trigger OnInsert()
    begin

        ServiceSetup.Get;

        if "No." = '' then begin
            TestNoSeries;
            "No. Series" := GetNoSeriesCode();
            "No." := NoSeriesMgt.GetNextNo("No. Series", "Posting Date", true);
        end;

        InitRecord;

        if GetFilter("Sell-to Customer No.") <> '' then
            if GetRangeMin("Sell-to Customer No.") = GetRangemax("Sell-to Customer No.") then
                Validate("Sell-to Customer No.", GetRangeMin("Sell-to Customer No."));

        if GetFilter("Sell-to Contact No.") <> '' then
            if GetRangeMin("Sell-to Contact No.") = GetRangemax("Sell-to Contact No.") then
                Validate("Sell-to Contact No.", GetRangeMin("Sell-to Contact No."));

        "Doc. No. Occurrence" := ArchiveManagement.GetNextOccurrenceNo(Database::"Service Header EDMS", "Document Type", "No.");
    end;

    trigger OnRename()
    begin
        Error(Text003, TableCaption);
    end;

    var
        Contract: Record Contract;
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        CompanyInfo: Record "Company Information";
        GLSetup: Record "General Ledger Setup";
        ServiceScheduleSetup: Record "Service Schedule Setup";
        GLAcc: Record "G/L Account";
        ServiceHeader: Record "Service Header EDMS";
        ServLine: Record "Service Line EDMS";
        CustLedgEntry: Record "Cust. Ledger Entry";
        Cust: Record Customer;
        PaymentTerms: Record "Payment Terms";
        PaymentMethod: Record "Payment Method";
        CurrExchRate: Record "Currency Exchange Rate";
        DmsServCommentLine: Record "Service Comment Line EDMS";
        PostCode: Record "Post Code";
        BankAcc: Record "Bank Account";
        SalesShptHeader: Record "Sales Shipment Header";
        SalesInvHeader: Record "Sales Invoice Header";
        SalesCrMemoHeader: Record "Sales Cr.Memo Header";
        ReturnRcptHeader: Record "Return Receipt Header";
        GenBusPostingGrp: Record "Gen. Business Posting Group";
        GenJnILine: Record "Gen. Journal Line";
        RespCenter: Record "Responsibility Center";
        Location: Record Location;
        WhseRequest: Record "Warehouse Request";
        ServicePlanDocumentLink: Record "Service Plan Document Link";
        VehicleComponent: Record "Vehicle Component";
        SalesHeader: Record "Sales Header";
        UserMgt: Codeunit "User Setup Management";

        UserMgtELVA: codeunit "UserProfileManagement";
        NoSeriesMgt: Codeunit "No. Series";
        CustCheckCreditLimit: Codeunit "Cust-Check Cr. Limit";
        SalesMgt: Codeunit "Item Sales Doc. Mgt. EDMS";
        GenJnlApply: Codeunit "Gen. Jnl.-Apply";
        DimMgt: Codeunit DimensionManagement;
        ArchiveManagement: Codeunit ArchiveManagement;
        ServiceScheduleMgt: Codeunit "Service Schedule Mgt.";
        CurrencyDate: Date;
        HideValidationDialog: Boolean;
        Confirmed: Boolean;
        ReservEntry: Record "Reservation Entry";
        SkipSellToContact: Boolean;
        SkipBillToContact: Boolean;
        Text001: label 'Do you want to print invoice %1?';
        Text003: label 'You cannot rename a %1.';
        Text004: label 'Do you want to change %1?';
        Text005: label 'You cannot reset %1 because the document still has one or more lines.';
        Text006: label 'You cannot change %1 because the order is associated with one or more purchase orders.';
        Text008: label 'Deleting this document will cause a gap in the number series for shipments. ';
        Text009: label 'An empty shipment %1 will be created to fill this gap in the number series.\\';
        Text010: label 'Do you want to continue?';
        Text011: label 'Deleting this document will cause a gap in the number series for posted invoices. ';
        Text012: label 'An empty posted invoice %1 will be created to fill this gap in the number series.\\';
        Text013: label 'Deleting this document will cause a gap in the number series for posted credit memos. ';
        Text014: label 'An empty posted credit memo %1 will be created to fill this gap in the number series.\\';
        Text015: label 'If you change %1, the existing sales lines will be deleted and new sales lines based on the new information on the header will be created.\\';
        Text017: label 'You must delete the existing sales lines before you can change %1.';
        Text018: label 'You have changed %1 on the service header, but it has not been changed on the existing service lines.\';
        Text019: label 'You must update the existing service lines manually.';
        Text020: label 'The change may affect the exchange rate used in the price calculation of the service lines.';
        Text021: label 'Do you want to update the exchange rate?';
        Text022: label 'You cannot delete this document. Your identification is set up to process from %1 %2 only.';
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
        Text045: label 'You can not change the %1 field because %2 %3 has %4 = %5 and the %6 has already been assigned %7 %8.';
        Text051: label 'The services %1 %2 already exists.';
        tcSER001: label 'The vehicle %1 %2, registration number %3,  VIN %4 exists on another service order.';
        SkipVehicleChoose: Boolean;
        LookUpMgt: Codeunit LookUpManagement;
        Text053: label 'You must cancel the approval process if you wish to change the %1.';
        Text054: label 'The sales %1 %2 has item tracking. Do you want to delete it anyway?';
        Text055: label 'Deleting this document will cause a gap in the number series for prepayment invoices. ';
        Text056: label 'An empty prepayment invoice %1 will be created to fill this gap in the number series.\\';
        SalesInvHeaderPrepmt: Record "Sales Invoice Header";
        SalesCrMemoHeaderPrepmt: Record "Sales Cr.Memo Header";
        Text064: label 'You may have changed a dimension.\\Do you want to update the lines?';
        Text101: label 'One or more sales invoice exist.';
        Text102: label 'Pending service plan No. %1 exists for this vehicle.';
        Text121: label 'The vehicle %1 %2, registration number %3,  VIN %4 exists in %5 other service orders.';
        Text122: label 'You cannot Release Quote or Make Order unless you specify a vehicle on the quote.\\Do you want to create vehicle now?';
        Text123: label 'You cannot Release Quote or Make Order unless you specify a sell-to contact or sell-to customer on the quote.\\Do you want to create contact now?';
        Text124: label 'Service package %1 is blocked.';
        Text125: label 'Do You want to link this vehice to contact No. %1?';
        EDMS001: label '%1 cannot be less than in previous visit.';
        VFMgt: Codeunit "Variable Field Management";
        ContBusRel: Record "Contact Business Relation";
        Text130: label 'There are one or more pending recall campaigns for VIN %1. Please check recall campaign details';
        Text131: label 'There is no vehicle with Registration No. %1';
        VehicleConfirm: label 'There is a vehicle linked to this contact.\%1 %2\%3 %4\%5 %6\Do you want to apply this vehicle?';
        ContactConfirm: label 'There is a customer linked to this vehicle.\%1 %2\Do you want to apply this customer?';
        FindVehicle: Boolean;
        FindCustomer: Boolean;
        TireManagement: Codeunit "Tire Management";
        Vehicle: Record Vehicle;
        VehicleServicePlanStageTmp_CS: Record "Vehicle Service Plan Stage" temporary;
        AppMgt: Codeunit DocumentManagementDMS;
        AboutComponentsNotified: Boolean;
        Text132: label 'There is component with pending plan stage.';
        LastModifiedRec: Record "Service Header EDMS";
        Text133: label 'No Service Package corresponds to characteristics of the vehicle.';
        ApplyCustEntries: Page "Apply Customer Entries";
        ResourceTextFieldValue: Text[250];
        ResourceTextFieldModified: Boolean;
        ServicePrevParcedRsc: Record "Service Header EDMS" temporary;
        ServLaborApplicationGlobTmp: Record "Serv. Labor Alloc. Application" temporary;
        Text134: label 'No Service Package Version corresponds to characteristics of the vehicle. (%1: %2)';
        Text135: label 'Do you want to leave prices and discounts unchanged?';
        Text136: label 'Cutomer No. %1 have %2 active contracts!';
        Text137: label 'There is no %1 with %2 %3';
        Text138: label 'Service Schedule Setup does not exist. Please create Service Schedule Setup Entry.';
        PricesInclVATValidated: Boolean;
        SavePricesConfirmed: Boolean;
        AlreadyConfirmed: Boolean;
        TCardMgt: Codeunit "TCard Management";
        DocTypeContainerErr: label 'Document Type does not mach with Container Type';
        FinishDateBeforeStartErr: label 'Finishing Date is before Starting Date';
        FinishTimeBeforeStartErr: label 'Finishing Time is before Starting Time';
        ShipToAddr: Record "Ship-to Address";
        GHText001: label 'Do you want to update %1 on the customer card too?';
        CreateOrSelectVehOptTxt: label 'Create a new vehicle card for %1,Select an existing vehicle';
        CreateOrSelectVehCaption: label 'The vehicle is not registered. To continue, choose one of the following options:';
        AppEventMgt: Codeunit "Application Event Management";


    procedure InitRecord()
    var
        LocCodeFilterStr: Code[20];
        SingleQuote: Char;
    begin
        case "Document Type" of
            "document type"::Order:
                begin
                    if ServiceSetup."Use Order No. as Posting No." then begin
                        "Posting No." := "No.";
                        "Posting No. Series" := "No. Series"
                    end else
                        if NoSeriesMgt.IsAutomatic(ServiceSetup."Posted Order Nos.") then
                            "Posting No. Series" := ServiceSetup."Posted Order Nos.";

                    if NoSeriesMgt.IsAutomatic(ServiceSetup."Posted Prepmt. Inv. Nos.") then
                        "Prepayment No. Series" := ServiceSetup."Posted Prepmt. Inv. Nos.";

                    if NoSeriesMgt.IsAutomatic(ServiceSetup."Posted Prepmt. Cr. Memo Nos.") then
                        "Prepmt. Cr. Memo No. Series" := ServiceSetup."Posted Prepmt. Cr. Memo Nos.";

                end;
            "document type"::"Return Order":
                begin
                    if ServiceSetup."Use Order No. as Posting No." then begin
                        "Pst. Return Order No." := "No.";
                        "Pst. Return Order No. Series" := "No. Series"
                    end else
                        if NoSeriesMgt.IsAutomatic(ServiceSetup."Posted Return Order Nos.") then
                            "Pst. Return Order No. Series" := ServiceSetup."Posted Return Order Nos.";

                end;
            "document type"::Booking:
                begin
                    "Location Code" := GetFilter("Location Code");
                end;
        end;

        if "Document Type" in ["document type"::"Return Order"] then begin
            GLSetup.Get;
            Correction := GLSetup."Mark Cr. Memos as Corrections";
        end;

        // "Responsibility Center" := UserMgt.GetRespCenter(3, "Responsibility Center");
        "Responsibility Center" := UserMgtELVA.GetRespCenterEDMS("Responsibility Center");
        GetUserSetup;
        "User ID" := UserId;

        Validate("Order Date", WorkDate);
        Validate("Order Time", Time);

        if "Posting Date" = 0D then
            "Posting Date" := WorkDate;
        "Document Date" := WorkDate;

        "Posting Description" := Format("Document Type") + ' ' + "No.";

        if not ServiceScheduleSetup.Get then
            if not HideValidationDialog then
                Message(Text138);

        "Planning Policy" := ServiceScheduleSetup."Planning Policy";

        if "Document Type" = "document type"::Booking then begin
            SingleQuote := 39;
            FilterGroup(2);
            LocCodeFilterStr := DelChr(GetFilter("Location Code"), '=', Format(SingleQuote));
            if LocCodeFilterStr <> '' then
                Validate("Location Code", GetFilter("Location Code"));
            "Requested Starting Date" := GetRangemax(Rec."Requested Starting Date");
            "Requested Finishing Date" := GetRangemax(Rec."Requested Starting Date");
            FilterGroup(0);
            "Requested Starting Time" := Time;
            "Requested Finishing Time" := Time;
        end;

        //04.10.2017 EB.AKR Warranty >>
        if "Document Type" <> "document type"::Quote then
            "Initial Service Order No." := "No.";
        //04.10.2017 EB.AKR Warranty <<
    end;


    procedure AssistEdit(OldSalesHeader: Record "Service Header EDMS"): Boolean
    var
        SalesHeader2: Record "Service Header EDMS";
    begin
        ServiceHeader.Copy(Rec);
        ServiceSetup.Get;
        TestNoSeries;
        if NoSeriesMgt.LookupRelatedNoSeries(GetNoSeriesCode(), OldSalesHeader."No. Series", ServiceHeader."No. Series") then begin
            ServiceHeader."No." := NoSeriesMgt.GetNextNo(ServiceHeader."No. Series", WorkDate(), true);
            if SalesHeader2.Get(ServiceHeader."Document Type", ServiceHeader."No.") then
                Error(Text051, Lowercase(Format(ServiceHeader."Document Type")), ServiceHeader."No.");
            Rec := ServiceHeader;
            exit(true);
        end;
    end;

    local procedure TestNoSeries(): Boolean
    begin
        case "Document Type" of
            "document type"::Quote:
                ServiceSetup.TestField("Quote Nos.");
            "document type"::Order:
                begin
                    if "Quote No." <> '' then
                        ServiceSetup.TestField("Order Nos. from Quote")
                    else
                        ServiceSetup.TestField("Order Nos.");
                end;
            "document type"::"Return Order":
                ServiceSetup.TestField("Return Order Nos.");
            "document type"::Booking:
                ServiceSetup.TestField("Service Booking Nos.");
        end;
    end;

    local procedure GetNoSeriesCode(): Code[10]
    begin
        case "Document Type" of
            "document type"::Quote:
                exit(ServiceSetup."Quote Nos.");
            "document type"::Order:
                begin
                    if "Quote No." <> '' then
                        exit(ServiceSetup."Order Nos. from Quote")
                    else
                        exit(ServiceSetup."Order Nos.");
                end;
            "document type"::"Return Order":
                exit(ServiceSetup."Return Order Nos.");
            "document type"::Booking:
                exit(ServiceSetup."Service Booking Nos.");
        end;
    end;

    local procedure GetPostingNoSeriesCode(): Code[10]
    begin
        if "Document Type" in ["document type"::"Return Order"] then
            exit(ServiceSetup."Posted Credit Memo Nos.");
        exit(ServiceSetup."Posted Invoice Nos.");
    end;


    procedure ConfirmDeletion(): Boolean
    begin
        if SalesShptHeader."No." <> '' then begin
            Confirmed := ConfirmLoc(StrSubstNo(Text008 + Text009 + Text010, SalesShptHeader."No."), true, '');
            if not Confirmed then
                exit;
        end;
        if SalesInvHeader."No." <> '' then begin
            Confirmed := ConfirmLoc(StrSubstNo(Text011 + Text012 + Text010, SalesInvHeader."No."), true, '');
            if not Confirmed then
                exit;
        end;
        if SalesCrMemoHeader."No." <> '' then begin
            Confirmed := ConfirmLoc(StrSubstNo(Text013 + Text014 + Text010, SalesCrMemoHeader."No."), true, '');
            if not Confirmed then
                exit;
        end;
        if ReturnRcptHeader."No." <> '' then begin
            Confirmed := ConfirmLoc(StrSubstNo(Text029 + Text030 + Text010, ReturnRcptHeader."No."), true, '');
            if not Confirmed then
                exit;
        end;
        //08-05-2007 EDMS P3 PREPMT >>
        if "Prepayment No." <> '' then begin
            Confirmed := ConfirmLoc(StrSubstNo(Text053 + Text054 + Text010, SalesInvHeaderPrepmt.TableName,
              SalesInvHeaderPrepmt."No."), true, '');
            if not Confirmed then
                exit;
        end;
        if "Prepmt. Cr. Memo No." <> '' then begin
            Confirmed := ConfirmLoc(StrSubstNo(Text055 + Text056 + Text010, SalesCrMemoHeaderPrepmt."No."), true, '');
            if not Confirmed then
                exit;
        end;
        //08-05-2007 EDMS P3 PREPMT <<

        exit(true);
    end;

    local procedure GetCust(CustNo: Code[20])
    begin
        if not (("Document Type" = "document type"::Quote) and (CustNo = '')) then begin
            if CustNo <> Cust."No." then
                Cust.Get(CustNo);
        end else
            Clear(Cust);
    end;


    procedure DmsServLinesExist(): Boolean
    begin
        ServLine.Reset;
        ServLine.SetRange("Document Type", "Document Type");
        ServLine.SetRange("Document No.", "No.");
        exit(ServLine.FindSet);
    end;


    procedure MessageIfServLinesExist(ChangedFieldName: Text[100])
    begin
        if DmsServLinesExist then
            MessageLoc(StrSubstNo(Text018 + Text019, ChangedFieldName), '');
    end;


    procedure PriceMessageIfServLinesExist(ChangedFieldName: Text[100])
    begin
        if DmsServLinesExist then
            MessageLoc(StrSubstNo(Text018 + Text020, ChangedFieldName), '');
    end;

    local procedure UpdateCurrencyFactor()
    begin
        if "Currency Code" <> '' then begin
            if ("Document Type" in ["document type"::Quote, "document type"::VHC]) and
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
        Confirmed := ConfirmLoc(Text021, false, '');
        if Confirmed then
            Validate("Currency Factor")
        else
            "Currency Factor" := xRec."Currency Factor";
    end;


    procedure SetHideValidationDialog(NewHideValidationDialog: Boolean)
    begin
        HideValidationDialog := NewHideValidationDialog;
    end;

    procedure GETHideValidationDialog(): Boolean
    BEGIN
        EXIT(HideValidationDialog);
    END;

    procedure SetSkipVehicleChoose(NewSkipVehicleChoose: Boolean)
    begin
        SkipVehicleChoose := NewSkipVehicleChoose;
    end;


    procedure UpdateDMSServLines(ChangedFieldName: Text[100]; AskQuestion: Boolean)
    var
        Question: Text[250];
        UpdateLines: Boolean;
    begin
        if DmsServLinesExist and AskQuestion then begin
            Question := StrSubstNo(
              Text031 +
              Text032, ChangedFieldName);
            Confirmed := ConfirmLoc(Question, true, '');
            if not Confirmed then
                exit
            else
                UpdateLines := true;
        end;
        if DmsServLinesExist then begin
            ServLine.LockTable;
            Modify;

            ServLine.Reset;
            ServLine.SetRange("Document Type", "Document Type");
            ServLine.SetRange("Document No.", "No.");
            if ServLine.FindSet then
                repeat
                    case ChangedFieldName of
                        FieldCaption("Currency Factor"):
                            if ServLine.Type <> ServLine.Type::Comment then begin
                                ServLine.Validate("Unit Price");
                                ServLine.Validate("Unit Cost (LCY)");
                            end;
                        FieldCaption("Requested Delivery Date"):
                            if ServLine."No." <> '' then
                                ServLine.Validate("Requested Delivery Date", "Requested Delivery Date");
                        FieldCaption("Promised Delivery Date"):
                            if ServLine."No." <> '' then
                                ServLine.Validate("Promised Delivery Date", "Promised Delivery Date");
                        //21.02.2010 EDMS P2 >>
                        FieldCaption("Prepayment %"):
                            if ServLine."No." <> '' then
                                ServLine.Validate("Prepayment %", "Prepayment %");
                        //21.02.2010 EDMS P2 <<
                        FieldCaption("Shipping Time"):
                            if ServLine."No." <> '' then
                                ServLine.Validate("Shipping Time", "Shipping Time");
                        FieldCaption("Shipment Date"):
                            if ServLine."No." <> '' then
                                ServLine.Validate("Shipment Date", "Shipment Date");
                    end;
                    //DMSServLineReserve.AssignForPlanning(DMSServLine);
                    ServLine.Modify(true);
                until ServLine.Next = 0;
        end;
    end;

    local procedure DeleteServLines()
    begin
        ServLine.Reset;
        ServLine.SetRange("Document Type", "Document Type");
        ServLine.SetRange("Document No.", "No.");
        ServLine.DeleteAll(true);
        if Get("Document Type", "No.") then;
    end;


    procedure CheckCustomerCreated(Prompt: Boolean): Boolean
    var
        Cont: Record Contact;
        Confirmed: Boolean;
    begin
        if ("Bill-to Customer No." <> '') and ("Sell-to Customer No." <> '') then
            exit(true);


        if Prompt then begin
            Confirmed := ConfirmLoc(Text035, true, '');
            if not Confirmed then
                exit(false);
        end;

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

        Validate("Sell-to Customer No.");  //01.02.2013 EDMS P8

        exit(("Bill-to Customer No." <> '') and ("Sell-to Customer No." <> ''));
    end;


    procedure UpdateSellToCont(CustomerNo: Code[20])
    var
        ContBusRel: Record "Contact Business Relation";
        Cont: Record Contact;
        Cust: Record Customer;
        recVehicle: Record Vehicle;
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
                end;            // 19.02.2015 EDMS P21
            end;              // 19.02.2015 EDMS P21

            //27.01.2015 EB.P7 #E0062 MMG7.00 >>
            if (Rec."Vehicle Registration No." = xRec."Vehicle Registration No.")
               and ("Vehicle Serial No." = xRec."Vehicle Serial No.") and not FindCustomer
            then
                if not SkipVehicleChoose then
                    FindContVehicle;
            //27.01.2015 EB.P7 #E0062 MMG7.00 <<
            //  END;          // 19.02.2015 EDMS P21
            //END;            // 19.02.2015 EDMS P21

            "Sell-to Contact" := Cust.Contact;
            if (Rec."Sell-to Contact No." <> xRec."Sell-to Contact No.") then
                if not SkipVehicleChoose then
                    //if not SkipSellToContact then //27.10.2014 EB.P8 #S0218 MMG7.00
                        Validate("Sell-to Contact No.");
        end;
    end;


    procedure UpdateBillToCont(CustomerNo: Code[20])
    var
        ContBusRel: Record "Contact Business Relation";
        Cont: Record Contact;
        Cust: Record Customer;
        recVehicle: Record Vehicle;
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
        if ("Bill-to Contact No." <> '') and Cont.Get("Bill-to Contact No.") then
            "Bill-to Contact Phone No." := Cont."Phone No.";

        if "Vehicle Serial No." <> '' then begin
            recVehicle.Get("Vehicle Serial No.");
        end;
    end;


    procedure UpdateSellToCust(ContactNo: Code[20])
    var
        ContBusinessRelation: Record "Contact Business Relation";
        Cust: Record Customer;
        Cont: Record Contact;
        CustTemplate: Record "Customer Templ.";
        ContComp: Record Contact;
        recVehicle: Record Vehicle;
    begin

        if Cont.Get(ContactNo) then begin
            "Sell-to Contact No." := Cont."No.";

            if Cont.Type = Cont.Type::Person then
                "Sell-to Contact" := Cont.Name
            else
                if Cust.Get("Sell-to Customer No.") then
                    "Sell-to Contact" := Cust.Contact
                else
                    "Sell-to Contact" := '';
            "Phone No." := Cont."Phone No.";
        end else begin
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
                "Sell-to Address" := ContComp.Address;
                "Sell-to Address 2" := ContComp."Address 2";
                "Sell-to City" := ContComp.City;
                "Sell-to Post Code" := ContComp."Post Code";
                "Sell-to County" := ContComp.County;
                "Sell-to Country/Region Code" := ContComp."Country/Region Code";
                if ("Sell-to Customer Template Code" = '') and (not CustTemplate.IsEmpty) then
                    Validate("Sell-to Customer Template Code", Cont.FindNewCustomerTemplate);
            end else
                Error(Text039, Cont."No.", Cont.Name);
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
            "Bill-to Contact Phone No." := Cont."Phone No.";
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


    procedure CheckCreditMaxBeforeInsert()
    var
        SalesHeader: Record "Sales Header";
        ContBusinessRelation: Record "Contact Business Relation";
        Cont: Record Contact;
        CustCheckCreditLimit: Codeunit "Cust-Check Cr. Limit";
    begin
        if GetFilter("Sell-to Customer No.") <> '' then begin
            if GetRangeMin("Sell-to Customer No.") = GetRangemax("Sell-to Customer No.") then begin
                SalesHeader."Bill-to Customer No." := GetRangeMin("Sell-to Customer No.");
                CustCheckCreditLimit.SalesHeaderCheck(SalesHeader);
            end
        end else
            if GetFilter("Sell-to Contact No.") <> '' then
                if GetRangeMin("Sell-to Contact No.") = GetRangemax("Sell-to Contact No.") then begin
                    Cont.Get(GetRangeMin("Sell-to Contact No."));
                    ContBusinessRelation.Reset;
                    ContBusinessRelation.SetCurrentkey("Link to Table", "No.");
                    ContBusinessRelation.SetRange("Link to Table", ContBusinessRelation."link to table"::Customer);
                    ContBusinessRelation.SetRange("Contact No.", Cont."Company No.");
                    if ContBusinessRelation.FindFirst then begin
                        SalesHeader."Bill-to Customer No." := ContBusinessRelation."No.";
                        CustCheckCreditLimit.SalesHeaderCheck(SalesHeader);
                    end;
                end;
    end;


    procedure CreateInvtPutAwayPick()
    var
        WhseRequest: Record "Warehouse Request";
    begin
        WhseRequest.Reset;
        WhseRequest.SetCurrentkey("Source Document", "Source No.");
        case "Document Type" of
            "document type"::Order:
                WhseRequest.SetRange("Source Document", WhseRequest."source document"::"Sales Order");
            "document type"::"Return Order":
                WhseRequest.SetRange("Source Document", WhseRequest."source document"::"Sales Return Order");
        end;
        WhseRequest.SetRange("Source No.", "No.");
        Report.RunModal(Report::"Create Invt Put-away/Pick/Mvmt", true, false, WhseRequest);
    end;


    procedure FindContVehicle(): Code[20]
    var
        Vehicle: Record Vehicle;
        VehCount: Integer;
        Cont: Record Contact;
        VehicleContact: Record "Vehicle Contact";
        Confirmed: Boolean;
        VehicleList: Page "Vehicle List";
        ClientTypeManagement: Codeunit "Client Type Management";
    begin
        if ClientTypeManagement.GetCurrentClientType in [ClientType::OData, ClientType::ODataV4, ClientType::SOAP] then
            SetHideValidationDialog(true);

        if "Sell-to Contact No." = '' then
            exit;

        if not Cont.Get("Sell-to Contact No.") then
            exit;

        FindVehicle := true;

        Vehicle.Reset;

        MarkContVehicles(Vehicle, Cont."No.");
        if (Cont.Type = Cont.Type::Person)
         and (Cont."Company No." <> '') then begin
            if Cont.Get(Cont."Company No.") then
                MarkContVehicles(Vehicle, Cont."No.");
        end;
        Vehicle.MarkedOnly(true);
        VehCount := Vehicle.Count;

        case VehCount of
            0:
                begin
                    Vehicle.MarkedOnly(false);
                end;
            1:
                begin
                    Vehicle.FindFirst;
                    Confirmed := ConfirmLoc(StrSubstNo(VehicleConfirm, Vehicle."Make Code", Vehicle."Model Code",
                      Vehicle.FieldCaption("Registration No."), Vehicle."Registration No.",
                      Vehicle.FieldCaption(VIN), Vehicle.VIN), true, '');
                    if Confirmed then
                        Validate("Vehicle Serial No.", Vehicle."Serial No.");
                end;
            else begin
                Commit;
                if not HideValidationDialog then begin
                    VehicleList.SetTableview(Vehicle);
                    VehicleList.SetRecord(Vehicle);
                    VehicleList.LookupMode(true);
                    //IF PAGE.RUNMODAL(PAGE::"Vehicle List",Vehicle) = ACTION::LookupOK THEN //!!
                    //  VALIDATE("Vehicle Serial No.",Vehicle."Serial No.")
                    if VehicleList.RunModal = Action::LookupOK then begin
                        VehicleList.GetRecord(Vehicle);
                        Validate("Vehicle Serial No.", Vehicle."Serial No.");
                    end;
                end else begin
                    Vehicle.FindFirst;
                    Validate("Vehicle Serial No.", Vehicle."Serial No.");
                end;
            end;
        end;
    end;


    procedure FindVehicleCont(): Code[20]
    var
        Vehicle: Record Vehicle;
        CustomerCount: Integer;
        Contact: Record Contact;
        VehicleContact: Record "Vehicle Contact";
        ContBusRelation: Record "Contact Business Relation";
        Customer: Record Customer;
        ContactCount: Integer;
        MarketingSetup: Record "Marketing Setup";
        ContactBusinessRelation: Record "Contact Business Relation";
        Customer2: Record Customer;
    begin
        if "Vehicle Serial No." = '' then
            exit;

        FindCustomer := true;
        //29.05.2013 Elva Baltic P15 >>
        ContBusRelation.Reset;
        Customer.Reset;
        VehicleContact.Reset;
        VehicleContact.SetRange("Vehicle Serial No.", "Vehicle Serial No.");
        VehicleContact.SetRange("Do Not Use In Service", false);
        MarketingSetup.Get;

        if VehicleContact.FindFirst then
            repeat
                ContBusRelation.SetRange("Contact No.", VehicleContact."Contact No.");

                if ContBusRelation.FindFirst then
                    repeat
                        if (ContBusRelation."Business Relation Code" = MarketingSetup."Bus. Rel. Code for Customers") and (Customer.Get(ContBusRelation."No.")) then
                            VehicleContact.Mark(true);
                    until ContBusRelation.Next = 0;
            until VehicleContact.Next = 0;
        VehicleContact.MarkedOnly(true);

        ContactCount := VehicleContact.Count;

        case ContactCount of
            0:
                begin
                    Contact.MarkedOnly(false);
                end;
            1:
                begin
                    Contact.FindFirst;
                    if "Sell-to Contact No." <> VehicleContact."Contact No." then begin       // 19.02.2015 EDMS P21
                        if GuiAllowed then begin
                            Confirmed := ConfirmLoc(StrSubstNo(ContactConfirm, Customer."No.", Customer.Name), true, '');
                            if Confirmed then
                                Validate("Sell-to Contact No.", VehicleContact."Contact No.");

                        end else begin
                            Validate("Sell-to Contact No.", VehicleContact."Contact No.");
                        end;
                    end;                                                                      // 19.02.2015 EDMS P21
                end;
            else begin
                Commit;
                if GuiAllowed then begin
                    if Page.RunModal(Page::"Vehicle Contacts", VehicleContact) = Action::LookupOK then
                        Validate("Sell-to Contact No.", VehicleContact."Contact No.");
                end else begin
                    Validate("Sell-to Contact No.", VehicleContact."Contact No.");
                end;
            end;
        end;
        //29.05.2013 Elva Baltic P15 <<
    end;


    procedure UpdVehicleInfo(VehSerialNo: Code[20]; recVehicle: Record Vehicle)
    var
        recServHeader: Record "Service Header EDMS";
        recSalesLine: Record "Sales Line";
    begin
        //11.07.2007. EDMS P2 >>
        if not HideValidationDialog then
            if VIN <> '' then begin
                recServHeader.SetRange("Document Type", "Document Type");
                recServHeader.SetFilter("No.", '<>%1', "No.");
                recServHeader.SetRange("Vehicle Serial No.", VehSerialNo);
                case recServHeader.Count of
                    0:
                        exit;
                    1:
                        MessageLoc(StrSubstNo(
                          tcSER001, recVehicle."Make Code", recVehicle."Model Code", recVehicle."Registration No.", recVehicle.VIN
                          ), '');
                    else
                        MessageLoc(StrSubstNo(
                          Text121, recVehicle."Make Code", recVehicle."Model Code", recVehicle."Registration No.", recVehicle.VIN, recServHeader.Count
                          ), '');
                end;
            end;
        //11.07.2007. EDMS P2 <<
    end;


    procedure GetUserSetup()
    var
        UserSetup: Record "User Setup";
        SingleInstanceMgt: Codeunit SingleInstanceManagement;
        UserProfileMgt: Codeunit UserProfileManagement;
        UserProfile: Record "Branch Profile Setup";
        ServSetup: Record "Service Mgt. Setup EDMS";
        ServLocation: Code[20];
        ishandled: boolean;
    begin
        ServSetup.Get;

        if UserSetup.Get(UserId) then begin
            if (UserSetup."Salespers./Purch. Code" <> '') AND ("Service Advisor" = '') then //>>DELTA 01 
                Validate("Service Advisor", UserSetup."Salespers./Purch. Code");
        end;

        if UserProfileMgt.CurrProfileID <> '' then begin
            if UserProfile.Get(UserProfileMgt.CurrProfileID, UserProfileMgt.CurrBranchNo) then begin
                if UserProfile."Spec. Service Setup" then begin //For Vehicle Salespersons
                    Validate("Initiator Code", UserSetup."Salespers./Purch. Code");
                    onBeforechangeserviceAdvisor(rec, ishandled);
                    if not ishandled then
                        Validate("Service Advisor", UserProfile."Spec. Order Receiver");
                    UserProfile.TestField("Spec. Servic Branch Profile");
                    if UserProfile.Get(UserProfile."Spec. Servic Branch Profile", UserProfile."Spec. Branch Code") then begin
                        ServLocation := UserProfile."Def. Service Location Code";
                        if ServLocation = '' then
                            ServLocation := ServSetup."Def. Service Location Code";
                        if ServLocation <> '' then
                            Validate("Location Code", ServLocation);
                        if UserProfile."Default Deal Type Code" <> '' then
                            Validate("Deal Type", UserProfile."Default Deal Type Code");
                    end;
                end
                else begin //For Service Employees
                    ServLocation := UserProfile."Def. Service Location Code";
                    if ServLocation = '' then
                        ServLocation := ServSetup."Def. Service Location Code";
                    if ServLocation <> '' then
                        Validate("Location Code", ServLocation);
                    if UserProfile."Default Deal Type Code" <> '' then
                        Validate("Deal Type", UserProfile."Default Deal Type Code");
                end;
            end;
        end else begin
            ServLocation := ServSetup."Def. Service Location Code";  //26.02.2013 EDMS P8
            if ServLocation <> '' then
                Validate("Location Code", ServLocation);
            if ServSetup."Deal Type Mandatory" then
                TestField("Deal Type");
        end;
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
            if DmsServLinesExist then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;

    local procedure UpdateAllLineDim(NewParentDimSetID: Integer; OldParentDimSetID: Integer)
    var
        ATOLink: Record "Assemble-to-Order Link";
        NewDimSetID: Integer;
    begin
        // Update all lines with changed dimensions.

        if NewParentDimSetID = OldParentDimSetID then
            exit;
        if not Confirm(Text064) then
            exit;

        ServLine.Reset;
        ServLine.SetRange("Document Type", "Document Type");
        ServLine.SetRange("Document No.", "No.");
        ServLine.LockTable;
        if ServLine.FindSet(true, false) then
            repeat
                NewDimSetID := DimMgt.GetDeltaDimSetID(ServLine."Dimension Set ID", NewParentDimSetID, OldParentDimSetID);
                if ServLine."Dimension Set ID" <> NewDimSetID then begin
                    ServLine."Dimension Set ID" := NewDimSetID;
                    DimMgt.UpdateGlobalDimFromDimSetID(
                      ServLine."Dimension Set ID", ServLine."Shortcut Dimension 1 Code", ServLine."Shortcut Dimension 2 Code");
                    ServLine.Modify;
                end;
            until ServLine.Next = 0;
    end;


    procedure CreateDim(Type1: Integer; No1: Code[20]; Type2: Integer; No2: Code[20]; Type3: Integer; No3: Code[20]; Type4: Integer; No4: Code[20]; Type5: Integer; No5: Code[20]; Type6: Integer; No6: Code[20]; Type7: Integer; No7: Code[20]; Type8: Integer; No8: Code[20]; Type9: Integer; No9: Code[20])
    var
        SourceCodeSetup: Record "Source Code Setup";
        TableID: array[10] of Integer;
        No: array[10] of Code[20];
        OldDimSetID: Integer;
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
        No[5] := No5;
        TableID[6] := Type6;
        No[6] := No6;
        TableID[7] := Type7;
        No[7] := No7;
        TableID[8] := Type8;  //25.10.2013 EDMS P8
        No[8] := No8;
        // 10.03.2015 EDMS P21 >>
        TableID[9] := Type9;
        No[9] := No9; */
        // 10.03.2015 EDMS P21 <<

        Clear(Dimsource);
        DimMgt.AddDimSource(Dimsource, Type1, No1);
        DimMgt.AddDimSource(Dimsource, Type2, No2);
        DimMgt.AddDimSource(Dimsource, Type3, No3);
        DimMgt.AddDimSource(Dimsource, Type4, No4);
        DimMgt.AddDimSource(Dimsource, Type5, No5);
        DimMgt.AddDimSource(Dimsource, Type6, No6);
        DimMgt.AddDimSource(Dimsource, Type7, No7);
        DimMgt.AddDimSource(Dimsource, Type8, No8);
        DimMgt.AddDimSource(Dimsource, Type9, No9);

        "Shortcut Dimension 1 Code" := '';
        "Shortcut Dimension 2 Code" := '';
        OldDimSetID := "Dimension Set ID";
        "Dimension Set ID" :=
          DimMgt.GetDefaultDimID(Dimsource, SourceCodeSetup."Service Management EDMS",
                             "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", 0, 0);

        if (OldDimSetID <> "Dimension Set ID") and DmsServLinesExist then begin
            Modify;
            UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;
    end;


    procedure RecreateDmsServLines(ChangedFieldName: Text[100])
    var
        ServLineTmp: Record "Service Line EDMS" temporary;
        //SIEAssgnt: Record "SIE Assignment";
        //SIEAssgntTmp: Record "SIE Assignment" temporary;
        ReservationEntryTemp: Record "Reservation Entry" temporary;
    begin
        if DmsServLinesExist then begin
            Confirmed := ConfirmLoc(StrSubstNo(Text015 + Text004, ChangedFieldName), false, '');
            if Confirmed then begin
                //    DocDim.LOCKTABLE;//26.01.2012 EDMS

                // 23.04.2015 EDMS P21 >>
                if ("Currency Code" = xRec."Currency Code") and not AlreadyConfirmed then begin
                    SavePricesConfirmed := ConfirmLoc(Text135, false, '');
                    AlreadyConfirmed := true;
                end;
                // 23.04.2015 EDMS P21 <<

                ServLine.LockTable;
                ReservEntry.LockTable;
                Modify;

                ServLine.Reset;
                ServLine.SetRange("Document Type", "Document Type");
                ServLine.SetRange("Document No.", "No.");
                if ServLine.FindSet(true, false) then begin
                    repeat
                        ServLine.TestField("Prepmt. Amt. Inv.", 0);
                        ServLine."Bill-to Customer No." := "Bill-to Customer No.";
                        ServLine."Contract No." := "Contract No.";                                  // 15.04.2014 Elva Baltic P21

                        ServLine."Gen. Bus. Posting Group" := "Gen. Bus. Posting Group";
                        if ServLine.Type <> ServLine.Type::Comment then
                            ServLine.Validate("VAT Bus. Posting Group", "VAT Bus. Posting Group");
                        ServLine.Modify;
                        ServLineTmp := ServLine;
                        ServLineTmp.Insert;
                        CopyReservation(ServLine, ServLineTmp, ReservationEntryTemp, 1)
                    until ServLine.Next = 0;

                    /*
                    SIEAssgnt.SetRange("Applies-to Type", Database::"Service Line EDMS");
                    SIEAssgnt.SetRange("Applies-to Doc. Type", "Document Type");
                    SIEAssgnt.SetRange("Applies-to Doc. No.", "No.");
                    if SIEAssgnt.FindFirst then begin
                        repeat
                            SIEAssgntTmp.Init;
                            SIEAssgntTmp := SIEAssgnt;
                            SIEAssgntTmp.Insert
                        until SIEAssgnt.Next = 0;
                        SIEAssgnt.DeleteAll;
                    end;
                    */

                    if ServLine.FindSet then begin
                        repeat
                            ServLine.SetRecreate(true);
                            ServLine.Delete(true);
                        until ServLine.Next = 0;
                    end;
                    ServLine.Init;
                    ServLine."Line No." := 0;
                    ServLineTmp.FindSet;
                    repeat
                        ServLine.Init;  //06.03.2008. EDMS P2 delete condition "if "Package No." = '' "
                        ServLine."Line No." := ServLineTmp."Line No.";
                        ServLine.Validate(Type, ServLineTmp.Type);
                        if ServLineTmp."No." = '' then begin
                            ServLine.Validate(Description, ServLineTmp.Description);
                            ServLine.Validate("Description 2", ServLineTmp."Description 2");
                        end else begin
                            ServLine."Standard Time" := ServLineTmp."Standard Time";
                            ServLine.Validate("No.", ServLineTmp."No.");
                            if ServLine.Type <> ServLine.Type::Comment then begin
                                ServLine.Validate("Unit of Measure Code", ServLineTmp."Unit of Measure Code");
                                ServLine.Validate("Variant Code", ServLineTmp."Variant Code");
                                ServLine."Standard Time" := ServLineTmp."Standard Time";
                                if ServLineTmp.Quantity <> 0 then
                                    ServLine.Validate(Quantity, ServLineTmp.Quantity);
                                ServLine."Purchase Order No." := ServLineTmp."Purchase Order No.";
                                ServLine."Purch. Order Line No." := ServLineTmp."Purch. Order Line No.";
                                ServLine.Split := ServLineTmp.Split;
                                ServLine.Description := ServLineTmp.Description;
                                ServLine."Description 2" := ServLineTmp."Description 2";
                                ServLine."Drop Shipment" := ServLine."Purch. Order Line No." <> 0;

                                //06.03.2008. EDMS P2 >>
                                ServLine.Group := ServLineTmp.Group;
                                ServLine."Group ID" := ServLineTmp."Group ID";
                                ServLine.VIN := ServLineTmp.VIN;
                                ServLine."Package No." := ServLineTmp."Package No.";
                                ServLine."Package Version No." := ServLineTmp."Package Version No.";
                                ServLine."Package Version Spec. Line No." := ServLineTmp."Package Version Spec. Line No.";
                                //06.03.2008. EDMS P2 <<
                                ServLine."Location Code" := ServLineTmp."Location Code";
                                ServLine.Status := ServLineTmp.Status;
                                ServLine."Variable Field 25006800" := ServLineTmp."Variable Field 25006800";
                                ServLine."Variable Field 25006801" := ServLineTmp."Variable Field 25006801";
                                ServLine."Variable Field 25006802" := ServLineTmp."Variable Field 25006802";
                                //2012.03.14 EDMS P8 >>
                                ServLine."Tire Operation Type" := ServLineTmp."Tire Operation Type";
                                ServLine."Vehicle Axle Code" := ServLineTmp."Vehicle Axle Code";
                                ServLine."Tire Position Code" := ServLineTmp."Tire Position Code";
                                ServLine."Tire Code" := ServLineTmp."Tire Code";
                                ServLine."New Vehicle Axle Code" := ServLineTmp."New Vehicle Axle Code";
                                ServLine."New Tire Position Code" := ServLineTmp."New Tire Position Code";
                                //2012.03.14 EDMS P8 <<

                                ServLine."External Serv. Tracking No." := ServLineTmp."External Serv. Tracking No.";

                                // 10.04.2014 Elva Baltic P21 >>
                                if SavePricesConfirmed then begin
                                    ServLine.Validate("Unit Price", ServLineTmp."Unit Price");
                                    ServLine.Validate("Line Discount %", ServLineTmp."Line Discount %");
                                end;
                                // 10.04.2014 Elva Baltic P21 <<
                            end;
                        end;
                        ServLine.Insert;
                        ServiceScheduleMgt.ResourcesCopyLineToLine(ServLineTmp."Document Type", ServLineTmp."Document No.",
                          ServLineTmp.Type, ServLineTmp."Line No.",
                          ServLine."Document Type", ServLine."Document No.", ServLine."Line No.");
                        CopyReservation(ServLine, ServLineTmp, ReservationEntryTemp, 2)
                    until ServLineTmp.Next = 0;

                    /*
                    if ServLineTmp.FindFirst then
                        repeat
                            SIEAssgntTmp.SetRange("Applies-to Doc. Line No.", ServLineTmp."Line No.");
                            if SIEAssgntTmp.FindFirst then
                                repeat
                                    SIEAssgnt.Init;
                                    SIEAssgnt := SIEAssgntTmp;
                                    SIEAssgnt.Insert;
                                until SIEAssgntTmp.Next = 0;
                        until ServLineTmp.Next = 0;
                    */

                    // 16.03.2015 EDMS P21 >>
                    if SavePricesConfirmed and ("Prices Including VAT" <> xRec."Prices Including VAT")
                       and not PricesInclVATValidated
                    then begin
                        Validate("Prices Including VAT");
                        PricesInclVATValidated := true;
                    end;
                    // 16.03.2015 EDMS P21 <<
                end;
            end else
                Error(
                  Text017, ChangedFieldName);
        end
    end;


    procedure InsertServPackage()
    var
        SPVersion: Record "Service Package Version";
    begin
        SPVersion.FilterGroup(2);

        InsertLookupSPVersion(SPVersion);
    end;


    procedure InsertServPackageRecall()
    var
        RecallCampaignVehicle: Record "Recall Campaign Vehicle";
        ServicePackage: Record "Service Package";
        SPVersion: Record "Service Package Version";
        RecallsNoFilter: Text[250];
        PackageNoFilter: Text[250];
        Text001: label 'No records to list.';
    begin
        RecallCampaignVehicle.Reset;
        RecallCampaignVehicle.SetRange(VIN, VIN);
        RecallCampaignVehicle.SetRange(Serviced, false);
        RecallCampaignVehicle.SetRange("Active Campaign", true);
        RecallCampaignVehicle.FindFirst;

        repeat
            RecallsNoFilter += '''' + RecallCampaignVehicle."Campaign No." + '''|'
        until RecallCampaignVehicle.Next = 0;
        RecallsNoFilter := CopyStr(RecallsNoFilter, 1, StrLen(RecallsNoFilter) - 1);
        ServicePackage.SetCurrentkey("Recall Campaign No.");
        ServicePackage.SetFilter("Recall Campaign No.", RecallsNoFilter);
        if not ServicePackage.FindFirst then
            Error(Text001);
        repeat
            PackageNoFilter += '''' + ServicePackage."No." + '''|'
        until ServicePackage.Next = 0;
        PackageNoFilter := CopyStr(PackageNoFilter, 1, StrLen(PackageNoFilter) - 1);
        SPVersion.FilterGroup(2);
        SPVersion.SetFilter("Package No.", PackageNoFilter);

        InsertLookupSPVersion(SPVersion);
    end;


    procedure InsertServPackageByRecallNo(RecallCampaignVehicleNo: Code[20])
    var
        ServicePackage: Record "Service Package";
        SPVersion: Record "Service Package Version";
        RecallsNoFilter: Text[250];
        PackageNoFilter: Text[250];
        Text001: label 'No records to list.';
    begin
        ServicePackage.SetCurrentkey("Recall Campaign No.");
        ServicePackage.SetRange("Recall Campaign No.", RecallCampaignVehicleNo);
        if not ServicePackage.FindFirst then
            exit;
        repeat
            PackageNoFilter += '''' + ServicePackage."No." + '''|'
        until ServicePackage.Next = 0;
        PackageNoFilter := CopyStr(PackageNoFilter, 1, StrLen(PackageNoFilter) - 1);
        SPVersion.SetFilter("Package No.", PackageNoFilter);

        InsertLookupSPVersion(SPVersion);
    end;


    procedure InsertLookupSPVersion(var SPVersion: Record "Service Package Version")
    var
        SPVersionSpec: Record "Service Package Version Line";
        ServLine: Record "Service Line EDMS";
        ServicePackage: Record "Service Package";
        LastLineNo: Integer;
        Text001: label 'No records to list.';
        ServicePackageVersionSelect: Page "Service Package Version-Select";
    begin
        SPVersionAssignFilter(SPVersion);
        if SPVersion.FindFirst then;
        if SPVersion.Count > 1 then begin
            ServicePackageVersionSelect.SetTableview(SPVersion);
            ServicePackageVersionSelect.LookupMode(true);
            //IF NOT (ServicePackageVersionSelect.RUNMODAL = ACTION::LookupOK) THEN
            if not (Page.RunModal(Page::"Service Package Version-Select", SPVersion) = Action::LookupOK) then
                exit;
        end;
        InsertSPVersion(SPVersion);
    end;


    procedure InsertSPVersion(var SPVersion: Record "Service Package Version")
    var
        SPVersionSpec: Record "Service Package Version Line";
        ServLine: Record "Service Line EDMS";
        ServicePackage: Record "Service Package";
        Text001: label 'No records to list.';
    begin
        if SPVersion."Package No." <> '' then begin
            ServicePackage.Get(SPVersion."Package No.");
            if ServicePackage.Blocked then
                Error(StrSubstNo(Text124, SPVersion."Package No."));

            SPVersionSpec.Reset;
            SPVersionSpec.SetRange("Package No.", SPVersion."Package No.");
            SPVersionSpec.SetRange("Version No.", SPVersion."Version No.");
            if SPVersionSpec.FindSet then begin
                repeat
                    SPVersionSpec.SetCurrPlanStage(VehicleServicePlanStageTmp_CS);
                    SPVersionSpec.CreateServLine("Document Type", Rec."No.");
                until SPVersionSpec.Next = 0
            end else begin
                Error(Text134, SPVersion.TableCaption, SPVersion."Version No.");
            end;
        end else
            Error(Text133, SPVersion.TableCaption);
    end;


    procedure InsertServPackagePlaned()
    var
        VehicleServicePlan: Record "Vehicle Service Plan";
        VehicleServicePlanStage: Record "Vehicle Service Plan Stage";
        ServicePackage: Record "Service Package";
        SPVersion: Record "Service Package Version";
        Text001: label 'No records to list.';
    begin
        Clear(VehicleServicePlanStageTmp_CS);
        VehicleServicePlan.Reset;
        VehicleServicePlan.SetRange("Vehicle Serial No.", "Vehicle Serial No.");
        VehicleServicePlan.SetRange(Active, true);
        if not VehicleServicePlan.FindFirst then
            Error(Text001)
        else
            if VehicleServicePlan.Count > 1 then begin
                if Page.RunModal(Page::"Vehicle Service Plans", VehicleServicePlan) = Action::LookupOK then
                    VehicleServicePlan.SetRange("No.", VehicleServicePlan."No.")
                else
                    VehicleServicePlan.SetRange("No.", '0');  // IT should not record within such filter by NO
            end;
        if VehicleServicePlan.FindFirst then begin
            VehicleServicePlanStage.SetRange("Vehicle Serial No.", "Vehicle Serial No.");
            VehicleServicePlanStage.SetRange("Plan No.", VehicleServicePlan."No.");
            VehicleServicePlanStage.SetRange(Status, VehicleServicePlanStage.Status::Pending);
            if VehicleServicePlanStage.FindFirst then begin
                VehicleServicePlanStageTmp_CS := VehicleServicePlanStage;
                if ServicePackage.Get(VehicleServicePlanStage."Package No.") then begin
                    SPVersion.SetRange("Package No.", ServicePackage."No.");
                    InsertLookupSPVersion(SPVersion);
                end else
                    Error(Text001)
            end;
        end else
            Error(Text001)
    end;


    procedure PriceErrorIfServLinesExist(ChangedFieldName: Text[100]; FilledTableNr: Integer)
    var
        RecRF: RecordRef;
    begin
        RecRF.Open(FilledTableNr);
        if DmsServLinesExist and not HideValidationDialog then
            Error(Text028, ChangedFieldName, RecRF.Caption);
    end;

    local procedure TestNoSeriesDate(No: Code[20]; NoSeriesCode: Code[10]; NoCapt: Text[1024]; NoSeriesCapt: Text[1024])
    var
        NoSeries: Record "No. Series";
    begin
        if (No <> '') and (NoSeriesCode <> '') then begin
            NoSeries.Get(NoSeriesCode);
            if NoSeries."Date Order" then
                Error(
                  Text045,
                  FieldCaption("Posting Date"), NoSeriesCapt, NoSeriesCode,
                  NoSeries.FieldCaption("Date Order"), NoSeries."Date Order", "Document Type",
                  NoCapt, No);
        end;
    end;

    /*
    procedure ShowSIEAssgnt()
    var
        SIEAssgnt: Record "SIE Assignment";
        SIEAssgntsForm: Page "SIE Assignment";
    begin
        Get("Document Type", "No.");
        TestField("No.");

        Clear(SIEAssgnt);
        with SIEAssgnt do begin
            Reset;
            SetRange("Applies-to Type", Database::"Service Line EDMS");
            SetRange("Applies-to Doc. Type", "Document Type");
            SetRange("Applies-to Doc. No.", "No.");
            if not FindLast then begin
                SIEAssgnt."Applies-to Type" := Database::"Service Line EDMS";
                SIEAssgnt."Applies-to Doc. Type" := "Document Type";
                SIEAssgnt."Applies-to Doc. No." := "No.";
            end;
            SIEAssgnt."Applies-to Doc. Line No." := 0;
        end;

        SIEAssgntsForm.Initialize(SIEAssgnt);
        SIEAssgntsForm.RunModal;
    end;
    */

    procedure InvoiceExist(): Boolean
    var
        SalesHeader: Record "Sales Header";
    begin
        SalesHeader.Reset;
        SalesHeader.SetCurrentkey("Service Document No.");
        SalesHeader.SetRange("Document Type", SalesHeader."document type"::Invoice);
        SalesHeader.SetRange("Service Document No.", "No.");
        if SalesHeader.FindFirst then
            exit(true)
    end;


    procedure GetVFCaption(intFieldNo: Integer): Text[30]
    begin
        Clear(VFMgt);
        exit(VFMgt.GetVFCaption(Database::"Service Header EDMS", intFieldNo, "Make Code"));
    end;


    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::"Service Header EDMS", intFieldNo));
    end;


    procedure TestVFRun1()
    var
        ServOrdInfoPaneMgt: Codeunit "Service Info-Pane Mgt. EDMS";
    begin
        //14.09.2007. P2 >>
        if "Variable Field Run 1" > 0 then begin
            if "Variable Field Run 1" < ServOrdInfoPaneMgt.CalcLastVisitVFRun1("Vehicle Serial No.") then
                MessageLoc(StrSubstNo(EDMS001, AppEventMgt.VFCaptionClassTranslate(GlobalLanguage, '25006145,25006180')), '');
            TestVFRun1ForComponent;
        end;
        //14.09.2007. P2 <<
    end;


    procedure TestVFRun2()
    var
        ServOrdInfoPaneMgt: Codeunit "Service Info-Pane Mgt. EDMS";
    begin
        if "Variable Field Run 2" > 0 then begin
            if "Variable Field Run 2" < ServOrdInfoPaneMgt.CalcLastVisitVFRun2("Vehicle Serial No.") then
                MessageLoc(StrSubstNo(EDMS001, AppEventMgt.VFCaptionClassTranslate(GlobalLanguage, '25006145,25006255')), '');
            TestVFRun1ForComponent;
        end;
    end;


    procedure TestVFRun3()
    var
        ServOrdInfoPaneMgt: Codeunit "Service Info-Pane Mgt. EDMS";
    begin
        if "Variable Field Run 3" > 0 then begin
            if "Variable Field Run 3" < ServOrdInfoPaneMgt.CalcLastVisitVFRun3("Vehicle Serial No.") then
                MessageLoc(StrSubstNo(EDMS001, AppEventMgt.VFCaptionClassTranslate(GlobalLanguage, '25006145,25006260')), '');
            TestVFRun1ForComponent;
        end;
    end;


    procedure TestVFRun1ForComponent()
    var
        VehicleServicePlanStage: Record "Vehicle Service Plan Stage";
        ServOrdInfoPaneMgt: Codeunit "Service Info-Pane Mgt. EDMS";
        CompPendingPlanExists: Boolean;
    begin
        // for now do not check actual value
        ServiceSetup.Get;
        if ServiceSetup."Notify About Components" then
            if not (("Document Type" = LastModifiedRec."Document Type") and ("No." = LastModifiedRec."No.")) then
                AboutComponentsNotified := false;
        LastModifiedRec := Rec;
        if not AboutComponentsNotified then begin
            VehicleComponent.Reset;
            VehicleComponent.SetRange("Parent Vehicle Serial No.", "Vehicle Serial No.");
            if VehicleComponent.FindFirst then
                repeat
                    VehicleServicePlanStage.Reset;
                    VehicleServicePlanStage.SetCurrentkey(Status, "Expected Service Date");
                    VehicleServicePlanStage.SetRange(Status, VehicleServicePlanStage.Status::Pending);
                    VehicleServicePlanStage.SetRange("Vehicle Serial No.", VehicleComponent."No.");
                    CompPendingPlanExists := VehicleServicePlanStage.FindFirst;
                until ((VehicleComponent.Next = 0) or CompPendingPlanExists);
            if CompPendingPlanExists then begin
                MessageLoc(Text132, '');
                AboutComponentsNotified := true;
            end;
        end;
    end;


    procedure CheckVehicleCreated(Prompt: Boolean): Boolean
    var
        Vehicle: Record Vehicle;
    begin
        if ("Vehicle Serial No." <> '') then
            exit(true);

        if Prompt then begin
            Confirmed := ConfirmLoc(Text122, true, '');
            if not Confirmed then
                exit(false);
        end;

        TestField("Make Code");
        TestField("Model Code");
        TestField(VIN);

        Vehicle.Reset;
        Vehicle."Serial No." := '';
        Vehicle.Insert(true);
        Vehicle.Validate(VIN, VIN);
        Vehicle.Validate("Make Code", "Make Code");
        Vehicle.Validate("Model Code", "Model Code");
        if "Model Version No." <> '' then
            Vehicle.Validate("Model Version No.", "Model Version No.");
        if "Vehicle Registration No." <> '' then
            Vehicle.Validate("Registration No.", "Vehicle Registration No.");
        if "Vehicle Status Code" <> '' then
            Vehicle.Validate("Status Code", "Vehicle Status Code");

        OnCheckVehicleCreatedOnBeforeVehicle1modify(Vehicle, Rec);
        Vehicle.Modify(true);
        // "Vehicle Serial No." := Vehicle."Serial No.";         // 16.03.2015 EDMS P21
        Validate("Vehicle Serial No.", Vehicle."Serial No.");    // 16.03.2015 EDMS P21

        exit("Vehicle Serial No." <> '');
    end;


    procedure CheckContactCreated(Prompt: Boolean): Boolean
    var
        Contact: Record Vehicle;
    begin
        if ("Sell-to Contact No." <> '') then
            exit(true);
        if ("Sell-to Customer No." <> '') then
            exit(true);

        if Prompt then begin
            Confirmed := ConfirmLoc(Text123, true, '');
            if not Confirmed then
                exit(false);
        end;
        exit(CreateContactFromServHeader);
    end;


    procedure CreateContactFromServHeader(): Boolean
    var
        Cont: Record Contact;
    begin
        Cont.Init;

        Cont.Validate(Name, "Sell-to Customer Name");
        Cont.Validate("Name 2", "Sell-to Customer Name 2");
        Cont.Validate(Address, "Sell-to Address");
        Cont.Validate("Address 2", "Sell-to Address 2");
        Cont.Validate(City, "Sell-to City");
        Cont.Validate("Post Code", "Sell-to Post Code");

        Cont."No." := '';
        Cont.SetSkipDefault; //Upgrade 2017
        Cont.Insert(true);
        Validate("Sell-to Contact No.", Cont."No.");
        Modify(true);
        exit(true);
    end;


    procedure CheckRecallCampaigns(VehSerialNo: Code[20])
    var
        Vehicle: Record Vehicle;
        RecallCampaignVeh: Record "Recall Campaign Vehicle";
    begin
        Vehicle.Reset;
        if not Vehicle.Get(VehSerialNo) then
            exit;

        ServiceSetup.Get;
        if not ServiceSetup."Recall Campaign Warnings" then
            exit;

        RecallCampaignVeh.Reset;
        RecallCampaignVeh.SetRange(VIN, Vehicle.VIN);
        if RecallCampaignVeh.FindFirst then
            repeat
                RecallCampaignVeh.CalcFields("Active Campaign");
                if (RecallCampaignVeh."Active Campaign") and not RecallCampaignVeh.Serviced then
                    MessageLoc(StrSubstNo(Text130, Vehicle.VIN), '');
            until RecallCampaignVeh.Next = 0;
    end;


    procedure MarkContVehicles(var Vehicle: Record Vehicle; ContNo: Code[20])
    var
        VehicleContact: Record "Vehicle Contact";
    begin
        VehicleContact.Reset;
        VehicleContact.SetCurrentkey("Contact No.");
        VehicleContact.SetRange("Contact No.", ContNo);
        VehicleContact.SetRange("Do Not Use In Service", false);
        if VehicleContact.FindFirst then
            repeat
                if Vehicle.Get(VehicleContact."Vehicle Serial No.") then
                    Vehicle.Mark := true;
            until VehicleContact.Next = 0;
    end;


    procedure MarkVehicleContacts(var Contact: Record Contact; VehSerialNo: Code[20])
    var
        VehicleContact: Record "Vehicle Contact";
    begin
        VehicleContact.Reset;
        VehicleContact.SetCurrentkey("Vehicle Serial No.");
        VehicleContact.SetRange("Vehicle Serial No.", VehSerialNo);
        if VehicleContact.FindFirst then
            repeat
                if Contact.Get(VehicleContact."Contact No.") then
                    Contact.Mark := true;
            until VehicleContact.Next = 0;
    end;


    procedure SetAmountToApply(AppliesToDocNo: Code[20]; CustomerNo: Code[20])
    var
        CustLedgEntry: Record "Cust. Ledger Entry";
    begin
        CustLedgEntry.SetCurrentkey("Document No.");
        CustLedgEntry.SetRange("Document No.", AppliesToDocNo);
        CustLedgEntry.SetRange("Customer No.", CustomerNo);
        CustLedgEntry.SetRange(Open, true);
        if CustLedgEntry.FindFirst then begin
            if CustLedgEntry."Amount to Apply" = 0 then begin
                CustLedgEntry.CalcFields("Remaining Amount");
                CustLedgEntry."Amount to Apply" := CustLedgEntry."Remaining Amount";
            end else
                CustLedgEntry."Amount to Apply" := 0;
            Codeunit.Run(Codeunit::"Cust. Entry-Edit", CustLedgEntry);
        end;
    end;


    procedure CheckServicePlan(FieldPar: Integer)
    var
        VehicleServicePlanStage: Record "Vehicle Service Plan Stage";
        PlanDateFormula: Code[20];
    begin
        if "Vehicle Serial No." = '' then
            exit;
        ServiceSetup.Get;

        if not ServiceSetup."Service Plan Notification" then
            exit;

        if IsAchievedServPlanStageByField(FieldPar, VehicleServicePlanStage) then
            MessageLoc(StrSubstNo(Text102, VehicleServicePlanStage."Plan No."), '');
    end;


    procedure IsAchievedServPlanStageByField(FieldPar: Integer; var VehicleServicePlanStage: Record "Vehicle Service Plan Stage"): Boolean
    var
        VehicleServicePlan: Record "Vehicle Service Plan";
        PlanDateFormula: Code[20];
        MakeCheck: Boolean;
    begin
        ServiceSetup.Get;

        VehicleServicePlanStage.Reset;
        VehicleServicePlanStage.SetRange("Vehicle Serial No.", "Vehicle Serial No.");
        VehicleServicePlanStage.SetRange(Status, VehicleServicePlanStage.Status::Pending);

        case FieldPar of
            FieldNo("Variable Field Run 1"):
                begin
                    if ("Variable Field Run 1" = 0) then
                        exit(false);
                    VehicleServicePlanStage.SetRange("Variable Field Run 1", 0.0000000001,
                                                     "Variable Field Run 1" + ServiceSetup."Notify Before (VF Run 1)");
                    if VehicleServicePlanStage.FindFirst then
                        if (VehicleServicePlanStage."Variable Field Run 1" = 0) then
                            exit(false);
                end;
            FieldNo("Variable Field Run 2"):
                begin
                    if ("Variable Field Run 2" = 0) then
                        exit(false);
                    VehicleServicePlanStage.SetRange("Variable Field Run 2", 0.0000000001,
                                                     "Variable Field Run 2" + ServiceSetup."Notify Before (VF Run 2)");
                    if VehicleServicePlanStage.FindFirst then
                        if (VehicleServicePlanStage."Variable Field Run 2" = 0) then
                            exit(false);
                end;
            FieldNo("Variable Field Run 3"):
                begin
                    if ("Variable Field Run 3" = 0) then
                        exit(false);
                    VehicleServicePlanStage.SetRange("Variable Field Run 3", 0.0000000001,
                                                     "Variable Field Run 3" + ServiceSetup."Notify Before (VF Run 3)");
                    if VehicleServicePlanStage.FindFirst then
                        if (VehicleServicePlanStage."Variable Field Run 3" = 0) then
                            exit(false);
                end;
            FieldNo("Order Date"):
                begin
                    if ("Order Date" = 0D) then
                        exit(false);
                    //08.05.2013 EDMS P8 >>
                    exit(IsAchievedServStageByInterval(VehicleServicePlanStage));
                    //08.05.2013 EDMS P8 <<
                    /*
                    PlanDateFormula := '-' +FORMAT(ServiceSetup."Notify Before (Date Formula)");
                    VehicleServicePlanStage.SETRANGE("Expected Service Date",
                                                     20010101D,
                                                     CALCDATE(ServiceSetup."Notify Before (Date Formula)","Order Date"));
                    IF VehicleServicePlanStage.FINDFIRST THEN
                      IF (VehicleServicePlanStage."Expected Service Date" = 0D) THEN
                        EXIT(FALSE);
                    */
                end;
        end;
        exit(VehicleServicePlanStage.FindFirst);

    end;


    procedure IsAchievedServStageByInterval(var VehicleServicePlanStage: Record "Vehicle Service Plan Stage"): Boolean
    var
        VehicleServicePlan: Record "Vehicle Service Plan";
        ServicePlanManagement: Codeunit "Service Plan Management";
        PlanDateFormula: Code[20];
        LastServiceDate: Date;
        NotifyBorderDate: Date;
        ExpectedServiceDate: Date;
        MakeCheck: Boolean;
    begin
        ServiceSetup.Get;

        VehicleServicePlanStage.Reset;
        VehicleServicePlanStage.SetRange("Vehicle Serial No.", "Vehicle Serial No.");
        VehicleServicePlanStage.SetRange(Status, VehicleServicePlanStage.Status::Pending);
        NotifyBorderDate := CalcDate(ServiceSetup."Notify Before (Date Formula)", "Order Date");
        if VehicleServicePlanStage.FindFirst then
            repeat
                //08.05.2013 EDMS P8 >>
                VehicleServicePlan.Get("Vehicle Serial No.", VehicleServicePlanStage."Plan No.");
                MakeCheck := false;
                if VehicleServicePlan."Auto Order By Exp. Date" then
                    MakeCheck := true
                else
                    if Format(VehicleServicePlanStage."Service Interval") <> '' then
                        MakeCheck := true;
                //08.05.2013 EDMS P8 <<
                if MakeCheck then begin
                    ExpectedServiceDate := ServicePlanManagement.GetExpectedDateByIntervalGlob("Vehicle Serial No.",
                      VehicleServicePlanStage."Plan No.", VehicleServicePlanStage);
                    if ((ExpectedServiceDate <= NotifyBorderDate) and (ExpectedServiceDate > 0D)) then
                        VehicleServicePlanStage.Mark(true);
                end;
            until VehicleServicePlanStage.Next = 0;
        VehicleServicePlanStage.MarkedOnly(true);
        exit(VehicleServicePlanStage.FindFirst);
    end;


    procedure UpdateVehicleContact()
    var
        VehicleContact: Record "Vehicle Contact";
    begin
        ServiceSetup.Get;
        if not ServiceSetup."Offer Link Vehicle and Contact" then
            exit;

        if "Sell-to Contact No." = '' then
            exit;

        VehicleContact.Reset;
        VehicleContact.SetRange("Vehicle Serial No.", "Vehicle Serial No.");
        if VehicleContact.Count > 0 then
            exit;

        Confirmed := ConfirmLoc(StrSubstNo(Text125, "Sell-to Contact No."), false, '');
        if not Confirmed then
            exit;

        VehicleContact.Init;
        VehicleContact.Validate("Vehicle Serial No.", "Vehicle Serial No.");
        VehicleContact.Validate("Relationship Code", ServiceSetup."Link Relationship Code");
        VehicleContact.Validate("Contact No.", "Sell-to Contact No.");
        VehicleContact.Insert(true);
    end;


    procedure CopyReservation(var ServiceLine: Record "Service Line EDMS"; var ServiceLineTemp: Record "Service Line EDMS"; var ReservationEntryTemp: Record "Reservation Entry"; CopyWay: Integer)
    var
        ReservationEntry: Record "Reservation Entry";
        ReservationEntry2: Record "Reservation Entry";
        ReservationEntryTemp2: Record "Reservation Entry" temporary;
    begin
        if CopyWay = 1 then begin
            ReservationEntry.Reset;
            ReservationEntry.SetCurrentkey("Source ID");
            ReservationEntry.SetRange("Source ID", ServiceLine."Document No.");
            ReservationEntry.SetRange("Source Type", Database::"Service Line EDMS");
            ReservationEntry.SetRange("Source Subtype", ServiceLine."Document Type");
            ReservationEntry.SetRange("Source Ref. No.", ServiceLine."Line No.");
            if ReservationEntry.FindFirst then
                repeat
                    ReservationEntryTemp := ReservationEntry;
                    ReservationEntryTemp.Insert;
                    if ReservationEntry2.Get(ReservationEntry."Entry No.", not ReservationEntry.Positive) then begin
                        ReservationEntryTemp := ReservationEntry2;
                        ReservationEntryTemp.Insert;
                    end;
                until ReservationEntry.Next = 0;
        end;

        if CopyWay = 2 then begin
            ReservationEntryTemp.Reset;
            ReservationEntryTemp.SetCurrentkey("Source ID");
            ReservationEntryTemp.SetRange("Source ID", ServiceLineTemp."Document No.");
            ReservationEntryTemp.SetRange("Source Type", Database::"Service Line EDMS");
            ReservationEntryTemp.SetRange("Source Subtype", ServiceLineTemp."Document Type");
            ReservationEntryTemp.SetRange("Source Ref. No.", ServiceLineTemp."Line No.");
            ReservationEntryTemp.SetRange("Reservation Status", ReservationEntryTemp."reservation status"::Reservation);
            if ReservationEntryTemp.FindFirst then
                repeat
                    ReservationEntry := ReservationEntryTemp;
                    ReservationEntry."Source Ref. No." := ServiceLine."Line No.";
                    ReservationEntry.Insert;
                    ReservationEntryTemp2 := ReservationEntryTemp;
                    ReservationEntryTemp2.Insert;
                until ReservationEntryTemp.Next = 0;
            if ReservationEntryTemp2.FindFirst then
                repeat
                    if ReservationEntryTemp.Get(ReservationEntryTemp2."Entry No.", not ReservationEntryTemp2.Positive) then begin
                        ReservationEntry := ReservationEntryTemp;
                        ReservationEntry.Insert;
                    end;
                until ReservationEntryTemp2.Next = 0;
        end;
    end;


    procedure SetNotFindVehicle()
    begin
        FindCustomer := true;
        FindVehicle := true;
    end;


    procedure SPVersionAssignFilter(var ServicePackageVersionPar: Record "Service Package Version")
    var
        Vehicle: Record Vehicle;
        RecordRef1: RecordRef;
        RecordRef2: RecordRef;
        FieldRef1: FieldRef;
        FieldRef2: FieldRef;
        VFUsage1: Record "Variable Field Usage";
        VFUsage2: Record "Variable Field Usage";
        VariableField: Record "Variable Field";
    begin
        // filter standard fields
        ServicePackageVersionPar.SetFilter("Make Code", '''''|%1', "Make Code");
        ServicePackageVersionPar.SetFilter("Model Code", '''''|%1', "Model Code");
        if not Vehicle.Get("Vehicle Serial No.") then
            exit;
        ServicePackageVersionPar.SetFilter("Prod. Year From", '..%1', Vehicle."Production Year");
        ServicePackageVersionPar.SetFilter("Prod. Year To", '''''|%1..', Vehicle."Production Year");
        VFMgt.AssignFilterSPVerToVeh(Vehicle, ServicePackageVersionPar);
    end;


    procedure OnLookupVehicleRegistrationNo()
    begin
        if "Vehicle Registration No." <> '' then begin
            Vehicle.Reset;
            Vehicle.SetCurrentkey("Registration No.");
            Vehicle.SetRange("Registration No.", "Vehicle Registration No.");
            if Vehicle.FindFirst then;
            Vehicle.SetRange("Registration No.");
        end;

        if LookUpMgt.LookUpVehicleAMT(Vehicle, "Vehicle Serial No.") then
            Validate("Vehicle Serial No.", Vehicle."Serial No.");
    end;


    procedure OnLookupVIN()
    var
        Vehicle: Record Vehicle;
    begin
        if LookUpMgt.LookUpVehicleAMT(Vehicle, "Vehicle Serial No.") then
            Validate("Vehicle Serial No.", Vehicle."Serial No.");
    end;


    procedure SetCurrPlanStage(VehicleServicePlanStagePar: Record "Vehicle Service Plan Stage")
    begin
        VehicleServicePlanStageTmp_CS := VehicleServicePlanStagePar;
    end;


    procedure CreateServHeader(DocType: Integer; OrderDate: Date; PlannedServiceDate: Date; HeaderDescription: Text[250]; SelltoCustomerNo: Code[20]; BilltoCustomerNo: Code[20]; VehicleSerialNo: Code[20])
    begin
        Init;
        SetHideValidationDialog(true);
        SetNotFindVehicle;
        Validate("Document Type", DocType);
        Insert(true);
        Validate(Description, HeaderDescription);
        SetDatesSchema1(OrderDate, PlannedServiceDate, PlannedServiceDate, PlannedServiceDate);
        SetSkipVehicleChoose(true);
        Validate("Sell-to Customer No.", SelltoCustomerNo);
        Validate("Bill-to Customer No.", BilltoCustomerNo);
        Validate("Vehicle Serial No.", VehicleSerialNo);
        Modify(true);
    end;


    procedure InsertServPlanDocLink(VehicleServicePlanStage: Record "Vehicle Service Plan Stage")
    var
        ServPlanDocumentLink: Record "Service Plan Document Link";
        LineNo: Integer;
    begin
        ServPlanDocumentLink.Reset;
        ServPlanDocumentLink.SetRange("Vehicle Serial No.", VehicleServicePlanStage."Vehicle Serial No.");
        ServPlanDocumentLink.SetRange("Serv. Plan No.", VehicleServicePlanStage."Plan No.");
        ServPlanDocumentLink.SetRange("Plan Stage Recurrence", VehicleServicePlanStage.Recurrence);
        ServPlanDocumentLink.SetRange("Serv. Plan Stage Code", VehicleServicePlanStage.Code);
        if ServPlanDocumentLink.FindLast then
            LineNo := ServPlanDocumentLink."Line No." + 10000
        else
            LineNo := 10000;

        ServPlanDocumentLink.Init;
        ServPlanDocumentLink.Validate("Vehicle Serial No.", VehicleServicePlanStage."Vehicle Serial No.");
        ServPlanDocumentLink.Validate("Serv. Plan No.", VehicleServicePlanStage."Plan No.");
        ServPlanDocumentLink.Validate("Plan Stage Recurrence", VehicleServicePlanStage.Recurrence);
        ServPlanDocumentLink.Validate("Serv. Plan Stage Code", VehicleServicePlanStage.Code);
        ServPlanDocumentLink."Line No." := LineNo;
        ServPlanDocumentLink.Insert(true);
        case "Document Type" of
            "document type"::Order:
                ServPlanDocumentLink.Validate("Document Type", ServPlanDocumentLink."document type"::Order);
            "document type"::"Return Order":
                ServPlanDocumentLink.Validate("Document Type", ServPlanDocumentLink."document type"::"Return Order");
            else
                ServPlanDocumentLink.Validate("Document Type", ServPlanDocumentLink."document type"::Quote);
        end;
        ServPlanDocumentLink.Validate("Document No.", "No.");
        ServPlanDocumentLink.Modify(true);
    end;


    procedure ConfirmLoc(MessageTxt: Text[1024]; ActiveButton: Boolean; RunParStr: Text[1024]): Boolean
    begin
        // RunParStr not used for now
        if HideValidationDialog then
            exit(true)
        else
            exit(Confirm(MessageTxt, ActiveButton));
    end;


    procedure MessageLoc(MessageTxt: Text[1024]; RunParStr: Text[1024])
    begin
        // RunParStr not used for now
        if not HideValidationDialog then
            Message(MessageTxt);
    end;


    procedure ValidateShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    var
        OldDimSetID: Integer;
    begin
        // 31.03.2014 Elva Baltic P18 MMG7.00 >>
        //DimMgt.ValidateDimValueCode(FieldNumber,ShortcutDimCode);

        OldDimSetID := "Dimension Set ID";
        DimMgt.ValidateShortcutDimValues(FieldNumber, ShortcutDimCode, "Dimension Set ID");
        if "No." <> '' then
            Modify;

        if OldDimSetID <> "Dimension Set ID" then begin
            Modify;
            if ServiceLinesExist then
                UpdateAllLineDim("Dimension Set ID", OldDimSetID);
        end;

        // 31.03.2014 Elva Baltic P18 MMG7.00 <<
    end;


    procedure SetDatesSchema1(OrderDate: Date; PlanDate: Date; Date3: Date; Date4: Date)
    begin
        // it supposed to be used as default - schema agreed for Sitra case
        // "Document Date" is used as actual service date
        if OrderDate = 0D then
            OrderDate := WorkDate;
        if PlanDate = 0D then
            PlanDate := WorkDate;
        Validate("Order Date", OrderDate);
        Validate("Planned Service Date", PlanDate);
        if PlanDate < WorkDate then
            Validate("Document Date", WorkDate)
        else
            Validate("Document Date", PlanDate);
    end;


    procedure "--SERVICE RESOURCES--"()
    begin
    end;


    procedure SetResourceTextFieldValue(TextValue: Text[250])
    begin
        if not ResourceTextFieldModified then
            ResourceTextFieldModified := (ResourceTextFieldValue <> TextValue);
        ResourceTextFieldValue := TextValue;
        SaveRelatedResourcesToDB(0);
    end;


    procedure GetResourceTextFieldValue(): Text[250]
    begin
        if (ServicePrevParcedRsc."Document Type" <> "Document Type") or
            (ServicePrevParcedRsc."No." <> "No.") then begin
            ResourceTextFieldModified := false;
            ServicePrevParcedRsc.TransferFields(Rec);
            ResourceTextFieldValue := GetRelatedResourcesFromDB(0);
        end;
        exit(ResourceTextFieldValue);
    end;


    procedure GetRelatedResourcesFromDB(RunMode: Integer) RetValue: Text[250]
    var
        ServLaborApplication: Record "Serv. Labor Alloc. Application";
        ServiceLine: Record "Service Line EDMS";
        isItDocAllocation: Boolean;
        StatusArray: array[10] of Integer;
        isTempTableUse: Boolean;
    begin
        RetValue := '';
        ServLaborApplicationGlobTmp.Reset;
        ServLaborApplicationGlobTmp.DeleteAll;
        ServLaborApplication.Reset;
        ServLaborApplication.SetRange("Document Type", "Document Type");
        ServLaborApplication.SetRange("Document No.", "No.");
        ServLaborApplication.SetRange("Document Line No.", 0);
        if ServLaborApplication.FindFirst then begin
            repeat
                ServLaborApplicationGlobTmp.SetRange("Resource No.", ServLaborApplication."Resource No.");
                if not ServLaborApplicationGlobTmp.FindLast then begin
                    if (StrLen(RetValue) + StrLen(ServLaborApplication."Resource No." + ',') <= MaxStrLen(RetValue)) then
                        RetValue += ServLaborApplication."Resource No." + ',';
                    ServLaborApplicationGlobTmp.Init;
                    ServLaborApplicationGlobTmp.TransferFields(ServLaborApplication);
                    ServLaborApplicationGlobTmp.Insert;
                end;
            until ServLaborApplication.Next = 0;
            if StrLen(RetValue) > 1 then
                RetValue := CopyStr(RetValue, 1, StrLen(RetValue) - 1);
        end;
        exit(RetValue);
    end;


    procedure SetRelatedResources(RecourcesTextSource: Text[250]; RunMode: Integer) ResourcesCount: Integer
    var
        ServLaborApplication: Record "Serv. Labor Alloc. Application";
        Posit: Integer;
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        ResourceToAdd: Text[30];
        Resource: Record Resource;
        RecourcesText: Text[250];
        RecourcesTextToModify: Text[250];
        AllocEntryNo: Integer;
        isItDocAllocation: Boolean;
        divResult: Integer;
        isItAllowedMessage: Boolean;
        ServiceLine: Record "Service Line EDMS";
        StatusArray: array[10] of Integer;
        LineNo: Integer;
    begin
        //RunMode = 0 - normal; 1 - no messages; second digit (tens) - is it document allocation
        // THAT FUNCTION SAVE IT ONLY INTO TEMPORARY TABLE
        // for now it stores only resources uniquely (one certain resource - one line)
        ServiceSetup.Get;
        AdjustFlagsToArray(RunMode, StatusArray);
        isItAllowedMessage := (StatusArray[1] = 1);
        isItDocAllocation := (StatusArray[2] = 1);

        RecourcesText := RecourcesTextSource;
        ResourcesCount := 0;
        ServLaborApplicationGlobTmp.Reset;
        ServLaborApplicationGlobTmp.DeleteAll;
        repeat
            Posit := StrPos(RecourcesText, ',');
            if Posit > 0 then begin
                ResourceToAdd := CopyStr(RecourcesText, 1, Posit - 1);
                RecourcesText := CopyStr(RecourcesText, Posit + 1, StrLen(RecourcesText) - Posit);
            end else begin
                ResourceToAdd := RecourcesText;
                RecourcesText := '';
            end;
            if Resource.Get(ResourceToAdd) then begin
                ServLaborApplicationGlobTmp.SetRange("Resource No.", ResourceToAdd);
                if not ServLaborApplicationGlobTmp.FindLast then begin
                    Resource.TestField(Blocked, false);
                    LineNo := 0;
                    ServLaborApplicationGlobTmp.Reset;
                    if ServLaborApplicationGlobTmp.FindLast then
                        LineNo := ServLaborApplicationGlobTmp."Line No.";
                    ServLaborApplicationGlobTmp.Init;
                    ServLaborApplicationGlobTmp."Allocation Entry No." := 0;
                    ServLaborApplicationGlobTmp."Document Type" := "Document Type";
                    ServLaborApplicationGlobTmp."Document No." := "No.";
                    ServLaborApplicationGlobTmp."Document Line No." := 0;
                    ServLaborApplicationGlobTmp."Resource No." := ResourceToAdd;
                    ServLaborApplicationGlobTmp."Line No." := LineNo + 10000;
                    ServLaborApplicationGlobTmp.Insert;
                end;
            end;
        until RecourcesText = '';
        ServLaborApplicationGlobTmp.SetRange("Resource No.");
        exit(ServLaborApplicationGlobTmp.Count);
    end;


    procedure SaveRelatedResourcesToDB(RunMode: Integer) ResourcesCount: Integer
    var
        ServLaborApplication: Record "Serv. Labor Alloc. Application";
        ServLaborAllocationEntryLoc: Record "Serv. Labor Allocation Entry";
        ServiceScheduleMgt: Codeunit "Service Schedule Mgt.";
        Posit: Integer;
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        ResourceToAdd: Text[30];
        Resource: Record Resource;
        RecourcesTextToModify: Text[250];
        AllocEntryNo: Integer;
        isItDocAllocation: Boolean;
        divResult: Integer;
        isItAllowedMessage: Boolean;
        ServiceLine: Record "Service Line EDMS";
        isFound: Boolean;
    begin
        //RunMode = 0 - normal; 1 - no messages; second digit (tens) - is it document allocation
        ResourcesCount := 0;
        if ResourceTextFieldModified then begin

            SetRelatedResources(ResourceTextFieldValue, 0);

            ServLaborApplication.Reset;
            ServLaborApplication.SetRange("Document Type", "Document Type");
            ServLaborApplication.SetRange("Document No.", "No.");
            ServLaborApplication.SetRange("Document Line No.", 0);
            if ServLaborApplicationGlobTmp.FindFirst then begin
                repeat
                    if Resource.Get(ServLaborApplicationGlobTmp."Resource No.") then begin
                        ServLaborApplication.SetRange("Resource No.", ServLaborApplicationGlobTmp."Resource No.");
                        isFound := ServLaborApplication.FindLast;
                        if not isFound then begin
                            Resource.TestField(Blocked, false);

                            ServLaborApplication.Init;
                            ServLaborApplication."Allocation Entry No." := 0;
                            ServLaborApplication."Document Type" := "Document Type";
                            ServLaborApplication."Document No." := "No.";
                            ServLaborApplication."Document Line No." := 0;
                            ServLaborApplication."Resource No." := ServLaborApplicationGlobTmp."Resource No.";
                            ServLaborApplication.Insert(true);
                        end;
                    end;
                until ServLaborApplicationGlobTmp.Next = 0;
            end;
            ServLaborApplication.SetRange("Document Line No.", 0);
            ServLaborApplication.SetRange("Resource No.");
            ServLaborApplicationGlobTmp.Reset;
            // here get remove unneed records
            if ServLaborApplication.FindFirst then begin
                repeat
                    //Allocation Entry No.,Document Type,Document No.,Line No.
                    ServLaborApplicationGlobTmp.SetRange("Resource No.", ServLaborApplication."Resource No.");
                    if not ServLaborApplicationGlobTmp.FindLast then
                        if not ServLaborAllocationEntryLoc.Get(ServLaborApplication."Allocation Entry No.") then begin
                            ServLaborApplication.Delete(true);
                            ServLaborApplication.FindFirst;
                        end else begin
                            // MESSAGE('IT is not allowed to delete allocated records');
                        end;
                until ServLaborApplication.Next = 0;
            end;
            if ServLaborApplication.FindFirst then begin
                ServLaborApplicationGlobTmp.SetRange("Resource No.", ServLaborApplication."Resource No.");
                if not ServLaborApplicationGlobTmp.FindLast then
                    if not ServLaborAllocationEntryLoc.Get(ServLaborApplication."Allocation Entry No.") then
                        ServLaborApplication.Delete(true);
            end;

            //ServiceScheduleMgt.RemoveDuplicates(ServLaborApplication);

        end;
        Clear(ResourceTextFieldModified);
        Clear(ServicePrevParcedRsc);
        exit(ServLaborApplication.Count);
    end;


    procedure RelatedResourcesList(var RelatedResources: Text[250])
    var
        ServLaborAllocApplication: Record "Serv. Labor Alloc. Application";
    begin
        ServLaborAllocApplication.Reset;
        ServLaborAllocApplication.SetRange("Document Type", "Document Type");
        ServLaborAllocApplication.SetRange("Document No.", "No.");
        ServLaborAllocApplication.SetRange("Document Line No.", 0);
        Page.RunModal(Page::"Service Line Resources", ServLaborAllocApplication);
        RelatedResources := GetRelatedResourcesFromDB(0);
        SetResourceTextFieldValue(RelatedResources);
    end;


    procedure DeleteResourcesOfLine()
    var
        ServLaborAllocApplication: Record "Serv. Labor Alloc. Application";
    begin
        ServLaborAllocApplication.Reset;
        ServLaborAllocApplication.SetRange("Document Type", "Document Type");
        ServLaborAllocApplication.SetRange("Document No.", "No.");
        ServLaborAllocApplication.SetRange("Document Line No.", 0);
        ServLaborAllocApplication.DeleteAll(true);
    end;


    procedure "--SMALL TECHN--"()
    begin
    end;


    procedure CutNextDigit(var Flags: Integer) RetValue: Integer
    begin
        RetValue := Flags MOD 10;
        Flags := Flags DIV 10;
        exit(RetValue);
    end;


    procedure AdjustFlagsToArray(Flags: Integer; var ArrayEDMS: array[10] of Integer)
    var
        i: Integer;
    begin
        for i := 1 to 10 do begin
            if (CutNextDigit(Flags) > 0) then
                ArrayEDMS[i] := i - 1
            else
                ArrayEDMS[i] := -1;
        end;
    end;


    procedure IsIntInArrayTen(CheckValue: Integer; var ArrayEDMS: array[10] of Integer) RetValue: Boolean
    var
        i: Integer;
    begin
        for i := 1 to 10 do begin
            if (CheckValue = ArrayEDMS[i]) then
                RetValue := true;
        end;

        exit(RetValue);
    end;


    procedure LookupShortcutDimCode(FieldNumber: Integer; var ShortcutDimCode: Code[20])
    begin
        // 31.03.2014 Elva Baltic P18 MMG7.00 >>
        DimMgt.LookupDimValueCode(FieldNumber, ShortcutDimCode);
        ValidateShortcutDimCode(FieldNumber, ShortcutDimCode);
        // 31.03.2014 Elva Baltic P18 MMG7.00 <<
    end;


    procedure ServiceLinesExist(): Boolean
    begin
        // 31.03.2014 Elva Baltic P18 MMG7.00 >>
        ServLine.Reset;
        ServLine.SetRange("Document Type", "Document Type");
        ServLine.SetRange("Document No.", "No.");
        exit(ServLine.FindFirst);
        // 31.03.2014 Elva Baltic P18 MMG7.00 <<
    end;


    procedure ShowShortcutDimCode(var ShortcutDimCode: array[8] of Code[20])
    begin
        DimMgt.GetShortcutDimensions("Dimension Set ID", ShortcutDimCode);
    end;


    procedure CalcAmountIncVAT() AmountIncVAT: Decimal
    begin
        if Status = Status::Released then begin
            ServLine.Reset;
            ServLine.SetRange("Document Type", "Document Type");
            ServLine.SetRange("Document No.", "No.");
            ServLine.CalcSums("Amount Including VAT");
            exit(ServLine."Amount Including VAT");
        end else
            exit(0);
    end;


    procedure FindContract()
    var
        ContractVehicle: Record "Contract Vehicle";
        ContractTemp: Record Contract temporary;
        Customer: Record Customer;
    begin
        if ("Bill-to Customer No." = '') or ("Vehicle Serial No." = '') then
            exit;

        Customer.Get("Bill-to Customer No.");
        Customer.SetContractFilter(ContractTemp, Contract.Status::Active, false, Contract."document profile"::Service, "Order Date", "Vehicle Serial No.");

        if ContractTemp.Count = 1 then begin
            ContractTemp.FindFirst;
            if "Contract No." <> ContractTemp."Contract No." then
                Validate("Contract No.", ContractTemp."Contract No.");
        end;

        if ContractTemp.Count > 1 then begin
            Message(Text136, "Bill-to Customer No.", ContractTemp.Count);
            if ("Contract No." <> '') then
                Validate("Contract No.", '');
        end;

        if (ContractTemp.Count = 0) and ("Contract No." <> '') then
            Validate("Contract No.", '');
    end;


    procedure SetWorkDescription(NewWorkDescription: Text)
    var
        OutStream: OutStream;
    begin
        Clear("Work Description");
        "Work Description".CreateOutStream(OutStream, TEXTENCODING::UTF8);
        OutStream.WriteText(NewWorkDescription);
        Modify;
    end;



    procedure GetWorkDescription(): Text
    var
        TypeHelper: Codeunit "Type Helper";
        InStream: InStream;
    begin
        CalcFields("Work Description");
        "Work Description".CreateInStream(InStream, TEXTENCODING::UTF8);
        exit(TypeHelper.ReadAsTextWithSeparator(InStream, TypeHelper.LFSeparator));
    end;

    local procedure UpdateServiceAddressCode()
    var
        VehicleCustomer: Record Vehicle;
    begin
        if ("Vehicle Serial No." <> '') and ("Sell-to Customer No." <> '') then begin
            VehicleCustomer.Get("Vehicle Serial No.");
            if "Sell-to Customer No." = VehicleCustomer."Customer No." then
                Validate("Service Address Code", VehicleCustomer."Customer Service Address Code");
        end;
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
        "Service Address" := "Sell-to Address";
        "Service Address 2" := "Sell-to Address 2";
        "Service Address City" := "Sell-to City";
        "Service Address Contact" := "Sell-to Contact";
        "Service Address Post Code" := "Sell-to Post Code";

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

    procedure UpdateRentOrderInfo(VehicleSerialNo: Code[20])
    var
        RentAsset: Record "Rent Asset";
        RentLine: Record "Rent Line";
        RentHeader: Record "Rent Header";
    begin
        if VehicleSerialNo = '' then
            exit;
        "Rent Order No." := '';
        "Rent Customer" := '';
        RentAsset.Reset();
        RentAsset.SetRange("Vehicle Serial No.", VehicleSerialNo);
        if RentAsset.FindFirst() then
            repeat
                RentLine.Reset();
                RentLine.SetRange("Rent Asset No.", RentAsset."No.");
                RentLine.SetRange(Status, RentLine.Status::Rented);
                if RentLine.FindFirst() then begin
                    "Rent Order No." := RentLine."Document No.";
                    if RentHeader.Get(RentHeader."Document Type"::Order, RentLine."Document No.") then
                        "Rent Customer" := RentHeader."Sell-to Customer Name";
                    OnAfterRentOrderInfoUpdate(Rec, RentAsset, RentLine, RentHeader);
                    Modify();
                end;
            until (RentAsset.Next() = 0) or ("Rent Order No." <> '');
    end;
    //>>DELTA 02
    [IntegrationEvent(TRUE, false)]

    procedure OnCustomerCreditLimitExceeded()
    begin
    end;
    //<<DELTA 02

    //>>DELTA MGR
    [IntegrationEvent(false, false)]
    procedure OnBeforeCreateDimBillToCustNo(var ServHeader: Record "Service Header EDMS")
    begin
    end;

    //<<DELTA MGR

    procedure GetServiceDocTypeTxt() TypeText: Text[50]
    var
        ReportDistributionMgt: Codeunit "Report Distribution Management";
    begin
        TypeText := ReportDistributionMgt.GetFullDocumentTypeText(Rec);

    end;

    [IntegrationEvent(false, false)]
    procedure OnAfterSetFieldsContractNo(VAR ServiceHeader: Record "Service Header EDMS"; Var Contract: Record Contract; var IsHandled: boolean)
    Begin
    End;

    [IntegrationEvent(false, false)]
    procedure OnCheckVehicleCreatedOnBeforeVehicle1modify(var Vehicle: record Vehicle; VAR ServiceHeader: Record "Service Header EDMS")
    Begin
    End;

    [IntegrationEvent(false, false)]
    procedure onBeforechangeserviceAdvisor(VAR ServiceHeader: Record "Service Header EDMS"; var ishandled: boolean)
    Begin

    End;

    [IntegrationEvent(false, false)]
    local procedure OnAfterRentOrderInfoUpdate(Var Rec: Record "Service Header EDMS"; RentAsset: Record "Rent Asset"; RentLine: Record "Rent Line"; RentHeader: Record "Rent Header")
    begin
    end;
}

