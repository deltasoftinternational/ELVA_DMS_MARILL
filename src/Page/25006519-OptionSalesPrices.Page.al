Page 25006519 "Option Sales Prices"
{
    Caption = 'Option Sales Prices';
    DataCaptionExpression = GetCaption;
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Option Sales Price";

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
                                    CustDiscGrList.LookupMode := true;
                                    if CustDiscGrList.RunModal = Action::LookupOK then
                                        Text := CustDiscGrList.GetSelectionFilter
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
                field(ItemTypeFilter; ItemTypeFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Option Type Filter';
                    Editable = true;
                    OptionCaption = 'Manufacturer Option,Own Option,None';

                    trigger OnValidate()
                    begin
                        ItemTypeFilterOnAfterValidate;
                    end;
                }
                field(CodeFilterCtrl; CodeFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Option Code Filter';
                    Enabled = CodeFilterCtrlEnable;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        case Rec."Option Type" of
                            Rec."option type"::"Manufacturer Option":
                                begin
                                    frmManOptions.LookupMode := true;
                                    if frmManOptions.RunModal = Action::LookupOK then begin
                                        Text := frmManOptions.GetSelectionFilter;
                                    end else
                                        exit(false);
                                end;
                            Rec."option type"::"Own Option":
                                begin
                                    frmOwnOptions.LookupMode := true;
                                    if frmOwnOptions.RunModal = Action::LookupOK then
                                        Text := frmOwnOptions.GetSelectionFilter
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
                field(OptionType; Rec."Option Type")
                {
                    ApplicationArea = Basic;
                }
                field(OptionSubtype; Rec."Option Subtype")
                {
                    ApplicationArea = Basic;
                }
                field(OptionCode; Rec."Option Code")
                {
                    ApplicationArea = Basic;
                }
                field(UnitPrice; Rec."Unit Price")
                {
                    ApplicationArea = Basic;
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field(PriceIncludesVAT; Rec."Price Includes VAT")
                {
                    ApplicationArea = Basic;
                }
                field(VATBusPostingGrPrice; Rec."VAT Bus. Posting Gr. (Price)")
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
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ModelCode; Rec."Model Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ModelVersionNo; Rec."Model Version No.")
                {
                    ApplicationArea = Basic;
                    Editable = ModelVersionNoEditable;
                    Visible = false;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    begin
        SetFieldsEditable;
    end;

    trigger OnInit()
    begin
        CodeFilterCtrlEnable := true;
        SalesCodeFilterCtrlEnable := true;
        ModelVersionNoEditable := true;
        SalesCodeEditable := true;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        SetFieldsEditable;
        Rec."Option Code" := Rec.GetFilter("Option Code");
        if Evaluate(Rec."Option SubType", Rec.GetFilter("Option SubType")) then;
        if Evaluate(Rec."Option Type", Rec.GetFilter("Option Type")) then;

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
        CustList: Page "Customer List";
        CustDiscGrList: Page "Customer Disc. Groups";
        CampaignList: Page "Campaign List";
        frmManOptions: Page "Manufacturer Options";
        frmOwnOptions: Page "Own Options";
        SalesTypeFilter: Option Customer,"Customer Discount Group","All Customers",Campaign,"None";
        SalesCodeFilter: Text[250];
        ItemTypeFilter: Option "Manufacturer Option","Own Option","None";
        OptionSubType: Option "Option","Color","Upholstery","None";
        CodeFilter: Text[250];
        StartingDateFilter: Text[30];
        Text000: label 'All Customers';
        [InDataSet]
        SalesCodeEditable: Boolean;
        [InDataSet]
        ModelVersionNoEditable: Boolean;
        [InDataSet]
        SalesCodeFilterCtrlEnable: Boolean;
        [InDataSet]
        CodeFilterCtrlEnable: Boolean;


    /*procedure GetRecFilters()
    begin
        if Rec.GetFilters <> '' then begin
            if Rec.GetFilter("Sales Type") <> '' then begin
                if Evaluate(SalesTypeFilter, Rec.GetFilter("Sales Type")) then;
            end else
                SalesTypeFilter := Salestypefilter::None;

            if Rec.GetFilter("Option Type") <> '' then begin
                if Evaluate(ItemTypeFilter, Rec.GetFilter("Option Type")) then;
            end else
                ItemTypeFilter := Itemtypefilter::None;

            if Rec.GetFilter("Option SubType") <> '' then begin
                if Evaluate(OptionSubType, Rec.GetFilter("Option SubType")) then;
            end else
                OptionSubType := OptionSubType::None;

            SalesCodeFilter := Rec.GetFilter("Sales Code");
            CodeFilter := Rec.GetFilter("Option Code");
            Evaluate(StartingDateFilter, Rec.GetFilter("Starting Date"));
        end;
    end;*/


    procedure GetRecFilters()
    begin
        if Rec.GetFilters <> '' then begin
            if Rec.GetFilter("Sales Type") <> '' then
                SalesTypeFilter := Rec."Sales Type"
            else
                SalesTypeFilter := Salestypefilter::None;

            if Rec.GetFilter("Option Type") <> '' then
                ItemTypeFilter := Rec."Option Type"
            else
                ItemTypeFilter := Itemtypefilter::None;

            SalesCodeFilter := Rec.GetFilter("Sales Code");
            CodeFilter := Rec.GetFilter("Option Code");
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
        //SetRange("Sales Type", "Sales Type"::Customer);
        //if SalesTypeFilter in [Salestypefilter::"All Customers", Salestypefilter::None] then begin
        //    SalesCodeFilterCtrlEnable := false;
        //    SalesCodeFilter := '';
        //end;

        if SalesCodeFilter <> '' then
            Rec.SetFilter("Sales Code", SalesCodeFilter)
        else
            Rec.SetRange("Sales Code");

        if ItemTypeFilter <> Itemtypefilter::None then
            Rec.SetRange("Option Type", ItemTypeFilter)
        else
            Rec.SetRange("Option Type");

        if OptionSubType <> OptionSubType::None then
            Rec.SetRange("Option SubType", OptionSubType)
        else
            Rec.SetRange("Option SubType");

        //if ItemTypeFilter = Itemtypefilter::None then begin
        //    CodeFilterCtrlEnable := false;
        //    CodeFilter := '';
        //end;

        if CodeFilter <> '' then begin
            Rec.SetFilter("Option Code", CodeFilter);
        end else
            Rec.SetRange("Option Code");

        if StartingDateFilter <> '' then
            Rec.SetFilter("Starting Date", StartingDateFilter)
        else
            Rec.SetRange("Starting Date");

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
        ModelVersionNoEditable := Rec."Option Type" <> Rec."option type"::"Own Option";

        SourceTableName := '';
        case ItemTypeFilter of
            Itemtypefilter::"Manufacturer Option":
                begin
                    SourceTableName := ObjTransl.TranslateObject(ObjTransl."object type"::Table, 25006370);
                    //Item."No." := CodeFilter;
                end;
            Itemtypefilter::"Own Option":
                begin
                    SourceTableName := ObjTransl.TranslateObject(ObjTransl."object type"::Table, 25006372);
                    //ItemDiscGr.Code := CodeFilter;
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

    local procedure ItemTypeFilterOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        CodeFilter := '';
        SetRecFilters;
    end;

    local procedure CodeFilterOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;

    local procedure SetFieldsEditable()
    begin
        //xRec := Rec;
        SalesCodeEditable := Rec."Sales Type" <> Rec."sales type"::"All Customers";
        ModelVersionNoEditable := Rec."Option Type" <> Rec."option type"::"Own Option";
    end;
}

