Table 25006168 "Service Register EDMS"
{
    // 29.09.2011 EDMS P8
    //   * Implement Tire Management, added fields:
    //   *   From Tire Entry No.
    //   *   To Tire Entry No.

    Caption = 'Service Register EDMS';
    DrillDownPageID = "Resource Registers";
    LookupPageID = "Resource Registers";

    fields
    {
        field(1; "No."; Integer)
        {
            Caption = 'No.';
        }
        field(2; "From Entry No."; Integer)
        {
            Caption = 'From Entry No.';
            TableRelation = "Service Ledger Entry EDMS";
        }
        field(3; "To Entry No."; Integer)
        {
            Caption = 'To Entry No.';
            TableRelation = "Service Ledger Entry EDMS";
        }
        field(4; "Creation Date"; Date)
        {
            Caption = 'Creation Date';
        }
        field(5; "Source Code"; Code[10])
        {
            Caption = 'Source Code';
            TableRelation = "Source Code";
        }
        field(6; "User ID"; Code[50])
        {
            Caption = 'User ID';

            trigger OnLookup()
            var
                LoginMgt: Codeunit UserProfileManagement;
            begin
                LoginMgt.LookupUserID("User ID");
            end;
        }
        field(7; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
        }
        field(20; "From Tire Entry No."; Integer)
        {
            Caption = 'From Tire Entry No.';
            TableRelation = "Tire Entry"."Entry No.";
        }
        field(21; "To Tire Entry No."; Integer)
        {
            Caption = 'To Tire Entry No.';
            TableRelation = "Tire Entry"."Entry No.";
        }
        field(12800; "Creation Time"; Time)
        {
            Caption = 'Creation Time';
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Creation Date")
        {
        }
        key(Key3; "Source Code", "Journal Batch Name", "Creation Date")
        {
        }
    }

    fieldgroups
    {
    }
}

