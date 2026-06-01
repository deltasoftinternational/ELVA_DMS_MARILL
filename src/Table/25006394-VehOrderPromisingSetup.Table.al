Table 25006394 "Veh. Order Promising Setup"
{
    Caption = 'Veh. Order Promising Setup';

    fields
    {
        field(1; "Primary Key"; Code[10])
        {
            Caption = 'Primary Key';
            Editable = false;
        }
        field(2; "Offset (Time)"; DateFormula)
        {
            Caption = 'Offset (Time)';
        }
        field(8; "Order Promising Nos."; Code[10])
        {
            Caption = 'Order Promising Nos.';
            TableRelation = "No. Series";
        }
        field(9; "Order Promising Template"; Code[10])
        {
            Caption = 'Order Promising Template';
            TableRelation = "Req. Wksh. Template";
        }
        field(10; "Order Promising Worksheet"; Code[10])
        {
            Caption = 'Order Promising Worksheet';
            TableRelation = "Requisition Wksh. Name".Name where("Worksheet Template Name" = field("Order Promising Template"));
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

