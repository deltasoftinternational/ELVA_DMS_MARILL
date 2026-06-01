Page 25006276 "Vehicle Axles"
{
    Caption = 'Vehicle Axles';
    PageType = List;
    SourceTable = "Vehicle Axle";

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
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action1101904005>")
            {
                Caption = 'Axle';
                action(TirePosition)
                {
                    ApplicationArea = Basic;
                    Caption = 'Tire &Position';
                    Image = Position;
                    RunObject = Page "Vehicle Tire Positions";
                    RunPageLink = "Vehicle Serial No." = field("Vehicle Serial No."),
                                  "Axle Code" = field(Code);
                }
                action(TireEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Tire &Entries';
                    Image = LedgerEntries;
                    RunObject = Page "Tire Entries";
                    RunPageLink = "Vehicle Serial No." = field("Vehicle Serial No."),
                                  "Vehicle Axle Code" = field(Code),
                                  Open = const(true);
                }
            }
            group("Function")
            {
                Caption = '&Function';
                action("<Action1101904009>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Copy From Template';
                    Image = Template;

                    trigger OnAction()
                    begin
                        TireManagement.ShowCreateAxleFromTmpl(Rec);
                    end;
                }
            }
        }
    }

    var
        TireManagement: Codeunit "Tire Management";
}

