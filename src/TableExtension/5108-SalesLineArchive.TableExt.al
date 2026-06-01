tableextension 25006140 "Sales Line Archive" extends "Sales Line Archive" //5108   
{
    // 13.06.2019 EB.P30 EDMS
    //   Modified field:
    //     "Line Type" Added option Resource
    // 
    // 20.02.2015 EB.P7 #Arch. Return Ord.
    //   Renewed EDMS fields from Sales Line
    // 
    // 08.04.2013 EDMS P8
    //   * Deleted fields: 'Mechanic No.'
    // 
    // 05.11.2012 EDMS P8
    //   * Added field: "Vehicle Assembly Version No."

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
        field(25006002; "Payment Method Code"; Code[10])
        {
            Caption = 'Payment Method Code';
            TableRelation = "Payment Method";
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
            CalcFormula = lookup(Vehicle."Registration No." where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Vehicle Registration No.';
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

            trigger OnLookup()
            var
                Vehicle: Record Vehicle;
            begin
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
            begin
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
            end;
        }
        field(25006379; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            TableRelation = "Vehicle Accounting Cycle"."No.";

            trigger OnLookup()
            var
                recVehAccCycle: Record "Vehicle Accounting Cycle";
            begin
            end;

            trigger OnValidate()
            var
                cuVehAccCycle: Codeunit VehicleAccountingCycleMgt;
            begin
            end;
        }
        field(25006380; "Vehicle Status Code"; Code[20])
        {
            Caption = 'Vehicle Status Code';
            TableRelation = "Vehicle Status".Code;
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
            begin
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
            end;
        }
        field(25006801; "Variable Field 25006801"; Code[20])
        {
            CaptionClass = '7,37,25006801';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
            end;
        }
        field(25006802; "Variable Field 25006802"; Code[20])
        {
            CaptionClass = '7,37,25006802';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
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
    }


    var
        cuLookUpMgt: Codeunit LookUpManagement;
}
