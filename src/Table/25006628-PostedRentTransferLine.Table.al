Table 25006628 "Posted Rent Transfer Line"
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
            end;
        }
        field(80; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(110; "Rent Asset No."; Code[20])
        {
            Caption = 'Rent Asset No.';
            TableRelation = "Rent Asset";
        }
        field(120; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = ToBeClassified;
            TableRelation = Location where("Use As In-Transit" = const(false));
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
            CaptionClass = '7,25006165,570';
            DataClassification = ToBeClassified;
        }
        field(580; "Variable Field Run 2"; Decimal)
        {
            CaptionClass = '7,25006165,580';
            DataClassification = ToBeClassified;
        }
        field(590; "Variable Field Run 3"; Decimal)
        {
            CaptionClass = '7,25006165,590';
            DataClassification = ToBeClassified;
        }
        field(600; "Service Order No."; Code[20])
        {
            Caption = 'Service Order No.';
            DataClassification = ToBeClassified;
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
        StatusCheckSuspended: Boolean;
        VFMgt: Codeunit "Variable Field Management";


    procedure IsVFActive(intFieldNo: Integer): Boolean
    begin
        Clear(VFMgt);
        exit(VFMgt.IsVFActive(Database::"Posted Rent Transfer Line", intFieldNo));
    end;
}

