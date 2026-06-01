Table 25006610 "Rent Package Line"
{

    fields
    {
        field(10; "Package No."; Code[20])
        {
            Caption = 'Package No.';
            TableRelation = "Rent Package";
        }
        field(20; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(30; Type; Option)
        {
            Caption = 'Type';
            OptionMembers = " ","G/L Account",Item,Resource,"Fixed Asset","Charge (Item)","External Service","Rent Item";
        }
        field(40; "No."; Code[20])
        {
            Caption = 'No.';
            TableRelation = if (Type = const(" ")) "Standard Text"
            else
            if (Type = const("G/L Account")) "G/L Account"
            else
            if (Type = const(Item)) Item
            else
            if (Type = const(Resource)) Resource
            else
            if (Type = const("Fixed Asset")) "Fixed Asset"
            else
            if (Type = const("Charge (Item)")) "Item Charge"
            else
            if (Type = const("External Service")) "External Service"
            else
            if (Type = const("Rent Item")) "Rent Item";

            trigger OnValidate()
            begin
                case Type of
                    Type::" ":
                        begin
                            StdTxt.Get("No.");
                            Description := StdTxt.Description;
                        end;
                    Type::"G/L Account":
                        begin
                            GLAcc.Get("No.");
                            GLAcc.CheckGLAcc;
                            Description := GLAcc.Name;
                        end;
                    Type::Item:
                        begin
                            GetItem;
                            Description := Item.Description;
                        end;
                    Type::Resource:
                        begin
                            Res.Get("No.");
                            Description := Res.Name;
                        end;
                    Type::"Fixed Asset":
                        begin
                            FA.Get("No.");
                            Description := FA.Description;
                        end;
                    Type::"Charge (Item)":
                        begin
                            ItemCharge.Get("No.");
                            Description := ItemCharge.Description;
                        end;
                end;
            end;
        }
        field(50; Quantity; Decimal)
        {
            Caption = 'Quantity';
        }
        field(60; "Unit Price"; Decimal)
        {
            Caption = 'Unit Price';
        }
        field(70; "Rent Period Quantity"; Decimal)
        {
            Caption = 'Rent Period Quantity';
        }
        field(80; "Rent Period Code"; Code[10])
        {
            Caption = 'Rent Period Code';
            TableRelation = "Rent Period";
        }
        field(90; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(100; "Price Includes VAT"; Boolean)
        {
            Caption = 'Price Includes VAT';
        }
        field(110; "VAT Bus. Posting Gr. (Price)"; Code[20])
        {
            Caption = 'VAT Bus. Posting Gr. (Price)';
            TableRelation = "VAT Business Posting Group";
        }
        field(120; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
    }

    keys
    {
        key(Key1; "Package No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        StdTxt: Record "Standard Text";
        GLAcc: Record "G/L Account";
        Item: Record Item;
        Resource: Record Resource;
        Res: Record Resource;
        FA: Record "Fixed Asset";
        ItemCharge: Record "Item Charge";

    local procedure GetItem()
    begin
        TestField("No.");
        if "No." <> Item."No." then
            Item.Get("No.");
    end;
}

