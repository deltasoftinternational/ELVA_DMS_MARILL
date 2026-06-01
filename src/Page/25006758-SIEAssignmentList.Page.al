/*
Page 25006758 "SIE Assignment List"
{
    Caption = 'SIE Assignment List';
    Editable = false;
    PageType = List;
    SourceTable = "SIE Assignment";

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
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                }
                field(ItemNo; Rec."Item No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(QtytoAssign; Rec."Qty. to Assign")
                {
                    ApplicationArea = Basic;
                }
                field(QtyAssignedDet; Rec."Qty. Assigned Det.")
                {
                    ApplicationArea = Basic;
                }
                field(UnitCost; Rec."Unit Cost")
                {
                    ApplicationArea = Basic;
                }
                field(AmounttoAssign; Rec."Amount to Assign")
                {
                    ApplicationArea = Basic;
                }
                field(AppliestoType; Rec."Applies-to Type")
                {
                    ApplicationArea = Basic;
                }
                field(AppliestoDocType; Rec."Applies-to Doc. Type")
                {
                    ApplicationArea = Basic;
                }
                field(AppliestoDocNo; Rec."Applies-to Doc. No.")
                {
                    ApplicationArea = Basic;
                }
                field(AppliestoDocLineNo; Rec."Applies-to Doc. Line No.")
                {
                    ApplicationArea = Basic;
                }
                field(AppliestoDocLineAmount; Rec."Applies-to Doc. Line Amount")
                {
                    ApplicationArea = Basic;
                }
                field(Corrected; Rec.Corrected)
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
*/