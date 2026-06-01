tableextension 25006374 "Item Charge" extends "Item Charge" //5800
{
    // 18.03.2019 EB.KN
    //   * Inventory Posting group field Code 10 --> Code 20
    // 
    // //30-08-2007 EDMS P3
    //    * New field Inventory Posting Group
    fields
    {
        field(25006000; "Inventory Posting Group"; Code[20])
        {
            Caption = 'Inventory Posting Group';
            TableRelation = "Inventory Posting Group";
        }

    }

}