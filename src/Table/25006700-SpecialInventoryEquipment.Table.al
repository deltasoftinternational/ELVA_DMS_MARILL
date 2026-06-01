/*
Table 25006700 "Special Inventory Equipment"
{
    Caption = 'Special Inventory Equipment';
    LookupPageID = "Special Invt. Equipment List";

    fields
    {
        field(10; "No."; Code[10])
        {
            Caption = 'No.';
        }
        field(20; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(30; Vendor; Text[100])
        {
            Caption = 'Vendor';
        }
        field(40; Active; Boolean)
        {
            Caption = 'Active';
        }
        field(50; "Control Unit"; Integer)
        {
            Caption = 'Control Unit';
            // TableRelation = Object.ID where(Type = const(Codeunit));
            TableRelation = AllObjWithCaption."Object ID" where("object type" = const(Codeunit));
            trigger OnValidate()
            var
                // obj: Record "Object";
                obj: Record AllObjWithCaption;
            begin
                //obj.Get(obj.Type::Codeunit, '', "Control Unit");
                obj.Get(obj."object type"::Codeunit, '', "Control Unit");
                "Control Unit Name" := obj."Object name";
            end;
        }
        field(55; "Control Unit Name"; Text[30])
        {
            Caption = 'Control Unit Name';
            Editable = false;
        }
        field(60; "DSN Name"; Text[20])
        {
            Caption = 'DSN Name';
        }
        field(70; "Last Tran Date"; Date)
        {
            Caption = 'Last Tran Date';
        }
        field(80; "Last Tran Time"; Time)
        {
            Caption = 'Last Tran Time';
        }
        field(90; "Posting Unit"; Integer)
        {
            Caption = 'Posting Unit';
            // TableRelation = Object.ID where(Type = const(Codeunit));
            TableRelation = AllObjWithCaption."Object ID" where("object Type" = const(Codeunit));
        }
        field(100; "Mand.1 Field"; Integer)
        {
            Caption = 'Mandatory Field 1';
        }
        field(110; "Mand.2 Field"; Integer)
        {
            Caption = 'Mandatory Field 2';
        }
        field(120; "Mand.3 Field"; Integer)
        {
            Caption = 'Mandatory Field 3';
        }
        field(130; "Mand.4 Field"; Integer)
        {
            Caption = 'Mandatory Field 4';
        }
        field(140; "Mand.5 Field"; Integer)
        {
            Caption = 'Mandatory Field 5';
        }
        field(150; SystemCode; Option)
        {
            Caption = 'System Code';
            OptionCaption = ' ,SAMOA';
            OptionMembers = " ",SAMOA;
        }
        field(160; "Check 1"; Boolean)
        {
            Caption = 'Check 1';

            trigger OnValidate()
            var
                UserSetup: Record "User Setup";
            begin
                if "Check 1" <> xRec."Check 1" then begin
                    UserSetup.Get(UserId);
                    if not UserSetup."SIE management" then
                        Error(Text001)
                end
            end;
        }
        field(170; "Check 1 Show Reminder"; Option)
        {
            Caption = 'Show Reminder';
            OptionCaption = 'Never,Checked,Unchecked';
            OptionMembers = Never,Checked,Unchecked;
        }
        field(180; "Check 1 Reminder Msg"; Text[150])
        {
            Caption = 'Check 1 Reminder Message';
        }
        field(300; "Auto Asignment Unit"; Integer)
        {
            Caption = 'Auto Asignment Unit';
            // TableRelation = Object.ID where(Type = const(Codeunit));
            TableRelation = AllObjWithCaption."Object ID" where("object Type" = const(Codeunit));
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    var
        Text001: label 'You have no rights to change this field.';
}
*/