Table 25006018 "Contract Signer"
{
    Caption = 'Contract Signer';

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

            trigger OnValidate()
            var
                Cont: Record Contact;
                ContBusinessRelation: Record "Contact Business Relation";
            begin
                if Cont.Get("Contact No.") then begin
                    "Signer Name" := Cont.Name;
                    "Signer Phone No." := Cont."Phone No.";
                    "Signer E-Mail" := Cont."E-Mail";
                    //"Signer Social Security No." := Cont."Social Security No.";
                    "Signer Fax No." := Cont."Fax No."
                end
                else begin
                    "Signer Name" := '';
                    "Signer Phone No." := '';
                    "Signer E-Mail" := '';
                    "Signer Fax No." := '';
                    exit;
                end;
            end;
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
    }

    keys
    {
        key(Key1; "Contract Type", "Contract No.", "Contract Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

