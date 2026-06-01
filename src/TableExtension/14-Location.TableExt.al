tableextension 25006001 "Location" extends Location //14
{
    fields
    {
        field(25006005; "Net Change (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Value Entry"."Cost Amount (Actual)" where("Location Code" = field(Code),
                                                                          "Posting Date" = field("Date Filter"),
                                                                          "Item Type" = field("Item Type Filter")));
            Caption = 'Net Change (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006010; "Purchases (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Value Entry"."Cost Amount (Actual)" where("Location Code" = field(Code),
                                                                          "Posting Date" = field("Date Filter"),
                                                                          "Item Ledger Entry Type" = const(Purchase),
                                                                          "Item Type" = field("Item Type Filter")));
            Caption = 'Purchases (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006020; "Positive Adjmt. (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = sum("Value Entry"."Cost Amount (Actual)" where("Location Code" = field(Code),
                                                                          "Posting Date" = field("Date Filter"),
                                                                          "Item Ledger Entry Type" = const("Positive Adjmt."),
                                                                          "Item Type" = field("Item Type Filter")));
            Caption = 'Positive Adjmt. (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006030; "Negative Adjmt. (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - sum("Value Entry"."Cost Amount (Actual)" where("Location Code" = field(Code),
                                                                           "Posting Date" = field("Date Filter"),
                                                                           "Item Ledger Entry Type" = const("Negative Adjmt."),
                                                                           "Item Type" = field("Item Type Filter")));
            Caption = 'Negative Adjmt. (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006040; "COGS (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = - sum("Value Entry"."Cost Amount (Actual)" where("Location Code" = field(Code),
                                                                           "Posting Date" = field("Date Filter"),
                                                                           "Item Ledger Entry Type" = const(Sale),
                                                                           "Item Type" = field("Item Type Filter")));
            Caption = 'COGS (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006050; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            FieldClass = FlowFilter;
        }
        field(25006060; "Item Type Filter"; Option)
        {
            Caption = 'Item Type Filter';
            FieldClass = FlowFilter;
            OptionCaption = ' ,Item,Model Version,Own Option,Material';
            OptionMembers = " ",Item,"Model Version","Own Option",Material;
        }
        field(25006070; "Transfered (LCY)"; Decimal)
        {
            CalcFormula = sum("Value Entry"."Cost Amount (Actual)" where("Location Code" = field(Code),
                                                                          "Item Ledger Entry Type" = const(Transfer),
                                                                          "Posting Date" = field("Date Filter"),
                                                                          "Item Type" = field("Item Type Filter")));
            Caption = 'Transfered (LCY)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006240; "Use As Service Location"; Boolean)
        {
            Caption = 'Use As Service Location';
        }
        field(25006250; "Use As Parts Location Code"; Boolean)
        {
            Caption = 'Use As Parts Location Code';
            DataClassification = ToBeClassified;
        }

        field(25006251; "Default Transf. From Loc. Code"; Code[10])
        {
            Caption = 'Default Transf. From Loc. Code';
            DataClassification = ToBeClassified;
            TableRelation = Location;
        }
        field(25006252; "Use As Rent Location Code"; Boolean)
        {
            Caption = 'Use As Rent Location Code';
            DataClassification = ToBeClassified;
        }
        field(25006260; "Hide Automatic Serv. Res. Msg."; Boolean)
        {
            Caption = 'Hide Automatic Service Reservation Messages';
            DataClassification = ToBeClassified;
        }
        field(25006270; "Rent Internal Customer No."; Code[20])
        {
            Caption = 'Rent Internal Customer No.';
            TableRelation = Customer;
        }
        field(25006280; "Rent Vehicle Status Code"; Code[20])
        {
            Caption = 'Rent Vehicle Status Code';
            TableRelation = "Vehicle Status";
        }
    }

    Var
        ELVAUnspecifiedLocationLbl: Label '(Unspecified Location)';



    procedure GetRentItemLocations()
    var
        Location: Record Location;
    begin
        Init;
        Validate(Name, ELVAUnspecifiedLocationLbl);
        Insert;

        Location.SetRange("Use As Rent Location Code", true);
        if Location.FindSet then
            repeat
                Init;
                Copy(Location);
                Insert;
            until Location.Next = 0;

        FindFirst;
    end;

}