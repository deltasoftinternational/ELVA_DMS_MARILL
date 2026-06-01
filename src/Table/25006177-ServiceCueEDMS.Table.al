Table 25006177 "Service Cue EDMS"
{
    Caption = 'Service Cue';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Service Orders - In Process"; Integer)
        {
            CalcFormula = count("Service Header EDMS" where("Document Type" = filter(Order),
                                                             "Work Status (System)" = filter("In Process")));
            Caption = 'Service Orders - in Process';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3; "Service Orders - Finished"; Integer)
        {
            CalcFormula = count("Service Header EDMS" where("Document Type" = filter(Order),
                                                             "Work Status (System)" = filter(Finished)));
            Caption = 'Service Orders - Finished';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "Service Orders - Inactive"; Integer)
        {
            CalcFormula = count("Service Header EDMS" where("Document Type" = filter(Order),
                                                             "Work Status (System)" = filter(Pending | "On Hold" | " ")));
            Caption = 'Service Orders - Inactive';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Open Service Quotes"; Integer)
        {
            CalcFormula = count("Service Header EDMS" where("Document Type" = const(Quote),
                                                             Status = const(Open)));
            Caption = 'Open Service Quotes';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Service Orders - Today"; Integer)
        {
            CalcFormula = count("Service Header EDMS" where("Document Type" = filter(Order),
                                                             "Planned Service Date" = field("Date Filter")));
            Caption = 'Service Orders - Today';
            Editable = false;
            FieldClass = FlowField;
        }
        field(9; "Service Orders - to Follow-up"; Integer)
        {
            CalcFormula = count("Service Header EDMS" where("Document Type" = filter(Order),
                                                             Status = filter(Open)));
            Caption = 'Service Orders - to Follow-up';
            Editable = false;
            FieldClass = FlowField;
        }
        field(10; "My Tasks EC"; Integer)
        {
            Caption = 'My Tasks';
            Editable = false;
        }
        field(20; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(30; "My Group Tasks EC"; Integer)
        {
            Caption = 'My Group Tasks';
            Editable = false;
        }
        field(40; "My Orders EC"; Integer)
        {
            CalcFormula = count("Service Header EDMS" where("Document Type" = const(Order)));
            Caption = 'My Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(100; "Service Orders - Unplanned"; Integer)
        {
            CalcFormula = count("Service Header EDMS" where("Document Type" = filter(Order),
                                                             "Work Status (System)" = filter(" ")));
            Caption = 'Service Orders - Unplanned';
            Editable = false;
            FieldClass = FlowField;
        }
        field(110; "Service Orders - Planned"; Integer)
        {
            CalcFormula = count("Service Header EDMS" where("Document Type" = filter(Order),
                                                             "Work Status (System)" = filter(Pending)));
            Caption = 'Service Orders - Planned';
            Editable = false;
            FieldClass = FlowField;
        }
        field(120; "Service Orders - OnHold"; Integer)
        {
            CalcFormula = count("Service Header EDMS" where("Document Type" = filter(Order),
                                                             "Work Status (System)" = filter("On Hold")));
            Caption = 'Service Orders - OnHold';
            Editable = false;
            FieldClass = FlowField;
        }
        field(130; "Service Return Orders"; Integer)
        {
            CalcFormula = count("Service Header EDMS" where("Document Type" = filter("Return Order")));
            Caption = 'Service Return Orders';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Primary Key")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

