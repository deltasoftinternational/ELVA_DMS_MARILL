Table 25006205 "Warranty Journal Batch"
{
    Caption = 'Warranty Journal Batch';
    DataCaptionFields = Name, Description;
    LookupPageID = "Warranty Jnl. Batches";

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Warranty Journal Template";
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
                    WarrantyJnlLine.SetRange("Journal Template Name", "Journal Template Name");
                    WarrantyJnlLine.SetRange("Journal Batch Name", Name);
                    WarrantyJnlLine.ModifyAll("Reason Code", "Reason Code");
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
                    WarrantyJnlTemplate.Get("Journal Template Name");
                    if WarrantyJnlTemplate.Recurring then
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
                WarrantyJnlLine.SetRange("Journal Template Name", "Journal Template Name");
                WarrantyJnlLine.SetRange("Journal Batch Name", Name);
                WarrantyJnlLine.ModifyAll("Posting No. Series", "Posting No. Series");
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
        WarrantyJnlLine.SetRange("Journal Template Name", "Journal Template Name");
        WarrantyJnlLine.SetRange("Journal Batch Name", Name);
        WarrantyJnlLine.DeleteAll(true);
    end;

    trigger OnInsert()
    begin
        LockTable;
        WarrantyJnlTemplate.Get("Journal Template Name");
    end;

    trigger OnRename()
    begin
        WarrantyJnlLine.SetRange("Journal Template Name", xRec."Journal Template Name");
        WarrantyJnlLine.SetRange("Journal Batch Name", xRec.Name);
        while WarrantyJnlLine.FindSet(true, true) do
            WarrantyJnlLine.Rename("Journal Template Name", Name, WarrantyJnlLine."Line No.");
    end;

    var
        Text000: label 'Only the %1 field can be filled in on recurring journals.';
        Text001: label 'must not be %1';
        WarrantyJnlTemplate: Record "Warranty Journal Template";
        WarrantyJnlLine: Record "Warranty Journal Line";


    procedure SetupNewBatch()
    begin
        WarrantyJnlTemplate.Get("Journal Template Name");
        "No. Series" := WarrantyJnlTemplate."No. Series";
        "Posting No. Series" := WarrantyJnlTemplate."Posting No. Series";
        "Reason Code" := WarrantyJnlTemplate."Reason Code";
    end;
}

