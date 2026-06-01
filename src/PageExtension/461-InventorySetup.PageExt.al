pageextension 25006040 "Inventory Setup" extends "Inventory Setup"//461
{
    layout
    {
        addafter("Skip Prompt to Create Item")
        {
            field(DefModelVersionItemCat; Rec."Def. Model Version Item Cat.")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies an item category to add by default when a model version is created.';
            }
            field(PostVehAddChargesonSale; Rec."Post Veh. Add. Charges on Sale")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies if vehicle charges should be posted to inventory and immediatelly to COGS on vehicle sales posting. If not selected, on purchase posting chanrges will go to inventory.';
            }
            field(VehicleSpecialCosting; Rec."Vehicle Special Costing")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies if special vehicle costing functionality should be enabled. It means distinguishing costs in transfer and sales posting. It will use splitting of value entries based on charges.';
            }
            field(VehicleOriginalCostDate; Rec."Vehicle Original Cost Date")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies if program should control dates used in vehicle charges. If enabled, any cost adjustment or posting to COGS can not happen before the date it was added to Vehicle.';
            }
            field(OnlyShipAvailableonPickPosting; Rec."Only Ship R. on Pick/Put Post.")
            {
                ApplicationArea = Basic;
                Caption = 'Only Ship Available on Pick Posting';
            }
        }
        addafter("Copy Item Descr. to Entries")
        {
            field(UpdtMarkupPronRefrCost; Rec."Updt. Markup Pr. on Refr. Cost")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies if system should update markup prices if cost refresh is done and if it should inform user on changed prices.';
            }
            field("Refresh Costs on Release"; Rec."Refresh Costs on Release")
            {
                ApplicationArea = Basic, Suite;
                ToolTip = 'Specifies if refresh costs functionality should be automatically run on sales and service document release';
            }
        }
        addafter("Package Caption")
        {
            field(FillItemGroupDefDimension; Rec."Fill Item Group Def. Dimension")
            {
                ApplicationArea = Basic;
                ToolTip = 'Specifies if dimensions to items should be automatically added based on Item Group Default Dimensions setup.';
            }
        }
        addafter("Posted Invt. Pick Nos.")
        {
            group(Vehicles)
            {
                Caption = 'Vehicles';
                field(VehicleSerialNoNos; Rec."Vehicle Serial No. Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series that will be used to assign numbers to vehicles.';
                }
                field(VehicleAccCycleNos; Rec."Vehicle Acc. Cycle Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series that will be used to assign numbers to vehicle accounting cycles.';
                }
                field(VehicleAssemblyNos; Rec."Vehicle Assembly Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series that will be used to assign numbers to vehicle assembly documents.';
                }
                field(VehicleAssemblyDocumentNos; Rec."Vehicle Assembly Document Nos.")
                {
                    ApplicationArea = Basic;
                    ToolTip = 'Specifies the number series that will be used to assign numbers to posting trough option journal.';
                }
            }
        }
    }
}