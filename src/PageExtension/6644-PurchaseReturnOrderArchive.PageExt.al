pageextension 25006107 "Purchase Return Order Archive" extends "Purchase Return Order Archive"//6644
{
    layout
    {
        modify(PurchLinesArchive)
        {
            Visible = not VehicleTradeDocument;
        }
        addafter(PurchLinesArchive)
        {
            part(PurchLinesArchiveVehicle; "Purch Ret. Ord Arch Sub (Veh.)")
            {
                ApplicationArea = All;
                Visible = VehicleTradeDocument;
            }
        }
    }
    trigger OnOpenPage()
    begin

        VehicleTradeDocument := Rec."Document Profile" = Rec."document profile"::"Vehicles Trade";
    end;

    var
        VehicleTradeDocument: Boolean;
}