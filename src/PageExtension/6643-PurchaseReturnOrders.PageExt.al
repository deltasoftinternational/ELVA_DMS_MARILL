pageextension 25006106 "Purchase Return Orders" extends "Purchase Return Orders"//6643
{
    layout
    {
        addafter("Line Discount %")
        {
            field("Document Profile"; Rec."Document Profile")
            {
                ApplicationArea = All;
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
                ToolTip = 'View the entries for every reservation that is made, either manually or automatically.';

                trigger OnAction()
                begin
                    Rec.ShowVehReservationEntries(true);
                end;
            }
        }
    }
}