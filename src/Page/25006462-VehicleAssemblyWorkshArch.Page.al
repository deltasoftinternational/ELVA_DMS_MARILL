Page 25006462 "Vehicle Assembly Worksh. Arch."
{
    // 16.03.2016 EB.P7 Branch Profile Setup
    //   Modified Amount - OnValidate(), Usert Profile Setup to Branch Profile Setup
    //   Modified Sales Price - OnValidate(), Usert Profile Setup to Branch Profile Setup

    AutoSplitKey = true;
    Caption = 'Vehicle Assembly Worksh. Arch.';
    DataCaptionFields = "Assembly ID", "Line No.", "Option Type", "Option Code";
    DelayedInsert = true;
    PageType = Worksheet;
    PopulateAllFields = true;
    SourceTable = "Vehicle Assembly Line Arch.";

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
                    Visible = false;
                }
                field(OptionCode; Rec."Option Code")
                {
                    ApplicationArea = Basic;
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
                field(CostAmount; Rec."Cost Amount")
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
            }
            group(Control1101907028)
            {
                ShowCaption = false;
                group(Control1101904001)
                {
                    ShowCaption = false;
                    field(GetTotalAmountCtrl; GetTotalAmount)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Total Sales Amount';
                        Editable = false;
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
        }
    }

    trigger OnClosePage()
    begin
        Clear(OptSalesPrDiscMgt);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        if xRec."Option Type" = xRec."option type"::"Vehicle Base" then
            Rec."Option Type" := Rec."option type"::"Manufacturer Option"
        else
            Rec."Option Type" := xRec."Option Type";
    end;

    var
        FCY: Code[20];
        FCYRateDate: Date;
        FCYFactor: Decimal;
        OptSalesPrDiscMgt: Codeunit VehicleSalesPriceDiscountMgt;
        SingleInstanceMgt: Codeunit SingleInstanceManagement;
        UserProfile: Record "Branch Profile Setup";
        Text100: label 'You don''t have rights to modify this field.';
        VehicleAssembly: Record "Vehicle Assembly Line Arch.";
        UserProfileMgt: Codeunit UserProfileManagement;


    procedure GetTotalAmount(): Decimal
    var
        TempVehicleAssembly: Record "Vehicle Assembly Line Arch.";
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
}

