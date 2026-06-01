Table 25006399 "Aftersales CRM Cue"
{

    fields
    {
        field(10; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(20; "Campaign Active"; Integer)
        {
            CalcFormula = count(Campaign where(Activated = filter(true)));
            Caption = 'Active Campaign ';
            Editable = false;
            FieldClass = FlowField;
        }
        field(30; "My To-do This Week"; Integer)
        {
            CalcFormula = count("To-do" where(Date = field("Date Filter 1"),
                                               "Salesperson Code" = field("Salesperson Code")));
            Caption = 'My To-do This Week';
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; "My To-do Next Week"; Integer)
        {
            CalcFormula = count("To-do" where(Date = field("Date Filter 2"),
                                               "Salesperson Code" = field("Salesperson Code")));
            Caption = 'My To-do Next Week';
            Editable = false;
            FieldClass = FlowField;
        }
        field(50; "My Segments"; Integer)
        {
            CalcFormula = count("Segment Header" where("Salesperson Code" = field("Salesperson Code")));
            Caption = 'My Segments';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; "My Contacts"; Integer)
        {
            CalcFormula = count(Contact where("Salesperson Code" = field("Salesperson Code")));
            Caption = 'My Contacts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70; "Date Filter 1"; Date)
        {
            Caption = 'Date Filter 1';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(80; "Date Filter 2"; Date)
        {
            Caption = 'Date Filter 2';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(90; "My Customers"; Integer)
        {
            CalcFormula = count(Customer where("Salesperson Code" = field("Salesperson Code")));
            Caption = 'My Customers';
            Editable = false;
            FieldClass = FlowField;
        }
        field(100; "My Contracts"; Integer)
        {
            CalcFormula = count(Contract where("Salesperson Code" = field("Salesperson Code")));
            Caption = 'My Contracts';
            Editable = false;
            FieldClass = FlowField;
        }
        field(110; "Salesperson Code"; Code[10])
        {
            Caption = 'Salesperson Code';
            FieldClass = FlowFilter;
        }
        field(120; "My To-do"; Integer)
        {
            CalcFormula = count("To-do" where("Salesperson Code" = field("Salesperson Code")));
            Caption = 'My To-do';
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

