Table 25006029 "Vehicle Change Log"
{
    // 12.01.2015 EB.P7 #Username length EDMS
    //   User ID Field length changed to Code(50)

    Caption = 'Vehicle Change Log';

    fields
    {
        field(10; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
        }
        field(20; "Change No."; Integer)
        {
            Caption = 'Change No.';
        }
        field(30; "User ID"; Code[50])
        {
            Caption = 'User ID';
        }
        field(40; "Date of Change"; Date)
        {
            Caption = 'Date of Change';
        }
        field(50; "Time of Change"; Time)
        {
            Caption = 'Time of Change';
        }
        field(60; "Field No."; Integer)
        {
            Caption = 'Field No.';
        }
        field(70; "Field Description"; Text[80])
        {
            Caption = 'Field Description';
        }
        field(80; "Old Value"; Text[50])
        {
            Caption = 'Old Value';
        }
        field(90; "New Value"; Text[50])
        {
            Caption = 'New Value';
        }
        field(100; "Type of Change"; Option)
        {
            Caption = 'Type of Change';
            OptionCaption = 'Modify,Insert,Delete';
            OptionMembers = Modify,Insert,Delete;
        }
    }

    keys
    {
        key(Key1; "Vehicle Serial No.", "Change No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

