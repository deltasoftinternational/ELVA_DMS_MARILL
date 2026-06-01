Table 25006171 "Serv. Comment Line Arch. EDMS"
{
    // 17.11.04 AB izveidota tabula

    Caption = 'Serv. Comment Line Arch. EDMS';
    DrillDownPageID = "Service Comment List EDMS";
    LookupPageID = "Service Comment List EDMS";

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Service Quote,Service Order,Symtom,Cause,Labor,External Service,Service Package,Service Packages Specification,Contract,Vehicle,Service Return Order,Posted Service Order,Posted Service Return Order';
            OptionMembers = "Service Quote","Service Order",Symtom,Cause,Labor,"External Service","Service Package","Service Package Specification",Contract,Vehicle,"Service Return Order","Posted Service Order","Posted Service Return Order";
        }
        field(2; "No."; Code[20])
        {
            Caption = 'No.';
        }
        field(3; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(4; Date; Date)
        {
            Caption = 'Date';
        }
        field(5; "Code"; Code[10])
        {
            Caption = 'Code';
        }
        field(6; Comment; Text[80])
        {
            Caption = 'Comment';
        }
        field(7; "User ID"; Code[50])
        {
            Caption = 'User ID';

            trigger OnLookup()
            var
                LoginMgt: Codeunit UserProfileManagement;
            begin
                LoginMgt.LookupUserID("User ID");
            end;
        }
        field(8; "Doc. No. Occurrence"; Integer)
        {
            Caption = 'Doc. No. Occurrence';
        }
        field(9; "Version No."; Integer)
        {
            Caption = 'Version No.';
        }
        field(10; "Comment Type Code"; Code[20])
        {
            Caption = 'Comment Type Code';
            TableRelation = "Service Comment Line Type";
        }
        field(25006100; Satisfaction; Integer)
        {
            BlankZero = true;
            Caption = 'Satisfaction';
        }
    }

    keys
    {
        key(Key1; Type, "No.", "Doc. No. Occurrence", "Version No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure SetUpNewLine()
    var
        SalesCommentLine: Record "Sales Comment Line";
    begin
        SalesCommentLine.SetRange("Document Type", Type);
        SalesCommentLine.SetRange("No.", "No.");

        if SalesCommentLine.IsEmpty then
            Date := WorkDate;
    end;
}

