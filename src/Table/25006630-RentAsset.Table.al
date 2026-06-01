Table 25006630 "Rent Asset"
{
    Caption = 'Rent Asset';
    DrillDownPageID = "Rent Asset List";
    LookupPageID = "Rent Asset List";

    fields
    {
        field(10; "No."; Code[20])
        {
            Caption = 'No.';
            DataClassification = ToBeClassified;
        }
        field(20; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;

            trigger OnValidate()
            begin
                if ("Search Description" = UpperCase(xRec.Description)) or ("Search Description" = '') then
                    "Search Description" := Description;
            end;
        }
        field(25; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
            DataClassification = ToBeClassified;
        }
        field(30; "Search Description"; Code[50])
        {
            Caption = 'Search Description';
            DataClassification = ToBeClassified;
        }
        field(40; "Rent Item Category Code"; Code[10])
        {
            Caption = 'Rent Item Category Code';
            DataClassification = ToBeClassified;
            TableRelation = "Rent Item Category";

            trigger OnValidate()
            var
                ProductSubgrp: Record "Product Subgroup";
            begin
            end;
        }
        field(50; "Rent Product Group Code"; Code[10])
        {
            Caption = 'Rent Product Group Code';
            DataClassification = ToBeClassified;
            TableRelation = "Rent Product Group".Code where("Rent Item Category Code" = field("Rent Item Category Code"));

            trigger OnValidate()
            var
                ProductSubgrp: Record "Product Subgroup";
            begin
            end;
        }
        field(60; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "No. Series";
        }
        field(70; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            DataClassification = ToBeClassified;
            NotBlank = true;
            TableRelation = Make;
        }
        field(80; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            DataClassification = ToBeClassified;
            TableRelation = Model.Code where("Make Code" = field("Make Code"));
        }
        field(90; "Location Code"; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = Location.Code;
            Caption = 'Default Stock Location Code';
        }
        field(100; Status; Option)
        {
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Available,Reserved,Rented,Received,Service Planned,Service,Other,Disposed';
            OptionMembers = " ",Available,Reserved,Rented,Received,"Service Planned",Service,Other,Disposed;
        }
        field(110; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            DataClassification = ToBeClassified;
            TableRelation = Vehicle."Serial No.";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                Vehicle: Record Vehicle;
                CheckAssets: Record "Rent Asset";
                ErrVehicleSN: label 'Vehicle Serial No. %1 already is assigned to other Rent Asset.';
            begin
                if "Vehicle Serial No." <> '' then begin
                    CheckAssets.Reset;
                    CheckAssets.SetRange("Vehicle Serial No.", "Vehicle Serial No.");
                    CheckAssets.SetFilter("No.", '<>%1', "No.");
                    if CheckAssets.FindFirst then
                        Error(ErrVehicleSN, "Vehicle Serial No.");
                end;

                if Vehicle.Get("Vehicle Serial No.") and ("Serial No." = '') then begin
                    if "Serial No." = '' then
                        "Serial No." := Vehicle.VIN;
                    if "Make Code" = '' then
                        "Make Code" := Vehicle."Make Code";
                    if "Model Code" = '' then
                        "Model Code" := Vehicle."Model Code";
                end;
            end;
        }
        field(111; "Serial No."; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(120; Quantity; Decimal)
        {
            CalcFormula = sum("Rent Ledger Entry".Quantity where("Posting Date" = field("Date Filter"),
                                                                  "Location Code" = field("Location Filter"),
                                                                  "Entry Type" = filter(Inventory)));
            Caption = 'Quantity';
            FieldClass = FlowField;
        }
        field(130; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(140; "Location Filter"; Code[10])
        {
            Caption = 'Location Filter';
            FieldClass = FlowFilter;
        }
        field(150; "Fixed Asset No."; Code[20])
        {
            Caption = 'Fixed Asset No.';
            DataClassification = ToBeClassified;
            TableRelation = "Fixed Asset";
        }

        field(165; "Asset Type"; Option)
        {
            Caption = 'Individual,Multiple';
            OptionCaption = 'Individual,Multiple';
            OptionMembers = "Individual","Multiple";
        }
        field(170; "Model Commercial Name"; Text[50])
        {
            CalcFormula = lookup(Model."Commercial Name" where("Make Code" = field("Make Code"),
                                                                Code = field("Model Code")));
            Caption = 'Model Commercial Name';
            FieldClass = FlowField;
        }
        field(180; "Current Location Code"; Code[20])
        {
            CalcFormula = lookup("Rent Ledger Entry"."Location Code" where("Rent Asset No." = field("No."),
                                                                Open = Const(true)));
            Caption = 'Current Location Code';
            FieldClass = FlowField;
        }
        field(190; "Inventory"; Decimal)
        {
            CalcFormula = Sum("Rent Ledger Entry"."Available Quantity" WHERE("Rent Asset No." = FIELD("No."),
                                                                  "Location Code" = FIELD("Location Filter")));
            Caption = 'Inventory';
            DecimalPlaces = 0 : 5;
            Editable = false;
            FieldClass = FlowField;
        }
        field(200; "Main Asset/Component"; Option)
        {
            Caption = 'Main Asset/Component';
            Editable = false;
            OptionCaption = ' ,Main Asset,Component';
            OptionMembers = " ","Main Asset",Component;
        }
        field(210; "Component of Main Asset"; Code[20])
        {
            Caption = 'Component of Main Asset';
            Editable = false;
            TableRelation = "Rent Asset";
        }
        field(25006800; "Variable Field 25006800"; Code[20])
        {
            CaptionClass = '7,25006630,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Rent Asset", FieldNo("Variable Field 25006800"),
                  "Make Code", "Variable Field 25006800") then begin
                    Validate("Variable Field 25006800", VFOptions.Code);
                end;
            end;
        }
        field(25006801; "Variable Field 25006801"; Code[20])
        {
            CaptionClass = '7,25006630,25006801';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Rent Asset", FieldNo("Variable Field 25006801"),
                  "Make Code", "Variable Field 25006801") then begin
                    Validate("Variable Field 25006801", VFOptions.Code);
                end;
            end;
        }
        field(25006802; "Variable Field 25006802"; Code[20])
        {
            CaptionClass = '7,25006630,25006802';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Rent Asset", FieldNo("Variable Field 25006802"),
                  "Make Code", "Variable Field 25006802") then begin
                    Validate("Variable Field 25006802", VFOptions.Code);
                end;
            end;
        }
        field(25006803; "Variable Field 25006803"; Code[20])
        {
            CaptionClass = '7,25006630,25006803';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Rent Asset", FieldNo("Variable Field 25006803"),
                  "Make Code", "Variable Field 25006803") then begin
                    Validate("Variable Field 25006803", VFOptions.Code);
                end;
            end;
        }
        field(25006804; "Variable Field 25006804"; Code[20])
        {
            CaptionClass = '7,25006630,25006804';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Rent Asset", FieldNo("Variable Field 25006804"),
                  "Make Code", "Variable Field 25006804") then begin
                    Validate("Variable Field 25006804", VFOptions.Code);
                end;
            end;
        }
        field(25006805; "Variable Field 25006805"; Code[20])
        {
            CaptionClass = '7,25006630,25006805';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Rent Asset", FieldNo("Variable Field 25006805"),
                  "Make Code", "Variable Field 25006805") then begin
                    Validate("Variable Field 25006805", VFOptions.Code);
                end;
            end;
        }
        field(25006806; "Variable Field 25006806"; Code[20])
        {
            CaptionClass = '7,25006630,25006806';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Rent Asset", FieldNo("Variable Field 25006806"),
                  "Make Code", "Variable Field 25006806") then begin
                    Validate("Variable Field 25006806", VFOptions.Code);
                end;
            end;
        }
        field(25006807; "Variable Field 25006807"; Code[20])
        {
            CaptionClass = '7,25006630,25006807';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Rent Asset", FieldNo("Variable Field 25006807"),
                  "Make Code", "Variable Field 25006807") then begin
                    Validate("Variable Field 25006807", VFOptions.Code);
                end;
            end;
        }
        field(25006808; "Variable Field 25006808"; Code[20])
        {
            CaptionClass = '7,25006630,25006808';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Rent Asset", FieldNo("Variable Field 25006808"),
                  "Make Code", "Variable Field 25006808") then begin
                    Validate("Variable Field 25006808", VFOptions.Code);
                end;
            end;
        }
        field(25006809; "Variable Field 25006809"; Code[20])
        {
            CaptionClass = '7,25006630,25006809';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Rent Asset", FieldNo("Variable Field 25006809"),
                  "Make Code", "Variable Field 25006809") then begin
                    Validate("Variable Field 25006809", VFOptions.Code);
                end;
            end;
        }
        field(25006810; "Variable Field 25006810"; Code[20])
        {
            CaptionClass = '7,25006630,25006810';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Rent Asset", FieldNo("Variable Field 25006810"),
                  "Make Code", "Variable Field 25006810") then begin
                    Validate("Variable Field 25006810", VFOptions.Code);
                end;
            end;
        }
        field(25006811; "Variable Field 25006811"; Code[20])
        {
            CaptionClass = '7,25006630,25006811';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Rent Asset", FieldNo("Variable Field 25006811"),
                  "Make Code", "Variable Field 25006811") then begin
                    Validate("Variable Field 25006811", VFOptions.Code);
                end;
            end;
        }
        field(25006812; "Variable Field 25006812"; Code[20])
        {
            CaptionClass = '7,25006630,25006812';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Rent Asset", FieldNo("Variable Field 25006812"),
                  "Make Code", "Variable Field 25006812") then begin
                    Validate("Variable Field 25006812", VFOptions.Code);
                end;
            end;
        }
        field(25006813; "Variable Field 25006813"; Code[20])
        {
            CaptionClass = '7,25006630,25006813';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Rent Asset", FieldNo("Variable Field 25006813"),
                  "Make Code", "Variable Field 25006813") then begin
                    Validate("Variable Field 25006813", VFOptions.Code);
                end;
            end;
        }
        field(25006814; "Variable Field 25006814"; Code[20])
        {
            CaptionClass = '7,25006630,25006814';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Rent Asset", FieldNo("Variable Field 25006814"),
                  "Make Code", "Variable Field 25006814") then begin
                    Validate("Variable Field 25006814", VFOptions.Code);
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        if "No." = '' then begin
            RentSetup.Get;
            RentSetup.TestField("Rent Item Nos.");
            "No. Series" := RentSetup."Rent Asset Nos.";
            "No." := NoSeriesMgt.GetNextNo("No. Series", 0D, true);
        end;
    end;

    trigger OnDelete()
    var
        RentAssetComponent: Record "Rent Asset Component";
        RentLine: Record "Rent Line";
        RentItemRelation: Record "Rent Item Relation";
    begin
        RentLine.Reset();
        RentLine.SetRange("Rent Asset No.", "No.");
        if RentLine.FindFirst() then
            Error(Error001);

        RentAssetComponent.Reset();
        RentAssetComponent.SetRange("Main Asset No.", "No.");
        if RentAssetComponent.FindFirst() then
            Error(Error003);

        RentAssetComponent.Reset();
        RentAssetComponent.SetRange("Rent Asset No.", "No.");
        if RentAssetComponent.FindFirst() then
            Error(Error002, RentAssetComponent."Main Asset No.");

        RentItemRelation.Reset();
        RentItemRelation.SetRange("Rent Asset No.", "No.");
        RentItemRelation.DeleteAll();
    end;

    var
        RentSetup: Record "Rent Mgt. Setup";
        NoSeriesMgt: Codeunit "No. Series";
        LookupMgt: Codeunit LookUpManagement;
        VFMgt: Codeunit "Variable Field Management";
        Error001: Label 'You can not delete this Rent Asset. It is in a rent line.';
        Error002: Label 'You can not delete this Rent Asset. It is linked to Main Asset %1.';
        Error003: Label 'You can not delete this Rent Asset. It has components linked to it.';


    procedure AssistEdit(): Boolean
    begin
        RentSetup.Get;
        RentSetup.TestField("Rent Asset Nos.");
        if NoSeriesMgt.LookupRelatedNoSeries(RentSetup."Rent Asset Nos.", xRec."No. Series", "No. Series") then begin
            "No." := NoSeriesMgt.GetNextNo("No. Series", WorkDate(), true);
            exit(true);
        end;
    end;


    procedure IsVFActive(FieldNo: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::"Rent Asset", FieldNo));
    end;
}

