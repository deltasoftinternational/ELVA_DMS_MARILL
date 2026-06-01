//Table 25006005 "Vehicle"
Table 25006279 "Vehicle"
{
    // 17.10.2022 EB.KN 
    //   Modified OnValidate for "Make Code"
    //
    // 16.03.2016 EB.P7 Branch Profile Setup
    //   Modified OnInsert(), Usert Profile Setup to Branch Profile Setup
    // 
    // 21.05.2014 Elva Baltic P8 #Exxx MMG7.00
    //   * Fix in TestNoOpenEntriesExist - to check previos model Version no.
    // 
    // 22.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added to DropDown Field Group:
    //     "Registration No."
    // 
    // 11.10.2013 EDMS P8
    //   * Added check of open ledger entries
    // 
    // 05.06.2013 EDMS P15
    //    * Added Filter ["Make Code"|''] into following Lookup Pages:
    //        Field             Page
    //      - "Interior Code"   "Vehicle Interior"
    //      - "Body Color Code" "Body Color"
    // 
    // 19.06.2013 EDMS P8
    //   * Merged with NAV2009
    // 
    // 29.09.2011 EDMS P8
    //   * Implement Tire Management
    // 
    // 28.02.2008. EDMS P2
    //   * Added code Make Code - OnValidate, Model Code - OnValidate
    // 
    // 26.11.2007. EDMS P2
    //         * Changed Comment Flowfield condition
    // 
    // 16.08.2007. EDMS P2
    //   * Added code in trigger OnDelete
    // 
    // 07-08-2007 EDMS P3
    //   * Added fields "Company Contact No.","Contact Company Name","Contact Name"
    // 
    // 26.07.2007. EDMS P2
    //   * Added field "Vehicle Contact Phone No."
    // 
    // 18.07.2007. EDMS P2
    //   * Added code in trigger "Registration No." - OnValidate
    // 
    // 25.01.2007. DMS P2
    //   added new fields

    Caption = 'Vehicle';
    DataCaptionFields = "Serial No.", VIN;
    DrillDownPageID = "Vehicle List";
    LookupPageID = "Vehicle List";

    fields
    {
        field(4; "Serial No."; Code[20])
        {
            Caption = 'Serial No.';

            trigger OnValidate()
            var
                recVehicle: Record Vehicle;
                tcDMS001: label 'You can not delete value of %1 field .';
                tcDMS002: label 'Vehicle %1 %2 already exists.';
            begin
                if (Rec."Serial No." = '') and (xRec."Serial No." <> '') then
                    Error(tcDMS001, FieldCaption("Serial No."));

                if (Rec."Serial No." = '') and (xRec."Serial No." = '') then
                    exit;
            end;
        }
        field(8; VIN; Code[20])
        {
            Caption = 'VIN';
            NotBlank = true;

            trigger OnValidate()
            begin
                CheckDublicates; //Checking for dublicates
                VINDecode.Decode2(Rec);
                VehChangeLogMgt.fRegisterChange(Rec, xRec, FieldNo(VIN));
            end;
        }
        field(10; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            NotBlank = true;
            TableRelation = Make;

            trigger OnValidate()
            var
                DefDim: Record "Default Dimension";
                MakeDefDim: Record "Default Dimension";
            begin
                //28.02.2008. EDMS P2 >>
                if "Make Code" <> xRec."Make Code" then
                    Validate("Model Code", '');
                //28.02.2008. EDMS P2 >>

                // 17.10.2022 EB.KN >>
                MakeDefDim.Reset;
                MakeDefDim.SetRange("Table ID", Database::Make);
                MakeDefDim.SetRange("No.", "Make Code");
                If MakeDefDim.FindFirst then
                    repeat
                        DefDim.Reset;
                        DefDim.SetRange("Table ID", Database::Vehicle);
                        DefDim.SetRange("No.", "Serial No.");
                        DefDim.SetRange("Dimension Code", MakeDefDim."Dimension Code");
                        if DefDim.Find('-') then begin
                            DefDim."Dimension Value Code" := MakeDefDim."Dimension Value Code";
                            DefDim."Value Posting" := DefDim."value posting"::" ";
                            DefDim.Modify(true);
                        end else begin
                            DefDim.Init;
                            DefDim."Table ID" := Database::Vehicle;
                            DefDim."No." := "Serial No.";
                            DefDim."Dimension Code" := MakeDefDim."Dimension Code";
                            DefDim."Dimension Value Code" := MakeDefDim."Dimension Value Code";
                            DefDim."Value Posting" := DefDim."value posting"::" ";
                            DefDim.Insert(true);
                        end;
                    until MakeDefDim.Next = 0;
                // 17.10.2022 EB.KN <<
            end;
        }
        field(20; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));

            trigger OnValidate()
            begin
                //28.02.2008. EDMS P2 >>
                if "Model Code" <> xRec."Model Code" then
                    Validate("Model Version No.", '');
                //28.02.2008. EDMS P2 >>
            end;
        }
        field(25; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item."No." where("Make Code" = field("Make Code"),
                                              "Model Code" = field("Model Code"),
                                              "Item Type" = const("Model Version"));

            trigger OnLookup()
            var
                recItem: Record Item;
            begin
                recItem.Reset;
                if LookupMgt.LookUpModelVersion(recItem, "Model Version No.", "Make Code", "Model Code") then
                    Validate("Model Version No.", recItem."No.");
            end;

            trigger OnValidate()
            begin
                // assign var fields from 'Model Version Specification'
                if xRec."Model Version No." <> '' then
                    if "Model Version No." <> xRec."Model Version No." then
                        TestNoOpenEntriesExist(FieldCaption("Model Version No."));  //11.10.2013 EDMS P8

                FillVariableFieldsFromSpecific;
            end;
        }
        field(30; "Model Commercial Name"; Text[50])
        {
            CalcFormula = lookup(Model."Commercial Name" where("Make Code" = field("Make Code"),
                                                                Code = field("Model Code")));
            Caption = 'Model Commercial Name';
            Editable = false;
            FieldClass = FlowField;
        }
        field(46; Comment; Boolean)
        {
            CalcFormula = exist("Service Comment Line EDMS" where(Type = const(Vehicle),
                                                                   "No." = field("Serial No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50; "Production Year"; Code[4])
        {
            Caption = 'Production Year';
        }
        field(70; "Registration No."; Code[20])
        {
            Caption = 'Registration No.';

            trigger OnValidate()
            var
                VehicleLoc: Record Vehicle;
                SalesLine: Record "Sales Line";
                PurchaseHeader: Record "Purchase Header";
                PurchaseLine: Record "Purchase Line";
                GenJournalLine: Record "Gen. Journal Line";
                ItemJournalLine: Record "Item Journal Line";
                TransferLine: Record "Transfer Line";
                ServiceHeader: Record "Service Header EDMS";
            begin
                ServiceMgtSetup.Get;
                if ServiceMgtSetup."Control Veh. Reg. No. Dubl." <> ServiceMgtSetup."control veh. reg. no. dubl."::No then begin
                    if ("Registration No." <> '') and ("Registration No." <> xRec."Registration No.") then begin
                        VehicleLoc.Reset;
                        VehicleLoc.SetCurrentkey("Registration No.");
                        VehicleLoc.SetRange("Registration No.", "Registration No.");
                        if VehicleLoc.FindFirst then begin
                            if ServiceMgtSetup."Control Veh. Reg. No. Dubl." = ServiceMgtSetup."control veh. reg. no. dubl."::Warning then
                                Message(EDMS001)
                            else
                                Error(EDMS001);
                        end;
                    end;
                end;

                if "Registration No." <> xRec."Registration No." then begin
                    SalesLine.Reset;
                    SalesLine.SetRange("Vehicle Serial No.", "Serial No.");
                    SalesLine.ModifyAll("Vehicle Registration No.", "Registration No.");
                    Commit();
                    PurchaseHeader.Reset;
                    PurchaseHeader.SetRange("Vehicle Serial No.", "Serial No.");
                    PurchaseHeader.ModifyAll("Vehicle Registration No.", "Registration No.");
                    Commit();
                    PurchaseLine.Reset;
                    PurchaseLine.SetRange("Vehicle Serial No.", "Serial No.");
                    PurchaseLine.ModifyAll("Vehicle Registration No.", "Registration No.");
                    Commit();
                    GenJournalLine.Reset;
                    GenJournalLine.SetRange("Vehicle Serial No.", "Serial No.");
                    if not GenJournalLine.IsEmpty() then begin
                        GenJournalLine.ModifyAll("Vehicle Registration No.", "Registration No.");
                        Commit();
                    end;
                    ItemJournalLine.Reset;
                    ItemJournalLine.SetRange("Vehicle Serial No.", "Serial No.");
                    ItemJournalLine.ModifyAll("Vehicle Registration No.", "Registration No.");
                    Commit();
                    TransferLine.Reset;
                    TransferLine.SetRange("Vehicle Serial No.", "Serial No.");
                    if not TransferLine.IsEmpty() then begin
                        TransferLine.ModifyAll("Vehicle Registration No.", "Registration No.");
                        Commit();
                    end;
                    ServiceHeader.Reset;
                    ServiceHeader.SetRange("Vehicle Serial No.", "Serial No.");
                    ServiceHeader.ModifyAll("Vehicle Registration No.", "Registration No.");
                    Commit();
                    //Commits needed to avoid system locks
                end;

                VehChangeLogMgt.fRegisterChange(Rec, xRec, FieldNo("Registration No."))
            end;
        }
        field(150; "Status Code"; Code[20])
        {
            Caption = 'Status Code';
            TableRelation = "Vehicle Status".Code;

            trigger OnValidate()
            var
                recVehStatus: Record "Vehicle Status";
            begin
                if recVehStatus.Get("Status Code") then
                    if recVehStatus."Vehicle Status Group Code" <> '' then
                        Validate("Status Group Code", recVehStatus."Vehicle Status Group Code");

                VehChangeLogMgt.fRegisterChange(Rec, xRec, FieldNo("Status Code"));
            end;
        }
        field(154; "Status Group Code"; Code[20])
        {
            Caption = 'Vehicle Status Group Code';
            Editable = false;
            TableRelation = "Vehicle Status Group";
        }
        field(270; Blocked; Boolean)
        {
            Caption = 'Blocked';
        }
        field(280; "Last Date Modified"; Date)
        {
            Caption = 'Last Date Modified';
            Editable = false;
        }
        field(290; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
            Editable = false;
        }
        field(300; "Global Dimension 1 Code Filter"; Code[10])
        {
            Caption = 'Department Filter';
            FieldClass = FlowFilter;
        }
        field(310; "Global Dimension 2 Code Filter"; Code[10])
        {
            Caption = 'Make Filter';
            FieldClass = FlowFilter;
        }
        field(330; "Variable Field Run 1"; Decimal)
        {
            CaptionClass = '7,25006279,330';
            DecimalPlaces = 0 : 0;
        }
        field(331; "Variable Field Run 2"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006279,331';
        }
        field(332; "Variable Field Run 3"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,25006279,332';
        }
        field(340; "Sales Date"; Date)
        {
            Caption = 'Sales Date';
        }
        field(670; Inventory; Decimal)
        {
            CalcFormula = sum("Item Ledger Entry".Quantity where("Serial No." = field("Serial No."),
                                                                "Location Code" = field("Location Filter")));
            Caption = 'Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(730; Reserved; Boolean)
        {
            CalcFormula = exist("Vehicle Reservation Entry" where("Vehicle Serial No." = field("Serial No.")));
            Caption = 'Reserved';
            Editable = false;
            FieldClass = FlowField;
        }
        field(770; "Tracking Code"; Code[10])
        {
            Caption = 'Tracking Code';
            TableRelation = "Vehicle Tracking Code";

            trigger OnValidate()
            var
                recVehicleStatus: Record "Vehicle Tracking Code";
            begin
                if recVehicleStatus.Get("Tracking Code") then begin
                    "Tracking Description" := recVehicleStatus.Description;
                end
                else begin
                    "Tracking Description" := '';
                end;

                VehChangeLogMgt.fRegisterChange(Rec, xRec, FieldNo("Tracking Code"));
            end;
        }
        field(780; "Tracking Description"; Text[30])
        {
            CalcFormula = lookup("Vehicle Tracking Code".Description where(Code = field("Tracking Code")));
            Caption = 'Vehicle Tracking Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(790; "Parent Component"; Code[20])
        {
            CalcFormula = lookup("Vehicle Component"."Parent Vehicle Serial No." where("No." = field("Serial No."),
                                                                                        Active = const(true)));
            Caption = 'Parent Component';
            Editable = false;
            FieldClass = FlowField;
        }
        field(800; Components; Boolean)
        {
            CalcFormula = exist("Vehicle Component" where("Parent Vehicle Serial No." = field("Serial No."),
                                                           Active = const(true)));
            Caption = 'Components';
            Editable = false;
            FieldClass = FlowField;
        }
        field(1100; "Body Color Code"; Code[20])
        {
            Caption = 'Body Color Code';
            TableRelation = "Body Color".Code;

            trigger OnLookup()
            var
                BodyColor: Record "Body Color";
            begin
                // 05.06.2013 EDMS P15 >>
                BodyColor.SetFilter("Make Code", '%1|%2', "Make Code", '');
                if Page.RunModal(Page::"Body Colors", BodyColor) = Action::LookupOK then begin
                    "Body Color Code" := BodyColor.Code;
                end;
                //05.06.2013 EDMS P15 <<
            end;
        }
        field(1200; "Interior Code"; Code[10])
        {
            Caption = 'Interior Code';
            TableRelation = "Vehicle Interior".Code;

            trigger OnLookup()
            var
                VehicleInterior: Record "Vehicle Interior";
            begin
                // 05.06.2013 EDMS P15 >>
                VehicleInterior.SetFilter("Make Code", '%1|%2', "Make Code", '');
                if Page.RunModal(Page::"Vehicle Interiors", VehicleInterior) = Action::LookupOK then begin
                    "Interior Code" := VehicleInterior.Code;
                end;
                //05.06.2013 EDMS P15 <<
            end;
        }
        field(2000; "Type Code"; Code[20])
        {
            Caption = 'Type Code';
            TableRelation = "Vehicle Type";
        }
        field(3000; "First Registration Date"; Date)
        {
            Caption = 'First Registration Date';
        }
        field(3100; "Registration Certificate No."; Code[20])
        {
            Caption = 'Registration Certificate No.';
        }
        field(3200; "Serv. Ledger Entry Exist"; Boolean)
        {
            CalcFormula = exist("Service Ledger Entry EDMS" where("Vehicle Serial No." = field("Serial No."),
                                                                   "Posting Date" = field("Date Filter")));
            Caption = 'Serv. Ledger Entry Exist';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3300; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(3400; "Fixed Asset No."; Code[20])
        {
            Caption = 'Fixed Asset No.';
            TableRelation = "Fixed Asset"."No.";

            trigger OnValidate()
            begin
                //Reset Old fixed asset
                if FixedAsset.Get(xRec."Fixed Asset No.") then begin
                    FixedAsset."Vehicle Serial No." := '';
                    FixedAsset.Modify;
                end;
                //Set New fixed asset
                if FixedAsset.Get("Fixed Asset No.") then begin
                    FixedAsset."Vehicle Serial No." := "Serial No.";
                    FixedAsset.Modify;
                end;
            end;
        }
        field(3500; "Next Vehicle Inspection Date"; Date)
        {
            Caption = 'Next Vehicle Inspection Date';
        }
        field(3600; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(3650; "Customer Name"; Text[100])
        {
            CalcFormula = lookup(Customer.Name where("No." = field("Customer No.")));
            Caption = 'Customer Name';
            FieldClass = FlowField;
        }
        field(3700; "Customer Service Address Code"; Code[10])
        {
            Caption = 'Customer Service Address Code';
            DataClassification = ToBeClassified;
            TableRelation = "Ship-to Address".Code where("Customer No." = field("Customer No."));
        }
        field(3710; "Customer Vehicle ID"; Code[20])
        {
            Caption = 'Customer Vehicle ID';
            DataClassification = ToBeClassified;
        }
        field(3720; "Location Filter"; Code[10])
        {
            Caption = 'Location Filter';
            FieldClass = FlowFilter;
            TableRelation = Location;
        }
        field(25006379; "Default Vehicle Acc. Cycle No."; Code[20])
        {
            CalcFormula = lookup("Vehicle Accounting Cycle"."No." where("Vehicle Serial No." = field("Serial No."),
                                                                         Default = const(true)));
            Caption = 'Default Vehicle Acc. Cycle No.';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Vehicle Accounting Cycle";
        }
        field(25006800; "Variable Field 25006800"; Code[20])
        {
            CaptionClass = '7,25006279,25006800';

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
            CaptionClass = '7,25006279,25006801';

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
            CaptionClass = '7,25006279,25006802';

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
        field(25006803; "Variable Field 25006803"; Code[20])
        {
            CaptionClass = '7,25006279,25006803';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::Vehicle, FieldNo("Variable Field 25006803"),
                  "Make Code", "Variable Field 25006803") then begin
                    Validate("Variable Field 25006803", VFOptions.Code);
                end;
            end;
        }
        field(25006804; "Variable Field 25006804"; Code[20])
        {
            CaptionClass = '7,25006279,25006804';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::Vehicle, FieldNo("Variable Field 25006804"),
                  "Make Code", "Variable Field 25006804") then begin
                    Validate("Variable Field 25006804", VFOptions.Code);
                end;
            end;
        }
        field(25006805; "Variable Field 25006805"; Code[20])
        {
            CaptionClass = '7,25006279,25006805';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::Vehicle, FieldNo("Variable Field 25006805"),
                  "Make Code", "Variable Field 25006805") then begin
                    Validate("Variable Field 25006805", VFOptions.Code);
                end;
            end;
        }
        field(25006806; "Variable Field 25006806"; Code[20])
        {
            CaptionClass = '7,25006279,25006806';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::Vehicle, FieldNo("Variable Field 25006806"),
                  "Make Code", "Variable Field 25006806") then begin
                    Validate("Variable Field 25006806", VFOptions.Code);
                end;
            end;
        }
        field(25006807; "Variable Field 25006807"; Code[20])
        {
            CaptionClass = '7,25006279,25006807';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::Vehicle, FieldNo("Variable Field 25006807"),
                  "Make Code", "Variable Field 25006807") then begin
                    Validate("Variable Field 25006807", VFOptions.Code);
                end;
            end;
        }
        field(25006808; "Variable Field 25006808"; Code[20])
        {
            CaptionClass = '7,25006279,25006808';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::Vehicle, FieldNo("Variable Field 25006808"),
                  "Make Code", "Variable Field 25006808") then begin
                    Validate("Variable Field 25006808", VFOptions.Code);
                end;
            end;
        }
        field(25006809; "Variable Field 25006809"; Code[20])
        {
            CaptionClass = '7,25006279,25006809';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::Vehicle, FieldNo("Variable Field 25006809"),
                  "Make Code", "Variable Field 25006809") then begin
                    Validate("Variable Field 25006809", VFOptions.Code);
                end;
            end;
        }
        field(25006810; "Variable Field 25006810"; Code[20])
        {
            CaptionClass = '7,25006279,25006810';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::Vehicle, FieldNo("Variable Field 25006810"),
                  "Make Code", "Variable Field 25006810") then begin
                    Validate("Variable Field 25006810", VFOptions.Code);
                end;
            end;
        }
        field(25006811; "Variable Field 25006811"; Code[20])
        {
            CaptionClass = '7,25006279,25006811';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::Vehicle, FieldNo("Variable Field 25006811"),
                  "Make Code", "Variable Field 25006811") then begin
                    Validate("Variable Field 25006811", VFOptions.Code);
                end;
            end;
        }
        field(25006812; "Variable Field 25006812"; Code[20])
        {
            CaptionClass = '7,25006279,25006812';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::Vehicle, FieldNo("Variable Field 25006812"),
                  "Make Code", "Variable Field 25006812") then begin
                    Validate("Variable Field 25006812", VFOptions.Code);
                end;
            end;
        }
        field(25006813; "Variable Field 25006813"; Code[20])
        {
            CaptionClass = '7,25006279,25006813';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::Vehicle, FieldNo("Variable Field 25006813"),
                  "Make Code", "Variable Field 25006813") then begin
                    Validate("Variable Field 25006813", VFOptions.Code);
                end;
            end;
        }
        field(25006814; "Variable Field 25006814"; Code[20])
        {
            CaptionClass = '7,25006279,25006814';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::Vehicle, FieldNo("Variable Field 25006814"),
                  "Make Code", "Variable Field 25006814") then begin
                    Validate("Variable Field 25006814", VFOptions.Code);
                end;
            end;
        }
        field(25006815; "Variable Field 25006815"; Code[20])
        {
            CaptionClass = '7,25006279,25006815';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::Vehicle, FieldNo("Variable Field 25006815"),
                  "Make Code", "Variable Field 25006815") then begin
                    Validate("Variable Field 25006815", VFOptions.Code);
                end;
            end;
        }
        field(25006816; "Variable Field 25006816"; Code[20])
        {
            CaptionClass = '7,25006279,25006816';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::Vehicle, FieldNo("Variable Field 25006816"),
                  "Make Code", "Variable Field 25006816") then begin
                    Validate("Variable Field 25006816", VFOptions.Code);
                end;
            end;
        }
        field(25006817; "Variable Field 25006817"; Code[20])
        {
            CaptionClass = '7,25006279,25006817';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::Vehicle, FieldNo("Variable Field 25006817"),
                  "Make Code", "Variable Field 25006817") then begin
                    Validate("Variable Field 25006817", VFOptions.Code);
                end;
            end;
        }
        field(25006818; "Variable Field 25006818"; Code[20])
        {
            CaptionClass = '7,25006279,25006818';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::Vehicle, FieldNo("Variable Field 25006818"),
                  "Make Code", "Variable Field 25006818") then begin
                    Validate("Variable Field 25006818", VFOptions.Code);
                end;
            end;
        }
        field(25006819; "Variable Field 25006819"; Code[20])
        {
            CaptionClass = '7,25006279,25006819';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::Vehicle, FieldNo("Variable Field 25006819"),
                  "Make Code", "Variable Field 25006819") then begin
                    Validate("Variable Field 25006819", VFOptions.Code);
                end;
            end;
        }
        field(25006820; "Variable Field 25006820"; Code[20])
        {
            CaptionClass = '7,25006279,25006820';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::Vehicle, FieldNo("Variable Field 25006820"),
                  "Make Code", "Variable Field 25006820") then begin
                    Validate("Variable Field 25006820", VFOptions.Code);
                end;
            end;
        }
        field(25006821; "Variable Field 25006821"; Code[20])
        {
            CaptionClass = '7,25006279,25006821';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::Vehicle, FieldNo("Variable Field 25006821"),
                  "Make Code", "Variable Field 25006821") then begin
                    Validate("Variable Field 25006821", VFOptions.Code);
                end;
            end;
        }
        field(25006822; "Variable Field 25006822"; Code[20])
        {
            CaptionClass = '7,25006279,25006822';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::Vehicle, FieldNo("Variable Field 25006822"),
                  "Make Code", "Variable Field 25006822") then begin
                    Validate("Variable Field 25006822", VFOptions.Code);
                end;
            end;
        }
        field(25006823; "Variable Field 25006823"; Code[20])
        {
            CaptionClass = '7,25006279,25006823';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::Vehicle, FieldNo("Variable Field 25006823"),
                  "Make Code", "Variable Field 25006823") then begin
                    Validate("Variable Field 25006823", VFOptions.Code);
                end;
            end;
        }
        field(25006824; "Variable Field 25006824"; Code[20])
        {
            CaptionClass = '7,25006279,25006824';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::Vehicle, FieldNo("Variable Field 25006824"),
                  "Make Code", "Variable Field 25006824") then begin
                    Validate("Variable Field 25006824", VFOptions.Code);
                end;
            end;
        }
        field(25006825; "Variable Field 25006825"; Code[20])
        {
            CaptionClass = '7,25006279,25006825';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::Vehicle, FieldNo("Variable Field 25006825"),
                  "Make Code", "Variable Field 25006825") then begin
                    Validate("Variable Field 25006825", VFOptions.Code);
                end;
            end;
        }
        field(25006830; "Bill-To Customer No."; Code[20])
        {
            Caption = 'Bill-To Customer No.';
            DataClassification = ToBeClassified;
            TableRelation = Customer;
        }
        field(25006840; "Bill-To Customer Name"; Text[100])
        {
            CalcFormula = lookup(Customer.Name where("No." = field("Bill-To Customer No.")));
            Caption = 'Bill-To Customer Name';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Serial No.")
        {
            Clustered = true;
        }
        key(Key2; "Make Code", "Model Code", "Model Version No.", "Status Group Code")
        {
        }
        key(Key3; "Registration No.")
        {
        }
        key(Key4; VIN)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Serial No.", VIN, "Make Code", "Model Code", "Registration No.")
        {
        }
    }

    trigger OnDelete()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        SalesLine: Record "Sales Line";
        PurchLine: Record "Purchase Line";
        ServiceHdr: Record "Service Header EDMS";
        ServiceLedgerEntry: Record "Service Ledger Entry EDMS";
        SalesHeader: Record "Sales Header";
    begin
        //ERROR(tcSER002);

        //16.08.2007. EDMS P2 >>
        ItemLedgerEntry.Reset;
        ItemLedgerEntry.SetCurrentkey("Serial No.");
        ItemLedgerEntry.SetRange("Serial No.", "Serial No.");
        if ItemLedgerEntry.FindFirst then
            Error(StrSubstNo(EDMS002, VIN));

        SalesLine.Reset;
        SalesLine.SetCurrentkey(Type, "Line Type", "Vehicle Serial No.");
        SalesLine.SetRange("Vehicle Serial No.", "Serial No.");
        if SalesLine.FindFirst then
            Error(StrSubstNo(EDMS003, VIN));

        PurchLine.Reset;
        PurchLine.SetCurrentkey(Type, "Line Type", "Vehicle Serial No.");
        PurchLine.SetRange("Vehicle Serial No.", "Serial No.");
        if PurchLine.FindFirst then
            Error(StrSubstNo(EDMS004, VIN));

        ServiceHdr.Reset;
        ServiceHdr.SetCurrentkey("Vehicle Serial No.");
        ServiceHdr.SetRange("Vehicle Serial No.", "Serial No.");
        if ServiceHdr.FindFirst then
            Error(StrSubstNo(EDMS005, VIN));
        //16.08.2007. EDMS P2 <<

        ServiceLedgerEntry.Reset;
        ServiceLedgerEntry.SetCurrentkey("Vehicle Serial No.", "Posting Date", "Entry Type");
        ServiceLedgerEntry.SetRange("Vehicle Serial No.", "Serial No.");
        if ServiceLedgerEntry.FindFirst then
            Error(StrSubstNo(EDMS006, VIN));

        SalesHeader.Reset;
        SalesHeader.SetCurrentkey("Vehicle Serial No.");
        SalesHeader.SetRange("Vehicle Serial No.", "Serial No.");
        if SalesHeader.FindFirst then
            Error(StrSubstNo(EDMS007, VIN));
    end;

    trigger OnInsert()
    begin
        if "Serial No." = '' then begin
            AssignSerialNo;
            NewAccCycleNo;
        end;

        if UserProfileMgt.CurrProfileID <> '' then begin
            if UserProfile.Get(UserProfileMgt.CurrProfileID, UserProfileMgt.CurrBranchNo) then begin
                if "Make Code" = '' then begin
                    if UserProfile."Default Make Code" <> '' then
                        Validate("Make Code", UserProfile."Default Make Code");
                end;
                if "Status Code" = '' then begin
                    if UserProfile."Default Vehicle Status" <> '' then
                        Validate("Status Code", UserProfile."Default Vehicle Status");
                end;

            end;
        end;

        "Creation Date" := Today;
        // 29.09.2011 EDMS P8 >>
        TireManagement.GetVehicleAxleToEntry("Serial No.", '');
        // 29.09.2011 EDMS P8 <<
    end;

    trigger OnModify()
    begin
        "Last Date Modified" := Today;
        // 29.09.2011 EDMS P8 >>
        TireManagement.GetVehicleAxleToEntry("Serial No.", '');
        // 29.09.2011 EDMS P8 <<
    end;

    trigger OnRename()
    begin
        "Last Date Modified" := Today;
    end;

    var
        Model: Record Model;
        Customer: Record Customer;
        VINDecode: Record "VIN Decoding";
        SingleInstanceMgt: Codeunit SingleInstanceManagement;
        UserProfile: Record "Branch Profile Setup";
        tcSER002: label 'Can''t delete vehicle, it can only be replaced.';
        InventorySetup: Record "Inventory Setup";
        tcDMS001: label 'VIN should be %1 char. long.';
        tcDMS002: label 'VIN must not include ''%1'' char.';
        VehChangeLogMgt: Codeunit "Vehicle Change Log Mgt.";
        LookupMgt: Codeunit LookUpManagement;
        VFMgt: Codeunit "Variable Field Management";
        EDMS001: label 'Registration No. already exist to other vehicle.';
        Cont: Record Contact;
        EDMS002: label 'Vehicle %1 exist item ledger entries.';
        EDMS003: label 'Vehicle %1 exist Sales documents.';
        EDMS004: label 'Vehicle %1 exist Purchase documents.';
        EDMS005: label 'Vehicle %1 exist Service documents.';
        EDMS006: label 'Vehicle %1 exist Service ledger entries.';
        EDMS007: label 'Vehicle %1 exist Sales documents.';
        Text102: label 'Order Nr. %1: ';
        LicensePermission: Record "License Permission";
        UserSetup: Record "User Setup";
        Salesperson: Record "Salesperson/Purchaser";
        TireManagement: Codeunit "Tire Management";
        Text019: label 'You cannot change %1 because there are one or more open ledger entries for this item.';
        FixedAsset: Record "Fixed Asset";
        ServiceMgtSetup: Record "Service Mgt. Setup EDMS";
        UserProfileMgt: Codeunit UserProfileManagement;
        HideMsg: boolean;


    procedure AssignSerialNo()
    var
        cuNoSeriesMgt: Codeunit "No. Series";
        recPurchaseLine: Record "Purchase Line";
        codSerialNos: Code[20];
        codNewSerialNo: Code[20];
        tcDMS001: label '%1 is set already.';
    begin
        if "Serial No." <> '' then
            Error(tcDMS001, FieldCaption("Serial No."));

        InventorySetup.Get;
        InventorySetup.TestField("Vehicle Serial No. Nos.");
        codSerialNos := InventorySetup."Vehicle Serial No. Nos.";
        Validate("Serial No.", cuNoSeriesMgt.GetNextNo(InventorySetup."Vehicle Serial No. Nos.", WorkDate(), true));
    end;


    procedure IsVFActive(FieldNo: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::Vehicle, FieldNo));
    end;


    procedure CheckDublicates()
    var
        recVehicle: Record Vehicle;
        tcDMS001: label 'VIN %1 already exists.';
    begin
        if VIN = '' then
            exit;
        recVehicle.Reset;
        recVehicle.SetCurrentkey(VIN);
        recVehicle.SetRange(VIN, VIN);
        recVehicle.SetFilter("Serial No.", '<>%1', "Serial No.");
        if recVehicle.FindFirst then
            Error(tcDMS001, VIN);
    end;


    procedure NewAccCycleNo()
    var
        CycleNo: Code[20];
        cuVehAccCycle: Codeunit VehicleAccountingCycleMgt;
        VehAccCycle: Record "Vehicle Accounting Cycle";
        ApprAllowed: Boolean;
    begin
        //LicensePermission.SetRange("Object Type", LicensePermission."object type"::Codeunit);
        //LicensePermission.SetRange("Object Number", Codeunit::VehicleAccountingCycleMgt);
        //LicensePermission.SetFilter("Execute Permission", '<>%1', LicensePermission."execute permission"::" ");

        //ApprAllowed := not LicensePermission.IsEmpty;

        //if ApprAllowed then begin

        //EDMS
        if "Serial No." = '' then
            exit;

        CycleNo := cuVehAccCycle.GetNewCycleNo;

        VehAccCycle.Init;
        VehAccCycle."No." := CycleNo;
        VehAccCycle.Validate("Vehicle Serial No.", "Serial No.");
        VehAccCycle.Validate(Default, true);
        VehAccCycle.Insert(true);
        //end;
    end;


    procedure GetAssemblyDescr(var SerialNo: Code[20]) Res: Text[1024]
    var
        VehAssembly: Record "Vehicle Assembly Line";
        Veh2: Record Vehicle;
        VehOptLedger: Record "Vehicle Opt. Ledger Entry";
        PurchLine: Record "Purchase Line";
    begin
        if Veh2.Get(SerialNo) then begin
            VehOptLedger.SetCurrentkey("Vehicle Serial No.");
            VehOptLedger.SetRange("Vehicle Serial No.", Veh2."Serial No.");
            VehOptLedger.SetRange(Open, true);
            if VehOptLedger.FindSet then
                repeat
                    if Res = '' then
                        Res := VehOptLedger."Option Code"
                    else
                        Res := Res + ' ' + VehOptLedger."Option Code"
                until VehOptLedger.Next = 0
        end else begin
            PurchLine.SetCurrentkey("Vehicle Serial No.", "Vehicle Assembly ID");
            PurchLine.SetRange("Vehicle Serial No.", SerialNo);
            PurchLine.SetRange("Document Type", PurchLine."document type"::Order);
            PurchLine.SetFilter("Vehicle Assembly ID", '<>''''');
            if PurchLine.FindSet then
                repeat
                    VehAssembly.SetRange("Serial No.", SerialNo);
                    VehAssembly.SetRange("Assembly ID", PurchLine."Vehicle Assembly ID");
                    if VehAssembly.FindSet then begin
                        repeat
                            if Res = '' then
                                Res := StrSubstNo(Text102, PurchLine."Document No.") + VehOptLedger."Option Code"
                            else
                                Res := Res + ' ' + VehOptLedger."Option Code"
                        until VehAssembly.Next = 0;
                        exit
                    end;
                until PurchLine.Next = 0;
        end
    end;


    procedure GetLocation() LocationCode: Code[10]
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        ItemLedgerEntry.SetCurrentkey("Item No.", Open, "Variant Code", "Location Code", "Item Tracking", "Lot No.", "Serial No.");
        ItemLedgerEntry.SetRange("Serial No.", "Serial No.");
        ItemLedgerEntry.SetRange(Open, true);
        if ItemLedgerEntry.FindFirst then
            LocationCode := ItemLedgerEntry."Location Code";
        exit(LocationCode);
    end;


    procedure GetCurrentPrice() CurrPrice: Decimal
    var
        SalesPrice: Record "Sales Price";
        Item: Record Item;
    begin
        SalesPrice.SetRange("Item No.", "Model Version No.");
        SalesPrice.SetRange("Make Code", "Make Code");
        SalesPrice.SetRange("Model Code", "Model Code");
        SalesPrice.SetRange("Vehicle Serial No.", "Serial No.");
        SalesPrice.SetRange("Document Profile", SalesPrice."document profile"::"Vehicles Trade");
        SalesPrice.SetRange("Sales Type", SalesPrice."sales type"::"All Customers");
        SalesPrice.SetFilter("Starting Date", '<=%1', WorkDate);
        SalesPrice.SetFilter("Ending Date", '''''|>=%1', WorkDate);
        if SalesPrice.FindLast then begin
            CurrPrice := SalesPrice."Unit Price";
        end else begin
            SalesPrice.SetRange("Vehicle Serial No.", '');
            if SalesPrice.FindLast then
                CurrPrice := SalesPrice."Unit Price"
            else
                if Item.Get("Model Version No.") then
                    CurrPrice := Item."Unit Price";
        end;
    end;


    procedure ShowVehReservationEntries(Modal: Boolean)
    var
        VehReservEngineMgt: Codeunit "Veh. Reservation Engine Mgt.";
        VehReserveSalesLine: Codeunit "Sales Line-Veh. Reserve";
        VehReservEntry: Record "Vehicle Reservation Entry";
    begin
        VehReservEngineMgt.InitFilterAndSortingLookupFor(VehReservEntry);
        VehReservEntry.SetRange("Vehicle Serial No.", "Serial No.");
        if Modal then
            Page.RunModal(Page::"Vehicle Reservation Entries", VehReservEntry)
        else
            Page.Run(Page::"Vehicle Reservation Entries", VehReservEntry);
    end;


    procedure CreateInteraction()
    var
        SegmentLine: Record "Segment Line" temporary;
        UserSetup: Record "User Setup";
        PurchSlsPer: Record "Salesperson/Purchaser";
    begin
        SegmentLine.CreateInteractionFromVehicle(Rec);
    end;


    procedure ShowSalesOrders()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        SalesHeader.Reset;
        SalesHeader.SetCurrentkey("Document Profile");
        SalesHeader.SetRange("Document Profile", SalesHeader."document profile"::"Vehicles Trade");

        SalesLine.Reset;
        SalesLine.SetCurrentkey(Type, "Line Type", "Vehicle Serial No.");
        SalesLine.SetRange("Line Type", SalesLine."line type"::Vehicle);
        SalesLine.SetRange("Vehicle Serial No.", "Serial No.");
        SalesLine.SetRange("Document Type", SalesLine."document type"::Order);
        if SalesLine.FindFirst then
            repeat
                if SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then
                    SalesHeader.Mark := true;
            until SalesLine.Next = 0;

        SalesHeader.MarkedOnly(true);
        if SalesHeader.Count = 1 then begin
            if Page.RunModal(Page::"Sales Order", SalesHeader) = Action::None then;
        end else begin
            if Page.RunModal(Page::"Sales Order List", SalesHeader) = Action::None then;
        end;
    end;


    procedure ShowSalesReturnOrders()
    var
        SalesHeader: Record "Sales Header";
        SalesLine: Record "Sales Line";
    begin
        SalesHeader.Reset;
        SalesHeader.SetCurrentkey("Document Profile");
        SalesHeader.SetRange("Document Profile", SalesHeader."document profile"::"Vehicles Trade");

        SalesLine.Reset;
        SalesLine.SetCurrentkey(Type, "Line Type", "Vehicle Serial No.");
        SalesLine.SetRange("Line Type", SalesLine."line type"::Vehicle);
        SalesLine.SetRange("Vehicle Serial No.", "Serial No.");
        SalesLine.SetRange("Document Type", SalesLine."document type"::"Return Order");
        if SalesLine.FindFirst then
            repeat
                if SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.") then
                    SalesHeader.Mark := true;
            until SalesLine.Next = 0;

        SalesHeader.MarkedOnly(true);
        if SalesHeader.Count = 1 then begin
            if Page.RunModal(Page::"Sales Return Order", SalesHeader) = Action::None then;
        end else begin
            if Page.RunModal(Page::"Sales Return Order List", SalesHeader) = Action::None then;
        end;
    end;


    procedure ShowPurchOrders()
    var
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
    begin
        PurchHeader.Reset;
        PurchHeader.SetCurrentkey("Document Profile");
        PurchHeader.SetRange("Document Profile", PurchHeader."document profile"::"Vehicles Trade");

        PurchLine.Reset;
        PurchLine.SetCurrentkey(Type, "Line Type", "Vehicle Serial No.");
        PurchLine.SetRange("Line Type", PurchLine."line type"::Vehicle);
        PurchLine.SetRange("Vehicle Serial No.", "Serial No.");
        PurchLine.SetRange("Document Type", PurchLine."document type"::Order);
        if PurchLine.FindFirst then
            repeat
                if PurchHeader.Get(PurchLine."Document Type", PurchLine."Document No.") then
                    PurchHeader.Mark := true;
            until PurchLine.Next = 0;

        PurchHeader.MarkedOnly(true);
        if PurchHeader.Count = 1 then begin
            if Page.RunModal(Page::"Purchase Order", PurchHeader) = Action::None then;
        end else begin
            if Page.RunModal(Page::"Purchase Order List", PurchHeader) = Action::None then;
        end;
    end;


    procedure ShowPurchReturnOrders()
    var
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
    begin
        PurchHeader.Reset;
        PurchHeader.SetCurrentkey("Document Profile");
        PurchHeader.SetRange("Document Profile", PurchHeader."document profile"::"Vehicles Trade");

        PurchLine.Reset;
        PurchLine.SetCurrentkey(Type, "Line Type", "Vehicle Serial No.");
        PurchLine.SetRange("Line Type", PurchLine."line type"::Vehicle);
        PurchLine.SetRange("Vehicle Serial No.", "Serial No.");
        PurchLine.SetRange("Document Type", PurchLine."document type"::"Return Order");
        if PurchLine.FindFirst then
            repeat
                if PurchHeader.Get(PurchLine."Document Type", PurchLine."Document No.") then
                    PurchHeader.Mark := true;
            until PurchLine.Next = 0;

        PurchHeader.MarkedOnly(true);
        if PurchHeader.Count = 1 then begin
            if Page.RunModal(Page::"Purchase Return Order", PurchHeader) = Action::None then;
        end else begin
            if Page.RunModal(Page::"Purchase Return Order List", PurchHeader) = Action::None then;
        end;
    end;


    procedure ShowServOrders()
    var
        ServiceHeader: Record "Service Header EDMS";
    begin
        ServiceHeader.Reset;
        ServiceHeader.SetCurrentkey("Vehicle Serial No.");
        ServiceHeader.SetRange("Vehicle Serial No.", "Serial No.");
        ServiceHeader.SetRange("Document Type", ServiceHeader."document type"::Order);

        if ServiceHeader.Count = 1 then begin
            if Page.RunModal(Page::"Service Order EDMS", ServiceHeader) = Action::None then;
        end else begin
            if Page.RunModal(Page::"Service Orders EDMS", ServiceHeader) = Action::None then;
        end;
    end;


    procedure ShowServReturnOrders()
    var
        ServiceHeader: Record "Service Header EDMS";
    begin
        ServiceHeader.Reset;
        ServiceHeader.SetCurrentkey("Vehicle Serial No.");
        ServiceHeader.SetRange("Vehicle Serial No.", "Serial No.");
        ServiceHeader.SetRange("Document Type", ServiceHeader."document type"::"Return Order");

        if ServiceHeader.Count = 1 then begin
            if Page.RunModal(Page::"Service Return Order EDMS", ServiceHeader) = Action::None then;
        end else begin
            if Page.RunModal(Page::"Service Return Orders EDMS", ServiceHeader) = Action::None then;
        end;
    end;


    procedure FillVariableFieldsFromSpecific()
    var
        VariableFieldUsage: Record "Variable Field Usage";
        VariableFieldUsage2: Record "Variable Field Usage";
        RecordRef: RecordRef;
        RecordRef2: RecordRef;
        FieldRef: FieldRef;
        FieldRef2: FieldRef;
        ModelVersionSpecification: Record "Model Version Specification";
    begin
        if not ModelVersionSpecification.Get("Make Code", "Model Code", "Model Version No.") then
            exit;
        RecordRef.Open(Database::"Model Version Specification");
        RecordRef.GetTable(ModelVersionSpecification);
        RecordRef2.Open(Database::Vehicle);
        RecordRef2.GetTable(Rec);

        VariableFieldUsage.Reset;
        VariableFieldUsage.SetRange("Table No.", Database::"Model Version Specification");
        if VariableFieldUsage.FindFirst then
            repeat
                VariableFieldUsage2.Reset;
                VariableFieldUsage2.SetRange("Table No.", Database::Vehicle);
                VariableFieldUsage2.SetRange("Variable Field Code", VariableFieldUsage."Variable Field Code");
                if VariableFieldUsage2.FindFirst then begin
                    FieldRef := RecordRef.Field(VariableFieldUsage."Field No.");
                    FieldRef2 := RecordRef2.Field(VariableFieldUsage2."Field No.");
                    FieldRef2.Value(FieldRef.Value);
                end;
            until VariableFieldUsage.Next = 0;
        RecordRef2.SetTable(Rec);
    end;


    procedure GetCaptionClass(FldNo: Integer): Text[80]
    begin
        exit('7,25006279,' + Format(FldNo));
    end;


    procedure TestNoOpenEntriesExist(CurrentFieldName: Text[100])
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        //21.05.2014 Elva Baltic P8 #Exxx MMG7.00 >>
        //ItemLedgEntry.SETCURRENTKEY("Item No.",Open);
        ItemLedgEntry.SetRange("Item No.", xRec."Model Version No.");
        ItemLedgEntry.SetRange("Serial No.", "Serial No.");
        //21.05.2014 Elva Baltic P8 #Exxx MMG7.00 <<
        ItemLedgEntry.SetRange(Open, true);
        if not ItemLedgEntry.IsEmpty then
            Error(
              Text019,
              CurrentFieldName);
    end;

    Procedure fHideMsg(pHideMsg: Boolean)
    begin
        HideMsg := pHideMsg;
    end;

    Procedure fgetHideMsg(): Boolean
    begin
        EXIT(HideMsg);
    end;


}

