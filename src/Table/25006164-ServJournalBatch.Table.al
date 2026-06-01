Table 25006164 "Serv. Journal Batch"
{
    Caption = 'Serv. Journal Batch';
    DataCaptionFields = Name, Description;
    LookupPageID = "Service Jnl. Batches";

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Serv. Journal Template";
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

            trigger OnValidate()
            begin
                if "Reason Code" <> xRec."Reason Code" then begin
                    ServJnlLine.SetRange("Journal Template Name", "Journal Template Name");
                    ServJnlLine.SetRange("Journal Batch Name", Name);
                    ServJnlLine.ModifyAll("Reason Code", "Reason Code");
                    Modify;
                end;
            end;
        }
        field(5; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                if "No. Series" <> '' then begin
                    ServJnlTemplate.Get("Journal Template Name");
                    if ServJnlTemplate.Recurring then
                        Error(
                          Text000,
                          FieldCaption("Posting No. Series"));
                    if "No. Series" = "Posting No. Series" then
                        Validate("Posting No. Series", '');
                end;
            end;
        }
        field(6; "Posting No. Series"; Code[20])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                if ("Posting No. Series" = "No. Series") and ("Posting No. Series" <> '') then
                    FieldError("Posting No. Series", StrSubstNo(Text001, "Posting No. Series"));
                ServJnlLine.SetRange("Journal Template Name", "Journal Template Name");
                ServJnlLine.SetRange("Journal Batch Name", Name);
                ServJnlLine.ModifyAll("Posting No. Series", "Posting No. Series");
                Modify;
            end;
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

    trigger OnDelete()
    begin
        ServJnlLine.SetRange("Journal Template Name", "Journal Template Name");
        ServJnlLine.SetRange("Journal Batch Name", Name);
        ServJnlLine.DeleteAll(true);
    end;

    trigger OnInsert()
    begin
        LockTable;
        ServJnlTemplate.Get("Journal Template Name");
    end;

    trigger OnRename()
    begin
        ServJnlLine.SetRange("Journal Template Name", xRec."Journal Template Name");
        ServJnlLine.SetRange("Journal Batch Name", xRec.Name);
        while ServJnlLine.FindSet(true, true) do
            ServJnlLine.Rename("Journal Template Name", Name, ServJnlLine."Line No.");
    end;

    var
        Text000: label 'Only the %1 field can be filled in on recurring journals.';
        Text001: label 'must not be %1';
        ServJnlTemplate: Record "Serv. Journal Template";
        ServJnlLine: Record "Serv. Journal Line";


    procedure SetupNewBatch()
    begin
        ServJnlTemplate.Get("Journal Template Name");
        "No. Series" := ServJnlTemplate."No. Series";
        "Posting No. Series" := ServJnlTemplate."Posting No. Series";
        "Reason Code" := ServJnlTemplate."Reason Code";
    end;
}

