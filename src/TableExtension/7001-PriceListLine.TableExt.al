tableextension 25006382 "Price List Line" extends "Price List Line"//7001
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

        field(25006373; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            Description = 'Only for Vehicle Trade';
            TableRelation = Vehicle;
        }
        field(25006700; "Ordering Price Type Code"; Code[10])
        {
            Caption = 'Ordering Price Type Code';
            TableRelation = "Ordering Price Type";
        }
        field(25006770; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            TableRelation = "Location";
        }
        field(25006771; "Item Category Code"; Code[20])
        {
            Caption = 'Item Category Code';
            TableRelation = "Item Category";
            trigger OnValidate()
            begin

                "Asset No." := '';
            end;
        }

    }
}
