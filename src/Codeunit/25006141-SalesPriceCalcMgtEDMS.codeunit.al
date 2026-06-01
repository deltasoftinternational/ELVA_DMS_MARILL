codeunit 25006141 "Sales Price Calc. Mgt. EDMS"
{



    procedure FindDMSServLinePrice(ServHeader: Record "Service Header EDMS"; var ServLine: Record "Service Line EDMS"; CalledByFieldNo: Integer)
    begin
        SetCurrency(
  ServHeader."Currency Code", ServHeader."Currency Factor", ServHeader."Order Date");
        SetVAT(ServHeader."Prices Including VAT", ServLine."VAT %", ServLine."VAT Calculation Type", ServLine."VAT Bus. Posting Group");
        SetUoM(Abs(ServLine.Quantity), ServLine."Qty. per Unit of Measure");
        SetLineDisc(ServLine."Line Discount %", ServLine."Allow Line Disc.", ServLine."Allow Invoice Disc.");

        ServLine.TestField("Qty. per Unit of Measure");
        if PricesInCurrency then
            ServHeader.TestField("Currency Factor");

        DMSServLinePriceExists(ServHeader, ServLine, false);
        CopyServicePriceToSalesPrice(TempServicePrice, TempSalesPrice);
        CalcBestUnitPrice(TempSalesPrice);
        //>>Look for Standard Price
        CalcStdUnitPrice(ServHeader, ServLine, TempSalesPrice, CalledByFieldNo);
        //<<
        CalcSPackageUnitPrice(TempSalesPrice, ServLine);  //18.01.2012 EDMS P8

        if TempSalesPrice."Sales Type" = TempSalesPrice."sales type"::Campaign then
            ServLine."Campaign No." := TempSalesPrice."Sales Code";

        if FoundSalesPrice or
            not (
            (CalledByFieldNo = ServLine.FieldNo("Variant Code")))
            then begin
            ServLine."Allow Line Disc." := TempSalesPrice."Allow Line Disc.";
            ServLine."Allow Invoice Disc." := TempSalesPrice."Allow Invoice Disc.";
            //>>DELTA XX
            //if ServHeader."Document Type" = ServHeader."document type"::Quote then
            //    "Unit Price" := ROUND(TempSalesPrice."Unit Price", 0.01)
            //else
            //<<DELTA XX
            ServLine."Unit Price" := TempSalesPrice."Unit Price";
        end;
        if not ServLine."Allow Line Disc." then
            ServLine."Line Discount %" := 0;
    end;

    procedure CalcSPackageUnitPrice(var SalesPrice: Record "Sales Price DMS"; var ServLine: Record "Service Line EDMS")
    var
        ServicePackage: Record "Service Package";
        BestSalesPrice: Record "Sales Price DMS";
    begin
        //18.01.2012 EDMS P8 >>
        BestSalesPrice := SalesPrice;
        if ServLine."Package No." <> '' then begin
            if ServicePackage.Get(ServLine."Package No.") then begin
                if ServicePackage."Fixed Prices and Discounts" then begin
                    SalesPrice.SetRange("Sales Type", SalesPrice."sales type"::SPackage);
                    if SalesPrice.FindSet then
                        BestSalesPrice := SalesPrice;
                end;
            end;
        end;
        SalesPrice := BestSalesPrice;
        //18.01.2012 EDMS P8 <<
    end;

    procedure CalcBestUnitPrice(var SalesPrice: Record "Sales Price DMS")
    var
        BestSalesPrice: Record "Sales Price DMS";
        BestSalesPriceFound: Boolean;
        IsHandled: Boolean;
        VATProdPostingGroup: Code[20];
    begin
        OnBeforeCalcBestUnitPrice(SalesPrice, IsHandled);
        if IsHandled then
            exit;

        //21.11.2007 EDMS P3 >>
        SalesPrice.SetRange("Sales Type", SalesPrice."sales type"::Assembly);
        FoundSalesPrice := SalesPrice.FindSet();
        if not FoundSalesPrice then begin
            SalesPrice.SetRange("Sales Type");
            SalesPrice.SetFilter("Vehicle Serial No.", '<>''''');
            FoundSalesPrice := SalesPrice.Find('-');
            if not FoundSalesPrice then begin
                SalesPrice.SetRange("Vehicle Serial No.");
                FoundSalesPrice := SalesPrice.Find('-');
            end
        end;
        //21.11.2007 EDMS P3 <<
        if FoundSalesPrice then
            repeat
                IsHandled := false;
                OnCalcBestUnitPriceOnBeforeCalcBestUnitPriceConvertPrice(SalesPrice, Qty, IsHandled);
                if not IsHandled then
                    //08.03.2010 EDMS P2 >>
                    case FindPriceFor of
                        Findpricefor::Labor:
                            VATProdPostingGroup := ServLabor."VAT Prod. Posting Group";
                        Findpricefor::Item:
                            VATProdPostingGroup := Item."VAT Prod. Posting Group";
                        Findpricefor::"Ext.Service":
                            VATProdPostingGroup := ExtServ."VAT Prod. Posting Group";
                    end;
                //08.03.2010 EDMS P2 <<
                if IsInMinQty(SalesPrice."Unit of Measure Code", SalesPrice."Minimum Quantity") then begin
                    CalcBestUnitPriceConvertPrice(SalesPrice);

                    case true of
                        ((BestSalesPrice."Currency Code" = '') and (SalesPrice."Currency Code" <> '')) or
                        ((BestSalesPrice."Variant Code" = '') and (SalesPrice."Variant Code" <> '')):
                            begin
                                BestSalesPrice := SalesPrice;
                                BestSalesPriceFound := true;
                            end;
                        ((BestSalesPrice."Currency Code" = '') or (SalesPrice."Currency Code" <> '')) and
                      ((BestSalesPrice."Variant Code" = '') or (SalesPrice."Variant Code" <> '')):
                            if (BestSalesPrice."Unit Price" = 0) or
                               (CalcLineAmount(BestSalesPrice) > CalcLineAmount(SalesPrice))
                            then begin
                                BestSalesPrice := SalesPrice;
                                BestSalesPriceFound := true;
                            end;
                    end;
                end;
            until SalesPrice.Next() = 0;

        OnAfterCalcBestUnitPrice(SalesPrice, BestSalesPrice);

        // No price found in agreement
        if not BestSalesPriceFound then begin
            //20.03.2013 EDMS >>
            case DefaultPriceFor of
                Defaultpricefor::Item:
                    begin
                        //20.03.2013 EDMS <<
                        ConvertPriceToVAT(
                          Item."Price Includes VAT", Item."VAT Prod. Posting Group",
                          Item."VAT Bus. Posting Gr. (Price)", Item."Unit Price");
                        ConvertPriceToUoM('', Item."Unit Price");
                        ConvertPriceLCYToFCY('', Item."Unit Price");

                        Clear(BestSalesPrice);
                        BestSalesPrice."Unit Price" := Item."Unit Price";
                        BestSalesPrice."Allow Line Disc." := AllowLineDisc;
                        BestSalesPrice."Allow Invoice Disc." := AllowInvDisc;
                        OnAfterCalcBestUnitPriceAsItemUnitPrice(BestSalesPrice, Item);

                    end;
                //20.03.2013 EDMS >>
                Defaultpricefor::"Ext.Serv":  // External service can be extended to save price inside record
                    begin
                        ConvertPriceToVAT(
                          ExtServ."Price Includes VAT", ExtServ."VAT Prod. Posting Group",
                          ServLabor."VAT Bus. Posting Gr. (Price)", ExtServ."Unit Price");
                        ConvertPriceToUoM('', ExtServ."Unit Price");
                        ConvertPriceLCYToFCY('', ExtServ."Unit Price");

                        Clear(BestSalesPrice);
                        BestSalesPrice."Unit Price" := ExtServ."Unit Price";
                        BestSalesPrice."Allow Line Disc." := AllowLineDisc;
                        BestSalesPrice."Allow Invoice Disc." := AllowInvDisc;
                    end;
                Defaultpricefor::Labor:
                    begin
                        ConvertPriceToVAT(
                          ServLabor."Price Includes VAT", ServLabor."VAT Prod. Posting Group",
                          ServLabor."VAT Bus. Posting Gr. (Price)", ServLabor."Unit Price");
                        ConvertPriceToUoM('', ServLabor."Unit Price");
                        ConvertPriceLCYToFCY('', ServLabor."Unit Price");

                        Clear(BestSalesPrice);
                        BestSalesPrice."Unit Price" := ServLabor."Unit Price";
                        BestSalesPrice."Allow Line Disc." := AllowLineDisc;
                        BestSalesPrice."Allow Invoice Disc." := AllowInvDisc;
                    end
            end
        end;
        //20.03.2013 EDMS <<
        SalesPrice := BestSalesPrice;
        DefaultPriceFor := Defaultpricefor::Item;     //20.03.2013 EDMS	
    end;

    local procedure CalcLineAmount(SalesPrice: Record "Sales Price DMS") LineAmount: Decimal
    begin
        if SalesPrice."Allow Line Disc." then
            LineAmount := SalesPrice."Unit Price" * (1 - LineDiscPerCent / 100)
        else
            LineAmount := SalesPrice."Unit Price";
        OnAfterCalcLineAmount(SalesPrice, LineAmount);
    end;

    procedure ConvertPriceToVAT(FromPricesInclVAT: Boolean; FromVATProdPostingGr: Code[20]; FromVATBusPostingGr: Code[20]; var UnitPrice: Decimal)
    var
        VATPostingSetup: Record "VAT Posting Setup";
        IsHandled: Boolean;
    begin
        if FromPricesInclVAT then begin
            VATPostingSetup.Get(FromVATBusPostingGr, FromVATProdPostingGr);
            IsHandled := false;
            OnBeforeConvertPriceToVAT(VATPostingSetup, UnitPrice, IsHandled);
            if IsHandled then
                exit;

            case VATPostingSetup."VAT Calculation Type" of
                VATPostingSetup."VAT Calculation Type"::"Reverse Charge VAT":
                    VATPostingSetup."VAT %" := 0;
                VATPostingSetup."VAT Calculation Type"::"Sales Tax":
                    Error(
                      Text010,
                      VATPostingSetup.FieldCaption("VAT Calculation Type"),
                      VATPostingSetup."VAT Calculation Type");
            end;

            case VATCalcType of
                VATCalcType::"Normal VAT",
                VATCalcType::"Full VAT",
                VATCalcType::"Sales Tax":
                    begin
                        if PricesInclVAT then begin
                            if VATBusPostingGr <> FromVATBusPostingGr then
                                UnitPrice := UnitPrice * (100 + VATPerCent) / (100 + VATPostingSetup."VAT %");
                        end else
                            UnitPrice := UnitPrice / (1 + VATPostingSetup."VAT %" / 100);
                    end;
                VATCalcType::"Reverse Charge VAT":
                    UnitPrice := UnitPrice / (1 + VATPostingSetup."VAT %" / 100);
            end;
        end else
            if PricesInclVAT then
                UnitPrice := UnitPrice * (1 + VATPerCent / 100);
    end;

    local procedure ConvertPriceToUoM(UnitOfMeasureCode: Code[10]; var UnitPrice: Decimal)
    begin
        if UnitOfMeasureCode = '' then
            UnitPrice := UnitPrice * QtyPerUOM;
    end;

    procedure ConvertPriceLCYToFCY(CurrencyCode: Code[10]; var UnitPrice: Decimal)
    var
        CurrExchRate: Record "Currency Exchange Rate";
    begin
        if PricesInCurrency then begin
            if CurrencyCode = '' then
                UnitPrice :=
                  CurrExchRate.ExchangeAmtLCYToFCY(ExchRateDate, Currency.Code, UnitPrice, CurrencyFactor);
            UnitPrice := Round(UnitPrice, Currency."Unit-Amount Rounding Precision");
        end else
            UnitPrice := Round(UnitPrice, GLSetup."Unit-Amount Rounding Precision");
    end;


    local procedure CalcBestUnitPriceConvertPrice(var SalesPrice: Record "Sales Price DMS")
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCalcBestUnitPriceConvertPrice(SalesPrice, IsHandled, Item);
        if IsHandled then
            exit;

        ConvertPriceToVAT(
    SalesPrice."Price Includes VAT", Item."VAT Prod. Posting Group",
    SalesPrice."VAT Bus. Posting Gr. (Price)", SalesPrice."Unit Price");
        ConvertPriceToUoM(SalesPrice."Unit of Measure Code", SalesPrice."Unit Price");
        ConvertPriceLCYToFCY(SalesPrice."Currency Code", SalesPrice."Unit Price");
    end;


    procedure CopyServicePriceToSalesPrice(var FromServicePrice: Record "Service Price"; var ToSalesPrice: Record "Sales Price DMS")
    begin
        if FromServicePrice.Find('-') then
            repeat
                if FromServicePrice.Price <> 0 then begin
                    ToSalesPrice.Init;
                    ToSalesPrice."Item No." := FromServicePrice.Code;
                    ToSalesPrice."Sales Type" := FromServicePrice."Sales Type";
                    ToSalesPrice."Sales Code" := FromServicePrice."Sales Code";
                    ToSalesPrice."Starting Date" := FromServicePrice."Starting Date";
                    ToSalesPrice."Ending Date" := FromServicePrice."Ending Date";
                    ToSalesPrice."Currency Code" := FromServicePrice."Currency Code";
                    ToSalesPrice."Unit Price" := FromServicePrice.Price;
                    ToSalesPrice."Price Includes VAT" := FromServicePrice."Price Includes VAT";
                    ToSalesPrice."Allow Invoice Disc." := FromServicePrice."Allow Invoice Disc.";
                    ToSalesPrice."VAT Bus. Posting Gr. (Price)" := FromServicePrice."VAT Bus. Posting Gr. (Price)";
                    ToSalesPrice."Allow Line Disc." := FromServicePrice."Allow Line Disc.";
                    ToSalesPrice."Unit of Measure Code" := FromServicePrice."Unit of Measure Code";
                    ToSalesPrice."Variable Field 25006800" := FromServicePrice."Variable Field 25006800";
                    //30.03.2014 Elva Baltic P1 #RX MMG7.00 >>
                    ToSalesPrice."Make Code" := FromServicePrice."Make Code";
                    //30.03.2014 Elva Baltic P1 #RX MMG7.00 <<
                    ToSalesPrice.Insert;
                end;
            until FromServicePrice.Next = 0;
    end;

    procedure DMSServLinePriceExists(ServiceHeader: Record "Service Header EDMS"; var ServiceLine: Record "Service Line EDMS"; ShowAll: Boolean): Boolean
    var
        Markup: Record "Sales/Serv. Item Markup";
    begin
        case ServiceLine.Type of
            ServiceLine.Type::Item:
                if Item.Get(ServiceLine."No.") then begin
                    FindPriceFor := Findpricefor::Item;
                    FindSalesPrice(
                      TempSalesPrice, ServiceLine."Bill-to Customer No.", ServiceHeader."Bill-to Contact No.",
                      ServiceLine."Customer Price Group", '', ServiceLine."No.", ServiceLine."Variant Code", ServiceLine."Unit of Measure Code",
                      ServiceHeader."Currency Code", ServiceHeaderStartDate(ServiceHeader, DateCaption),
                      ShowAll, ServiceLine."Location Code", ServiceLine."Ordering Price Type Code", 3);
                    FindMarkupPrice(TempSalesPrice, ServiceLine."Bill-to Customer No.", ServiceHeader."Bill-to Contact No.",
                      ServiceLine."Customer Price Group", '', ServiceLine."No.", ServiceHeaderStartDate(ServiceHeader, DateCaption),
                      // ShowAll,"Appl.-to Item Entry");                                                  // 25.03.2014 Elva Baltic P21
                      ShowAll, GetAppltoItemEntryNo(ServiceLine));                                        // 25.03.2014 Elva Baltic P21
                    FindSPPrice(TempSalesPrice, ServiceLine."Package No.", ServiceLine."Package Version No.",
                      ServiceLine."Package Version Spec. Line No.", ServiceLine.Type, ServiceLine."No.");

                    //11.10.2013 EDMS P8
                    if ServiceHeader."Contract No." <> '' then
                        FindContractSalesPrice(
                          TempSalesPrice, ServiceLine."Bill-to Customer No.", ServiceLine."No.", ServiceLine."Variant Code", ServiceLine."Currency Code",
                          ServiceHeaderStartDate(ServiceHeader, DateCaption), ShowAll,
                          ServiceLine."Location Code", ServiceLine."Ordering Price Type Code", 3, ServiceHeader."Vehicle Serial No.", ServiceHeader."Contract No.");

                    exit(TempSalesPrice.Find('-'));
                end;
            ServiceLine.Type::"External Service":
                if ExtServ.Get(ServiceLine."No.") then begin
                    FindPriceFor := Findpricefor::"Ext.Service";
                    //<<DELTA BHA 09/08/2022
                    OnBeforeFindExtServPrice(ServiceHeader, ServiceLine);
                    //>>DELTA BHA 09/08/2022
                    FindExtServPrice(
                      TempSalesPrice, ServiceLine."Bill-to Customer No.", ServiceHeader."Bill-to Contact No.",
                      ServiceHeader."Customer Price Group", '', ServiceLine."No.", ServiceHeader."Currency Code",
                      ServiceHeaderStartDate(ServiceHeader, DateCaption), ShowAll);
                    FindSPPrice(TempSalesPrice, ServiceLine."Package No.", ServiceLine."Package Version No.",
                      ServiceLine."Package Version Spec. Line No.", ServiceLine.Type, ServiceLine."No.");
                    DefaultPriceFor := Defaultpricefor::"Ext.Serv";
                    exit(TempSalesPrice.Find('-'));
                end;
            ServiceLine.Type::Labor:
                if ServLabor.Get(ServiceLine."No.") then begin
                    FindPriceFor := Findpricefor::Labor;
                    //<<DELTA BHA 09/08/2022
                    OnBeforeFindServLaborPrice(ServiceHeader, ServiceLine);
                    //>>DELTA BHA 09/08/2022
                    FindServLaborPrice(
                      TempServicePrice, ServiceLine."Bill-to Customer No.", ServiceHeader."Bill-to Contact No.",
                      ServiceHeader."Customer Price Group", '', ServiceLine."No.", ServiceHeader."Currency Code",
                      ServiceHeaderStartDate(ServiceHeader, DateCaption), ShowAll, ServLabor."Price Group Code", ServiceLine."Unit of Measure Code",
                      //30.03.2014 Elva Baltic P1 #RX MMG7.00 >>
                      //ServiceHeader."Vehicle Serial No.");
                      ServiceHeader."Vehicle Serial No.", ServiceLine."Location Code", ServiceLine."Make Code");
                    //30.03.2014 Elva Baltic P1 #RX MMG7.00 <<
                    FindSPServicePrice(TempServicePrice, ServiceLine."Package No.", ServiceLine."Package Version No.",
                      ServiceLine."Package Version Spec. Line No.", ServiceLine.Type, ServiceLine."No.");
                    FindContractLaborPrice(
                      TempServicePrice, ServiceLine."Bill-to Customer No.", ServiceLine."No.", ServiceLine."Variant Code", ServiceLine."Currency Code",
                      ServiceHeaderStartDate(ServiceHeader, DateCaption), ShowAll,
                      ServiceLine."Location Code", ServiceLine."Ordering Price Type Code", 3, ServiceHeader."Vehicle Serial No.");  //23.08.2013 EDMS P8

                    DefaultPriceFor := Defaultpricefor::Labor;
                    exit(TempServicePrice.Find('-'));
                end
        end;
        exit(false);
    end;

    procedure FindContractLaborPrice(var ToServicePrice: Record "Service Price"; CustNo: Code[20]; LaborNo: Code[20]; VariantCode: Code[10]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean; LocationCode: Code[10]; OrderingPriceType: Code[10]; DocumentProfile: Integer; VehicleSerialNo: Code[20])
    var
        ContractHeader: Record Contract;
        ContractPrice: Record "Contract Sales Price";
        ServiceLabor: Record "Service Labor";
    begin
        ContractHeader.Reset;
        ContractHeader.SetCurrentkey("Bill-to Customer No.");
        ContractHeader.SetRange("Bill-to Customer No.", CustNo);
        ContractHeader.SetRange(Status, ContractHeader.Status::Active);
        ContractHeader.SetRange("Starting Date", 0D, StartingDate);
        ContractHeader.SetFilter("Expiration Date", '%1|>=%2', 0D, StartingDate);

        if DocumentProfile = 1 then
            ContractHeader.SetFilter("Document Profile", '%1|%2',
                   ContractHeader."document profile"::" ", ContractHeader."document profile"::"Spare Parts Trade");
        if DocumentProfile = 3 then
            ContractHeader.SetFilter("Document Profile", '%1|%2',
                   ContractHeader."document profile"::" ", ContractHeader."document profile"::Service);

        if not ContractHeader.Find('-') then
            exit;

        repeat
            ContractPrice.Reset;
            ContractPrice.SetRange("Contract No.", ContractHeader."Contract No.");
            ContractPrice.SetRange(Type, ContractPrice.Type::Labor);
            ContractPrice.SetRange(Code, LaborNo);
            ContractPrice.SetFilter("Variant Code", '%1|%2', VariantCode, '');
            ContractPrice.SetFilter("Ending Date", '%1|>=%2', 0D, StartingDate);
            ContractPrice.SetFilter("Ordering Price Type Code", '%1|%2', OrderingPriceType, '');
            if not ShowAll then begin
                ContractPrice.SetFilter("Currency Code", '%1|%2', CurrencyCode, '');
                ContractPrice.SetRange("Starting Date", 0D, StartingDate);
                ContractPrice.SetFilter("Location Code", '%1|%2', LocationCode, '');
            end;
            ContractPrice.SetFilter("Vehicle Serial No.", '%1|%2', VehicleSerialNo, '');
            CopyContrPriceToServicePrice(ContractPrice, ToServicePrice);
            //23.08.2013 EDMS P8 >>
            if ServiceLabor.Get(LaborNo) then
                if ServiceLabor."Price Group Code" <> '' then begin
                    ContractPrice.Reset;
                    ContractPrice.SetRange("Contract No.", ContractHeader."Contract No.");
                    ContractPrice.SetRange(Type, ContractPrice.Type::"Labor Price Group");
                    ContractPrice.SetRange(Code, ServiceLabor."Price Group Code");
                    ContractPrice.SetFilter("Variant Code", '%1|%2', VariantCode, '');
                    ContractPrice.SetFilter("Ending Date", '%1|>=%2', 0D, StartingDate);
                    ContractPrice.SetFilter("Ordering Price Type Code", '%1|%2', OrderingPriceType, '');
                    if not ShowAll then begin
                        ContractPrice.SetFilter("Currency Code", '%1|%2', CurrencyCode, '');
                        ContractPrice.SetRange("Starting Date", 0D, StartingDate);
                        ContractPrice.SetFilter("Location Code", '%1|%2', LocationCode, '');
                    end;
                    ContractPrice.SetFilter("Vehicle Serial No.", '%1|%2', VehicleSerialNo, '');
                    CopyContrPriceToServicePrice(ContractPrice, ToServicePrice);
                end;
        //23.08.2013 EDMS P8 <<
        until ContractHeader.Next = 0;
    end;

    procedure CopyContrPriceToServicePrice(var ContractPrice: Record "Contract Sales Price"; var ToServicePrice: Record "Service Price")
    begin
        if ContractPrice.FindFirst then begin
            repeat
                ToServicePrice.Init;
                ToServicePrice.Type := ToServicePrice.Type::Labor;
                ToServicePrice.Code := ContractPrice.Code;
                ToServicePrice."Sales Type" := ToServicePrice."sales type"::Contract;
                ToServicePrice."Sales Code" := ContractPrice."Contract No.";
                ToServicePrice."Starting Date" := ContractPrice."Starting Date";
                ToServicePrice."Currency Code" := ContractPrice."Currency Code";
                ToServicePrice."Location Code" := ContractPrice."Location Code";
                ToServicePrice.Price := ContractPrice."Unit Price";
                ToServicePrice."Price Includes VAT" := ContractPrice."Price Includes VAT";
                ToServicePrice."Allow Invoice Disc." := ContractPrice."Allow Invoice Disc.";
                ToServicePrice."VAT Bus. Posting Gr. (Price)" := ContractPrice."VAT Bus. Posting Gr. (Price)";
                ToServicePrice."Ending Date" := ContractPrice."Ending Date";
                ToServicePrice."Allow Line Disc." := ContractPrice."Allow Line Disc.";
                ToServicePrice.Insert;
            until ContractPrice.Next = 0;
        end;
    end;

    procedure FindSPServicePrice(var ToServicePrice: Record "Service Price"; SPackageNo: Code[20]; SPVersionNo: Integer; SPVersionSpecLineNo: Integer; Type: Option " ","G/L Account",Item,Labor,"Ext. Service"; No: Code[20])
    var
        SPackage: Record "Service Package";
        SPVersion: Record "Service Package Version";
        SPVersionSpec: Record "Service Package Version Line";
        ServLineTmp: Record "Service Line EDMS" temporary;
    begin
        if SPackageNo <> '' then begin
            if SPVersionNo = 0 then
                Error(Text101, ServLineTmp.FieldCaption("Package Version No."),
                  ServLineTmp.FieldCaption("Package No."));
            if SPVersionSpecLineNo = 0 then
                Error(Text101, ServLineTmp.FieldCaption("Package Version Spec. Line No."),
                  ServLineTmp.FieldCaption("Package No."));
            SPackage.Get(SPackageNo);
            if SPackage."Fixed Prices and Discounts" then begin
                SPVersionSpec.Get(SPackageNo, SPVersionNo, SPVersionSpecLineNo);
                ToServicePrice.Init;
                ToServicePrice.Type := ToServicePrice.Type::Labor;
                ToServicePrice.Code := No;
                ToServicePrice."Sales Type" := ToServicePrice."sales type"::SPackage;
                ToServicePrice."Sales Code" := SPackageNo;
                ToServicePrice."Starting Date" := SPackage."Starting Date";
                ToServicePrice."Ending Date" := SPackage."Ending Date";
                ToServicePrice."Currency Code" := SPackage."Currency Code";
                ToServicePrice.Price := SPVersionSpec."Unit Price";
                ToServicePrice."Price Includes VAT" := SPackage."Prices Including VAT";
                ToServicePrice."Allow Invoice Disc." := SPVersionSpec."Allow Invoice Disc.";
                ToServicePrice."VAT Bus. Posting Gr. (Price)" := SPackage."VAT Bus. Posting Gr. (Price)";
                if SPackage."Free of Charge" then
                    ToServicePrice."Allow Line Disc." := true
                else
                    ToServicePrice."Allow Line Disc." := SPVersionSpec."Allow Line Disc.";
                ToServicePrice.Insert;
            end
        end;
    end;

    procedure FindServLaborPrice(var ToServicePrice: Record "Service Price"; CustNo: Code[20]; ContNo: Code[20]; CustPriceGrCode: Code[10]; CampaignNo: Code[20]; LaborNo: Code[20]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean; LaborPriceGroupCode: Code[10]; UOM: Code[10]; VehicleSerialNo: Code[20]; LocationCode: Code[20]; MakeCode: Code[20]): Boolean
    var
        FromLaborPrice: Record "Service Price";
        TempTargetCampaignGr: Record "Campaign Target Group" temporary;
        VariableFieldUsage: Record "Variable Field Usage";
        Vehicle: Record Vehicle;
    begin
        FromLaborPrice.SetRange(Type, FromLaborPrice.Type::Labor);
        FromLaborPrice.SetRange(Code, LaborNo);

        FromLaborPrice.SetFilter("Ending Date", '%1|>=%2', 0D, StartingDate);

        //30.03.2014 Elva Baltic P1 #RX MMG7.00 >>
        FromLaborPrice.SetFilter("Location Code", '%1|%2', LocationCode, '');
        FromLaborPrice.SetFilter("Make Code", '%1|%2', MakeCode, '');
        //30.03.2014 Elva Baltic P1 #RX MMG7.00 <<

        if not ShowAll then begin
            FromLaborPrice.SetFilter("Currency Code", '%1|%2', CurrencyCode, '');
            FromLaborPrice.SetRange("Starting Date", 0D, StartingDate);
            if UOM <> '' then
                FromLaborPrice.SetFilter("Unit of Measure Code", '%1|%2', UOM, '');
        end;

        if Vehicle.Get(VehicleSerialNo) then begin
            VariableFieldUsage.Reset;
            VariableFieldUsage.SetRange("Table No.", Database::"Service Price");
            VariableFieldUsage.SetRange("Field No.", 25006800);
            if VariableFieldUsage.FindFirst then
                FromLaborPrice.SetFilter("Variable Field 25006800", '%1|%2', '',
                           GetVariableValue(Vehicle, VariableFieldUsage."Variable Field Code"));
        end;

        ToServicePrice.Reset;
        ToServicePrice.DeleteAll;

        FromLaborPrice.SetRange("Sales Type", FromLaborPrice."sales type"::"All Customers");
        FromLaborPrice.SetRange("Sales Code");
        CopyServicePriceToServicePrice(FromLaborPrice, ToServicePrice);

        if CustNo <> '' then begin
            FromLaborPrice.SetRange("Sales Type", FromLaborPrice."sales type"::Customer);
            FromLaborPrice.SetRange("Sales Code", CustNo);
            CopyServicePriceToServicePrice(FromLaborPrice, ToServicePrice);
        end;

        if CustPriceGrCode <> '' then begin
            FromLaborPrice.SetRange("Sales Type", FromLaborPrice."sales type"::"Customer Price Group");
            FromLaborPrice.SetRange("Sales Code", CustPriceGrCode);
            CopyServicePriceToServicePrice(FromLaborPrice, ToServicePrice);
        end;

        if not ((CustNo = '') and (ContNo = '') and (CampaignNo = '')) then begin
            FromLaborPrice.SetRange("Sales Type", FromLaborPrice."sales type"::Campaign);
            if ActivatedCampaignExists(TempTargetCampaignGr, CustNo, ContNo, CampaignNo) then
                repeat
                    FromLaborPrice.SetRange("Sales Code", TempTargetCampaignGr."Campaign No.");
                    CopyServicePriceToServicePrice(FromLaborPrice, ToServicePrice);
                until TempTargetCampaignGr.Next = 0;
        end;

        if LaborPriceGroupCode <> '' then begin
            FromLaborPrice.SetRange(Type, FromLaborPrice.Type::"Labor Group");
            FromLaborPrice.SetRange(Code, LaborPriceGroupCode);

            FromLaborPrice.SetRange("Sales Type", FromLaborPrice."sales type"::"All Customers");
            FromLaborPrice.SetRange("Sales Code");
            CopyServicePriceToServicePrice(FromLaborPrice, ToServicePrice);

            if CustNo <> '' then begin
                FromLaborPrice.SetRange("Sales Type", FromLaborPrice."sales type"::Customer);
                FromLaborPrice.SetRange("Sales Code", CustNo);
                CopyServicePriceToServicePrice(FromLaborPrice, ToServicePrice);
            end;

            if CustPriceGrCode <> '' then begin
                FromLaborPrice.SetRange("Sales Type", FromLaborPrice."sales type"::"Customer Price Group");
                FromLaborPrice.SetRange("Sales Code", CustPriceGrCode);
                CopyServicePriceToServicePrice(FromLaborPrice, ToServicePrice);
            end;

            if not ((CustNo = '') and (ContNo = '') and (CampaignNo = '')) then begin
                FromLaborPrice.SetRange("Sales Type", FromLaborPrice."sales type"::Campaign);
                if ActivatedCampaignExists(TempTargetCampaignGr, CustNo, ContNo, CampaignNo) then
                    repeat
                        FromLaborPrice.SetRange("Sales Code", TempTargetCampaignGr."Campaign No.");
                        CopyServicePriceToServicePrice(FromLaborPrice, ToServicePrice);
                    until TempTargetCampaignGr.Next = 0;
            end;
        end;
    end;

    procedure FindExtServPrice(var ToSalesPrice: Record "Sales Price DMS"; CustNo: Code[20]; ContNo: Code[20]; CustPriceGrCode: Code[10]; CampaignNo: Code[20]; ExtServNo: Code[20]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean): Boolean
    var
        FromServPrice: Record "Service Price";
        TempTargetCampaignGr: Record "Campaign Target Group" temporary;
    begin
        FromServPrice.SetRange(Type, FromServPrice.Type::"Ext.Serv.");
        FromServPrice.SetRange(Code, ExtServNo);

        FromServPrice.SetFilter("Ending Date", '%1|>=%2', 0D, StartingDate);

        if not ShowAll then begin
            FromServPrice.SetFilter("Currency Code", '%1|%2', CurrencyCode, '');
            FromServPrice.SetRange("Starting Date", 0D, StartingDate);
        end;

        ToSalesPrice.Reset;
        ToSalesPrice.DeleteAll;

        FromServPrice.SetRange("Sales Type", FromServPrice."sales type"::"All Customers");
        FromServPrice.SetRange("Sales Code");
        CopyServicePriceToSalesPrice(FromServPrice, ToSalesPrice);

        if CustNo <> '' then begin
            FromServPrice.SetRange("Sales Type", FromServPrice."sales type"::Customer);
            FromServPrice.SetRange("Sales Code", CustNo);
            CopyServicePriceToSalesPrice(FromServPrice, ToSalesPrice);
        end;

        if CustPriceGrCode <> '' then begin
            FromServPrice.SetRange("Sales Type", FromServPrice."sales type"::"Customer Price Group");
            FromServPrice.SetRange("Sales Code", CustPriceGrCode);
            CopyServicePriceToSalesPrice(FromServPrice, ToSalesPrice);
        end;

        if not ((CustNo = '') and (ContNo = '') and (CampaignNo = '')) then begin
            FromServPrice.SetRange("Sales Type", FromServPrice."sales type"::Campaign);
            if ActivatedCampaignExists(TempTargetCampaignGr, CustNo, ContNo, CampaignNo) then
                repeat
                    FromServPrice.SetRange("Sales Code", TempTargetCampaignGr."Campaign No.");
                    CopyServicePriceToSalesPrice(FromServPrice, ToSalesPrice);
                until TempTargetCampaignGr.Next = 0;
        end;
    end;

    procedure CopyServicePriceToServicePrice(var FromServicePrice: Record "Service Price"; var ToServicePrice: Record "Service Price")
    begin
        if FromServicePrice.Find('-') then
            repeat
                if FromServicePrice.Price <> 0 then begin
                    ToServicePrice := FromServicePrice;
                    ToServicePrice.Insert;
                end;
            until FromServicePrice.Next = 0;
    end;

    procedure FindContractSalesPrice(var ToSalesPrice: Record "Sales Price DMS"; CustNo: Code[20]; ItemNo: Code[20]; VariantCode: Code[10]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean; LocationCode: Code[10]; OrderingPriceType: Code[10]; DocumentProfile: Integer; VehicleSerialNo: Code[20]; ContractNumber: Code[20])
    var
        ContractHeader: Record Contract;
        ContractPrice: Record "Contract Sales Price";
    begin
        ContractHeader.Reset;
        ContractHeader.SetCurrentkey("Bill-to Customer No.");
        ContractHeader.SetRange("Contract No.", ContractNumber);
        ContractHeader.SetRange("Bill-to Customer No.", CustNo);
        ContractHeader.SetRange(Status, ContractHeader.Status::Active);
        ContractHeader.SetRange("Starting Date", 0D, StartingDate);
        ContractHeader.SetFilter("Expiration Date", '%1|>=%2', 0D, StartingDate);

        if DocumentProfile = 1 then
            ContractHeader.SetFilter("Document Profile", '%1|%2',
                   ContractHeader."document profile"::" ", ContractHeader."document profile"::"Spare Parts Trade");
        if DocumentProfile = 3 then
            ContractHeader.SetFilter("Document Profile", '%1|%2',
                   ContractHeader."document profile"::" ", ContractHeader."document profile"::Service);

        if not ContractHeader.Find('-') then
            exit;

        repeat
            ContractPrice.Reset;
            ContractPrice.SetRange("Contract No.", ContractHeader."Contract No.");
            ContractPrice.SetRange(Type, ContractPrice.Type::Item);
            ContractPrice.SetRange(Code, ItemNo);
            ContractPrice.SetFilter("Variant Code", '%1|%2', VariantCode, '');
            ContractPrice.SetFilter("Ending Date", '%1|>=%2', 0D, StartingDate);
            ContractPrice.SetFilter("Ordering Price Type Code", '%1|%2', OrderingPriceType, '');
            if not ShowAll then begin
                ContractPrice.SetFilter("Currency Code", '%1|%2', CurrencyCode, '');
                ContractPrice.SetRange("Starting Date", 0D, StartingDate);
                ContractPrice.SetFilter("Location Code", '%1|%2', LocationCode, '');
            end;
            ContractPrice.SetFilter("Vehicle Serial No.", '%1|%2', VehicleSerialNo, '');
            CopyContrPriceToSalesPrice(ContractPrice, ToSalesPrice);
        until ContractHeader.Next = 0;
    end;

    procedure CopyContrPriceToSalesPrice(var ContractPrice: Record "Contract Sales Price"; var ToSalesPrice: Record "Sales Price DMS")
    begin
        if ContractPrice.FindFirst then
            repeat
                ToSalesPrice.Init;
                ToSalesPrice."Item No." := ContractPrice.Code;
                ToSalesPrice."Sales Type" := ToSalesPrice."sales type"::Contract;
                ToSalesPrice."Sales Code" := ContractPrice."Contract No.";
                ToSalesPrice."Starting Date" := ContractPrice."Starting Date";
                ToSalesPrice."Currency Code" := ContractPrice."Currency Code";
                ToSalesPrice."Variant Code" := ContractPrice."Variant Code";
                ToSalesPrice."Minimum Quantity" := ContractPrice."Minimum Quantity";
                ToSalesPrice."Ordering Price Type Code" := ContractPrice."Ordering Price Type Code";
                ToSalesPrice."Location Code" := ContractPrice."Location Code";
                ToSalesPrice."Unit Price" := ContractPrice."Unit Price";
                ToSalesPrice."Price Includes VAT" := ContractPrice."Price Includes VAT";
                ToSalesPrice."Allow Invoice Disc." := ContractPrice."Allow Invoice Disc.";
                ToSalesPrice."VAT Bus. Posting Gr. (Price)" := ContractPrice."VAT Bus. Posting Gr. (Price)";
                ToSalesPrice."Ending Date" := ContractPrice."Ending Date";
                ToSalesPrice."Allow Line Disc." := ContractPrice."Allow Line Disc.";
                ToSalesPrice.Insert;
            until ContractPrice.Next = 0;
    end;


    procedure FindSPPrice(var ToSalesPrice: Record "Sales Price DMS"; SPackageNo: Code[20]; SPVersionNo: Integer; SPVersionSpecLineNo: Integer; Type: Option " ","G/L Account",Item,Labor,"Ext. Service"; No: Code[20])
    var
        SPackage: Record "Service Package";
        SPVersion: Record "Service Package Version";
        SPVersionSpec: Record "Service Package Version Line";
        ServLineTmp: Record "Service Line EDMS" temporary;
    begin
        if SPackageNo <> '' then begin
            if SPVersionNo = 0 then
                Error(Text101, ServLineTmp.FieldCaption("Package Version No."),
                  ServLineTmp.FieldCaption("Package No."));
            if SPVersionSpecLineNo = 0 then
                Error(Text101, ServLineTmp.FieldCaption("Package Version Spec. Line No."),
                  ServLineTmp.FieldCaption("Package No."));
            SPackage.Get(SPackageNo);
            if SPackage."Fixed Prices and Discounts" then begin
                SPVersionSpec.Get(SPackageNo, SPVersionNo, SPVersionSpecLineNo);
                ToSalesPrice.Init;
                ToSalesPrice."Item No." := No;
                ToSalesPrice."Sales Type" := ToSalesPrice."sales type"::SPackage;
                ToSalesPrice."Sales Code" := SPackageNo;
                ToSalesPrice."Starting Date" := SPackage."Starting Date";
                ToSalesPrice."Ending Date" := SPackage."Ending Date";
                ToSalesPrice."Currency Code" := SPackage."Currency Code";
                ToSalesPrice."Unit Price" := SPVersionSpec."Unit Price";
                ToSalesPrice."Price Includes VAT" := SPackage."Prices Including VAT";
                ToSalesPrice."Allow Invoice Disc." := SPVersionSpec."Allow Invoice Disc.";
                ToSalesPrice."VAT Bus. Posting Gr. (Price)" := SPackage."VAT Bus. Posting Gr. (Price)";
                if SPackage."Free of Charge" then
                    ToSalesPrice."Allow Line Disc." := true
                else
                    ToSalesPrice."Allow Line Disc." := SPVersionSpec."Allow Line Disc.";
                ToSalesPrice.Insert;
            end
        end;
    end;


    procedure FindMarkupPrice(var ToSalesPrice: Record "Sales Price DMS"; CustNo: Code[20]; ContNo: Code[20]; CustPriceGrCode: Code[10]; CampaignNo: Code[20]; ItemNo: Code[20]; StartingDate: Date; ShowAll: Boolean; ApplToEntry: Integer)
    var
        FromMarkup: Record "Sales/Serv. Item Markup";
        Item: Record Item;
        TempTargetCampaignGr: Record "Campaign Target Group" temporary;
        MarkupPrice: Decimal;
    begin
        Item.Get(ItemNo);
        FromMarkup.SetFilter("Ending Date", '%1|>=%2', 0D, StartingDate);
        FromMarkup.SetFilter("Item Category Code", '%1|''''', Item."Item Category Code");

        if not ShowAll then begin
            FromMarkup.SetRange("Starting Date", 0D, StartingDate);
        end;

        FromMarkup.SetRange("Sales Type", FromMarkup."sales type"::"All Customers");
        FromMarkup.SetRange("Sales Code");
        CopyMarkupPriceToSalesPrice(FromMarkup, ToSalesPrice, Item, ApplToEntry);

        if CustNo <> '' then begin
            FromMarkup.SetRange("Sales Type", FromMarkup."sales type"::Customer);
            FromMarkup.SetRange("Sales Code", CustNo);
            CopyMarkupPriceToSalesPrice(FromMarkup, ToSalesPrice, Item, ApplToEntry);
        end;

        if CustPriceGrCode <> '' then begin
            FromMarkup.SetRange("Sales Type", FromMarkup."sales type"::"Customer Price Group");
            FromMarkup.SetRange("Sales Code", CustPriceGrCode);
            CopyMarkupPriceToSalesPrice(FromMarkup, ToSalesPrice, Item, ApplToEntry);
        end;

        if not ((CustNo = '') and (CampaignNo = '')) then begin
            FromMarkup.SetRange("Sales Type", FromMarkup."sales type"::Campaign);
            if ActivatedCampaignExists(TempTargetCampaignGr, CustNo, ContNo, CampaignNo) then
                repeat
                    FromMarkup.SetRange("Sales Code", TempTargetCampaignGr."Campaign No.");
                    CopyMarkupPriceToSalesPrice(FromMarkup, ToSalesPrice, Item, ApplToEntry);
                until TempTargetCampaignGr.Next = 0;
        end;
    end;

    procedure CopyMarkupPriceToSalesPrice(var FromMarkup: Record "Sales/Serv. Item Markup"; var ToSalesPrice: Record "Sales Price DMS"; Item: Record Item; ApplToEntry: Integer)
    var
        ItemLedgEntry: Record "Item Ledger Entry";
        UnitPrice: Decimal;
        UnitPrice2: Decimal;
        FromMarkupTmp: Record "Sales/Serv. Item Markup" temporary;
    begin
        if FromMarkup.FindSet then
            repeat
                case FromMarkup.Base of
                    FromMarkup.Base::"Unit Cost":
                        begin
                            if ApplToEntry = 0 then
                                UnitPrice2 := Item."Unit Cost"
                            else
                                if ItemLedgEntry.Get(ApplToEntry) then begin
                                    ItemLedgEntry.TestField("Item No.", Item."No.");
                                    ItemLedgEntry.CalcFields("Cost Amount (Actual)");
                                    if ItemLedgEntry."Cost Amount (Actual)" <> 0 then                               // 25.03.2014 Elva Baltic P21
                                        UnitPrice2 := ItemLedgEntry."Cost Amount (Actual)" / ItemLedgEntry.Quantity
                                    // 25.03.2014 Elva Baltic P21 >>
                                    else begin
                                        ItemLedgEntry.CalcFields("Cost Amount (Expected)");
                                        UnitPrice2 := ItemLedgEntry."Cost Amount (Expected)" / ItemLedgEntry.Quantity
                                    end;
                                    // 25.03.2014 Elva Baltic P21 <<
                                end;
                            UnitPrice2 := ROUND(UnitPrice2 * (1 + FromMarkup."Markup %" / 100), 0.00001);
                            if (UnitPrice2 <> 0) then
                                if UnitPrice = 0 then begin
                                    UnitPrice := UnitPrice2;
                                    FromMarkupTmp := FromMarkup
                                end else
                                    if UnitPrice2 < UnitPrice then begin
                                        UnitPrice := UnitPrice2;
                                        FromMarkupTmp := FromMarkup
                                    end
                        end
                end
            until FromMarkup.Next = 0;

        if UnitPrice <> 0 then begin
            if ToSalesPrice.Get(Item."No.", ToSalesPrice."sales type"::Markup, '', FromMarkupTmp."Starting Date", '', '', '', 0, '', '', 0, '') then begin
                if UnitPrice < ToSalesPrice."Unit Price" then begin
                    ToSalesPrice."Unit Price" := UnitPrice;
                    ToSalesPrice.Modify
                end
            end else begin
                ToSalesPrice.Init;
                ToSalesPrice."Item No." := Item."No.";
                ToSalesPrice."Sales Type" := ToSalesPrice."sales type"::Markup;
                ToSalesPrice."Sales Code" := FromMarkupTmp."Sales Code";                               //31.05.2016 EB.P30 EDMS T073
                ToSalesPrice."Starting Date" := FromMarkupTmp."Starting Date";
                ToSalesPrice."Ending Date" := FromMarkupTmp."Ending Date";
                ToSalesPrice."Unit Price" := UnitPrice;
                ToSalesPrice."Price Includes VAT" := false;
                // 07.01.2015 EB.P7 #T012>>
                ToSalesPrice."Unit of Measure Code" := '';
                // 07.01.2015 EB.P7 #T012<<
                ToSalesPrice."Allow Invoice Disc." := FromMarkupTmp."Allow Invoice Disc.";
                ToSalesPrice."Allow Line Disc." := FromMarkupTmp."Allow Line Disc.";
                ToSalesPrice.Insert;
            end
        end;
    end;


    procedure FindSalesPrice(var ToSalesPrice: Record "Sales Price DMS"; CustNo: Code[20]; ContNo: Code[20]; CustPriceGrCode: Code[10]; CampaignNo: Code[20]; ItemNo: Code[20]; VariantCode: Code[10]; UOM: Code[10]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean; LocationCode: Code[10]; OrderingPriceType: Code[10]; DocumentProfile: Integer)
    var
        FromSalesPrice: Record "Sales Price DMS";
        TempTargetCampaignGr: Record "Campaign Target Group" temporary;
    begin
        if not ToSalesPrice.IsTemporary then
            Error(TempTableErr);

        ToSalesPrice.Reset();
        ToSalesPrice.DeleteAll();

        OnBeforeFindSalesPrice(
          ToSalesPrice, FromSalesPrice, QtyPerUOM, Qty, CustNo, ContNo, CustPriceGrCode, CampaignNo,
          ItemNo, VariantCode, UOM, CurrencyCode, StartingDate, ShowAll);

        FromSalesPrice.SetRange("Item No.", ItemNo);
        FromSalesPrice.SetFilter("Variant Code", '%1|%2', VariantCode, '');
        FromSalesPrice.SetFilter("Ending Date", '%1|>=%2', 0D, StartingDate);
        //20.03.2013 EDMS >>
        FromSalesPrice.SetFilter("Ordering Price Type Code", '%1|%2', OrderingPriceType, '');

        if Item.Get(ItemNo) and (Item."Item Type" = Item."item type"::"Model Version") then
            Item.FieldError("Item Type");
        //20.03.2013 EDMS <<

        if not ShowAll then begin
            FromSalesPrice.SetFilter("Currency Code", '%1|%2', CurrencyCode, '');
            if UOM <> '' then
                FromSalesPrice.SetFilter("Unit of Measure Code", '%1|%2', UOM, '');
            FromSalesPrice.SetRange("Starting Date", 0D, StartingDate);
            FromSalesPrice.SetFilter("Location Code", '%1|%2', LocationCode, '');  //20.03.2013 EDMS
        end;

        FromSalesPrice.SetRange("Sales Type", FromSalesPrice."Sales Type"::"All Customers");
        FromSalesPrice.SetRange("Sales Code");
        CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);

        if CustNo <> '' then begin
            FromSalesPrice.SetRange("Sales Type", FromSalesPrice."Sales Type"::Customer);
            FromSalesPrice.SetRange("Sales Code", CustNo);
            CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
        end;

        if CustPriceGrCode <> '' then begin
            FromSalesPrice.SetRange("Sales Type", FromSalesPrice."Sales Type"::"Customer Price Group");
            FromSalesPrice.SetRange("Sales Code", CustPriceGrCode);
            CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
        end;

        if not ((CustNo = '') and (ContNo = '') and (CampaignNo = '')) then begin
            FromSalesPrice.SetRange("Sales Type", FromSalesPrice."Sales Type"::Campaign);
            if ActivatedCampaignExists(TempTargetCampaignGr, CustNo, ContNo, CampaignNo) then
                repeat
                    FromSalesPrice.SetRange("Sales Code", TempTargetCampaignGr."Campaign No.");
                    CopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice);
                until TempTargetCampaignGr.Next() = 0;
        end;

        OnAfterFindSalesPrice(
          ToSalesPrice, FromSalesPrice, QtyPerUOM, Qty, CustNo, ContNo, CustPriceGrCode, CampaignNo,
          ItemNo, VariantCode, UOM, CurrencyCode, StartingDate, ShowAll);
    end;


    local procedure CopySalesPriceToSalesPrice(var FromSalesPrice: Record "Sales Price DMS"; var ToSalesPrice: Record "Sales Price DMS")
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeCopySalesPriceToSalesPrice(FromSalesPrice, ToSalesPrice, IsHandled);
        if IsHandled then
            exit;

        if FromSalesPrice.FindSet then
            repeat
                ToSalesPrice := FromSalesPrice;
                ToSalesPrice.Insert;
            until FromSalesPrice.Next() = 0;
    end;




    procedure FindDMSServLineLineDisc(ServHeader: Record "Service Header EDMS"; var ServLine: Record "Service Line EDMS")
    begin
        SetCurrency(ServHeader."Currency Code", 0, 0D);
        SetUoM(Abs(ServLine.Quantity), ServLine."Qty. per Unit of Measure");

        TempSalesLineDisc.Reset;
        TempSalesLineDisc.DeleteAll;

        ServLine.TestField("Qty. per Unit of Measure");
        case ServLine.Type of
            ServLine.Type::Item, ServLine.Type::Labor, ServLine.Type::"External Service":
                begin
                    DMSServLineLineDiscExists(ServHeader, ServLine, false);
                    CopyServLaborDiscToSalesDisc(TempServiceLineDiscount, TempSalesLineDisc);
                    CalcBestLineDisc(TempSalesLineDisc);
                    //>>Look for Standard Discount
                    CalcStdDiscount(ServHeader, ServLine, TempSalesLineDisc);
                    CalcSPackageLineDisc(TempSalesLineDisc, ServLine);  //18.01.2012 EDMS P8

                    if TempSalesPrice."Sales Type" = TempSalesPrice."sales type"::Campaign then
                        ServLine."Campaign No." := TempSalesPrice."Sales Code";

                    ServLine."Line Discount %" := TempSalesLineDisc."Line Discount %";
                end;
        end
    end;

    procedure DMSServLineLineDiscExists(ServiceHeader: Record "Service Header EDMS"; var ServiceLine: Record "Service Line EDMS"; ShowAll: Boolean): Boolean
    begin
        case ServiceLine.Type of
            ServiceLine.Type::Item:
                if Item.Get(ServiceLine."No.") then begin
                    if not Vehicle.Get(ServiceHeader."Vehicle Serial No.") then  //20.12.2013 EDMS P8
                        Vehicle.Init;
                    FindSalesLineDisc(
                      TempSalesLineDisc, ServiceLine."Bill-to Customer No.", ServiceHeader."Bill-to Contact No.",
                      ServiceLine."Customer Disc. Group", '', ServiceLine."No.", Item."Item Disc. Group", ServiceLine."Variant Code", ServiceLine."Unit of Measure Code",
                      ServiceHeader."Currency Code", ServiceHeaderStartDate(ServiceHeader, DateCaption), ShowAll, 3);

                    FindSPLineDisc(TempSalesLineDisc, ServiceLine."Package No.", ServiceLine."Package Version No.",
                      ServiceLine."Package Version Spec. Line No.", ServiceLine.Type, ServiceLine."No.");

                    FindSPContrLineDisc(
                      TempSalesLineDisc, ServiceLine."Bill-to Customer No.", 1, ServiceLine."No."
                      , 3, ServiceHeader."Vehicle Serial No.",
                      ServiceLine."Unit of Measure Code", ServiceHeader."Make Code");

                    // 16.04.2014 Elva Baltic P21 >>
                    // FindContractSalesDisc(  //13.11.2013 EDMS P8
                    //   TempSalesLineDisc,"Bill-to Customer No.", "No.", "Currency Code",
                    //   ServiceHeaderStartDate(ServiceHeader,DateCaption), ShowAll,
                    //   "Location Code", 3, ServiceHeader."Vehicle Serial No.");
                    FindContractSalesDisc2(TempSalesLineDisc, ServiceLine."Contract No.", Item."Item Category Code",
                      ServiceHeaderStartDate(ServiceHeader, DateCaption), ServiceLine."Currency Code", ServiceLine."Location Code", ShowAll);
                    // 16.04.2014 Elva Baltic P21 <<

                    FindItemCategorySalesDisc(TempSalesLineDisc, ServiceLine, ServiceHeaderStartDate(ServiceHeader, DateCaption), ShowAll);  // 04.02.2016 EB.P30 #T032

                    exit(TempSalesLineDisc.Find('-'));
                end;
            ServiceLine.Type::"External Service":
                if ExtServ.Get(ServiceLine."No.") then begin
                    FindSPLineDisc(TempSalesLineDisc, ServiceLine."Package No.", ServiceLine."Package Version No.",
                      ServiceLine."Package Version Spec. Line No.", ServiceLine.Type, ServiceLine."No.");
                    exit(TempSalesLineDisc.Find('-'));
                end;
            ServiceLine.Type::Labor:
                if ServLabor.Get(ServiceLine."No.") then begin
                    //11.10.2013 EDMS P8
                    /*
                    FindSPContrLineDisc(
                      TempSalesLineDisc,"Bill-to Customer No.",2,"No."
                      ,3,ServiceHeader."Vehicle Serial No.",
                      "Unit of Measure Code");
                     */

                    FindSPServiceDisc(TempServiceLineDiscount, ServiceLine."Package No.", ServiceLine."Package Version No.",
                      ServiceLine."Package Version Spec. Line No.", ServiceLine.Type, ServiceLine."No.");

                    //23.08.2013 EDMS P8
                    FindServLaborDisc(
                      TempServiceLineDiscount, ServLabor."No.", ServiceHeader."Vehicle Serial No.",
                      ServiceLine."Bill-to Customer No.", ServiceLine."Customer Disc. Group",
                      ServiceHeader."Currency Code", ServiceHeaderStartDate(ServiceHeader, DateCaption), ShowAll);

                    // 16.04.2014 Elva Baltic P21 >>
                    // FindContractLaborDisc(
                    //   TempServiceLineDiscount, "Bill-to Customer No.", "No.", "Variant Code", "Currency Code",
                    //   ServiceHeaderStartDate(ServiceHeader,DateCaption), ShowAll,
                    //   "Location Code", "Ordering Price Type Code", 3, ServiceHeader."Vehicle Serial No.");  //23.08.2013 EDMS P8
                    FindContractLaborDisc2(TempServiceLineDiscount, ServiceLine, ServiceHeaderStartDate(ServiceHeader, DateCaption), ShowAll);
                    // 16.04.2014 Elva Baltic P21 <<

                    exit(TempServiceLineDiscount.Find('-'));
                end
        end;
        exit(false);

    end;


    procedure FindContractLaborDisc2(var ToLaborSalesLineDiscount: Record "Labor Sales Line Discount"; ServiceLine: Record "Service Line EDMS"; StartingDate: Date; ShowAll: Boolean)
    var
        ContractHeader: Record Contract;
        ContractDiscount: Record "Contract Sales Line Discount";
        ServiceLabor: Record "Service Labor";
        VehicleLoc: Record Vehicle;
    begin
        ContractDiscount.Reset;
        ContractDiscount.SetRange("Contract Type", ContractDiscount."contract type"::Contract);
        ContractDiscount.SetRange("Contract No.", ServiceLine."Contract No.");
        ContractDiscount.SetRange(Type, ContractDiscount.Type::Labor);
        ContractDiscount.SetRange("No.", ServiceLine."No.");
        ContractDiscount.SetFilter("Ending Date", '%1|>=%2', 0D, StartingDate);
        if not ShowAll then begin
            ContractDiscount.SetFilter("Currency Code", '%1|%2', ServiceLine."Currency Code", '');
            ContractDiscount.SetRange("Starting Date", 0D, StartingDate);
            ContractDiscount.SetFilter("Location Code", '%1|%2', ServiceLine."Location Code", '');
        end;

        CopyContrDiscToSalesDisc(ContractDiscount, TempSalesLineDisc);

        if ServiceLabor.Get(ServiceLine."No.") then
            if ServiceLabor."Labor Discount Group" <> '' then begin
                ContractDiscount.Reset;
                ContractDiscount.SetRange("Contract Type", ContractDiscount."contract type"::Contract);
                ContractDiscount.SetRange("Contract No.", ServiceLine."Contract No.");
                ContractDiscount.SetRange(Type, ContractDiscount.Type::"Labor Discount Group");
                ContractDiscount.SetRange("No.", ServiceLabor."Labor Discount Group");
                ContractDiscount.SetFilter("Ending Date", '%1|>=%2', 0D, StartingDate);
                if not ShowAll then begin
                    ContractDiscount.SetFilter("Currency Code", '%1|%2', ServiceLine."Currency Code", '');
                    ContractDiscount.SetRange("Starting Date", 0D, StartingDate);
                    ContractDiscount.SetFilter("Location Code", '%1|%2', ServiceLine."Location Code", '');
                end;
                CopyContrDiscToSalesDisc(ContractDiscount, TempSalesLineDisc);
            end;
    end;

    procedure FindServLaborDisc(var ToLaborSalesLineDiscount: Record "Labor Sales Line Discount"; LaborNo: Code[20]; VehicleSerialNo: Code[20]; CustNo: Code[20]; CustDiscGrCode: Code[20]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean)
    var
        LaborSalesLineDiscount: Record "Labor Sales Line Discount";
        ServiceLabor: Record "Service Labor";
        VehicleLoc: Record Vehicle;
        LineDiscount: Decimal;
    begin
        LaborSalesLineDiscount.Reset;
        LaborSalesLineDiscount.SetFilter("Ending Date", '%1|>=%2', 0D, StartingDate);
        ServiceLabor.Get(LaborNo);
        if not ShowAll then begin
            LaborSalesLineDiscount.SetRange("Starting Date", 0D, StartingDate);
            LaborSalesLineDiscount.SetFilter("Currency Code", '%1|%2', CurrencyCode, '');
            LaborSalesLineDiscount.SetFilter("Vehicle Serial No.", '%1|%2', VehicleSerialNo, '');
        end;

        for LaborSalesLineDiscount."Sales Type" := LaborSalesLineDiscount."sales type"::Customer to LaborSalesLineDiscount."sales type"::Campaign do
            if (LaborSalesLineDiscount."Sales Type" = LaborSalesLineDiscount."sales type"::"All Customers") or
               ((LaborSalesLineDiscount."Sales Type" = LaborSalesLineDiscount."sales type"::Customer) and (CustNo <> '')) or
               ((LaborSalesLineDiscount."Sales Type" = LaborSalesLineDiscount."sales type"::"Customer Disc. Group") and (CustDiscGrCode <> ''))
            then begin
                LaborSalesLineDiscount.SetRange("Sales Type", LaborSalesLineDiscount."Sales Type");
                case LaborSalesLineDiscount."Sales Type" of
                    LaborSalesLineDiscount."sales type"::"All Customers":
                        LaborSalesLineDiscount.SetRange("Sales Code");
                    LaborSalesLineDiscount."sales type"::Customer:
                        LaborSalesLineDiscount.SetRange("Sales Code", CustNo);
                    LaborSalesLineDiscount."sales type"::"Customer Disc. Group":
                        LaborSalesLineDiscount.SetRange("Sales Code", CustDiscGrCode);
                end;

                LaborSalesLineDiscount.SetRange(Type, LaborSalesLineDiscount.Type::Labor);
                LaborSalesLineDiscount.SetRange(Code, LaborNo);
                CopyServLaborDiscToServDisc(LaborSalesLineDiscount, ToLaborSalesLineDiscount);

                if ServiceLabor."Labor Discount Group" <> '' then begin
                    LaborSalesLineDiscount.SetRange(Type, LaborSalesLineDiscount.Type::"Labor Discount Group");
                    LaborSalesLineDiscount.SetRange(Code, ServiceLabor."Labor Discount Group");
                    CopyServLaborDiscToServDisc(LaborSalesLineDiscount, ToLaborSalesLineDiscount);
                end;

            end;
    end;

    procedure FindSPServiceDisc(var ToLaborSalesLineDiscount: Record "Labor Sales Line Discount"; SPackageNo: Code[20]; SPVersionNo: Integer; SPVersionSpecLineNo: Integer; Type: Option " ","G/L Account",Item,Labor,"Ext. Service"; No: Code[20])
    var
        SPackage: Record "Service Package";
        SPVersion: Record "Service Package Version";
        SPVersionSpec: Record "Service Package Version Line";
        ServLineTmp: Record "Service Line EDMS" temporary;
    begin
        if SPackageNo <> '' then begin
            if SPVersionNo = 0 then
                Error(Text101, ServLineTmp.FieldCaption("Package Version No."),
                  ServLineTmp.FieldCaption("Package No."));
            if SPVersionSpecLineNo = 0 then
                Error(Text101, ServLineTmp.FieldCaption("Package Version Spec. Line No."),
                  ServLineTmp.FieldCaption("Package No."));
            SPackage.Get(SPackageNo);
            if SPackage."Free of Charge" then begin
                ToLaborSalesLineDiscount.Init;
                ToLaborSalesLineDiscount.Type := ToLaborSalesLineDiscount.Type::All;
                ToLaborSalesLineDiscount.Code := '';
                ToLaborSalesLineDiscount."Sales Type" := ToLaborSalesLineDiscount."sales type"::SPackage;
                ToLaborSalesLineDiscount."Sales Code" := SPackageNo;
                ToLaborSalesLineDiscount."Starting Date" := SPackage."Starting Date";
                ToLaborSalesLineDiscount."Ending Date" := SPackage."Ending Date";
                ToLaborSalesLineDiscount."Currency Code" := SPackage."Currency Code";
                ToLaborSalesLineDiscount."Line Discount %" := 100;
                ToLaborSalesLineDiscount.Insert;
            end else
                if SPackage."Fixed Prices and Discounts" then begin
                    SPVersionSpec.Get(SPackageNo, SPVersionNo, SPVersionSpecLineNo);
                    ToLaborSalesLineDiscount.Init;
                    ToLaborSalesLineDiscount.Type := ToLaborSalesLineDiscount.Type::All;
                    ToLaborSalesLineDiscount.Code := '';
                    ToLaborSalesLineDiscount."Sales Type" := ToLaborSalesLineDiscount."sales type"::SPackage;
                    ToLaborSalesLineDiscount."Sales Code" := SPackageNo;
                    ToLaborSalesLineDiscount."Starting Date" := SPackage."Starting Date";
                    ToLaborSalesLineDiscount."Ending Date" := SPackage."Ending Date";
                    ToLaborSalesLineDiscount."Currency Code" := SPackage."Currency Code";
                    ToLaborSalesLineDiscount."Line Discount %" := SPVersionSpec."Discount %";
                    ToLaborSalesLineDiscount.Insert;
                end
        end;
    end;

    local procedure CopyServLaborDiscToServDisc(var FromLaborSalesLineDiscount: Record "Labor Sales Line Discount"; var ToLaborSalesLineDiscount: Record "Labor Sales Line Discount")
    begin
        if FromLaborSalesLineDiscount.FindSet then
            repeat
                if FromLaborSalesLineDiscount."Line Discount %" <> 0 then begin
                    ToLaborSalesLineDiscount := FromLaborSalesLineDiscount;  //14.01.2014 EDMS P8
                    ToLaborSalesLineDiscount.Insert;
                end;
            until FromLaborSalesLineDiscount.Next = 0;
    end;

    procedure CopyContrDiscToSalesDisc(var ContractDiscount: Record "Contract Sales Line Discount"; var ToSalesDiscount: Record "Sales Line Discount DMS")
    begin
        //23.08.2013 EDMS P8
        if ContractDiscount.FindFirst then
            repeat
                ToSalesDiscount.Init;
                ToSalesDiscount.Type := ContractDiscount.Type + 2;  //05.12.2013 EDMS P8
                ToSalesDiscount.Code := ContractDiscount."No.";
                ToSalesDiscount."Sales Type" := ToSalesDiscount."sales type"::Contract;
                ToSalesDiscount."Sales Code" := ContractDiscount."Contract No.";
                ToSalesDiscount."Starting Date" := ContractDiscount."Starting Date";
                ToSalesDiscount."Currency Code" := ContractDiscount."Currency Code";
                ToSalesDiscount."Minimum Quantity" := ContractDiscount."Minimum Quantity";
                ToSalesDiscount."Line Discount %" := ContractDiscount."Line Discount %";
                ToSalesDiscount."Ending Date" := ContractDiscount."Ending Date";
                //21.11.2013 EDMS P8 >>
                ToSalesDiscount."Document Profile" := ContractDiscount."Document Profile";
                ToSalesDiscount."Vehicle Serial No." := ContractDiscount."Vehicle Serial No.";
                ToSalesDiscount."Make Code" := ContractDiscount."Make Code";
                if ToSalesDiscount.Insert(true) then; //08.10.2013 EDMS P8
            until ContractDiscount.Next = 0;
    end;

    procedure FindSPContrLineDisc(var ToSalesLineDisc: Record "Sales Line Discount DMS"; CustNo: Code[20]; Type: Option ,Item,Labor; ItemNo: Code[20]; intDocumentProfile: Integer; "Vehicle Serial No.": Code[20]; UnitMeasureCode: Code[10]; MakeCode: Code[20])
    var
        recContractHeader: Record Contract;
        recContractLine: Record "Contract Sales Line Discount";
        LastContractLineTmp: Record "Contract Sales Line Discount" temporary;
        codNo: Code[20];
        intType: Integer;
        recItem: Record Item;
        LineDiscount: Decimal;
        ContractNo: Code[20];
        VehicleLoc: Record Vehicle;
    begin
        recContractHeader.Reset;
        recContractHeader.SetCurrentkey("Bill-to Customer No.");
        recContractHeader.SetRange("Bill-to Customer No.", CustNo);
        recContractHeader.SetRange(Status, recContractHeader.Status::Active);

        if intDocumentProfile = 1 then
            recContractHeader.SetFilter("Document Profile", '%1|%2',
                   recContractHeader."document profile"::" ", recContractHeader."document profile"::"Spare Parts Trade");
        if intDocumentProfile = 3 then
            recContractHeader.SetFilter("Document Profile", '%1|%2',
                   recContractHeader."document profile"::" ", recContractHeader."document profile"::Service);

        if not recContractHeader.Find('-') then
            exit;

        case Type of
            Type::Item:
                begin
                    recItem.Get(ItemNo);
                    intType := recContractLine.Type::"Item Category";
                    codNo := recItem."Item Category Code";
                end;
            Type::Labor:
                //11.10.2013 EDMS P8
                //that case is used only for case when is not known person so actual contract could not be found
                // like from function: DMSSPLineLineDiscExists
                begin
                    intType := recContractLine.Type::Labor;
                    codNo := ItemNo; //write labor no.
                end;
        end;

        recContractLine.Reset;
        recContractLine.SetRange("Contract No.", recContractHeader."Contract No.");
        recContractLine.SetRange(Type, intType);
        recContractLine.SetFilter("Vehicle Serial No.", '%1|%2', "Vehicle Serial No.", '');
        recContractLine.SetFilter("No.", '%1|%2', codNo, '');
        recContractLine.SetFilter("Unit of Measure Code", '%1|%2', '', UnitMeasureCode);
        //11.10.2013 EDMS P8 >>
        if "Vehicle Serial No." <> '' then
            if MakeCode = '' then
                if VehicleLoc.Get("Vehicle Serial No.") then
                    MakeCode := VehicleLoc."Make Code";
        if MakeCode <> '' then
            recContractLine.SetFilter("Make Code", '%1|%2', '', MakeCode);

        //06.06.2019 EB.P7 BC Upgr. >>
        //IF Type = Type::Item THEN BEGIN
        //  IF recItem."Product Group Code" <> '' THEN
        //    recContractLine.SETFILTER("Product Group Code", '%1|%2', '', recItem."Product Group Code");
        //END;
        //11.10.2013 EDMS P8 <<
        //06.06.2019 EB.P7 BC Upgr. <<

        if recContractLine.FindFirst then begin
            LineDiscount := recContractLine."Line Discount %";
            ContractNo := recContractLine."Contract No.";
            repeat
                if LineDiscount < recContractLine."Line Discount %" then begin
                    LineDiscount := recContractLine."Line Discount %";
                    ContractNo := recContractLine."Contract No.";
                    LastContractLineTmp := recContractLine;  //08.10.2013 EDMS P8
                end;
            until recContractLine.Next = 0;
        end;

        if LineDiscount > 0 then begin
            CopyContrDiscToSalesDisc(LastContractLineTmp, ToSalesLineDisc); //08.10.2013 EDMS P8
                                                                            //ToSalesLineDisc..INIT;
                                                                            //ToSalesLineDisc."Sales Type" := ToSalesLineDisc."Sales Type"::Contract;
                                                                            //ToSalesLineDisc."Sales Code" := ContractNo;
                                                                            //ToSalesLineDisc.Type := intType;
                                                                            //ToSalesLineDisc.Code := codNo;
                                                                            //ToSalesLineDisc."Line Discount %" := recContractLine."Line Discount %";
                                                                            //ToSalesLineDisc."Document Profile" := intDocumentProfile;
                                                                            //ToSalesLineDisc.INSERT(TRUE);
        end;
    end;

    local procedure FindItemCategorySalesDisc(var ToSalesDisc: Record "Sales Line Discount DMS"; ServiceLinePar: Record "Service Line EDMS"; ServDate: Date; ShowAll: Boolean)
    var
        FromSalesLineDisc: Record "Sales Line Discount DMS";
        Vehicle: Record Vehicle;
    begin
        if Vehicle.Get(ServiceLinePar."Vehicle Serial No.") then;
        FromSalesLineDisc.SetRange(Type, FromSalesLineDisc.Type::All);
        FromSalesLineDisc.SetRange("Currency Code", ServiceLinePar."Currency Code");
        FromSalesLineDisc.SetFilter("Minimum Quantity", '..%1', ServiceLinePar.Quantity);
        FromSalesLineDisc.SetFilter("Starting Date", '..%1', ServDate);
        FromSalesLineDisc.SetFilter("Ending Date", '%1|%2..', 0D, ServDate);
        FromSalesLineDisc.SetFilter("Unit of Measure Code", '%1|%2', '', ServiceLinePar."Unit of Measure Code");
        FromSalesLineDisc.SetFilter("Variant Code", '%1|%2', '', ServiceLinePar."Variant Code");
        //  SETRANGE("Document Profile", "Document Profile"::"Service Document");
        FromSalesLineDisc.SetFilter("Make Code", '%1|%2', '', ServiceLinePar."Make Code");
        FromSalesLineDisc.SetFilter("Vehicle Status Code", '%1|%2', '', Vehicle."Status Code");
        FromSalesLineDisc.SetFilter("Model Code", '%1|%2', '', ServiceLinePar."Model Code");
        FromSalesLineDisc.SetFilter("Model Version No.", '%1|%2', '', Vehicle."Model Version No.");
        FromSalesLineDisc.SetFilter("Vehicle Serial No.", '%1|%2', '', ServiceLinePar."Vehicle Serial No.");

        FromSalesLineDisc.SetFilter("Sales Type", '%1', FromSalesLineDisc."sales type"::"All Customers");
        CopyItemCategoryDiscToSalesDisc(ToSalesDisc, FromSalesLineDisc);
        FromSalesLineDisc.SetFilter("Sales Type", '%1', FromSalesLineDisc."sales type"::Customer);
        FromSalesLineDisc.SetFilter("Sales Code", '%1', ServiceLinePar."Sell-to Customer No.");
        CopyItemCategoryDiscToSalesDisc(ToSalesDisc, FromSalesLineDisc);
        FromSalesLineDisc.SetFilter("Sales Type", '%1', FromSalesLineDisc."sales type"::"Customer Disc. Group");
        FromSalesLineDisc.SetFilter("Sales Code", '%1', ServiceLinePar."Customer Disc. Group");
        CopyItemCategoryDiscToSalesDisc(ToSalesDisc, FromSalesLineDisc);
        FromSalesLineDisc.SetFilter("Sales Type", '%1', FromSalesLineDisc."sales type"::Campaign);
        FromSalesLineDisc.SetFilter("Sales Code", '%1', ServiceLinePar."Campaign No.");
        FromSalesLineDisc.SetFilter("Starting Date", '');
        FromSalesLineDisc.SetFilter("Ending Date", '');
        CopyItemCategoryDiscToSalesDisc(ToSalesDisc, FromSalesLineDisc);
    end;

    local procedure CopyItemCategoryDiscToSalesDisc(var ToSalesDisc: Record "Sales Line Discount DMS"; var FromSalesLineDisc: Record "Sales Line Discount DMS")
    begin
        if FromSalesLineDisc.FindFirst then
            repeat
                ToSalesDisc.Init;
                ToSalesDisc := FromSalesLineDisc;
                if ToSalesDisc.Insert(true) then;
            until FromSalesLineDisc.Next = 0;
    end;

    procedure FindContractSalesDisc2(var ToSalesDisc: Record "Sales Line Discount DMS"; ContractNo: Code[20]; ItemCatCode: Code[20]; StartingDate: Date; CurrencyCode: Code[10]; LocationCode: Code[10]; ShowAll: Boolean)
    var
        ContractDiscount: Record "Contract Sales Line Discount";
    begin
        if ItemCatCode = '' then
            exit;

        ContractDiscount.Reset;
        ContractDiscount.SetRange("Contract Type", ContractDiscount."contract type"::Contract);
        ContractDiscount.SetRange("Contract No.", ContractNo);
        ContractDiscount.SetRange(Type, ContractDiscount.Type::"Item Category");
        ContractDiscount.SetRange("No.", ItemCatCode);
        ContractDiscount.SetFilter("Ending Date", '%1|>=%2', 0D, StartingDate);
        if not ShowAll then begin
            ContractDiscount.SetFilter("Currency Code", '%1|%2', CurrencyCode, '');
            ContractDiscount.SetRange("Starting Date", 0D, StartingDate);
            ContractDiscount.SetFilter("Location Code", '%1|%2', LocationCode, '');
        end;
        CopyContrDiscToSalesDisc(ContractDiscount, ToSalesDisc);
    end;

    procedure FindSPLineDisc(var ToSalesLineDisc: Record "Sales Line Discount DMS"; SPackageNo: Code[20]; SPVersionNo: Integer; SPVersionSpecLineNo: Integer; Type: Option " ","G/L Account",Item,Labor,"Ext. Service"; No: Code[20])
    var
        SPackage: Record "Service Package";
        SPVersion: Record "Service Package Version";
        SPVersionSpec: Record "Service Package Version Line";
        ServLineTmp: Record "Service Line EDMS" temporary;
    begin
        if SPackageNo <> '' then begin
            if SPVersionNo = 0 then
                Error(Text101, ServLineTmp.FieldCaption("Package Version No."),
                  ServLineTmp.FieldCaption("Package No."));
            if SPVersionSpecLineNo = 0 then
                Error(Text101, ServLineTmp.FieldCaption("Package Version Spec. Line No."),
                  ServLineTmp.FieldCaption("Package No."));
            SPackage.Get(SPackageNo);
            if SPackage."Free of Charge" then begin
                ToSalesLineDisc.Init;
                ToSalesLineDisc.Type := ToSalesLineDisc.Type::Item;
                ToSalesLineDisc.Code := No;
                ToSalesLineDisc."Sales Type" := ToSalesLineDisc."sales type"::SPackage;
                ToSalesLineDisc."Sales Code" := SPackageNo;
                ToSalesLineDisc."Starting Date" := SPackage."Starting Date";
                ToSalesLineDisc."Ending Date" := SPackage."Ending Date";
                ToSalesLineDisc."Currency Code" := SPackage."Currency Code";
                ToSalesLineDisc."Line Discount %" := 100;
                ToSalesLineDisc.Insert;
            end else
                if SPackage."Fixed Prices and Discounts" then begin
                    SPVersionSpec.Get(SPackageNo, SPVersionNo, SPVersionSpecLineNo);
                    ToSalesLineDisc.Init;
                    ToSalesLineDisc.Type := ToSalesLineDisc.Type::Item;
                    ToSalesLineDisc.Code := No;
                    ToSalesLineDisc."Sales Type" := ToSalesLineDisc."sales type"::SPackage;
                    ToSalesLineDisc."Sales Code" := SPackageNo;
                    ToSalesLineDisc."Starting Date" := SPackage."Starting Date";
                    ToSalesLineDisc."Ending Date" := SPackage."Ending Date";
                    ToSalesLineDisc."Currency Code" := SPackage."Currency Code";
                    ToSalesLineDisc."Line Discount %" := SPVersionSpec."Discount %";
                    ToSalesLineDisc.Insert;
                end
        end;
    end;

    procedure ServiceHeaderStartDate(ServiceHeader: Record "Service Header EDMS"; var DateCaption: Text[30]): Date
    begin
        if ServiceHeader."Document Type" = ServiceHeader."document type"::Order then begin
            DateCaption := ServiceHeader.FieldCaption("Posting Date");
            exit(ServiceHeader."Posting Date")
        end else begin
            DateCaption := ServiceHeader.FieldCaption("Order Date");
            exit(ServiceHeader."Order Date");
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

        IsHandled := false;
        OnBeforeActivatedCampaignExists(ToCampaignTargetGr, CustNo, ContNo, CampaignNo, IsHandled);
        IF IsHandled then
            exit;

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
                until FromCampaignTargetGr.Next() = 0
            else
                if Cont.Get(ContNo) then begin
                    FromCampaignTargetGr.SetRange(Type, FromCampaignTargetGr.Type::Contact);
                    FromCampaignTargetGr.SetRange("No.", Cont."Company No.");
                    if FromCampaignTargetGr.FindSet then
                        repeat
                            ToCampaignTargetGr := FromCampaignTargetGr;
                            ToCampaignTargetGr.Insert();
                        until FromCampaignTargetGr.Next() = 0;
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

    procedure FindSalesLineDisc(var ToSalesLineDisc: Record "Sales Line Discount DMS"; CustNo: Code[20]; ContNo: Code[20]; CustDiscGrCode: Code[20]; CampaignNo: Code[20]; ItemNo: Code[20]; ItemDiscGrCode: Code[20]; VariantCode: Code[10]; UOM: Code[10]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean; DocumentProfile: Integer)
    var
        FromSalesLineDisc: Record "Sales Line Discount DMS";
        TempCampaignTargetGr: Record "Campaign Target Group" temporary;
        InclCampaigns: Boolean;
        recItem: Record Item;
    begin
        OnBeforeFindSalesLineDisc(
          ToSalesLineDisc, CustNo, ContNo, CustDiscGrCode, CampaignNo, ItemNo, ItemDiscGrCode, VariantCode, UOM,
          CurrencyCode, StartingDate, ShowAll);

        FromSalesLineDisc.SetFilter("Ending Date", '%1|>=%2', 0D, StartingDate);
        FromSalesLineDisc.SetFilter("Variant Code", '%1|%2', VariantCode, '');
        //EDMS >>
        FromSalesLineDisc.SetFilter("Document Profile", '%1|%2', DocumentProfile, 0);
        if Item.Get(ItemNo) and (Item."Item Type" = Item."item type"::"Model Version") then
            Item.FieldError("Item Type");
        //EDMS <<
        OnFindSalesLineDiscOnAfterSetFilters(FromSalesLineDisc);
        if not ShowAll then begin
            FromSalesLineDisc.SetRange("Starting Date", 0D, StartingDate);
            FromSalesLineDisc.SetFilter("Currency Code", '%1|%2', CurrencyCode, '');
            if UOM <> '' then
                FromSalesLineDisc.SetFilter("Unit of Measure Code", '%1|%2', UOM, '');
        end;

        ToSalesLineDisc.Reset();
        ToSalesLineDisc.DeleteAll();
        for FromSalesLineDisc."Sales Type" := FromSalesLineDisc."Sales Type"::Customer to FromSalesLineDisc."Sales Type"::Campaign do
            if (FromSalesLineDisc."Sales Type" = FromSalesLineDisc."Sales Type"::"All Customers") or
               ((FromSalesLineDisc."Sales Type" = FromSalesLineDisc."Sales Type"::Customer) and (CustNo <> '')) or
               ((FromSalesLineDisc."Sales Type" = FromSalesLineDisc."Sales Type"::"Customer Disc. Group") and (CustDiscGrCode <> '')) or
               ((FromSalesLineDisc."Sales Type" = FromSalesLineDisc."Sales Type"::Campaign) and
                not ((CustNo = '') and (ContNo = '') and (CampaignNo = '')))
            then begin
                InclCampaigns := false;

                FromSalesLineDisc.SetRange("Sales Type", FromSalesLineDisc."Sales Type");
                case FromSalesLineDisc."Sales Type" of
                    FromSalesLineDisc."Sales Type"::"All Customers":
                        FromSalesLineDisc.SetRange("Sales Code");
                    FromSalesLineDisc."Sales Type"::Customer:
                        FromSalesLineDisc.SetRange("Sales Code", CustNo);
                    FromSalesLineDisc."Sales Type"::"Customer Disc. Group":
                        FromSalesLineDisc.SetRange("Sales Code", CustDiscGrCode);
                    FromSalesLineDisc."Sales Type"::Campaign:
                        begin
                            InclCampaigns := ActivatedCampaignExists(TempCampaignTargetGr, CustNo, ContNo, CampaignNo);
                            FromSalesLineDisc.SetRange("Sales Code", TempCampaignTargetGr."Campaign No.");
                        end;
                end;

                repeat
                    FromSalesLineDisc.SetRange(Type, FromSalesLineDisc.Type::Item);
                    FromSalesLineDisc.SetRange(Code, ItemNo);
                    FromSalesLineDisc.SetFilter("Make Code", '%1|%2', '', Vehicle."Make Code");  //20.12.2013 EDMS P8
                    CopySalesDiscToSalesDisc(FromSalesLineDisc, ToSalesLineDisc);

                    if ItemDiscGrCode <> '' then begin
                        FromSalesLineDisc.SetRange(Type, FromSalesLineDisc.Type::"Item Disc. Group");
                        FromSalesLineDisc.SetRange(Code, ItemDiscGrCode);
                        CopySalesDiscToSalesDisc(FromSalesLineDisc, ToSalesLineDisc);
                    end;
                    if Item."Item Category Code" <> '' then begin  //05.12.2013 EDMS P8
                        FromSalesLineDisc.SetRange(Type, FromSalesLineDisc.Type::All);
                        FromSalesLineDisc.SetRange(Code, Item."Item Category Code");
                        CopySalesDiscToSalesDisc(FromSalesLineDisc, ToSalesLineDisc);
                    end;

                    if InclCampaigns then begin
                        InclCampaigns := TempCampaignTargetGr.Next <> 0;
                        FromSalesLineDisc.SetRange("Sales Code", TempCampaignTargetGr."Campaign No.");
                    end;
                until not InclCampaigns;
            end;


        OnAfterFindSalesLineDisc(
          ToSalesLineDisc, CustNo, ContNo, CustDiscGrCode, CampaignNo, ItemNo, ItemDiscGrCode, VariantCode, UOM,
          CurrencyCode, StartingDate, ShowAll);
    end;

    local procedure CopySalesDiscToSalesDisc(var FromSalesLineDisc: Record "Sales Line Discount DMS"; var ToSalesLineDisc: Record "Sales Line Discount DMS")
    begin
        if FromSalesLineDisc.FindSet then
            repeat
                ToSalesLineDisc := FromSalesLineDisc;
                ToSalesLineDisc.Insert;
            until FromSalesLineDisc.Next() = 0;
    end;

    procedure CalcBestLineDisc(var SalesLineDisc: Record "Sales Line Discount DMS")
    var
        BestSalesLineDisc: Record "Sales Line Discount DMS";
        IsHandled: Boolean;
        FoundSalesLineDiscount: Boolean;
    begin
        IsHandled := false;
        OnBeforeCalcBestLineDisc(SalesLineDisc, Item, IsHandled, QtyPerUOM, Qty);
        if IsHandled then
            exit;

        //26.11.2007 EDMS P3 >>
        SalesLineDisc.SetRange("Sales Type", SalesLineDisc."sales type"::Assembly);


        FoundSalesLineDiscount := SalesLineDisc.FindSet;
        if not FoundSalesLineDiscount then begin
            SalesLineDisc.SetRange("Sales Type");
            SalesLineDisc.SetFilter("Vehicle Serial No.", '<>''''');
            FoundSalesLineDiscount := SalesLineDisc.FindSet;
            if not FoundSalesLineDiscount then begin
                SalesLineDisc.SetRange("Vehicle Serial No.");
                FoundSalesLineDiscount := SalesLineDisc.Find('-');
            end
        end;
        //26.11.2007 EDMS P3 <<
        if FoundSalesLineDiscount then
            repeat
                if IsInMinQty(SalesLineDisc."Unit of Measure Code", SalesLineDisc."Minimum Quantity") then
                    case true of
                        ((BestSalesLineDisc."Currency Code" = '') and (SalesLineDisc."Currency Code" <> '')) or
                      ((BestSalesLineDisc."Variant Code" = '') and (SalesLineDisc."Variant Code" <> '')):
                            BestSalesLineDisc := SalesLineDisc;
                        ((BestSalesLineDisc."Currency Code" = '') or (SalesLineDisc."Currency Code" <> '')) and
                      ((BestSalesLineDisc."Variant Code" = '') or (SalesLineDisc."Variant Code" <> '')):
                            if BestSalesLineDisc."Line Discount %" < SalesLineDisc."Line Discount %" then
                                BestSalesLineDisc := SalesLineDisc;
                    end;
            until SalesLineDisc.Next() = 0;

        SalesLineDisc := BestSalesLineDisc;
    end;

    local procedure IsInMinQty(UnitofMeasureCode: Code[10]; MinQty: Decimal): Boolean
    begin
        if UnitofMeasureCode = '' then
            exit(MinQty <= QtyPerUOM * Qty);
        exit(MinQty <= Qty);
    end;

    procedure GetAppltoItemEntryNo(ServiceLine: Record "Service Line EDMS"): Integer
    var
        ResEntryNegative: Record "Reservation Entry";
        ResEntryPositive: Record "Reservation Entry";
    begin
        ResEntryNegative.Reset;
        ResEntryNegative.SetCurrentkey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype");
        ResEntryNegative.SetRange("Source ID", ServiceLine."Document No.");
        ResEntryNegative.SetRange("Source Ref. No.", ServiceLine."Line No.");
        ResEntryNegative.SetRange("Source Type", Database::"Service Line EDMS");
        ResEntryNegative.SetRange("Source Subtype", ServiceLine."Document Type");
        if ResEntryNegative.FindFirst then
            repeat
                if ResEntryPositive.Get(ResEntryNegative."Entry No.", true) then
                    if ResEntryPositive."Source Type" = Database::"Item Ledger Entry" then
                        exit(ResEntryPositive."Source Ref. No.");
            until ResEntryNegative.Next = 0;
        exit(0);
    end;


    procedure CalcSPackageLineDisc(var SalesLineDisc: Record "Sales Line Discount DMS"; var ServLine: Record "Service Line EDMS")
    var
        ServicePackage: Record "Service Package";
        BestSalesLineDisc: Record "Sales Line Discount DMS";
    begin
        //18.01.2012 EDMS P8 >>
        BestSalesLineDisc := SalesLineDisc;
        if ServLine."Package No." <> '' then begin
            if ServicePackage.Get(ServLine."Package No.") then begin
                if ServicePackage."Fixed Prices and Discounts" then begin
                    SalesLineDisc.SetRange("Sales Type", SalesLineDisc."sales type"::SPackage);
                    if SalesLineDisc.FindSet then
                        BestSalesLineDisc := SalesLineDisc;
                end;
            end;
        end;
        SalesLineDisc := BestSalesLineDisc;
        //18.01.2012 EDMS P8 <<
    end;

    local procedure CopyServLaborDiscToSalesDisc(var FromLaborSalesLineDiscount: Record "Labor Sales Line Discount"; var ToSalesLineDisc: Record "Sales Line Discount DMS")
    begin
        if FromLaborSalesLineDiscount.FindSet then
            repeat
                if FromLaborSalesLineDiscount."Line Discount %" <> 0 then begin
                    ToSalesLineDisc.Init;
                    ToSalesLineDisc.Type := FromLaborSalesLineDiscount.Type + 3;  //05.12.2013 EDMS P8
                    ToSalesLineDisc.Code := FromLaborSalesLineDiscount.Code;
                    ToSalesLineDisc."Sales Type" := FromLaborSalesLineDiscount."Sales Type";
                    ToSalesLineDisc."Sales Code" := FromLaborSalesLineDiscount."Sales Code";
                    ToSalesLineDisc."Starting Date" := FromLaborSalesLineDiscount."Starting Date";
                    ToSalesLineDisc."Currency Code" := FromLaborSalesLineDiscount."Currency Code";
                    ToSalesLineDisc."Minimum Quantity" := FromLaborSalesLineDiscount."Minimum Quantity";
                    ToSalesLineDisc."Vehicle Status Code" := FromLaborSalesLineDiscount."Vehicle Status Code";
                    ToSalesLineDisc."Vehicle Serial No." := FromLaborSalesLineDiscount."Vehicle Serial No.";
                    ToSalesLineDisc."Line Discount %" := FromLaborSalesLineDiscount."Line Discount %";
                    ToSalesLineDisc.Insert;
                end;
            until FromLaborSalesLineDiscount.Next = 0;
    end;



    procedure SetCurrency(CurrencyCode2: Code[10]; CurrencyFactor2: Decimal; ExchRateDate2: Date)
    begin
        PricesInCurrency := CurrencyCode2 <> '';
        if PricesInCurrency then begin
            Currency.Get(CurrencyCode2);
            Currency.TestField("Unit-Amount Rounding Precision");
            CurrencyFactor := CurrencyFactor2;
            ExchRateDate := ExchRateDate2;
        end else
            GLSetup.Get();
    end;

    procedure SetUoM(Qty2: Decimal; QtyPerUoM2: Decimal)
    begin
        Qty := Qty2;
        QtyPerUOM := QtyPerUoM2;
    end;

    procedure SetVAT(PriceInclVAT2: Boolean; VATPerCent2: Decimal; VATCalcType2: Option; VATBusPostingGr2: Code[20])
    begin
        PricesInclVAT := PriceInclVAT2;
        VATPerCent := VATPerCent2;
        VATCalcType := VATCalcType2;
        VATBusPostingGr := VATBusPostingGr2;
    end;

    procedure SetLineDisc(LineDiscPerCent2: Decimal; AllowLineDisc2: Boolean; AllowInvDisc2: Boolean)
    begin
        LineDiscPerCent := LineDiscPerCent2;
        AllowLineDisc := AllowLineDisc2;
        AllowInvDisc := AllowInvDisc2;
    end;








    [EventSubscriber(ObjectType::codeunit, Codeunit::"Price Calculation - V16", 'OnAfterCalcBestAmount', '', false, false)]

    local procedure OnAfterCalcBestAmount(AmountType: Enum "Price Amount Type"; var PriceCalculationBufferMgt: Codeunit "Price Calculation Buffer Mgt."; var PriceListLine: Record "Price List Line"; var FoundBestPrice: Boolean)

    Var
        CustomerNo: Code[20];
        CustomerPriceGroup: Code[20];
        CustomerDiscGroup: Code[20];
        Item: Record item;
        LicensePermission: Record "license permission";
        ShowAll: Boolean;
        PriceAssetList: Codeunit "Price Asset List";
        PriceSourceList: Codeunit "Price Source List";
        PriceSource: Record "Price Source";
        Level: array[2] of Integer;
        CurrLevel: Integer;
        PriceCalculation: Interface "Price Calculation";
        PriceSourceType: enum "Price Source Type";
        PriceAssetType: enum "Price Asset Type";
        ResultPriceCalculationBuffer: Record "Price Calculation Buffer";
        VariantCode: Code[10];
        ContractNo: Code[20];
        SalesLine: record "Sales line";
    begin

        PriceCalculationBufferMgt.GetAssets(PriceAssetList);
        PriceCalculationBufferMgt.GetSources(PriceSourceList);
        PriceCalculationBufferMgt.GetBuffer(ResultPriceCalculationBuffer);
        CustomerNo := PriceSourceList.GetValue(PriceSourceType::Customer);
        CustomerPriceGroup := PriceSourceList.GetValue(PriceSourceType::"Customer Price Group");
        CustomerDiscGroup := PriceSourceList.GetValue(PriceSourceType::"Customer Disc. Group");


        //If SalesLine.Get(ResultPriceCalculationBuffer."Document Type", ResultPriceCalculationBuffer."Document No.", ResultPriceCalculationBuffer."Line No.") then begin

        //CustomerPriceGroup := salesline."Customer Price Group";
        if Item.get(ResultPriceCalculationBuffer."asset no.") then Begin
            //Item.get(PriceListLine."Asset No.");
            // Ramzi
            if AmountType = AmountType::Price then Begin
                if Item."Item Type" <> Item."item type"::"Model Version" then begin

                    //20.03.2013 EDMS >>
                    FindMarkupPrice(TempSalesPrice, CustomerNo, '',
                      CustomerPriceGroup, '', PriceListLine."Asset No.", ResultPriceCalculationBuffer."Document Date",
                      ShowAll, 0);

                    //11.10.2013 EDMS P8


                    ContractNo := ResultPriceCalculationBuffer."Contract No.";
                    IF ContractNo <> '' then
                        FindContractSalesPrice(
                                              TempSalesPrice, CustomerNo, ResultPriceCalculationBuffer."Asset No.", VariantCode, ResultPriceCalculationBuffer."Currency Code",
                                              ResultPriceCalculationBuffer."Document Date", ShowAll,
                                              ResultPriceCalculationBuffer."Location Code", ResultPriceCalculationBuffer."Ordering Price Type Code", ResultPriceCalculationBuffer."Document Profile", '', ContractNo);

                    CopySalesPriceToPriceListPrice(TempSalesPrice, PriceListLine, FoundBestPrice);
                end else begin

                    LicensePermission.SetRange("Object Type", LicensePermission."object type"::Codeunit);
                    LicensePermission.SetRange("Object Number", Codeunit::VehicleSalesPriceDiscountMgt);
                    LicensePermission.SetFilter("Execute Permission", '<>%1', LicensePermission."execute permission"::" ");
                    if not LicensePermission.IsEmpty then
                        If SalesLine.Get(ResultPriceCalculationBuffer."Document Type", ResultPriceCalculationBuffer."Document No.", ResultPriceCalculationBuffer."Line No.") then
                            if VehPriceCalcMgt.ChkAssemblyHdrSalesLine(SalesLine, ShowAll) then Begin
                                FindVehPrice(
                                 TempSalesPrice, CustomerNo, '',
                                 CustomerPriceGroup, '', item."no.", ResultPriceCalculationBuffer."Currency Code",
                                 ResultPriceCalculationBuffer."Document Date", ShowAll, ResultPriceCalculationBuffer."Location Code",
                                 ResultPriceCalculationBuffer."Ordering Price Type Code", ResultPriceCalculationBuffer."Document Profile", ResultPriceCalculationBuffer."Vehicle Serial No.", SalesLine."Vehicle Assembly ID");
                                //CopySalesPriceToPriceListPrice(TempSalesPrice, PriceListLine);
                                if TempSalesPrice."Unit Price" <> 0 then
                                    PriceListLine."Unit Price" := TempSalesPrice."Unit Price";
                            End;
                end;
            end
            Else
                if AmountType = AmountType::Discount then Begin
                    if Item."Item Type" <> Item."item type"::"Model Version" then begin
                        Vehicle.Init;  //20.12.2013 EDMS P8

                        FindSalesLineDisc(
                    TempSalesLineDisc, CustomerNo, '',
                          CustomerDiscGroup, '', ResultPriceCalculationBuffer."asset no.", Item."Item Disc. Group", SalesLine."Variant Code", ResultPriceCalculationBuffer."Unit of Measure Code",
                      ResultPriceCalculationBuffer."Currency Code", ResultPriceCalculationBuffer."Document Date", ShowAll,
                     ResultPriceCalculationBuffer."Document Profile");   //20.03.2013 EDMS


                        //20.03.2013 EDMS >>
                        FindSPContrLineDisc(
                            TempSalesLineDisc, CustomerNo, 1, ResultPriceCalculationBuffer."asset no."
                            , ResultPriceCalculationBuffer."Document Profile", ResultPriceCalculationBuffer."Vehicle Serial No.", ResultPriceCalculationBuffer."Unit of Measure Code",
                            ResultPriceCalculationBuffer."Make Code");

                        // 16.04.2014 Elva Baltic P21 >>
                        ContractNo := ResultPriceCalculationBuffer."Contract No.";
                        FindContractSalesDisc2(TempSalesLineDisc, ContractNo, Item."Item Category Code",
                          ResultPriceCalculationBuffer."Document Date", ResultPriceCalculationBuffer."Currency Code", ResultPriceCalculationBuffer."Location Code", ShowAll);
                        // 16.04.2014 Elva Baltic P21 <<

                        /// Find Discount Per Item Category
                        // 
                        FindCategoryDiscount(PriceListLine, ResultPriceCalculationBuffer, CustomerNo, CustomerDiscGroup, FoundBestPrice);
                        //
                        CopySalesDiscountToPriceListPrice(TempSalesLineDisc, PriceListLine, FoundBestPrice);
                    End
                    else begin
                        LicensePermission.SetRange("Object Type", LicensePermission."object type"::Codeunit);
                        LicensePermission.SetRange("Object Number", Codeunit::VehicleSalesPriceDiscountMgt);
                        LicensePermission.SetFilter("Execute Permission", '<>%1', LicensePermission."execute permission"::" ");
                        if not LicensePermission.IsEmpty then
                            If SalesLine.Get(ResultPriceCalculationBuffer."Document Type", ResultPriceCalculationBuffer."Document No.", ResultPriceCalculationBuffer."Line No.") then
                                if VehPriceCalcMgt.ChkAssemblyHdrSalesLine(SalesLine, ShowAll) then
                                    FindVehDisc(
                                      TempSalesLineDisc, CustomerNo, '',
                                      SalesLine."Customer Disc. Group", '', ResultPriceCalculationBuffer."asset no.", Item."Item Disc. Group", ResultPriceCalculationBuffer."Currency Code",
                                      ResultPriceCalculationBuffer."Document Date",
                                      ShowAll, ResultPriceCalculationBuffer."Document Profile", ResultPriceCalculationBuffer."Vehicle Serial No.", SalesLine."Vehicle Assembly ID");
                        if TempSalesLineDisc."Line Discount %" <> 0 then
                            PriceListLine."Line Discount %" := TempSalesLineDisc."Line Discount %";

                    end;

                End;
        end;
        //end;
    end;

    Procedure FindCategoryDiscount(var PriceListLine: Record "Price List Line"; ResultPriceCalculationBuffer: Record "Price Calculation Buffer"; CustNo: Code[20]; CustDiscGrCode: Code[20]; FoundBestPrice: boolean)
    Var
        PriceListLine2: Record "Price List Line";
        PriceListLine3: Record "Price List Line";
    Begin
        //Ramzi
        PriceListLine2.Setrange(Status, PriceListLine2.status::active);
        PriceListLine2.Setrange("Asset no.", '');
        PriceListLine2.SetFilter("Ending Date", '%1|>=%2', 0D, ResultPriceCalculationBuffer."document Date");
        PriceListLine2.SetFilter("Document Profile", '%1|%2', ResultPriceCalculationBuffer."document Profile", 0);
        PriceListLine2.SetRange("Starting Date", 0D, ResultPriceCalculationBuffer."document Date");
        PriceListLine2.SetFilter("Currency Code", '%1|%2', ResultPriceCalculationBuffer."Currency Code", '');
        PriceListLine2.setrange("item category code", ResultPriceCalculationBuffer."item category code");
        IF PriceListLine2.Findfirst then
            Repeat
                IF PriceListLine2."Source Type" = PriceListLine2."Source Type"::"All Customers" then
                    IF PriceListLine2."Line Discount %" > PriceListLine."Line Discount %" then Begin
                        PriceListLine."Line Discount %" := PriceListLine2."Line Discount %";
                        FoundBestPrice := true;
                    End;
                IF PriceListLine2."Source Type" = PriceListLine2."Source Type"::"Customer" then
                    IF PriceListLine2."Source No." = Custno then
                        IF PriceListLine2."Line Discount %" > PriceListLine."Line Discount %" then Begin
                            PriceListLine."Line Discount %" := PriceListLine2."Line Discount %";
                            FoundBestPrice := true;
                        End;
                IF PriceListLine2."Source Type" = PriceListLine2."Source Type"::"Customer Disc. Group" then
                    IF PriceListLine2."Source No." = CustDiscGrCode then
                        IF PriceListLine2."Line Discount %" > PriceListLine."Line Discount %" then Begin
                            PriceListLine."Line Discount %" := PriceListLine2."Line Discount %";
                            FoundBestPrice := true;
                        End;

            until PriceListLine2.Next = 0;

    end;

    [EventSubscriber(ObjectType::codeunit, Codeunit::"Price Asset - Item", 'OnAfterFillBestLine', '', false, false)]
    local procedure OnAfterFillBestLine(PriceCalculationBuffer: Record "Price Calculation Buffer"; AmountType: Enum "Price Amount Type"; var PriceListLine: Record "Price List Line")
    var
        Customer: Record Customer;
        PriceCalculation: Interface "Price Calculation";
        PriceSourceType: enum "Price Source Type";
        PriceAssetType: enum "Price Asset Type";
        CustomerPriceGroup: Code[20];
        CustomerDiscGroup: Code[20];
        VariantCode: Code[10];
        ContractNo: Code[20];
        CustomerNo: Code[20];
        ShowAll: Boolean;
        SalesLine: record "Sales line";
        FoundBestPrice: boolean;
    Begin
        CustomerNo := PriceCalculationBuffer."Bill-to Customer No.";
        ContractNo := PriceCalculationBuffer."Contract No.";
        IF Customer.get(CustomerNo) then Begin
            CustomerPriceGroup := Customer."Customer Price Group";
            CustomerDiscGroup := Customer."Customer Disc. Group";
        End;
        //If SalesLine.Get(PriceCalculationBuffer."Document Type", PriceCalculationBuffer."Document No.", PriceCalculationBuffer."Line No.") then begin

        //CustomerPriceGroup := salesline."Customer Price Group";
        if Item.get(PriceCalculationBuffer."asset no.") then Begin

            // Ramzi
            if AmountType = AmountType::Price then Begin
                if Item."Item Type" <> Item."item type"::"Model Version" then begin

                    IF CustomerNo <> '' then
                        FindMarkupPrice(TempSalesPrice, CustomerNo, '',
                          CustomerPriceGroup, '', PriceCalculationBuffer."Asset No.", PriceCalculationBuffer."Document Date",
                          ShowAll, 0);

                    IF ContractNo <> '' then Begin
                        //ContractHeader.Get(ContractNo);
                        //CustomerNo := ContractHeader."Bill-to Customer No.";
                        FindContractSalesPrice(
                                              TempSalesPrice, CustomerNo, PriceCalculationBuffer."Asset No.", VariantCode, PriceCalculationBuffer."Currency Code",
                                              PriceCalculationBuffer."Document Date", ShowAll,
                                              PriceCalculationBuffer."Location Code", PriceCalculationBuffer."Ordering Price Type Code", PriceCalculationBuffer."Document Profile", '', ContractNo);
                    End;
                    CopySalesPriceToPriceListPrice(TempSalesPrice, PriceListLine, FoundBestPrice);
                end
                else begin
                    LicensePermission.SetRange("Object Type", LicensePermission."object type"::Codeunit);
                    LicensePermission.SetRange("Object Number", Codeunit::VehicleSalesPriceDiscountMgt);
                    LicensePermission.SetFilter("Execute Permission", '<>%1', LicensePermission."execute permission"::" ");
                    if not LicensePermission.IsEmpty then
                        If SalesLine.Get(PriceCalculationBuffer."Document Type", PriceCalculationBuffer."Document No.", PriceCalculationBuffer."Line No.") then
                            if VehPriceCalcMgt.ChkAssemblyHdrSalesLine(SalesLine, ShowAll) then Begin
                                FindVehPrice(
                                 TempSalesPrice, CustomerNo, '',
                                 CustomerPriceGroup, '', item."no.", PriceCalculationBuffer."Currency Code",
                                 PriceCalculationBuffer."Document Date", ShowAll, PriceCalculationBuffer."Location Code",
                                 PriceCalculationBuffer."Ordering Price Type Code", PriceCalculationBuffer."Document Profile", PriceCalculationBuffer."Vehicle Serial No.", SalesLine."Vehicle Assembly ID");
                                CopySalesPriceToPriceListPrice(TempSalesPrice, PriceListLine, FoundBestPrice);
                                if TempSalesPrice."Unit Price" <> 0 then
                                    PriceListLine."Unit Price" := TempSalesPrice."Unit Price";

                            end;
                end
            end
            Else
                if AmountType = AmountType::Discount then Begin
                    if Item."Item Type" <> Item."item type"::"Model Version" then begin
                        Vehicle.Init;  //20.12.2013 EDMS P8

                        FindSalesLineDisc(
                    TempSalesLineDisc, CustomerNo, '',
                          CustomerDiscGroup, '', PriceCalculationBuffer."Asset No.", Item."Item Disc. Group", PriceCalculationBuffer."Variant Code", PriceCalculationBuffer."Unit of Measure Code",
                      PriceCalculationBuffer."Currency Code", PriceCalculationBuffer."Document Date", ShowAll,
                     PriceCalculationBuffer."Document Profile");   //20.03.2013 EDMS


                        //20.03.2013 EDMS >>
                        FindSPContrLineDisc(
                            TempSalesLineDisc, CustomerNo, 1, PriceCalculationBuffer."Asset No."
                            , PriceCalculationBuffer."Document Profile", PriceCalculationBuffer."Vehicle Serial No.", PriceCalculationBuffer."Unit of Measure Code",
                            PriceCalculationBuffer."Make Code");

                        // 16.04.2014 Elva Baltic P21 >>
                        ContractNo := PriceCalculationBuffer."Contract No.";
                        FindContractSalesDisc2(TempSalesLineDisc, ContractNo, Item."Item Category Code",
                          PriceCalculationBuffer."Document Date", PriceCalculationBuffer."Currency Code", PriceCalculationBuffer."Location Code", ShowAll);
                        // 16.04.2014 Elva Baltic P21 <<

                        /// Find Discount Per Item Category
                        FindCategoryDiscount(PriceListLine, PriceCalculationBuffer, CustomerNo, CustomerDiscGroup, FoundBestPrice);
                        CopySalesDiscountToPriceListPrice(TempSalesLineDisc, PriceListLine, FoundBestPrice);
                    End
                    else begin
                        LicensePermission.SetRange("Object Type", LicensePermission."object type"::Codeunit);
                        LicensePermission.SetRange("Object Number", Codeunit::VehicleSalesPriceDiscountMgt);
                        LicensePermission.SetFilter("Execute Permission", '<>%1', LicensePermission."execute permission"::" ");
                        if not LicensePermission.IsEmpty then
                            If SalesLine.Get(PriceCalculationBuffer."Document Type", PriceCalculationBuffer."Document No.", PriceCalculationBuffer."Line No.") then
                                if VehPriceCalcMgt.ChkAssemblyHdrSalesLine(SalesLine, ShowAll) then
                                    FindVehDisc(
                                      TempSalesLineDisc, CustomerNo, '',
                                      CustomerDiscGroup, '', PriceCalculationBuffer."Asset No.", Item."Item Disc. Group", PriceCalculationBuffer."Currency Code",
                                      PriceCalculationBuffer."Document Date",
                                      ShowAll, PriceCalculationBuffer."Document Profile", PriceCalculationBuffer."Vehicle Serial No.", SalesLine."Vehicle Assembly ID");
                        if TempSalesLineDisc."Line Discount %" <> 0 then
                            PriceListLine."Line Discount %" := TempSalesLineDisc."Line Discount %";
                    end;
                end;
        End;
        //end;
    end;

    local procedure CopySalesPriceToPriceListPrice(var FromSalesPrice: Record "Sales Price DMS"; var PriceListLine: Record "Price List Line"; var FoundBestPrice: Boolean)
    Var
    begin
        if FromSalesPrice.FindSet then
            repeat
                if FromSalesPrice."Unit Price" <> 0 then begin
                    //>>DELTA MGR
                    if FromSalesPrice."Currency Code" <> '' then
                        PriceListLine."Currency Code" := FromSalesPrice."Currency Code";
                    //<<DELTA MGR
                    IF FromSalesPrice."Unit Price" < PriceListLine."Unit Price" then Begin
                        PriceListLine."Unit Price" := FromSalesPrice."Unit Price";
                        FoundBestPrice := true;
                    end;
                end;
            until FromSalesPrice.Next = 0;
    end;

    local procedure CopySalesDiscountToPriceListPrice(var FromSalesDiscount: Record "Sales Line Discount DMS"; var PriceListLine: Record "Price List Line"; var FoundBestPrice: Boolean)
    Var
    begin
        if FromSalesDiscount.FindSet then
            repeat
                if FromSalesDiscount."Line Discount %" > 0 then begin
                    IF FromSalesDiscount."Line Discount %" > PriceListLine."Line Discount %" then Begin
                        PriceListLine."Line Discount %" := FromSalesDiscount."Line Discount %";
                        FoundBestPrice := true;
                    End;
                end;
            until FromSalesDiscount.Next = 0;
    end;


    procedure FindVehPrice(var ToSalesPrice: Record "Sales Price DMS"; CustNo: Code[20]; ContNo: Code[20]; CustPriceGrCode: Code[10]; CampaignNo: Code[20]; ItemNo: Code[20]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean; LocationCode: Code[10]; OrderingPriceType: Code[10]; DocumentProfile: Integer; VehSerialNo: Code[20]; AssemblyID: Code[20])
    begin
        if (AssemblyID <> '') and (VehSerialNo <> '') then
            VehPriceCalcMgt.FindVehicleSalesPriceAW(ToSalesPrice, VehSerialNo,
              AssemblyID, ItemNo)
        else
            VehPriceCalcMgt.FindVehiclePrice(
              ToSalesPrice, CustNo, ContNo,
              CustPriceGrCode, CampaignNo, ItemNo,
              CurrencyCode, StartingDate, ShowAll, LocationCode,
              OrderingPriceType, DocumentProfile, VehSerialNo)
    end;

    procedure FindVehDisc(var ToSalesLineDisc: Record "Sales Line Discount DMS"; CustNo: Code[20]; ContNo: Code[20]; CustDiscGrCode: Code[20]; CampaignNo: Code[20]; ItemNo: Code[20]; ItemDiscGrCode: Code[20]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean; DocumentProfile: Integer; VehSerialNo: Code[20]; AssemblyID: Code[20])
    var
        codNo: Code[20];
        intType: Integer;
        recItem: Record Item;
        decDiscountPercent: Decimal;
        recSalesLine: Record "Sales Line";
        recVehAssembly: Record "Vehicle Assembly Line";
    begin
        ToSalesLineDisc.Reset;
        ToSalesLineDisc.DeleteAll;

        if (AssemblyID <> '') and (VehSerialNo <> '') then
            VehPriceCalcMgt.FindVehicleLineDiscountAW(ToSalesLineDisc, VehSerialNo,
              AssemblyID, ItemNo)
        else
            VehPriceCalcMgt.FindVehicleDiscount(
              ToSalesLineDisc, CustNo, ContNo,
              CustDiscGrCode, CampaignNo, ItemNo, ItemDiscGrCode,
              CurrencyCode, StartingDate, ShowAll, VehSerialNo)
    end;

    procedure GetVariableValue(Vehicle: Record Vehicle; "Field": Text[30]) Fieldvalue: Text[30]
    var
        RecordRef: RecordRef;
        FieldRef: FieldRef;
        VariableFieldUsage: Record "Variable Field Usage";
    begin
        Fieldvalue := '';

        if Field = '' then
            exit;

        RecordRef.Open(Database::Vehicle);
        RecordRef.GetTable(Vehicle);
        VariableFieldUsage.Reset;
        VariableFieldUsage.SetCurrentkey("Variable Field Code");
        VariableFieldUsage.SetRange("Table No.", Database::Vehicle);
        VariableFieldUsage.SetRange("Variable Field Code", Field);

        if VariableFieldUsage.FindFirst then begin
            FieldRef := RecordRef.Field(VariableFieldUsage."Field No.");
            Fieldvalue := FieldRef.Value;
        end;
        RecordRef.SetTable(Vehicle);
    end;

    procedure SalesHeaderStartDate(var SalesHeader: Record "Sales Header"; var DateCaption: Text[30]): Date
    var
        StartDate: Date;

    begin
        if SalesHeader."Document Type" in [SalesHeader."Document Type"::Invoice, SalesHeader."Document Type"::"Credit Memo"] then begin
            DateCaption := SalesHeader.FieldCaption("Posting Date");
            exit(SalesHeader."Posting Date")
        end else begin
            DateCaption := SalesHeader.FieldCaption("Order Date");
            exit(SalesHeader."Order Date");
        end;
    end;

    local procedure ServiceHeaderExchDate(ServiceHeader: Record "Service Header EDMS"): Date
    begin
        if (ServiceHeader."Document Type" in [ServiceHeader."document type"::Quote]) and
   (ServiceHeader."Posting Date" = 0D)
then
            exit(WorkDate);
        exit(ServiceHeader."Posting Date");
    end;

    procedure GetDMSServLinePrice(ServiceHeader: Record "Service Header EDMS"; var ServiceLine: Record "Service Line EDMS")
    begin
        DMSServLinePriceExists(ServiceHeader, ServiceLine, true);

        if ServiceLine.Type = ServiceLine.Type::Labor then begin
            if Page.RunModal(Page::"Get Service Price", TempServicePrice) = Action::LookupOK then begin
                SetVAT(
                  ServiceHeader."Prices Including VAT", ServiceLine."VAT %", ServiceLine."VAT Calculation Type", ServiceLine."VAT Bus. Posting Group");
                SetUoM(Abs(ServiceLine.Quantity), ServiceLine."Qty. per Unit of Measure");
                SetCurrency(
                  ServiceHeader."Currency Code", ServiceHeader."Currency Factor", ServiceHeaderExchDate(ServiceHeader));

                if not (TempServicePrice."Currency Code" in [ServiceLine."Currency Code", '']) then
                    Error(
                      Text001,
                      ServiceLine.FieldCaption("Currency Code"),
                      ServiceLine.TableCaption,
                      TempServicePrice.TableCaption);
                if not (TempServicePrice."Unit of Measure Code" in [ServiceLine."Unit of Measure Code", '']) then
                    Error(
                      Text001,
                      ServiceLine.FieldCaption("Unit of Measure Code"),
                      ServiceLine.TableCaption,
                      TempServicePrice.TableCaption);
                if TempServicePrice."Starting Date" > ServiceHeaderStartDate(ServiceHeader, DateCaption) then
                    Error(
                      Text000,
                      DateCaption,
                      TempServicePrice.FieldCaption("Starting Date"),
                      TempServicePrice.TableCaption);

                ConvertPriceToVAT(
                  TempServicePrice."Price Includes VAT", Item."VAT Prod. Posting Group",
                  TempServicePrice."VAT Bus. Posting Gr. (Price)", TempServicePrice.Price);
                ConvertPriceToUoM(ServiceLine."Unit of Measure Code", TempServicePrice.Price);
                ConvertPriceLCYToFCY(TempServicePrice."Currency Code", TempServicePrice.Price);

                ServiceLine."Allow Invoice Disc." := TempServicePrice."Allow Invoice Disc.";
                ServiceLine."Allow Line Disc." := TempServicePrice."Allow Line Disc.";
                if not ServiceLine."Allow Line Disc." then
                    ServiceLine."Line Discount %" := 0;

                ServiceLine.Validate("Unit Price", TempServicePrice.Price);
            end;
        end else begin
            if Page.RunModal(Page::"Get Sales Price DMS", TempSalesPrice) = Action::LookupOK then begin
                SetVAT(
                  ServiceHeader."Prices Including VAT", ServiceLine."VAT %", ServiceLine."VAT Calculation Type", ServiceLine."VAT Bus. Posting Group");
                SetUoM(Abs(ServiceLine.Quantity), ServiceLine."Qty. per Unit of Measure");
                SetCurrency(
                  ServiceHeader."Currency Code", ServiceHeader."Currency Factor", ServiceHeaderExchDate(ServiceHeader));

                if not IsInMinQty(TempSalesPrice."Unit of Measure Code", TempSalesPrice."Minimum Quantity") then
                    Error(
                      Text000,
                      ServiceLine.FieldCaption(Quantity),
                      TempSalesPrice.FieldCaption("Minimum Quantity"),
                      TempSalesPrice.TableCaption);
                if not (TempSalesPrice."Currency Code" in [ServiceLine."Currency Code", '']) then
                    Error(
                      Text001,
                      ServiceLine.FieldCaption("Currency Code"),
                      ServiceLine.TableCaption,
                      TempSalesPrice.TableCaption);
                if not (TempSalesPrice."Unit of Measure Code" in [ServiceLine."Unit of Measure Code", '']) then
                    Error(
                      Text001,
                      ServiceLine.FieldCaption("Unit of Measure Code"),
                      ServiceLine.TableCaption,
                      TempSalesPrice.TableCaption);
                if TempSalesPrice."Starting Date" > ServiceHeaderStartDate(ServiceHeader, DateCaption) then
                    Error(
                      Text000,
                      DateCaption,
                      TempSalesPrice.FieldCaption("Starting Date"),
                      TempSalesPrice.TableCaption);

                ConvertPriceToVAT(
                  TempSalesPrice."Price Includes VAT", Item."VAT Prod. Posting Group",
                  TempSalesPrice."VAT Bus. Posting Gr. (Price)", TempSalesPrice."Unit Price");
                ConvertPriceToUoM(ServiceLine."Unit of Measure Code", TempSalesPrice."Unit Price");
                ConvertPriceLCYToFCY(TempSalesPrice."Currency Code", TempSalesPrice."Unit Price");

                ServiceLine."Allow Invoice Disc." := TempSalesPrice."Allow Invoice Disc.";
                ServiceLine."Allow Line Disc." := TempSalesPrice."Allow Line Disc.";
                if not ServiceLine."Allow Line Disc." then
                    ServiceLine."Line Discount %" := 0;

                ServiceLine.Validate("Unit Price", TempSalesPrice."Unit Price");
            end;
        end;
    end;

    procedure GetDMSServLineLineDisc(ServiceHeader: Record "Service Header EDMS"; var ServiceLine: Record "Service Line EDMS")
    begin
        DMSServLineLineDiscExists(ServiceHeader, ServiceLine, true);

        if ServiceLine.Type = ServiceLine.Type::Labor then begin
            if Page.RunModal(Page::"Get Service Disc.", TempServiceLineDiscount) = Action::LookupOK then begin
                SetCurrency(ServiceHeader."Currency Code", 0, 0D);
                SetUoM(Abs(ServiceLine.Quantity), ServiceLine."Qty. per Unit of Measure");

                if not (TempServiceLineDiscount."Currency Code" in [ServiceLine."Currency Code", '']) then
                    Error(
                      Text001,
                      ServiceLine.FieldCaption("Currency Code"),
                      ServiceLine.TableCaption,
                      TempServiceLineDiscount.TableCaption);
                if TempSalesLineDisc."Starting Date" > ServiceHeaderStartDate(ServiceHeader, DateCaption) then
                    Error(
                      Text000,
                      DateCaption,
                      TempSalesLineDisc.FieldCaption("Starting Date"),
                      TempSalesLineDisc.TableCaption);

                if TempSalesLineDisc."Sales Type" = TempSalesLineDisc."sales type"::Campaign then
                    ServiceLine."Campaign No." := TempSalesLineDisc."Sales Code";

                ServiceLine.TestField("Allow Line Disc.");
                ServiceLine.Validate("Line Discount %", TempSalesLineDisc."Line Discount %");
            end;
        end else begin
            if Page.RunModal(Page::"Get Sales Line Disc. DMS", TempSalesLineDisc) = Action::LookupOK then begin
                SetCurrency(ServiceHeader."Currency Code", 0, 0D);
                SetUoM(Abs(ServiceLine.Quantity), ServiceLine."Qty. per Unit of Measure");

                if not IsInMinQty(TempSalesLineDisc."Unit of Measure Code", TempSalesLineDisc."Minimum Quantity")
                then
                    Error(
                      Text000, ServiceLine.FieldCaption(Quantity),
                      TempSalesLineDisc.FieldCaption("Minimum Quantity"),
                      TempSalesLineDisc.TableCaption);
                if not (TempSalesLineDisc."Currency Code" in [ServiceLine."Currency Code", '']) then
                    Error(
                      Text001,
                      ServiceLine.FieldCaption("Currency Code"),
                      ServiceLine.TableCaption,
                      TempSalesLineDisc.TableCaption);
                if not (TempSalesLineDisc."Unit of Measure Code" in [ServiceLine."Unit of Measure Code", '']) then
                    Error(
                      Text001,
                      ServiceLine.FieldCaption("Unit of Measure Code"),
                      ServiceLine.TableCaption,
                      TempSalesLineDisc.TableCaption);
                if TempSalesLineDisc."Starting Date" > ServiceHeaderStartDate(ServiceHeader, DateCaption) then
                    Error(
                      Text000,
                      DateCaption,
                      TempSalesLineDisc.FieldCaption("Starting Date"),
                      TempSalesLineDisc.TableCaption);

                if TempSalesLineDisc."Sales Type" = TempSalesLineDisc."sales type"::Campaign then
                    ServiceLine."Campaign No." := TempSalesLineDisc."Sales Code";

                ServiceLine.TestField("Allow Line Disc.");
                ServiceLine.Validate("Line Discount %", TempSalesLineDisc."Line Discount %");
            end;
        end;
    end;

    procedure GetRentSalesLinePrice(RentHeader: Record "Rent Header"; var RentSalesLine: Record "Rent Sales Line")
    begin
        RentSalesLinePriceExists(RentHeader, RentSalesLine, true);
        Page.RunModal(Page::"Get Sales Price DMS", TempSalesPrice);
    end;

    procedure GetRentSalesLineLineDisc(RentHeader: Record "Rent Header"; var RentSalesLine: Record "Rent Sales Line")
    begin
        RentSalesLineLineDiscExists(RentHeader, RentSalesLine, true);
        Page.RunModal(Page::"Get Sales Line Disc. DMS", TempSalesLineDisc);
    end;

    procedure FindDMSSPLinePrice(SPackage: Record "Service Package"; var SPVersionSpec: Record "Service Package Version Line"; CalledByFieldNo: Integer)
    begin
        SalesSetup.Get;
        if (SalesSetup."Def.S.Price VAT Bus.Post.Grp." <> '') and (SalesSetup."Def.S.Price VAT Prod.Post.Grp." <> '') then
            VATPostSetup.Get(SalesSetup."Def.S.Price VAT Bus.Post.Grp.", SalesSetup."Def.S.Price VAT Prod.Post.Grp.");

        SetCurrency(SPackage."Currency Code", SPackage."Currency Factor", WorkDate);

        SetVAT(SPackage."Prices Including VAT", VATPostSetup."VAT %", VATPostSetup."VAT Calculation Type",
          SalesSetup."Def.S.Price VAT Bus.Post.Grp.");

        SetUoM(Abs(SPVersionSpec.Quantity), SPVersionSpec."Qty. per Unit of Measure");
        SetLineDisc(SPVersionSpec."Discount %", SPVersionSpec."Allow Line Disc.", SPVersionSpec."Allow Invoice Disc.");

        SPVersionSpec.TestField("Qty. per Unit of Measure");
        if PricesInCurrency then
            SPackage.TestField("Currency Factor");

        TempServicePrice.Reset; //22.12.2016 EB.P7
        TempServicePrice.DeleteAll; //22.12.2016 EB.P7
        TempSalesPrice.Reset;                                                           // 08.12.2015 EB.P30
        TempSalesPrice.DeleteAll;                                                       // 08.12.2015 EB.P30
        DMSSPLinePriceExists(SPackage, SPVersionSpec, false);                             // 25.01.2016 EB.P30
        CopyServicePriceToSalesPrice(TempServicePrice, TempSalesPrice);                 // 08.12.2015 EB.P30
        CalcBestUnitPrice(TempSalesPrice);

        if FoundSalesPrice or
           not (CalledByFieldNo = SPVersionSpec.FieldNo(Quantity))
            then begin
            SPVersionSpec."Allow Line Disc." := TempSalesPrice."Allow Line Disc.";
            SPVersionSpec."Allow Invoice Disc." := TempSalesPrice."Allow Invoice Disc.";
            SPVersionSpec."Unit Price" := TempSalesPrice."Unit Price";
        end;
        if not SPVersionSpec."Allow Line Disc." then
            SPVersionSpec."Discount %" := 0;
    end;

    procedure FindDMSSPLineLineDisc(SPackage: Record "Service Package"; var SPVersionSpec: Record "Service Package Version Line")
    begin
        SetCurrency(SPackage."Currency Code", 0, 0D);
        SetUoM(Abs(SPVersionSpec.Quantity), SPVersionSpec."Qty. per Unit of Measure");

        SPVersionSpec.TestField("Qty. per Unit of Measure");
        case SPVersionSpec.Type of
            SPVersionSpec.Type::Item, SPVersionSpec.Type::Labor:
                begin
                    DMSSPLineLineDiscExists(SPackage, SPVersionSpec, false);
                    CalcBestLineDisc(TempSalesLineDisc);

                    SPVersionSpec."Discount %" := TempSalesLineDisc."Line Discount %";
                end;
        end
    end;

    procedure DMSSPLineLineDiscExists(SPackage: Record "Service Package"; var SPVersionSpec: Record "Service Package Version Line"; ShowAll: Boolean): Boolean
    begin
        case SPVersionSpec.Type of
            SPVersionSpec.Type::Item:
                if Item.Get(SPVersionSpec."No.") then begin
                    Vehicle.Init;  //20.12.2013 EDMS P8
                    Vehicle."Make Code" := SPackage."Make Code";
                    FindSalesLineDisc(TempSalesLineDisc, '', '', '', '', SPVersionSpec."No.",
                      Item."Item Disc. Group", '', SPVersionSpec."Unit of Measure Code",
                      SPackage."Currency Code", WorkDate, ShowAll, 3);
                    FindSPContrLineDisc(
                      TempSalesLineDisc, '', 1, SPVersionSpec."No.",
                      3, '', SPVersionSpec."Unit of Measure Code", SPVersionSpec."Make Code");
                    exit(TempSalesLineDisc.Find('-'));
                end;
            SPVersionSpec.Type::Labor:
                if ServLabor.Get(SPVersionSpec."No.") then begin
                    FindSPContrLineDisc(
                      TempSalesLineDisc, '', 2, SPVersionSpec."No.",
                      3, '', SPVersionSpec."Unit of Measure Code", SPVersionSpec."Make Code");
                    exit(TempSalesLineDisc.Find('-'));
                end
        end;
        exit(false);
    end;


    procedure NonstockSalesPriceToItem(var recNonstockSalesPrice: Record "Nonstock Item Price"; var xrecNonstockSalesPrice: Record "Nonstock Item Price"; intActivity: Integer)
    var
        recItem: Record Item;
        recNonstockItem: Record "Nonstock Item";
        recSalesPrice: Record "Price List Line";
        PriceListHeader: record "Price List Header";
        LineNo: Integer;
    begin
        SalesSetup.get;
        /*intActivity:
         0 - insert
         1 - modify
         2 - rename
         3 - delete
        */
        if not recNonstockItem.Get(recNonstockSalesPrice."Nonstock Item Entry No.") then
            exit;
        if recNonstockItem."Item No." = '' then
            exit;
        if not recItem.Get(recNonstockItem."Item No.") then
            exit;


        //  recNonstockItem.TESTFIELD("Item No.",recNonstockItem."Entry No.");
        SalesSetup.TestField("Non Stock Item Price List Code");
        PriceListHeader.get(SalesSetup."Non Stock Item Price List Code");

        recSalesPrice.Setrange("Price List Code", PriceListHeader.Code);
        IF recSalesPrice.FindLast() then
            LineNo := recSalesPrice."Line No." + 1000
        else
            LineNo := 1000;


        case intActivity of
            0: //Insert
                begin

                    recSalesPrice.Reset;
                    recSalesPrice.SetRange("Price List Code", recNonstockSalesPrice."Price List Code");
                    recSalesPrice.SetRange("Line No.", recNonstockSalesPrice."Price List Line No.");
                    if recSalesPrice.FindFirst then
                        recSalesPrice.Delete;


                    recSalesPrice.Init;
                    recSalesPrice."Price List Code" := PriceListHeader.Code;
                    recSalesPrice."Line No." := LineNo;
                    Case recNonstockSalesPrice."Sales Type" of
                        recNonstockSalesPrice."Sales Type"::"All Customers":
                            recSalesPrice."Source Type" := recSalesPrice."Source Type"::"All Customers";
                        recNonstockSalesPrice."Sales Type"::"Customer":
                            recSalesPrice."Source Type" := recSalesPrice."Source Type"::"Customer";
                        recNonstockSalesPrice."Sales Type"::"Customer Price Group":
                            recSalesPrice."Source Type" := recSalesPrice."Source Type"::"Customer Price Group"
                    End;
                    IF recSalesPrice."Source Type" <> recSalesPrice."Source Type"::"All Customers" then
                        recSalesPrice."Source No." := recNonstockSalesPrice."Sales Code";
                    recSalesPrice."Asset Type" := recSalesPrice."Asset Type"::Item;
                    recSalesPrice.Validate("Asset No.", recItem."No.");
                    recSalesPrice."Starting Date" := recNonstockSalesPrice."Starting Date";
                    recSalesPrice."Currency Code" := recNonstockSalesPrice."Currency Code";
                    recSalesPrice."Unit of Measure Code" := recNonstockSalesPrice."Unit of Measure Code";
                    recSalesPrice."Minimum Quantity" := recNonstockSalesPrice."Minimum Quantity";
                    //recSalesPrice."Location Code" := recNonstockSalesPrice."Location Code";
                    recSalesPrice."Unit Price" := recNonstockSalesPrice."Unit Price";
                    recSalesPrice."Price Includes VAT" := recNonstockSalesPrice."Price Includes VAT";
                    recSalesPrice."Allow Invoice Disc." := recNonstockSalesPrice."Allow Invoice Disc.";
                    recSalesPrice."VAT Bus. Posting Gr. (Price)" := recNonstockSalesPrice."VAT Bus. Posting Gr. (Price)";
                    recSalesPrice."Ending Date" := recNonstockSalesPrice."Ending Date";
                    recSalesPrice."Allow Line Disc." := recNonstockSalesPrice."Allow Line Disc.";
                    recSalesPrice."Ordering Price Type Code" := recNonstockSalesPrice."Ordering Price Type Code";
                    recSalesPrice."Document Profile" := recNonstockSalesPrice."Document Profile";
                    recSalesPrice.Insert;
                    recNonstockSalesPrice."Price List Code" := recSalesPrice."Price List Code";
                    recNonstockSalesPrice."Price List Line No." := recSalesPrice."Line No.";
                end;
            1, 2: //modify,rename
                begin
                    recSalesPrice.Reset;
                    recSalesPrice.SetRange("Price List Code", recNonstockSalesPrice."Price List Code");
                    recSalesPrice.SetRange("Line No.", recNonstockSalesPrice."Price List Line No.");
                    if recSalesPrice.FindFirst then
                        recSalesPrice.Delete;


                    recSalesPrice.Init;
                    recSalesPrice."Price List Code" := recNonstockSalesPrice."Price List Code";
                    recSalesPrice."Line No." := recNonstockSalesPrice."Price List Line No.";
                    Case recNonstockSalesPrice."Sales Type" of
                        recNonstockSalesPrice."Sales Type"::"All Customers":
                            recSalesPrice."Source Type" := recSalesPrice."Source Type"::"All Customers";
                        recNonstockSalesPrice."Sales Type"::"Customer":
                            recSalesPrice."Source Type" := recSalesPrice."Source Type"::"Customer";
                        recNonstockSalesPrice."Sales Type"::"Customer Price Group":
                            recSalesPrice."Source Type" := recSalesPrice."Source Type"::"Customer Price Group"
                    End;
                    IF recSalesPrice."Source Type" <> recSalesPrice."Source Type"::"All Customers" then
                        recSalesPrice."Source No." := recNonstockSalesPrice."Sales Code";
                    recSalesPrice."Asset Type" := recSalesPrice."Asset Type"::Item;
                    recSalesPrice.Validate("Asset No.", recItem."No.");
                    recSalesPrice."Starting Date" := recNonstockSalesPrice."Starting Date";
                    recSalesPrice."Currency Code" := recNonstockSalesPrice."Currency Code";
                    recSalesPrice."Unit of Measure Code" := recNonstockSalesPrice."Unit of Measure Code";
                    recSalesPrice."Minimum Quantity" := recNonstockSalesPrice."Minimum Quantity";
                    //recSalesPrice."Location Code" := recNonstockSalesPrice."Location Code";
                    recSalesPrice."Unit Price" := recNonstockSalesPrice."Unit Price";
                    recSalesPrice."Price Includes VAT" := recNonstockSalesPrice."Price Includes VAT";
                    recSalesPrice."Allow Invoice Disc." := recNonstockSalesPrice."Allow Invoice Disc.";
                    recSalesPrice."VAT Bus. Posting Gr. (Price)" := recNonstockSalesPrice."VAT Bus. Posting Gr. (Price)";
                    recSalesPrice."Ending Date" := recNonstockSalesPrice."Ending Date";
                    recSalesPrice."Allow Line Disc." := recNonstockSalesPrice."Allow Line Disc.";
                    recSalesPrice."Ordering Price Type Code" := recNonstockSalesPrice."Ordering Price Type Code";
                    recSalesPrice."Document Profile" := recNonstockSalesPrice."Document Profile";
                    recSalesPrice.Insert;




                end;
            3:  //delete
                begin

                    recSalesPrice.Reset;
                    recSalesPrice.SetRange("Price List Code", recNonstockSalesPrice."Price List Code");
                    recSalesPrice.SetRange("Line No.", recNonstockSalesPrice."Price List Line No.");
                    if recSalesPrice.FindFirst then
                        recSalesPrice.Delete;
                end;
        end;

    end;

    procedure NonstockSalesLineDiscToItem(var recNonstockSalesLineDisc: Record "Nonstock Sales Line Discount"; var xrecNonstockSalesLineDisc: Record "Nonstock Sales Line Discount"; intActivity: Integer)
    var
        recItem: Record Item;
        recNonstockItem: Record "Nonstock Item";
        recSalesLineDisc: Record "Price List Line";

        PriceListHeader: record "Price List Header";
        LineNo: Integer;
    begin
        /*intActivity:
         0 - insert
         1 - modify
         2 - rename
         3 - delete
        */

        if not recNonstockItem.Get(recNonstockSalesLineDisc."Nonstock Item Entry No.") then
            exit;
        if recNonstockItem."Item No." = '' then
            exit;
        if not recItem.Get(recNonstockItem."Item No.") then
            exit;


        SalesSetup.TestField("Non Stock Item Price List Code");
        PriceListHeader.get(SalesSetup."Non Stock Item Price List Code");

        recSalesLineDisc.Setrange("Price List Code", PriceListHeader.Code);
        IF recSalesLineDisc.FindLast() then
            LineNo := recSalesLineDisc."Line No." + 1000
        else
            LineNo := 1000;



        case intActivity of
            0: //Insert
                begin

                    recSalesLineDisc.Reset;
                    recSalesLineDisc.SetRange("Price List Code", recNonstockSalesLineDisc."Price List Code");
                    recSalesLineDisc.SetRange("Line No.", recNonstockSalesLineDisc."Price List Line No.");
                    if recSalesLineDisc.FindFirst then
                        recSalesLineDisc.Delete;


                    recSalesLineDisc.Init;
                    recSalesLineDisc."Price List Code" := PriceListHeader.Code;
                    recSalesLineDisc."Line No." := LineNo;
                    Case recNonstockSalesLineDisc."Sales Type" of
                        recNonstockSalesLineDisc."Sales Type"::"All Customers":
                            recSalesLineDisc."Source Type" := recSalesLineDisc."Source Type"::"All Customers";
                        recNonstockSalesLineDisc."Sales Type"::"Customer":
                            recSalesLineDisc."Source Type" := recSalesLineDisc."Source Type"::"Customer";
                        recNonstockSalesLineDisc."Sales Type"::"Customer Price Group":
                            recSalesLineDisc."Source Type" := recSalesLineDisc."Source Type"::"Customer Price Group"
                    End;
                    IF recSalesLineDisc."Source Type" <> recSalesLineDisc."Source Type"::"All Customers" then
                        recSalesLineDisc."Source No." := recNonstockSalesLineDisc."Sales Code";
                    recSalesLineDisc."Asset Type" := recSalesLineDisc."Asset Type"::Item;
                    recSalesLineDisc.Validate("Asset No.", recItem."No.");


                    recSalesLineDisc."Starting Date" := recNonstockSalesLineDisc."Starting Date";
                    recSalesLineDisc."Currency Code" := recNonstockSalesLineDisc."Currency Code";
                    recSalesLineDisc."Unit of Measure Code" := recNonstockSalesLineDisc."Unit of Measure Code";
                    recSalesLineDisc."Minimum Quantity" := recNonstockSalesLineDisc."Minimum Quantity";
                    recSalesLineDisc."Ending Date" := recNonstockSalesLineDisc."Ending Date";
                    recSalesLineDisc."Line Discount %" := recNonstockSalesLineDisc."Line Discount %";
                    //                    recSalesLineDisc."Vehicle Status Code" := recNonstockSalesLineDisc."Vehicle Status Code";
                    recSalesLineDisc."Document Profile" := recNonstockSalesLineDisc."Document Profile";
                    recSalesLineDisc.Insert();
                end;
            1, 2: //modify,rename
                begin

                    recSalesLineDisc.Reset;
                    recSalesLineDisc.SetRange("Price List Code", recNonstockSalesLineDisc."Price List Code");
                    recSalesLineDisc.SetRange("Line No.", recNonstockSalesLineDisc."Price List Line No.");
                    if recSalesLineDisc.FindFirst then
                        recSalesLineDisc.Delete;



                    Clear(recSalesLineDisc);

                    recSalesLineDisc.Init;


                    recSalesLineDisc."Price List Code" := recNonstockSalesLineDisc."Price List Code";
                    recSalesLineDisc."Line No." := recNonstockSalesLineDisc."Price List Line No.";
                    Case recNonstockSalesLineDisc."Sales Type" of
                        recNonstockSalesLineDisc."Sales Type"::"All Customers":
                            recSalesLineDisc."Source Type" := recSalesLineDisc."Source Type"::"All Customers";
                        recNonstockSalesLineDisc."Sales Type"::"Customer":
                            recSalesLineDisc."Source Type" := recSalesLineDisc."Source Type"::"Customer";
                        recNonstockSalesLineDisc."Sales Type"::"Customer Price Group":
                            recSalesLineDisc."Source Type" := recSalesLineDisc."Source Type"::"Customer Price Group"
                    End;
                    IF recSalesLineDisc."Source Type" <> recSalesLineDisc."Source Type"::"All Customers" then
                        recSalesLineDisc."Source No." := recNonstockSalesLineDisc."Sales Code";
                    recSalesLineDisc."Asset Type" := recSalesLineDisc."Asset Type"::Item;
                    recSalesLineDisc.Validate("Asset No.", recItem."No.");


                    recSalesLineDisc."Starting Date" := recNonstockSalesLineDisc."Starting Date";
                    recSalesLineDisc."Currency Code" := recNonstockSalesLineDisc."Currency Code";
                    recSalesLineDisc."Unit of Measure Code" := recNonstockSalesLineDisc."Unit of Measure Code";
                    recSalesLineDisc."Minimum Quantity" := recNonstockSalesLineDisc."Minimum Quantity";
                    recSalesLineDisc."Ending Date" := recNonstockSalesLineDisc."Ending Date";
                    recSalesLineDisc."Line Discount %" := recNonstockSalesLineDisc."Line Discount %";
                    //                    recSalesLineDisc."Vehicle Status Code" := recNonstockSalesLineDisc."Vehicle Status Code";
                    recSalesLineDisc."Document Profile" := recNonstockSalesLineDisc."Document Profile";
                    recSalesLineDisc.Insert();




                end;
            3:  //delete
                begin

                    recSalesLineDisc.Reset;
                    recSalesLineDisc.SetRange("Price List Code", recNonstockSalesLineDisc."Price List Code");
                    recSalesLineDisc.SetRange("Line No.", recNonstockSalesLineDisc."Price List Line No.");
                    if recSalesLineDisc.FindFirst then
                        recSalesLineDisc.Delete;


                end;
        end;

    end;

    procedure ItemSalesPriceToNonstock(var recSalesPrice: Record "Price List Line"; var xrecSalesPrice: Record "price list line"; intActivity: Integer)
    var
        recItem: Record Item;
        recNonstockItem: Record "Nonstock Item";
        recNonstockSalesPrice: Record "Nonstock Item Price";
    begin
        /*intActivity:
         0 - insert
         1 - modify
         2 - rename
         3 - delete
        */

        IF recSalesPrice."Price Type" <> recSalesPrice."Price Type"::Sale then
            exit;
        // 11.10.2011 EDMS P8 <<
        if not recItem.Get(recSalesPrice."Asset No.") then
            exit;
        if not recItem."Created From Nonstock Item" then
            exit;

        recNonstockItem.Reset;
        recNonstockItem.SetCurrentkey("Item No.");
        recNonstockItem.SetRange("Item No.", recItem."No.");
        if not recNonstockItem.FindFirst then                            //   07.08.2015 EB.P30 #T0047
            exit;

        case intActivity of
            0: //Insert
                begin
                    recNonstockSalesPrice.Init;
                    Case recSalesPrice."Source Type" of
                        recSalesPrice."Source Type"::"All Customers":
                            recNonstockSalesPrice."Sales Type" := recNonstockSalesPrice."Sales Type"::"All Customers";
                        recSalesPrice."Source Type"::"Customer":
                            recNonstockSalesPrice."Sales Type" := recNonstockSalesPrice."Sales Type"::"Customer";
                        recSalesPrice."Source Type"::"Customer Price Group":
                            recNonstockSalesPrice."Sales Type" := recNonstockSalesPrice."Sales Type"::"Customer Price Group"
                    End;

                    IF recNonstockSalesPrice."Sales Type" <> recNonstockSalesPrice."Sales Type"::"All Customers" then
                        recNonstockSalesPrice."Sales Code" := recSalesPrice."Source No.";

                    recNonstockSalesPrice."Nonstock Item Entry No." := recNonstockItem."Entry No.";
                    recNonstockSalesPrice."Starting Date" := recSalesPrice."Starting Date";
                    recNonstockSalesPrice."Currency Code" := recSalesPrice."Currency Code";
                    recNonstockSalesPrice."Unit of Measure Code" := recSalesPrice."Unit of Measure Code";
                    recNonstockSalesPrice."Minimum Quantity" := recSalesPrice."Minimum Quantity";
                    //recNonstockSalesPrice."Location Code" := recSalesPrice."Location Code";
                    recNonstockSalesPrice."Document Profile" := recSalesPrice."Document Profile";
                    recNonstockSalesPrice."Unit Price" := recSalesPrice."Unit Price";
                    recNonstockSalesPrice."Price Includes VAT" := recSalesPrice."Price Includes VAT";
                    recNonstockSalesPrice."Allow Invoice Disc." := recSalesPrice."Allow Invoice Disc.";
                    recNonstockSalesPrice."VAT Bus. Posting Gr. (Price)" := recSalesPrice."VAT Bus. Posting Gr. (Price)";
                    recNonstockSalesPrice."Ending Date" := recSalesPrice."Ending Date";
                    recNonstockSalesPrice."Allow Line Disc." := recSalesPrice."Allow Line Disc.";
                    recNonstockSalesPrice."Ordering Price Type Code" := recSalesPrice."Ordering Price Type Code";
                    recNonstockSalesPrice."Price List Code" := recSalesPrice."Price List Code";
                    recNonstockSalesPrice."Price List Line No." := recSalesPrice."Line No.";
                    recNonstockSalesPrice.Insert;
                end;
            1, 2: //modify,rename
                begin
                    recNonstockSalesPrice.Reset;
                    recNonstockSalesPrice.SetRange("Price List Code", recSalesPrice."Price List Code");
                    recNonstockSalesPrice.SetRange("Price List Line No.", recSalesPrice."Line No.");
                    if recNonstockSalesPrice.FindFirst then
                        recNonstockSalesPrice.Delete;




                    recNonstockSalesPrice.Init;
                    Case recSalesPrice."Source Type" of
                        recSalesPrice."Source Type"::"All Customers":
                            recNonstockSalesPrice."Sales Type" := recNonstockSalesPrice."Sales Type"::"All Customers";
                        recSalesPrice."Source Type"::"Customer":
                            recNonstockSalesPrice."Sales Type" := recNonstockSalesPrice."Sales Type"::"Customer";
                        recSalesPrice."Source Type"::"Customer Price Group":
                            recNonstockSalesPrice."Sales Type" := recNonstockSalesPrice."Sales Type"::"Customer Price Group"
                    End;
                    IF recNonstockSalesPrice."Sales Type" <> recNonstockSalesPrice."Sales Type"::"All Customers" then
                        recNonstockSalesPrice."Sales Code" := recSalesPrice."Source No.";
                    recNonstockSalesPrice."Nonstock Item Entry No." := recNonstockItem."Entry No.";
                    recNonstockSalesPrice."Starting Date" := recSalesPrice."Starting Date";
                    recNonstockSalesPrice."Currency Code" := recSalesPrice."Currency Code";
                    recNonstockSalesPrice."Unit of Measure Code" := recSalesPrice."Unit of Measure Code";
                    recNonstockSalesPrice."Minimum Quantity" := recSalesPrice."Minimum Quantity";
                    //                    recNonstockSalesPrice."Location Code" := recSalesPrice."Location Code";
                    recNonstockSalesPrice."Unit Price" := recSalesPrice."Unit Price";
                    recNonstockSalesPrice."Price Includes VAT" := recSalesPrice."Price Includes VAT";
                    recNonstockSalesPrice."Allow Invoice Disc." := recSalesPrice."Allow Invoice Disc.";
                    recNonstockSalesPrice."VAT Bus. Posting Gr. (Price)" := recSalesPrice."VAT Bus. Posting Gr. (Price)";
                    recNonstockSalesPrice."Ending Date" := recSalesPrice."Ending Date";
                    recNonstockSalesPrice."Allow Line Disc." := recSalesPrice."Allow Line Disc.";
                    recNonstockSalesPrice."Ordering Price Type Code" := recSalesPrice."Ordering Price Type Code";
                    recNonstockSalesPrice."Document Profile" := recSalesPrice."Document Profile";
                    recNonstockSalesPrice."Price List Code" := recSalesPrice."Price List Code";
                    recNonstockSalesPrice."Price List Line No." := recSalesPrice."Line No.";
                    recNonstockSalesPrice.Insert;

                end;
            3:  //delete
                begin

                    recNonstockSalesPrice.Reset;
                    recNonstockSalesPrice.SetRange("Price List Code", recSalesPrice."Price List Code");
                    recNonstockSalesPrice.SetRange("Price List Line No.", recSalesPrice."Line No.");
                    if recNonstockSalesPrice.FindFirst then
                        recNonstockSalesPrice.Delete;



                end;
        end;

    end;

    procedure GetDMSServLinePriceList(ServiceHeaderEDMS: Record "Service Header EDMS"; ServiceLineEDMS: Record "Service Line EDMS"; var TempSalesPriceList: Record "Sales Price DMS" temporary)
    begin
        DMSServLinePriceExists(ServiceHeaderEDMS, ServiceLineEDMS, true);
        if TempSalesPrice.FindSet then
            repeat
                TempSalesPriceList.Init;
                TempSalesPriceList.TransferFields(TempSalesPrice);
                TempSalesPriceList.Insert;
            until TempSalesPrice.Next = 0;
    end;

    procedure GetSalesLinePriceList(SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line"; var TempSalesPriceList: Record "Sales Price DMS" temporary)
    begin
        SalesLinePriceExists(SalesHeader, SalesLine, true);
        if TempSalesPrice.FindSet then
            repeat
                TempSalesPriceList.Init;
                TempSalesPriceList.TransferFields(TempSalesPrice);
                TempSalesPriceList.Insert;
            until TempSalesPrice.Next = 0;
    end;

    procedure SalesLinePriceExists(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; ShowAll: Boolean) Result: Boolean
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeSalesLinePriceExistsProcedure(SalesHeader, SalesLine, ShowAll, TempSalesPrice, Result, IsHandled);
        if IsHandled then
            exit(Result);

        //20.03.2013 EDMS >>
        //  IF (Type = Type::Item) AND Item.GET("No.") THEN BEGIN
        case SalesLine.Type of
            SalesLine.Type::Item:
                if Item.Get(SalesLine."No.") then begin
                    IsHandled := false;
                    OnBeforeSalesLinePriceExists(
                      SalesLine, SalesHeader, TempSalesPrice, Currency, CurrencyFactor,
                      SalesHeaderStartDate(SalesHeader, DateCaption), Qty, QtyPerUOM, ShowAll, IsHandled);
                    if Item."Item Type" <> Item."item type"::"Model Version" then begin
                        //20.03.2013 EDMS <<
                        if not IsHandled then begin
                            FindSalesPrice(
                        TempSalesPrice, GetCustNoForSalesHeader(SalesHeader), SalesHeader."Bill-to Contact No.",
                        SalesLine."Customer Price Group", '', SalesLine."No.", SalesLine."Variant Code", SalesLine."Unit of Measure Code",
                                    SalesHeader."Currency Code", SalesHeaderStartDate(SalesHeader, DateCaption), ShowAll,
                                    SalesLine."Location Code", SalesLine."Ordering Price Type Code", SalesLine."Document Profile"); //20.03.2013 EDMS
                            OnAfterSalesLinePriceExists(SalesLine, SalesHeader, TempSalesPrice, ShowAll);
                        end;
                        //20.03.2013 EDMS >>
                        FindMarkupPrice(TempSalesPrice, SalesLine."Bill-to Customer No.", SalesHeader."Bill-to Contact No.",
                          SalesLine."Customer Price Group", '', SalesLine."No.", SalesHeaderStartDate(SalesHeader, DateCaption),
                          ShowAll, SalesLine."Appl.-to Item Entry");

                        //11.10.2013 EDMS P8
                        if SalesHeader."Contract No." <> '' then
                            FindContractSalesPrice(
                            TempSalesPrice, SalesLine."Bill-to Customer No.", SalesLine."No.", SalesLine."Variant Code", SalesLine."Currency Code",
                            SalesHeaderStartDate(SalesHeader, DateCaption), ShowAll,
                            SalesLine."Location Code", SalesLine."Ordering Price Type Code", SalesLine."Document Profile", '', SalesHeader."Contract No.");

                        FindSPPrice(TempSalesPrice, SalesLine."Package No.", SalesLine."Package Version No.",
                          SalesLine."Package Version Spec. Line No.", SalesLine.Type, SalesLine."No.");

                    end else begin
                        LicensePermission.SetRange("Object Type", LicensePermission."object type"::Codeunit);
                        LicensePermission.SetRange("Object Number", Codeunit::VehicleSalesPriceDiscountMgt);
                        LicensePermission.SetFilter("Execute Permission", '<>%1', LicensePermission."execute permission"::" ");
                        if not LicensePermission.IsEmpty then
                            if VehPriceCalcMgt.ChkAssemblyHdrSalesLine(SalesLine, ShowAll) then
                                FindVehPrice(
                                 TempSalesPrice, SalesLine."Bill-to Customer No.", SalesHeader."Bill-to Contact No.",
                                 SalesLine."Customer Price Group", '', SalesLine."Model Version No.", SalesHeader."Currency Code",
                                 SalesHeaderStartDate(SalesHeader, DateCaption), ShowAll, SalesLine."Location Code",
                                 SalesLine."Ordering Price Type Code", SalesLine."Document Profile", SalesLine."Vehicle Serial No.", SalesLine."Vehicle Assembly ID")
                    end;
                    //20.03.2013 EDMS <<
                    exit(TempSalesPrice.FindFirst);
                end;
            //07.03.2008. EDMS P2 >>
            SalesLine.Type::"External Service":
                if ExtServ.Get(SalesLine."No.") then begin
                    FindExtServPrice(
                      TempSalesPrice, SalesLine."Bill-to Customer No.", SalesHeader."Bill-to Contact No.",
                      SalesHeader."Customer Price Group", '', SalesLine."No.", SalesHeader."Currency Code",
                      SalesHeaderStartDate(SalesHeader, DateCaption), ShowAll);
                    FindSPPrice(TempSalesPrice, SalesLine."Package No.", SalesLine."Package Version No.",
                      SalesLine."Package Version Spec. Line No.", SalesLine.Type, SalesLine."No.");
                    DefaultPriceFor := Defaultpricefor::"Ext.Serv";
                    exit(TempSalesPrice.Find('-'));
                end;
        //07.03.2008. EDMS P2 <<
        end;
        exit(false);
    end;


    local procedure GetCustNoForSalesHeader(SalesHeader: Record "Sales Header"): Code[20]
    var
        CustNo: Code[20];
    begin
        CustNo := SalesHeader."Bill-to Customer No.";
        OnGetCustNoForSalesHeader(SalesHeader, CustNo);
        exit(CustNo);
    end;


    procedure ItemSalesLineDiscToNonstock(var recSalesLineDisc: Record "Sales Line Discount DMS"; var xrecSalesLineDisc: Record "Sales Line Discount DMS"; intActivity: Integer)
    var
        recItem: Record Item;
        recNonstockItem: Record "Nonstock Item";
        recNonstockSalesLineDisc: Record "Nonstock Sales Line Discount";
    begin
        /*intActivity:
         0 - insert
         1 - modify
         2 - rename
         3 - delete
        */

        if (recSalesLineDisc."Sales Type" <> recSalesLineDisc."sales type"::"All Customers") and
        (recSalesLineDisc."Sales Type" <> recSalesLineDisc."sales type"::Campaign) then
            exit;
        if recSalesLineDisc.Type <> recSalesLineDisc.Type::Item then
            exit;
        if not recItem.Get(recSalesLineDisc.Code) then
            exit;
        if not recItem."Created From Nonstock Item" then
            exit;

        recNonstockItem.Reset;
        recNonstockItem.SetCurrentkey("Item No.");
        recNonstockItem.SetRange("Item No.", recItem."No.");
        if not recNonstockItem.FindFirst then                                     //  07.08.2015 EB.P30 #T0047
            exit;

        case intActivity of
            0: //Insert
                begin
                    recNonstockSalesLineDisc.Init;
                    recNonstockSalesLineDisc."Sales Type" := recSalesLineDisc."Sales Type";
                    recNonstockSalesLineDisc."Sales Code" := recSalesLineDisc."Sales Code";
                    recNonstockSalesLineDisc."Nonstock Item Entry No." := recNonstockItem."Entry No.";
                    recNonstockSalesLineDisc."Starting Date" := recSalesLineDisc."Starting Date";
                    recNonstockSalesLineDisc."Currency Code" := recSalesLineDisc."Currency Code";
                    recNonstockSalesLineDisc."Unit of Measure Code" := recSalesLineDisc."Unit of Measure Code";
                    recNonstockSalesLineDisc."Minimum Quantity" := recSalesLineDisc."Minimum Quantity";
                    recNonstockSalesLineDisc."Line Discount %" := recSalesLineDisc."Line Discount %";
                    recNonstockSalesLineDisc."Ending Date" := recSalesLineDisc."Ending Date";
                    recNonstockSalesLineDisc."Vehicle Status Code" := recSalesLineDisc."Vehicle Status Code";
                    recNonstockSalesLineDisc."Document Profile" := recSalesLineDisc."Document Profile";
                    recNonstockSalesLineDisc.Insert();
                end;
            1, 2: //modify,rename
                begin
                    recNonstockSalesLineDisc.Reset;
                    recNonstockSalesLineDisc.SetRange("Sales Type", xrecSalesLineDisc."Sales Type");
                    recNonstockSalesLineDisc.SetRange("Sales Code", xrecSalesLineDisc."Sales Code");
                    recNonstockSalesLineDisc.SetRange("Nonstock Item Entry No.", recNonstockItem."Entry No.");
                    recNonstockSalesLineDisc.SetRange("Starting Date", xrecSalesLineDisc."Starting Date");
                    recNonstockSalesLineDisc.SetRange("Currency Code", xrecSalesLineDisc."Currency Code");
                    recNonstockSalesLineDisc.SetRange("Unit of Measure Code", xrecSalesLineDisc."Unit of Measure Code");
                    recNonstockSalesLineDisc.SetRange("Minimum Quantity", xrecSalesLineDisc."Minimum Quantity");
                    recNonstockSalesLineDisc.SetRange("Vehicle Status Code", xrecSalesLineDisc."Vehicle Status Code");
                    recNonstockSalesLineDisc.SetRange("Document Profile", xrecSalesLineDisc."Document Profile");

                    if recNonstockSalesLineDisc.FindFirst then
                        recNonstockSalesLineDisc.Delete;

                    recNonstockSalesLineDisc.Init;
                    recNonstockSalesLineDisc."Sales Type" := recSalesLineDisc."Sales Type";
                    recNonstockSalesLineDisc."Sales Code" := recSalesLineDisc."Sales Code";
                    recNonstockSalesLineDisc."Nonstock Item Entry No." := recNonstockItem."Entry No.";
                    recNonstockSalesLineDisc."Starting Date" := recSalesLineDisc."Starting Date";
                    recNonstockSalesLineDisc."Currency Code" := recSalesLineDisc."Currency Code";
                    recNonstockSalesLineDisc."Unit of Measure Code" := recSalesLineDisc."Unit of Measure Code";
                    recNonstockSalesLineDisc."Minimum Quantity" := recSalesLineDisc."Minimum Quantity";
                    recNonstockSalesLineDisc."Line Discount %" := recSalesLineDisc."Line Discount %";
                    recNonstockSalesLineDisc."Ending Date" := recSalesLineDisc."Ending Date";
                    recNonstockSalesLineDisc."Vehicle Status Code" := recSalesLineDisc."Vehicle Status Code";
                    recNonstockSalesLineDisc."Document Profile" := recSalesLineDisc."Document Profile";

                    recNonstockSalesLineDisc.Insert();

                end;
            3:  //delete
                begin
                    recNonstockSalesLineDisc.Reset;
                    recNonstockSalesLineDisc.SetRange("Sales Type", recSalesLineDisc."Sales Type");
                    recNonstockSalesLineDisc.SetRange("Sales Code", recSalesLineDisc."Sales Code");
                    recNonstockSalesLineDisc.SetRange("Nonstock Item Entry No.", recNonstockItem."Entry No.");
                    recNonstockSalesLineDisc.SetRange("Starting Date", recSalesLineDisc."Starting Date");
                    recNonstockSalesLineDisc.SetRange("Currency Code", recSalesLineDisc."Currency Code");
                    recNonstockSalesLineDisc.SetRange("Unit of Measure Code", recSalesLineDisc."Unit of Measure Code");
                    recNonstockSalesLineDisc.SetRange("Minimum Quantity", recSalesLineDisc."Minimum Quantity");
                    recNonstockSalesLineDisc.SetRange("Vehicle Status Code", recSalesLineDisc."Vehicle Status Code");
                    recNonstockSalesLineDisc.SetRange("Document Profile", recSalesLineDisc."Document Profile");

                    if recNonstockSalesLineDisc.FindFirst then
                        recNonstockSalesLineDisc.Delete;
                end;
        end;

    end;


    procedure DMSSPLinePriceExists(SPackage: Record "Service Package"; var SPVersionSpec: Record "Service Package Version Line"; ShowAll: Boolean): Boolean
    begin
        case SPVersionSpec.Type of
            SPVersionSpec.Type::Item:
                if Item.Get(SPVersionSpec."No.") then begin
                    FindSalesPrice(TempSalesPrice, '', '', '', '', SPVersionSpec."No.", '', SPVersionSpec."Unit of Measure Code",
                      SPackage."Currency Code", WorkDate, ShowAll, '', '', 3);
                    FindMarkupPrice(TempSalesPrice, '', '', '', '', SPVersionSpec."No.", WorkDate, ShowAll, 0);
                    exit(TempSalesPrice.Find('-'));
                end;
            SPVersionSpec.Type::"Ext. Service":
                if ExtServ.Get(SPVersionSpec."No.") then begin
                    FindExtServPrice(TempSalesPrice, '', '', '', '', SPVersionSpec."No.", SPackage."Currency Code", WorkDate, ShowAll);
                    DefaultPriceFor := Defaultpricefor::"Ext.Serv";
                    exit(TempSalesPrice.Find('-'));
                end;
            SPVersionSpec.Type::Labor:
                if ServLabor.Get(SPVersionSpec."No.") then begin
                    FindServLaborPrice(TempServicePrice, '', '', '', '', SPVersionSpec."No.", SPackage."Currency Code", WorkDate, ShowAll,
                                       ServLabor."Price Group Code",
                                       //30.03.2014 Elva Baltic P1 #RX MMG7.00 >>
                                       //SPVersionSpec."Unit of Measure Code", '');
                                       SPVersionSpec."Unit of Measure Code", '', '', '');
                    //30.03.2014 Elva Baltic P1 #RX MMG7.00 <<
                    DefaultPriceFor := Defaultpricefor::Labor;
                    exit(TempSalesPrice.Find('-'));
                end
        end;
        exit(false);
    end;


    procedure RentSalesLineLineDiscExists(RentHeader: Record "Rent Header"; var RentSalesLine: Record "Rent Sales Line"; ShowAll: Boolean): Boolean
    begin
        case RentSalesLine.Type of
            RentSalesLine.Type::Item:
                if Item.Get(RentSalesLine."No.") then begin
                    FindSalesLineDisc(
                      TempSalesLineDisc, RentHeader."Bill-to Customer No.", RentHeader."Bill-to Contact No.",
                      RentHeader."Customer Disc. Group", '', RentSalesLine."No.", Item."Item Disc. Group", RentSalesLine."Variant Code", RentSalesLine."Unit of Measure Code",
                      RentHeader."Currency Code", WorkDate, ShowAll, 3);
                    exit(TempSalesLineDisc.Find('-'));
                end;
        end;
        exit(false);
    end;

    procedure NoOfRentSalesLinePrice(RentHeader: Record "Rent Header"; var RentSalesLine: Record "Rent Sales Line"; ShowAll: Boolean): Integer
    begin
        if RentSalesLinePriceExists(RentHeader, RentSalesLine, ShowAll) then
            exit(TempSalesPrice.Count);
    end;


    procedure NoOfRentSalesLineLineDisc(RentHeader: Record "Rent Header"; var RentSalesLine: Record "Rent Sales Line"; ShowAll: Boolean): Integer
    begin
        if RentSalesLineLineDiscExists(RentHeader, RentSalesLine, ShowAll) then
            exit(TempSalesLineDisc.Count);
    end;



    procedure RentSalesLinePriceExists(RentHeader: Record "Rent Header"; var RentSalesLine: Record "Rent Sales Line"; ShowAll: Boolean): Boolean
    var
        Markup: Record "Sales/Serv. Item Markup";
    begin
        case RentSalesLine.Type of
            RentSalesLine.Type::Item:
                if Item.Get(RentSalesLine."No.") then begin
                    FindPriceFor := Findpricefor::Item;
                    FindSalesPrice(
                      TempSalesPrice, RentHeader."Bill-to Customer No.", RentHeader."Bill-to Contact No.",
                      RentHeader."Customer Price Group", '', RentSalesLine."No.", RentSalesLine."Variant Code", RentSalesLine."Unit of Measure Code",
                      RentHeader."Currency Code", WorkDate,
                      ShowAll, RentSalesLine."Location Code", RentSalesLine."Ordering Price Type Code", 3);
                    exit(TempSalesPrice.Find('-'));
                end;
        end;
        exit(false);
    end;

    Procedure CalcStdUnitPrice(ServiceHeader: Record "Service Header EDMS"; ServiceLine: Record "Service Line EDMS"; var SalesPrice: Record "Sales Price DMS"; CalledByFieldNo: Integer)
    Var
        SalesHeader: Record "Sales Header" temporary;
        SalesLine: Record "Sales line" temporary;
        PriceCalculation: Interface "Price Calculation";
        PriceType: Enum "Price Type";


    begin
        If ServiceLine.type <> ServiceLine.type::Item then
            exit;

        CreateSalesDocument(ServiceHeader, ServiceLine, SalesHeader, SalesLine);
        SalesLine.GetPriceCalculationHandler(PriceType::Sale, SalesHeader, PriceCalculation);
        //PriceCalculation.ApplyDiscount();
        SalesLine.ApplyPrice(CalledByFieldNo, PriceCalculation);
        IF (TempSalesPrice."Unit Price" <> 0) Then Begin
            If (Salesline."Unit Price" <> 0) And (Salesline."Unit Price" <= TempSalesPrice."Unit Price") then
                TempSalesPrice."Unit Price" := Salesline."Unit Price";
        End
        Else
            TempSalesPrice."Unit Price" := Salesline."Unit Price";


    end;

    Procedure CalcStdDiscount(ServiceHeader: Record "Service Header EDMS"; ServiceLine: Record "Service Line EDMS"; var TempSalesDiscount: Record "Sales Line Discount DMS")
    Var
        SalesHeader: Record "Sales Header" Temporary;
        SalesLine: Record "Sales line" Temporary;
        PriceCalculation: Interface "Price Calculation";
        PriceType: Enum "Price Type";


    begin
        If ServiceLine.type <> ServiceLine.type::Item then
            exit;
        CreateSalesDocument(ServiceHeader, ServiceLine, SalesHeader, SalesLine);
        SalesLine.GetPriceCalculationHandler(PriceType::Sale, SalesHeader, PriceCalculation);
        PriceCalculation.ApplyDiscount();
        SalesLine.ApplyPrice(0, PriceCalculation);
        If (Salesline."Line Discount %" <> 0) And (Salesline."Line Discount %" > TempSalesDiscount."Line Discount %") then
            TempSalesDiscount."Line Discount %" := Salesline."Line Discount %";

    end;


    Procedure CreateSalesDocument(ServiceHeader: Record "Service Header EDMS"; ServiceLine: Record "Service Line EDMS"; Var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales line")
    Var

    begin
        if ServiceHeader."Document Type" = ServiceHeader."document type"::Order then
            SalesHeader.Validate("Document Type", SalesHeader."document type"::Invoice)
        else
            SalesHeader.Validate("Document Type", SalesHeader."document type"::"Credit Memo");
        SalesHeader."No." := 'XX';

        SalesHeader."Posting Date" := ServiceHeader."Posting Date";
        SalesHeader."Document Date" := ServiceHeader."Document Date";

        SalesHeader.SetDontFindContract(true);

        SalesHeader."Sell-to Customer No." := ServiceHeader."Sell-to Customer No.";
        SalesHeader."Bill-to Customer No." := ServiceHeader."Bill-to Customer No.";
        SalesHeader.SetHideValidationDialog(true);
        //SalesHeader.Validate("Bill-to Customer No.", "Bill-to Customer No.");
        //SalesHeader.Validate("Payment Method Code", "Payment Method Code");
        SalesHeader."Make Code" := ServiceHeader."Make Code";
        SalesHeader."Model Code" := ServiceHeader."Model Code";
        SalesHeader."Vehicle Serial No." := ServiceHeader."Vehicle Serial No.";
        SalesHeader."Vehicle Accounting Cycle No." := ServiceHeader."Vehicle Accounting Cycle No.";
        SalesHeader."Vehicle Registration No." := ServiceHeader."Vehicle Registration No.";
        SalesHeader."Service Document" := true;
        SalesHeader."Document Profile" := SalesHeader."document profile"::Service;
        SalesHeader."VAT Bus. Posting Group" := ServiceHeader."VAT Bus. Posting Group";
        SalesHeader."Service Document No." := ServiceHeader."No.";
        SalesHeader."Order Date" := ServiceHeader."Order Date";
        SalesHeader."Deal Type Code" := ServiceHeader."Deal Type";
        SalesHeader."Vehicle Status Code" := ServiceHeader."Vehicle Status Code";
        SalesHeader."Currency Code" := ServiceHeader."Currency Code";
        SalesHeader."Currency Factor" := ServiceHeader."Currency Factor";
        SalesHeader."Contract No." := ServiceHeader."Contract No.";
        IF SalesHeader.insert then;

        SalesLine.Init;
        SalesLine."Document Type" := SalesHeader."Document Type";
        SalesLine."Document No." := SalesHeader."No.";
        SalesLine."Line No." := 10000;
        SalesLine."Make Code" := ServiceLine."Make Code";
        SalesLine."Line Type" := ServiceLine.Type;
        SalesLine."Service Order No. EDMS" := ServiceLine."Document No.";
        SalesLine."Service Order Line No. EDMS" := ServiceLine."Line No.";
        SalesLine."Order Line Type No." := ServiceLine."No.";
        SalesLine.Type := SalesLine.Type::Item;
        SalesLine."No." := ServiceLine."No.";
        SalesLine."Customer Price Group" := ServiceLine."Customer Price Group";
        SalesLine."Customer Disc. Group" := ServiceLine."Customer Disc. Group";
        SalesLine."Gen. Bus. Posting Group" := ServiceLine."Gen. Bus. Posting Group";
        SalesLine."VAT Bus. Posting Group" := ServiceLine."VAT Bus. Posting Group";
        SalesLine."Location Code" := ServiceLine."Location Code";
        SalesLine."Allow Line Disc." := true;
        SalesLine."Gen. Prod. Posting Group" := ServiceLine."Gen. Prod. Posting Group";
        SalesLine."VAT Prod. Posting Group" := ServiceLine."VAT Prod. Posting Group";
        SalesLine."Unit of Measure Code" := ServiceLine."Unit of Measure Code";
        SalesLine.Quantity := ServiceLine.Quantity;
        SalesLine."Document Profile" := SalesLine."document profile"::Service;

        SalesLine."Variant Code" := ServiceLine."Variant Code";
        SalesLine."Ordering Price Type Code" := ServiceLine."Ordering Price Type Code";
        if SalesLine.Insert() then;

    end;

    procedure NoOfSalesLineMarkupPrice(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; ShowAll: Boolean): Integer
    begin

        FindMarkupPrice(TempSalesPrice, SalesHeader."Bill-to Customer No.", SalesHeader."Bill-to Contact No.",
          SalesHeader."Customer Price Group", '', SalesLine."No.", SalesHeaderStartDate(SalesHeader, DateCaption),
          ShowAll, SalesLine."Appl.-to Item Entry");
        exit(TempSalesPrice.Count);
    end;

    procedure CalcNoOfSalesMarkupPrices(var SalesLine: Record "Sales Line"): Integer
    Var
        SalesHeader: record "Sales Header";
    begin
        IF GetItem(SalesLine) THEN Begin
            if SalesHeader.get(SalesLine."Document Type", Salesline."document no.") then
                EXIT(NoOfSalesLineMarkupPrice(SalesHeader, SalesLine, TRUE));
        end;
    end;


    local procedure GetItem(var SalesLine: Record "Sales Line"): Boolean
    begin
        if (SalesLine.Type <> SalesLine.Type::Item) or (SalesLine."No." = '') then
            exit(false);

        if SalesLine."No." <> Item."No." then
            Item.Get(SalesLine."No.");
        exit(true);
    end;


    procedure GetSalesLinePrice(SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line")
    var

    begin
        SalesLinePriceExists(SalesHeader, SalesLine, true);
        if PAGE.RunModal(PAGE::"Get Sales Price DMS", TempSalesPrice) = ACTION::LookupOK then begin
            SetVAT(
              SalesHeader."Prices Including VAT", SalesLine."VAT %", SalesLine."VAT Calculation Type", SalesLine."VAT Bus. Posting Group");
            SetUoM(Abs(SalesLine.Quantity), SalesLine."Qty. per Unit of Measure");
            SetCurrency(
              SalesHeader."Currency Code", SalesHeader."Currency Factor", SalesHeaderExchDate(SalesHeader));

            if not IsInMinQty(TempSalesPrice."Unit of Measure Code", TempSalesPrice."Minimum Quantity") then
                Error(
                  Text000,
                  SalesLine.FieldCaption(Quantity),
                  TempSalesPrice.FieldCaption("Minimum Quantity"),
                  TempSalesPrice.TableCaption);
            if not (TempSalesPrice."Currency Code" in [SalesLine."Currency Code", '']) then
                Error(
                  Text001,
                  SalesLine.FieldCaption("Currency Code"),
                  SalesLine.TableCaption,
                  TempSalesPrice.TableCaption);
            if not (TempSalesPrice."Unit of Measure Code" in [SalesLine."Unit of Measure Code", '']) then
                Error(
                  Text001,
                  SalesLine.FieldCaption("Unit of Measure Code"),
                  SalesLine.TableCaption,
                  TempSalesPrice.TableCaption);
            if TempSalesPrice."Starting Date" > SalesHeaderStartDate(SalesHeader, DateCaption) then
                Error(
                  Text000,
                  DateCaption,
                  TempSalesPrice.FieldCaption("Starting Date"),
                  TempSalesPrice.TableCaption);

            ConvertPriceToVAT(
              TempSalesPrice."Price Includes VAT", Item."VAT Prod. Posting Group",
              TempSalesPrice."VAT Bus. Posting Gr. (Price)", TempSalesPrice."Unit Price");
            ConvertPriceToUoM(TempSalesPrice."Unit of Measure Code", TempSalesPrice."Unit Price");
            ConvertPriceLCYToFCY(TempSalesPrice."Currency Code", TempSalesPrice."Unit Price");
            SalesLine."Allow Invoice Disc." := TempSalesPrice."Allow Invoice Disc.";
            SalesLine."Allow Line Disc." := TempSalesPrice."Allow Line Disc.";
            if not SalesLine."Allow Line Disc." then
                SalesLine."Line Discount %" := 0;

            if TempSalesPrice."Sales Type" = TempSalesPrice."sales type"::Campaign then
                SalesLine."Campaign No." := TempSalesPrice."Sales Code"
            else
                SalesLine."Campaign No." := '';


            SalesLine.Validate("Unit Price", TempSalesPrice."Unit Price");
        end;


    end;

    local procedure SalesHeaderExchDate(SalesHeader: Record "Sales Header"): Date
    begin
        if SalesHeader."Posting Date" <> 0D then
            exit(SalesHeader."Posting Date");
        exit(WorkDate);
    end;

    procedure CalcNoOfSalesPrices(var recServiceLine: Record "Service Line EDMS"): Integer
    begin
        if GetItem2(recServiceLine) then begin
            GetServiceHeader(recServiceLine);
            exit(NoOfServLinePriceEDMS(ServiceHeader, recServiceLine, true));
        end;
    end;

    local procedure GetServiceHeader(recServiceLine: Record "Service Line EDMS")
    begin
        if (recServiceLine."Document Type" <> ServiceHeader."Document Type") or
           (recServiceLine."Document No." <> ServiceHeader."No.")
        then
            ServiceHeader.Get(recServiceLine."Document Type", recServiceLine."Document No.");
    end;

    local procedure GetItem2(var recServiceLine: Record "Service Line EDMS"): Boolean
    begin
        if (recServiceLine.Type <> recServiceLine.Type::Item) or (recServiceLine."No." = '') then
            exit(false);

        if recServiceLine."No." <> Item."No." then
            Item.Get(recServiceLine."No.");
        exit(true);
    end;



    procedure NoOfServLineLineDiscEDMS(ServiceHeader: Record "Service Header EDMS"; var ServiceLine: Record "Service Line EDMS"; ShowAll: Boolean): Integer
    begin
        if DMSServLineLineDiscExists(ServiceHeader, ServiceLine, ShowAll) then
            exit(TempSalesLineDisc.Count)

    end;

    procedure NoOfServLinePriceEDMS(ServiceHeader: Record "Service Header EDMS"; var ServiceLine: Record "Service Line EDMS"; ShowAll: Boolean): Integer
    begin
        if DMSServLinePriceExists(ServiceHeader, ServiceLine, ShowAll) then
            exit(TempSalesPrice.Count);
    end;

    //Ramzi
    [EventSubscriber(ObjectType::codeunit, Codeunit::"Sales Line - Price", 'OnAfterFillBuffer', '', false, false)]
    local procedure OnAfterFillBuffer(var PriceCalculationBuffer: Record "Price Calculation Buffer"; SalesHeader: Record "Sales Header"; SalesLine: Record "Sales Line")
    begin

        PriceCalculationBuffer."Ordering Price Type Code" := SalesLine."Ordering Price Type Code";
        PriceCalculationBuffer."Document Profile" := SalesHeader."Document Profile";
        PriceCalculationBuffer."Vehicle Serial No." := SalesLine."Vehicle Serial No.";
        PriceCalculationBuffer."Contract No." := SalesLine."Contract No.";
        PriceCalculationBuffer."Bill-to Customer No." := SalesHeader."Bill-to Customer No.";
        PriceCalculationBuffer."Document Type" := Salesline."Document Type";
        PriceCalculationBuffer."Document No." := Salesline."Document No.";
        PriceCalculationBuffer."Line No." := Salesline."Line No.";
        PriceCalculationBuffer."item category Code" := salesLine."Item Category Code";
    end;

    [EventSubscriber(ObjectType::codeunit, Codeunit::"Price Calculation Buffer Mgt.", 'OnAfterSetFilters', '', false, false)]
    local procedure OnAfterSetFilters(var PriceListLine: Record "Price List Line"; AmountType: Enum "Price Amount Type"; var PriceCalculationBuffer: Record "Price Calculation Buffer"; ShowAll: Boolean)
    begin
        PriceListLine.Setrange("asset type");
        PriceListLine.SetFilter("Document Profile", '%1|%2', PriceCalculationBuffer."Document Profile", PriceCalculationBuffer."Document Profile"::" ");
        PriceListLine.SetFilter("Vehicle Serial No.", '%1|%2', PriceCalculationBuffer."Vehicle Serial No.", '');
        PriceListLine.SetFilter("Ordering Price Type Code", '%1|%2', PriceCalculationBuffer."Ordering Price Type Code", '');
        PriceListLine.SetFilter("Location Code", '%1|%2', PriceCalculationBuffer."Location Code", '');
        PriceListLine.SetFilter("Item Category Code", '%1|%2', PriceCalculationBuffer."Item Category Code", '');
    end;


    [EventSubscriber(ObjectType::codeunit, Codeunit::"Price List Management", 'OnBeforeFindDuplicatePriceListLine', '', false, false)]
    local procedure OnBeforeFindDuplicatePriceListLine(PriceListLine: Record "Price List Line"; var DuplicatePriceListLine: Record "Price List Line")
    begin
        DuplicatePriceListLine.SetRange("Vehicle Serial No.", PriceListLine."Vehicle Serial No.");
        DuplicatePriceListLine.SetRange("Ordering Price Type Code", PriceListLine."Ordering Price Type Code");
        DuplicatePriceListLine.SetRange("Document Profile", PriceListLine."Document Profile");
        DuplicatePriceListLine.SetRange("Location Code", PriceListLine."location Code");
        DuplicatePriceListLine.Setrange("Item Category Code", PriceListLine."Item Category Code");
    end;



    [EventSubscriber(ObjectType::codeunit, Codeunit::"Price Calculation - V16", 'OnAfterIsBetterLine', '', false, false)]
    local procedure OnAfterIsBetterLine(PriceListLine: Record "Price List Line"; AmountType: Enum "Price Amount Type"; BestPriceListLine: Record "Price List Line"; var Result: Boolean)
    begin
        // A completer  pour mettre la priorite sur order price fff
    end;



    [EventSubscriber(ObjectType::table, database::"Sales Line", 'OnAfterPickPrice', '', false, false)]
    local procedure OnAfterPickPrice(var SalesLine: Record "Sales Line"; var PriceCalculation: Interface "Price Calculation")
    begin



    end;






    [IntegrationEvent(false, false)]
    local procedure OnBeforeFindSalesLineDisc(var ToSalesLineDisc: Record "Sales Line Discount DMS"; var CustNo: Code[20]; ContNo: Code[20]; var CustDiscGrCode: Code[20]; var CampaignNo: Code[20]; var ItemNo: Code[20]; var ItemDiscGrCode: Code[20]; var VariantCode: Code[10]; var UOM: Code[10]; var CurrencyCode: Code[10]; var StartingDate: Date; var ShowAll: Boolean)
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnFindSalesLineDiscOnAfterSetFilters(var SalesLineDiscount: Record "Sales Line Discount DMS")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeActivatedCampaignExists(var ToCampaignTargetGr: Record "Campaign Target Group"; CustNo: Code[20]; ContNo: Code[20]; CampaignNo: Code[20]; var IsHandled: Boolean);
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnAfterFindSalesLineDisc(var ToSalesLineDisc: Record "Sales Line Discount DMS"; CustNo: Code[20]; ContNo: Code[20]; CustDiscGrCode: Code[20]; CampaignNo: Code[20]; ItemNo: Code[20]; ItemDiscGrCode: Code[20]; VariantCode: Code[10]; UOM: Code[10]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalcBestLineDisc(var SalesLineDisc: Record "Sales Line Discount DMS"; Item: Record Item; var IsHandled: Boolean; QtyPerUOM: Decimal; Qty: Decimal);
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCalcBestUnitPrice(var SalesPrice: Record "Sales Price DMS"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCalcBestUnitPriceOnBeforeCalcBestUnitPriceConvertPrice(var SalesPrice: Record "Sales Price DMS"; Qty: Decimal; var IsHandled: Boolean)
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnAfterCalcBestUnitPrice(var SalesPrice: Record "Sales Price DMS"; var BestSalesPrice: Record "Sales Price DMS")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalcBestUnitPriceAsItemUnitPrice(var SalesPrice: Record "Sales Price DMS"; var Item: Record Item)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeConvertPriceToVAT(var VATPostingSetup: Record "VAT Posting Setup"; var UnitPrice: Decimal; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterCalcLineAmount(SalesPrice: Record "Sales Price DMS"; var LineAmount: Decimal)
    begin
    end;

    [IntegrationEvent(true, false)]
    local procedure OnBeforeCalcBestUnitPriceConvertPrice(var SalesPrice: Record "Sales Price DMS"; var IsHandled: Boolean; Item: Record "Item")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFindSalesPrice(var ToSalesPrice: Record "Sales Price DMS"; var FromSalesPrice: Record "Sales Price DMS"; var QtyPerUOM: Decimal; var Qty: Decimal; var CustNo: Code[20]; var ContNo: Code[20]; var CustPriceGrCode: Code[10]; var CampaignNo: Code[20]; var ItemNo: Code[20]; var VariantCode: Code[10]; var UOM: Code[10]; var CurrencyCode: Code[10]; var StartingDate: Date; var ShowAll: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFindExtServPrice(Var ServiceHeader: Record "Service Header EDMS"; var ServiceLine: Record "Service Line EDMS")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeFindServLaborPrice(Var ServiceHeader: Record "Service Header EDMS"; var ServiceLine: Record "Service Line EDMS")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterFindSalesPrice(var ToSalesPrice: Record "Sales Price DMS"; var FromSalesPrice: Record "Sales Price DMS"; QtyPerUOM: Decimal; Qty: Decimal; CustNo: Code[20]; ContNo: Code[20]; CustPriceGrCode: Code[10]; CampaignNo: Code[20]; ItemNo: Code[20]; VariantCode: Code[10]; UOM: Code[10]; CurrencyCode: Code[10]; StartingDate: Date; ShowAll: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCopySalesPriceToSalesPrice(var FromSalesPrice: Record "Sales Price DMS"; var ToSalesPrice: Record "Sales Price DMS"; var IsHandled: Boolean)
    begin
    end;


    [IntegrationEvent(false, false)]
    local procedure OnBeforeSalesLinePriceExistsProcedure(var SalesHeader: Record "Sales Header"; var SalesLine: Record "Sales Line"; ShowAll: Boolean; TempSalesPrice: Record "Sales Price dms" temporary; var Result: Boolean; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSalesLinePriceExists(var SalesLine: Record "Sales Line"; var SalesHeader: Record "Sales Header"; var TempSalesPrice: Record "Sales Price DMS" temporary; Currency: Record Currency; CurrencyFactor: Decimal; StartingDate: Date; Qty: Decimal; QtyPerUOM: Decimal; ShowAll: Boolean; var InHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSalesLinePriceExists(var SalesLine: Record "Sales Line"; var SalesHeader: Record "Sales Header"; var TempSalesPrice: Record "Sales Price DMS" temporary; ShowAll: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnGetCustNoForSalesHeader(var SalesHeader: Record "Sales Header"; var CustomerNo: Code[20])
    begin
    end;





    var
        VehPriceCalcMgt: Codeunit VehicleSalesPriceDiscountMgt;
        DateCaption: Text[30];


        GLSetup: Record "General Ledger Setup";
        Item: Record Item;
        NonStockItem: Record "Nonstock Item";
        ResPrice: Record "Resource Price";
        Res: Record Resource;
        Currency: Record Currency;
        Text000: Label '%1 is less than %2 in the %3.';
        Text010: Label 'Prices including VAT cannot be calculated when %1 is %2.';
        TempSalesPrice: Record "Sales Price DMS" temporary;
        TempNonstockItemPrice: Record "Nonstock Item Price" temporary;
        TempSalesLineDisc: Record "Sales Line Discount DMS" temporary;
        TempServicePrice: Record "Service Price" temporary;
        TempServiceLineDiscount: Record "Labor Sales Line Discount" temporary;
        Vehicle: Record Vehicle;
        SingleInstanceMgt: Codeunit SingleInstanceManagement;
        LineDiscPerCent: Decimal;
        Qty: Decimal;
        AllowLineDisc: Boolean;
        AllowInvDisc: Boolean;
        VATPerCent: Decimal;
        PricesInclVAT: Boolean;
        VATCalcType: Option "Normal VAT","Reverse Charge VAT","Full VAT","Sales Tax";
        VATBusPostingGr: Code[20];
        QtyPerUOM: Decimal;
        PricesInCurrency: Boolean;
        CurrencyFactor: Decimal;
        ExchRateDate: Date;
        Text018: Label '%1 %2 is greater than %3 and was adjusted to %4.';
        FoundSalesPrice: Boolean;
        Text001: Label 'The %1 in the %2 must be same as in the %3.';
        TempTableErr: Label 'The table passed as a parameter must be temporary.';
        HideResUnitPriceMessage: Boolean;
        LicensePermission: Record "License Permission";
        ServLabor: Record "Service Labor";
        SalesSetup: Record "Sales & Receivables Setup";
        VATPostSetup: Record "VAT Posting Setup";
        Text101: label '%1 cannot be empty when %2 is defined.';
        DefaultPriceFor: Option Item,Labor,"Ext.Serv";
        ExtServ: Record "External Service";
        Text102: label '%1 is incomplete. Field %2 cannot be 0.';
        FindPriceFor: Option Item,Labor,"Ext.Service";

        ServiceHeader: Record "Service Header EDMS";

}
