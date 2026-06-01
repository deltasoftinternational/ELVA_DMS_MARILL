Table 25006759 "Nonstock Item Translation"
{
    Caption = 'Nonstock Item Translation';
    DataCaptionFields = "Nonstock Item Entry No.", "Language Code", Description;
    LookupPageID = "Nonstock Item Translations";

    fields
    {
        field(1; "Nonstock Item Entry No."; Code[20])
        {
            Caption = 'Nonstock Item Entry No.';
            NotBlank = true;
            TableRelation = "Nonstock Item";
        }
        field(2; "Language Code"; Code[10])
        {
            Caption = 'Language Code';
            NotBlank = true;
            TableRelation = Language;
        }
        field(3; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(4; "Description 2"; Text[30])
        {
            Caption = 'Description 2';
        }
    }

    keys
    {
        key(Key1; "Nonstock Item Entry No.", "Language Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        TranslationMgt.fNonstockTranslationToItem(Rec, xRec, 3);
    end;

    trigger OnInsert()
    begin
        TranslationMgt.fNonstockTranslationToItem(Rec, xRec, 0);
    end;

    trigger OnModify()
    begin
        TranslationMgt.fNonstockTranslationToItem(Rec, xRec, 1);
    end;

    trigger OnRename()
    begin
        TranslationMgt.fNonstockTranslationToItem(Rec, xRec, 2);
    end;

    var
        TranslationMgt: Codeunit "Translation Management";
}

