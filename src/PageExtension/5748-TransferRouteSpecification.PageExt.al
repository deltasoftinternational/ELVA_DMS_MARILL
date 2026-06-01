pageextension 25006093 "Transfer Route Specification" extends "Transfer Route Specification"//5748
{
    layout
    {
        addfirst(General)
        {
            field(TransferfromCode; Rec."Transfer-from Code")
            {
                ApplicationArea = Basic;
            }
            field(TransfertoCode; Rec."Transfer-to Code")
            {
                ApplicationArea = Basic;
            }
        }
        addlast(General)
        {
            field(DefaultVehicleStatusto; Rec."Default Vehicle Status-to")
            {
                ApplicationArea = Basic;
            }
        }
    }
}