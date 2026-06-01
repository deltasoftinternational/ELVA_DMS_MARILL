Page 25006268 "Tire Card"
{
    Caption = 'Tire Card';
    PageType = Card;
    SourceTable = Tire;

    layout
    {
        area(content)
        {
            group(General)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit then
                            CurrPage.Update;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(Available; Rec.Available)
                {
                    ApplicationArea = Basic;
                }
                field(CurrentVehicleSerialNo; Rec."Current Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field(CurrentVehicleAxleCode; Rec."Current Vehicle Axle Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(CurrentVehicleTirePosition; Rec."Current Vehicle Tire Position")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1101904007; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group("<Action1101904009>")
            {
                Caption = '&Tire';
                action(Entries)
                {
                    ApplicationArea = Basic;
                    Caption = '&Entries';
                    Image = LedgerEntries;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Tire Entries";
                    RunPageLink = "Tire Code" = field(Code);
                    ShortCutKey = 'Ctrl+F7';
                }
            }
        }
    }
}

