Table 25006747 "Lost Sales Entry"
{
    Caption = 'Lost Sales Entry';
    LookupPageID = "Lost Sales Entries";

    fields
    {
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(20; Date; Date)
        {
            Caption = 'Date';
        }
        field(30; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = Item;
        }
        field(40; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
        }
        //field(50;"Product Group Code";Code[10])
        //{
        //    Caption = 'Product Group Code';
        //}
        //field(60;"Product Subgroup Code";Code[10])
        //{
        //    Caption = 'Product Subgroup Code';
        //}
        field(70; "Customer No."; Code[20])
        {
            Caption = 'Customer No.';
            TableRelation = Customer;
        }
        field(80; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(90; "Description 2"; Text[30])
        {
            Caption = 'Description 2';
        }
        field(100; "Reason Code"; Code[20])
        {
            Caption = 'Reason Code';
            TableRelation = "Lost Sales Reason";
        }
        field(110; "Reason Description"; Text[30])
        {
            CalcFormula = lookup("Lost Sales Reason".Description where(Code = field("Reason Code")));
            Caption = 'Reason Description';
            Editable = false;
            FieldClass = FlowField;
        }
        field(120; "Reason Description 2"; Text[30])
        {
            CalcFormula = lookup("Lost Sales Reason"."Description 2" where(Code = field("Reason Code")));
            Caption = 'Reason Description 2';
            Editable = false;
            FieldClass = FlowField;
        }
        field(130; Priority; Option)
        {
            Caption = 'Priority';
            OptionCaption = ',Highest,High,Medium,Low,Lowest';
            OptionMembers = ,Highest,High,Medium,Low,Lowest;
        }
        field(150; Automatic; Boolean)
        {
            Caption = 'Automatic';
            Description = 'For example, on line deletion';
        }
        field(160; "Location Code"; Code[20])
        {
            Caption = 'Location Code';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Item No.")
        {
        }
    }

    fieldgroups
    {
    }
}

