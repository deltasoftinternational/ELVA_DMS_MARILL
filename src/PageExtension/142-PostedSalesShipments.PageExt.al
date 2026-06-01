pageextension 25006060 "Posted Sales Shipments" extends "Posted Sales Shipments"//142
{
    layout
    {
        addafter("External Document No.")
        {
            field("Document Profile"; Rec."Document Profile")
            {
                ApplicationArea = All;
            }
        }
    }
}
