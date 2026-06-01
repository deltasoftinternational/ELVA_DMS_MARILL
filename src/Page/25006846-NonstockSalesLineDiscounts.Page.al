Page 25006846 "Nonstock Sales Line Discounts"
{
    Caption = 'Nonstock Item Sales Line Discounts';
    DataCaptionExpression = GetCaption;
    DelayedInsert = true;
    PageType = List;
    SaveValues = true;
    SourceTable = "Nonstock Sales Line Discount";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
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
                    var
                        ApplicationMgt: Codeunit DocumentManagementDMS;
                    begin
                        if ApplicationMgt.MakeDateFilter(txtStartingDateFilter) = 0 then;
                        txtStartingDateFilterOnAfterVa;
                    end;
                }
                field(SalesCodeFilterCtrl; txtCurrencyCodeFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Currency Code Filter';
                    Enabled = SalesCodeFilterCtrlEnable;

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
                field(LineDiscount; Rec."Line Discount %")
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
        txtStartingDateFilter: Text[30];
        txtCurrencyCodeFilter: Text[250];
        recNonstockItem: Record "Nonstock Item";
        txtNonstockItemEntryFilter: Text[250];
        [InDataSet]
        SalesCodeFilterCtrlEnable: Boolean;
        CurrencyList: Page Currencies;


    procedure GetRecFilters()
    begin
        if Rec.GetFilters <> '' then begin
            txtNonstockItemEntryFilter := Rec.GetFilter("Nonstock Item Entry No.");
            txtCurrencyCodeFilter := Rec.GetFilter("Currency Code");
            Evaluate(txtStartingDateFilter, Rec.GetFilter("Starting Date"));
        end;
    end;


    procedure SetRecFilters()
    begin
        SalesCodeFilterCtrlEnable := true;


        if txtCurrencyCodeFilter <> '' then begin
            Rec.SetFilter("Currency Code", txtCurrencyCodeFilter);
        end else
            Rec.SetRange("Currency Code");

        if txtNonstockItemEntryFilter <> '' then begin
            Rec.SetFilter("Nonstock Item Entry No.", txtNonstockItemEntryFilter);
        end else
            Rec.SetRange("Nonstock Item Entry No.");


        if txtStartingDateFilter <> '' then
            Rec.SetFilter("Starting Date", txtStartingDateFilter)
        else
            Rec.SetRange("Starting Date");

        CurrPage.Update(false);
    end;


    procedure GetCaption(): Text[250]
    var
        recObjTransl: Record "Object Translation";
        txtSourceTableName: Text[100];
        txtSalesSrcTableName: Text[100];
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

    local procedure txtCurrencyCodeFilterOnAfterVa()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;

    local procedure txtNonstockItemEntryFilterOnAf()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;
}

