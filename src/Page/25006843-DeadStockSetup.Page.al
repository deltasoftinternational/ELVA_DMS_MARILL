Page 25006843 "Dead Stock Setup"
{
    Caption = 'Dead Stock Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Dead Stock Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(StartingDate; Rec."Starting Date")
                {
                    ApplicationArea = Basic;
                }
                field(EndingDate; Rec."Ending Date")
                {
                    ApplicationArea = Basic;
                }
                field(MinDeadStockRate; Rec."Min. Dead Stock Rate")
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

