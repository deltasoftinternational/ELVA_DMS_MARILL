Codeunit 25006291 "Application Event Management"
{
    // 04.10.2018 EB.P7 Bug in email.
    //   Modified OnAllocationsStatusChangeOrderStatus
    // 
    // 23.11.2015 EB.P7 #T017
    // Removed form EDMS version:
    //   TypeIDNameModifiedVersion ListDateTimeCompiledLockedLocked By
    //   511Gen. Jnl.-Check LineNoNAVW19.0015.09.1512:00:00YesYesEB\reinisc
    //   521Item Jnl.-Check LineNoNAVW19.0015.09.1512:00:00YesYesEB\reinisc
    //   5414Release Sales DocumentNoNAVW19.0015.09.1512:00:00YesYesEB\reinisc
    //   5415Release Purchase DocumentNoNAVW19.0015.09.1512:00:00YesYesEB\reinisc
    //   17302Bin ContentNoNAVW19.0015.09.1512:00:00YesYesEB\reinisc
    // 
    // Customer table changes:
    //   OnInsert Modified, code moved to Events
    //   Added function GetInsertFromContacts
    //   Moved function CustomerUpdateFromTemplate to Events
    //   OnDelete Modified code moved to events
    //   Blocked field OnValidate Code moved to events
    // 
    // Item table partly moved code to events
    // Requisition Wksh. Name table code moved to events
    // Nonstock Item OnDelete Code moved to events
    // SalesPrice Trigger code moved to events (viss kods)
    // Sales Line Discount code moved from triggers to events (viss kods)
    // Purchase Price code moved from triggers to events (viss kods)
    // Bin Content viss kods uz eventiem (izņemts no dms)


    trigger OnRun()
    begin
    end;

    var
        Text001: label 'is not within your range of allowed posting dates';
        Text100: label 'Do you want to use a Customer Template to create a Customer?';
        Text101: label 'The Creation of the customer has been aborted.';
        tcDMS005: label 'You have no right to block/unblock customer!';
        Text102: label 'Don''t forget to set %1';
        Text103: label 'You cannot change a default bin content for bin %1, because this is SIE Bin.';
        Text106: label 'Is all job finished for order %1?';
        Text107: label 'Error createing new allocation, becouse of incorrect allocation data.';
        ServOrdDeleteCanceledErr: label 'Service Order delete process canceled.';

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Gen. Jnl.-Check Line", 'OnAfterCheckGenJnlLine', '', false, false)]
    local procedure ValidateOnAfterCheckGenJnlLine(var GenJournalLine: Record "Gen. Journal Line")
    var
        LicensePermission: Record "License Permission";
        UserSetup: Record "User Setup";
        SalesShipmentHeader: Record "Sales Shipment Header";
        SalesShipmentLine: Record "Sales Shipment Line";
        ApprAllowed: Boolean;
    begin
        if GenJournalLine."Vehicle Serial No." <> '' then begin
            LicensePermission.SetRange("Object Type", LicensePermission."object type"::Codeunit);
            LicensePermission.SetRange("Object Number", Codeunit::VehicleAccountingCycleMgt);
            LicensePermission.SetFilter("Execute Permission", '<>%1', LicensePermission."execute permission"::" ");
            ApprAllowed := not LicensePermission.IsEmpty;
            if ApprAllowed then
                GenJournalLine.TestField("Vehicle Accounting Cycle No.");
        end;

        if UserId <> '' then
            if UserSetup.Get(UserId) then
                if UserSetup."Allow Posting Only Today" and (GenJournalLine."Posting Date" <> Today) then
                    if (SalesShipmentHeader.get(GenJournalLine."Document No.")) then begin
                        SalesShipmentLine.reset();
                        SalesShipmentLine.setrange("Document No.", GenJournalLine."Document No.");
                        SalesShipmentLine.setfilter(Quantity, '<>0');
                        if SalesShipmentLine.findfirst then begin
                            if not UserSetup."Allow Return Not Only Today" then
                                GenJournalLine.FieldError("Posting Date", Text001)
                        end
                        else
                            GenJournalLine.FieldError("Posting Date", Text001);
                    end
                    else
                        GenJournalLine.FieldError("Posting Date", Text001);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Check Line", 'OnAfterCheckItemJnlLine', '', false, false)]
    local procedure ValidateOnAfterCheckItemJnlLine(var ItemJnlLine: Record "Item Journal Line")
    var
        VehicleCostMgt: Codeunit "Vehicle Cost Management";
        Item: Record Item;
    begin
        if (ItemJnlLine."Item Type" = ItemJnlLine."item type"::"Model Version")
 and (ItemJnlLine."Item Charge No." = '') then
            ItemJnlLine.TestField("Vehicle Accounting Cycle No.");

        if Item.Get(ItemJnlLine."Item No.") then
            if VehicleCostMgt.ItemHaveSpecialVehicleCost(Item) then
                VehicleCostMgt.CheckItemJnlVehicleCostReq(Item, ItemJnlLine);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Sales Document", 'OnBeforeReleaseSalesDoc', '', false, false)]
    local procedure ValidateOnBeforeReleaseSalesDoc(var SalesHeader: Record "Sales Header")
    var
        SalesLine: Record "Sales Line";
        SalesSetup: Record "Sales & Receivables Setup";
        ServiceSetup: Record "Service Mgt. Setup EDMS";
        MakeSetup: Record "Make Setup";
        Approved: Boolean;
        InvtSetup: Record "Inventory Setup";
        ItemCostManagement: Codeunit "Item Cost Management";
    begin
        SalesSetup.Get;
        case SalesHeader."Document Profile" of
            SalesHeader."document profile"::"Spare Parts Trade", SalesHeader."document profile"::"Vehicles Trade":
                case SalesHeader."Document Type" of
                    SalesHeader."document type"::Invoice, SalesHeader."document type"::Order:
                        begin
                            if SalesSetup."Payment Method Mandatory" then
                                SalesHeader.TestField("Payment Method Code");
                            onaftercheckPRVNsalesheader(SalesHeader);
                        end;
                end;
            SalesHeader."document profile"::Service:
                begin
                    ServiceSetup.Get;
                    case SalesHeader."Document Type" of
                        SalesHeader."document type"::Invoice, SalesHeader."document type"::Order:
                            begin
                                if ServiceSetup."Payment Method Mandatory" then
                                    SalesHeader.TestField("Payment Method Code");
                                onafterchecserviceheader(SalesHeader);
                            end;
                    end;
                end;
        end;

        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetFilter(Type, '>0');
        SalesLine.SetFilter(Quantity, '<>0');
        SalesLine.SetRange("Line Type", SalesLine."line type"::Vehicle);
        if SalesLine.FindSet then
            repeat
                MakeSetup.Get(SalesLine."Make Code");
                if MakeSetup."Vehicle Assembly Mandatory" then
                    SalesLine.TestField(SalesLine."Vehicle Assembly ID")    //05.12.2007 EDMS P3
            until SalesLine.Next = 0;
        SalesLine.SetRange("Line Type");

        SalesLine.Reset;
        SalesLine.SetRange("Document Type", SalesHeader."Document Type");
        SalesLine.SetRange("Document No.", SalesHeader."No.");
        SalesLine.SetRange(Type, SalesLine.Type::Item);
        if SalesLine.FindFirst then
            repeat
                SalesLine.ApplyMarkupRestrictions(1);
            until SalesLine.Next = 0;

        InvtSetup.Get;
        if InvtSetup."Refresh Costs on Release" then
            ItemCostManagement.RefreshCostsSale(SalesHeader);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Release Purchase Document", 'OnBeforeReleasePurchaseDoc', '', false, false)]
    local procedure ValidateOnBeforeReleasePurchaseDoc(var PurchaseHeader: Record "Purchase Header")
    var
        PurchLine: Record "Purchase Line";
        MakeSetup: Record "Make Setup";
    begin
        PurchLine.SetRange("Document Type", PurchaseHeader."Document Type");
        PurchLine.SetRange("Document No.", PurchaseHeader."No.");
        PurchLine.SetRange("Line Type", PurchLine."line type"::Vehicle);
        if PurchLine.Find('-') then
            repeat
                PurchLine.TestField("Vehicle Status Code");
                MakeSetup.Get(PurchLine."Make Code");
                if MakeSetup."Vehicle Assembly Mandatory" then
                    PurchLine.TestField(PurchLine."Vehicle Assembly ID")
            until PurchLine.Next = 0;
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeInsertEvent', '', false, false)]
    local procedure UpdateCustomerOnAfterInsertCustomer(var Rec: Record Customer; RunTrigger: Boolean)
    var
        CustTemplate: Record "Customer Templ.";
        ishandled: Boolean;
    begin
        ishandled := false;
        beforeUpdateCustomerOnAfterInsertCustomer(ishandled);
        if ishandled then
            exit;
        if RunTrigger then
            if not Rec.GetInsertFromContact then begin
                CustTemplate.Reset;
                if CustTemplate.Find('-') then begin
                    if Confirm(Text100, true) then begin
                        Commit;
                        CustUpdateFromTemplate(Rec, '');
                    end;
                end;
            end;
    end;


    procedure CustUpdateFromTemplate(var Customer2: Record Customer; CustTemplateCode: Code[10])
    var
        CustTemplate: Record "Customer Templ.";
        DefaultDim: Record "Default Dimension";
        DefaultDim2: Record "Default Dimension";
    begin
        if CustTemplateCode <> '' then
            CustTemplate.Get(CustTemplateCode)
        else begin
            if Page.RunModal(0, CustTemplate) = Action::LookupOK then
                CustTemplateCode := CustTemplate.Code
            else
                Error(Text101);
        end;

        if CustTemplate.Code <> '' then begin
            Customer2."Territory Code" := CustTemplate."Territory Code";
            Customer2."Currency Code" := CustTemplate."Currency Code";
            Customer2."Country/Region Code" := CustTemplate."Country/Region Code";
            Customer2."Customer Posting Group" := CustTemplate."Customer Posting Group";
            Customer2."Customer Price Group" := CustTemplate."Customer Price Group";
            Customer2."Invoice Disc. Code" := CustTemplate."Invoice Disc. Code";
            Customer2."Customer Disc. Group" := CustTemplate."Customer Disc. Group";
            Customer2."Allow Line Disc." := CustTemplate."Allow Line Disc.";
            Customer2."Gen. Bus. Posting Group" := CustTemplate."Gen. Bus. Posting Group";
            Customer2."VAT Bus. Posting Group" := CustTemplate."VAT Bus. Posting Group";
            Customer2."Prices Including VAT" := CustTemplate."Prices Including VAT DMS";
            Customer2."Payment Terms Code" := CustTemplate."Payment Terms Code";
            Customer2."Payment Method Code" := CustTemplate."Payment Method Code";
            Customer2.Reserve := CustTemplate.Reserve;

            DefaultDim.SetRange("Table ID", Database::"Customer Templ.");
            DefaultDim.SetRange(DefaultDim."No.", CustTemplate.Code);
            if DefaultDim.FindSet then
                repeat
                    Clear(DefaultDim2);
                    DefaultDim2.Init;
                    DefaultDim2.Validate("Table ID", Database::Customer);
                    DefaultDim2."No." := Customer2."No.";
                    DefaultDim2.Validate("Dimension Code", DefaultDim."Dimension Code");
                    DefaultDim2.Validate("Dimension Value Code", DefaultDim."Dimension Value Code");
                    DefaultDim2."Value Posting" := DefaultDim."Value Posting";
                    DefaultDim2.Insert(true);
                until DefaultDim.Next = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnBeforeDeleteEvent', '', false, false)]
    local procedure DeletePrepmtOnAfterDeleteCustomer(var Rec: Record Customer; RunTrigger: Boolean)
    var
        SalesPrepmtPct: Record "Sales Prepayment %";
    begin
        if RunTrigger then begin
            SalesPrepmtPct.SetCurrentkey("Sales Type", "Sales Code");
            SalesPrepmtPct.SetRange("Sales Type", SalesPrepmtPct."sales type"::Customer);
            SalesPrepmtPct.SetRange("Sales Code", Rec."No.");
            SalesPrepmtPct.DeleteAll;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::Customer, 'OnAfterValidateEvent', 'Blocked', false, false)]
    local procedure CheckAllowOnAfterValidateCustomerBlocked(var Rec: Record Customer; var xRec: Record Customer; CurrFieldNo: Integer)
    var
        UserSetup: Record "User Setup";
    begin
        if CurrFieldNo = Rec.FieldNo(Blocked) then
            if UserSetup.Get(UserId) then begin
                if not UserSetup."Allow Block Customer" then
                    Error(tcDMS005);
            end else
                Error(tcDMS005);
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterInsertEvent', '', false, false)]
    local procedure AfterOnInsertItem(var Rec: Record Item; RunTrigger: Boolean)
    var
        InvtSetup: Record "Inventory Setup";
    begin
        if RunTrigger then begin
            if Rec."Item Type" = Rec."item type"::"Model Version" then begin
                InvtSetup.Get;
                if InvtSetup."Def. Model Version Item Cat." <> '' then
                    Rec.SetNewEntryVariable(true);
                Rec.Validate("Item Category Code", InvtSetup."Def. Model Version Item Cat.");
                Rec.SetNewEntryVariable(false);
            end;
        end;
    end;


    procedure FillItemGroupDefDim(var Rec: Record Item)
    var
        ItemGrDefDim: Record "Item Group Default Dimension";
        DefDim: Record "Default Dimension";
        InvSetup: Record "Inventory Setup";
        CategoryCode: Code[20];
        CategoryCode2: Code[20];
        ItemCategory: Record "Item Category";
    begin
        InvSetup.Get;
        if not InvSetup."Fill Item Group Def. Dimension" then
            exit;

        if Rec."Item Category Code" = '' then
            exit;
        CategoryCode := '';
        ItemGrDefDim.SETFILTER(ItemGrDefDim."Item Category Code", Rec."Item Category Code");
        if ItemGrDefDim.FindSet then
            CategoryCode := Rec."Item Category Code";

        if CategoryCode = '' then begin
            CategoryCode2 := Rec."Item Category Code";
            ItemCategory.Get(CategoryCode2);
            repeat
                if ItemCategory."Parent Category" <> '' then begin
                    ItemGrDefDim.SETFILTER(ItemGrDefDim."Item Category Code", ItemCategory."Parent Category");
                    if ItemGrDefDim.FindSet then
                        CategoryCode := ItemCategory."Parent Category" else
                        if ItemCategory."Parent Category" <> '' then begin
                            CategoryCode2 := ItemCategory."Parent Category";
                            ItemCategory.Get(CategoryCode2);
                        end;
                end;
            until (ItemCategory."Parent Category" = '') or (CategoryCode <> '');
        end;
        if CategoryCode <> '' then begin
            Rec.Modify;
            repeat
                DefDim.Reset;
                DefDim.SetRange("Table ID", Database::Item);
                DefDim.SetRange("No.", Rec."No.");
                DefDim.SetRange("Dimension Code", ItemGrDefDim."Dimension Code");
                if DefDim.Find('-') then begin
                    DefDim."Dimension Value Code" := ItemGrDefDim."Dimension Value Code";
                    DefDim."Value Posting" := DefDim."value posting"::" ";
                    DefDim.Modify(true);
                end else begin
                    DefDim.Init;
                    DefDim."Table ID" := Database::Item;
                    DefDim."No." := Rec."No.";
                    DefDim."Dimension Code" := ItemGrDefDim."Dimension Code";
                    DefDim."Dimension Value Code" := ItemGrDefDim."Dimension Value Code";
                    DefDim."Value Posting" := DefDim."value posting"::" ";
                    DefDim.Insert(true);
                end;
            until ItemGrDefDim.Next = 0;
        end;
        Rec.Get(Rec."No.");
        Rec.Modify(true);
    end;
    //DELTA OBSOLETE
    /*  [EventSubscriber(ObjectType::Table, Database::"Item Template", 'OnAfterInsertItemFromTemplate', '', false, false)]

      local procedure AfterOnInsertItemFromTemplate(var ItemTemplate: Record "Item Template"; var Item: Record Item; ConfigTemplateHeader: Record "Config. Template Header")
      begin
          if Item."Item Category Code" <> '' then
              FillItemGroupDefDim(Item);
      end;*/

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterValidateEvent', 'Item Category Code', false, false)]
    local procedure AfterOnValidateItemCategoryCode(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    begin
        if CurrFieldNo = Rec.FieldNo("Item Category Code") then
            FillItemGroupDefDim(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::Item, 'OnAfterValidateEvent', 'Exchange Unit', false, false)]
    local procedure AfterOnValidateItemExchangeUnit(var Rec: Record Item; var xRec: Record Item; CurrFieldNo: Integer)
    var
        recNonstockItem: Record "Nonstock Item";
    begin
        if CurrFieldNo = Rec.FieldNo("Exchange Unit") then begin
            recNonstockItem.Reset;
            recNonstockItem.SetCurrentkey("Item No.");
            recNonstockItem.SetRange("Item No.", Rec."No.");
            if recNonstockItem.FindFirst then begin
                recNonstockItem."Exchange Unit" := Rec."Exchange Unit";
                recNonstockItem.Modify;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Requisition Wksh. Name", 'OnAfterInsertEvent', '', false, false)]
    local procedure AfterOnInsertRequisitionWkshName(var Rec: Record "Requisition Wksh. Name"; RunTrigger: Boolean)
    var
        ReqWkshTmpl: Record "Req. Wksh. Template";
    begin
        if RunTrigger then begin
            if Rec."Document Profile" = 0 then begin
                ReqWkshTmpl.Get(Rec."Worksheet Template Name");
                Rec."Document Profile" := ReqWkshTmpl."Document Profile";
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Nonstock Item", 'OnAfterDeleteEvent', '', false, false)]
    local procedure AfterOnDeleteNonstockItem(var Rec: Record "Nonstock Item"; RunTrigger: Boolean)
    var
        NonstockSalesPrice: Record "Nonstock Item Price";
        NonstockPurchasePrice: Record "Nonstock Purchase Price";
        NonstockSalesLineDiscount: Record "Nonstock Sales Line Discount";
        NonstockPurchaseLineDisc: Record "Nonstock Purchase Line Disc";
        ItemSubstitution: Record "Item Substitution";
    begin
        if RunTrigger then begin
            NonstockSalesPrice.Reset;
            NonstockSalesPrice.SetRange("Nonstock Item Entry No.", Rec."Entry No.");
            NonstockSalesPrice.DeleteAll;

            NonstockPurchasePrice.Reset;
            NonstockPurchasePrice.SetRange("Nonstock Item Entry No.", Rec."Entry No.");
            NonstockPurchasePrice.DeleteAll;

            NonstockSalesLineDiscount.Reset;
            NonstockSalesLineDiscount.SetRange("Nonstock Item Entry No.", Rec."Entry No.");
            NonstockSalesLineDiscount.DeleteAll;

            NonstockPurchaseLineDisc.Reset;
            NonstockPurchaseLineDisc.SetRange("Nonstock Item Entry No.", Rec."Entry No.");
            NonstockPurchaseLineDisc.DeleteAll;

            ItemSubstitution.Reset;
            ItemSubstitution.SetRange(Type, ItemSubstitution.Type::"Nonstock Item");
            ItemSubstitution.SetRange("No.", Rec."Entry No.");
            ItemSubstitution.DeleteAll;

            ItemSubstitution.Reset;
            ItemSubstitution.SetRange("Substitute Type", ItemSubstitution."substitute type"::"Nonstock Item");
            ItemSubstitution.SetRange("Substitute No.", Rec."Entry No.");
            ItemSubstitution.DeleteAll;
        end;
    end;
    //DELTA SALES PRICE

    [EventSubscriber(ObjectType::Table, Database::"Price List Line", 'OnBeforeInsertEvent', '', false, false)]
    local procedure BeforeOnInsertSalesPrice(var Rec: Record "Price List Line"; RunTrigger: Boolean)
    var
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt. EDMS";
        xRec: Record "Price List Line";
    begin
        if RunTrigger then begin
            xRec := Rec;
            SalesPriceCalcMgt.ItemSalesPriceToNonstock(Rec, xRec, 0);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Price List Line", 'OnBeforeModifyEvent', '', false, false)]
    local procedure BeforeOnModifySalesPrice(var Rec: Record "Price List Line"; var xRec: Record "Price List Line"; RunTrigger: Boolean)
    var
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt. EDMS";
    begin
        if RunTrigger then
            SalesPriceCalcMgt.ItemSalesPriceToNonstock(Rec, xRec, 1);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Price List Line", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure BeforeOnDeleteSalesPrice(var Rec: Record "Price List Line"; RunTrigger: Boolean)
    var
        xRec: Record "Price List Line";
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt. EDMS";
    begin
        if RunTrigger then begin
            xRec := Rec;
            SalesPriceCalcMgt.ItemSalesPriceToNonstock(Rec, xRec, 3);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Price List Line", 'OnBeforeRenameEvent', '', false, false)]
    local procedure BeforeOnRenameSalesPrice(var Rec: Record "Price List Line"; var xRec: Record "Price List Line"; RunTrigger: Boolean)
    var
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt. EDMS";
    begin
        if RunTrigger then
            SalesPriceCalcMgt.ItemSalesPriceToNonstock(Rec, xRec, 2);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Price DMS", 'OnBeforeValidateEvent', 'Item No.', false, false)]
    local procedure BeforeOnValidateSalesPriceItemNo(var Rec: Record "Sales Price DMS"; var xRec: Record "Sales Price DMS"; CurrFieldNo: Integer)
    var
        Item: Record Item;
    begin
        if Item.Get(Rec."Item No.") then begin
            Rec."Make Code" := Item."Make Code";
            Rec."Model Code" := Item."Model Code";
            Rec."Allow Invoice Disc." := Item."Allow Invoice Disc.";
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Price DMS", 'OnBeforeValidateEvent', 'Price Includes VAT', false, false)]
    local procedure BeforeOnValidateSalesPricePriceIncVat(var Rec: Record "Sales Price DMS"; var xRec: Record "Sales Price DMS"; CurrFieldNo: Integer)
    begin
        if (Rec."Price Includes VAT" <> xRec."Price Includes VAT") and Rec."Price Includes VAT" then
            Message(Text102, Rec.FieldCaption(Rec."VAT Bus. Posting Gr. (Price)"))
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line Discount DMS", 'OnAfterInsertEvent', '', false, false)]
    local procedure AfterOnInsertSalesLineDiscount(var Rec: Record "Sales Line Discount DMS"; RunTrigger: Boolean)
    var
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt. EDMS";
        xRec: Record "Sales Line Discount DMS";
    begin
        if RunTrigger then begin
            xRec := Rec;
            SalesPriceCalcMgt.ItemSalesLineDiscToNonstock(Rec, xRec, 0);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line Discount DMS", 'OnAfterModifyEvent', '', false, false)]
    local procedure AfterOnModifySalesLineDiscount(var Rec: Record "Sales Line Discount DMS"; var xRec: Record "Sales Line Discount DMS"; RunTrigger: Boolean)
    var
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt. EDMS";
    begin
        if RunTrigger then
            SalesPriceCalcMgt.ItemSalesLineDiscToNonstock(Rec, xRec, 1);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line Discount DMS", 'OnAfterDeleteEvent', '', false, false)]
    local procedure AfterOnDeleteSalesLineDiscount(var Rec: Record "Sales Line Discount DMS"; RunTrigger: Boolean)
    var
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt. EDMS";
        xRec: Record "Sales Line Discount DMS";
    begin
        if RunTrigger then begin
            xRec := Rec;
            SalesPriceCalcMgt.ItemSalesLineDiscToNonstock(Rec, xRec, 3);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line Discount DMS", 'OnAfterRenameEvent', '', false, false)]
    local procedure AfterOnRenameSalesLineDiscount(var Rec: Record "Sales Line Discount DMS"; var xRec: Record "Sales Line Discount DMS"; RunTrigger: Boolean)
    var
        SalesPriceCalcMgt: Codeunit "Sales Price Calc. Mgt. EDMS";
    begin
        if RunTrigger then
            SalesPriceCalcMgt.ItemSalesLineDiscToNonstock(Rec, xRec, 2);
    end;
    //DELTA SALESPRICE

    [EventSubscriber(ObjectType::Table, Database::"Price List Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure AfterOnInsertPurchasePrice(var Rec: Record "Price List Line"; RunTrigger: Boolean)
    var
        PurchPriceCalcMgt: Codeunit "Purch. Price Calc. Mgt. EDMS";
        xRec: Record "Price List Line";
    begin
        if RunTrigger then begin
            xRec := Rec;
            PurchPriceCalcMgt.ItemPurchPriceToNonstock(Rec, xRec, 0);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Price List Line", 'OnAfterModifyEvent', '', false, false)]
    local procedure AfterOnModifyPurchasePrice(var Rec: Record "Price List Line"; var xRec: Record "Price List Line"; RunTrigger: Boolean)
    var
        PurchPriceCalcMgt: Codeunit "Purch. Price Calc. Mgt. EDMS";
    begin
        if RunTrigger then
            PurchPriceCalcMgt.ItemPurchPriceToNonstock(Rec, xRec, 1);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Price List Line", 'OnAfterDeleteEvent', '', false, false)]
    local procedure AfterOnDeletePurchasePrice(var Rec: Record "Price List Line"; RunTrigger: Boolean)
    var
        PurchPriceCalcMgt: Codeunit "Purch. Price Calc. Mgt. EDMS";
        xRec: Record "Price List Line";
    begin
        if RunTrigger then begin
            xRec := Rec;
            PurchPriceCalcMgt.ItemPurchPriceToNonstock(Rec, xRec, 3);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Price List Line", 'OnAfterRenameEvent', '', false, false)]
    local procedure AfterOnRenamePurchasePrice(var Rec: Record "Price List Line"; var xRec: Record "Price List Line"; RunTrigger: Boolean)
    var
        PurchPriceCalcMgt: Codeunit "Purch. Price Calc. Mgt. EDMS";
    begin
        if RunTrigger then
            PurchPriceCalcMgt.ItemPurchPriceToNonstock(Rec, xRec, 2);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Price List Line", 'OnAfterInsertEvent', '', false, false)]
    local procedure AfterOnInsertPurchaseLineDiscount(var Rec: Record "Price List Line"; RunTrigger: Boolean)
    var
        PurchPriceCalcMgt: Codeunit "Purch. Price Calc. Mgt. EDMS";
        xRec: Record "Price List Line";
    begin
        if RunTrigger then begin
            xRec := Rec;
            PurchPriceCalcMgt.ItemPurLineDiscToNonstock(Rec, xRec, 0);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Price List Line", 'OnAfterModifyEvent', '', false, false)]
    local procedure AfterOnModifyPurchaseLineDiscount(var Rec: Record "Price List Line"; var xRec: Record "Price List Line"; RunTrigger: Boolean)
    var
        PurchPriceCalcMgt: Codeunit "Purch. Price Calc. Mgt. EDMS";
    begin
        if RunTrigger then
            PurchPriceCalcMgt.ItemPurLineDiscToNonstock(Rec, xRec, 1);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Price List Line", 'OnAfterDeleteEvent', '', false, false)]
    local procedure AfterOnDeletePurchaseLineDiscount(var Rec: Record "Price List Line"; RunTrigger: Boolean)
    var
        PurchPriceCalcMgt: Codeunit "Purch. Price Calc. Mgt. EDMS";
        xRec: Record "Price List Line";
    begin
        if RunTrigger then begin
            xRec := Rec;
            PurchPriceCalcMgt.ItemPurLineDiscToNonstock(Rec, xRec, 3);
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Price List Line", 'OnAfterRenameEvent', '', false, false)]
    local procedure AfterOnRenamePurchaseLineDiscount(var Rec: Record "Price List Line"; var xRec: Record "Price List Line"; RunTrigger: Boolean)
    var
        PurchPriceCalcMgt: Codeunit "Purch. Price Calc. Mgt. EDMS";
    begin
        if RunTrigger then
            PurchPriceCalcMgt.ItemPurLineDiscToNonstock(Rec, xRec, 2);
    end;

    /*
    [EventSubscriber(ObjectType::Table, Database::"Bin Content", 'OnAfterValidateEvent', 'Default', false, false)]
    local procedure AfterOnValidateBinContentDefault(var Rec: Record "Bin Content"; var xRec: Record "Bin Content"; CurrFieldNo: Integer)
    var
        SIE: Record "Special Inventory Equipment";
        SIESAMOAMgt: Codeunit "SAMOA 3d Party Mgt.";
    begin
        //   There is possible generalisation - through SIE management and
        //   generalized procedure that will call all sie interfaces. (AS event)
        //   Now it is for samoa only
        if (xRec.Default <> Rec.Default) and not Rec.Default then begin
          SIE.SetRange(Active,true);
          SIE.SetRange(SystemCode,SIE.Systemcode::SAMOA);
          if SIE.FindFirst then
            if SIESAMOAMgt.CheckSIEBin(Rec."Location Code",Rec."Bin Code") and SIE."Check 1" then
              Error(Text103,Rec."Bin Code")
        end;
    end;
    */

    [EventSubscriber(ObjectType::Table, Database::Vehicle, 'OnAfterValidateEvent', 'Customer No.', false, false)]
    local procedure OnValidateVehicleCustomerAddVehicleContact(var Rec: Record Vehicle; var xRec: Record Vehicle; CurrFieldNo: Integer)
    var
        Contact: Record Contact;
        VehicleContact: Record "Vehicle Contact";
        VehicleContactNew: Record "Vehicle Contact";
        ContactBusinessRelation: Record "Contact Business Relation";
        ServiceMgtSetup: Record "Service Mgt. Setup EDMS";
        MarketingSetup: Record "Marketing Setup";
    begin
        //if not (CurrFieldNo in [Rec.FieldNo("Customer No.")]) then
        //    exit;

        if Rec."Customer No." <> xRec."Customer No." then
            Rec."Customer Service Address Code" := '';

        if Rec."Customer No." = '' then
            exit;

        MarketingSetup.Get;
        ServiceMgtSetup.Get;
        if (ServiceMgtSetup."Link Relationship Code" <> '') then begin
            ContactBusinessRelation.SetRange("No.", Rec."Customer No.");
            ContactBusinessRelation.SetRange("Business Relation Code", MarketingSetup."Bus. Rel. Code for Customers");
            if ContactBusinessRelation.FindFirst then begin
                if not VehicleContact.Get(Rec."Serial No.", ServiceMgtSetup."Link Relationship Code", ContactBusinessRelation."Contact No.") then begin
                    VehicleContact.Reset();
                    VehicleContact.SetRange("Vehicle Serial No.", Rec."Serial No.");
                    VehicleContact.SetRange("Contact No.", ContactBusinessRelation."Contact No.");
                    if VehicleContact.FindFirst() then begin
                        if VehicleContact."Relationship Code" <> ServiceMgtSetup."Link Relationship Code" then begin
                            VehicleContactNew.Init;
                            VehicleContactNew."Vehicle Serial No." := Rec."Serial No.";
                            VehicleContactNew.Validate("Relationship Code", ServiceMgtSetup."Link Relationship Code");
                            VehicleContactNew."Contact No." := ContactBusinessRelation."Contact No.";
                            VehicleContactNew.Insert;

                            VehicleContact.Delete;
                        end;
                    end else begin
                        VehicleContact.Init;
                        VehicleContact."Vehicle Serial No." := Rec."Serial No.";
                        VehicleContact.Validate("Relationship Code", ServiceMgtSetup."Link Relationship Code");
                        VehicleContact."Contact No." := ContactBusinessRelation."Contact No.";
                        VehicleContact.Insert;
                    end;
                end;
                if (ServiceMgtSetup."Prev Owner Relationship Code" <> '') then begin
                    VehicleContact.Reset();
                    VehicleContact.SetRange("Vehicle Serial No.", Rec."Serial No.");
                    VehicleContact.SetRange("Relationship Code", ServiceMgtSetup."Link Relationship Code");
                    VehicleContact.Setfilter("Contact No.", '<>%1', ContactBusinessRelation."Contact No.");
                    If VehicleContact.FindFirst() then
                        repeat
                            if not VehicleContactNew.Get(Rec."Serial No.", ServiceMgtSetup."Prev Owner Relationship Code", VehicleContact."Contact No.") then begin
                                VehicleContactNew.Init;
                                VehicleContactNew."Vehicle Serial No." := Rec."Serial No.";
                                VehicleContactNew.Validate("Relationship Code", ServiceMgtSetup."Prev Owner Relationship Code");
                                VehicleContactNew."Contact No." := VehicleContact."Contact No.";
                                VehicleContactNew.Insert;
                            end;
                            VehicleContact.Delete;
                        until VehicleContact.Next = 0;
                end;
            end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vehicle Contact", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnInsertVehicleContactUpdateVehicleCustomer(var Rec: Record "Vehicle Contact"; RunTrigger: Boolean)
    var
        Contact: Record Contact;
        Vehicle: Record Vehicle;
        ContactBusinessRelation: Record "Contact Business Relation";
        ServiceMgtSetup: Record "Service Mgt. Setup EDMS";
        MarketingSetup: Record "Marketing Setup";
    begin
        if not RunTrigger then
            exit;
        MarketingSetup.Get;
        ServiceMgtSetup.Get;
        if Rec."Relationship Code" <> ServiceMgtSetup."Link Relationship Code" then
            exit;

        Contact.Get(Rec."Contact No.");
        if ContactBusinessRelation.Get(Contact."Company No.", MarketingSetup."Bus. Rel. Code for Customers") then begin
            Vehicle.Get(Rec."Vehicle Serial No.");
            if Vehicle."Customer No." = ContactBusinessRelation."No." then
                exit;
            Vehicle."Customer No." := ContactBusinessRelation."No.";
            Vehicle.Modify;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Vehicle Contact", 'OnAfterRenameEvent', '', false, false)]
    local procedure OnRenameVehicleContactUpdateVehicleCustomer(var Rec: Record "Vehicle Contact"; var xRec: Record "Vehicle Contact"; RunTrigger: Boolean)
    var
        Contact: Record Contact;
        Vehicle: Record Vehicle;
        ContactBusinessRelation: Record "Contact Business Relation";
        ServiceMgtSetup: Record "Service Mgt. Setup EDMS";
        MarketingSetup: Record "Marketing Setup";
    begin
        MarketingSetup.Get;
        ServiceMgtSetup.Get;
        if Rec."Relationship Code" <> ServiceMgtSetup."Link Relationship Code" then
            exit;

        if Rec."Contact No." <> xRec."Contact No." then begin
            Contact.Get(Rec."Contact No.");
            if ContactBusinessRelation.Get(Contact."Company No.", MarketingSetup."Bus. Rel. Code for Customers") then begin
                Vehicle.Get(Rec."Vehicle Serial No.");
                Vehicle."Customer No." := ContactBusinessRelation."No.";
                Vehicle.Modify;
            end;
        end;
    end;

    [EventSubscriber(Objecttype::Page, 25006355, 'OnAllocationChangeStatus', '', false, false)]

    procedure OnAllocationsStatusChangePlanNextAllocation(Status: Option Pending,"In Process","Finish All","Finish Part","On Hold"; AllocEntryNo: Integer)
    var
        LaborAllocEntry: Record "Serv. Labor Allocation Entry";
        AllocationPrompt: Page "Allocation Prompt";
        ServiceHour: Record "Service Hour EDMS";
        Resource: Record Resource;
        NextDay: Date;
        StartDateTime: Decimal;
        SourceType: Integer;
        Mode: Option "New Allocation","Move Existing","Split Existing","Break";
        ServiceLine: Record "Service Line EDMS";
        DateTimeMgt: Codeunit "Datetime Mgt.";
        AllocationForm: Page Allocation;
        ServiceScheduleSetup: Record "Service Schedule Setup";
        AllocatedEntryNo: Integer;
        UserSetup: Record "User Setup";
        Text106Msg: Text;
    begin
        if UserSetup.Get(UserId) then;
        ServiceScheduleSetup.Get;
        if not UserSetup."Ask Work Finished" then
            exit;

        NextDay := WorkDate + 1;
        LaborAllocEntry.Get(AllocEntryNo);
        Resource.Get(LaborAllocEntry."Resource No.");
        ServiceHour.Reset;
        ServiceHour.SetRange("Service Work Group Code", Resource."Service Work Group Code");
        ServiceHour.SetFilter("Starting Date", '''''|<=%1', NextDay);
        ServiceHour.SetFilter("Ending Date", '''''|>=%1', NextDay);
        ServiceHour.SetRange(Day, Date2dwy(NextDay, 1) - 1);
        if ServiceHour.FindFirst then;

        if LaborAllocEntry.Get(AllocEntryNo) then
            if (LaborAllocEntry."Source ID" <> '') and (LaborAllocEntry."Source Subtype" = LaborAllocEntry."source subtype"::Order) and not LaborAllocEntry.Travel then
                if (Status = Status::"Finish All") or (Status = Status::"Finish Part") then begin
                    Text106Msg := StrSubstNo(Text106, LaborAllocEntry."Source ID");
                    if not Dialog.Confirm(Text106Msg, true) then begin
                        Commit;
                        AllocationPrompt.SetAllocationDate(NextDay);
                        AllocationPrompt.SetAllocationTime(ServiceHour."Starting Time");
                        AllocationPrompt.SetAllocationDuration(ServiceScheduleSetup."Def. Serv. D. Alloc. Duration");
                        AllocationPrompt.SetOrderNo(LaborAllocEntry."Source ID");
                        AllocationPrompt.LookupMode(true);
                        if (AllocationPrompt.RunModal = Action::LookupOK) then begin
                            //MESSAGE(FORMAT(AllocationPrompt.GetAllocationDate)+' '+FORMAT(AllocationPrompt.GetAllocationTime)+' '+FORMAT(AllocationPrompt.GetAllocationDuration));
                            if (AllocationPrompt.GetAllocationDate <> 0D) and (AllocationPrompt.GetAllocationTime <> 0T) and (AllocationPrompt.GetAllocationDuration > 0) then begin
                                StartDateTime := DateTimeMgt.Datetime(AllocationPrompt.GetAllocationDate, AllocationPrompt.GetAllocationTime);

                                ServiceLine.SetRange("Document Type", LaborAllocEntry."Source Type");
                                ServiceLine.SetRange("Document No.", LaborAllocEntry."Source ID");
                                ServiceLine.SetRange("Line No.", 0);

                                Clear(AllocationForm);

                                AllocationForm.SetParam(0, LaborAllocEntry."Resource No.", StartDateTime, 1, LaborAllocEntry."Source Type", LaborAllocEntry."Source Subtype", LaborAllocEntry."Source ID", 0, ServiceLine, 0);
                                AllocationForm.SetInvisibles(AllocationPrompt.GetAllocationDuration);
                                AllocationForm.SetIsTravel(LaborAllocEntry.Travel);
                                AllocatedEntryNo := AllocationForm.Allocate;
                            end else begin
                                Message(Text107);
                            end;
                        end;
                    end;
                end;
    end;

    local procedure IsItemInCategory(CategoryCodeForItem: Code[20]; CategoryCodeForDim: Code[20]): Boolean
    var
        ItemCategory: Record "Item Category";
        CategoryFound: Boolean;
        CategoryCode: Code[20];
    begin
        if CategoryCodeForItem = CategoryCodeForDim then
            exit(true);
        CategoryCode := CategoryCodeForItem;
        repeat
            ItemCategory.Get(CategoryCode);
            if ItemCategory."Parent Category" = '' then
                exit(false)
            else
                if ItemCategory."Parent Category" = CategoryCodeForDim then
                    exit(true)
                else
                    CategoryCode := ItemCategory."Parent Category";
        until CategoryFound;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Service Header EDMS", 'OnBeforeDeleteEvent', '', false, false)]
    local procedure BeforeOnDeleteServiceHeader(var Rec: Record "Service Header EDMS"; RunTrigger: Boolean)
    var
        ServiceWIPMgt: Codeunit "Service WIP Management";
        WIPTotals: Record "Service WIP Total";
        ConfirmWIPReversal: Page "Service WIP Rev. Post. Date";
        ReversalPostingDate: Date;
    begin
        if Rec.IsTemporary then
            exit;

        WIPTotals.Reset;
        WIPTotals.SetRange("Service Order No.", Rec."No.");
        WIPTotals.SetRange(Reversed, false);
        if WIPTotals.FindFirst then begin
            Clear(ConfirmWIPReversal);
            ConfirmWIPReversal.SetParam(Today);
            if ConfirmWIPReversal.RunModal = Action::Yes then begin
                ConfirmWIPReversal.GetParam(ReversalPostingDate);
                ServiceWIPMgt.ServiceOrderCheckAndPostWIP(Rec."No.", ReversalPostingDate);
                ServiceWIPMgt.DeleteCalculatedWIP(Rec."No.");
            end else
                Error(ServOrdDeleteCanceledErr);
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Caption Class", 'OnResolveCaptionClass', '', false, false)]

    procedure OnResolveCaptionClass(CaptionArea: Text; CaptionExpr: Text; Language: Integer; var Caption: Text; var Resolved: Boolean)
    begin
        if CaptionArea = '7' then begin
            Caption := VFCaptionClassTranslate(Language, CaptionExpr);
            Resolved := true;
        end;// ELSE

        // if Caption hasn't been resolved, fallback to CaptionClassExpr
        if not Resolved then
            Caption := CaptionExpr;
    end;

    procedure VFCaptionClassTranslate(Language: Integer; CaptionRef: Text[80]): Text[30]
    var
        LanguageCode: Code[10];
        LanguageRec: Record Language;
        VFMgt: Codeunit "Variable Field Management";
        TableID: Integer;
        FieldNo: Integer;
    begin
        //EDMS - Variable Fields
        if CaptionRef = '' then
            exit('');
        if not Evaluate(TableID, SelectStr(1, CaptionRef)) then
            exit('');
        if not Evaluate(FieldNo, SelectStr(2, CaptionRef)) then
            exit('');

        LanguageRec.Reset;
        LanguageRec.SetCurrentkey("Windows Language ID");
        LanguageRec.SetRange("Windows Language ID", Language);
        if LanguageRec.Find('-') then
            LanguageCode := LanguageRec.Code;

        exit(VFMgt.GetVFCaption(TableID, FieldNo, LanguageCode));
    end;

    [EventSubscriber(ObjectType::Table, Database::"Detailed CV Ledg. Entry Buffer", 'OnAfterCopyFromGenJnlLine', '', false, false)]
    local procedure OnAfterCopyFromGenJnlLineFillDMSFields(var DtldCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; GenJnlLine: Record "Gen. Journal Line")
    begin
        DtldCVLedgEntryBuffer."Document Profile" := GenJnlLine."Document Profile";
    end;

    [EventSubscriber(ObjectType::Table, Database::"Detailed CV Ledg. Entry Buffer", 'OnAfterCopyFromCVLedgEntryBuf', '', false, false)]
    local procedure OnAfterCopyFromCustLedgerEntryFillDMSFields(var DetailedCVLedgEntryBuffer: Record "Detailed CV Ledg. Entry Buffer"; CVLedgerEntryBuffer: Record "CV Ledger Entry Buffer")
    begin
        CVLedgerEntryBuffer."Document Profile" := DetailedCVLedgEntryBuffer."Document Profile";
    end;

    [EventSubscriber(Objecttype::Page, 25006355, 'OnAllocationChangeStatus', '', false, false)]

    procedure OnAllocationsStatusChangeFillPlannedFields(Status: Option Pending,"In Process","Finish All","Finish Part","On Hold"; AllocEntryNo: Integer)
    var
        DocumentStatus: Record "Document Status";
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        ServiceHeader: Record "Service Header EDMS";
    begin
        if ServLaborAllocationEntry.Get(AllocEntryNo) then
            case Status of
                Status::"In Process":
                    begin
                        if (ServLaborAllocationEntry."Planned Start Date-Time" = 0) or (ServLaborAllocationEntry."Planned End Date-Time" = 0) then begin
                            ServLaborAllocationEntry."Planned Start Date-Time" := ServLaborAllocationEntry."Start Date-Time";
                            ServLaborAllocationEntry."Planned End Date-Time" := ServLaborAllocationEntry."End Date-Time";
                            ServLaborAllocationEntry."Planned Duration (Hours)" := ServLaborAllocationEntry."Quantity (Hours)";
                            ServLaborAllocationEntry.Modify;
                        end;
                    end;
            end;
    end;

    [EventSubscriber(Objecttype::Page, 25006355, 'OnAllocationChangeStatus', '', false, false)]

    procedure OnAllocationsStatusChangeOrderStatus(Status: Option Pending,"In Process","Finish All","Finish Part","On Hold"; AllocEntryNo: Integer)
    var
        DocumentStatus: Record "Document Status";
        ServLaborAllocationEntry: Record "Serv. Labor Allocation Entry";
        ServiceHeader: Record "Service Header EDMS";
        HighestStatus: Option Pending,"In Progress",Finished,"On Hold";
        ResTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
        ServiceWorkStatus: Record "Service Work Status EDMS";
    begin
        if ServLaborAllocationEntry.Get(AllocEntryNo) then
            if ServLaborAllocationEntry."Source Type" = ServLaborAllocationEntry."source type"::"Service Document" then
                if ServiceHeader.Get(ServLaborAllocationEntry."Source Subtype", ServLaborAllocationEntry."Source ID") then begin
                    if DocumentStatus.Get(DocumentStatus."document profile"::Service, ServiceHeader."Document Type", ServiceHeader."Document Status") then begin
                        HighestStatus := ResTimeRegMgt.GetDocumentHighestAllocationStatus(ServiceHeader);
                        case HighestStatus of
                            HighestStatus::"In Progress":
                                begin
                                    if (DocumentStatus."Next Status on Work Started" <> '') then
                                        ServiceHeader."Document Status" := DocumentStatus."Next Status on Work Started";
                                end;
                            HighestStatus::Finished:
                                begin
                                    if (DocumentStatus."Next Status on Work Finished" <> '') then
                                        ServiceHeader."Document Status" := DocumentStatus."Next Status on Work Finished";
                                end;
                        end;
                        //ServiceHeader."Work Status (System)" := HighestStatus;
                        //ServiceWorkStatus.Reset();
                        //ServiceWorkStatus.SetRange(ServiceWorkStatus."Service Order Status", HighestStatus);
                        //if ServiceWorkStatus.FindFirst() then
                        //    ServiceHeader."Work Status Code" := ServiceWorkStatus.Code;
                        // ^^^ Removed - Work Status Code change functionality in ServiceScheduleMgt.Codeunit
                        ServiceHeader.Modify(true);
                    end;
                end;
    end;

    [EventSubscriber(Objecttype::Page, 344, 'OnAfterNavigateFindRecords', '', false, false)]

    procedure OnAfterNavigateFindRecords(var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text)
    var
        ServLedgEntryEDMS: Record "Service Ledger Entry EDMS";
        DetServLedgEntryEDMS: Record "Det. Serv. Ledger Entry EDMS";
        PostedServiceHeader: Record "Posted Serv. Order Header";
        PostedRetServiceHeader: Record "Posted Serv. Ret. Order Header";
        PostedReturnServOrderTxt: Label 'Posted Return Service Order';
        PostedServOrderTxt: Label 'Posted Service Order';
        SalesInvHeader: Record "Sales Invoice Header";
        ServiceOrderNo: Code[20];

    begin
        SalesInvHeader.Reset();
        SalesInvHeader.SetFilter("No.", DocNoFilter);
        IF SalesInvHeader.FindFirst() then begin
            ServiceOrderNo := SalesInvHeader."Service Order No.";
        end;
        if PostedRetServiceHeader.ReadPermission then begin
            PostedRetServiceHeader.Reset();
            if ServiceOrderNo <> '' then
                PostedRetServiceHeader.SetFilter("No.", ServiceOrderNo)
            else
                PostedRetServiceHeader.SetFilter("No.", DocNoFilter);
            PostedRetServiceHeader.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(DocumentEntry, DATABASE::"Posted Serv. Ret. Order Header", 0, PostedReturnServOrderTxt, PostedRetServiceHeader.Count);
        end;
        if PostedServiceHeader.ReadPermission then begin
            PostedServiceHeader.Reset();
            if ServiceOrderNo <> '' then
                PostedServiceHeader.SetFilter("No.", ServiceOrderNo)
            else
                PostedServiceHeader.SetFilter("No.", DocNoFilter);
            PostedServiceHeader.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(DocumentEntry, DATABASE::"Posted Serv. Order Header", 0, PostedServOrderTxt, PostedServiceHeader.Count);
        end;
        if ServLedgEntryEDMS.ReadPermission then begin
            ServLedgEntryEDMS.Reset();
            ServLedgEntryEDMS.SetCurrentKey("Document No.", "Posting Date");
            ServLedgEntryEDMS.SetFilter("Document No.", DocNoFilter);
            ServLedgEntryEDMS.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(DocumentEntry, DATABASE::"Service Ledger Entry EDMS", 0, ServLedgEntryEDMS.TableCaption, ServLedgEntryEDMS.Count);
        end;
        if DetServLedgEntryEDMS.ReadPermission then begin
            DetServLedgEntryEDMS.Reset();
            DetServLedgEntryEDMS.SetCurrentKey("Document No.", "Posting Date");
            DetServLedgEntryEDMS.SetFilter("Document No.", DocNoFilter);
            DetServLedgEntryEDMS.SetFilter("Posting Date", PostingDateFilter);
            InsertIntoDocEntry(DocumentEntry, DATABASE::"Det. Serv. Ledger Entry EDMS", 0, DetServLedgEntryEDMS.TableCaption, DetServLedgEntryEDMS.Count);
        end;
    end;

    procedure InsertIntoDocEntry(var TempDocumentEntry: Record "Document Entry" temporary; DocTableID: Integer; DocType: Option; DocTableName: Text; DocNoOfRecords: Integer)
    begin
        if DocNoOfRecords = 0 then
            exit;

        TempDocumentEntry.Init;
        TempDocumentEntry."Entry No." := TempDocumentEntry."Entry No." + 1;
        TempDocumentEntry."Table ID" := DocTableID;
        TempDocumentEntry."Document Type" := DocType;
        TempDocumentEntry."Table Name" := CopyStr(DocTableName, 1, MaxStrLen(TempDocumentEntry."Table Name"));
        TempDocumentEntry."No. of Records" := DocNoOfRecords;
        TempDocumentEntry.Insert;
    end;

    [EventSubscriber(Objecttype::Page, 344, 'OnAfterShowRecords', '', false, false)]

    procedure OnAfterShowRecords(var DocumentEntry: Record "Document Entry"; DocNoFilter: Text; PostingDateFilter: Text; ItemTrackingSearch: Boolean; ContactType: Enum "Navigate Contact Type"; ContactNo: Code[250]; ExtDocNo: Code[250])
    var
        ServLedgEntryEDMS: Record "Service Ledger Entry EDMS";
        DetServLedgEntryEDMS: Record "Det. Serv. Ledger Entry EDMS";
        PostedServiceHeader: Record "Posted Serv. Order Header";
        PostedRetServiceHeader: Record "Posted Serv. Ret. Order Header";
        PostedReturnServOrderTxt: Label 'Posted Return Service Order';
        PostedServOrderTxt: Label 'Posted Service Order';
        SalesInvHeader: Record "Sales Invoice Header";
        ServiceOrderNo: Code[20];

    begin

        case DocumentEntry."Table ID" of
            DATABASE::"Posted Serv. Ret. Order Header":
                begin
                    SalesInvHeader.Reset();
                    SalesInvHeader.SetFilter("No.", DocNoFilter);
                    IF SalesInvHeader.FindFirst() then
                        ServiceOrderNo := SalesInvHeader."Service Order No.";
                    PostedRetServiceHeader.Reset();
                    if ServiceOrderNo <> '' then
                        PostedRetServiceHeader.SetFilter("No.", ServiceOrderNo)
                    else
                        PostedRetServiceHeader.SetFilter("No.", DocNoFilter);
                    PostedRetServiceHeader.SetFilter("Posting Date", PostingDateFilter);
                    if DocumentEntry."No. of Records" = 1 then
                        PAGE.Run(PAGE::"Posted Service Ret.Order EDMS", PostedRetServiceHeader)
                    else
                        PAGE.Run(PAGE::"Posted Service Ret.Orders EDMS", PostedRetServiceHeader);
                end;
            DATABASE::"Service Ledger Entry EDMS":
                begin
                    ServLedgEntryEDMS.Reset();
                    ServLedgEntryEDMS.SetFilter("Document No.", DocNoFilter);
                    ServLedgEntryEDMS.SetFilter("Posting Date", PostingDateFilter);
                    PAGE.Run(PAGE::"Service Ledger Entries EDMS", ServLedgEntryEDMS)
                end;
            DATABASE::"Det. Serv. Ledger Entry EDMS":
                begin
                    DetServLedgEntryEDMS.Reset();
                    DetServLedgEntryEDMS.SetFilter("Document No.", DocNoFilter);
                    DetServLedgEntryEDMS.SetFilter("Posting Date", PostingDateFilter);
                    PAGE.Run(PAGE::"Det. Serv. Ledger Entries EDMS", DetServLedgEntryEDMS)
                end;
            DATABASE::"Posted Serv. Order Header":
                begin
                    SalesInvHeader.Reset();
                    SalesInvHeader.SetFilter("No.", DocNoFilter);
                    IF SalesInvHeader.FindFirst() then
                        ServiceOrderNo := SalesInvHeader."Service Order No.";
                    PostedServiceHeader.Reset();
                    if ServiceOrderNo <> '' then
                        PostedServiceHeader.SetFilter("No.", ServiceOrderNo)
                    else
                        PostedServiceHeader.SetFilter("No.", DocNoFilter);
                    PostedServiceHeader.SetFilter("Posting Date", PostingDateFilter);
                    if DocumentEntry."No. of Records" = 1 then
                        PAGE.Run(PAGE::"Posted Service Order EDMS", PostedServiceHeader)
                    else
                        PAGE.Run(PAGE::"Posted Service Orders EDMS", PostedServiceHeader);

                end;
        end;
    end;

    [EventSubscriber(Objecttype::Report, 25006109, 'GetProcessInfo', '', false, false)]

    procedure BLSGetProcessInfo(var InvCnt: Integer; var CreatedSalesHeader: record "Sales Header")
    var

    begin
        Page.Run(Page::"Sales Invoice List", CreatedSalesHeader);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Option Lookup Buffer", 'OnBeforeIncludeOption', '', false, false)]
    local procedure AddPurchLineTypesToOption(LookupType: Option; Option: Integer; OptionLookupBuffer: Record "Option Lookup Buffer"; var Handled: Boolean; var Result: Boolean)
    var
        PurchLine: Record "Purchase Line";
        IndexOfOptionType: Integer;
    begin
        if (LookupType <> OptionLookupBuffer."Lookup Type"::Purchases) then
            exit;
        IndexOfOptionType := PurchLine.Type.Ordinals.IndexOf(PurchLine.Type::"External Service".AsInteger()) - 1;
        if Option = IndexOfOptionType then begin
            Result := true;
            Handled := true;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Option Lookup Buffer", 'OnBeforeInsertEvent', '', false, false)]
    local procedure AddPurchLineTypeDescriptionToOptionLookupBuffer(var Rec: Record "Option Lookup Buffer")
    var
        PurchLine: Record "Purchase Line";
        IndexOfOptionType: Integer;
    begin
        if Rec."Lookup Type" <> Rec."Lookup Type"::Purchases then
            exit;

        IndexOfOptionType := PurchLine.Type.Ordinals.IndexOf(PurchLine.Type::"External Service".AsInteger()) - 1;
        if Rec.ID = IndexOfOptionType then begin
            Rec.ID := "Purchase Line Type"::"External Service".AsInteger();
            Rec."Option Caption" := Format("Purchase Line Type"::"External Service");
        end;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Option Lookup Buffer", 'OnBeforeIncludeOption', '', false, false)]
    local procedure AddSalesLineTypesToOption(LookupType: Option; Option: Integer; OptionLookupBuffer: Record "Option Lookup Buffer"; var Handled: Boolean; var Result: Boolean)
    var
        SalesLine: Record "Sales Line";
        IndexOfOptionType: Integer;
    begin
        if (LookupType <> OptionLookupBuffer."Lookup Type"::Sales) then
            exit;
        IndexOfOptionType := SalesLine.Type.Ordinals.IndexOf(SalesLine.Type::"External Service".AsInteger()) - 1;
        if Option = IndexOfOptionType then begin
            Result := true;
            Handled := true;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Option Lookup Buffer", 'OnBeforeInsertEvent', '', false, false)]
    local procedure AddSalesLineTypeDescriptionToOptionLookupBuffer(var Rec: Record "Option Lookup Buffer")
    var
        SalesLine: Record "Sales Line";
        IndexOfOptionType: Integer;
    begin
        if Rec."Lookup Type" <> Rec."Lookup Type"::Sales then
            exit;

        IndexOfOptionType := SalesLine.Type.Ordinals.IndexOf(SalesLine.Type::"External Service".AsInteger()) - 1;
        if Rec.ID = IndexOfOptionType then begin
            Rec.ID := "Sales Line Type"::"External Service".AsInteger();
            Rec."Option Caption" := Format("Sales Line Type"::"External Service");
        end;

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Document-Mailing", 'OnBeforeSendEmail', '', false, false)]
    local procedure OnBeforeSendEmail(var TempEmailItem: Record "Email Item" temporary; var IsFromPostedDoc: Boolean; var PostedDocNo: Code[20]; var HideDialog: Boolean; var ReportUsage: Integer; var EmailSentSuccesfully: Boolean; var IsHandled: Boolean; EmailDocName: Text[250]; SenderUserID: Code[50]; EmailScenario: Enum "Email Scenario")
    var
        AttachmentInStream: Instream;
        AttachmentOutStream: OutStream;
        TempBlob: Codeunit "Temp Blob";
        DocumentAttachment: Record "Document Attachment";
    //MediaRec: Record Media;
    //MediaRec: Record media;
    begin
        DocumentAttachment.Reset();
        DocumentAttachment.SetRange("Table ID", Database::"Service Header EDMS");
        DocumentAttachment.SetRange("No.", PostedDocNo);
        DocumentAttachment.SetRange(IncludeInEmail, true);
        if DocumentAttachment.FindFirst() then
            repeat
                if DocumentAttachment."Document Reference ID".HasValue then begin
                    TempBlob.CreateOutStream(AttachmentOutStream);
                    DocumentAttachment."Document Reference ID".ExportStream(AttachmentOutStream);
                    TempBlob.CreateInStream(AttachmentInStream);
                    TempEmailItem.AddAttachment(AttachmentInStream, DocumentAttachment."File Name" + '.' + DocumentAttachment."File Extension");
                end;
            until DocumentAttachment.Next() = 0;
    end;


    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Purch.-Post", 'OnCheckAndUpdateOnAfterSetPostingFlags', '', false, false)]
    local procedure CheckVehicleVIN(var PurchHeader: Record "Purchase Header"; var TempPurchLineGlobal: Record "Purchase Line" temporary)
    var
        PurchaseLine: Record "Purchase Line";
        Text001: label 'Vehicle VIN must be specified for vehicle with serial number %1 to proceed posting!';
    begin
        If PurchHeader."Document Profile" = PurchHeader."Document Profile"::"Vehicles Trade" then begin
            PurchaseLine.Reset;
            PurchaseLine.SetRange("Document Type", PurchHeader."Document Type");
            PurchaseLine.SetRange("Document No.", PurchHeader."No.");
            PurchaseLine.SetRange("Line Type", PurchaseLine."Line Type"::Vehicle);
            PurchaseLine.SetFilter("Qty. to Receive", '>0');
            if PurchaseLine.FindSet then
                repeat
                    PurchaseLine.CalcFields(VIN);
                    if PurchaseLine.VIN = '' then
                        Error(Text001, PurchaseLine."Vehicle Serial No.");
                Until PurchaseLine.NEXT = 0;
        end;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Post Invoice Events", 'OnPostBalancingEntryOnBeforeGenJnlPostLine', '', false, false)]
    local procedure AddDMSInfoAutomaticSalesPayment(var GenJnlLine: Record "Gen. Journal Line"; SalesHeader: Record "Sales Header")
    begin
        If SalesHeader."Vehicle Serial No." <> '' then
            GenJnlLine.Validate("Vehicle Serial No.", SalesHeader."Vehicle Serial No.");
    end;
    // From codeunit 441 "Prepayment Mgt."
    procedure ServTranfLinePrep(ServLine: Record "Service Line EDMS")
    var
        ServLine1: Record "Service Line EDMS";
        ServLine2: Record "Service Line EDMS";
        TempServLine: Record "Service Line EDMS" temporary;
        Rate: Decimal;
        FreeAmount: Decimal;
        Text100: label 'Can''t apply all prepayment amount.';
    begin
        ServLine1.Reset;
        ServLine1.SetRange("Document Type", ServLine."Document Type");
        ServLine1.SetRange("Document No.", ServLine."Document No.");
        ServLine1.SetFilter("Line No.", '<>%1', ServLine."Line No.");
        ServLine1.SetFilter(Type, '<>%1', ServLine.Type::Comment);
        ServLine1.SetRange("Gen. Bus. Posting Group", ServLine."Gen. Bus. Posting Group");
        ServLine1.SetRange("Gen. Prod. Posting Group", ServLine."Gen. Prod. Posting Group");
        ServLine1.SetRange("VAT Bus. Posting Group", ServLine."VAT Bus. Posting Group");
        ServLine1.SetRange("VAT Prod. Posting Group", ServLine."VAT Prod. Posting Group");
        ServLine1.SetRange("VAT Bus. Posting Group", ServLine."VAT Bus. Posting Group");
        ServLine1.SetRange("VAT Prod. Posting Group", ServLine."VAT Prod. Posting Group");

        ServLine1.SetFilter("Line Amount", '>0');

        TempServLine.DeleteAll;
        if ServLine1.FindFirst then
            repeat
                if ServLine1."Line Amount" <> ServLine1."Prepayment Amount" then begin
                    TempServLine.Init;
                    TempServLine.Copy(ServLine1);
                    TempServLine.Insert;
                end;
            until ServLine1.Next = 0;
        TempServLine.Reset;



        if TempServLine.FindFirst then
            repeat
                ServLine1.Get(TempServLine."Document Type", TempServLine."Document No.", TempServLine."Line No.");
                FreeAmount := 0;
                FreeAmount := ServLine1."Line Amount" - ServLine1."Prepayment Amount";

                if FreeAmount >= ServLine."Prepayment Amount" then begin
                    ServLine1.Validate("Prepmt. Line Amount", ServLine1."Prepayment Amount" + ServLine."Prepayment Amount");
                    ServLine1."Prepmt. Amt. Inv." += ServLine."Prepmt. Amt. Inv.";
                    ServLine1."Prepmt. Amt. Incl. VAT" += ServLine."Prepmt. Amt. Incl. VAT";
                    ServLine1."Prepayment Amount" += ServLine."Prepayment Amount";
                    ServLine1."Prepmt. VAT Base Amt." += ServLine."Prepmt. VAT Base Amt.";
                    ServLine1."Prepayment VAT %" += ServLine."Prepayment VAT %";
                    ServLine1."Prepmt. VAT Calc. Type" := ServLine."Prepmt. VAT Calc. Type";
                    ServLine1."Prepayment VAT Identifier" := ServLine."Prepayment VAT Identifier";
                    ServLine1."Prepayment Tax Area Code" := ServLine."Prepayment Tax Area Code";
                    ServLine1."Prepayment Tax Liable" := ServLine."Prepayment Tax Liable";
                    ServLine1."Prepayment Tax Group Code" := ServLine."Prepayment Tax Group Code";
                    ServLine1."Prepmt Amt to Deduct" += ServLine."Prepmt Amt to Deduct";
                    ServLine1."Prepmt Amt Deducted" += ServLine."Prepmt Amt Deducted";
                    ServLine1."Prepayment Amount Incl. VAT" += ServLine."Prepayment Amount Incl. VAT";
                    ServLine1.Modify;

                    //Updating Real Entry
                    ServLine1.Get(ServLine."Document Type", ServLine."Document No.", ServLine."Line No.");

                    ServLine1."Prepayment %" := 0;
                    ServLine1."Prepmt. Line Amount" := 0;

                    ServLine1."Prepmt. Amt. Inv." := 0;
                    ServLine1."Prepmt. Amt. Incl. VAT" := 0;
                    ServLine1."Prepayment Amount" := 0;
                    ServLine1."Prepmt. VAT Base Amt." := 0;
                    ServLine1."Prepayment VAT %" := 0;
                    ServLine1."Prepmt. VAT Calc. Type" := 0;
                    ServLine1."Prepayment VAT Identifier" := '';
                    ServLine1."Prepayment Tax Area Code" := '';
                    //ServLine1."Prepayment Tax Liable" := ;
                    ServLine1."Prepayment Tax Group Code" := '';
                    ServLine1."Prepmt Amt to Deduct" := 0;
                    ServLine1."Prepmt Amt Deducted" := 0;
                    ServLine1."Prepayment Amount Incl. VAT" := 0;
                    ServLine1.Modify;

                    //Updating Base Amounts
                    ServLine."Prepmt. Line Amount" := 0;
                end
                else begin
                    //Rate := FreeAmount/ServLine."Prepmt. Line Amount";
                    ServLine2 := ServLine1;

                    ServLine1.Validate("Prepayment %", 100);
                    Rate := ServLine1."Prepmt. Line Amount" / ServLine2."Prepmt. Line Amount";

                    ServLine1."Prepmt. Amt. Inv." := ROUND((ServLine1."Prepmt. Amt. Inv." * Rate), 0.01);
                    ServLine1."Prepmt. Amt. Incl. VAT" := ROUND((ServLine1."Prepmt. Amt. Incl. VAT" * Rate), 0.01);
                    ServLine1."Prepayment Amount" := ROUND((ServLine1."Prepayment Amount" * Rate), 0.01);
                    ServLine1."Prepmt. VAT Base Amt." := ROUND((ServLine1."Prepmt. VAT Base Amt." * Rate), 0.01);
                    ServLine1."Prepayment VAT %" := ServLine."Prepayment VAT %";
                    ServLine1."Prepmt. VAT Calc. Type" := ServLine."Prepmt. VAT Calc. Type";
                    ServLine1."Prepayment VAT Identifier" := ServLine."Prepayment VAT Identifier";
                    ServLine1."Prepayment Tax Area Code" := ServLine."Prepayment Tax Area Code";
                    ServLine1."Prepayment Tax Liable" := ServLine."Prepayment Tax Liable";
                    ServLine1."Prepayment Tax Group Code" := ServLine."Prepayment Tax Group Code";
                    ServLine1."Prepmt Amt to Deduct" := ROUND((ServLine1."Prepmt Amt to Deduct" * Rate), 0.01);
                    ServLine1."Prepmt Amt Deducted" := ROUND((ServLine1."Prepmt Amt Deducted" * Rate), 0.01);
                    ServLine1."Prepayment Amount Incl. VAT" := ROUND((ServLine1."Prepayment Amount Incl. VAT" * Rate), 0.01);
                    ServLine1.Modify;

                    //Updating Base Amounts
                    ServLine."Prepmt. Line Amount" -= (ServLine1."Prepmt. Line Amount" - ServLine2."Prepmt. Line Amount");
                    ServLine."Prepmt. Amt. Inv." -= (ServLine1."Prepmt. Amt. Inv." - ServLine2."Prepmt. Line Amount");
                    ServLine."Prepmt. Amt. Incl. VAT" -= (ServLine1."Prepmt. Amt. Incl. VAT" - ServLine2."Prepmt. Amt. Incl. VAT");
                    ServLine."Prepayment Amount" -= (ServLine1."Prepayment Amount" - ServLine2."Prepayment Amount");
                    ServLine."Prepmt. VAT Base Amt." -= (ServLine1."Prepmt. VAT Base Amt." - ServLine2."Prepmt. VAT Base Amt.");
                    ServLine."Prepmt Amt to Deduct" -= (ServLine1."Prepmt Amt to Deduct" - ServLine2."Prepmt Amt to Deduct");
                    ServLine."Prepmt Amt Deducted" -= (ServLine1."Prepmt Amt Deducted" - ServLine2."Prepmt Amt Deducted");
                    ServLine."Prepayment Amount Incl. VAT" -= (ServLine1."Prepayment Amount Incl. VAT" -
                                                                 ServLine2."Prepayment Amount Incl. VAT");
                end;
            until TempServLine.Next = 0;

        if ServLine."Prepmt. Line Amount" <> 0 then
            Error(Text100);
    end;

    // From codeunit 441 "Prepayment Mgt."
    procedure SalesTranfLinePrep(SalesLine: Record "Sales Line")
    var
        SalesLine1: Record "Sales Line";
        SalesLine2: Record "Sales Line";
        TempSalesLine: Record "Sales Line" temporary;
        FreeAmount: Decimal;
        Rate: Decimal;
        Text100: label 'Can''t apply all prepayment amount.';
    begin
        SalesLine1.Reset;
        SalesLine1.SetRange("Document Type", SalesLine."Document Type");
        SalesLine1.SetRange("Document No.", SalesLine."Document No.");
        SalesLine1.SetFilter("Line No.", '<>%1', SalesLine."Line No.");
        SalesLine1.SetFilter(Type, '<>%1', SalesLine.Type::" ");
        SalesLine1.SetRange("Gen. Bus. Posting Group", SalesLine."Gen. Bus. Posting Group");
        SalesLine1.SetRange("Gen. Prod. Posting Group", SalesLine."Gen. Prod. Posting Group");
        SalesLine1.SetRange("VAT Bus. Posting Group", SalesLine."VAT Bus. Posting Group");
        SalesLine1.SetRange("VAT Prod. Posting Group", SalesLine."VAT Prod. Posting Group");

        SalesLine1.SetFilter("Line Amount", '>0');

        TempSalesLine.DeleteAll;
        if SalesLine1.FindFirst then
            repeat
                if SalesLine1."Line Amount" <> SalesLine1."Prepayment Amount" then begin
                    TempSalesLine.Init;
                    TempSalesLine.Copy(SalesLine1);
                    TempSalesLine.Insert;
                end;
            until SalesLine1.Next = 0;
        TempSalesLine.Reset;

        if TempSalesLine.FindFirst then
            repeat
                SalesLine1.Get(TempSalesLine."Document Type", TempSalesLine."Document No.", TempSalesLine."Line No.");
                FreeAmount := 0;
                FreeAmount := SalesLine1."Line Amount" - SalesLine1."Prepayment Amount";

                if FreeAmount >= SalesLine."Prepayment Amount" then begin
                    SalesLine1.Validate("Prepmt. Line Amount", SalesLine1."Prepmt. Line Amount" + SalesLine."Prepmt. Line Amount");
                    SalesLine1."Prepmt. Amt. Inv." += SalesLine."Prepmt. Amt. Inv.";
                    SalesLine1."Prepmt. Amt. Incl. VAT" += SalesLine."Prepmt. Amt. Incl. VAT";
                    SalesLine1."Prepayment Amount" += SalesLine."Prepayment Amount";
                    SalesLine1."Prepmt. VAT Base Amt." += SalesLine."Prepmt. VAT Base Amt.";
                    SalesLine1."Prepayment VAT %" := SalesLine."Prepayment VAT %";
                    SalesLine1."Prepmt. VAT Calc. Type" := SalesLine."Prepmt. VAT Calc. Type";
                    SalesLine1."Prepayment VAT Identifier" := SalesLine."Prepayment VAT Identifier";
                    SalesLine1."Prepayment Tax Area Code" := SalesLine."Prepayment Tax Area Code";
                    SalesLine1."Prepayment Tax Liable" := SalesLine."Prepayment Tax Liable";
                    SalesLine1."Prepayment Tax Group Code" := SalesLine."Prepayment Tax Group Code";
                    SalesLine1."Prepmt Amt to Deduct" += SalesLine."Prepmt Amt to Deduct";
                    SalesLine1."Prepmt Amt Deducted" += SalesLine."Prepmt Amt Deducted";
                    SalesLine1."Prepmt. Amount Inv. Incl. VAT" += SalesLine."Prepmt. Amount Inv. Incl. VAT";
                    SalesLine1.Modify;

                    //Updating Real Entry
                    SalesLine1.Get(SalesLine."Document Type", SalesLine."Document No.", SalesLine."Line No.");

                    SalesLine1."Prepayment %" := 0;
                    SalesLine1."Prepmt. Line Amount" := 0;

                    SalesLine1."Prepmt. Amt. Inv." := 0;
                    SalesLine1."Prepmt. Amt. Incl. VAT" := 0;
                    SalesLine1."Prepayment Amount" := 0;
                    SalesLine1."Prepmt. VAT Base Amt." := 0;
                    SalesLine1."Prepayment VAT %" := 0;
                    SalesLine1."Prepmt. VAT Calc. Type" := 0;
                    SalesLine1."Prepayment VAT Identifier" := '';
                    SalesLine1."Prepayment Tax Area Code" := '';
                    SalesLine1."Prepayment Tax Group Code" := '';
                    SalesLine1."Prepmt Amt to Deduct" := 0;
                    SalesLine1."Prepmt Amt Deducted" := 0;
                    SalesLine1."Prepmt. Amount Inv. Incl. VAT" := 0;
                    SalesLine1.Modify;

                    //Updating Base Amounts
                    SalesLine."Prepmt. Line Amount" := 0;
                end
                else begin
                    //Rate := FreeAmount/SalesLine."Prepmt. Line Amount";
                    SalesLine2 := SalesLine1;

                    SalesLine1.Validate("Prepayment %", 100);
                    Rate := SalesLine1."Prepmt. Line Amount" / SalesLine2."Prepmt. Line Amount";

                    SalesLine1."Prepmt. Amt. Inv." := ROUND((SalesLine1."Prepmt. Amt. Inv." * Rate), 0.01);
                    SalesLine1."Prepmt. Amt. Incl. VAT" := ROUND((SalesLine1."Prepmt. Amt. Incl. VAT" * Rate), 0.01);
                    SalesLine1."Prepayment Amount" := ROUND((SalesLine1."Prepayment Amount" * Rate), 0.01);
                    SalesLine1."Prepmt. VAT Base Amt." := ROUND((SalesLine1."Prepmt. VAT Base Amt." * Rate), 0.01);
                    SalesLine1."Prepayment VAT %" := SalesLine."Prepayment VAT %";
                    SalesLine1."Prepmt. VAT Calc. Type" := SalesLine."Prepmt. VAT Calc. Type";
                    SalesLine1."Prepayment VAT Identifier" := SalesLine."Prepayment VAT Identifier";
                    SalesLine1."Prepayment Tax Area Code" := SalesLine."Prepayment Tax Area Code";
                    SalesLine1."Prepayment Tax Liable" := SalesLine."Prepayment Tax Liable";
                    SalesLine1."Prepayment Tax Group Code" := SalesLine."Prepayment Tax Group Code";
                    SalesLine1."Prepmt Amt to Deduct" := ROUND((SalesLine1."Prepmt Amt to Deduct" * Rate), 0.01);
                    SalesLine1."Prepmt Amt Deducted" := ROUND((SalesLine1."Prepmt Amt Deducted" * Rate), 0.01);
                    SalesLine1."Prepmt. Amount Inv. Incl. VAT" := ROUND((SalesLine1."Prepmt. Amount Inv. Incl. VAT" * Rate), 0.01);
                    SalesLine1.Modify;

                    //Updating Base Amounts
                    SalesLine."Prepmt. Line Amount" -= (SalesLine1."Prepmt. Line Amount" - SalesLine2."Prepmt. Line Amount");
                    SalesLine."Prepmt. Amt. Inv." -= (SalesLine1."Prepmt. Amt. Inv." - SalesLine2."Prepmt. Amt. Inv.");
                    SalesLine."Prepmt. Amt. Incl. VAT" -= (SalesLine1."Prepmt. Amt. Incl. VAT" - SalesLine2."Prepmt. Amt. Incl. VAT");
                    SalesLine."Prepayment Amount" -= (SalesLine1."Prepayment Amount" - SalesLine2."Prepayment Amount");
                    SalesLine."Prepmt. VAT Base Amt." -= (SalesLine1."Prepmt. VAT Base Amt." - SalesLine2."Prepmt. VAT Base Amt.");
                    SalesLine."Prepmt Amt to Deduct" -= (SalesLine1."Prepmt Amt to Deduct" - SalesLine2."Prepmt Amt to Deduct");
                    SalesLine."Prepmt Amt Deducted" -= (SalesLine1."Prepmt Amt Deducted" - SalesLine2."Prepmt Amt Deducted");
                    SalesLine."Prepmt. Amount Inv. Incl. VAT" -= (SalesLine1."Prepmt. Amount Inv. Incl. VAT" -
                                                                  SalesLine2."Prepmt. Amount Inv. Incl. VAT");
                end;
            until TempSalesLine.Next = 0;

        if SalesLine."Prepmt. Line Amount" <> 0 then
            Error(Text100);
    end;
    //From codeunit 5702 "Dist. Integration"
    procedure GetSpecialServiceOrders(var PurchHeader: Record "Purchase Header")
    var
        ServiceHeader: Record "Service Header EDMS";
        ServiceLine: Record "Service Line EDMS";
        PurchLine2: Record "Purchase Line";
        ItemUnitOfMeasure: Record "Item Unit of Measure";
        TransferExtendedText: Codeunit "Transfer Extended Text";
        CopyDocMgt: Codeunit "Copy Document Mgt.";
        NextLineNo: Integer;
        SalesLine: Record "Sales Line";
        PurchLine: Record "Purchase Line";
        Text000: Label 'There are no items with cross reference %1.', Comment = '%1=Cross-Reference No.';
        Text001: Label 'The Quantity per Unit of Measure %1 has changed from %2 to %3 since the sales order was created. Adjust the quantity on the sales order or the unit of measure.', Comment = '%1=Unit of Measure Code,%2=Qty. per Unit of Measure in Sales Line,%3=Qty. per Unit of Measure in Item Unit of Measure';
    begin
        PurchHeader.TestField("Document Type", PurchHeader."document type"::Order);

        ServiceHeader.SetCurrentkey("Document Type", "Sell-to Customer No.");
        ServiceHeader.SetRange("Document Type", ServiceHeader."document type"::Order);
        ServiceHeader.SetRange("Sell-to Customer No.", PurchHeader."Sell-to Customer No.");
        if (Page.RunModal(Page::"Service Orders EDMS", ServiceHeader) <> Action::LookupOK) or
           (ServiceHeader."No." = '')
        then
            exit;
        if PurchHeader.RECORDLEVELLOCKING then
            PurchHeader.LockTable;
        ServiceHeader.TestField("Document Type", ServiceHeader."document type"::Order);
        PurchHeader.TestField("Sell-to Customer No.", ServiceHeader."Sell-to Customer No.");
        //PurchHeader.VALIDATE("Location Code", ServiceHeader."Location Code"); // P8 - i AM NOT SURE - should it be or not
        PurchHeader.SetShipToForSpecOrder;

        PurchLine.LockTable;
        if not PurchHeader.RECORDLEVELLOCKING then
            PurchHeader.LockTable(true, true); // Only version check
        ServiceLine.LockTable;
        if not PurchHeader.RECORDLEVELLOCKING then
            ServiceHeader.LockTable(true, true); // Only version check

        PurchLine.SetRange("Document Type", PurchLine."document type"::Order);
        PurchLine.SetRange("Document No.", PurchHeader."No.");
        if PurchLine.FindLast then
            NextLineNo := PurchLine."Line No." + 10000
        else
            NextLineNo := 10000;

        ServiceLine.Reset;
        ServiceLine.SetRange("Document Type", SalesLine."document type"::Order);
        ServiceLine.SetRange("Document No.", ServiceHeader."No.");
        ServiceLine.SetRange("Special Order", true);
        ServiceLine.SetFilter("Outstanding Quantity", '<>0');
        ServiceLine.SetRange(Type, SalesLine.Type::Item);
        ServiceLine.SetFilter("No.", '<>%1', '');
        ServiceLine.SetRange("Special Order Purch. Line No.", 0);

        if ServiceLine.FindSet then
            repeat
                if (ServiceLine.Type = SalesLine.Type::Item) and ItemUnitOfMeasure.Get(ServiceLine."No.", ServiceLine."Unit of Measure") then
                    if ServiceLine."Qty. per Unit of Measure" <> ItemUnitOfMeasure."Qty. per Unit of Measure" then
                        Error(Text001,
                          ServiceLine.FieldCaption("Qty. per Unit of Measure"),
                          ServiceLine.FieldCaption("Unit of Measure"),
                          ServiceLine."Unit of Measure",
                          ServiceLine."Qty. per Unit of Measure",
                          ItemUnitOfMeasure."Qty. per Unit of Measure",
                          ServiceLine.FieldCaption(Quantity));
                PurchLine.Init;
                PurchLine."Document Type" := PurchLine."document type"::Order;
                PurchLine."Document No." := PurchHeader."No.";
                PurchLine."Line No." := NextLineNo;
                TransfldsFromServToPurchLine(ServiceLine, PurchLine);
                PurchLine."Special Order" := true;
                PurchLine."Purchasing Code" := ServiceLine."Purchasing Code";
                PurchLine."Special Order Service No." := ServiceLine."Document No.";
                PurchLine."Special Order Service Line No." := ServiceLine."Line No.";
                PurchLine.Insert;
                NextLineNo := NextLineNo + 10000;

                ServiceLine."Unit Cost (LCY)" := PurchLine."Unit Cost (LCY)";
                ServiceLine.Validate("Unit Cost (LCY)");
                ServiceLine."Special Order Purchase No." := PurchLine."Document No.";
                ServiceLine."Special Order Purch. Line No." := PurchLine."Line No.";
                ServiceLine.Modify;
                if TransferExtendedText.PurchCheckIfAnyExtText(PurchLine, true) then begin
                    TransferExtendedText.InsertPurchExtText(PurchLine);
                    PurchLine2.SetRange("Document Type", PurchHeader."Document Type");
                    PurchLine2.SetRange("Document No.", PurchHeader."No.");
                    if PurchLine2.FindLast then
                        NextLineNo := PurchLine2."Line No.";
                    NextLineNo := NextLineNo + 10000;
                end;
            until ServiceLine.Next = 0
        else
            Error(
              Text000,
              ServiceHeader."No.");

        PurchHeader.Modify; // Only version check
        ServiceHeader.Modify; // Only version check
    end;
    //From codeunit 5702 "Dist. Integration"
    procedure TransfldsFromServToPurchLine(var FromServiceLine: Record "Service Line EDMS"; var ToPurchLine: Record "Purchase Line")
    begin
        ToPurchLine.Validate(Type, FromServiceLine.Type);
        ToPurchLine.Validate("No.", FromServiceLine."No.");
        ToPurchLine.Validate("Variant Code", FromServiceLine."Variant Code");
        ToPurchLine.Validate("Location Code", FromServiceLine."Location Code");
        ToPurchLine.Validate("Unit of Measure Code", FromServiceLine."Unit of Measure Code");
        if (ToPurchLine.Type = ToPurchLine.Type::Item) and (ToPurchLine."No." <> '') then
            ToPurchLine.UpdateUOMQtyPerStockQty;
        ToPurchLine."Expected Receipt Date" := FromServiceLine."Shipment Date";
        ToPurchLine."Bin Code" := FromServiceLine."Bin Code";
        ToPurchLine.Validate(Quantity, FromServiceLine."Outstanding Quantity");
        ToPurchLine.Validate("Direct Unit Cost");
    end;
    //From codeunit 5703 "Catalog Item Management"
    procedure TransferSalesPrices(var recNonstockItem: Record "Nonstock Item")
    var
        recSalesPrice: Record "Sales Price";
        recNonstockSalesPrice: Record "Nonstock Item Price";
        recItemUOM: Record "Item Unit of Measure";
    begin
        //EDMS
        recNonstockSalesPrice.SetRange("Nonstock Item Entry No.", recNonstockItem."Entry No.");
        if not recNonstockSalesPrice.FindSet(true, false) then
            exit;

        repeat
            recNonstockSalesPrice.Modify(true)
        until recNonstockSalesPrice.Next = 0;
    end;

    //From codeunit 5703 "Catalog Item Management"
    procedure TransferSalesLineDiscounts(var recNonstockItem: Record "Nonstock Item")
    var
        recSalesDisc: Record "Sales Line Discount";
        recNonstockSalesDisc: Record "Nonstock Sales Line Discount";
        recItemUOM: Record "Item Unit of Measure";
    begin
        //EDMS
        recNonstockSalesDisc.SetRange("Nonstock Item Entry No.", recNonstockItem."Entry No.");
        if not recNonstockSalesDisc.FindSet(true, false) then
            exit;

        repeat
            recNonstockSalesDisc.Modify(true);
        until recNonstockSalesDisc.Next = 0;
    end;

    //From codeunit 5703 "Catalog Item Management"
    procedure TransferPurchPrices(var recNonstockItem: Record "Nonstock Item")
    var
        recPurchPrice: Record "Purchase Price";
        recNonstockPurchPrice: Record "Nonstock Purchase Price";
        recItemUOM: Record "Item Unit of Measure";
    begin
        //EDMS
        recNonstockPurchPrice.SetRange("Nonstock Item Entry No.", recNonstockItem."Entry No.");
        if not recNonstockPurchPrice.FindSet(true, false) then
            exit;

        repeat
            recNonstockPurchPrice.Modify(true);
        until recNonstockPurchPrice.Next = 0;
    end;

    //From codeunit 5703 "Catalog Item Management"
    procedure TransferPurchLineDiscounts(var recNonstockItem: Record "Nonstock Item")
    var
        recItemUOM: Record "Item Unit of Measure";
        recPurchDisc: Record "Purchase Line Discount";
        recNonstockPurchDisc: Record "Nonstock Purchase Line Disc";
    begin
        //EDMS
        recNonstockPurchDisc.SetRange("Nonstock Item Entry No.", recNonstockItem."Entry No.");
        if not recNonstockPurchDisc.FindSet(true, false) then
            exit;

        repeat
            recNonstockPurchDisc.Modify(true);
        until recNonstockPurchDisc.Next = 0;
    end;

    //From codeunit 5703 "Catalog Item Management"
    procedure LinkToItem(EntryNo: Code[20]): Boolean
    var
        LookUpManagement: Codeunit LookUpManagement;
        LinkItem: Record Item;
        NonStock: Record "Nonstock Item";
        Text008: label 'Nonstock Item No. %1 and Item No. %2 No. are not equal. Would you like to proceed?';
        Text009: label 'Nonstock Item No. %1 linked to Item No. %2';

    begin
        NonStock.Get(EntryNo);
        LookUpManagement.LookUpItem(LinkItem, EntryNo);
        if LinkItem."No." <> EntryNo then
            if not Confirm(StrSubstNo(Text008, EntryNo, LinkItem."No.")) then
                exit
            else begin
                NonStock."Item No." := LinkItem."No.";
                NonStock.Modify(false);
                LinkItem."Created From Nonstock Item" := true;
                LinkItem.Modify(true);
                TransferSalesPrices(NonStock);
                TransferSalesLineDiscounts(NonStock);
                TransferPurchPrices(NonStock);
                TransferPurchLineDiscounts(NonStock);
                Message(StrSubstNo(Text009, EntryNo, LinkItem."No."));
            end;
    end;
    //From codeunit 5704 "TransferOrder-Post Shipment"
    procedure UpdateVehicelSerialNo(var recTransferHeader: Record "Transfer Header")
    var
        recTransferLine: Record "Transfer Line";
        cuVehSN: Codeunit "Vehicle Serial No. Mgt.";
    begin
        if recTransferHeader."Document Profile" <> recTransferHeader."document profile"::"Vehicles Trade" then
            exit;
        Clear(cuVehSN);
        recTransferLine.Reset;
        recTransferLine.SetRange("Document No.", recTransferHeader."No.");
        if recTransferLine.Find('-') then
            repeat
                if recTransferLine."Document Profile" = recTransferLine."document profile"::"Vehicles Trade" then begin
                    recTransferLine.TestField("Vehicle Serial No.");
                    cuVehSN.fDeleteTransferLineTracking(recTransferLine);
                    cuVehSN.fCreateTransferLineTracking(recTransferLine);
                end;
            until recTransferLine.Next = 0;
    end;

    //From codeunit 5704 "TransferOrder-Post Shipment"
    procedure CheckService(Rec: Record "Transfer Header")
    var
        Location: Record Location;
        InboundToLink: Boolean;
        Text101: label 'There is a Transfer Line(s) not fully reserved to a Service Line(s). Do you want system to create automatic reservation(s)?\Note: This may lead to creation of new Service Lines';
        Text010: label 'There is a Transfer Line(s) not fully reserved to a Service Line(s).';
        ServTransfMgt: Codeunit "Service Transfer Mgt.";
    begin
        Rec.TestField("Source No.");

        if (Rec."Source Type" = Database::"Service Header EDMS") and
           (Rec."Source Subtype" = 1) then //Service Order
            InboundToLink := CheckInboundToLink(Rec);

        if InboundToLink then
            if GuiAllowed then begin  //06.03.2013 EDMS P8
                if Confirm(Text101, false) then
                    ServTransfMgt.LinkTransferWithService(Rec)
                else                    // 04.02.2015 EDMS P21
                    Error(Text010)        // 04.02.2015 EDMS P21
            end else
                ServTransfMgt.LinkTransferWithService(Rec)
    end;

    //From codeunit 5704 "TransferOrder-Post Shipment"
    procedure CheckInboundToLink(Rec: Record "Transfer Header"): Boolean
    var
        Location: Record Location;
        TransferLine: Record "Transfer Line";
        ServTransfMgt: Codeunit "Service Transfer Mgt.";
    begin
        if not ServTransfMgt.IsServiceLocation(Rec."Transfer-to Code") then
            exit;
        TransferLine.Reset;
        TransferLine.SetRange("Document No.", Rec."No.");
        if TransferLine.FindFirst then
            repeat
                TransferLine.CalcFields("Reserved Quantity Inbnd.");
                if (TransferLine.Quantity - TransferLine."Quantity Shipped") <> TransferLine."Reserved Quantity Inbnd." then
                    exit(true);
            until TransferLine.Next = 0;
    end;

    //From codeunit 5704 "TransferOrder-Post Shipment"
    procedure FillLineVariableFields(var TransferLine: Record "Transfer Line"; var TransferShipmentLine: Record "Transfer Shipment Line")
    var
        VariableFieldUsage: Record "Variable Field Usage";
        VariableFieldUsage2: Record "Variable Field Usage";
        RecordRef: RecordRef;
        RecordRef2: RecordRef;
        FieldRef: FieldRef;
        FieldRef2: FieldRef;
    begin
        RecordRef.Open(Database::"Transfer Line");
        RecordRef.GetTable(TransferLine);
        RecordRef2.Open(Database::"Transfer Shipment Line");
        RecordRef2.GetTable(TransferShipmentLine);

        VariableFieldUsage.Reset;
        VariableFieldUsage.SetRange("Table No.", Database::"Transfer Line");
        if VariableFieldUsage.FindFirst then
            repeat
                VariableFieldUsage2.Reset;
                VariableFieldUsage2.SetRange("Table No.", Database::"Transfer Shipment Line");
                VariableFieldUsage2.SetRange("Variable Field Code", VariableFieldUsage."Variable Field Code");
                if VariableFieldUsage2.FindFirst then begin
                    FieldRef := RecordRef.Field(VariableFieldUsage."Field No.");
                    FieldRef2 := RecordRef2.Field(VariableFieldUsage2."Field No.");
                    FieldRef2.Value(FieldRef.Value);
                end;
            until VariableFieldUsage.Next = 0;
        RecordRef2.SetTable(TransferShipmentLine);
    end;

    //From codeunit 5704 "TransferOrder-Post Shipment"
    procedure EDMSCheckItemInInventory(TransLine: Record "Transfer Line")
    var
        Item: Record Item;
        Text009: Label 'Item %1 is not in inventory.';
    begin
        Item.Get(TransLine."Item No.");
        Item.SetRange("Variant Filter", TransLine."Variant Code");
        Item.SetRange("Location Filter", TransLine."Transfer-from Code");
        Item.CalcFields(Inventory);
        if Item.Inventory <= 0 then
            Error(Text009, TransLine."Item No.");
    end;

    //For codeunit 5777 "Whse. Validate Source Line"
    procedure EDMSWhseLinesExist(SourceType: Integer; SourceSubType: Option; SourceNo: Code[20]; SourceLineNo: Integer; SourceSublineNo: Integer; SourceQty: Decimal) Result: Text[100]
    var
        WhseRcptLine: Record "Warehouse Receipt Line";
        WhseShptLine: Record "Warehouse Shipment Line";
        WhseManagement: Codeunit "Whse. Management";
        WhseActivLine: Record "Warehouse Activity Line";
        TableCaptionValue: Text[100];
    begin

        if ((SourceType = DATABASE::"Purchase Line") and (SourceSubType = 1) and (SourceQty >= 0)) or
           ((SourceType = DATABASE::"Purchase Line") and (SourceSubType = 5) and (SourceQty < 0)) or
           ((SourceType = DATABASE::"Sales Line") and (SourceSubType = 1) and (SourceQty < 0)) or
           ((SourceType = DATABASE::"Sales Line") and (SourceSubType = 5) and (SourceQty >= 0)) or
           ((SourceType = DATABASE::"Transfer Line") and (SourceSubType = 1))
        then begin
            WhseManagement.SetSourceFilterForWhseRcptLine(WhseRcptLine, SourceType, SourceSubType, SourceNo, SourceLineNo, true);
            if not WhseRcptLine.IsEmpty() then begin
                TableCaptionValue := WhseRcptLine.TableCaption;
            end;
        end;

        if ((SourceType = DATABASE::"Purchase Line") and (SourceSubType = 1) and (SourceQty < 0)) or
           ((SourceType = DATABASE::"Purchase Line") and (SourceSubType = 5) and (SourceQty >= 0)) or
           ((SourceType = DATABASE::"Sales Line") and (SourceSubType = 1) and (SourceQty >= 0)) or
           ((SourceType = DATABASE::"Sales Line") and (SourceSubType = 5) and (SourceQty < 0)) or
           ((SourceType = DATABASE::"Transfer Line") and (SourceSubType = 0)) or
           ((SourceType = DATABASE::"Service Line") and (SourceSubType = 1))
        then begin
            WhseShptLine.SetSourceFilter(SourceType, SourceSubType, SourceNo, SourceLineNo, true);
            if not WhseShptLine.IsEmpty() then begin
                TableCaptionValue := WhseShptLine.TableCaption;
            end;
        end;

        WhseActivLine.SetSourceFilter(SourceType, SourceSubType, SourceNo, SourceLineNo, SourceSublineNo, true);
        if not WhseActivLine.IsEmpty() then begin
            TableCaptionValue := WhseActivLine.TableCaption;
        end;

        TableCaptionValue := '';
        exit(TableCaptionValue);
    end;

    procedure ServicLineEDMSCheck(ServiceLine: Record "Service Line EDMS"; ForceRequest: Boolean)
    Var
        ReserveServiceLineEDMS: Codeunit "Service Line EDMS-Reserve";
        ReservEntry: Record "Reservation Entry";
        ReservationCheckDateConfl: Codeunit "Reservation-Check Date Confl.";
        ReservationMgtEDMS: Codeunit "Reservation Management EDMS";
    begin
        if not ReserveServiceLineEDMS.FindReservEntry(ServiceLine, ReservEntry) then
            exit;
        if ReservationCheckDateConfl.DateConflict(ServiceLine."Planned Service Date", ForceRequest, ReservEntry) then
            if ForceRequest then ReservationCheckDateConfl.IssueError(ServiceLine."Planned Service Date");
        ReservationCheckDateConfl.UpdateDate(ReservEntry, ServiceLine."Planned Service Date");
        ReservationMgtEDMS.SetServLineEDMS(ServiceLine);
        ReservationMgtEDMS.ClearSurplus;
        ReservationMgtEDMS.AutoTrack(ServiceLine."Outstanding Qty. (Base)");
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::SegCriteriaManagement, 'OnBeforeInsertCriteriaAction', '', false, false)]
    local procedure OnBeforeInsertCriteriaAction(SegmentNo: Code[20]; var CalledFromReportNo: Integer; var AllowExistingContacts: Boolean; var ExpandContact: Boolean; var AllowCompanyWithPersons: Boolean; var IgnoreExclusion: Boolean; var EntireCompanies: Boolean; var IsHandled: Boolean);
    var
        SegCriteriaLine: Record "Segment Criteria Line";
        NextLineNo: Integer;

    begin

        SegCriteriaLine.LockTable();
        SegCriteriaLine.SetRange("Segment No.", SegmentNo);
        if SegCriteriaLine.FindLast then
            NextLineNo := SegCriteriaLine."Line No." + 1
        else
            NextLineNo := 1;

        SegCriteriaLine.Init();
        SegCriteriaLine."Segment No." := SegmentNo;
        SegCriteriaLine."Line No." := NextLineNo;
        SegCriteriaLine.Type := SegCriteriaLine.Type::Action;
        case CalledFromReportNo of
            REPORT::"EDMS Add Contacts":
                SegCriteriaLine.Action := SegCriteriaLine.Action::"Add Contacts";
            REPORT::"EDMS Remove Contacts - Reduce":
                SegCriteriaLine.Action := SegCriteriaLine.Action::"Remove Contacts (Reduce)";
            REPORT::"EDMS Remove Contacts - Refine":
                SegCriteriaLine.Action := SegCriteriaLine.Action::"Remove Contacts (Refine)";
            else
                OnInsertCriteriaActionOnCalledFromReportNoElseCase(SegCriteriaLine, CalledFromReportNo);
        end;
        SegCriteriaLine."Allow Existing Contacts" := AllowExistingContacts;
        SegCriteriaLine."Expand Contact" := ExpandContact;
        SegCriteriaLine."Allow Company with Persons" := AllowCompanyWithPersons;
        SegCriteriaLine."Ignore Exclusion" := IgnoreExclusion;
        SegCriteriaLine."Entire Companies" := EntireCompanies;
        OnBeforeInsertCriteriaActionOnBeforeSegCriteriaLineInsert(SegCriteriaLine);
        SegCriteriaLine.Insert();

        IsHandled := true;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnInsertCriteriaActionOnCalledFromReportNoElseCase(var SegCriteriaLine: Record "Segment Criteria Line"; CalledFromReportNo: Integer)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertCriteriaActionOnBeforeSegCriteriaLineInsert(var SegCriteriaLine: Record "Segment Criteria Line")
    begin
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Phys. Invt. Count.-Management", 'OnBeforeCalcInvtQtyOnHand', '', false, false)]
    local procedure OnBeforeCalcInvtQtyOnHand(DocNo: Code[20]; PostingDate: Date; ZeroQty: Boolean; var TempPhysInvtItemSelection: Record "Phys. Invt. Item Selection" temporary; var IsHandled: Boolean; var ItemJournalLine: Record "Item Journal Line"; var Item: Record Item);
    var

        CalculateInventory: Report "EDMS Calculate Inventory";
    begin
        CalculateInventory.InitializeRequest(PostingDate, DocNo, ZeroQty, false);
        CalculateInventory.SetItemJnlLine(ItemJournalLine);
        CalculateInventory.InitializePhysInvtCount(
          TempPhysInvtItemSelection."Phys Invt Counting Period Code",
          TempPhysInvtItemSelection."Phys Invt Counting Period Type");
        CalculateInventory.UseRequestPage(false);
        CalculateInventory.SetHideValidationDialog(true);
        Item.SetRange("No.", TempPhysInvtItemSelection."Item No.");
        if TempPhysInvtItemSelection."Phys Invt Counting Period Type" =
           TempPhysInvtItemSelection."Phys Invt Counting Period Type"::SKU
        then begin
            Item.SetRange("Variant Filter", TempPhysInvtItemSelection."Variant Code");
            Item.SetRange("Location Filter", TempPhysInvtItemSelection."Location Code");
        end;
        CalculateInventory.SetTableView(Item);
        CalculateInventory.RunModal;
        Clear(CalculateInventory);

        IsHandled := false;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::ArchiveManagement, 'OnGetNextVersionNo', '', false, false)]
    local procedure OnGetNextVersionNoForService(TableId: Integer; DocType: Option; DocNo: Code[20]; DocNoOccurrence: Integer; var VersionNo: Integer);
    var
        ServiceHeaderArchive: Record "Service Header Archive";
        ContractArchive: Record "Contract Archive";
        VehicleAssemblyHeaderArch: Record "Vehicle Assembly Header Arch.";
    begin
        case TableId of
            Database::"Service Header EDMS":
                begin
                    ServiceHeaderArchive.LockTable;
                    ServiceHeaderArchive.SetRange("Document Type", DocType);
                    ServiceHeaderArchive.SetRange("No.", DocNo);
                    ServiceHeaderArchive.SetRange("Doc. No. Occurrence", DocNoOccurrence);
                    if ServiceHeaderArchive.FindLast then
                        VersionNo := ServiceHeaderArchive."Version No." + 1
                    else
                        VersionNo := 1;
                end;
            Database::Contract:
                begin
                    ContractArchive.LockTable;
                    ContractArchive.SetRange("Contract No.", DocNo);
                    ContractArchive.SetRange("Doc. No. Occurrence", DocNoOccurrence);
                    if ContractArchive.FindLast then
                        VersionNo := ContractArchive."Version No." + 1
                    else
                        VersionNo := 1;
                end;
            Database::"Vehicle Assembly Header":
                begin
                    VehicleAssemblyHeaderArch.LockTable;
                    VehicleAssemblyHeaderArch.SetRange("Assembly ID", DocNo);
                    if VehicleAssemblyHeaderArch.FindLast then
                        VersionNo := VehicleAssemblyHeaderArch."Version No." + 1
                    else
                        VersionNo := 1;
                end;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Gen. Journal Line", 'OnValidateAccountNoOnAfterAssignValue', '', false, false)]
    local procedure AddVehicleInfoForFixedAssetInGL(var GenJournalLine: Record "Gen. Journal Line"; var xGenJournalLine: Record "Gen. Journal Line")
    var
        FixedAsset: Record "Fixed Asset";
        Vehicle: Record Vehicle;
    begin
        if GenJournalLine."Account Type" = GenJournalLine."Account Type"::"Fixed Asset" then
            if FixedAsset.GET(GenJournalLine."Account No.") then
                if FixedAsset."Vehicle Serial No." <> '' then
                    if Vehicle.Get(FixedAsset."Vehicle Serial No.") then
                        GenJournalLine.Validate("Vehicle Serial No.", FixedAsset."Vehicle Serial No.");
    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterAssignFixedAssetValues', '', false, false)]
    local procedure AddVehicleInfoFromFixedAssetInSalesLine(var SalesLine: Record "Sales Line"; FixedAsset: Record "Fixed Asset")
    begin
        if FixedAsset."Vehicle Serial No." <> '' then begin
            SalesLine.Validate("Vehicle Serial No.", FixedAsset."Vehicle Serial No.");
        end;

    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterAssignFixedAssetValues', '', false, false)]
    local procedure AddVehicleInfoFromFixedAssetInPurchaseLine(var PurchLine: Record "Purchase Line"; FixedAsset: Record "Fixed Asset")
    begin
        if FixedAsset."Vehicle Serial No." <> '' then begin
            PurchLine.Validate("Vehicle Serial No.", FixedAsset."Vehicle Serial No.");
        end;

    end;

    [IntegrationEvent(false, false)]
    local procedure beforeUpdateCustomerOnAfterInsertCustomer(var ishandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure onaftercheckPRVNsalesheader(var SalesHeader: Record "Sales Header")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure onafterchecserviceheader(var SalesHeader: Record "Sales Header")
    begin
    end;

}

