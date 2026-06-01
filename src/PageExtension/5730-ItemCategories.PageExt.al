pageextension 25006089 "Item Categories" extends "Item Categories"//5730
{
    layout
    {
        addafter(Description)
        {
            field(DescriptionSalesDocument; Rec."Description (Sales Document)")
            {
                ApplicationArea = Basic;
            }
        }
    }
    actions
    {
        addafter(Recalculate)
        {
            action(Dimensions)
            {
                ApplicationArea = Basic;
                Caption = 'Dimensions';
                Image = Dimensions;
                RunObject = Page "Default Dimensions";
                RunPageLink = "Table ID" = const(5722),
                              "No." = field(Code);
                ShortCutKey = 'Shift+Ctrl+D';
            }
        }
    }
}