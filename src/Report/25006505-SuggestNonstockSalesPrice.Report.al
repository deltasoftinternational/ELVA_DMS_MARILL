Report 25006505 "Suggest Nonstock Sales Price"
{
    Caption = 'Suggest Sales Price on Wksh.';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Nonstock Item Price"; "Nonstock Item Price")
        {
            DataItemTableView = sorting("Sales Type", "Sales Code", "Nonstock Item Entry No.", "Starting Date", "Currency Code", "Unit of Measure Code", "Minimum Quantity", "Location Code", "Ordering Price Type Code", "Document Profile");
            RequestFilterFields = "Sales Type", "Sales Code", "Nonstock Item Entry No.", "Currency Code", "Starting Date";
            column(ReportForNavId_8545; 8545)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if NonstockItem."Entry No." <> "Nonstock Item Entry No." then begin
                    NonstockItem.Get("Nonstock Item Entry No.");
                    Window.Update(1, "Nonstock Item Entry No.");
                end;

                ReplaceSalesCode := not (("Sales Type" = ToSalesType) and ("Sales Code" = ToSalesCode));

                if (ToSalesCode = '') and (ToSalesType <> Tosalestype::"All Customers") then
                    Error(Text002, "Sales Type");

                Clear(SalesPriceWksh);

                SalesPriceWksh.Validate("Sales Type", ToSalesType);
                if not ReplaceSalesCode then
                    SalesPriceWksh.Validate("Sales Code", "Sales Code")
                else
                    SalesPriceWksh.Validate("Sales Code", ToSalesCode);

                SalesPriceWksh.Validate(Type, SalesPriceWksh.Type::"Nonstock Item");
                SalesPriceWksh.Validate("Item No.", "Nonstock Item Entry No.");
                SalesPriceWksh."New Unit Price" := "Unit Price";
                SalesPriceWksh."Minimum Quantity" := "Minimum Quantity";
                SalesPriceWksh."Unit of Measure Code" := "Unit of Measure Code";
                SalesPriceWksh.Validate("Unit of Measure Code");
                SalesPriceWksh."Ordering Price Type Code" := "Ordering Price Type Code";
                SalesPriceWksh."Location Code" := "Location Code";

                if not ReplaceCurrency then
                    SalesPriceWksh."Currency Code" := "Currency Code"
                else
                    SalesPriceWksh."Currency Code" := ToCurrency.Code;

                if not ReplaceStartingDate then
                    SalesPriceWksh.Validate("Starting Date", "Starting Date")
                else
                    SalesPriceWksh.Validate("Starting Date", ToStartDate);

                if not ReplaceEndingDate then
                    SalesPriceWksh.Validate("Ending Date", "Ending Date")
                else
                    SalesPriceWksh.Validate("Ending Date", ToEndDate);

                if "Currency Code" <> SalesPriceWksh."Currency Code" then begin
                    if "Currency Code" <> '' then begin
                        FromCurrency.Get("Currency Code");
                        FromCurrency.TestField(Code);
                        SalesPriceWksh."New Unit Price" :=
                          CurrExchRate.ExchangeAmtFCYToLCY(
                            WorkDate, "Currency Code", SalesPriceWksh."New Unit Price",
                            CurrExchRate.ExchangeRate(
                              WorkDate, "Currency Code"));
                    end;
                    if SalesPriceWksh."Currency Code" <> '' then
                        SalesPriceWksh."New Unit Price" :=
                          CurrExchRate.ExchangeAmtLCYToFCY(
                            WorkDate, SalesPriceWksh."Currency Code",
                            SalesPriceWksh."New Unit Price", CurrExchRate.ExchangeRate(
                              WorkDate, SalesPriceWksh."Currency Code"));
                end;

                if SalesPriceWksh."Currency Code" = '' then
                    Currency2.InitRoundingPrecision
                else begin
                    Currency2.Get(SalesPriceWksh."Currency Code");
                    Currency2.TestField("Unit-Amount Rounding Precision");
                end;
                SalesPriceWksh."New Unit Price" :=
                  ROUND(SalesPriceWksh."New Unit Price", Currency2."Unit-Amount Rounding Precision");

                if SalesPriceWksh."New Unit Price" > PriceLowerLimit then
                    SalesPriceWksh."New Unit Price" := SalesPriceWksh."New Unit Price" * UnitPriceFactor;
                if RoundingMethod.Code <> '' then begin
                    RoundingMethod."Minimum Amount" := SalesPriceWksh."New Unit Price";
                    if RoundingMethod.Find('=<') then begin
                        SalesPriceWksh."New Unit Price" :=
                          SalesPriceWksh."New Unit Price" + RoundingMethod."Amount Added Before";
                        if RoundingMethod.Precision > 0 then
                            SalesPriceWksh."New Unit Price" :=
                              ROUND(
                                SalesPriceWksh."New Unit Price",
                                RoundingMethod.Precision, CopyStr('=><', RoundingMethod.Type + 1, 1));
                        SalesPriceWksh."New Unit Price" := SalesPriceWksh."New Unit Price" +
                          RoundingMethod."Amount Added After";
                    end;
                end;

                SalesPriceWksh."Price Includes VAT" := "Price Includes VAT";
                SalesPriceWksh."VAT Bus. Posting Gr. (Price)" := "VAT Bus. Posting Gr. (Price)";
                SalesPriceWksh."Allow Invoice Disc." := "Allow Invoice Disc.";
                SalesPriceWksh."Allow Line Disc." := "Allow Line Disc.";
                SalesPriceWksh.CalcCurrentPrice(PriceAlreadyExists);

                if PriceAlreadyExists or CreateNewPrices then begin
                    SalesPriceWksh2 := SalesPriceWksh;
                    if SalesPriceWksh2.Find('=') then
                        SalesPriceWksh.Modify(true)
                    else
                        SalesPriceWksh.Insert(true);
                end;
            end;

            trigger OnPreDataItem()
            begin
                Window.Open(Text001);
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
                                ToSalesCodeOnValidate;
                            end;
                        }
                        field(UnitofMeasureCode; ToUnitOfMeasure.Code)
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
        case ToSalesType of
            Tosalestype::Customer:
                begin
                    ToCust."No." := ToSalesCode;
                    if ToCust."No." <> '' then
                        ToCust.Find
                    else begin
                        if not ToCust.Find then
                            ToCust.Init;
                        ToSalesCode := ToCust."No.";
                    end;
                end;
            Tosalestype::"Customer Price Group":
                begin
                    ToCustPriceGr.Code := ToSalesCode;
                    if ToCustPriceGr.Code <> '' then
                        ToCustPriceGr.Find
                    else begin
                        if not ToCustPriceGr.Find then
                            ToCustPriceGr.Init;
                        ToSalesCode := ToCustPriceGr.Code;
                    end;
                end;
            Tosalestype::Campaign:
                begin
                    ToCampaign."No." := ToSalesCode;
                    if ToCampaign."No." <> '' then
                        ToCampaign.Find
                    else begin
                        if not ToCampaign.Find then
                            ToCampaign.Init;
                        ToSalesCode := ToCampaign."No.";
                    end;
                    ToStartDate := ToCampaign."Starting Date";
                    ToEndDate := ToCampaign."Ending Date";
                end;
        end;

        ReplaceUnitOfMeasure := ToUnitOfMeasure.Code <> '';
        ReplaceCurrency := ToCurrency.Code <> '';
        ReplaceStartingDate := ToStartDate <> 0D;
        ReplaceEndingDate := ToEndDate <> 0D;

        if ReplaceUnitOfMeasure and (ToUnitOfMeasure.Code <> '') then
            ToUnitOfMeasure.Find;

        RoundingMethod.SetRange(Code, RoundingMethod.Code);
    end;

    var
        Text001: label 'Processing Nonstock Items  #1##########';
        NonstockSalesPrice2: Record "Nonstock Item Price";
        SalesPriceWksh2: Record "Sales Price Worksheet";
        SalesPriceWksh: Record "Sales Price Worksheet";
        ToCust: Record Customer;
        ToCustPriceGr: Record "Customer Price Group";
        ToCampaign: Record Campaign;
        ToUnitOfMeasure: Record "Unit of Measure";
        ToCurrency: Record Currency;
        FromCurrency: Record Currency;
        Currency2: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        RoundingMethod: Record "Rounding Method";
        NonstockItem: Record "Nonstock Item";
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
        ReplaceSalesCode: Boolean;
        ReplaceUnitOfMeasure: Boolean;
        ReplaceCurrency: Boolean;
        ReplaceStartingDate: Boolean;
        ReplaceEndingDate: Boolean;
        Text002: label 'Sales Code must be specified when copying from %1 to All Customers.';
        [InDataSet]
        SalesCodeCtrlEnable: Boolean;
        [InDataSet]
        ToStartDateCtrlEnable: Boolean;
        [InDataSet]
        ToEndDateCtrlEnable: Boolean;


    procedure InitializeRequest(NewToSalesType: Option Customer,"Customer Price Group",Campaign,"All CUstomers"; NewToSalesCode: Code[20]; NewToStartDate: Date; NewToEndDate: Date; NewToCurrCode: Code[10]; NewToUOMCode: Code[10]; NewCreateNewPrices: Boolean)
    begin
        ToSalesType := NewToSalesType;
        ToSalesCode := NewToSalesCode;
        ToStartDate := NewToStartDate;
        ToEndDate := NewToEndDate;
        ToCurrency.Code := NewToCurrCode;
        ToUnitOfMeasure.Code := NewToUOMCode;
        CreateNewPrices := NewCreateNewPrices;
    end;


    procedure ToSalesCodeOnValidate()
    var
        Customer: Record Customer;
        CustomerPriceGroup: Record "Customer Price Group";
        Campaign: Record Campaign;
    begin
        if ToSalesType = Tosalestype::"All Customers" then exit;

        case ToSalesType of
            Tosalestype::Customer:
                Customer.Get(ToSalesCode);
            Tosalestype::"Customer Price Group":
                CustomerPriceGroup.Get(ToSalesCode);
            Tosalestype::Campaign:
                begin
                    Campaign.Get(ToSalesCode);
                    ToStartDate := Campaign."Starting Date";
                    ToEndDate := Campaign."Ending Date";
                end;
        end;
    end;
}

