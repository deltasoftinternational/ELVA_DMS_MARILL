Table 25006212 "BLS Setup"
{
    Caption = 'Billing Setup';

    fields
    {
        field(10; "Primary Key"; Code[10])
        {
        }
        field(1000; "Contract Nos."; Code[10])
        {
            Caption = 'Contract Nos.';
            TableRelation = "No. Series";
        }
        field(2000; "Base Calendar Code"; Code[10])
        {
            Caption = 'Base Calendar Code';
            TableRelation = "Base Calendar";
        }
        field(3000; "Leasing Schedule Nos."; Code[10])
        {
            Caption = 'Leasing Schedule Nos.';
            TableRelation = "No. Series";
        }
        field(3010; "Leasing Service Code"; Code[20])
        {
            Caption = 'Leasing Service Code';
            TableRelation = "BLS Service".Code;
        }
        field(3020; "Additional Service Code"; Code[20])
        {
            Caption = 'Additional Service Code';
            TableRelation = "BLS Service".Code;
        }
        field(3030; "Lease Interest Service Code"; Code[20])
        {
            Caption = 'Leasing Interest Service Code';
            TableRelation = "BLS Service".Code;
        }
        field(3040; "Auto Post Lease Invoices"; Boolean)
        {
            Caption = 'Automatically Post Lease Invoices';
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

