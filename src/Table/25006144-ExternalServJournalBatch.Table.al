Table 25006144 "External Serv. Journal Batch"
{
    Caption = 'External Serv. Journal Batch';
    LookupPageID = "Ext. Service Jnl. Batches";

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Ext. Service Journal Template";
        }
        field(2; Name; Code[10])
        {
            Caption = 'Name';
            NotBlank = true;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(4; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Reason Code";
        }
        field(5; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";
        }
        field(6; "Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";
        }
    }

    keys
    {
        key(Key1; "Journal Template Name", Name)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        ExtServiceJnlTemplate: Record "Ext. Service Journal Template";


    procedure SetupNewBatch()
    begin
        ExtServiceJnlTemplate.Get("Journal Template Name");
        "No. Series" := ExtServiceJnlTemplate."No. Series";
        "Posting No. Series" := ExtServiceJnlTemplate."Posting No. Series";
        "Reason Code" := ExtServiceJnlTemplate."Reason Code";
    end;
}

