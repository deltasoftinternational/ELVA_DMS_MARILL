Page 25006078 "Service Labor Discount Groups"
{
    Caption = 'Service Labor Discount Groups';
    PageType = List;
    SourceTable = "Service Labor Discount Group";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the code of the service labor discount group.';
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the service labor discount group.';
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(ItemDiscGroups)
            {
                Caption = 'Item &Disc. Groups';
                Image = Group;
                action(ServiceLineDiscounts)
                {
                    ApplicationArea = Basic;
                    Caption = 'Service &Line Discounts';
                    Image = SalesLineDisc;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Labor Sales Line Discounts";
                    RunPageLink = Type = const("Labor Discount Group"),
                                  Code = field(Code);
                    RunPageView = sorting(Type, Code);
                }
            }
        }
    }


    procedure GetSelectionFilter(): Text
    var
        ServiceLaborDiscountGroup: Record "Service Labor Discount Group";
        SelectionFilterManagement: Codeunit SelectionFilterManagement;
        ItemSalesDocMgtEDMS: Codeunit "Item Sales Doc. Mgt. EDMS";
    begin
        CurrPage.SetSelectionFilter(ServiceLaborDiscountGroup);
        exit(ItemSalesDocMgtEDMS.GetSelectionFilterForLaborDiscountGroup(ServiceLaborDiscountGroup));
    end;
}

