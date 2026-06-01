Table 25006281 "Schedule Color Config."
{
    Caption = 'Schedule Color Config.';

    fields
    {
        field(10; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionCaption = ',Service Document,Standard Event,Rent';
            OptionMembers = ,"Service Document","Standard Event",Rent;
        }
        field(20; "Source Subtype"; Option)
        {
            Caption = 'Source Subtype';
            OptionCaption = 'Quote,Order,Posted Order,Return Order,Posted Return Order,Service';
            OptionMembers = Quote,"Order","Posted Order","Return Order","Posted Return Order",Service;
        }
        field(30; "Work Status"; Code[20])
        {
            Caption = 'Work Status';
            TableRelation = "Service Work Status EDMS";
        }
        field(40; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Pending,In Progress,Finished,On Hold';
            OptionMembers = Pending,"In Progress",Finished,"On Hold";
        }
        field(50; "Font Color"; Integer)
        {
            Caption = 'Font Color';
        }
        field(60; "Font Bold"; Boolean)
        {
            Caption = 'Font Bold';
        }
        field(70; "Active Allocation"; Boolean)
        {
            Caption = 'Active Allocation';
        }
        field(80; "Mixed Allocation"; Boolean)
        {
            Caption = 'Mixed Allocation';
        }
        field(90; "Background Color"; Integer)
        {
            Caption = 'Background Color';
            Description = 'For RTC only';
        }
        field(100; "Allocation Delay Color"; Integer)
        {
            Caption = 'Allocation Delay Color';
        }
        field(110; "Rent Order Subtype"; Option)
        {
            Caption = 'Rent Order Subtype';
            DataClassification = ToBeClassified;
            OptionMembers = Planned,Shipped,Received;
        }
    }

    keys
    {
        key(Key1; "Source Type", "Source Subtype", "Work Status", Status, "Active Allocation", "Mixed Allocation")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

