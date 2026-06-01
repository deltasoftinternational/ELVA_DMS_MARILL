Page 25006810 "SP Sales Disc. Group Items"
{
    Caption = 'SP Sales Disc. Group Items';
    PageType = List;
    SourceTable = "SP Sales Disc. Group Items";

    layout
    {
        area(content)
        {
            repeater(Control1190000)
            {
                field(SalesDiscGroupCode; Rec."Sales Disc. Group Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(MaxDiscount; Rec."Max. Discount %")
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

