Report 25006026 "Suggest Sales Price From Prch."
{
    // 14.04.2014 Elva Baltic P7 #X MMG7.00
    //   * Report created

    ProcessingOnly = true;

    dataset
    {
        dataitem("Purch. Inv. Line"; "Purch. Inv. Line")
        {
            RequestFilterFields = "Document No.";
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            var
                PurchaseHeader: Record "Purch. Inv. Header";
                CurrExchRate: Record "Currency Exchange Rate";
                SalesPrice: Record "Sales Price";
            begin

                if Item."No." <> "No." then begin
                    if Item.Get("No.") then
                        Window.Update(1, "No.")
                    else
                        CurrReport.Skip;
                end;

                //ReplaceSalesCode := NOT (("Sales Type" = ToSalesType) AND ("Sales Code" = ToSalesCode));

                //IF (ToSalesCode = '') AND (ToSalesType <> ToSalesType::"All Customers") THEN
                //  ERROR(Text002,"Sales Type");

                Clear(SalesPriceWksh);
                //SalesPriceWksh.VALIDATE("Sales Type",ToSalesType);
                SalesPriceWksh.Validate("Sales Type", SalesPriceWksh."sales type"::"All Customers");

                //IF NOT ReplaceSalesCode THEN
                //  SalesPriceWksh.VALIDATE("Sales Code","Sales Code")
                //ELSE
                //  SalesPriceWksh.VALIDATE("Sales Code",ToSalesCode);


                SalesPriceWksh.Validate("Item No.", "No.");
                SalesPriceWksh.Validate(Type, SalesPriceWksh.Type::Item);


                //IF NOT ReplaceStartingDate THEN BEGIN
                //  IF NOT ReplaceEndingDate THEN
                //    SalesPriceWksh.VALIDATE("Starting Date",SalesPrice."Starting Date")
                //END ELSE
                //  SalesPriceWksh.VALIDATE("Starting Date",ToStartDate);

                //IF NOT ReplaceEndingDate THEN BEGIN
                //  IF NOT ReplaceStartingDate THEN
                //    SalesPriceWksh.VALIDATE("Ending Date",SalesPrice."Ending Date")
                //END ELSE
                //  SalesPriceWksh.VALIDATE("Ending Date",ToEndDate);
                SalesPriceWksh.Validate("Starting Date", ToStartDate);
                SalesPriceWksh.CalcCurrentPrice(PriceAlreadyExists);



                PurchaseHeader.Reset;
                PurchaseHeader.Get("Document No.");

                if PurchaseHeader."Currency Code" = '' then
                    SalesPriceWksh."Unit Cost" := "Direct Unit Cost"
                else
                    SalesPriceWksh."Unit Cost" :=
                     CurrExchRate.ExchangeAmtFCYToLCY(
                       WorkDate, PurchaseHeader."Currency Code", "Direct Unit Cost", PurchaseHeader."Currency Factor");

                SalesPrice.Reset;
                SalesPrice.SetRange("Item No.", "No.");
                SalesPrice.SetRange("Sales Type", SalesPrice."sales type"::"All Customers");
                SalesPrice.SetRange("Currency Code", '');
                SalesPrice.SetRange("Variant Code", '');
                SalesPrice.SetRange("Ordering Price Type Code", "Ordering Price Type Code");
                if SalesPrice.FindLast then begin
                    SalesPriceWksh."Current Unit Price" := SalesPrice."Unit Price";
                end;

                SalesPriceWksh."Minimum Quantity" := 0;

                SalesPriceWksh."Ordering Price Type Code" := "Ordering Price Type Code";

                //21.04.2014 Elva Baltic P1 #RX MMG7.00 -commented>>
                //SalesPriceWksh."Location Code" := "Location Code";
                //21.04.2014 Elva Baltic P1 #RX MMG7.00 <<

                SalesPriceWksh."Unit Profit (Current)" := SalesPriceWksh."Current Unit Price" - SalesPriceWksh."Unit Cost";
                if SalesPriceWksh."Current Unit Price" <> 0 then
                    SalesPriceWksh."Unit Profit % (Current)" :=
                       ROUND(SalesPriceWksh."Unit Profit (Current)" / SalesPriceWksh."Current Unit Price" * 100, 0.1)
                else
                    SalesPriceWksh."Unit Profit % (Current)" := 0;

                SalesPriceWksh."New Unit Price" := SalesPriceWksh."Current Unit Price";
                SalesPriceWksh."Unit Profit (New)" := SalesPriceWksh."Unit Profit (Current)";
                SalesPriceWksh."Unit Profit % (New)" := SalesPriceWksh."Unit Profit % (Current)";

                SalesPriceWksh."Price Includes VAT" := PurchaseHeader."Prices Including VAT";
                SalesPriceWksh."VAT Bus. Posting Gr. (Price)" := "Purch. Inv. Line"."VAT Bus. Posting Group";
                SalesPriceWksh."Allow Invoice Disc." := "Allow Invoice Disc.";
                //SalesPriceWksh."Allow Line Disc." := "Allow Line Disc.";

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
                        field(SalesType; ToSalesType)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Sales Type';
                            OptionCaption = 'Customer,Customer Price Group,All Customers,Campaign';
                            Visible = false;

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
                            Visible = false;

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
                        field(UnitOfMeasureCode; ToUnitOfMeasure.Code)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Unit of Measure Code';
                            TableRelation = "Unit of Measure";
                            Visible = false;

                            trigger OnValidate()
                            begin
                                if ToUnitOfMeasure.Code <> '' then
                                    ToUnitOfMeasure.Find;
                            end;
                        }
                        field(CurrencyCode; ToCurrency.Code)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Currency Code';
                            TableRelation = Currency;
                            Visible = false;

                            trigger OnValidate()
                            begin
                                if ToCurrency.Code <> '' then
                                    ToCurrency.Find;
                            end;
                        }
                        field(ToStartDateCtrl; ToStartDate)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Starting Date';
                            Enabled = true;
                        }
                        field(ToEndDateCtrl; ToEndDate)
                        {
                            ApplicationArea = Basic;
                            Caption = 'Ending Date';
                            Visible = false;
                        }
                    }
                    field(OnlyPricesAbove; PriceLowerLimit)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Only Prices Above';
                        DecimalPlaces = 2 : 5;
                        Visible = false;
                    }
                    field(AdjustmentFactor; UnitPriceFactor)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Adjustment Factor';
                        DecimalPlaces = 0 : 5;
                        MinValue = 0;
                        Visible = false;
                    }
                    field(RoundingMethodCtrl; RoundingMethod.Code)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Rounding Method';
                        TableRelation = "Rounding Method";
                        Visible = false;
                    }
                    field(CreateNewPrices; CreateNewPrices)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Create New Prices';
                        Visible = false;
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

    trigger OnInitReport()
    begin
        ToStartDate := Today;
    end;

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
        CreateNewPrices := true;
    end;

    var
        SalesPriceWksh2: Record "Sales Price Worksheet";
        SalesPriceWksh: Record "Sales Price Worksheet";
        ToCust: Record Customer;
        ToCustPriceGr: Record "Customer Price Group";
        ToCampaign: Record Campaign;
        ToUnitOfMeasure: Record "Unit of Measure";
        ItemUnitOfMeasure: Record "Item Unit of Measure";
        ToCurrency: Record Currency;
        FromCurrency: Record Currency;
        Currency2: Record Currency;
        CurrExchRate: Record "Currency Exchange Rate";
        RoundingMethod: Record "Rounding Method";
        Item: Record Item;
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
        [InDataSet]
        SalesCodeCtrlEnable: Boolean;
        [InDataSet]
        ToStartDateCtrlEnable: Boolean;
        [InDataSet]
        ToEndDateCtrlEnable: Boolean;
        Text001: label 'Processing items  #1##########';
        Text002: label 'Sales Code must be specified when copying from %1 to All Customers.';


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


    procedure InitializeRequest2(NewToSalesType: Option Customer,"Customer Price Group",Campaign,"All CUstomers"; NewToSalesCode: Code[20]; NewToStartDate: Date; NewToEndDate: Date; NewToCurrCode: Code[10]; NewToUOMCode: Code[10]; NewCreateNewPrices: Boolean; NewPriceLowerLimit: Decimal; NewUnitPriceFactor: Decimal; NewRoundingMethodCode: Code[10])
    begin
        InitializeRequest(NewToSalesType, NewToSalesCode, NewToStartDate, NewToEndDate, NewToCurrCode, NewToUOMCode, NewCreateNewPrices);
        PriceLowerLimit := NewPriceLowerLimit;
        UnitPriceFactor := NewUnitPriceFactor;
        RoundingMethod.Code := NewRoundingMethodCode;
    end;


    procedure ToSalesCodeOnAfterValidate()
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

