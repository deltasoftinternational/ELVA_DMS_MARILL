Table 25006275 "Schedule Resource Group Spec."
{
    // 18.12.2014 EDMS P12
    //   * Changed properties ValidateTableRelation, TestTableRelation for field "Resource No." from No to Yes.
    // 
    // 22.03.2014 Elva Baltic P1 #RX MMG7.00
    //   *Field "Description" added

    Caption = 'Schedule Resource Group Spec.';
    DrillDownPageID = "Schedule Res. Group Spec.";

    fields
    {
        field(10; "Group Code"; Code[10])
        {
            Caption = 'Group Code';
            TableRelation = "Schedule Resource Group";
        }
        field(30; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            TableRelation = Resource;

            trigger OnValidate()
            var
                Resource: Record Resource;
            begin
                Resource.Reset;
                if Resource.Get("Resource No.") then
                    Description := Resource.Name;
            end;
        }
        field(40; Description; Text[30])
        {
            Caption = 'Name';
        }
        field(60; Current; Boolean)
        {
            Caption = 'Current';
        }
    }

    keys
    {
        key(Key1; "Group Code", "Resource No.")
        {
            Clustered = true;
        }
        key(Key2; Description)
        {
        }
    }

    fieldgroups
    {
    }
}

