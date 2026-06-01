Page 25006040 "Option Purchase Prices"
{
    Caption = 'Option Purchase Prices';
    DataCaptionExpression = GetCaption;
    DelayedInsert = true;
    PageType = Worksheet;
    PopulateAllFields = true;
    SaveValues = true;
    SourceTable = "Option Purchase Price";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
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
                field(VendorNo; Rec."Vendor No.")
                {
                    ApplicationArea = Basic;
                }
                field(OptionType; Rec."Option Type")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(OptionSubtype; Rec."Option Subtype")
                {
                    ApplicationArea = Basic;
                }
                field(OptionCode; Rec."Option Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(CurrencyCode; Rec."Currency Code")
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
        OnAfterGetCurrRecord;
    end;

    trigger OnInit()
    begin
        CodeFilterCtrlEnable := true;
        ModelVersionNoEditable := true;
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
        CustList: Page "Customer List";
        CustDiscGrList: Page "Customer Disc. Groups";
        CampaignList: Page "Campaign List";
        frmManOptions: Page "Manufacturer Options";
        frmOwnOptions: Page "Own Options";
        ItemTypeFilter: Option "Manufacturer Option","Own Option","None";
        CodeFilter: Text[250];
        StartingDateFilter: Text[30];
        Text000: label 'All Customers';
        [InDataSet]
        ModelVersionNoEditable: Boolean;
        [InDataSet]
        CodeFilterCtrlEnable: Boolean;


    procedure GetRecFilters()
    begin
        if Rec.GetFilters <> '' then begin
            //IF GETFILTER("Sales Type") <> '' THEN
            //  SalesTypeFilter := "Sales Type"
            //ELSE
            //  SalesTypeFilter := SalesTypeFilter::None;

            if Rec.GetFilter("Option Type") <> '' then
                ItemTypeFilter := Rec."Option Type"
            else
                ItemTypeFilter := Itemtypefilter::None;

            //SalesCodeFilter := GETFILTER("Sales Code");
            CodeFilter := Rec.GetFilter("Option Code");
            Evaluate(StartingDateFilter, Rec.GetFilter("Starting Date"));
        end;
    end;


    procedure SetRecFilters()
    begin
        CodeFilterCtrlEnable := true;

        if ItemTypeFilter <> Itemtypefilter::None then
            Rec.SetRange("Option Type", ItemTypeFilter)
        else
            Rec.SetRange("Option Type");


        if ItemTypeFilter = Itemtypefilter::None then begin
            CodeFilterCtrlEnable := false;
            CodeFilter := '';
        end;

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
        //SalesCodeEditable := "Sales Type" <> "Sales Type"::"All Customers";
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

        /*
        SalesSrcTableName := '';
        CASE SalesTypeFilter OF
          SalesTypeFilter::Customer:
            BEGIN
              SalesSrcTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,18);
              Cust."No." := SalesCodeFilter;
              IF Cust.FIND THEN
                Description := Cust.Name;
            END;
          SalesTypeFilter::"Customer Discount Group":
            BEGIN
              SalesSrcTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,340);
              CustDiscGr.Code := SalesCodeFilter;
              IF CustDiscGr.FIND THEN
                Description := CustDiscGr.Description;
            END;
          SalesTypeFilter::Campaign:
            BEGIN
              SalesSrcTableName := ObjTransl.TranslateObject(ObjTransl."Object Type"::Table,5071);
              Campaign."No." := SalesCodeFilter;
              IF Campaign.FIND THEN
                Description := Campaign.Description;
            END;
        
          SalesTypeFilter::"All Customers":
            BEGIN
              SalesSrcTableName := Text000;
              Description := '';
            END;
        END;
        
        IF SalesSrcTableName = Text000 THEN
          EXIT(STRSUBSTNO('%1 %2 %3 %4 %5',SalesSrcTableName,SalesCodeFilter,Description,SourceTableName,CodeFilter));
        EXIT(STRSUBSTNO('%1 %2 %3 %4 %5',SalesSrcTableName,SalesCodeFilter,Description,SourceTableName,CodeFilter));
        */

    end;

    local procedure SalesCodeFilterOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;

    local procedure SalesTypeFilterOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        //SalesCodeFilter := '';
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

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        //SalesCodeEditable := "Sales Type" <> "Sales Type"::"All Customers";
        ModelVersionNoEditable := Rec."Option Type" <> Rec."option type"::"Own Option";
    end;
}

