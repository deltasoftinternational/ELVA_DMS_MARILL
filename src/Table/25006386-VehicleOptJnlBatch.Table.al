Table 25006386 "Vehicle Opt. Jnl. Batch"
{
    // 19.06.2004 EDMS P1
    //    *Created

    Caption = 'Vehicle Option Jnl. Batch';
    DataCaptionFields = Name, Description;
    LookupPageID = "Vehicle Opt. Jnl. Batches";

    fields
    {
        field(1; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            NotBlank = true;
            TableRelation = "Vehicle Opt. Jnl. Template";
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
        field(5; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            TableRelation = "No. Series";

            trigger OnValidate()
            begin
                if "No. Series" <> '' then begin
                    recVehOptJnlTemplate.Get("Journal Template Name");
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
                recVehOptJnlLine.SetRange("Journal Template Name", "Journal Template Name");
                recVehOptJnlLine.SetRange("Journal Batch Name", Name);
                recVehOptJnlLine.ModifyAll("Posting No. Series", "Posting No. Series");
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
        recVehOptJnlLine.SetRange("Journal Template Name", "Journal Template Name");
        recVehOptJnlLine.SetRange("Journal Batch Name", Name);
        recVehOptJnlLine.DeleteAll(true);
    end;

    trigger OnInsert()
    begin
        LockTable;
        recVehOptJnlTemplate.Get("Journal Template Name");
    end;

    trigger OnRename()
    begin
        recVehOptJnlLine.SetRange("Journal Template Name", xRec."Journal Template Name");
        recVehOptJnlLine.SetRange("Journal Batch Name", xRec.Name);
        if recVehOptJnlLine.FindSet(true, true) then
            repeat
                recVehOptJnlLine.Rename("Journal Template Name", Name, recVehOptJnlLine."Line No.");
            until recVehOptJnlLine.Next = 0;
    end;

    var
        Text000: label 'Only the %1 field can be filled in on recurring journals.';
        Text001: label 'must not be %1';
        recVehOptJnlTemplate: Record "Vehicle Opt. Jnl. Template";
        recVehOptJnlLine: Record "Vehicle Opt. Jnl. Line";


    procedure fSetupNewBatch()
    begin
        recVehOptJnlTemplate.Get("Journal Template Name");
        "No. Series" := recVehOptJnlTemplate."No. Series";
        "Posting No. Series" := recVehOptJnlTemplate."Posting No. Series";
    end;
}

