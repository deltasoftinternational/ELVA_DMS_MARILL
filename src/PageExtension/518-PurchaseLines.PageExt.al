pageextension 25006075 "Purchase Lines" extends "Purchase Lines"//518
{
    layout
    {
        addafter("Amt. Rcd. Not Invoiced (LCY)")
        {
            field(VehicleRegistrationNo; Rec."Vehicle Registration No.")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
    }
    actions
    {
        modify("Reservation Entries")
        {
            Visible = false;
        }
        addafter("Reservation Entries")
        {
            action("DMS Reservation Entries")
            {
                AccessByPermission = TableData Item = R;
                ApplicationArea = Reservation;
                Caption = 'Reservation Entries';
                Image = ReservationLedger;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                ToolTip = 'View the entries for every reservation that is made, either manually or automatically.';

                trigger OnAction()
                begin
                    Rec.ShowVehReservationEntries(true);
                end;
            }
        }
    }
}