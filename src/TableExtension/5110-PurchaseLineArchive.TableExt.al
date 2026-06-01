tableextension 25006145 "Purchase Line Archive" extends "Purchase Line Archive" //5110
{
    // 05.11.2012 EDMS P8
    //   * Added field: "Vehicle Assembly Version No."
    // 
    // 23.02.2012 EDMS P8
    //   * Add function ShowShortcutDimCode

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
        }
        field(25006006; "Vendor Order No."; Code[20])
        {
            Caption = 'Vendor Order No.';
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
            end;
        }
        field(25006130; "External Serv. Tracking No."; Code[20])
        {
            Caption = 'External Serv. Tracking No.';
            TableRelation = if (Type = filter("External Service")) "External Serv. Tracking No."."External Serv. Tracking No." where("External Service No." = field("No."));
        }
        field(25006170; "Vehicle Registration No."; Code[20])
        {
            CalcFormula = lookup(Vehicle."Registration No." where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Vehicle Registration No.';
            Editable = false;
            FieldClass = FlowField;
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
            end;
        }
        field(25006371; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));
        }
        field(25006372; "Line Type"; Option)
        {
            Caption = 'Line Type';
            OptionCaption = 'Comment,Vehicle,,,Charge (Item),G/L Account,Resource';
            OptionMembers = Comment,Vehicle,,Item,"Charge (Item)","G/L Account",Resource;

            trigger OnValidate()
            var
                DocMgtDMS: Codeunit DocumentManagementDMS;
                Opt: Integer;
            begin
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
        field(25006700; "Ordering Price Type Code"; Code[20])
        {
            Caption = 'Ordering Price Type Code';
            TableRelation = "Ordering Price Type";
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

    }

    var
        cuLookUpMgt: Codeunit LookUpManagement;
}
