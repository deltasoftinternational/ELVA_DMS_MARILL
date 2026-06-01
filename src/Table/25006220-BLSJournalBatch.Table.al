Table 25006220 "BLS Journal Batch"
{
    Caption = 'BLS Journal Batch';
    DataCaptionFields = Name, Description;
    LookupPageID = "BLS Jnl. Batches";

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "BLS Journal Template";
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
                    BLSJnlLine.SetRange("Journal Template Name", "Journal Template Name");
                    BLSJnlLine.SetRange("Journal Batch Name", Name);
                    BLSJnlLine.ModifyAll("Reason Code", "Reason Code");
                    Modify;
                end;
            end;
        }
        field(5; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                if "No. Series" <> '' then begin
                    BLSJnlTemplate.Get("Journal Template Name");
                    if BLSJnlTemplate.Recurring then
                        Error(
                          Text000,
                          FieldCaption("Posting No. Series"));
                    if "No. Series" = "Posting No. Series" then
                        Validate("Posting No. Series", '');
                end;
            end;
        }
        field(6; "Posting No. Series"; Code[10])
        {
            Caption = 'Posting No. Series';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                if ("Posting No. Series" = "No. Series") and ("Posting No. Series" <> '') then
                    FieldError("Posting No. Series", StrSubstNo(Text001, "Posting No. Series"));
                BLSJnlLine.SetRange("Journal Template Name", "Journal Template Name");
                BLSJnlLine.SetRange("Journal Batch Name", Name);
                BLSJnlLine.ModifyAll("Posting No. Series", "Posting No. Series");
                Modify;
            end;
        }
        field(22; Recurring; Boolean)
        {
            CalcFormula = lookup("Res. Journal Template".Recurring where(Name = field("Journal Template Name")));
            Caption = 'Recurring';
            Editable = false;
            FieldClass = FlowField;
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
        BLSJnlLine.SetRange("Journal Template Name", "Journal Template Name");
        BLSJnlLine.SetRange("Journal Batch Name", Name);
        BLSJnlLine.DeleteAll(true);
    end;

    trigger OnInsert()
    begin
        LockTable;
        BLSJnlTemplate.Get("Journal Template Name");
    end;

    trigger OnRename()
    begin
        BLSJnlLine.SetRange("Journal Template Name", xRec."Journal Template Name");
        BLSJnlLine.SetRange("Journal Batch Name", xRec.Name);
        while BLSJnlLine.FindFirst do
            BLSJnlLine.Rename("Journal Template Name", Name, BLSJnlLine."Line No.");
    end;

    var
        BLSJnlTemplate: Record "BLS Journal Template";
        BLSJnlLine: Record "BLS Journal Line";
        Text000: label 'Only the %1 field can be filled in on recurring journals.';
        Text001: label 'must not be %1';


    procedure SetupNewBatch()
    begin
        BLSJnlTemplate.Get("Journal Template Name");
        "No. Series" := BLSJnlTemplate."No. Series";
        "Posting No. Series" := BLSJnlTemplate."Posting No. Series";
        "Reason Code" := BLSJnlTemplate."Reason Code";
    end;
}

