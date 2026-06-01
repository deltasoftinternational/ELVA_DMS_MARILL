Page 25006646 "Rent Item Attribute Value List"
{
    Caption = 'Rent Item Attribute Values';
    DelayedInsert = true;
    LinksAllowed = false;
    PageType = ListPart;
    SourceTable = "Item Attribute Value Selection";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(Attribute; Rec."Attribute Name")
                {
                    ApplicationArea = Basic, Suite;
                    AssistEdit = false;
                    Caption = 'Attribute';
                    TableRelation = "Item Attribute".Name where(Blocked = const(false));
                    ToolTip = 'Specifies the item attribute.';

                    trigger OnValidate()
                    var
                        ItemAttributeValue: Record "Item Attribute Value";
                        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
                    begin
                        if xRec."Attribute Name" <> '' then
                            DeleteItemAttributeValueMapping(xRec."Attribute ID");

                        if not Rec.FindAttributeValue(ItemAttributeValue) then
                            Rec.InsertItemAttributeValue(ItemAttributeValue, Rec);

                        if ItemAttributeValue.Get(ItemAttributeValue."Attribute ID", ItemAttributeValue.ID) then begin
                            ItemAttributeValueMapping.Reset;
                            ItemAttributeValueMapping.Init;
                            ItemAttributeValueMapping."Table ID" := Database::"Rent Item";
                            ItemAttributeValueMapping."No." := RelatedRecordCode;
                            ItemAttributeValueMapping."Item Attribute ID" := ItemAttributeValue."Attribute ID";
                            ItemAttributeValueMapping."Item Attribute Value ID" := ItemAttributeValue.ID;
                            ItemAttributeValueMapping.Insert;
                        end;
                    end;
                }
                field(Value; Rec.Value)
                {
                    ApplicationArea = Basic, Suite;
                    Caption = 'Value';
                    TableRelation = if ("Attribute Type" = const(Option)) "Item Attribute Value".Value where("Attribute ID" = field("Attribute ID"),
                                                                                                            Blocked = const(false));
                    ToolTip = 'Specifies the value of the item attribute.';

                    trigger OnValidate()
                    var
                        ItemAttributeValue: Record "Item Attribute Value";
                        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
                        ItemAttribute: Record "Item Attribute";
                    begin
                        if not Rec.FindAttributeValue(ItemAttributeValue) then
                            Rec.InsertItemAttributeValue(ItemAttributeValue, Rec);

                        ItemAttributeValueMapping.SetRange("Table ID", Database::"Rent Item");
                        ItemAttributeValueMapping.SetRange("No.", RelatedRecordCode);
                        ItemAttributeValueMapping.SetRange("Item Attribute ID", ItemAttributeValue."Attribute ID");

                        if ItemAttributeValueMapping.FindFirst then begin
                            ItemAttributeValueMapping."Item Attribute Value ID" := ItemAttributeValue.ID;
                            ItemAttributeValueMapping.Modify;
                        end;

                        ItemAttribute.Get(Rec."Attribute ID");
                        if ItemAttribute.Type <> ItemAttribute.Type::Option then
                            if Rec.FindAttributeValueFromRecord(ItemAttributeValue, xRec) then
                                if not ItemAttributeValue.HasBeenUsed then
                                    ItemAttributeValue.Delete;
                    end;
                }
                field(UnitofMeasure; Rec."Unit of Measure")
                {
                    ApplicationArea = Basic, Suite;
                    ToolTip = 'Specifies the name of the item or resource''s unit of measure, such as piece or hour.';
                }
            }
        }
    }

    actions
    {
    }

    trigger OnDeleteRecord(): Boolean
    begin
        DeleteItemAttributeValueMapping(Rec."Attribute ID");
    end;

    trigger OnOpenPage()
    begin
        CurrPage.Editable(true);
    end;

    var
        RelatedRecordCode: Code[20];

    procedure LoadAttributes(RentItemNo: Code[20])
    var
        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
        TempItemAttributeValue: Record "Item Attribute Value" temporary;
        ItemAttributeValue: Record "Item Attribute Value";
    begin
        RelatedRecordCode := RentItemNo;
        ItemAttributeValueMapping.SetRange("Table ID", Database::"Rent Item");
        ItemAttributeValueMapping.SetRange("No.", RentItemNo);
        if ItemAttributeValueMapping.FindSet then
            repeat
                ItemAttributeValue.Get(ItemAttributeValueMapping."Item Attribute ID", ItemAttributeValueMapping."Item Attribute Value ID");
                TempItemAttributeValue.TransferFields(ItemAttributeValue);
                TempItemAttributeValue.Insert;
            until ItemAttributeValueMapping.Next = 0;

        Rec.PopulateItemAttributeValueSelection(TempItemAttributeValue);
    end;

    local procedure DeleteItemAttributeValueMapping(AttributeToDeleteID: Integer)
    var
        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
        ItemAttribute: Record "Item Attribute";
    begin
        ItemAttributeValueMapping.SetRange("Table ID", Database::"Rent Item");
        ItemAttributeValueMapping.SetRange("No.", RelatedRecordCode);
        ItemAttributeValueMapping.SetRange("Item Attribute ID", AttributeToDeleteID);
        if ItemAttributeValueMapping.FindFirst then
            ItemAttributeValueMapping.Delete;

        ItemAttribute.Get(AttributeToDeleteID);
        ItemAttribute.RemoveUnusedArbitraryValues;
    end;
}

