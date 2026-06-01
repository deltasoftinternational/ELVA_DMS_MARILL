tableextension 25006049 "Sales Header" extends "Sales Header" //36
{
    //>>DELTA 01 RC (23/11/2021) Ajout ServiceSetup.GET  --NOT MERGE EXIST IN FUNCTION GetSalesSetup
    // 07.09.2018 EB.P30
    //   Added field:
    //     25007408 "Ordering Price Type Code"
    //   Modified trigger:
    //     OnValidate."Deal Type Code"
    //   Modified function:
    //     CreateSalesLine
    // 
    // 27.08.2018 EB.P30 EDMS
    //   Added function:
    //     UpdateVehicelInSalesLines
    //   Modified trigger:
    //     "Vehicle Serial No." - OnValidate
    // 
    // 22.08.2018 EB.P7 EDMS
    //   Field added "Document Status"
    // 
    // 02.08.2018 EB.P30 EDMS Rent
    //   Modified field "Document Profile":
    //     Added option "Rent"
    //   Added field:
    //     25006600 "Rent Order No."
    // 
    // 11.10.2017 EB.AKR BLS
    // Added Field:
    //   55010BLS Contract No.
    // 
    // 04.10.2017 EB.AKR Warranty
    //   Added fields:
    //     51240:"Initial Service Order No."
    // 
    // 02.05.2017 EB.P7
    //   Added fields:
    //     "Customer Signature Image"
    //     "Customer Signature Text"
    //     "Employee Signature Image"
    //     "Employee Signature Text"
    // 
    // 27.05.2016 EB.P30 #T086
    //   Added fields:
    //     "Phone No."
    //     "Mobile Phone No."
    //   Modified "Sell-to Contact No." OnValidate trigger
    //   Modified "Sell-to Customer No." OnValidate trigger
    // 
    // 05.05.2016 EB.P7 #T084
    //   Modified Location Code OnValidate trigger. Removed CreateDim function. (bug changing customer.)
    //   Modified CreateSalesLine
    // 
    // 02.05.2016 EB.P7 #WSH_23
    //   Modified FindContVehilce function.
    // 
    // 16.03 2016 EB.P7 Branch Setup
    //   Modified SetUserDefaultValues, Usert Profile Setup to Branch Profile Setup
    // 
    // 16.04.2015 EB.P7 #Merge
    //   CreateDimSetForPrepmtAccDefaultDim() Modified to Call CreateDim with suficient params.
    //   CreateSalesLine function modified. EDMS functionality moved to function.
    // 
    // 10.03.2015 EDMS P21
    //   Modified procedure:
    //     CreateDim
    //   Modified CreateDim calls because of added parameter
    //   Modified trigger:
    //     Location Code - OnValidate
    // 
    // 09.06.2014 Elva Baltic P8 #F0002 EDMS7.10
    //   * VIN became to Normal type.
    // 
    // 07.05.2014 Elva Baltic P8 #S0083 MMG7.00
    //   * Default values should be set at SellToCustomer. Default values must be taken only if empty!
    // 
    // 28.04.2014 Elva Baltic P8 #S0075 MMG7.00
    //   * Fix in ApplyVehMarginalVAT need not to TESTFIELD of setup.
    // 
    // 22.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified trigger:
    //     OnDelete()
    //   Added procedure:
    //     SetDontFindContract
    // 
    // 17.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified procedure:
    //     RecreateSalesLines
    //   Added code to:
    //     Contract No. - OnValidate()
    //     Contract No. - OnLookup()
    //     Bill-to Customer No. - OnValidate()
    //   Delete commented code in:
    //     Sell-to Customer No. - OnValidate()
    //   Added procedure:
    //     FindContract
    // 
    // 16.04.2014 Elva Baltic P7 #RX MMG7.00
    //   * TradeIn Function added
    // 
    // 08.04.2014 Elva Baltic P7 #RX MMG7.00
    //   * Field "Bill-to Bank Acc. No." added
    // 
    // 27.03.2014 Elva Baltic P1 #RX MMG7.00
    //   *"Deal Type Code" added to CreateDim
    // 
    // 26.03.2014 Elva Baltic P18 #F011 MMG7.00
    //   Added Code to "Vehicle Serial No. - OnValidate()"
    // 
    // 26.03.2014 Elva Baltic P18 #RX027 MMG7.00
    //   Modified Function
    //     CreateDim() - Added dimension for "Payment Method Code"
    // 
    // 26.03.2014 Elva Baltic P7 #Marginal VAT MMG7.00
    //   Modified function "ApplyVehMarginalVAT"
    // 
    // 21.03.2014 Elva Baltic P18 #RX012 MMG7.00
    //   Added field 50200 "Contract No."
    //   Added Code to
    //     Sell-to Customer No. - OnValidate()
    // 
    // 25.10.2013 EDMS P8
    //   * Added use of Vehicle default dimension
    // 11.06.2013 EDMS P8
    //   Merged with NAV2009
    // 
    // 28.02.2013 EDMS P8
    //   * FIX calculation of vehicle marginal VAT process
    // 
    // 23.01.2013 EDMS P8
    //   * small fix to update VIN in lines
    // 
    // 2012.07.31 EDMS P8
    //   * added fields: Variable Field Run 2, Variable Field Run 3
    //   * renamed field Kilometrage to 'Variable Field Run 1'
    // 
    // 09.05.2008. EDMS P2
    //   * Added code OnInsert
    // 
    // 24.09.2007. EDMS P2
    //   * Added field Kilometrage
    // 
    // 10.09.2007 EDMS P3
    //   * Added 2 functions related to PutInTakeOut functionality:TransferPutIn and TransferTakeOut

    fields
    {
        field(51240; "Initial Service Order No."; Code[20])
        {
            Caption = 'Initial Service Order No.';
        }
        field(55010; "BLS Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = Contract."Contract No.";

            trigger OnLookup()
            var
                BLSMgt: Codeunit "BLS Management";
            begin
                TestField("Bill-to Customer No.");
                "BLS Contract No." := BLSMgt.LookupActiveContract(1, "Bill-to Customer No.", "Document Date", "BLS Contract No.");
                Validate("BLS Contract No.");
            end;

            trigger OnValidate()
            var
                ContractDMS: Record Contract;
            begin
                if "BLS Contract No." <> '' then begin
                    TestField("Bill-to Customer No.");
                    begin
                        ContractDMS.Get("BLS Contract No.");
                        ContractDMS.TestField(Status, ContractDMS.Status::Active);
                        ContractDMS.TestField("Bill-to Customer No.", "Bill-to Customer No.");
                        ContractDMS.TestField("Currency Code", "Currency Code");
                        if ContractDMS."Payment Terms Code" <> '' then
                            Validate("Payment Terms Code", ContractDMS."Payment Terms Code");
                    end;
                end;
            end;
        }
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service,Rent';
            OptionMembers = " ","Spare Parts Trade","Vehicles Trade",Service,Rent;
        }
        field(25006001; "Deal Type Code"; Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";

            trigger OnValidate()
            var
                recSalesLine: Record "Sales Line";
                tcDMS001: label 'Do you want to change lines too?';
                DealType: Record "Deal Type";
            begin
                TestField(Status, Status::Open);

                recSalesLine.Reset;
                recSalesLine.SetRange("Document Type", "Document Type");
                recSalesLine.SetRange("Document No.", "No.");
                if recSalesLine.FindSet(true, false) then
                    if Confirm(tcDMS001) then
                        repeat
                            recSalesLine.Validate("Deal Type Code", "Deal Type Code");
                            recSalesLine.Modify;
                        until recSalesLine.Next = 0;


                CreateDimFromDefaultDim(Rec.FieldNo("deal type code"));
                //27.03.2014 Elva Baltic P1 #RX MMG7.00 >>
                // CreateDim(
                //       DATABASE::Customer, "Bill-to Customer No.",
                //       DATABASE::"Salesperson/Purchaser", "Salesperson Code",
                //       DATABASE::Campaign, "Campaign No.",
                //       DATABASE::"Responsibility Center", "Responsibility Center",
                //       DATABASE::"Customer Templ.", "Bill-to Customer Templ. Code");
                //27.03.2014 Elva Baltic P1 #RX MMG7.00  <<

                //07.09.2018 EB.P30 >>
                if DealType.Get("Deal Type Code") then
                    if DealType."Ordering Price Type Code" <> '' then
                        Validate("Ordering Price Type Code", DealType."Ordering Price Type Code");

                //UpdateAllLineDim(Rec."Dimension Set ID", xRec."Dimension Set ID");
                //07.09.2018 EB.P30 <<
            end;
        }
        field(25006005; "Prepmt. Bill-to Cust. Changed"; Boolean)
        {
            Caption = 'Prepmt. Bill-to Cust. Changed';
        }
        field(25006120; "Service Document No."; Code[20])
        {
            Caption = 'Service Document No.';
        }
        field(25006130; "Service Document"; Boolean)
        {
            Caption = 'Service Document';
        }
        field(25006140; "Order Creator"; Code[10])
        {
            Caption = 'Order Creator';
            Description = 'Internal';
            TableRelation = "Salesperson/Purchaser";
        }
        field(25006150; "Vehicle Status Code"; Code[20])
        {
            Caption = 'Vehicle Status Code';
            Description = 'Only For Service or Spare Parts Trade';
            TableRelation = "Vehicle Status".Code;
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
                end else
                    Message(Text131, "Vehicle Registration No.");
            end;
        }
        field(25006276; "Warranty Claim No."; Code[20])
        {
            Caption = 'Warranty Claim No.';
        }
        field(25006370; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            Description = 'Only For Service or Spare Parts Trade';
            TableRelation = Make;

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(25006371; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            Description = 'Only For Service or Spare Parts Trade';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(25006372; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            Description = 'Only For Service or Spare Parts Trade';
            TableRelation = Item."No." where("Item Type" = const("Model Version"),
                                              "Make Code" = field("Make Code"),
                                              "Model Code" = field("Model Code"));

            trigger OnLookup()
            var
                recModelVersion: Record Item;
            begin
                TestField("Make Code");
                TestField("Model Code");

                recModelVersion.Reset;
                if LookUpMgt.LookUpModelVersion(recModelVersion, "Model Version No.", "Make Code", "Model Code") then
                    Validate("Model Version No.", recModelVersion."No.")
            end;

            trigger OnValidate()
            begin
                TestField(Status, Status::Open);
            end;
        }
        field(25006377; "Quote Applicable To Date"; Date)
        {
            Caption = 'Quote Applicable To Date';
        }
        field(25006378; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            Description = 'Not for Vehicle Trade';
            TableRelation = Vehicle;

            trigger OnValidate()
            var
                Vehicle: Record Vehicle;
            begin
                //CALCFIELDS(VIN);  //09.06.2014 Elva Baltic P8 #F0002 EDMS7.10

                if "Vehicle Serial No." = '' then begin
                    VIN := '';  //09.06.2014 Elva Baltic P8 #F0002 EDMS7.10
                    "Vehicle Accounting Cycle No." := '';
                    "Vehicle Status Code" := '';
                    "Make Code" := '';
                    "Model Code" := '';
                    "Model Version No." := '';
                    "Vehicle Registration No." := '';
                    Validate("Contract No.", '');                                               // 17.04.2014 Elva Baltic P21
                end else begin
                    Vehicle.Get("Vehicle Serial No.");
                    VIN := Vehicle.VIN;  //09.06.2014 Elva Baltic P8 #F0002 EDMS7.10
                    Vehicle.CalcFields("Default Vehicle Acc. Cycle No.");
                    "Vehicle Accounting Cycle No." := Vehicle."Default Vehicle Acc. Cycle No.";
                    "Vehicle Status Code" := Vehicle."Status Code";
                    "Make Code" := Vehicle."Make Code";
                    "Model Code" := Vehicle."Model Code";
                    "Model Version No." := Vehicle."Model Version No.";
                    "Vehicle Registration No." := Vehicle."Registration No.";
                end;

                if (Rec."Sell-to Customer No." = xRec."Sell-to Customer No.") and not FindVehicle then
                    FindVehicleCont;

                UpdateVehicleContact;
                //RecreateSalesLines(FIELDCAPTION("Vehicle Serial No.")); //23.01.2013 EDMS P8
                UpdateVehicelInSalesLines;    // 27.08.2018 EDMS P30

                // 26.03.2014 Elva Baltic P18 #F011 MMG7.00 >>
                CreateDimFromDefaultDim(Rec.FieldNo("Vehicle Serial No."));
                //CreateDim(
                //      DATABASE::Customer, "Bill-to Customer No.",
                //      DATABASE::"Salesperson/Purchaser", "Salesperson Code",
                //      DATABASE::Campaign, "Campaign No.",
                //      DATABASE::"Responsibility Center", "Responsibility Center",
                //      DATABASE::"Customer Templ.", "Bill-to Customer Templ. Code");
                // 26.03.2014 Elva Baltic P18 #F011 MMG7.00 <<
            end;
        }
        field(25006379; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Description = 'Only For Service or Spare Parts Trade';
            TableRelation = "Vehicle Accounting Cycle"."No.";
        }
        field(25006390; "Vehicle Item Charge No."; Code[20])
        {
            Caption = 'Vehicle Item Charge No.';
            TableRelation = "Item Charge";
        }
        field(25006391; "Phone No."; Text[30])
        {
            Caption = 'Phone No.';
        }
        field(25006392; "Mobile Phone No."; Text[30])
        {
            Caption = 'Mobile Phone No.';
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
        field(25006600; "Rent Order No."; Code[20])
        {
            Description = 'Only for Rent';

            trigger OnLookup()
            var
                RentHeader: Record "Rent Header";
                RentOrdrNotFoundMsg: label 'Rent Order not found.';
            begin
                RentHeader.Reset;
                RentHeader.SetRange("No.", "Rent Order No.");
                if RentHeader.FindFirst then
                    Page.Run(Page::"Rent Order", RentHeader)
                else
                    Message(RentOrdrNotFoundMsg);
            end;
        }
        field(25006670; VIN; Code[20])
        {
            Caption = 'VIN';
            Description = 'Only For Service or Spare Parts Trade';
            FieldClass = Normal;
            TableRelation = Vehicle;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                Vehicle: Record Vehicle;
                VehicleCard: Page "Vehicle Card";
                Ishandled: Boolean;
            begin
                OnBeforeCreateVehicleSalesHeader(Rec, Ishandled);
                if not Ishandled then begin
                    //09.06.2014 Elva Baltic P8 #F0002 EDMS7.10
                    if VIN <> '' then begin
                        Vehicle.Reset;
                        Vehicle.SetRange(VIN, VIN);
                        if Vehicle.FindFirst then
                            "Vehicle Serial No." := Vehicle."Serial No."
                        else begin

                            //PROMPT TO CREATE NEW VEH. CARD
                            if Confirm(StrSubstNo(TextEDMS100, Vehicle.TableCaption), true) then begin
                                Vehicle.Reset;
                                Vehicle.Init;
                                Vehicle.VIN := VIN;
                                Vehicle.Insert(true);
                                VehicleCard.SetRecord(Vehicle);
                                Commit;
                                VehicleCard.RunModal;
                                //PAGE.RUN(PAGE::"Vehicle Card", Vehicle);
                                Vehicle.SetRange(VIN, VIN);
                                if Vehicle.FindFirst then
                                    "Vehicle Serial No." := Vehicle."Serial No."
                            end else
                                exit;
                        end;
                    end else
                        "Vehicle Serial No." := '';
                    Validate("Vehicle Serial No.");
                end;
            end;
        }
        field(25006680; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = Contract."Contract No.";

            trigger OnLookup()
            var
                Customer: Record Customer;
                ContractTemp: Record Contract temporary;
            begin
                if Customer.Get("Bill-to Customer No.") then;
                Customer.SetContractFilter(ContractTemp, Contract.Status::Active, false, Contract."document profile"::"Spare Parts Trade", "Order Date", '');
                if ContractTemp.Get("Contract No.") then;
                if Page.RunModal(0, ContractTemp) = Action::LookupOK then
                    Validate("Contract No.", ContractTemp."Contract No.");
            end;

            trigger OnValidate()
            begin
                if Contract.Get("Contract No.") and ("Contract No." <> xRec."Contract No.") then
                    Validate("Payment Terms Code", Contract."Payment Terms Code");

                if (xRec."Contract No." <> "Contract No.") and not (GetHideValidationDialog() or not GuiAllowed()) then
                    if Confirm(ConfirmRecrLinesOnContract, false) then
                        RecreateSalesLines(FieldCaption("Contract No."));
            end;
        }
        field(25006800; "Variable Field 25006800"; Code[20])
        {
            CaptionClass = '7,36,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookUpMgt.LookUpVariableField(VFOptions, Database::"Sales Header", FieldNo("Variable Field 25006800"),
                  "Make Code", "Variable Field 25006800") then begin
                    Validate("Variable Field 25006800", VFOptions.Code);
                end;
            end;
        }
        field(25006801; "Variable Field 25006801"; Code[20])
        {
            CaptionClass = '7,36,25006801';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookUpMgt.LookUpVariableField(VFOptions, Database::"Sales Header", FieldNo("Variable Field 25006801"),
                  "Make Code", "Variable Field 25006801") then begin
                    Validate("Variable Field 25006801", VFOptions.Code);
                end;
            end;
        }
        field(25006802; "Variable Field 25006802"; Code[20])
        {
            CaptionClass = '7,36,25006802';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookUpMgt.LookUpVariableField(VFOptions, Database::"Sales Header", FieldNo("Variable Field 25006802"),
                  "Make Code", "Variable Field 25006802") then begin
                    Validate("Variable Field 25006802", VFOptions.Code);
                end;
            end;
        }
        field(25006995; "Variable Field Run 1"; Decimal)
        {
            CaptionClass = '7,36,25006995';
        }
        field(25006996; "Variable Field Run 2"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,36,25006996';
        }
        field(25006997; "Variable Field Run 3"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,36,25006997';
        }
        field(25007407; "Document Status"; Code[20])
        {
            Caption = 'Document Status';
            TableRelation = "Document Status".Code where("Document Type" = field("Document Type"),
                                                          "Document Profile" = field("Document Profile"));
        }
        field(25007408; "Ordering Price Type Code"; Code[10])
        {
            Caption = 'Ordering Price Type Code';
            DataClassification = ToBeClassified;
            TableRelation = "Ordering Price Type";
        }
        field(25007409; "Post Purchasing Invoice"; boolean)
        {
            Caption = 'Post Purchasing Invoice';
            DataClassification = ToBeClassified;

        }
        field(25007410; "Apply To Doc Type EDMS"; option)
        {
            Caption = 'Apply To Doc Type';
            DataClassification = ToBeClassified;
            Optionmembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order",Receipt,"Transfer Receipt","Return Shipment","Sales Shipment","Return Receipt";

        }
        field(25007411; "Apply To Doc No EDMS"; Code[20])
        {
            Caption = 'Apply To Doc No';
            DataClassification = ToBeClassified;
        }
        field(25007412; "Apply To Line No EDMS"; integer)
        {
            Caption = 'Apply To Line No';
            DataClassification = ToBeClassified;


        }
        field(25007413; "Apply To Item No EDMS"; Code[20])
        {
            Caption = 'Apply To Item No';
            DataClassification = ToBeClassified;
        }
        field(25007414; "Purchase Doc No"; Code[20])
        {
            Caption = 'Purchase Doc No';
            DataClassification = ToBeClassified;
        }

        modify("Sell-to Customer No.")
        {
            trigger OnAfterValidate()
            var
                Cont: Record Contact;
            begin
                // 27.05.2016 EB.P30 >>
                if Cont.Get("Sell-to Contact No.") then begin
                    Validate("Mobile Phone No.", Cont."Mobile Phone No.");
                    Validate("Phone No.", Cont."Phone No.");
                end;
                // 27.05.2016 EB.P30 <<
            end;
        }

        modify("Bill-to Customer No.")
        {
            trigger OnAfterValidate()
            begin
                //EDMS 07.01.08
                SetUserDefaultValues;
                if (xRec."Bill-to Customer No." <> "Bill-to Customer No.") and not DontFindContract then                 // 17.04.2014 Elva Baltic P21
                    FindContract;
            end;
        }
        modify("Sell-to Contact No.")
        {
            trigger OnAfterValidate()
            var
                Cont: Record Contact;
            begin
                if "Sell-to Customer No." = '' then
                    SetUserDefaultValues;
                //EDMS1.0.00 <<

                // 27.05.2016 EB.P30 >>
                if Cont.Get("Sell-to Contact No.") then begin
                    Validate("Mobile Phone No.", Cont."Mobile Phone No.");
                    Validate("Phone No.", Cont."Phone No.");
                end;
                // 27.05.2016 EB.P30 <<
            end;
        }
    }

    keys
    {
        key(Key14; "Document Profile")
        {
        }
        key(Key15; "Service Document No.")
        {
        }
        key(Key16; "Vehicle Serial No.")
        {
        }
    }

    Var
        Contract: Record Contract;
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        SalesSetup: Record "Sales & Receivables Setup";
        VFMgt: Codeunit "Variable Field Management";
        Text125: label 'Do You want to link this vehice to contact No. %1?';
        FindVehicle: Boolean;
        FindCustomer: Boolean;
        VehicleConfirm: label 'There is a vehicle linked to this contact.\%1 %2\%3 %4\%5 %6\Do you want to apply this vehicle?';
        ContactConfirm: label 'There is a customer linked to this vehicle.\%1 %2\Do you want to apply this customer?';
        LookUpMgt: Codeunit LookUpManagement;
        Text131: label 'There is no vehicle with Registration No. %1';
        PromptProfile: Boolean;
        TextDlg001: label 'Default,Spare Parts Trade,Vehicles Trade';
        Text136: label 'Cutomer No. %1 have %2 active contracts!';
        DontFindContract: Boolean;
        TextEDMS100: label 'Do you want create the vehicle?';
        ConfirmRecrLinesOnContract: Label 'New contract could have specific prices or discounts. Would you like to regenerate sales lines? Note: you will loose any current prices on lines.';


    procedure SetUserDefaultValues()
    var
        UserSetup: Record "User Setup";
        UserProfile: Record "Branch Profile Setup";
        UserProfileMgt: Codeunit UserProfileManagement;
        PriofileID: Code[30];
    begin
        //EDMS
        UserSetup.Reset;
        if UserSetup.Get(UserId) then
            if (UserSetup."Salespers./Purch. Code" <> '') AND ("Salesperson Code" = '') then
                Validate("Salesperson Code", UserSetup."Salespers./Purch. Code");

        PriofileID := UserProfileMgt.CurrProfileID;
        if PriofileID <> '' then
            //07.05.2014 Elva Baltic P8 #S0083 MMG7.00 >>
            if UserProfile.Get(UserProfileMgt.CurrProfileID, UserProfileMgt.CurrBranchNo) then begin
                if "Location Code" = '' then
                    if UserProfile."Default Location Code" <> '' then
                        Validate("Location Code", UserProfile."Default Location Code");
                if "Deal Type Code" = '' then
                    if UserProfile."Default Deal Type Code" <> '' then
                        Validate("Deal Type Code", UserProfile."Default Deal Type Code");
                if "Payment Method Code" = '' then
                    if UserProfile."Default Payment Method" <> '' then
                        Validate("Payment Method Code", UserProfile."Default Payment Method");
                if "Shipping Agent Code" = '' then
                    if UserProfile."Default Shipping Agent Code" <> '' then
                        Validate("Shipping Agent Code", UserProfile."Default Shipping Agent Code");
            end;
        //07.05.2014 Elva Baltic P8 #S0083 MMG7.00 <<
    end;

    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::"Sales Header", intFieldNo));
    end;

    procedure FindContVehicle()
    var
        Vehicle: Record Vehicle;
        VehCount: Integer;
        Cont: Record Contact;
        VehicleContact: Record "Vehicle Contact";
    begin
        if ("Document Profile" <> "document profile"::"Spare Parts Trade") then
            exit;

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
                    if Confirm(VehicleConfirm, true, Vehicle."Make Code", Vehicle."Model Code",
                      Vehicle.FieldCaption("Registration No."), Vehicle."Registration No.",
                      Vehicle.FieldCaption(VIN), Vehicle.VIN) then
                        Validate("Vehicle Serial No.", Vehicle."Serial No.");
                end;
            else begin
                Commit;
                if not HideValidationDialog then begin
                    if LookUpMgt.LookUpVehicleAMT(Vehicle, '') then begin
                        Validate("Vehicle Serial No.", Vehicle."Serial No.");
                    end
                end else begin
                    Vehicle.FindFirst;
                    Validate("Vehicle Serial No.", Vehicle."Serial No.");
                end;
            end;
        end;
    end;

    procedure FindVehicleCont()
    var
        Vehicle: Record Vehicle;
        CustomerCount: Integer;
        Contact: Record Contact;
        VehicleContact: Record "Vehicle Contact";
        ContBusRelation: Record "Contact Business Relation";
        Customer: Record Customer;
    begin
        if ("Document Profile" <> "document profile"::"Spare Parts Trade") then
            exit;

        if "Vehicle Serial No." = '' then
            exit;

        FindCustomer := true;

        Contact.Reset;
        Customer.Reset;

        MarkVehicleContacts(Contact, "Vehicle Serial No.");
        Contact.MarkedOnly(true);
        if Contact.FindFirst then
            repeat
                ContBusRelation.SetRange("Contact No.", Contact."No.");
                if ContBusRelation.FindFirst then
                    repeat
                        if Customer.Get(ContBusRelation."No.") then
                            Customer.Mark(true);
                    until ContBusRelation.Next = 0;
            until Contact.Next = 0;
        Customer.MarkedOnly(true);

        CustomerCount := Customer.Count;

        case CustomerCount of
            0:
                begin
                    Customer.MarkedOnly(false);
                end;
            1:
                begin
                    Customer.FindFirst;
                    if Confirm(ContactConfirm, true, Customer."No.", Customer.Name) then
                        Validate("Sell-to Customer No.", Customer."No.");
                end;
            else begin
                Commit;
                if Page.RunModal(Page::"Customer List", Customer) = Action::LookupOK then
                    Validate("Sell-to Customer No.", Customer."No.");
            end;
        end;
    end;

    procedure MarkContVehicles(var Vehicle: Record Vehicle; ContNo: Code[20])
    var
        VehicleContact: Record "Vehicle Contact";
    begin
        VehicleContact.Reset;
        VehicleContact.SetCurrentkey("Contact No.");
        VehicleContact.SetRange("Contact No.", ContNo);
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


    procedure UpdateVehicleContact()
    var
        VehicleContact: Record "Vehicle Contact";
    begin
        SalesSetup.Get;
        if not SalesSetup."Offer Link Vehicle and Contact" then
            exit;

        if "Sell-to Contact No." = '' then
            exit;

        VehicleContact.Reset;
        VehicleContact.SetRange("Vehicle Serial No.", "Vehicle Serial No.");
        if VehicleContact.Count > 0 then
            exit;

        if not Confirm(StrSubstNo(Text125, "Sell-to Contact No.")) then
            exit;

        VehicleContact.Init;
        VehicleContact.Validate("Vehicle Serial No.", "Vehicle Serial No.");
        VehicleContact.Validate("Relationship Code", SalesSetup."Link Relationship Code");
        VehicleContact.Validate("Contact No.", "Sell-to Contact No.");
        VehicleContact.Insert(true);
    end;


    procedure GetPromptProfile(): Boolean
    begin
        exit(PromptProfile);
    end;

    procedure SetPromptProfile(BoolValueToSet: Boolean)
    begin
        PromptProfile := BoolValueToSet;
    end;

    procedure DefineProfileRange()
    var
        Selected: Integer;
    begin
        if GetPromptProfile then begin
            Selected := StrMenu(TextDlg001, 1);
            if Selected > 0 then begin
                "Document Profile" := Selected - 1;
                SetRange("Document Profile", "Document Profile");
            end;
        end;
    end;

    procedure FindContract()
    var
        ContractVehicle: Record "Contract Vehicle";
        ContractTemp: Record Contract temporary;
        Customer: Record Customer;
    begin
        if ("Bill-to Customer No." = '') then
            exit;

        Customer.Get("Bill-to Customer No.");
        Customer.SetContractFilter(ContractTemp, Contract.Status::Active, false, Contract."document profile"::"Spare Parts Trade", "Order Date", '');

        if ContractTemp.Count = 1 then begin
            ContractTemp.FindFirst;
            if "Contract No." <> ContractTemp."Contract No." then
                Validate("Contract No.", ContractTemp."Contract No.");
        end;

        if ContractTemp.Count > 1 then begin
            if not (GetHideValidationDialog or not GuiAllowed) then
                Message(Text136, "Bill-to Customer No.", ContractTemp.Count);
            if ("Contract No." <> '') then
                Validate("Contract No.", '');
        end;

        if (ContractTemp.Count = 0) and ("Contract No." <> '') then
            Validate("Contract No.", '');
    end;

    procedure SetDontFindContract(NewDontFindContract: Boolean)
    begin
        DontFindContract := NewDontFindContract;
    end;

    procedure OnLookupVehicleRegistrationNo()
    var
        Vehicle: Record Vehicle;
    begin
        if "Vehicle Registration No." <> '' then begin
            Vehicle.Reset;
            Vehicle.SetCurrentkey("Registration No.");
            Vehicle.SetRange("Registration No.", "Vehicle Registration No.");
            if Vehicle.FindFirst then;
            Vehicle.SetRange("Registration No.");
        end;
    end;

    local procedure UpdateVehicelInSalesLines()
    var
        SalesLineVehicle: Record "Sales Line";
    begin
        SalesLineVehicle.Reset;
        SalesLineVehicle.SetRange("Document Type", "Document Type");
        SalesLineVehicle.SetRange("Document No.", "No.");
        if SalesLineVehicle.FindSet(true, false) then
            repeat
                SalesLineVehicle.Validate("Vehicle Serial No.", "Vehicle Serial No.");
                SalesLineVehicle.Modify;
            until SalesLineVehicle.Next = 0;
    end;

    procedure GetFindCustomer(): Boolean
    begin
        exit(FindCustomer);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateVehicleSalesHeader(VAR Rec: Record "Sales Header"; var Ishandled: Boolean)
    begin
    end;


}