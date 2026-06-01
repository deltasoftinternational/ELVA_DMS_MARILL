Table 25006186 "Tire Mgt Cue"
{
    Caption = 'Tire Mgt Cue';

    fields
    {
        field(10; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(20; "Service Lines Count"; Integer)
        {
            CalcFormula = count("Service Line EDMS" where("Tire Operation Type" = filter(> " ")));
            Caption = 'Service Lines Count';
            Editable = false;
            FieldClass = FlowField;
        }
        field(30; "Put on Tires Count"; Integer)
        {
            CalcFormula = count("Tire Entry" where(Open = const(true)));
            Caption = 'Put on Tires Count';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

