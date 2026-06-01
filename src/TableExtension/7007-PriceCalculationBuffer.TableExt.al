tableextension 25006383 "Price Calculation Buffer" extends "Price Calculation Buffer"//7007
{
    fields
    {
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = " ","Spare Parts Trade","Vehicles Trade",Service;

        }
        field(25006002; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            Description = 'Only for Vehicle Trade';
            TableRelation = Make;
        }
        field(25006007; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            Description = 'Only for Vehicle Trade';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));
        }
        field(25006010; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            Description = 'Only for Vehicle Trade';
            TableRelation = Item."No." where("Item Type" = const("Model Version"),
                                              "Make Code" = field("Make Code"),
                                              "Model Code" = field("Model Code"));
        }

        field(25006130; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            Editable = false;
        }

        field(25006373; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            Description = 'Only for Vehicle Trade';
        }
        field(25006700; "Ordering Price Type Code"; Code[10])
        {
            Caption = 'Ordering Price Type Code';
            TableRelation = "Ordering Price Type";
        }

        field(25006701; "Bill-to Customer No."; Code[20])
        {
            Caption = 'Bill-to Customer No.';
            TableRelation = customer;
        }
        field(25006702; "Document Type"; Enum "Sales Document Type")
        {
            Caption = 'Document Type';
        }

        field(25006703; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Sales Header"."No." WHERE("Document Type" = FIELD("Document Type"));
        }
        field(25006704; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(25006705; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";

        }



    }
}
