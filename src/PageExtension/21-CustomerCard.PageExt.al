pageextension 25006003 "Customer Card" extends "Customer Card" //21
{
    layout
    {
        addafter(PricesandDiscounts)
        {
            field(Internal; Rec.Internal)
            {
                ApplicationArea = All;
                ToolTip = 'Specifies if the customer is internal. Internal customers are used for internal charging between departments, for example, warranty or Vehicle PDI services.';
            }
            field(CorrespondingVendorNo; Rec."Corresponding Vendor No.")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the linked internal Vendor code. If this field is filled, then after service order posting using this customer system will create internal purchase order to put costs on the vehicle used in service document.';
            }
            field(DefaultServiceItemCharge; Rec."Default Service Item Charge")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies the item charge that should be used to post service charges to increase vehicle inventory cost. It is mandatory to fill this field if Internal Vendor is specified.';
            }
            field(ItemChargeInvoiceDealType; Rec."Item Charge Invoice Deal Type")
            {
                ApplicationArea = All;
                ToolTip = 'Specifies  a specific Deal Type that should be used for internal purchase order to assign costs to vehicle. This Deal Type allows to identify documents and assign specific dimensions to them.';
            }
        }
    }
    actions
    {
        addafter(Contact)
        {
            action(Vehicles)
            {
                ApplicationArea = Basic;
                Caption = '&Vehicles';
                Image = Delivery;

                trigger OnAction()
                begin
                    rec.ShowVehicles;
                end;
            }
        }
        addbefore("Invoice &Discounts")
        {
            action("<Action1101904003>")
            {
                ApplicationArea = Basic;
                Caption = 'Con&tracts';
                Image = ServiceAgreement;
                RunObject = Page "Contract List EDMS";
                RunPageLink = "Bill-to Customer No." = field("No.");
                RunPageView = sorting("Bill-to Customer No.");
            }
        }
    }
}