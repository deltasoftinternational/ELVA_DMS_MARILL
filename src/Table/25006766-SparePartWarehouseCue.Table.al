Table 25006766 "Spare Part Warehouse Cue"
{
    Caption = 'Warehouse Basic Cue';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
        }
        field(2; "Released Sales Orders - Today"; Integer)
        {
            CalcFormula = count("Sales Header" where("Document Type" = filter(Order),
                                                      Status = filter(Released),
                                                      "Shipment Date" = field("Date Filter"),
                                                      "Location Code" = field("Location Filter"),
                                                      "Document Profile" = const("Spare Parts Trade")));
            Caption = 'Released Sales Orders - Today';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3; "Posted Sales Shipments - Today"; Integer)
        {
            CalcFormula = count("Sales Shipment Header" where("Posting Date" = field("Date Filter2"),
                                                               "Location Code" = field("Location Filter"),
                                                               "Document Profile" = const("Spare Parts Trade")));
            Caption = 'Posted Sales Shipments - Today';
            Editable = false;
            FieldClass = FlowField;
        }
        field(4; "Expected Purch. Orders - Today"; Integer)
        {
            CalcFormula = count("Purchase Header" where("Document Type" = filter(Order),
                                                         Status = filter(Released),
                                                         "Expected Receipt Date" = field("Date Filter"),
                                                         "Location Code" = field("Location Filter"),
                                                         "Document Profile" = const("Spare Parts Trade")));
            Caption = 'Expected Purchase Orders - Today';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Posted Purch. Receipts - Today"; Integer)
        {
            CalcFormula = count("Purch. Rcpt. Header" where("Posting Date" = field("Date Filter2"),
                                                             "Location Code" = field("Location Filter"),
                                                             "Document Profile" = const("Spare Parts Trade")));
            Caption = 'Posted Purchase Receipts - Today';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Inventory Picks - Today"; Integer)
        {
            CalcFormula = count("Warehouse Activity Header" where(Type = filter("Invt. Pick"),
                                                                   "Shipment Date" = field("Date Filter"),
                                                                   "Location Code" = field("Location Filter")));
            Caption = 'Inventory Picks - Today';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Inventory Put-aways - Today"; Integer)
        {
            CalcFormula = count("Warehouse Activity Header" where(Type = filter("Invt. Put-away"),
                                                                   "Shipment Date" = field("Date Filter"),
                                                                   "Location Code" = field("Location Filter")));
            Caption = 'Inventory Put-aways - Today';
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
        field(22; "Location Filter"; Code[10])
        {
            Caption = 'Location Filter';
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

