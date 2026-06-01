Table 25006601 "Rent Item"
{
    Caption = 'Rent Item';
    DrillDownPageID = "Rent Item List";
    LookupPageID = "Rent Item List";

    fields
    {
        field(10; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(20; Description; Text[100])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                if ("Search Description" = UpperCase(xRec.Description)) or ("Search Description" = '') then
                    "Search Description" := Description;
            end;
        }
        field(25; "Description 2"; Text[100])
        {
            Caption = 'Description 2';
        }
        field(30; "Search Description"; Code[50])
        {
            Caption = 'Search Description';
        }
        field(40; "Rent Item Category Code"; Code[10])
        {
            Caption = 'Rent Item Category Code';
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
            TableRelation = "Rent Product Group".Code where("Rent Item Category Code" = field("Rent Item Category Code"));

            trigger OnValidate()
            var
                ProductSubgrp: Record "Product Subgroup";
            begin
            end;
        }
        field(60; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(70; "Default Rent Package No."; Code[20])
        {
            Caption = 'Default Rent Package No.';
            TableRelation = "Rent Package";
        }
        field(80; "Global Dimension 1 Code"; Code[20])
        {
            CaptionClass = '1,1,1';
            Caption = 'Global Dimension 1 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(90; "Global Dimension 2 Code"; Code[20])
        {
            CaptionClass = '1,1,2';
            Caption = 'Global Dimension 2 Code';
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(100; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));
        }
        field(500; "Resource No."; Code[20])
        {
            TableRelation = Resource;
        }
        field(510; "Extra Charge Resource No."; Code[20])
        {
            TableRelation = Resource;
        }
        field(520; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(530; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            NotBlank = true;
            TableRelation = Make;

            trigger OnValidate()
            var
                DefDim: Record "Default Dimension";
                MakeDefDim: Record "Default Dimension";
            begin
                MakeDefDim.Reset;
                MakeDefDim.SetRange("Table ID", Database::Make);
                MakeDefDim.SetRange("No.", "Make Code");
                If MakeDefDim.FindFirst then
                    repeat
                        DefDim.Reset;
                        DefDim.SetRange("Table ID", Database::"Rent Item");
                        DefDim.SetRange("No.", "No.");
                        DefDim.SetRange("Dimension Code", MakeDefDim."Dimension Code");
                        if DefDim.Find('-') then begin
                            DefDim."Dimension Value Code" := MakeDefDim."Dimension Value Code";
                            DefDim."Value Posting" := DefDim."value posting"::" ";
                            DefDim.Modify(true);
                        end else begin
                            DefDim.Init;
                            DefDim."Table ID" := Database::"Rent Item";
                            DefDim."No." := "No.";
                            DefDim."Dimension Code" := MakeDefDim."Dimension Code";
                            DefDim."Dimension Value Code" := MakeDefDim."Dimension Value Code";
                            DefDim."Value Posting" := DefDim."value posting"::" ";
                            DefDim.Insert(true);
                        end;
                    until MakeDefDim.Next = 0;
            end;
        }
        field(540; "Variable Field 1"; Code[20])
        {
            CaptionClass = '7,25006601,540';
            DataClassification = ToBeClassified;
            TableRelation = Resource;
        }
        field(541; "Variable Field 2"; Code[20])
        {
            CaptionClass = '7,25006601,541';
            DataClassification = ToBeClassified;
            TableRelation = Resource;
        }
        field(542; "Variable Field 3"; Code[20])
        {
            CaptionClass = '7,25006601,542';
            DataClassification = ToBeClassified;
            TableRelation = Resource;
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
            "No. Series" := RentSetup."Rent Item Nos.";
            "No." := NoSeriesMgt.GetNextNo("No. Series", 0D, true);
        end;
    end;

    var
        RentSetup: Record "Rent Mgt. Setup";
        Rent: Record "Rent Item";
        NoSeriesMgt: Codeunit "No. Series";
        DimMgt: Codeunit DimensionManagement;

    procedure AssistEdit(): Boolean
    begin
        RentSetup.Get;
        RentSetup.TestField("Rent Item Nos.");
        if NoSeriesMgt.LookupRelatedNoSeries(RentSetup."Rent Item Nos.", xRec."No. Series", "No. Series") then begin
            "No." := NoSeriesMgt.GetNextNo("No. Series", WorkDate(), true);
            exit(true);
        end;
    end;


    procedure IsVFActive(intFieldNo: Integer): Boolean
    var
        VFMgt: Codeunit "Variable Field Management";
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::"Rent Line", intFieldNo));
    end;
}

