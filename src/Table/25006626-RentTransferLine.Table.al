Table 25006626 "Rent Transfer Line"
{

    fields
    {
        field(20; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(40; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(50; "Rent Item No."; Code[20])
        {
            Caption = 'Rent Item No.';
            TableRelation = "Rent Item";

            trigger OnValidate()
            var
                DocumentDate: Date;
            begin
                if (xRec."Rent Item No." <> "Rent Item No.") and ("Rent Item No." <> '') then begin
                    if RentItem.Get("Rent Item No.") then
                        Description := RentItem.Description;
                end;
            end;
        }
        field(80; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(110; "Rent Asset No."; Code[20])
        {
            Caption = 'Rent Asset No.';
            TableRelation = "Rent Asset";

            trigger OnValidate()
            var
                RentAsset: Record "Rent Asset";
            begin
                if (xRec."Rent Asset No." <> "Rent Asset No.") and ("Rent Asset No." <> '') then begin
                    if RentAsset.Get("Rent Asset No.") then begin
                        if RentAsset.Status = RentAsset.Status::Disposed then
                            Error(Err006);

                        if RentAsset."Vehicle Serial No." <> '' then
                            Validate("Vehicle Serial No.", RentAsset."Vehicle Serial No.");
                        "Variable Field 25006800" := RentAsset."Variable Field 25006800";
                        "Variable Field 25006801" := RentAsset."Variable Field 25006801";
                        "Variable Field 25006802" := RentAsset."Variable Field 25006802";
                        "Variable Field 25006803" := RentAsset."Variable Field 25006803";
                        "Variable Field 25006804" := RentAsset."Variable Field 25006804";
                        "Variable Field 25006805" := RentAsset."Variable Field 25006805";
                        "Variable Field 25006806" := RentAsset."Variable Field 25006806";
                        "Variable Field 25006807" := RentAsset."Variable Field 25006807";
                        "Variable Field 25006808" := RentAsset."Variable Field 25006808";
                        "Variable Field 25006809" := RentAsset."Variable Field 25006809";
                        "Variable Field 25006810" := RentAsset."Variable Field 25006810";
                        "Variable Field 25006811" := RentAsset."Variable Field 25006811";
                        "Variable Field 25006812" := RentAsset."Variable Field 25006812";
                        "Variable Field 25006813" := RentAsset."Variable Field 25006813";
                        "Variable Field 25006814" := RentAsset."Variable Field 25006814";
                        "Make Code" := RentAsset."Make Code";
                        "Model Code" := RentAsset."Model Code";
                    end;
                end;
                if (xRec."Rent Asset No." <> "Rent Asset No.") and ("Rent Asset No." = '') then begin
                    Validate("Vehicle Serial No.", '');
                    "Variable Field 25006800" := '';
                    "Variable Field 25006801" := '';
                    "Variable Field 25006802" := '';
                    "Variable Field 25006803" := '';
                    "Variable Field 25006804" := '';
                    "Variable Field 25006805" := '';
                    "Variable Field 25006806" := '';
                    "Variable Field 25006807" := '';
                    "Variable Field 25006808" := '';
                    "Variable Field 25006809" := '';
                    "Variable Field 25006810" := '';
                    "Variable Field 25006811" := '';
                    "Variable Field 25006812" := '';
                    "Variable Field 25006813" := '';
                    "Variable Field 25006814" := '';
                    "Make Code" := '';
                    "Model Code" := '';
                end;
            end;
        }
        field(160; Quantity; Integer)
        {
            Caption = 'Quantity';
        }
        field(190; "Rent Order No."; Code[20])
        {
            Caption = 'Rent Order No.';
            TableRelation = "Rent Header";
        }
        field(200; "Rent Line No."; Integer)
        {
            Caption = 'Rent Line No.';
        }
        field(570; "Variable Field Run 1"; Decimal)
        {
            CaptionClass = '7,25006626,570';
            DataClassification = ToBeClassified;
        }
        field(580; "Variable Field Run 2"; Decimal)
        {
            CaptionClass = '7,25006626,580';
            DataClassification = ToBeClassified;
        }
        field(590; "Variable Field Run 3"; Decimal)
        {
            CaptionClass = '7,25006626,590';
            DataClassification = ToBeClassified;
        }
        field(600; "Service Order No."; Code[20])
        {
            Caption = 'Service Order No.';
            DataClassification = ToBeClassified;
        }
        field(610; "Rent Asset Description"; Text[50])
        {
            CalcFormula = lookup("Rent Asset"."Description" where("No." = field("Rent Asset No.")));
            Caption = 'Rent Asset Description';
            FieldClass = FlowField;
        }
        field(620; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
        }
        field(630; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(640; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));
        }
        field(25006800; "Variable Field 25006800"; Code[20])
        {
            CaptionClass = '7,25006626,25006800';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Rent Transfer Line", FieldNo("Variable Field 25006800"),
                  "Make Code", "Variable Field 25006800") then begin
                    Validate("Variable Field 25006800", VFOptions.Code);
                end;
            end;
        }
        field(25006801; "Variable Field 25006801"; Code[20])
        {
            CaptionClass = '7,25006626,25006801';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Rent Transfer Line", FieldNo("Variable Field 25006801"),
                  "Make Code", "Variable Field 25006801") then begin
                    Validate("Variable Field 25006801", VFOptions.Code);
                end;
            end;
        }
        field(25006802; "Variable Field 25006802"; Code[20])
        {
            CaptionClass = '7,25006626,25006802';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Rent Transfer Line", FieldNo("Variable Field 25006802"),
                  "Make Code", "Variable Field 25006802") then begin
                    Validate("Variable Field 25006802", VFOptions.Code);
                end;
            end;
        }
        field(25006803; "Variable Field 25006803"; Code[20])
        {
            CaptionClass = '7,25006626,25006803';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Rent Transfer Line", FieldNo("Variable Field 25006803"),
                  "Make Code", "Variable Field 25006803") then begin
                    Validate("Variable Field 25006803", VFOptions.Code);
                end;
            end;
        }
        field(25006804; "Variable Field 25006804"; Code[20])
        {
            CaptionClass = '7,25006626,25006804';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Rent Transfer Line", FieldNo("Variable Field 25006804"),
                  "Make Code", "Variable Field 25006804") then begin
                    Validate("Variable Field 25006804", VFOptions.Code);
                end;
            end;
        }
        field(25006805; "Variable Field 25006805"; Code[20])
        {
            CaptionClass = '7,25006626,25006805';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Rent Transfer Line", FieldNo("Variable Field 25006805"),
                  "Make Code", "Variable Field 25006805") then begin
                    Validate("Variable Field 25006805", VFOptions.Code);
                end;
            end;
        }
        field(25006806; "Variable Field 25006806"; Code[20])
        {
            CaptionClass = '7,25006626,25006806';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Rent Transfer Line", FieldNo("Variable Field 25006806"),
                  "Make Code", "Variable Field 25006806") then begin
                    Validate("Variable Field 25006806", VFOptions.Code);
                end;
            end;
        }
        field(25006807; "Variable Field 25006807"; Code[20])
        {
            CaptionClass = '7,25006626,25006807';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Rent Transfer Line", FieldNo("Variable Field 25006807"),
                  "Make Code", "Variable Field 25006807") then begin
                    Validate("Variable Field 25006807", VFOptions.Code);
                end;
            end;
        }
        field(25006808; "Variable Field 25006808"; Code[20])
        {
            CaptionClass = '7,25006626,25006808';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Rent Transfer Line", FieldNo("Variable Field 25006808"),
                  "Make Code", "Variable Field 25006808") then begin
                    Validate("Variable Field 25006808", VFOptions.Code);
                end;
            end;
        }
        field(25006809; "Variable Field 25006809"; Code[20])
        {
            CaptionClass = '7,25006626,25006809';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Rent Transfer Line", FieldNo("Variable Field 25006809"),
                  "Make Code", "Variable Field 25006809") then begin
                    Validate("Variable Field 25006809", VFOptions.Code);
                end;
            end;
        }
        field(25006810; "Variable Field 25006810"; Code[20])
        {
            CaptionClass = '7,25006626,25006810';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Rent Transfer Line", FieldNo("Variable Field 25006810"),
                  "Make Code", "Variable Field 25006810") then begin
                    Validate("Variable Field 25006810", VFOptions.Code);
                end;
            end;
        }
        field(25006811; "Variable Field 25006811"; Code[20])
        {
            CaptionClass = '7,25006626,25006811';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Rent Transfer Line", FieldNo("Variable Field 25006811"),
                  "Make Code", "Variable Field 25006811") then begin
                    Validate("Variable Field 25006811", VFOptions.Code);
                end;
            end;
        }
        field(25006812; "Variable Field 25006812"; Code[20])
        {
            CaptionClass = '7,25006626,25006812';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Rent Transfer Line", FieldNo("Variable Field 25006812"),
                  "Make Code", "Variable Field 25006812") then begin
                    Validate("Variable Field 25006812", VFOptions.Code);
                end;
            end;
        }
        field(25006813; "Variable Field 25006813"; Code[20])
        {
            CaptionClass = '7,25006626,25006813';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Rent Transfer Line", FieldNo("Variable Field 25006813"),
                  "Make Code", "Variable Field 25006813") then begin
                    Validate("Variable Field 25006813", VFOptions.Code);
                end;
            end;
        }
        field(25006814; "Variable Field 25006814"; Code[20])
        {
            CaptionClass = '7,25006626,25006814';

            trigger OnLookup()
            var
                VFOptions: Record "Variable Field Options";
            begin
                VFOptions.Reset;
                if LookupMgt.LookUpVariableField(VFOptions, Database::"Rent Transfer Line", FieldNo("Variable Field 25006814"),
                  "Make Code", "Variable Field 25006814") then begin
                    Validate("Variable Field 25006814", VFOptions.Code);
                end;
            end;
        }
    }

    keys
    {
        key(Key1; "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        Quantity := 1;
    end;

    var
        UserSetup: Record "User Setup";
        RentItemSalesPrice: Record "Rent Item Sales Price";
        RentItem: Record "Rent Item";
        RentPackage: Record "Rent Package";
        RentPackageLine: Record "Rent Package Line";
        RentLine: Record "Rent Line";
        RentSalesLine: Record "Rent Sales Line";
        RentHeader: Record "Rent Header";
        RentPeriod: Record "Rent Period";
        Currency: Record Currency;
        LineNo: Integer;
        SalesLineInvQty: Integer;
        Err001: label 'Quantity to Invoice can''t be greater than %1';
        Err006: label 'Can''t use this Rent Asset. Rent Asset is Disposed.';
        StatusCheckSuspended: Boolean;
        EDMS001: label 'The new kilometrage is less than the previous one.';
        EDMS002: label 'The new motor hours are less than the previous one.';
        FA: Record "Fixed Asset";
        Vehicle: Record Vehicle;
        LookupMgt: Codeunit LookUpManagement;
        VFMgt: Codeunit "Variable Field Management";


    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::"Rent Transfer Line", intFieldNo));
    end;
}

