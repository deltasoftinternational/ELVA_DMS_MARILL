Table 25006210 "Quest. Subj. Group Q. Answer"
{
    // 06/03/2018 GH P1
    //   *Added ENG captions

    Caption = 'Quest. Subj. Group Q. Answer';
    LookupPageID = "Quest. Group Suj. Q. Answers";

    fields
    {
        field(10; "Questionary Subject Group Code"; Code[20])
        {
            Caption = 'Questionary Subject Group Code';
            NotBlank = true;
            TableRelation = "Questionary Subject Group".Code;
        }
        field(20; "Question No."; Integer)
        {
            Caption = 'Question No.';
            MinValue = 1;
            TableRelation = "Quest. Subj. Group Question"."No." where("Questionary Subject Group Code" = field("Questionary Subject Group Code"));
        }
        field(30; "Answer Text"; Text[250])
        {
            Caption = 'Answer Text';
            NotBlank = true;

            trigger OnValidate()
            begin
                Question.Get("Questionary Subject Group Code", "Question No.");
                if Question."Answer Type" in [Question."answer type"::Option] then
                    "Answer Text" := UpperCase("Answer Text");
            end;
        }
        field(110; "Sorting No."; Integer)
        {
            Caption = 'Sorting No.';
        }
    }

    keys
    {
        key(Key1; "Questionary Subject Group Code", "Question No.", "Answer Text")
        {
            Clustered = true;
        }
        key(Key2; "Questionary Subject Group Code", "Question No.", "Sorting No.")
        {
        }
    }

    fieldgroups
    {
    }

    var
        Question: Record "Quest. Subj. Group Question";
}

