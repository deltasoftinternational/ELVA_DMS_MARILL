tableextension 25006380 "Item Attribute Value" extends "Item Attribute Value" //7501
{
    fields
    {

    }

    procedure LoadIRenttemAttributesFactBoxData(KeyValue: Code[20])
    var
        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
        ItemAttributeValue: Record "Item Attribute Value";
    begin
        Reset;
        DeleteAll;
        ItemAttributeValueMapping.SetRange("Table ID", Database::"Rent Item");
        ItemAttributeValueMapping.SetRange("No.", KeyValue);
        if ItemAttributeValueMapping.FindSet then
            repeat
                if ItemAttributeValue.Get(ItemAttributeValueMapping."Item Attribute ID", ItemAttributeValueMapping."Item Attribute Value ID") then begin
                    TransferFields(ItemAttributeValue);
                    Insert;
                end
            until ItemAttributeValueMapping.Next = 0;
    end;

}