tableextension 25006017 "Purch. Rcpt. Header" extends "Purch. Rcpt. Header" //120
{
    fields
    {
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service';
            OptionMembers = " ","Spare Parts Trade","Vehicles Trade",Service;
        }
        field(25006001; "Deal Type Code"; Code[10])
        {
            Caption = 'Deal Type Code';
            TableRelation = "Deal Type";
        }
    }
    keys
    {
        key(Key7; "Document Profile")
        {
        }
    }

}