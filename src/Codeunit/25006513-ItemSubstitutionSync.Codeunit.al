Codeunit 25006513 "Item Substitution Sync"
{
    // 28.08.2014 EDMS P8
    //   * Use of new page "Item Replacement Overview"
    // 
    // 03.04.2014 Elva Baltic P15 #F124 MMG7.00
    //   * Added func: ShowReplacementOverview
    // 
    // 26.03.2014 Elva baltic P15 #F124 MMG7.00
    //   * Added Func: GetNextReplacementNo
    // 
    // 08.04.2008. EDMS P2
    //   * Added code InsertItemSub
    // 
    // 16.10.2007. EDMS P2
    //   * Created


    trigger OnRun()
    begin
    end;

    var
        ItemSync: Record Item;
        ItemSync2: Record Item;
        NonstockItemSync: Record "Nonstock Item";
        NonstockItemSync2: Record "Nonstock Item";
        ItemSubSync: Record "Item Substitution";
        ItemSubSync2: Record "Item Substitution";
        SubContentSync: Record "Substitution Condition";
        SubContentSync2: Record "Substitution Condition";
        ChooseReplacementTxt: label 'Please choose the replacement condition group:';
        SalesSetup: Record "Sales & Receivables Setup";
        ReplaceInfoTxt: label 'Item %1 replaced by %2';
        ReplaceConfirmInvTxt: label 'Item %1 is in inventory. Would you like to apply replacements?';
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        PurchaseSetup: Record "Purchases & Payables Setup";
        TempServiceLine: Record "Service Line EDMS";
        ItemSubstitution: Record "Item Substitution";
        TempItemSubstitution: Record "Item Substitution" temporary;
        CompanyInfo: Record "Company Information";
        AvailToPromise: Codeunit "Available to Promise";
        SaveItemNo: Code[20];
        SaveVariantCode: Code[10];
        SaveDropShip: Boolean;
        GrossReq: Decimal;
        SchedRcpt: Decimal;
        SaveQty: Decimal;
        SaveLocation: Code[10];
        OldSalesUOM: Code[10];
        Item: Record Item;
        NonStockItem: Record "Nonstock Item";
        ServiceHeader: Record "Service Header EDMS";
        TempSalesLine: Record "Sales Line" temporary;
        Text001: Label 'An Item Substitution with the specified variant does not exist for Item No. ''%1''.';
        Text101: label 'This item No. has been replaced. Check substitutions';
        Text102: label 'There is a replaced item in inventory. Check substitutions';
        Text103: label 'Item %1 has been discontinued and is not available';


    procedure InsertItemSub(ItemSub: Record "Item Substitution")
    begin
        ItemSubSync.DontDeleteInterchangeableItem; //08.04.2008. EDMS P2
        if (ItemSub.Type = ItemSub.Type::Item) and (ItemSub."Substitute Type" = ItemSub."substitute type"::Item) then begin
            NonstockItemSync.Reset;
            NonstockItemSync2.Reset;
            NonstockItemSync.SetCurrentkey("Item No.");
            NonstockItemSync2.SetCurrentkey("Item No.");
            NonstockItemSync.SetRange("Item No.", ItemSub."No.");
            NonstockItemSync2.SetRange("Item No.", ItemSub."Substitute No.");
            if NonstockItemSync.FindFirst and NonstockItemSync2.FindFirst then begin
                ItemSubSync.Type := ItemSubSync.Type::"Nonstock Item";
                ItemSubSync."No." := NonstockItemSync."Entry No.";
                ItemSubSync."Substitute Type" := ItemSubSync."substitute type"::"Nonstock Item";
                ItemSubSync."Substitute No." := NonstockItemSync2."Entry No.";
                if ItemSubSync.Find then
                    exit;

                ItemSubSync.Init;
                ItemSubSync.TransferFields(ItemSub);
                ItemSubSync.Type := ItemSubSync.Type::"Nonstock Item";
                ItemSubSync."No." := NonstockItemSync."Entry No.";
                ItemSubSync."Substitute Type" := ItemSubSync."substitute type"::"Nonstock Item";
                ItemSubSync.SetItemVariantDescription(ItemSubSync."Substitute Type".AsInteger(), ItemSubSync."Substitute No.", ItemSubSync."Substitute Variant Code", ItemSubSync.Description);
                ItemSubSync."Substitute No." := NonstockItemSync2."Entry No.";
                ItemSubSync.Interchangeable := ItemSub.Interchangeable;
                ItemSubSync.Insert;
            end;
        end;

        if (ItemSub.Type = ItemSub.Type::"Nonstock Item") and
           (ItemSub."Substitute Type" = ItemSub."substitute type"::"Nonstock Item")
        then begin
            NonstockItemSync.Get(ItemSub."No.");
            NonstockItemSync2.Get(ItemSub."Substitute No.");
            if ItemSync.Get(NonstockItemSync."Item No.") and ItemSync2.Get(NonstockItemSync2."Item No.") then begin
                ItemSubSync.Type := ItemSubSync.Type::Item;
                ItemSubSync."No." := ItemSync."No.";
                ItemSubSync."Substitute Type" := ItemSubSync."substitute type"::Item;
                ItemSubSync."Substitute No." := ItemSync2."No.";
                if ItemSubSync.Find then
                    exit;

                ItemSubSync.Init;
                ItemSubSync.TransferFields(ItemSub);
                ItemSubSync.Type := ItemSubSync.Type::Item;
                ItemSubSync."No." := ItemSync."No.";
                ItemSubSync."Substitute Type" := ItemSubSync."substitute type"::Item;
                ItemSubSync."Substitute No." := ItemSync2."No.";
                ItemSubSync.Interchangeable := ItemSub.Interchangeable;
                ItemSubSync.Insert;
            end;
        end;
    end;


    procedure ModifyItemSub(ItemSub: Record "Item Substitution")
    begin
        if (ItemSub.Type = ItemSub.Type::Item) and (ItemSub."Substitute Type" = ItemSub."substitute type"::Item) then begin
            NonstockItemSync.Reset;
            NonstockItemSync2.Reset;
            NonstockItemSync.SetCurrentkey("Item No.");
            NonstockItemSync2.SetCurrentkey("Item No.");
            NonstockItemSync.SetRange("Item No.", ItemSub."No.");
            NonstockItemSync2.SetRange("Item No.", ItemSub."Substitute No.");
            if NonstockItemSync.FindFirst and NonstockItemSync2.FindFirst then begin
                ItemSubSync.Type := ItemSubSync.Type::"Nonstock Item";
                ItemSubSync."No." := NonstockItemSync."Entry No.";
                ItemSubSync."Substitute Type" := ItemSubSync."substitute type"::"Nonstock Item";
                ItemSubSync."Substitute No." := NonstockItemSync2."Entry No.";
                if not ItemSubSync.Find then
                    exit;

                ItemSubSync.Validate(Description, ItemSub.Description);
                ItemSubSync.Validate(Interchangeable, ItemSub.Interchangeable);
                ItemSubSync.Validate("Quantity Avail. on Shpt. Date", ItemSub."Quantity Avail. on Shpt. Date");
                ItemSubSync.Validate("Shipment Date", ItemSub."Shipment Date");
                ItemSubSync.Validate("Replacement Info.", ItemSub."Replacement Info.");
                ItemSubSync.Modify;
            end;
        end;

        if (ItemSub.Type = ItemSub.Type::"Nonstock Item") and
           (ItemSub."Substitute Type" = ItemSub."substitute type"::"Nonstock Item")
        then begin
            NonstockItemSync.Get(ItemSub."No.");
            NonstockItemSync2.Get(ItemSub."Substitute No.");
            if ItemSync.Get(NonstockItemSync."Item No.") and ItemSync2.Get(NonstockItemSync2."Item No.") then begin
                ItemSubSync.Type := ItemSubSync.Type::Item;
                ItemSubSync."No." := ItemSync."No.";
                ItemSubSync."Substitute Type" := ItemSubSync."substitute type"::Item;
                ItemSubSync."Substitute No." := ItemSync2."No.";
                if not ItemSubSync.Find then
                    exit;

                ItemSubSync.Validate(Description, ItemSub.Description);
                ItemSubSync.Validate(Interchangeable, ItemSub.Interchangeable);
                ItemSubSync.Validate("Quantity Avail. on Shpt. Date", ItemSub."Quantity Avail. on Shpt. Date");
                ItemSubSync.Validate("Shipment Date", ItemSub."Shipment Date");
                ItemSubSync.Validate("Replacement Info.", ItemSub."Replacement Info.");
                ItemSubSync.Modify;

            end;
        end;
    end;


    procedure DeleteItemSub(ItemSub: Record "Item Substitution"; DeleteInterItem: Boolean)
    var
        SubCondition: Record "Substitution Condition";
    begin
        if (ItemSub.Type = ItemSub.Type::Item) and (ItemSub."Substitute Type" = ItemSub."substitute type"::Item) then begin
            NonstockItemSync.Reset;
            NonstockItemSync2.Reset;
            NonstockItemSync.SetCurrentkey("Item No.");
            NonstockItemSync2.SetCurrentkey("Item No.");
            NonstockItemSync.SetRange("Item No.", ItemSub."No.");
            NonstockItemSync2.SetRange("Item No.", ItemSub."Substitute No.");
            if NonstockItemSync.FindFirst and NonstockItemSync2.FindFirst then begin
                ItemSubSync.Type := ItemSubSync.Type::"Nonstock Item";
                ItemSubSync."No." := NonstockItemSync."Entry No.";
                ItemSubSync."Substitute Type" := ItemSubSync."substitute type"::"Nonstock Item";
                ItemSubSync."Substitute No." := NonstockItemSync2."Entry No.";
                if not ItemSubSync.Find then
                    exit;

                if ItemSubSync.Interchangeable then
                    if DeleteInterItem then
                        ItemSubSync.DeleteInterchangeableItem(ItemSubSync.Type, ItemSubSync."No.", ItemSubSync."Variant Code",
                               ItemSubSync."Substitute Type", ItemSubSync."Substitute No.", ItemSubSync."Substitute Variant Code")
                    else
                        if ItemSub.Get(ItemSubSync."Substitute Type", ItemSubSync."Substitute No.", ItemSubSync."Substitute Variant Code",
                                      ItemSubSync.Type, ItemSubSync."No.", ItemSubSync."Variant Code")
                        then begin
                            ItemSub.Interchangeable := false;
                            ItemSub.Modify;
                        end;

                ItemSubSync.CalcFields(Condition);
                if ItemSubSync.Condition then begin
                    SubCondition.SetRange(Type, ItemSubSync.Type);
                    SubCondition.SetRange("No.", ItemSubSync."No.");
                    SubCondition.SetRange("Variant Code", ItemSubSync."Variant Code");
                    SubCondition.SetRange("Substitute Type", ItemSubSync."Substitute Type");
                    SubCondition.SetRange("Substitute No.", ItemSubSync."Substitute No.");
                    SubCondition.SetRange("Substitute Variant Code", ItemSubSync."Substitute Variant Code");
                    SubCondition.DeleteAll;
                end;

                ItemSubSync.Delete;
            end;
        end;

        if (ItemSub.Type = ItemSub.Type::"Nonstock Item") and
           (ItemSub."Substitute Type" = ItemSub."substitute type"::"Nonstock Item")
        then begin
            if NonstockItemSync.Get(ItemSub."No.") then;
            if (NonstockItemSync.Get(ItemSub."No.")) and (NonstockItemSync2.Get(ItemSub."Substitute No.")) then begin
                ItemSubSync.Type := ItemSubSync.Type::Item;
                ItemSubSync."No." := NonstockItemSync."Item No.";
                ItemSubSync."Substitute Type" := ItemSubSync."substitute type"::Item;
                ItemSubSync."Substitute No." := NonstockItemSync2."Item No.";
                if not ItemSubSync.Find then
                    exit;

                if ItemSubSync.Interchangeable then
                    if DeleteInterItem then
                        ItemSubSync.DeleteInterchangeableItem(ItemSubSync.Type, ItemSubSync."No.", ItemSubSync."Variant Code",
                               ItemSubSync."Substitute Type", ItemSubSync."Substitute No.", ItemSubSync."Substitute Variant Code")
                    else
                        if ItemSub.Get(ItemSubSync."Substitute Type", ItemSubSync."Substitute No.", ItemSubSync."Substitute Variant Code",
                                      ItemSubSync.Type, ItemSubSync."No.", ItemSubSync."Variant Code")
                        then begin
                            ItemSub.Interchangeable := false;
                            ItemSub.Modify;
                        end;

                ItemSubSync.CalcFields(Condition);
                if ItemSubSync.Condition then begin
                    SubCondition.SetRange(Type, ItemSubSync.Type);
                    SubCondition.SetRange("No.", ItemSubSync."No.");
                    SubCondition.SetRange("Variant Code", ItemSubSync."Variant Code");
                    SubCondition.SetRange("Substitute Type", ItemSubSync."Substitute Type");
                    SubCondition.SetRange("Substitute No.", ItemSubSync."Substitute No.");
                    SubCondition.SetRange("Substitute Variant Code", ItemSubSync."Substitute Variant Code");
                    SubCondition.DeleteAll;
                end;

                ItemSubSync.Delete(true);
            end;
        end;
    end;


    procedure RenameItemSub(ItemSubNew: Record "Item Substitution"; ItemSubOld: Record "Item Substitution")
    var
        SubCondition: Record "Substitution Condition";
        SubCondition2: Record "Substitution Condition";
    begin
        if (ItemSubNew.Type = ItemSubNew.Type::Item) and (ItemSubNew."Substitute Type" = ItemSubNew."substitute type"::Item) then begin
            NonstockItemSync.Reset;
            NonstockItemSync2.Reset;
            NonstockItemSync.SetCurrentkey("Item No.");
            NonstockItemSync2.SetCurrentkey("Item No.");
            NonstockItemSync.SetRange("Item No.", ItemSubNew."No.");
            NonstockItemSync2.SetRange("Item No.", ItemSubNew."Substitute No.");
            if NonstockItemSync.FindFirst and NonstockItemSync2.FindFirst then begin
                ItemSubSync.Type := ItemSubSync.Type::"Nonstock Item";
                ItemSubSync."No." := ItemSubOld."No.";
                ItemSubSync."Substitute Type" := ItemSubSync."substitute type"::"Nonstock Item";
                ItemSubSync."Substitute No." := ItemSubOld."Substitute No.";
                if not ItemSubSync.Find then
                    exit;

                ItemSubSync2.Init;
                ItemSubSync2.TransferFields(ItemSubSync);
                ItemSubSync2.Validate("No.", NonstockItemSync."Entry No.");
                ItemSubSync2.Validate("Substitute No.", NonstockItemSync2."Entry No.");
                if ItemSubSync2.Insert then;

                ItemSubSync.CalcFields(Condition);
                if ItemSubSync.Condition then begin
                    SubCondition.SetRange(Type, ItemSubSync.Type);
                    SubCondition.SetRange("No.", ItemSubSync."No.");
                    SubCondition.SetRange("Variant Code", ItemSubSync."Variant Code");
                    SubCondition.SetRange("Substitute Type", ItemSubSync."Substitute Type");
                    SubCondition.SetRange("Substitute No.", ItemSubSync."Substitute No.");
                    SubCondition.SetRange("Substitute Variant Code", ItemSubSync."Substitute Variant Code");
                    if SubCondition.FindFirst then
                        repeat
                            SubCondition2.Init;
                            SubCondition2.TransferFields(SubCondition);
                            SubCondition2.Validate("No.", NonstockItemSync."Entry No.");
                            SubCondition2.Validate("Substitute No.", NonstockItemSync2."Entry No.");
                            if SubCondition2.Insert then;
                        until SubCondition.Next = 0;
                    SubCondition.DeleteAll;
                end;

                ItemSubSync.Delete;
            end;
        end;

        if (ItemSubNew.Type = ItemSubNew.Type::"Nonstock Item") and
           (ItemSubNew."Substitute Type" = ItemSubNew."substitute type"::"Nonstock Item")
        then begin
            NonstockItemSync.Get(ItemSubNew."No.");
            NonstockItemSync2.Get(ItemSubNew."Substitute No.");
            if ItemSync.Get(NonstockItemSync."Item No.") and ItemSync2.Get(NonstockItemSync2."Item No.") then begin
                ItemSubSync.Type := ItemSubSync.Type::Item;
                ItemSubSync."No." := ItemSubOld."No.";
                ItemSubSync."Substitute Type" := ItemSubSync."substitute type"::Item;
                ItemSubSync."Substitute No." := ItemSubOld."Substitute No.";
                if not ItemSubSync.Find then
                    exit;

                ItemSubSync2.Init;
                ItemSubSync2.TransferFields(ItemSubSync);
                ItemSubSync2.Validate("No.", ItemSync."No.");
                ItemSubSync2.Validate("Substitute No.", ItemSync2."No.");
                if ItemSubSync2.Insert then;

                ItemSubSync.CalcFields(Condition);
                if ItemSubSync.Condition then begin
                    SubCondition.SetRange(Type, ItemSubSync.Type);
                    SubCondition.SetRange("No.", ItemSubSync."No.");
                    SubCondition.SetRange("Variant Code", ItemSubSync."Variant Code");
                    SubCondition.SetRange("Substitute Type", ItemSubSync."Substitute Type");
                    SubCondition.SetRange("Substitute No.", ItemSubSync."Substitute No.");
                    SubCondition.SetRange("Substitute Variant Code", ItemSubSync."Substitute Variant Code");
                    if SubCondition.FindFirst then
                        repeat
                            SubCondition2.Init;
                            SubCondition2.TransferFields(SubCondition);
                            SubCondition2.Validate("No.", ItemSync."No.");
                            SubCondition2.Validate("Substitute No.", ItemSync2."No.");
                            if SubCondition2.Insert then;
                        until SubCondition.Next = 0;
                    SubCondition.DeleteAll;
                end;

                ItemSubSync.Delete;

            end;
        end;
    end;


    procedure SyncSubContent(SubContent: Record "Substitution Condition"; NotDelete: Boolean)
    begin
        if (SubContent.Type = SubContent.Type::Item) and (SubContent."Substitute Type" = SubContent."substitute type"::Item) then begin
            SubContentSync.Reset;
            SubContentSync.SetRange(Type, SubContentSync.Type::"Nonstock Item");
            SubContentSync.SetRange("No.", SubContent."No.");
            SubContentSync.SetRange("Variant Code", SubContent."Variant Code");
            SubContentSync.SetRange("Substitute Type", SubContentSync."substitute type"::"Nonstock Item");
            SubContentSync.SetRange("Substitute No.", SubContent."Substitute No.");
            SubContentSync.DeleteAll;

            if ItemSubSync.Get(ItemSubSync.Type::"Nonstock Item", SubContent."No.", SubContent."Variant Code",
                         ItemSubSync."substitute type"::"Nonstock Item", SubContent."Substitute No.", SubContent."Substitute Variant Code")
            then begin
                SubContentSync.Reset;
                SubContentSync.SetRange(Type, SubContent.Type);
                SubContentSync.SetRange("No.", SubContent."No.");
                SubContentSync.SetRange("Variant Code", SubContent."Variant Code");
                SubContentSync.SetRange("Substitute Type", SubContent."Substitute Type");
                SubContentSync.SetRange("Substitute No.", SubContent."Substitute No.");
                if SubContentSync.FindFirst then
                    repeat
                        SubContentSync2.Init;
                        SubContentSync2.TransferFields(SubContentSync);
                        SubContentSync2.Validate(Type, SubContentSync2.Type::"Nonstock Item");
                        SubContentSync2.Validate("Substitute Type", SubContentSync2."substitute type"::"Nonstock Item");
                        SubContentSync2.Insert;
                    until SubContentSync.Next = 0;

                if NotDelete then begin
                    ItemSubSync2.Reset;
                    if SubContentSync2.Get(SubContentSync2.Type::"Nonstock Item", SubContent."No.", SubContent."Variant Code",
                        SubContentSync2."substitute type"::"Nonstock Item", SubContent."Substitute No.", SubContent."Substitute Variant Code",
                        SubContent."Line No.")
                    then begin
                        SubContentSync2.Condition := SubContent.Condition;
                        SubContentSync2.Modify;
                    end else begin
                        SubContentSync2.TransferFields(SubContent);
                        SubContentSync2.Validate(Type, SubContentSync2.Type::"Nonstock Item");
                        SubContentSync2.Validate("Substitute Type", SubContentSync2."substitute type"::"Nonstock Item");
                        SubContentSync2.Insert;
                    end;
                end else
                    if SubContentSync2.Get(SubContentSync2.Type::"Nonstock Item", SubContent."No.", SubContent."Variant Code",
                        SubContentSync2."substitute type"::"Nonstock Item", SubContent."Substitute No.", SubContent."Substitute Variant Code",
                        SubContent."Line No.")
                    then
                        SubContentSync2.Delete;

            end;
        end;

        if (SubContent.Type = SubContent.Type::"Nonstock Item") and
           (SubContent."Substitute Type" = SubContent."substitute type"::"Nonstock Item")
        then begin
            SubContentSync.Reset;
            SubContentSync.SetRange(Type, SubContentSync.Type::Item);
            SubContentSync.SetRange("No.", SubContent."No.");
            SubContentSync.SetRange("Variant Code", SubContent."Variant Code");
            SubContentSync.SetRange("Substitute Type", SubContentSync."substitute type"::Item);
            SubContentSync.SetRange("Substitute No.", SubContent."Substitute No.");
            SubContentSync.DeleteAll;

            if ItemSubSync.Get(ItemSubSync.Type::Item, SubContent."No.", SubContent."Variant Code",
                       ItemSubSync."substitute type"::Item, SubContent."Substitute No.", SubContent."Substitute Variant Code")
            then begin

                SubContentSync.Reset;
                SubContentSync.SetRange(Type, SubContent.Type);
                SubContentSync.SetRange("No.", SubContent."No.");
                SubContentSync.SetRange("Variant Code", SubContent."Variant Code");
                SubContentSync.SetRange("Substitute Type", SubContent."Substitute Type");
                SubContentSync.SetRange("Substitute No.", SubContent."Substitute No.");
                if SubContentSync.FindFirst then
                    repeat
                        SubContentSync2.Init;
                        SubContentSync2.TransferFields(SubContentSync);
                        SubContentSync2.Validate(Type, SubContentSync2.Type::Item);
                        SubContentSync2.Validate("Substitute Type", SubContentSync2."substitute type"::Item);
                        SubContentSync2.Insert;
                    until SubContentSync.Next = 0;

                if NotDelete then begin
                    ItemSubSync2.Reset;
                    if SubContentSync2.Get(SubContentSync2.Type::Item, SubContent."No.", SubContent."Variant Code",
                        SubContentSync2."substitute type"::Item, SubContent."Substitute No.", SubContent."Substitute Variant Code",
                        SubContent."Line No.")
                    then begin
                        SubContentSync2.Condition := SubContent.Condition;
                        SubContentSync2.Modify;
                    end else begin
                        SubContentSync2.TransferFields(SubContent);
                        SubContentSync2.Validate(Type, SubContentSync2.Type::Item);
                        SubContentSync2.Validate("Substitute Type", SubContentSync2."substitute type"::Item);
                        SubContentSync2.Insert;
                    end;
                end else
                    if SubContentSync2.Get(SubContentSync2.Type::Item, SubContent."No.", SubContent."Variant Code",
                        SubContentSync2."substitute type"::Item, SubContent."Substitute No.", SubContent."Substitute Variant Code",
                        SubContent."Line No.")
                    then
                        SubContentSync2.Delete;


            end;
        end;
    end;


    procedure GetNextReplacementNo(var TypePar: Option Item,"Nonstock Item"; var NoPar: Code[20]; var VariantCodePar: Code[10]; ReplInfoPar: Option " ",Replace,Replacement)
    var
        ItemSubst: Record "Item Substitution";
    begin
        //26.03.2014 Elva baltic P15 #F124 MMG7.00 - created

        // Option ReplInfoPar means: Replace = "Replaced by" (forward direction); Replacement = "Replaces" (backward)
        ItemSubst.Reset;
        ItemSubst.SetRange("Entry Type", ItemSubst."entry type"::Replacement);  //Only Replacement entry
        ItemSubst.SetRange(Type, TypePar);

        ItemSubst.SetRange("Variant Code", VariantCodePar);
        ItemSubst.SetRange("Replacement Info.", ReplInfoPar); //search direction (backward/forward)

        ItemSubst.SetRange("No.", NoPar);
        if ItemSubst.FindFirst then;
        TypePar := ItemSubst."Substitute Type";
        NoPar := ItemSubst."Substitute No.";
        VariantCodePar := ItemSubst."Substitute Variant Code";
        //10 rows
    end;


    procedure ShowReplacementOverview(Type1: Option; No1: Code[20]; VarCode1: Code[10])
    var
        ItemSubstSync: Codeunit "Item Substitution Sync";
        ReplInfoPar: Option " ",Replace,Replacement;
        TypePar: Option Item,"Nonstock Item";
        NoPar: Code[20];
        VariantCodePar: Code[10];
        PrevTypePar: Option Item,"Nonstock Item";
        PrevNoPar: Code[20];
        PrevVariantCodePar: Code[10];
        CurrKey: Integer;
        DataBuffer: Record "Data Buffer" temporary;
        ItemReplOverview: Page "Item Replacement Overview";
    begin
        //03.04.2014 Elva Baltic P15 #F124 MMG7.00 >>
        DataBuffer.Reset;
        DataBuffer.DeleteAll;

        //set search values
        TypePar := Type1;
        NoPar := No1;
        VariantCodePar := VarCode1;

        CurrKey := 0;
        ReplInfoPar := Replinfopar::Replacement; //about turn and forward (i.e. backward)
        repeat
            PrevTypePar := TypePar;
            PrevNoPar := NoPar;
            PrevVariantCodePar := VariantCodePar;

            ItemSubstSync.GetNextReplacementNo(TypePar, NoPar, VariantCodePar, ReplInfoPar);
            if NoPar <> '' then begin
                CurrKey -= 1;
                DataBuffer.Init;
                DataBuffer.Validate("Entry No.", CurrKey);
                DataBuffer.Validate("Text Field 1", Format(TypePar));
                DataBuffer.Validate("Code Field 1", NoPar);
                DataBuffer.Validate("Code Field 2", VariantCodePar);
                DataBuffer.Validate("Text Field 2", Format(PrevTypePar));
                DataBuffer.Validate("Code Field 3", PrevNoPar);
                DataBuffer.Validate("Code Field 4", PrevVariantCodePar);
                DataBuffer.Insert(true);
            end;
        until NoPar = '';

        //restore initial search values
        TypePar := Type1;
        NoPar := No1;
        VariantCodePar := VarCode1;

        ReplInfoPar := Replinfopar::Replace; //forward
        CurrKey := 0;
        repeat
            PrevTypePar := TypePar;
            PrevNoPar := NoPar;
            PrevVariantCodePar := VariantCodePar;

            ItemSubstSync.GetNextReplacementNo(TypePar, NoPar, VariantCodePar, ReplInfoPar);
            if NoPar <> '' then begin
                CurrKey += 1;
                DataBuffer.Init;
                DataBuffer.Validate("Entry No.", CurrKey);
                DataBuffer.Validate("Text Field 1", Format(PrevTypePar));
                DataBuffer.Validate("Code Field 1", PrevNoPar);
                DataBuffer.Validate("Code Field 2", PrevVariantCodePar);
                DataBuffer.Validate("Text Field 2", Format(TypePar));
                DataBuffer.Validate("Code Field 3", NoPar);
                DataBuffer.Validate("Code Field 4", VariantCodePar);
                DataBuffer.Insert(true);
            end;
        until NoPar = '';
        Page.Run(Page::"Item Replacement Overview", DataBuffer);

        // 03.04.2014 Elva Baltic P15 #F124 MMG7.00 <<
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'No.', false, false)]

    procedure CheckItemReplacementOnSalesLineNoValidate(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        NonstockItem: Record "Nonstock Item";
        IsHandled: Boolean;
    begin
        if Rec.Type = Rec.Type::Item then begin
            OnBeforeCheckItemReplacementOnSalesLineNoValidate(Rec, IsHandled);
            If IsHandled Then
                exit;
            NonstockItem.Reset;
            NonstockItem.SetRange("Item No.", Rec."No.");
            if NonstockItem.FindFirst then
                Rec."Has Replacement" := CheckReplacementsByNonstockEntryNo(NonstockItem."Entry No.");
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterValidateEvent', 'No.', false, false)]

    procedure CheckItemReplacementOnPurchaseLineNoValidate(var Rec: Record "Purchase Line"; var xRec: Record "Purchase Line"; CurrFieldNo: Integer)
    var
        NonstockItem: Record "Nonstock Item";
        IsHandled: Boolean;
    begin
        if Rec.Type = Rec.Type::Item then begin
            OnBeforeCheckItemReplacementOnPurchaseLineNoValidate(Rec, IsHandled);
            If IsHandled Then
                exit;
            NonstockItem.Reset;
            NonstockItem.SetRange("Item No.", Rec."No.");
            if NonstockItem.FindFirst then
                Rec."Has Replacement" := CheckReplacementsByNonstockEntryNo(NonstockItem."Entry No.");
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Service Line EDMS", 'OnAfterValidateEvent', 'No.', false, false)]

    procedure CheckItemReplacementOnServiceLineNoValidate(var Rec: Record "Service Line EDMS"; var xRec: Record "Service Line EDMS"; CurrFieldNo: Integer)
    var
        NonstockItem: Record "Nonstock Item";
    begin
        if Rec.Type = Rec.Type::Item then begin
            NonstockItem.Reset;
            NonstockItem.SetRange("Item No.", Rec."No.");
            if NonstockItem.FindFirst then
                Rec."Has Replacement" := CheckReplacementsByNonstockEntryNo(NonstockItem."Entry No.");
        end;
    end;




    procedure ReplaceSalesLineItemNo(var SalesLine: Record "Sales Line")
    var
        ReplacementsFound: Boolean;
        FirstLine: Boolean;
        Replacements: Record "Item Substitution" temporary;
        NonstockItem: Record "Nonstock Item";
        NonstockItem2: Record "Nonstock Item";
        NonstockItemMgt: Codeunit "Catalog Item Management";
        SalesLineNo: Integer;
        SalesLine2: Record "Sales Line";
        ReplacementInfo: Text[250];
        OldItemNo: Code[20];
        OldItemQty: Decimal;
        NextSalseLine: Integer;
        OldItem: Record Item;
        OldItemInventory: Decimal;
        RequestedItemNo: Code[20];
    begin
        SalesSetup.Get;


        if SalesLine."Document Profile" = SalesLine."document profile"::Service then
            exit;
        if (SalesLine."Document Type" = SalesLine."document type"::"Credit Memo") or
          (SalesLine."Document Type" = SalesLine."document type"::"Return Order") then
            exit;

        if SalesLine."Quantity Shipped" > 0 then
            exit;

        if SalesLine.Quantity = 0 then
            exit;

        if not SalesSetup."Auto Apply Replacements" then
            exit;

        if SalesLine.Type = SalesLine.Type::Item then begin
            OldItemNo := SalesLine."No.";
            OldItemQty := SalesLine.Quantity;
            OldItem.Get(OldItemNo);
            OldItem.CalcFields(Inventory);
            OldItemInventory := OldItem.Inventory;

            if SalesLine."Requested Item No." <> '' then
                RequestedItemNo := SalesLine."Requested Item No."
            else
                RequestedItemNo := OldItemNo;

            //Check inventory
            if (OldItemInventory > 0) and SalesLine."Has Replacement" then
                if not Dialog.Confirm(ReplaceConfirmInvTxt, false, OldItemNo) then
                    exit;

            NonstockItem.Reset;
            NonstockItem.SetRange("Item No.", SalesLine."No.");
            if NonstockItem.FindFirst then begin
                GetReplacementsByNonstockEntryNo(NonstockItem."Entry No.", Replacements, OldItemQty);
                if Replacements.FindFirst then begin
                    FirstLine := true;
                    SalesLine2.CopyFilters(SalesLine);
                    SalesLine2.FindLast;
                    SalesLineNo := SalesLine2."Line No.";
                    repeat

                        //Generate Item from Nonstock if needed to get Item No.
                        NonstockItem2.Get(Replacements."Substitute No.");
                        if NonstockItem2."Item No." = '' then
                            NonstockItemMgt.NonstockAutoItem(NonstockItem2);
                        NonstockItem.Get(NonstockItem2."Entry No.");

                        //Apply replacement to line
                        if FirstLine then begin
                            //Modify Existing line
                            SalesLine.Validate("No.", NonstockItem."Item No.");
                            SalesLine.Validate(Quantity, Replacements."Superseding Quantity");
                            if SalesLine."Line No." <> 0 then begin
                                SalesLine."Requested Item No." := RequestedItemNo;
                                SalesLine.Modify;
                            end else begin
                                SalesLineNo := SalesLineNo + 10000;
                                SalesLine."Line No." := SalesLineNo;
                                SalesLine."Requested Item No." := RequestedItemNo;
                                SalesLine.Insert;
                            end;
                        end else begin
                            // Create New Lines
                            SalesLineNo := SalesLineNo + 10000;
                            SalesLine2.Init;
                            SalesLine2."Line No." := SalesLineNo;
                            SalesLine2.Validate(Type, SalesLine2.Type::Item);
                            SalesLine2.Validate("No.", NonstockItem."Item No.");
                            SalesLine2.Validate(Quantity, Replacements."Superseding Quantity");
                            SalesLine2."Requested Item No." := RequestedItemNo;
                            SalesLine2.Insert;
                        end;
                        ReplacementInfo += Format(NonstockItem."Item No.") + ',';
                        FirstLine := false;

                    until Replacements.Next = 0;
                end;
            end;

            if (SalesSetup."Item No. Replacement Warnings") and (ReplacementInfo <> '') then begin
                ReplacementInfo := DelChr(ReplacementInfo, '>', ',');
                Message(ReplaceInfoTxt, OldItemNo, ReplacementInfo);
            end;



        end;
    end;


    procedure ReplaceServiceLineItemNo(var ServiceLine: Record "Service Line EDMS")
    var
        ReplacementsFound: Boolean;
        FirstLine: Boolean;
        Replacements: Record "Item Substitution" temporary;
        NonstockItem: Record "Nonstock Item";
        NonstockItem2: Record "Nonstock Item";
        NonstockItemMgt: Codeunit "Catalog Item Management";
        ServiceLineNo: Integer;
        ServiceLine2: Record "Service Line EDMS";
        ReplacementInfo: Text[250];
        OldItemNo: Code[20];
        OldItemQty: Decimal;
        NextServiceLine: Integer;
        OldItem: Record Item;
        OldItemInventory: Decimal;
        RequestedItemNo: Code[20];
    begin
        ServiceSetup.Get;

        if (ServiceLine."Document Type" = ServiceLine."document type"::"Return Order") then
            exit;

        if ServiceLine.Quantity = 0 then
            exit;

        if not ServiceSetup."Auto Apply Replacements" then
            exit;

        if ServiceLine.Type = ServiceLine.Type::Item then begin
            OldItemNo := ServiceLine."No.";
            OldItemQty := ServiceLine.Quantity;
            OldItem.Get(OldItemNo);
            OldItem.CalcFields(Inventory);
            OldItemInventory := OldItem.Inventory;

            if ServiceLine."Requested Item No." <> '' then
                RequestedItemNo := ServiceLine."Requested Item No."
            else
                RequestedItemNo := OldItemNo;

            //Check inventory
            if (OldItemInventory > 0) and ServiceLine."Has Replacement" then
                if not Dialog.Confirm(ReplaceConfirmInvTxt, false, OldItemNo) then
                    exit;

            NonstockItem.Reset;
            NonstockItem.SetRange("Item No.", ServiceLine."No.");
            if NonstockItem.FindFirst then begin
                GetReplacementsByNonstockEntryNo(NonstockItem."Entry No.", Replacements, OldItemQty);
                if Replacements.FindFirst then begin
                    FirstLine := true;
                    ServiceLine2.CopyFilters(ServiceLine);
                    if ServiceLine2.FindLast then
                        ServiceLineNo := ServiceLine2."Line No.";
                    repeat

                        //Generate Item from Nonstock if needed to get Item No.
                        NonstockItem2.Get(Replacements."Substitute No.");
                        if NonstockItem2."Item No." = '' then
                            NonstockItemMgt.NonstockAutoItem(NonstockItem2);
                        NonstockItem.Get(NonstockItem2."Entry No.");

                        //Apply replacement to line
                        if FirstLine then begin
                            //Modify Existing line
                            ServiceLine.Validate("No.", NonstockItem."Item No.");
                            ServiceLine.Validate(Quantity, Replacements."Superseding Quantity");
                            if ServiceLine."Line No." <> 0 then begin
                                ServiceLine."Requested Item No." := RequestedItemNo;
                                ServiceLine.Modify;
                            end else begin
                                ServiceLineNo := ServiceLineNo + 10000;
                                ServiceLine."Line No." := ServiceLineNo;
                                ServiceLine."Requested Item No." := RequestedItemNo;
                                ServiceLine.Insert;
                            end;
                        end else begin
                            // Create New Lines
                            ServiceLineNo := ServiceLineNo + 10000;
                            ServiceLine2.Init;
                            ServiceLine2."Line No." := ServiceLineNo;
                            ServiceLine2."Document Type" := ServiceLine."Document Type";
                            ServiceLine2."Document No." := ServiceLine."Document No.";
                            ServiceLine2.Validate(Type, ServiceLine2.Type::Item);
                            ServiceLine2.Validate("No.", NonstockItem."Item No.");
                            ServiceLine2.Validate(Quantity, Replacements."Superseding Quantity");
                            ServiceLine2."Requested Item No." := RequestedItemNo;
                            ServiceLine2.Insert;
                        end;
                        ReplacementInfo += Format(NonstockItem."Item No.") + ',';
                        FirstLine := false;

                    until Replacements.Next = 0;
                end;
            end;

            if (ServiceSetup."Item No. Replacement Warnings") and (ReplacementInfo <> '') then begin
                ReplacementInfo := DelChr(ReplacementInfo, '>', ',');
                Message(ReplaceInfoTxt, OldItemNo, ReplacementInfo);
            end;



        end;
    end;


    procedure ReplacePurchaseLineItemNo(var PurchaseLine: Record "Purchase Line")
    var
        ReplacementsFound: Boolean;
        FirstLine: Boolean;
        Replacements: Record "Item Substitution" temporary;
        NonstockItem: Record "Nonstock Item";
        NonstockItem2: Record "Nonstock Item";
        NonstockItemMgt: Codeunit "Catalog Item Management";
        PurchaseLineNo: Integer;
        PurchaseLine2: Record "Purchase Line";
        ReplacementInfo: Text[250];
        OldItemNo: Code[20];
        OldItemQty: Decimal;
        NextPurchaseLine: Integer;
        RequestedItemNo: Code[20];
    begin
        PurchaseSetup.Get;

        if PurchaseLine."Quantity Received" > 0 then
            exit;

        if PurchaseLine.Quantity = 0 then
            exit;

        if not PurchaseSetup."Auto Apply Replacements" then
            exit;

        if PurchaseLine.Type = PurchaseLine.Type::Item then begin
            OldItemNo := PurchaseLine."No.";
            OldItemQty := PurchaseLine.Quantity;

            if PurchaseLine."Requested Item No." <> '' then
                RequestedItemNo := PurchaseLine."Requested Item No."
            else
                RequestedItemNo := OldItemNo;

            NonstockItem.Reset;
            NonstockItem.SetRange("Item No.", PurchaseLine."No.");
            if NonstockItem.FindFirst then begin
                GetReplacementsByNonstockEntryNo(NonstockItem."Entry No.", Replacements, OldItemQty);
                if Replacements.FindFirst then begin
                    FirstLine := true;
                    PurchaseLine2.CopyFilters(PurchaseLine);
                    PurchaseLine2.FindLast;
                    PurchaseLineNo := PurchaseLine2."Line No.";
                    repeat

                        //Generate Item from Nonstock if needed to get Item No.
                        NonstockItem2.Get(Replacements."Substitute No.");
                        if NonstockItem2."Item No." = '' then
                            NonstockItemMgt.NonstockAutoItem(NonstockItem2);
                        NonstockItem.Get(NonstockItem2."Entry No.");

                        //Apply replacement to line
                        if FirstLine then begin
                            //Modify Existing line
                            PurchaseLine.Validate("No.", NonstockItem."Item No.");
                            PurchaseLine.Validate(Quantity, Replacements."Superseding Quantity");
                            if PurchaseLine."Line No." <> 0 then begin
                                PurchaseLine."Requested Item No." := RequestedItemNo;
                                PurchaseLine.Modify;
                            end else begin
                                PurchaseLineNo := PurchaseLineNo + 10000;
                                PurchaseLine."Line No." := PurchaseLineNo;
                                PurchaseLine."Requested Item No." := RequestedItemNo;
                                PurchaseLine.Insert;
                            end;
                        end else begin
                            // Create New Lines
                            PurchaseLineNo := PurchaseLineNo + 10000;
                            PurchaseLine2.Init;
                            PurchaseLine2."Line No." := PurchaseLineNo;
                            PurchaseLine2.Validate(Type, PurchaseLine2.Type::Item);
                            PurchaseLine2.Validate("No.", NonstockItem."Item No.");
                            PurchaseLine2.Validate(Quantity, Replacements."Superseding Quantity");
                            PurchaseLine2."Requested Item No." := RequestedItemNo;
                            PurchaseLine2.Insert;
                        end;
                        ReplacementInfo += Format(NonstockItem."Item No.") + ',';
                        FirstLine := false;

                    until Replacements.Next = 0;
                end;
            end;

            if (SalesSetup."Item No. Replacement Warnings") and (ReplacementInfo <> '') then begin
                ReplacementInfo := DelChr(ReplacementInfo, '>', ',');
                Message(ReplaceInfoTxt, OldItemNo, ReplacementInfo);
            end;



        end;
    end;


    procedure GetReplacementsByNonstockEntryNo(EntryNo: Code[20]; var ReplacementsEntryNo: Record "Item Substitution"; Qty: Decimal) ReplacementsFound: Boolean
    var
        ItemSubst: Record "Item Substitution";
        ItemTmp: Record Item temporary;
        ReplacementGroupsTmp: Record "Item Substitution" temporary;
        ConditionGroups: Text[250];
        ConditionSelected: Integer;
        ConditionGroupsArr: array[100] of Text[50];
        i: Integer;
        CalculatedQty: Decimal;
    begin
        //Get Unconditions ungrouped items
        ItemSubst.SetRange("Entry Type", ItemSubst."entry type"::Replacement);
        ItemSubst.SetRange(Type, ItemSubst.Type::"Nonstock Item");
        ItemSubst.SetRange("Replacement Info.", ItemSubst."replacement info."::Replace);
        ItemSubst.SetRange("Condition Group", '');
        ItemSubst.SetRange("No.", EntryNo);
        if ItemSubst.FindFirst then begin
            ReplacementsFound := true;
            repeat
                if ItemSubst."Superseding Quantity" = 0 then
                    ItemSubst."Superseding Quantity" := 1;
                CalculatedQty := Qty * ItemSubst."Superseding Quantity";

                if not GetReplacementsByNonstockEntryNo(ItemSubst."Substitute No.", ReplacementsEntryNo, CalculatedQty) then begin
                    ReplacementsEntryNo.Init;
                    ReplacementsEntryNo := ItemSubst;
                    ReplacementsEntryNo."Superseding Quantity" := CalculatedQty;
                    ReplacementsEntryNo.Insert;
                end;
            until ItemSubst.Next = 0;
        end;

        //Get groups
        ItemSubst.Reset;
        ItemSubst.SetRange("Entry Type", ItemSubst."entry type"::Replacement);
        ItemSubst.SetRange(Type, ItemSubst.Type::"Nonstock Item");
        ItemSubst.SetRange("Replacement Info.", ItemSubst."replacement info."::Replace);
        ItemSubst.SetFilter("Condition Group", '<>%1', '');
        ItemSubst.SetRange("No.", EntryNo);

        if ItemSubst.FindFirst then begin
            repeat
                ReplacementGroupsTmp.Reset;
                ReplacementGroupsTmp.SetRange("Condition Group", ItemSubst."Condition Group");
                if not ReplacementGroupsTmp.FindFirst then begin
                    i += 1;
                    ReplacementGroupsTmp.Init;
                    ReplacementGroupsTmp := ItemSubst;
                    ReplacementGroupsTmp.Insert;

                    ConditionGroups += Format(ReplacementGroupsTmp."Condition Group") + ',';
                    ConditionGroupsArr[i] := Format(ReplacementGroupsTmp."Condition Group");
                end;
            until ItemSubst.Next = 0;

            //Choose one group
            if i > 1 then begin
                if ConditionGroups <> '' then begin
                    ConditionSelected := Dialog.StrMenu(ConditionGroups, 1, ChooseReplacementTxt);
                end;
            end else
                ConditionSelected := 1;

            //Selected group items
            if ConditionSelected > 0 then begin
                ItemSubst.Reset;
                ItemSubst.SetRange("Entry Type", ItemSubst."entry type"::Replacement);
                ItemSubst.SetRange(Type, ItemSubst.Type::"Nonstock Item");
                ItemSubst.SetRange("Replacement Info.", ItemSubst."replacement info."::Replace);
                ItemSubst.SetRange("Condition Group", ConditionGroupsArr[ConditionSelected]);
                ItemSubst.SetRange("No.", EntryNo);
                if ItemSubst.FindFirst then begin
                    ReplacementsFound := true;
                    repeat
                        if ItemSubst."Superseding Quantity" = 0 then
                            ItemSubst."Superseding Quantity" := 1;
                        CalculatedQty := Qty * ItemSubst."Superseding Quantity";
                        if not GetReplacementsByNonstockEntryNo(ItemSubst."Substitute No.", ReplacementsEntryNo, CalculatedQty) then begin
                            ReplacementsEntryNo.Init;
                            ReplacementsEntryNo := ItemSubst;
                            ReplacementsEntryNo."Superseding Quantity" := CalculatedQty;
                            ReplacementsEntryNo.Insert;
                        end;
                    until ItemSubst.Next = 0;
                end;
            end;
        end;
    end;


    procedure CheckReplacementsByNonstockEntryNo(EntryNo: Code[20]) ReplacementsFound: Boolean
    var
        ItemSubst: Record "Item Substitution";
        ItemTmp: Record Item temporary;
        ReplacementGroupsTmp: Record "Item Substitution" temporary;
        ConditionGroups: Text[250];
        ConditionSelected: Integer;
    begin
        //Get Unconditions ungrouped items
        ItemSubst.SetRange("Entry Type", ItemSubst."entry type"::Replacement);
        ItemSubst.SetRange(Type, ItemSubst.Type::"Nonstock Item");
        ItemSubst.SetRange("Replacement Info.", ItemSubst."replacement info."::Replace);
        ItemSubst.SetRange("No.", EntryNo);
        if ItemSubst.FindFirst then
            ReplacementsFound := true;
    end;

    // From codeunit 5701 "Item Subst."
    procedure ItemSubstGetService(var ServiceLine: Record "Service Line EDMS"): Code[10]
    var
        ServiceHeader: Record "Service Header EDMS";
        NonstockItemMgt: Codeunit "Catalog Item Management";

    begin
        TempServiceLine := ServiceLine;
        if (TempServiceLine.Type <> TempServiceLine.Type::Item) or
           (TempServiceLine."Document Type" in
            [TempServiceLine."document type"::"Return Order"])
        then
            exit;

        SaveItemNo := TempServiceLine."No.";
        SaveVariantCode := TempServiceLine."Variant Code";

        Item.Get(TempServiceLine."No.");
        Item.SetFilter("Location Filter", TempServiceLine."Location Code");
        Item.SetFilter("Variant Filter", TempServiceLine."Variant Code");
        ServiceHeader.Get(TempServiceLine."Document Type", TempServiceLine."Document No.");
        Item.SetRange("Date Filter", 0D, ServiceHeader."Document Date");
        Item.CalcFields(Inventory);
        Item.CalcFields("Qty. on Sales Order");
        Item.CalcFields("Qty. on Service Order");
        OldSalesUOM := Item."Sales Unit of Measure";

        ItemSubstitution.Reset;
        ItemSubstitution.SetRange(Type, ItemSubstitution.Type::Item);
        ItemSubstitution.SetRange("No.", TempServiceLine."No.");
        ItemSubstitution.SetRange("Variant Code", TempServiceLine."Variant Code");
        ItemSubstitution.SetRange("Location Filter", TempServiceLine."Location Code");
        if ItemSubstitution.Find('-') then begin
            CalcCustPriceService(TempServiceLine);
            TempItemSubstitution.Reset;
            TempItemSubstitution.SetRange("No.", TempServiceLine."No.");
            TempItemSubstitution.SetRange("Variant Code", TempServiceLine."Variant Code");
            TempItemSubstitution.SetRange("Location Filter", TempServiceLine."Location Code");
            if Page.RunModal(Page::"Item Substitution Entries", TempItemSubstitution) =
              Action::LookupOK
            then begin
                if TempItemSubstitution."Substitute Type" =
                  TempItemSubstitution."substitute type"::"Nonstock Item"
                then begin
                    NonStockItem.Get(TempItemSubstitution."Substitute No.");
                    if NonStockItem."Item No." = '' then begin
                        NonstockItemMgt.CreateItemFromNonstock(NonStockItem);
                        NonStockItem.Get(TempItemSubstitution."Substitute No.");
                    end;
                    TempItemSubstitution."Substitute No." := NonStockItem."Item No."
                end;


                TempServiceLine."No." := TempItemSubstitution."Substitute No.";
                TempServiceLine."Variant Code" := TempItemSubstitution."Substitute Variant Code";
                SaveQty := TempServiceLine.Quantity;
                SaveLocation := TempServiceLine."Location Code";
                SaveDropShip := TempServiceLine."Drop Shipment";
                TempServiceLine.Quantity := 0;
                TempServiceLine.Validate("No.", TempItemSubstitution."Substitute No.");
                TempServiceLine.Validate("Variant Code", TempItemSubstitution."Substitute Variant Code");
                //TempServiceLine."Originally Ordered No." := SaveItemNo;
                //TempServiceLine."Originally Ordered Var. Code" := SaveVariantCode;
                TempServiceLine."Location Code" := SaveLocation;
                TempServiceLine."Drop Shipment" := SaveDropShip;
                TempServiceLine.Validate(Quantity, SaveQty);
                TempServiceLine.Validate("Unit of Measure Code", OldSalesUOM);
                Commit;
            end;
        end else
            Error(Text001, TempServiceLine."No.");

        ServiceLine := TempServiceLine;
    end;
    // From codeunit 5701 "Item Subst."
    procedure CalcCustPriceService(ServiceLine: Record "Service Line EDMS")
    Var
    begin
        TempItemSubstitution.Reset;
        TempItemSubstitution.DeleteAll;
        ServiceHeader.Get(TempServiceLine."Document Type", TempServiceLine."Document No.");
        if ItemSubstitution.Find('-') then begin
            repeat
                TempItemSubstitution."No." := ItemSubstitution."No.";
                TempItemSubstitution."Variant Code" := ItemSubstitution."Variant Code";
                TempItemSubstitution."Substitute No." := ItemSubstitution."Substitute No.";
                TempItemSubstitution."Substitute Variant Code" := ItemSubstitution."Substitute Variant Code";
                TempItemSubstitution.Description := ItemSubstitution.Description;
                TempItemSubstitution.Interchangeable := ItemSubstitution.Interchangeable;
                TempItemSubstitution."Location Filter" := ItemSubstitution."Location Filter";
                TempItemSubstitution.Condition := ItemSubstitution.Condition;
                TempItemSubstitution."Shipment Date" := ServiceHeader."Document Date";
                if ItemSubstitution."Substitute Type" = ItemSubstitution."substitute type"::Item then begin
                    Item.Get(ItemSubstitution."Substitute No.");
                    /*if not SetupDataIsPresent then
                        GetSetupData;*/
                    CompanyInfo.get();
                    AvailToPromise.CalcQtyAvailableToPromise(
                      Item, GrossReq, SchedRcpt,
                      Item.GetRangemax("Date Filter"), CompanyInfo."Check-Avail. Time Bucket",
                      CompanyInfo."Check-Avail. Period Calc.");

                    Item.CalcFields(Inventory, "Reserved Qty. on Inventory");
                    TempItemSubstitution."Quantity Avail. on Shpt. Date" :=
                      Item.Inventory - Item."Reserved Qty. on Inventory" - GrossReq + SchedRcpt;
                    TempItemSubstitution.Inventory := Item.Inventory;
                end else begin
                    TempItemSubstitution."Substitute Type" := TempItemSubstitution."substitute type"::"Nonstock Item";
                    TempItemSubstitution."Quantity Avail. on Shpt. Date" := 0;
                    TempItemSubstitution.Inventory := 0;
                end;
                TempItemSubstitution.Insert;
            until ItemSubstitution.Next = 0;
        end;
    end;
    // From codeunit 5701 "Item Subst."
    procedure CheckReplacements(ItemNo: Code[20])
    var
        ItemSubst: Record "Item Substitution";
    begin
        ItemSubst.Reset;
        ItemSubst.SetRange(Type, ItemSubst.Type::"Nonstock Item"); //18.12.2014 EDMS P12 Item -> Nonstock Item
        ItemSubst.SetRange("No.", ItemNo);
        ItemSubst.SetRange("Replacement Info.", ItemSubst."replacement info."::Replace);
        if ItemSubst.FindFirst then
            Message(Text101);

        //Replace
        ItemSubst.Reset;
        ItemSubst.SetRange(Type, ItemSubst.Type::"Nonstock Item"); //18.12.2014 EDMS P12 Item -> Nonstock Item
        ItemSubst.SetRange("No.", ItemNo);
        ItemSubst.SetRange("Replacement Info.", ItemSubst."replacement info."::Replacement);
        if ItemSubst.FindFirst then begin
            ItemSubst.CalcFields("EDMS Inventory");
            if ItemSubst."EDMS Inventory" > 0 then
                Message(Text102);
        end;
    end;
    // From codeunit 5701 "Item Subst."
    procedure CheckDiscontinued(ItemNo: Code[20]; LineQuantity: Decimal)
    var
        ItemSubst: Record "Item Substitution";
        Item: Record Item;
    begin
        if Item.Get(ItemNo) then begin
            Item.CalcFields(Inventory, "Nonstock Entry No.");
            if NonStockItem.Get(Item."Nonstock Entry No.") then begin
                if LineQuantity > Item.Inventory then begin
                    ItemSubst.Reset;
                    ItemSubst.SetRange("No.", ItemNo);
                    ItemSubst.SetRange("Entry Type", ItemSubst."entry type"::Discontinued);
                    ItemSubst.SetRange(Type, ItemSubst.Type::"Nonstock Item");
                    if ItemSubst.FindFirst then begin
                        Message(Text103, Item."No.");
                    end;
                end;
            end;
        end;
    end;
    // From codeunit 5701 "Item Subst."
    procedure ItemSubstGetRent(var RentSalesLine: Record "Rent Sales Line")
    var
        SalesLineReserve: Codeunit "Sales Line-Reserve";
    begin
        if (RentSalesLine.Type <> RentSalesLine.Type::Item) then
            exit;

        SaveItemNo := RentSalesLine."No.";
        SaveVariantCode := RentSalesLine."Variant Code";

        Item.Get(RentSalesLine."No.");
        Item.SetFilter("Location Filter", RentSalesLine."Location Code");
        Item.SetFilter("Variant Filter", RentSalesLine."Variant Code");
        Item.SetRange("Date Filter", 0D, RentSalesLine."Shipment Date");
        Item.CalcFields(Inventory);
        Item.CalcFields("Qty. on Sales Order");
        Item.CalcFields("Qty. on Service Order");

        ItemSubstitution.Reset;
        ItemSubstitution.SetRange(Type, ItemSubstitution.Type::Item);
        ItemSubstitution.SetRange("No.", TempSalesLine."No.");
        ItemSubstitution.SetRange("Variant Code", RentSalesLine."Variant Code");
        ItemSubstitution.SetRange("Location Filter", RentSalesLine."Location Code");
        if ItemSubstitution.Find('-') then begin
            //CalcCustPrice;
            TempItemSubstitution.Reset;
            TempItemSubstitution.SetRange("No.", RentSalesLine."No.");
            TempItemSubstitution.SetRange("Variant Code", RentSalesLine."Variant Code");
            TempItemSubstitution.SetRange("Location Filter", RentSalesLine."Location Code");
            Page.RunModal(Page::"Item Substitution Entries", TempItemSubstitution);
        end;
    end;

    [IntegrationEvent(True, False)]
    local procedure OnBeforeCheckItemReplacementOnSalesLineNoValidate(var Rec: Record "Sales Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(True, False)]
    local procedure OnBeforeCheckItemReplacementOnPurchaseLineNoValidate(var Rec: Record "Purchase Line"; var IsHandled: Boolean)
    begin
    end;


}

