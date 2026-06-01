Page 25006064 "Contract Sales Line Disc.Arch."
{
    AutoSplitKey = true;
    Caption = 'Contract Sales Line Discount Archive';
    DelayedInsert = true;
    Editable = false;
    PageType = List;
    SourceTable = "Contract Sales Line Disc.Arch.";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(ContractFilterCtrl; ContractFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Contract Filter';

                    trigger OnValidate()
                    begin
                        ContractFilterOnAfterValidate;
                    end;
                }
                field(TypeFilterCtrl; TypeFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'Type Filter';

                    trigger OnValidate()
                    begin
                        TypeFilterOnAfterValidate;
                    end;
                }
                field(NoFilterCtrl; NoFilter)
                {
                    ApplicationArea = Basic;
                    Caption = 'No. Filter';

                    trigger OnValidate()
                    begin
                        NoFilterOnAfterValidate;
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
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(StartingDate; Rec."Starting Date")
                {
                    ApplicationArea = Basic;
                }
                field(LineDiscount; Rec."Line Discount %")
                {
                    ApplicationArea = Basic;
                }
                field(ContractExpirationDate; Rec."Contract Expiration Date")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field(VIN; Rec.VIN)
                {
                    ApplicationArea = Basic;
                    Visible = false;
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
        ContractFilter: Text[250];
        TypeFilter: Option "Item Category",Labor,"None";
        StartingDateFilter: Text[30];
        NoFilter: Text[250];


    procedure GetRecFilters()
    begin
        if Rec.GetFilter(Type) <> '' then
            TypeFilter := Rec.Type
        else
            TypeFilter := Typefilter::None;

        if Rec.GetFilters <> '' then begin
            ContractFilter := Rec.GetFilter("Contract No.");
            NoFilter := Rec.GetFilter("No.");
        end;

        Evaluate(StartingDateFilter, Rec.GetFilter("Starting Date"));
    end;


    procedure SetRecFilters()
    begin
        if ContractFilter <> '' then
            Rec.SetFilter("Contract No.", ContractFilter)
        else
            Rec.SetRange("Contract No.");

        if TypeFilter <> Typefilter::None then
            Rec.SetRange(Type, TypeFilter)
        else
            Rec.SetRange(Type);

        if NoFilter <> '' then
            Rec.SetFilter("No.", NoFilter)
        else
            Rec.SetRange("No.");

        if StartingDateFilter <> '' then
            Rec.SetFilter("Starting Date", StartingDateFilter)
        else
            Rec.SetRange("Starting Date");

        CurrPage.Update(false);
    end;

    local procedure TypeFilterOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;

    local procedure StartingDateFilterOnAfterValid()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;

    local procedure ContractFilterOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;

    local procedure NoFilterOnAfterValidate()
    begin
        CurrPage.SaveRecord;
        SetRecFilters;
    end;
}

