Page 25006364 "Chose Item Loc. Qty. Dialog"
{
    // #Owner POD.DMS.Parts
    // 
    // 02.04.2017 EB.RC POD.DMS.Parts P439.WH24 POD0.40
    //   Added fields:
    //     60"InventoryDecimal"
    //     70"Reserved Qty. on Inventory"
    //     80"Qty. on Purch. Binning Lists"
    // 
    // 30.01.2017 EB.RC POD.DMS.Service P439.INTVPIM
    //   Bugfix
    // 
    // 30.01.2017 EB.RC POD.DMS.Parts P439.WH24
    //   Bugfix
    // 
    // 28.12.2016 EB.RC POD.DMS.Parts P439.INTVPIM
    //   Added new text Info fields.
    //   Modified function AddDialogData
    // 
    // 20.12.2016 EB.RC POD.DMS.Parts P439.WSH24 POD0.39
    //   Modified trigger:
    //     OnAfterGetCurrRecord
    //   Added fields:
    //     "Estimate Of Demand"
    //     "VAU Class"
    //     "Picks Class"
    // 
    // 18.07.2016 EB.RC POD.DMS.Parts P439.PAR90 POD0.16
    //   Created

    DeleteAllowed = false;
    InsertAllowed = false;
    PageType = StandardDialog;
    SourceTable = "Item Location Qty. Buffer";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(LocationDescription; Rec."Location Description")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(AvailableQuantity; Rec."Available Quantity")
                {
                    ApplicationArea = Basic;
                    DecimalPlaces = 0 : 2;
                    Editable = false;
                }
                field(SelectedQuantity; Rec."Selected Quantity")
                {
                    ApplicationArea = Basic;
                    DecimalPlaces = 0 : 2;
                }
                field(Inventory; Rec.Inventory)
                {
                    ApplicationArea = Basic;
                }
                field(ReservedQtyonInventory; Rec."Reserved Qty. on Inventory")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Control50012)
            {
                fixed(Control50011)
                {
                    ShowCaption = false;
                    group(ItemNo)
                    {
                        Caption = 'Item No.';
                        field(Control50014; ItemNo)
                        {
                            ShowCaption = false;
                            ApplicationArea = Basic;
                        }
                    }
                    group(ItemDescription)
                    {
                        Caption = 'Item Description';
                        field(Control50010; ItemDescription)
                        {
                            ShowCaption = false;
                            ApplicationArea = Basic;
                            Editable = false;
                        }
                    }
                }
            }
        }
    }

    actions
    {
    }

    trigger OnAfterGetRecord()
    var
        StockkeepingUnit: Record "Stockkeeping Unit";
    begin
        //EstimateOfDemand := 0;
        //VAUClass := '';
        //PicksClass := '';

        /*
        StockkeepingUnit.RESET;
        StockkeepingUnit.SETRANGE("Location Code",Rec."Location Code");
        StockkeepingUnit.SETRANGE("Item No.",Rec."Item No.");
        IF StockkeepingUnit.FINDFIRST THEN BEGIN
          //EstimateOfDemand := StockkeepingUnit."Estimate of Demand";
          //VAUClass := StockkeepingUnit."VAU Class";
          //PicksClass := StockkeepingUnit."Picks Class";
        END;
        */

    end;

    var
        ItemDescription: Text;
        ItemNo: Text;
        VendorItemNoBase: Text;
        VendorItemNoPrefix: Text;


    procedure AddDialogData(var ItemLocationQtyBuffer: Record "Item Location Qty. Buffer")
    var
        Item: Record Item;
    begin
        if ItemLocationQtyBuffer.FindFirst then
            repeat
                Rec.Init;
                Rec := ItemLocationQtyBuffer;
                Rec.Insert
            until ItemLocationQtyBuffer.Next = 0;

        if Item.Get(Rec."Item No.") then begin
            ItemDescription := Item.Description;
            ItemNo := Item."No.";
            //VendorItemNoBase := Item."Vendor Item No. Base";
            //VendorItemNoPrefix := Item."Vendor Item No. Prefix";
        end;
    end;


    procedure GetDialogData(var ItemLocationQtyBuffer: Record "Item Location Qty. Buffer")
    var
        ItemLocationQtyBufferToSet: Record "Item Location Qty. Buffer" temporary;
    begin
        ItemLocationQtyBuffer.DeleteAll;
        Rec.Reset;
        if Rec.FindFirst then
            repeat
                ItemLocationQtyBuffer.Init;
                ItemLocationQtyBuffer := Rec;
                ItemLocationQtyBuffer.Insert
            until Rec.Next = 0;
    end;
}

