Page 25006066 "Contract Signers Archive"
{
    AutoSplitKey = true;
    Caption = 'Contract Signers Archive';
    DataCaptionFields = "Contract Type", "Contract No.";
    DelayedInsert = true;
    Editable = false;
    PageType = List;
    SourceTable = "Contract Signer Archive";

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field(ContractNo; Rec."Contract No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ContractLineNo; Rec."Contract Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ContactNo; Rec."Contact No.")
                {
                    ApplicationArea = Basic;
                }
                field(SignerName; Rec."Signer Name")
                {
                    ApplicationArea = Basic;
                }
                field(SignerSocialSecurityNo; Rec."Signer Social Security No.")
                {
                    ApplicationArea = Basic;
                }
                field(SignerPhoneNo; Rec."Signer Phone No.")
                {
                    ApplicationArea = Basic;
                }
                field(SignerFaxNo; Rec."Signer Fax No.")
                {
                    ApplicationArea = Basic;
                }
                field(SignerEMail; Rec."Signer E-Mail")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

