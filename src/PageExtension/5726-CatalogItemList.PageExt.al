pageextension 25006029 "Catalog Item List" extends "Catalog Item List"//5726
{
    layout
    {
        addfirst(Control1)
        {
            field("Entry No."; Rec."Entry No.")
            {
                ToolTip = 'Specifies the number of the entry, as assigned from the specified number series when the entry was created.';
                ApplicationArea = All;
            }
        }
        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = Basic, Suite, Service;
                Visible = false;
            }
        }
        addafter("Bar Code")
        {
            field(Blocked; Rec.Blocked)
            {
                ToolTip = 'Specifies that the related record is blocked from being used.';
                ApplicationArea = All;
            }
            field("Item Category Code"; Rec."Item Category Code")
            {
                ToolTip = 'Specifies the category that the item belongs to. Item categories also contain any assigned item attributes.';
                ApplicationArea = All;
            }
            field("Item Price Group Code"; Rec."Item Price Group Code")
            {
                ToolTip = 'Specifies a code for item price group.';
                ApplicationArea = All;
            }
            field("Item Disc. Group"; Rec."Item Disc. Group")
            {
                ToolTip = 'Specifies a code for item discount group.';
                ApplicationArea = All;
            }
            field("Item Tracking Code"; Rec."Item Tracking Code")
            {
                ToolTip = 'Specifies how serial or lot numbers assigned to the item are tracked in the supply chain.';
                ApplicationArea = All;
            }
            field(Discontinued; Rec.Discontinued)
            {
                ToolTip = 'Specifies that this catalogue item is discontinued and can no longer be ordered.';
                ApplicationArea = All;
            }
            field("Replacements Exist"; Rec."Replacements Exist")
            {
                ToolTip = 'Specifies that there are replacements for this catalogue item.';
                ApplicationArea = All;
            }
            field("Substitutes Exist"; Rec."Substitutes Exist")
            {
                ToolTip = 'Specifies that there are substitutes for this catalogue item.';
                ApplicationArea = All;
            }
            field("Market Recomended Sales Price"; Rec."Market Recomended Sales Price")
            {
                ToolTip = 'Specifies the Recomended Sales Price.';
                ApplicationArea = All;
                Visible = false;
            }
            field("MRSP Currency Code"; Rec."MRSP Currency Code")
            {
                ToolTip = 'Specifies the Recomended Sales Price currency.';
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    {
        addafter("Substituti&ons")
        {
            action(ReplacementOverview)
            {
                ApplicationArea = Basic;
                Caption = 'Replacement Overview';
                Image = ItemSubstitution;
                ToolTip = 'View replacement information for this item.';

                trigger OnAction()
                var
                    ItemSubstSync: Codeunit "Item Substitution Sync";
                    TypePar: Option Item,"Nonstock Item";
                begin
                    // 03.04.2014 Elva Baltic P15 #F124 MMG7.00 >>
                    ItemSubstSync.ShowReplacementOverview(Typepar::"Nonstock Item", Rec."Entry No.", '');
                    // 03.04.2014 Elva Baltic P15 #F124 MMG7.00 <<
                end;
            }
        }
        addafter("Co&mments")
        {
            action("<Action184>")
            {
                ApplicationArea = Basic;
                Caption = 'Dimensions';
                Image = Dimensions;
                RunObject = Page "Default Dimensions";
                RunPageLink = "Table ID" = const(5718),
                                  "No." = field("Entry No.");
                ShortCutKey = 'Shift+Ctrl+D';
                ToolTip = 'View or edit dimensions, such as area, project, or department, that you can assign to sales and purchase documents to distribute costs and analyze transaction history.';
            }
            action("<Action1101904006>")
            {
                ApplicationArea = Basic;
                Caption = 'Translations';
                Image = Translations;
                RunObject = Page "Nonstock Item Translations";
                RunPageLink = "Nonstock Item Entry No." = field("Entry No.");
                ToolTip = 'View or edit translated item descriptions. Translated item descriptions are automatically inserted on documents according to the language code.';
            }
            action("<Action1101904013>")
            {
                ApplicationArea = Basic;
                Caption = 'Vehicle Models';
                Image = Item;
                ToolTip = 'View information on vehicle models where this item can be used.';

                trigger OnAction()
                begin
                    Rec.ShowVehModels
                end;
            }
        }
        addafter("Ca&talog Item")
        {
            group(Sales)
            {
                Caption = 'Sales';
                action("<Action36>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Prices';
                    Image = ResourcePrice;
                    RunObject = Page "Nonstock Sales Prices";
                    RunPageLink = "Nonstock Item Entry No." = field("Entry No.");
                    RunPageView = sorting("Sales Type", "Sales Code", "Nonstock Item Entry No.", "Starting Date", "Currency Code", "Unit of Measure Code", "Minimum Quantity", "Location Code", "Ordering Price Type Code", "Document Profile");
                    ToolTip = 'Set up different sales prices for the item.';
                }
                action("<Action34>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Line Discounts';
                    Image = LineDiscount;
                    RunObject = Page "Nonstock Sales Line Discounts";
                    RunPageLink = "Nonstock Item Entry No." = field("Entry No.");
                    RunPageView = sorting("Nonstock Item Entry No.", "Sales Type", "Sales Code", "Starting Date", "Currency Code", "Unit of Measure Code", "Minimum Quantity", "Vehicle Status Code", "Document Profile");
                    ToolTip = 'Set up different sales line discounts for the item.';
                }
            }
            group(Purchases)
            {
                Caption = 'Purchases';
                action("<Action39>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Prices';
                    Image = ResourcePrice;
                    RunObject = Page "Nonstock Purchase Prices";
                    RunPageLink = "Nonstock Item Entry No." = field("Entry No.");
                    RunPageView = sorting("Nonstock Item Entry No.", "Vendor No.", "Starting Date", "Currency Code", "Unit of Measure Code", "Minimum Quantity", "Ordering Price Type Code");
                    ToolTip = 'Set up different purchase prices for the item.';
                }
                action("<Action42>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Line Discounts';
                    Image = Discount;
                    RunObject = Page "Nonstock Purchase Line Disc.";
                    RunPageLink = "Nonstock Item Entry No." = field("Entry No.");
                    RunPageView = sorting("Nonstock Item Entry No.", "Vendor No.", "Starting Date", "Currency Code", "Unit of Measure Code", "Minimum Quantity", "Ordering Price Type Code");
                    ToolTip = 'Set up different purchase line discounts for the item.';
                }
            }
        }
        addfirst(Creation)
        {
            action(NewItem)
            {
                ApplicationArea = Advanced;
                Caption = 'New Item';
                Image = NewItem;
                Promoted = true;
                PromotedCategory = New;
                RunObject = Page "Item Card";
                RunPageMode = Create;
                ToolTip = 'Create an item card based on the stockkeeping unit.';
            }
        }
        addfirst(reporting)
        {
            action(InventoryList)
            {
                ApplicationArea = Advanced;
                Caption = 'Inventory - List';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Inventory - List";
                ToolTip = 'View various information about the item, such as name, unit of measure, posting group, shelf number, vendor''s item number, lead time calculation, minimum inventory, and alternate item number. You can also see if the item is blocked.';
            }
            action(InventoryAvailability)
            {
                ApplicationArea = Advanced;
                Caption = 'Inventory Availability';
                Image = "Report";
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = "Report";
                RunObject = Report "Inventory Availability";
                ToolTip = 'View, print, or save a summary of historical inventory transactions with selected items, for example, to decide when to purchase the items. The report specifies quantity on sales order, quantity on purchase order, back orders from vendors, minimum inventory, and whether there are reorders.';
            }
            action(InventoryAvailabilityPlan)
            {
                ApplicationArea = Advanced;
                Caption = 'Inventory - Availability Plan';
                Image = ItemAvailability;
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Inventory - Availability Plan";
                ToolTip = 'View a list of the quantity of each item in customer, purchase, and transfer orders and the quantity available in inventory. The list is divided into columns that cover six periods with starting and ending dates as well as the periods before and after those periods. The list is useful when you are planning your inventory purchases.';
            }
            action(ItemVendorCatalog)
            {
                ApplicationArea = Advanced;
                Caption = 'Item/Vendor Catalog';
                Image = "Report";
                Promoted = true;
                PromotedCategory = "Report";
                RunObject = Report "Item/Vendor Catalog";
                ToolTip = 'View a list of the vendors for the selected items. For each combination of item and vendor, it shows direct unit cost, lead time calculation and the vendor''s item number.';
            }
        }
        addfirst(Processing)
        {
            group("<Action139>")
            {
                Caption = 'F&unctions';
                action("<Action41>")
                {
                    ApplicationArea = Basic;
                    Caption = '&Create Item';
                    Image = NewItemNonStock;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Create an item card based on the stockkeeping unit.';

                    trigger OnAction()
                    var
                        NonstockItemMgt: Codeunit "Catalog Item Management";
                    begin
                        NonstockItemMgt.NonstockAutoItem(Rec);
                    end;
                }
            }
        }
    }
    procedure GetSelectionFilter(): Code[80]
    var
        recNonstockItem: Record "Nonstock Item";
        codFirstItem: Code[30];
        codLastItem: Code[30];
        codSelectionFilter: Code[250];
        iItemCount: Integer;
        bMore: Boolean;
    begin
        CurrPage.SetSelectionFilter(recNonstockItem);
        iItemCount := recNonstockItem.Count;
        if iItemCount > 0 then begin
            recNonstockItem.Find('-');
            while iItemCount > 0 do begin
                iItemCount := iItemCount - 1;
                recNonstockItem.MarkedOnly(false);
                codFirstItem := recNonstockItem."Entry No.";
                codLastItem := codFirstItem;
                bMore := (iItemCount > 0);
                while bMore do
                    if recNonstockItem.Next = 0 then
                        bMore := false
                    else
                        if not recNonstockItem.Mark then
                            bMore := false
                        else begin
                            codLastItem := recNonstockItem."Entry No.";
                            iItemCount := iItemCount - 1;
                            if iItemCount = 0 then
                                bMore := false;
                        end;
                if codSelectionFilter <> '' then
                    codSelectionFilter := codSelectionFilter + '|';
                if codFirstItem = codLastItem then
                    codSelectionFilter := codSelectionFilter + codFirstItem
                else
                    codSelectionFilter := codSelectionFilter + codFirstItem + '..' + codLastItem;
                if iItemCount > 0 then begin
                    recNonstockItem.MarkedOnly(true);
                    recNonstockItem.Next;
                end;
            end;
        end;
        exit(codSelectionFilter);
    end;
}

