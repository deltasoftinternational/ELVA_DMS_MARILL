Page 25006401 "SMS Entries"
{
    PageType = List;
    SourceTable = "SMS Entry";

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
                field(PhoneNo; Rec."Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field(MessageText; Rec."Message Text")
                {
                    ApplicationArea = Basic;
                }
                field(DeliveryStatus; Rec."Delivery Status")
                {
                    ApplicationArea = Basic;
                }
                field(QueueStatus; Rec."Queue Status")
                {
                    ApplicationArea = Basic;
                }
                field(BatchQueueEntryNo; Rec."Batch Queue Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(Replay; Rec.Replay)
                {
                    ApplicationArea = Basic;
                }
                field(ReplayPhoneNo; Rec."Replay Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field(ProviderBatchId; Rec."Provider BatchId")
                {
                    ApplicationArea = Basic;
                }
                field(ProviderReplayId; Rec."Provider ReplayId")
                {
                    ApplicationArea = Basic;
                }
                field(ProviderReportedStatus; Rec."Provider Reported Status")
                {
                    ApplicationArea = Basic;
                }
                field(EntryCreated; Rec."Entry Created")
                {
                    ApplicationArea = Basic;
                }
                field(MessageSent; Rec."Message Sent")
                {
                    ApplicationArea = Basic;
                }
                field(ProviderBatchCost; Rec."Provider Batch Cost")
                {
                    ApplicationArea = Basic;
                }
                field(SentInMultipleBatch; Rec."Sent In Multiple Batch")
                {
                    ApplicationArea = Basic;
                }
                field(ContactNo; Rec."Contact No.")
                {
                    ApplicationArea = Basic;
                }
                field(InteractionLogEntryNo; Rec."Interaction Log Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(SalespersonCode; Rec."Salesperson Code")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentType; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

