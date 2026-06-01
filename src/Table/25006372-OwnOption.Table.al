Table 25006372 "Own Option"
{
    Caption = 'Own Option';
    LookupPageID = "Own Options";

    fields
    {
        field(10; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(20; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));
        }
        field(40; "Option Code"; Code[20])
        {
            Caption = 'Option Code';
            NotBlank = true;
        }
        field(50; Description; Text[250])
        {
            Caption = 'Description';
        }
        field(60; "Description 2"; Text[250])
        {
            Caption = 'Description 2';
        }
        field(70; "Package No."; Code[20])
        {
            Caption = 'Package No.';
            TableRelation = "Service Package";
        }
    }

    keys
    {
        key(Key1; "Make Code", "Model Code", "Option Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure GetCurrentPrice() CurrPrice: Decimal
    var
        OptionSalesPrice: Record "Option Sales Price";
    begin
        OptionSalesPrice.Reset;
        OptionSalesPrice.SetRange("Option Code", "Option Code");
        OptionSalesPrice.SetRange("Sales Type", OptionSalesPrice."sales type"::"All Customers");
        OptionSalesPrice.SetFilter("Starting Date", '<=%1', WorkDate);
        OptionSalesPrice.SetFilter("Ending Date", '''''|>=%1', WorkDate);
        OptionSalesPrice.SetFilter("Make Code", '%1|%2', '', "Make Code");
        OptionSalesPrice.SetFilter("Model Code", '%1|%2', '', "Model Code");
        OnBeforeGetCurrentPrice(OptionSalesPrice, rec);
        if OptionSalesPrice.FindLast then
            CurrPrice := OptionSalesPrice."Unit Price";
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeGetCurrentPrice(var OptionSalesPrice: Record "Option Sales Price"; rec: Record "Own Option")
    begin
    end;
}

