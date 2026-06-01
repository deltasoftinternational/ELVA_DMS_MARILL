Table 25006187 "Det. Serv. Journal Line"
{
    // 28.05.2015 EB.P30 #T030
    //   Added field:
    //     "Cost Amount"
    // 
    // 12.05.2015 EB.P30 #T030
    //   Added field:
    //     "Unit Cost"

    Caption = 'Det. Serv. Journal Line';

    fields
    {
        field(10; "Journal Template Name"; Code[10])
        {
            Caption = 'Journal Template Name';
            TableRelation = "Serv. Journal Template";
        }
        field(20; "Journal Batch Name"; Code[10])
        {
            Caption = 'Journal Batch Name';
            TableRelation = "Serv. Journal Batch".Name where("Journal Template Name" = field("Journal Template Name"));
        }
        field(30; "Journal Line No."; Integer)
        {
            Caption = 'Journal Line No.';
        }
        field(40; "Line No."; Integer)
        {
            Caption = 'Line No.';
        }
        field(50; "Resource No."; Code[20])
        {
            Caption = 'Resource No.';
            TableRelation = Resource;
        }
        field(60; "Finished Quantity (Hours)"; Decimal)
        {
            Caption = 'Finished Quantity (Hours)';
        }
        field(70; "Unit Cost"; Decimal)
        {
            Caption = 'Unit Cost';
        }
        field(80; "Cost Amount"; Decimal)
        {
        }
        field(90; "Quantity (Hours)"; Decimal)
        {
        }
        field(100; "Finished Qty. (Hours) Travel"; Decimal)
        {
            Caption = 'Finished Quantity (Hours)';
        }
    }

    keys
    {
        key(Key1; "Journal Template Name", "Journal Batch Name", "Journal Line No.", "Line No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

