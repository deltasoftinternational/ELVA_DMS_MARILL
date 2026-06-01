Table 25006765 "Spare Parts Purchase Cue"
{
    Caption = 'Spare Parts Purchase Cue';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "To Send or Confirm"; Integer)
        {
            CalcFormula = count("Purchase Header" where("Document Type" = filter(Order),
                                                         Status = filter(Open),
                                                         "Document Profile" = const("Spare Parts Trade")));
            Caption = 'To Send or Confirm';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3; "Upcoming Orders"; Integer)
        {
            CalcFormula = count("Purchase Header" where("Document Type" = filter(Order),
                                                         Status = filter(Released),
                                                         "Expected Receipt Date" = field("Date Filter"),
                                                         "Document Profile" = const("Spare Parts Trade")));
            Caption = 'Upcoming Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "Outstanding Purchase Orders"; Integer)
        {
            CalcFormula = count("Purchase Header" where("Document Type" = filter(Order),
                                                         Status = filter(Released),
                                                         Receive = filter(true),
                                                         "Completely Received" = filter(false),
                                                         "Document Profile" = const("Spare Parts Trade")));
            Caption = 'Outstanding Purchase Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Purchase Return Orders - All"; Integer)
        {
            CalcFormula = count("Purchase Header" where("Document Type" = filter("Return Order"),
                                                         "Document Profile" = const("Spare Parts Trade")));
            Caption = 'Purchase Return Orders - All';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Not Invoiced"; Integer)
        {
            CalcFormula = count("Purchase Header" where("Document Type" = filter(Order),
                                                         "Completely Received" = filter(true),
                                                         Invoice = filter(false),
                                                         "Document Profile" = const("Spare Parts Trade")));
            Caption = 'Not Invoiced';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Partially Invoiced"; Integer)
        {
            CalcFormula = count("Purchase Header" where("Document Type" = filter(Order),
                                                         "Completely Received" = filter(true),
                                                         Invoice = filter(true),
                                                         "Document Profile" = const("Spare Parts Trade")));
            Caption = 'Partially Invoiced';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            Editable = false;
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

