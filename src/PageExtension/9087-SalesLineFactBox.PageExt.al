pageextension 25006458 "Sales Line FactBox" extends "Sales Line FactBox" //9087
{
    layout
    {
        addafter(Item)
        {
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
        addafter(SalesPrices)
        {
            field(Markup; SalesPriceCalcMgtEDMS.CalcNoOfSalesMarkupPrices(Rec))
            {
                ApplicationArea = all;
                Caption = 'Sales Markup';
                trigger OnDrillDown()
                Var
                    SalesHeader: Record "Sales Header";
                begin
                    SalesHeader.GET(rec."Document Type", rec."Document No.");
                    CLEAR(SalesPriceCalcMgtEDMS);
                    SalesPriceCalcMgtEDMS.GetSalesLinePrice(SalesHeader, Rec);
                    CurrPage.UPDATE;

                end;
            }
        }
    }


    trigger OnOpenPage()
    begin
        if not Item.Get(Rec."No.") then  //08.09.2014 Elva baltic P8 #F0015 EDMS
            Item.Init;

        Item.CalcFields("Replacements Exist") // 17.12.2014 EDMS P12
    end;

    var
        Item: Record Item;
        SalesInfoPaneMgt: Codeunit "Sales Info-Pane Management";
        SalesPriceCalcMgtEDMS: Codeunit "Sales Price Calc. Mgt. EDMS";
}