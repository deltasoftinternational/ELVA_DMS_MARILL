tableextension 25006033 "Sales Line" extends "Sales Line" //37
{
    // 
    // 13.06.2019 EB.P30 EDMS
    //   Modified field:
    //     "Line Type" Added option Resource
    // 
    // 02.08.2018 EB.P30 EDMS Rent
    //   Modified field "Document Profile":
    //     Added option "Rent"
    //   Added field:
    //     25006600 "Rent Order No."
    //     25006601 "Rent Order Line No."
    //     25006602 "Rent Item No."
    //     25006603 "Rent Order Sales Line No."
    //     25006604 "Rent Asset No."
    //     25006605 "Rent Start Date"
    //     25006606 "Rent End Date"
    // 
    // 11.10.2017 EB.AKR BLS
    //   Added Fields:
    //   55000BLS Invoicing Entry No.
    //     55010BLS Service Code
    //     55020BLS Object Code
    // 
    // 01.09.2017 EB.P30 EDMS
    //   Added function:
    //     GetVehicleAssemblyFromPurchase;
    //   Modified trigger:
    //     "Vehicle Serial No."
    // 
    // 05.07.2016 EB.P7 #PAR28
    //   "No." OnLookup() trigger code moved to page
    //   "No." OnValidate trigger modified
    // 
    // 11.05.2016 EB.P7 #PAR28
    //   Field "Has Replacement" added
    // 
    // 16.03 2016 EB.P7 Branch Setup
    //   Modified CheckVehicleDiscount function, Usert Profile Setup to Branch Profile Setup
    //   Modified No. - OnValidate Usert Profile Setup to Branch Profile Setup
    //   Modified Vehicle Serial No. - OnValidate Usert Profile Setup to Branch Profile Setup
    // 
    // 25.01.2016 EB.P30 #T031
    //   Modified field "Vehicle Body Color Code" lenght to 20 characters
    // 
    // 15.05.2015 EB.P7 #Merge
    //   Modified function UpdatePrepmtSetupFields() merged edms functionality
    // 
    // 10.03.2015 EDMS P21
    //   Modified procedure:
    //     CreateDim
    //   Modified CreateDim calls because of added parameter
    //   Modified trigger:
    //     Location Code - OnValidate
    // 
    // 14.05.2014 Elva Baltic P21 #S0103 MMG7.00
    //   Added code to:
    //     No. - OnLookup()
    // 
    // 29.04.2014 Elva Baltic P8 #F037 MMG7.00
    //   * Use of Def. Status from profile
    // 
    // 27.03.2014 Elva Baltic P1 #RX MMG7.00
    //   *Added functions GetReservationColor, FilterSalesLineRes
    // 
    // 17.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added field:
    //     Contract No.
    // 
    // 26.03.2014 Elva Baltic P18 #F011 #MMG7.00
    //   Added COde To "Vehicle Serial No. - OnValidate()"
    // 
    // 25.10.2013 EDMS P8
    //   * Added use of Vehicle default dimension
    // 
    // 29.08.2013 EDMS P8
    //   * small fix
    // 
    // 03.06.2013 Elva Baltic P15
    //   * If Vehicle is in Vehicle.Inventory UnitCost is got from ILE Open Entry, otherwise, as it was before, from Item
    //   * Added Function: GetVehUnitCost
    // 
    // 23.01.2013 EDMS P8
    //   * small fix to update VIN in lines at insert
    // 
    // 2012.07.31 EDMS P8
    //   * added fields: Variable Field Run 2, Variable Field Run 3
    //   * renamed field Kilometrage to 'Variable Field Run 1' and type to decimal
    // 
    // 2012.04.12 EDMS P8
    //   * removed fields "Resource No."(25006050) and "Mechanics No."
    // 
    // 20.08.2008. EDMS P2
    //   * Added code NoAssistEdit
    // 
    // 02.07.2008. EDMS P2
    //   * Added code ApplyAmrkupRestrictions
    // 
    // 10.06.2008. EDMS P2
    //   * Changed code fVehApplyToPurch
    // 
    // 10.05.2008. EDMS P2
    //   * Added code Location Code - OnValidate
    // 
    // 09.05.2008. EDMS P2
    //   * Added code Quantity - OnValidate (check for Vehicle qty not more than 1)
    // 
    // 08.04.2008. EDMS P2
    //   * Changed code OnDelete
    // 
    // 07.03.2008. EDMS P2
    //   * Added code No. - OnValidate
    // 
    // 28.12.2007 EDMS P5
    //         * Changed property "OptionString" for field "Type"
    //           from  ",G/L Account,Item,Resource,Fixed Asset,Charge (Item)"
    //           to " ,G/L Account,Item,Resource,Fixed Asset,Charge (Item),,External Service"
    // 
    //         * Changed property "TableRelation" for field "No."
    //           from "IF (Type=CONST(" ")) "Standard Text"
    //               ELSE IF (Type=CONST(G/L Account)) "G/L Account"
    //               ELSE IF (Type=CONST(Item)) Item
    //               ELSE IF (Type=CONST(Resource)) Resource
    //               ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset"
    //               ELSE IF (Type=CONST("Charge (Item)")) "Item Charge""
    //           to "IF (Type=CONST(" ")) "Standard Text"
    //               ELSE IF (Type=CONST(G/L Account)) "G/L Account"
    //               ELSE IF (Type=CONST(Item)) Item
    //               ELSE IF (Type=CONST(Resource)) Resource
    //               ELSE IF (Type=CONST(Fixed Asset)) "Fixed Asset"
    //               ELSE IF (Type=CONST("Charge (Item)")) "Item Charge"
    //               ELSE IF (Type=CONST(External Service)) "External Service EDMS""
    // 
    //         * Added new field
    //           25006130 "Ext. Service Tracking No."
    // 
    // 03.10.2007. EDMS P2
    //    * Added code OnDelete
    // 
    // 10.09.2007 EDMS P3
    //   * Added 2 procedures: ShowTransferTakeOut and ShowTransferPutIn
    // 
    // 31.08.2007. EDMS P2
    //   * Added code in trigger "Vehicle Serial No. - OnValidate()"
    // 
    // 17-07-2007 EDMS P3
    //   * Added field "Include In Vehicle Sls Amt" to control creation of value entry for this line to impact
    //     overall sales amt. sum on vehicle
    // 
    // 05.06.2007. EDMS P2
    //   * Created function VehChecklistItem
    // 
    // //09-02-2007 EDMS P3
    // Added field 25006377 - EDMS No. (also in posted line)
    // 
    // EBLV7.00.00
    fields
    {
        modify("No.")
        {
            TableRelation = if (Type = const(" ")) "Standard Text"
            else
            if (Type = const("G/L Account"),
                                     "System-Created Entry" = const(false)) "G/L Account" where("Direct Posting" = const(true),
                                                                                               "Account Type" = const(Posting),
                                                                                               Blocked = const(false))
            else
            if (Type = const("G/L Account"),
                                                                                                        "System-Created Entry" = const(true)) "G/L Account"
            else
            if (Type = const(Item),
                                                                                                                 "Line Type" = const(Vehicle)) Item where("Item Type" = const("Model Version"))
            else
            if (Type = const(Item),
                                                                                                                          "Line Type" = filter(<> Vehicle)) Item where("Item Type" = filter(" " | Item),
                                                                                                                                                                     Blocked = const(false), "Sales Blocked" = const(false))
            else
            if (Type = const(Resource)) Resource
            else
            if (Type = const("Fixed Asset")) "Fixed Asset"
            else
            if (Type = const("Charge (Item)")) "Item Charge"
            else
            if (Type = const("External Service")) "External Service"
            else
            if (Type = const(Item),
                                                                                                                                                                              "Document Type" = filter(<> "Credit Memo" & <> "Return Order")) Item where(Blocked = const(false),
                                                                                                                                                                                                                                                    "Sales Blocked" = const(false))
            else
            if (Type = const(Item),
                                                                                                                                                                                                                                                             "Document Type" = filter("Credit Memo" | "Return Order")) Item where(Blocked = const(false));
        }
        field(55000; "BLS Invoicing Entry No."; Integer)
        {
            Caption = 'Billing Invoicing Entry No.';
            TableRelation = "BLS Invoicing Ledger Entry"."Entry No.";
        }
        field(55010; "BLS Service Code"; Code[20])
        {
            Caption = 'Service Code';
            TableRelation = "BLS Service".Code;

            trigger OnValidate()
            begin
                if not IsTemporary then
                    CreateDimFromDefaultDim(Rec.FieldNo("BLS Service code"));

                //   rec.CreateDim(
                //     DimMgt.TypeToTableID3(Type), "No.",
                ////  DATABASE::Job,"Job No.",
                //  Database::"Vehicle Status", "Vehicle Status Code", //DMS
                //  Database::"Responsibility Center", "Responsibility Center");
                /*
                Database::"Deal Type", "Deal Type Code", //DMS
                Database::Make, "Make Code", //DMS
                Database::"Payment Method", "Payment Method Code", //DMS
                Database::Vehicle, "Vehicle Serial No.", //DMS
                Database::Location, "Location Code"//,      // 10.03.2015 EDMS P21
                                                   // DATABASE::"BLS Service", "BLS Service Code"
                );*/
            end;
        }
        field(55020; "BLS Object Code"; Code[20])
        {
            Caption = 'Object Code';
            TableRelation = "BLS Object".Code;
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
            begin
                //21.12.2004 EDMS P1
                CreateDimFromDefaultDim(Rec.FieldNo("Deal Type code"));
                //  CreateDim(
                //    Database::"Responsibility Center", "Responsibility Center",
                //    DimMgt.TypeToTableID3("Type".AsInteger()), "No.",
                //    //DATABASE::Job,"Job No.",
                //    Database::"Vehicle Status", "Vehicle Status Code");
                /*
                Database::"Deal Type", "Deal Type Code",
                Database::Make, "Make Code",
                Database::"Payment Method", "Payment Method Code",
                Database::Vehicle, "Vehicle Serial No.", //DMS
                Database::Location, "Location Code"      // 10.03.2015 EDMS P21
                );*/
            end;
        }
        field(25006002; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";

            trigger OnValidate()
            begin

                //CreateDimFromDefaultDim(Rec.FieldNo("Payment Method code"));
                //CreateDim(
                //  Database::"Responsibility Center", "Responsibility Center",
                //  DimMgt.TypeToTableID3("Type".AsInteger()), "No.",
                //  //DATABASE::Job,"Job No.",
                //  Database::"Vehicle Status", "Vehicle Status Code");
                /*
                Database::"Deal Type", "Deal Type Code",
                Database::Make, "Make Code",
                Database::"Payment Method", "Payment Method Code",
                Database::Vehicle, "Vehicle Serial No.", //DMS
                Database::Location, "Location Code"      // 10.03.2015 EDMS P21
                );*/
            end;
        }
        field(25006006; Group; Boolean)
        {
            Caption = 'Group';
        }
        field(25006007; "Group ID"; Integer)
        {
            Caption = 'Group ID';
            TableRelation = "Sales Line"."Line No." where("Document Type" = field("Document Type"),
                                                           "Document No." = field("Document No."),
                                                           Group = const(true));
        }
        field(25006008; "Group Description"; Text[100])
        {
            CalcFormula = lookup("Sales Line".Description where("Document Type" = field("Document Type"),
                                                                 "Document No." = field("Document No."),
                                                                 "Line No." = field("Group ID")));
            Caption = 'Group Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006010; "Item No. for Print"; Code[20])
        {
            Caption = 'Item No. for Print';
            TableRelation = Item;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                recItem: Record Item;
            begin
                if "Item No. for Print" <> '' then begin
                    if recItem.Get("Item No. for Print") then
                        "Item Description for Print" := recItem.Description;
                end
                else
                    "Item Description for Print" := '';
            end;
        }
        field(25006020; "Item Description for Print"; Text[30])
        {
            Caption = 'Item Description for Print';
        }
        field(25006030; "Campaign No."; Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;
            ValidateTableRelation = false;
        }
        field(25006060; "Standard Time"; Decimal)
        {
            BlankZero = true;
            Caption = 'Standard Time';
            DecimalPlaces = 0 : 5;
            Editable = false;
        }
        field(25006130; "External Serv. Tracking No."; Code[20])
        {
            Caption = 'External Serv. Tracking No.';
            TableRelation = if (Type = filter("External Service")) "External Serv. Tracking No."."External Serv. Tracking No." where("External Service No." = field("No."));
        }
        field(25006135; "Service Order No. EDMS"; Code[20])
        {
            Caption = 'Service Order No. EDMS';
            Description = 'Only Service';
        }
        field(25006137; "Service Order Line No. EDMS"; Integer)
        {
            Caption = 'Service Order Line No. EDMS';
            Description = 'Only Service';
        }
        field(25006140; "Order Line Type No."; Code[20])
        {
            Caption = 'Order Line Type No.';
            Description = 'Only Service';
            TableRelation = if ("Line Type" = const(Comment)) "Standard Text"
            else
            if ("Line Type" = const("G/L Account")) "G/L Account"
            else
            if ("Line Type" = const(Item)) Item
            else
            if ("Line Type" = const(Labor)) "Service Labor"
            else
            if ("Line Type" = const("Ext. Service")) "External Service";
        }
        field(25006150; "Customer Notification Date"; Date)
        {
            Caption = 'Customer Notification Date';
        }
        field(25006155; "Real Time"; Decimal)
        {
            BlankZero = true;
            Caption = 'Real Time';
            Description = 'Only Service';
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
                    Message(StrSubstNo(Text105, "Vehicle Registration No."), '');
            end;
        }
        // field(25006171; "Sell-to Customer Name"; Text[100])
        // {
        //     CalcFormula = lookup("Sales Header"."Sell-to Customer Name" where("Document Type" = field("Document Type"),
        //                                                                        "No." = field("Document No.")));
        //     Caption = 'Sell-to Customer Name';
        //     Editable = false;
        //     FieldClass = FlowField;
        // }
        field(25006180; "Sell-to Contact Phone No."; Text[100])
        {
            CalcFormula = lookup("Sales Header"."Sell-to Contact" where("Document Type" = field("Document Type"),
                                                                         "No." = field("Document No.")));
            Caption = 'Sell-to Contact Phone No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006210; "Package No."; Code[20])
        {
            Caption = 'Package No.';
            Editable = false;
            TableRelation = "Service Package"."No.";
        }
        field(25006300; "Package Version No."; Integer)
        {
            Caption = 'Package Version No.';
            Editable = false;
            TableRelation = "Service Package Version"."Version No." where("Package No." = field("Package No."));
        }
        field(25006310; "Package Version Spec. Line No."; Integer)
        {
            Caption = 'Package Version Spec. Line No.';
            Editable = false;
            NotBlank = true;
            TableRelation = "Service Package Version Line"."Line No." where("Package No." = field("Package No."),
                                                                             "Version No." = field("Package Version No."));
        }
        field(25006370; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;

            trigger OnValidate()
            begin
                TestStatusOpen;
                CreateDimFromDefaultDim(Rec.FieldNo("Make code"));
                //CreateDim(
                //Database::"Responsibility Center", "Responsibility Center",
                //DimMgt.TypeToTableID3("Type".AsInteger()), "No.",
                ////DATABASE::Job,"Job No."
                //Database::"Vehicle Status", "Vehicle Status Code");


                /*  Database::"Deal Type", "Deal Type Code",
                  Database::Make, "Make Code",
                  Database::"Payment Method", "Payment Method Code",
                  Database::Vehicle, "Vehicle Serial No.", //DMS
                  Database::Location, "Location Code"      // 10.03.2015 EDMS P21
                  );*/

                if ("Make Code" <> xRec."Make Code") and ("Model Code" <> '') then begin
                    Validate("Model Code", '');
                end;
            end;
        }
        field(25006371; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));

            trigger OnValidate()
            var
                recVehicle: Record Vehicle;
                recItem: Record Item;
            begin
                TestStatusOpen;

                if ("Model Code" <> xRec."Model Code") and ("Model Version No." <> '') then begin
                    Validate("Model Version No.", '');
                end;
            end;
        }
        field(25006372; "Line Type"; Option)
        {
            Caption = 'Line Type';
            OptionCaption = 'Comment,G/L Account,Item,Labor,Ext. Service,Materials,Vehicle,Own Option,Charge (Item),Fixed Asset,Resource';
            OptionMembers = Comment,"G/L Account",Item,Labor,"Ext. Service",Materials,Vehicle,"Own Option","Charge (Item)","Fixed Asset",Resource;

            trigger OnValidate()
            var
                cuDocMgtDMS: Codeunit DocumentManagementDMS;
            begin
                cuDocMgtDMS.SL_SetType_LineType(Rec);
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
                Vehicle: Record Vehicle;
            begin
                Vehicle.Reset;
                if LookUpMgt.LookUpVehicleAMT(Vehicle, "Vehicle Serial No.") then begin
                    Validate("Vehicle Serial No.", Vehicle."Serial No.");
                    CalcFields(VIN);
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
                    OnLookupOnBeforeValidateModVersion(Rec, recItem);
                    Validate("Model Version No.", recItem."No.");
                end;
            end;

            trigger OnValidate()
            begin
                TestStatusOpen;

                if "Line Type" = "line type"::Vehicle then begin
                    if "Model Version No." = '' then begin
                        Validate("No.", "Model Version No.");
                        VIN := '';
                        "Vehicle Serial No." := '';
                        "Vehicle Accounting Cycle No." := '';
                    end else
                        Validate("No.", "Model Version No.");
                    UpdateUnitPrice(FieldNo("Model Version No."));
                end;
            end;
        }
        field(25006375; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';

            trigger OnLookup()
            var
                Vehicle: Record Vehicle;
            begin
                Vehicle.Reset;
                if LookUpMgt.LookUpVehicleAMT(Vehicle, "Vehicle Serial No.") then begin
                    Validate("Vehicle Serial No.", Vehicle."Serial No.");
                    VIN := Vehicle.VIN;
                end;
            end;

            trigger OnValidate()
            var
                ReservationEntry: Record "Reservation Entry";
                SalesLine: Record "Sales Line";
                EntryNo: Integer;
                frmItemTrackingLines: Page "Item Tracking Lines";
                SalesLineReserve: Codeunit "Sales Line-Reserve";
                Vehicle: Record Vehicle;
                SerialNoPre: Code[20];
                DefCycle: Code[20];
                VehAccCycleMgt: Codeunit VehicleAccountingCycleMgt;
                VehSerialNo: Code[20];
                ishandled: Boolean;
            begin
                TestStatusOpen;

                if ("Vehicle Serial No." <> '') and ("Line Type" = "line type"::Comment) and
                   ("Document Profile" = "document profile"::"Vehicles Trade")
                then begin
                    VehSerialNo := "Vehicle Serial No.";
                    Validate("Line Type", "line type"::Vehicle);
                    Validate("Vehicle Serial No.", VehSerialNo);
                end;

                if ("Vehicle Serial No." <> '') and ("Line Type" = "line type"::Vehicle) then begin
                    SalesLine.Reset;
                    SalesLine.SetRange("Document Type", SalesLine."document type"::Order);
                    SalesLine.SetCurrentkey(Type, "Line Type", "Vehicle Serial No.");
                    SalesLine.SetRange("Vehicle Serial No.", "Vehicle Serial No.");
                    SalesLine.SetRange("Line Type", SalesLine."line type"::Vehicle);
                    if SalesLine.FindFirst then
                        Message(StrSubstNo(EDMS001, "Vehicle Serial No.", SalesLine."Document No."));
                    if Vehicle.GET("Vehicle Serial No.") then
                        Vehicle.TestField("Model Version No.");
                end;

                if "Vehicle Serial No." = '' then begin
                    VIN := '';
                    "Vehicle Accounting Cycle No." := '';
                    "Vehicle Registration No." := '';

                end else begin
                    Vehicle.Reset;
                    Vehicle.SetCurrentkey("Serial No.");
                    Vehicle.SetRange("Serial No.", "Vehicle Serial No.");
                    if Vehicle.FindFirst then begin
                        SerialNoPre := "Vehicle Serial No.";
                        "Make Code" := Vehicle."Make Code";
                        "Model Code" := Vehicle."Model Code";
                        Validate("Model Version No.", Vehicle."Model Version No.");
                        CalcFields(VIN);

                        "Vehicle Registration No." := Vehicle."Registration No.";

                        "Vehicle Body Color Code" := Vehicle."Body Color Code";
                        "Vehicle Interior Code" := Vehicle."Interior Code";
                        //16.03.2016 EB.P7 #Branch Profile >>
                        //if "Vehicle Status Code" = '' then
                        "Vehicle Status Code" := Vehicle."Status Code";
                        if "Vehicle Status Code" = '' then
                            if UserProfileMgt.CurrProfileID <> '' then
                                if UserProfile.Get(UserProfileMgt.CurrProfileID, UserProfileMgt.CurrBranchNo) then
                                    if UserProfile."Default Vehicle Status" <> '' then
                                        "Vehicle Status Code" := UserProfile."Default Vehicle Status";

                        "Vehicle Serial No." := SerialNoPre;
                        OnAfterAssignOnBeforeValidateVehicleStatusCode(Rec, Vehicle);
                        Validate("Vehicle Status Code");
                        //16.03.2016 EB.P7 #Branch Profile <<


                        LicensePermission.SetRange("Object Type", LicensePermission."object type"::Codeunit);
                        LicensePermission.SetRange("Object Number", Codeunit::VehicleAccountingCycleMgt);
                        LicensePermission.SetFilter("Execute Permission", '<>%1', LicensePermission."execute permission"::" ");
                        if not LicensePermission.IsEmpty then begin
                            Vehicle.CalcFields("Default Vehicle Acc. Cycle No.");
                            Validate("Vehicle Accounting Cycle No.", Vehicle."Default Vehicle Acc. Cycle No.");
                        end;

                    end else begin
                        VIN := '';

                        LicensePermission.SetRange("Object Type", LicensePermission."object type"::Codeunit);
                        LicensePermission.SetRange("Object Number", Codeunit::VehicleAccountingCycleMgt);
                        LicensePermission.SetFilter("Execute Permission", '<>%1', LicensePermission."execute permission"::" ");
                        if not LicensePermission.IsEmpty then begin
                            DefCycle := VehAccCycleMgt.GetDefaultCycle("Vehicle Serial No.", "Vehicle Accounting Cycle No.");
                            if DefCycle = '' then begin
                                onbeforeNewAccCycleNo(DefCycle, ishandled);
                                if not ishandled then
                                    NewAccCycleNo
                            end else
                                Validate("Vehicle Accounting Cycle No.", DefCycle);
                        end;

                    end;
                    //09.04.2014 Elva Baltic P1 #RX MMG7.00 >>
                    if Type <> Type::" " then
                        //09.04.2014 Elva Baltic P1 #RX MMG7.00 <<
                        UpdateUnitPrice(FieldNo("Vehicle Serial No."));
                end;

                if "Vehicle Serial No." <> xRec."Vehicle Serial No." then
                    "Vehicle Assembly ID" := '';

                // 01.09.2017 EB.P30 EDMS >>
                if ("Vehicle Serial No." <> '') and ("Line Type" = "line type"::Vehicle) and ("Vehicle Assembly ID" = '') then
                    GetVehicleAssemblyFromPurchase;
                // 01.09.2017 EB.P30 EDMS <<

                // 26.03.2014 Elva Baltic P18 #F011 #MMG7.00 >>
                CreateDimFromDefaultDim(Rec.FieldNo("Vehicle Serial No."));
                //CreateDim(
                //  DimMgt.TypeToTableID3("Type".AsInteger()), "No.",
                // // DATABASE::Job,JobPlanningLine."Job No.", //DMS
                // Database::"Responsibility Center", "Responsibility Center",
                //  Database::"Vehicle Status", "Vehicle Status Code");//DMS

                /*Database::"Deal Type", "Deal Type Code", //DMS
                Database::Make, "Make Code", //DMS
                Database::"Payment Method", "Payment Method Code", //DMS
                Database::Vehicle, "Vehicle Serial No.", //DMS
                Database::Location, "Location Code"      // 10.03.2015 EDMS P21
                );*/
                // 26.03.2014 Elva Baltic P18 #F011 #MMG7.00 <<
            end;
        }
        field(25006376; "Vehicle Assembly ID"; Code[20])
        {
            Caption = 'Vehicle Assembly ID';

            trigger OnValidate()
            var
                VehAssembly: Record "Vehicle Assembly Line";
                tcAMT001: label 'Vehicle assembly list %1 is not empty.';
            begin
                TestStatusOpen;

                TestField("Vehicle Serial No.");

                if (xRec."Vehicle Assembly ID" <> '') and (xRec."Vehicle Assembly ID" <> Rec."Vehicle Assembly ID")
                 and (xRec."Line No." = Rec."Line No.") then begin
                    VehAssembly.Reset;
                    VehAssembly.SetRange("Serial No.", xRec."Vehicle Serial No.");
                    VehAssembly.SetRange("Assembly ID", xRec."Vehicle Assembly ID");
                    if not VehAssembly.IsEmpty then
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
            TableRelation = "Vehicle Accounting Cycle"."No.";

            trigger OnLookup()
            var
                recVehAccCycle: Record "Vehicle Accounting Cycle";
            begin
                recVehAccCycle.Reset;
                if LookUpMgt.LookUpVehicleAccCycle(recVehAccCycle, "Vehicle Serial No.", "Vehicle Accounting Cycle No.") then
                    Validate("Vehicle Accounting Cycle No.", recVehAccCycle."No.");
            end;

            trigger OnValidate()
            var
                cuVehAccCycle: Codeunit VehicleAccountingCycleMgt;
            begin
                LicensePermission.SetRange("Object Type", LicensePermission."object type"::Codeunit);
                LicensePermission.SetRange("Object Number", Codeunit::VehicleAccountingCycleMgt);
                LicensePermission.SetFilter("Execute Permission", '<>%1', LicensePermission."execute permission"::" ");
                if not LicensePermission.IsEmpty then begin
                    TestStatusOpen;
                    cuVehAccCycle.CheckCycleRelation("Vehicle Serial No.", "Vehicle Accounting Cycle No.");
                end;
            end;
        }
        field(25006380; "Vehicle Status Code"; Code[20])
        {
            Caption = 'Vehicle Status Code';
            TableRelation = "Vehicle Status".Code;

            trigger OnValidate()
            begin
                TestStatusOpen;
                //21.12.2004 EDMS P1
                CreateDimFromDefaultDim(Rec.FieldNo("Vehicle Status code"));
                //CreateDim(
                //  DimMgt.TypeToTableID3("Type".AsInteger()), "No.",
                //  //DATABASE::Job,"Job No.",
                //  Database::"Vehicle Status", "Vehicle Status Code",
                //  Database::"Responsibility Center", "Responsibility Center");

                /*  Database::"Deal Type", "Deal Type Code",
                  Database::Make, "Make Code",
                  Database::"Payment Method", "Payment Method Code",
                  Database::Vehicle, "Vehicle Serial No.", //DMS
                  Database::Location, "Location Code"      // 10.03.2015 EDMS P21
                  );*/
            end;
        }
        field(25006382; Reserved; Boolean)
        {
            CalcFormula = exist("Vehicle Reservation Entry" where("Source Type" = const(37),
                                                                   "Source Subtype" = field("Document Type"),
                                                                   "Source ID" = field("Document No."),
                                                                   "Source Ref. No." = field("Line No.")));
            Caption = 'Reserved';
            Description = 'Only for Vehicles';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006386; "Vehicle Body Color Code"; Code[20])
        {
            Caption = 'Vehicle Body Color Code';
            TableRelation = "Body Color".Code;
        }
        field(25006388; "Vehicle Interior Code"; Code[10])
        {
            Caption = 'Vehicle Interior Code';
            TableRelation = "Vehicle Interior";
        }
        field(25006389; "Variable Field Run 1"; Decimal)
        {
            CaptionClass = '7,37,25006389';
        }
        field(25006390; "Vehicle Trade-In Line"; Boolean)
        {
            Caption = 'Vehicle Trade-In Line';
        }
        field(25006391; "Applies-to Veh. Serial No."; Code[20])
        {
            Caption = 'Applies-to Veh. Serial No.';
        }
        field(25006392; "Applies-to Veh. Cycle No."; Code[20])
        {
            Caption = 'Applies-to Veh. Cycle No.';
        }
        field(25006578; "Include In Veh. Sales Amt."; Boolean)
        {
            Caption = 'Include In Veh. Sales Amt.';
        }
        field(25006600; "Rent Order No."; Code[20])
        {
            Caption = 'Rent Order No.';
            Description = 'Only for Rent';
        }
        field(25006601; "Rent Order Line No."; Integer)
        {
            Caption = 'Rent Order Line No.';
        }
        field(25006602; "Rent Item No."; Code[20])
        {
            Caption = 'Rent Item No.';
        }
        field(25006603; "Rent Order Sales Line No."; Integer)
        {
            Caption = 'Rent Order Sales Line No.';
            DataClassification = ToBeClassified;
        }
        field(25006604; "Rent Asset No."; Code[20])
        {
            Caption = 'Rent Asset No.';
            DataClassification = ToBeClassified;
        }
        field(25006605; "Rent Start Date"; Date)
        {
            Caption = 'Rent Start Date';
            DataClassification = ToBeClassified;
        }
        field(25006606; "Rent End Date"; Date)
        {
            Caption = 'Rent End Date';
            DataClassification = ToBeClassified;
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
            end;
        }
        field(25006700; "Ordering Price Type Code"; Code[10])
        {
            Caption = 'Ordering Price Type Code';
            TableRelation = "Ordering Price Type";

            trigger OnValidate()
            var
                OrderingPriceType: Record "Ordering Price Type";
                lSalesHeader: record "sales header";
            begin
                lSalesHeader.get("document type", "document no.");
                UpdateUnitPrice(FieldNo("Ordering Price Type Code"));

                if OrderingPriceType.Get("Ordering Price Type Code") then
                    Validate("Shipping Time", OrderingPriceType."Outbound Time")
                else
                    Validate("Shipping Time", lSalesHeader."Shipping Time");
            end;
        }
        field(25006730; "Print in Order"; Boolean)
        {
            Caption = 'Print in Order';
        }
        field(25006740; "Backorder Date"; Date)
        {
            Caption = 'Backorder Date';
        }
        field(25006800; "Variable Field 25006800"; Code[20])
        {
            CaptionClass = '7,37,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookUpMgt.LookUpVariableField(VFOptions, Database::"Sales Line", FieldNo("Variable Field 25006800"),
                  "Make Code", "Variable Field 25006800") then begin
                    Validate("Variable Field 25006800", VFOptions.Code);
                end;
            end;
        }
        field(25006801; "Variable Field 25006801"; Code[20])
        {
            CaptionClass = '7,37,25006801';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookUpMgt.LookUpVariableField(VFOptions, Database::"Sales Line", FieldNo("Variable Field 25006801"),
                  "Make Code", "Variable Field 25006801") then begin
                    Validate("Variable Field 25006801", VFOptions.Code);
                end;
            end;
        }
        field(25006802; "Variable Field 25006802"; Code[20])
        {
            CaptionClass = '7,37,25006802';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookUpMgt.LookUpVariableField(VFOptions, Database::"Sales Line", FieldNo("Variable Field 25006802"),
                  "Make Code", "Variable Field 25006802") then begin
                    Validate("Variable Field 25006802", VFOptions.Code);
                end;
            end;
        }
        field(25006996; "Variable Field Run 2"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,37,25006996';
        }
        field(25006997; "Variable Field Run 3"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,37,25006997';
        }
        field(25006998; "Has Replacement"; Boolean)
        {
            Caption = 'Has Replacement';
        }
        field(25006999; "Requested Item No."; Code[20])
        {
            Caption = 'Requested Item No.';
        }
        field(25006850; "Leasing Schedule No."; Code[20])
        {
            Caption = 'Leasing Schedule No.';
        }
        field(25006851; "Leasing Schedule Line No."; Integer)
        {
            Caption = 'Leasing Schedule Line No.';
        }
    }

    keys
    {

        key(Key20; "Document Profile")
        {
        }
        /*
        key(Key21; Type, "Line Type", "Vehicle Serial No.", "Vehicle Accounting Cycle No.")
        {
        } */
        key(Key22; "Vehicle Serial No.", "Vehicle Assembly ID")
        {
        }
        key(Key23; "Rent Order No.", "Rent Order Sales Line No.")
        {
        }
        /* TO vrify 
        key(Key25; "Document Type", Type, "No.", "Variant Code", "Drop Shipment", "Location Code", "Shipment Date")
        {
            SumIndexFields = "Outstanding Qty. (Base)", Quantity;
        }*/
    }

    procedure AutoReserveVehicle()
    var
        QtyToReserve: Decimal;
        QtyToReservebase: Decimal;
    begin
        TestField("Line Type", "line type"::Vehicle);
        TestField("Vehicle Serial No.");

        if VehReserveSalesLine.ReservQuantity(Rec) <> 0 then begin
            VehReservMgt.SetSalesLine(Rec);
            TestField("Shipment Date");

            // 26.10.2012 EDMS >>
            ReserveSalesLine.ReservQuantity(Rec, QtyToReserve, QtyToReservebase);
            VehReservMgt.AutoReserve(FullAutoReservation, '', QtyToReserve);
            // 26.10.2012 EDMS <<

            Find;
            if not FullAutoReservation then begin
                Commit;
                if Confirm(Text104, true) then begin
                    ShowVehReservation;
                    Find;
                end;
            end;
        end;
    end;

    procedure ShowVehReservation()
    var
        VehReservation: Page "Vehicle Reservation";
    begin
        TestField("Line Type", "line type"::Vehicle);
        TestField("No.");
        //TESTFIELD(Reserve);
        Clear(VehReservation);
        VehReservation.SetSalesLine(Rec);
        VehReservation.RunModal;
    end;

    procedure NewAccCycleNo()
    var
        recInvSetup: Record "Inventory Setup";
        cuNoSeriesMgt: Codeunit "No. Series";
        codCycleNo: Code[20];
        recVehAccCycle: Record "Vehicle Accounting Cycle";
        cuVehAccCycle: Codeunit VehicleAccountingCycleMgt;
    begin
        //DMS
        if "Line Type" <> "line type"::Vehicle then
            exit;

        TestField("Vehicle Serial No.");

        codCycleNo := cuVehAccCycle.GetNewCycleNo;

        recVehAccCycle.Init;
        recVehAccCycle."No." := codCycleNo;
        recVehAccCycle.Validate("Vehicle Serial No.", "Vehicle Serial No.");
        recVehAccCycle.Validate(Default, true);
        recVehAccCycle.Insert(true);

        Validate("Vehicle Accounting Cycle No.", codCycleNo);
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

    procedure GetVehUnitCost_ILE(): Decimal
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        //03.06.2013 Elva Baltic P15
        rec.GetItem(Item);
        ItemLedgerEntry.Reset;
        ItemLedgerEntry.SetRange("Item No.", Item."No.");
        ItemLedgerEntry.SetRange("Serial No.", "Vehicle Serial No.");
        ItemLedgerEntry.SetRange(Open, true);
        if ItemLedgerEntry.FindFirst then begin
            ItemLedgerEntry.CalcFields("Cost Amount (Actual)");
            exit(ItemLedgerEntry."Cost Amount (Actual)");
        end else
            exit(0);
    end;

    procedure NewSerialNo()
    var
        InvSetup: Record "Inventory Setup";
        NoSeries: Codeunit "No. Series";
        SerialNo: Code[20];
    begin
        //EDMS
        if "Line Type" = "line type"::Vehicle then begin
            InvSetup.Get;
            InvSetup.TestField("Vehicle Serial No. Nos.");
            Validate("Vehicle Serial No.", NoSeries.GetNextNo(InvSetup."Vehicle Serial No. Nos.", WorkDate(), true));
        end;
    end;


    procedure RegLostSales()
    var
        LostSalesRegItem: Page "Register Item Lost Sale";
    begin
        Clear(LostSalesRegItem);
        if Type = Type::Item then
            LostSalesRegItem.SetItem("No.");
        LostSalesRegItem.SetCustomer("Sell-to Customer No.");
        LostSalesRegItem.SetLocationCode("Location Code");
        LostSalesRegItem.LookupMode(TRUE);
        LostSalesRegItem.RunModal();
    end;

    procedure UpdateUnitPrice2()
    begin
        UpdateUnitPrice(0);
        UpdateAmounts;
    end;

    procedure GetVehicleAssemblyFromPurchase()
    var
        PurchaseLine: Record "Purchase Line";
    begin
        PurchaseLine.Reset;
        PurchaseLine.SetRange("Vehicle Serial No.", "Vehicle Serial No.");
        if PurchaseLine.FindFirst then
            if PurchaseLine."Vehicle Assembly ID" <> '' then
                "Vehicle Assembly ID" := PurchaseLine."Vehicle Assembly ID";
    end;

    procedure DeleteVehItemTrackingLine(LocationCode: Code[20])
    var
        ReservationEntry: Record "Reservation Entry";
    begin
        ReservationEntry.Reset;
        ReservationEntry.SetCurrentkey("Item No.", "Variant Code", "Location Code");
        ReservationEntry.SetRange("Item No.", "No.");
        ReservationEntry.SetRange("Reservation Status", ReservationEntry."reservation status"::Surplus);
        ReservationEntry.SetRange("Location Code", LocationCode);
        ReservationEntry.SetRange("Source Type", Database::"Sales Line");
        ReservationEntry.SetRange("Source ID", "Document No.");
        ReservationEntry.SetRange("Source Ref. No.", "Line No.");
        ReservationEntry.SetRange("Serial No.", "Vehicle Serial No.");
        if ReservationEntry.FindFirst then
            ReservationEntry.Delete(true);
    end;

    procedure CheckItemAvailabilityOnValidateSalesLineQty(DoNotCheckCurrField: Boolean; DoNotCheckItemAvailDone: Boolean) InteruptValidateTrigger: Boolean
    var
        Location: Record Location;
        Options: Text[250];
        SelectedOption: Integer;
        QtyLocation: Decimal;
        QtySum: Decimal;
        i: Integer;
        LocationArr: array[50] of Code[20];
        ServiceTransferMgt: Codeunit "Service Transfer Mgt.";
        ItemLocationQtyBuffer: Record "Item Location Qty. Buffer" temporary;
        ChoseItemLocQtyDialog: Page "Chose Item Loc. Qty. Dialog";
        ItemLocationQtyBufferSelected: Record "Item Location Qty. Buffer" temporary;
        SalesLineToCreate: Record "Sales Line";
        SalesLineNo: Integer;
        ItemInventory: Record Item;
        ItemSubstSync: Codeunit "Item Substitution Sync";
        SourceCodeSetup: Record "Source Code Setup";
        ItemJournalLine: Record "Item Journal Line";
        ItemAddInfo: Record Item;

        AvailabilityDate: Date;
    begin
        SalesSetup.Get;
        if not SalesSetup."Enable Stock Avail. Selection" then
            exit;
        if Type <> Type::Item then
            exit;
        if not (CurrFieldNo = Rec.FieldNo(Quantity)) and not DoNotCheckCurrField then
            exit;
        if CheckItemAvailabilityDone and not DoNotCheckItemAvailDone then
            exit;

        CheckItemAvailabilityDone := true;

        ItemLocationQtyBuffer.DeleteAll;
        if (ServiceTransferMgt.GetItemAvailableQtyOnLocation(Rec, Rec."Location Code") < Rec.Quantity) or (ServiceTransferMgt.GetItemAvailableQtyOnLocation(Rec, Rec."Location Code") = 0) then begin
            //Check Item Qty on other locations
            Location.Reset;
            Location.SetRange("Use As Parts Location Code", true);
            if Location.FindFirst then
                repeat
                    QtyLocation := ServiceTransferMgt.GetItemAvailableQtyOnLocation(Rec, Location.Code);
                    if (QtyLocation > 0) or (Location.Code = Rec."Location Code") then begin
                        if Rec."Shipment Date" <> 0D then
                            AvailabilityDate := Rec."Shipment Date"
                        else
                            AvailabilityDate := WorkDate;
                        ItemAddInfo.Reset;
                        ItemAddInfo.SetRange("No.", Rec."No.");
                        ItemAddInfo.SetRange("Date Filter", 0D, AvailabilityDate);
                        ItemAddInfo.SetRange("Variant Filter", Rec."Variant Code");
                        ItemAddInfo.SetRange("Location Filter", Location.Code);
                        ItemLocationQtyBuffer.Init;
                        ItemLocationQtyBuffer."Location Code" := Location.Code;
                        ItemLocationQtyBuffer."Location Description" := Location.Name;
                        ItemLocationQtyBuffer."Available Quantity" := QtyLocation;
                        if (Location.Code = Rec."Location Code") then
                            ItemLocationQtyBuffer."Selected Quantity" := Rec.Quantity
                        else
                            ItemLocationQtyBuffer."Selected Quantity" := 0;
                        ItemLocationQtyBuffer."Item No." := Rec."No.";
                        ItemLocationQtyBuffer.Inventory := ItemAddInfo.Inventory;
                        ItemLocationQtyBuffer."Reserved Qty. on Inventory" := ItemAddInfo."Reserved Qty. on Inventory";
                        ItemLocationQtyBuffer.Insert;
                        if QtyLocation > 0 then
                            QtySum += QtyLocation;
                    end;
                until Location.Next = 0;

            if QtySum > 0 then begin
                SalesLineToCreate.Reset;
                SalesLineToCreate.SetRange("Document No.", Rec."Document No.");
                SalesLineToCreate.SetRange("Document Type", Rec."Document Type");
                SalesLineToCreate.SetCurrentkey("Line No.");
                if SalesLineToCreate.FindLast then
                    SalesLineNo := SalesLineToCreate."Line No.";

                ChoseItemLocQtyDialog.AddDialogData(ItemLocationQtyBuffer);
                if ChoseItemLocQtyDialog.RunModal = Action::OK then begin
                    ChoseItemLocQtyDialog.GetDialogData(ItemLocationQtyBufferSelected);
                    if ItemLocationQtyBufferSelected.FindFirst then
                        repeat
                            if ItemLocationQtyBufferSelected."Selected Quantity" > 0 then begin
                                i += 1;
                                if i = 1 then begin
                                    SalesLineNo := SalesLineNo + 10000;

                                    Rec.Validate("Location Code", ItemLocationQtyBufferSelected."Location Code");
                                    Rec.Validate(Quantity, ItemLocationQtyBufferSelected."Selected Quantity");
                                    //06.12.2016 EB.RC POD.DMS.Parts P439.EXTRAPAR12 >>
                                    xRec."Location Code" := Rec."Location Code"; //Workaround for buggy standard code.
                                                                                 //06.12.2016 EB.RC POD.DMS.Parts P439.EXTRAPAR12 <<
                                    InteruptValidateTrigger := true;
                                end else begin
                                    SalesLineNo := SalesLineNo + 10000;
                                    SalesLineToCreate.Init;
                                    SalesLineToCreate := Rec;
                                    SalesLineToCreate.Validate("Location Code", ItemLocationQtyBufferSelected."Location Code");
                                    SalesLineToCreate.Validate(Quantity, ItemLocationQtyBufferSelected."Selected Quantity");
                                    SalesLineToCreate."Line No." := SalesLineNo;
                                    SalesLineToCreate.Insert;
                                end;
                            end;
                        //MESSAGE(ItemLocationQtyBufferSelected."Location Code"+'-'+FORMAT(ItemLocationQtyBufferSelected."Selected Quantity"));
                        until ItemLocationQtyBufferSelected.Next = 0;
                end;
            end;
        end;
        Commit;


        //14.11.2016 EB.RC POD.DMS.Parts P439.IM19 >>
        SourceCodeSetup.Get;
        ItemJournalLine.Reset;
        ItemJournalLine.SetRange("Item No.", Rec."No.");
        ItemJournalLine.SetRange("Location Code", Rec."Location Code");
        ItemJournalLine.SetRange("Source Code", SourceCodeSetup."Phys. Inventory Journal");
        if ItemJournalLine.FindFirst then
            Message(Text129);
        //14.11.2016 EB.RC POD.DMS.Parts P439.IM19 <<
    end;

    procedure ApplyMarkupRestrictions(ActionType: Integer)
    var
        CurrencyExch: Record "Currency Exchange Rate";
        LineSalesPrice: Decimal;
        LineCost: Decimal;
        Item: Record Item;
        LineMarkupPercent: Decimal;
        UserSetup: Record "User Setup";
        ItemMarkupRestriction: Record "Item Markup Restriction";
        TextPercent: label '%';
        TextMarkupRestriced: label 'Item No. %1 must have at least %2 %3 markup.';
        ItemMarkupRestrictionGroup: Record "Item Markup Restriction Group";
        ItemLedgEntry: Record "Item Ledger Entry";
        ReservationEntry: Record "Reservation Entry";
        ReservationEntry2: Record "Reservation Entry";
        ItemCost2: Decimal;
        lSalesHeader: Record "Sales Header";
    begin
        //ActioType = 0 => Value validation
        //ActioType = 1 => Document Release

        if (Type <> Type::Item) or ("Quantity (Base)" = 0) then
            exit;

        if "Document Profile" = "document profile"::"Vehicles Trade" then
            exit;

        if "No." = '' then
            exit;

        lSalesHeader.GET("Document Type", "Document No.");       // 07/12/2017 P30 GP1
        //GetSalesHeader;                                           // 07/12/2017 P30 GP1

        if not UserSetup.Get(UserId) then
            exit;
        if UserSetup."Item Markup Restriction Group" = '' then
            exit;

        ItemMarkupRestriction.Reset;
        ItemMarkupRestriction.SetFilter("Group Code", '%1|''''', UserSetup."Item Markup Restriction Group");
        ItemMarkupRestriction.SetFilter("Customer Price Group", '%1|''''', "Customer Price Group");
        ItemMarkupRestriction.SetFilter("Item Category Code", '%1|''''', "Item Category Code");
        if ItemMarkupRestriction.IsEmpty then
            exit;



        LineCost := 0;

        case ItemMarkupRestriction.Base of
            ItemMarkupRestriction.Base::"Unit Cost":
                begin

                    //02.07.2008. EDMS P2 >>
                    if "Appl.-to Item Entry" <> 0 then begin
                        ItemLedgEntry.Get("Appl.-to Item Entry");
                        ItemLedgEntry.CalcFields("Cost Amount (Actual)");
                        LineCost := ItemLedgEntry."Cost Amount (Actual)" / ItemLedgEntry.Quantity;
                    end else begin
                        CalcFields("Reserved Quantity");
                        if "Reserved Quantity" <> 0 then begin
                            ReservationEntry.Reset;
                            ReservationEntry.SetCurrentkey("Source ID", "Source Ref. No.");
                            ReservationEntry.SetRange("Source ID", "Document No.");
                            ReservationEntry.SetRange("Source Ref. No.", "Line No.");
                            ReservationEntry.SetRange("Source Type", Database::"Sales Line");
                            ItemCost2 := 0;
                            if ReservationEntry.FindFirst then
                                repeat
                                    ReservationEntry2.Get(ReservationEntry."Entry No.", not ReservationEntry.Positive);
                                    if ReservationEntry2."Source Type" = Database::"Item Ledger Entry" then begin
                                        ItemLedgEntry.Get(ReservationEntry2."Source Ref. No.");
                                        ItemLedgEntry.CalcFields("Cost Amount (Actual)");
                                        if ItemCost2 < ItemLedgEntry."Cost Amount (Actual)" / ItemLedgEntry.Quantity then
                                            ItemCost2 := ItemLedgEntry."Cost Amount (Actual)" / ItemLedgEntry.Quantity;
                                    end;
                                until ReservationEntry.Next = 0;
                            LineCost := ItemCost2;
                        end;
                        if Item.Get("No.") and (LineCost = 0) then
                            LineCost := Item."Unit Cost";
                    end;
                    //28.02.2008. EDMS P2 <<

                    if "Currency Code" <> '' then
                        LineSalesPrice := "Line Amount" / lSalesHeader."Currency Factor" / "Quantity (Base)"
                    else
                        LineSalesPrice := "Line Amount" / "Quantity (Base)";

                end;
        end;

        LineCost := ROUND(LineCost, 0.01, '<');
        if LineCost = 0 then
            exit;

        //Calculating Sales Price
        if lSalesHeader."Prices Including VAT" then
            LineSalesPrice := ROUND(LineSalesPrice / (1 + "VAT %" / 100), 0.00001);

        //Apr??inam uzcenojumu
        LineMarkupPercent := 0;
        if LineCost <> 0 then
            LineMarkupPercent := (LineSalesPrice - LineCost) / LineCost * 100;

        case ActionType of
            0: //validation
                begin
                    if LineMarkupPercent < ItemMarkupRestriction."Min. Markup %" then
                        Message(TextMarkupRestriced, "No.", ItemMarkupRestriction."Min. Markup %", TextPercent);
                end;
            1: //release
                begin
                    if LineMarkupPercent < ItemMarkupRestriction."Min. Markup %" then
                        Message(TextMarkupRestriced, "No.", ItemMarkupRestriction."Min. Markup %", TextPercent);
                end;
        end;
    end;

    procedure CheckVehicleDiscount()
    var
        SingleInstanceMgt: Codeunit SingleInstanceManagement;
        UserProfile: Record "Branch Profile Setup";
        UserProfileMgt: Codeunit UserProfileManagement;
    begin
        UserProfile.Reset;
        if UserProfile.Get(UserProfileMgt.CurrProfileID, UserProfileMgt.CurrBranchNo) then
            if UserProfile."Vehicle Sales Disc. Check" then
                if "Line Discount %" > UserProfile."Vehicle Max Sales Disc.%" then
                    Error(Text102, FieldCaption("Line Discount %"), UserProfile."Vehicle Max Sales Disc.%");
    end;

    procedure CheckDiscount()
    var
        SalesDiscount: Record "SP Sales Disc. Group Items";
        Ishandled: Boolean;
        errorexit: Boolean;
    begin
        if not (Type in [Type::Item]) then
            exit;
        errorexit := true;
        if UserSetup.Get(UserId) then begin
            if UserSetup."SP Sales Disc. Group Code" <> '' then begin
                SalesDiscount.Reset;
                SalesDiscount.SetRange("Sales Disc. Group Code", UserSetup."SP Sales Disc. Group Code");
                SalesDiscount.SetRange(Type, SalesDiscount.Type::"Item Category");
                OnbeforefilterCheckDiscount(rec, SalesDiscount, Ishandled);
                if not Ishandled then
                    SalesDiscount.SetFilter("No.", '%1|%2', '', "Item Category Code");
                if SalesDiscount.FindLast then begin
                    OnbeforeCheckDiscount(rec, SalesDiscount, errorexit);
                    if errorexit then
                        if "Line Discount %" > SalesDiscount."Max. Discount %" then
                            Error(Text102, FieldCaption("Line Discount %"), SalesDiscount."Max. Discount %");
                end;
            end;
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
        //DMS
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
                        "line type"::"Charge (Item)":
                            begin
                                recItemCharge.Reset;
                                if LookUpMgt.LookUpItemCharges_Sale(recItemCharge, "No.") then
                                    Validate("No.", recItemCharge."No.");
                            end;
                        "line type"::"G/L Account":
                            begin
                                recGLAccount.Reset;
                                if LookUpMgt.LookUpGLAccount(recGLAccount, "No.") then
                                    Validate("No.", recGLAccount."No.");
                            end;
                        "line type"::Item:
                            begin
                                recItem.Reset;
                                if LookUpMgt.LookUpModelVersion(recItem, "No.", "Make Code", "Model Code") then
                                    Validate("No.", recItem."No.");
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
                                if LookUpMgt.LookUpItemCharges_Sale(recItemCharge, "No.") then
                                    Validate("No.", recItemCharge."No.");
                            end;
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
                            if LookUpMgt.LookUpItemCharges_Sale(recItemCharge, "No.") then
                                Validate("No.", recItemCharge."No.");
                        end;
                end;
            end;
        end
    end;

    procedure VehicleAssembly()
    var
        VehicleAssemby: Record "Vehicle Assembly Line";
        VehAssemblyWorksheet: Page "Vehicle Assembly Worksheet";
        InvSetup: Record "Inventory Setup";
        NoSeries: Codeunit "No. Series";
        VehOptMgt: Codeunit VehicleOptionManagement;
        lSalesHeader: Record "Sales Header";
        CurrencyDate: Date;
    begin
        if "Line Type" <> "line type"::Vehicle then
            exit;

        TestField("No.");
        TestField("Vehicle Serial No.");
        TestField("Make Code");
        TestField("Model Code");
        TestField("Model Version No.");

        if "Vehicle Assembly ID" = '' then
            NewVehAssemblyNo;

        VehPriceMgt.ChkAssemblyHdrSalesLine(Rec, false);
        VehOptMgt.FillVehAssembly("Vehicle Serial No.", "Vehicle Assembly ID",
          "Make Code", "Model Code", "Model Version No.");

        //GetSalesHeader;
        lSalesHeader.GET("Document Type", "Document No.");
        Commit;

        VehicleAssemby.SetRange("Assembly ID", "Vehicle Assembly ID");
        VehicleAssemby.SetRange("Make Code", "Make Code");
        VehicleAssemby.SetRange("Model Code", "Model Code");
        VehicleAssemby.SetRange("Model Version No.", "Model Version No.");
        VehicleAssemby.SetRange("Serial No.", "Vehicle Serial No.");

        Clear(VehAssemblyWorksheet);

        if lSalesHeader."Document Type" = lSalesHeader."document type"::Quote then
            CurrencyDate := lSalesHeader."Document Date"
        else
            CurrencyDate := lSalesHeader."Posting Date";

        VehAssemblyWorksheet.SetFCY(lSalesHeader."Currency Code", CurrencyDate, lSalesHeader."Currency Factor");
        VehAssemblyWorksheet.SetTableview(VehicleAssemby);
        VehAssemblyWorksheet.LookupMode(true);
        VehAssemblyWorksheet.RunModal;
    end;

    procedure VehApplyToPurch()
    var
        recPurchLine: Record "Purchase Line";
        recSalesLine: Record "Sales Line";
    begin
        TestStatusOpen;
        TestField("Line Type", "line type"::Vehicle);

        recPurchLine.Reset;
        recPurchLine.SetCurrentkey("Document Profile");
        recPurchLine.SetRange("Document Profile", recPurchLine."document profile"::"Vehicles Trade");
        recPurchLine.SetRange("Line Type", recPurchLine."line type"::Vehicle);

        if "Make Code" <> '' then
            recPurchLine.SetRange("Make Code", "Make Code");
        if "Model Code" <> '' then
            recPurchLine.SetRange("Model Code", "Model Code");
        if "Model Version No." <> '' then
            recPurchLine.SetRange("Model Version No.", "Model Version No.");

        if VIN <> '' then
            recPurchLine.SetRange("Vehicle Serial No.", "Vehicle Serial No.");

        if "Vehicle Assembly ID" <> '' then
            recPurchLine.SetFilter("Vehicle Assembly ID", '<>''''');


        if Page.RunModal(Page::"Apply Sales to Purchase Line", recPurchLine) = Action::LookupOK then begin
            //10.06.2008. EDMS P2 >>
            if "Vehicle Serial No." = '' then
                Validate("Vehicle Serial No.", recPurchLine."Vehicle Serial No.");
            if "Make Code" = '' then
                Validate("Make Code", recPurchLine."Make Code");
            if "Model Code" = '' then
                Validate("Model Code", recPurchLine."Model Code");
            if "Model Version No." = '' then
                Validate("Model Version No.", recPurchLine."Model Version No.");

            Validate("Vehicle Accounting Cycle No.", recPurchLine."Vehicle Accounting Cycle No.");
            //10.06.2008. EDMS P2 <<

            Validate("Vehicle Assembly ID", recPurchLine."Vehicle Assembly ID");
        end;
    end;

    procedure GetStat(): Text[30]
    var
        recResEntry: Record "Reservation Entry";
        recResEntry2: Record "Reservation Entry";
        recResEntry3: Record "Reservation Entry";
        InStock: Decimal;
    begin
        if Quantity = 0 then exit;
        CalcFields("Reserved Quantity");
        if "Reserved Quantity" = 0 then
            exit(tcSER001);
        recResEntry.Reset;
        recResEntry.SetCurrentkey
        ("Item No.", "Source Type", "Source Subtype", "Reservation Status", "Location Code", "Variant Code", "Shipment Date",
         "Expected Receipt Date", "Serial No.", "Lot No.");
        recResEntry.SetRange("Source Type", Database::"Sales Line");
        recResEntry.SetRange("Source Subtype", "Document Type");
        recResEntry.SetRange("Source ID", "Document No.");
        recResEntry.SetRange("Source Ref. No.", "Line No.");
        recResEntry.SetRange("Reservation Status", recResEntry."reservation status"::Reservation);

        if not recResEntry.IsEmpty then begin
            recResEntry.Reset;
            recResEntry.SetRange(Positive, true);
            recResEntry.SetRange("Entry No.", recResEntry."Entry No.");
            if recResEntry.FindFirst then begin
                if "Reserved Quantity" = recResEntry.Quantity then begin
                    case recResEntry."Source Type" of
                        Database::"Requisition Line":
                            exit(tcSER002);
                        Database::"Purchase Line":
                            exit(tcSER003);
                        Database::"Item Ledger Entry":
                            if "Customer Notification Date" = 0D then
                                exit(tcSER004)
                            else
                                exit(tcSER005);
                    end;
                end else begin
                    InStock := 0;
                    //30.10.2007. EDMS P2 >>
                    recResEntry3.Reset;
                    recResEntry3.SetCurrentkey
                     ("Item No.", "Source Type", "Source Subtype", "Reservation Status", "Location Code", "Variant Code", "Shipment Date",
                     "Expected Receipt Date", "Serial No.", "Lot No.");
                    recResEntry3.SetRange("Source Type", 37);
                    recResEntry3.SetRange("Source Subtype", "Document Type");
                    recResEntry3.SetRange("Source ID", "Document No.");
                    recResEntry3.SetRange("Source Ref. No.", "Line No.");
                    recResEntry3.SetRange("Reservation Status", recResEntry."reservation status"::Reservation);
                    if recResEntry3.FindSet then
                        repeat
                            if recResEntry2.Get(recResEntry3."Entry No.", true) and
                               (recResEntry2."Source Type" = Database::"Item Ledger Entry")
                            then
                                InStock += recResEntry2.Quantity;
                        until recResEntry3.Next = 0;

                    if InStock = "Reserved Quantity" then begin
                        //30.10.2007. EDMS P2 <<
                        if "Customer Notification Date" = 0D then
                            exit(tcSER004)
                        else
                            exit(tcSER005);
                    end else
                        if InStock = 0 then
                            exit(tcSER003)
                        else
                            exit(tcSER006);
                end;
            end;
        end;
    end;


    procedure VehTradeIn()
    var
        VehTradeInMgt: Codeunit "Veh.Trade-In Mgt.";
    begin
        VehTradeInMgt.ApplyTradeIn(Rec)
    end;


    procedure NoAssistEdit()
    var
        NonstockItem: Record "Nonstock Item";
        NonstockItemMgt: Codeunit "Catalog Item Management";
    begin
        //EDMS
        if Type = Type::Item then begin

            //20.08.2008. EDMS P2 >>
            CurrFieldNo := FieldNo("No.");
            //20.08.2008. EDMS P2 <<

            NonstockItem.Reset;
            if LookUpMgt.LookUpNonstockItem(NonstockItem, "No.") then begin
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



    procedure ApplyDealDocuments()
    var
        DealDocApplication: Page "Deal Document Application";
    begin
        //EDMS P3
        DealDocApplication.SetApplication(1, 0, "Document Type", "Document No.", "Line No.");

        DealDocApplication.RunModal
    end;

    procedure AutoReserve2()
    var
        QtyToReserve: Decimal;
        QtyToReserveBase: Decimal;
        //ReservMgt: Codeunit "Reservation Management";
        ReservationMgtEDMS: Codeunit "Reservation Management EDMS";
    begin
        TestField(Type, Type::Item);
        TestField("No.");

        // 26.10.2012 EDMS >>
        ReserveSalesLine.ReservQuantity(Rec, QtyToReserve, QtyToReserveBase);

        if (QtyToReserve <> 0) then begin
            // 26.10.2012 EDMS <<

            //ReservMgt.SetSalesLine(Rec);
            ReservationMgtEDMS.SetReservSource(Rec);
            TestField("Shipment Date");

            // 26.10.2012 EDMS >>
            ReserveSalesLine.ReservQuantity(Rec, QtyToReserve, QtyToReserveBase);
            ReservationMgtEDMS.AutoReserve(FullAutoReservation, '', "Shipment Date", QtyToReserve, QtyToReserveBase);
            // 26.10.2012 EDMS <<

            Find;
        end;
    end;

    procedure AutoReserveSilent()
    var
        QtyToReserve: Decimal;
        QtyToReserveBase: Decimal;
        //ReservMgt: Codeunit "Reservation Management";
        ReservationMgtEDMS: Codeunit "Reservation Management EDMS";
    begin
        TestField(Type, Type::Item);
        TestField("No.");

        // 26.10.2012 EDMS >>
        ReserveSalesLine.ReservQuantity(Rec, QtyToReserve, QtyToReserveBase);

        if (QtyToReserve <> 0) then begin
            // 26.10.2012 EDMS <<
            //ReservMgt.SetSalesLine(Rec);
            ReservationMgtEDMS.SetReservSource(Rec);
            TestField("Shipment Date");
            // 26.10.2012 EDMS >>
            ReservationMgtEDMS.AutoReserve(FullAutoReservation, '', "Shipment Date", QtyToReserve, QtyToReserveBase);
            // 26.10.2012 EDMS <<
            Find;
        end;
    end;

    procedure ShowVehReservationEntries(Modal: Boolean)
    var
        VehReservEngineMgt: Codeunit "Veh. Reservation Engine Mgt.";
        VehReserveSalesLine: Codeunit "Sales Line-Veh. Reserve";
        VehReservEntry: Record "Vehicle Reservation Entry";
    begin
        TestField("Line Type", "line type"::Vehicle);
        TestField("No.");
        VehReservEngineMgt.InitFilterAndSortingLookupFor(VehReservEntry);
        VehReserveSalesLine.FilterReservFor(VehReservEntry, Rec);
        if Modal then
            Page.RunModal(Page::"Vehicle Reservation Entries", VehReservEntry)
        else
            Page.Run(Page::"Vehicle Reservation Entries", VehReservEntry);
    end;



    procedure TransferLinePrepayment()
    var
        // PrepMgt: Codeunit "Prepayment Mgt.";
        ApplicationEventManagement: Codeunit "Application Event Management";
    begin
        TestField("Document No.");
        TestField("No.");
        TestField("Prepmt. Line Amount");
        // PrepMgt.SalesTranfLinePrep(Rec);
        ApplicationEventManagement.SalesTranfLinePrep(Rec);
    end;


    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::"Sales Line", intFieldNo));
    end;


    procedure MoveLines(var SalesLineRec: Record "Sales Line")
    var
        EDMS001: label '%1 lines will be processed.\Do you want to proceed?';
    begin
        TestStatusOpen;
        if SalesLineRec.Count = 0 then
            exit;

        if Confirm(EDMS001, false, SalesLineRec.Count) then
            Report.RunModal(Report::"Sales Order-Transfer Line", true, false, SalesLineRec);
    end;

    procedure GetReservationColor(): Text[20]
    var
        ResEntry: Record "Reservation Entry";
    begin
        //28.03.2014 Elva Baltic P1 #RX MMG7.00

        FilterSalesLineRes(ResEntry);

        if ResEntry.IsEmpty then
            exit('None');

        ResEntry.SetRange("Source Type", 246);
        if ResEntry.FindFirst then
            exit('StrongAccent');

        ResEntry.SetFilter("Source Type", '%1|%2', 39, 5741);
        if ResEntry.FindFirst then
            exit('Ambiguous');

        ResEntry.SetRange("Source Type", 32);
        if ResEntry.FindFirst then
            exit('Favorable');
    end;

    procedure FilterSalesLineRes(var FilteredResEntry: Record "Reservation Entry")
    var
        ResEntryNegative: Record "Reservation Entry";
        ResEntryTransferOutg: Record "Reservation Entry";
    begin
        //27.03.2014 Elva Baltic P1 #RX MMG7.00

        ResEntryNegative.Reset;
        ResEntryNegative.SetCurrentkey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
        ResEntryNegative.SetRange("Source ID", "Document No.");
        ResEntryNegative.SetRange("Source Ref. No.", "Line No.");
        ResEntryNegative.SetRange("Source Type", Database::"Sales Line");
        ResEntryNegative.SetRange("Source Subtype", 1);
        ResEntryNegative.SetRange("Reservation Status", ResEntryNegative."reservation status"::Reservation);
        if ResEntryNegative.FindFirst then
            repeat
                FilteredResEntry.Get(ResEntryNegative."Entry No.", true);
                FilteredResEntry.Mark(true);
            until ResEntryNegative.Next = 0;
        FilteredResEntry.MarkedOnly(true)
    end;

    procedure CreateVehicle()
    var
        VINInput: Page "Create Vehicle-Interactive";
        Vehicle: Record Vehicle;
        NewVIN: Code[20];
        Vehicle2: Record Vehicle;
        SalesLine: Record "Sales Line";
        tcAMT001: label 'VIN %1 already exists.';
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
        //IF NewVIN = '' THEN
        // EXIT;

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

    procedure ChangeVehicle()
    var
        ChooseVehicle: Page "Vehicle List";
        Vehicle: Record Vehicle;
        VehAssemblyLine: Record "Vehicle Assembly Line";
        VehAssemblyHeader: Record "Vehicle Assembly Header";
        OldVehicleSerialNo: Code[20];
    begin
        TestField("Make Code");
        TestField("Model Code");
        TestField("Model Version No.");

        OldVehicleSerialNo := "Vehicle Serial No.";

        Vehicle.Reset();
        Vehicle.SetRange("Make Code", "Make Code");
        Vehicle.SetRange("Model Code", "Model Code");
        Vehicle.SetRange("Model Version No.", "Model Version No.");
        //Vehicle.SetFilter(Inventory, '>%1', 0);

        ChooseVehicle.SetTableView(Vehicle);
        ChooseVehicle.LookupMode(true);
        ChooseVehicle.Editable(false);
        if ChooseVehicle.RunModal = ACTION::LookupOK then begin
            ChooseVehicle.GetRecord(Vehicle);

            Vehicle.CalcFields("Default Vehicle Acc. Cycle No.", Reserved);

            if Vehicle.Reserved then begin
                if not Dialog.CONFIRM(VehIsReservedPrmt, false) then
                    exit;
            end;

            //Update sales line
            "Vehicle Serial No." := Vehicle."Serial No.";
            "Vehicle Registration No." := Vehicle."Registration No.";
            VIN := Vehicle.VIN;
            "Vehicle Accounting Cycle No." := Vehicle."Default Vehicle Acc. Cycle No.";
            Modify();

            //Update assembly
            VehAssemblyLine.Reset;
            VehAssemblyLine.SetRange("Serial No.", OldVehicleSerialNo);
            VehAssemblyLine.SetRange("Assembly ID", "Vehicle Assembly ID");
            if VehAssemblyLine.FindFirst() then
                repeat
                    VehAssemblyLine.Rename(Vehicle."Serial No.", VehAssemblyLine."Assembly ID", VehAssemblyLine."Line No.");
                until VehAssemblyLine.Next() = 0;
        end;
    end;


    procedure ApplyVehMarginalVAT()
    var
        SalesLineMargVAT: Record "Sales Line";
        PurchaseAmount: Decimal;
        SalesAmount: Decimal;
        ItemLedgerEntry: Record "Item Ledger Entry";
        LineNoMargVAT: Integer;
        GrossProfit: Decimal;
        CurrExchangeRate: Record "Currency Exchange Rate";
        PurchDate: Date;
        Text101: label 'Can''t find a positive entry.';
        TextAmounts: label 'Purchase Amount:%1\Sales Amount:%2';
        //SalesSetup: Record "Sales & Receivables Setup";
        SalesHeaderMargVAT: Record "Sales Header";
        ItemMargVAT: Record Item;
        AssignItemChargeSales: Codeunit "Item Charge Assgnt. (Sales)";
        Text200: label 'Model version No. %1 cost is not adjusted. Do you want to continue?';
        ValueEntry: Record "Value Entry";
        ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";

    begin
        //EDMS
        SalesSetup.Get;
        //SalesSetup.TESTFIELD("Veh. Marginal VAT Account No.");  //28.04.2014 Elva Baltic P8 #S0075 MMG7.00

        SalesHeaderMargVAT.Get("Document Type", "Document No.");

        LineNoMargVAT := "Line No." + 5;
        if SalesLineMargVAT.Get("Document Type", "Document No.", LineNoMargVAT) then begin
            SalesLineMargVAT.Reset;
            SalesLineMargVAT.SetRange("Document Type", "Document Type");
            SalesLineMargVAT.SetRange("Document No.", "Document No.");
            if SalesLineMargVAT.FindLast then
                LineNoMargVAT := SalesLineMargVAT."Line No." + 10000;
        end;

        TestField("Make Code");
        TestField("Model Code");
        TestField("Model Version No.");
        TestField("No.");
        TestField("Line Amount");
        TestField("Vehicle Serial No.");

        ItemMargVAT.Get("No.");
        if not ItemMargVAT."Cost is Adjusted" then
            if not Confirm(StrSubstNo(Text200, "Model Version No.")) then
                exit;

        //Getting Sales Amount
        SalesAmount := "Line Amount";  //28.02.2013 EDMS P8

        //Getting Purchase Amount
        ItemLedgerEntry.Reset;
        ItemLedgerEntry.SetCurrentkey("Serial No.");
        ItemLedgerEntry.SetRange("Serial No.", "Vehicle Serial No.");
        ItemLedgerEntry.SetRange(Open, true);
        if ItemLedgerEntry.IsEmpty then
            Error(Text101);
        // 26.03.2014 Elva Baltic P7 #Marginal VAT MMG7.00 >>
        ItemLedgerEntry.FindFirst;

        ValueEntry.Reset;
        ValueEntry.SetRange("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
        ValueEntry.SetRange("Entry Type", ValueEntry."entry type"::"Direct Cost");
        if ValueEntry.FindFirst then begin
            repeat
                PurchaseAmount += ValueEntry."Cost Amount (Actual)";
            until ValueEntry.Next = 0
        end;

        PurchDate := ItemLedgerEntry."Posting Date";
        if "Currency Code" <> '' then begin
            PurchaseAmount := ROUND(CurrExchangeRate.ExchangeAmtLCYToFCY(PurchDate, "Currency Code",
                                 PurchaseAmount, CurrExchangeRate.ExchangeRate(PurchDate, "Currency Code")), 0.01);
        end;

        Message(TextAmounts, Format(PurchaseAmount), Format(SalesAmount));

        if SalesAmount > PurchaseAmount then begin  //01.07.2008. EDMS P2
            GrossProfit := SalesAmount - PurchaseAmount;

            SalesLineMargVAT.Init;
            SalesLineMargVAT."Document Profile" := "document profile"::"Vehicles Trade";
            SalesLineMargVAT."Document Type" := "Document Type";
            SalesLineMargVAT."Document No." := "Document No.";
            LineNoMargVAT := LineNoMargVAT;
            SalesLineMargVAT."Line No." := LineNoMargVAT;
            SalesLineMargVAT.Validate("Line Type", SalesLineMargVAT."line type"::"Charge (Item)");
            SalesLineMargVAT.Validate("No.", SalesSetup."Veh. Marg. VAT Item Charge");
            SalesLineMargVAT.Validate(Quantity, 1);
            SalesLineMargVAT.Validate("Unit Price", ROUND(GrossProfit));  //28.02.2013 EDMS P8
            SalesLineMargVAT.Validate("Make Code", "Make Code");
            SalesLineMargVAT.Validate("Model Code", "Model Code");
            SalesLineMargVAT.Validate("Model Version No.", "Model Version No.");
            SalesLineMargVAT.Validate("Vehicle Serial No.", "Vehicle Serial No.");
            SalesLineMargVAT.Insert(true);

            //Add Item Charge Assignment
            ItemChargeAssgntSales.Init;
            ItemChargeAssgntSales."Document Type" := SalesLineMargVAT."Document Type";
            ItemChargeAssgntSales."Document No." := SalesLineMargVAT."Document No.";
            ItemChargeAssgntSales."Document Line No." := SalesLineMargVAT."Line No.";
            ItemChargeAssgntSales."Item Charge No." := SalesLineMargVAT."No.";

            if "Currency Code" = '' then
                Currency.InitRoundingPrecision
            else begin
                SalesHeaderMargVAT.TestField("Currency Factor");
                Currency.Get("Currency Code");
                Currency.TestField("Amount Rounding Precision");
            end;


            if (SalesLineMargVAT."Inv. Discount Amount" = 0) and
               (SalesLineMargVAT."Line Discount Amount" = 0) and
               (not SalesHeaderMargVAT."Prices Including VAT")
            then
                ItemChargeAssgntSales."Unit Cost" := SalesLineMargVAT."Unit Price"
            else
                if SalesHeaderMargVAT."Prices Including VAT" then
                    ItemChargeAssgntSales."Unit Cost" :=
                      ROUND(
                        (SalesLineMargVAT."Line Amount" - SalesLineMargVAT."Inv. Discount Amount") / SalesLineMargVAT.Quantity / (1 + SalesLineMargVAT."VAT %" / 100),
                        Currency."Unit-Amount Rounding Precision")
                else
                    ItemChargeAssgntSales."Unit Cost" :=
                      ROUND(
                        (SalesLineMargVAT."Line Amount" - SalesLineMargVAT."Inv. Discount Amount") / SalesLineMargVAT.Quantity,
                        Currency."Unit-Amount Rounding Precision");

            if "Document Type" in ["document type"::"Return Order", "document type"::"Credit Memo"] then
                AssignItemChargeSales.CreateDocChargeAssgn(ItemChargeAssgntSales, SalesLineMargVAT."Return Receipt No.")
            else
                AssignItemChargeSales.CreateDocChargeAssgn(ItemChargeAssgntSales, SalesLineMargVAT."Shipment No.");
            Clear(AssignItemChargeSales);

            //Change Quantity to Assign to 1
            ItemChargeAssgntSales.Reset;
            ItemChargeAssgntSales.SetRange("Applies-to Doc. Type", "Document Type");
            ItemChargeAssgntSales.SetRange("Applies-to Doc. No.", "Document No.");
            ItemChargeAssgntSales.SetRange("Applies-to Doc. Line No.", "Line No.");
            ItemChargeAssgntSales.SetRange("Document Line No.", SalesLineMargVAT."Line No.");
            if ItemChargeAssgntSales.FindFirst then
                repeat
                    ItemChargeAssgntSales.Validate("Qty. to Assign", 1);
                    ItemChargeAssgntSales.Modify;
                until ItemChargeAssgntSales.Next = 0;
        end;

        Validate("Gen. Prod. Posting Group", SalesSetup."Veh. Marg.VAT Gen.Prod.Grp.");
        Validate("Gen. Bus. Posting Group", SalesSetup."Veh. Marg.VAT Gen.Bus.Grp.");
        //28.02.2013 EDMS P8 >>
        if SalesAmount > PurchaseAmount then
            Validate("Unit Price", PurchaseAmount)
        else
            Validate("Unit Price", SalesAmount);
        //28.02.2013 EDMS P8 <<
        Modify;

        Commit;
        //  26.03.2014 Elva Baltic P7 #Marginal VAT MMG7.00 <<
    end;

    procedure NewVehAssemblyNo()
    var
        InvSetup: Record "Inventory Setup";
        NoSeries: Codeunit "No. Series";
        AssemblyNo: Code[20];
    begin
        if "Line Type" = "line type"::Vehicle then begin
            InvSetup.Get;
            InvSetup.TestField("Vehicle Assembly Nos.");
            Validate("Vehicle Assembly ID", NoSeries.GetNextNo(InvSetup."Vehicle Assembly Nos.", WorkDate(), false));
            Modify();
        end;
    end;


    [IntegrationEvent(false, false)]
    local procedure OnLookupOnBeforeValidateModVersion(var SalesLine: Record "Sales Line"; ModelVersion: Record Item)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAssignOnBeforeValidateVehicleStatusCode(var SalesLine: Record "Sales Line"; var Vehicle: Record Vehicle)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnbeforefilterCheckDiscount(salesline: record "sales line"; var SalesDiscount: Record "SP Sales Disc. Group Items"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnbeforeCheckDiscount(salesline: record "sales line"; var SalesDiscount: Record "SP Sales Disc. Group Items"; var Errorexist: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure onbeforeNewAccCycleNo(DefCycle: Code[20]; var ishandled: Boolean);
    begin
    end;



    var
        UserSetup: Record "User Setup";

        SalesSetup: Record "Sales & Receivables Setup";
        Item: Record item;
        GLSetup: Record "General Ledger Setup";
        UserProfile: Record "Branch Profile Setup";
        DimMgt: Codeunit DimensionManagement;
        CheckItemAvailabilityDone: Boolean;
        Text129: label 'Item is under stocktaking';
        LookUpMgt: Codeunit LookUpManagement;
        recDMSLabor: Record "Service Labor";
        recDMSExternal: Record "External Service";
        tcSER001: label 'Customer''s Request';
        tcSER002: label 'Requisition Worksheet';
        tcSER003: label 'Purchase Order';
        tcSER004: label 'In Stock';
        tcSER005: label 'In Stock - Informed';
        tcSER006: label 'Partly in Stock';
        EDMS001: label 'Vehicle %1 exist in other sales order.';
        VehPriceMgt: Codeunit VehicleSalesPriceDiscountMgt;
        Text102: label '%1 cannot be greater than %2.';
        ExternalService: Record "External Service";
        LicensePermission: Record "License Permission";
        Text103: label 'There are linked deal documents. All links will be deleted. Are you sure you want to change this line?';
        VehReserveSalesLine: Codeunit "Sales Line-Veh. Reserve";
        ReserveSalesLine: Codeunit "Sales Line-Reserve";
        VehReservMgt: Codeunit "Veh. Reservation Management";
        Text104: label 'Automatic reservation is not possible.\Reserve vehicle manually?';
        VFMgt: Codeunit "Variable Field Management";
        Text26500: label 'You must check field %1 in %2 to be able to change the %3 field manually.';
        GLSetupRead: Boolean;
        FullAutoReservation: Boolean;
        Text105: label 'There is no vehicle with Registration No. %1';
        UserProfileMgt: Codeunit UserProfileManagement;
        Currency: Record Currency;
        VehIsReservedPrmt: Label 'Vehicle is already reserved. Do you want to continue change vehicle?';

}