Page 25006054 "Model Version List"
{
    // 06.12.2017 EB.P7 #T007
    //   Removed field "Product Subgroup Code"
    // 
    // 26.10.2015 #NAV2016 Merge
    //   Action "Item Tracking Entries" removed;

    ApplicationArea = Basic;
    Caption = 'Model Version List';
    CardPageID = "Model Version Card";
    Editable = false;
    PageType = List;
    SourceTable = Item;
    SourceTableView = sorting("Item Type")
                      where("Item Type" = const("Model Version"));
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                }
                field(ModelCode; Rec."Model Code")
                {
                    ApplicationArea = Basic;
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(BaseUnitofMeasure; Rec."Base Unit of Measure")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ShelfNo; Rec."Shelf No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(CostingMethod; Rec."Costing Method")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(CostisAdjusted; Rec."Cost is Adjusted")
                {
                    ApplicationArea = Basic;
                }
                field(StandardCost; Rec."Standard Cost")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(UnitCost; Rec."Unit Cost")
                {
                    ApplicationArea = Basic;
                }
                field(LastDirectCost; Rec."Last Direct Cost")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PriceProfitCalculation; Rec."Price/Profit Calculation")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Profit; Rec."Profit %")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(UnitPrice; Rec."Unit Price")
                {
                    ApplicationArea = Basic;
                }
                field(InventoryPostingGroup; Rec."Inventory Posting Group")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(GenProdPostingGroup; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VATProdPostingGroup; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ItemDiscGroup; Rec."Item Disc. Group")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VendorNo; Rec."Vendor No.")
                {
                    ApplicationArea = Basic;
                }
                field(VendorItemNo; Rec."Vendor Item No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(TariffNo; Rec."Tariff No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SearchDescription; Rec."Search Description")
                {
                    ApplicationArea = Basic;
                }
                field(OverheadRate; Rec."Overhead Rate")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(IndirectCost; Rec."Indirect Cost %")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ItemCategoryCode; Rec."Item Category Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(LastDateModified; Rec."Last Date Modified")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ItemTrackingCode; Rec."Item Tracking Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ItemType; Rec."Item Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            part(Control1901314507; "Item Invoicing FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
                Visible = true;
            }
            part("Model Version Pictures"; "Object Picture FactBox")
            {
                ApplicationArea = All;
                Caption = 'Model Version Pictures';
                SubPageLink = "Source Type" = const(27),
                              "Source Subtype" = const("2"),
                              "Source ID" = field("No."),
                              "Source Ref. No." = const(0);
                SubPageView = sorting("Source Type", "Source Subtype", "Source ID", "Source Ref. No.", "No.");
            }
            part(Control1906840407; "Item Planning FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
                Visible = true;
            }
            part(Control1901796907; "Item Warehouse FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "No." = field("No.");
                Visible = false;
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = All;
                Visible = true;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = All;
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Item)
            {
                Caption = '&Item';
                group(Entries)
                {
                    Caption = 'E&ntries';
                    Image = Entries;
                    action(LedgerEntries)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Ledger E&ntries';
                        Image = ItemLedger;
                        Promoted = false;
                        //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                        //PromotedCategory = Process;
                        RunObject = Page "Item Ledger Entries";
                        RunPageLink = "Item No." = field("No.");
                        RunPageView = sorting("Item No.");
                        ShortCutKey = 'Ctrl+F7';
                    }
                    action(ReservationEntries)
                    {
                        ApplicationArea = Basic;
                        Caption = '&Reservation Entries';
                        Image = ReservationLedger;
                        RunObject = Page "Reservation Entries";
                        RunPageLink = "Reservation Status" = const(Reservation),
                                      "Item No." = field("No.");
                        RunPageView = sorting("Item No.", "Variant Code", "Location Code", "Reservation Status");
                    }
                    action(PhysInventoryLedgerEntries)
                    {
                        ApplicationArea = Basic;
                        Caption = '&Phys. Inventory Ledger Entries';
                        Image = PhysicalInventoryLedger;
                        RunObject = Page "Phys. Inventory Ledger Entries";
                        RunPageLink = "Item No." = field("No.");
                        RunPageView = sorting("Item No.");
                    }
                    action(ValueEntries)
                    {
                        ApplicationArea = Basic;
                        Caption = '&Value Entries';
                        Image = ValueLedger;
                        RunObject = Page "Value Entries";
                        RunPageLink = "Item No." = field("No.");
                        RunPageView = sorting("Item No.");
                    }
                }
                group(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    action(Action16)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Statistics';
                        Image = Statistics;
                        Promoted = true;
                        PromotedCategory = Process;
                        ShortCutKey = 'F7';

                        trigger OnAction()
                        var
                            ItemStatistics: Page "EDMS Item Statistics";
                        begin
                            ItemStatistics.SetItem(Rec);
                            ItemStatistics.RunModal;
                        end;
                    }
                    action(EntryStatistics)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Entry Statistics';
                        Image = Statistics;
                        RunObject = Page "Item Entry Statistics";
                        RunPageLink = "No." = field("No."),
                                      "Date Filter" = field("Date Filter"),
                                      "Global Dimension 1 Filter" = field("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter" = field("Global Dimension 2 Filter"),
                                      "Location Filter" = field("Location Filter"),
                                      "Drop Shipment Filter" = field("Drop Shipment Filter"),
                                      "Variant Filter" = field("Variant Filter");
                    }
                    action(Turnover)
                    {
                        ApplicationArea = Basic;
                        Caption = 'T&urnover';
                        Image = Turnover;
                        RunObject = Page "Item Turnover";
                        RunPageLink = "No." = field("No."),
                                      "Global Dimension 1 Filter" = field("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter" = field("Global Dimension 2 Filter"),
                                      "Location Filter" = field("Location Filter"),
                                      "Drop Shipment Filter" = field("Drop Shipment Filter"),
                                      "Variant Filter" = field("Variant Filter");
                    }
                }
                action(ItemsbyLocation)
                {
                    ApplicationArea = Basic;
                    Caption = 'Items b&y Location';
                    Image = ItemAvailbyLoc;

                    trigger OnAction()
                    var
                        ItemsByLocation: Page "Items by Location";
                    begin
                        ItemsByLocation.SetRecord(Rec);
                        ItemsByLocation.Run;
                    end;
                }
                action("<Action1101904003>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Manufacturer Options';
                    Image = CheckList;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    RunObject = Page "Manufacturer Options";
                    RunPageLink = "Make Code" = field("Make Code"),
                                  "Model Code" = field("Model Code"),
                                  "Model Version No." = field("No.");
                }
                action(Specification)
                {
                    ApplicationArea = Basic;
                    Caption = 'Specification';
                    Image = CheckList;
                    Promoted = true;
                    PromotedCategory = Process;
                    RunObject = Page "Model Version Specification";
                    RunPageLink = "Make Code" = field("Make Code"),
                                  "Model Code" = field("Model Code"),
                                  "Model Version No." = field("No.");
                }
                group(ItemAvailabilityby)
                {
                    Caption = '&Item Availability by';
                    Image = ItemAvailability;
                    action(Period)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Period';
                        Image = Period;
                        RunObject = Page "Item Availability by Periods";
                        RunPageLink = "No." = field("No."),
                                      "Global Dimension 1 Filter" = field("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter" = field("Global Dimension 2 Filter"),
                                      "Location Filter" = field("Location Filter"),
                                      "Drop Shipment Filter" = field("Drop Shipment Filter"),
                                      "Variant Filter" = field("Variant Filter");
                    }
                    action(Variant)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Variant';
                        Image = ItemVariant;
                        RunObject = Page "Item Availability by Variant";
                        RunPageLink = "No." = field("No."),
                                      "Global Dimension 1 Filter" = field("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter" = field("Global Dimension 2 Filter"),
                                      "Location Filter" = field("Location Filter"),
                                      "Drop Shipment Filter" = field("Drop Shipment Filter"),
                                      "Variant Filter" = field("Variant Filter");
                    }
                    action(Location)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Location';
                        Image = Warehouse;
                        RunObject = Page "Item Availability by Location";
                        RunPageLink = "No." = field("No."),
                                      "Global Dimension 1 Filter" = field("Global Dimension 1 Filter"),
                                      "Global Dimension 2 Filter" = field("Global Dimension 2 Filter"),
                                      "Location Filter" = field("Location Filter"),
                                      "Drop Shipment Filter" = field("Drop Shipment Filter"),
                                      "Variant Filter" = field("Variant Filter");
                    }
                }
                action(BinContents)
                {
                    ApplicationArea = Basic;
                    Caption = '&Bin Contents';
                    Image = BinContent;
                    RunObject = Page "Bin Contents";
                    RunPageLink = "Item No." = field("No.");
                    RunPageView = sorting("Item No.");
                }
                action(Comments)
                {
                    ApplicationArea = Basic;
                    Caption = 'Co&mments';
                    Image = ViewComments;
                    RunObject = Page "Comment Sheet";
                    RunPageLink = "Table Name" = const(Item),
                                  "No." = field("No.");
                }
                group(Dimensions)
                {
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    action(DimensionsSingle)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Dimensions-Single';
                        Image = Dimensions;
                        RunObject = Page "Default Dimensions";
                        RunPageLink = "Table ID" = const(27),
                                      "No." = field("No.");
                        ShortCutKey = 'Shift+Ctrl+D';
                    }
                    action(DimensionsMultiple)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Dimensions-&Multiple';
                        Image = Dimensions;

                        trigger OnAction()
                        var
                            Item: Record Item;
                            DefaultDimMultiple: Page "Default Dimensions-Multiple";
                        begin
                            CurrPage.SetSelectionFilter(Item);
                            DefaultDimMultiple.SetMultiRecord(Item, Item.FieldNo("No."));
                            DefaultDimMultiple.RunModal;
                        end;
                    }
                }
                action("<Page Object Picture>")
                {
                    ApplicationArea = Basic;
                    Caption = '&Pictures';
                    Image = Picture;
                    RunObject = Page Pictures;
                    RunPageLink = "Source Type" = const(27),
                                  "Source Subtype" = const("2"),
                                  "Source ID" = field("No."),
                                  "Source Ref. No." = const(0);
                    RunPageMode = View;

                    trigger OnAction()
                    begin
                        // 1st par 25006005 - Vehicle
                        //PictureMgt.ShowObjectPictures(27,"Item Type"::"Model Version","No.",0)
                    end;
                }
                action(UnitsofMeasure)
                {
                    ApplicationArea = Basic;
                    Caption = '&Units of Measure';
                    Image = UnitOfMeasure;
                    RunObject = Page "Item Units of Measure";
                    RunPageLink = "Item No." = field("No.");
                }
                action(CrossReferences)
                {
                    ApplicationArea = Basic;
                    Caption = 'Cross Re&ferences';
                    Image = Link;
                    RunObject = Page "Item Reference Entries";
                    RunPageLink = "Item No." = field("No.");
                }
                action(Translations)
                {
                    ApplicationArea = Basic;
                    Caption = 'Translations';
                    Image = Translations;
                    RunObject = Page "Item Translations";
                    RunPageLink = "Item No." = field("No."),
                                  "Variant Code" = const('');
                }
                action(ExtendedTexts)
                {
                    ApplicationArea = Basic;
                    Caption = 'E&xtended Texts';
                    Image = Text;
                    RunObject = Page "Extended Text List";
                    RunPageLink = "Table Name" = const(Item),
                                  "No." = field("No.");
                    RunPageView = sorting("Table Name", "No.", "Language Code", "All Language Codes", "Starting Date", "Ending Date");
                }
                action(Identifiers)
                {
                    ApplicationArea = Basic;
                    Caption = 'Identifiers';
                    Image = Union;
                    RunObject = Page "Item Identifiers";
                    RunPageLink = "Item No." = field("No.");
                    RunPageView = sorting("Item No.", "Variant Code", "Unit of Measure Code");
                }
            }
            group(Sales)
            {
                Caption = 'S&ales';
                /*action(Prices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Prices';
                    Image = ResourcePrice;
                    RunObject = Page "Sales Prices";
                    RunPageLink = "Item No." = field("No.");
                    RunPageView = sorting("Item No.");
                }*/

                action(SalesPriceLists)
                {
                    AccessByPermission = TableData "Sales Price Access" = R;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Prices';
                    Image = Price;
                    Scope = Repeater;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Set up sales prices for the item. An item price is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.';

                    trigger OnAction()
                    var
                        AmountType: Enum "Price Amount Type";
                        PriceType: Enum "Price Type";
                    begin
                        Rec.ShowPriceListLines(PriceType::Sale, AmountType::Price);
                    end;
                }
                action(SalesPriceListsDiscounts)
                {
                    AccessByPermission = TableData "Sales Discount Access" = R;
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Discounts';
                    Image = LineDiscount;
                    Scope = Repeater;
                    Promoted = true;
                    PromotedCategory = Process;
                    ToolTip = 'Set up sales discounts for the item. An item discount is automatically granted on invoice lines when the specified criteria are met, such as customer, quantity, or ending date.';

                    trigger OnAction()
                    var
                        AmountType: Enum "Price Amount Type";
                        PriceType: Enum "Price Type";
                    begin
                        Rec.ShowPriceListLines(PriceType::Sale, AmountType::Discount);
                    end;
                }

                /* action(LineDiscounts)
                 {
                     ApplicationArea = Basic;
                     Caption = 'Line Discounts';
                     Image = LineDiscount;
                     RunObject = Page "Sales Line Discounts";
                     RunPageLink = Type = const(Item),
                                   Code = field("No.");
                     RunPageView = sorting(Type, Code);
                 }*/
                action(PrepaymentPercentages)
                {
                    ApplicationArea = Basic;
                    Caption = 'Prepa&yment Percentages';
                    Image = PrepaymentPercentages;
                    RunObject = Page "Sales Prepayment Percentages";
                    RunPageLink = "Item No." = field("No.");
                }
                action(Orders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Orders';
                    Image = Document;
                    RunObject = Page "Sales Orders";
                    RunPageLink = Type = const(Item),
                                  "No." = field("No.");
                    RunPageView = sorting("Document Type", Type, "No.");
                }
                action(ReturnsOrders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Returns Orders';
                    Image = ReturnOrder;
                    RunObject = Page "Sales Return Orders";
                    RunPageLink = Type = const(Item),
                                  "No." = field("No.");
                    RunPageView = sorting("Document Type", Type, "No.");
                }
            }
            group(Purchases)
            {
                Caption = '&Purchases';
                action(Vendors)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ven&dors';
                    Image = Vendor;
                    RunObject = Page "Item Vendor Catalog";
                    RunPageLink = "Item No." = field("No.");
                    RunPageView = sorting("Item No.");
                }
                /* action(Action39)
                 {
                     ApplicationArea = Basic;
                     Caption = 'Prices';
                     Image = ResourcePrice;
                     RunObject = Page "Purchase Prices";
                     RunPageLink = "Item No." = field("No.");
                     RunPageView = sorting("Item No.");
                 }
                 action(Action42)
                 {
                     ApplicationArea = Basic;
                     Caption = 'Line Discounts';
                     Image = LineDiscount;
                     RunObject = Page "Purchase Line Discounts";
                     RunPageLink = "Item No." = field("No.");
                     RunPageView = sorting("Item No.");
                 }*/
                action(PurchPriceLists)
                {
                    AccessByPermission = TableData "Purchase Price Access" = R;
                    ApplicationArea = Suite;
                    Caption = 'Purchase Prices';
                    Image = Price;
                    ToolTip = 'Set up purchase prices for the item. An item price is automatically granted on invoice lines when the specified criteria are met, such as vendor, quantity, or ending date.';

                    trigger OnAction()
                    var
                        AmountType: Enum "Price Amount Type";
                        PriceType: Enum "Price Type";
                    begin
                        Rec.ShowPriceListLines(PriceType::Purchase, AmountType::Price);
                    end;
                }
                action(PurchPriceListsDiscounts)
                {
                    AccessByPermission = TableData "Purchase Price Access" = R;
                    ApplicationArea = Suite;
                    Caption = 'Purchase Discounts';
                    Image = LineDiscount;
                    ToolTip = 'Set up purchase discounts for the item. An item discount is automatically granted on invoice lines when the specified criteria are met, such as vendor, quantity, or ending date.';

                    trigger OnAction()
                    var
                        AmountType: Enum "Price Amount Type";
                        PriceType: Enum "Price Type";
                    begin
                        Rec.ShowPriceListLines(PriceType::Purchase, AmountType::Discount);
                    end;
                }
                action(Action125)
                {
                    ApplicationArea = Basic;
                    Caption = 'Prepa&yment Percentages';
                    Image = PrepaymentPercentages;
                    RunObject = Page "Purchase Prepmt. Percentages";
                    RunPageLink = "Item No." = field("No.");
                }
                action(Action40)
                {
                    ApplicationArea = Basic;
                    Caption = 'Orders';
                    Image = Document;
                    RunObject = Page "Purchase Orders";
                    RunPageLink = Type = const(Item),
                                  "No." = field("No.");
                    RunPageView = sorting("Document Type", Type, "No.");
                }
                action(ReturnOrders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Return Orders';
                    Image = ReturnOrder;
                    RunObject = Page "Purchase Return Orders";
                    RunPageLink = Type = const(Item),
                                  "No." = field("No.");
                    RunPageView = sorting("Document Type", Type, "No.");
                }
            }
        }
        area(processing)
        {
            /*   action(SalesPrices)
               {
                   ApplicationArea = Basic;
                   Caption = 'Sales Prices';
                   Image = SalesPrices;
                   Promoted = true;
                   PromotedCategory = Process;
                   RunObject = Page "Model Version Sales Prices";
                   RunPageLink = "Item No." = field("No.");
                   RunPageView = sorting("Item No.");
               }*/
            /* action(SalesLineDiscounts)
             {
                 ApplicationArea = Basic;
                 Caption = 'Sales Line Discounts';
                 Image = SalesLineDisc;
                 //Promoted = false;
                 //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                 //PromotedCategory = Process;
                 RunObject = Page "Sales Line Discounts";
                 RunPageLink = Type = const(Item),
                               Code = field("No.");
                 RunPageView = sorting(Type, Code);
             }*/
            action(RequisitionWorksheet)
            {
                ApplicationArea = Basic;
                Caption = 'Requisition Worksheet';
                Image = Worksheet;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Req. Worksheet";
            }
            action(ItemJournal)
            {
                ApplicationArea = Basic;
                Caption = 'Item Journal';
                Image = Journals;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Item Journal";
            }
            action(ItemReclassificationJournal)
            {
                ApplicationArea = Basic;
                Caption = 'Item Reclassification Journal';
                Image = Journals;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Item Reclass. Journal";
            }
            action(ItemTracing)
            {
                ApplicationArea = Basic;
                Caption = 'Item Tracing';
                Image = ItemTracing;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Page "Item Tracing";
            }
            action(AdjustItemCostPrice)
            {
                ApplicationArea = Basic;
                Caption = 'Adjust Item Cost/Price';
                Image = AdjustItemCost;
                Promoted = false;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Process;
                RunObject = Report "Adjust Item Costs/Prices";
            }
            action(AdjustCostItemEntries)
            {
                ApplicationArea = Basic;
                Caption = 'Adjust Cost - Item Entries';
                Image = AdjustEntries;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Report "Adjust Cost - Item Entries";
            }
        }

    }


    procedure GetSelectionFilter(): Code[80]
    var
        Item: Record Item;
        FirstItem: Code[30];
        LastItem: Code[30];
        SelectionFilter: Code[250];
        ItemCount: Integer;
        More: Boolean;
    begin
        CurrPage.SetSelectionFilter(Item);
        ItemCount := Item.Count;
        if ItemCount > 0 then begin
            Item.FindSet;
            while ItemCount > 0 do begin
                ItemCount := ItemCount - 1;
                Item.MarkedOnly(false);
                FirstItem := Item."No.";
                LastItem := FirstItem;
                More := (ItemCount > 0);
                while More do
                    if Item.Next = 0 then
                        More := false
                    else
                        if not Item.Mark then
                            More := false
                        else begin
                            LastItem := Item."No.";
                            ItemCount := ItemCount - 1;
                            if ItemCount = 0 then
                                More := false;
                        end;
                if SelectionFilter <> '' then
                    SelectionFilter := SelectionFilter + '|';
                if FirstItem = LastItem then
                    SelectionFilter := SelectionFilter + FirstItem
                else
                    SelectionFilter := SelectionFilter + FirstItem + '..' + LastItem;
                if ItemCount > 0 then begin
                    Item.MarkedOnly(true);
                    Item.Next;
                end;
            end;
        end;
        exit(SelectionFilter);
    end;


    procedure SetSelection(var Item: Record Item)
    begin
        CurrPage.SetSelectionFilter(Item);
    end;
}

