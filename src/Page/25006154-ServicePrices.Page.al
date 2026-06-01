Page 25006154 "Service Prices"
{
    // 30.03.2014 Elva Baltic P1 #RX MMG7.00
    //   * Added field "Make Code"
    //   * Added field "Location Code"
    // 
    // 09.02.2010 EDMS P2
    //   * Opened field "Unit of Measure Code", "DMS Variable Field 25006800"

    ApplicationArea = Basic;
    Caption = 'Service Prices';
    DataCaptionExpression = GetCaption;
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Service Price";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(SalesTypeFilter; SalesTypeFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Type Filter';
                    OptionCaption = 'Customer,Customer Price Group,All Customers,Campaign,None';

                    trigger OnValidate()
                    begin
                        SalesTypeFilterOnAfterValidate;
                    end;
                }
                field(SalesCodeFilterCtrl; SalesCodeFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Code Filter';
                    Enabled = SalesCodeFilterCtrlEnable;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        if SalesTypeFilter = Salestypefilter::"All Customers" then exit;

                        case SalesTypeFilter of
                            Salestypefilter::Customer:
                                begin
                                    CustList.LookupMode := true;
                                    if CustList.RunModal = Action::LookupOK then
                                        Text := CustList.GetSelectionFilter
                                    else
                                        exit(false);
                                end;
                            Salestypefilter::"Customer Price Group":
                                begin
                                    CustPriceGrList.LookupMode := true;
                                    if CustPriceGrList.RunModal = Action::LookupOK then
                                        Text := CustPriceGrList.GetSelectionFilter
                                    else
                                        exit(false);
                                end;
                            Salestypefilter::Campaign:
                                begin
                                    CampaignList.LookupMode := true;
                                    if CampaignList.RunModal = Action::LookupOK then
                                        Text := CampaignList.GetSelectionFilter
                                    else
                                        exit(false);
                                end;
                        end;

                        exit(true);
                    end;

                    trigger OnValidate()
                    begin
                        SalesCodeFilterOnAfterValidate;
                    end;
                }
                field(TypeFilter; TypeFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Type Filter';
                    OptionCaption = 'Service Labor,Serv. Labor Pr. Group,External Service,None';

                    trigger OnValidate()
                    begin
                        TypeFilterOnAfterValidate;
                    end;
                }
                field(CodeFilterCtrl; CodeFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Code Filter';
                    Enabled = CodeFilterCtrlEnable;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        LaborPriceGroup: Record "Service Labor Price Group";
                        ExtServ: Record "External Service";
                    begin
                        case Rec.Type of
                            Rec.Type::Labor:
                                begin
                                    LaborList.LookupMode := true;
                                    if LaborList.RunModal = Action::LookupOK then
                                        Text := LaborList.GetSelectionFilter
                                    else
                                        exit(false);
                                end;
                            Rec.Type::"Labor Group":
                                begin
                                    LaborPriceGroupList.LookupMode := true;
                                    if LaborPriceGroupList.RunModal = Action::LookupOK then begin
                                        LaborPriceGroupList.GetRecord(LaborPriceGroup);
                                        Text := LaborPriceGroup."No."; //ItemFlowList.GetSelectionFilter
                                    end else
                                        exit(false);
                                end;
                            Rec.Type::"Ext.Serv.":
                                begin
                                    ExtServList.LookupMode := true;
                                    if ExtServList.RunModal = Action::LookupOK then begin
                                        ExtServList.GetRecord(ExtServ);
                                        Text := ExtServ."No.";
                                    end else
                                        exit(false)
                                end;
                        end;
                        exit(true);
                    end;

                    trigger OnValidate()
                    begin
                        CodeFilterOnAfterValidate;
                    end;
                }
                field(StartingDateFilter; StartingDateFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Starting Date Filter';

                    trigger OnValidate()
                    begin
                        StartingDateFilterOnAfterValid;
                    end;
                }
            }
            repeater(Control1101907000)
            {
                field(SalesType; Rec."Sales Type")
                {
                    ApplicationArea = Basic;
                    OptionCaption = 'Customer,Customer Price Group,All Customers,Campaign';
                }
                field(SalesCode; Rec."Sales Code")
                {
                    ApplicationArea = Basic;
                    Editable = SalesCodeEditable;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field("DMS Variable Field 25006800"; Rec."Variable Field 25006800")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006800Visibl;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                }
                field(Price; Rec.Price)
                {
                    ApplicationArea = Basic;
                }
                field(StartingDate; Rec."Starting Date")
                {
                    ApplicationArea = Basic;
                }
                field(EndingDate; Rec."Ending Date")
                {
                    ApplicationArea = Basic;
                }
                field(PriceIncludesVAT; Rec."Price Includes VAT")
                {
                    ApplicationArea = Basic;
                }
                field(AllowLineDisc; Rec."Allow Line Disc.")
                {
                    ApplicationArea = Basic;
                }
                field(AllowInvoiceDisc; Rec."Allow Invoice Disc.")
                {
                    ApplicationArea = Basic;
                }
                field(VATBusPostingGrPrice; Rec."VAT Bus. Posting Gr. (Price)")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Options)
            {
                Caption = 'Options';
                field(SalesCodeFilterCtrl3; CurrencyCodeFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Currency Code Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        CurrencyList.LookupMode := true;
                        if CurrencyList.RunModal = Action::LookupOK then
                            Text := CurrencyList.GetSelectionFilter
                        else
                            exit(false);

                        exit(true);
                    end;

                    trigger OnValidate()
                    begin
                        CurrencyCodeFilterOnAfterValid;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin
        CodeFilterCtrlEnable := true;
        SalesCodeFilterCtrlEnable := true;
        DMSVariableField25006800Visibl := true;
        SalesCodeEditable := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        GetRecFilters;
        SetRecFilters;

        //09.02.2010 EDMSB P2 >>
        fSetVariableFields;
        // 09.02.2010 EDMSB P2 <<
    end;

    var
        Cust: Record Customer;
        CustPriceGr: Record "Customer Price Group";
        Campaign: Record Campaign;
        Labor: Record "Service Labor";
        LaborGrp: Record "Service Labor Price Group";
        ExtServ: Record "External Service";
        CustList: Page "Customer List";
        CustPriceGrList: Page "Customer Price Groups";
        CampaignList: Page "Campaign List";
        LaborList: Page "Service Labor List";
        LaborPriceGroupList: Page "Service Labor Price Groups";
        ExtServList: Page "External Service List";
        CurrencyList: Page Currencies;
        SalesTypeFilter: Option Customer,"Customer Price Group","All Customers",Campaign,"None";
        SalesCodeFilter: Text[250];
        CodeFilter: Text[250];
        StartingDateFilter: Text[30];
        CurrencyCodeFilter: Text[250];
        Text000: label 'All Customers';
        TypeFilter: Option Labor,"Labor Group","Ext.Serv.","None";
        [InDataSet]
        SalesCodeEditable: Boolean;
        [InDataSet]
        DMSVariableField25006800Visibl: Boolean;
        [InDataSet]
        SalesCodeFilterCtrlEnable: Boolean;
        [InDataSet]
        CodeFilterCtrlEnable: Boolean;


    procedure GetRecFilters()
    var
        TmpCode: Text[250];
    begin
        if Rec.GetFilters <> '' then begin
            if Rec.GetFilter("Sales Type") <> '' then
                SalesTypeFilter := Rec."Sales Type"
            else
                SalesTypeFilter := Salestypefilter::None;

            if Rec.GetFilter(Type) <> '' then
                TypeFilter := Rec.Type
            else
                TypeFilter := Typefilter::None;

            SalesCodeFilter := Rec.GetFilter("Sales Code");
            CodeFilter := Rec.GetFilter(Code);
            CurrencyCodeFilter := Rec.GetFilter("Currency Code");
            Evaluate(StartingDateFilter, Rec.GetFilter("Starting Date"));
        end;
    end;


    procedure SetRecFilters()
    begin
        SalesCodeFilterCtrlEnable := true;
        CodeFilterCtrlEnable := true;

        if SalesTypeFilter <> Salestypefilter::None then
            Rec.SetRange("Sales Type", SalesTypeFilter)
        else
            Rec.SetRange("Sales Type");

        if SalesTypeFilter in [Salestypefilter::"All Customers", Salestypefilter::None] then begin
            SalesCodeFilterCtrlEnable := false;
            SalesCodeFilter := '';
        end;

        if SalesCodeFilter <> '' then
            Rec.SetFilter("Sales Code", SalesCodeFilter)
        else
            Rec.SetRange("Sales Code");

        if StartingDateFilter <> '' then
            Rec.SetFilter("Starting Date", StartingDateFilter)
        else
            Rec.SetRange("Starting Date");

        if TypeFilter <> Typefilter::None then
            Rec.SetRange(Type, TypeFilter)
        else
            Rec.SetRange(Type);

        if TypeFilter = Typefilter::None then begin
            CodeFilterCtrlEnable := false;
            CodeFilter := '';
        end;

        if CodeFilter <> '' then
            Rec.SetFilter(Code, CodeFilter)
        else
            Rec.SetRange(Code);

        if CurrencyCodeFilter <> '' then begin
            Rec.SetFilter("Currency Code", CurrencyCodeFilter);
        end else
            Rec.SetRange("Currency Code");

        CurrPage.Update(false);
    end;


    procedure GetCaption(): Text[250]
    var
        ObjTransl: Record "Object Translation";
        SourceTableName: Text[100];
        SalesSrcTableName: Text[100];
        Description: Text[250];
        ReturnText: Text[1000];
    begin
        GetRecFilters;
        SalesCodeEditable := Rec."Sales Type" <> Rec."sales type"::"All Customers";

        SourceTableName := '';
        case TypeFilter of
            Typefilter::Labor:
                begin
                    SourceTableName := ObjTransl.TranslateObject(ObjTransl."object type"::Table, 25006121);
                    Labor."No." := CodeFilter;
                end;
            Typefilter::"Labor Group":
                begin
                    SourceTableName := ObjTransl.TranslateObject(ObjTransl."object type"::Table, 25006158);
                    LaborGrp."No." := CodeFilter;
                end;
            Typefilter::"Ext.Serv.":
                begin
                    SourceTableName := ObjTransl.TranslateObject(ObjTransl."object type"::Table, 25006133);
                    ExtServ."No." := CodeFilter;
                end;
        end;

        SalesSrcTableName := '';
        case SalesTypeFilter of
            Salestypefilter::Customer:
                begin
                    SalesSrcTableName := ObjTransl.TranslateObject(ObjTransl."object type"::Table, 18);
                    Cust."No." := SalesCodeFilter;
                    if Cust.Find then
                        Description := Cust.Name;
                end;
            Salestypefilter::"Customer Price Group":
                begin
                    SalesSrcTableName := ObjTransl.TranslateObject(ObjTransl."object type"::Table, 6);
                    CustPriceGr.Code := SalesCodeFilter;
                    if CustPriceGr.Find then
                        Description := CustPriceGr.Description;
                end;
            Salestypefilter::Campaign:
                begin
                    SalesSrcTableName := ObjTransl.TranslateObject(ObjTransl."object type"::Table, 5071);
                    Campaign."No." := SalesCodeFilter;
                    if Campaign.Find then
                        Description := Campaign.Description;
                end;
            Salestypefilter::"All Customers":
                begin
                    SalesSrcTableName := Text000;
                    Description := '';
                end;
        end;

        if SalesSrcTableName = Text000 then begin
            if SalesSrcTableName <> '' then
                ReturnText := SalesSrcTableName;
            if SourceTableName <> '' then
                ReturnText += ' ' + SourceTableName;
            if CodeFilter <> '' then
                ReturnText += ' ' + CodeFilter;
        end else begin
            if SalesSrcTableName <> '' then
                ReturnText := SalesSrcTableName;
            if SalesCodeFilter <> '' then
                ReturnText += ' ' + SalesCodeFilter;
            if Description <> '' then
                ReturnText += ' ' + Description;
            if SourceTableName <> '' then
                ReturnText += ' ' + SourceTableName;
            if CodeFilter <> '' then
                ReturnText += ' ' + CodeFilter;
        end;

        exit(ReturnText);
    end;


    procedure fSetVariableFields()
    begin
        //Variable Fields
        DMSVariableField25006800Visibl := Rec.IsVFActive(Rec.FieldNo("Variable Field 25006800"));
    end;

    local procedure SalesCodeFilterOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;

    local procedure SalesTypeFilterOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        SalesCodeFilter := '';
        SetRecFilters;
    end;

    local procedure StartingDateFilterOnAfterValid()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;

    local procedure CodeFilterOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;

    local procedure TypeFilterOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        CodeFilter := '';
        SetRecFilters;
    end;

    local procedure CurrencyCodeFilterOnAfterValid()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        SalesCodeEditable := Rec."Sales Type" <> Rec."sales type"::"All Customers"
    end;
}

