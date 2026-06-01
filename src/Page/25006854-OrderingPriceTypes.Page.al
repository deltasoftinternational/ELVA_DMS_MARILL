Page 25006854 "Ordering Price Types"
{
    Caption = 'Ordering Price Types';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Ordering Price Type";

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(InboundTime; Rec."Inbound Time")
                {
                    ApplicationArea = Basic;
                }
                field(OutboundTime; Rec."Outbound Time")
                {
                    ApplicationArea = Basic;
                }
                field(DefPurchTransportMethod; Rec."Def. Purch. Transport Method")
                {
                    ApplicationArea = Basic;
                }
                field(SeparatePOrdperVehicle; Rec."Separate P. Ord. per Vehicle")
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

