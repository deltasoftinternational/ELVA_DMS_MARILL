Table 25006761 "Item Markup Restriction Group"
{
    // 22.10.2007. EDMS P2
    //   * Added new field "Notification Type"

    Caption = 'Item Markup Restriction Group';
    LookupPageID = "Item Markup Restriction Groups";

    fields
    {
        field(10; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(20; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(30; "Notification Type"; Option)
        {
            Caption = 'Notification Type';
            OptionCaption = 'Message,Error';
            OptionMembers = Message,Error;
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

