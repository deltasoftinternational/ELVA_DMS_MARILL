tableextension 25006015 "Inventory Posting Group" extends "Inventory Posting Group" //94
{
    // 21.01.2015 EDMS P11
    //   Vehicle special cost adjustment
    //   Added fields:
    //     25006001 "Split Value Entries"
    fields
    {
        field(25006000; "Vehicle Additional Expenses"; Boolean)
        {
            Caption = 'Vehicle Additional Expenses';
        }
        field(25006001; "Split Value Entries"; Boolean)
        {
            Caption = 'Split Value Entries';
        }
    }

}