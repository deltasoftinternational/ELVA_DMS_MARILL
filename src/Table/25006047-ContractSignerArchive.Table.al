Table 25006047 "Contract Signer Archive"
{
    Caption = 'Contract Signer Archive';
    DrillDownPageID = "Contract Signers Archive";
    LookupPageID = "Contract Signers Archive";

    fields
    {
        field(5; "Contract Type"; Option)
        {
            Caption = 'Contract Type';
            Description = 'Not Supported. Reserved for future.';
            OptionCaption = 'Quote,Contract';
            OptionMembers = Quote,Contract;
        }
        field(10; "Contract No."; Code[20])
        {
            Caption = 'Contract No.';
            TableRelation = Contract."Contract No.";
        }
        field(20; "Contract Line No."; Integer)
        {
            Caption = 'Contract Line No.';
        }
        field(30; "Contact No."; Code[20])
        {
            Caption = 'Contact No.';
            TableRelation = Contact."No.";
        }
        field(910; "Signer Name"; Text[50])
        {
            Caption = 'Signer Name';
        }
        field(915; "Signer Social Security No."; Text[30])
        {
            Caption = 'Social Security No.';
        }
        field(920; "Signer Phone No."; Text[30])
        {
            Caption = 'Signer Phone No.';
        }
        field(930; "Signer Fax No."; Text[30])
        {
            Caption = 'Signer Fax No.';
        }
        field(940; "Signer E-Mail"; Text[80])
        {
            Caption = 'Signer E-Mail';
        }
        field(5047; "Version No."; Integer)
        {
            Caption = 'Version No.';
        }
        field(5048; "Doc. No. Occurrence"; Integer)
        {
            Caption = 'Doc. No. Occurrence';
        }
    }

    keys
    {
        key(Key1; "Contract Type", "Contract No.", "Doc. No. Occurrence", "Version No.", "Contract Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

