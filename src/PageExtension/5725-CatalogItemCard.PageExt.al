pageextension 25006028 "Catalog Item Card" extends "Catalog Item Card"//5725
{
    layout
    {
        addafter(Description)
        {
            field("Description 2"; Rec."Description 2")
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
        addafter("Last Date Modified")
        {
            field(Blocked; Rec.Blocked)
            {
                ToolTip = 'Specifies that the related record is blocked from being used.';
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
            field(Inventory; Rec.Inventory)
            {
                ToolTip = 'Shows inventory of related item.';
                ApplicationArea = All;
            }
            field(Returnable; Rec.Returnable)
            {
                ToolTip = 'Specifies that this catalogue item is returnable to vendor.';
                ApplicationArea = All;
            }
            field(Discontinued; Rec.Discontinued)
            {
                ToolTip = 'Specifies that this catalogue item is discontinued and can no longer be ordered.';
                ApplicationArea = All;
            }
            field("Item Category Code"; Rec."Item Category Code")
            {
                ToolTip = 'Specifies the category that the item belongs to. Item categories also contain any assigned item attributes.';
                ApplicationArea = All;
            }
        }
        addlast(Invoicing)
        {
            field("Tariff No."; Rec."Tariff No.")
            {
                ToolTip = 'Specifies a code for the item''s tariff number.';
                ApplicationArea = All;
            }
            field("Country/Region of Origin Code"; Rec."Country/Region of Origin Code")
            {
                ToolTip = 'Specifies a code for the country/region where the item was produced or processed.';
                ApplicationArea = All;
            }
            field("Item Tracking Code"; Rec."Item Tracking Code")
            {
                ToolTip = 'Specifies how serial or lot numbers assigned to the item are tracked in the supply chain.';
                ApplicationArea = All;
            }
            field("Item Disc. Group"; Rec."Item Disc. Group")
            {
                ToolTip = 'Specifies a code for item discount group.';
                ApplicationArea = All;
            }
            field("Item Price Group Code"; Rec."Item Price Group Code")
            {
                ToolTip = 'Specifies a code for item price group.';
                ApplicationArea = All;
            }
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
        }
    }

    actions
    {
        addafter("Substituti&ons")
        {
            action(Replacements)
            {
                ApplicationArea = Basic;
                Caption = 'Replacements';
                Image = ItemSubstitution;
                RunObject = Page "Item Substitution Entry";
                RunPageLink = Type = const("Nonstock Item"),
                                  "No." = field("Entry No."),
                                  "Entry Type" = const(Replacement),
                                  "Substitute Type" = const("Nonstock Item");
                ToolTip = 'View replacements for this item.';
            }
            action(ReplacementOverview)
            {
                ApplicationArea = Basic;
                Caption = 'Replacement Overview';
                Image = ItemSubstitution;
                ToolTip = 'View replacement information for this item.';

                trigger OnAction()
                var
                    ItemSubstSync: Codeunit "Item Substitution Sync";
                    ReplInfoPar: Option " ",Replace,Replacement;
                    TypePar: Option Item,"Nonstock Item";
                    NoPar: Code[20];
                    VariantCodePar: Code[10];
                    PrevTypePar: Option Item,"Nonstock Item";
                    PrevNoPar: Code[20];
                    PrevVariantCodePar: Code[10];
                    CurrKey: Integer;
                    DataBuffer: Record "Data Buffer" temporary;
                    ItemReplOverview: Page "Item Replacement Overview";
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
            action(VehicleModels)
            {
                ApplicationArea = Basic;
                Caption = 'Vehicle Models';
                Image = Item;
                ToolTip = 'View information on vehicle models where this item can be used.';

                trigger OnAction()
                begin
                    rec.ShowVehModels
                end;
            }
        }
        addafter("Ca&talog Item")
        {
            group("<Action124>")
            {
                Caption = 'Sales';
                action(Prices)
                {
                    ApplicationArea = Basic;
                    Caption = 'Prices';
                    Image = SalesPrices;
                    RunObject = Page "Nonstock Sales Prices";
                    RunPageLink = "Nonstock Item Entry No." = field("Entry No.");
                    ToolTip = 'Set up different sales prices for the item.';
                }
                action("<Action1101904008>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Line Discounts';
                    Image = LineDiscount;
                    RunObject = Page "Nonstock Sales Line Discounts";
                    RunPageLink = "Nonstock Item Entry No." = field("Entry No.");
                    ToolTip = 'Set up different sales line discounts for the item.';
                }
            }
            group("<Action224>")
            {
                Caption = 'Purchases';
                action("Page Nonstock Purchase Prices")
                {
                    ApplicationArea = Basic;
                    Caption = 'Prices';
                    Image = Price;
                    RunObject = Page "Nonstock Purchase Prices";
                    RunPageLink = "Nonstock Item Entry No." = field("Entry No.");
                    ToolTip = 'Set up different purchase prices for the item.';
                }
                action("<Action1101924008>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Line Discounts';
                    Image = Discount;
                    RunObject = Page "Nonstock Purchase Line Disc.";
                    RunPageLink = "Nonstock Item Entry No." = field("Entry No.");
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
        addlast("F&unctions")
        {
            action(LinkToItem)
            {
                ApplicationArea = Basic;
                Caption = 'Link To Item';
                Image = LinkWithExisting;
                ToolTip = 'Link catalogue item to an existing item.';

                trigger OnAction()
                var
                    NonstockItemManagement: Codeunit "Application Event Management";
                begin
                    NonstockItemManagement.LinkToItem(rec."Entry No.");         // 12.05.2015 EB.P30
                end;
            }
        }
    }
}