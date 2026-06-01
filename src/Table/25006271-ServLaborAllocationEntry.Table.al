Table 25006271 "Serv. Labor Allocation Entry"
{
    // 14.03.2014 Elva Baltic P8 #S0003 MMG7.00
    //   * Fix: Details Entry No. should be copied into related allocations
    // 
    // 03.01.2008. EDMS P2
    //   * Added new field "Applies-to Entry No"

    Caption = 'Serv. Labor Allocation Entry';
    DrillDownPageID = "Serv. Labor Allocation Entries";
    LookupPageID = "Serv. Labor Allocation Entries";

    fields
    {
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(20; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionCaption = ' ,Service Document,Standard Event';
            OptionMembers = ,"Service Document","Standard Event";
        }
        field(30; "Source Subtype"; Option)
        {
            Caption = 'Source Subtype';
            OptionCaption = 'Quote,Order,Return Order,Booking';
            OptionMembers = Quote,"Order","Return Order",Booking;
        }
        field(40; "Source ID"; Code[20])
        {
            Caption = 'Source ID';
            TableRelation = if ("Source Type" = const("Service Document")) "Service Header EDMS"."No." where("Document Type" = field("Source Subtype"))
            else
            if ("Source Type" = const("Standard Event")) "Serv. Standard Event".Code;
            //This property is currently not supported
            //TestTableRelation = false;
        }
        field(70; "Start Date-Time"; Decimal)
        {
            AutoFormatExpression = 'DATETIME';
            AutoFormatType = 10;
            Caption = 'Start Date-Time';
        }
        field(71; "End Date-Time"; Decimal)
        {
            AutoFormatExpression = 'DATETIME';
            AutoFormatType = 10;
            Caption = 'End Date-Time';
        }
        field(100; "Quantity (Hours)"; Decimal)
        {
            Caption = 'Quantity (Hours)';
            DecimalPlaces = 0 : 5;
        }
        field(110; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            TableRelation = Resource;
        }
        field(140; "User ID"; Code[50])
        {
            Caption = 'User ID';

            trigger OnLookup()
            var
                LoginMgt: Codeunit UserProfileManagement;
            begin
                LoginMgt.LookupUserID("User ID");
            end;
        }
        field(150; "Applies-to Entry No."; Integer)
        {
            Caption = 'Applies-to Entry No.';

            trigger OnValidate()
            begin
                //14.03.2014 Elva Baltic P8 #S0003 MMG7.00 >>
                if "Applies-to Entry No." <> xRec."Applies-to Entry No." then
                    if LaborAllocEntry.Get("Applies-to Entry No.") then
                        Validate("Detail Entry No.", LaborAllocEntry."Detail Entry No.");
                //14.03.2014 Elva Baltic P8 #S0003 MMG7.00 <<
            end;
        }
        field(160; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = 'Pending,In Progress,Finished,On Hold';
            OptionMembers = Pending,"In Progress",Finished,"On Hold";
        }
        field(170; "Reason Code"; Code[10])
        {
            Caption = 'Reason Code';
            TableRelation = "Serv. Break Reason";
        }
        field(180; "Planning Policy"; Option)
        {
            Caption = 'Planning Policy';
            OptionCaption = 'Appointment,Queue';
            OptionMembers = Appointment,Queue;
        }
        field(210; "Parent Alloc. Entry No."; Integer)
        {
            Caption = 'Parent Alloc. Entry No.';
            Description = 'means is related to other entry';
            TableRelation = "Serv. Labor Allocation Entry";
        }
        field(220; "Parent Link Synchronize"; Boolean)
        {
            Caption = 'Parent Link Synchronize';
            Description = 'means it should hold begin and length same';
        }
        field(230; "Detail Entry No."; Integer)
        {
            TableRelation = "Serv. Allocation Description";

            trigger OnValidate()
            begin
                //14.03.2014 Elva Baltic P8 #S0003 MMG7.00 >>
                if xRec."Detail Entry No." <> "Detail Entry No." then begin
                    LaborAllocEntry.Reset;
                    LaborAllocEntry.SetRange("Applies-to Entry No.", "Entry No.");
                    if LaborAllocEntry.FindFirst then
                        repeat
                            if LaborAllocEntry."Detail Entry No." <> "Detail Entry No." then begin
                                LaborAllocEntry.Validate("Detail Entry No.", "Detail Entry No.");
                                LaborAllocEntry.Modify;
                            end;
                        until LaborAllocEntry.Next = 0;
                end;
                //14.03.2014 Elva Baltic P8 #S0003 MMG7.00 <<
            end;
        }
        field(400; "Allocation Status"; Option)
        {
            Caption = 'Allocation Status';
            Description = 'System';
            OptionCaption = 'Allocation,Unavailability';
            OptionMembers = Allocation,Unavailability;
        }
        field(410; "Resource Group Code"; Code[10])
        {
            TableRelation = "Schedule Resource Group";
        }
        field(420; "Total Time Spent"; Decimal)
        {
            CalcFormula = sum("Resource Time Reg. Entry"."Time Spent" where("Allocation Entry No." = field("Entry No."),
                                                                             Canceled = const(false),
                                                                             Travel = const(false)));
            FieldClass = FlowField;
        }
        field(430; "Application Entry Count"; Integer)
        {
            CalcFormula = count("Serv. Labor Alloc. Application" where("Allocation Entry No." = field("Entry No.")));
            FieldClass = FlowField;
        }
        field(440; "Total Cost Amount"; Decimal)
        {
            CalcFormula = sum("Serv. Labor Alloc. Application"."Cost Amount" where("Allocation Entry No." = field("Entry No.")));
            FieldClass = FlowField;
        }
        field(450; "Last Clocked"; Date)
        {
            CalcFormula = max("Resource Time Reg. Entry".Date where("Entry Type" = filter(Finished | "On Hold"),
                                                                     "Allocation Entry No." = field("Entry No.")));
            FieldClass = FlowField;
        }
        field(460; Travel; Boolean)
        {
        }
        field(470; "Total Time Spent Travel"; Decimal)
        {
            CalcFormula = sum("Resource Time Reg. Entry"."Time Spent" where("Allocation Entry No." = field("Entry No."),
                                                                             Canceled = const(false),
                                                                             Travel = const(true)));
            FieldClass = FlowField;
        }
        field(471; "Planned Start Date-Time"; Decimal)
        {
            Caption = 'Planned Start Date-Time';
            DataClassification = ToBeClassified;
        }
        field(472; "Planned End Date-Time"; Decimal)
        {
            Caption = 'Planned End Date-Time';
            DataClassification = ToBeClassified;
        }
        field(473; "Planned Duration (Hours)"; Decimal)
        {
            Caption = 'Planned Duration (Hours)';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Resource No.")
        {
        }
        key(Key3; "Resource No.", "Start Date-Time", "End Date-Time")
        {
            SumIndexFields = "Quantity (Hours)";
        }
        key(Key4; "Resource No.", "End Date-Time")
        {
        }
        key(Key5; "Source Type", Status, "Resource No.")
        {
        }
        key(Key6; "Applies-to Entry No.")
        {
        }
        key(Key7; "Source Type", "Source Subtype", "Source ID")
        {
        }
        key(Key8; "Source Type", "Source Subtype", "Source ID", "Start Date-Time")
        {
        }
        key(Key9; "Parent Alloc. Entry No.")
        {
        }
        key(Key10; "Detail Entry No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    var
        ServiceOrderAllocation: Record "Serv. Labor Alloc. Application";
    begin
        ServLaborAllocApplication.Reset;
        ServLaborAllocApplication.SetRange("Allocation Entry No.", "Entry No.");
        ServLaborAllocApplication.DeleteAll;

        ResourceTimeRegEntry.Reset;
        ResourceTimeRegEntry.SetRange("Allocation Entry No.", "Entry No.");
        ResourceTimeRegEntry.DeleteAll;
    end;

    trigger OnInsert()
    var
        recServResAlloc: Record "Serv. Labor Allocation Entry";
    begin
    end;

    var
        ServLaborAllocApplication: Record "Serv. Labor Alloc. Application";
        LaborAllocEntry: Record "Serv. Labor Allocation Entry";
        ResourceTimeRegEntry: Record "Resource Time Reg. Entry";


    procedure GetLookupDetailsText(): Text[250]
    var
        ServLaborAllocationDetailLoc: Record "Serv. Allocation Description";
    begin
        if ServLaborAllocationDetailLoc.Get("Detail Entry No.") then;
        if Page.RunModal(0, ServLaborAllocationDetailLoc) = Action::LookupOK then begin
            Validate("Detail Entry No.", ServLaborAllocationDetailLoc."Entry No.");
            exit(ServLaborAllocationDetailLoc.Description);
        end;
        exit('');
    end;
}

