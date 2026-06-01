Page 25006241 "Service Line FactBox EDMS"
{
    // 12.05.2015 EB.P30 #T030
    //   Added field:
    //     "Res. Cost Amount Total"
    // 
    // 17.12.2014 EDMS P12
    //   * Moved code form trigger OnLookup to OnDrillDown for field "Replacements Exist"
    // 
    // 08.09.2014 Elva baltic P8 #F0015 EDMS
    //   * Added field Item."Replacements Exist"

    Caption = 'Service Line Details';
    PageType = CardPart;
    SourceTable = "Service Line EDMS";

    layout
    {
        area(content)
        {
            field(ItemNo; Rec."No.")
            {
                ApplicationArea = Basic;
                Caption = 'Item No.';
                Lookup = false;

                trigger OnDrillDown()
                begin
                    ShowDetails;
                end;
            }
            field(Availability; StrSubstNo('%1', ServiceInfoPaneMgt.CalcAvailability(Rec)))
            {
                ApplicationArea = Basic;
                Caption = 'Availability';
                //DecimalPlaces = 2:0;
                DrillDown = true;
                Editable = true;

                trigger OnDrillDown()
                begin
                    Rec.ItemAvailability(0);
                    CurrPage.Update(true);
                end;
            }
            field(Inventory; ServiceInfoPaneMgt.CalcAvailableInventory(Rec))
            {
                ApplicationArea = Basic;
                Caption = 'Inventory';

            }
            field(Substitutions; StrSubstNo('%1', ServiceInfoPaneMgt.CalcNoOfSubstitutions(Rec)))
            {
                ApplicationArea = Basic;
                Caption = 'Substitutions';
                DrillDown = true;
                Editable = true;

                trigger OnDrillDown()
                begin
                    Rec.ShowItemSub;
                    CurrPage.Update;
                end;
            }
            field(SalesPrices; StrSubstNo('%1', ServiceInfoPaneMgt.CalcNoOfSalesPrices(Rec)))
            {
                ApplicationArea = Basic;
                Caption = 'Sales Prices';
                DrillDown = true;
                Editable = true;

                trigger OnDrillDown()
                begin
                    ShowPrices;
                    CurrPage.Update;
                end;
            }
            field(Markup; SalesPriceCalcMgt.CalcNoOfSalesPrices(Rec))
            {
                ApplicationArea = all;
                Caption = 'Sales Markup';
                trigger OnDrillDown()
                Var
                    ServiceHeader: Record "Service Header EDMS";
                begin
                    ServiceHeader.GET(rec."Document Type", rec."Document No.");
                    CLEAR(SalesPriceCalcMgt);
                    SalesPriceCalcMgt.GetDMSServLinePrice(ServiceHeader, Rec);
                    CurrPage.UPDATE;

                end;
            }

            field(SalesLineDiscounts; StrSubstNo('%1', ServiceInfoPaneMgt.CalcNoOfSalesLineDisc(Rec)))
            {
                ApplicationArea = Basic;
                Caption = 'Sales Line Discounts';
                DrillDown = true;
                Editable = true;
                trigger OnDrillDown()
                begin
                    ShowLineDisc;
                    CurrPage.Update;
                end;
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
            field(ResCostAmountTotal; Rec."Res. Cost Amount Total")
            {
                ApplicationArea = Basic;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        if not Item.Get(Rec."No.") then  //08.09.2014 Elva baltic P8 #F0015 EDMS
            Item.Init;
        Item.CalcFields("Replacements Exist");

        LocationFilterForFactbox := Rec."Location Code";
        if UserProfile.Get(UserProfileMgt.CurrProfileID, UserProfileMgt.CurrBranchNo) and (UserProfile."Def. Spare Part Location Code" <> '') then
            LocationFilterForFactbox := UserProfile."Def. Spare Part Location Code";
        Item.SetFilter("Variant Filter", Rec."Variant Code");
        Item.SetFilter("Location Filter", LocationFilterForFactbox);
        Item.SetFilter("Drop Shipment Filter", '%1', false);
        Item.CalcFields(Inventory);
    end;

    var
        ServiceHeader: Record "Service Header EDMS";
        Item: Record Item;
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt. EDMS";
        ServiceInfoPaneMgt: Codeunit "Service Info-Pane Mgt. EDMS";
        LocationFilterForFactbox: Text;
        UserProfile: Record "Branch Profile Setup";
        UserProfileMgt: Codeunit UserProfileManagement;


    procedure ShowDetails()
    var
        Item: Record Item;
    begin
        if Rec.Type = Rec.Type::Item then begin
            Item.Get(Rec."No.");
            Page.Run(Page::"Item Card", Item);
        end;
    end;


    procedure ShowPrices()
    var
        ServiceHeader: Record "Service Header EDMS";
    begin
        ServiceHeader.Get(Rec."Document Type", Rec."Document No.");

        If rec.Type = rec.Type::Item then
            PickPrice()
        else
            SalesPriceCalcMgt.GetDMSServLinePrice(ServiceHeader, Rec);
    end;

    procedure PickPrice()
    var
        PriceCalculation: Interface "Price Calculation";
        SalesHeader: Record "Sales Header" temporary;
        SalesLine: Record "Sales Line" temporary;
        PriceType: Enum "Price Type";
    begin
        ServiceHeader.get(rec."Document Type", rec."Document No.");
        SalesPriceCalcMgt.CreateSalesDocument(ServiceHeader, rec, SalesHeader, SalesLine);
        SalesLine.PickPrice();
        if SalesLine."Unit Price" <> 0 then
            rec.VALIDATE("Unit Price", SalesLine."Unit Price");

        //GetPriceCalculationHandler(PriceType::Sale, SalesHeader, SalesLine, PriceCalculation);
        //PriceCalculation.PickPrice();
        //GetLineWithCalculatedPrice(PriceCalculation);





    end;

    procedure PickDiscount()
    var
        PriceCalculation: Interface "Price Calculation";
        SalesHeader: Record "Sales Header" temporary;
        SalesLine: Record "Sales Line" temporary;
        PriceType: Enum "Price Type";
    begin
        ServiceHeader.get(rec."Document Type", rec."Document No.");
        SalesPriceCalcMgt.CreateSalesDocument(ServiceHeader, rec, SalesHeader, SalesLine);
        GetPriceCalculationHandler(PriceType::Sale, SalesHeader, SalesLine, PriceCalculation);
        SalesLine.PickDiscount();
        //PriceCalculation.PickDiscount();
        If SalesLine."Line Discount %" <> 0 then
            rec.VALIDATE("Line Discount %", SalesLine."Line Discount %");
        //GetLineWithCalculatedPrice(PriceCalculation);


    end;




    procedure GetPriceCalculationHandler(PriceType: Enum "Price Type"; SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; var PriceCalculation: Interface "Price Calculation")
    var
        PriceCalculationMgt: codeunit "Price Calculation Mgt.";
        LineWithPrice: Interface "Line With Price";

    begin
        if (SalesHeader."No." = '') and (rec."Document No." <> '') then
            SalesHeader.Get(rec."Document Type", rec."Document No.");
        GetLineWithPrice(LineWithPrice);
        LineWithPrice.SetLine(PriceType, SalesHeader, SalesLine);
        PriceCalculationMgt.GetHandler(LineWithPrice, PriceCalculation);
    end;

    procedure GetLineWithPrice(var LineWithPrice: Interface "Line With Price")
    var
        SalesLinePrice: Codeunit "Sales Line - Price";
    begin
        LineWithPrice := SalesLinePrice;

    end;


    local procedure GetLineWithCalculatedPrice(var PriceCalculation: Interface "Price Calculation")
    var
        Line: Variant;
    begin
        PriceCalculation.GetLine(Line);
        //  Rec := Line;
    end;




    procedure ShowLineDisc()
    var
        recServiceHeader: Record "Service Header EDMS";
    begin
        ServiceHeader.Get(Rec."Document Type", Rec."Document No.");
        If rec.Type = rec.Type::Item then
            PickDiscount()
        else
            SalesPriceCalcMgt.GetDMSServLineLineDisc(ServiceHeader, Rec);
    end;

    local procedure ShowInventory()
    var
        ItemLedgerEntry: Record "Item Ledger Entry";
    begin
        ItemLedgerEntry.Reset;
        ItemLedgerEntry.SetRange("Item No.", Rec."No.");
        ItemLedgerEntry.SetRange("Location Code", LocationFilterForFactbox);
        ItemLedgerEntry.SetRange("Variant Code", Rec."Variant Code");
        Page.Run(Page::"Item Ledger Entries", ItemLedgerEntry);
    end;
}

