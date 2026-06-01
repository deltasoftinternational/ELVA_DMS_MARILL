Page 25006402 "SMS Batch Queue Entries"
{
    PageType = List;
    SourceTable = "SMS Batch Queue Entry";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(EntryType; Rec."Entry Type")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field(RequestAttempts; Rec."Request Attempts")
                {
                    ApplicationArea = Basic;
                }
                field(LastRequestAttempt; Rec."Last Request Attempt")
                {
                    ApplicationArea = Basic;
                }
                field(ExpireDateTime; Rec."Expire Date Time")
                {
                    ApplicationArea = Basic;
                }
                field(ProviderBatchId; Rec."Provider BatchId")
                {
                    ApplicationArea = Basic;
                }
                field(SMSRepliable; Rec."SMS Repliable")
                {
                    ApplicationArea = Basic;
                }
                field(SMSSenderId; Rec."SMS SenderId")
                {
                    ApplicationArea = Basic;
                }
                field(EntryCreated; Rec."Entry Created")
                {
                    ApplicationArea = Basic;
                }
                field(ProviderBatchCost; Rec."Provider Batch Cost")
                {
                    ApplicationArea = Basic;
                }
                field(SMSEntryCount; Rec."SMS Entry Count")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(creation)
        {
            action("Show SMS Entries")
            {
                ApplicationArea = Basic;
            }
        }
    }
}

