Table 25006395 "Vehicle Sales Cue"
{
    Caption = 'Vehicle Sales Cue';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Sales Quotes - Open"; Integer)
        {
            CalcFormula = count("Sales Header" where("Document Type" = filter(Quote),
                                                      Status = filter(Open),
                                                      "Document Profile" = const("Vehicles Trade")));
            Caption = 'Sales Quotes - Open';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3; "Sales Orders - Open"; Integer)
        {
            CalcFormula = count("Sales Header" where("Document Type" = filter(Order),
                                                      Status = filter(Open),
                                                      "Document Profile" = const("Vehicles Trade")));
            Caption = 'Sales Orders - Open';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "Ready to Ship"; Integer)
        {
            CalcFormula = count("Sales Header" where("Document Type" = filter(Order),
                                                      Status = filter(Released),
                                                      Ship = filter(false),
                                                      "Shipment Date" = field("Date Filter2"),
                                                      "Document Profile" = const("Vehicles Trade")));
            Caption = 'Ready to Ship';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; Delayed; Integer)
        {
            CalcFormula = count("Sales Header" where("Document Type" = filter(Order),
                                                      Status = filter(Released),
                                                      "Shipment Date" = field("Date Filter"),
                                                      "Document Profile" = const("Vehicles Trade")));
            Caption = 'Delayed';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Sales Return Orders - All"; Integer)
        {
            CalcFormula = count("Sales Header" where("Document Type" = filter("Return Order"),
                                                      Status = filter(Open),
                                                      "Document Profile" = const("Vehicles Trade")));
            Caption = 'Sales Return Orders - All';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Sales Credit Memos - All"; Integer)
        {
            CalcFormula = count("Sales Header" where("Document Type" = filter("Credit Memo"),
                                                      Status = filter(Open),
                                                      "Document Profile" = const("Vehicles Trade")));
            Caption = 'Sales Credit Memos - All';
            Editable = false;
            FieldClass = FlowField;
        }
        field(8; "Partially Shipped"; Integer)
        {
            CalcFormula = count("Sales Header" where("Document Type" = filter(Order),
                                                      Status = filter(Released),
                                                      Ship = filter(true),
                                                      "Completely Shipped" = filter(false),
                                                      "Shipment Date" = field("Date Filter2"),
                                                      "Document Profile" = const("Vehicles Trade")));
            Caption = 'Partially Shipped';
            Editable = false;
            FieldClass = FlowField;
        }
        field(20; "Date Filter"; Date)
        {
            Caption = 'Date Filter';
            Editable = false;
            FieldClass = FlowFilter;
        }
        field(21; "Date Filter2"; Date)
        {
            Caption = 'Date Filter2';
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

