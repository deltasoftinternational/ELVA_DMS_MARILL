Table 25006953 "Checklist Service Cue"
{
    // 16/08/2018 P30 GH
    //   Added location filter to flowfields:
    //     250 "Veh. Inspections - Pending"
    //     255 "Veh. Inspections - In Progress"
    //     270 "Veh. Inspections - Aw.Confirm"
    // 
    // 28/06/2018 P30 GH
    //   Added fields:
    //     600 "Pending Tasks"
    //     610 "User ID Filter"
    // 
    // 27/03/2018 GP1 P30
    //   Added fields:
    //     241 "VHC - Reminders Overdue"
    //     242 "VHC - Reminders Upcoming"
    //     243 "VHC - Date Filter Rem. Upc."


    fields
    {
        field(10; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(20; "Orders - In Process"; Integer)
        {
            CalcFormula = count("Service Header EDMS" where("Document Type" = filter(Order),
                                                             "Work Status (System)" = filter("In Process"),
                                                             "Location Code" = field("Location Filter")));
            Caption = 'Orders - In Process';
            Editable = false;
            FieldClass = FlowField;
        }
        field(25; "Orders - Pending Today"; Integer)
        {
            CalcFormula = count("Service Header EDMS" where("Document Type" = filter(Order),
                                                             "Work Status (System)" = filter(Pending | " "),
                                                             "Location Code" = field("Location Filter"),
                                                             "Schedule Start Date Time" = field(filter("Allocation Date Filter"))));
            Caption = 'Orders - Pending Today';
            Editable = false;
            FieldClass = FlowField;
        }
        field(26; "Orders - Ready For Collection"; Integer)
        {
            CalcFormula = count("Service Header EDMS" where("Document Type" = filter(Order),
                                                             "Location Code" = field("Location Filter"),
                                                             "Work Status Code" = field("Work Status Filter")));
            Caption = 'Orders - Ready For Collection';
            Editable = false;
            FieldClass = FlowField;
        }
        field(30; "Orders - Finished"; Integer)
        {
            CalcFormula = count("Service Header EDMS" where("Document Type" = filter(Order),
                                                             "Work Status (System)" = filter(Finished),
                                                             "Location Code" = field("Location Filter")));
            Caption = 'Orders - Finished';
            Editable = false;
            FieldClass = FlowField;
        }
        field(40; "Orders - Pending"; Integer)
        {
            CalcFormula = count("Service Header EDMS" where("Document Type" = filter(Order),
                                                             "Work Status (System)" = filter(Pending | " "),
                                                             "Location Code" = field("Location Filter")));
            Caption = 'Orders - Pending';
            Editable = false;
            FieldClass = FlowField;
        }
        field(43; "Orders - On Hold"; Integer)
        {
            CalcFormula = count("Service Header EDMS" where("Document Type" = filter(Order),
                                                             "Work Status (System)" = filter("On Hold"),
                                                             "Location Code" = field("Location Filter")));
            Caption = 'Orders - On Hold';
            FieldClass = FlowField;
        }
        field(45; "Orders -Total"; Integer)
        {
            CalcFormula = count("Service Header EDMS" where("Document Type" = filter(Order),
                                                             "Location Code" = field("Location Filter")));
            FieldClass = FlowField;
        }
        field(50; "Service Quotes"; Integer)
        {
            CalcFormula = count("Service Header EDMS" where("Document Type" = const(Quote),
                                                             Status = const(Open),
                                                             "Location Code" = field("Location Filter")));
            Caption = 'Service Quotes';
            Editable = false;
            FieldClass = FlowField;
        }
        field(60; "Orders - Today"; Integer)
        {
            CalcFormula = count("Service Header EDMS" where("Document Type" = filter(Order),
                                                             "Planned Service Date" = field("Date Filter")));
            Caption = 'Orders - Today';
            Editable = false;
            FieldClass = FlowField;
        }
        field(70; "Orders - to Follow-up"; Integer)
        {
            CalcFormula = count("Service Header" where("Document Type" = filter(Order),
                                                        Status = filter("In Process")));
            Caption = 'Orders - to Follow-up';
            Editable = false;
            FieldClass = FlowField;
        }
        field(80; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(85; "Allocation Date Filter"; Decimal)
        {
            Caption = 'Allocation Date Filter';
            FieldClass = FlowFilter;
        }
        field(90; "My To-do This Week"; Integer)
        {
            CalcFormula = count("To-do" where(Date = field("Date Filter 1"),
                                               "Salesperson Code" = field("Salesperson Code")));
            Caption = 'My To-do This Week';
            Editable = false;
            FieldClass = FlowField;
        }
        field(100; "My To-do Next Week"; Integer)
        {
            CalcFormula = count("To-do" where(Date = field("Date Filter 2"),
                                               "Salesperson Code" = field("Salesperson Code")));
            Caption = 'My To-do Next Week';
            Editable = false;
            FieldClass = FlowField;
        }
        field(110; "Date Filter 1"; Date)
        {
            Caption = 'Date Filter 1';
            FieldClass = FlowFilter;
        }
        field(120; "Date Filter 2"; Date)
        {
            Caption = 'Date Filter 2';
            FieldClass = FlowFilter;
        }
        field(130; "My To-do"; Integer)
        {
            CalcFormula = count("To-do" where("Salesperson Code" = field("Salesperson Code")));
            Caption = 'My To-do';
            Editable = false;
            FieldClass = FlowField;
        }
        field(140; "Salesperson Code"; Code[10])
        {
            Caption = 'Salesperson Code';
            FieldClass = FlowFilter;
        }
        field(150; "Bookings - Today"; Integer)
        {
            CalcFormula = count("Service Header EDMS" where("Document Type" = filter(Booking),
                                                             "Requested Starting Date" = field("Date Filter 3")));
            Caption = 'Bookings - Today';
            FieldClass = FlowField;
        }
        field(160; "Bookings - Tomorrow"; Integer)
        {
            CalcFormula = count("Service Header EDMS" where("Document Type" = filter(Booking),
                                                             "Requested Starting Date" = field("Date Filter 4")));
            Caption = 'Bookings - Tomorrow';
            FieldClass = FlowField;
        }
        field(165; "Bookings - Lost"; Integer)
        {
            CalcFormula = count("Service Header EDMS" where("Document Type" = filter(Booking),
                                                             "Requested Starting Date" = field("Date Filter 5")));
            Caption = 'Bookings - Lost';
            FieldClass = FlowField;
        }
        field(170; "Date Filter 3"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(180; "Date Filter 4"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(190; "Date Filter 5"; Date)
        {
            FieldClass = FlowFilter;
        }
        field(200; "VHC - Awaiting Action"; Integer)
        {
            CalcFormula = count("Service Header EDMS" where("Document Type" = filter(VHC),
                                                             "VHC Status" = const("Awaiting Action"),
                                                             "Location Code" = field("Location Filter")));
            FieldClass = FlowField;
        }
        field(210; "VHC - Awaiting Parts"; Integer)
        {
            CalcFormula = count("Service Header EDMS" where("Document Type" = filter(VHC),
                                                             "VHC Status" = const("Awaiting Parts"),
                                                             "Location Code" = field("Location Filter")));
            FieldClass = FlowField;
        }
        field(220; "VHC - Awaiting Advisor"; Integer)
        {
            CalcFormula = count("Service Header EDMS" where("Document Type" = filter(VHC),
                                                             "VHC Status" = const("Awaiting Advisor"),
                                                             "Location Code" = field("Location Filter")));
            FieldClass = FlowField;
        }
        field(230; "VHC - Awaiting Authorisation"; Integer)
        {
            CalcFormula = count("Service Header EDMS" where("Document Type" = filter(VHC),
                                                             "VHC Status" = const("Awaiting Authorisation"),
                                                             "Location Code" = field("Location Filter")));
            FieldClass = FlowField;
        }
        field(240; "VHC - Completed"; Integer)
        {
            CalcFormula = count("Service Header EDMS" where("Document Type" = filter(VHC),
                                                             "VHC Status" = const(Completed),
                                                             "Location Code" = field("Location Filter")));
            FieldClass = FlowField;
        }
        field(241; "VHC - Reminders Overdue"; Integer)
        {
            /* FIXME
            CalcFormula = count("Service Line EDMS" where ("Document Type"=const("4"),
                                                           "Location Code"=field("Location Filter"),
                                                           "Reminder Date"=field("Date Filter 5"),
                                                           "Customer Authorised"=const(false)));
                                                           */
            Caption = 'VHC - Reminders Overdue';
            FieldClass = FlowField;
        }
        field(242; "VHC - Reminders Upcoming"; Integer)
        {
            /* FIXME
            CalcFormula = count("Service Line EDMS" where ("Document Type"=const("4"),
                                                           "Location Code"=field("Location Filter"),
                                                           "Reminder Date"=field("VHC - Date Filter Rem. Upc."),
                                                           "Customer Authorised"=const(false)));
                                                           */
            Caption = 'VHC - Reminders Upcoming';
            FieldClass = FlowField;
        }
        field(243; "VHC - Date Filter Rem. Upc."; Date)
        {
            FieldClass = FlowFilter;
        }
        field(250; "Veh. Inspections - Pending"; Integer)
        {
            CalcFormula = count("Process Checklist Header" where(Type = const("Vehicle Inspection"),
                                                                  "Process Status" = const(Pending),
                                                                  "Confirmed by Advisor" = const(false),
                                                                  "Location Code" = field("Location Filter")));
            Caption = 'VI - Pending';
            FieldClass = FlowField;
        }
        field(255; "Veh. Inspections - In Progress"; Integer)
        {
            CalcFormula = count("Process Checklist Header" where(Type = const("Vehicle Inspection"),
                                                                  "Process Status" = const("In Progress"),
                                                                  "Confirmed by Advisor" = const(false),
                                                                  "Location Code" = field("Location Filter")));
            Caption = 'VI - In Progress';
            FieldClass = FlowField;
        }
        field(270; "Veh. Inspections - Aw.Confirm"; Integer)
        {
            CalcFormula = count("Process Checklist Header" where(Type = const("Vehicle Inspection"),
                                                                  "Process Status" = const(Completed),
                                                                  "Confirmed by Advisor" = const(false),
                                                                  "Location Code" = field("Location Filter")));
            Caption = 'VI - Awaiting Confirmation';
            FieldClass = FlowField;
        }
        field(300; "My Tasks EC"; Integer)
        {
            Caption = 'My Tasks';
        }
        field(310; "Group Tasks EC"; Integer)
        {
            Caption = 'Group Tasks';
        }
        field(320; "Orders EC"; Integer)
        {
            CalcFormula = count("Service Header EDMS" where("Document Type" = const(Order),
                                                             "Location Code" = field("Location Filter")));
            Caption = 'Service Orders';
            FieldClass = FlowField;
        }
        field(500; "Location Filter"; Code[100])
        {
            Caption = 'Location Filter';
            FieldClass = FlowFilter;
            TableRelation = Location;
        }
        field(600; "Pending Tasks"; Integer)
        {
            CalcFormula = count("User Task" where("Assigned To User Name" = field("User ID Filter"),
                                                   "Percent Complete" = filter(<> 100)));
            Caption = 'Pending Tasks';
            FieldClass = FlowField;
        }
        field(610; "User ID Filter"; Code[50])
        {
            Caption = 'User ID Filter';
            FieldClass = FlowFilter;
        }
        field(620; "Work Status Filter"; Code[10])
        {
            Caption = 'Work Status Filter';
            FieldClass = FlowFilter;
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

