Page 25006417 "BLS Setup"
{
    ApplicationArea = Basic;
    Caption = 'Billing Setup';
    PageType = Card;
    SourceTable = "BLS Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(BaseCalendarCode; Rec."Base Calendar Code")
                {
                    ApplicationArea = Basic;
                }
                field(LeasingServiceCode; Rec."Leasing Service Code")
                {
                    ApplicationArea = All;
                }
                field(AdditionalServiceCode; Rec."Additional Service Code")
                {
                    ApplicationArea = All;
                }
                field(LeaseInterestServiceCode; Rec."Lease Interest Service Code")
                {
                    ApplicationArea = All;
                }
                field("Auto Post Lease Invoices"; Rec."Auto Post Lease Invoices")
                {
                    ApplicationArea = All;
                }
            }
            group(Numbering)
            {
                Caption = 'Numbering';
                field(ContractNos; Rec."Contract Nos.")
                {
                    ApplicationArea = Basic;
                }
                field(LeasingScheduleNos; Rec."Leasing Schedule Nos.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;
    end;
}

