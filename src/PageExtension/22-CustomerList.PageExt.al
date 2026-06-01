pageextension 25006004 "Customer List" extends "Customer List" //22
{
    layout
    {

    }
    actions
    {
        addafter("C&ontact")
        {
            action(Vehicles)
            {
                ApplicationArea = Basic;
                Caption = '&Vehicles';
                Image = Delivery;

                trigger OnAction()
                begin
                    rec.ShowVehicles;
                end;
            }
        }
    }
}