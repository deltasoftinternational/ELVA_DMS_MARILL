Codeunit 25006600 "Rent Management"
{

    trigger OnRun()
    begin
    end;


    procedure ShowRentItemServiceEntries(RentItemNo: Code[20])
    var
        RentItemRelation: Record "Rent Item Relation";
        VehicleFilter: Text[256];
        ServiceLedgEntry: Record "Service Ledger Entry EDMS";
        FA: Record "Fixed Asset";
        Vehicle: Record Vehicle;
    begin
        RentItemRelation.Reset;
        RentItemRelation.SetRange("Rent Item No.", RentItemNo);
        if RentItemRelation.FindFirst then begin
            repeat
                if FA.Get(RentItemRelation."Rent Asset No.") then
                    if Vehicle.Get(FA."Vehicle Serial No.") then
                        VehicleFilter += Format(Vehicle."Serial No.") + '|';
            until RentItemRelation.Next = 0;
        end;
        VehicleFilter := DelChr(VehicleFilter, '>', '|');
        ServiceLedgEntry.Reset;
        ServiceLedgEntry.SetCurrentkey("Vehicle Serial No.", "Posting Date", "Entry Type");
        ServiceLedgEntry.SetFilter("Vehicle Serial No.", VehicleFilter);
        Page.RunModal(Page::"Service Ledger Entries EDMS", ServiceLedgEntry);
    end;


    procedure GetMotorhoursByFANo(FANo: Code[20]): Decimal
    var
        FA: Record "Fixed Asset";
        ServiceLedgEntry: Record "Service Ledger Entry EDMS";
        Vehicle: Record Vehicle;
    begin
        if FA.Get(FANo) then
            if Vehicle.Get(FA."Vehicle Serial No.") then begin
                ServiceLedgEntry.Reset;
                ServiceLedgEntry.SetCurrentkey("Vehicle Serial No.", "Posting Date", "Entry Type");
                ServiceLedgEntry.SetRange("Vehicle Serial No.", Vehicle."Serial No.");
                ServiceLedgEntry.SetFilter("Entry Type", '%1|%2', ServiceLedgEntry."entry type"::Usage, ServiceLedgEntry."entry type"::Info);
                //ServiceLedgEntry.SETFILTER("Motor Hours", '<>0');
                //IF ServiceLedgEntry.FINDLAST THEN
                //EXIT(ServiceLedgEntry."Motor Hours");
            end;
    end;

    procedure FindItemsByAttributes(var FilterItemAttributesBuffer: Record "Filter Item Attributes Buffer"; var TempFilteredRentItem: Record "Rent Item" temporary)
    var
        ItemAttributeValueMapping: Record "Item Attribute Value Mapping";
        ItemAttribute: Record "Item Attribute";
        AttributeValueIDFilter: Text;
        ItemAttributeMgt: Codeunit "Item Attribute Management";
    begin
        if not FilterItemAttributesBuffer.FindSet then
            exit;

        ItemAttributeValueMapping.SetRange("Table ID", Database::"Rent Item");

        repeat
            ItemAttribute.SetRange(Name, FilterItemAttributesBuffer.Attribute);
            if ItemAttribute.FindFirst then begin
                ItemAttributeValueMapping.SetRange("Item Attribute ID", ItemAttribute.ID);
                //AttributeValueIDFilter := ItemAttributeMgt.GetItemAttributeValueFilter(FilterItemAttributesBuffer,ItemAttribute); //FIXME
                //GetItemAttributeValueFilter is local in ItemAttributeMgt
                if AttributeValueIDFilter = '' then begin
                    TempFilteredRentItem.DeleteAll;
                    exit;
                end;

                GetFilteredRentItems(ItemAttributeValueMapping, TempFilteredRentItem, AttributeValueIDFilter);
                if TempFilteredRentItem.IsEmpty then
                    exit;
            end;
        until FilterItemAttributesBuffer.Next = 0;
    end;

    local procedure GetItemNoFilter(var ItemAttributeValueMapping: Record "Item Attribute Value Mapping"; PreviousItemNoFilter: Text; AttributeValueIDFilter: Text) RentItemNoFilter: Text
    begin
        ItemAttributeValueMapping.SetFilter("No.", PreviousItemNoFilter);
        ItemAttributeValueMapping.SetFilter("Item Attribute Value ID", AttributeValueIDFilter);

        if not ItemAttributeValueMapping.FindSet then
            exit;

        repeat
            RentItemNoFilter += StrSubstNo('%1|', ItemAttributeValueMapping."No.");
        until ItemAttributeValueMapping.Next = 0;

        exit(CopyStr(RentItemNoFilter, 1, StrLen(RentItemNoFilter) - 1));
    end;

    local procedure GetFilteredRentItems(var ItemAttributeValueMapping: Record "Item Attribute Value Mapping"; var TempFilteredRentItem: Record "Rent Item" temporary; AttributeValueIDFilter: Text)
    var
        RentItem: Record "Rent Item";
    begin
        ItemAttributeValueMapping.SetFilter("Item Attribute Value ID", AttributeValueIDFilter);

        if ItemAttributeValueMapping.IsEmpty then begin
            TempFilteredRentItem.Reset;
            TempFilteredRentItem.DeleteAll;
            exit;
        end;

        if not TempFilteredRentItem.FindSet then begin
            if ItemAttributeValueMapping.FindSet then
                repeat
                    RentItem.Get(ItemAttributeValueMapping."No.");
                    TempFilteredRentItem.TransferFields(RentItem);
                    TempFilteredRentItem.Insert;
                until ItemAttributeValueMapping.Next = 0;
            exit;
        end;

        repeat
            ItemAttributeValueMapping.SetRange("No.", TempFilteredRentItem."No.");
            if ItemAttributeValueMapping.IsEmpty then
                TempFilteredRentItem.Delete;
        until TempFilteredRentItem.Next = 0;
        ItemAttributeValueMapping.SetRange("No.");
    end;

    procedure GetItemNoFilterText(var TempFilteredRentItem: Record "Rent Item" temporary; var ParameterCount: Integer) FilterText: Text
    var
        NextRentItem: Record "Rent Item";
        PreviousNo: Code[20];
        FilterRangeStarted: Boolean;
    begin
        if not TempFilteredRentItem.FindSet then begin
            FilterText := '<>*';
            exit;
        end;

        repeat
            if FilterText = '' then begin
                FilterText := TempFilteredRentItem."No.";
                NextRentItem."No." := TempFilteredRentItem."No.";
                ParameterCount += 1;
            end else begin
                if NextRentItem.Next = 0 then
                    NextRentItem."No." := '';
                if TempFilteredRentItem."No." = NextRentItem."No." then begin
                    if not FilterRangeStarted then
                        FilterText += '..';
                    FilterRangeStarted := true;
                end else begin
                    if not FilterRangeStarted then begin
                        FilterText += StrSubstNo('|%1', TempFilteredRentItem."No.");
                        ParameterCount += 1;
                    end else begin
                        FilterText += StrSubstNo('%1|%2', PreviousNo, TempFilteredRentItem."No.");
                        FilterRangeStarted := false;
                        ParameterCount += 2;
                    end;
                    NextRentItem := TempFilteredRentItem;
                end;
            end;
            PreviousNo := TempFilteredRentItem."No.";
        until TempFilteredRentItem.Next = 0;

        // close range if needed
        if FilterRangeStarted then begin
            FilterText += StrSubstNo('%1', PreviousNo);
            ParameterCount += 1;
        end;
    end;
}

