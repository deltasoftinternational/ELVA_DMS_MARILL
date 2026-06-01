tableextension 25006029 "Purchase Line Discount" extends "Purchase Line Discount" //7014
{
    fields
    {
        field(25006670; "Item Discount Group Code"; Code[10])
        {
            Caption = 'Item Discount Group Code';
            TableRelation = "Item Discount Group";
        }
        field(25006700; "Ordering Price Type Code"; Code[10])
        {
            Caption = 'Ordering Price Type Code';
            TableRelation = "Ordering Price Type";
        }
    }
}