pageextension 25006456 "Sales Price Worksheet" extends "Sales Price Worksheet"//7023
{
    layout
    {
        modify("Item No.")
        {
            Visible = false;
        }
        addafter("Currency Code")
        {
            field(Type; Rec.Type)
            {
                ApplicationArea = Basic;
            }
            field(No; Rec."Item No.")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies the number of the item for which sales prices are being changed or set up.';
            }
        }
        addafter("Variant Code")
        {
            field(LocationCode; Rec."Location Code")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
        }
        modify("Unit of Measure Code")
        {
            Visible = false;
        }
        modify("Minimum Quantity")
        {
            Visible = false;
        }
        addafter("Current Unit Price")
        {
            field(UnitProfitCurrent; Rec."Unit Profit (Current)")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
            field(Control15; Rec."Unit Profit % (Current)")
            {
                ApplicationArea = Basic;
                Editable = false;
            }
        }
        addafter("New Unit Price")
        {
            field(UnitProfitNew; Rec."Unit Profit (New)")
            {
                ApplicationArea = Basic;
            }
            field(Control18; Rec."Unit Profit % (New)")
            {
                ApplicationArea = Basic;
            }
        }
        addafter("Allow Line Disc.")
        {
            field(OrderingPriceTypeCode; Rec."Ordering Price Type Code")
            {
                ApplicationArea = Basic;
                Visible = true;
            }
            field(UnitCost; Rec."Unit Cost")
            {
                ApplicationArea = Basic;
                Visible = true;
            }
        }
    }
    actions
    {
        addafter("Suggest &Sales Price on Wksh.")
        {
            action(SuggestSalesPriceFromPrch)
            {
                ApplicationArea = Basic;
                Caption = 'Suggest Sales Price From Prch.';

                trigger OnAction()
                begin
                    Report.RunModal(Report::"Suggest Sales Price From Prch.", true, true);
                end;
            }
        }
        addafter("I&mplement Price Change")
        {
            separator(Action1101904000)
            {
            }
            action(SuggestNonstockItemonWksh)
            {
                ApplicationArea = Basic;
                Caption = 'Suggest Nonstock Item on Wksh.';
                Ellipsis = true;
                Image = NonStockItem;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Report.RunModal(Report::"Suggest Nonstock Item Price", true, true);
                end;
            }
            action(SuggestNonstockSalesPriceonWksh)
            {
                ApplicationArea = Basic;
                Caption = 'Suggest Nonstock Sales Price on Wksh.';
                Ellipsis = true;
                Image = SalesPrices;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Report.RunModal(Report::"Suggest Nonstock Sales Price", true, true);
                end;
            }
            separator(Action1101904003)
            {
            }
            action(CalculatePriceFromCost)
            {
                ApplicationArea = Basic;
                Caption = 'Calculate Price From Cost';
                Ellipsis = true;
                Image = SuggestSalesPrice;
                Promoted = false;

                trigger OnAction()
                var
                    SalesPriceWorksheet: Record "Sales Price Worksheet";
                begin
                    SalesPriceWorksheet.Reset;
                    SalesPriceWorksheet.CopyFilters(Rec);
                    Report.RunModal(Report::"Calc. Sales Price From Cost", true, false, SalesPriceWorksheet);
                end;
            }
            action(CalculatePriceFromMRSP)
            {
                ApplicationArea = Basic;
                Caption = 'Calculate Price From MRSP';
                Ellipsis = true;
                Image = SuggestSalesPrice;
                Promoted = false;

                trigger OnAction()
                var
                    SalesPriceWorksheet: Record "Sales Price Worksheet";
                begin
                    SalesPriceWorksheet.Reset;
                    SalesPriceWorksheet.CopyFilters(Rec);
                    Report.RunModal(Report::"Calc. Sales Price From MRSP", true, false, SalesPriceWorksheet);
                end;
            }
            action(CalculatePriceFromPurchasePrice)
            {
                ApplicationArea = Basic;
                Caption = 'Calculate Price From Purchase Price';
                Ellipsis = true;
                Image = SuggestSalesPrice;
                Promoted = false;

                trigger OnAction()
                var
                    SalesPriceWorksheet: Record "Sales Price Worksheet";
                begin
                    SalesPriceWorksheet.Reset;
                    SalesPriceWorksheet.CopyFilters(Rec);
                    Report.RunModal(Report::"Calc. Sales Price From Purch P", true, false, SalesPriceWorksheet);
                end;
            }
        }
    }
}
