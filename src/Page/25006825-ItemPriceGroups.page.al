page 25006825 "Item Price Groups"
{
    ApplicationArea = All;
    Caption = 'Item Price Groups';
    PageType = List;
    SourceTable = "Item Price Group";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(General)
            {
                field("Code"; Rec."Code")
                {
                    ToolTip = 'Specifies the Code for Item Price Group.';
                    ApplicationArea = All;
                }
                field(Description; Rec.Description)
                {
                    ToolTip = 'Specifies a Description for the Item Price Group.';
                    ApplicationArea = All;
                }
                field("Purchase Discount percent"; Rec."Purchase Discount percent")
                {
                    ToolTip = 'Specifies a discount percent for purchases using this discount group.';
                    ApplicationArea = All;
                }
                field("Purchase Discount percent 2"; Rec."Purchase Discount percent 2")
                {
                    ToolTip = 'Specifies a discount percent for purchases using this discount group.';
                    ApplicationArea = All;
                    Visible = false;
                }
            }
        }
    }
    actions
    {
        area(processing)
        {
            action("&Setup")
            {
                ApplicationArea = Basic, Suite;
                Caption = '&Setup';
                Image = Setup;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Item Price Group Setup";
                RunPageLink = "Item Price Group Code" = FIELD(Code);
                ToolTip = 'View or edit how you want to set up prices using this Item Price Group.';
            }
        }
    }
}
