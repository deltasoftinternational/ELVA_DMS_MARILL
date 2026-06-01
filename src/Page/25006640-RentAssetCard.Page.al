Page 25006640 "Rent Asset Card"
{
    Caption = 'Rent Asset Card';
    PageType = Card;
    PromotedActionCategories = 'New,Process,Report,Asset,Related Information';
    SourceTable = "Rent Asset";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the rent asset, according to the specified number series.';

                    trigger OnAssistEdit()
                    begin
                        if Rec.AssistEdit then
                            CurrPage.Update;
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a description of the rent asset.';
                }
                field(Description2; Rec."Description 2")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies an additional description of the rent asset.';
                }
                field(SearchDescription; Rec."Search Description")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies a search description that you use to find the rent asset in lists.';
                }
                field(RentItemCategoryCode; Rec."Rent Item Category Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the category that the rent asset belongs to.';
                }
                field(RentProductGroupCode; Rec."Rent Product Group Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the product group that the rent asset belongs to.';
                }
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the make of this rent asset.';
                }
                field(ModelCode; Rec."Model Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the model of this rent asset.';
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the default location code of this rent asset.';
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Shows the status of this rent asset.';
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the vehicle to which this rent asset is linked to.';
                }
                field(SerialNo; Rec."Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the serial number of this rent asset.';
                }
                field(FixedAssetNo; Rec."Fixed Asset No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the fixed asset to which this rent asset is linked to.';
                }
                field("Asset Type"; Rec."Asset Type")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the rent asset card type. This can be a rent asset card that represents a single rent asset like a vehicle or this could be a rent asset that can define something countable in case of multiple type.';
                }
                field("Current Location Code"; Rec."Current Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows current location where this rent asset is.';
                }
                field("Main Asset/Component"; Rec."Main Asset/Component")
                {
                    ToolTip = 'Specifies if the rent asset is a main asset or a component of a rent asset.';
                    ApplicationArea = All;
                }
                field("Component of Main Asset"; Rec."Component of Main Asset")
                {
                    ToolTip = 'Specifies the number of the main rent asset.';
                    ApplicationArea = All;
                }

            }
            group(Specification)
            {

                field("Variable Field 25006800"; Rec."Variable Field 25006800")
                {
                    ApplicationArea = All;
                    Visible = VF25006800Visible;
                }
                field("Variable Field 25006801"; Rec."Variable Field 25006801")
                {
                    ApplicationArea = All;
                    Visible = VF25006801Visible;
                }
                field("Variable Field 25006802"; Rec."Variable Field 25006802")
                {
                    ApplicationArea = All;
                    Visible = VF25006802Visible;
                }
                field("Variable Field 25006803"; Rec."Variable Field 25006803")
                {
                    ApplicationArea = All;
                    Visible = VF25006803Visible;
                }
                field("Variable Field 25006804"; Rec."Variable Field 25006804")
                {
                    ApplicationArea = All;
                    Visible = VF25006804Visible;
                }
                field("Variable Field 25006805"; Rec."Variable Field 25006805")
                {
                    ApplicationArea = All;
                    Visible = VF25006805Visible;
                }
                field("Variable Field 25006806"; Rec."Variable Field 25006806")
                {
                    ApplicationArea = All;
                    Visible = VF25006806Visible;
                }
                field("Variable Field 25006807"; Rec."Variable Field 25006807")
                {
                    ApplicationArea = All;
                    Visible = VF25006807Visible;
                }
                field("Variable Field 25006808"; Rec."Variable Field 25006808")
                {
                    ApplicationArea = All;
                    Visible = VF25006808Visible;
                }
                field("Variable Field 25006809"; Rec."Variable Field 25006809")
                {
                    ApplicationArea = All;
                    Visible = VF25006809Visible;
                }
                field("Variable Field 25006810"; Rec."Variable Field 25006810")
                {
                    ApplicationArea = All;
                    Visible = VF25006810Visible;
                }
                field("Variable Field 25006811"; Rec."Variable Field 25006811")
                {
                    ApplicationArea = All;
                    Visible = VF25006811Visible;
                }
                field("Variable Field 25006812"; Rec."Variable Field 25006812")
                {
                    ApplicationArea = All;
                    Visible = VF25006812Visible;
                }
                field("Variable Field 25006813"; Rec."Variable Field 25006813")
                {
                    ApplicationArea = All;
                    Visible = VF25006813Visible;
                }
                field("Variable Field 25006814"; Rec."Variable Field 25006814")
                {
                    ApplicationArea = All;
                    Visible = VF25006814Visible;
                }
            }
        }

        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = RecordLinks;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = Notes;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action(Availability)
            {
                ApplicationArea = Basic;
                Image = AvailableToPromise;
                Visible = false;

                trigger OnAction()
                var
                    RentItemCapacity: Page "Rent Item Capacity";
                begin
                    RentItemCapacity.SetRentAssets(Rec, True);
                    RentItemCapacity.SetItemOrAsset(1);//Set Asset
                    RentItemCapacity.Run;
                end;
            }
            action("Status Log")
            {
                ApplicationArea = Basic;
                Caption = 'Status Log';
                Image = Log;
                RunObject = Page "Rent Asset Status Change Log";
                RunPageLink = "Rent Asset No." = field("No.");
            }
            action("Change Status")
            {
                ApplicationArea = Basic;
                Caption = 'Change Status';
                Image = Status;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ChangeStatusDialog: Page "Rent Asset Status Dialog";
                    NewStatus: Option;
                begin
                    ChangeStatusDialog.SetParam(Rec.Status);
                    if ChangeStatusDialog.RunModal = Action::OK then begin
                        ChangeStatusDialog.GetParam(NewStatus);
                        Rec.Validate(Status, NewStatus);
                        Rec.Modify;
                    end;
                end;
            }
            action(RentLedgerEntries)
            {
                ApplicationArea = Basic;
                Caption = 'Rent Ledger Entries';
                Image = LedgerEntries;
                RunObject = Page "Rent Ledger Entries";
                RunPageLink = "Rent Asset No." = field("No.");
            }
            action("M&ain Asset Components")
            {
                ApplicationArea = FixedAssets;
                Caption = 'Rent Asset Components';
                Image = Components;
                RunObject = Page "Rent Asset Components";
                RunPageLink = "Main Asset No." = FIELD("No.");
                ToolTip = 'View or edit fixed asset components of the main fixed asset that is represented by the fixed asset card.';
            }
            action(RentItemRelation)
            {
                ApplicationArea = Basic;
                Caption = 'Rent Item Relation';
                Image = ItemSubstitution;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Rent Item Relations";
                RunPageLink = "Rent Asset No." = field("No.");
            }
            action(RentAssetOpenDoc)
            {
                ApplicationArea = Basic;
                Caption = 'Rent Asset in Open Documents';
                Image = LedgerEntries;
                RunObject = Page "Rent Lines";
                RunPageLink = "Rent Asset No." = field("No."),
                                Closed = CONST(false);
            }
            action(RentAssetClosedDoc)
            {
                ApplicationArea = Basic;
                Caption = 'Rent Asset in Closed Documents';
                Image = LedgerEntries;
                RunObject = Page "Rent Lines";
                RunPageLink = "Rent Asset No." = field("No."),
                                Closed = CONST(true);
            }
        }
    }

    trigger OnInit()
    begin
        SetVariableFields;
    end;

    var
        [InDataSet]
        VF25006800Visible: Boolean;
        [InDataSet]
        VF25006801Visible: Boolean;
        [InDataSet]
        VF25006802Visible: Boolean;
        [InDataSet]
        VF25006803Visible: Boolean;
        [InDataSet]
        VF25006804Visible: Boolean;
        [InDataSet]
        VF25006805Visible: Boolean;
        [InDataSet]
        VF25006806Visible: Boolean;
        [InDataSet]
        VF25006807Visible: Boolean;
        [InDataSet]
        VF25006808Visible: Boolean;
        [InDataSet]
        VF25006809Visible: Boolean;
        [InDataSet]
        VF25006810Visible: Boolean;
        [InDataSet]
        VF25006811Visible: Boolean;
        [InDataSet]
        VF25006812Visible: Boolean;
        [InDataSet]
        VF25006813Visible: Boolean;
        [InDataSet]
        VF25006814Visible: Boolean;


    procedure SetVariableFields()
    begin
        VF25006800Visible := Rec.IsVFActive(25006800);
        VF25006801Visible := Rec.IsVFActive(25006801);
        VF25006802Visible := Rec.IsVFActive(25006802);
        VF25006803Visible := Rec.IsVFActive(25006803);
        VF25006804Visible := Rec.IsVFActive(25006804);
        VF25006805Visible := Rec.IsVFActive(25006805);
        VF25006806Visible := Rec.IsVFActive(25006806);
        VF25006807Visible := Rec.IsVFActive(25006807);
        VF25006808Visible := Rec.IsVFActive(25006808);
        VF25006809Visible := Rec.IsVFActive(25006809);
        VF25006810Visible := Rec.IsVFActive(25006810);
        VF25006811Visible := Rec.IsVFActive(25006811);
        VF25006812Visible := Rec.IsVFActive(25006812);
        VF25006813Visible := Rec.IsVFActive(25006813);
        VF25006814Visible := Rec.IsVFActive(25006814);
    end;
}

