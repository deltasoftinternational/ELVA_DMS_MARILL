Table 25006401 "SMS Entry"
{
    DrillDownPageID = "SMS Entries";

    fields
    {
        field(10; "Entry No."; Integer)
        {
        }
        field(20; "Phone No."; Text[50])
        {
        }
        field(30; "Message Text"; Text[250])
        {
        }
        field(40; "Delivery Status"; Option)
        {
            OptionMembers = Queued,Sent,Delivered,Failed,Expired,Cancelled;
        }
        field(45; "Queue Status"; Option)
        {
            OptionMembers = Pending,"Waiting Report",Finished;
        }
        field(55; "Batch Queue Entry No."; Integer)
        {
            TableRelation = "SMS Batch Queue Entry"."Entry No." where("Entry No." = field("Batch Queue Entry No."));
        }
        field(60; Replay; Boolean)
        {
        }
        field(70; "Replay Phone No."; Text[50])
        {
        }
        field(75; "Provider BatchId"; Text[30])
        {
        }
        field(80; "Provider ReplayId"; Integer)
        {
        }
        field(90; "Provider Reported Status"; Integer)
        {
        }
        field(100; "Entry Created"; DateTime)
        {
        }
        field(110; "Message Sent"; DateTime)
        {
        }
        field(120; "Provider Batch Cost"; Decimal)
        {
        }
        field(130; "Sent In Multiple Batch"; Boolean)
        {
        }
        field(140; "Interaction Log Entry No."; Integer)
        {
            TableRelation = "Interaction Log Entry";
        }
        field(150; "Contact No."; Code[20])
        {
        }
        field(160; "Salesperson Code"; Code[10])
        {
        }
        field(170; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = ' ,Quote,Order,Return Order';
            OptionMembers = " ",Quote,"Order","Return Order";
        }
        field(180; "Document No."; Code[20])
        {
            Caption = 'Document No.';
            TableRelation = "Service Header EDMS"."No." where("Document Type" = field("Document Type"));
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

