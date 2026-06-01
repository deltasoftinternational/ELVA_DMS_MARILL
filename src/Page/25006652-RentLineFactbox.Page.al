Page 25006652 "Rent Line Factbox"
{
    PageType = CardPart;
    SourceTable = "Rent Line";

    layout
    {
        area(content)
        {
            group(RentItem)
            {
                Caption = 'Rent Item';
                field(RentItemNo; Rec."Rent Item No.")
                {
                    ApplicationArea = Basic;
                }
                field(Make; Make.Name)
                {
                    ApplicationArea = Basic;
                    Caption = 'Make';
                }
                field(Model; Model."Commercial Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Model';
                }
            }
            group(RentAsset)
            {
                Caption = 'Rent Asset';
                field(RentAssetNo; Rec."Rent Asset No.")
                {
                    ApplicationArea = Basic;
                }
                field(RentMakeName; RentMake.Name)
                {
                    ApplicationArea = Basic;
                    Caption = 'Make';
                }
                field(RentModelCommercialName; RentModel."Commercial Name")
                {
                    ApplicationArea = Basic;
                    Caption = 'Model';
                }
                field(Status; RentAsset.Status)
                {
                    ApplicationArea = Basic;
                    Caption = 'Status';
                }
                field(SerialNo; RentAsset."Serial No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Serial No.';
                }
                field(VehicleSerialNo; RentAsset."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicle Serial No.';
                }
                field(FixedAssetNo; RentAsset."Fixed Asset No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Fixed Asset No.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetCurrRecord()
    begin
        Clear(RentItem);
        Clear(Make);
        Clear(Model);
        Clear(RentAsset);
        Clear(RentMake);
        Clear(RentModel);

        if Rec."Rent Item No." <> '' then begin
            RentItem.Get(Rec."Rent Item No.");
            if RentItem."Make Code" <> '' then begin
                Make.Get(RentItem."Make Code");
                if RentItem."Model Code" <> '' then
                    Model.Get(RentItem."Make Code", RentItem."Model Code");
            end;
        end;
        if Rec."Rent Asset No." <> '' then begin
            RentAsset.Get(Rec."Rent Asset No.");
            if RentAsset."Make Code" <> '' then begin
                RentMake.Get(RentAsset."Make Code");
                if RentAsset."Model Code" <> '' then
                    RentModel.Get(RentAsset."Make Code", RentAsset."Model Code");
            end;
        end;
    end;

    var
        Make: Record Make;
        Model: Record Model;
        RentMake: Record Make;
        RentModel: Record Model;
        RentAsset: Record "Rent Asset";
        RentItem: Record "Rent Item";
}

