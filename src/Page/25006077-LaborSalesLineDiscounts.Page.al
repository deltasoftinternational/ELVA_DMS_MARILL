Page 25006077 "Labor Sales Line Discounts"
{
    Caption = 'Labor Sales Line Discounts';
    DataCaptionExpression = GetCaption;
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Labor Sales Line Discount";

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
                    OptionCaption = 'Customer,Customer Disc. Group,All Customers,Campaign,Contract,Assembly,Serv. Package,None';

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
                    var
                        CustList: Page "Customer List";
                        CustDiscGrList: Page "Customer Disc. Groups";
                        CampaignList: Page "Campaign List";
                        ServicePackageList: Page "Service Package List";
                    begin
                        if SalesTypeFilter = Salestypefilter::"All Customers" then
                            exit;

                        case SalesTypeFilter of
                            Salestypefilter::Customer:
                                begin
                                    CustList.LookupMode := true;
                                    if CustList.RunModal = Action::LookupOK then
                                        Text := CustList.GetSelectionFilter
                                    else
                                        exit(false);
                                end;
                            Salestypefilter::"Customer Disc. Group":
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
                            Salestypefilter::"Serv. Package":  //14.01.2014 EDMS P8
                                begin
                                    ServicePackageList.LookupMode := true;
                                    if ServicePackageList.RunModal = Action::LookupOK then
                                        Text := ServicePackageList.GetSelectionFilter
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
                field(TypeFilter; TypeFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Type Filter';
                    OptionCaption = 'Labor,Labor Disceount Group,All,None';

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
                        LaborList: Page "Service Labor List";
                        LaborGroupList: Page "Service Labor Discount Groups";
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
                            Rec.Type::"Labor Discount Group":
                                begin
                                    LaborGroupList.LookupMode := true;
                                    if LaborGroupList.RunModal = Action::LookupOK then
                                        Text := LaborGroupList.GetSelectionFilter
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
                field(SalesCodeFilterCtrl2; CurrencyCodeFilter)
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
            repeater(Control1)
            {
                field(SalesType; Rec."Sales Type")
                {
                    ApplicationArea = Basic;
                }
                field(SalesCode; Rec."Sales Code")
                {
                    ApplicationArea = Basic;
                    Editable = "Sales CodeEditable";
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
                field(StartingDate; Rec."Starting Date")
                {
                    ApplicationArea = Basic;
                }
                field(EndingDate; Rec."Ending Date")
                {
                    ApplicationArea = Basic;
                }
                field(LaborGroupCode; Rec."Labor Group Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(LaborSubgroupCode; Rec."Labor Subgroup Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
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
                    Visible = false;
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        "Sales CodeEditable" := Rec."Sales Type" <> Rec."sales type"::"All Customers";
    end;

    trigger OnInit()
    begin
        CodeFilterCtrlEnable := true;
        SalesCodeFilterCtrlEnable := true;
        "Sales CodeEditable" := true;
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
        ServiceLabor: Record "Service Labor";
        ServiceLaborGroup: Record "Service Labor Discount Group";
        ServicePackage: Record "Service Package";
        SalesTypeFilter: Option Customer,"Customer Disc. Group","All Customers",Campaign,Contract,Assembly,"Serv. Package","None";
        SalesCodeFilter: Text[250];
        TypeFilter: Option Labor,"Labor Disceount Group",All,"None";
        CodeFilter: Text[250];
        StartingDateFilter: Text[30];
        Text000: label 'All Customers';
        CurrencyCodeFilter: Text[250];
        [InDataSet]
        "Sales CodeEditable": Boolean;
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

        if TypeFilter <> Typefilter::None then
            Rec.SetRange(Type, TypeFilter)
        else
            Rec.SetRange(Type);

        if TypeFilter = Typefilter::None then begin
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
        "Sales CodeEditable" := Rec."Sales Type" <> Rec."sales type"::"All Customers";

        SourceTableName := '';
        case TypeFilter of
            Typefilter::Labor:
                begin
                    SourceTableName := ObjTransl.TranslateObject(ObjTransl."object type"::Table, 25006121);
                    ServiceLabor."No." := CodeFilter;
                end;
            Typefilter::"Labor Disceount Group":
                begin
                    SourceTableName := ObjTransl.TranslateObject(ObjTransl."object type"::Table, 25006058);
                    ServiceLaborGroup.Code := CodeFilter;
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
            Salestypefilter::"Customer Disc. Group":
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
            Salestypefilter::"Serv. Package":  //14.01.2014 EDMS P8
                begin
                    SalesSrcTableName := ObjTransl.TranslateObject(ObjTransl."object type"::Table, 25006134);
                    ServicePackage."No." := SalesCodeFilter;
                    if ServicePackage.Find then
                        Description := ServicePackage.Description;
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

    local procedure TypeFilterOnAfterValidate()
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

    local procedure CurrencyCodeFilterOnAfterValid()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;
}

