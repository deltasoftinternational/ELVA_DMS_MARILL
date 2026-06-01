tableextension 25006002 "G/L Account" extends "G/L Account" //15
{
    fields
    {
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = " ","Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006052; "Veh. Cost Closing Entry Filter"; Boolean)
        {
            Caption = 'Veh. Cost Closing Entry Filter';
            Description = 'Vehicle Cost Support';
            FieldClass = FlowFilter;
        }
        field(25006055; "Vehicle Serial No. Filter"; Code[20])
        {
            Caption = 'Vehicle Serial No. Filter';
            FieldClass = FlowFilter;
            TableRelation = Vehicle."Serial No.";
        }
        field(25006060; "Vehicle ID Mandatory"; Boolean)
        {
            Caption = 'Vehicle ID Mandatory';
        }
        field(25006379; "Vehicle Acc. Cycle No. Filter"; Code[20])
        {
            Caption = 'Vehicle Acc. Cycle No. Filter';
            FieldClass = FlowFilter;
            TableRelation = "Vehicle Accounting Cycle"."No.";
        }
        field(25006390; Description; Text[150])
        {
            Caption = 'Description';
        }
        field(25006400; "Source Type Filter"; Option)
        {
            Caption = 'Source Type Filter';
            FieldClass = FlowFilter;
            OptionCaption = ' ,Customer,Vendor,Bank Account,Fixed Asset';
            OptionMembers = " ",Customer,Vendor,"Bank Account","Fixed Asset";
        }
        field(25006410; "Source No. Filter"; Code[20])
        {
            Caption = 'Source No. Filter';
            FieldClass = FlowFilter;
            TableRelation = if ("Source Type Filter" = const(Customer)) Customer."No."
            else
            if ("Source Type Filter" = const(Vendor)) Vendor."No."
            else
            if ("Source Type Filter" = const("Bank Account")) "Bank Account"."No.";

            trigger OnLookup()
            var
                Customer: Record Customer;
                Vendor: Record Vendor;
                FixedAsset: Record "Fixed Asset";
                BankAccount: Record "Bank Account";
            begin
                case "Source Type Filter" of
                    "source type filter"::Customer:
                        if Page.RunModal(Page::"Customer List", Customer) = Action::LookupOK then
                            Validate("Source No. Filter", Customer."No.");
                    "source type filter"::Vendor:
                        if Page.RunModal(Page::"Vendor List", Vendor) = Action::LookupOK then
                            Validate("Source No. Filter", Vendor."No.");
                    "source type filter"::"Bank Account":
                        if Page.RunModal(Page::"Bank Account List", BankAccount) = Action::LookupOK then
                            Validate("Source No. Filter", BankAccount."No.");
                    "source type filter"::"Fixed Asset":
                        if Page.RunModal(Page::"Fixed Asset List", FixedAsset) = Action::LookupOK then
                            Validate("Source No. Filter", FixedAsset."No.");
                end;
            end;
        }
        //>>Addes by deltasoft
        field(25006411; "EDMS Balance at Date"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("G/L Entry".Amount WHERE("G/L Account No." = FIELD("No."),
                                                        "G/L Account No." = field(filter(Totaling)),
                                                        "Business Unit Code" = field("Business Unit Filter"),
                                                        "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                        "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                        "Posting Date" = field(upperlimit("Date Filter")),
                                                        "Vehicle Serial No." = field("Vehicle Serial No. Filter"),
                                                        "Vehicle Accounting Cycle No." = field("Vehicle Acc. Cycle No. Filter"),
                                                        "Source Type" = field("Source Type Filter"),
                                                        "Source No." = field("Source No. Filter")));
            Caption = 'Balance at Date';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006412; "EDMS Net Change"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("G/L Entry".Amount WHERE("G/L Account No." = FIELD("No."),
                                                        "G/L Account No." = field(filter(Totaling)),
                                                        "Business Unit Code" = field("Business Unit Filter"),
                                                        "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                        "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                        "Posting Date" = field(upperlimit("Date Filter")),
                                                        "Vehicle Serial No." = field("Vehicle Serial No. Filter"),
                                                        "Vehicle Accounting Cycle No." = field("Vehicle Acc. Cycle No. Filter"),
                                                        "Source Type" = field("Source Type Filter"),
                                                        "Source No." = field("Source No. Filter")));
            Caption = 'Net Change';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006413; "EDMS Balance"; Decimal)
        {
            AutoFormatType = 1;
            CalcFormula = Sum("G/L Entry".Amount WHERE("G/L Account No." = FIELD("No."),
                                                        "G/L Account No." = field(filter(Totaling)),
                                                        "Business Unit Code" = field("Business Unit Filter"),
                                                        "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                        "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                        "Posting Date" = field(upperlimit("Date Filter")),
                                                        "Vehicle Serial No." = field("Vehicle Serial No. Filter"),
                                                        "Vehicle Accounting Cycle No." = field("Vehicle Acc. Cycle No. Filter"),
                                                        "Source Type" = field("Source Type Filter"),
                                                        "Source No." = field("Source No. Filter")));
            Caption = 'Balance';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006414; "EDMS Debit Amount"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("G/L Entry"."Debit Amount" WHERE("G/L Account No." = FIELD("No."),
                                                                "G/L Account No." = field(filter(Totaling)),
                                                                "Business Unit Code" = field("Business Unit Filter"),
                                                                "Global Dimension 1 Code" = field("Global Dimension 1 Filter"),
                                                                "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                "Posting Date" = field(upperlimit("Date Filter")),
                                                                "Vehicle Serial No." = field("Vehicle Serial No. Filter"),
                                                                "Vehicle Accounting Cycle No." = field("Vehicle Acc. Cycle No. Filter"),
                                                                "Source Type" = field("Source Type Filter"),
                                                                "Source No." = field("Source No. Filter")));
            Caption = 'Debit Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006415; "EDMS Credit Amount"; Decimal)
        {
            AutoFormatType = 1;
            BlankZero = true;
            CalcFormula = Sum("G/L Entry"."Credit Amount" WHERE("G/L Account No." = FIELD("No."),
                                                                 "G/L Account No." = FIELD(FILTER(Totaling)),
                                                                 "Business Unit Code" = FIELD("Business Unit Filter"),
                                                                 "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                 "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                 "Posting Date" = field(upperlimit("Date Filter")),
                                                                 "Vehicle Serial No." = field("Vehicle Serial No. Filter"),
                                                                 "Vehicle Accounting Cycle No." = field("Vehicle Acc. Cycle No. Filter"),
                                                                 "Source Type" = field("Source Type Filter"),
                                                                 "Source No." = field("Source No. Filter"),
                                                                 "Dimension Set ID" = FIELD("Dimension Set ID Filter")));
            Caption = 'Credit Amount';
            Editable = false;
            FieldClass = FlowField;
        }

        field(25006416; "EDMS Additional-Currency Net Change"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 1;
            CalcFormula = Sum("G/L Entry"."Additional-Currency Amount" WHERE("G/L Account No." = FIELD("No."),
                                                                              "G/L Account No." = FIELD(FILTER(Totaling)),
                                                                              "Business Unit Code" = FIELD("Business Unit Filter"),
                                                                              "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                              "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                              "Posting Date" = field("Date Filter"),
                                                                              "Vehicle Serial No." = field("Vehicle Serial No. Filter"),
                                                                              "Vehicle Accounting Cycle No." = field("Vehicle Acc. Cycle No. Filter")));
            Caption = 'Additional-Currency Net Change';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006417; "EMDS Add.-Currency Balance at Date"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 1;
            CalcFormula = Sum("G/L Entry"."Additional-Currency Amount" WHERE("G/L Account No." = FIELD("No."),
                                                                              "G/L Account No." = FIELD(FILTER(Totaling)),
                                                                              "Business Unit Code" = FIELD("Business Unit Filter"),
                                                                              "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                              "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                              "Posting Date" = field(upperlimit("Date Filter")),
                                                                              "Vehicle Serial No." = field("Vehicle Serial No. Filter"),
                                                                              "Vehicle Accounting Cycle No." = field("Vehicle Acc. Cycle No. Filter")));
            Caption = 'Add.-Currency Balance at Date';
            Editable = false;
            FieldClass = FlowField;
        }

        field(25006418; "EMDSAdditional-Currency Balance"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 1;
            CalcFormula = Sum("G/L Entry"."Additional-Currency Amount" WHERE("G/L Account No." = FIELD("No."),
                                                                              "G/L Account No." = FIELD(FILTER(Totaling)),
                                                                              "Business Unit Code" = FIELD("Business Unit Filter"),
                                                                              "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                              "Global Dimension 2 Code" = field("Global Dimension 2 Filter"),
                                                                              "Vehicle Serial No." = field("Vehicle Serial No. Filter"),
                                                                              "Vehicle Accounting Cycle No." = field("Vehicle Acc. Cycle No. Filter")));
            Caption = 'Additional-Currency Balance';
            Editable = false;
            FieldClass = FlowField;
        }

        field(25006419; "EMDSAdd.-Currency Debit Amount"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 1;
            CalcFormula = Sum("G/L Entry"."Add.-Currency Debit Amount" WHERE("G/L Account No." = FIELD("No."),
                                                                              "G/L Account No." = FIELD(FILTER(Totaling)),
                                                                              "Business Unit Code" = FIELD("Business Unit Filter"),
                                                                              "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                              "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                              "Posting Date" = field("Date Filter"),
                                                                              "Vehicle Serial No." = field("Vehicle Serial No. Filter"),
                                                                              "Vehicle Accounting Cycle No." = field("Vehicle Acc. Cycle No. Filter")));
            Caption = 'Add.-Currency Debit Amount';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25006420; "EMDSAdd.-Currency Credit Amount"; Decimal)
        {
            AutoFormatExpression = GetCurrencyCode();
            AutoFormatType = 1;
            CalcFormula = Sum("G/L Entry"."Add.-Currency Credit Amount" WHERE("G/L Account No." = FIELD("No."),
                                                                               "G/L Account No." = FIELD(FILTER(Totaling)),
                                                                               "Business Unit Code" = FIELD("Business Unit Filter"),
                                                                               "Global Dimension 1 Code" = FIELD("Global Dimension 1 Filter"),
                                                                               "Global Dimension 2 Code" = FIELD("Global Dimension 2 Filter"),
                                                                               "Posting Date" = field("Date Filter"),
                                                                               "Vehicle Serial No." = field("Vehicle Serial No. Filter"),
                                                                               "Vehicle Accounting Cycle No." = field("Vehicle Acc. Cycle No. Filter")));
            Caption = 'Add.-Currency Credit Amount';
            Editable = false;
            FieldClass = FlowField;
        }
    }

}