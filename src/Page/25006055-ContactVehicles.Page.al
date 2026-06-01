Page 25006055 "Contact Vehicles"
{
    // 30.01.2014 Elva Baltic P8 #F038 MMG7.00
    //   * Added fields

    Caption = 'Contact Vehicles';
    DataCaptionFields = "Vehicle Serial No.";
    DelayedInsert = true;
    PageType = List;
    PromotedActionCategories = 'New,Process,Reports,Vehicles';
    SourceTable = "Vehicle Contact";
    SourceTableView = sorting("Contact No.");

    layout
    {
        area(content)
        {
            repeater(Control1190000)
            {
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field(RelationshipCode; Rec."Relationship Code")
                {
                    ApplicationArea = Basic;
                }
                field(ContactNo; Rec."Contact No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VIN; Rec.VIN)
                {
                    ApplicationArea = Basic;
                }
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                }
                field(ModelCode; Rec."Model Code")
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
            action(VehicleCard)
            {
                ApplicationArea = Basic;
                Caption = 'Vehicle Card';
                Image = Card;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    VehCard: Page "Vehicle Card";
                    Vehicle: Record Vehicle;
                begin
                    Vehicle.Get(Rec."Vehicle Serial No.");
                    VehCard.SetRecord(Vehicle);
                    VehCard.Run;
                end;
            }
        }
    }
}

