Table 25006021 "Vehicle Status"
{
    // 05.11.2007. EDMS P2
    //   * Rename field "Kilometrage Is Important" -> "Registration Is Important"

    Caption = 'Vehicle Status';
    LookupPageID = "Vehicle Statuses";

    fields
    {
        field(10; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(20; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(50; "Vehicle Status Group Code"; Code[20])
        {
            Caption = 'Vehicle Status Group Code';
            TableRelation = "Vehicle Status Group";
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
}

