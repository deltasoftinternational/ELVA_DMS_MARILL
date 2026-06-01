Page 25006526 "Vehicle Opt. Setup"
{
    Caption = 'Vehicle Option Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = Card;
    SourceTable = "Vehicle Opt. Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(FunctionalityActivated; Rec."Functionality Activated")
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

