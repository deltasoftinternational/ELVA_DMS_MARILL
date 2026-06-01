Table 25006017 "Contract Sales Line Discount"
{
    // 16.04.2014 Elva Baltic P21 #F182 MMG7.00
    //   Modified triggers:
    //     Type - OnValidate()
    //     No. - OnValidate()
    // 
    // 30.01.2014 Elva Baltic P8 #F038 MMG7.00
    //   * Added Key
    // 
    // 09.10.2013 EDMS P8
    //   * Added fields: Make Code, Group
    // 
    // 23.08.2013
    //   * new option in Type: "Labor Discount Group"

    Caption = 'Contract Sales Line Discount';
    DrillDownPageID = "Contract Sales Line Discount";
    LookupPageID = "Contract Sales Line Discount";

    fields
    {
        field(3; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;

            trigger OnValidate()
            begin
                TestStatusOpen;
            end;
        }
        field(5; "Contract Type"; Option)
        {
            Caption = 'Contract Type';
            Description = 'Not Supported. Reserved for future.';
            OptionCaption = 'Quote,Contract';
            OptionMembers = Quote,Contract;
        }
        field(10; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = if ("Contract Type" = const(Contract)) Contract."Contract No.";
        }
        field(14; "Minimum Quantity"; Decimal)
        {
            Caption = 'Minimum Quantity';
            MinValue = 0;
        }
        field(20; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(40; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Item Category,Labor,Labor Discount Group';
            OptionMembers = "Item Category",Labor,"Labor Discount Group";

            trigger OnValidate()
            begin
                // TestStatusOpen;                                                            // 16.04.2014 Elva Baltic P21
                "No." := '';
                if Type <> Type::"Item Category" then begin
                    Validate("Product Group Code", '');
                    Validate("Product Subgroup Code", '');
                end;
            end;
        }
        field(50; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = if (Type = const(Labor)) "Service Labor"."No."
            else
            if (Type = const("Item Category")) "Item Category".Code
            else
            if (Type = const("Labor Discount Group")) "Service Labor Discount Group".Code;

            trigger OnValidate()
            begin
                // TestStatusOpen;                                                            // 16.04.2014 Elva Baltic P21
                case Type of
                    Type::"Item Category":
                        if recItemGroup.Get("No.") then
                            Description := recItemGroup.Description;
                    Type::"Labor Discount Group":
                        if ServiceLaborDiscountGroup.Get("No.") then
                            Description := ServiceLaborDiscountGroup.Description;
                    Type::Labor:
                        begin
                            //"No.":='';
                        end;
                end;
            end;
        }
        field(60; VIN; Code[20])
        {
            CalcFormula = lookup(Vehicle.VIN where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'VIN';
            Editable = false;
            FieldClass = FlowField;

            trigger OnLookup()
            begin
                recVehicle.Reset;
                if cuLookUpMgt.LookUpVehicleAMT(recVehicle, "Vehicle Serial No.") then begin
                    Validate("Vehicle Serial No.", recVehicle."Serial No.");
                    VIN := recVehicle.VIN;
                end;
            end;
        }
        field(65; "Vehicle Serial No."; Code[20])
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
                recReservationEntry: Record "Reservation Entry";
                iEntryNo: Integer;
                cSalesLineReserve: Codeunit "Sales Line-Reserve";
                recVehicle: Record Vehicle;
                codSerialNoPre: Code[20];
                codDefCycle: Code[20];
                cuVehAccCycle: Codeunit VehicleAccountingCycleMgt;
            begin
                TestStatusOpen;

                if "Vehicle Serial No." = '' then begin
                    VIN := '';
                end
                else begin
                    recVehicle.Reset;
                    if recVehicle.Get("Vehicle Serial No.") then begin
                        codSerialNoPre := "Vehicle Serial No.";
                        VIN := recVehicle.VIN;
                        "Vehicle Serial No." := codSerialNoPre;
                    end;
                end;
            end;
        }
        field(70; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(190; "Contract Expiration Date"; Date)
        {
            Caption = 'Contract Expiration Date';
        }
        field(220; "Line Discount %"; Decimal)
        {
            AutoFormatType = 2;
            BlankZero = true;
            Caption = 'Line Discount %';
            DecimalPlaces = 0 : 5;
            MaxValue = 100;
            MinValue = 0;
        }
        field(240; "Starting Date"; Date)
        {
            Caption = 'Starting Date';
            Editable = false;
        }
        field(250; "Ending Date"; Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            begin
                TestStatusOpen();
                if CurrFieldNo = 0 then
                    exit;

                Validate("Starting Date");
            end;
        }
        field(5400; "Unit of Measure Code"; Code[10])
        {
            Caption = 'Unit of Measure Code';
            TableRelation = "Unit of Measure";
        }
        field(5410; "Product Group Code"; Code[10])
        {
            Caption = 'Product Group Code';

            trigger OnValidate()
            var
                ProductSubgrp: Record "Product Subgroup";
            begin
                if not ProductSubgrp.Get("No.", "Product Group Code", "Product Subgroup Code") then
                    Validate("Product Subgroup Code", '')
                else
                    Validate("Product Subgroup Code");
            end;
        }
        field(5420; "Product Subgroup Code"; Code[10])
        {
            Caption = 'Product Subgroup Code';
        }
        field(5430; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Service';
            OptionMembers = " ","Spare Parts Trade",Service;
        }
        field(25006770; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
            TableRelation = Location;
        }
    }

    keys
    {
        key(Key1; "Contract Type", "Contract No.", "Line No.")
        {
            Clustered = true;
        }
        key(Key2; "Vehicle Serial No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        recItemGroup: Record "Item Discount Group";
        ServiceLaborDiscountGroup: Record "Service Labor Discount Group";
        ContractSalesLineDiscount: Record "Contract Sales Line Discount";
        StatusCheckSuspended: Boolean;
        Contract: Record Contract;
        recVehicle: Record Vehicle;
        cuLookUpMgt: Codeunit LookUpManagement;



    procedure fNewRec()
    begin
        if ("Line No." = 0) and ("Contract No." <> '') then begin
            Contract.Get("Contract Type", "Contract No.");
        end;
    end;


    procedure UpdateCust(ContactNo: Code[20])
    var
        ContBusinessRelation: Record "Contact Business Relation";
        Cust: Record Customer;
        Cont: Record Contact;
        CustTemplate: Record "Customer Templ.";
        ContComp: Record Contact;
        recContrHeader: Record Contract;
    begin
        recContrHeader.Get(ContactNo);
        if not Modify then
            Insert
    end;


    procedure UpdateCont(CustomerNo: Code[20])
    var
        ContBusRel: Record "Contact Business Relation";
        Cont: Record Contact;
        Cust: Record Customer;
        ServOrderMgt: Codeunit ServOrderManagement;
        ContactNo: Code[20];
        recContrHeader: Record Contract;
    begin
        recContrHeader.Get("Contract No.");
        if Cust.Get(CustomerNo) then begin
            Clear(ServOrderMgt);
            ContactNo := ServOrderMgt.FindContactInformation(Cust."No.");
        end;
    end;


    procedure ShowSigners()
    var
        recContractSigners: Record "Contract Signer";
        PageContractSigners: Page "Contract Signers";
    begin
        TestField("Contract No.");
        TestField("Line No.");
        recContractSigners.Reset;
        recContractSigners.SetRange("Contract Type", "Contract Type");
        recContractSigners.SetRange("Contract No.", "Contract No.");
        recContractSigners.SetRange("Contract Line No.", "Line No.");
        PageContractSigners.SetTableview(recContractSigners);
        PageContractSigners.RunModal;
    end;


    procedure TestStatusOpen()
    var
        Contract: Record Contract;
    begin
        if StatusCheckSuspended then
            exit;
        Contract.Get("Contract No.");
        Contract.TestField(Status, Contract.Status::Inactive);
    end;


    trigger OnInsert()
    begin
        TestStatusOpen()
    end;

    trigger OnModify()
    begin
        TestStatusOpen()
    end;

    trigger OnDelete()
    begin
        TestStatusOpen();
    end;
}

