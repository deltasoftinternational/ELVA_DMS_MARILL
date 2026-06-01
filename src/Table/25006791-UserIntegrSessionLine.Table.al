Table 25006791 "User Integr. Session Line"
{

    fields
    {
        field(10; "Session ID"; Integer)
        {
            Caption = 'Session ID';
            TableRelation = "User Integr. Session Header";
        }
        field(20; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(100; "Source Type"; Integer)
        {
            Caption = 'Source Type';
            DataClassification = ToBeClassified;
        }
        field(110; "Source Subtype"; Integer)
        {
            Caption = 'Source Subtype';
            DataClassification = ToBeClassified;
        }
        field(120; "Source ID"; Code[20])
        {
            Caption = 'Source ID';
            DataClassification = ToBeClassified;
        }
        field(130; "Source Line No."; Integer)
        {
            Caption = 'Source Line No.';
            DataClassification = ToBeClassified;
        }
        field(200; Status; Option)
        {
            Caption = 'Status';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,OK,Error,Warning';
            OptionMembers = " ",OK,Error,Warning;
        }
        field(1000; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;

            trigger OnValidate()
            begin
                if (xRec."Item No." <> "Item No.") then begin
                    "Variant Code" := '';
                    "Item Description" := '';
                    "Unit Of Measure Code" := '';
                    Validate("Unit Cost", 0);
                    Validate("Unit Price", 0);
                end;

                if "Item No." <> '' then begin
                    Item.Get("Item No.");
                    "Item Description" := Item.Description;
                    "Unit Of Measure Code" := Item."Base Unit of Measure";
                end;
            end;
        }
        field(1010; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            TableRelation = "Item Variant".Code where("Item No." = field("Item No."));
        }
        field(1020; "Item Description"; Text[50])
        {
            Caption = 'Item Description';
        }
        field(1030; "Unit Of Measure Code"; Code[10])
        {
            Caption = 'Unit Of Measure Code';
            TableRelation = "Item Unit of Measure".Code where("Item No." = field("Item No."));
        }
        field(2000; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = Location.Code;
        }
        field(8000; Quantity; Decimal)
        {
            Caption = 'Quantity';
            DecimalPlaces = 0 : 5;
        }
        field(8010; "Available Quantity"; Decimal)
        {
            DataClassification = ToBeClassified;
            DecimalPlaces = 0 : 5;
        }
        field(8100; "Unit Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8110; "Total Cost"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8120; "Unit Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8130; "Total Price"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8200; "Discount, %"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
        field(8210; "Discount Amount"; Decimal)
        {
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Session ID", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Item: Record Item;


    procedure GetStatusStyleExpr(): Text
    begin
        /*
        'StandardAccent'  - blue
        'Strong'          - black bold
        'StrongAccent'    - blue bold
        'Attention'       - red italic
        'AttentionAccent' - blue italic
        'Favorable'       - green
        'Unfavorable'     - red bold italic
        'Ambiguous'       - yellow-orange
        'Subordinate'     - grey
        */

        case Status of
            Status::OK:
                exit('Standard');
            Status::Warning:
                exit('StrongAccent');
            Status::Error:
                exit('Unfavorable');
            else
                exit('Subordinate');
        end;

    end;
}

