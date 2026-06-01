tableextension 25006057 "Inventory Setup" extends "Inventory Setup" //313
{
    // 21.01.2015 EDMS P11
    //   Vehicle Special Costing
    //   Added fields:
    //     25006040 "Vehicle Special Costing" [boolean]
    //     25006050 "Vehicle Original Cost Date" [boolean]
    // 
    // 10.05.2007 Elva Baltic P2
    //   *Add field "Use Item Category Dim."

    fields
    {
        field(25006000; "Vehicle Assembly Nos."; Code[10])
        {
            Caption = 'Vehicle Assembly Nos.';
            TableRelation = "No. Series";
        }
        field(25006001; "Vehicle Serial No. Nos."; Code[10])
        {
            Caption = 'Vehicle Serial No. Nos.';
            TableRelation = "No. Series";
        }
        field(25006002; "Vehicle Acc. Cycle Nos."; Code[10])
        {
            Caption = 'Vehicle Acc. Cycle Nos.';
            TableRelation = "No. Series";
        }
        field(25006005; "Fill Item Group Def. Dimension"; Boolean)
        {
            Caption = 'Fill Item Group Def. Dimension';
        }
        field(25006010; "Post Veh. Add. Charges on Sale"; Boolean)
        {
            Caption = 'Post Vehicle Additional Charges on Sale';

            trigger OnValidate()
            begin
                if "Post Veh. Add. Charges on Sale" <> xRec."Post Veh. Add. Charges on Sale" then begin
                    ItemLedgEntry.Reset;
                    ItemLedgEntry.SetCurrentkey("Item Type");
                    ItemLedgEntry.SetRange("Item Type", ItemLedgEntry."item type"::"Model Version");
                    if ItemLedgEntry.FindFirst then Error(Text100, ItemLedgEntry.TableCaption)
                end;
            end;
        }
        field(25006020; "Vehicle Assembly Document Nos."; Code[10])
        {
            Caption = 'Vehicle Assembly Document Nos.';
            TableRelation = "No. Series";
        }
        field(25006030; "Def. Model Version Item Cat."; Code[10])
        {
            Caption = 'Def. Model Version Item Category';
            TableRelation = "Item Category";
        }
        field(25006040; "Vehicle Special Costing"; Boolean)
        {
            Caption = 'Vehicle Special Costing';
        }
        field(25006050; "Vehicle Original Cost Date"; Boolean)
        {
            Caption = 'Vehicle Original Cost Date';
        }
        field(25006060; "Only Ship R. on Pick/Put Post."; Boolean)
        {
            Caption = 'Only Ship and Receive on Pick and Putaway Posting';
            DataClassification = ToBeClassified;
        }
        field(25006070; "Updt. Markup Pr. on Refr. Cost"; Option)
        {
            Caption = 'Update Markup Price on Refresh Cost';
            DataClassification = ToBeClassified;
            OptionCaption = 'No update,Silent Update,Update and Show';
            OptionMembers = "No update","Silent Update","Update and Show";
        }
        Field(25006080; "Refresh Costs on Release"; Boolean)
        {
            Caption = 'Refresh Costs on Release';
        }
    }

    var
        ItemLedgEntry: Record "Item Ledger Entry";
        Text100: label 'There are records in Table %1.';
}
