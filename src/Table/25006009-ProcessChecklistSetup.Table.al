Table 25006009 "Process Checklist Setup"
{
    // 10/08/2018 EB.P30 GH
    //   Added field:
    //     130 "Archive on Delete"

    Caption = 'Process Checklist Setup';
    //DrillDownPageID = UnknownPage70000;

    fields
    {
        field(10; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(100; "Process Checklist Nos."; Code[10])
        {
            Caption = 'Process Checklist Nos.';
            TableRelation = "No. Series";
        }
        field(110; "CheckBox Checked"; Blob)
        {
            Caption = 'CheckBox Checked';
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(120; "CheckBox Unchecked"; Blob)
        {
            Caption = 'CheckBox Unchecked';
            DataClassification = ToBeClassified;
            SubType = Bitmap;
        }
        field(130; "Archive on Delete"; Boolean)
        {
            Caption = 'Archive on Delete';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

