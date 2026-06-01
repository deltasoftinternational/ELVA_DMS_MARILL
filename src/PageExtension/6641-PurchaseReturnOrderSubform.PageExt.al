pageextension 25006105 "Purchase Return Order Subform" extends "Purchase Return Order Subform"//6641
{
    layout
    {
        addafter(ShortcutDimCode8)
        {
            field(ExternalServTrackingNo; Rec."External Serv. Tracking No.")
            {
                ApplicationArea = Basic;
                Visible = True;
            }
        }
    }
    actions
    {
        modify(Reserve)
        {
            Visible = false;
        }
        addafter(Reserve)
        {
            action(DMSReserve)
            {
                ApplicationArea = Reservation;
                Caption = '&Reserve';
                Image = Reserve;
                Enabled = Rec.Type = Rec.Type::Item;
                ToolTip = 'Reserve the quantity of the selected item that is required on the document line from which you opened this page. This action is available only for lines that contain an item.';

                trigger OnAction()
                begin
                    PageShowReservation();
                end;
            }
        }
    }
    local procedure PageShowReservation()
    begin
        Rec.Find();
        Rec.ShowVehReservation;
    end;
}