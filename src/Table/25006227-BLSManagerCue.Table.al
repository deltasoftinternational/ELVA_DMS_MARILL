Table 25006227 "BLS Manager Cue"
{

    fields
    {
        field(10; "Prinary Key"; Code[10])
        {
        }
        field(20; "BLS Contracts Active"; Integer)
        {
            CalcFormula = count("Contract" where("Status" = const(Active)));
            Caption = 'Active Contracts';
            FieldClass = FlowField;
        }
        field(30; "BLS Contracts Inactive"; Integer)
        {
            CalcFormula = count("Contract" where(Status = const(Inactive)));
            Caption = 'Inactive Contracts';
            FieldClass = FlowField;
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

