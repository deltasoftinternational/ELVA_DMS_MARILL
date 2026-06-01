tableextension 25006040 "Requisition Line" extends "Requisition Line" //246
{
    // 22.11.2019 EB.P30
    //   Added field:
    //     25006760 "Purchase Order No."
    // 
    // 15.11.2019 EB.P7 EDMS
    //   Modified function:
    //     GetReservInfoForFactBox
    // 
    // 13.02.2019 EB.KN
    //   Modified trigger:
    //     GetLocationCode
    // 
    // 07.09.2018 EB.P30
    //   Modified trigger:
    //     OnValidate."Ordering Price Type Code"
    // 
    // 28.08.2018 EB.P30
    //   Added fields:
    //     25006710"Net Weight"
    //     25006720"Order Qty. Weight"
    //     25006730"Reservation Created By"
    //     25006740"Purchase Transport Method"
    // 
    // 27.05.2016 EB.P30 T036
    //   Modified function UpdateDescription
    // 
    // 03.11.2015 EB.P7 #T002
    //   Function UpdateDescription modified.
    // 
    // 06.06.2014 Elva Baltic P8 #F0001 EDMS7.10
    //   * Add fill value of "Ordering Price Type Code"
    //   * Add to local key "Ordering Price Type Code"
    // 
    // 07.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added key:
    //     Worksheet Template Name,Journal Batch Name,Vendor No.,Sell-to Customer No.,Ship-to Code,Order Address Code,Currency Code,Location Code,Transfer-from Code,Type,No.
    // 
    // 28.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added function:
    //     GetReservForInfo
    // 
    // 18.01.2013 EDMS P8
    //   * Added fields: Service Order No., Service Order Line No.
    // 
    // 06.08.2008 EDMS P1
    //  *Added field "Order Promising Type"
    //  *Field "Order Promising Type" added to key "Order Promising ID,Order Promising Line ID,Order Promising Line No."

    fields
    {
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006001; "Deal Type Code"; Code[10])
        {
            Caption = 'Deal Type Code';
            Editable = true;
            TableRelation = "Deal Type";


            trigger OnValidate()
            var
                Dimsource: List of [Dictionary of [Integer, code[20]]];
                DimDictionary: Dictionary of [Integer, code[20]];
            begin
                if "Deal Type Code" <> '' then begin
                    /* CreateDim(
                      DimMgt.PurchLineTypeToTableID(Type.AsInteger()),
                       "No.", Database::Vendor, "Vendor No.");
                     CreateDim(
                      DimMgt.PurchLineTypeToTableID(Type.AsInteger()),
                      "No.", Database::"Deal Type", "Deal Type Code");*/
                    Clear(DimDictionary);
                    Clear(Dimsource);
                    DimDictionary.Add(DimMgt.PurchLineTypeToTableID(Type), "No.");
                    DimDictionary.Add(Database::Vendor, "Vendor No.");
                    Dimsource.Add(DimDictionary);
                    CreateDim(Dimsource);
                    Clear(DimDictionary);
                    Clear(Dimsource);
                    DimDictionary.Add(DimMgt.PurchLineTypeToTableID(Type), "No.");
                    DimDictionary.Add(Database::"Deal Type", "Deal Type Code");
                    Dimsource.Add(DimDictionary);
                end;
            end;
        }
        field(25006008; "Order Promising Type"; Option)
        {
            Caption = 'Order Promising Type';
            OptionCaption = ' ,Sales,Requisition Line,Purchase,Item Journal,BOM Journal,Item Ledger Entry,Prod. Order Line,Prod. Order Component,Planning Line,Planning Component,Transfer,Service Order,Service Order EDMS';
            OptionMembers = " ",Sales,"Requisition Line",Purchase,"Item Journal","BOM Journal","Item Ledger Entry","Prod. Order Line","Prod. Order Component","Planning Line","Planning Component",Transfer,"Service Order","Service Order EDMS";
        }
        field(25006010; "Reservation Entry No."; Integer)
        {
            BlankZero = true;
            CalcFormula = lookup("Reservation Entry"."Entry No." where("Reservation Status" = const(Reservation),
                                                                        "Source Type" = const(246),
                                                                        "Source Subtype" = const(0),
                                                                        "Source ID" = field("Worksheet Template Name"),
                                                                        "Source Batch Name" = field("Journal Batch Name"),
                                                                        "Source Prod. Order Line" = const(0),
                                                                        "Source Ref. No." = field("Line No.")));
            Caption = 'Reservation Entry No.';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006011; "Reservation Source Type"; Integer)
        {
            BlankZero = true;
            CalcFormula = lookup("Reservation Entry"."Source Type" where("Entry No." = field("Reservation Entry No."),
                                                                          Positive = const(false)));
            Caption = 'Reservation Source Type';
            Description = 'Negative Entry';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006012; "Reservation Source Subtype"; Option)
        {
            BlankZero = true;
            CalcFormula = lookup("Reservation Entry"."Source Subtype" where("Entry No." = field("Reservation Entry No."),
                                                                             Positive = const(false)));
            Caption = 'Reservation Source Subtype';
            Description = 'Negative Entry';
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
            Description = 'Negative Entry';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006014; "Reservation Source Ref. No."; Integer)
        {
            BlankZero = true;
            CalcFormula = lookup("Reservation Entry"."Source Ref. No." where("Entry No." = field("Reservation Entry No."),
                                                                              Positive = const(false)));
            Caption = 'Reservation Source Ref. No.';
            Description = 'Negative Entry';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006015; "Reservation VIN"; Code[20])
        {
            CalcFormula = lookup("Sales Line".VIN where("Document Type" = field("Reservation Source Subtype"),
                                                         "Document No." = field("Reservation Source ID"),
                                                         "Line No." = field("Reservation Source Ref. No.")));
            Caption = 'Reservation VIN';
            Description = 'Negative Entry';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006016; "Reservation Customer No."; Code[20])
        {
            CalcFormula = lookup("Sales Line"."Sell-to Customer No." where("Document Type" = field("Reservation Source Subtype"),
                                                                            "Document No." = field("Reservation Source ID"),
                                                                            "Line No." = field("Reservation Source Ref. No.")));
            Caption = 'Reservation Customer No.';
            Description = 'Negative Entry';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006020; "Reorder Point"; Decimal)
        {
            CalcFormula = lookup(Item."Reorder Point" where("No." = field("No.")));
            Caption = 'Minimum Quantity';
            FieldClass = FlowField;
        }
        field(25006021; "Maximum Quantity"; Decimal)
        {
            CalcFormula = lookup(Item."Maximum Inventory" where("No." = field("No.")));
            FieldClass = FlowField;
        }
        field(25006100; "Service Order No."; Code[20])
        {
            Caption = 'Sales Order No.';
            Editable = false;
            TableRelation = "Service Header EDMS"."No." where("Document Type" = const(Order));

            trigger OnValidate()
            var
                ApprAllowed: Boolean;
            begin
                ReserveReqLine.VerifyChange(Rec, xRec);

                LicensePermission.SetRange("Object Type", LicensePermission."object type"::Codeunit);
                LicensePermission.SetRange("Object Number", Codeunit::"Req. Line-Veh. Reserve");
                LicensePermission.SetFilter("Execute Permission", '<>%1', LicensePermission."execute permission"::" ");
                ApprAllowed := not LicensePermission.IsEmpty;
            end;
        }
        field(25006101; "Service Order Line No."; Integer)
        {
            Caption = 'Sales Order Line No.';
            Editable = false;

            trigger OnValidate()
            var
                ApprAllowed: Boolean;
            begin
                ReserveReqLine.VerifyChange(Rec, xRec);

                LicensePermission.SetRange("Object Type", LicensePermission."object type"::Codeunit);
                LicensePermission.SetRange("Object Number", Codeunit::"Req. Line-Veh. Reserve");
                LicensePermission.SetFilter("Execute Permission", '<>%1', LicensePermission."execute permission"::" ");
                ApprAllowed := not LicensePermission.IsEmpty;
            end;
        }
        field(25006370; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;

            trigger OnValidate()
            var
                recVehicle: Record Vehicle;
                recModel: Record Model;
            begin
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
                if ("Model Code" <> xRec."Model Code") and ("Model Version No." <> '') then begin
                    Validate("Model Version No.", '');
                end;
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
                    VIN := Vehicle.VIN;
                end;
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
                if LookUpMgt.LookUpModelVersion(recItem, "No.", "Make Code", "Model Code") then
                    Validate("Model Version No.", recItem."No.");
            end;

            trigger OnValidate()
            var
                recVehicle: Record Vehicle;
            begin
                if "Model Version No." = '' then begin
                    Validate("No.", "Model Version No.");
                    VIN := '';
                    "Vehicle Serial No." := '';
                    //"Vehicle Accounting Cycle No." := '';
                end
                else
                    Validate("No.", "Model Version No.");
            end;
        }
        field(25006375; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';

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
        }
        field(25006376; "Vehicle Assembly ID"; Code[20])
        {
            Caption = 'Vehicle Assembly ID';

            trigger OnValidate()
            var
                tcAMT001: label 'Vehicle assembly list %1 is not empty.';
            begin
                TestField("Vehicle Serial No.");
            end;
        }
        field(25006379; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            TableRelation = "Vehicle Accounting Cycle"."No.";

            trigger OnLookup()
            var
                VehAccCycle: Record "Vehicle Accounting Cycle";
                LookUpMgt: Codeunit LookUpManagement;
            begin
                VehAccCycle.Reset;
                if LookUpMgt.LookUpVehicleAccCycle(VehAccCycle, "Vehicle Serial No.", "Vehicle Accounting Cycle No.") then
                    Validate("Vehicle Accounting Cycle No.", VehAccCycle."No.");
            end;

            trigger OnValidate()
            var
                VehAccCycle: Codeunit VehicleAccountingCycleMgt;
            begin
                VehAccCycle.CheckCycleRelation("Vehicle Serial No.", "Vehicle Accounting Cycle No.");
            end;
        }
        field(25006382; Reserved; Boolean)
        {
            CalcFormula = exist("Vehicle Reservation Entry" where("Source Type" = const(246),
                                                                   "Source ID" = field("Worksheet Template Name"),
                                                                   "Source Ref. No." = field("Line No."),
                                                                   "Source Subtype" = const("0"),
                                                                   "Source Batch Name" = field("Journal Batch Name")));
            Caption = 'Reserved';
            Description = 'Only for Vehicles';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006670; "Qty in Sales Quotes"; Decimal)
        {
            CalcFormula = sum("Sales Line".Quantity where(Type = const(Item),
                                                           "Document Type" = const(Quote),
                                                           "No." = field("No.")));
            Caption = 'Qty in Sales Quotes';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006700; "Ordering Price Type Code"; Code[10])
        {
            Caption = 'Ordering Price Type Code';
            TableRelation = "Ordering Price Type";

            trigger OnValidate()
            var
                OrderingPriceType: Record "Ordering Price Type";
            begin
                // 07.09.2018 EB.P30 >>
                if OrderingPriceType.Get("Ordering Price Type Code") then
                    "Purchase Transport Method" := OrderingPriceType."Def. Purch. Transport Method";
                // 07.09.2018 EB.P30 <<
            end;
        }
        field(25006710; "Net Weight"; Decimal)
        {
            Caption = 'Net Weight';
            DataClassification = ToBeClassified;
        }
        field(25006720; "Order Qty. Weight"; Decimal)
        {
            Caption = 'Order Qty. Weight';
            DataClassification = ToBeClassified;
        }
        field(25006730; "Reservation Created By"; Code[50])
        {
            CalcFormula = lookup("Reservation Entry"."Created By" where("Entry No." = field("Reservation Entry No.")));
            Caption = 'Reservation Created By';
            FieldClass = FlowField;
        }
        field(25006740; "Purchase Transport Method"; Code[10])
        {
            Caption = 'Purchase Transport Method';
            DataClassification = ToBeClassified;
            TableRelation = "Transport Method";
        }
        field(25006750; "Reservation Veh. Serial No."; Code[20])
        {
            Caption = 'Reservation Vehicle Serial No.';
            DataClassification = ToBeClassified;
        }
        field(25006760; "Purchase Order No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }

    }
    keys
    {   /*
        key(Key14; "Worksheet Template Name", "Journal Batch Name", "Vendor No.", "Sell-to Customer No.", "Ship-to Code", "Order Address Code", "Currency Code", "Location Code", "Transfer-from Code", Type, "Ordering Price Type Code", "No.")
        {
        }
        key(Key15; "Order Promising ID", "Order Promising Line ID", "Order Promising Line No.", "Order Promising Type")
        {
        }
        key(Key16; "Worksheet Template Name", "Journal Batch Name", "Vendor No.", "Location Code", "Purchase Transport Method", "Ordering Price Type Code", "Reservation Veh. Serial No.", "No.")
        {
        }
        */
    }

    procedure ShowVehReservation()
    var
        VehReservation: Page "Vehicle Reservation";
    begin
        TestField(Type, Type::Item);
        TestField("No.");
        Clear(VehReservation);
        VehReservation.SetReqLine(Rec);
        VehReservation.RunModal;
    end;

    procedure ShowVehReservationEntries(Modal: Boolean)
    var
        VehReservEngineMgt: Codeunit "Veh. Reservation Engine Mgt.";
        VehReservEntry: Record "Vehicle Reservation Entry";
        VehReserveReqLine: Codeunit "Req. Line-Veh. Reserve";
    begin
        TestField(Type, Type::Item);
        TestField("No.");
        VehReservEngineMgt.InitFilterAndSortingLookupFor(VehReservEntry);
        VehReserveReqLine.FilterReservFor(VehReservEntry, Rec);
        if Modal then
            Page.RunModal(Page::"Vehicle Reservation Entries", VehReservEntry)
        else
            Page.Run(Page::"Vehicle Reservation Entries", VehReservEntry);
    end;


    procedure NewVehAssemblyNo()
    var
        InvSetup: Record "Inventory Setup";
        NoSeriesMgt: Codeunit "No. Series";
        AssemblyNo: Code[20];
    begin
        if "Document Profile" = "document profile"::"Vehicles Trade" then begin
            InvSetup.Get;
            InvSetup.TestField("Vehicle Assembly Nos.");
            Validate("Vehicle Assembly ID", NoSeriesMgt.GetNextNo(InvSetup."Vehicle Assembly Nos.", WorkDate(), true));
        end;
    end;


    procedure VehicleAssembly()
    var
        VehicleAssemby: Record "Vehicle Assembly Line";
        VehAssemblyWorksheet: Page "Vehicle Assembly Worksheet";
        VehPriceMgt: Codeunit VehicleSalesPriceDiscountMgt;
        VehOptMgt: Codeunit VehicleOptionManagement;
    begin
        if "Document Profile" <> "document profile"::"Vehicles Trade" then
            exit;

        TestField("No.");
        TestField("Vehicle Serial No.");

        TestField("Make Code");
        TestField("Model Code");
        TestField("Model Version No.");

        if "Vehicle Assembly ID" = '' then
            NewVehAssemblyNo;

        VehPriceMgt.ChkAssemblyHdrReqLine(Rec);
        VehOptMgt.FillVehAssembly("Vehicle Serial No.", "Vehicle Assembly ID", "Make Code", "Model Code", "Model Version No.");



        VehicleAssemby.SetRange("Assembly ID", "Vehicle Assembly ID");
        VehicleAssemby.SetRange("Make Code", "Make Code");
        VehicleAssemby.SetRange("Model Code", "Model Code");
        VehicleAssemby.SetRange("Model Version No.", "Model Version No.");
        VehicleAssemby.SetRange("Serial No.", "Vehicle Serial No.");

        Clear(VehAssemblyWorksheet);
        VehAssemblyWorksheet.SetTableview(VehicleAssemby);
        VehAssemblyWorksheet.Run;
    end;

    procedure GetReservForInfo(ReturnValue: Option CustomerNo,VIN,DealType,CustomerName,OrderingPriceType,Make,Model,Location): Text[50]
    var
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        ReservEngineMgtEDMS: Codeunit "Reservation Management EDMS";

    begin
        exit(ReservEngineMgtEDMS.GetReservInfoForFactBox(ReturnValue, "Worksheet Template Name", "Line No.", Database::"Requisition Line", 0, 0, "Journal Batch Name"));
    end;


    procedure SetPriceTypeCode()
    begin
        //06.06.2014 EDMS P8 >>
        if "Ordering Price Type Code" = '' then
            Validate("Ordering Price Type Code", GetReservForInfo(4)); //CustomerNo,VIN,DealType,CustomerName,OrderingPriceType
        //06.06.2014 EDMS P8 <<
    end;

    var
        CompanyInformation: Record "Company Information";
        LookUpMgt: Codeunit LookUpManagement;
        VehReserveReqLine: Codeunit "Req. Line-Veh. Reserve";
        LicensePermission: Record "License Permission";
        DimMgt: Codeunit DimensionManagement;
        ReserveReqLine: Codeunit "Req. Line-Reserve";
}