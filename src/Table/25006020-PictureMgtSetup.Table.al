Table 25006020 "Picture Mgt. Setup"
{
    // 06/03/2018 GH P1
    //   Added fied "Camera Picture Quality"


    fields
    {
        field(1; "Primary Key"; Code[10])
        {
        }
        field(10; "Picture Nos."; Code[10])
        {
            Caption = 'Picture Nos.';
            TableRelation = "No. Series";
        }
        field(25006995; "Camera Picture Quality"; Integer)
        {
            MaxValue = 100;
            MinValue = 0;
        }
        field(25006996; "Thumbnail Width"; Integer)
        {
        }
        field(25006997; "Thumbnail Height"; Integer)
        {
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

