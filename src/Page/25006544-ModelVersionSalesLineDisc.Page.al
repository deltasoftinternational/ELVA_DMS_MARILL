Page 25006544 "Model Version Sales Line Disc."
{
    Caption = 'Model Version Sales Line Discounts';
    DataCaptionExpression = GetCaption;
    DelayedInsert = true;
    PageType = List;
    SaveValues = true;
    SourceTable = "Sales Line Discount";

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
                    OptionCaption = 'Customer,Customer Discount Group,All Customers,Campaign,None';

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
                            Salestypefilter::"Customer Discount Group":
                                begin
                                    CustdiscGrList.LookupMode := true;
                                    if CustdiscGrList.RunModal = Action::LookupOK then
                                        Text := CustdiscGrList.GetSelectionFilter
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
                field(CodeFilterCtrl; CodeFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Code Filter';
                    Enabled = CodeFilterCtrlEnable;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        case Rec.Type of
                            Rec.Type::Item:
                                begin
                                    ItemList.LookupMode := true;
                                    if ItemList.RunModal = Action::LookupOK then
                                        Text := ItemList.GetSelectionFilter
                                    else
                                        exit(false);
                                end;
                            Rec.Type::"Item Disc. Group":
                                begin
                                    ItemDiscGrList.LookupMode := true;
                                    if ItemDiscGrList.RunModal = Action::LookupOK then
                                        Text := ItemDiscGrList.GetSelectionFilter
                                    else
                                        exit(false);
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
                    var
                        ApplicationMgt: Codeunit DocumentManagementDMS;
                    begin
                        if ApplicationMgt.MakeDateFilter(StartingDateFilter) = 0 then;
                        StartingDateFilterOnAfterValid;
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
                    Editable = SalesCodeEditable;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    OptionCaption = 'Model Version No.';
                }
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                }
                field(ModelCode; Rec."Model Code")
                {
                    ApplicationArea = Basic;
                }
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    Caption = 'Model Version No.';
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field(ModelVersionNo; Rec."Model Version No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VehicleStatusCode; Rec."Vehicle Status Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
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
                    OptionCaption = ' ,,Vehicles Trade';
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
            group(Options)
            {
                Caption = 'Options';
                field(SalesCodeFilterCtrl1; CurrencyCodeFilter)
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
    end;

    var
        Cust: Record Customer;
        CustDiscGr: Record "Customer Discount Group";
        Campaign: Record Campaign;
        Item: Record Item;
        ItemDiscGr: Record "Item Discount Group";
        ItemList: Page "Item List";
        CustList: Page "Customer List";
        CustdiscGrList: Page "Customer Disc. Groups";
        CampaignList: Page "Campaign List";
        CurrencyList: Page Currencies;
        ItemDiscGrList: Page "Item Disc. Groups";
        SalesTypeFilter: Option Customer,"Customer Discount Group","All Customers",Campaign,"None";
        SalesCodeFilter: Text[250];
        ItemTypeFilter: Option Item,"Item Discount Group","None";
        CodeFilter: Text[250];
        StartingDateFilter: Text[30];
        Text000: label 'All Customers';
        CurrencyCodeFilter: Text[250];
        [InDataSet]
        SalesCodeEditable: Boolean;
        [InDataSet]
        SalesCodeFilterCtrlEnable: Boolean;
        [InDataSet]
        CodeFilterCtrlEnable: Boolean;


    procedure GetRecFilters()
    begin
        if Rec.GetFilters <> '' then begin
            if Rec.GetFilter("Sales Type") <> '' then
                SalesTypeFilter := Rec."Sales Type"
            else
                SalesTypeFilter := Salestypefilter::None;

            if Rec.GetFilter(Type) <> '' then
                ItemTypeFilter := Rec.Type
            else
                ItemTypeFilter := Itemtypefilter::None;

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

        if ItemTypeFilter <> Itemtypefilter::None then
            Rec.SetRange(Type, ItemTypeFilter)
        else
            Rec.SetRange(Type);

        if ItemTypeFilter = Itemtypefilter::None then begin
            CodeFilterCtrlEnable := false;
            CodeFilter := '';
        end;

        if CodeFilter <> '' then begin
            Rec.SetFilter(Code, CodeFilter);
        end else
            Rec.SetRange(Code);

        if CurrencyCodeFilter <> '' then begin
            Rec.SetFilter("Currency Code", CurrencyCodeFilter);
        end else
            Rec.SetRange("Currency Code");

        if StartingDateFilter <> '' then
            Rec.SetFilter("Starting Date", StartingDateFilter)
        else
            Rec.SetRange("Starting Date");

        Rec.SetRange("Document Profile", Rec."document profile"::"Vehicles Trade");

        CurrPage.Update(false);
    end;


    procedure GetCaption(): Text[250]
    var
        ObjTransl: Record "Object Translation";
        SourceTableName: Text[100];
        SalesSrcTableName: Text[100];
        Description: Text[250];
    begin
        GetRecFilters;
        SalesCodeEditable := Rec."Sales Type" <> Rec."sales type"::"All Customers";

        SourceTableName := '';
        case ItemTypeFilter of
            Itemtypefilter::Item:
                begin
                    SourceTableName := ObjTransl.TranslateObject(ObjTransl."object type"::Table, 27);
                    Item."No." := CodeFilter;
                end;
            Itemtypefilter::"Item Discount Group":
                begin
                    SourceTableName := ObjTransl.TranslateObject(ObjTransl."object type"::Table, 341);
                    ItemDiscGr.Code := CodeFilter;
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
            Salestypefilter::"Customer Discount Group":
                begin
                    SalesSrcTableName := ObjTransl.TranslateObject(ObjTransl."object type"::Table, 340);
                    CustDiscGr.Code := SalesCodeFilter;
                    if CustDiscGr.Find then
                        Description := CustDiscGr.Description;
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

        if SalesSrcTableName = Text000 then
            exit(StrSubstNo('%1 %2 %3 %4 %5', SalesSrcTableName, SalesCodeFilter, Description, SourceTableName, CodeFilter));
        exit(StrSubstNo('%1 %2 %3 %4 %5', SalesSrcTableName, SalesCodeFilter, Description, SourceTableName, CodeFilter));
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

    local procedure CurrencyCodeFilterOnAfterValid()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        SalesCodeEditable := Rec."Sales Type" <> Rec."sales type"::"All Customers";
    end;
}

