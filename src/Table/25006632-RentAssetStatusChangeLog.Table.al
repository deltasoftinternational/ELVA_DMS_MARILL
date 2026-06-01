Table 25006632 "Rent Asset Status Change Log"
{
    Caption = 'Rent Asset Status Change Log';

    fields
    {
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            DataClassification = ToBeClassified;
        }
        field(20; "Rent Asset No."; Code[20])
        {
            Caption = 'Rent Asset No.';
            DataClassification = ToBeClassified;
            TableRelation = "Rent Asset";
        }
        field(30; Date; Date)
        {
            Caption = 'Date';
            DataClassification = ToBeClassified;
        }
        field(40; "New Status"; Option)
        {
            Caption = 'New Status';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Available,Reserved,Rented,Received,Service Planned,Service,Other,Disposed';
            OptionMembers = " ",Available,Reserved,Rented,Received,"Service Planned",Service,Other,Disposed;
        }
        field(50; "Previos Status"; Option)
        {
            Caption = 'Previous Status';
            DataClassification = ToBeClassified;
            OptionCaption = ' ,Available,Reserved,Rented,Received,Service Planned,Service,Other,Disposed';
            OptionMembers = " ",Available,Reserved,Rented,Received,"Service Planned",Service,Other,Disposed;
        }
        field(60; "User ID"; Code[100])
        {
            Caption = 'User ID';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure AddChangeLogEntry(RentAssetNo: Code[20]; NewStatus: Integer; PreviosStatus: Integer)
    var
        EntryNo: Integer;
    begin
        Reset;
        if FindLast then
            EntryNo := "Entry No." + 1
        else
            EntryNo := 1;

        Init;
        "Entry No." := EntryNo;
        "Rent Asset No." := RentAssetNo;
        Date := WorkDate;
        "New Status" := NewStatus;
        "Previos Status" := PreviosStatus;
        "User ID" := UserId;
        Insert;
    end;
}

