Page 25006403 "SMS Management Setup"
{
    ApplicationArea = Basic;
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "SMS Management Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(SMSProviderUsername; Rec."SMS Provider Username")
                {
                    ApplicationArea = Basic;
                }
                field(SMSProviderPassword; Rec."SMS Provider Password")
                {
                    ApplicationArea = Basic;
                }
                field(SmsBatchQueueExpirePeriod; Rec."Sms Batch Queue Expire Period")
                {
                    ApplicationArea = Basic;
                }
                field(SmsBatchQueueArchPeriod; Rec."Sms Batch Queue Arch. Period")
                {
                    ApplicationArea = Basic;
                }
                field(EnableRepliableSMS; Rec."Enable Repliable SMS")
                {
                    ApplicationArea = Basic;
                }
                field(SMSSenderId; Rec."SMS Sender Id")
                {
                    ApplicationArea = Basic;
                }
                field(ProviderURL; Rec."Provider URL")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;
    end;
}

