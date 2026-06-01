Page 25006247 "Recall Campaign Vehicles"
{
    Caption = 'Recall Campaign Vehicles';
    DataCaptionFields = "Campaign No.", VIN;
    DelayedInsert = true;
    PageType = Document;
    SourceTable = "Recall Campaign Vehicle";

    layout
    {
        area(content)
        {
            repeater(Control1190000)
            {
                field(CampaignNo; Rec."Campaign No.")
                {
                    ApplicationArea = Basic;
                }
                field(VIN; Rec.VIN)
                {
                    ApplicationArea = Basic;
                }
                field(Serviced; Rec.Serviced)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        if Rec.Serviced then begin
                            SelectedRecallNo := Rec."Campaign No.";
                            CurrPage.Close;
                        end;
                    end;
                }
                field(Exists; Rec.Exists)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Line)
            {
                Caption = 'Line';
                action(Campaign)
                {
                    ApplicationArea = Basic;
                    Caption = 'Campaign';
                    Image = Campaign;
                    Promoted = true;
                    RunObject = Page "Recall Campaign Card";
                    RunPageLink = "No." = field("Campaign No.");
                }
                action(Vehicle)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicle';
                    Image = Item;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        Vehicle: Record Vehicle;
                    begin
                        Vehicle.SetCurrentkey(VIN);
                        Vehicle.SetRange(VIN, Rec.VIN);
                        Page.RunModal(Page::"Vehicle Card", Vehicle);
                    end;
                }
            }
        }
    }

    var
        SelectedRecallNo: Code[20];


    procedure GetSelectedRecallNo(): Code[20]
    begin
        exit(SelectedRecallNo);
    end;
}

