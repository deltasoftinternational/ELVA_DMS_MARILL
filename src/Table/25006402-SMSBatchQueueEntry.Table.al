Table 25006402 "SMS Batch Queue Entry"
{
    DrillDownPageID = "SMS Batch Queue Entries";

    fields
    {
        field(10; "Entry No."; Integer)
        {
        }
        field(20; "Entry Type"; Option)
        {
            OptionMembers = "Single SMS","Multiple SMS";
        }
        field(30; Status; Option)
        {
            OptionMembers = Pending,"Waiting Report",Finished;
        }
        field(40; "Request Attempts"; Integer)
        {
        }
        field(50; "Last Request Attempt"; DateTime)
        {
        }
        field(60; "Expire Date Time"; DateTime)
        {
        }
        field(70; "Provider BatchId"; Text[30])
        {
        }
        field(90; "SMS Repliable"; Boolean)
        {
        }
        field(100; "SMS SenderId"; Text[30])
        {
        }
        field(110; "Entry Created"; DateTime)
        {
        }
        field(120; "Provider Batch Cost"; Decimal)
        {
        }
        field(130; "SMS Entry Count"; Integer)
        {
            CalcFormula = count("SMS Entry" where("Batch Queue Entry No." = field("Entry No.")));
            FieldClass = FlowField;
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
        fieldgroup(SMSEntryAndSMSBatch; "Entry No.", "Entry Type", Status, "Provider BatchId")
        {
        }
    }
}

