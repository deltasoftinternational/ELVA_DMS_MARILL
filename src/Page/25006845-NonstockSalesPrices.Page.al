Page 25006845 "Nonstock Sales Prices"
{
    // 13.08.2004 EDMS P1
    //  * Opened field "Location Code"

    Caption = 'Nonstock Item Sales Prices';
    DataCaptionExpression = GetCaption;
    DelayedInsert = true;
    PageType = List;
    SaveValues = true;
    SourceTable = "Nonstock Item Price";

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
                field(NonstockItemEntryNoFilterCtrl; txtNonstockItemEntryFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Nonstock Item Entry No Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        NonstockItemList: Page "Catalog Item List";
                        recNonstockItem: Record "Nonstock Item";
                    begin
                        NonstockItemList.LookupMode := true;
                        if NonstockItemList.RunModal = Action::LookupOK then
                            Text := NonstockItemList.GetSelectionFilter
                        else
                            exit(false);

                        exit(true);
                    end;

                    trigger OnValidate()
                    begin
                        txtNonstockItemEntryFilterOnAf;
                    end;
                }
                field(txtStartingDateFilter; txtStartingDateFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Starting Date Filter';

                    trigger OnValidate()
                    begin
                        txtStartingDateFilterOnAfterVa;
                    end;
                }
            }
            repeater(Control1)
            {
                field(SalesType; Rec."Sales Type")
                {
                    ApplicationArea = Basic;
                }
                field(SalesCode; Rec."Sales Code")
                {
                    ApplicationArea = Basic;
                }
                field(NonstockItemEntryNo; Rec."Nonstock Item Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(OrderingPriceTypeCode; Rec."Ordering Price Type Code")
                {
                    ApplicationArea = Basic;
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field(MinimumQuantity; Rec."Minimum Quantity")
                {
                    ApplicationArea = Basic;
                }
                field(UnitPrice; Rec."Unit Price")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentProfile; Rec."Document Profile")
                {
                    ApplicationArea = Basic;
                    OptionCaption = ' ,Spare Parts Trade,,Service';
                    Visible = false;
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
                    Visible = false;
                }
                field(AllowLineDisc; Rec."Allow Line Disc.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(AllowInvoiceDisc; Rec."Allow Invoice Disc.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VATBusPostingGrPrice; Rec."VAT Bus. Posting Gr. (Price)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
            group(Options)
            {
                Caption = 'Options';
                field(SalesCodeFilterCtrl2; txtCurrencyCodeFilter)
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
                        txtCurrencyCodeFilterOnAfterVa;
                    end;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        SalesCodeFilterCtrlEnable := true;
    end;

    trigger OnOpenPage()
    begin
        GetRecFilters;
        SetRecFilters;
    end;

    var
        SalesTypeFilter: Option Customer,"Customer Price Group","All Customers",Campaign,"None";
        SalesCodeFilter: Text[250];
        txtNonstockItemEntryFilter: Text[250];
        txtStartingDateFilter: Text[30];
        txtCurrencyCodeFilter: Text[250];
        [InDataSet]
        SalesCodeFilterCtrlEnable: Boolean;
        CustList: Page "Customer List";
        CustPriceGrList: Page "Customer Price Groups";
        CampaignList: Page "Campaign List";
        CurrencyList: Page Currencies;


    procedure GetRecFilters()
    begin
        if Rec.GetFilters <> '' then begin
            if Rec.GetFilter("Sales Type") <> '' then
                SalesTypeFilter := Rec."Sales Type"
            else
                SalesTypeFilter := Salestypefilter::None;

            SalesCodeFilter := Rec.GetFilter("Sales Code");
            txtNonstockItemEntryFilter := Rec.GetFilter("Nonstock Item Entry No.");
            txtCurrencyCodeFilter := Rec.GetFilter("Currency Code");
        end;

        Evaluate(txtStartingDateFilter, Rec.GetFilter("Starting Date"));
    end;


    procedure SetRecFilters()
    begin
        SalesCodeFilterCtrlEnable := true;

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

        if txtStartingDateFilter <> '' then
            Rec.SetFilter("Starting Date", txtStartingDateFilter)
        else
            Rec.SetRange("Starting Date");

        if txtNonstockItemEntryFilter <> '' then begin
            Rec.SetFilter("Nonstock Item Entry No.", txtNonstockItemEntryFilter);
        end else
            Rec.SetRange("Nonstock Item Entry No.");

        if txtCurrencyCodeFilter <> '' then begin
            Rec.SetFilter("Currency Code", txtCurrencyCodeFilter);
        end else
            Rec.SetRange("Currency Code");

        CurrPage.Update(false);
    end;


    procedure GetCaption(): Text[250]
    var
        recObjTransl: Record "Object Translation";
        txtSourceTableName: Text[100];
        txtDescription: Text[250];
    begin
        GetRecFilters;

        txtSourceTableName := '';
        if txtNonstockItemEntryFilter <> '' then
            txtSourceTableName := recObjTransl.TranslateObject(recObjTransl."object type"::Table, 5718);

        exit(StrSubstNo('%1 %2', txtSourceTableName, txtNonstockItemEntryFilter));
    end;

    local procedure txtStartingDateFilterOnAfterVa()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;

    local procedure txtNonstockItemEntryFilterOnAf()
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

    local procedure SalesCodeFilterOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;

    local procedure txtCurrencyCodeFilterOnAfterVa()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;
}

