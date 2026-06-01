tableextension 25006044 "PhysInventory Ledger Entry" extends "Phys. Inventory Ledger Entry" //281
{
    fields
    {
        field(25006000; "Document Profile"; Option)
        {
            Caption = 'Document Profile';
            OptionCaption = ' ,Spare Parts Trade,Vehicles Trade';
            OptionMembers = ,"Spare Parts Trade","Vehicles Trade";
        }
        field(25006001; "Item Type"; Option)
        {
            Caption = 'Item Type';
            OptionCaption = ' ,Item,Model Version';
            OptionMembers = " ",Item,"Model Version";
        }
        field(25006002; "Make Code"; Code[20])
        {
            Caption = 'Make Code';
            TableRelation = Make;
        }
        field(25006003; "Model Code"; Code[20])
        {
            Caption = 'Model Code';
            TableRelation = Model.Code where("Make Code" = field("Make Code"));
        }
        field(25006004; "Model Version No."; Code[20])
        {
            Caption = 'Model Version No.';
            TableRelation = Item."No." where("Make Code" = field("Make Code"),
                                              "Model Code" = field("Model Code"),
                                              "Item Type" = const("Model Version"));

            trigger OnLookup()
            var
                recItem: Record Item;
            begin
                recItem.SetCurrentkey("Item Type", "Make Code", "Model Code");
                recItem.SetRange("Item Type", recItem."item type"::"Model Version");
                recItem.SetRange("Make Code", "Make Code");
                recItem.SetRange("Model Code", "Model Code");
                if Page.RunModal(Page::"Item List", recItem) = Action::LookupOK then //30.10.2012 EDMS
                 begin
                    Validate("Model Version No.", recItem."No.");
                end;
            end;
        }
        field(25006005; VIN; Code[20])
        {
            Caption = 'VIN';
            TableRelation = Vehicle;
        }

    }
}