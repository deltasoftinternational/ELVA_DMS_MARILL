Table 25006396 "Vehicle Purchase Cue"
{
    Caption = 'Vehicle Purchase Cue';

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
                                                         "Document Profile" = const("Vehicles Trade"), //DELTA HT
                                                         "Responsibility Center" = field("Resp. Center Filter"))); //DELTA HT
            Caption = 'To Send or Confirm';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3; "Upcoming Orders"; Integer)
        {
            CalcFormula = count("Purchase Header" where("Document Type" = filter(Order),
                                                         Status = filter(Released),
                                                         "Expected Receipt Date" = field("Date Filter"),
                                                         "Document Profile" = const("Vehicles Trade"), //DELTA HT
                                                         "Responsibility Center" = field("Resp. Center Filter"))); //DELTA HT
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
                                                          "Document Profile" = const("Vehicles Trade"), //DELTA HT
                                                         "Responsibility Center" = field("Resp. Center Filter"))); //DELTA HT
            Caption = 'Outstanding Purchase Orders';
            Editable = false;
            FieldClass = FlowField;
        }
        field(5; "Purchase Return Orders - All"; Integer)
        {
            CalcFormula = count("Purchase Header" where("Document Type" = filter("Return Order"),
                                                         "Document Profile" = const("Vehicles Trade"), //DELTA HT
                                                         "Responsibility Center" = field("Resp. Center Filter"))); //DELTA HT
            Caption = 'Purchase Return Orders - All';
            Editable = false;
            FieldClass = FlowField;
        }
        field(6; "Not Invoiced"; Integer)
        {
            CalcFormula = count("Purchase Header" where("Document Type" = filter(Order),
                                                         "Completely Received" = filter(true),
                                                         Invoice = filter(false),
                                                         "Document Profile" = const("Vehicles Trade"), //DELTA HT
                                                         "Responsibility Center" = field("Resp. Center Filter"))); //DELTA HT
            Caption = 'Not Invoiced';
            Editable = false;
            FieldClass = FlowField;
        }
        field(7; "Partially Invoiced"; Integer)
        {
            CalcFormula = count("Purchase Header" where("Document Type" = filter(Order),
                                                         "Completely Received" = filter(true),
                                                         Invoice = filter(true),
                                                         "Document Profile" = const("Vehicles Trade"), //DELTA HT
                                                         "Responsibility Center" = field("Resp. Center Filter"))); //DELTA HT
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
        field(100; "Resp. Center Filter"; Code[10])  //ADD HT DELTASOFT  
        {

            Caption = 'Responsibility Center Filter';
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

