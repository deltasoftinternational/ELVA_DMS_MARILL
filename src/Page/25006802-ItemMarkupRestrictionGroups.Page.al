Page 25006802 "Item Markup Restriction Groups"
{
    // 22.10.2007. EDMS P2
    //   * Added new field "Notice Type"

    Caption = 'Item Markup Restriction Groups';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Item Markup Restriction Group";

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
                field(NotificationType; Rec."Notification Type")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(MarkupRestrictions)
            {
                ApplicationArea = Basic;
                Caption = 'Markup Restrictions';
                Image = List;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Item Markup Restrictions";
                RunPageLink = "Group Code" = field(Code);
            }
        }
    }
}

