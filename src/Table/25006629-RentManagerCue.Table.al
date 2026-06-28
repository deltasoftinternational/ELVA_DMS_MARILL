Table 25006629 "Rent Manager Cue"
{

    fields
    {
        field(10; "Prinary Key"; Code[10])
        {
        }
        field(20; "Rent Quotes"; Integer)
        {
            CalcFormula = count("Rent Header" where("Document Type" = const(Quote), "Responsibility Center" = Field("Responsibility Center Filter")));
            Caption = 'Rent Quotes';
            FieldClass = FlowField;
        }
        field(30; "Rent Orders"; Integer)
        {
            CalcFormula = count("Rent Header" where("Document Type" = const(Order), Closed = FILTER(false), "Responsibility Center" = Field("Responsibility Center Filter")));
            Caption = 'Rent Orders';
            FieldClass = FlowField;
        }
        field(40; "Rent Invoices"; Integer)
        {
            CalcFormula = count("Sales Header" where("Document Profile" = const(Rent), "Responsibility Center" = Field("Responsibility Center Filter")));
            Caption = 'Rent Invoices';
            FieldClass = FlowField;
        }
        field(50; "Rent Credit Memos"; Integer)
        {
            CalcFormula = count("Sales Header" where("Document Profile" = const(Rent), "Responsibility Center" = Field("Responsibility Center Filter")));
            Caption = 'Rent Credit Memos';
            FieldClass = FlowField;
        }
        field(60; "Rent Transfer Orders"; Integer)
        {
            CalcFormula = count("Rent Transfer Header" where("Responsibility Center" = Field("Responsibility Center Filter")));
            ;
            Caption = 'Rent Transfer Orders';
            FieldClass = FlowField;
        }
        field(61; "Responsibility Center Filter"; Code[10])
        {
            Caption = 'Responsibility Center Filter';
            FieldClass = FlowFilter;
            TableRelation = "Responsibility Center";
        }
    }

    keys
    {
        key(Key1; "Prinary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

