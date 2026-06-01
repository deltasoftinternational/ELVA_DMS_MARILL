tableextension 25006144 "Transfer Line" extends "Transfer Line" //5741
{
    // 18.10.2018 EB.P7  FIX
    //   Modified function AutoReservServ
    // 
    // 21.05.2014 Elva Baltic P21 #F012 MMG7.00
    //   Added function:
    //     FindVehicleDimSetID
    //   Modified trigger:
    //     Item No. - OnValidate()
    // 
    // 29.04.2014 Elva Baltic P8 #F037 MMG7.00
    //   * Use of Def. Status from profile
    // 
    // 19.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added functions:
    //     GetReservationColor
    //     FilterTransferRes
    // 
    // 12.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Changed "Planning Flexibility" field InitValue property to None
    // 
    // 15.07.2013 EDMS P8
    //   * Fix for use veh. reservation
    // 
    // 27.04.2013 EDMS P8
    //   * Adjust to use veh. reservation
    fields
    {
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006010; "From Location Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1,' + Text107;
            Caption = 'From Location Dimension Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(25006020; "From Location Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2,' + Text107;
            Caption = 'From Location Dimension Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(25006030; "To Location Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,2,1,' + Text108;
            Caption = 'To Location Dimension Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(25006040; "To Location Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,2,2,' + Text108;
            Caption = 'To Location Dimension Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(25006160; "Source Type"; Integer)
        {
            Caption = 'Source Type';
            Editable = false;
        }
        field(25006166; "Source Subtype"; Option)
        {
            Caption = 'Source Subtype';
            Editable = false;
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
        }
        field(25006170; "Vehicle Registration No."; Code[20])
        {
            Caption = 'Vehicle Registration No.';
            Editable = false;

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
        field(25006200; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            Editable = false;
            TableRelation = if ("Source Type" = const(25006145)) "Service Header EDMS"."No." where("Document Type" = field("Source Subtype"));
        }
        field(25006370; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            Editable = false;
            TableRelation = Make;
        }
        field(25006371; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            Editable = false;
            TableRelation = Model.Code where("Make Code" = field("Make Code"));
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
                if LookUpMgt.LookUpVehicleAMT(Vehicle, "Vehicle Serial No.") then
                    Validate("Vehicle Serial No.", Vehicle."Serial No.");
            end;

            trigger OnValidate()
            var
                recSalesLine: Record "Sales Line";
                tcAMT001: label 'This VIN is being used in %1. Are you shore that you want to use exactly this VIN?';
                recVehicle: Record Vehicle;
                tcAMT002: label 'Serial No. in Vehicle table differs from Serial No. in Sales Line.';
            begin
                TestStatusOpen;
            end;
        }
        field(25006374; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            Editable = false;
            TableRelation = Item."No." where("Make Code" = field("Make Code"),
                                              "Model Code" = field("Model Code"),
                                              "Item Type" = const("Model Version"));

            trigger OnLookup()
            var
                Item: Record Item;
            begin
                Item.Reset;
                if LookUpMgt.LookUpModelVersion(Item, "Item No.", "Make Code", "Model Code") then
                    Validate("Model Version No.", Item."No.");
            end;

            trigger OnValidate()
            var
                recVehicle: Record Vehicle;
            begin
                TestStatusOpen;

                if "Document Profile" = "document profile"::"Vehicles Trade" then
                    Validate("Item No.", "Model Version No.");
            end;
        }
        field(25006375; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;

            trigger OnValidate()
            var
                Vehicle: Record Vehicle;
                SerialNoPre: Code[20];
            begin
                TestStatusOpen;

                if "Vehicle Serial No." = '' then begin
                    VIN := '';
                    "Vehicle Accounting Cycle No." := '';
                    "Vehicle Registration No." := '';
                end
                else begin
                    Vehicle.Get("Vehicle Serial No.");
                    begin
                        SerialNoPre := "Vehicle Serial No.";
                        Validate("Make Code", Vehicle."Make Code");
                        Validate("Model Code", Vehicle."Model Code");
                        Validate("Model Version No.", Vehicle."Model Version No.");
                        VIN := Vehicle.VIN;
                        "Vehicle Serial No." := SerialNoPre;
                        Vehicle.CalcFields("Default Vehicle Acc. Cycle No.");
                        Validate("Vehicle Accounting Cycle No.", Vehicle."Default Vehicle Acc. Cycle No.");
                        "Vehicle Registration No." := Vehicle."Registration No.";
                        //29.04.2014 Elva Baltic P8 #F037 MMG7.00 >>
                        if "Vehicle Status Code" = '' then
                            "Vehicle Status Code" := TransferRoute.GetVehicleStatusCode("Transfer-from Code", "Transfer-to Code");
                        if "Vehicle Status Code" = '' then
                            "Vehicle Status Code" := Vehicle."Status Code";
                        //29.04.2014 Elva Baltic P8 #F037 MMG7.00 <<
                        Validate("Vehicle Status Code");
                    end;
                end;

                if "Vehicle Serial No." <> xRec."Vehicle Serial No." then
                    "Vehicle Assembly ID" := '';
            end;
        }
        field(25006376; "Vehicle Assembly ID"; Code[20])
        {
            Caption = 'Vehicle Assembly ID';

            trigger OnValidate()
            var
                VehAssembly: Record "Vehicle Assembly Line";
            begin
                TestField("Vehicle Serial No.");
                if (xRec."Vehicle Assembly ID" <> '') and (xRec."Vehicle Assembly ID" <> Rec."Vehicle Assembly ID") then begin
                    VehAssembly.Reset;
                    VehAssembly.SetRange("Serial No.", xRec."Vehicle Serial No.");
                    VehAssembly.SetRange("Assembly ID", xRec."Vehicle Assembly ID");
                    if not VehAssembly.IsEmpty then
                        Error(Text100, xRec."Vehicle Assembly ID");
                end;
            end;
        }
        field(25006379; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            TableRelation = "Vehicle Accounting Cycle"."No.";

            trigger OnLookup()
            var
                VehAccCycle: Record "Vehicle Accounting Cycle";
            begin
                VehAccCycle.Reset;
                if LookUpMgt.LookUpVehicleAccCycle(VehAccCycle, "Vehicle Serial No.", "Vehicle Accounting Cycle No.") then
                    Validate("Vehicle Accounting Cycle No.", VehAccCycle."No.");
            end;

            trigger OnValidate()
            var
                cuVehAccCycle: Codeunit VehicleAccountingCycleMgt;
            begin
                TestStatusOpen;
                cuVehAccCycle.CheckCycleRelation("Vehicle Serial No.", "Vehicle Accounting Cycle No.");
            end;
        }
        field(25006380; "Vehicle Status Code"; Code[20])
        {
            Caption = 'Vehicle Status Code';
            TableRelation = "Vehicle Status".Code;
        }
        field(25006382; "Reserved Inbound"; Boolean)
        {
            CalcFormula = exist("Vehicle Reservation Entry" where("Source Type" = const(5741),
                                                                   "Source ID" = field("Document No."),
                                                                   "Source Ref. No." = field("Line No."),
                                                                   "Source Subtype" = const("1")));
            Caption = 'Reserved Inbound';
            Description = 'Only for Vehicles';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006383; "Reserved Outbound"; Boolean)
        {
            CalcFormula = exist("Vehicle Reservation Entry" where("Source Type" = const(5741),
                                                                   "Source ID" = field("Document No."),
                                                                   "Source Ref. No." = field("Line No."),
                                                                   "Source Subtype" = const("0")));
            Caption = 'Reserved Outbound';
            Description = 'Only for Vehicles';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006390; "Variable Field Run 1"; Decimal)
        {
            CaptionClass = '7,5741,25006390';
        }
        field(25006996; "Variable Field Run 2"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,5741,25006996';
        }
        field(25006997; "Variable Field Run 3"; Decimal)
        {
            BlankZero = true;
            CaptionClass = '7,5741,25006997';
        }
        modify("Item No.")
        {
            trigger OnAfterValidate()
            begin
                //26.02.2010 EDMS P2 >>
                GetNewDimensions;
                //26.02.2010 EDMS P2 <<
            end;
        }

    }
    var
        TransferRoute: Record "Transfer Route";
        ReserveTransferVehLine: Codeunit "Transfer Line-Veh. Reserve";
        Text011: Label 'Outbound,Inbound';
        LookUpMgt: Codeunit LookUpManagement;
        Text100: label 'Vehicle assembly list %1 is not empty.';
        Text107: label 'From Location ';
        Text108: label 'To Location ';
        Text109: label '%1 with %2 has reservation, delete/cancel it first.';
        Text105: label 'There is no vehicle with Registration No. %1';
        VFMgt: Codeunit "Variable Field Management";

    trigger OnBeforeModify()
    var
        ReserveTransferVehLine: Codeunit "Transfer Line-Veh. Reserve";
    begin
        if "Document Profile" = "document profile"::"Vehicles Trade" then
            ReserveTransferVehLine.VerifyChange(Rec, xRec);
    end;

    procedure AutoReserveServ(Direction: Option Outbound,Inbound) FullReservation: Boolean
    var
        //ReservMgt: Codeunit "Reservation Management";
        ReservationMgtEDMS: Codeunit "Reservation Management EDMS";
        TransferHeader: Record "Transfer Header";
    begin
        //EDMS function
        TestField("Item No.");
        ReservationMgtEDMS.SetTransferLine(Rec, Direction);
        TestField("Shipment Date");
        CalcFields("Reserved Quantity Inbnd.", "Reserved Quantity Outbnd.");

        if Direction = Direction::Outbound then begin
            ReservationMgtEDMS.SetSpecSummEntryNo(220);

            // 26.10.2012 EDMS >>
            ReservationMgtEDMS.AutoReserve(FullReservation, '', "Shipment Date", "Outstanding Qty. (Base)" - "Reserved Quantity Outbnd.",
            "Outstanding Qty. (Base)" - "Reserved Quantity Outbnd.");
            // 26.10.2012 EDMS <<

        end
        else begin
            ReservationMgtEDMS.SetSpecSummEntryNo(220);

            //18.10.2018 EB.P7 >>
            if TransferHeader.Get("Document No.") then;
            ReservationMgtEDMS.SetServiceReservLoc(TransferHeader."Transfer-from Code");
            //18.10.2018 EB.P7 <<
            // 26.10.2012 EDMS >>

            ReservationMgtEDMS.AutoReserve(FullReservation, '', "Receipt Date", "Outstanding Qty. (Base)" - "Reserved Quantity Inbnd.",
            "Outstanding Qty. (Base)" - "Reserved Quantity Inbnd.");
            // 26.10.2012 EDMS <<

        end;

        Find;
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
            Modify();
        end;
    end;

    procedure VehicleAssembly()
    var
        VehicleAssemby: Record "Vehicle Assembly Line";
        VehAssemblyWorksheet: Page "Vehicle Assembly Worksheet";
        InvSetup: Record "Inventory Setup";
        NoSeriesMgt: Codeunit "No. Series";
        VehOptMgt: Codeunit VehicleOptionManagement;
        SalesHeader: Record "Sales Header";
        CurrencyDate: Date;
        VehPriceMgt: Codeunit VehicleSalesPriceDiscountMgt;
    begin
        if "Document Profile" <> "document profile"::"Vehicles Trade" then
            exit;

        TestField("Item No.");
        TestField("Vehicle Serial No.");
        TestField("Make Code");
        TestField("Model Code");
        TestField("Model Version No.");

        if "Vehicle Assembly ID" = '' then
            NewVehAssemblyNo;

        VehPriceMgt.ChkAssemblyHdrTransferLine(Rec);
        VehOptMgt.FillVehAssembly("Vehicle Serial No.", "Vehicle Assembly ID",
          "Make Code", "Model Code", "Model Version No.");

        Commit;

        VehicleAssemby.SetRange("Assembly ID", "Vehicle Assembly ID");
        VehicleAssemby.SetRange("Make Code", "Make Code");
        VehicleAssemby.SetRange("Model Code", "Model Code");
        VehicleAssemby.SetRange("Model Version No.", "Model Version No.");
        VehicleAssemby.SetRange("Serial No.", "Vehicle Serial No.");

        Clear(VehAssemblyWorksheet);
        VehAssemblyWorksheet.SetTableview(VehicleAssemby);
        VehAssemblyWorksheet.RunModal;
    end;

    procedure GetNewDimensions()
    var
        GLSetup: Record "General Ledger Setup";
        LocationDimensionSetup: Record "Location Dimension Setup";
    begin
        GLSetup.Get;

        if LocationDimensionSetup.Get("Transfer-from Code", "Item Category Code", GLSetup."Global Dimension 1 Code") then
            "From Location Dimension 1 Code" := LocationDimensionSetup."Dimension Value Code";
        if LocationDimensionSetup.Get("Transfer-from Code", "Item Category Code", GLSetup."Global Dimension 2 Code") then
            "From Location Dimension 2 Code" := LocationDimensionSetup."Dimension Value Code";

        if LocationDimensionSetup.Get("Transfer-to Code", "Item Category Code", GLSetup."Global Dimension 1 Code") then
            "To Location Dimension 1 Code" := LocationDimensionSetup."Dimension Value Code";
        if LocationDimensionSetup.Get("Transfer-to Code", "Item Category Code", GLSetup."Global Dimension 2 Code") then
            "To Location Dimension 2 Code" := LocationDimensionSetup."Dimension Value Code";
    end;


    procedure ShowReservationEntries(Modal: Boolean; Direction: Option Outbound,Inbound)
    var
        ReservEntry: Record "Reservation Entry";
        ReservEngineMgt: Codeunit "Reservation Engine Mgt.";
        ReserveTransferLine: Codeunit "Transfer Line-Reserve";
    begin
        TestField("Item No.");
        ReservEngineMgt.InitFilterAndSortingLookupFor(ReservEntry, true);
        Rec.SetReservationFilters(ReservEntry, Direction);
        if Modal then
            Page.RunModal(Page::"Reservation Entries", ReservEntry)
        else
            Page.Run(Page::"Reservation Entries", ReservEntry);
    end;

    procedure AutoReserveSilent(Direction: Option Outbound,Inbound)
    var
        //ReservMgt: Codeunit "Reservation Management";
        ReservationMgtEDMS: Codeunit "Reservation Management EDMS";
        FullAutoReservation: Boolean;
        ReservQuantity: Decimal;
        ResDate: Date;
        ServTransfMgt: Codeunit "Service Transfer Mgt.";
    begin
        //EDMS function
        TestField("Item No.");
        ReservationMgtEDMS.SetTransferLine(Rec, Direction);

        case Direction of
            Direction::Outbound:
                begin
                    ReservQuantity := Quantity - "Quantity Shipped";
                    ResDate := "Shipment Date";
                    if ServTransfMgt.IsServiceLocation("Transfer-from Code") then
                        ReservationMgtEDMS.SetSpecSummEntryNo(1);
                end;
            Direction::Inbound:
                begin
                    ReservQuantity := Quantity - "Quantity Received";
                    ResDate := "Receipt Date";
                    if ServTransfMgt.IsServiceLocation("Transfer-to Code") then
                        ReservationMgtEDMS.SetSpecSummEntryNo(220);
                end;
        end;

        if ReservQuantity <> 0 then begin
            TestField("Shipment Date");
            // 26.10.2012 EDMS >>
            ReservationMgtEDMS.AutoReserve(FullAutoReservation, '', ResDate, ReservQuantity, ReservQuantity);
            // 26.10.2012 EDMS <<
            Find;
        end;
    end;

    procedure ShowVehReservation()
    var
        VehReservation: Page "Vehicle Reservation";
        OptionNumber: Integer;
    begin
        TestField("Document Profile", "document profile"::"Vehicles Trade");
        TestField("Item No.");
        //TESTFIELD(Reserve);
        Clear(VehReservation);
        OptionNumber := StrMenu(Text011);
        if OptionNumber > 0 then begin
            VehReservation.SetTransLine(Rec, OptionNumber - 1);
            VehReservation.RunModal;
        end;
    end;

    procedure ShowVehReservationEntries(Modal: Boolean; Direction: Option Outbound,Inbound)
    var
        VehReservEngineMgt: Codeunit "Veh. Reservation Engine Mgt.";
        VehReserveSalesLine: Codeunit "Sales Line-Veh. Reserve";
        VehReservEntry: Record "Vehicle Reservation Entry";
    begin
        TestField("Document Profile", "document profile"::"Vehicles Trade");
        TestField("Item No.");
        /*
        VehReservEngineMgt.InitFilterAndSortingLookupFor(VehReservEntry);
        VehReserveSalesLine.FilterReservFor(VehReservEntry,Rec);
        IF Modal THEN
          PAGE.RUNMODAL(PAGE::"Vehicle Reservation Entries",VehReservEntry)
        ELSE
          PAGE.RUN(PAGE::"Vehicle Reservation Entries",VehReservEntry);
         */

    end;

    procedure GetReservedQtyVeh(SourceBatchName: Code[10]; DoFilterByBatch: Boolean; SourceSubtype: Integer; DoFilterBySubtype: Boolean) RetValue: Decimal
    var
        VehicleReservationEntry: Record "Vehicle Reservation Entry";
    begin
        //15.07.2013 EDMS P8 >>
        VehicleReservationEntry.Reset;
        VehicleReservationEntry.SetRange("Vehicle Serial No.", "Vehicle Serial No.");
        VehicleReservationEntry.SetRange("Source Type", Database::"Transfer Line");
        if DoFilterBySubtype then
            VehicleReservationEntry.SetRange("Source Subtype", SourceSubtype);
        VehicleReservationEntry.SetRange("Source ID", "Document No.");
        if DoFilterByBatch then
            VehicleReservationEntry.SetRange("Source Batch Name", SourceBatchName);
        VehicleReservationEntry.SetRange("Source Ref. No.", "Line No.");
        RetValue := 0;
        if VehicleReservationEntry.FindFirst then begin
            RetValue := VehicleReservationEntry.Quantity;
            if not VehicleReservationEntry.Positive then
                RetValue := RetValue * (-1);
        end;
        exit(RetValue);
    end;

    procedure GetReservationColor(): Text[20]
    var
        ResEntry: Record "Reservation Entry";
    begin
        FilterTransferRes(ResEntry);

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


    procedure FilterTransferRes(var FilteredResEntry: Record "Reservation Entry")
    var
        ResEntryNegative: Record "Reservation Entry";
        ResEntryTransferOutg: Record "Reservation Entry";
    begin
        //receivment into transfer
        ResEntryNegative.Reset;
        ResEntryNegative.SetCurrentkey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
        ResEntryNegative.SetRange("Source ID", "Document No.");
        ResEntryNegative.SetRange("Source Ref. No.", "Line No.");
        ResEntryNegative.SetRange("Source Type", Database::"Transfer Line");
        ResEntryNegative.SetRange("Source Subtype", 0);
        ResEntryNegative.SetRange("Source Prod. Order Line", "Derived From Line No.");
        ResEntryNegative.SetRange("Reservation Status", ResEntryNegative."reservation status"::Reservation);
        if ResEntryNegative.FindFirst then
            repeat
                FilteredResEntry.Get(ResEntryNegative."Entry No.", true);
                FilteredResEntry.Mark(true);
            until ResEntryNegative.Next = 0;
        FilteredResEntry.MarkedOnly(true)
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

    procedure IsVFActive(FieldNo: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::"Transfer Line", FieldNo));
    end;
}