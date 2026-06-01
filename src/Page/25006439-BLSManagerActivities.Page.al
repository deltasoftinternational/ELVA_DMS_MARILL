Page 25006439 "BLS Manager Activities"
{
    Caption = 'Activities';
    PageType = CardPart;
    RefreshOnActivate = true;
    SourceTable = "BLS Manager Cue";

    layout
    {
        area(content)
        {
            cuegroup(Rent)
            {
                Caption = 'Contracts';
                field(RentQuotes; Rec."BLS Contracts Active")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Contract List EDMS";
                }
                field(RentOrders; Rec."BLS Contracts Inactive")
                {
                    ApplicationArea = Basic;
                    DrillDownPageID = "Contract List EDMS";
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

