Page 25006490 "Vehicle Assembly Worksheet"
{
    // 16.03.2016 EB.P7 Branch Profile Setup
    //   Modified Amount - OnValidate(), Usert Profile Setup to Branch Profile Setup
    //   Modified Sales Price - OnValidate(), Usert Profile Setup to Branch Profile Setup
    // 
    // 23.05.2013 Elva Baltic P15
    //   * Added function - CheckDuplicates(by

    AutoSplitKey = true;
    Caption = 'Vehicle Assembly Worksheet';
    DataCaptionFields = "Assembly ID", "Line No.", "Option Type", "Option Code";
    DelayedInsert = true;
    PageType = Worksheet;
    PopulateAllFields = true;
    RefreshOnActivate = true;
    SourceTable = "Vehicle Assembly Line";

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field(AssemblyID; Rec."Assembly ID")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
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

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        OwnOptions: Page "Own Options";
                        ManOptions: Page "Manufacturer Options";
                        ManOption: Record "Manufacturer Option";
                        OwnOption: Record "Own Option";
                        Item: Record Item;
                        Items: Page "Item List";
                    begin
                        case Rec."Option Type" of
                            Rec."option type"::"Vehicle Base":
                                ;
                            Rec."option type"::"Manufacturer Option":
                                begin
                                    ManOption.Reset;
                                    ManOption.SetRange("Make Code", Rec."Make Code");
                                    ManOption.SetRange("Model Code", Rec."Model Code");
                                    ManOption.SetRange("Model Version No.", Rec."Model Version No.");
                                    ManOption.SetRange(Type, Rec."Option Subtype");
                                    Clear(ManOptions);
                                    ManOptions.SetTableview(ManOption);
                                    if Rec."Option Code" <> '' then begin
                                        ManOption.SetRange("Option Code", Rec."Option Code");
                                        if ManOption.FindSet then;
                                        ManOption.SetRange("Option Code");
                                        ManOptions.SetRecord(ManOption);
                                    end;
                                    ManOptions.LookupMode(true);
                                    if ManOptions.RunModal = Action::LookupOK then begin
                                        ManOptions.GetRecord(ManOption);
                                        Rec.Validate("Option Code", ManOption."Option Code");
                                    end;
                                end;
                            Rec."option type"::"Own Option":
                                begin
                                    OwnOption.Reset;
                                    OwnOption.SetRange("Make Code", Rec."Make Code");
                                    OwnOption.SetRange("Model Code", Rec."Model Code");
                                    Clear(OwnOptions);
                                    OwnOptions.SetTableview(OwnOption);
                                    if Rec."Option Code" <> '' then begin
                                        OwnOption.SetRange("Option Code", Rec."Option Code");
                                        if OwnOption.FindSet then;
                                        OwnOption.SetRange("Option Code");
                                        OwnOptions.SetRecord(OwnOption);
                                    end;
                                    OwnOptions.LookupMode(true);
                                    if OwnOptions.RunModal = Action::LookupOK then begin
                                        OwnOptions.GetRecord(OwnOption);
                                        Rec.Validate("Option Code", OwnOption."Option Code");
                                    end;
                                end;
                            Rec."Option Type"::Item:
                                begin
                                    Item.Reset;
                                    Item.SetRange("Item Type", Item."Item Type"::Item);
                                    Clear(Items);
                                    Items.SetTableview(Item);
                                    Items.LookupMode(true);
                                    if Items.RunModal = Action::LookupOK then begin
                                        Items.GetRecord(Item);
                                        Rec.Validate("Option Code", Item."No.");
                                    end;
                                end;
                        end;
                        CurrPage.Update;
                    end;
                }
                field(ExternalCode; Rec."External Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(Description2; Rec."Description 2")
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
                field(SalesPrice; Rec."Sales Price")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        if UserProfile.Get(UserProfileMgt.CurrProfileID, UserProfileMgt.CurrBranchNo) then
                            if UserProfile."Vehicle Sales Disc. Check" then
                                Error(Text100);
                    end;
                }
                field(LineDiscount; Rec."Line Discount %")
                {
                    ApplicationArea = Basic;
                }
                field(LineDiscountAmount; Rec."Line Discount Amount")
                {
                    ApplicationArea = Basic;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        if UserProfile.Get(UserProfileMgt.CurrProfileID, UserProfileMgt.CurrBranchNo) then
                            if UserProfile."Vehicle Sales Disc. Check" then
                                Error(Text100);
                    end;
                }
                field(Standard; Rec.Standard)
                {
                    ApplicationArea = Basic;
                }
                field(SerialNo; Rec."Serial No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Posted; Rec.Posted)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field("<Assembly ID 2>"; Rec."Assembly ID")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PDICreated; Rec."PDI Created")
                {
                    ApplicationArea = Basic;
                }
                field(DirectPurchaseCost; Rec."Direct Purchase Cost")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PurchaseDiscount; Rec."Purchase Discount %")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PurchaseDiscountAmount; Rec."Purchase Discount Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PurchaseCostAmount; Rec."Purchase Cost Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
            group(Control1101907028)
            {
                ShowCaption = false;
                group(Control1101904001)
                {
                    ShowCaption = false;
                    field(TotalAmount; TotalAmount)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Total Sales Amount';
                        Editable = false;
                        QuickEntry = false;
                    }
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Option)
            {
                Caption = 'Option';
                action(Translations)
                {
                    ApplicationArea = Basic;
                    Caption = 'Translations';
                    Image = Translations;

                    trigger OnAction()
                    var
                        recOptTransl: Record "Option Translation";
                    begin
                        Rec.TestField("Option Code");
                        if not (recOptTransl."Option Type" in [recOptTransl."option type"::"Manufacturer Option", recOptTransl."option type"::"Own Option"
                        ]) then
                            exit;
                        recOptTransl.Reset;
                        recOptTransl.SetRange("Option Type", Rec."Option Type");
                        recOptTransl.SetRange("Make Code", Rec."Make Code");
                        recOptTransl.SetRange("Model Code", Rec."Model Code");
                        recOptTransl.SetRange("Model Version No.", Rec."Model Version No.");
                        recOptTransl.SetRange("Option Code", Rec."Option Code");
                        Page.RunModal(Page::"Option Translations", recOptTransl);
                    end;
                }
            }
            group(Functions)
            {
                Caption = 'Functions';
                action(Refresh)
                {
                    ApplicationArea = Basic;
                    Caption = 'Refresh';
                    Image = Refresh;

                    trigger OnAction()
                    var
                        cuVehOptMgt: Codeunit VehicleOptionManagement;
                    begin
                        Rec.TestField("Serial No.");
                        Rec.TestField("Assembly ID");
                        Clear(cuVehOptMgt);
                        cuVehOptMgt.SyncVehAssembly(Rec);
                    end;
                }
                action("<Action1101907046>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post Own Option';
                    Image = Post;

                    trigger OnAction()
                    begin
                        if not Confirm(Text002) then
                            exit;
                        Rec.TestField("Serial No.");
                        Rec.TestField("Assembly ID");
                        //TESTFIELD("Option Code");
                        Rec.TestField(Posted, false);
                        Clear(VehOptMgt);
                        VehOptMgt.PutOnOption(Rec);
                    end;
                }
                action(CreatePDIServiceDocument)
                {
                    ApplicationArea = Basic;
                    Caption = 'Create &PDI Service Document';
                    Image = ServiceAgreement;

                    trigger OnAction()
                    begin
                        VehicleAssembly.Reset;
                        CurrPage.SetSelectionFilter(VehicleAssembly);
                        VehicleOptionMgt.CreatePDIdocFromAssemblyLine(VehicleAssembly);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    begin
        TotalAmount := GetTotalAmount;
    end;

    trigger OnInsertRecord(BelowxRec: Boolean): Boolean
    begin
        //23.05.2013 Elva Baltic P15 >>
        if Rec."Option Type" <> Rec."Option Type"::Comment then
            if CheckDuplicates then
                Error(Text001);
        //23.05.2013 Elva Baltic P15 <<
    end;

    trigger OnModifyRecord(): Boolean
    begin
        //23.05.2013 Elva Baltic P15 >>
        if Rec."Option Type" <> Rec."Option Type"::Comment then
            if CheckDuplicates then
                Error(Text001);
        //23.05.2013 Elva Baltic P15 <<
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if xRec."Option Type" = xRec."option type"::"Vehicle Base" then
            Rec."Option Type" := Rec."option type"::"Manufacturer Option"
        else
            Rec."Option Type" := xRec."Option Type";
    end;

    trigger OnOpenPage()
    begin
        TotalAmount := GetTotalAmount;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        if CloseAction in [Action::OK, Action::LookupOK] then begin
            Rec.CheckOptionConditions();
            Clear(OptSalesPrDiscMgt);
            OptSalesPrDiscMgt.UpdateSalesLineAmounts(Rec);
            //OptSalesPrDiscMgt.UpdatePurchLineAmounts(Rec); DELTA 01
        end;
    end;

    var
        FCY: Code[20];
        FCYRateDate: Date;
        FCYFactor: Decimal;
        OptSalesPrDiscMgt: Codeunit VehicleSalesPriceDiscountMgt;
        Text002: label 'Do you really want to post put-on?';
        VehOptMgt: Codeunit VehicleOptionManagement;
        SingleInstanceMgt: Codeunit SingleInstanceManagement;
        UserProfile: Record "Branch Profile Setup";
        Text100: label 'You don''t have rights to modify this field.';
        VehicleOptionMgt: Codeunit VehicleOptionManagement;
        VehicleAssembly: Record "Vehicle Assembly Line";
        TotalAmount: Decimal;
        Text001: label 'The same Option already exists.';
        UserProfileMgt: Codeunit UserProfileManagement;


    procedure GetTotalAmount() RetValue: Decimal
    var
        TempVehicleAssembly: Record "Vehicle Assembly Line";
        CurrExchRate: Record "Currency Exchange Rate";
        TotalSalesPrice: Decimal;
        TotalSalesDiscAmount: Decimal;
    begin
        TempVehicleAssembly.Reset;
        TempVehicleAssembly.CopyFilters(Rec);
        TempVehicleAssembly.SetRange("Make Code");
        TempVehicleAssembly.SetRange("Model Code");
        TempVehicleAssembly.SetRange("Model Version No.");

        TempVehicleAssembly.CalcSums(Amount);
        exit(TempVehicleAssembly.Amount);
    end;


    procedure SetFCY(CurrencyCode: Code[20]; ExchangeRateDate: Date; CurrencyFactor: Decimal)
    begin
        FCY := CurrencyCode;
        FCYRateDate := ExchangeRateDate;
        FCYFactor := CurrencyFactor;
    end;


    procedure CheckDuplicates(): Boolean
    var
        VehicleAssembly2: Record "Vehicle Assembly Line";
    begin
        //23.05.2013 Elva Baltic P15
        VehicleAssembly2.Reset;
        VehicleAssembly2.CopyFilters(Rec);
        VehicleAssembly2.SetRange("Option Type", Rec."Option Type");
        VehicleAssembly2.SetRange("Option Subtype", Rec."Option Subtype");
        VehicleAssembly2.SetRange("Option Code", Rec."Option Code");
        VehicleAssembly2.SetFilter(VehicleAssembly2."Line No.", '<>%1', Rec."Line No.");
        exit(VehicleAssembly2.FindFirst);
    end;
}

