Table 25006290 "Resource Time Reg. Entry"
{
    DrillDownPageID = "Resource Time Reg. Entries";
    LookupPageID = "Resource Time Reg. Entries";

    fields
    {
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(20; "Allocation Entry No."; Integer)
        {
            Caption = 'Allocation Entry No.';
            TableRelation = "Serv. Labor Allocation Entry";
        }
        field(30; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            NotBlank = true;
            TableRelation = Resource;

            trigger OnValidate()
            var
                Resource: Record Resource;
            begin
            end;
        }
        field(40; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionMembers = Pending,"In Progress",Finished,"On Hold";
        }
        field(60; "Time Spent"; Decimal)
        {
            Caption = 'Time Spent';
        }
        field(70; Date; Date)
        {
            Caption = 'Date';

            trigger OnValidate()
            var
                ResourceTimeRegEntryPrev: Record "Resource Time Reg. Entry";
                ActualWorkSpentTime: Decimal;
            begin
                ResourceTimeRegEntryPrev.Reset;
                ResourceTimeRegEntryPrev.SetRange("Allocation Entry No.", "Allocation Entry No.");
                ResourceTimeRegEntryPrev.SetRange("Entry Type", ResourceTimeRegEntryPrev."entry type"::"In Progress");
                ResourceTimeRegEntryPrev.SetFilter("Entry No.", '<%1', Rec."Entry No.");
                ResourceTimeRegEntryPrev.SetRange(Canceled, false);

                if ResourceTimeRegEntryPrev.FindLast and ("Entry Type" <> "entry type"::"In Progress") then begin
                    ActualWorkSpentTime := CreateDatetime(Date, Time) - CreateDatetime(ResourceTimeRegEntryPrev.Date, ResourceTimeRegEntryPrev.Time);
                    ActualWorkSpentTime := ROUND(ActualWorkSpentTime / 3600000, 0.0001);
                end;

                "Time Spent" := ActualWorkSpentTime;
            end;
        }
        field(80; Time; Time)
        {
            Caption = 'Time';

            trigger OnValidate()
            var
                ResourceTimeRegEntryPrev: Record "Resource Time Reg. Entry";
                ActualWorkSpentTime: Decimal;
            begin
                ResourceTimeRegEntryPrev.Reset;
                ResourceTimeRegEntryPrev.SetRange("Allocation Entry No.", "Allocation Entry No.");
                ResourceTimeRegEntryPrev.SetRange("Entry Type", ResourceTimeRegEntryPrev."entry type"::"In Progress");
                ResourceTimeRegEntryPrev.SetFilter("Entry No.", '<%1', Rec."Entry No.");
                ResourceTimeRegEntryPrev.SetRange(Canceled, false);

                if ResourceTimeRegEntryPrev.FindLast and ("Entry Type" <> "entry type"::"In Progress") then begin
                    ActualWorkSpentTime := CreateDatetime(Date, Time) - CreateDatetime(ResourceTimeRegEntryPrev.Date, ResourceTimeRegEntryPrev.Time);
                    ActualWorkSpentTime := ROUND(ActualWorkSpentTime / 3600000, 0.0001);
                end;

                "Time Spent" := ActualWorkSpentTime;
            end;
        }
        field(100; Canceled; Boolean)
        {
            Caption = 'Canceled';
        }
        field(110; "Worktime Entry"; Boolean)
        {
            Caption = 'Worktime Entry';
        }
        field(120; "Resource Name"; Text[100])
        {
            CalcFormula = lookup(Resource.Name where("No." = field("Resource No.")));
            Caption = 'Resource Name';
            FieldClass = FlowField;
        }
        field(130; "Start Entry Date"; Date)
        {
            Caption = 'Start Entry Date';
        }
        field(140; Idle; Boolean)
        {
            Caption = 'Idle';
        }
        field(150; Travel; Boolean)
        {
            Caption = 'Travel';
        }
        field(160; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionCaption = ' ,Service Document,Standard Event';
            OptionMembers = ,"Service Document","Standard Event";
        }
        field(170; "Source Subtype"; Option)
        {
            Caption = 'Source Subtype';
            OptionCaption = 'Quote,Order,Return Order,Booking';
            OptionMembers = Quote,"Order","Return Order",Booking;
        }
        field(180; "Source ID"; Code[20])
        {
            Caption = 'Source ID';
            TableRelation = if ("Source Type" = const("Service Document")) "Service Header EDMS"."No." where("Document Type" = field("Source Subtype"))
            else
            if ("Source Type" = const("Standard Event")) "Serv. Standard Event".Code;
            //This property is currently not supported
            //TestTableRelation = false;
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

    trigger OnInsert()
    var
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
    begin
        if ServLaborAllocationEntry.Get("Allocation Entry No.") then begin
            "Source Type" := ServLaborAllocationEntry."Source Type";
            "Source Subtype" := ServLaborAllocationEntry."Source Subtype";
            "Source ID" := ServLaborAllocationEntry."Source ID";
        end;
    end;
}

