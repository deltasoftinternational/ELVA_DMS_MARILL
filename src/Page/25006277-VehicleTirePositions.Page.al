Page 25006277 "Vehicle Tire Positions"
{
    Caption = 'Vehicle Tire Positions';
    PageType = List;
    SourceTable = "Vehicle Tire Position";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(Available; Rec.Available)
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Position)
            {
                Caption = '&Position';
                action(TireEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Tire &Entries';
                    Image = LedgerEntries;
                    RunObject = Page "Tire Entries";
                    RunPageLink = "Vehicle Serial No." = field("Vehicle Serial No."),
                                  "Vehicle Axle Code" = field("Axle Code"),
                                  "Tire Position Code" = field(Code);
                }
            }
        }
    }
}

