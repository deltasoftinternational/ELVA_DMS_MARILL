Table 25006058 "Service Labor Discount Group"
{
    Caption = 'Service Labor Discount Group';
    LookupPageID = "Service Labor Discount Groups";

    fields
    {
        field(1; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Description; Text[100])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        SalesLineDiscount: Record "Labor Sales Line Discount";
    begin
        SalesLineDiscount.SetRange(Type, SalesLineDiscount.Type::"Labor Discount Group");
        SalesLineDiscount.SetRange(Code, Code);
        SalesLineDiscount.DeleteAll(true);
    end;
}

