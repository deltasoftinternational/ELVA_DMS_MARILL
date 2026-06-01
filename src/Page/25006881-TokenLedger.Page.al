Page 25006881 "Token Ledger"
{
    ApplicationArea = Basic;
    Editable = false;
    PageType = List;
    SourceTable = "Token Ledger";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                }
                field(Time; Rec.Time)
                {
                    ApplicationArea = Basic;
                }
                field(TokenQty; Rec."Token Qty.")
                {
                    ApplicationArea = Basic;
                }
                field(OperationCount; Rec."Operation Count")
                {
                    ApplicationArea = Basic;
                }
                field(ServiceCode; Rec."Service Code")
                {
                    ApplicationArea = Basic;
                }
                field(OperationNo; Rec."Operation No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(UserID; Rec."User ID")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

