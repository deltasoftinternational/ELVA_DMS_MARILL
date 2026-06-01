Page 25006829 "Item Markups"
{
    // 17.02.05 AB

    ApplicationArea = Basic;
    Caption = 'Item Markups';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Sales/Serv. Item Markup";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field(SalesType; Rec."Sales Type")
                {
                    ApplicationArea = Basic;
                }
                field(SalesCode; Rec."Sales Code")
                {
                    ApplicationArea = Basic;
                }
                field(StartingDate; Rec."Starting Date")
                {
                    ApplicationArea = Basic;
                }
                field(EndingDate; Rec."Ending Date")
                {
                    ApplicationArea = Basic;
                }
                field(Markup; Rec."Markup %")
                {
                    ApplicationArea = Basic;
                }
                field(ItemCategoryCode; Rec."Item Category Code")
                {
                    ApplicationArea = Basic;
                }
                field(Base; Rec.Base)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(AllowLineDisc; Rec."Allow Line Disc.")
                {
                    ApplicationArea = Basic;
                }
                field(AllowInvoiceDisc; Rec."Allow Invoice Disc.")
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

