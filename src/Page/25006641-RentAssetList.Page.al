Page 25006641 "Rent Asset List"
{
    ApplicationArea = Basic;
    Caption = 'Rent Asset List';
    CardPageID = "Rent Asset Card";
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Related Information';
    SourceTable = "Rent Asset";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the rent asset, according to the specified number series.';
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
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    Editable = false;
                    ToolTip = 'Shows the status of this rent asset.';
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
                field(SerialNo; Rec."Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the serial number of this rent asset.';
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
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the default location code of this rent asset.';
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the vehicle to which this rent asset is linked to.';
                }
                field("Current Location Code"; Rec."Current Location Code")
                {
                    ApplicationArea = All;
                    ToolTip = 'Shows current location where this rent asset is.';
                }
                field("Variable Field 25006800"; Rec."Variable Field 25006800")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006800Visible;
                }
                field("Variable Field 25006801"; Rec."Variable Field 25006801")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006801Visible;
                }
                field("Variable Field 25006802"; Rec."Variable Field 25006802")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006802Visible;
                }
                field("Variable Field 25006803"; Rec."Variable Field 25006803")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006803Visible;
                }
                field("Variable Field 25006804"; Rec."Variable Field 25006804")
                {
                    ApplicationArea = Basic;
                    Visible = VF25006804Visible;
                }
                field("Main Asset/Component"; Rec."Main Asset/Component")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies if the rent asset is a main asset or a component of a rent asset.';
                    Visible = false;
                }
                field("Component of Main Asset"; Rec."Component of Main Asset")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number of the main rent asset.';
                    Visible = false;
                }
                field("Fixed Asset No."; Rec."Fixed Asset No.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the fixed asset to which this rent asset is linked to.';
                    Visible = false;
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
        area(processing)
        {
            action(RemoveMarkedOnlyFilter)
            {
                ApplicationArea = Basic;
                Caption = 'Show All';
                Image = AllLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Rec.MarkedOnly(false);
                    Rec.MarkedOnly := false;
                end;
            }
        }
        area(navigation)
        {
            action(Availability)
            {
                ApplicationArea = Basic;
                Image = AvailableToPromise;

                trigger OnAction()
                var
                    RentItemCapacity: Page "Rent Item Capacity";
                begin
                    RentItemCapacity.SetRentAssets(Rec, Rec.MarkedOnly);
                    RentItemCapacity.SetItemOrAsset(1);//Set Asset
                    RentItemCapacity.Run;
                end;
            }
            action("Status Log")
            {
                ApplicationArea = Basic;
                Caption = 'Status Log';
                Image = Log;
                //The property 'PromotedCategory' can only be set if the property 'Promoted' is set to 'true'
                //PromotedCategory = Category4;
                //The property 'PromotedIsBig' can only be set if the property 'Promoted' is set to 'true'
                //PromotedIsBig = true;
                RunObject = Page "Rent Asset Status Change Log";
                RunPageLink = "Rent Asset No." = field("No.");
            }
            action(RentLedgerEntries)
            {
                ApplicationArea = Basic;
                Caption = 'Rent Ledger Entries';
                Image = LedgerEntries;
                RunObject = Page "Rent Ledger Entries";
                RunPageLink = "Rent Asset No." = field("No.");
            }
            action(RentAssetsByLocation)
            {
                ApplicationArea = Basic;
                Caption = 'Availability by Location';
                Image = LedgerEntries;
                trigger OnAction()
                var
                    RentItemsByLocation: Page "Rent Assets by Location";
                begin
                    RentItemsByLocation.SetTableView(Rec);
                    RentItemsByLocation.Run();
                end;
            }
        }
    }
    trigger OnOpenPage()
    begin
        Rec.MarkedOnly := True;
        if Rec.Count() = 0 then
            Rec.MarkedOnly := False;
    end;

    trigger OnInit()
    begin
        SetVariableFields;
    end;

    var
        MarkedOnly: Boolean;
        VF25006800Visible: Boolean;
        VF25006801Visible: Boolean;
        VF25006802Visible: Boolean;
        VF25006803Visible: Boolean;
        VF25006804Visible: Boolean;

    procedure SetVariableFields()
    begin
        VF25006800Visible := Rec.IsVFActive(25006800);
        VF25006801Visible := Rec.IsVFActive(25006801);
        VF25006802Visible := Rec.IsVFActive(25006802);
        VF25006803Visible := Rec.IsVFActive(25006803);
        VF25006804Visible := Rec.IsVFActive(25006804);
    end;
}

