pageextension 25006069 "Item Journal Batches" extends "Item Journal Batches" //262
{
    layout
    {
        addafter("Reason Code")
        {
            field(LocationCode; Rec."Location Code")
            {
                ApplicationArea = Basic;
            }
        }
    }
}