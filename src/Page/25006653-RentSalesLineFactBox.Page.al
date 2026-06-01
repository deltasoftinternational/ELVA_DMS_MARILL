Page 25006653 "Rent Sales Line FactBox"
{
    Caption = 'Sales Line Details';
    PageType = CardPart;
    SourceTable = "Rent Sales Line";

    layout
    {
        area(content)
        {
            field(ItemNo; ShowNo)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Item No.';
                Lookup = false;
                ToolTip = 'Specifies the item that is handled on the sales line.';

                trigger OnDrillDown()
                begin
                    RentInfoPaneMgt.LookupItem(Rec);
                end;
            }
            field("Required Quantity"; Rec."Outstanding Quantity" - Rec."Reserved Quantity")
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Required Quantity';
                DecimalPlaces = 0 : 5;
                ToolTip = 'Specifies how many units of the item are required on the sales line.';
            }
            group(Availability)
            {
                Caption = 'Availability';
                field("Item Availability"; RentInfoPaneMgt.CalcAvailability(Rec))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Item Availability';
                    DecimalPlaces = 0 : 5;
                    DrillDown = true;
                    ToolTip = 'Specifies how may units of the item on the sales line are available, in inventory or incoming before the shipment date.';

                    trigger OnDrillDown()
                    begin
                        if Rec.Type = Rec.Type::Item then begin
                            if Item.Get(Rec."No.") then begin
                                ItemAvailFormsMgt.ShowItemAvailabilityFromItem(Item, "Item Availability Type"::"Event");
                                CurrPage.Update(true);
                            end;
                        end;
                    end;
                }
                field("Available Inventory"; RentInfoPaneMgt.CalcAvailableInventory(Rec))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Available Inventory';
                    DecimalPlaces = 0 : 5;
                    ToolTip = 'Specifies the quantity of the item that is currently in inventory and not reserved for other demand.';
                }
            }
            group(Item)
            {
                Caption = 'Item';
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Unit of Measure Code';
                    ToolTip = 'Specifies the unit of measure that is used to determine the value in the Unit Price field on the sales line.';
                }
                field("Qty. per Unit of Measure"; Rec."Qty. per Unit of Measure")
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Qty. per Unit of Measure';
                    ToolTip = 'Specifies an auto-filled number if you have included Sales Unit of Measure on the item card and a quantity in the Qty. per Unit of Measure field.';
                }
                field(Substitutions; RentInfoPaneMgt.CalcNoOfSubstitutions(Rec))
                {
                    ApplicationArea = Suite;
                    Caption = 'Substitutions';
                    DrillDown = true;
                    ToolTip = 'Specifies other items that are set up to be traded instead of the item in case it is not available.';

                    trigger OnDrillDown()
                    begin
                        Rec.ShowItemSub;
                    end;
                }
                field(SalesPrices; RentInfoPaneMgt.CalcNoOfSalesPrices(Rec))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Prices';
                    DrillDown = true;
                    ToolTip = 'Specifies special sales prices that you grant when certain conditions are met, such as customer, quantity, or ending date. The price agreements can be for individual customers, for a group of customers, for all customers or for a campaign.';

                    trigger OnDrillDown()
                    begin
                        ShowPrices;
                        CurrPage.Update;
                    end;
                }
                field(SalesLineDiscounts; RentInfoPaneMgt.CalcNoOfSalesLineDisc(Rec))
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Sales Line Discounts';
                    DrillDown = true;
                    ToolTip = 'Specifies how many special discounts you grant for the sales line. Choose the value to see the sales line discounts.';

                    trigger OnDrillDown()
                    begin
                        ShowLineDisc;
                        CurrPage.Update;
                    end;
                }
            }
            field(ReplacementsExist; Item."Replacements Exist")
            {
                ApplicationArea = Basic;
                Caption = 'Replacements Exist';

                trigger OnDrillDown()
                var
                    ItemSubstSync: Codeunit "Item Substitution Sync";
                    TypePar: Option Item,"Nonstock Item";
                begin
                    ItemSubstSync.ShowReplacementOverview(Typepar::"Nonstock Item", Item.GetSourceNonstockEntryNo(), '');
                end;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin

        if not Item.Get(Rec."No.") then
            Item.Init;
        Rec.CalcFields("Reserved Quantity");

        Item.CalcFields("Replacements Exist")
    end;

    var
        Item: Record Item;
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt. EDMS";
        SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management";
        ItemAvailFormsMgt: Codeunit "Item Availability Forms Mgt";
        RentHeader: Record "Rent Header";
        RentInfoPaneMgt: Codeunit "Rent Info-Pane Mgt.";

    local procedure ShowPrices()
    begin
        Clear(SalesPriceCalcMgt);
        RentHeader.Get(Rec."Document Type", Rec."Document No.");
        // DELTA SALESPRICE 
        SalesPriceCalcMgt.GetRentSalesLinePrice(RentHeader, Rec);
    end;

    local procedure ShowLineDisc()
    begin
        Clear(SalesPriceCalcMgt);
        RentHeader.Get(Rec."Document Type", Rec."Document No.");
        // DELTA SALESPRICE 
        SalesPriceCalcMgt.GetRentSalesLineLineDisc(RentHeader, Rec);
    end;

    local procedure ShowNo(): Code[20]
    begin
        if Rec.Type <> Rec.Type::Item then
            exit('');
        exit(Rec."No.");
    end;
}

