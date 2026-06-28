codeunit 25006145 "Service Line EDMS - Price" implements "Line With Price"
{

    var
        ServiceHeader: Record "Service Header EDMS";
        ServiceLine: Record "Service Line EDMS";
        PriceSourceList: codeunit "Price Source List";
        CurrPriceType: Enum "Price Type";
        PriceCalculated: Boolean;

    procedure GetTableNo(): Integer
    begin
        exit(Database::"Service Line EDMS")
    end;

    procedure SetLine(PriceType: Enum "Price Type"; Line: Variant)
    begin
        ServiceLine := Line;
        CurrPriceType := PriceType;
        PriceCalculated := false;
        AddSources();
    end;

    procedure SetLine(PriceType: Enum "Price Type"; Header: Variant; Line: Variant)
    begin
        ClearAll();
        ServiceHeader := Header;
        SetLine(PriceType, Line);
    end;

    procedure SetSources(var NewPriceSourceList: Codeunit "Price Source List")
    begin
        PriceSourceList.Copy(NewPriceSourceList);
    end;

    procedure GetLine(var Line: Variant)
    begin
        Line := ServiceLine;
    end;

    procedure GetLine(var Header: Variant; var Line: Variant)
    begin
        Header := ServiceHeader;
        Line := ServiceLine;
    end;

    procedure GetAssetType() AssetType: Enum "Price Asset Type"
    begin
        case ServiceLine.Type of
            ServiceLine.Type::Item:
                AssetType := AssetType::Item;
            ServiceLine.Type::"G/L Account":
                AssetType := AssetType::"G/L Account";
            ServiceLine.Type::Resource:
                AssetType := AssetType::Resource;
            else
                AssetType := AssetType::" ";
        end;
        OnAfterGetAssetType(ServiceLine, AssetType);
    end;

    procedure GetPriceType(): Enum "Price Type"
    begin
        exit(CurrPriceType);
    end;

    procedure IsPriceUpdateNeeded(AmountType: Enum "Price Amount Type"; FoundPrice: Boolean; CalledByFieldNo: Integer) Result: Boolean
    begin
        if FoundPrice then
            Result := true
        else
            Result :=
                Result or
                not (CalledByFieldNo in [ServiceLine.FieldNo(Quantity), ServiceLine.FieldNo("Variant Code")]);

        OnAfterIsPriceUpdateNeeded(AmountType, FoundPrice, CalledByFieldNo, Result, ServiceLine);
    end;

    procedure IsDiscountAllowed() Result: Boolean
    begin
        Result := ServiceLine."Allow Line Disc." or not PriceCalculated;
        OnAfterIsDiscountAllowed(ServiceLine, PriceCalculated, Result, ServiceHeader);
    end;

    procedure Verify()
    var
        IsHandled: Boolean;
    begin
        IsHandled := false;
        OnBeforeVerify(ServiceHeader, ServiceLine, IsHandled);
        if IsHandled then
            exit;

        ServiceLine.TestField("Qty. per Unit of Measure");
        if ServiceHeader."Currency Code" <> '' then
            ServiceHeader.TestField("Currency Factor");
    end;

    procedure SetAssetSourceForSetup(var DtldPriceCalculationSetup: Record "Dtld. Price Calculation Setup"): Boolean
    begin
        DtldPriceCalculationSetup.Init();
        DtldPriceCalculationSetup.Type := CurrPriceType;
        DtldPriceCalculationSetup.Method := ServiceLine."Price Calculation Method";
        DtldPriceCalculationSetup."Asset Type" := GetAssetType();
        DtldPriceCalculationSetup."Asset No." := ServiceLine."No.";
        exit(PriceSourceList.GetSourceGroup(DtldPriceCalculationSetup));
    end;

    procedure CopyToBuffer(var PriceCalculationBufferMgt: Codeunit "Price Calculation Buffer Mgt."): Boolean
    var
        PriceCalculationBuffer: Record "Price Calculation Buffer";
    begin
        PriceCalculationBuffer.Init();
        if not SetAssetSource(PriceCalculationBuffer) then
            exit(false);

        FillBuffer(PriceCalculationBuffer);
        PriceCalculationBufferMgt.Set(PriceCalculationBuffer, PriceSourceList);
        OnCopyToBufferOnAfterPriceCalculationBufferMgtSet(PriceCalculationBufferMgt, PriceCalculationBuffer, PriceSourceList);
        exit(true);
    end;

    local procedure FillBuffer(var PriceCalculationBuffer: Record "Price Calculation Buffer")
    var
        Item: Record Item;
        Resource: Record Resource;
    begin
        PriceCalculationBuffer."Price Calculation Method" := ServiceLine."Price Calculation Method";
        // Tax
        PriceCalculationBuffer."Prices Including Tax" := ServiceHeader."Prices Including VAT";
        PriceCalculationBuffer."Tax %" := ServiceLine."VAT %";
        PriceCalculationBuffer."VAT Calculation Type" := ServiceLine."VAT Calculation Type".AsInteger();
        PriceCalculationBuffer."VAT Bus. Posting Group" := ServiceLine."VAT Bus. Posting Group";
        PriceCalculationBuffer."VAT Prod. Posting Group" := ServiceLine."VAT Prod. Posting Group";

        case PriceCalculationBuffer."Asset Type" of
            PriceCalculationBuffer."Asset Type"::Item:
                begin
                    PriceCalculationBuffer."Variant Code" := ServiceLine."Variant Code";
                    Item.Get(PriceCalculationBuffer."Asset No.");
                    PriceCalculationBuffer."Unit Price" := Item."Unit Price";
                    PriceCalculationBuffer."Item Disc. Group" := Item."Item Disc. Group";
                    if PriceCalculationBuffer."VAT Prod. Posting Group" = '' then
                        PriceCalculationBuffer."VAT Prod. Posting Group" := Item."VAT Prod. Posting Group";
                end;
            PriceCalculationBuffer."Asset Type"::Resource:
                begin
                    //PriceCalculationBuffer."Work Type Code" := ServiceLine."Work Type Code";
                    Resource.Get(PriceCalculationBuffer."Asset No.");
                    PriceCalculationBuffer."Unit Price" := Resource."Unit Price";
                    if PriceCalculationBuffer."VAT Prod. Posting Group" = '' then
                        PriceCalculationBuffer."VAT Prod. Posting Group" := Resource."VAT Prod. Posting Group";
                end;
        end;
        PriceCalculationBuffer."Location Code" := ServiceLine."Location Code";
        PriceCalculationBuffer."Document Date" := ServiceHeader."Document Date";

        // Currency
        PriceCalculationBuffer.Validate("Currency Code", ServiceHeader."Currency Code");
        PriceCalculationBuffer."Currency Factor" := ServiceHeader."Currency Factor";
        if (PriceCalculationBuffer."Price Type" = PriceCalculationBuffer."Price Type"::Purchase) and
           (PriceCalculationBuffer."Asset Type" = PriceCalculationBuffer."Asset Type"::Resource)
        then
            PriceCalculationBuffer."Calculation in LCY" := true;

        // UoM
        PriceCalculationBuffer.Quantity := Abs(ServiceLine.Quantity);
        PriceCalculationBuffer."Unit of Measure Code" := ServiceLine."Unit of Measure Code";
        PriceCalculationBuffer."Qty. per Unit of Measure" := ServiceLine."Qty. per Unit of Measure";
        // Discounts
        PriceCalculationBuffer."Line Discount %" := ServiceLine."Line Discount %";
        PriceCalculationBuffer."Allow Line Disc." := IsDiscountAllowed();
        PriceCalculationBuffer."Allow Invoice Disc." := ServiceLine."Allow Invoice Disc.";
        OnAfterFillBuffer(PriceCalculationBuffer, ServiceHeader, ServiceLine);
    end;

    procedure Update(AmountType: Enum "Price Amount Type")
    begin
    end;

    procedure SetPrice(AmountType: Enum "Price Amount Type"; PriceListLine: Record "Price List Line")
    begin
    end;

    procedure ValidatePrice(AmountType: Enum "Price Amount Type")
    begin
    end;

    local procedure AddSources()
    begin
        PriceSourceList.Init();
        case CurrPriceType of
            CurrPriceType::Sale:
                AddCustomerSources();
            CurrPriceType::Purchase:
                PriceSourceList.Add(Enum::"Price Source Type"::"All Vendors");
        end;
        //PriceSourceList.AddJobAsSources(ServiceLine."Job No.", ServiceLine."Job Task No.");
        OnAfterAddSources(ServiceHeader, ServiceLine, CurrPriceType, PriceSourceList);
    end;

    local procedure AddCustomerSources()
    begin
        PriceSourceList.Add(Enum::"Price Source Type"::"All Customers");
        PriceSourceList.Add(Enum::"Price Source Type"::Customer, ServiceHeader."Bill-to Customer No.");
        PriceSourceList.Add(Enum::"Price Source Type"::Contact, ServiceHeader."Bill-to Contact No.");
        PriceSourceList.Add(Enum::"Price Source Type"::Campaign, ServiceHeader."Campaign No.");
        AddActivatedCampaignsAsSource();
        PriceSourceList.Add(Enum::"Price Source Type"::"Customer Price Group", ServiceLine."Customer Price Group");
        PriceSourceList.Add(Enum::"Price Source Type"::"Customer Disc. Group", ServiceLine."Customer Disc. Group");
    end;

    procedure AddActivatedCampaignsAsSource()
    var
        TempTargetCampaignGr: Record "Campaign Target Group" temporary;
        SourceType: Enum "Price Source Type";
    begin
        if FindActivatedCampaign(TempTargetCampaignGr) then
            repeat
                PriceSourceList.Add(SourceType::Campaign, TempTargetCampaignGr."Campaign No.");
            until TempTargetCampaignGr.Next() = 0;
    end;

    local procedure FindActivatedCampaign(var TempCampaignTargetGr: Record "Campaign Target Group" temporary): Boolean
    var
        PriceSourceType: enum "Price Source Type";
    begin
        TempCampaignTargetGr.Reset();
        TempCampaignTargetGr.DeleteAll();

        if PriceSourceList.GetValue(PriceSourceType::Campaign) = '' then
            if not FindCustomerCampaigns(PriceSourceList.GetValue(PriceSourceType::Customer), TempCampaignTargetGr) then
                FindContactCompanyCampaigns(PriceSourceList.GetValue(PriceSourceType::Contact), TempCampaignTargetGr);

        exit(TempCampaignTargetGr.FindFirst());
    end;

    local procedure FindCustomerCampaigns(CustomerNo: Code[20]; var TempCampaignTargetGr: Record "Campaign Target Group" temporary) Found: Boolean;
    var
        CampaignTargetGr: Record "Campaign Target Group";
    begin
        CampaignTargetGr.SetRange(Type, CampaignTargetGr.Type::Customer);
        CampaignTargetGr.SetRange("No.", CustomerNo);
        Found := CampaignTargetGr.CopyTo(TempCampaignTargetGr);
        OnAfterFindCustomerCampaigns(CustomerNo, TempCampaignTargetGr, Found);
    end;

    local procedure FindContactCompanyCampaigns(ContactNo: Code[20]; var TempCampaignTargetGr: Record "Campaign Target Group" temporary) Found: Boolean
    var
        CampaignTargetGr: Record "Campaign Target Group";
        Contact: Record Contact;
    begin
        if Contact.Get(ContactNo) then begin
            CampaignTargetGr.SetRange(Type, CampaignTargetGr.Type::Contact);
            CampaignTargetGr.SetRange("No.", Contact."Company No.");
            Found := CampaignTargetGr.CopyTo(TempCampaignTargetGr);
            OnAfterFindContactCompanyCampaigns(ContactNo, TempCampaignTargetGr, Found);
        end;
    end;

    local procedure SetAssetSource(var PriceCalculationBuffer: Record "Price Calculation Buffer"): Boolean;
    begin
        PriceCalculationBuffer."Price Type" := CurrPriceType;
        PriceCalculationBuffer."Asset Type" := GetAssetType();
        PriceCalculationBuffer."Asset No." := ServiceLine."No.";
        exit((PriceCalculationBuffer."Asset Type" <> PriceCalculationBuffer."Asset Type"::" ") and (PriceCalculationBuffer."Asset No." <> ''));
    end;


    [IntegrationEvent(false, false)]
    local procedure OnAfterGetAssetType(ServiceLine: Record "Service Line EDMS"; var AssetType: Enum "Price Asset Type")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterAddSources(ServiceHeader: Record "Service Header EDMS"; ServiceLine: Record "Service Line EDMS";
        PriceType: Enum "Price Type"; var PriceSourceList: Codeunit "Price Source List")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterFillBuffer(var PriceCalculationBuffer: Record "Price Calculation Buffer"; ServiceHeader: Record "Service Header EDMS"; ServiceLine: Record "Service Line EDMS")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterGetDocumentDate(var DocumentDate: Date; ServiceHeader: Record "Service Header EDMS"; ServiceLine: Record "Service Line EDMS")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSetPrice(var ServiceLine: Record "Service Line EDMS"; PriceListLine: Record "Price List Line"; AmountType: Enum "Price Amount Type"; var ServiceHeader: Record "Service Header EDMS")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterUpdate(var ServiceLine: Record "Service Line EDMS"; CurrPriceType: Enum "Price Type"; AmountType: Enum "Price Amount Type"; var ServiceHeader: Record "Service Header EDMS")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeSetPrice(var ServiceLine: Record "Service Line EDMS"; PriceListLine: Record "Price List Line"; AmountType: Enum "Price Amount Type"; var IsHandled: Boolean; var ServiceHeader: Record "Service Header EDMS")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeVerify(ServiceHeader: Record "Service Header EDMS"; ServiceLine: Record "Service Line EDMS"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnCopyToBufferOnAfterPriceCalculationBufferMgtSet(var PriceCalculationBufferMgt: Codeunit "Price Calculation Buffer Mgt."; PriceCalculationBuffer: Record "Price Calculation Buffer"; var PriceSourceList: Codeunit "Price Source List")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterIsDiscountAllowed(ServiceLine: Record "Service Line EDMS"; PriceCalculated: Boolean; var Result: Boolean; var ServiceHeader: Record "Service Header EDMS")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterValidatePrice(var ServiceLine: Record "Service Line EDMS"; CurrPriceType: Enum "Price Type"; AmountType: Enum "Price Amount Type"; var ServiceHeader: Record "Service Header EDMS")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterIsPriceUpdateNeeded(AmountType: Enum "Price Amount Type"; FoundPrice: Boolean;
                                                               CalledByFieldNo: Integer; var Result: Boolean; ServiceLine: Record "Service Line EDMS")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterFindContactCompanyCampaigns(ContactNo: Code[20]; var TempCampaignTargetGr: Record "Campaign Target Group" temporary; var Found: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterFindCustomerCampaigns(CustomerNo: Code[20]; var TempCampaignTargetGr: Record "Campaign Target Group" temporary; var Found: Boolean)
    begin
    end;
}
