Page 25006455 "Model Version Card"
{
    // 26.10.2015 #NAV2016 Merge
    //   Action "Item Tracking Entries" removed;
    // 22.10.2015 NAV2016 Merge
    //   "Next Counting Period" field deleted (deleted in nav2016 standard)

    Caption = 'Model Version Card';
    PageType = Card;
    PopulateAllFields = true;
    RefreshOnActivate = true;
    SourceTable = Item;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    NotBlank = true;

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit then
                            CurrPage.Update;
                    end;
                }
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                }
                field(ModelCode; Rec."Model Code")
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
                    Importance = Promoted;
                }
                field(AssemblyBOM; Rec."Assembly BOM")
                {
                    ApplicationArea = Basic;
                }
                field(ShelfNo; Rec."Shelf No.")
                {
                    ApplicationArea = Basic;
                }
                field(AutomaticExtTexts; Rec."Automatic Ext. Texts")
                {
                    ApplicationArea = Basic;
                }
                field(CreatedFromNonstockItem; Rec."Created From Nonstock Item")
                {
                    ApplicationArea = Basic;
                }
                field(ItemCategoryCode; Rec."Item Category Code")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        EnableCostingControls;
                    end;
                }
                field(SearchDescription; Rec."Search Description")
                {
                    ApplicationArea = Basic;
                }
                field(Inventory; Rec.Inventory)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(QtyonPurchOrder; Rec."Qty. on Purch. Order")
                {
                    ApplicationArea = Basic;
                }
                field(QtyonProdOrder; Rec."Qty. on Prod. Order")
                {
                    ApplicationArea = Basic;
                }
                field(QtyonComponentLines; Rec."Qty. on Component Lines")
                {
                    ApplicationArea = Basic;
                }
                field(QtyonSalesOrder; Rec."Qty. on Sales Order")
                {
                    ApplicationArea = Basic;
                }
                field(QtyonServiceOrder; Rec."Qty. on Service Order")
                {
                    ApplicationArea = Basic;
                }
                field(ServiceItemGroup; Rec."Service Item Group")
                {
                    ApplicationArea = Basic;
                }
                field(Blocked; Rec.Blocked)
                {
                    ApplicationArea = Basic;
                }
                field(LastDateModified; Rec."Last Date Modified")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Invoicing)
            {
                Caption = 'Invoicing';
                field(CostingMethod; Rec."Costing Method")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        EnableCostingControls;
                    end;
                }
                field(CostisAdjusted; Rec."Cost is Adjusted")
                {
                    ApplicationArea = Basic;
                }
                field(CostisPostedtoGL; Rec."Cost is Posted to G/L")
                {
                    ApplicationArea = Basic;
                }
                field(StandardCost; Rec."Standard Cost")
                {
                    ApplicationArea = Basic;
                    Enabled = StandardCostEnable;

                    trigger OnDrillDown()
                    var
                        ShowAvgCalcItem: Codeunit "Show Avg. Calc. - Item";
                    begin
                        ShowAvgCalcItem.DrillDownAvgCostAdjmtPoint(Rec)
                    end;
                }
                field(UnitCost; Rec."Unit Cost")
                {
                    ApplicationArea = Basic;
                    Enabled = UnitCostEnable;

                    trigger OnDrillDown()
                    var
                        ShowAvgCalcItem: Codeunit "Show Avg. Calc. - Item";
                    begin
                        ShowAvgCalcItem.DrillDownAvgCostAdjmtPoint(Rec)
                    end;
                }
                field(OverheadRate; Rec."Overhead Rate")
                {
                    ApplicationArea = Basic;
                }
                field(IndirectCost; Rec."Indirect Cost %")
                {
                    ApplicationArea = Basic;
                }
                field(LastDirectCost; Rec."Last Direct Cost")
                {
                    ApplicationArea = Basic;
                }
                field(PriceProfitCalculation; Rec."Price/Profit Calculation")
                {
                    ApplicationArea = Basic;
                }
                field(Profit; Rec."Profit %")
                {
                    ApplicationArea = Basic;
                }
                field(UnitPrice; Rec."Unit Price")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(GenProdPostingGroup; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(VATProdPostingGroup; Rec."VAT Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                }
                field(InventoryPostingGroup; Rec."Inventory Posting Group")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(NetInvoicedQty; Rec."Net Invoiced Qty.")
                {
                    ApplicationArea = Basic;
                }
                field(AllowInvoiceDisc; Rec."Allow Invoice Disc.")
                {
                    ApplicationArea = Basic;
                }
                field(ItemDiscGroup; Rec."Item Disc. Group")
                {
                    ApplicationArea = Basic;
                }
                field(SalesUnitofMeasure; Rec."Sales Unit of Measure")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Replenishment)
            {
                Caption = 'Replenishment';
                field(ReplenishmentSystem; Rec."Replenishment System")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                    OptionCaption = 'Purchase,Prod. Order';
                }
                group(Purchase)
                {
                    Caption = 'Purchase';
                    field(VendorNo; Rec."Vendor No.")
                    {
                        ApplicationArea = Basic;
                    }
                    field(VendorItemNo; Rec."Vendor Item No.")
                    {
                        ApplicationArea = Basic;
                    }
                    field(PurchUnitofMeasure; Rec."Purch. Unit of Measure")
                    {
                        ApplicationArea = Basic;
                    }
                    field(LeadTimeCalculation; Rec."Lead Time Calculation")
                    {
                        ApplicationArea = Basic;
                    }
                }
                group(Production)
                {
                    Caption = 'Production';
                    field(ManufacturingPolicy; Rec."Manufacturing Policy")
                    {
                        ApplicationArea = Basic;
                    }
                    field(RoutingNo; Rec."Routing No.")
                    {
                        ApplicationArea = Basic;
                    }
                    field(ProductionBOMNo; Rec."Production BOM No.")
                    {
                        ApplicationArea = Basic;
                    }
                    field(RoundingPrecision; Rec."Rounding Precision")
                    {
                        ApplicationArea = Basic;
                    }
                    field(FlushingMethod; Rec."Flushing Method")
                    {
                        ApplicationArea = Basic;
                    }
                    field(Scrap; Rec."Scrap %")
                    {
                        ApplicationArea = Basic;
                    }
                    field(LotSize; Rec."Lot Size")
                    {
                        ApplicationArea = Basic;
                    }
                }
            }
            group(Planning)
            {
                Caption = 'Planning';
                field(ReorderingPolicy; Rec."Reordering Policy")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;

                    trigger OnValidate()
                    begin
                        EnablePlanningControls
                    end;
                }
                field(IncludeInventory; Rec."Include Inventory")
                {
                    ApplicationArea = Basic;
                    Enabled = IncludeInventoryEnable;

                    trigger OnValidate()
                    begin
                        EnablePlanningControls
                    end;
                }
                field(Reserve; Rec.Reserve)
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(OrderTrackingPolicy; Rec."Order Tracking Policy")
                {
                    ApplicationArea = Basic;
                }
                field(StockkeepingUnitExists; Rec."Stockkeeping Unit Exists")
                {
                    ApplicationArea = Basic;
                }
                field(Critical; Rec.Critical)
                {
                    ApplicationArea = Basic;
                }
                field(TimeBucket; Rec."Time Bucket")
                {
                    ApplicationArea = Basic;
                    Enabled = ReorderCycleEnable;
                }
                field(SafetyLeadTime; Rec."Safety Lead Time")
                {
                    ApplicationArea = Basic;
                    Enabled = SafetyLeadTimeEnable;
                }
                field(SafetyStockQuantity; Rec."Safety Stock Quantity")
                {
                    ApplicationArea = Basic;
                    Enabled = SafetyStockQuantityEnable;
                }
                field(ReorderPoint; Rec."Reorder Point")
                {
                    ApplicationArea = Basic;
                    Enabled = ReorderPointEnable;
                }
                field(ReorderQuantity; Rec."Reorder Quantity")
                {
                    ApplicationArea = Basic;
                    Enabled = ReorderQuantityEnable;
                }
                field(MaximumInventory; Rec."Maximum Inventory")
                {
                    ApplicationArea = Basic;
                    Enabled = MaximumInventoryEnable;
                }
                field(MinimumOrderQuantity; Rec."Minimum Order Quantity")
                {
                    ApplicationArea = Basic;
                    Enabled = MinimumOrderQuantityEnable;
                }
                field(MaximumOrderQuantity; Rec."Maximum Order Quantity")
                {
                    ApplicationArea = Basic;
                    Enabled = MaximumOrderQuantityEnable;
                }
                field(OrderMultiple; Rec."Order Multiple")
                {
                    ApplicationArea = Basic;
                    Enabled = OrderMultipleEnable;
                }
            }
            group(ForeignTrade)
            {
                Caption = 'Foreign Trade';
                field(TariffNo; Rec."Tariff No.")
                {
                    ApplicationArea = Basic;
                }
                field(CountryRegionofOriginCode; Rec."Country/Region of Origin Code")
                {
                    ApplicationArea = Basic;
                }
                field(NetWeight; Rec."Net Weight")
                {
                    ApplicationArea = Basic;
                }
                field(GrossWeight; Rec."Gross Weight")
                {
                    ApplicationArea = Basic;
                }
            }
            group(ItemTracking)
            {
                Caption = 'Item Tracking';
                field(ItemTrackingCode; Rec."Item Tracking Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(SerialNos; Rec."Serial Nos.")
                {
                    ApplicationArea = Basic;
                }
                field(LotNos; Rec."Lot Nos.")
                {
                    ApplicationArea = Basic;
                }
                field(ExpirationCalculation; Rec."Expiration Calculation")
                {
                    ApplicationArea = Basic;
                }
            }
            group(ECommerce)
            {
                Caption = 'E-Commerce';
                group(BizTalk)
                {
                    Caption = 'BizTalk';
                    field(CommonItemNo; Rec."Common Item No.")
                    {
                        ApplicationArea = Basic;
                    }
                }
            }
            group(Warehouse)
            {
                Caption = 'Warehouse';
                field(SpecialEquipmentCode; Rec."Special Equipment Code")
                {
                    ApplicationArea = Basic;
                }
                field(PutawayTemplateCode; Rec."Put-away Template Code")
                {
                    ApplicationArea = Basic;
                }
                field(PutawayUnitofMeasureCode; Rec."Put-away Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(PhysInvtCountingPeriodCode; Rec."Phys Invt Counting Period Code")
                {
                    ApplicationArea = Basic;
                    Importance = Promoted;
                }
                field(LastPhysInvtDate; Rec."Last Phys. Invt. Date")
                {
                    ApplicationArea = Basic;
                }
                field(LastCountingPeriodUpdate; Rec."Last Counting Period Update")
                {
                    ApplicationArea = Basic;
                }
                field(IdentifierCode; Rec."Identifier Code")
                {
                    ApplicationArea = Basic;
                }
                field(UseCrossDocking; Rec."Use Cross-Docking")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            part(ItemPicture; "Item Picture")
            {
                ApplicationArea = All;
                Caption = 'Picture';
                SubPageLink = "No." = field("No.");
            }
            part("Model Version Pictures"; "Object Picture FactBox")
            {
                ApplicationArea = All;
                Caption = 'Model Version Pictures';
                Visible = false;
                SubPageLink = "Source Type" = const(27),
                              "Source Subtype" = const("2"),
                              "Source ID" = field("No."),
                              "Source Ref. No." = const(0);
                SubPageView = sorting("Source Type", "Source Subtype", "Source ID", "Source Ref. No.", "No.");
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
                action(StockkeepingUnits)
                {
                    ApplicationArea = Basic;
                    Caption = 'Stockkeepin&g Units';
                    Image = Warehouse;
                    RunObject = Page "Stockkeeping Unit List";
                    RunPageLink = "Item No." = field("No.");
                    RunPageView = sorting("Item No.");
                }
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
                    action(ApplicationWorksheet)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Application Worksheet';
                        Image = Worksheet;
                        RunObject = Page "Application Worksheet";
                        RunPageLink = "Item No." = field("No.");
                    }
                }
                group(Statistics)
                {
                    Caption = 'Statistics';
                    Image = Statistics;
                    action(Action107)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Statistics';
                        Image = Statistics;
                        Promoted = true;
                        PromotedCategory = Process;
                        ShortCutKey = 'F7';

                        trigger OnAction()
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
                    begin
                        ItemsByLocation.SetRecord(Rec);
                        ItemsByLocation.Run;
                    end;
                }
                action("Manufacturer Options")
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
                action("<Action1101901000>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Specification';
                    Image = ExternalDocument;
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
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    RunObject = Page "Default Dimensions";
                    RunPageLink = "Table ID" = const(27),
                                  "No." = field("No.");
                    ShortCutKey = 'Shift+Ctrl+D';
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
                action(Variants)
                {
                    ApplicationArea = Basic;
                    Caption = 'Va&riants';
                    Image = ItemVariant;
                    RunObject = Page "Item Variants";
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
                action(Substitutions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Substituti&ons';
                    Image = List;
                    RunObject = Page "Item Substitution Entry";
                    RunPageLink = Type = const(Item),
                                  "No." = field("No.");
                }
                action(NonstockItems)
                {
                    ApplicationArea = Basic;
                    Caption = 'Nonstoc&k Items';
                    Image = Item;
                    RunObject = Page "Catalog Item List";
                }
                action(Translations)
                {
                    ApplicationArea = Basic;
                    Caption = 'Translations';
                    Image = Translations;
                    RunObject = Page "Item Translations";
                    RunPageLink = "Item No." = field("No.");
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
                group(AssemblyList)
                {
                    Caption = 'Assembly List';
                    Image = AssemblyBOM;
                    action(BillofMaterials)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Bill of Materials';
                        Image = List;
                        RunObject = Page "Assembly BOM";
                        RunPageLink = "Parent Item No." = field("No.");
                    }
                    action(WhereUsedList)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Where-Used List';
                        Image = List;
                        RunObject = Page "Where-Used List";
                        RunPageLink = Type = const(Item),
                                      "No." = field("No.");
                        RunPageView = sorting(Type, "No.");
                    }
                    action(CalcStandardCost)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Calc. Stan&dard Cost';
                        Image = Calculate;

                        trigger OnAction()
                        begin
                            Clear(CalculateStdCost);
                            CalculateStdCost.CalcItem(Rec."No.", true);
                        end;
                    }
                }
                group(Manufacturing)
                {
                    Caption = 'Manufa&cturing';
                    Image = Production;
                    action(WhereUsed)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Where-Used';
                        Image = List;

                        trigger OnAction()
                        begin
                            ProdBOMWhereUsed.SetItem(Rec, WorkDate);
                            ProdBOMWhereUsed.RunModal;
                        end;
                    }
                    action(Action123)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Calc. Stan&dard Cost';
                        Image = Calculate;

                        trigger OnAction()
                        begin
                            Clear(CalculateStdCost);
                            CalculateStdCost.CalcItem(Rec."No.", false);
                        end;
                    }
                }
                action(ServiceItems)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ser&vice Items';
                    Image = ServiceItem;
                    RunObject = Page "Service Items";
                    RunPageLink = "Item No." = field("No.");
                    RunPageView = sorting("Item No.");
                }
                action(Troubleshooting)
                {
                    ApplicationArea = Basic;
                    Caption = 'Troubleshooting';
                    Image = Troubleshoot;
                    RunObject = Page "Troubleshooting Setup";
                    RunPageLink = Type = const(Item),
                                  "No." = field("No.");
                }
                group(Resource)
                {
                    Caption = 'R&esource';
                    Image = Resource;
                    action(ResourceSkills)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Resource Skills';
                        Image = Skills;
                        RunObject = Page "Resource Skills";
                        RunPageLink = Type = const(Item),
                                      "No." = field("No.");
                    }
                    action(SkilledResources)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Skilled Resources';
                        Image = Resource;

                        trigger OnAction()
                        var
                            ResourceSkill: Record "Resource Skill";
                        begin
                            Clear(SkilledResourceList);
                            SkilledResourceList.Initialize(ResourceSkill.Type::Item, Rec."No.", Rec.Description);
                            SkilledResourceList.RunModal;
                        end;
                    }
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
                /*   action(Prices)
                   {
                       ApplicationArea = Basic;
                       Caption = 'Prices';
                       Image = ResourcePrice;
                       RunObject = Page "Model Version Sales Prices";
                       RunPageLink = "Item No." = field("No.");
                       RunPageView = sorting("Item No.");
                   }
                   action(LineDiscounts)
                   {
                       ApplicationArea = Basic;
                       Caption = 'Line Discounts';
                       Image = LineDiscount;
                       RunObject = Page "Sales Line Discounts";
                       RunPageLink = Type = const(Item),
                                     Code = field("No.");
                       RunPageView = sorting(Type, Code);
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
                action(ReturnOrders)
                {
                    ApplicationArea = Basic;
                    Caption = 'Return Orders';
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
                /*  action(Action85)
                  {
                      ApplicationArea = Basic;
                      Caption = 'Prices';
                      Image = ResourcePrice;
                      RunObject = Page "Purchase Prices";
                      RunPageLink = "Item No." = field("No.");
                      RunPageView = sorting("Item No.");
                  }
                  action(Action86)
                  {
                      ApplicationArea = Basic;
                      Caption = 'Line Discounts';
                      Image = LineDiscount;
                      RunObject = Page "Purchase Line Discounts";
                      RunPageLink = "Item No." = field("No.");
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
                action(Action240)
                {
                    ApplicationArea = Basic;
                    Caption = 'Prepa&yment Percentages';
                    Image = PrepaymentPercentages;
                    RunObject = Page "Purchase Prepmt. Percentages";
                    RunPageLink = "Item No." = field("No.");
                }
                action(Action87)
                {
                    ApplicationArea = Basic;
                    Caption = 'Orders';
                    Image = Document;
                    RunObject = Page "Purchase Orders";
                    RunPageLink = Type = const(Item),
                                  "No." = field("No.");
                    RunPageView = sorting("Document Type", Type, "No.");
                }
                action(Action191)
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
            group(Functions)
            {
                Caption = 'F&unctions';
                action(CreateStockkeepingUnit)
                {
                    ApplicationArea = Basic;
                    Caption = '&Create Stockkeeping Unit';
                    Image = CreateSKU;

                    trigger OnAction()
                    var
                        Item: Record Item;
                    begin
                        Item.SetRange("No.", Rec."No.");
                        Report.RunModal(Report::"Create Stockkeeping Unit", true, false, Item);
                    end;
                }
                action(CalculateCountingPeriod)
                {
                    ApplicationArea = Basic;
                    Caption = 'C&alculate Counting Period';
                    Image = Calculate;

                    trigger OnAction()
                    var
                        PhysInvtCountMgt: Codeunit "Phys. Invt. Count.-Management";
                    begin
                        PhysInvtCountMgt.UpdateItemPhysInvtCount(Rec);
                    end;
                }
                action(ApplyTemplate)
                {
                    ApplicationArea = Basic;
                    Caption = 'Apply Template';
                    Ellipsis = true;
                    Image = ApplyTemplate;
                    Promoted = true;
                    PromotedCategory = Process;

                    trigger OnAction()
                    var
                        TemplateMgt: Codeunit "Config. Template Management";
                        RecRef: RecordRef;
                    begin
                        RecRef.GetTable(Rec);
                        TemplateMgt.UpdateFromTemplateSelection(RecRef);
                    end;
                }
            }
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
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Item Reclass. Journal";
            }
            action(ItemTracing)
            {
                ApplicationArea = Basic;
                Caption = 'Item Tracing';
                Image = ItemTracing;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page "Item Tracing";
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        EnablePlanningControls;
        EnableCostingControls;
    end;

    trigger OnInit()
    begin
        UnitCostEnable := true;
        StandardCostEnable := true;
        IncludeInventoryEnable := true;
        OrderMultipleEnable := true;
        MaximumOrderQuantityEnable := true;
        MinimumOrderQuantityEnable := true;
        MaximumInventoryEnable := true;
        ReorderQuantityEnable := true;
        ReorderPointEnable := true;
        SafetyStockQuantityEnable := true;
        SafetyLeadTimeEnable := true;
        ReorderCycleEnable := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        EnableCostingControls;

        //EDMS >>
        Rec."Item Type" := Rec."item type"::"Model Version";
        //EDMS <<
    end;

    var
        CalculateStdCost: Codeunit "Calculate Standard Cost";
        ItemStatistics: Page "EDMS Item Statistics";
        ItemsByLocation: Page "Items by Location";
        ProdBOMWhereUsed: Page "Prod. BOM Where-Used";
        SkilledResourceList: Page "Skilled Resource List";
        [InDataSet]
        ReorderCycleEnable: Boolean;
        [InDataSet]
        SafetyLeadTimeEnable: Boolean;
        [InDataSet]
        SafetyStockQuantityEnable: Boolean;
        [InDataSet]
        ReorderPointEnable: Boolean;
        [InDataSet]
        ReorderQuantityEnable: Boolean;
        [InDataSet]
        MaximumInventoryEnable: Boolean;
        [InDataSet]
        MinimumOrderQuantityEnable: Boolean;
        [InDataSet]
        MaximumOrderQuantityEnable: Boolean;
        [InDataSet]
        OrderMultipleEnable: Boolean;
        [InDataSet]
        IncludeInventoryEnable: Boolean;
        [InDataSet]
        StandardCostEnable: Boolean;
        [InDataSet]
        UnitCostEnable: Boolean;


    procedure EnablePlanningControls()
    var
        PlanningGetParam: Codeunit "Planning-Get Parameters";
        ReorderCycleEnabled: Boolean;
        SafetyLeadTimeEnabled: Boolean;
        SafetyStockQtyEnabled: Boolean;
        ReorderPointEnabled: Boolean;
        ReorderQuantityEnabled: Boolean;
        MaximumInventoryEnabled: Boolean;
        MinimumOrderQtyEnabled: Boolean;
        MaximumOrderQtyEnabled: Boolean;
        OrderMultipleEnabled: Boolean;
        IncludeInventoryEnabled: Boolean;
        BoolVar: Boolean;
        PlanningParameters: Record "Planning Parameters";
    begin
        PlanningParameters."Reordering Policy" := Rec."Reordering Policy";
        PlanningParameters."Include Inventory" := Rec."Include Inventory";
        PlanningParameters."Time Bucket Enabled" := ReorderCycleEnabled;
        PlanningParameters."Safety Lead Time Enabled" := SafetyLeadTimeEnabled;
        PlanningParameters."Safety Stock Qty Enabled" := SafetyStockQtyEnabled;
        PlanningParameters."Reorder Point Enabled" := ReorderPointEnabled;
        PlanningParameters."Reorder Quantity Enabled" := ReorderQuantityEnabled;
        PlanningParameters."Maximum Inventory Enabled" := MaximumInventoryEnabled;
        PlanningParameters."Minimum Order Qty Enabled" := MinimumOrderQtyEnabled;
        PlanningParameters."Maximum Order Qty Enabled" := MaximumOrderQtyEnabled;
        PlanningParameters."Order Multiple Enabled" := OrderMultipleEnabled;
        PlanningParameters."Include Inventory Enabled" := IncludeInventoryEnabled;
        PlanningParameters."Rescheduling Period Enabled" := BoolVar;
        PlanningParameters."Lot Accum. Period Enabled" := BoolVar;
        PlanningParameters."Dampener Period Enabled" := BoolVar;
        PlanningParameters."Dampener Quantity Enabled" := BoolVar;
        PlanningParameters."Overflow Level Enabled" := BoolVar;
        /*PlanningGetParam.SetUpPlanningControls(Rec."Reordering Policy", Rec."Include Inventory",
          ReorderCycleEnabled, SafetyLeadTimeEnabled, SafetyStockQtyEnabled,
          ReorderPointEnabled, ReorderQuantityEnabled, MaximumInventoryEnabled,
          MinimumOrderQtyEnabled, MaximumOrderQtyEnabled, OrderMultipleEnabled, IncludeInventoryEnabled, BoolVar, BoolVar, BoolVar, BoolVar, BoolVar);
        ReorderCycleEnable := ReorderCycleEnabled;*/
        PlanningGetParam.SetPlanningParameters(PlanningParameters);
        SafetyLeadTimeEnable := SafetyLeadTimeEnabled;
        SafetyStockQuantityEnable := SafetyStockQtyEnabled;
        ReorderPointEnable := ReorderPointEnabled;

        MaximumInventoryEnable := MaximumInventoryEnabled;
        MinimumOrderQuantityEnable := MinimumOrderQtyEnabled;
        MaximumOrderQuantityEnable := MaximumOrderQtyEnabled;
        OrderMultipleEnable := OrderMultipleEnabled;
        IncludeInventoryEnable := IncludeInventoryEnabled;
    end;


    procedure EnableCostingControls()
    begin
        StandardCostEnable := Rec."Costing Method" = Rec."costing method"::Standard;
        UnitCostEnable := Rec."Costing Method" <> Rec."costing method"::Standard;
    end;
}

