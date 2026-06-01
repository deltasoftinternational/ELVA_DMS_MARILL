Table 25006400 "SMS Request Log"
{

    fields
    {
        field(10; "Entry No."; Integer)
        {
        }
        field(15; "Entry Time"; DateTime)
        {
        }
        field(20; Url; Text[250])
        {
        }
        field(30; RequestData; Text[250])
        {
        }
        field(40; ResponseData; Text[250])
        {
        }
        field(45; "Source Type"; Option)
        {
            OptionMembers = "Std. Request","SMS Message","SMS Batch";
        }
        field(50; "Source Id"; Integer)
        {
        }
        field(60; RequestDataBlob; Blob)
        {
        }
        field(70; ResponseDataBlob; Blob)
        {
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

