//Table 25006148 "Service Comment Line EDMS"
Table 25006381 "Service Comment Line EDMS"
{
    // 04.04.2013 EDMS P8
    //   * Is extended options of field Type
    // 
    // 17.11.04 AB izveidota tabula

    Caption = 'Service Comment Line EDMS';
    DrillDownPageID = "Service Comment List EDMS";
    LookupPageID = "Service Comment List EDMS";

    fields
    {
        field(1; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'Service Quote,Service Order,Symtom,Recall Campaign,Labor,External Service,Service Package,Service Package Specification,Contract,Vehicle,Service Return Order,Posted Service Order,Posted Service Return Order,Warranty Document';
            OptionMembers = "Service Quote","Service Order",Symtom,"Recall Campaign",Labor,"External Service","Service Package","Service Package Specification",Contract,Vehicle,"Service Return Order","Posted Service Order","Posted Service Return Order","Warranty Doc";
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
        field(10; "Comment Type Code"; Code[20])
        {
            Caption = 'Comment Type Code';
            TableRelation = "Service Comment Line Type";
        }
        field(25006000; "Extended Comment (BLOB)"; Blob)
        {
            Caption = 'Extended Comment (BLOB)';
            DataClassification = SystemMetadata;
        }
    }

    keys
    {
        key(Key1; Type, "No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        "User ID" := UserId;
        ServiceMgtSetup.Get;
        if "Comment Type Code" = '' then
            Validate("Comment Type Code", ServiceMgtSetup."Service Comment Line Type");
    end;

    trigger OnModify()
    begin
        "User ID" := UserId;
    end;

    var
        ServiceMgtSetup: Record "Service Mgt. Setup EDMS";


    procedure SetUpNewLine()
    var
        CommentLine: Record "Service Comment Line EDMS";
    begin
        CommentLine.Reset();
        CommentLine.SetRange("Type", Type);
        CommentLine.SetRange("No.", "No.");
        if CommentLine.FindLast() then
            "Line No." := CommentLine."Line No." + 10000
        else
            "Line No." := 10000;

        Date := WorkDate;


        ServiceMgtSetup.Get;
        if "Comment Type Code" = '' then
            Validate("Comment Type Code", ServiceMgtSetup."Service Comment Line Type");
    end;

    procedure SetExtendedComment(NewWorkDescription: Text)
    var
        TempBlob: Codeunit "Temp Blob";
        OutStr: OutStream;
        LineExist: Boolean;
        CommentLine: Record "Service Comment Line EDMS";
    begin
        LineExist := CommentLine.Get(Type, "No.", "Line No.");
        Clear("Extended Comment (BLOB)");

        "Extended Comment (BLOB)".CREATEOUTSTREAM(OutStr, TextEncoding::UTF8);
        OutStr.WriteText(NewWorkDescription);
        Comment := CopyStr(NewWorkDescription, 1, MaxStrLen(Comment));
        if not LineExist then
            Insert(true)
        else
            Modify();
    end;

    procedure GetExtendeComment() Result: Text
    var
        TempBlob: Codeunit "Temp Blob";
        CR: Text[1];
        InStr: InStream;
    begin
        CalcFields("Extended Comment (BLOB)");
        if not "Extended Comment (BLOB)".Hasvalue() then
            exit('');
        CR[1] := 10;
        "Extended Comment (BLOB)".CREATEINSTREAM(InStr, TextEncoding::UTF8);
        InStr.Read(Result);
    end;
}

