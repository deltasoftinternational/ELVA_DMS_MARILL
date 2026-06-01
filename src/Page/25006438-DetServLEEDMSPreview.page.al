page 25006438 "Det. Serv. LE. EDMS Preview"
{

    ApplicationArea = All;
    Caption = 'Det. Serv. LE. EDMS Preview';
    PageType = List;
    SourceTable = "Det. Serv. Ledger Entry EDMS";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Cost Amount"; Rec."Cost Amount")
                {
                    ApplicationArea = All;
                }
                field("Document No."; Rec."Document No.")
                {
                    ApplicationArea = All;
                }
                field("Document Type"; Rec."Document Type")
                {
                    ApplicationArea = All;
                }
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Finished Qty. (Hours) Travel"; Rec."Finished Qty. (Hours) Travel")
                {
                    ApplicationArea = All;
                }
                field("Finished Quantity (Hours)"; Rec."Finished Quantity (Hours)")
                {
                    ApplicationArea = All;
                }
                field("Posting Date"; Rec."Posting Date")
                {
                    ApplicationArea = All;
                }
                field("Quantity (Hours)"; Rec."Quantity (Hours)")
                {
                    ApplicationArea = All;
                }
                field("Resource No."; Rec."Resource No.")
                {
                    ApplicationArea = All;
                }
                field("Service Ledger Entry No."; Rec."Service Ledger Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Unit Cost"; Rec."Unit Cost")
                {
                    ApplicationArea = All;
                }
            }
        }
    }

}
