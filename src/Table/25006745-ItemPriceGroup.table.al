table 25006745 "Item Price Group"
{
    Caption = 'Item Price Group';
    DataClassification = ToBeClassified;
    LookupPageID = "Item Price Groups";
    DrillDownPageId = "Item Price Groups";

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            DataClassification = ToBeClassified;
        }
        field(2; Description; Text[50])
        {
            Caption = 'Description';
            DataClassification = ToBeClassified;
        }
        field(3; "Purchase Discount percent"; Decimal)
        {
            Caption = 'Purchase Discount percent';
            DataClassification = ToBeClassified;
        }
        field(4; "Purchase Discount percent 2"; Decimal)
        {
            Caption = 'Purchase Discount percent 2';
            DataClassification = ToBeClassified;
        }
    }
    keys
    {
        key(PK; "Code")
        {
            Clustered = true;
        }
    }
}
