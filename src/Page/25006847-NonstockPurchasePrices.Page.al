Page 25006847 "Nonstock Purchase Prices"
{
    Caption = 'Nonstock Item Purchase Prices';
    DataCaptionExpression = GetCaption;
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Nonstock Purchase Price";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(VendNoFilterCtrl; codVendNoFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vendor No. Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        VendList.LookupMode := true;
                        if VendList.RunModal = Action::LookupOK then
                            Text := VendList.GetSelectionFilter
                        else
                            exit(false);

                        exit(true);
                    end;

                    trigger OnValidate()
                    begin
                        codVendNoFilterOnAfterValidate;
                    end;
                }
                field(NonstockItemEntryNoFIlterCtrl; codNonstockItemEntryNoFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Nonstock Item Entry No. Filter';

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        NonstockItemList: Page "Catalog Item List";
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
                        codNonstockItemEntryNoFilterOn;
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
                field(VendorNo; Rec."Vendor No.")
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
                }
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field(MinimumQuantity; Rec."Minimum Quantity")
                {
                    ApplicationArea = Basic;
                }
                field(DirectUnitCost; Rec."Direct Unit Cost")
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
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        GetRecFilters;
        SetRecFilters;
    end;

    var
        codVendNoFilter: Code[30];
        codNonstockItemEntryNoFilter: Code[30];
        txtStartingDateFilter: Text[30];
        recVend: Record Vendor;
        VendList: Page "Vendor List";


    procedure GetRecFilters()
    begin
        if Rec.GetFilters <> '' then begin
            codVendNoFilter := Rec.GetFilter("Vendor No.");
            codNonstockItemEntryNoFilter := Rec.GetFilter("Nonstock Item Entry No.");
            Evaluate(txtStartingDateFilter, Rec.GetFilter("Starting Date"));
        end;
    end;


    procedure SetRecFilters()
    begin
        if codVendNoFilter <> '' then
            Rec.SetFilter("Vendor No.", codVendNoFilter)
        else
            Rec.SetRange("Vendor No.");

        if txtStartingDateFilter <> '' then
            Rec.SetFilter("Starting Date", txtStartingDateFilter)
        else
            Rec.SetRange("Starting Date");

        if codNonstockItemEntryNoFilter <> '' then begin
            Rec.SetFilter("Nonstock Item Entry No.", codNonstockItemEntryNoFilter);
        end else
            Rec.SetRange("Nonstock Item Entry No.");

        CurrPage.Update(false);
    end;


    procedure GetCaption(): Text[250]
    var
        ObjTransl: Record "Object Translation";
        SourceTableName: Text[100];
        Description: Text[250];
    begin
        GetRecFilters;

        if codNonstockItemEntryNoFilter <> '' then
            SourceTableName := ObjTransl.TranslateObject(ObjTransl."object type"::Table, 5718)
        else
            SourceTableName := '';

        recVend."No." := codVendNoFilter;
        if recVend.Find then
            Description := recVend.Name;

        exit(StrSubstNo('%1 %2 %3 %4 ', codVendNoFilter, Description, SourceTableName, codNonstockItemEntryNoFilter));
    end;

    local procedure codVendNoFilterOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;

    local procedure txtStartingDateFilterOnAfterVa()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;

    local procedure codNonstockItemEntryNoFilterOn()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;
}

