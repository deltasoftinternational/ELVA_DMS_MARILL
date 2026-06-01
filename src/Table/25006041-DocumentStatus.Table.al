Table 25006041 "Document Status"
{
    DrillDownPageID = "Document Status List";
    LookupPageID = "Document Status List";

    fields
    {
        field(10; "Code"; Code[20])
        {
            Caption = 'Code';
        }
        field(20; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(30; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order,Transfer Order,Warranty Document';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order","Transfer Order","Warranty Document";
        }
        field(40; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade,Service,Rent';
            OptionMembers = " ","Spare Parts Trade","Vehicles Trade",Service,Rent;
        }
        field(50; "Next Status on Work Started"; Code[20])
        {
            Caption = 'Next Status on Work Started';
            TableRelation = "Document Status".Code;
        }
        field(60; "Next Status on Work Finished"; Code[20])
        {
            Caption = 'Next Status on Work Finished';
            TableRelation = "Document Status".Code;
        }
    }

    keys
    {
        key(Key1; "Document Profile", "Document Type", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

