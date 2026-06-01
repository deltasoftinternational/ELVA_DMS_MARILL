Page 25006754 "SIE Setup"
{
    ApplicationArea = Basic;
    Caption = 'SIE Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "SIE Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(SynchIntervalsec; Rec."Synch. Interval (sec)")
                {
                    ApplicationArea = Basic;
                }
                field(FileName; Rec."File Name")
                {
                    ApplicationArea = Basic;
                }
                field(AutomaticSIEJournalPosting; Rec."Automatic SIE Journal Posting")
                {
                    ApplicationArea = Basic;
                }
                field(AutomaticPutInTakeOut; Rec."Automatic PutInTakeOut")
                {
                    ApplicationArea = Basic;
                }
                field(AutomaticAssign; Rec."Automatic Assign")
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

