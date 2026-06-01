Page 25006862 "Item Disc. Group Parameters"
{
    // 10.03.2015 EDMS P21 #T029
    //   Restructured

    Caption = 'Item Discount Group Parameter';
    PageType = List;
    SourceTable = "Item Discount Group Parameter";

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field(VendorNo; Rec."Vendor No.")
                {
                    ApplicationArea = Basic;
                }
                field(ItemDiscountGroupCode; Rec."Item Discount Group Code")
                {
                    ApplicationArea = Basic;
                }
                field(OrderingPriceTypeCode; Rec."Ordering Price Type Code")
                {
                    ApplicationArea = Basic;
                }
                field(StartingDate; Rec."Starting Date")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(Surcharge; Rec."Surcharge %")
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

