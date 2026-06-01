Table 25006292 "Serv. Alloc. Status Priority"
{
    Caption = 'Serv. Alloc. Status Priority';

    fields
    {
        field(1; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Pending,In Progress,Finished,On Hold';
            OptionMembers = Pending,"In Progress",Finished,"On Hold";
        }
        field(2; Description; Text[30])
        {
            Caption = 'Description';
        }
        field(4; Priority; Option)
        {
            Caption = 'Priority';
            OptionCaption = 'High,Medium High,Medium Low,Low';
            OptionMembers = High,"Medium High","Medium Low",Low;
        }
    }

    keys
    {
        key(Key1; Status)
        {
            Clustered = true;
        }
        key(Key2; Priority)
        {
        }
    }

    fieldgroups
    {
    }
}

