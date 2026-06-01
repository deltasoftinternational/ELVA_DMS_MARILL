Table 25006162 "Recall Campaign"
{
    // 06.10.2017 EB.AKR Warranty
    //   Added Fields:
    //     51100Symptom Code
    //     51102Causal Part No.
    //     51302Make Code

    Caption = 'Recall Campaign';
    LookupPageID = "Recall Campaign List";

    fields
    {
        field(6; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(30; Description; Text[100])
        {
            Caption = 'Description';

            trigger OnValidate()
            begin
                if ("Search Description" = CopyStr(UpperCase(xRec.Description), 1, 30)) or ("Search Description" = '') then
                    "Search Description" := CopyStr(Description, 1, 30);
            end;
        }
        field(36; "Description 2"; Text[50])
        {
            Caption = 'Description 2';
        }
        field(40; "Search Description"; Code[30])
        {
            Caption = 'Search Name';
        }
        field(56; "No. Series"; Code[20])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(80; Comment; Boolean)
        {
            CalcFormula = exist("Service Comment Line EDMS" where(Type = const("Recall Campaign"),
                                                                   "No." = field("No.")));
            Caption = 'Comment';
            Editable = false;
            FieldClass = FlowField;
        }
        field(81; "External No."; Code[20])
        {
            Caption = 'External No.';
        }
        field(100; "Starting Date"; Date)
        {
            Caption = 'Starting Date';

            trigger OnValidate()
            begin
                if ("Starting Date" > "Ending Date") and ("Ending Date" > 0D) then
                    Error(Text000, FieldCaption("Starting Date"), FieldCaption("Ending Date"));
            end;
        }
        field(110; "Ending Date"; Date)
        {
            Caption = 'Ending Date';

            trigger OnValidate()
            begin
                if ("Ending Date" < "Starting Date") and ("Ending Date" > 0D) then
                    Error(Text001, FieldCaption("Ending Date"), FieldCaption("Starting Date"));
            end;
        }
        field(140; Active; Boolean)
        {
            Caption = 'Active';
        }
        field(150; Type; Code[20])
        {
            DataClassification = ToBeClassified;
            TableRelation = "Recall Campaign Types";
        }
        field(51100; "Symptom Code"; Code[10])
        {
            Caption = 'Symptom Code';
            TableRelation = "Symptom Code EDMS".Code;
        }
        field(51102; "Causal Part No."; Code[20])
        {
            Caption = 'Causal Part No.';
            TableRelation = Item;
        }
        field(51302; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Search Description")
        {
        }
        key(Key3; Active)
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        //VINs to be deleted
    end;

    trigger OnInsert()
    begin
        if "No." = '' then begin
            ServSetup.Get;
            ServSetup.TestField("Recall Campaign Nos.");
            "No." := NoSeriesMgt.GetNextNo(ServSetup."Recall Campaign Nos.", 0D, true);
        end;
    end;

    var
        ServSetup: Record "Service Mgt. Setup EDMS";
        NoSeriesMgt: Codeunit "No. Series";
        Recall: Record "Recall Campaign";
        Text000: label '%1 must be before %2.';
        Text001: label '%1 must be after %2.';
        Item: Record Item;


    procedure AssistEdit(OldRecall: Record "Recall Campaign"): Boolean
    begin
        Recall := Rec;
        ServSetup.Get;
        ServSetup.TestField("Recall Campaign Nos.");
        if NoSeriesMgt.LookupRelatedNoSeries(ServSetup."Recall Campaign Nos.", OldRecall."No. Series", Recall."No. Series") then begin
            ServSetup.Get();
            ServSetup.TestField("Recall Campaign Nos.");
            Recall."No." := NoSeriesMgt.GetNextNo(Recall."No. Series", WorkDate(), true);
            Rec := Recall;
            exit(true);
        end;

    end;
}

