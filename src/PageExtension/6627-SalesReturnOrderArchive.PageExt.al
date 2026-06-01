pageextension 25006101 "Sales Return Order Archive" extends "Sales Return Order Archive"//6627
{
    layout
    {
        addafter(Status)
        {
            field(PhoneNo; Rec."Phone No.")
            {
                ApplicationArea = Basic;
                Importance = Additional;
            }
            field(MobilePhoneNo; Rec."Mobile Phone No.")
            {
                ApplicationArea = Basic;
                Importance = Additional;
            }
        }
        modify(SalesLinesArchive)
        {
            Visible = not VehicleTradeDocument;
        }
        addafter(SalesLinesArchive)
        {
            part(SalesLinesArchiveVehicle; "Sales Ret. Ord Arch Sub (Veh.)")
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
        [InDataSet]
        VehicleTradeDocument: Boolean;
}
