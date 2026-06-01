Report 25006308 "Copy Option"
{
    Caption = 'Copy Option';
    ProcessingOnly = true;

    dataset
    {
    }

    requestpage
    {
        DataCaptionExpression = CaptionVar;

        layout
        {
            area(content)
            {
                group(General)
                {
                    Caption = 'General';
                    field(MakeCodeCtrl; ItemSource."Make Code")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Make Code';
                        Lookup = true;
                        TableRelation = Make.Code;
                    }
                    field(ModelCtrl; ItemSource."Model Code")
                    {
                        ApplicationArea = Basic;
                        Caption = 'Model Code';

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            ModelSource.SetRange("Make Code", ItemSource."Make Code");
                            ModelSource.Code := ItemSource."Model Code";
                            if ModelSource.Find then;
                            if Page.RunModal(0, ModelSource) = Action::LookupOK then
                                ItemSource."Model Code" := ModelSource.Code;
                        end;
                    }
                    field(ModelVersionCtrl; ModelVersionNo)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Model Version No.';
                        Enabled = ModelVersionCtrlEnable;

                        trigger OnLookup(var Text: Text): Boolean
                        begin
                            LookupDocNo;
                        end;
                    }
                    field(OptionSubtypeCtrl; OptionSubtypeFilter)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Option Subtype';
                    }
                    field(CodeFilterCtrl; CodeFilter)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Option Code Filter';
                        Enabled = CodeFilterCtrlEnable;

                        trigger OnLookup(var Text: Text): Boolean
                        var
                            ItemList: Page "Item List";
                            ItemDiscGrList: Page "Item Disc. Groups";
                            frmManOptions: Page "Manufacturer Options";
                            frmOwnOptions: Page "Own Options";
                        begin
                            case OptionTypeFilter of
                                Optiontypefilter::"Manufacturer Option":
                                    begin
                                        SetManOptFilter;
                                        frmManOptions.SetTableview(ManufacturerOption);
                                        frmManOptions.LookupMode := true;
                                        if frmManOptions.RunModal = Action::LookupOK then
                                            Text := frmManOptions.GetSelectionFilter
                                        else
                                            exit(false);
                                    end;
                                Optiontypefilter::"Own Option":
                                    begin
                                        SetOwnOptFilter;
                                        frmOwnOptions.SetTableview(OwnOption);
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
                }
                group(PricesGroup)
                {
                    Caption = 'Prices';
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
                        var
                            CustList: Page "Customer List";
                            CustDiscGrList: Page "Customer Disc. Groups";
                            CampaignList: Page "Campaign List";
                            ItemList: Page "Item List";
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
                    field(StartingDateFilter; StartingDateFilter)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Starting Date Filter';

                        trigger OnValidate()
                        begin
                            //IF ApplicationMgt.MakeDateFilter(StartingDateFilter) = 0 THEN;;
                            StartingDateFilterOnAfterValid;
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
            CodeFilterCtrlEnable := true;
            SalesCodeFilterCtrlEnable := true;
        end;

        trigger OnOpenPage()
        begin
            ItemSource.SetRange("Item Type", DocType);
            case OptionTypeFilter of
                Optiontypefilter::"Manufacturer Option":
                    CaptionVar := Text001;
                Optiontypefilter::"Own Option":
                    CaptionVar := Text002;
            end;
        end;
    }

    labels
    {
    }

    trigger OnInitReport()
    begin
        DocType := ItemDestination."item type"::"Model Version";
        SalesTypeFilter := Salestypefilter::None;
        MakeCodeCtrlEnabled := true;
        ModelCtrlEnabled := true;
        ModelVersionCtrlEnable := true;
        OptionSubtypeCtrlEnabled := true;
        CodeFilterCtrlEnable := true;
        SalesCodeFilterCtrlEnable := true;
        OptionSubtypeFilter := -1;
    end;

    trigger OnPreReport()
    begin
        case OptionTypeFilter of
            Optiontypefilter::"Manufacturer Option":
                begin
                    SetManOptFilter;

                    CopyDocumentMgt.CopyManufOptionsToModelVersion(ManufacturerOption, ItemDestination, SalesTypeFilter, SalesCodeFilter,
                      StartingDateFilter);
                end;
            Optiontypefilter::"Own Option":
                begin
                    SetOwnOptFilter;

                    CopyDocumentMgt.CopyOwnOptionsToModel(OwnOption, ModelDestination, SalesTypeFilter, SalesCodeFilter, StartingDateFilter);
                end;
        end;
    end;

    var
        Make: Record Make;
        CopyDocumentMgt: Codeunit DocumentManagementDMS;
        ItemDestination: Record Item;
        ItemSource: Record Item;
        ManufacturerOption: Record "Manufacturer Option";
        ModelCode: Code[20];
        ModelVersionNo: Code[20];
        DocType: Integer;
        ModelDestination: Record Model;
        ModelSource: Record Model;
        OwnOption: Record "Own Option";
        MakeCode: Code[20];
        MakeModel: Code[20];
        SalesTypeFilter: Option Customer,"Customer Discount Group","All Customers",Campaign,"None";
        SalesCodeFilter: Text[250];
        OptionTypeFilter: Option "Manufacturer Option","Own Option","None";
        OptionSubtypeFilter: Option Option,Color,Upholstery;
        CodeFilter: Text[250];
        StartingDateFilter: DateFormula;
        CurrencyCodeFilter: Text[250];
        MakeCodeCtrlEnabled: Boolean;
        ModelCtrlEnabled: Boolean;
        [InDataSet]
        ModelVersionCtrlEnable: Boolean;
        OptionSubtypeCtrlEnabled: Boolean;
        [InDataSet]
        CodeFilterCtrlEnable: Boolean;
        [InDataSet]
        SalesCodeFilterCtrlEnable: Boolean;
        Text001: label 'Manufacturer Options';
        Text002: label 'Own Options';
        CaptionVar: Text[100];


    procedure SetItem(NewItem: Record Item)
    begin
        NewItem.TestField("No.");
        ItemDestination := NewItem;
        OptionTypeFilter := Optiontypefilter::"Manufacturer Option";
        ModelVersionCtrlEnable := true;
        OptionSubtypeCtrlEnabled := true;
    end;


    procedure SetModel(NewModel: Record Model)
    begin
        NewModel.TestField(Code);
        NewModel.TestField("Make Code");
        ModelDestination := NewModel;
        OptionTypeFilter := Optiontypefilter::"Own Option";
        ModelVersionCtrlEnable := false;
        OptionSubtypeCtrlEnabled := false;
    end;

    local procedure LookupDocNo()
    begin
        case OptionTypeFilter of
            Optiontypefilter::"Manufacturer Option":
                begin
                    ItemSource.SetRange("Item Type", DocType);
                    if ItemSource."Make Code" <> '' then
                        ItemSource.SetRange("Make Code", ItemSource."Make Code")
                    else
                        ItemSource.SetRange("Make Code");
                    if ItemSource."Model Code" <> '' then
                        ItemSource.SetRange("Model Code", ItemSource."Model Code")
                    else
                        ItemSource.SetRange("Model Code");

                    ItemSource."No." := ModelVersionNo;
                    if ItemSource.Find then;
                    if Page.RunModal(Page::"Model Version List", ItemSource) = Action::LookupOK then
                        ModelVersionNo := ItemSource."No.";
                end;
            Optiontypefilter::"Own Option":
                begin
                    ModelSource."Make Code" := MakeCode;
                    ModelSource.Code := ModelCode;
                    if ModelSource.Find then;
                    if Page.RunModal(0, ModelSource) = Action::LookupOK then begin
                        ModelCode := ModelSource.Code;
                        MakeCode := ModelSource."Make Code";
                    end;
                end;
        end;
    end;


    procedure SetRecFilters()
    begin
        SalesCodeFilterCtrlEnable := true;
        CodeFilterCtrlEnable := true;

        if SalesTypeFilter in [Salestypefilter::"All Customers", Salestypefilter::None] then begin
            SalesCodeFilterCtrlEnable := false;
            SalesCodeFilter := '';
        end;

        if OptionTypeFilter = Optiontypefilter::None then begin
            CodeFilterCtrlEnable := false;
            CodeFilter := '';
        end;
    end;


    procedure SetManOptFilter()
    begin
        ItemSource.Get(ModelVersionNo);
        ManufacturerOption.SetRange("Make Code", ItemSource."Make Code");
        ManufacturerOption.SetRange("Model Code", ItemSource."Model Code");
        ManufacturerOption.SetRange("Model Version No.", ItemSource."No.");
        if (OptionSubtypeFilter < 0) then
            ManufacturerOption.SetRange(Type)
        else
            ManufacturerOption.SetRange(Type, OptionSubtypeFilter);
        if (CodeFilter = '') then
            ManufacturerOption.SetRange("Option Code")
        else
            ManufacturerOption.SetFilter("Option Code", CodeFilter);
    end;


    procedure SetOwnOptFilter()
    begin
        ModelSource.Get(ItemSource."Make Code", ItemSource."Model Code");
        OwnOption.SetRange("Make Code", ItemSource."Make Code");
        OwnOption.SetRange("Model Code", ItemSource."Model Code");
        if (CodeFilter = '') then
            OwnOption.SetRange("Option Code")
        else
            OwnOption.SetFilter("Option Code", CodeFilter);
    end;

    local procedure SalesCodeFilterOnAfterValidate()
    begin
        SetRecFilters;
    end;

    local procedure StartingDateFilterOnAfterValid()
    begin
        SetRecFilters;
    end;

    local procedure CodeFilterOnAfterValidate()
    begin
        SetRecFilters;
    end;

    local procedure SalesTypeFilterOnAfterValidate()
    begin
        SalesCodeFilter := '';
        SetRecFilters;
    end;

    local procedure OptionTypeFilterOnAfterValidat()
    begin
        CodeFilter := '';
        SetRecFilters;
    end;
}

