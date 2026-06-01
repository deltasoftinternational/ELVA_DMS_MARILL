Page 25006876 "Branch Profile Setup Card"
{
    Caption = 'Branch Profile Setup';
    PageType = Card;
    SourceTable = "Branch Profile Setup";

    layout
    {
        area(content)
        {
            group(General)
            {
                field(BranchCode; Rec."Branch Code")
                {
                    ApplicationArea = Basic;
                }
                field(ProfileID; Rec."Profile ID")
                {
                    ApplicationArea = All;
                    Caption = 'Profile ID';
                    DrillDown = false;
                    Editable = false;
                    LookupPageID = "Profile List";
                    ToolTip = 'Specifies the ID of the profile that is associated with the current user.';

                    trigger OnAssistEdit()
                    var
                        UserProfileManagement: Codeunit "UserProfileManagement";
                        TempAllProfile: Record "All Profile" temporary;
                    begin
                        UserProfileManagement.PopulateProfiles(TempAllProfile);
                        if Page.RunModal(Page::Roles, TempAllProfile) = Action::LookupOK then
                            Rec."Profile ID" := TempAllProfile."Profile ID";
                    end;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(MakeCodeFilter; Rec."Make Code Filter")
                {
                    ApplicationArea = Basic;
                }
                field(DefaultDealTypeCode; Rec."Default Deal Type Code")
                {
                    ApplicationArea = Basic;
                }
                field(DefaultMakeCode; Rec."Default Make Code")
                {
                    ApplicationArea = Basic;
                }
                field(DefaultLocationCode; Rec."Default Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(DefaultLocationFilter; Rec."Default Location Filter")
                {
                    ApplicationArea = Basic;
                }
                field("Default Req. Location Filter"; Rec."Default Req. Location Filter")
                {
                    ApplicationArea = All;
                }
                field(DefaultVendorNo; Rec."Default Vendor No.")
                {
                    ApplicationArea = Basic;
                }
                field(DefaultPaymentMethod; Rec."Default Payment Method")
                {
                    ApplicationArea = Basic;
                }
                field(DefaultShippingAgentCode; Rec."Default Shipping Agent Code")
                {
                    ApplicationArea = Basic;
                }
                field(DefaultVehicleStatus; Rec."Default Vehicle Status")
                {
                    ApplicationArea = Basic;
                }
                field(DefaultVehicleSalesStatus; Rec."New Vehicle Stat. After Sale")
                {
                    ApplicationArea = Basic;
                }
            }
            group(SpareParts)
            {
                Caption = 'Spare Parts';
                field(DefSparePartLocationCode; Rec."Def. Spare Part Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(SalesLineMarkupCheck; Rec."Sales Line Markup Check")
                {
                    ApplicationArea = Basic;
                }
                field(SalesLineMinMarkup; Rec."Sales Line Min Markup %")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Service)
            {
                Caption = 'Service';
                field(DefServiceLocationCode; Rec."Def. Service Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(SpecServiceSetup; Rec."Spec. Service Setup")
                {
                    ApplicationArea = Basic;
                }
                field(SpecBranchCode; Rec."Spec. Branch Code")
                {
                    ApplicationArea = Basic;
                }
                field(SpecServiceBranchProfile; Rec."Spec. Servic Branch Profile")
                {
                    ApplicationArea = Basic;
                    Caption = 'Spec. Service Branch Profile';
                }
                field(SpecOrderReceiver; Rec."Spec. Order Receiver")
                {
                    ApplicationArea = Basic;
                }
                field(ServiceScheduleViewCode; Rec."Service Schedule View Code")
                {
                    ApplicationArea = Basic;
                }
            }
            group(VehicleSales)
            {
                Caption = 'Vehicle Sales';
                field(DontUseVehicleAssembly; Rec."Don't Use Vehicle Assembly")
                {
                    ApplicationArea = Basic;
                }
                field(ShowVehicleCount; Rec."Show Vehicle Count")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleSalesDiscCheck; Rec."Vehicle Sales Disc. Check")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleMaxSalesDisc; Rec."Vehicle Max Sales Disc.%")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

