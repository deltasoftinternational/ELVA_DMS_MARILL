Page 25006645 "Ren Item Attribute Val. Editor"
{
    Caption = 'Rent Item Attribute Values';
    PageType = StandardDialog;
    SourceTable = "Rent Item";

    layout
    {
        area(content)
        {
            part(ItemAttributeValueList; "Rent Item Attribute Value List")
            {
                ApplicationArea = Basic, Suite;
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        CurrPage.ItemAttributeValueList.Page.LoadAttributes(Rec."No.");
    end;
}

