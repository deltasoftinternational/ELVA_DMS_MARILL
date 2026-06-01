Table 25006771 "Integration Connector EDMS"
{
    // #Owner EDMS.Integration

    Caption = 'Integration Connector';
    LookupPageID = "Integration Connectors EDMS";

    fields
    {
        field(10; "Connector Code"; Code[20])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(100; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(110; "Is Active"; Boolean)
        {
            Caption = 'Is Active';
        }
        field(1000; "Activation Codeunit ID"; Integer)
        {
            Caption = 'Activation Codeunit ID';
            //TableRelation = Object.ID where(Type = const(Codeunit));
            TableRelation = AllObjWithCaption."Object ID" where("object Type" = const(Codeunit));
        }
        field(2000; "Dealer ID"; Code[20])
        {
            Caption = 'Dealer ID';
        }
        field(2010; "Vendor ID"; Code[20])
        {
            Caption = 'Vendor ID';
            DataClassification = ToBeClassified;
        }
        field(2020; "Make ID"; Code[20])
        {
            Caption = 'Make ID';
            DataClassification = ToBeClassified;
        }
        field(2030; "Customer ID"; Code[20])
        {
            Caption = 'Customer ID';
            DataClassification = ToBeClassified;
        }
        field(3000; "Connection Address"; Text[100])
        {
            Caption = 'Connection Address';
            DataClassification = ToBeClassified;
        }
        field(3010; "User ID"; Text[50])
        {
            Caption = 'User ID';
            DataClassification = ToBeClassified;
        }
        field(3020; Password; Text[50])
        {
            Caption = 'Password';
            DataClassification = ToBeClassified;
            ExtendedDatatype = Masked;
        }
        field(4000; "WMQ Hostname"; Text[100])
        {
            Caption = 'Hostname';
            DataClassification = ToBeClassified;
        }
        field(4010; "WMQ Port"; Integer)
        {
            Caption = 'Port';
            DataClassification = ToBeClassified;
        }
        field(4020; "WMQ Channel"; Text[30])
        {
            Caption = 'Channel';
            DataClassification = ToBeClassified;
        }
        field(4030; "WMQ Manager"; Text[30])
        {
            Caption = 'Queue Manager';
            DataClassification = ToBeClassified;
        }
        field(4100; "WMQ Allow Send/Receive"; Boolean)
        {
            Caption = 'Allow Handle External Queue';
            DataClassification = ToBeClassified;
        }
        field(5000; "MAX Queue To Send"; Integer)
        {
            Caption = 'MAX Queue To Send';
            DataClassification = ToBeClassified;
            MinValue = 0;
        }
        field(5010; "MAX Queue To Receive"; Integer)
        {
            Caption = 'MAX Queue To Receive';
            DataClassification = ToBeClassified;
            MinValue = 0;
        }
        field(5100; "Allow Reset Errors On Send"; Boolean)
        {
            Caption = 'Allow Reset Errors On Send';
            DataClassification = ToBeClassified;
        }
        field(5110; "Allow Reset Errors On Receive"; Boolean)
        {
            Caption = 'Allow Reset Errors On Receive';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Connector Code")
        {
            Clustered = true;
        }
        key(Key2; Description)
        {
        }
    }

    fieldgroups
    {
        fieldgroup(DropDown; "Connector Code", Description)
        {
        }
    }

    trigger OnDelete()
    begin
        if not IsAllowedModification then
            Error(NotAllowedModificationErr);
    end;

    trigger OnModify()
    begin
        if not IsAllowedModification then
            Error(NotAllowedModificationErr);
    end;

    var
        NotAllowedModificationErr: label 'Connector modification or deleting is not allowed.';


    procedure ActivateConnector()
    begin
        TestField("Is Active", false);
        TestField("Activation Codeunit ID");

        if not Codeunit.Run("Activation Codeunit ID", Rec) then
            Error(GetLastErrorText);

        "Is Active" := true;
        Modify;
    end;


    procedure DeactivateConnector()
    begin
        TestField("Is Active", true);
        "Is Active" := false;
        Modify;
    end;


    procedure IsAllowedModification(): Boolean
    begin
        exit(not "Is Active");
    end;
}

