tableextension 25006051 "Item Journal Line" extends "Item Journal Line"//83
{
    // 06.12.2017 EB.P7 #T007
    //   Removed field "Product Subgroup Code"
    // 
    // 26.07.2007. EDMS P2
    //   * Added new key "Journal Template Name,Journal Batch Name,Item Category Code,Product Group Code"
    // 
    // 31.05.2007. EDMS P2
    //   *Added code to Model Version No. - OnValidate()

    fields
    {
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade";
        }
        field(25006001; "Item Type"; Option)
        {
            Caption = 'Item Type';
            OptionCaption = ' ,Item,Model Version';
            OptionMembers = ,Item,"Model Version";
        }
        field(25006002; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(25006003; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));
        }
        field(25006004; "Model Version No."; Code[20])
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
                if cuLookUpMgt.LookUpModelVersion(recItem, "Model Version No.", "Make Code", "Model Code") then
                    Validate("Model Version No.", recItem."No.");
            end;

            trigger OnValidate()
            begin
                if "Model Version No." = '' then
                    exit;
                Validate("Item No.", "Model Version No.");
            end;
        }
        field(25006005; VIN; Code[20])
        {
            CalcFormula = lookup(Vehicle.VIN where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = Vehicle;

            trigger OnLookup()
            var
                recVehicle: Record Vehicle;
            begin
                recVehicle.Reset;
                if cuLookUpMgt.LookUpVehicleAMT(recVehicle, "Vehicle Serial No.") then begin
                    Validate("Vehicle Serial No.", recVehicle."Serial No.");
                    VIN := recVehicle.VIN;
                end;
            end;
        }
        field(25006010; "Deal Type Code"; Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";
        }
        field(25006025; "External Document No. 2"; Code[20])
        {
            Caption = 'External Document No. 2';
        }
        field(25006030; "Campaign No."; Code[20])
        {
            Caption = 'Campaign No.';
            TableRelation = Campaign;
            ValidateTableRelation = false;
        }
        field(25006160; "Transfer Source Type"; Integer)
        {
            Caption = 'Transfer Source Type';
            Editable = false;
        }
        field(25006166; "Transfer Source Subtype"; Option)
        {
            Caption = 'Transfer Source Subtype';
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
                    Message(StrSubstNo(Text100, "Vehicle Registration No."), '');
            end;
        }
        field(25006200; "Transfer Source No."; Code[20])
        {
            Caption = 'Transfer Source No.';
            TableRelation = if ("Transfer Source Type" = const(25006145)) "Service Header EDMS"."No." where("Document Type" = field("Transfer Source Subtype"),
                                                                                                           "No." = field("Transfer Source No."));
        }
        field(25006373; "Vehicle Assembly No."; Code[20])
        {
            Caption = 'Vehicle Assembly No.';
        }
        field(25006375; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';

            trigger OnLookup()
            var
                recVehicle: Record Vehicle;
            begin
                recVehicle.Reset;
                if cuLookUpMgt.LookUpVehicleAMT(recVehicle, "Vehicle Serial No.") then begin
                    Validate("Vehicle Serial No.", recVehicle."Serial No.");
                    VIN := recVehicle.VIN;
                end;
            end;

            trigger OnValidate()
            var
                recVehicle: Record Vehicle;
                codSerialNoPre: Code[20];
                codDefCycle: Code[20];
                cuVehAccCycle: Codeunit VehicleAccountingCycleMgt;
            begin
                if "Vehicle Serial No." = '' then begin
                    VIN := '';
                    "Vehicle Accounting Cycle No." := '';
                    "Vehicle Registration No." := '';
                end
                else begin
                    if recVehicle.Get("Vehicle Serial No.") then begin
                        codSerialNoPre := "Vehicle Serial No.";
                        Validate("Make Code", recVehicle."Make Code");
                        Validate("Model Code", recVehicle."Model Code");
                        Validate("Model Version No.", recVehicle."Model Version No.");
                        VIN := recVehicle.VIN;
                        "Vehicle Serial No." := codSerialNoPre;
                        "Vehicle Registration No." := recVehicle."Registration No.";
                        recVehicle.CalcFields("Default Vehicle Acc. Cycle No.");
                        Validate("Vehicle Accounting Cycle No.", recVehicle."Default Vehicle Acc. Cycle No.");
                    end
                    else begin
                        VIN := '';
                        codDefCycle := cuVehAccCycle.GetDefaultCycle("Vehicle Serial No.", "Vehicle Accounting Cycle No.");
                        Validate("Vehicle Accounting Cycle No.", codDefCycle);
                    end;
                end;
            end;
        }
        field(25006379; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Editable = false;
            TableRelation = "Vehicle Accounting Cycle"."No.";

            trigger OnLookup()
            var
                recVehAccCycle: Record "Vehicle Accounting Cycle";
            begin
                recVehAccCycle.Reset;
                if cuLookUpMgt.LookUpVehicleAccCycle(recVehAccCycle, "Vehicle Serial No.", "Vehicle Accounting Cycle No.") then
                    Validate("Vehicle Accounting Cycle No.", recVehAccCycle."No.");
            end;
        }
        field(25006382; Reserved; Boolean)
        {
            CalcFormula = exist("Vehicle Reservation Entry" where("Source Ref. No." = field("Line No."),
                                                                   "Source ID" = field("Journal Template Name"),
                                                                   "Source Batch Name" = field("Journal Batch Name"),
                                                                   "Source Type" = const(83),
                                                                   "Source Subtype" = field("Entry Type")));
            Caption = 'Reserved';
            Description = 'Only for Vehicles';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006680; "Not To Post"; Boolean)
        {
            Caption = 'Not To Post';
        }
        field(25006681; "Veh Additional Expenses"; Boolean)
        {
            Caption = 'Veh. Additional Expenses';

        }


    }
    keys
    {
        key(DMS1; "Location Code", "Bin Code")
        {
        }


    }


    procedure CalcVehicleUnitCost(VehSerialNo: Code[20]; AddAdditionalExpenses: Boolean): Decimal
    var
        ValueEntry: Record "Value Entry";
        ItemLedgerEntry: Record "Item Ledger Entry";
        InventoryPostingGroup: Record "Inventory Posting Group";
        UnitCostLoc: Decimal;
    begin
        UnitCostLoc := 0;
        ItemLedgerEntry.Reset;
        ItemLedgerEntry.SetCurrentkey("Serial No.");
        ItemLedgerEntry.SetRange("Serial No.", VehSerialNo);
        ItemLedgerEntry.SetRange(Open, true);
        if ItemLedgerEntry.FindFirst then
            repeat
                ValueEntry.Reset;
                ValueEntry.SetCurrentkey("Item Ledger Entry No.");
                ValueEntry.SetRange("Item Ledger Entry No.", ItemLedgerEntry."Entry No.");
                if ValueEntry.FindFirst then
                    repeat
                        if InventoryPostingGroup.Get(ValueEntry."Inventory Posting Group") then;
                        if AddAdditionalExpenses or not (InventoryPostingGroup."Vehicle Additional Expenses") then
                            UnitCostLoc += ValueEntry."Cost Amount (Actual)";
                    until ValueEntry.Next = 0;
            until ItemLedgerEntry.Next = 0;

        exit(UnitCostLoc);
    end;


    procedure SetVehAdditionalExpenses(VehAdditionalExpenses1: Boolean)
    begin
        Rec."Veh Additional Expenses" := VehAdditionalExpenses1;
    end;

    procedure GetVehAdditionalExpenses(): Boolean
    begin
        Exit(VehAdditionalExpenses);
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




    var
        cuLookUpMgt: Codeunit LookUpManagement;
        VehAdditionalExpenses: Boolean;
        Text100: label 'There is no vehicle with Registration No. %1';
        LookUpMgt: Codeunit LookUpManagement;
}
