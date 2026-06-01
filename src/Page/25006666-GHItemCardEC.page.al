page 25006666 "GH Item Card EC"
{
    Caption = 'Item Card';
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Item,History,Prices & Discounts,Approve,Request Approval';
    RefreshOnActivate = true;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            group(Item)
            {
                Caption = 'Item';
                field("No."; Rec."No.")
                {
                    ApplicationArea = All;
                    Importance = Standard;
                    ToolTip = 'Specifies the number of the involved entry or record, according to the specified number series.';
                    Visible = NoFieldVisible;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit then
                            CurrPage.Update();
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                    ToolTip = 'Specifies a description of the item.';
                    Visible = DescriptionFieldVisible;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies that the related record is blocked from being posted in transactions, for example an item that is placed in quarantine.';
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies if the item card represents a physical inventory unit (Inventory), a labor time unit (Service), or a physical unit that is not tracked in inventory (Non-Inventory).';

                    trigger OnValidate()
                    begin
                        EnableControls;
                    end;
                }
                field("Base Unit of Measure"; Rec."Base Unit of Measure")
                {
                    ApplicationArea = Basic, Suite, Invoicing;
                    Importance = Promoted;
                    ShowMandatory = true;
                    ToolTip = 'Specifies the base unit used to measure the item, such as piece, box, or pallet. The base unit of measure also serves as the conversion basis for alternate units of measure.';

                    trigger OnValidate()
                    begin
                        CurrPage.Update(true);
                        Rec.Get(Rec."No.");
                    end;
                }
                field("Last Date Modified"; Rec."Last Date Modified")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies when the item card was last modified.';
                }
                field(GTIN; Rec.GTIN)
                {
                    ApplicationArea = Basic, Suite;
                    Enabled = NOT IsService;
                    Importance = Additional;
                    ToolTip = 'Specifies the Global Trade Item Number (GTIN) for the item. For example, the GTIN is used with bar codes to track items, and when sending and receiving documents electronically. The GTIN number typically contains a Universal Product Code (UPC), or European Article Number (EAN).';
                }
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the make code this item belongs to.';
                }
                field("Item Category Code"; Rec."Item Category Code")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the category that the item belongs to. Item categories also contain any assigned item attributes.';

                    trigger OnValidate()
                    begin
                        CurrPage.ItemAttributesFactbox.PAGE.LoadItemAttributesData(Rec."No.");
                        EnableCostingControls;
                    end;
                }
                field("Service Item Group"; Rec."Service Item Group")
                {
                    ApplicationArea = Service;
                    Importance = Additional;
                    ToolTip = 'Specifies the code of the service item group that the item belongs to.';
                }
                field("Automatic Ext. Texts"; Rec."Automatic Ext. Texts")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies that an extended text that you have set up will be added automatically on sales or purchase documents for this item.';
                }
                field("Common Item No."; Rec."Common Item No.")
                {
                    ApplicationArea = Intercompany;
                    Importance = Additional;
                    ToolTip = 'Specifies the unique common item number that the intercompany partners agree upon.';
                }
                field(Returnable; Rec.Returnable)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                    ToolTip = 'Specifies if this item is returnable.';
                }
                field(Discontinued; Rec.Discontinued)
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    Editable = false;
                    Importance = Additional;
                    ToolTip = 'Specifies if this item is discountinued. This information is retrieved from item substitution entries of type Discontinued.';

                    trigger OnAssistEdit()
                    var
                        ItemSubstitutionEntry: Page "Item Substitution Entry";
                        ItemSubstitution: Record "Item Substitution";
                    begin
                        Rec.CalcFields("Nonstock Entry No.");
                        ItemSubstitution.Reset;
                        ItemSubstitution.SetRange("No.", Rec."Nonstock Entry No.");
                        ItemSubstitution.SetRange("Entry Type", ItemSubstitution."entry type"::Discontinued);
                        ItemSubstitution.SetRange(Type, ItemSubstitution.Type::"Nonstock Item");
                        ItemSubstitutionEntry.SetTableview(ItemSubstitution);
                        ItemSubstitutionEntry.Run;
                    end;
                }
                field(ABCCategory; Rec."ABC Category")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the ABC code this item belongs to. There is a process to update ABC categories for items and calculation is done based on number of sales cases for the item in selected period of time.';
                }
                field("Purchasing Code"; Rec."Purchasing Code")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the code for a special procurement method, such as drop shipment.';
                }
            }
            group(InventoryGrp)
            {
                Caption = 'Inventory';
                Visible = IsInventoriable;
                field("Shelf No."; Rec."Shelf No.")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies where to find the item in the warehouse. This is informational only.';
                }
                field("Created From Nonstock Item"; Rec."Created From Nonstock Item")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies that the item was created from a catalog item.';
                }
                field("Search Description"; Rec."Search Description")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies a search description that you use to find the item in lists.';
                }
                field(Inventory; Rec.Inventory)
                {
                    ApplicationArea = Basic, Suite;
                    Enabled = IsInventoriable;
                    HideValue = IsNonInventoriable;
                    Importance = Promoted;
                    ToolTip = 'Specifies how many units, such as pieces, boxes, or cans, of the item are in inventory.';
                    Visible = IsFoundationEnabled;

                    trigger OnAssistEdit()
                    var
                        AdjustInventory: Page "Adjust Inventory";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);

                        if RecRef.IsDirty() then begin
                            Rec.Modify(true);
                            Commit();
                        end;

                        AdjustInventory.SetItem(Rec."No.");
                        if AdjustInventory.RunModal() in [ACTION::LookupOK, ACTION::OK] then
                            Rec.Get(Rec."No.");
                        CurrPage.Update()
                    end;
                }
                field(InventoryNonFoundation; Rec.Inventory)
                {
                    ApplicationArea = Basic, Suite;
                    AssistEdit = false;
                    Caption = 'Inventory';
                    Enabled = IsInventoriable;
                    Importance = Promoted;
                    ToolTip = 'Specifies how many units, such as pieces, boxes, or cans, of the item are in inventory.';
                    Visible = NOT IsFoundationEnabled;
                }
                field("Qty. on Purch. Order"; Rec."Qty. on Purch. Order")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies how many units of the item are inbound on purchase orders, meaning listed on outstanding purchase order lines.';
                }
                field("Qty. on Prod. Order"; Rec."Qty. on Prod. Order")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies how many units of the item are allocated to production orders, meaning listed on outstanding production order lines.';
                }
                field("Qty. on Component Lines"; Rec."Qty. on Component Lines")
                {
                    ApplicationArea = Manufacturing;
                    ToolTip = 'Specifies how many units of the item are allocated as production order components, meaning listed under outstanding production order lines.';
                }
                field("Qty. on Sales Order"; Rec."Qty. on Sales Order")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies how many units of the item are allocated to sales orders, meaning listed on outstanding sales orders lines.';
                }
                field("Qty. on Service Order"; Rec."Qty. on Service Order")
                {
                    ApplicationArea = Service;
                    Importance = Additional;
                    ToolTip = 'Specifies how many units of the item are allocated to service orders, meaning listed on outstanding service order lines.';
                }
                field(QtyonServiceOrderEDMS; Rec."Qty. on Service Order EDMS")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies how many units of the item are allocated to EDMS service orders, meaning listed on service order lines.';
                }
                field("Qty. on Job Order"; Rec."Qty. on Job Order")
                {
                    ApplicationArea = Jobs;
                    Importance = Additional;
                    ToolTip = 'Specifies how many units of the item are allocated to jobs, meaning listed on outstanding job planning lines.';
                }
                field("Qty. on Assembly Order"; Rec."Qty. on Assembly Order")
                {
                    ApplicationArea = Assembly;
                    Importance = Additional;
                    ToolTip = 'Specifies how many units of the item are allocated to assembly orders, which is how many are listed on outstanding assembly order headers.';
                }
                field("Qty. on Asm. Component"; Rec."Qty. on Asm. Component")
                {
                    ApplicationArea = Assembly;
                    Importance = Additional;
                    ToolTip = 'Specifies how many units of the item are allocated as assembly components, which means how many are listed on outstanding assembly order lines.';
                }
                field(StockoutWarningDefaultYes; Rec."Stockout Warning")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Stockout Warning';
                    Editable = IsInventoriable;
                    OptionCaption = 'Default (Yes),No,Yes';
                    ToolTip = 'Specifies if a warning is displayed when you enter a quantity on a sales document that brings the item''s inventory below zero.';
                    Visible = ShowStockoutWarningDefaultYes;
                }
                field(StockoutWarningDefaultNo; Rec."Stockout Warning")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Stockout Warning';
                    OptionCaption = 'Default (No),No,Yes';
                    ToolTip = 'Specifies if a warning is displayed when you enter a quantity on a sales document that brings the item''s inventory below zero.';
                    Visible = ShowStockoutWarningDefaultNo;
                }
                field(PreventNegInventoryDefaultYes; Rec."Prevent Negative Inventory")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Prevent Negative Inventory';
                    Importance = Additional;
                    OptionCaption = 'Default (Yes),No,Yes';
                    ToolTip = 'Specifies if you can post a transaction that will bring the item''s inventory below zero.';
                    Visible = ShowPreventNegInventoryDefaultYes;
                }
                field(PreventNegInventoryDefaultNo; Rec."Prevent Negative Inventory")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Prevent Negative Inventory';
                    Importance = Additional;
                    OptionCaption = 'Default (No),No,Yes';
                    ToolTip = 'Specifies if you can post a transaction that will bring the item''s inventory below zero.';
                    Visible = ShowPreventNegInventoryDefaultNo;
                }
                field("Net Weight"; Rec."Net Weight")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the net weight of the item.';
                }
                field("Gross Weight"; Rec."Gross Weight")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the gross weight of the item.';
                }
                field("Unit Volume"; Rec."Unit Volume")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the volume of one unit of the item.';
                }
                field("Over-Receipt Code"; Rec."Over-Receipt Code")
                {
                    ApplicationArea = All;
                    Visible = true;
                    ToolTip = 'Specifies the policy that will be used for the item if more items than ordered are received.';
                }
            }
            group("Costs & Posting")
            {
                Caption = 'Costs & Posting';
                group("Cost Details")
                {
                    Caption = 'Cost Details';
                    field("Costing Method"; Rec."Costing Method")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies how the item''s cost flow is recorded and whether an actual or budgeted value is capitalized and used in the cost calculation.';

                        trigger OnValidate()
                        begin
                            EnableCostingControls;
                        end;
                    }
                    field("Standard Cost"; Rec."Standard Cost")
                    {
                        ApplicationArea = Basic, Suite;
                        Enabled = StandardCostEnable;
                        ToolTip = 'Specifies the unit cost that is used as an estimation to be adjusted with variances later. It is typically used in assembly and production where costs can vary.';

                        trigger OnDrillDown()
                        var
                            ShowAvgCalcItem: Codeunit "Show Avg. Calc. - Item";
                        begin
                            ShowAvgCalcItem.DrillDownAvgCostAdjmtPoint(Rec)
                        end;
                    }
                    field("Unit Cost"; Rec."Unit Cost")
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = UnitCostEditable;
                        Enabled = UnitCostEnable;
                        Importance = Promoted;
                        ToolTip = 'Specifies the cost of one unit of the item or resource on the line.';

                        trigger OnDrillDown()
                        var
                            ShowAvgCalcItem: Codeunit "Show Avg. Calc. - Item";
                        begin
                            ShowAvgCalcItem.DrillDownAvgCostAdjmtPoint(Rec)
                        end;
                    }
                    field("Indirect Cost %"; Rec."Indirect Cost %")
                    {
                        ApplicationArea = Basic, Suite;
                        Enabled = IsInventoriable;
                        Importance = Additional;
                        ToolTip = 'Specifies the percentage of the item''s last purchase cost that includes indirect costs, such as freight that is associated with the purchase of the item.';
                    }
                    field("Last Direct Cost"; Rec."Last Direct Cost")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                        ToolTip = 'Specifies the most recent direct unit cost of the item.';
                    }
                    field("Net Invoiced Qty."; Rec."Net Invoiced Qty.")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies how many units of the item in inventory have been invoiced.';
                    }
                    field("Cost is Adjusted"; Rec."Cost is Adjusted")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies whether the item''s unit cost has been adjusted, either automatically or manually.';
                    }
                    field("Cost is Posted to G/L"; Rec."Cost is Posted to G/L")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                        ToolTip = 'Specifies that all the inventory costs for this item have been posted to the general ledger.';
                    }
                    field(SpecialPurchPriceListTxt; PurchPriceListsText)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Purchase Prices & Discounts';
                        Editable = false;
                        Visible = ExtendedPriceEnabled;
                        ToolTip = 'Specifies purchase price lists for the item.';

                        trigger OnDrillDown()
                        var
                            AmountType: Enum "Price Amount Type";
                            PriceType: Enum "Price Type";
                        begin
                            if PurchPriceListsText = ViewExistingTxt then
                                Rec.ShowPriceListLines(PriceType::Purchase, AmountType::Any)
                            else
                                PAGE.RunModal(PAGE::"Purchase Price Lists");
                            UpdateSpecialPriceListsTxt(PriceType::Purchase);
                        end;
                    }
                    field(SpecialPurchPricesAndDiscountsTxt; SpecialPurchPricesAndDiscountsTxt)
                    {
                        ApplicationArea = Suite;
                        Caption = 'Purchase Prices & Discounts';
                        Editable = false;
                        Visible = not ExtendedPriceEnabled;
                        ToolTip = 'Specifies purchase prices and line discounts for the item.';
                        ObsoleteState = Pending;
                        ObsoleteReason = 'Replaced by the new implementation (V16) of price calculation.';
                        ObsoleteTag = '17.0';

                        trigger OnDrillDown()
                        var
                            PurchasePrice: Record "Purchase Price";
                            PurchaseLineDiscount: Record "Purchase Line Discount";
                            PurchasesPriceAndLineDisc: Page "Purchases Price and Line Disc.";
                        begin
                            if SpecialPurchPricesAndDiscountsTxt = ViewExistingTxt then begin
                                PurchasesPriceAndLineDisc.LoadItem(Rec);
                                PurchasesPriceAndLineDisc.RunModal;
                                exit;
                            end;

                            case StrMenu(StrSubstNo('%1,%2', CreateNewSpecialPriceTxt, CreateNewSpecialDiscountTxt), 1, '') of
                                1:
                                    begin
                                        PurchasePrice.SetRange("Item No.", Rec."No.");
                                        PAGE.RunModal(PAGE::"Purchase Prices", PurchasePrice);
                                    end;
                                2:
                                    begin
                                        PurchaseLineDiscount.SetRange("Item No.", Rec."No.");
                                        PAGE.RunModal(PAGE::"Purchase Line Discounts", PurchaseLineDiscount);
                                    end;
                            end;

                            UpdateSpecialPricesAndDiscountsTxt;
                        end;
                    }
                }
                group("Posting Details")
                {
                    Caption = 'Posting Details';
                    field("Gen. Prod. Posting Group"; Rec."Gen. Prod. Posting Group")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Promoted;
                        ShowMandatory = true;
                        ToolTip = 'Specifies the item''s product type to link transactions made for this item with the appropriate general ledger account according to the general posting setup.';
                    }
                    field("VAT Prod. Posting Group"; Rec."VAT Prod. Posting Group")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                        ShowMandatory = true;
                        ToolTip = 'Specifies the VAT specification of the involved item or resource to link transactions made for this record with the appropriate general ledger account according to the VAT posting setup.';
                    }
                    field("Tax Group Code"; Rec."Tax Group Code")
                    {
                        ApplicationArea = SalesTax;
                        Importance = Promoted;
                        ToolTip = 'Specifies the tax group that is used to calculate and post sales tax.';
                    }
                    field("Inventory Posting Group"; Rec."Inventory Posting Group")
                    {
                        ApplicationArea = Basic, Suite;
                        Editable = IsInventoriable;
                        Importance = Promoted;
                        ShowMandatory = IsInventoriable;
                        ToolTip = 'Specifies links between business transactions made for the item and an inventory account in the general ledger, to group amounts for that item type.';
                    }
                    field("Default Deferral Template Code"; Rec."Default Deferral Template Code")
                    {
                        ApplicationArea = Suite;
                        Caption = 'Default Deferral Template';
                        ToolTip = 'Specifies how revenue or expenses for the item are deferred to other accounting periods by default.';
                    }
                }
                group(ForeignTrade)
                {
                    Caption = 'Foreign Trade';
                    field("Tariff No."; Rec."Tariff No.")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies a code for the item''s tariff number.';
                    }
                    field("Country/Region of Origin Code"; Rec."Country/Region of Origin Code")
                    {
                        ApplicationArea = Basic, Suite;
                        Importance = Additional;
                        ToolTip = 'Specifies a code for the country/region where the item was produced or processed.';
                    }
                }
            }
            group("Prices & Sales")
            {
                Caption = 'Prices & Sales';
                field("Unit Price"; Rec."Unit Price")
                {
                    ApplicationArea = Basic, Suite, Invoicing;
                    Editable = PriceEditable;
                    Importance = Promoted;
                    ToolTip = 'Specifies the price of one unit of the item or resource. You can enter a price manually or have it entered according to the Price/Profit Calculation field on the related card.';
                }
                field(CalcUnitPriceExclVAT; Rec.CalcUnitPriceExclVAT)
                {
                    ApplicationArea = Basic, Suite;
                    CaptionClass = '2,0,' + Rec.FieldCaption("Unit Price");
                    Importance = Additional;
                    ToolTip = 'Specifies the unit price excluding VAT.';
                }
                field("Price Includes VAT"; Rec."Price Includes VAT")
                {
                    ApplicationArea = VAT;
                    Importance = Additional;
                    ToolTip = 'Specifies if the Unit Price and Line Amount fields on sales document lines for this item should be shown with or without VAT.';

                    trigger OnValidate()
                    begin
                        if Rec."Price Includes VAT" = xRec."Price Includes VAT" then
                            exit;
                    end;
                }
                field("Price/Profit Calculation"; Rec."Price/Profit Calculation")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the relationship between the Unit Cost, Unit Price, and Profit Percentage fields associated with this item.';

                    trigger OnValidate()
                    begin
                        EnableControls;
                    end;
                }
                field("Profit %"; Rec."Profit %")
                {
                    ApplicationArea = Basic, Suite;
                    DecimalPlaces = 2 : 2;
                    Editable = ProfitEditable;
                    ToolTip = 'Specifies the profit margin that you want to sell the item at. You can enter a profit percentage manually or have it entered according to the Price/Profit Calculation field';
                }
                field(SpecialSalesPriceListTxt; SalesPriceListsText)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Prices & Discounts';
                    Editable = false;
                    Visible = ExtendedPriceEnabled;
                    ToolTip = 'Specifies sales price lists for the item.';

                    trigger OnDrillDown()
                    var
                        AmountType: Enum "Price Amount Type";
                        PriceType: Enum "Price Type";
                    begin
                        if SalesPriceListsText = ViewExistingTxt then
                            Rec.ShowPriceListLines(PriceType::Sale, AmountType::Any)
                        else
                            PAGE.RunModal(PAGE::"Sales Price Lists");
                        UpdateSpecialPriceListsTxt(PriceType::Sale);
                    end;
                }
                field(SpecialPricesAndDiscountsTxt; SpecialPricesAndDiscountsTxt)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Prices & Discounts';
                    Editable = false;
                    Visible = not ExtendedPriceEnabled;
                    ToolTip = 'Specifies sales prices and line discounts for the item.';
                    ObsoleteState = Pending;
                    ObsoleteReason = 'Replaced by the new implementation (V16) of price calculation.';
                    ObsoleteTag = '16.0';

                    trigger OnDrillDown()
                    var
                        SalesPrice: Record "Sales Price";
                        SalesLineDiscount: Record "Sales Line Discount";
                        SalesPriceAndLineDiscounts: Page "Sales Price and Line Discounts";
                    begin
                        if SpecialPricesAndDiscountsTxt = ViewExistingTxt then begin
                            SalesPriceAndLineDiscounts.InitPage(true);
                            SalesPriceAndLineDiscounts.LoadItem(Rec);
                            SalesPriceAndLineDiscounts.RunModal;
                            exit;
                        end;

                        case StrMenu(StrSubstNo('%1,%2', CreateNewSpecialPriceTxt, CreateNewSpecialDiscountTxt), 1, '') of
                            1:
                                begin
                                    SalesPrice.SetRange("Item No.", Rec."No.");
                                    PAGE.RunModal(PAGE::"Sales Prices", SalesPrice);
                                end;
                            2:
                                begin
                                    SalesLineDiscount.SetRange(Type, SalesLineDiscount.Type::Item);
                                    SalesLineDiscount.SetRange(Code, Rec."No.");
                                    PAGE.RunModal(PAGE::"Sales Line Discounts", SalesLineDiscount);
                                end;
                        end;

                        UpdateSpecialPricesAndDiscountsTxt;
                    end;
                }
                field("Allow Invoice Disc."; Rec."Allow Invoice Disc.")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies if the item should be included in the calculation of an invoice discount on documents where the item is traded.';
                }
                field("Item Disc. Group"; Rec."Item Disc. Group")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies an item group code that can be used as a criterion to grant a discount when the item is sold to a certain customer.';
                }
                field("Sales Unit of Measure"; Rec."Sales Unit of Measure")
                {
                    ApplicationArea = Suite;
                    ToolTip = 'Specifies the unit of measure code used when you sell the item.';
                }
                field("Sales Blocked"; Rec."Sales Blocked")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies that the item cannot be entered on sales documents, except return orders and credit memos, and journals.';
                }
                field("Application Wksh. User ID"; Rec."Application Wksh. User ID")
                {
                    ApplicationArea = Basic, Suite;
                    Importance = Additional;
                    ToolTip = 'Specifies the ID of a user who is working in the Application Worksheet window.';
                    Visible = false;
                }
                field("VAT Bus. Posting Gr. (Price)"; Rec."VAT Bus. Posting Gr. (Price)")
                {
                    ApplicationArea = Advanced;
                    ToolTip = 'Specifies the VAT business posting group for customers for whom you want the sales price including VAT to apply.';
                }
            }
            group(Replenishment)
            {
                Caption = 'Replenishment';
                field("Replenishment System"; ItemReplenishmentSystem)
                {
                    ApplicationArea = Assembly, Planning;
                    Caption = 'Replenishment System';
                    Importance = Promoted;
                    ToolTip = 'Specifies the type of supply order created by the planning system when the item needs to be replenished.';

                    trigger OnValidate()
                    begin
                        Rec.Validate("Replenishment System", ItemReplenishmentSystem);
                    end;
                }
                field("Lead Time Calculation"; Rec."Lead Time Calculation")
                {
                    ApplicationArea = Assembly, Planning;
                    ToolTip = 'Specifies a date formula for the amount of time it takes to replenish the item.';
                }
                group(Purchase)
                {
                    Caption = 'Purchase';
                    field("Vendor No."; Rec."Vendor No.")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies the vendor code of who supplies this item by default.';
                    }
                    field("Vendor Item No."; Rec."Vendor Item No.")
                    {
                        ApplicationArea = Planning;
                        ToolTip = 'Specifies the number that the vendor uses for this item.';
                    }
                    field("Purch. Unit of Measure"; Rec."Purch. Unit of Measure")
                    {
                        ApplicationArea = Planning;
                        ToolTip = 'Specifies the unit of measure code used when you purchase the item.';
                    }
                    field("Purchasing Blocked"; Rec."Purchasing Blocked")
                    {
                        ApplicationArea = Basic, Suite;
                        ToolTip = 'Specifies that the item cannot be entered on purchase documents, except return orders and credit memos, and journals.';
                    }
                }
                group(Replenishment_Production)
                {
                    Caption = 'Production';
                    field("Manufacturing Policy"; Rec."Manufacturing Policy")
                    {
                        ApplicationArea = Manufacturing;
                        ToolTip = 'Specifies if additional orders for any related components are calculated.';
                    }
                    field("Routing No."; Rec."Routing No.")
                    {
                        ApplicationArea = Manufacturing;
                        ToolTip = 'Specifies the number of the production routing that the item is used in.';
                    }
                    field("Production BOM No."; Rec."Production BOM No.")
                    {
                        ApplicationArea = Manufacturing;
                        ToolTip = 'Specifies the number of the production BOM that the item represents.';
                    }
                    field("Rounding Precision"; Rec."Rounding Precision")
                    {
                        ApplicationArea = Manufacturing;
                        ToolTip = 'Specifies how calculated consumption quantities are rounded when entered on consumption journal lines.';
                    }
                    field("Flushing Method"; Rec."Flushing Method")
                    {
                        ApplicationArea = Manufacturing;
                        ToolTip = 'Specifies how consumption of the item (component) is calculated and handled in production processes. Manual: Enter and post consumption in the consumption journal manually. Forward: Automatically posts consumption according to the production order component lines when the first operation starts. Backward: Automatically calculates and posts consumption according to the production order component lines when the production order is finished. Pick + Forward / Pick + Backward: Variations with warehousing.';
                    }
                    field("Overhead Rate"; Rec."Overhead Rate")
                    {
                        ApplicationArea = Manufacturing;
                        Enabled = IsInventoriable;
                        Importance = Additional;
                        ToolTip = 'Specifies the item''s indirect cost as an absolute amount.';
                    }
                    field("Scrap %"; Rec."Scrap %")
                    {
                        ApplicationArea = Manufacturing;
                        ToolTip = 'Specifies the percentage of the item that you expect to be scrapped in the production process.';
                    }
                    field("Lot Size"; Rec."Lot Size")
                    {
                        ApplicationArea = Manufacturing;
                        ToolTip = 'Specifies the default number of units of the item that are processed in one production operation. This affects standard cost calculations and capacity planning. If the item routing includes fixed costs such as setup time, the value in this field is used to calculate the standard cost and distribute the setup costs. During demand planning, this value is used together with the value in the Default Dampener % field to ignore negligible changes in demand and avoid re-planning. Note that if you leave the field blank, it will be threated as 1.';
                    }
                }
                group(Replenishment_Assembly)
                {
                    Caption = 'Assembly';
                    field("Assembly Policy"; Rec."Assembly Policy")
                    {
                        ApplicationArea = Assembly;
                        ToolTip = 'Specifies which default order flow is used to supply this assembly item.';
                    }
                    field(AssemblyBOM; Rec."Assembly BOM")
                    {
                        AccessByPermission = TableData "BOM Component" = R;
                        ApplicationArea = Assembly;
                        ToolTip = 'Specifies if the item is an assembly BOM.';

                        trigger OnDrillDown()
                        var
                            BOMComponent: Record "BOM Component";
                        begin
                            Commit();
                            BOMComponent.SetRange("Parent Item No.", Rec."No.");
                            PAGE.Run(PAGE::"Assembly BOM", BOMComponent);
                            CurrPage.Update();
                        end;
                    }
                }
            }
            group(Planning)
            {
                Caption = 'Planning';
                field("Reordering Policy"; Rec."Reordering Policy")
                {
                    ApplicationArea = Planning;
                    Importance = Promoted;
                    ToolTip = 'Specifies the reordering policy.';

                    trigger OnValidate()
                    begin
                        EnablePlanningControls();
                    end;
                }
                field(Reserve; Rec.Reserve)
                {
                    ApplicationArea = Reservation;
                    Importance = Additional;
                    ToolTip = 'Specifies if and how the item will be reserved. Never: It is not possible to reserve the item. Optional: You can reserve the item manually. Always: The item is automatically reserved from demand, such as sales orders, against inventory, purchase orders, assembly orders, and production orders.';
                }
                field("Order Tracking Policy"; Rec."Order Tracking Policy")
                {
                    ApplicationArea = Planning;
                    Importance = Promoted;
                    ToolTip = 'Specifies if and how order tracking entries are created and maintained between supply and its corresponding demand.';
                }
                field("Stockkeeping Unit Exists"; Rec."Stockkeeping Unit Exists")
                {
                    ApplicationArea = Planning;
                    ToolTip = 'Specifies that a stockkeeping unit exists for this item.';
                }
                field("Dampener Period"; Rec."Dampener Period")
                {
                    ApplicationArea = Planning;
                    Enabled = DampenerPeriodEnable;
                    Importance = Additional;
                    ToolTip = 'Specifies a period of time during which you do not want the planning system to propose to reschedule existing supply orders forward. The dampener period limits the number of insignificant rescheduling of existing supply to a later date if that new date is within the dampener period. The dampener period function is only initiated if the supply can be rescheduled to a later date and not if the supply can be rescheduled to an earlier date. Accordingly, if the suggested new supply date is after the dampener period, then the rescheduling suggestion is not blocked. If the lot accumulation period is less than the dampener period, then the dampener period is dynamically set to equal the lot accumulation period. This is not shown in the value that you enter in the Dampener Period field. The last demand in the lot accumulation period is used to determine whether a potential supply date is in the dampener period. If this field is empty, then the value in the Default Dampener Period field in the Manufacturing Setup window applies. The value that you enter in the Dampener Period field must be a date formula, and one day (1D) is the shortest allowed period.';
                }
                field("Dampener Quantity"; Rec."Dampener Quantity")
                {
                    ApplicationArea = Planning;
                    Enabled = DampenerQtyEnable;
                    Importance = Additional;
                    ToolTip = 'Specifies a dampener quantity to block insignificant change suggestions for an existing supply, if the change quantity is lower than the dampener quantity.';
                }
                field(Critical; Rec.Critical)
                {
                    ApplicationArea = OrderPromising;
                    ToolTip = 'Specifies if the item is included in availability calculations to promise a shipment date for its parent item.';
                }
                field("Safety Lead Time"; Rec."Safety Lead Time")
                {
                    ApplicationArea = Planning;
                    Enabled = SafetyLeadTimeEnable;
                    ToolTip = 'Specifies a date formula to indicate a safety lead time that can be used as a buffer period for production and other delays.';
                }
                field("Safety Stock Quantity"; Rec."Safety Stock Quantity")
                {
                    ApplicationArea = Planning;
                    Enabled = SafetyStockQtyEnable;
                    ToolTip = 'Specifies a quantity of stock to have in inventory to protect against supply-and-demand fluctuations during replenishment lead time.';
                }
                group(LotForLotParameters)
                {
                    Caption = 'Lot-for-Lot Parameters';
                    field("Include Inventory"; Rec."Include Inventory")
                    {
                        ApplicationArea = Planning;
                        Enabled = IncludeInventoryEnable;
                        ToolTip = 'Specifies that the inventory quantity is included in the projected available balance when replenishment orders are calculated.';

                        trigger OnValidate()
                        begin
                            EnablePlanningControls
                        end;
                    }
                    field("Lot Accumulation Period"; Rec."Lot Accumulation Period")
                    {
                        ApplicationArea = Planning;
                        Enabled = LotAccumulationPeriodEnable;
                        ToolTip = 'Specifies a period in which multiple demands are accumulated into one supply order when you use the Lot-for-Lot reordering policy.';
                    }
                    field("Rescheduling Period"; Rec."Rescheduling Period")
                    {
                        ApplicationArea = Planning;
                        Enabled = ReschedulingPeriodEnable;
                        ToolTip = 'Specifies a period within which any suggestion to change a supply date always consists of a Reschedule action and never a Cancel + New action.';
                    }
                }
                group(ReorderPointParameters)
                {
                    Caption = 'Reorder-Point Parameters';
                    group(Control64)
                    {
                        ShowCaption = false;
                        field("Reorder Point"; Rec."Reorder Point")
                        {
                            ApplicationArea = Planning;
                            Enabled = ReorderPointEnable;
                            ToolTip = 'Specifies a stock quantity that sets the inventory below the level that you must replenish the item.';
                        }
                        field("Reorder Quantity"; Rec."Reorder Quantity")
                        {
                            ApplicationArea = Planning;
                            Enabled = ReorderQtyEnable;
                            ToolTip = 'Specifies a standard lot size quantity to be used for all order proposals.';
                        }
                        field("Maximum Inventory"; Rec."Maximum Inventory")
                        {
                            ApplicationArea = Planning;
                            Enabled = MaximumInventoryEnable;
                            ToolTip = 'Specifies a quantity that you want to use as a maximum inventory level.';
                        }
                    }
                    field("Overflow Level"; Rec."Overflow Level")
                    {
                        ApplicationArea = Planning;
                        Enabled = OverflowLevelEnable;
                        Importance = Additional;
                        ToolTip = 'Specifies a quantity you allow projected inventory to exceed the reorder point, before the system suggests to decrease supply orders.';
                    }
                    field("Time Bucket"; Rec."Time Bucket")
                    {
                        ApplicationArea = Planning;
                        Enabled = TimeBucketEnable;
                        Importance = Additional;
                        ToolTip = 'Specifies a time period that defines the recurring planning horizon used with Fixed Reorder Qty. or Maximum Qty. reordering policies.';
                    }
                }
                group(OrderModifiers)
                {
                    Caption = 'Order Modifiers';
                    group(Control61)
                    {
                        ShowCaption = false;
                        field("Minimum Order Quantity"; Rec."Minimum Order Quantity")
                        {
                            ApplicationArea = Planning;
                            Enabled = MinimumOrderQtyEnable;
                            ToolTip = 'Specifies a minimum allowable quantity for an item order proposal.';
                        }
                        field("Maximum Order Quantity"; Rec."Maximum Order Quantity")
                        {
                            ApplicationArea = Planning;
                            Enabled = MaximumOrderQtyEnable;
                            ToolTip = 'Specifies a maximum allowable quantity for an item order proposal.';
                        }
                        field("Order Multiple"; Rec."Order Multiple")
                        {
                            ApplicationArea = Planning;
                            Enabled = OrderMultipleEnable;
                            ToolTip = 'Specifies a parameter used by the planning system to modify the quantity of planned supply orders.';
                        }
                    }
                }
            }
            group(ItemTracking)
            {
                Caption = 'Item Tracking';
                field("Item Tracking Code"; Rec."Item Tracking Code")
                {
                    ApplicationArea = ItemTracking;
                    Importance = Promoted;
                    ToolTip = 'Specifies how serial or lot numbers assigned to the item are tracked in the supply chain.';

                    trigger OnValidate()
                    begin
                        SetExpirationCalculationEditable;
                    end;
                }
                field("Serial Nos."; Rec."Serial Nos.")
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies a number series code to assign consecutive serial numbers to items produced.';
                }
                field("Lot Nos."; Rec."Lot Nos.")
                {
                    ApplicationArea = ItemTracking;
                    ToolTip = 'Specifies the number series code that will be used when assigning lot numbers.';
                }
                field("Expiration Calculation"; Rec."Expiration Calculation")
                {
                    ApplicationArea = ItemTracking;
                    Editable = ExpirationCalculationEditable;
                    ToolTip = 'Specifies the date formula for calculating the expiration date on the item tracking line. Note: This field will be ignored if the involved item has Require Expiration Date Entry set to Yes on the Item Tracking Code page.';

                    trigger OnValidate()
                    begin
                        Rec.Validate("Item Tracking Code");
                    end;
                }
            }
            group(Warehouse)
            {
                Caption = 'Warehouse';
                field("Warehouse Class Code"; Rec."Warehouse Class Code")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the warehouse class code for the item.';
                }
                field("Special Equipment Code"; Rec."Special Equipment Code")
                {
                    ApplicationArea = Warehouse;
                    Importance = Additional;
                    ToolTip = 'Specifies the code of the equipment that warehouse employees must use when handling the item.';
                }
                field("Put-away Template Code"; Rec."Put-away Template Code")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the code of the put-away template by which the program determines the most appropriate zone and bin for storage of the item after receipt.';
                }
                field("Put-away Unit of Measure Code"; Rec."Put-away Unit of Measure Code")
                {
                    ApplicationArea = Warehouse;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code of the item unit of measure in which the program will put the item away.';
                }
                field("Phys Invt Counting Period Code"; Rec."Phys Invt Counting Period Code")
                {
                    ApplicationArea = Warehouse;
                    Importance = Promoted;
                    ToolTip = 'Specifies the code of the counting period that indicates how often you want to count the item in a physical inventory.';
                }
                field("Last Phys. Invt. Date"; Rec."Last Phys. Invt. Date")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the date on which you last posted the results of a physical inventory for the item to the item ledger.';
                }
                field("Last Counting Period Update"; Rec."Last Counting Period Update")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the last date on which you calculated the counting period. It is updated when you use the function Calculate Counting Period.';
                }
                field("Next Counting Start Date"; Rec."Next Counting Start Date")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the starting date of the next counting period.';
                }
                field("Next Counting End Date"; Rec."Next Counting End Date")
                {
                    ApplicationArea = Warehouse;
                    ToolTip = 'Specifies the ending date of the next counting period.';
                }
                field("Identifier Code"; Rec."Identifier Code")
                {
                    ApplicationArea = Advanced;
                    Importance = Additional;
                    ToolTip = 'Specifies a unique code for the item in terms that are useful for automatic data capture.';
                }
                field("Use Cross-Docking"; Rec."Use Cross-Docking")
                {
                    ApplicationArea = Warehouse;
                    Importance = Additional;
                    ToolTip = 'Specifies if this item can be cross-docked.';
                }
            }
        }
        area(factboxes)
        {
            part(ItemPicture; "Item Picture")
            {
                ApplicationArea = All;
                Caption = 'Picture';
                SubPageLink = "No." = FIELD("No."),
                              "Date Filter" = FIELD("Date Filter"),
                              "Global Dimension 1 Filter" = FIELD("Global Dimension 1 Filter"),
                              "Global Dimension 2 Filter" = FIELD("Global Dimension 2 Filter"),
                              "Location Filter" = FIELD("Location Filter"),
                              "Drop Shipment Filter" = FIELD("Drop Shipment Filter"),
                              "Variant Filter" = FIELD("Variant Filter");
            }
            part("Attached Documents"; "Doc. Attachment List Factbox")
            {
                ApplicationArea = All;
                Caption = 'Attachments';
                SubPageLink = "Table ID" = CONST(27),
                              "No." = FIELD("No.");
            }
            part(ItemAttributesFactbox; "Item Attributes Factbox")
            {
                ApplicationArea = Basic, Suite;
            }
            part(WorkflowStatus; "Workflow Status FactBox")
            {
                ApplicationArea = Suite;
                Editable = false;
                Enabled = false;
                ShowFilter = false;
                Visible = ShowWorkflowStatus;
            }
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }



    trigger OnAfterGetCurrRecord()
    var
        CRMCouplingManagement: Codeunit "CRM Coupling Management";
        WorkflowWebhookManagement: Codeunit "Workflow Webhook Management";
    begin
        CreateItemFromTemplate;

        EnableControls;
        if CRMIntegrationEnabled then begin
            CRMIsCoupledToRecord := CRMCouplingManagement.IsRecordCoupledToCRM(Rec.RecordId);
            if Rec."No." <> xRec."No." then
                CRMIntegrationManagement.SendResultNotification(Rec);
        end;
        OpenApprovalEntriesExistCurrUser := ApprovalsMgmt.HasOpenApprovalEntriesForCurrentUser(Rec.RecordId);
        OpenApprovalEntriesExist := ApprovalsMgmt.HasOpenApprovalEntries(Rec.RecordId);
        ShowWorkflowStatus := CurrPage.WorkflowStatus.PAGE.SetFilterOnWorkflowRecord(Rec.RecordId);

        WorkflowWebhookManagement.GetCanRequestAndCanCancel(Rec.RecordId, CanRequestApprovalForFlow, CanCancelApprovalForFlow);

        CurrPage.ItemAttributesFactbox.PAGE.LoadItemAttributesData(Rec."No.");

        ItemReplenishmentSystem := Rec."Replenishment System";
        SetDMSIntegrationActionsVisibility;   // ASMX
    end;

    trigger OnAfterGetRecord()
    begin
        ItemReplenishmentSystem := Rec."Replenishment System";
    end;

    trigger OnInit()
    var
        WorkflowManagement: Codeunit "Workflow Management";
        WorkflowEventHandling: Codeunit "Workflow Event Handling";
    begin
        InitControls;
        EventFilter := WorkflowEventHandling.RunWorkflowOnSendItemForApprovalCode + '|' +
          WorkflowEventHandling.RunWorkflowOnItemChangedCode;

        EnabledApprovalWorkflowsExist := WorkflowManagement.EnabledWorkflowExist(DATABASE::Item, EventFilter);
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        InsertItemUnitOfMeasure;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnNewRec;
        EnablePlanningControls;
        EnableCostingControls;
        //EDMS >>
        Rec."Item Type" := Rec."item type"::Item;
        //EDMS <<
    end;

    trigger OnOpenPage()
    var
        IntegrationTableMapping: Record "Integration Table Mapping";
        EnvironmentInfo: Codeunit "Environment Information";
        ItemReferenceMgt: Codeunit "Item Reference Management";
        FeatureManagementFacade: Codeunit "Feature Management Facade";
    begin
        IsFoundationEnabled := ApplicationAreaMgmtFacade.IsFoundationEnabled();
        SetNoFieldVisible();
        IsSaaS := EnvironmentInfo.IsSaaS();
        DescriptionFieldVisible := true;
        SetOverReceiptControlsVisibility();
        //ItemReferenceVisible := FeatureManagementFacade.IsEnabled();
        CRMIntegrationEnabled := CRMIntegrationManagement.IsCRMIntegrationEnabled();
        if CRMIntegrationEnabled then
            if IntegrationTableMapping.Get('ITEM-PRODUCT') then
                BlockedFilterApplied := IntegrationTableMapping.GetTableFilter().Contains('Field54=1(0)');
        ExtendedPriceEnabled := PriceCalculationMgt.IsExtendedPriceCalculationEnabled();

        EnableShowStockOutWarning;

        EnableShowShowEnforcePositivInventory;

        if CurrentClientType = ClientType::ODataV4 then
            EnableControls();

        OnAfterOnOpenPage();
    end;

    var
        ApplicationAreaMgmtFacade: Codeunit "Application Area Mgmt. Facade";
        CalculateStdCost: Codeunit "Calculate Standard Cost";
        CRMIntegrationManagement: Codeunit "CRM Integration Management";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        ApprovalsMgmt: Codeunit "Approvals Mgmt.";
        PriceCalculationMgt: Codeunit "Price Calculation Mgt.";
        SkilledResourceList: Page "Skilled Resource List";
        IsFoundationEnabled: Boolean;
        ShowStockoutWarningDefaultYes: Boolean;
        ShowStockoutWarningDefaultNo: Boolean;
        ShowPreventNegInventoryDefaultYes: Boolean;
        ShowPreventNegInventoryDefaultNo: Boolean;
        CRMIntegrationEnabled: Boolean;
        CRMIsCoupledToRecord: Boolean;
        BlockedFilterApplied: Boolean;
        OpenApprovalEntriesExistCurrUser: Boolean;
        OpenApprovalEntriesExist: Boolean;
        ShowWorkflowStatus: Boolean;
        ProfitEditable: Boolean;
        PriceEditable: Boolean;
        SalesPriceListsText: Text;
        PurchPriceListsText: Text;
        SpecialPricesAndDiscountsTxt: Text;
        CreateNewTxt: Label 'Create New...';
        ViewExistingTxt: Label 'View Existing Prices and Discounts...';
        CreateNewSpecialPriceTxt: Label 'Create New Special Price...';
        CreateNewSpecialDiscountTxt: Label 'Create New Special Discount...';
        SpecialPurchPricesAndDiscountsTxt: Text;

    protected var
        ItemReplenishmentSystem: Enum "Item Replenishment System";
        EnabledApprovalWorkflowsExist: Boolean;
        EventFilter: Text;
        NoFieldVisible: Boolean;
        DescriptionFieldVisible: Boolean;
        NewMode: Boolean;
        CanRequestApprovalForFlow: Boolean;
        CanCancelApprovalForFlow: Boolean;
        IsSaaS: Boolean;
        IsService: Boolean;
        IsNonInventoriable: Boolean;
        IsInventoriable: Boolean;
        ExpirationCalculationEditable: Boolean;
        OverReceiptAllowed: Boolean;
        [InDataSet]
        ItemReferenceVisible: Boolean;
        ExtendedPriceEnabled: Boolean;
        [InDataSet]
        TimeBucketEnable: Boolean;
        [InDataSet]
        SafetyLeadTimeEnable: Boolean;
        [InDataSet]
        SafetyStockQtyEnable: Boolean;
        [InDataSet]
        ReorderPointEnable: Boolean;
        [InDataSet]
        ReorderQtyEnable: Boolean;
        [InDataSet]
        MaximumInventoryEnable: Boolean;
        [InDataSet]
        MinimumOrderQtyEnable: Boolean;
        [InDataSet]
        MaximumOrderQtyEnable: Boolean;
        [InDataSet]
        OrderMultipleEnable: Boolean;
        [InDataSet]
        IncludeInventoryEnable: Boolean;
        [InDataSet]
        ReschedulingPeriodEnable: Boolean;
        [InDataSet]
        LotAccumulationPeriodEnable: Boolean;
        [InDataSet]
        DampenerPeriodEnable: Boolean;
        [InDataSet]
        DampenerQtyEnable: Boolean;
        [InDataSet]
        OverflowLevelEnable: Boolean;
        [InDataSet]
        StandardCostEnable: Boolean;
        [InDataSet]
        UnitCostEnable: Boolean;
        [InDataSet]
        UnitCostEditable: Boolean;
        ShowIntegrationActionGetPrice: Boolean;
        ShowIntegrationActionGetAvailability: Boolean;

    local procedure EnableControls()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
        PriceType: Enum "Price Type";
    begin
        IsService := Rec.IsServiceType;
        IsNonInventoriable := Rec.IsNonInventoriableType;
        IsInventoriable := Rec.IsInventoriableType;

        if IsNonInventoriable then
            Rec."Stockout Warning" := Rec."Stockout Warning"::No;

        if Rec.Type = Rec.Type::Inventory then begin
            ItemLedgerEntry.SetRange("Item No.", Rec."No.");
            UnitCostEditable := ItemLedgerEntry.IsEmpty;
        end else
            UnitCostEditable := true;

        ProfitEditable := Rec."Price/Profit Calculation" <> Rec."Price/Profit Calculation"::"Profit=Price-Cost";
        PriceEditable := Rec."Price/Profit Calculation" <> Rec."Price/Profit Calculation"::"Price=Cost+Profit";

        EnablePlanningControls();
        EnableCostingControls();

        if ExtendedPriceEnabled then
            UpdateSpecialPriceListsTxt(PriceType::Any)
        else
            UpdateSpecialPricesAndDiscountsTxt;

        SetExpirationCalculationEditable;
    end;

    local procedure OnNewRec()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
    begin
        if GuiAllowed then
            if Rec."No." = '' then
                if DocumentNoVisibility.ItemNoSeriesIsDefault then
                    NewMode := true;
    end;

    local procedure EnableShowStockOutWarning()
    var
        SalesSetup: Record "Sales & Receivables Setup";
    begin
        SalesSetup.Get();
        ShowStockoutWarningDefaultYes := SalesSetup."Stockout Warning";
        ShowStockoutWarningDefaultNo := not ShowStockoutWarningDefaultYes;

        EnableShowShowEnforcePositivInventory;
    end;

    local procedure InsertItemUnitOfMeasure()
    var
        ItemUnitOfMeasure: Record "Item Unit of Measure";
    begin
        if Rec."Base Unit of Measure" <> '' then begin
            ItemUnitOfMeasure.Init();
            ItemUnitOfMeasure."Item No." := Rec."No.";
            ItemUnitOfMeasure.Validate(Code, Rec."Base Unit of Measure");
            ItemUnitOfMeasure."Qty. per Unit of Measure" := 1;
            ItemUnitOfMeasure.Insert();
        end;
    end;

    local procedure EnableShowShowEnforcePositivInventory()
    var
        InventorySetup: Record "Inventory Setup";
    begin
        InventorySetup.Get();
        ShowPreventNegInventoryDefaultYes := InventorySetup."Prevent Negative Inventory";
        ShowPreventNegInventoryDefaultNo := not ShowPreventNegInventoryDefaultYes;
    end;

    protected procedure EnablePlanningControls()
    var
        PlanningGetParam: Codeunit "Planning-Get Parameters";
        TimeBucketEnabled: Boolean;
        SafetyLeadTimeEnabled: Boolean;
        SafetyStockQtyEnabled: Boolean;
        ReorderPointEnabled: Boolean;
        ReorderQtyEnabled: Boolean;
        MaximumInventoryEnabled: Boolean;
        MinimumOrderQtyEnabled: Boolean;
        MaximumOrderQtyEnabled: Boolean;
        OrderMultipleEnabled: Boolean;
        IncludeInventoryEnabled: Boolean;
        ReschedulingPeriodEnabled: Boolean;
        LotAccumulationPeriodEnabled: Boolean;
        DampenerPeriodEnabled: Boolean;
        DampenerQtyEnabled: Boolean;
        OverflowLevelEnabled: Boolean;
        PlanningParameters: Record "Planning Parameters";
    begin
        PlanningParameters."Reordering Policy" := Rec."Reordering Policy";
        PlanningParameters."Include Inventory" := Rec."Include Inventory";
        PlanningParameters."Time Bucket Enabled" := TimeBucketEnabled;
        PlanningParameters."Safety Lead Time Enabled" := SafetyLeadTimeEnabled;
        PlanningParameters."Safety Stock Qty Enabled" := SafetyStockQtyEnabled;
        PlanningParameters."Reorder Point Enabled" := ReorderPointEnabled;
        PlanningParameters."Reorder Quantity Enabled" := ReorderQtyEnabled;
        PlanningParameters."Maximum Inventory Enabled" := MaximumInventoryEnabled;
        PlanningParameters."Minimum Order Qty Enabled" := MinimumOrderQtyEnabled;
        PlanningParameters."Maximum Order Qty Enabled" := MaximumOrderQtyEnabled;
        PlanningParameters."Order Multiple Enabled" := OrderMultipleEnabled;
        PlanningParameters."Include Inventory Enabled" := IncludeInventoryEnabled;
        PlanningParameters."Rescheduling Period Enabled" := ReschedulingPeriodEnabled;
        PlanningParameters."Lot Accum. Period Enabled" := LotAccumulationPeriodEnabled;
        PlanningParameters."Dampener Period Enabled" := DampenerPeriodEnabled;
        PlanningParameters."Dampener Quantity Enabled" := DampenerQtyEnabled;
        PlanningParameters."Overflow Level Enabled" := OverflowLevelEnabled;

        /* PlanningGetParam.SetUpPlanningControls(Rec."Reordering Policy".AsInteger(), Rec."Include Inventory",
          TimeBucketEnabled, SafetyLeadTimeEnabled, SafetyStockQtyEnabled,
          ReorderPointEnabled, ReorderQtyEnabled, MaximumInventoryEnabled,
          MinimumOrderQtyEnabled, MaximumOrderQtyEnabled, OrderMultipleEnabled, IncludeInventoryEnabled,
          ReschedulingPeriodEnabled, LotAccumulationPeriodEnabled,
          DampenerPeriodEnabled, DampenerQtyEnabled, OverflowLevelEnabled);*/
        PlanningGetParam.SetPlanningParameters(PlanningParameters);
        TimeBucketEnable := TimeBucketEnabled;
        SafetyLeadTimeEnable := SafetyLeadTimeEnabled;
        SafetyStockQtyEnable := SafetyStockQtyEnabled;
        ReorderPointEnable := ReorderPointEnabled;
        ReorderQtyEnable := ReorderQtyEnabled;
        MaximumInventoryEnable := MaximumInventoryEnabled;
        MinimumOrderQtyEnable := MinimumOrderQtyEnabled;
        MaximumOrderQtyEnable := MaximumOrderQtyEnabled;
        OrderMultipleEnable := OrderMultipleEnabled;
        IncludeInventoryEnable := IncludeInventoryEnabled;
        ReschedulingPeriodEnable := ReschedulingPeriodEnabled;
        LotAccumulationPeriodEnable := LotAccumulationPeriodEnabled;
        DampenerPeriodEnable := DampenerPeriodEnabled;
        DampenerQtyEnable := DampenerQtyEnabled;
        OverflowLevelEnable := OverflowLevelEnabled;

        OnAfterEnablePlanningControls();
    end;

    protected procedure EnableCostingControls()
    begin
        StandardCostEnable := Rec."Costing Method" = Rec."Costing Method"::Standard;
        UnitCostEnable := Rec."Costing Method" <> Rec."Costing Method"::Standard;
    end;

    local procedure InitControls()
    begin
        UnitCostEnable := true;
        StandardCostEnable := true;
        OverflowLevelEnable := true;
        DampenerQtyEnable := true;
        DampenerPeriodEnable := true;
        LotAccumulationPeriodEnable := true;
        ReschedulingPeriodEnable := true;
        IncludeInventoryEnable := true;
        OrderMultipleEnable := true;
        MaximumOrderQtyEnable := true;
        MinimumOrderQtyEnable := true;
        MaximumInventoryEnable := true;
        ReorderQtyEnable := true;
        ReorderPointEnable := true;
        SafetyStockQtyEnable := true;
        SafetyLeadTimeEnable := true;
        TimeBucketEnable := true;
        Rec."Costing Method" := Rec."Costing Method"::FIFO;
        UnitCostEditable := true;

        OnAfterInitControls();
    end;

    [Obsolete('Replaced by the new implementation (V16) of price calculation.', '17.0')]
    local procedure UpdateSpecialPricesAndDiscountsTxt()
    var
        TempSalesPriceAndLineDiscBuff: Record "Sales Price and Line Disc Buff" temporary;
        TempPurchPriceLineDiscBuff: Record "Purch. Price Line Disc. Buff." temporary;
    begin
        SpecialPricesAndDiscountsTxt := CreateNewTxt;
        if TempSalesPriceAndLineDiscBuff.ItemHasLines(Rec) then
            SpecialPricesAndDiscountsTxt := ViewExistingTxt;

        SpecialPurchPricesAndDiscountsTxt := CreateNewTxt;
        if TempPurchPriceLineDiscBuff.ItemHasLines(Rec) then
            SpecialPurchPricesAndDiscountsTxt := ViewExistingTxt;
    end;

    local procedure UpdateSpecialPriceListsTxt(PriceType: Enum "Price Type")
    begin
        if PriceType in [PriceType::Any, PriceType::Sale] then
            SalesPriceListsText := GetPriceActionText(PriceType::Sale);
        if PriceType in [PriceType::Any, PriceType::Purchase] then
            PurchPriceListsText := GetPriceActionText(PriceType::Purchase);
    end;

    local procedure GetPriceActionText(PriceType: Enum "Price Type"): Text
    var
        PriceListLine: Record "Price List Line";
        PriceAssetList: Codeunit "Price Asset List";
        PriceUXManagement: Codeunit "Price UX Management";
        AssetType: Enum "Price Asset Type";
        AmountType: Enum "Price Amount Type";
    begin
        PriceAssetList.Add(AssetType::Item, Rec."No.");
        PriceUXManagement.SetPriceListLineFilters(PriceListLine, PriceAssetList, PriceType, AmountType::Any);
        if PriceListLine.IsEmpty() then
            exit(CreateNewTxt);
        exit(ViewExistingTxt);
    end;

    local procedure CreateItemFromTemplate()
    var
        Item: Record Item;
        InventorySetup: Record "Inventory Setup";
        ItemTemplMgt: Codeunit "Item Templ. Mgt.";
    begin
        OnBeforeCreateItemFromTemplate(NewMode);

        if not NewMode then
            exit;
        NewMode := false;

        if ItemTemplMgt.InsertItemFromTemplate(Item) then begin
            Rec.Copy(Item);
            CurrPage.Update();
            OnCreateItemFromTemplateOnAfterCurrPageUpdate(Rec);
        end else
            if ItemTemplMgt.TemplatesAreNotEmpty() then begin
                CurrPage.Close;
                exit;
            end;

        if ApplicationAreaMgmtFacade.IsFoundationEnabled then
            if (Item."No." = '') and InventorySetup.Get then
                Rec.Validate("Costing Method", InventorySetup."Default Costing Method");
    end;

    local procedure SetNoFieldVisible()
    var
        DocumentNoVisibility: Codeunit DocumentNoVisibility;
    begin
        NoFieldVisible := DocumentNoVisibility.ItemNoIsVisible;
    end;

    local procedure SetExpirationCalculationEditable()
    var
        EmptyDateFormula: DateFormula;
    begin
        // allow customers to edit expiration date to remove it if the item has no item tracking code
        ExpirationCalculationEditable := Rec.ItemTrackingCodeUseExpirationDates() or (Rec."Expiration Calculation" <> EmptyDateFormula);
    end;

    local procedure SetOverReceiptControlsVisibility()
    var
        OverReceiptMgt: Codeunit "Over-Receipt Mgt.";
    begin
        OverReceiptAllowed := OverReceiptMgt.IsOverReceiptAllowed();
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnAfterInitControls()
    begin
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnAfterOnOpenPage()
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnAfterEnablePlanningControls()
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCreateItemFromTemplate(var NewMode: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCreateItemFromTemplateOnAfterCurrPageUpdate(var Item: Record Item)
    begin
    end;

    local procedure SetDMSIntegrationActionsVisibility()
    var
        DMSIntegrationMgt: Codeunit "Integration Management EDMS";
        ActionCode: array[10] of Code[20];
        ActionIsEnabled: array[10] of Boolean;
    begin
        if ActionCode[1] = '' then
            DMSIntegrationMgt.InitMethodAliasArrayBySource(ActionCode,
                                                           Database::Item, 0,
                                                           Page::"Item Card", 0);

        DMSIntegrationMgt.IsEnabledActionsByArr10(DMSIntegrationMgt.GetConnectorCodeByItem(Rec."No."),
                                                  ActionCode, ActionIsEnabled);
        ShowIntegrationActionGetPrice := ActionIsEnabled[1];
        ShowIntegrationActionGetAvailability := ActionIsEnabled[2];
    end;
}

