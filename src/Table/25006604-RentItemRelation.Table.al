Table 25006604 "Rent Item Relation"
{

    fields
    {
        field(1; "Rent Item No."; Code[20])
        {
            Caption = 'Rent Item No.';
            TableRelation = "Rent Item";
        }
        field(3; "Rent Asset No."; Code[20])
        {
            Caption = 'Rent Assetn No.';
            TableRelation = "Rent Asset";
        }
        field(4; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(5; "Rent Item Description"; Text[100])
        {
            CalcFormula = lookup("Rent Item".Description where("No." = field("Rent Item No.")));
            Caption = 'Rent Item Description';
            FieldClass = FlowField;
        }
        field(6; "Rent Item Category Code"; Code[10])
        {
            CalcFormula = lookup("Rent Item"."Rent Item Category Code" where("No." = field("Rent Item No.")));
            Caption = 'Rent Item Category Code';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Rent Item Category";

            trigger OnValidate()
            var
                ProductSubgrp: Record "Product Subgroup";
            begin
            end;
        }
        field(7; "Rent Product Group Code"; Code[10])
        {
            CalcFormula = lookup("Rent Item"."Rent Product Group Code" where("No." = field("Rent Item No.")));
            Caption = 'Rent Product Group Code';
            Editable = false;
            FieldClass = FlowField;
            TableRelation = "Rent Product Group".Code where("Rent Item Category Code" = field("Rent Item Category Code"));

            trigger OnValidate()
            var
                ProductSubgrp: Record "Product Subgroup";
            begin
            end;
        }
        field(8; "Rent Item Description 2"; Text[100])
        {
            CalcFormula = lookup("Rent Item"."Description 2" where("No." = field("Rent Item No.")));
            Caption = 'Rent Item Description 2';
            FieldClass = FlowField;
        }

        field(20; "Rent Asset Description"; Text[50])
        {
            CalcFormula = lookup("Rent Asset"."Description" where("No." = field("Rent Asset No.")));
            Caption = 'Rent Asset Description';
            FieldClass = FlowField;
        }

        field(30; "Rent Asset Description 2"; Text[50])
        {
            CalcFormula = lookup("Rent Asset"."Description 2" where("No." = field("Rent Asset No.")));
            Caption = 'Rent Asset Description 2';
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Rent Item No.", "Rent Asset No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


}

