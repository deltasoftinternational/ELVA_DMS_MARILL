pageextension 25006027 "Location Card" extends "Location Card" //5703

{
    layout
    {
        addafter("Use As In-Transit")
        {
            field(DefaultTransfFromLocCode; Rec."Default Transf. From Loc. Code")
            {
                ApplicationArea = Basic;
            }
            field("Hide Automatic Serv. Res. Msg."; Rec."Hide Automatic Serv. Res. Msg.")
            {
                ApplicationArea = Basic;
            }
        }
        addafter(ContactDetails)
        {
            field(UseAsServiceLocation; Rec."Use As Service Location")
            {
                ApplicationArea = Basic;
            }

            field(UseAsPartsLocationCode; Rec."Use As Parts Location Code")
            {
                ApplicationArea = Basic;
            }
            field(UseAsRentLocation; Rec."Use As Rent Location Code")
            {
                ApplicationArea = Basic;
            }
            field(RentInternalCustomerNo; Rec."Rent Internal Customer No.")
            {
                ApplicationArea = All;
            }
            field("Rent Vehicle Status Code"; Rec."Rent Vehicle Status Code")
            {
                ApplicationArea = All;
            }
        }
    }

    actions
    {
        addafter("Online Map")
        {
            action("DMS Dimensions")
            {
                ApplicationArea = Basic;
                Caption = 'Dimensions';
                Image = Dimensions;
                RunObject = Page "Default Dimensions";
                RunPageLink = "Table ID" = const(14),
                                  "No." = field(Code);
                ShortCutKey = 'Shift+Ctrl+D';
            }
        }
    }


}