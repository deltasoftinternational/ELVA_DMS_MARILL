tableextension 25006176 "Invoice Posting Buffer" extends "Invoice Posting Buffer"//55
{
    fields
    {
        field(25006050; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No';
        }
        field(25006379; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            Editable = false;
        }
    }
}