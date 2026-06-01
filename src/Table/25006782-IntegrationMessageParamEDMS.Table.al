Table 25006782 "Integration Message Param EDMS"
{
    Caption = 'DMS Integration Message Param';

    fields
    {
        field(10; "Message ID"; Integer)
        {
            Caption = 'Message ID';
            TableRelation = "Integration Message EDMS";
        }
        field(20; "Message Line No."; Integer)
        {
            Caption = 'Message Line No.';
        }
        field(30; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
        }
        field(200; "User ID"; Code[50])
        {
            Caption = 'User ID';
            DataClassification = ToBeClassified;
        }
        field(210; "Date, Time Stamp"; DateTime)
        {
            Caption = 'Date, Time Stamp';
            DataClassification = ToBeClassified;
        }
        field(1000; "Source Type"; Integer)
        {
            Caption = 'Source Type';
            DataClassification = ToBeClassified;
            Description = '1000..1999   NAV side info';
        }
        field(1010; "Source Subtype"; Option)
        {
            Caption = 'Source Subtype';
            DataClassification = ToBeClassified;
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
        }
        field(1020; "Source ID"; Code[20])
        {
            Caption = 'Source ID';
            DataClassification = ToBeClassified;
        }
        field(1021; "Source ID1"; Code[20])
        {
            Caption = 'Source ID1';
            DataClassification = ToBeClassified;
        }
        field(1022; "Source ID2"; Code[20])
        {
            Caption = 'Source ID2';
            DataClassification = ToBeClassified;
        }
        field(1030; "Source Batch Name"; Code[10])
        {
            Caption = 'Source Batch Name';
            DataClassification = ToBeClassified;
        }
        field(1040; "Source Prod. Order Line"; Integer)
        {
            Caption = 'Source Prod. Order Line';
            DataClassification = ToBeClassified;
        }
        field(1050; "Source Ref. No."; Integer)
        {
            Caption = 'Source Ref. No.';
            DataClassification = ToBeClassified;
        }
        field(1070; "Item Ledger Entry No."; Integer)
        {
            Caption = 'Item Ledger Entry No.';
            DataClassification = ToBeClassified;
            Editable = false;
            TableRelation = "Item Ledger Entry";
        }
        field(2000; "Param Name"; Text[50])
        {
            Caption = 'Param Name';
            DataClassification = ToBeClassified;
        }
        field(2010; "Param Value"; Text[250])
        {
            Caption = 'Param Value';
            DataClassification = ToBeClassified;
        }
        field(2020; Visible; Boolean)
        {
            Caption = 'Visible';
            DataClassification = ToBeClassified;
        }
        field(2030; "Modified By User"; Boolean)
        {
            Caption = 'Modified By User';
            DataClassification = ToBeClassified;
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Message ID", "Message Line No.", "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Source Type", "Source Subtype", "Source ID", "Source Ref. No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    begin
        TestField("Message ID");
        if "Entry No." = 0 then begin
            Rec2.Reset;
            Rec2.SetRange("Message ID", "Message ID");
            Rec2.SetRange("Message Line No.", "Message Line No.");
            if Rec2.FindLast then
                "Entry No." := Rec2."Entry No." + 1
            else
                "Entry No." := 1;
        end;

        "User ID" := UserId;
        "Date, Time Stamp" := CurrentDatetime;
    end;

    var
        Rec2: Record "Integration Message Param EDMS";


    procedure SetSource(SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceBatchName: Code[10]; SourceProdLineNo: Integer; SourceRefNo: Integer; ItemLedgEntryNo: Integer)
    begin
        "Source Type" := SourceType;
        "Source Subtype" := SourceSubtype;
        "Source ID" := SourceID;
        "Source Batch Name" := SourceBatchName;
        "Source Prod. Order Line" := SourceProdLineNo;
        "Source Ref. No." := SourceRefNo;
        "Item Ledger Entry No." := ItemLedgEntryNo;
    end;
}

