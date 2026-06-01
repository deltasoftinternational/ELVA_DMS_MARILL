pageextension 25006078 "Assembly Order" extends "Assembly Order"//900
{
    actions
    {
        addafter("BOM Level")
        {
            action(AvailabilityByLocation)
            {
                ApplicationArea = Basic;
                Caption = 'Availability by Location';
                Image = ItemAvailbyLoc;
                Promoted = true;
                PromotedCategory = Process;
                ToolTip = 'Show a list of items grouped by location.';

                trigger OnAction()
                var
                    ItemByLocation: Page "Items by Location EDMS";
                begin
                    ItemByLocation.SetParams(Database::"Assembly Header", Rec."Document Type".AsInteger(), Rec."No.");
                    ItemByLocation.RunModal;
                end;
            }
        }
    }
}
