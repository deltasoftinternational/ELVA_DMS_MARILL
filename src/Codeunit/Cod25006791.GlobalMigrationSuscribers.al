Codeunit 25006791 "Global Migration Suscribers"
{
    // #Owner EDMS.Integration


    trigger OnRun()
    begin
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Buy-from Vendor No.', false, false)]
    local procedure OnAfterValidateEventBuyfromVendorNo(var Rec: Record "Purchase Header")
    begin
        Rec.fSetUserDefaultValues;

        //        Rec.CreateDim(
        //                        Database::Vendor, Rec."Pay-to Vendor No.",
        //                        Database::"Salesperson/Purchaser", Rec."Purchaser Code",
        //                        Database::Campaign, Rec."Campaign No.",
        //                        Database::"Responsibility Center", Rec."Responsibility Center"
        //
        //                        );

    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterInitDefaultDimensionSources', '', false, false)]
    local procedure OnAfterInitDefaultDimensionSourcesPurchH(var PurchaseHeader: Record "Purchase Header"; var DefaultDimSource: List of [Dictionary of [Integer, Code[20]]]; FieldNo: Integer)
    Var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.AddDimSource(DefaultDimSource, Database::"Deal Type", PurchaseHeader."Deal Type Code", FieldNo = PurchaseHeader.FieldNo("Deal Type Code"));
        DimMgt.AddDimSource(DefaultDimSource, Database::"Vehicle", PurchaseHeader."Vehicle Serial No.", FieldNo = PurchaseHeader.FieldNo("Vehicle Serial No."));

    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Header", 'OnAfterInitDefaultDimensionSources', '', false, false)]
    local procedure OnAfterInitDefaultDimensionSourcesSalesH(var SalesHeader: Record "Sales Header"; var DefaultDimSource: List of [Dictionary of [Integer, Code[20]]]; FieldNo: Integer)
    Var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.AddDimSource(DefaultDimSource, Database::"Deal Type", SalesHeader."Deal Type Code", FieldNo = SalesHeader.FieldNo("Deal Type Code"));
        DimMgt.AddDimSource(DefaultDimSource, Database::"Vehicle", SalesHeader."Vehicle Serial No.", FieldNo = SalesHeader.FieldNo("Vehicle Serial No."));

    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Line", 'OnAfterInitDefaultDimensionSources', '', false, false)]
    local procedure OnAfterInitDefaultDimensionSourcesPurchL(var PurchaseLine: Record "Purchase Line"; var DefaultDimSource: List of [Dictionary of [Integer, Code[20]]]; FieldNo: Integer)
    Var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.AddDimSource(DefaultDimSource, Database::"Deal Type", PurchaseLine."Deal Type Code", FieldNo = PurchaseLine.FieldNo("Deal Type Code"));
        DimMgt.AddDimSource(DefaultDimSource, Database::"Make", PurchaseLine."Make Code", FieldNo = PurchaseLine.FieldNo("Make Code"));
        DimMgt.AddDimSource(DefaultDimSource, Database::"Vehicle Status", PurchaseLine."Vehicle Status Code", FieldNo = PurchaseLine.FieldNo("Vehicle Status Code"));
        DimMgt.AddDimSource(DefaultDimSource, Database::Vehicle, PurchaseLine."Vehicle Serial No.", FieldNo = PurchaseLine.FieldNo("Vehicle Serial No."));

    end;

    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterInitDefaultDimensionSources', '', false, false)]
    local procedure OnAfterInitDefaultDimensionSourcesSalesL(var SalesLine: Record "Sales Line"; var DefaultDimSource: List of [Dictionary of [Integer, Code[20]]]; FieldNo: Integer)
    Var
        DimMgt: Codeunit DimensionManagement;
    begin
        DimMgt.AddDimSource(DefaultDimSource, Database::"Deal Type", SalesLine."Deal Type Code", FieldNo = SalesLine.FieldNo("Deal Type Code"));
        DimMgt.AddDimSource(DefaultDimSource, Database::"Make", SalesLine."Make Code", FieldNo = SalesLine.FieldNo("Make Code"));
        DimMgt.AddDimSource(DefaultDimSource, Database::"Vehicle Status", SalesLine."Vehicle Status Code", FieldNo = SalesLine.FieldNo("Vehicle Status Code"));
        DimMgt.AddDimSource(DefaultDimSource, Database::Vehicle, SalesLine."Vehicle Serial No.", FieldNo = SalesLine.FieldNo("Vehicle Serial No."));

    end;




    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnValidatePurchaseHeaderPayToVendorNoOnBeforeCheckDocType', '', false, false)]
    local procedure OnValidatePurchaseHeaderPayToVendorNo(var PurchaseHeader: Record "Purchase Header"; Vendor: Record Vendor)
    begin
        //EDMS1.0.00 >>
        if PurchaseHeader."Purchaser Code" = '' then
            SetPurchaserCode(Vendor."Purchaser Code", PurchaseHeader."Purchaser Code");
        //EDMS1.0.00 <<
    end;

    local procedure SetPurchaserCode(PurchaserCodeToCheck: Code[20]; var PurchaserCodeToAssign: Code[20])
    var
        IsHandled: Boolean;
        SalespersonPurchaser: Record "Salesperson/Purchaser";

    begin
        if PurchaserCodeToCheck = '' then
            PurchaserCodeToCheck := GetUserSetupPurchaserCode();
        if SalespersonPurchaser.Get(PurchaserCodeToCheck) then begin
            if SalespersonPurchaser.VerifySalesPersonPurchaserPrivacyBlocked(SalespersonPurchaser) then
                PurchaserCodeToAssign := ''
            else
                PurchaserCodeToAssign := PurchaserCodeToCheck;
        end else
            PurchaserCodeToAssign := '';
    end;



    /*  [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterCreateDimTableIDs', '', false, false)]
      local procedure OnAfterCreateDimTableIDsAddDim(var PurchaseHeader: Record "Purchase Header"; CallingFieldNo: Integer; var No: array[10] of Code[20]; var TableID: array[10] of Integer)
      begin
          case CallingFieldNo of
              2, 4, 79:
                  begin
                      TableID[5] := Database::Vehicle;
                      No[5] := PurchaseHeader."Vehicle Serial No.";
                      TableID[6] := Database::Location;
                      No[6] := PurchaseHeader."Location Code";
                      TableID[7] := Database::"Deal Type";
                      No[7] := PurchaseHeader."Deal Type Code";
                  end;
              28:
                  begin
                      TableID[5] := Database::"Responsibility Center";
                      No[5] := PurchaseHeader."Responsibility Center";
                      TableID[6] := Database::Vehicle;
                      No[6] := PurchaseHeader."Vehicle Serial No.";
                      TableID[7] := Database::"Deal Type";
                      No[7] := PurchaseHeader."Deal Type Code";
                  end;
              43:
                  begin
                      TableID[5] := Database::Vehicle;
                      No[5] := PurchaseHeader."Vehicle Serial No.";
                      TableID[6] := Database::Location;
                      No[6] := PurchaseHeader."Location Code";
                      TableID[7] := Database::"Deal Type";
                      No[7] := PurchaseHeader."Deal Type Code";
                  end;
              5050:
                  begin
                      TableID[5] := Database::Vehicle;
                      No[5] := PurchaseHeader."Vehicle Serial No.";
                      TableID[6] := Database::Location;
                      No[6] := PurchaseHeader."Location Code";
                      TableID[7] := Database::"Deal Type";
                      No[7] := PurchaseHeader."Deal Type Code";
                  end;
              5700:
                  begin
                      TableID[5] := Database::Vehicle;
                      No[5] := PurchaseHeader."Vehicle Serial No.";
                      TableID[6] := Database::Location;
                      No[6] := PurchaseHeader."Location Code";
                      TableID[7] := Database::"Deal Type";
                      No[7] := PurchaseHeader."Deal Type Code";
                  end;
              25006001:
                  begin
                      TableID[5] := Database::Vehicle;
                      No[5] := PurchaseHeader."Vehicle Serial No.";
                      TableID[6] := Database::Location;
                      No[6] := PurchaseHeader."Location Code";
                      TableID[7] := Database::"Deal Type";
                      No[7] := PurchaseHeader."Deal Type Code";
                  end;
              25006378:
                  begin
                      TableID[5] := Database::Vehicle;
                      No[5] := PurchaseHeader."Vehicle Serial No.";
                      TableID[6] := Database::Location;
                      No[6] := PurchaseHeader."Location Code";
                      TableID[7] := Database::"Deal Type";
                      No[7] := PurchaseHeader."Deal Type Code";
                  end;
          end;
      end;*/



    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Location Code', false, false)]
    local procedure OnAfterValidateEventLocationCode(var Rec: Record "Purchase Header")
    begin
        /* L'axe sur le magasin est devenu un standard 
               Rec.CreateDim(
                          Database::Location, Rec."Location Code",
                          Database::Vendor, Rec."Pay-to Vendor No.",
                          Database::"Salesperson/Purchaser", Rec."Purchaser Code",
                          Database::Campaign, Rec."Campaign No.");*/
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterValidateEvent', 'Vendor Order No.', false, false)]
    local procedure OnAfterValidateEventVendorOrderNo(var Rec: Record "Purchase Header")
    var
        PurchLine: Record "Purchase Line";
        tcDMS001: label 'Update lines too?';
    begin
        //EDMS1.0.00 >>
        PurchLine.Reset;
        PurchLine.SetRange("Document Type", Rec."Document Type");
        PurchLine.SetRange("Document No.", Rec."No.");
        if not PurchLine.IsEmpty then begin
            if not Confirm(tcDMS001) then
                exit;
            PurchLine.ModifyAll("Vendor Order No.", Rec."Vendor Order No.");
        end;
        //EDMS1.0.00 <<
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertEventPurchaseHeader(var Rec: Record "Purchase Header")
    var
        StandardCodesMgtGlobal: Codeunit "Standard Codes Mgt.";
    begin
        if Rec.GetCheckDefaultVendor() then
            Rec.GetDefaultVendor;
        if Rec."Buy-from Vendor No." <> '' then
            StandardCodesMgtGlobal.CheckCreatePurchRecurringLines(Rec);
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnRecreatePurchLinesOnAfterValidateType', '', false, false)]
    local procedure OnRecreatePurchLinesOnAfterValidateType(var PurchaseLine: Record "Purchase Line"; TempPurchaseLine: Record "Purchase Line" temporary)
    begin
        //EDMS1.0.00 >>
        PurchaseLine."Document Profile" := TempPurchaseLine."Document Profile";
        PurchaseLine.Validate(Type, TempPurchaseLine.Type);
        PurchaseLine."Line Type" := TempPurchaseLine."Line Type";
        //EDMS1.0.00 <<
    end;

    [EventSubscriber(ObjectType::Table, Database::"Purchase Header", 'OnRecreatePurchLinesOnBeforeTransferSavedFields', '', false, false)]
    local procedure OnRecreatePurchLinesOnBeforeTransferSavedFields(var PurchaseLine: Record "Purchase Line"; var Rec: Record "Purchase Header"; var TempPurchLine: Record "Purchase Line" temporary)
    begin
        //EDMS1.0.00 >>
        PurchaseLine.Validate("Make Code", TempPurchLine."Make Code");
        PurchaseLine.Validate("Model Code", TempPurchLine."Model Code");
        PurchaseLine.Validate("Model Version No.", TempPurchLine."Model Version No.");
        //EDMS1.0.00 <<

        PurchaseLine.Validate("No.", TempPurchLine."No.");

        //EDMS1.0.00 >>
        PurchaseLine.Validate("Vehicle Serial No.", TempPurchLine."Vehicle Serial No.");
        PurchaseLine.Validate("Vehicle Accounting Cycle No.", TempPurchLine."Vehicle Accounting Cycle No.");
        //EDMS1.0.00 <<

        PurchaseLine.Validate("No.", TempPurchLine."No.");
    end;

    [EventSubscriber(ObjectType::Table, Database::Opportunity, 'OnAfterValidateEvent', 'Wizard Estimated Value (LCY)', false, false)]
    local procedure OnAfterValidateEventWizardEstimatedValue(var Rec: Record Opportunity)
    var
        Currency: Record Currency;
    begin
        //20.03.2013 EDMS >>
        if Rec."Wizard Currency Code" <> '' then begin
            UpdateCurrencyFactor(Rec);
            Currency.Get(Rec."Wizard Currency Code");
            Rec."Wizard Estimated Value" := ROUND(Rec."Wizard Estimated Value (LCY)" * CurrencyFactor, Currency."Amount Rounding Precision")
        end else
            rec."Wizard Estimated Value" := rec."Wizard Estimated Value (LCY)";
        //20.03.2013 EDMS <<
    end;

    procedure UpdateCurrencyFactor(var Rec: Record Opportunity)
    var
        CurrExchRate: Record "Currency Exchange Rate";
        CurrencyDate: Date;
    begin
        if Rec."Wizard Currency Code" <> '' then begin
            CurrencyDate := WorkDate;
            CurrencyFactor := CurrExchRate.ExchangeRate(CurrencyDate, Rec."Wizard Currency Code");
        end else
            CurrencyFactor := 0;
    end;




    [EventSubscriber(ObjectType::Table, Database::Opportunity, 'OnCreateQuoteOnBeforeSalesHeaderInsert', '', false, false)]
    local procedure OnCreateQuoteOnBeforeSalesHeaderInsert(Opportunity: Record Opportunity; var SalesHeader: Record "Sales Header")
    var
        Selected: Integer;
    begin

        Selected := Opportunity.ChooseProfile;
        if (Selected) > 0 then begin
            case Selected of
                4: // Service EDMS
                    Opportunity.AssignServiceQuoteEDMS;
                5: // Rent
                    Opportunity.AssignRentQuote;
                else begin //Std.		
                    SalesHeader.SetRange("Sell-to Contact No.", Opportunity."Contact No.");
                    SalesHeader.Init();
                    //11.11.2015 EB.P7 #T066>>
                    SalesHeader."Document Profile" := Selected - 1;
                    //11.11.2015 EB.P7 #T066<<	        
                    SalesHeader."Document Type" := SalesHeader."Document Type"::Quote;
                end;
            END;
        end;
    end;

    [EventSubscriber(ObjectType::Table, Database::"Opportunity Entry", 'OnAfterInitOpportunityEntry', '', false, false)]
    local procedure OnAfterInitOpportunityEntryInit(Opportunity: Record Opportunity; var OpportunityEntry: Record "Opportunity Entry")

    begin
        if Opportunity."Wizard Currency Code" <> '' then begin
            OpportunityEntry.Validate("Currency Code", Opportunity."Wizard Currency Code");
            OpportunityEntry.Validate("Estimated Value", Opportunity."Wizard Estimated Value");
        end;
    END;

    [EventSubscriber(ObjectType::Table, Database::"Opportunity Entry", 'OnAfterValidateEvent', 'Date of Change', false, false)]
    local procedure OnAfterValidateEventDateOfChange(var Rec: Record "Opportunity Entry")

    begin
        //EDMS1.0.00 >>
        Rec.UpdateCurrencyFactor;
        Rec.Validate("Estimated Value (LCY)");
        //EDMS1.0.00 <<
    END;

    [EventSubscriber(ObjectType::Table, Database::"Opportunity Entry", 'OnAfterValidateEvent', 'Estimated Value (LCY)', false, false)]
    local procedure OnAfterValidateEventEstimatedValueLCY(var Rec: Record "Opportunity Entry")
    var
        Currency: Record Currency;
    begin
        //EDMS1.0.00 >>
        if Rec."Currency Code" <> '' then begin
            Currency.Get(Rec."Currency Code");
            Rec."Estimated Value" := ROUND(Rec."Estimated Value (LCY)" * Rec."Currency Factor", Currency."Amount Rounding Precision")
        end else
            Rec."Estimated Value" := Rec."Estimated Value (LCY)";
        //EDMS1.0.00 <<
    END;

    [EventSubscriber(ObjectType::Table, Database::"Opportunity Entry", 'OnAfterValidateEvent', 'Calcd. Current Value (LCY)', false, false)]
    local procedure OnAfterValidateEventCalcdCurrentValueLCY(var Rec: Record "Opportunity Entry")
    var
        Currency: Record Currency;
    begin
        //20.03.2013 EDMS >>
        if Rec."Currency Code" <> '' then begin
            Currency.Get(Rec."Currency Code");
            Rec."Calcd. Current Value" := ROUND(Rec."Calcd. Current Value (LCY)" / Rec."Currency Factor", Currency."Amount Rounding Precision")
        end else
            Rec."Calcd. Current Value" := Rec."Calcd. Current Value (LCY)";
        //20.03.2013 EDMS <<
    END;

    local procedure GetUserSetupPurchaserCode(): Code[20]
    var
        UserSetup: Record "User Setup";
    begin
        if not UserSetup.Get(UserId) then
            exit;

        exit(UserSetup."Salespers./Purch. Code");
    end;

    var
        CurrencyFactor: Decimal;

    // -------------------------------------------- Codeunit 22

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnRunWithCheckOnAfterRetrieveItemTracking', '', false, false)]
    local procedure OnRunWithCheckOnAfterRetrieveItemTrackingChekVehicle(var ItemJournalLine: Record "Item Journal Line"; var TempTrackingSpecification: Record "Tracking Specification"; var TrackingSpecExists: Boolean)
    begin
        //26.06.2008. EDMS P2 >>
        CheckModelVersion(ItemJournalLine);
        //26.06.2008. EDMS P2 <<

        //EDMS1.0.00 P1>>
        fUpdateVehicelSerialNo(ItemJournalLine);
        //EDMS1.0.00 P1<<
    end;

    procedure CheckModelVersion(ItemJnlLineLoc: Record "Item Journal Line")
    var
        ItemLoc: Record Item;
        Item: Record Item;
    begin
        //EDMS Upgrade 2017 >>
        if ItemJnlLineLoc."Model Version No." = '' then
            exit;
        ItemLoc.Get(ItemJnlLineLoc."Model Version No.");
        ItemLoc.TestField("Costing Method", Item."costing method"::Specific);
        ItemLoc.TestField("Item Tracking Code");
        //EDMS Upgrade 2017 <<
    end;

    procedure fUpdateVehicelSerialNo(var ItemJnlLine8: Record "Item Journal Line")
    var
        recSalesLine: Record "Sales Line";
        cuVehSN: Codeunit "Vehicle Serial No. Mgt.";
    begin

        Clear(cuVehSN);
        if ItemJnlLine8."Model Version No." = '' then
            exit;
        if ItemJnlLine8."Model Version No." <> ItemJnlLine8."Item No." then
            exit;
        if ItemJnlLine8."Entry Type" <> ItemJnlLine8."entry type"::"Positive Adjmt." then
            exit;

        ItemJnlLine8.TestField("Vehicle Serial No.");
        cuVehSN.fDeleteItemJnlLineTracking(ItemJnlLine8);
        cuVehSN.fCreateItemJnlLineTracking(ItemJnlLine8);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnCodeOnBeforeCheckItemTracking', '', false, false)]
    local procedure OnCodeOnBeforeCheckItemTracking(var ItemJnlLine: Record "Item Journal Line"; DisableItemTracking: Boolean; var IsHandled: Boolean; var TempTrackingSpecification: Record "Tracking Specification");
    var
        LocItemLedgEntry: Record "Item Ledger Entry";
        LocValueEntry: Record "Value Entry";
        PostInvCost: Report "Post Inventory Cost to G/L";
        PostMethod: Option "per Posting Group","per Entry";
        InvtSetup: Record "Inventory Setup";
        InvtPost: Codeunit "Inventory Posting To G/L";
    begin
        //EDMS1.0.00 P3>>
        if (ItemJnlLine."Item Charge No." <> '') and (ItemJnlLine."Item Type" = ItemJnlLine."item type"::"Model Version")
          and (InvtSetup."Post Veh. Add. Charges on Sale") then
            if not IsVehicleSold(ItemJnlLine."Serial No.") then ItemJnlLine."Not To Post" := true;

        if (ItemJnlLine."Entry Type" = ItemJnlLine."entry type"::Sale) and
          (ItemJnlLine."Document Profile" = ItemJnlLine."document profile"::"Vehicles Trade") then begin
            LocItemLedgEntry.Reset;
            LocItemLedgEntry.SetCurrentkey("Serial No.", "Vehicle Accounting Cycle No.", "Item Type");
            LocItemLedgEntry.SetRange("Serial No.", ItemJnlLine."Serial No.");
            LocItemLedgEntry.SetRange("Vehicle Accounting Cycle No.", ItemJnlLine."Vehicle Accounting Cycle No.");
            LocItemLedgEntry.SetRange("Item Type", ItemJnlLine."item type"::"Model Version");
            if LocItemLedgEntry.FindFirst then begin
                LocValueEntry.Reset;
                LocValueEntry.SetCurrentkey("Not To Post", "Item Ledger Entry No.");
                LocValueEntry.SetRange("Not To Post", true);
                repeat
                    LocValueEntry.SetRange("Item Ledger Entry No.", LocItemLedgEntry."Entry No.");
                    if LocValueEntry.FindFirst then
                        repeat
                            LocValueEntry."Not To Post" := false;
                            LocValueEntry.Modify;
                            InvtPost.BufferInvtPosting(LocValueEntry);
                            InvtPost.PostInvtPostBufPerEntry(LocValueEntry);
                        until LocValueEntry.Next = 0;
                until LocItemLedgEntry.Next = 0;
            end
        end;
        //EDMS1.0.00 P3>>
    end;

    procedure IsVehicleSold(SerialNo: Code[20]): Boolean
    var
        ItemLedgEntry: Record "Item Ledger Entry";
    begin
        ItemLedgEntry.Reset;
        //14.11.2007. EDMS P2>>
        ItemLedgEntry.SetCurrentkey("Serial No.", "Vehicle Accounting Cycle No.", "Item Type");
        //14.11.2007. EDMS P2<<
        ItemLedgEntry.SetRange("Serial No.", SerialNo);
        ItemLedgEntry.SetRange("Item Type", ItemLedgEntry."item type"::"Model Version");
        ItemLedgEntry.SetRange(Open, true);
        exit(not ItemLedgEntry.FindFirst)
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnInsertCapValueEntryOnBeforeInventoryPostingToGL', '', false, false)]
    local procedure OnInsertCapValueEntryOnBeforeInventoryPostingToGL(ValueEntry: Record "Value Entry"; var IsHandled: Boolean; PostToGL: Boolean);
    begin
        IsHandled := true;
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertCapValueEntry', '', false, false)]
    local procedure OnBeforeInsertCapValueEntry(var ValueEntry: Record "Value Entry"; ItemJnlLine: Record "Item Journal Line");
    var
        InventoryPostingToGL: Codeunit "Inventory Posting To G/L";
        InvtSetup: Record "Inventory Setup";
    begin
        InvtSetup.Get();

        InventoryPostingToGL.SetRunOnlyCheck(true, not InvtSetup."Automatic Cost Posting", false);
        PostInvtBuffer(ValueEntry);

        //EDMS1.0.00 >>
        ValueEntry."Item Type" := ItemJnlLine."Item Type";
        ValueEntry."Not To Post" := ItemJnlLine."Not To Post";  //26-04-2007 JF EB LV Copy to ValueEntry
                                                                //EDMS1.0.00 <<
                                                                //18.01.2008. EDMS P2 >>
        ValueEntry."Item Category Code" := ItemJnlLine."Item Category Code";
        //ValueEntry."Product Group Code" := "Product Group Code"; //06.06.2019 EB.P7 BC Upgr.
        //18.01.2008. EDMS P2 <<
    end;

    local procedure PostInvtBuffer(var ValueEntry: Record "Value Entry")
    var
        InventoryPostingToGL: Codeunit "Inventory Posting To G/L";
    begin
        if InventoryPostingToGL.BufferInvtPosting(ValueEntry) then
            InventoryPostingToGL.PostInvtPostBufPerEntry(ValueEntry);
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnItemQtyPostingOnBeforeApplyItemLedgEntry', '', false, false)]
    local procedure OnItemQtyPostingOnBeforeApplyItemLedgEntry(var ItemJournalLine: Record "Item Journal Line"; var ItemLedgerEntry: Record "Item Ledger Entry");
    var
        VehReserveItemJnlLine: Codeunit "Item Jnl. Line-Veh. Reserve";
    begin
        if ItemLedgerEntry.Quantity > 0 then
            if ItemLedgerEntry."Entry Type" <> ItemLedgerEntry."entry type"::Transfer then
                if ItemLedgerEntry."Item Type" = ItemLedgerEntry."item type"::"Model Version" then //26.02.2008 EDMS P1
                    VehReserveItemJnlLine.TransferItemJnlToItemLedgEntry(
                     ItemJournalLine, ItemLedgerEntry, true); //26.02.2008 EDMS P1
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitItemLedgEntry', '', false, false)]
    local procedure OnAfterInitItemLedgEntry(var NewItemLedgEntry: Record "Item Ledger Entry"; var ItemJournalLine: Record "Item Journal Line"; var ItemLedgEntryNo: Integer);
    begin
        //EDMS1.0.00 >>
        NewItemLedgEntry."Document Profile" := ItemJournalLine."Document Profile";
        NewItemLedgEntry."Item Type" := ItemJournalLine."Item Type";
        NewItemLedgEntry."Make Code" := ItemJournalLine."Make Code";
        NewItemLedgEntry."Model Code" := ItemJournalLine."Model Code";
        NewItemLedgEntry."Model Version No." := ItemJournalLine."Model Version No.";
        NewItemLedgEntry.VIN := ItemJournalLine.VIN;
        NewItemLedgEntry."Vehicle Accounting Cycle No." := ItemJournalLine."Vehicle Accounting Cycle No.";
        NewItemLedgEntry."Campaign No." := ItemJournalLine."Campaign No.";
        NewItemLedgEntry."Deal Type Code" := ItemJournalLine."Deal Type Code";
        NewItemLedgEntry."External Document No. 2" := ItemJournalLine."External Document No. 2";
        //EDMS1.0.00 <<
        //03.03.2010 EDMS P2 >>
        NewItemLedgEntry."Transfer Source Type" := ItemJournalLine."Transfer Source Type";
        NewItemLedgEntry."Transfer Source Subtype" := ItemJournalLine."Transfer Source Subtype";
        NewItemLedgEntry."Transfer Source No." := ItemJournalLine."Transfer Source No.";
        //03.03.2010 EDMS P2 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertPhysInvtLedgEntry', '', false, false)]
    local procedure OnBeforeInsertPhysInvtLedgEntry(var PhysInventoryLedgerEntry: Record "Phys. Inventory Ledger Entry"; ItemJournalLine: Record "Item Journal Line"; LastSplitItemJournalLine: Record "Item Journal Line");
    begin
        //23.12.2008. EDMS P2 >>
        PhysInventoryLedgerEntry."Document Profile" := ItemJournalLine."Document Profile";
        PhysInventoryLedgerEntry."Item Type" := ItemJournalLine."Item Type";
        PhysInventoryLedgerEntry."Make Code" := ItemJournalLine."Make Code";
        PhysInventoryLedgerEntry."Model Code" := ItemJournalLine."Model Code";
        PhysInventoryLedgerEntry."Model Version No." := ItemJournalLine."Model Version No.";
        ItemJournalLine.CalcFields(VIN);
        PhysInventoryLedgerEntry.VIN := ItemJournalLine.VIN;
        //23.12.2008. EDMS P2 <<
    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnInitValueEntryOnAfterAssignFields', '', false, false)]
    local procedure OnInitValueEntryOnAfterAssignFields(var ValueEntry: Record "Value Entry"; ItemLedgEntry: Record "Item Ledger Entry"; ItemJnlLine: Record "Item Journal Line");
    begin

        //EDMS1.0.00 >>
        ValueEntry."Item Category Code" := ItemJnlLine."Item Category Code";
        //ValueEntry."Product Group Code" := "Product Group Code"; //30.05.2019 EB.P7 BC upgr. bug email
        ValueEntry."Not To Post" := ItemJnlLine."Not To Post";
        //EDMS1.0.00 <<

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnInitValueEntryOnAfterSetValueEntryInventoriable', '', false, false)]
    local procedure OnInitValueEntryOnAfterSetValueEntryInventoriable(var ValueEntry: Record "Value Entry"; var ItemJournalLine: Record "Item Journal Line");
    var
        ItemLedgEntry: record "Item Ledger Entry";
        Item: record Item;
    begin
        if ItemLedgEntry.Get(ValueEntry."Item Ledger Entry No.") then begin
            ValueEntry.Inventoriable := false;
            if (ItemLedgEntry.Quantity > 0) or
             (ItemLedgEntry."Invoiced Quantity" > 0) or
             ((ItemJournalLine."Value Entry Type" = ItemJournalLine."Value Entry Type"::"Direct Cost") and (ItemJournalLine."Item Charge No." = '')) or
             (ItemJournalLine."Entry Type" in [ItemJournalLine."Entry Type"::Output, ItemJournalLine."Entry Type"::"Assembly Output"]) or

           //EDMS1.0.00 P3>>
           //Adjustment
           (ItemJournalLine.Adjustment and (ItemJournalLine."Vehicle Serial No." = ''))
          //EDMS1.0.00 P3<<
          then
                ValueEntry.Inventoriable := Item.Type = Item.Type::Inventory;
        end;
    end;

    var
        DirCostValueEntry: Record "Value Entry";
    //RC
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnAfterInitValueEntry', '', false, false)]
    local procedure OnAfterInitValueEntry(var ValueEntry: Record "Value Entry"; ItemJournalLine: Record "Item Journal Line"; var ValueEntryNo: Integer; ItemLedgEntry: Record "Item Ledger Entry")
    begin
        //EDMS1.0.00 >>
        ValueEntry."Item Category Code" := ItemJournalLine."Item Category Code";
        //ValueEntry."Product Group Code" := "Product Group Code"; //30.05.2019 EB.P7 BC upgr. bug email
        ValueEntry."Not To Post" := ItemJournalLine."Not To Post";
        //EDMS1.0.00 <<

        if (ItemJournalLine."Value Entry Type" = ItemJournalLine."value entry type"::"Direct Cost") and
               ((ItemJournalLine."Item Charge No." = '') or (ItemJournalLine."Item Type" = ItemJournalLine."item type"::"Model Version")) then
            //EDMS1.0.00 <<

            ValueEntry."Inventory Posting Group" := ItemJournalLine."Inventory Posting Group"

    end;

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnInitTransValueEntryOnAfterInitValueEntry', '', false, false)]
    local procedure OnInitTransValueEntryOnAfterInitValueEntry(var ValueEntry: Record "Value Entry"; ItemLedgerEntry: Record "Item Ledger Entry")
    begin
        ValueEntry."Item Category Code" := ItemLedgerEntry."Item Category Code";
    end;


    //<<
    /* [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnInitValueEntryOnBeforeRoundAmtValueEntry', '', false, false)]
    local procedure OnInitValueEntryOnBeforeRoundAmtValueEntry(var ValueEntry: Record "Value Entry"; ItemJnlLine: Record "Item Journal Line");
    begin
        GetLastDirectCostValEntry(ValueEntry."Item Ledger Entry No.");
        //EDMS1.0.00 >>
        //IF ("Value Entry Type" = "Value Entry Type"::"Direct Cost") AND ("Item Charge No." = '') THEN
        if (ItemJnlLine."Value Entry Type" = ItemJnlLine."value entry type"::"Direct Cost") and
           ((ItemJnlLine."Item Charge No." = '') or (ItemJnlLine."Item Type" = ItemJnlLine."item type"::"Model Version")) then
            //EDMS1.0.00 <<

            ValueEntry."Inventory Posting Group" := ItemJnlLine."Inventory Posting Group"
        else
            ValueEntry."Inventory Posting Group" := DirCostValueEntry."Inventory Posting Group";

    end;

    
        local procedure GetLastDirectCostValEntry(ItemLedgEntryNo: Decimal)
        var
            Found: Boolean;
        begin
            if ItemLedgEntryNo = DirCostValueEntry."Item Ledger Entry No." then
                exit;
            DirCostValueEntry.Reset();
            DirCostValueEntry.SetCurrentKey("Item Ledger Entry No.", "Entry Type");
            DirCostValueEntry.SetRange("Item Ledger Entry No.", ItemLedgEntryNo);
            DirCostValueEntry.SetRange("Entry Type", DirCostValueEntry."Entry Type"::"Direct Cost");
            DirCostValueEntry.SetFilter("Item Charge No.", '%1', '');
            Found := DirCostValueEntry.FindLast;
            DirCostValueEntry.SetRange("Item Charge No.");
            if not Found then
                DirCostValueEntry.FindLast;
        end;
        */

    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Item Jnl.-Post Line", 'OnBeforeInsertValueEntry', '', false, false)]
    local procedure OnBeforeInsertValueEntry(var ValueEntry: Record "Value Entry"; ItemJournalLine: Record "Item Journal Line"; var ItemLedgerEntry: Record "Item Ledger Entry"; var ValueEntryNo: Integer; var InventoryPostingToGL: Codeunit "Inventory Posting To G/L"; CalledFromAdjustment: Boolean; var OldItemLedgEntry: Record "Item Ledger Entry"; var Item: Record Item; TransferItem: Boolean; var GlobalValueEntry: Record "Value Entry");
    begin
        //EDMS1.0.00 >>
        ValueEntry."Item Type" := ItemLedgerEntry."Item Type";
        //EDMS1.0.00 <<

        //18.01.2008. EDMS P2 >>
        ValueEntry."Item Category Code" := ItemJournalLine."Item Category Code";
        //ValueEntry."Product Group Code" := "Product Group Code"; //06.06.2019 EB.P7 BC Upgr.
        //18.01.2008. EDMS P2 <<
    end;

    //------------------------------- codeunit 408 DimensionManagement

    [EventSubscriber(ObjectType::Codeunit, Codeunit::DimensionManagement, 'OnAfterSetupObjectNoList', '', false, false)]
    local procedure OnAfterSetupObjectNoList(var TempAllObjWithCaption: Record AllObjWithCaption temporary);
    var
        DimensionManagement: Codeunit DimensionManagement;
    begin
        //19.10.2015 #2016 merge >>
        DimensionManagement.InsertObject(TempAllObjWithCaption, Database::Make);
        DimensionManagement.InsertObject(TempAllObjWithCaption, Database::"Vehicle Status");
        DimensionManagement.InsertObject(TempAllObjWithCaption, Database::"Deal Type");
        DimensionManagement.InsertObject(TempAllObjWithCaption, Database::"External Service");
        DimensionManagement.InsertObject(TempAllObjWithCaption, Database::"Nonstock Item");
        DimensionManagement.InsertObject(TempAllObjWithCaption, Database::"Service Labor");
        DimensionManagement.InsertObject(TempAllObjWithCaption, Database::Vehicle);  //25.10.2013 EDMS P8
        DimensionManagement.InsertObject(TempAllObjWithCaption, Database::"Payment Method");  // 26.03.2014 Elva Baltic P18 #RX027
        DimensionManagement.InsertObject(TempAllObjWithCaption, Database::"Item Category");  // 31.03.2014 Elva Baltic P18 MMG7.00
        DimensionManagement.InsertObject(TempAllObjWithCaption, Database::Location);         // 21.05.2014 Elva Baltic P21 #F012 MMG7.00
        //19.10.2015 #2016 merge <<
    end;

    //------------------------------- codeunit 442 "Sales-Post Prepayments"
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales-Post Prepayments", 'OnRoundAmountsOnBeforeIncrAmounts', '', false, false)]
    local procedure OnRoundAmountsOnBeforeIncrAmounts(SalesHeader: Record "Sales Header"; var PrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer"; var TotalPrepmtInvLineBuf: Record "Prepayment Inv. Line Buffer"; var TotalPrepmtInvLineBufLCY: Record "Prepayment Inv. Line Buffer");
    var
        GenLedgSetup: Record "General Ledger Setup";
        Difference: Decimal;
        Text103: label 'Too large difference in currency calculations';
    begin
        GenLedgSetup.Get; //EDMS
        if SalesHeader."Currency Code" <> '' then begin
            //01.10.2009. EDMS P2 >>
            Difference := PrepmtInvLineBuf."Amount Incl. VAT" - PrepmtInvLineBuf.Amount - PrepmtInvLineBuf."VAT Amount";
            case true of
                Abs(Difference) > GenLedgSetup."Inv. Rounding Precision (LCY)":
                    Error(Text103);
                (Abs(Difference) > 0) and (Abs(Difference) <= GenLedgSetup."Inv. Rounding Precision (LCY)"):
                    PrepmtInvLineBuf."VAT Amount" := PrepmtInvLineBuf."Amount Incl. VAT" - PrepmtInvLineBuf.Amount
            end
            //01.10.2009. EDMS P2 <<
        end;

    end;


}

