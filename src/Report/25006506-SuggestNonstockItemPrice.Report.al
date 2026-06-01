Report 25006506 "Suggest Nonstock Item Price"
{
    Caption = 'Suggest Nonstock Item Price';
    ProcessingOnly = true;

    dataset
    {
        dataitem(NonstockItem; "Nonstock Item")
        {
            RequestFilterFields = "Entry No.", "Vendor No.";
            column(ReportForNavId_7723; 7723)
            {
            }

            trigger OnAfterGetRecord()
            begin
                Window.Update(1, "Entry No.");
                SalesPriceWksh.Init;
                SalesPriceWksh.Validate(Type, SalesPriceWksh.Type::"Nonstock Item");
                SalesPriceWksh.Validate("Item No.", NonstockItem."Entry No.");
                SalesPriceWksh.Validate("Unit of Measure Code", NonstockItem."Unit of Measure");
                SalesPriceWksh."Current Unit Price" :=
                  ROUND(
                    CurrExchRate.ExchangeAmtLCYToFCY(
                      WorkDate, ToCurrency.Code,
                      NonstockItem."Unit Price",
                      CurrExchRate.ExchangeRate(
                        WorkDate, ToCurrency.Code)),
                    ToCurrency."Unit-Amount Rounding Precision");

                if SalesPriceWksh."Current Unit Price" > PriceLowerLimit then
                    SalesPriceWksh."New Unit Price" := SalesPriceWksh."Current Unit Price" * UnitPriceFactor;

                if RoundingMethod.Code <> '' then begin
                    RoundingMethod."Minimum Amount" := SalesPriceWksh."New Unit Price";
                    if RoundingMethod.Find('=<') then begin
                        SalesPriceWksh."New Unit Price" := SalesPriceWksh."New Unit Price" + RoundingMethod."Amount Added Before";
                        if RoundingMethod.Precision > 0 then
                            SalesPriceWksh."New Unit Price" :=
                              ROUND(
                                SalesPriceWksh."New Unit Price",
                                RoundingMethod.Precision, CopyStr('=><', RoundingMethod.Type + 1, 1));
                        SalesPriceWksh."New Unit Price" := SalesPriceWksh."New Unit Price" + RoundingMethod."Amount Added After";
                    end;
                end;

                SalesPriceWksh.CalcCurrentPrice(PriceAlreadyExists);

                if PriceAlreadyExists or CreateNewPrices then begin
                    SalesPriceWksh2 := SalesPriceWksh;
                    if SalesPriceWksh2.Find('=') then
                        SalesPriceWksh.Modify
                    else
                        SalesPriceWksh.Insert;
                end;
            end;

            trigger OnPreDataItem()
            begin
                Window.Open(Text000);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    group(CopytoSalesPriceWorksheet)
                    {
                        Caption = 'Copy to Sales Price Worksheet...';
                        field(ToSalesType; ToSalesType)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Sales Type';
                            OptionCaption = 'Customer,Customer Price Group,All Customers,Campaign';

                            trigger OnValidate()
                            begin
                                SalesCodeCtrlEnable := ToSalesType <> Tosalestype::"All Customers";
                                ToStartDateCtrlEnable := ToSalesType <> Tosalestype::Campaign;
                                ToEndDateCtrlEnable := ToSalesType <> Tosalestype::Campaign;

                                ToSalesCode := '';
                                ToStartDate := 0D;
                                ToEndDate := 0D;
                            end;
                        }
                        field(SalesCodeCtrl; ToSalesCode)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Sales Code';
                            Enabled = SalesCodeCtrlEnable;

                            trigger OnLookup(var Text: Text): Boolean
                            var
                                CustList: Page "Customer List";
                                CustPriceGrList: Page "Customer Price Groups";
                                CampaignList: Page "Campaign List";
                            begin
                                case ToSalesType of
                                    Tosalestype::Customer:
                                        begin
                                            CustList.LookupMode := true;
                                            CustList.SetRecord(ToCust);
                                            if CustList.RunModal = Action::LookupOK then begin
                                                CustList.GetRecord(ToCust);
                                                ToSalesCode := ToCust."No.";
                                            end;
                                        end;
                                    Tosalestype::"Customer Price Group":
                                        begin
                                            CustPriceGrList.LookupMode := true;
                                            CustPriceGrList.SetRecord(ToCustPriceGr);
                                            if CustPriceGrList.RunModal = Action::LookupOK then begin
                                                CustPriceGrList.GetRecord(ToCustPriceGr);
                                                ToSalesCode := ToCustPriceGr.Code;
                                            end;
                                        end;
                                    Tosalestype::Campaign:
                                        begin
                                            CampaignList.LookupMode := true;
                                            CampaignList.SetRecord(ToCampaign);
                                            if CampaignList.RunModal = Action::LookupOK then begin
                                                CampaignList.GetRecord(ToCampaign);
                                                ToSalesCode := ToCampaign."No.";
                                                ToStartDate := ToCampaign."Starting Date";
                                                ToEndDate := ToCampaign."Ending Date";
                                            end;
                                        end;
                                end;
                            end;

                            trigger OnValidate()
                            begin
                                ToSalesCodeOnAfterValidate;
                            end;
                        }
                        field(UnitofMeasureCode; ToUnitofMeasure.Code)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Unit of Measure Code';
                            TableRelation = "Unit of Measure";
                        }
                        field(CurrencyCode; ToCurrency.Code)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Currency Code';
                            TableRelation = Currency;
                        }
                        field(ToStartDateCtrl; ToStartDate)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Starting Date';
                            Enabled = ToStartDateCtrlEnable;
                        }
                        field(ToEndDateCtrl; ToEndDate)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Ending Date';
                            Enabled = ToEndDateCtrlEnable;
                        }
                    }
                    field(PriceLowerLimit; PriceLowerLimit)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Only Amounts Above';
                        DecimalPlaces = 2 : 5;
                    }
                    field(UnitPriceFactor; UnitPriceFactor)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Adjustment Factor';
                        DecimalPlaces = 0 : 5;
                        MinValue = 0;
                    }
                    field(RoundingMethod; RoundingMethod.Code)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Rounding Method';
                        TableRelation = "Rounding Method";
                    }
                    field(CreateNewPrices; CreateNewPrices)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Create New Prices';
                    }
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        RoundingMethod.SetRange(Code, RoundingMethod.Code);
        if ToCurrency.Code = '' then begin
            ToCurrency.InitRoundingPrecision;
        end else begin
            ToCurrency.Find;
            ToCurrency.TestField("Unit-Amount Rounding Precision");
        end;

        if (ToSalesCode = '') and (ToSalesType <> Tosalestype::"All Customers") then
            Error(Text002, NonstockSalesPrice.FieldCaption("Sales Code"));

        if ToUnitofMeasure.Code <> '' then
            ToUnitofMeasure.Find;
        SalesPriceWksh.Validate("Sales Type", ToSalesType);
        SalesPriceWksh.Validate("Sales Code", ToSalesCode);
        SalesPriceWksh.Validate("Currency Code", ToCurrency.Code);
        SalesPriceWksh.Validate("Starting Date", ToStartDate);
        SalesPriceWksh.Validate("Ending Date", ToEndDate);
        SalesPriceWksh."Unit of Measure Code" := ToUnitofMeasure.Code;

        case ToSalesType of
            Tosalestype::Customer:
                begin
                    ToCust."No." := ToSalesCode;
                    ToCust.Find;
                    SalesPriceWksh."Price Includes VAT" := ToCust."Prices Including VAT";
                    SalesPriceWksh."Allow Line Disc." := ToCust."Allow Line Disc.";
                end;
            Tosalestype::"Customer Price Group":
                begin
                    ToCustPriceGr.Code := ToSalesCode;
                    ToCustPriceGr.Find;
                    SalesPriceWksh."Price Includes VAT" := ToCustPriceGr."Price Includes VAT";
                    SalesPriceWksh."Allow Line Disc." := ToCustPriceGr."Allow Line Disc.";
                    SalesPriceWksh."Allow Invoice Disc." := ToCustPriceGr."Allow Invoice Disc.";
                end;
        end;
    end;

    var
        Text000: label 'Processing Nonstock Items  #1##########';
        RoundingMethod: Record "Rounding Method";
        NonstockSalesPrice: Record "Nonstock Item Price";
        SalesPriceWksh2: Record "Sales Price Worksheet";
        SalesPriceWksh: Record "Sales Price Worksheet";
        ToCust: Record Customer;
        ToCustPriceGr: Record "Customer Price Group";
        ToCampaign: Record Campaign;
        ToCurrency: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        ToUnitofMeasure: Record "Unit of Measure";
        ItemUnitOfMeasure: Record "Item Unit of Measure";
        UOMMgt: Codeunit "Unit of Measure Management";
        Window: Dialog;
        PriceAlreadyExists: Boolean;
        CreateNewPrices: Boolean;
        UnitPriceFactor: Decimal;
        PriceLowerLimit: Decimal;
        ToSalesType: Option Customer,"Customer Price Group","All Customers",Campaign;
        ToSalesCode: Code[20];
        ToStartDate: Date;
        ToEndDate: Date;
        Text002: label '%1 must be specified.';
        [InDataSet]
        SalesCodeCtrlEnable: Boolean;
        [InDataSet]
        ToStartDateCtrlEnable: Boolean;
        [InDataSet]
        ToEndDateCtrlEnable: Boolean;


    procedure InitializeRequest(NewToSalesType: Option; NewToSalesCode: Code[20]; NewToStartDateText: Date; NewToEndDateText: Date; NewToCurrCode: Code[10]; NewToUOMCode: Code[10])
    begin
        ToSalesType := NewToSalesType;
        ToSalesCode := NewToSalesCode;
        ToStartDate := NewToStartDateText;
        ToEndDate := NewToEndDateText;
        ToCurrency.Code := NewToCurrCode;
        ToUnitofMeasure.Code := NewToUOMCode;
    end;


    procedure ToSalesCodeOnAfterValidate()
    var
        Customer: Record Customer;
        CustomerPriceGroup: Record "Customer Price Group";
        Campaign: Record Campaign;
    begin
        if ToSalesType = Tosalestype::Campaign then begin
            if ToCampaign.Get(ToSalesCode) then begin
                ToStartDate := ToCampaign."Starting Date";
                ToEndDate := ToCampaign."Ending Date";
            end else begin
                ToStartDate := 0D;
                ToEndDate := 0D;
            end;
        end;
    end;
}

