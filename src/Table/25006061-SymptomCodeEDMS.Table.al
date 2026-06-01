Table 25006061 "Symptom Code EDMS"
{
    // 20.03.2014 Elva Baltic P1 #X01 MMG7.00
    //  * Code field added to Primary Key
    // 
    // 18.03.2014 Elva Baltic P8 #S0006 MMG7.00
    //   * created

    Caption = 'Symptom Code EDMS';
    DrillDownPageID = "Symptom Code List";
    LookupPageID = "Symptom Code List";

    fields
    {
        field(9; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            NotBlank = true;
            TableRelation = Make;
        }
        field(10; "Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(20; Name; Text[70])
        {
            Caption = 'Name';
        }
        field(30; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(40; "Description 2"; Text[100])
        {
            Caption = 'Description 2';
        }
        field(41; "Description 3"; Text[100])
        {
            Caption = 'Description 3';
        }
        field(50; "Symptom Group"; Code[20])
        {
            Caption = 'Symptom Group';
        }
        field(51; "Symptom Group Name"; Text[50])
        {
            Caption = 'Symptom Group Name';
        }
        field(60; Common; Boolean)
        {
            Caption = 'Common';
        }
    }

    keys
    {
        key(Key1; "Make Code", "Code")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

