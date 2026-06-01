tableextension 25006045 "Reservation Entry" extends "Reservation Entry" //337
{
    // 26.03.2014 Elva Baltic P21 #F182 MMG7.00
    //   Added field:
    //     Item No. Changed
    // 
    // 08.07.08 EDMS P1 - EDMS Service Management integration

    fields
    {
        field(25006000; "Item No. Changed"; Boolean)
        {
            Caption = 'Item No. Changed';
        }

    }
}