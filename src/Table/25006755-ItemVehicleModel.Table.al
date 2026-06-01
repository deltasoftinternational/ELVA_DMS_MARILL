Table 25006755 "Item Vehicle Model"
{
    Caption = 'Item Vehicle Model';
    LookupPageID = "Item Vehicle Models";

    fields
    {
        field(5; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Item,Nonstock Item';
            OptionMembers = Item,"Nonstock Item";
        }
        field(10; "No."; Code[20])
        {
            Caption = 'Item No.';
            TableRelation = if (Type = const(Item)) Item
            else
            if (Type = const("Nonstock Item")) "Nonstock Item";
        }
        field(20; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(30; "Model No."; Code[30])
        {
            Caption = 'Model No.';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));
        }
        field(40; "External Code"; Code[20])
        {
            Caption = 'External Code';
        }
    }

    keys
    {
        key(Key1; Type, "No.", "Make Code", "Model No.", "External Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

