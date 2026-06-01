Codeunit 25006614 "Rent Price & Disc. Calc. Mgt."
{

    trigger OnRun()
    begin
    end;

    var
        GLSetup: Record "General Ledger Setup";
        Currency: Record Currency;
        TempSalesPrice: Record "Rent Item Sales Price" temporary;
        VATCalcType: Option "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        RentSetup: Record "Rent Mgt. Setup";
        VATPerCent: Decimal;
        PricesInclVAT: Boolean;
        PricesInCurrency: Boolean;
        CurrencyFactor: Decimal;
        ExchRateDate: Date;
        FoundSalesPrice: Boolean;
        VATBusPostingGr: Code[10];
        Text010: label 'Prices including VAT cannot be calculated when %1 is %2.';
        TempTableErr: Label 'The table passed as a parameter must be temporary.';


    local procedure CalcBestUnitPrice(var SalesPrice: Record "Rent Item Sales Price")
    var
        BestSalesPrice: Record "Rent Item Sales Price";
        CustomerPriceGroup: Record "Customer Price Group";
        VATProdPostingGroup: Code[20];
        RentItemCategory: Record "Rent Item Category";
        RentItem: Record "Rent Item";
        BestSalesPriceFound: Boolean;
    begin
        /*
        with SalesPrice do begin
            SalesPrice.Reset;
            SalesPrice.SetCurrentkey("Rent Period Price");
            if SalesPrice.FindFirst then begin
                FoundSalesPrice := true;
                if (RentItem.Get(SalesPrice."Rent Item No.")) then
                    if RentItemCategory.Get(RentItem."Rent Item Category Code") then
                        VATProdPostingGroup := RentItemCategory."Def. VAT Prod. Posting Group";
                ConvertPriceToVAT("Price Includes VAT", VATProdPostingGroup, "VAT Bus. Posting Gr. (Price)", "Rent Period Price");
                ConvertPriceLCYToFCY("Currency Code", "Rent Period Price");
            end;
        end;
        */
        if SalesPrice.FindSet then
            repeat
                ConvertPriceToVAT(SalesPrice."Price Includes VAT", VATProdPostingGroup, SalesPrice."VAT Bus. Posting Gr. (Price)", SalesPrice."Rent Period Price");
                //ConvertPriceToUoM("Unit of Measure Code", "Rent Period Price");
                ConvertPriceLCYToFCY(SalesPrice."Currency Code", SalesPrice."Rent Period Price");
                case true of
                    ((BestSalesPrice."Currency Code" = '') and (SalesPrice."Currency Code" <> '')):
                        begin
                            BestSalesPrice := SalesPrice;
                            BestSalesPriceFound := true;
                        end;
                    ((BestSalesPrice."Currency Code" = '') or (SalesPrice."Currency Code" <> '')):
                        if (BestSalesPrice."Rent Period Price" = 0) or
                            (BestSalesPrice."Rent Period Price" > SalesPrice."Rent Period Price")
                        then begin
                            BestSalesPrice := SalesPrice;
                            BestSalesPriceFound := true;
                        end;
                end;
            until SalesPrice.Next = 0;
        SalesPrice := BestSalesPrice;
    end;


    procedure FindSalesPrice(
      var ToSalesPrice: Record "Rent Item Sales Price";
      CustNo: Code[20];
      ContNo: Code[20];
      CustPriceGrCode: Code[10];
      CampaignNo: Code[20];
      RentItemNo: Code[20];
      RentPeriodType: Code[10];
      CurrencyCode: Code[10];
      StartingDate: Date;
      ShowAll: Boolean)
    var
        FromSalesPrice: Record "Rent Item Sales Price";
        TempTargetCampaignGr: Record "Campaign Target Group" temporary;
        VariableFieldUsage: Record "Variable Field Usage";
    begin
        FromSalesPrice.SetRange("Rent Item No.", RentItemNo);
        FromSalesPrice.SetRange("Rent Period Code", RentPeriodType);
        FromSalesPrice.SetFilter("Ending Date", '%1|>=%2', 0D, StartingDate);

        if not ShowAll then begin
            FromSalesPrice.SetFilter("Currency Code", '%1|%2', CurrencyCode, '');
            FromSalesPrice.SetRange("Starting Date", 0D, StartingDate);
        end;

        ToSalesPrice.Reset;
        ToSalesPrice.DeleteAll;

        FromSalesPrice.SetRange("Sales Type", FromSalesPrice."sales type"::"All Customers");
        FromSalesPrice.SetRange("Sales Code");
        CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);

        if CustNo <> '' then begin
            FromSalesPrice.SetRange("Sales Type", FromSalesPrice."sales type"::Customer);
            FromSalesPrice.SetRange("Sales Code", CustNo);
            CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
        end;

        if CustPriceGrCode <> '' then begin
            FromSalesPrice.SetRange("Sales Type", FromSalesPrice."sales type"::"Customer Price Group");
            FromSalesPrice.SetRange("Sales Code", CustPriceGrCode);
            CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
        end;

        if not ((CustNo = '') and (ContNo = '') and (CampaignNo = '')) then begin
            FromSalesPrice.SetRange("Sales Type", FromSalesPrice."sales type"::Campaign);
            if ActivatedCampaignExists(TempTargetCampaignGr, CustNo, ContNo, CampaignNo) then
                repeat
                    FromSalesPrice.SetRange("Sales Code", TempTargetCampaignGr."Campaign No.");
                    CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
                until TempTargetCampaignGr.Next = 0;
        end;
    end;

    procedure ActivatedCampaignExists(var ToCampaignTargetGr: Record "Campaign Target Group"; CustNo: Code[20]; ContNo: Code[20]; CampaignNo: Code[20]): Boolean
    var
        FromCampaignTargetGr: Record "Campaign Target Group";
        Cont: Record Contact;
        IsHandled: Boolean;
        recCampaign: Record Campaign;
    begin
        if not ToCampaignTargetGr.IsTemporary then
            Error(TempTableErr);

        //IsHandled := false;
        //OnBeforeActivatedCampaignExists(ToCampaignTargetGr, CustNo, ContNo, CampaignNo, IsHandled);
        //IF IsHandled then
        //    exit;
        ToCampaignTargetGr.Reset();
        ToCampaignTargetGr.DeleteAll();

        if CampaignNo <> '' then begin
            ToCampaignTargetGr."Campaign No." := CampaignNo;
            ToCampaignTargetGr.Insert();
        end else begin
            FromCampaignTargetGr.SetRange(Type, FromCampaignTargetGr.Type::Customer);
            FromCampaignTargetGr.SetRange("No.", CustNo);
            if FromCampaignTargetGr.FindSet then
                repeat
                    ToCampaignTargetGr := FromCampaignTargetGr;
                    ToCampaignTargetGr.Insert();
                until FromCampaignTargetGr.Next = 0
            else
                if Cont.Get(ContNo) then begin
                    FromCampaignTargetGr.SetRange(Type, FromCampaignTargetGr.Type::Contact);
                    FromCampaignTargetGr.SetRange("No.", Cont."Company No.");
                    if FromCampaignTargetGr.FindSet then
                        repeat
                            ToCampaignTargetGr := FromCampaignTargetGr;
                            ToCampaignTargetGr.Insert();
                        until FromCampaignTargetGr.Next = 0;
                end;

            //20.03.2013 EDMS >>
            recCampaign.Reset;

            recCampaign.SetCurrentkey("Activated (Sales)");
            recCampaign.SetRange("Activated (Sales)", true);
            recCampaign.SetRange("Campaign Applies to All");
            if recCampaign.FindSet then
                repeat
                    ToCampaignTargetGr.Init;
                    ToCampaignTargetGr.Type := ToCampaignTargetGr.Type::Customer;
                    ToCampaignTargetGr."No." := CustNo;
                    ToCampaignTargetGr."Campaign No." := recCampaign."No.";
                    if ToCampaignTargetGr.Insert then;
                until recCampaign.Next = 0;
            //20.03.2013 EDMS <<

        end;
        exit(ToCampaignTargetGr.FindFirst);
    end;


    procedure CopySalesPrice(var SalesPrice: Record "Rent Item Sales Price")
    begin
        SalesPrice.DeleteAll;
        CopySalesPriceToSalesPrice(TempSalesPrice, SalesPrice);
    end;

    local procedure CopySalesPriceToSalesPrice(var FromSalesPrice: Record "Rent Item Sales Price"; var ToSalesPrice: Record "Rent Item Sales Price")
    begin
        if FromSalesPrice.FindSet then
            repeat
                ToSalesPrice := FromSalesPrice;
                ToSalesPrice.Insert;
            until FromSalesPrice.Next = 0;
    end;

    local procedure CopySalesDiscToSalesDisc(var FromSalesLineDisc: Record "Rent Item Sales Discount"; var ToSalesLineDisc: Record "Rent Item Sales Discount")
    begin
        if FromSalesLineDisc.FindSet then
            repeat
                if FromSalesLineDisc."Line Discount %" <> 0 then begin
                    ToSalesLineDisc := FromSalesLineDisc;
                    ToSalesLineDisc.Insert;
                end;
            until FromSalesLineDisc.Next = 0;
    end;


    procedure SalesLinePriceExists(RentHeader: Record "Rent Header"; var RentLine: Record "Rent Line"; ShowAll: Boolean): Boolean
    begin
        FindSalesPrice(
  TempSalesPrice, RentHeader."Bill-to Customer No.", RentHeader."Bill-to Contact No.",
  RentHeader."Customer Price Group", '', RentLine."Rent Item No.", RentLine."Rent Period Type", RentHeader."Currency Code",
  RentHeader."Document Date", false);
        exit(TempSalesPrice.FindFirst);
        exit(false);
    end;

    local procedure RentHeaderExchDate(RentHeader: Record "Rent Header"): Date
    begin
        if (RentHeader."Document Type" in [RentHeader."document type"::Quote]) and
   (RentHeader."Posting Date" = 0D)
then
            exit(WorkDate);
        exit(RentHeader."Posting Date");
    end;


    procedure FindSalesLinePrice4Weeks(RentHeader: Record "Rent Header"; var RentLine: Record "Rent Line"; CalledByFieldNo: Integer)
    var
        Customer: Record Customer;
        CustomerPriceGroup: Record "Customer Price Group";
    begin
        RentSetup.Get;

        SetCurrency(RentHeader."Currency Code", RentHeader."Currency Factor", RentHeaderExchDate(RentHeader));
        SetVAT(false, RentLine."VAT %", RentLine."VAT Calculation Type", RentLine."VAT Bus. Posting Group");
        if PricesInCurrency then
            RentHeader.TestField("Currency Factor");
        FindSalesPrice(
          TempSalesPrice, RentHeader."Bill-to Customer No.", RentHeader."Bill-to Contact No.",
          RentHeader."Customer Price Group", '', RentLine."Rent Item No.", RentSetup."Default 4 Weeks Rent Period", RentHeader."Currency Code",
          RentHeader."Document Date", false);
        CalcBestUnitPrice(TempSalesPrice);
        OnAfterFindRentSalesPrice4Weeks(RentLine, TempSalesPrice);
    end;


    procedure FindSalesLinePriceWeekly(RentHeader: Record "Rent Header"; var RentLine: Record "Rent Line"; CalledByFieldNo: Integer)
    var
        Customer: Record Customer;
        CustomerPriceGroup: Record "Customer Price Group";
    begin
        RentSetup.Get;
        SetCurrency(RentHeader."Currency Code", RentHeader."Currency Factor", RentHeaderExchDate(RentHeader));
        SetVAT(false, RentLine."VAT %", RentLine."VAT Calculation Type", RentLine."VAT Bus. Posting Group");
        if PricesInCurrency then
            RentHeader.TestField("Currency Factor");
        FindSalesPrice(
          TempSalesPrice, RentHeader."Bill-to Customer No.", RentHeader."Bill-to Contact No.",
          RentHeader."Customer Price Group", '', RentLine."Rent Item No.", RentSetup."Default Weekly Rent Period", RentHeader."Currency Code",
          RentHeader."Document Date", false);
        CalcBestUnitPrice(TempSalesPrice);
        OnAfterFindRentSalesPriceWeekly(RentLine, TempSalesPrice);
    end;


    procedure FindSalesLinePriceDaily(RentHeader: Record "Rent Header"; var RentLine: Record "Rent Line"; CalledByFieldNo: Integer)
    var
        Customer: Record Customer;
        CustomerPriceGroup: Record "Customer Price Group";
    begin
        RentSetup.Get;
        SetCurrency(RentHeader."Currency Code", RentHeader."Currency Factor", RentHeaderExchDate(RentHeader));
        SetVAT(false, RentLine."VAT %", RentLine."VAT Calculation Type", RentLine."VAT Bus. Posting Group");
        if PricesInCurrency then
            RentHeader.TestField("Currency Factor");
        FindSalesPrice(
          TempSalesPrice, RentHeader."Bill-to Customer No.", RentHeader."Bill-to Contact No.",
          RentHeader."Customer Price Group", '', RentLine."Rent Item No.", RentSetup."Default Daily Rent Period", RentHeader."Currency Code",
          RentHeader."Document Date", false);

        CalcBestUnitPrice(TempSalesPrice);

        OnAfterFindRentSalesPriceDaily(RentLine, TempSalesPrice);
    end;

    local procedure ConvertPriceToVAT(FromPricesInclVAT: Boolean; FromVATProdPostingGr: Code[10]; FromVATBusPostingGr: Code[10]; var UnitPrice: Decimal)
    var
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        if FromPricesInclVAT then begin
            VATPostingSetup.Get(FromVATBusPostingGr, FromVATProdPostingGr);

            case VATPostingSetup."VAT Calculation Type" of
                VATPostingSetup."vat calculation type"::"Reverse Charge VAT":
                    VATPostingSetup."VAT %" := 0;
                VATPostingSetup."vat calculation type"::"Sales Tax":
                    Error(
                      Text010,
                      VATPostingSetup.FieldCaption("VAT Calculation Type"),
                      VATPostingSetup."VAT Calculation Type");
            end;

            case VATCalcType of
                Vatcalctype::"Normal VAT",
                Vatcalctype::"Full VAT",
                Vatcalctype::"Sales Tax":
                    begin
                        if PricesInclVAT then begin
                            if VATBusPostingGr <> FromVATBusPostingGr then
                                UnitPrice := UnitPrice * (100 + VATPerCent) / (100 + VATPostingSetup."VAT %");
                        end else
                            UnitPrice := UnitPrice / (1 + VATPostingSetup."VAT %" / 100);
                    end;
                Vatcalctype::"Reverse Charge VAT":
                    UnitPrice := UnitPrice / (1 + VATPostingSetup."VAT %" / 100);
            end;
        end else
            if PricesInclVAT then
                UnitPrice := UnitPrice * (1 + VATPerCent / 100);
    end;

    local procedure SetVAT(PriceInclVAT2: Boolean; VATPerCent2: Decimal; VATCalcType2: Option; VATBusPostingGr2: Code[10])
    begin
        PricesInclVAT := PriceInclVAT2;
        VATPerCent := VATPerCent2;
        VATCalcType := VATCalcType2;
        VATBusPostingGr := VATBusPostingGr2;
    end;

    local procedure ConvertPriceLCYToFCY(CurrencyCode: Code[10]; var UnitPrice: Decimal)
    var
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        if PricesInCurrency then begin
            if CurrencyCode = '' then
                UnitPrice :=
                  CurrExchRate.ExchangeAmtLCYToFCY(ExchRateDate, Currency.Code, UnitPrice, CurrencyFactor);
            UnitPrice := ROUND(UnitPrice, Currency."Unit-Amount Rounding Precision");
        end else
            UnitPrice := ROUND(UnitPrice, GLSetup."Unit-Amount Rounding Precision");
    end;

    local procedure SetCurrency(CurrencyCode2: Code[10]; CurrencyFactor2: Decimal; ExchRateDate2: Date)
    begin
        PricesInCurrency := CurrencyCode2 <> '';
        if PricesInCurrency then begin
            Currency.Get(CurrencyCode2);
            Currency.TestField("Unit-Amount Rounding Precision");
            CurrencyFactor := CurrencyFactor2;
            ExchRateDate := ExchRateDate2;
        end else
            GLSetup.Get;
    end;


    procedure FindSalesLinePrice(RentHeader: Record "Rent Header"; var RentLine: Record "Rent Line"; CalledByFieldNo: Integer)
    var
        Customer: Record Customer;
        CustomerPriceGroup: Record "Customer Price Group";
        RentPeriod: Record "Rent Period";
    begin
        SetCurrency(RentHeader."Currency Code", RentHeader."Currency Factor", RentHeaderExchDate(RentHeader));
        SetVAT(RentHeader."Prices Including VAT", RentLine."VAT %", RentLine."VAT Calculation Type", RentLine."VAT Bus. Posting Group");
        if PricesInCurrency then
            RentHeader.TestField("Currency Factor");

        FindSalesPrice(
          TempSalesPrice, RentHeader."Bill-to Customer No.", RentHeader."Bill-to Contact No.",
          RentHeader."Customer Price Group", '', RentLine."Rent Item No.", RentLine."Rent Period Type", RentHeader."Currency Code",
          RentHeader."Document Date", false);

        CalcBestUnitPrice(TempSalesPrice);

        if FoundSalesPrice or not (CalledByFieldNo = RentLine.FieldNo(Quantity))
        then begin
            RentLine."Unit Price" := TempSalesPrice."Rent Period Price";
        end;
        OnAfterFindRentSalesPrice(RentLine, TempSalesPrice);
    end;

    procedure FindRentItemDisc(RentHeader: Record "Rent Header"; var RentLine: Record "Rent Line"): Decimal
    var
        TempRentItemDisc: Record "Rent Item Sales Discount" temporary;
    begin
        FillTempRentItemDisc(TempRentItemDisc, true, RentHeader."Currency Code", RentHeader."Document Date", RentHeader."Document Date", RentLine."Rent Item No.", RentHeader."Sell-to Customer No."
                              , '', RentLine."Rent Period Type");
        TempRentItemDisc.Reset;
        TempRentItemDisc.SetCurrentkey("Line Discount %");
        TempRentItemDisc.SetAscending("Line Discount %", false);
        if TempRentItemDisc.FindLast then
            exit(TempRentItemDisc."Line Discount %")
        else
            exit(0);
    end;

    procedure FillTempRentItemDisc(var TempRentItemDisc: Record "Rent Item Sales Discount" temporary; UseDateFilter: Boolean; CurrencyCode: Code[10]; StartingDate: Date; EndingDate: Date; RentItemNo: Code[20]; CustomerNo: Code[20]; CampaignNo: Code[20]; RentPeriodCode: Code[10])
    var
        RentItemSalesDisc: Record "Rent Item Sales Discount";
        RentItem: Record "Rent Item";
        Customer: Record Customer;
    begin
        RentItemSalesDisc.Reset;
        RentItemSalesDisc.SetFilter("Currency Code", '%1|%2', CurrencyCode, '');
        if UseDateFilter then begin
            RentItemSalesDisc.SetFilter("Starting Date", '%1|<=%2', 0D, StartingDate);
            RentItemSalesDisc.SetFilter("Ending Date", '%1|<=%2', 0D, EndingDate);
        end;
        RentItemSalesDisc.SetFilter("Rent Period Code", '%1|%2', RentPeriodCode, '');

        for RentItemSalesDisc.Type := RentItemSalesDisc.Type::" " to RentItemSalesDisc.Type::"Rent Item Category" do begin
            RentItemSalesDisc.SetFilter(Type, '%1|%2', RentItemSalesDisc.Type, RentItemSalesDisc.Type::" ");
            case RentItemSalesDisc.Type of
                RentItemSalesDisc.Type::" ":
                    RentItemSalesDisc.SetFilter(Code, '%1', '');
                RentItemSalesDisc.Type::"Rent Item":
                    RentItemSalesDisc.SetFilter(Code, '%1|%2', RentItemNo, '');
                RentItemSalesDisc.Type::"Rent Item Category":
                    begin
                        if RentItemNo <> '' then begin
                            RentItem.Get(RentItemNo);
                            if RentItem."Rent Item Category Code" <> '' then
                                RentItemSalesDisc.SetFilter(Code, '%1|%2', RentItem."Rent Item Category Code", '')
                            else
                                RentItemSalesDisc.SetFilter(Code, '%1', '');
                        end;
                    end;
            end;
            for RentItemSalesDisc."Sales Type" := RentItemSalesDisc."sales type"::"All Customers" to RentItemSalesDisc."sales type"::"Customer Discount Group" do begin
                case RentItemSalesDisc."Sales Type" of
                    RentItemSalesDisc."sales type"::Customer:
                        RentItemSalesDisc.SetRange("Sales Code", CustomerNo);
                    RentItemSalesDisc."sales type"::"All Customers":
                        RentItemSalesDisc.SetRange("Sales Code");
                    RentItemSalesDisc."sales type"::"Customer Discount Group":
                        begin
                            Customer.Get(CustomerNo);
                            RentItemSalesDisc.SetRange("Sales Code", Customer."Customer Disc. Group");
                        end;
                end;
                if RentItemSalesDisc.FindSet then
                    repeat
                        TempRentItemDisc.Init;
                        TempRentItemDisc.TransferFields(RentItemSalesDisc);
                        TempRentItemDisc.Insert;
                    until RentItemSalesDisc.Next = 0;
            end;
        end;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterFindRentSalesPrice(var RentLine: Record "Rent Line"; var RentSalesPrice: Record "Rent Item Sales Price")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterFindRentSalesPrice4Weeks(var RentLine: Record "Rent Line"; var RentSalesPrice: Record "Rent Item Sales Price")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterFindRentSalesPriceDaily(var RentLine: Record "Rent Line"; var RentSalesPrice: Record "Rent Item Sales Price")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterFindRentSalesPriceWeekly(var RentLine: Record "Rent Line"; var RentSalesPrice: Record "Rent Item Sales Price")
    begin
    end;
}

