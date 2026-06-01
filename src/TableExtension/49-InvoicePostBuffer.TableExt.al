tableextension 25006010 "Invoice Post. Buffer" extends "Invoice Post. Buffer"//49
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
