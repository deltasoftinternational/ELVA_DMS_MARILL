Table 25006147 "Technical Condition"
{
    Caption = 'Technical Condition';
    LookupPageID = "Technical Condition";

    fields
    {
        field(10; "Document type"; Option)
        {
            Caption = 'Document type';
            OptionCaption = ' ,Quote,Order,Invoice';
            OptionMembers = " ",Quote,"Order",Invoice;
        }
        field(20; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(30; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(40; Description; Text[80])
        {
            Caption = 'Description';
        }
    }

    keys
    {
        key(Key1; "Document type", "Document No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

