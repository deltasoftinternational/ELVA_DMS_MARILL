tableextension 25006011 "Purchase Line" extends "Purchase Line" //39
{
    // 21/05/2018 GH P30
    //   Added function CopyFromExternalService
    //   Modified trigger No. - OnValidate
    // 
    // 06.10.2016 EB.P7 #PAR28
    //   Modified Trigger Quantity OnValidate
    // 
    // 07.06.2016 EB.P30 EDMS
    //   Added Key:
    //     "Document Type,Document No.,Shipment Package No."
    // 
    // 30.05.2016 EB.P7 #PAR28
    //   Added field:
    //     25006998Has Replacement
    // 
    // 20.05.2016 EB.P30 EDMS
    //   Added field:
    //     " Shipment Package No."
    // 
    // 12.04.2016 EB.P7 field 90 trigger fix
    //   Field trigger reverted to standard.
    // 
    // 16.03.2016 EB.P7 Branch Setup
    //   Modified No.-OnValidate, Usert Profile Setup to Branch Profile Setup
    // 
    // 12.06.2015 EB.P30 #T042
    //   Modified function:
    //     CreateDim
    //   Modified CreateDim calls because of added parameter
    //   Modified trigger:
    //     Dela Type - OnValidate
    // 
    // 15.04.2015 EB.P7 #Merge
    //   Modified UpdatePrepmtSetupFields() merged with edms functionality.
    // 
    // 10.03.2015 EDMS P21
    //   Modified procedure:
    //     CreateDim
    //   Modified CreateDim calls because of added parameter
    //   Modified trigger:
    //     Location Code - OnValidate
    // 
    // 29.04.2014 Elva Baltic P8 #F037 MMG7.00
    //   * Use of Def. Status from profile
    // 
    // 04.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added code to:
    //     No. - OnValidate()
    // 
    // 02.04.2014 Elva Baltic P15 #F124 MMG7.00
    //   * Added Replacement Creation in case of changed "No."(OnModify trigger)
    // 
    // 28.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added function:
    //     GetReservForInfo
    // 
    // 26.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added field:
    //     50020 Item No. Changed
    //   Added code to:
    //     No. - OnValidate()
    // 
    // 26.03.2014 Elva Baltic P18 #F011 #MMG7.00
    //   Added Code To "Vehicle Serial No. - OnValidate()"
    // 
    // 12.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Changed "Planning Flexibility" field InitValue property to None
    // 
    // 25.10.2013 EDMS P8
    //   * Added use of Vehicle default dimension
    // 
    // 18.01.2013 EDMS P8
    //   * Added fields: Special Order Service No., Special Order Service Line No.
    // 
    // 08.01.2013 EDMS P8
    //   * VALIDATION OF quantity
    // 
    // 16.11.2011 EDMS P8
    //   * add function UpdateDatesEDMS
    // 
    // 01.09.2008. EDMS P2
    //   * Added field "Link Trade-In Entry"
    // 
    // 20.08.2008. EDMS P2
    //   * Added code fNoAssistEdit
    // 
    // 18.06.2008. EDMS P2
    //   * Changed field "Vehicle Body Color Code" Table Relation property
    //   * Added code Vehicle Serial No. - OnValidate
    // 
    // 09.05.2008. EDMS P2
    //   * Added code Quantity - OnValidate (check for Vehicle qty not more than 1)
    // 
    // 07.05.2008. EDMS P2
    //   * Delete code No. - OnLookup
    //        //EDMS1.0.00 >>
    //        fNoLookup;
    //        //EDMS1.0.00 <<
    // 
    // 28.12.2007 EDMS P5
    //         * Changed property "OptionString" for field "Type"
    //           from " ,G/L Account,Item,,Fixed Asset,Charge (Item)"
    //           to   " ,G/L Account,Item,,Fixed Asset,Charge (Item),,External Service"
    // 
    //         * Changed property "TableRelation" for field "No."
    //           from "IF (Type=CONST(" ")) "Standard Text"
    //                 ELSE IF (Type=CONST(G/L Account)) "G/L Account"
    //                 ELSE IF (Type=CONST(Item)) Item
    //                 ELSE IF (Type=CONST(3)) Resource
    //                 ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset"
    //                 ELSE IF (Type=CONST("Charge (Item)")) "Item Charge"
    //           to "IF (Type=CONST(" ")) "Standard Text"
    //               ELSE IF (Type=CONST(G/L Account)) "G/L Account"
    //               ELSE IF (Type=CONST(Item)) Item
    //               ELSE IF (Type=CONST(3)) Resource
    //               ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset"
    //               ELSE IF (Type=CONST("Charge (Item)")) "Item Charge"
    //               ELSE IF (Type=CONST(External Service)) "External Service EDMS""
    // 
    //         * Added code to OnValidate trigger of "No." field
    // 
    //         * Added new field
    //           25006130 "Ext. Service Tracking No."
    // 
    // 26.09.2007. EDMS P2
    //   * Added field Qty. on Back Order
    // 
    // 20.07.2007. EDMS P2
    //   * Added new key "Order Date"
    fields
    {
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = " ","Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006001; "Deal Type Code"; Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";

            trigger OnValidate()
            begin
                TestStatusOpen;
                //12.06.2015 EB.P30 >>
                /*      CreateDim(
                        DimMgt.TypeToTableID3(Type.AsInteger()), "No.",
                        Database::"Vehicle Status", "Vehicle Status Code", //DMS
                        Database::"Responsibility Center", "Responsibility Center",
                        Database::"Work Center", "Work Center No."
                        ); //DMS */
                CreateDimFromDefaultDim(Rec.FieldNo("Deal Type code"));
                //12.06.2015 EB.P30 <<
            end;
        }
        field(25006006; "Vendor Order No."; Code[20])
        {
            Caption = 'Vendor Order No.';

            trigger OnValidate()
            begin
                TestStatusOpen;
            end;
        }
        field(25006010; "Reservation Entry No."; Integer)
        {
            BlankZero = true;
            CalcFormula = lookup("Reservation Entry"."Entry No." where("Source Type" = const(39),
                                                                        "Source Subtype" = field("Document Type"),
                                                                        "Source ID" = field("Document No."),
                                                                        "Source Ref. No." = field("Line No."),
                                                                        "Reservation Status" = const(Reservation)));
            Caption = 'Reservation Entry No.';
            Description = 'Tracking';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006011; "Reservation Source Type"; Integer)
        {
            BlankZero = true;
            CalcFormula = lookup("Reservation Entry"."Source Type" where("Entry No." = field("Reservation Entry No."),
                                                                          Positive = const(false)));
            Caption = 'Reservation Source Type';
            Description = 'Tracking';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006012; "Reservation Source Subtype"; Option)
        {
            BlankZero = true;
            CalcFormula = lookup("Reservation Entry"."Source Subtype" where("Entry No." = field("Reservation Entry No."),
                                                                             Positive = const(false)));
            Caption = 'Reservation Source Subtype';
            Description = 'Tracking';
            Editable = false;
            FieldClass = FlowField;
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
        }
        field(25006013; "Reservation Source ID"; Code[20])
        {
            CalcFormula = lookup("Reservation Entry"."Source ID" where("Entry No." = field("Reservation Entry No."),
                                                                        Positive = const(false)));
            Caption = 'Reservation Source ID';
            Description = 'Tracking';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006014; "Reservation Source Ref. No."; Integer)
        {
            BlankZero = true;
            CalcFormula = lookup("Reservation Entry"."Source Ref. No." where("Entry No." = field("Reservation Entry No."),
                                                                              Positive = const(false)));
            Caption = 'Reservation Source Ref. No.';
            Description = 'Tracking';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006015; "Reservation VIN"; Code[20])
        {
            CalcFormula = lookup("Sales Line".VIN where("Document Type" = field("Reservation Source Subtype"),
                                                         "Document No." = field("Reservation Source ID"),
                                                         "Line No." = field("Reservation Source Ref. No.")));
            Caption = 'Reservation VIN';
            Description = 'Tracking';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006016; "Reservation Customer No."; Code[20])
        {
            CalcFormula = lookup("Sales Line"."Sell-to Customer No." where("Document Type" = field("Reservation Source Subtype"),
                                                                            "Document No." = field("Reservation Source ID"),
                                                                            "Line No." = field("Reservation Source Ref. No.")));
            Caption = 'Reservation Customer No.';
            Description = 'Tracking';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006100; "Special Order Service No."; Code[20])
        {
            Caption = 'Special Order Service No.';
            Description = 'P15';
            Editable = false;
            TableRelation = "Service Header EDMS"."No." where("Document Type" = const(Order));

            trigger OnValidate()
            var
                ApprAllowed: Boolean;
            begin
                if (xRec."Special Order Service No." <> "Special Order Service No.") and (Quantity <> 0) then
                    PurchasesWarehouseMgt.PurchaseLineVerifyChange(Rec, xRec);
            end;
        }
        field(25006101; "Special Order Service Line No."; Integer)
        {
            Caption = 'Sales Order Line No.';
            Editable = false;

            trigger OnValidate()
            var
                ApprAllowed: Boolean;
            begin
                if (xRec."Special Order Service Line No." <> "Special Order Service Line No.") and (Quantity <> 0) then
                    PurchasesWarehouseMgt.PurchaseLineVerifyChange(Rec, xRec);
            end;
        }
        field(25006130; "External Serv. Tracking No."; Code[20])
        {
            Caption = 'External Serv. Tracking No.';
            TableRelation = if (Type = filter("External Service")) "External Serv. Tracking No."."External Serv. Tracking No." where("External Service No." = field("No."));
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
                end; //ELSE
                     //[Lookup from Webservice removed]
                     //MESSAGE(STRSUBSTNO(Text105, "Vehicle Registration No."), '');
            end;
        }
        field(25006310; "Link Trade-In Entry"; Integer)
        {
            Caption = 'Link Trade-In Entry';
        }
        field(25006370; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;

            trigger OnValidate()
            var
                recModel: Record Model;
            begin
                TestStatusOpen;

                //EDMS
                /*  CreateDim(
                    Database::"Responsibility Center", "Responsibility Center",
                    DimMgt.TypeToTableID3(Type), "No.",
                    //DATABASE::Job,"Job No.",
                    Database::"Vehicle Status", "Vehicle Status Code",
                    Database::"Work Center", "Work Center No."
                    );*/
                CreateDimFromDefaultDim(Rec.FieldNo("Make code"));

                if "Make Code" <> xRec."Make Code" then begin
                    Validate("Model Code", '');
                end;
            end;
        }
        field(25006371; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));

            trigger OnValidate()
            begin
                TestStatusOpen;

                if "Model Code" <> xRec."Model Code" then begin
                    Validate("Model Version No.", '');
                end;
            end;
        }
        field(25006372; "Line Type"; Option)
        {
            Caption = 'Line Type';
            OptionCaption = 'Comment,Vehicle,,Item,Charge (Item),G/L Account,Resource';
            OptionMembers = Comment,Vehicle,,Item,"Charge (Item)","G/L Account",Resource;

            trigger OnValidate()
            var
                DocMgtDMS: Codeunit DocumentManagementDMS;
                Opt: Integer;
            begin
                TestStatusOpen;

                Opt := "Line Type";
                DocMgtDMS.PL_SetType_LineType(Rec);
                "Line Type" := Opt;
            end;
        }
        field(25006373; VIN; Code[20])
        {
            CalcFormula = lookup(Vehicle.VIN where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            var
                recVehicle: Record Vehicle;
                frmVehicleList: Page "Vehicle List";
            begin
                recVehicle.Reset;
                if LookUpMgt.LookUpVehicleAMT(recVehicle, "Vehicle Serial No.") then begin
                    Validate("Vehicle Serial No.", recVehicle."Serial No.");
                    VIN := recVehicle.VIN;
                end;
            end;

            trigger OnValidate()
            begin
                TestStatusOpen;
            end;
        }
        field(25006374; "Model Version No."; Code[20])
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
                if LookUpMgt.LookUpModelVersion(recItem, "No.", "Make Code", "Model Code") then begin
                    //<<DELTA BCH 09/03/2022
                    if "make code" = '' then
                        "make code" := recitem."make code";
                    if "model code" = '' then
                        "model code" := recitem."model code";
                    //>>DELTA BCH 09/03/2022
                    Validate("Model Version No.", recItem."No.");
                end;
            end;

            trigger OnValidate()
            begin
                TestStatusOpen;

                if "Line Type" = "line type"::Vehicle then begin
                    Validate("No.", "Model Version No.");
                    //08.01.2013 EDMS P8 >>
                    CurrFieldNo := FieldNo(Quantity);
                    if Type = Type::Item then
                        if "No." <> '' then
                            UpdateDirectUnitCost(FieldNo(Quantity))
                    //08.01.2013 EDMS P8 <<
                end;
            end;
        }
        field(25006375; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                recVehicle: Record Vehicle;
            begin
                recVehicle.Reset;
                if LookUpMgt.LookUpVehicleAMT(recVehicle, "Vehicle Serial No.") then begin
                    Validate("Vehicle Serial No.", recVehicle."Serial No.");
                    VIN := recVehicle.VIN;
                end;
            end;

            trigger OnValidate()
            var
                recReservationEntry: Record "Reservation Entry";
                iEntryNo: Integer;
                frmItemTrackingLines: Page "Item Tracking Lines";
                cPurchLineReserve: Codeunit "Purch. Line-Reserve";
                recVehicle: Record Vehicle;
                codSerialNoPre: Code[20];
                codDefCycle: Code[20];
                cuVehSN: Codeunit "Vehicle Serial No. Mgt.";
                TextAssignNewCycle: label 'Do you want to assign new %1?';
                VehAccCycleMgt: Codeunit VehicleAccountingCycleMgt;
                VheAccCycle: Record "Vehicle Accounting Cycle";
            begin
                TestStatusOpen;
                GetPurchHeader;

                if "Vehicle Serial No." = '' then begin
                    VIN := '';
                    "Vehicle Accounting Cycle No." := '';
                    "Vehicle Registration No." := '';
                end
                else begin
                    recVehicle.Reset;
                    if recVehicle.Get("Vehicle Serial No.") then begin
                        codSerialNoPre := "Vehicle Serial No.";
                        Validate("Make Code", recVehicle."Make Code");
                        Validate("Model Code", recVehicle."Model Code");
                        Validate("Model Version No.", recVehicle."Model Version No.");
                        VIN := recVehicle.VIN;
                        "Vehicle Serial No." := codSerialNoPre;
                        recVehicle.CalcFields("Default Vehicle Acc. Cycle No.");

                        "Vehicle Registration No." := recVehicle."Registration No.";

                        //13.05.2008. EDMS P2 >>
                        "Vehicle Status Code" := recVehicle."Status Code";
                        //13.05.2008. EDMS P2 <<

                        //18.06.2008. EDMS P2 >>
                        "Vehicle Body Color Code" := recVehicle."Body Color Code";
                        "Vehicle Interior Code" := recVehicle."Interior Code";
                        //18.06.2008. EDMS P2 <<

                        if recVehicle."Default Vehicle Acc. Cycle No." <> '' then
                            if (PurchHeader."Document Profile" <> PurchHeader."document profile"::Service) and
                               ("Line Type" = "line type"::Vehicle) and (not DontPromptVehCycle) //10.03.2008. EDMS P2
                            then
                                if Confirm(TextAssignNewCycle, false, FieldCaption("Vehicle Accounting Cycle No.")) then begin
                                    VheAccCycle.Reset;
                                    if VheAccCycle.Get(recVehicle."Default Vehicle Acc. Cycle No.") then begin
                                        Clear(VehAccCycleMgt);
                                        VehAccCycleMgt.CreateNewCycle_User(VheAccCycle);
                                        VehAccCycleMgt.SetAsDefault(VheAccCycle);
                                        recVehicle.CalcFields("Default Vehicle Acc. Cycle No.");
                                    end;
                                end;
                        Validate("Vehicle Accounting Cycle No.", recVehicle."Default Vehicle Acc. Cycle No.");
                    end
                    else begin
                        VIN := '';
                        codDefCycle := VehAccCycle.GetDefaultCycle("Vehicle Serial No.", "Vehicle Accounting Cycle No.");
                        if codDefCycle = '' then
                            fNewAccCycleNo
                        else
                            Validate("Vehicle Accounting Cycle No.", codDefCycle);
                    end;
                end;

                // 26.03.2014 Elva Baltic P18 #F011 #MMG7.00 >>
                /*CreateDim(
                  DimMgt.TypeToTableID3(Type.AsInteger()), "No.",
                  Database::"Vehicle Status", "Vehicle Status Code", //DMS
                  Database::"Responsibility Center", "Responsibility Center",
                  Database::"Work Center", "Work Center No."
                  ); //DMS*/
                // 26.03.2014 Elva Baltic P18 #F011 #MMG7.00 <<
                CreateDimFromDefaultDim(Rec.FieldNo("Vehicle Serial No."));
            end;
        }
        field(25006376; "Vehicle Assembly ID"; Code[20])
        {
            Caption = 'Vehicle Assembly ID';

            trigger OnValidate()
            var
                recVehAssembly: Record "Vehicle Assembly Line";
                tcAMT001: label 'Vehicle assembly list %1 is not empty.';
            begin
                TestStatusOpen;
                TestField("Vehicle Serial No.");
                if (xRec."Vehicle Assembly ID" <> '') and (xRec."Vehicle Assembly ID" <> Rec."Vehicle Assembly ID") then begin
                    recVehAssembly.Reset;
                    recVehAssembly.SetRange("Serial No.", xRec."Vehicle Serial No.");
                    recVehAssembly.SetRange("Assembly ID", xRec."Vehicle Assembly ID");
                    if not recVehAssembly.IsEmpty then
                        Error(tcAMT001, xRec."Vehicle Assembly ID");
                end;
            end;
        }
        field(25006378; "Vehicle Exists"; Boolean)
        {
            CalcFormula = exist(Vehicle where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Vehicle Exists';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006379; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            TableRelation = "Vehicle Accounting Cycle"."No." where("Vehicle Serial No." = field("Vehicle Serial No."));
            ValidateTableRelation = false;

            trigger OnLookup()
            var
                recVehAccCycle: Record "Vehicle Accounting Cycle";
            begin
                recVehAccCycle.Reset;
                if LookUpMgt.LookUpVehicleAccCycle(recVehAccCycle, "Vehicle Serial No.", "Vehicle Accounting Cycle No.") then
                    Validate("Vehicle Accounting Cycle No.", recVehAccCycle."No.");
            end;

            trigger OnValidate()
            begin
                TestStatusOpen;
                VehAccCycle.CheckCycleRelation("Vehicle Serial No.", "Vehicle Accounting Cycle No.");
            end;
        }
        field(25006380; "Vehicle Status Code"; Code[20])
        {
            Caption = 'Vehicle Status Code';
            TableRelation = "Vehicle Status".Code;

            trigger OnValidate()
            var
                recDimValue: Record "Dimension Value";
            begin
                TestStatusOpen;
                //EDMS
                /*CreateDim(
                  DimMgt.TypeToTableID3(Type.AsInteger()), "No.",
                  //DATABASE::Job,"Job No.",
                  Database::"Vehicle Status", "Vehicle Status Code",
                  Database::"Responsibility Center", "Responsibility Center",
                  Database::"Work Center", "Work Center No."
                  ); */
                CreateDimFromDefaultDim(Rec.FieldNo("Vehicle Status code"));
            end;
        }
        field(25006382; Reserved; Boolean)
        {
            CalcFormula = exist("Vehicle Reservation Entry" where("Source Type" = const(39),
                                                                   "Source Subtype" = field("Document Type"),
                                                                   "Source ID" = field("Document No."),
                                                                   "Source Ref. No." = field("Line No.")));
            Caption = 'Reserved';
            Description = 'Only for Vehicles';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006386; "Vehicle Body Color Code"; Code[10])
        {
            Caption = 'Vehicle Body Color Code';
            TableRelation = "Body Color".Code;
        }
        field(25006388; "Vehicle Interior Code"; Code[10])
        {
            Caption = 'Vehicle Interior Code';
            TableRelation = "Vehicle Interior";
        }
        field(25006389; "Requested Item No."; Code[20])
        {
            Caption = 'Requested Item No.';
        }
        field(25006700; "Ordering Price Type Code"; Code[20])
        {
            Caption = 'Ordering Price Type Code';
            TableRelation = "Ordering Price Type";

            trigger OnValidate()
            begin
                TestStatusOpen;
                UpdateDirectUnitCost(FieldNo("Ordering Price Type Code"));
                UpdateLeadTimeFields;
                UpdateDates;
            end;
        }
        field(25006710; "Qty. on Back Order"; Decimal)
        {
            Caption = 'Qty. on Back Order';
        }
        field(25006720; "Back Order Date"; Date)
        {
            Caption = 'Back Order Date';
        }
        field(25006730; "Item No. Changed"; Boolean)
        {
            Caption = 'Item No. Changed';
        }
        field(25006740; "Shipment Package No."; Code[20])
        {
            Caption = 'Shipment Package No.';
        }
        field(25006998; "Has Replacement"; Boolean)
        {
            Caption = 'Has Replacement';
        }
        modify("No.")
        {
            TableRelation = if (Type = const(" ")) "Standard Text"
            else
            if (Type = const("G/L Account"), "System-Created Entry" = const(false)) "G/L Account" where("Direct Posting" = const(true),
                                                                                                        "Account Type" = const(Posting),
                                                                                                        Blocked = const(false))
            else
            if (Type = const("G/L Account"), "System-Created Entry" = const(false)) "G/L Account"
            else
            if (Type = const(Item), "Line Type" = filter(<> Vehicle)) Item where("Item Type" = filter(" " | Item),
                                                                                "Purchasing Blocked" = const(false))
            else
            if (Type = const(Item), "Line Type" = const(Vehicle)) Item where("Item Type" = const("Model Version"))
            else
            if (Type = const(3)) Resource
            else
            if (Type = const("Fixed Asset")) "Fixed Asset"
            else
            if (Type = const("Charge (Item)")) "Item Charge"
            else
            if (Type = const("External Service")) "External Service"
            else
            if (Type = const(Item), "Document Type" = filter(<> "Credit Memo" & <> "Return Order")) Item where(Blocked = const(false), "Purchasing Blocked" = const(false))
            else
            if (Type = const(Item), "Document Type" = FILTER("Credit Memo" | "Return Order")) Item WHERE(Blocked = CONST(false))
            else
            if (Type = const(Resource)) Resource;

            trigger OnAfterValidate()
            Var
                Item: record Item;
            begin
                if Rec."Line Type" = Rec."line type"::Vehicle then begin
                    if Rec."Vehicle Serial No." = '' then
                        Rec.fNewSerialNo;
                    if Rec."No." <> Rec."Model Version No." then begin
                        If Item.Get("No.") Then;
                        Rec."Model Version No." := Rec."No.";
                        Rec."Make Code" := Item."Make Code";
                        Rec."Model Code" := Item."Model Code"
                    end
                end;
                //EDMS1.0.00 <<
                //GetPurchHeader;
            end;
        }

        modify("Order Date")
        {
            trigger OnAfterValidate()
            begin
                //16.11.2011 EDMS P8 >>
                UpdateDatesEDMS;
                //16.11.2011 EDMS P8 <<
            end;
        }
        modify("Location Code")
        {
            trigger OnAfterValidate()
            begin
                /*CreateDim(
                      DimMgt.TypeToTableID3(rec.Type.AsInteger()), "No.",
                      Database::"Vehicle Status", "Vehicle Status Code", //DMS
                      Database::"Responsibility Center", "Responsibility Center",
                      Database::Location, "Location Code"
                      );*/
                CreateDimFromDefaultDim(Rec.FieldNo("Location Code"));

            end;
        }

    }

    keys
    {
        key(EDMS19; "Document Profile")
        {
        }
        //  Create a mixed key from BaseApp & extension !!!
        /*
         key(Key20; Type, "Line Type", "Vehicle Serial No.", "Vehicle Accounting Cycle No.")
         {
         }
         */
        key(EDMS21; "Order Date")
        {
        }
        key(EDMS22; "Vehicle Serial No.", "Vehicle Assembly ID")
        {
        }
        //  Create a mixed key from BaseApp & extension !!!
        /*
        key(Key23; "Document Type", "Document No.", "Shipment Package No.")
        {
        }
        */
    }

    trigger OnModify()
    var
        Item1: Record Item;
        Item2: Record Item;
        NonstockItem1: Record "Nonstock Item";
        NonstockItem2: Record "Nonstock Item";
        ItemSubstitution: Record "Item Substitution";
        No1: Code[20];
        No2: Code[20];
    begin
        //02.04.2014 Elva Baltic P15 #F124 MMG7.00 >>
        if (Type = Type::Item) and (xRec."No." <> "No.") and (xRec."No." <> '') and ("No." <> '')
          and ("Document Profile" <> "document profile"::"Vehicles Trade") then begin
            if Item1.Get(xRec."No.") and Item2.Get(Rec."No.") then begin
                if Item1."Created From Nonstock Item" and Item2."Created From Nonstock Item" then begin
                    No1 := Item1.GetSourceNonstockEntryNo();
                    No2 := Item2.GetSourceNonstockEntryNo();
                    if (No1 <> '') and (No2 <> '') then begin
                        if not ItemSubstitution.Get(ItemSubstitution.Type::"Nonstock Item", No1, "Variant Code",
                                                    ItemSubstitution.Type::"Nonstock Item", No2, "Variant Code") then begin
                            if Confirm(Text055, true, xRec."No.", "No.") then begin
                                if ItemSubstitution.CreateReplacement(ItemSubstitution.Type::"Nonstock Item", No1, xRec."Variant Code",
                                                                      ItemSubstitution.Type::"Nonstock Item", No2, Rec."Variant Code", true) then
                                    Message(Text056, No1, No2);
                            end;
                        end;
                    end;
                end;
            end;
        end;
        //02.04.2014 Elva Baltic P15 #F124 MMG7.00 <<   
    end;

    var
        UserProfile: Record "Branch Profile Setup";
        LookUpMgt: Codeunit LookUpManagement;
        VehAccCycle: Codeunit VehicleAccountingCycleMgt;
        Text26500: label 'You must check field %1 in %2 to be able to change the %3 field manually.';
        TextItemDisallowedToPurchase: label 'Item %1 not allowed to purchase in location %2. Line No. %3.';
        VehPriceMgt: Codeunit VehicleSalesPriceDiscountMgt;
        ExternalService: Record "External Service";
        VehReservePurchLine: Codeunit "Purch. Line-Veh. Reserve";
        DontPromptVehCycle: Boolean;
        Text055: label 'Do you want to make a number replacement?\%1 -> %2';
        Text056: label 'Replacement created \ %1 - %2';
        Text105: label 'There is no vehicle with Registration No. %1';
        UserProfileMgt: Codeunit UserProfileManagement;
        ReservePurchLine: Codeunit "Purch. Line-Reserve";
        PurchHeader: Record "Purchase Header";
        DimMgt: Codeunit DimensionManagement;
        PurchasesWarehouseMgt: Codeunit "Purchases Warehouse Mgt.";
        WhseValidateSourceLine: Codeunit "Whse. Validate Source Line";

    [IntegrationEvent(false, false)]
    local procedure OnAfterAddItemElva(var PurchaseLine: Record "Purchase Line"; LastPurchaseLine: Record "Purchase Line")
    begin
    end;

    procedure UpdateInvoiceOnPurchOrder()
    begin
        if "Document Type" = "document type"::Order then begin
            GetPurchHeader;
            if ("Quantity Received" > 0) and ("Quantity Invoiced" > 0) and not PurchHeader.Invoice then begin
                PurchHeader.Invoice := true;
                PurchHeader.Modify;
            end;
        end;
    end;

    procedure ShowVehReservation()
    var
        VehReservation: Page "Vehicle Reservation";
    begin
        TestField(Type, Type::Item);
        TestField("Prod. Order No.", '');
        TestField("No.");
        Clear(VehReservation);
        VehReservation.SetPurchLine(Rec);
        VehReservation.RunModal;
    end;

    procedure ShowVehReservationEntries(Modal: Boolean)
    var
        VehReservEngineMgt: Codeunit "Veh. Reservation Management";
        VehReservEntry: Record "Vehicle Reservation Entry";
        VehReservePurchLine: Codeunit "Purch. Line-Veh. Reserve";
    begin
        TestField(Type, Type::Item);
        TestField("No.");
        VehReservePurchLine.FilterReservFor(VehReservEntry, Rec);
        if Modal then
            Page.RunModal(Page::"Vehicle Reservation Entries", VehReservEntry)
        else
            Page.Run(Page::"Vehicle Reservation Entries", VehReservEntry);
    end;

    procedure SetNotPromptVehCycle()
    begin
        DontPromptVehCycle := true;
    end;

    procedure UpdateDatesEDMS()
    var
        OrderingPriceType: Record "Ordering Price Type";
    begin
        //16.11.2011 EDMS P8 >>
        if "Expected Receipt Date" <> 0D then
            if OrderingPriceType.Get("Ordering Price Type Code") then
                if Format(OrderingPriceType."Inbound Time") <> '' then
                    "Expected Receipt Date" := CalcDate(OrderingPriceType."Inbound Time", "Expected Receipt Date");
    end;

    procedure GetReservForInfo(ReturnValue: Option CustomerNo,VIN,DealType,CustomerName,OrderingPriceType): Text[50]
    var
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        ReservEngineMgtEDMS: Codeunit "Reservation Management EDMS";
    begin
        exit(ReservEngineMgtEDMS.GetReservInfoForFactBox(ReturnValue, "Document No.", "Line No.", Database::"Purchase Line", "Document Type".AsInteger(), 0, ''));
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

        if LookUpMgt.LookUpVehicleAMT(Vehicle, "Vehicle Serial No.") then
            Validate("Vehicle Serial No.", Vehicle."Serial No.");
    end;

    procedure UpdateUnitPrice2()
    begin
        UpdateDirectUnitCost(0);
        UpdateAmounts;
    end;

    procedure CopyFromExternalService()
    begin
        //21/05/18 GH P1 - added function
        ExternalService.Get("No.");
        Description := ExternalService.Description;
        "Gen. Prod. Posting Group" := ExternalService."Gen. Prod. Posting Group";
        "VAT Prod. Posting Group" := ExternalService."VAT Prod. Posting Group";
    end;

    procedure IsServiceItem(): Boolean
    var
        Item: Record Item;
    begin
        if Type <> Type::Item then
            exit(false);
        if "No." = '' then
            exit(false);
        TestField("No.");
        Item.Get("No.");
        exit(Item.Type = Item.Type::Service);
    end;

    procedure fNewSerialNo()
    var
        recInvSetup: Record "Inventory Setup";
        cuNoSeriesMgt: Codeunit "No. Series";
        codSerialNo: Code[20];
        cuVehSerialNoMgt: Codeunit "Vehicle Serial No. Mgt.";
    begin
        //DMS
        if "Line Type" <> "line type"::Vehicle then
            exit;
        codSerialNo := cuVehSerialNoMgt.fGetNewNo;
        Validate("Vehicle Serial No.", codSerialNo);
    end;

    procedure fNewAccCycleNo()
    var
        recInvSetup: Record "Inventory Setup";
        cuNoSeriesMgt: Codeunit "No. Series";
        codCycleNo: Code[20];
        recVehAccCycle: Record "Vehicle Accounting Cycle";
    begin
        //DMS
        if "Line Type" <> "line type"::Vehicle then
            exit;

        TestField("Vehicle Serial No.");

        codCycleNo := VehAccCycle.GetNewCycleNo;

        recVehAccCycle.Init;
        recVehAccCycle."No." := codCycleNo;
        recVehAccCycle.Validate("Vehicle Serial No.", "Vehicle Serial No.");
        recVehAccCycle.Validate(Default, true);
        recVehAccCycle.Insert(true);

        Validate("Vehicle Accounting Cycle No.", codCycleNo);
    end;

    procedure NewVehAssemblyNo()
    var
        InvSetup: Record "Inventory Setup";
        NoSeriesMgt: Codeunit "No. Series";
        AssemblyNo: Code[20];
    begin
        //DMS
        if "Line Type" = "line type"::Vehicle then begin
            InvSetup.Get;
            InvSetup.TestField("Vehicle Assembly Nos."); //16.11.2007 P3
            Validate("Vehicle Assembly ID", NoSeriesMgt.GetNextNo(InvSetup."Vehicle Assembly Nos.", WorkDate(), true));
        end;
    end;

    procedure NoLookup()
    var
        recItem: Record Item;
        recItemCharge: Record "Item Charge";
        recGLAccount: Record "G/L Account";
        recFixedAsset: Record "Fixed Asset";
        recStandardText: Record "Standard Text";
    begin
        case "Document Profile" of
            "document profile"::"Vehicles Trade":
                begin
                    case "Line Type" of
                        "line type"::Comment:
                            begin
                                recStandardText.Reset;
                                if LookUpMgt.LookUpStandardText(recStandardText, "No.") then
                                    Validate("No.", recStandardText.Code);
                            end;
                        "line type"::Vehicle:
                            begin
                                recItem.Reset;
                                if LookUpMgt.LookUpModelVersion(recItem, "No.", "Make Code", "Model Code") then
                                    Validate("Model Version No.", recItem."No.");
                            end;
                        "line type"::Item:
                            begin
                                recItem.Reset;
                                if LookUpMgt.LookUpItemREZ(recItem, "No.") then
                                    Validate("No.", recItem."No.");
                            end;
                        "line type"::"Charge (Item)":
                            begin
                                recItemCharge.Reset;
                                if LookUpMgt.LookUpChargeItem_Purch(recItemCharge, "No.") then
                                    Validate("No.", recItemCharge."No.");
                            end;

                        //21.12.2007 EDMS P5 >>
                        Type::"External Service":
                            begin
                                ExternalService.Reset;
                                if LookUpMgt.LookUpExtService(ExternalService, "No.") then
                                    Validate("No.", ExternalService."No.");
                            end;
                        //21.12.2007 EDMS P5 <<

                        "line type"::"G/L Account":
                            begin
                                recGLAccount.Reset;
                                if LookUpMgt.LookUpGLAccount(recGLAccount, "No.") then
                                    Validate("No.", recGLAccount."No.");
                            end;
                    end;
                end;
            "document profile"::"Spare Parts Trade":
                begin
                    case Type of
                        Type::" ":
                            begin
                                recStandardText.Reset;
                                if LookUpMgt.LookUpStandardText(recStandardText, "No.") then
                                    Validate("No.", recStandardText.Code);
                            end;
                        Type::"G/L Account":
                            begin
                                recGLAccount.Reset;
                                if LookUpMgt.LookUpGLAccount(recGLAccount, "No.") then
                                    Validate("No.", recGLAccount."No.");
                            end;
                        Type::Item:
                            begin
                                recItem.Reset;
                                if LookUpMgt.LookUpItemREZ(recItem, "No.") then
                                    Validate("No.", recItem."No.");
                            end;
                        Type::"Fixed Asset":
                            begin
                                recFixedAsset.Reset;
                                if LookUpMgt.LookUpFixedAsset(recFixedAsset, "No.") then
                                    Validate("No.", recFixedAsset."No.");
                            end;
                        Type::"Charge (Item)":
                            begin
                                recItemCharge.Reset;
                                if LookUpMgt.LookUpChargeItem_Purch(recItemCharge, "No.") then
                                    Validate("No.", recItemCharge."No.");
                            end;

                        //21.12.2007 EDMS P5 >>
                        Type::"External Service":
                            begin
                                ExternalService.Reset;
                                if LookUpMgt.LookUpExtService(ExternalService, "No.") then
                                    Validate("No.", ExternalService."No.");
                            end;
                    //21.12.2007 EDMS P5 <<

                    end;
                end;
            else begin
                case Type of
                    Type::" ":
                        begin
                            recStandardText.Reset;
                            if LookUpMgt.LookUpStandardText(recStandardText, "No.") then
                                Validate("No.", recStandardText.Code);
                        end;
                    Type::"G/L Account":
                        begin
                            recGLAccount.Reset;
                            if LookUpMgt.LookUpGLAccount(recGLAccount, "No.") then
                                Validate("No.", recGLAccount."No.");
                        end;
                    Type::Item:
                        begin
                            recItem.Reset;
                            if LookUpMgt.LookUpItem(recItem, "No.") then
                                Validate("No.", recItem."No.");
                        end;
                    Type::"Fixed Asset":
                        begin
                            recFixedAsset.Reset;
                            if LookUpMgt.LookUpFixedAsset(recFixedAsset, "No.") then
                                Validate("No.", recFixedAsset."No.");
                        end;
                    Type::"Charge (Item)":
                        begin
                            recItemCharge.Reset;
                            if LookUpMgt.LookUpChargeItem_Purch(recItemCharge, "No.") then
                                Validate("No.", recItemCharge."No.");
                        end;

                    //21.12.2007 EDMS P5 >>
                    Type::"External Service":
                        begin
                            ExternalService.Reset;
                            if LookUpMgt.LookUpExtService(ExternalService, "No.") then
                                Validate("No.", ExternalService."No.");
                        end;
                //21.12.2007 EDMS P5 <<

                end;
            end;
        end
    end;

    procedure CreateVehicle()
    var
        VINInput: Page "Create Vehicle-Interactive";
        Vehicle: Record Vehicle;
        NewVIN: Code[20];
        Vehicle2: Record Vehicle;
        SalesLine: Record "Sales Line";
        tcAMT001: label 'VIN %1 already exists.';
        Text100: label 'Warning! Vehicle is not created as VIN was not specified.';
    begin
        TestField("Make Code");
        TestField("Model Code");
        TestField("Model Version No.");
        TestField("Vehicle Serial No.");
        CalcFields("Vehicle Exists");
        TestField("Vehicle Exists", false);

        Clear(VINInput);
        VINInput.fSetData("Make Code", "Model Code", "Model Version No.",
          "Vehicle Serial No.", "Vehicle Body Color Code", "Vehicle Interior Code");
        if VINInput.RunModal <> Action::OK then
            exit;


        NewVIN := VINInput.fGetNewVin;
        if NewVIN = '' then Begin
            Message(Text100);
            exit;
        End;

        Vehicle.Reset;

        Vehicle.Init;
        Vehicle.Validate("Serial No.", "Vehicle Serial No.");
        Vehicle.Validate(VIN, NewVIN);
        Vehicle.Validate("Make Code", "Make Code");
        Vehicle.Validate("Model Code", "Model Code");
        Vehicle.Validate("Model Version No.", "Model Version No.");
        Vehicle.Validate("Status Code", "Vehicle Status Code");
        Vehicle.Validate("Body Color Code", "Vehicle Body Color Code");
        Vehicle.Validate("Interior Code", "Vehicle Interior Code");
        Vehicle.Insert(true);
    end;


    procedure VehicleAssembly()
    var
        iLineNo: Integer;
        recVehicleAssemby: Record "Vehicle Assembly Line";
        frmVehAssemblyWorksheet: Page "Vehicle Assembly Worksheet";
        recInvSetup: Record "Inventory Setup";
        cuNoSeriesMgt: Codeunit "No. Series";
        VehOptMgt: Codeunit VehicleOptionManagement;
    begin
        if "Line Type" <> "line type"::Vehicle then
            exit;

        TestField("No.");
        TestField("Vehicle Serial No.");

        TestField("Make Code");
        TestField("Model Code");
        TestField("Model Version No.");

        if "Vehicle Assembly ID" = '' then begin
            NewVehAssemblyNo;
            Modify;
        end;

        VehPriceMgt.ChkAssemblyHdrPurchLine(Rec);
        VehOptMgt.FillVehAssembly("Vehicle Serial No.", "Vehicle Assembly ID", "Make Code", "Model Code", "Model Version No.");


        recVehicleAssemby.SetRange("Assembly ID", "Vehicle Assembly ID");
        recVehicleAssemby.SetRange("Make Code", "Make Code");
        recVehicleAssemby.SetRange("Model Code", "Model Code");
        recVehicleAssemby.SetRange("Model Version No.", "Model Version No.");
        recVehicleAssemby.SetRange("Serial No.", "Vehicle Serial No.");

        Clear(frmVehAssemblyWorksheet);
        frmVehAssemblyWorksheet.SetTableview(recVehicleAssemby);
        frmVehAssemblyWorksheet.Run;
    end;

    procedure NoAssistEdit()
    var
        NonstockItem: Record "Nonstock Item";
        NonstockItemMgt: Codeunit "Catalog Item Management";
    begin
        if Type = Type::Item then begin

            //20.08.2008. EDMS P2 >>
            CurrFieldNo := FieldNo("No.");
            //20.08.2008. EDMS P2 <<

            NonstockItem.Reset;
            if LookUpMgt.LookUpNonstockItemByItem(NonstockItem, "No.") then begin
                if NonstockItem."Item No." = '' then begin
                    NonstockItemMgt.NonstockAutoItem(NonstockItem);
                    NonstockItem.Get(NonstockItem."Entry No.");
                    Validate("No.", NonstockItem."Item No.");
                end
                else begin
                    Validate("No.", NonstockItem."Item No.");
                end;
            end;
        end;
    end;

    procedure ApplyVehAssemblyToSales()
    var
        SalesLine: Record "Sales Line";
    begin
        TestField(Type, Type::Item);
        TestField("Line Type", "line type"::Vehicle);

        SalesLine.Reset;
        SalesLine.SetCurrentkey("Document Profile");
        SalesLine.SetRange("Document Profile", SalesLine."document profile"::"Vehicles Trade");

        if "Make Code" <> '' then
            SalesLine.SetRange("Make Code", "Make Code");
        if "Model Code" <> '' then
            SalesLine.SetRange("Model Code", "Model Code");
        if "Model Version No." <> '' then
            SalesLine.SetRange("Model Version No.", "Model Version No.");

        if "Vehicle Assembly ID" <> '' then
            SalesLine.SetFilter("Vehicle Assembly ID", '<>''''');


        if Page.RunModal(Page::"Apply Purchase to Sales Line", SalesLine) = Action::LookupOK then begin
            if "Make Code" = '' then
                Validate("Make Code", SalesLine."Make Code");
            if "Model Code" = '' then
                Validate("Model Code", SalesLine."Model Code");
            if "Model Version No." = '' then
                Validate("Model Version No.", SalesLine."Model Version No.");

            Validate("Vehicle Serial No.", SalesLine."Vehicle Serial No.");

            Validate("Vehicle Assembly ID", SalesLine."Vehicle Assembly ID");
        end;
    end;



    procedure AddItemElva(var PurchLine: Record "Purchase Line"; ItemNo: Code[20])
    var
        LastPurchLine: Record "Purchase Line";
        TransferExtendedText: Codeunit "Transfer Extended Text";
    begin
        PurchLine.Init();
        PurchLine."Line No." += 10000;
        PurchLine.Validate(Type, Type::Item);
        PurchLine.Validate("No.", ItemNo);
        PurchLine.Insert(true);
        if TransferExtendedText.PurchCheckIfAnyExtText(PurchLine, false) then begin
            TransferExtendedText.InsertPurchExtTextRetLast(PurchLine, LastPurchLine);
            PurchLine."Line No." := LastPurchLine."Line No."
        end;
        OnAfterAddItemElva(PurchLine, LastPurchLine);
    end;

}
