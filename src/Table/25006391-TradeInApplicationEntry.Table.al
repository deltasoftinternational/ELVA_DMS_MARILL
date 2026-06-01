Table 25006391 "Trade-In Application Entry"
{
    // 26.06.2009. EDMS P2
    //   * Changed "Document Type" property OptionString

    Caption = 'Trade-In Application Entry';
    LookupPageID = "Veh.Trade-In App.Entries";

    fields
    {
        field(10; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(20; "Entry Type"; Option)
        {
            Caption = 'Entry Type';
            OptionCaption = 'Purchase,Sale';
            OptionMembers = Purchase,Sale;
        }
        field(30; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(40; "Document Type"; Option)
        {
            Caption = 'Document Type';
            OptionCaption = 'Order,Ret. Order,Invoice,Cr.Memo';
            OptionMembers = "Order","Ret. Order",Invoice,"Cr.Memo";
        }
        field(50; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(60; "Amount (LCY)"; Decimal)
        {
            Caption = 'Amount (LCY)';
        }
        field(70; "Amount (FCY)"; Decimal)
        {
            Caption = 'Amount (FCY)';
        }
        field(80; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            TableRelation = Currency;
        }
        field(90; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            TableRelation = Vehicle;
        }
        field(100; "Vehicle Accounting Cycle No."; Code[20])
        {
            Caption = 'Vehicle Accounting Cycle No.';
            TableRelation = "Vehicle Accounting Cycle" where("Vehicle Serial No." = field("Vehicle Serial No."));
        }
        field(110; "Applies-to Vehicle Serial No."; Code[20])
        {
            Caption = 'Applies-to Vehicle Serial No.';
            TableRelation = Vehicle;
        }
        field(120; "Applies-to Veh. Acc. Cycle No."; Code[20])
        {
            Caption = 'Applies-to Veh. Acc. Cycle No.';
            TableRelation = Vehicle;
        }
        field(25006170; "Vehicle Registration No."; Code[20])
        {
            CalcFormula = lookup(Vehicle."Registration No." where("Serial No." = field("Vehicle Serial No.")));
            Caption = 'Vehicle Registration No.';
            FieldClass = FlowField;

            trigger OnValidate()
            var
                Vehicle: Record Vehicle;
            begin
            end;
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
}

