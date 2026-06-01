Table 25006206 "Warranty Journal Line"
{
    // 12.06.2013 EDMS P8
    //   * Merged code with NAV2009
    // 
    // 2012.07.31 EDMS, P8
    //   * changed type of field 'Variable Field Run 1' - now it is decimal
    //   * added fields: 'Variable Field Run 2', 'Variable Field Run 3', 'Document Line No.', 'Plan No.'
    // 
    // 2012.04.12 EDMS P8
    //   * removed field "Resource No."(580)
    // 
    // 29.09.2011 EDMS P8
    //   * Implement Tire Management, added fields:
    //   *   Vehicle Axle Code
    //   *   Tire Position Code
    //   *   Tire Code
    //   *   Tire Entry
    // 
    // 14.12.2011 EDMS P8
    //   * MATH DIVIDE must checked for zero before act
    // 
    // 07.11.2011 EDMS P8
    //   * VALIDATION triggers are recoded
    // 
    // 28.01.2010 EDMSB P2
    //   * Added field "Standard Time", "Campaign No.", "Amount Including VAT (LCY)"
    // 
    // 20.10.2008. EDMS P2
    //   * Added field "Deal Type Code"
    // 
    // 05.03.2008 EDMS P2
    //   * Added fields "Package No."
    //                  "Package Version No."
    //                  "Package Version Spec. Line No."
    // 
    // * Serial No. - onvalidate
    // Working with dimensions is disabled (need to think about how to realize it)
    // See another validates also

    Caption = 'Warranty Journal Line';

    fields
    {
        field(10; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Warranty Journal Template";
        }
        field(20; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Warranty Journal Batch".Name where("Journal Template Name" = field("Journal Template Name"));
        }
        field(30; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(33; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,G/L Account,Item,Labor,External Service';
            OptionMembers = " ","G/L Account",Item,Labor,"External Service";

            trigger OnValidate()
            var
                ServiceHeader: Record "Service Header EDMS";
                recMarkup: Record "Sales/Serv. Item Markup";
                recItemDisc: Record "Sales Line Discount";
                recLabTransl: Record "Service Labor Translation";
                recItemTransl: Record "Item Translation";
            begin
            end;
        }
        field(40; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(60; "Document Date"; Date)
        {
            Caption = 'Document Date';
        }
        field(70; "Debit Code"; Code[20])
        {
            Caption = 'Debit Code';
        }
        field(80; "Debit Description"; Text[50])
        {
            Caption = 'Debit Description';
        }
        field(90; "Reject Code"; Code[20])
        {
            Caption = 'Reject Code';
        }
        field(100; "Reject Description"; Text[50])
        {
            Caption = 'Reject Description';
        }
        field(110; Status; Option)
        {
            Caption = 'Status';
            OptionMembers = Approved,Rejected;
        }
        field(120; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(130; "Currency Code"; Code[20])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(140; "Posting Date"; Date)
        {
            Caption = 'Posting Date';

            trigger OnValidate()
            begin
                Validate("Document Date", "Posting Date");
            end;
        }
        field(145; VIN; Code[20])
        {
            Caption = 'VIN';
            //This property is currently not supported
            //TestTableRelation = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;

            trigger OnLookup()
            var
                Vehicle: Record Vehicle;
            begin
                // 23.04.2015 EDMS P21 >>
                // IF LookUpMgt.LookUpVehicleAMT(Vehicle,"Vehicle Serial No.") THEN
                //  VALIDATE("Vehicle Serial No.",Vehicle."Serial No.");
                OnLookupVIN;
                // 23.04.2015 EDMS P21 <<
            end;

            trigger OnValidate()
            begin
                //TESTFIELD(Status,Status::Open);

                // 20.02.2015 EDMS P21 >>
                if VIN = '' then begin
                    Validate("Vehicle Serial No.", '');
                    exit;
                end;

                Vehicle.Reset;
                Vehicle.SetCurrentkey(VIN);
                Vehicle.SetRange(VIN, VIN);
                if Vehicle.FindFirst then begin
                    if "Vehicle Serial No." <> Vehicle."Serial No." then
                        Validate("Vehicle Serial No.", Vehicle."Serial No.")
                end else begin
                    MessageLoc(StrSubstNo(Text137, Vehicle.TableCaption, FieldCaption(VIN), VIN), '');
                    //IF "Document Type" <> "Document Type"::Quote THEN
                    VIN := xRec.VIN;
                end;
                // 20.02.2015 EDMS P21 <<
            end;
        }
        field(150; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;

            trigger OnValidate()
            begin
                Veh.Get("Vehicle Serial No.");
                Veh.CalcFields("Model Commercial Name");

                Veh.TestField(Blocked, false);

                "Make Code" := Veh."Make Code";
                "Model Code" := Veh."Model Code";
                "Model Version No." := Veh."Model Version No.";
            end;
        }
        field(160; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            Editable = false;
            TableRelation = Make;
        }
        field(170; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));
        }
        field(180; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item."No." where("Make Code" = field("Make Code"),
                                              "Model Code" = field("Model Code"),
                                              "Item Type" = const("Model Version"));

            trigger OnLookup()
            var
                recItem: Record Item;
                LookupMgt: Codeunit LookUpManagement;
            begin
            end;
        }
        field(190; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Editable = false;
            TableRelation = "Vehicle Accounting Cycle";
        }
        field(200; "Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
        field(250; "Recurring Method"; Option)
        {
            BlankZero = true;
            Caption = 'Recurring Method';
            OptionCaption = ',Fixed,Variable';
            OptionMembers = ,"Fixed",Variable;
        }
        field(270; "Recurring Frequency"; DateFormula)
        {
            Caption = 'Recurring Frequency';
        }
        field(280; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";

            trigger OnValidate()
            begin
                WarrantyJnlLine.SetRange("Journal Template Name", "Journal Template Name");
                WarrantyJnlLine.ModifyAll("Source Code", "Source Code");
                Modify;
            end;
        }
        field(290; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(300; "Warranty Document No."; Code[20])
        {
            TableRelation = "Warranty Document Header";

            trigger OnValidate()
            var
                WarrantyDocumentHeader: Record "Warranty Document Header";
            begin
                if "Warranty Document No." <> xRec."Warranty Document No." then
                    "Warranty Document Line No." := 0;

                if WarrantyDocumentHeader.Get("Warranty Document No.") then begin
                    VIN := WarrantyDocumentHeader.VIN;
                    "Vehicle Serial No." := WarrantyDocumentHeader."Vehicle Serial No.";
                    "Vehicle Accounting Cycle No." := WarrantyDocumentHeader."Vehicle Accounting Cycle No.";
                    "Make Code" := WarrantyDocumentHeader."Make Code";
                    "Model Code" := WarrantyDocumentHeader."Model Code";
                    "Model Version No." := WarrantyDocumentHeader."Model Version No.";
                end;
            end;
        }
        field(310; "Warranty Document Line No."; Integer)
        {
            TableRelation = "Warranty Document Line"."Line No." where("Document No." = field("Warranty Document No."));

            trigger OnValidate()
            var
                WarrantyDocumentLine: Record "Warranty Document Line";
            begin
                if WarrantyDocumentLine.Get("Warranty Document No.", "Warranty Document Line No.") then begin
                    Type := WarrantyDocumentLine.Type;
                    "No." := WarrantyDocumentLine."No.";
                    Description := WarrantyDocumentLine.Description;
                end;
            end;
        }
        field(51200; "Labor Type"; Option)
        {
            Caption = 'Labor Type';
            OptionCaption = 'Labor,Travel Time,Travel Distance,Travel Other,Meal Allowance,Other';
            OptionMembers = Labor,"Travel Time","Travel Distance","Travel Other","Meal Allowance",Other;
        }
        field(52205; "Debit Code Type"; Boolean)
        {
        }
        field(52206; CoverageId; Text[250])
        {
        }
        field(52207; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(52208; Description; Text[100])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Journal Template Name", "Journal Batch Name", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        // 26.10.2012 EDMS <<
        /*
        DimMgt.DeleteJnlLineDim(
          DATABASE::"Serv. Journal Line",
          "Journal Template Name","Journal Batch Name","Line No.",0);
        */
        // 26.10.2012 EDMS <<

    end;

    trigger OnInsert()
    begin
        LockTable;
        WarrantyJnlTemplate.Get("Journal Template Name");
        WarrantyJnlBatch.Get("Journal Template Name", "Journal Batch Name");
    end;

    var
        WarrantyJnlTemplate: Record "Warranty Journal Template";
        WarrantyJnlBatch: Record "Warranty Journal Batch";
        WarrantyJnlLine: Record "Warranty Journal Line";
        Veh: Record Vehicle;
        Customer: Record Customer;
        GLSetup: Record "General Ledger Setup";
        GLAcc: Record "G/L Account";
        Labor: Record "Service Labor";
        UnitOfMeasure: Record "Unit of Measure";
        ResFindUnitCost: Codeunit "Resource-Find Cost";
        ResFindUnitPrice: Codeunit "Resource-Find Price";
        NoSeriesMgt: Codeunit "No. Series";
        DimMgt: Codeunit DimensionManagement;
        GLSetupRead: Boolean;
        Item: Record Item;
        cuVFMgt: Codeunit "Variable Field Management";
        cuLookupMgt: Codeunit LookUpManagement;
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        ExternalService: Record "External Service";
        Currency: Record Currency;
        RoundingPrecision: Decimal;
        LCYRoundingPrecision: Decimal;
        RoundingPrecisionUnit: Decimal;
        LCYRoundingPrecisionUnit: Decimal;
        FCYRate: Decimal;
        HideValidationDialog: Boolean;
        Vehicle: Record Vehicle;
        LookUpMgt: Codeunit LookUpManagement;
        NoVehicleTxt: label 'There is no vehicle with %1 %2';
        Text137: label 'There is no %1 with %2 %3';


    procedure EmptyLine(): Boolean
    begin
        exit("Document No." = '');
    end;


    procedure SetUpNewLine(LastWarrantyJnlLine: Record "Warranty Journal Line")
    begin
        WarrantyJnlTemplate.Get("Journal Template Name");
        WarrantyJnlBatch.Get("Journal Template Name", "Journal Batch Name");
        WarrantyJnlLine.SetRange("Journal Template Name", "Journal Template Name");
        WarrantyJnlLine.SetRange("Journal Batch Name", "Journal Batch Name");
        if WarrantyJnlLine.FindFirst then begin
            "Posting Date" := LastWarrantyJnlLine."Posting Date";
            "Document Date" := LastWarrantyJnlLine."Document Date";
            "Document No." := LastWarrantyJnlLine."Document No.";
        end else begin
            "Posting Date" := WorkDate;
            "Document Date" := WorkDate;
            if WarrantyJnlBatch."No. Series" <> '' then begin
                Clear(NoSeriesMgt);
                "Document No." := NoSeriesMgt.PeekNextNo(WarrantyJnlBatch."No. Series", "Posting Date");
            end;
        end;
    end;

    local procedure GetGLSetup()
    begin
        if not GLSetupRead then
            GLSetup.Get;
        GLSetupRead := true;
    end;


    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        Clear(cuVFMgt);
        exit(cuVFMgt.IsVFActive(Database::"Serv. Journal Line", intFieldNo));
    end;


    procedure MessageLoc(MessageTxt: Text[1024]; RunParStr: Text[1024])
    begin
        // RunParStr not used for now
        if not HideValidationDialog then
            Message(MessageTxt);
    end;


    procedure OnLookupVIN()
    var
        Vehicle: Record Vehicle;
    begin
        if LookUpMgt.LookUpVehicleAMT(Vehicle, "Vehicle Serial No.") then
            Validate("Vehicle Serial No.", Vehicle."Serial No.");
    end;
}

