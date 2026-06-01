Page 25006056 "Contract Sales Prices"
{
    // 08.03.2010 EDMSB P2
    //   * Opened field Type

    Caption = 'Contract Sales Prices';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Contract Sales Price";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(SalesCodeFilterCtrl; ContractFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract Filter';

                    trigger OnValidate()
                    begin
                        ContractFilterOnAfterValidate;
                    end;
                }
                field(ItemNoFilterCtrl; ItemNoFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Item No. Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        ItemList: Page "Item List";
                    begin
                        ItemList.LookupMode := true;
                        if ItemList.RunModal = Action::LookupOK then
                            Text := ItemList.GetSelectionFilter
                        else
                            exit(false);

                        exit(true);
                    end;

                    trigger OnValidate()
                    begin
                        ItemNoFilterOnAfterValidate;
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
            repeater(Control1190002)
            {
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
                field(MinimumQuantity; Rec."Minimum Quantity")
                {
                    ApplicationArea = Basic;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(OrderingPriceTypeCode; Rec."Ordering Price Type Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
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
                field(UnitPrice; Rec."Unit Price")
                {
                    ApplicationArea = Basic;
                }
                field(PriceIncludesVAT; Rec."Price Includes VAT")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(AllowInvoiceDisc; Rec."Allow Invoice Disc.")
                {
                    ApplicationArea = Basic;
                }
                field(AllowLineDisc; Rec."Allow Line Disc.")
                {
                    ApplicationArea = Basic;
                }
                field(VATBusPostingGrPrice; Rec."VAT Bus. Posting Gr. (Price)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VIN; Rec.VIN)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
            group(Options)
            {
                Caption = 'Options';
                field(SalesCodeFilterCtrlEDMS; CurrencyCodeFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Currency Code Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        CurrencyList: Page Currencies;
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

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec."Contract Type" := Rec."contract type"::Contract;
    end;

    trigger OnOpenPage()
    begin
        GetRecFilters;
        SetRecFilters;
    end;

    var
        ContractFilter: Text[250];
        ItemNoFilter: Text[250];
        StartingDateFilter: Text[30];
        CurrencyCodeFilter: Text[250];


    procedure GetRecFilters()
    begin
        if Rec.GetFilters <> '' then begin
            ContractFilter := Rec.GetFilter("Contract No.");
            ItemNoFilter := Rec.GetFilter(Code);
            CurrencyCodeFilter := Rec.GetFilter("Currency Code");
        end;

        Evaluate(StartingDateFilter, Rec.GetFilter("Starting Date"));
    end;


    procedure SetRecFilters()
    begin
        if ContractFilter <> '' then
            Rec.SetFilter("Contract No.", ContractFilter)
        else
            Rec.SetRange("Contract No.");

        if StartingDateFilter <> '' then
            Rec.SetFilter("Starting Date", StartingDateFilter)
        else
            Rec.SetRange("Starting Date");

        if ItemNoFilter <> '' then begin
            Rec.SetFilter(Code, ItemNoFilter);
        end else
            Rec.SetRange(Code);

        if CurrencyCodeFilter <> '' then begin
            Rec.SetFilter("Currency Code", CurrencyCodeFilter);
        end else
            Rec.SetRange("Currency Code");

        CurrPage.Update(false);
    end;

    local procedure StartingDateFilterOnAfterValid()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;

    local procedure ItemNoFilterOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;

    local procedure ContractFilterOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;

    local procedure CurrencyCodeFilterOnAfterValid()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;
}

