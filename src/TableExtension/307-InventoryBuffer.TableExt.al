tableextension 25006043 "Inventory Buffer" extends "Inventory Buffer" //307
{
    fields
    {
        field(25006379; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            TableRelation = "Vehicle Accounting Cycle"."No.";
        }
    }
}