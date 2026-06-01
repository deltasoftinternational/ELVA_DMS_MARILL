tableextension 25006041 "Gen. Product Posting Group" extends "Gen. Product Posting Group" //251
{
    // 21.01.2015 EDMS P11
    //   Vehicle special cost adjustment
    //   Added fields:
    //     25006000 "Split Value Entries"

    fields
    {
        field(25006000; "Split Value Entries"; Boolean)
        {
            Caption = 'Split Value Entries';
        }
    }
}