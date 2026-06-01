/*
Table 25006708 "SIE Object Category"
{
    Caption = 'SIE Object Category';
    LookupPageID = "SIE Object Categories";

    fields
    {
        field(5;"SIE No.";Code[10])
        {
            Caption = 'SIE No.';
            NotBlank = true;
            TableRelation = "Special Inventory Equipment"."No.";
        }
        field(10;"No.";Code[10])
        {
            Caption = 'No.';
            NotBlank = true;
        }
        field(20;Name;Text[30])
        {
            Caption = 'Name';
        }
        field(30;SYSType;Option)
        {
            Caption = 'SYSType';
            OptionCaption = ' ,Bin,Resource';
            OptionMembers = " ",Bin,Resource;
        }
    }

    keys
    {
        key(Key1;"SIE No.","No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}
*/