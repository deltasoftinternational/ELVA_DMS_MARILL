//>>DELTA 01 RC (28/09/2022) Rajout Filtrer Article lors de la recherche de la remise.
Codeunit 25006301 "VehicleSalesPriceDiscountMgt"
{
    // 11.04.2013 EDMS P8
    //   * changes due to new field in T25006374


    trigger OnRun()
    begin
    end;

    var
        SalesSetup: Record "Sales & Receivables Setup";
        VehAssembly: Record "Vehicle Assembly Line";
        VehAssemblyHdr: Record "Vehicle Assembly Header";
        GLSetup: Record "General Ledger Setup";
        Currency: Record Currency;
        Item: Record Item;
        ManufacturerOption: Record "Manufacturer Option";
        OwnOption: Record "Own Option";
        TempAssemblyPrice: Record "Sales Price DMS" temporary;
        TempAssemblyLineDisc: Record "Sales Line Discount DMS" temporary;
        TempOptSalesPrice: Record "Option Sales Price" temporary;
        Make: Record Make;
        PricesInCurrency: Boolean;
        VATPerCent: Decimal;
        PricesInclVAT: Boolean;
        VATCalcType: Option "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        VATBusPostingGr: Code[10];
        VATProdPostingGr: Code[10];
        CurrencyFactor: Decimal;
        ExchRateDate: Date;
        LineDiscPerCent: Decimal;
        AllowLineDisc: Boolean;
        AllowInvDisc: Boolean;
        Text010: label 'Prices including VAT cannot be calculated when %1 is %2.';
        FoundAssemblyPrice: Boolean;
        VehPriceCalcMgt: Codeunit VehicleSalesPriceDiscountMgt;


    procedure GetOptionLineDiscount(OptionCode: Code[20]; OptionType: Option "Manufacturer Option","Own Option","Vehicle Base"; OptionSubtype: Option Option,Color,Upholstery; MakeCode: Code[20]; ModelCode: Code[20]; ModelVerNo: Code[20]; VehSerialNo: Code[20]; VehAssemblyNo: Code[20]): Decimal
    begin
        SalesSetup.Get;
        SetCurrency(SalesSetup."Def.S.Price Currency Code", 0, 0D);

        if SalesSetup."Def.Sales Price AllowLineDisc." then begin
            FindOptionDiscount(
              TempAssemblyLineDisc, '', '', '', '', OptionCode, '',
              WorkDate, false, MakeCode, ModelCode, ModelVerNo, OptionType, OptionSubtype);

            CalcBestAssemblyLineDisc(TempAssemblyLineDisc);
            exit(TempAssemblyLineDisc."Line Discount %")
        end else
            exit(0)
    end;


    procedure GetOptionPrice(OptionCode: Code[20]; OptionType: Option "Manufacturer Option","Own Option","Vehicle Base"; OptionSubtype: Option Option,Color,Upholstery; MakeCode: Code[20]; ModelCode: Code[20]; ModelVerNo: Code[20]; VehSerialNo: Code[20]; VehAssemblyID: Code[20]): Decimal
    var
        VATPostSetup: Record "VAT Posting Setup";
        UnitPrice: Decimal;
        LineDisc: Decimal;
    begin
        SalesSetup.Get;
        SalesSetup.TestField("Def.S.Price Rounding Precision");

        if (SalesSetup."Def.S.Price VAT Bus.Post.Grp." <> '') and (SalesSetup."Def.S.Price VAT Prod.Post.Grp." <> '') then
            VATPostSetup.Get(SalesSetup."Def.S.Price VAT Bus.Post.Grp.", SalesSetup."Def.S.Price VAT Prod.Post.Grp.");

        SetCurrency(SalesSetup."Def.S.Price Currency Code", 0, 0D);
        SetVAT(SalesSetup."Def. Sales Price Include VAT", VATPostSetup."VAT %",
          VATPostSetup."VAT Calculation Type", SalesSetup."Def.S.Price VAT Bus.Post.Grp.");


        case OptionType of
            Optiontype::"Manufacturer Option":
                if ManufacturerOption.Get(MakeCode, ModelCode, ModelVerNo, OptionSubtype, OptionCode) then begin
                    FindOptionPrice(TempAssemblyPrice, '', '', '', '', OptionCode, '', WorkDate,
                      false, MakeCode, ModelCode, ModelVerNo, OptionType, OptionSubtype);
                end;
            Optiontype::"Own Option":
                if OwnOption.Get(MakeCode, ModelCode, OptionCode) then begin
                    FindOptionPrice(TempAssemblyPrice, '', '', '', '', OptionCode, '', WorkDate,
                      false, MakeCode, ModelCode, ModelVerNo, OptionType, OptionSubtype);
                end;
            else
                Error('This place cannot be reached! Contact programmers')
        end;

        CalcBestAssemblyPrice(TempAssemblyPrice);

        if FoundAssemblyPrice then
            if SalesSetup."Def.Sales Price Include Disc." and TempAssemblyPrice."Allow Line Disc." and
             SalesSetup."Def.Sales Price AllowLineDisc." then begin
                LineDisc := GetOptionLineDiscount(OptionCode, OptionType, OptionSubtype, MakeCode, ModelCode, ModelVerNo, VehSerialNo, VehAssemblyID);
                UnitPrice := ROUND(TempAssemblyPrice."Unit Price" - TempAssemblyPrice."Unit Price" * (LineDisc / 100),
                  SalesSetup."Def.S.Price Rounding Precision");
                exit(UnitPrice)
            end else
                exit(ROUND(TempAssemblyPrice."Unit Price", SalesSetup."Def.S.Price Rounding Precision"))
        else
            exit(0)
    end;


    procedure FindAssemblyLineDisc(VehAssemblyHdr: Record "Vehicle Assembly Header"; var VehAssembly: Record "Vehicle Assembly Line")
    begin
        SetCurrency(VehAssemblyHdr."Currency Code", 0, 0D);

        AssemblyLineDiscExists(VehAssemblyHdr, VehAssembly, false);
        CalcBestAssemblyLineDisc(TempAssemblyLineDisc);

        VehAssembly."Line Discount %" := TempAssemblyLineDisc."Line Discount %";
    end;


    procedure FindAssemblyLinePrice(VehAssemblyHdr: Record "Vehicle Assembly Header"; var VehAssembly: Record "Vehicle Assembly Line")
    begin
        SetCurrency(
  VehAssemblyHdr."Currency Code", VehAssemblyHdr."Currency Factor", VehAssemblyHdr."Exchange Date");
        SetVAT(VehAssemblyHdr."Prices Including VAT", VehAssemblyHdr."VAT %",
          VehAssemblyHdr."VAT Calculation Type", VehAssemblyHdr."VAT Bus. Posting Group");
        SetLineDisc(VehAssemblyHdr."Line Discount %", VehAssemblyHdr."Allow Line Disc.", VehAssemblyHdr."Allow Invoice Disc.");
        if PricesInCurrency then
            VehAssemblyHdr.TestField("Currency Factor");

        AssemblyPriceExists(VehAssemblyHdr, VehAssembly, false);
        CalcBestAssemblyPrice(TempAssemblyPrice);
        //>>DELTA HT
        if not FoundAssemblyPrice then
            if VehAssembly."Option Type" = VehAssembly."Option Type"::"Vehicle Base" then
                if TempAssemblyPrice."Unit Price" <> 0 then begin
                    VehAssembly."Allow Line Disc." := TempAssemblyPrice."Allow Line Disc.";
                    VehAssembly."Sales Price" := TempAssemblyPrice."Unit Price";
                end;
        //<<DELTA HT

        if FoundAssemblyPrice then begin
            VehAssembly."Allow Line Disc." := TempAssemblyPrice."Allow Line Disc.";
            VehAssembly."Sales Price" := TempAssemblyPrice."Unit Price";
            if TempAssemblyPrice."Sales Type" = TempAssemblyPrice."sales type"::Campaign then
                VehAssembly."Campaign No." := TempAssemblyPrice."Sales Code";
        end;
        if not VehAssembly."Allow Line Disc." then
            VehAssembly."Line Discount %" := 0;
        OnAfterFindAssemblyLinePrice(VehAssembly, TempAssemblyPrice);
    end;


    procedure AssemblyPriceExists(VehAssemblyHdr: Record "Vehicle Assembly Header"; VehAssembly: Record "Vehicle Assembly Line"; ShowAll: Boolean): Boolean
    Var
        Ishandled: Boolean;
    begin
        case VehAssembly."Option Type" of
            VehAssembly."option type"::"Manufacturer Option":
                if ManufacturerOption.Get(VehAssembly."Make Code", VehAssembly."Model Code", VehAssembly."Model Version No.", VehAssembly."Option Subtype", VehAssembly."Option Code") then
                    FindOptionPrice(
                      TempAssemblyPrice, VehAssemblyHdr."Bill-to Customer No.", VehAssemblyHdr."Bill-to Contact No.",
                      VehAssemblyHdr."Customer Price Group", '', VehAssembly."Option Code", VehAssemblyHdr."Currency Code", VehAssemblyHdr."Start Date",
                      ShowAll, VehAssembly."Make Code", VehAssembly."Model Code", VehAssembly."Model Version No.", VehAssembly."Option Type", VehAssembly."Option Subtype");
            VehAssembly."option type"::"Own Option":
                if OwnOption.Get(VehAssembly."Make Code", VehAssembly."Model Code", VehAssembly."Option Code") then begin
                    OnBeforeFindOptionOwnOptionPrice(Ishandled, VehAssembly, TempAssemblyPrice, VehAssemblyHdr."Bill-to Customer No.", VehAssemblyHdr."Bill-to Contact No.",
                  VehAssemblyHdr."Customer Price Group", '', VehAssembly."Option Code", VehAssemblyHdr."Currency Code", VehAssemblyHdr."Start Date",
                  ShowAll, VehAssembly."Make Code", VehAssembly."Model Code", VehAssembly."Model Version No.", VehAssembly."Option Type", VehAssembly."Option Subtype");
                    If not Ishandled then
                        FindOptionPrice(
                          TempAssemblyPrice, VehAssemblyHdr."Bill-to Customer No.", VehAssemblyHdr."Bill-to Contact No.",
                          VehAssemblyHdr."Customer Price Group", '', VehAssembly."Option Code", VehAssemblyHdr."Currency Code", VehAssemblyHdr."Start Date",
                          ShowAll, VehAssembly."Make Code", VehAssembly."Model Code", VehAssembly."Model Version No.", VehAssembly."Option Type", VehAssembly."Option Subtype");
                end;
            VehAssembly."option type"::"Vehicle Base":
                if Item.Get(VehAssembly."Model Version No.") then
                    FindVehiclePriceBase(
                      TempAssemblyPrice, VehAssemblyHdr."Bill-to Customer No.", VehAssemblyHdr."Bill-to Contact No.",
                      VehAssemblyHdr."Customer Price Group", '', VehAssembly."Model Version No.",/*,"Variant Code","Unit of Measure Code",*/
                      VehAssemblyHdr."Currency Code", VehAssemblyHdr."Start Date", ShowAll, VehAssemblyHdr."Location Code",
                      VehAssemblyHdr."Ordering Price Type Code", VehAssemblyHdr."Document Profile", VehAssembly."Serial No.");
            VehAssembly."option type"::Item:
                if Item.Get(VehAssembly."Option Code") then
                    FindVehiclePrice(
                      TempAssemblyPrice, VehAssemblyHdr."Bill-to Customer No.", VehAssemblyHdr."Bill-to Contact No.",
                      VehAssemblyHdr."Customer Price Group", '', VehAssembly."Option Code",/*,"Variant Code","Unit of Measure Code",*/
                      VehAssemblyHdr."Currency Code", VehAssemblyHdr."Start Date", ShowAll, VehAssemblyHdr."Location Code",
                      VehAssemblyHdr."Ordering Price Type Code", VehAssemblyHdr."Document Profile", VehAssembly."Serial No.");
        end;
        exit(TempAssemblyPrice.FindSet);

    end;


    procedure AssemblyLineDiscExists(VehAssemblyHdr: Record "Vehicle Assembly Header"; VehAssembly: Record "Vehicle Assembly Line"; ShowAll: Boolean): Boolean
    begin
        case VehAssembly."Option Type" of
            VehAssembly."option type"::"Manufacturer Option":
                if ManufacturerOption.Get(VehAssembly."Make Code", VehAssembly."Model Code", VehAssembly."Model Version No.", VehAssembly."Option Subtype", VehAssembly."Option Code") then
                    FindOptionDiscount(
                      TempAssemblyLineDisc, VehAssemblyHdr."Bill-to Customer No.", VehAssemblyHdr."Bill-to Contact No.",
                      VehAssemblyHdr."Customer Disc. Group", '', VehAssembly."Option Code", VehAssemblyHdr."Currency Code",
                      VehAssemblyHdr."Start Date", ShowAll, VehAssembly."Make Code", VehAssembly."Model Code", VehAssembly."Model Version No.", VehAssembly."Option Type", VehAssembly."Option Subtype");
            VehAssembly."option type"::"Own Option":
                if OwnOption.Get(VehAssembly."Make Code", VehAssembly."Model Code", VehAssembly."Option Code") then
                    FindOptionDiscount(
                      TempAssemblyLineDisc, VehAssemblyHdr."Bill-to Customer No.", VehAssemblyHdr."Bill-to Contact No.",
                      VehAssemblyHdr."Customer Disc. Group", '', VehAssembly."Option Code", VehAssemblyHdr."Currency Code",
                      VehAssemblyHdr."Start Date", ShowAll, VehAssembly."Make Code", VehAssembly."Model Code", VehAssembly."Model Version No.", VehAssembly."Option Type", VehAssembly."Option Subtype");
            VehAssembly."option type"::"Vehicle Base":
                if Item.Get(VehAssembly."Model Version No.") then
                    FindVehicleDiscount(
                      TempAssemblyLineDisc, VehAssemblyHdr."Bill-to Customer No.", VehAssemblyHdr."Bill-to Contact No.",
                      VehAssemblyHdr."Customer Disc. Group", '', VehAssembly."Option Code", Item."Item Disc. Group",
                      VehAssemblyHdr."Currency Code", VehAssemblyHdr."Start Date", ShowAll, VehAssembly."Serial No.");
            VehAssembly."option type"::Item:
                if Item.Get(VehAssembly."Option Code") then
                    FindVehicleDiscount(
                      TempAssemblyLineDisc, VehAssemblyHdr."Bill-to Customer No.", VehAssemblyHdr."Bill-to Contact No.",
                      VehAssemblyHdr."Customer Disc. Group", '', VehAssembly."Option Code", Item."Item Disc. Group",
                      VehAssemblyHdr."Currency Code", VehAssemblyHdr."Start Date", ShowAll, VehAssembly."Serial No.");
        end;
        exit(TempAssemblyLineDisc.FindSet)
    end;


    procedure CalcBestAssemblyPrice(var SalesPrice: Record "Sales Price DMS")
    var
        BestSalesPrice: Record "Sales Price DMS";
    begin
        SalesPrice.SetFilter("Vehicle Serial No.", '<>''''');   //21.11.2007 EDMS P3 - priority to serialNo.
        FoundAssemblyPrice := not SalesPrice.IsEmpty;
        if not FoundAssemblyPrice then begin
            SalesPrice.SetRange("Vehicle Serial No.");
            FoundAssemblyPrice := not SalesPrice.IsEmpty;
        end;
        if FoundAssemblyPrice then
            repeat
                ConvertPriceToVAT(
                  SalesPrice."Price Includes VAT", Item."VAT Prod. Posting Group",
                  SalesPrice."VAT Bus. Posting Gr. (Price)", SalesPrice."Unit Price");
                ConvertPriceLCYToFCY(SalesPrice."Currency Code", SalesPrice."Unit Price");

                case true of
                    ((BestSalesPrice."Currency Code" = '') and (SalesPrice."Currency Code" <> '')) or
                  ((BestSalesPrice."Variant Code" = '') and (SalesPrice."Variant Code" <> '')):
                        BestSalesPrice := SalesPrice;
                    ((BestSalesPrice."Currency Code" = '') or (SalesPrice."Currency Code" <> '')) and
                  ((BestSalesPrice."Variant Code" = '') or (SalesPrice."Variant Code" <> '')):
                        if (BestSalesPrice."Unit Price" = 0) or
                           (CalcLineAmount(BestSalesPrice) > CalcLineAmount(SalesPrice))
                        then
                            BestSalesPrice := SalesPrice;
                end;
            until SalesPrice.Next = 0;

        // No price found in agreement
        if BestSalesPrice."Unit Price" = 0 then begin
            ConvertPriceToVAT(
              Item."Price Includes VAT", Item."VAT Prod. Posting Group",
              Item."VAT Bus. Posting Gr. (Price)", Item."Unit Price");
            ConvertPriceLCYToFCY('', Item."Unit Price");

            Clear(BestSalesPrice);
            BestSalesPrice."Unit Price" := Item."Unit Price";
            BestSalesPrice."Allow Line Disc." := AllowLineDisc;
            BestSalesPrice."Allow Invoice Disc." := AllowInvDisc;
        end;

        SalesPrice := BestSalesPrice;
    end;


    procedure CalcBestAssemblyLineDisc(var AssemblyLineDisc: Record "Sales Line Discount DMS")
    var
        BestSalesLineDisc: Record "Sales Line Discount DMS";
        FoundSalesLineDiscount: Boolean;
    begin
        //DELTA SALES PRICE
        //26.11.2007 EDMS P3 >>
        AssemblyLineDisc.SetRange("Sales Type", AssemblyLineDisc."sales type"::Assembly);
        FoundSalesLineDiscount := not AssemblyLineDisc.IsEmpty;
        if not FoundSalesLineDiscount then begin
            AssemblyLineDisc.SetRange("Sales Type");
            AssemblyLineDisc.SetFilter("Vehicle Serial No.", '<>''''');
            FoundSalesLineDiscount := not AssemblyLineDisc.IsEmpty;
            if not FoundSalesLineDiscount then begin
                AssemblyLineDisc.SetRange("Vehicle Serial No.");
                FoundSalesLineDiscount := not AssemblyLineDisc.IsEmpty;
            end
        end;
        //26.11.2007 EDMS P3 <<

        if FoundSalesLineDiscount then
            repeat
                case true of
                    ((BestSalesLineDisc."Currency Code" = '') and (AssemblyLineDisc."Currency Code" <> '')) or
                  ((BestSalesLineDisc."Variant Code" = '') and (AssemblyLineDisc."Variant Code" <> '')):
                        BestSalesLineDisc := AssemblyLineDisc;
                    ((BestSalesLineDisc."Currency Code" = '') or (AssemblyLineDisc."Currency Code" <> '')) and
                  ((BestSalesLineDisc."Variant Code" = '') or (AssemblyLineDisc."Variant Code" <> '')):
                        if BestSalesLineDisc."Line Discount %" < AssemblyLineDisc."Line Discount %" then
                            BestSalesLineDisc := AssemblyLineDisc;
                end;
            until AssemblyLineDisc.Next = 0;

        AssemblyLineDisc := BestSalesLineDisc;
    end;


    procedure FindOptionPrice(var ToSalesPrice: Record "Sales Price DMS"; CustNo: Code[20]; ContNo: Code[20]; CustPriceGrCode: Code[10]; CampaignNo: Code[20]; OptionNo: Code[20]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean; MakeCode: Code[20]; ModelCode: Code[20]; ModelVersionNo: Code[20]; OptionType: Integer; OptionSubtype: Integer)
    var
        FromOptionPrice: Record "Option Sales Price";
        TempTargetCampaignGr: Record "Campaign Target Group" temporary;
    begin
        FromOptionPrice.SetRange("Option Code", OptionNo);

        FromOptionPrice.SetRange("Make Code", MakeCode);
        FromOptionPrice.SetRange("Model Code", ModelCode);
        if OptionType <> FromOptionPrice."option type"::"Own Option" then
            FromOptionPrice.SetRange("Model Version No.", ModelVersionNo);
        FromOptionPrice.SetRange("Option Type", OptionType);
        FromOptionPrice.SetRange("Option Subtype", OptionSubtype);

        FromOptionPrice.SetFilter("Ending Date", '%1|>=%2', 0D, StartingDate);

        if not ShowAll then begin
            FromOptionPrice.SetFilter("Currency Code", '%1|%2', CurrencyCode, '');
            FromOptionPrice.SetRange("Starting Date", 0D, StartingDate);
        end;

        ToSalesPrice.Reset;
        ToSalesPrice.DeleteAll;

        FromOptionPrice.SetRange("Sales Type", FromOptionPrice."sales type"::"All Customers");
        FromOptionPrice.SetRange("Sales Code");
        CopyOptionPriceToSalesPrice(FromOptionPrice, ToSalesPrice);

        if CustNo <> '' then begin
            FromOptionPrice.SetRange("Sales Type", FromOptionPrice."sales type"::Customer);
            FromOptionPrice.SetRange("Sales Code", CustNo);
            CopyOptionPriceToSalesPrice(FromOptionPrice, ToSalesPrice);
        end;

        if CustPriceGrCode <> '' then begin
            FromOptionPrice.SetRange("Sales Type", FromOptionPrice."sales type"::"Customer Price Group");
            FromOptionPrice.SetRange("Sales Code", CustPriceGrCode);
            CopyOptionPriceToSalesPrice(FromOptionPrice, ToSalesPrice);
        end;

        if not ((CustNo = '') and (ContNo = '') and (CampaignNo = '')) then begin
            FromOptionPrice.SetRange("Sales Type", FromOptionPrice."sales type"::Campaign);
            if ActivatedCampaignExists(TempTargetCampaignGr, CustNo, ContNo, CampaignNo) then
                repeat
                    FromOptionPrice.SetRange("Sales Code", TempTargetCampaignGr."Campaign No.");
                    CopyOptionPriceToSalesPrice(FromOptionPrice, ToSalesPrice);
                until TempTargetCampaignGr.Next = 0;
        end;
    end;

    procedure FindVehiclePrice(var ToSalesPrice: Record "Sales Price DMS"; CustNo: Code[20]; ContNo: Code[20]; CustPriceGrCode: Code[10]; CampaignNo: Code[20]; ItemNo: Code[20]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean; LocationCode: Code[10]; OrderingPriceType: Code[10]; DocumentProfile: Integer; VehSerialNo: Code[20])
    var
        FromSalesPrice: Record "Sales Price DMS";
        TempTargetCampaignGr: Record "Campaign Target Group" temporary;
    begin
        FromSalesPrice.SetRange("Item No.", ItemNo);
        FromSalesPrice.SetFilter("Ending Date", '%1|>=%2', 0D, StartingDate);
        //DMS
        FromSalesPrice.SetFilter("Location Code", '%1|%2', LocationCode, '');
        FromSalesPrice.SetFilter("Document Profile", '%1|%2', DocumentProfile, 0);
        FromSalesPrice.SetFilter("Ordering Price Type Code", '%1|%2', OrderingPriceType, '');
        if VehSerialNo <> '' then
            FromSalesPrice.SetFilter("Vehicle Serial No.", '%1|%2', VehSerialNo, '')
        else
            FromSalesPrice.SetRange("Vehicle Serial No.", '');

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


    procedure FindVehiclePriceBase(var ToSalesPrice: Record "Sales Price DMS"; CustNo: Code[20]; ContNo: Code[20]; CustPriceGrCode: Code[10]; CampaignNo: Code[20]; ItemNo: Code[20]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean; LocationCode: Code[10]; OrderingPriceType: Code[10]; DocumentProfile: Integer; VehSerialNo: Code[20])
    var

        FromSalesPrice: Record "Price List Line";
        TempTargetCampaignGr: Record "Campaign Target Group" temporary;
    begin
        FromSalesPrice.SetRange(Status, FromSalesPrice.Status::Active);
        FromSalesPrice.SetRange("Price Type", FromSalesPrice."Price Type"::Sale);
        FromSalesPrice.SetRange("Asset Type", FromSalesPrice."Asset Type"::Item);
        FromSalesPrice.SetRange("asset No.", ItemNo);

        FromSalesPrice.SetFilter("Ending Date", '%1|>=%2', 0D, StartingDate);
        //DMS
        //SetFilter("Location Code", '%1|%2', LocationCode, '');
        FromSalesPrice.SetFilter("Document Profile", '%1|%2', DocumentProfile, 0);
        FromSalesPrice.SetFilter("Ordering Price Type Code", '%1|%2', OrderingPriceType, '');
        if VehSerialNo <> '' then
            FromSalesPrice.SetFilter("Vehicle Serial No.", '%1|%2', VehSerialNo, '')
        else
            FromSalesPrice.SetRange("Vehicle Serial No.", '');

        if not ShowAll then begin
            FromSalesPrice.SetFilter("Currency Code", '%1|%2', CurrencyCode, '');
            FromSalesPrice.SetRange("Starting Date", 0D, StartingDate);
        end;

        ToSalesPrice.Reset;
        ToSalesPrice.DeleteAll;

        FromSalesPrice.SetRange("Source Type", FromSalesPrice."Source type"::"All Customers");
        FromSalesPrice.SetRange("Source No.");
        NewCopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);

        if CustNo <> '' then begin
            FromSalesPrice.SetRange("Source Type", FromSalesPrice."source type"::Customer);
            FromSalesPrice.SetRange("Source No.", CustNo);
            NewCopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
        end;

        if CustPriceGrCode <> '' then begin
            FromSalesPrice.SetRange("Source Type", FromSalesPrice."source type"::"Customer Price Group");
            FromSalesPrice.SetRange("Source No.", CustPriceGrCode);
            NewCopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
        end;

        if not ((CustNo = '') and (ContNo = '') and (CampaignNo = '')) then begin
            FromSalesPrice.SetRange("Source Type", FromSalesPrice."source type"::Campaign);
            if ActivatedCampaignExists(TempTargetCampaignGr, CustNo, ContNo, CampaignNo) then
                repeat
                    FromSalesPrice.SetRange("Source No.", TempTargetCampaignGr."Campaign No.");
                    NewCopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
                until TempTargetCampaignGr.Next = 0;
        end;
    end;


    procedure FindVehiclePurchasePrice(var ToPurchasePrice: Record "Purchase Price"; ItemNo: Code[20]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean; OrderingPriceType: Code[10])
    var
        FromPurchasePrice: Record "Purchase Price";
        TempTargetCampaignGr: Record "Campaign Target Group" temporary;
    begin
        FromPurchasePrice.SetRange("Item No.", ItemNo);
        FromPurchasePrice.SetFilter("Ending Date", '%1|>=%2', 0D, StartingDate);
        FromPurchasePrice.SetFilter("Ordering Price Type Code", '%1|%2', OrderingPriceType, '');
        if not ShowAll then begin
            FromPurchasePrice.SetFilter("Currency Code", '%1|%2', CurrencyCode, '');
            FromPurchasePrice.SetRange("Starting Date", 0D, StartingDate);
        end;

        ToPurchasePrice.Reset;
        ToPurchasePrice.DeleteAll;

        CopyPurchasePriceToPurchasePrice(FromPurchasePrice, ToPurchasePrice);
    end;


    procedure FindVehicleDiscount(var ToSalesLineDisc: Record "Sales Line Discount DMS"; CustNo: Code[20]; ContNo: Code[20]; CustDiscGrCode: Code[20]; CampaignNo: Code[20]; ItemNo: Code[20]; ItemDiscGrCode: Code[20]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean; VehSerialNo: Code[20])
    var
        FromSalesLineDisc: Record "Sales Line Discount DMS";
        TempCampaignTargetGr: Record "Campaign Target Group" temporary;
        InclCampaigns: Boolean;
    begin
        FromSalesLineDisc.SetFilter("Ending Date", '%1|>=%2', 0D, StartingDate);

        if VehSerialNo <> '' then
            FromSalesLineDisc.SetFilter("Vehicle Serial No.", '%1|%2', VehSerialNo, '')
        else
            FromSalesLineDisc.SetRange("Vehicle Serial No.", '');

        if not ShowAll then begin
            FromSalesLineDisc.SetRange("Starting Date", 0D, StartingDate);
            FromSalesLineDisc.SetFilter("Currency Code", '%1|%2', CurrencyCode, '');
        end;

        ToSalesLineDisc.Reset;
        ToSalesLineDisc.DeleteAll;
        for FromSalesLineDisc."Sales Type" := FromSalesLineDisc."sales type"::Customer to FromSalesLineDisc."sales type"::Campaign do
            if (FromSalesLineDisc."Sales Type" = FromSalesLineDisc."sales type"::"All Customers") or
               ((FromSalesLineDisc."Sales Type" = FromSalesLineDisc."sales type"::Customer) and (CustNo <> '')) or
               ((FromSalesLineDisc."Sales Type" = FromSalesLineDisc."sales type"::"Customer Disc. Group") and (CustDiscGrCode <> '')) or
               ((FromSalesLineDisc."Sales Type" = FromSalesLineDisc."sales type"::Campaign) and
                   not ((CustNo = '') and (ContNo = '') and (CampaignNo = '')))
            then begin
                InclCampaigns := false;

                FromSalesLineDisc.SetRange("Sales Type", FromSalesLineDisc."Sales Type");
                case FromSalesLineDisc."Sales Type" of
                    FromSalesLineDisc."sales type"::"All Customers":
                        FromSalesLineDisc.SetRange("Sales Code");
                    FromSalesLineDisc."sales type"::Customer:
                        FromSalesLineDisc.SetRange("Sales Code", CustNo);
                    FromSalesLineDisc."sales type"::"Customer Disc. Group":
                        FromSalesLineDisc.SetRange("Sales Code", CustDiscGrCode);
                    FromSalesLineDisc."sales type"::Campaign:
                        begin
                            InclCampaigns := ActivatedCampaignExists(TempCampaignTargetGr, CustNo, ContNo, CampaignNo);
                            FromSalesLineDisc.SetRange("Sales Code", TempCampaignTargetGr."Campaign No.");
                        end;
                end;

                repeat
                    FromSalesLineDisc.SetRange(Type, FromSalesLineDisc.Type::Item);
                    FromSalesLineDisc.SetRange(Code, ItemNo);
                    CopySalesDiscToSalesDisc(FromSalesLineDisc, ToSalesLineDisc);

                    if ItemDiscGrCode <> '' then begin
                        FromSalesLineDisc.SetRange(Type, FromSalesLineDisc.Type::"Item Disc. Group");
                        FromSalesLineDisc.SetRange(Code, ItemDiscGrCode);
                        CopySalesDiscToSalesDisc(FromSalesLineDisc, ToSalesLineDisc);
                    end;

                    if InclCampaigns then begin
                        InclCampaigns := TempCampaignTargetGr.Next <> 0;
                        FromSalesLineDisc.SetRange("Sales Code", TempCampaignTargetGr."Campaign No.");
                    end;
                until not InclCampaigns;
            end;
    end;


    procedure FindVehiclePurchaseDiscount(var ToPurchaseLineDisc: Record "Purchase Line Discount"; ItemNo: Code[20]; ItemDiscGrCode: Code[20]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean)
    var
        FromPurchaseLineDisc: Record "Purchase Line Discount";
        TempCampaignTargetGr: Record "Campaign Target Group" temporary;
        InclCampaigns: Boolean;
    begin
        FromPurchaseLineDisc.SetFilter("Ending Date", '%1|>=%2', 0D, StartingDate);
        //>>DELTA 01
        FromPurchaseLineDisc.SetRange("Item No.", itemNo);
        //<<DELTA 01

        if not ShowAll then begin
            FromPurchaseLineDisc.SetRange("Starting Date", 0D, StartingDate);
            FromPurchaseLineDisc.SetFilter("Currency Code", '%1|%2', CurrencyCode, '');
        end;

        ToPurchaseLineDisc.Reset;
        ToPurchaseLineDisc.DeleteAll;
        CopyPurchaseDiscToPurchaseDisc(FromPurchaseLineDisc, ToPurchaseLineDisc)
    end;


    procedure FindOptionDiscount(var ToSalesLineDisc: Record "Sales Line Discount DMS"; CustNo: Code[20]; ContNo: Code[20]; CustDiscGrCode: Code[20]; CampaignNo: Code[20]; OptionCode: Code[20]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean; MakeCode: Code[20]; ModelCode: Code[20]; ModelVersionNo: Code[20]; OptionType: Integer; OptionSubtype: Integer)
    var
        FromOptionLineDisc: Record "Option Sales Discount";
        TempCampaignTargetGr: Record "Campaign Target Group" temporary;
        InclCampaigns: Boolean;
    begin
        FromOptionLineDisc.SetFilter("Ending Date", '%1|>=%2', 0D, StartingDate);

        if not ShowAll then begin
            FromOptionLineDisc.SetRange("Starting Date", 0D, StartingDate);
            FromOptionLineDisc.SetFilter("Currency Code", '%1|%2', CurrencyCode, '');
        end;
        FromOptionLineDisc.SetRange("Make Code", MakeCode);
        FromOptionLineDisc.SetRange("Model Code", ModelCode);
        if OptionType <> FromOptionLineDisc."option type"::"Own Option" then
            FromOptionLineDisc.SetRange("Model Version No.", ModelVersionNo);

        ToSalesLineDisc.Reset;
        ToSalesLineDisc.DeleteAll;
        for FromOptionLineDisc."Sales Type" := FromOptionLineDisc."sales type"::Customer to FromOptionLineDisc."sales type"::Campaign do
            if (FromOptionLineDisc."Sales Type" = FromOptionLineDisc."sales type"::"All Customers") or
               ((FromOptionLineDisc."Sales Type" = FromOptionLineDisc."sales type"::Customer) and (CustNo <> '')) or
               ((FromOptionLineDisc."Sales Type" = FromOptionLineDisc."sales type"::"Customer Disc. Group") and (CustDiscGrCode <> '')) or
               ((FromOptionLineDisc."Sales Type" = FromOptionLineDisc."sales type"::Campaign) and
                   not ((CustNo = '') and (ContNo = '') and (CampaignNo = '')))
            then begin
                InclCampaigns := false;

                FromOptionLineDisc.SetRange("Sales Type", FromOptionLineDisc."Sales Type");
                case FromOptionLineDisc."Sales Type" of
                    FromOptionLineDisc."sales type"::"All Customers":
                        FromOptionLineDisc.SetRange("Sales Code");
                    FromOptionLineDisc."sales type"::Customer:
                        FromOptionLineDisc.SetRange("Sales Code", CustNo);
                    FromOptionLineDisc."sales type"::"Customer Disc. Group":
                        FromOptionLineDisc.SetRange("Sales Code", CustDiscGrCode);
                    FromOptionLineDisc."sales type"::Campaign:
                        begin
                            InclCampaigns := ActivatedCampaignExists(TempCampaignTargetGr, CustNo, ContNo, CampaignNo);
                            FromOptionLineDisc.SetRange("Sales Code", TempCampaignTargetGr."Campaign No.");
                        end;
                end;

                repeat
                    FromOptionLineDisc.SetRange("Option Type", OptionType);
                    FromOptionLineDisc.SetRange("Option Subtype", OptionSubtype);
                    FromOptionLineDisc.SetRange("Option Code", OptionCode);
                    CopyOptionDiscToSalesDisc(FromOptionLineDisc, ToSalesLineDisc);

                    if InclCampaigns then begin
                        InclCampaigns := TempCampaignTargetGr.Next <> 0;
                        FromOptionLineDisc.SetRange("Sales Code", TempCampaignTargetGr."Campaign No.");
                    end;
                until not InclCampaigns;
            end;
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

    local procedure SetVAT(PriceInclVAT2: Boolean; VATPerCent2: Decimal; VATCalcType2: Option; VATBusPostingGr2: Code[10])
    begin
        PricesInclVAT := PriceInclVAT2;
        VATPerCent := VATPerCent2;
        VATCalcType := VATCalcType2;
        VATBusPostingGr := VATBusPostingGr2;
    end;

    local procedure SetLineDisc(LineDiscPerCent2: Decimal; AllowLineDisc2: Boolean; AllowInvDisc2: Boolean)
    begin
        LineDiscPerCent := LineDiscPerCent2;
        AllowLineDisc := AllowLineDisc2;
        AllowInvDisc := AllowInvDisc2;
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

    local procedure ConvertPriceFCYToLCY(CurrencyCode: Code[10]; var UnitPrice: Decimal)
    var
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        if CurrencyCode <> '' then
            UnitPrice := CurrExchRate.ExchangeAmtFCYToLCY(ExchRateDate, CurrencyCode, UnitPrice, CurrencyFactor);
        UnitPrice := ROUND(UnitPrice, Currency."Unit-Amount Rounding Precision");
    end;


    procedure FindVehicleSalesPriceAW(var ToSalesPrice: Record "Sales Price DMS"; VehSerialNo: Code[20]; AssemblyID: Code[20]; ItemNo: Code[20])
    var
        SalesPrice: Decimal;
    begin
        //DELTA SALES PRICE

        VehAssembly.Reset;
        VehAssembly.SetRange("Serial No.", VehSerialNo);
        VehAssembly.SetRange("Assembly ID", AssemblyID);
        if VehAssembly.FindSet then begin
            VehAssemblyHdr.Get(VehAssembly."Assembly ID");
            SalesPrice := 0;
            repeat
                SalesPrice += VehAssembly."Sales Price";
            until VehAssembly.Next = 0;

            ToSalesPrice.Reset;
            ToSalesPrice.DeleteAll;

            if SalesPrice > 0 then begin
                ToSalesPrice.Init;
                ToSalesPrice."Sales Type" := ToSalesPrice."sales type"::Assembly;
                ToSalesPrice."Sales Code" := '';
                ToSalesPrice."Item No." := ItemNo;
                ToSalesPrice."Unit Price" := SalesPrice;
                ToSalesPrice."Price Includes VAT" := VehAssemblyHdr."Prices Including VAT";
                ToSalesPrice."Currency Code" := VehAssemblyHdr."Currency Code";
                ToSalesPrice."Document Profile" := ToSalesPrice."document profile"::"Vehicles Trade";
                ToSalesPrice."VAT Bus. Posting Gr. (Price)" := VehAssemblyHdr."VAT Bus. Posting Group";
                ToSalesPrice."Vehicle Serial No." := VehSerialNo;

                ToSalesPrice.Insert;
            end;
        end
    end;


    procedure FindVehicleSalesPriceAWV16(var PriceCalculationBuffer: Record "Price Calculation Buffer"; VehSerialNo: Code[20]; AssemblyID: Code[20]; ItemNo: Code[20])
    var
        SalesPrice: Decimal;
    begin


        VehAssembly.Reset;
        VehAssembly.SetRange("Serial No.", VehSerialNo);
        VehAssembly.SetRange("Assembly ID", AssemblyID);
        if VehAssembly.FindSet then begin
            VehAssemblyHdr.Get(VehAssembly."Assembly ID");
            SalesPrice := 0;
            repeat
                SalesPrice += VehAssembly."Sales Price";
            until VehAssembly.Next = 0;

            //ToSalesPrice.Reset;
            //ToSalesPrice.DeleteAll;

            if SalesPrice > 0 then begin
                PriceCalculationBuffer."Unit Price" := SalesPrice;
                // ToSalesPrice.Init;
                // ToSalesPrice."Sales Type" := ToSalesPrice."sales type"::Assembly;
                // ToSalesPrice."Sales Code" := '';
                // ToSalesPrice."Item No." := ItemNo;
                // ToSalesPrice."Unit Price" := SalesPrice;
                // ToSalesPrice."Price Includes VAT" := VehAssemblyHdr."Prices Including VAT";
                // ToSalesPrice."Currency Code" := VehAssemblyHdr."Currency Code";
                // ToSalesPrice."Document Profile" := ToSalesPrice."document profile"::"Vehicles Trade";
                // ToSalesPrice."VAT Bus. Posting Gr. (Price)" := VehAssemblyHdr."VAT Bus. Posting Group";
                // ToSalesPrice."Vehicle Serial No." := VehSerialNo;

                // ToSalesPrice.Insert;
            end;
        end
    end;



    procedure FindVehicleLineDiscountAW(var ToSalesLineDisc: Record "Sales Line Discount DMS"; VehSerialNo: Code[20]; AssemblyID: Code[20]; ItemNo: Code[20])
    var
        SalesPrice: Decimal;
        Discount: Decimal;
    begin
        //DELTA SALES PRICE

        VehAssembly.Reset;
        VehAssembly.SetRange("Serial No.", VehSerialNo);
        VehAssembly.SetRange("Assembly ID", AssemblyID);
        if VehAssembly.FindSet then begin
            VehAssemblyHdr.Get(VehAssembly."Assembly ID");
            SalesPrice := 0;
            Discount := 0;
            repeat
                SalesPrice += VehAssembly."Sales Price";
                Discount += VehAssembly."Line Discount Amount";
            until VehAssembly.Next = 0;
            if SalesPrice <> 0 then
                Discount := Discount / SalesPrice * 100
            else
                Discount := 0;

            ToSalesLineDisc.Reset;
            ToSalesLineDisc.DeleteAll;

            if Discount > 0 then begin
                ToSalesLineDisc.Init;
                ToSalesLineDisc."Sales Type" := ToSalesLineDisc."sales type"::Assembly;
                ToSalesLineDisc."Sales Code" := '';
                ToSalesLineDisc.Type := ToSalesLineDisc.Type::Item;
                ToSalesLineDisc.Code := ItemNo;
                ToSalesLineDisc."Line Discount %" := Discount;
                ToSalesLineDisc."Document Profile" := ToSalesLineDisc."document profile"::"Vehicles Trade";
                ToSalesLineDisc."Currency Code" := VehAssemblyHdr."Currency Code";
                ToSalesLineDisc."Vehicle Serial No." := VehSerialNo;
                ToSalesLineDisc.Insert;
            end;
        end
    end;


    procedure FindVehiclePurchasePriceAW(var ToPurchasePrice: Record "Purchase Price"; VehSerialNo: Code[20]; AssemblyID: Code[20]; ItemNo: Code[20])
    var
        PurchasePrice: Decimal;
    begin
        VehAssembly.Reset;
        VehAssembly.SetRange("Serial No.", VehSerialNo);
        VehAssembly.SetRange("Assembly ID", AssemblyID);
        if VehAssembly.FindSet then begin
            VehAssemblyHdr.Get(VehAssembly."Assembly ID");
            PurchasePrice := 0;
            repeat
                PurchasePrice += VehAssembly."Direct Purchase Cost";
            until VehAssembly.Next = 0;

            ToPurchasePrice.Reset;
            ToPurchasePrice.DeleteAll;

            if PurchasePrice > 0 then begin
                ToPurchasePrice.Init;
                ToPurchasePrice."Item No." := ItemNo;
                ToPurchasePrice."Direct Unit Cost" := PurchasePrice;
                ToPurchasePrice."Currency Code" := VehAssemblyHdr."Currency Code";
                ToPurchasePrice.Insert;
            end;
        end
    end;


    procedure FindVehiclePurchaseDiscountAW(var ToPurchaseLineDisc: Record "Purchase Line Discount"; VehSerialNo: Code[20]; AssemblyID: Code[20]; ItemNo: Code[20])
    var
        PurchasePrice: Decimal;
        Discount: Decimal;
    begin
        VehAssembly.Reset;
        VehAssembly.SetRange("Serial No.", VehSerialNo);
        VehAssembly.SetRange("Assembly ID", AssemblyID);
        if VehAssembly.FindFirst then begin
            VehAssemblyHdr.Get(VehAssembly."Assembly ID");
            PurchasePrice := 0;
            Discount := 0;
            repeat
                PurchasePrice += VehAssembly."Direct Purchase Cost";
                Discount += VehAssembly."Purchase Discount Amount";
            until VehAssembly.Next = 0;
            if PurchasePrice <> 0 then
                Discount := Discount / PurchasePrice * 100
            else
                Discount := 0;

            ToPurchaseLineDisc.Reset;
            ToPurchaseLineDisc.DeleteAll;

            if Discount > 0 then begin
                ToPurchaseLineDisc.Init;
                ToPurchaseLineDisc."Item No." := ItemNo;
                ToPurchaseLineDisc."Line Discount %" := Discount;
                ToPurchaseLineDisc."Currency Code" := VehAssemblyHdr."Currency Code";
                ToPurchaseLineDisc.Insert;
            end;
        end
    end;


    procedure ChkAssemblyHdrSalesLine(SalesLine: Record "Sales Line"; NoModify: Boolean): Boolean
    var
        SalesHeader: Record "Sales Header";
        DateCap: Text[30];
        HdrNew: Boolean;
    begin
        if (SalesLine."Vehicle Serial No." = '') then exit(false);
        if (SalesLine."Vehicle Assembly ID" = '') then exit(true);

        SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
        HdrNew := not VehAssemblyHdr.Get(SalesLine."Vehicle Assembly ID");

        if NoModify then
            exit((VehAssemblyHdr."Currency Code" = SalesLine."Currency Code") and
(VehAssemblyHdr."Currency Factor" = SalesHeader."Currency Factor") and
(VehAssemblyHdr."Prices Including VAT" = SalesHeader."Prices Including VAT") and
(VehAssemblyHdr."VAT %" = SalesLine."VAT %") and
(VehAssemblyHdr."VAT Calculation Type" = SalesLine."VAT Calculation Type".asinteger()) and
(VehAssemblyHdr."VAT Bus. Posting Group" = SalesLine."VAT Bus. Posting Group") and
(VehAssemblyHdr."VAT Prod. Posting Group" = SalesLine."VAT Prod. Posting Group") and
(VehAssemblyHdr."Bill-to Customer No." = SalesLine."Bill-to Customer No.") and
(VehAssemblyHdr."Bill-to Contact No." = SalesHeader."Bill-to Contact No.") and
(VehAssemblyHdr."Customer Price Group" = SalesLine."Customer Price Group") and
(VehAssemblyHdr."Location Code" = SalesLine."Location Code") and
(VehAssemblyHdr."Ordering Price Type Code" = SalesLine."Ordering Price Type Code") and
(VehAssemblyHdr."Document Profile" = SalesLine."Document Profile") and
(VehAssemblyHdr."Start Date" = SalesHeaderStartDate(SalesHeader, DateCap)) and
(VehAssemblyHdr."Customer Disc. Group" = SalesLine."Customer Disc. Group"));

        if HdrNew then begin
            VehAssemblyHdr.Init;
            VehAssemblyHdr."Assembly ID" := SalesLine."Vehicle Assembly ID";
            VehAssemblyHdr.Insert;
        end;
        if VehAssemblyHdr."Currency Code" <> SalesLine."Currency Code" then
            VehAssemblyHdr."Currency Factor" := SalesHeader."Currency Factor";
        VehAssemblyHdr.Validate("Currency Code", SalesLine."Currency Code");
        VehAssemblyHdr.Validate("Currency Factor", SalesHeader."Currency Factor");
        VehAssemblyHdr.Validate("Exchange Date", SalesHeaderExchDate(SalesHeader));
        VehAssemblyHdr.Validate("Prices Including VAT", SalesHeader."Prices Including VAT");
        VehAssemblyHdr.Validate("VAT %", SalesLine."VAT %");
        VehAssemblyHdr.Validate("VAT Calculation Type", SalesLine."VAT Calculation Type");
        VehAssemblyHdr.Validate("VAT Bus. Posting Group", SalesLine."VAT Bus. Posting Group");
        VehAssemblyHdr.Validate("VAT Prod. Posting Group", SalesLine."VAT Prod. Posting Group");
        VehAssemblyHdr.Validate("Bill-to Customer No.", SalesLine."Bill-to Customer No.");
        VehAssemblyHdr.Validate("Bill-to Contact No.", SalesHeader."Bill-to Contact No.");
        VehAssemblyHdr.Validate("Customer Price Group", SalesLine."Customer Price Group");
        VehAssemblyHdr.Validate("Location Code", SalesLine."Location Code");
        VehAssemblyHdr.Validate("Ordering Price Type Code", SalesLine."Ordering Price Type Code");
        VehAssemblyHdr.Validate("Document Profile", SalesLine."Document Profile");
        VehAssemblyHdr.Validate("Start Date", SalesHeaderStartDate(SalesHeader, DateCap));
        VehAssemblyHdr.Validate("Customer Disc. Group", SalesLine."Customer Disc. Group");

        VehAssemblyHdr.Modify;
        exit(true);  // Can be extended by confirmations
    end;


    procedure ChkAssemblyHdrPurchaseLine(PurchaseLine: Record "Purchase Line"; NoModify: Boolean): Boolean
    var
        PurchaseHeader: Record "Purchase Header";
        DateCap: Text[30];
        HdrNew: Boolean;
    begin
        if (PurchaseLine."Vehicle Serial No." = '') then exit(false);
        if (PurchaseLine."Vehicle Assembly ID" = '') then exit(true);

        PurchaseHeader.Get(PurchaseLine."Document Type", PurchaseLine."Document No.");
        HdrNew := not VehAssemblyHdr.Get(PurchaseLine."Vehicle Assembly ID");

        if NoModify then
            exit((VehAssemblyHdr."Currency Code" = PurchaseLine."Currency Code") and
(VehAssemblyHdr."Currency Factor" = PurchaseHeader."Currency Factor") and
(VehAssemblyHdr."Prices Including VAT" = PurchaseHeader."Prices Including VAT") and
(VehAssemblyHdr."VAT %" = PurchaseLine."VAT %") and
(VehAssemblyHdr."VAT Calculation Type" = PurchaseLine."VAT Calculation Type".asinteger()) and
(VehAssemblyHdr."VAT Bus. Posting Group" = PurchaseLine."VAT Bus. Posting Group") and
(VehAssemblyHdr."VAT Prod. Posting Group" = PurchaseLine."VAT Prod. Posting Group") and
(VehAssemblyHdr."Location Code" = PurchaseLine."Location Code") and
(VehAssemblyHdr."Ordering Price Type Code" = PurchaseLine."Ordering Price Type Code") and
(VehAssemblyHdr."Document Profile" = PurchaseLine."Document Profile") and
(VehAssemblyHdr."Start Date" = PurchaseHeaderStartDate(PurchaseHeader, DateCap)));

        if HdrNew then begin
            VehAssemblyHdr.Init;
            VehAssemblyHdr."Assembly ID" := PurchaseLine."Vehicle Assembly ID";
            VehAssemblyHdr.Insert;
        end;
        if VehAssemblyHdr."Currency Code" <> PurchaseLine."Currency Code" then
            VehAssemblyHdr."Currency Factor" := PurchaseHeader."Currency Factor";
        VehAssemblyHdr.Validate("Currency Code", PurchaseLine."Currency Code");
        VehAssemblyHdr.Validate("Currency Factor", PurchaseHeader."Currency Factor");
        VehAssemblyHdr.Validate("Exchange Date", PurchaseHeaderExchDate(PurchaseHeader));
        VehAssemblyHdr.Validate("Prices Including VAT", PurchaseHeader."Prices Including VAT");
        VehAssemblyHdr.Validate("VAT %", PurchaseLine."VAT %");
        VehAssemblyHdr.Validate("VAT Calculation Type", PurchaseLine."VAT Calculation Type");
        VehAssemblyHdr.Validate("VAT Bus. Posting Group", PurchaseLine."VAT Bus. Posting Group");
        VehAssemblyHdr.Validate("VAT Prod. Posting Group", PurchaseLine."VAT Prod. Posting Group");
        VehAssemblyHdr.Validate("Location Code", PurchaseLine."Location Code");
        VehAssemblyHdr.Validate("Ordering Price Type Code", PurchaseLine."Ordering Price Type Code");
        VehAssemblyHdr.Validate("Document Profile", PurchaseLine."Document Profile");
        VehAssemblyHdr.Validate("Start Date", PurchaseHeaderStartDate(PurchaseHeader, DateCap));
        VehAssemblyHdr.Modify;
        exit(true);  // Can be extended by confirmations
    end;


    procedure UpdAssemblyHdrField(SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; NonRecalcField: Integer)
    begin
        if (SalesLine."Vehicle Assembly ID" = '') or (SalesLine."Vehicle Serial No." = '') then exit;

        if VehAssemblyHdr."Assembly ID" <> SalesLine."Vehicle Assembly ID" then
            if not VehAssemblyHdr.Get(SalesLine."Vehicle Assembly ID") then exit;

        case NonRecalcField of
            SalesHeader.FieldNo("Prices Including VAT"):
                VehAssemblyHdr."Prices Including VAT" := SalesHeader."Prices Including VAT";
            SalesHeader.FieldNo("Currency Code"):
                VehAssemblyHdr."Currency Code" := SalesHeader."Currency Code";
        end;
        VehAssemblyHdr.Modify;
    end;


    procedure ChkAssemblyHdrPurchLine(PurchLine: Record "Purchase Line"): Boolean
    var
        PurchHeader: Record "Purchase Header";
        DateCap: Text[30];
        HdrNew: Boolean;
    begin
        if (PurchLine."Vehicle Assembly ID" = '') or (PurchLine."Vehicle Serial No." = '') then exit(false);
        PurchHeader.Get(PurchLine."Document Type", PurchLine."Document No.");
        HdrNew := not VehAssemblyHdr.Get(PurchLine."Vehicle Assembly ID");

        if HdrNew then begin
            VehAssemblyHdr.Init;
            VehAssemblyHdr."Assembly ID" := PurchLine."Vehicle Assembly ID";
            VehAssemblyHdr.Insert;
        end;
        if VehAssemblyHdr."Currency Code" <> PurchLine."Currency Code" then
            VehAssemblyHdr."Currency Factor" := PurchHeader."Currency Factor";
        VehAssemblyHdr.Validate("Currency Code", PurchLine."Currency Code");
        VehAssemblyHdr.Validate("Currency Factor", PurchHeader."Currency Factor");
        VehAssemblyHdr.Validate("Exchange Date", PurchHeaderExchDate(PurchHeader));
        VehAssemblyHdr.Validate("Document Profile", PurchLine."Document Profile");
        VehAssemblyHdr.Modify;
        exit(true);  // Can be extended by confirmations
    end;

    local procedure CopyOptionPriceToSalesPrice(var FromOptionPrice: Record "Option Sales Price"; var ToSalesPrice: Record "Sales Price DMS")
    begin
        if FromOptionPrice.FindSet then
            repeat
                if FromOptionPrice."Unit Price" <> 0 then begin
                    ToSalesPrice.Init;
                    ToSalesPrice."Item No." := FromOptionPrice."Option Code";
                    ToSalesPrice."Make Code" := FromOptionPrice."Make Code";
                    ToSalesPrice."Model Code" := FromOptionPrice."Model Code";
                    ToSalesPrice."Model Version No." := FromOptionPrice."Model Version No.";
                    ToSalesPrice."Sales Type" := FromOptionPrice."Sales Type";
                    ToSalesPrice."Sales Code" := FromOptionPrice."Sales Code";
                    ToSalesPrice."Starting Date" := FromOptionPrice."Starting Date";
                    ToSalesPrice."Ending Date" := FromOptionPrice."Ending Date";
                    ToSalesPrice."Currency Code" := FromOptionPrice."Currency Code";
                    ToSalesPrice."Price Includes VAT" := FromOptionPrice."Price Includes VAT";
                    ToSalesPrice."VAT Bus. Posting Gr. (Price)" := FromOptionPrice."VAT Bus. Posting Gr. (Price)";
                    ToSalesPrice."Unit Price" := FromOptionPrice."Unit Price";
                    ToSalesPrice.Insert;
                end;
            until FromOptionPrice.Next = 0;
    end;

    local procedure CopyOptionDiscToSalesDisc(var FromOptionLineDisc: Record "Option Sales Discount"; var ToSalesLineDisc: Record "Sales Line Discount DMS")
    begin
        if FromOptionLineDisc.FindSet then
            repeat
                if FromOptionLineDisc."Line Discount %" <> 0 then begin
                    ToSalesLineDisc.Init;
                    ToSalesLineDisc.Type := ToSalesLineDisc.Type::Item;
                    ToSalesLineDisc.Code := FromOptionLineDisc."Option Code";
                    ToSalesLineDisc."Sales Type" := FromOptionLineDisc."Sales Type";
                    ToSalesLineDisc."Sales Code" := FromOptionLineDisc."Sales Code";
                    ToSalesLineDisc."Starting Date" := FromOptionLineDisc."Starting Date";
                    ToSalesLineDisc."Currency Code" := FromOptionLineDisc."Currency Code";
                    ToSalesLineDisc."Line Discount %" := FromOptionLineDisc."Line Discount %";
                    ToSalesLineDisc."Ending Date" := FromOptionLineDisc."Ending Date";
                    ToSalesLineDisc."Make Code" := FromOptionLineDisc."Make Code";
                    ToSalesLineDisc."Model Code" := FromOptionLineDisc."Model Code";
                    ToSalesLineDisc."Model Version No." := FromOptionLineDisc."Model Version No.";
                    ToSalesLineDisc.Insert;
                end;
            until FromOptionLineDisc.Next = 0;
    end;

    local procedure CopySalesPriceToSalesPrice(var FromSalesPrice: Record "Sales Price DMS"; var ToSalesPrice: Record "Sales Price DMS")
    begin
        if FromSalesPrice.FindSet then
            repeat
                if FromSalesPrice."Unit Price" <> 0 then begin
                    ToSalesPrice := FromSalesPrice;
                    ToSalesPrice.Insert;
                end;
            until FromSalesPrice.Next = 0;
    end;

    local procedure NewCopySalesPriceToSalesPrice(var FromSalesPrice: Record "Price List Line"; var ToSalesPrice: Record "Sales Price DMS")
    begin
        if FromSalesPrice.FindSet then
            repeat
                if FromSalesPrice."Unit Price" <> 0 then begin
                    ToSalesPrice.init;
                    ToSalesPrice."Allow Invoice Disc." := FromSalesPrice."Allow Invoice Disc.";
                    ToSalesPrice."Allow Line Disc." := FromSalesPrice."Allow Line Disc.";
                    ToSalesPrice."Currency Code" := FromSalesPrice."Currency Code";
                    ToSalesPrice."Document Profile" := FromSalesPrice."Document Profile";
                    ToSalesPrice."Ending Date" := FromSalesPrice."Ending Date";
                    ToSalesPrice."Item No." := FromSalesPrice."Asset No.";
                    //ToSalesPrice."Location Code" := FromSalesPrice."Location Code";
                    ToSalesPrice."Make Code" := FromSalesPrice."Make Code";
                    ToSalesPrice."Minimum Quantity" := FromSalesPrice."Minimum Quantity";
                    ToSalesPrice."Model Code" := FromSalesPrice."Model Code";
                    ToSalesPrice."Model Version No." := FromSalesPrice."Model Version No.";
                    ToSalesPrice."Ordering Price Type Code" := FromSalesPrice."Ordering Price Type Code";
                    ToSalesPrice."Price Includes VAT" := FromSalesPrice."Price Includes VAT";
                    Case FromSalesPrice."Source Type" of
                        FromSalesPrice."Source Type"::"All Customers":
                            ToSalesPrice."Sales Type" := ToSalesPrice."Sales Type"::"All Customers";
                        FromSalesPrice."Source Type"::"Customer":
                            ToSalesPrice."Sales Type" := ToSalesPrice."Sales Type"::"Customer";
                        FromSalesPrice."Source Type"::"Customer Price Group":
                            ToSalesPrice."Sales Type" := ToSalesPrice."Sales Type"::"Customer Price Group"
                    End;
                    ToSalesPrice."Sales Code" := FromSalesPrice."Source No.";
                    ToSalesPrice."Starting Date" := FromSalesPrice."Starting Date";
                    ToSalesPrice."Unit Price" := FromSalesPrice."Unit Price";
                    //ToSalesPrice := FromSalesPrice;
                    ToSalesPrice.Insert;
                end;
            until FromSalesPrice.Next = 0;
    end;

    local procedure CopyPurchasePriceToPurchasePrice(var FromPurchasePrice: Record "Purchase Price"; var ToPurchasePrice: Record "Purchase Price")
    begin
        if FromPurchasePrice.FindSet then
            repeat
                if FromPurchasePrice."Direct Unit Cost" <> 0 then begin
                    ToPurchasePrice := FromPurchasePrice;
                    ToPurchasePrice.Insert;
                end;
            until FromPurchasePrice.Next = 0;
    end;

    local procedure CopySalesDiscToSalesDisc(var FromSalesLineDisc: Record "Sales Line Discount DMS"; var ToSalesLineDisc: Record "Sales Line Discount DMS")
    begin
        if FromSalesLineDisc.FindSet then
            repeat
                if FromSalesLineDisc."Line Discount %" <> 0 then begin
                    ToSalesLineDisc := FromSalesLineDisc;
                    ToSalesLineDisc.Insert;
                end;
            until FromSalesLineDisc.Next = 0;
    end;

    local procedure CopyPurchaseDiscToPurchaseDisc(var FromPurchaseLineDisc: Record "Purchase Line Discount"; var ToPurchaseLineDisc: Record "Purchase Line Discount")
    begin
        if FromPurchaseLineDisc.FindSet then
            repeat
                if FromPurchaseLineDisc."Line Discount %" <> 0 then begin
                    ToPurchaseLineDisc := FromPurchaseLineDisc;
                    ToPurchaseLineDisc.Insert;
                end;
            until FromPurchaseLineDisc.Next = 0;
    end;

    local procedure ActivatedCampaignExists(var ToCampaignTargetGr: Record "Campaign Target Group"; CustNo: Code[20]; ContNo: Code[20]; CampaignNo: Code[20]): Boolean
    var
        FromCampaignTargetGr: Record "Campaign Target Group";
        Cont: Record Contact;
        recCampaign: Record Campaign;
    begin
        ToCampaignTargetGr.Reset;
        ToCampaignTargetGr.DeleteAll;

        if CampaignNo <> '' then begin
            ToCampaignTargetGr."Campaign No." := CampaignNo;
            ToCampaignTargetGr.Insert;
        end else begin
            FromCampaignTargetGr.SetRange(Type, FromCampaignTargetGr.Type::Customer);
            FromCampaignTargetGr.SetRange("No.", CustNo);
            if FromCampaignTargetGr.FindSet then
                repeat
                    ToCampaignTargetGr := FromCampaignTargetGr;
                    ToCampaignTargetGr.Insert;
                until FromCampaignTargetGr.Next = 0
            else begin
                if Cont.Get(ContNo) then begin
                    FromCampaignTargetGr.SetRange(Type, FromCampaignTargetGr.Type::Contact);
                    FromCampaignTargetGr.SetRange("No.", Cont."Company No.");
                    if FromCampaignTargetGr.FindSet then
                        repeat
                            ToCampaignTargetGr := FromCampaignTargetGr;
                            ToCampaignTargetGr.Insert;
                        until FromCampaignTargetGr.Next = 0;
                end;
            end;
            //DMS
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

        end;
        exit(ToCampaignTargetGr.FindSet);
    end;

    local procedure SalesHeaderExchDate(SalesHeader: Record "Sales Header"): Date
    begin
        if (SalesHeader."Document Type" in [SalesHeader."document type"::"Blanket Order", SalesHeader."document type"::Quote]) and
   (SalesHeader."Posting Date" = 0D)
then
            exit(WorkDate);
        exit(SalesHeader."Posting Date");
    end;

    local procedure SalesHeaderStartDate(SalesHeader: Record "Sales Header"; var DateCaption: Text[30]): Date
    begin
        if SalesHeader."Document Type" in [SalesHeader."document type"::Invoice, SalesHeader."document type"::"Credit Memo"] then begin
            DateCaption := SalesHeader.FieldCaption("Posting Date");
            exit(SalesHeader."Posting Date")
        end else begin
            DateCaption := SalesHeader.FieldCaption("Order Date");
            exit(SalesHeader."Order Date");
        end;
    end;

    local procedure PurchaseHeaderExchDate(PurchaseHeader: Record "Purchase Header"): Date
    begin
        if (PurchaseHeader."Document Type" in [PurchaseHeader."document type"::"Blanket Order", PurchaseHeader."document type"::Quote]) and
   (PurchaseHeader."Posting Date" = 0D)
then
            exit(WorkDate);
        exit(PurchaseHeader."Posting Date");
    end;

    local procedure PurchaseHeaderStartDate(PurchaseHeader: Record "Purchase Header"; var DateCaption: Text[30]): Date
    begin
        if PurchaseHeader."Document Type" in [PurchaseHeader."document type"::Invoice, PurchaseHeader."document type"::"Credit Memo"] then begin
            DateCaption := PurchaseHeader.FieldCaption("Posting Date");
            exit(PurchaseHeader."Posting Date")
        end else begin
            DateCaption := PurchaseHeader.FieldCaption("Order Date");
            exit(PurchaseHeader."Order Date");
        end;
    end;


    procedure UpdateSalesLineAmounts(var NewVehAssembly: Record "Vehicle Assembly Line")
    var
        SalesLine: Record "Sales Line";
        SalesHeader: Record "Sales Header";
        ToSalesPrice: Record "Sales Price DMS";
    begin
        //Izmainam pārdošanas rindās
        SalesLine.Reset;
        SalesLine.SetCurrentkey(Type, "Line Type", "Vehicle Serial No.");
        SalesLine.SetRange("Line Type", SalesLine."line type"::Vehicle);
        SalesLine.SetRange("Vehicle Serial No.", NewVehAssembly."Serial No.");
        SalesLine.SetRange("Vehicle Assembly ID", NewVehAssembly."Assembly ID");
        if SalesLine.FindSet(true, false) then begin
            SalesHeader.Get(SalesLine."Document Type", SalesLine."Document No.");
            SalesHeader.TestField(Status, SalesHeader.Status::Open);

            repeat
                //>>DELT XX
                SalesLine.UpdateUnitPrice2;
                SalesLine.Modify;
            //<<DELTA XX
            /*if (SalesLine."Vehicle Assembly ID" <> '') and (SalesLine."Vehicle Serial No." <> '') then Begin
                VehPriceCalcMgt.FindVehicleSalesPriceAW(ToSalesPrice, SalesLine."Vehicle Serial No.",
                  SalesLine."Vehicle Assembly ID", SalesLine."No.");
                If (ToSalesPrice."Unit Price" <> 0) then Begin
                    Salesline.Validate("unit Price", ToSalesPrice."Unit Price");

                    SalesLine.Modify;
                end;

            end;*/


            until SalesLine.Next = 0;
            OnAfterUpdateUnitPrice(SalesHeader);
        end;
    end;


    procedure UpdatePurchLineAmounts(var NewVehAssembly: Record "Vehicle Assembly Line")
    var
        PurchaseLine: Record "Purchase Line";
        PurchaseHeader: Record "Purchase Header";
    begin
        //Izmainam iepirkumu rindās
        PurchaseLine.Reset;
        PurchaseLine.SetCurrentkey(Type, "Line Type", "Vehicle Serial No.");
        PurchaseLine.SetRange("Line Type", PurchaseLine."line type"::Vehicle);
        PurchaseLine.SetRange("Vehicle Serial No.", NewVehAssembly."Serial No.");
        PurchaseLine.SetRange("Vehicle Assembly ID", NewVehAssembly."Assembly ID");
        OnUpdatePurchLineAmountsOnBeforeFind(PurchaseLine, NewVehAssembly);
        if PurchaseLine.FindSet(true, false) then begin
            PurchaseHeader.Get(PurchaseLine."Document Type", PurchaseLine."Document No.");
            PurchaseHeader.TestField(Status, PurchaseHeader.Status::Open);
            repeat
                PurchaseLine.UpdateUnitPrice2;
                PurchaseLine.Modify;
            until PurchaseLine.Next = 0;
        end;
    end;

    local procedure CalcLineAmount(SalesPrice: Record "Sales Price DMS"): Decimal
    begin
        if SalesPrice."Allow Line Disc." then
            exit(SalesPrice."Unit Price" * (1 - LineDiscPerCent / 100));
        exit(SalesPrice."Unit Price");
    end;

    local procedure PurchHeaderExchDate(PurchHeader: Record "Purchase Header"): Date
    begin
        if (PurchHeader."Document Type" in [PurchHeader."document type"::"Blanket Order", PurchHeader."document type"::Quote]) and
   (PurchHeader."Posting Date" = 0D)
then
            exit(WorkDate);
        exit(PurchHeader."Posting Date");
    end;


    procedure ChkAssemblyHdrReqLine(ReqLine: Record "Requisition Line"): Boolean
    var
        DateCap: Text[30];
        HdrNew: Boolean;
    begin
        if (ReqLine."Vehicle Assembly ID" = '') or (ReqLine."Vehicle Serial No." = '') then exit(false);
        HdrNew := not VehAssemblyHdr.Get(ReqLine."Vehicle Assembly ID");

        if HdrNew then begin
            VehAssemblyHdr.Init;
            VehAssemblyHdr."Assembly ID" := ReqLine."Vehicle Assembly ID";
            VehAssemblyHdr.Insert;
        end;
        if VehAssemblyHdr."Currency Code" <> ReqLine."Currency Code" then
            VehAssemblyHdr."Currency Factor" := ReqLine."Currency Factor";
        VehAssemblyHdr.Validate("Currency Code", ReqLine."Currency Code");
        VehAssemblyHdr.Validate("Currency Factor", ReqLine."Currency Factor");
        VehAssemblyHdr.Validate("Exchange Date", WorkDate);
        VehAssemblyHdr.Validate("Document Profile", ReqLine."Document Profile");
        VehAssemblyHdr.Modify;
        exit(true);  // Can be extended by confirmations
    end;


    procedure ChkAssemblyHdrTransferLine(TransferLine: Record "Transfer Line"): Boolean
    var
        DateCap: Text[30];
        HdrNew: Boolean;
    begin
        if (TransferLine."Vehicle Assembly ID" = '') or (TransferLine."Vehicle Serial No." = '') then exit(false);
        HdrNew := not VehAssemblyHdr.Get(TransferLine."Vehicle Assembly ID");

        if HdrNew then begin
            VehAssemblyHdr.Init;
            VehAssemblyHdr."Assembly ID" := TransferLine."Vehicle Assembly ID";
            VehAssemblyHdr.Insert;
        end;
        VehAssemblyHdr.Validate("Document Profile", TransferLine."Document Profile");
        VehAssemblyHdr.Modify;
        exit(true);  // Can be extended by confirmations
    end;


    procedure FindAssemblyLinePurchasePrice(VehAssemblyHdr: Record "Vehicle Assembly Header"; var VehAssembly: Record "Vehicle Assembly Line")
    var
        OptionPurchasePrice: Record "Option Purchase Price";
        PurchasePrice: Record "Purchase Price";
        CurrencyCode: Code[10];
        CurrExchRate: Record "Currency Exchange Rate";
        CurrentExchFactor: Decimal;
    begin
        SetVAT(VehAssemblyHdr."Prices Including VAT", VehAssemblyHdr."VAT %",
  VehAssemblyHdr."VAT Calculation Type", VehAssemblyHdr."VAT Bus. Posting Group");
        SetLineDisc(VehAssemblyHdr."Line Discount %", VehAssemblyHdr."Allow Line Disc.", VehAssemblyHdr."Allow Invoice Disc.");

        if PricesInCurrency then
            VehAssemblyHdr.TestField("Currency Factor");

        case VehAssembly."Option Type" of
            VehAssembly."option type"::"Manufacturer Option":
                begin
                    OptionPurchasePrice.SetRange("Option Code", VehAssembly."Option Code");
                    OptionPurchasePrice.SetRange("Make Code", VehAssembly."Make Code");
                    OptionPurchasePrice.SetRange("Model Code", VehAssembly."Model Code");
                    if VehAssembly."Option Type" <> OptionPurchasePrice."option type"::"Own Option" then
                        OptionPurchasePrice.SetRange("Model Version No.", VehAssembly."Model Version No.");
                    OptionPurchasePrice.SetRange("Option Type", VehAssembly."Option Type");
                    OptionPurchasePrice.SetRange("Option Subtype", VehAssembly."Option Subtype");
                    OptionPurchasePrice.SetRange("Starting Date", 0D, VehAssemblyHdr."Start Date");
                    OptionPurchasePrice.SetFilter("Ending Date", '%1|>=%2', 0D, VehAssemblyHdr."Start Date");
                    //SETFILTER("Currency Code",'%1|%2',VehAssemblyHdr."Currency Code",'');
                    if OptionPurchasePrice.FindLast then begin
                        CurrentExchFactor := CurrExchRate.GetCurrentCurrencyFactor(OptionPurchasePrice."Currency Code");
                        SetCurrency(OptionPurchasePrice."Currency Code", CurrentExchFactor, VehAssemblyHdr."Exchange Date");
                        ConvertPriceFCYToLCY(OptionPurchasePrice."Currency Code", OptionPurchasePrice."Direct Unit Cost");

                        SetCurrency(VehAssemblyHdr."Currency Code", VehAssemblyHdr."Currency Factor", VehAssemblyHdr."Exchange Date");
                        ConvertPriceLCYToFCY('', OptionPurchasePrice."Direct Unit Cost");
                        VehAssembly."Direct Purchase Cost" := OptionPurchasePrice."Direct Unit Cost";
                    end;
                end;
            VehAssembly."option type"::"Own Option":
                begin
                    OptionPurchasePrice.SetRange("Option Code", VehAssembly."Option Code");
                    OptionPurchasePrice.SetRange("Make Code", VehAssembly."Make Code");
                    OptionPurchasePrice.SetRange("Model Code", VehAssembly."Model Code");
                    if VehAssembly."Option Type" <> OptionPurchasePrice."option type"::"Own Option" then
                        OptionPurchasePrice.SetRange("Model Version No.", VehAssembly."Model Version No.");
                    OptionPurchasePrice.SetRange("Option Type", VehAssembly."Option Type");
                    OptionPurchasePrice.SetRange("Option Subtype", VehAssembly."Option Subtype");
                    OptionPurchasePrice.SetRange("Starting Date", 0D, VehAssemblyHdr."Start Date");
                    OptionPurchasePrice.SetFilter("Ending Date", '%1|>=%2', 0D, VehAssemblyHdr."Start Date");
                    //SETFILTER("Currency Code",'%1|%2',VehAssemblyHdr."Currency Code",'');
                    if OptionPurchasePrice.FindLast then begin
                        CurrentExchFactor := CurrExchRate.GetCurrentCurrencyFactor(OptionPurchasePrice."Currency Code");
                        SetCurrency(OptionPurchasePrice."Currency Code", CurrentExchFactor, VehAssemblyHdr."Exchange Date");
                        ConvertPriceFCYToLCY(OptionPurchasePrice."Currency Code", OptionPurchasePrice."Direct Unit Cost");

                        SetCurrency(VehAssemblyHdr."Currency Code", VehAssemblyHdr."Currency Factor", VehAssemblyHdr."Exchange Date");
                        ConvertPriceLCYToFCY('', OptionPurchasePrice."Direct Unit Cost");
                        VehAssembly."Direct Purchase Cost" := OptionPurchasePrice."Direct Unit Cost";
                    end;
                end;
            VehAssembly."option type"::"Vehicle Base":
                with PurchasePrice do begin
                    PurchasePrice.SetRange("Item No.", VehAssembly."Model Version No.");
                    PurchasePrice.SetRange("Starting Date", 0D, VehAssemblyHdr."Start Date");
                    PurchasePrice.SetFilter("Ending Date", '%1|>=%2', 0D, VehAssemblyHdr."Start Date");
                    PurchasePrice.SetFilter("Ordering Price Type Code", '%1|%2', VehAssemblyHdr."Ordering Price Type Code", '');
                    //SETFILTER("Currency Code",'%1|%2',CurrencyCode,'');
                    if PurchasePrice.FindLast then begin
                        CurrentExchFactor := CurrExchRate.GetCurrentCurrencyFactor(OptionPurchasePrice."Currency Code");
                        SetCurrency(OptionPurchasePrice."Currency Code", CurrentExchFactor, VehAssemblyHdr."Exchange Date");
                        ConvertPriceFCYToLCY(OptionPurchasePrice."Currency Code", PurchasePrice."Direct Unit Cost");

                        SetCurrency(VehAssemblyHdr."Currency Code", VehAssemblyHdr."Currency Factor", VehAssemblyHdr."Exchange Date");
                        ConvertPriceLCYToFCY('', PurchasePrice."Direct Unit Cost");
                        VehAssembly."Direct Purchase Cost" := PurchasePrice."Direct Unit Cost";
                    end;
                end;
        end;
    end;


    procedure FindAssemblyLinePurchaseDisc(VehAssemblyHdr: Record "Vehicle Assembly Header"; var VehAssembly: Record "Vehicle Assembly Line")
    var
        OptionPurchaseDiscount: Record "Option Purchase Discount";
        PurchaseLineDiscount: Record "Purchase Line Discount";
        CurrencyCode: Code[10];
    begin
        SetCurrency(VehAssemblyHdr."Currency Code", 0, 0D);
        case VehAssembly."Option Type" of
            VehAssembly."option type"::"Manufacturer Option":
                begin
                    OptionPurchaseDiscount.SetRange("Starting Date", 0D, VehAssemblyHdr."Start Date");
                    OptionPurchaseDiscount.SetFilter("Ending Date", '%1|>=%2', 0D, VehAssemblyHdr."Start Date");
                    //SETFILTER("Currency Code",'%1|%2',VehAssemblyHdr."Currency Code",'');

                    OptionPurchaseDiscount.SetRange("Make Code", VehAssembly."Make Code");
                    OptionPurchaseDiscount.SetRange("Model Code", VehAssembly."Model Code");

                    if VehAssembly."Option Type" <> OptionPurchaseDiscount."option type"::"Own Option" then
                        OptionPurchaseDiscount.SetRange("Model Version No.", VehAssembly."Model Version No.");

                    OptionPurchaseDiscount.SetRange("Option Type", VehAssembly."Option Type");
                    OptionPurchaseDiscount.SetRange("Option Subtype", VehAssembly."Option Subtype");
                    OptionPurchaseDiscount.SetRange("Option Code", VehAssembly."Option Code");
                    if OptionPurchaseDiscount.FindLast then begin
                        VehAssembly."Purchase Discount %" := OptionPurchaseDiscount."Line Discount %";
                    end;
                end;
            VehAssembly."option type"::"Own Option":
                begin
                    OptionPurchaseDiscount.SetRange("Starting Date", 0D, VehAssemblyHdr."Start Date");
                    OptionPurchaseDiscount.SetFilter("Ending Date", '%1|>=%2', 0D, VehAssemblyHdr."Start Date");
                    //SETFILTER("Currency Code",'%1|%2',VehAssemblyHdr."Currency Code",'');

                    OptionPurchaseDiscount.SetRange("Make Code", VehAssembly."Make Code");
                    OptionPurchaseDiscount.SetRange("Model Code", VehAssembly."Model Code");

                    if VehAssembly."Option Type" <> OptionPurchaseDiscount."option type"::"Own Option" then
                        OptionPurchaseDiscount.SetRange("Model Version No.", VehAssembly."Model Version No.");

                    OptionPurchaseDiscount.SetRange("Option Type", VehAssembly."Option Type");
                    OptionPurchaseDiscount.SetRange("Option Subtype", VehAssembly."Option Subtype");
                    OptionPurchaseDiscount.SetRange("Option Code", VehAssembly."Option Code");
                    if OptionPurchaseDiscount.FindLast then begin
                        VehAssembly."Purchase Discount %" := OptionPurchaseDiscount."Line Discount %";
                    end;
                end;
            VehAssembly."option type"::"Vehicle Base":
                with PurchaseLineDiscount do begin
                    PurchaseLineDiscount.SetRange("Item No.", VehAssembly."Model Version No.");
                    PurchaseLineDiscount.SetRange("Starting Date", 0D, VehAssemblyHdr."Start Date");
                    PurchaseLineDiscount.SetFilter("Ending Date", '%1|>=%2', 0D, VehAssemblyHdr."Start Date");
                    //SETFILTER("Currency Code",'%1|%2',CurrencyCode,'');
                    if PurchaseLineDiscount.FindLast then begin
                        VehAssembly."Purchase Discount %" := PurchaseLineDiscount."Line Discount %";
                    end;
                end;
        end;
    end;


    [IntegrationEvent(true, false)]
    local procedure OnBeforeFindOptionOwnOptionPrice(var Ishandled: Boolean; var VehAssembly: Record "Vehicle Assembly Line"; var ToSalesPrice: Record "Sales Price DMS"; CustNo: Code[20]; ContNo: Code[20]; CustPriceGrCode: Code[10]; CampaignNo: Code[20]; OptionNo: Code[20]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean; MakeCode: Code[20]; ModelCode: Code[20]; ModelVersionNo: Code[20]; OptionType: Integer; OptionSubtype: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterFindAssemblyLinePrice(var Rec: Record "Vehicle Assembly Line"; var TempAssemblyPrice: Record "Sales Price DMS" temporary)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUpdatePurchLineAmountsOnBeforeFind(var PurchaseLine: Record "Purchase Line"; var NewVehAssembly: Record "Vehicle Assembly Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterUpdateUnitPrice(var SalesHeader: Record "Sales Header")
    begin
    end;
}

