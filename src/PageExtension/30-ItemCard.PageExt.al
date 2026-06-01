pageextension 25006008 "Item Card" extends "Item Card" //30
{
    layout
    {
        
        modify("Description 2")
        {
                            Visible = false;
            }
        
        addafter(GTIN)
        {
            field(MakeCode; Rec."Make Code")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies the make code this item belongs to.';
            }
        }
        addafter("Common Item No.")
        {
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
                    rec.CalcFields("Nonstock Entry No.");
                    ItemSubstitution.Reset;
                    ItemSubstitution.SetRange("No.", rec."Nonstock Entry No.");
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
        }
        addafter("Qty. on Service Order")
        {
            field(QtyonServiceOrderEDMS; Rec."Qty. on Service Order EDMS")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies how many units of the item are allocated to EDMS service orders, meaning listed on service order lines.';
            }
        }
        modify("Over-Receipt Code")
        {
            Visible = true;
        }
        addafter("VAT Bus. Posting Gr. (Price)")
        {
            field("Market Recomended Sales Price"; Rec."Market Recomended Sales Price")
            {
                ToolTip = 'Specifies the Recomended Sales Price.';
                ApplicationArea = All;
            }
            field("MRSP Currency Code"; Rec."MRSP Currency Code")
            {
                ToolTip = 'Specifies the Recomended Sales Price currency.';
                ApplicationArea = All;
            }
            field("Item Price Group Code"; Rec."Item Price Group Code")
            {
                ToolTip = 'Specifies the Item Price Group.';
                ApplicationArea = All;
            }
        }

    }
    actions
    {
        addafter(SaveAsTemplate)
        {
            action("<Action1101904001>")
            {
                ApplicationArea = Basic;
                Caption = 'Register Lost Sale';
                Image = Register;

                trigger OnAction()
                var
                    LostSalesMgt: Codeunit "Lost Sales Management";
                begin
                    LostSalesMgt.RegisterLostSale_Item(Rec."No."); //EDMS
                end;
            }
        }
        addafter("Item Tracing")
        {
            group(DMSIntegration)
            {
                Caption = 'DMS Integration';
                action(GetPrice)
                {
                    ApplicationArea = Basic;
                    Caption = 'Get Price';
                    Image = Price;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = ShowIntegrationActionGetPrice;

                    trigger OnAction()
                    var
                        ItemIntegrationMgt: Codeunit "Item Mgt. EDMS";
                    begin
                        ItemIntegrationMgt.GetPriceForItem(Rec."No.");
                    end;
                }
                action(GetAvailability)
                {
                    ApplicationArea = Basic;
                    Caption = 'Get Availability';
                    Image = AvailableToPromise;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    Visible = ShowIntegrationActionGetAvailability;

                    trigger OnAction()
                    var
                        ItemIntegrationMgt: Codeunit "Item Mgt. EDMS";
                    begin
                        ItemIntegrationMgt.GetAvailabilityForItem(Rec."No.");
                    end;
                }
            }
        }
        addafter(Dimensions)
        {
            action(Replacements)
            {
                ApplicationArea = Basic;
                Caption = 'Replacements';
                Image = ItemSubstitution;
                RunObject = Page "Item Substitution Entry";
                RunPageLink = Type = const(Item),
                                  "No." = field("No."),
                                  "Entry Type" = const(Replacement),
                                  "Substitute Type" = const(Item);
                ToolTip = 'View replacement items that are related to this item.';
            }
            action("Elva Substituti&ons")
            {
                ApplicationArea = Suite;
                Caption = 'Substituti&ons';
                Image = ItemSubstitution;
                RunObject = Page "Item Substitution Entry";
                RunPageLink = Type = CONST(Item),
                                "No." = FIELD("No."),
                                "Entry Type" = const(Substitution),
                                "Substitute Type" = const(Item);
                ToolTip = 'View substitute items that are set up to be sold instead of the item.';
            }
            action(ReplacementOverview)
            {
                ApplicationArea = Basic;
                Caption = 'Replacement Overview';
                Image = ItemSubstitution;
                ToolTip = 'View information on all replacement chain related to this item.';

                trigger OnAction()
                var
                    ItemSubstSync: Codeunit "Item Substitution Sync";
                    TypePar: Option Item,"Nonstock Item";
                begin
                    // 03.04.2014 Elva Baltic P15 #F124 MMG7.00 >>
                    ItemSubstSync.ShowReplacementOverview(Typepar::"Nonstock Item", rec.GetSourceNonstockEntryNo(), '');
                    // 03.04.2014 Elva Baltic P15 #F124 MMG7.00 <<
                end;
            }
        }
        modify("Substituti&ons")
        {
            Visible = false;
        }
        addafter(Availability)
        {
            group(ActionGroup126)
            {
                Caption = 'History';
                Image = History;
                action(VehicleModels)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicle Models';
                    Image = ListPage;

                    trigger OnAction()
                    begin
                        rec.ShowItemVehicleModels;
                    end;
                }
                group(ActionGroup101)
                {
                    Caption = 'E&ntries';
                    Image = Entries;
                    action(Action105)
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
                    action(Action75)
                    {
                        ApplicationArea = Basic;
                        Caption = '&Reservation Entries';
                        Image = ReservationLedger;
                        RunObject = Page "Reservation Entries";
                        RunPageLink = "Reservation Status" = const(Reservation),
                                      "Item No." = field("No.");
                        RunPageView = sorting("Item No.", "Variant Code", "Location Code", "Reservation Status");
                    }
                    action(Action112)
                    {
                        ApplicationArea = Basic;
                        Caption = '&Phys. Inventory Ledger Entries';
                        Image = PhysicalInventoryLedger;
                        RunObject = Page "Phys. Inventory Ledger Entries";
                        RunPageLink = "Item No." = field("No.");
                        RunPageView = sorting("Item No.");
                    }
                    action(Action5800)
                    {
                        ApplicationArea = Basic;
                        Caption = '&Value Entries';
                        Image = ValueLedger;
                        RunObject = Page "Value Entries";
                        RunPageLink = "Item No." = field("No.");
                        RunPageView = sorting("Item No.");
                    }
                    action(Action6500)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Item &Tracking Entries';
                        Image = ItemTrackingLedger;

                        trigger OnAction()
                        var
                            ItemTrackingDocMgt: Codeunit "Item Tracking Doc. Management";
                        begin
                            ItemTrackingDocMgt.ShowItemTrackingForEntity(3, '', rec."No.", '', '');
                        end;
                    }
                    action(Action11)
                    {
                        ApplicationArea = Basic;
                        Caption = '&Warehouse Entries';
                        Image = BinLedger;
                        RunObject = Page "Warehouse Entries";
                        RunPageLink = "Item No." = field("No.");
                        RunPageView = sorting("Item No.", "Bin Code", "Location Code", "Variant Code", "Unit of Measure Code", "Lot No.", "Serial No.", "Entry Type", Dedicated);
                    }
                    action(Action237)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Application Worksheet';
                        Image = ApplicationWorksheet;
                        RunObject = Page "Application Worksheet";
                        RunPageLink = "Item No." = field("No.");
                    }
                    action(LostSaleEntries)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Lost Sale Entries';
                        Image = LedgerEntries;
                        RunObject = Page "Lost Sales Entries";
                        RunPageLink = "Item No." = field("No.");
                        RunPageView = sorting("Item No.");
                    }
                    action("Service Ledger Entries EDMS")
                    {
                        ApplicationArea = All;
                        Caption = 'Service Ledger Entries EDMS';
                        Image = BinLedger;
                        RunObject = Page "Service Ledger Entries EDMS";
                        RunPageLink = "Entry Type" = CONST(Usage),
                                      "Type" = CONST(Item),
                                      "No." = FIELD("No.");
                    }
                }

            }

        }

        modify(Statistics)
        {
            Visible = false;
        }

        addafter(Statistics)
        {
            action(EDMSStatistics)
            {
                ApplicationArea = Basic, Suite;
                Caption = 'Statistics';
                Image = Statistics;
                ShortCutKey = 'F7';
                ToolTip = 'View statistical information, such as the value of posted entries, for the record.';

                trigger OnAction()
                var
                    EDMSItemStatistics: Page "EDMS Item Statistics";
                begin
                    EDMSItemStatistics.SetItem(Rec);
                    EDMSItemStatistics.RunModal;
                end;
            }
        }

    }
    trigger OnAfterGetCurrRecord()
    begin
        SetDMSIntegrationActionsVisibility;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        EnablePlanningControls;
        EnableCostingControls;
        //EDMS >>
        rec."Item Type" := rec."item type"::Item;
        //EDMS <<
    end;

    var
        ShowIntegrationActionGetPrice: Boolean;
        ShowIntegrationActionGetAvailability: Boolean;

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