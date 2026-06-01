Codeunit 25006794 "Vehicle Sales Doc. Mgt. EDMS"
{
    // #Owner EDMS.Integration
    //HELA


    trigger OnRun()
    begin
    end;

    //>>ADDED For table 37
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnValidateTypeOnCopyFromTempSalesLine', '', false, false)]
    local procedure OnValidateTypeOnCopyFromTempSalesLine(var SalesLine: Record "Sales Line"; var TempSalesLine: Record "Sales Line" temporary);
    begin
        SalesLine."Document Profile" := TempSalesLine."Document Profile";
        SalesLine."Line Type" := TempSalesLine."Line Type";
    end;

    //>>ADDED For table 37
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnValidateNoOnAfterVerifyChange', '', false, false)]
    local procedure OnValidateNoOnAfterVerifyChange(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line")
    var
        VehReserveSalesLine: Codeunit "Sales Line-Veh. Reserve";
    begin
        if SalesLine."Line Type" = SalesLine."line type"::Vehicle then //24.02.2008 EDMS P1
            VehReserveSalesLine.VerifyChange(SalesLine, xSalesLine); //24.02.2008 EDMS P1
    end;

    //>>ADDED For table 37
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnValidateNoOnCopyFromTempSalesLine', '', false, false)]
    local procedure OnValidateNoOnCopyFromTempSalesLine(var SalesLine: Record "Sales Line"; var TempSalesLine: Record "Sales Line" temporary; xSalesLine: Record "Sales Line")
    var
        UserProfileMgt: Codeunit UserProfileManagement;
        UserProfile: Record "Branch Profile Setup";
    begin
        //EDMS >>
        SalesLine."Vehicle Assembly ID" := TempSalesLine."Vehicle Assembly ID";
        SalesLine."Document Profile" := TempSalesLine."Document Profile";
        SalesLine."Vehicle Status Code" := TempSalesLine."Vehicle Status Code";
        //16.03.2016 EB.P7 #Branch Profile >>
        if SalesLine."Vehicle Status Code" = '' then
            if UserProfileMgt.CurrProfileID <> '' then
                if UserProfile.Get(UserProfileMgt.CurrProfileID, UserProfileMgt.CurrBranchNo) then
                    if UserProfile."Default Vehicle Status" <> '' then
                        SalesLine.Validate("Vehicle Status Code", UserProfile."Default Vehicle Status");
        //16.03.2016 EB.P7 #Branch Profile <<
        SalesLine."Make Code" := TempSalesLine."Make Code";
        SalesLine."Model Code" := TempSalesLine."Model Code";
        SalesLine."Model Version No." := TempSalesLine."Model Version No.";
        SalesLine."Line Type" := TempSalesLine."Line Type";
        SalesLine."Service Order Line No. EDMS" := TempSalesLine."Service Order Line No. EDMS";
        SalesLine."Order Line Type No." := TempSalesLine."Order Line Type No.";
        SalesLine."Deal Type Code" := TempSalesLine."Deal Type Code";
        SalesLine."Real Time" := TempSalesLine."Real Time";
        SalesLine."Vehicle Serial No." := TempSalesLine."Vehicle Serial No.";
        SalesLine."Vehicle Accounting Cycle No." := TempSalesLine."Vehicle Accounting Cycle No.";
        SalesLine.Group := TempSalesLine.Group;
        SalesLine."Group ID" := TempSalesLine."Group ID";
        SalesLine."Package No." := TempSalesLine."Package No.";
        SalesLine."Package Version No." := TempSalesLine."Package Version No.";
        SalesLine."Package Version Spec. Line No." := TempSalesLine."Package Version Spec. Line No.";
        SalesLine."External Serv. Tracking No." := TempSalesLine."External Serv. Tracking No.";
        //EDMS <<
        SalesLine."Contract No." := TempSalesLine."Contract No.";
        //EDMS >>
        if (SalesLine."No." = '') and (SalesLine."Line Type" = SalesLine."line type"::Vehicle) then
            SalesLine.Quantity := 1;
        //EDMS <<
    end;


    //>>ADDED For table 37
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterAssignGLAccountValues', '', false, false)]
    local procedure OnAfterAssignGLAccountValues(var SalesLine: Record "Sales Line"; GLAccount: Record "G/L Account")
    var
        recDMSLabor: Record "Service Labor";
        recDMSExternal: Record "External Service";
    begin
        case SalesLine."Line Type" of
            SalesLine."line type"::Labor:
                begin
                    recDMSLabor.Get(SalesLine."Order Line Type No.");
                    SalesLine."Gen. Prod. Posting Group" := recDMSLabor."Gen. Prod. Posting Group";
                    SalesLine."VAT Prod. Posting Group" := recDMSLabor."VAT Prod. Posting Group";
                end;
            SalesLine."line type"::"Ext. Service":
                begin
                    recDMSExternal.Get(SalesLine."Order Line Type No.");
                    SalesLine."Gen. Prod. Posting Group" := recDMSExternal."Gen. Prod. Posting Group";
                    SalesLine."VAT Prod. Posting Group" := recDMSExternal."VAT Prod. Posting Group";
                end;
            else begin
                SalesLine."Gen. Prod. Posting Group" := GLAccount."Gen. Prod. Posting Group";
                SalesLine."VAT Prod. Posting Group" := GLAccount."VAT Prod. Posting Group";
            end;
        end;
    end;

    //>>ADDED For table 37
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterAssignItemValues', '', false, false)]
    local procedure OnAfterAssignItemValues(var SalesLine: Record "Sales Line"; Item: Record Item)
    var
        SalesSetup: Record "Sales & Receivables Setup";
        ItemSubstitutionSync: Codeunit "Item Substitution Sync";
        // ItemSubstitutionMgt: Codeunit "Item Subst.";
        litem: Record item;
        lsalesheader: Record "Sales Header";
        IsHandled: Boolean;
    begin
        SalesLine.GetItem(litem);
        lsalesheader.get(SalesLine."Document type", SalesLine."Document No.");
        if SalesLine."Line Type" = SalesLine."line type"::Vehicle then
            SalesLine.Reserve := SalesLine.Reserve::Optional;
        SalesSetup.Get;
        SalesLine."Ordering Price Type Code" := lsalesheader."Ordering Price Type Code";

        if SalesSetup."Item No. Replacement Warnings" then
            if litem."Item Type" = litem."item type"::Item then begin
                // ItemSubstitutionMgt.CheckReplacements(SalesLine."No.");
                OnBeforeCheckReplacement(SalesLine, IsHandled);
                if not IsHandled then
                    ItemSubstitutionSync.CheckReplacements(SalesLine."No.");
            end;
    end;

    //>>ADDED For table 37
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterAssignFieldsForNo', '', false, false)]
    local procedure OnAfterAssignFieldsForNo(var SalesLine: Record "Sales Line"; var xSalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header")
    var
        ExternalService: Record "External Service";
    begin
        //14.12.2007 EDMS P5 >>
        if SalesLine.Type = SalesLine.Type::"External Service" then begin
            ExternalService.Get(SalesLine."No.");
            SalesLine.Description := ExternalService.Description;
            SalesLine."Gen. Prod. Posting Group" := ExternalService."Gen. Prod. Posting Group";
            SalesLine."VAT Prod. Posting Group" := ExternalService."VAT Prod. Posting Group";
            SalesLine."Unit of Measure Code" := ExternalService."Unit of Measure Code";
        end;
        //14.12.2007 EDMS P5 <<
    end;
    //>>ADDED For table 37
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeVerifyChangeForSalesLineReserve', '', false, false)]
    local procedure OnBeforeVerifyChangeForSalesLineReserve(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line"; CallingFieldNo: Integer; var IsHandled: Boolean)
    var
        VehReserveSalesLine: Codeunit "Sales Line-Veh. Reserve";
    begin
        if CallingFieldNo in [SalesLine.FieldNo("No."), SalesLine.FieldNo("Purchase Order No."),
                SalesLine.FieldNo("Purch. Order Line No.")] then begin
            if SalesLine."Line Type" = SalesLine."line type"::Vehicle then //24.02.2008 EDMS P1
                VehReserveSalesLine.VerifyChange(SalesLine, xSalesLine); //24.02.2008 EDMS P1
        end;
        if CallingFieldNo = 0 then begin
            if ((SalesLine.Quantity <> 0) or (xSalesLine.Quantity <> 0)) and SalesLine.ItemExists(xsalesline."No.") then
                if SalesLine."Line Type" = SalesLine."line type"::Vehicle then //24.02.2008 EDMS P1
                    VehReserveSalesLine.VerifyChange(SalesLine, xSalesLine); //24.02.2008 EDMS P1
        end;
    end;

    //>>ADDED For table 37
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnValidateNoOnAfterUpdateUnitPrice', '', false, false)]
    local procedure OnValidateNoOnAfterUpdateUnitPrice(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line")
    var
        litem: Record item;
    begin
        //EDMS >>

        if SalesLine."Line Type" = SalesLine."line type"::Vehicle then begin
            SalesLine.GetItem(litem);
            if SalesLine."Vehicle Serial No." = '' then
                SalesLine.NewSerialNo;
            if SalesLine."No." <> SalesLine."Model Version No." then begin
                SalesLine."Model Version No." := SalesLine."No.";
                SalesLine."Make Code" := litem."Make Code";
                SalesLine."Model Code" := litem."Model Code"
            end
        end;
        //EDMS <<
    end;
    //>>ADDED For table 37
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Location Code', true, true)]
    local procedure OnAfterValidateEventLocationCode(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        NewLocationCode: Code[20];
        DimMgt: Codeunit DimensionManagement;
        VehReserveSalesLine: Codeunit "Sales Line-Veh. Reserve";
        Dimsource: List of [Dictionary of [Integer, code[20]]];
    begin

        //10.05.2008. EDMS P2 >>
        NewLocationCode := Rec."Location Code";
        Rec."Location Code" := xRec."Location Code";
        Rec."Location Code" := NewLocationCode;
        //10.05.2008. EDMS P2 <<

        //15.02.2008. EDMS P2 >>
        if (Rec."Document Profile" = Rec."document profile"::"Vehicles Trade") and (Rec."Line Type" = Rec."line type"::Vehicle) then
            Rec.DeleteVehItemTrackingLine(xRec."Location Code");
        //15.02.2008. EDMS P2 <<

        if (Rec."Location Code" <> xRec."Location Code") and (Rec.Quantity <> 0) then
            if Rec."Line Type" = Rec."line type"::Vehicle then //24.02.2008 EDMS P1
                VehReserveSalesLine.VerifyChange(Rec, xRec); //24.02.2008 EDMS P1

        // 10.03.2015 EDMS P21 >>
        /* Rec.CreateDim(
          DimMgt.TypeToTableID3(rec.Type.AsInteger()), rec."No.",
          Database::"Responsibility Center", rec."Responsibility Center",
          Database::Location, rec."Location Code");*/
        Clear(Dimsource);
        DimMgt.AddDimSource(Dimsource, DimMgt.SalesLineTypeToTableID(rec.Type), rec."No.");
        DimMgt.AddDimSource(Dimsource, Database::"Responsibility Center", rec."Responsibility Center");
        DimMgt.AddDimSource(Dimsource, DATABASE::"Location", rec."Location Code");
        DimMgt.AddDimSource(Dimsource, Database::"Vehicle Status", rec."Vehicle Status Code");
        DimMgt.AddDimSource(Dimsource, Database::"Deal Type", rec."Deal Type Code");
        DimMgt.AddDimSource(Dimsource, Database::Make, rec."Make Code");
        DimMgt.AddDimSource(Dimsource, Database::"Payment Method", rec."Payment Method Code");
        DimMgt.AddDimSource(Dimsource, Database::Vehicle, rec."Vehicle Serial No.");
        rec.CreateDim(Dimsource);

        /* Database::"Vehicle Status", rec."Vehicle Status Code",
         Database::"Deal Type", rec."Deal Type Code",
         Database::Make, rec."Make Code",
         Database::"Payment Method", rec."Payment Method Code",
         Database::Vehicle, rec."Vehicle Serial No."
         );*/
        // 10.03.2015 EDMS P21 <<

        if rec.Modify() then;
    end;

    //>>ADDED For table 37
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Drop Shipment', true, true)]
    local procedure OnAfterValidateEventDropShipment(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        VehReserveSalesLine: Codeunit "Sales Line-Veh. Reserve";
    begin
        if (xRec."Drop Shipment" <> Rec."Drop Shipment") and (Rec.Quantity <> 0) then begin
            if Rec."Line Type" = Rec."line type"::Vehicle then //24.02.2008 EDMS P1
                VehReserveSalesLine.VerifyChange(Rec, xRec); //24.02.2008 EDMS P1
        end;
    end;
    //>>ADDED For table 37
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Variant Code', true, true)]
    local procedure OnAfterValidateEventVariantCode(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
        VehReserveSalesLine: Codeunit "Sales Line-Veh. Reserve";
    begin
        if (xRec."Variant Code" <> Rec."Variant Code") and (Rec.Quantity <> 0) then begin
            if Rec."Line Type" = Rec."line type"::Vehicle then //24.02.2008 EDMS P1
                VehReserveSalesLine.VerifyChange(Rec, xRec); //24.02.2008 EDMS P1
        end;
    end;

    //>>ADDED For table 37
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'Unit of Measure Code', true, true)]
    local procedure OnAfterValidateEventUnitofMeasure(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    var
    begin
        if Rec.Type = Rec.Type::Item then //DMS
            Rec.CheckItemAvailable(Rec.FieldNo("Unit of Measure Code")); //DMS
    end;

    //>>ADDED For table 37
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterValidateEvent', 'VAT Prod. Posting Group', true, true)]
    local procedure OnAfterValidateEventVATProd(var Rec: Record "Sales Line"; var xRec: Record "Sales Line"; CurrFieldNo: Integer)
    begin
        Rec.Validate("Prepayment %");
        // Rec.Modify()
    end;
    //>>ADDED For table 37
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnValidateQuantityOnBeforeCheckAssocPurchOrder', '', false, false)]
    local procedure OnValidateQuantityOnBeforeCheckAssocPurchOrder(var SalesLine: Record "Sales Line")
    var
        IsHandled: Boolean;
    begin
        //>>DELTA 01 
        //ItemSubstSync.ReplaceSalesLineItemNo(Rec);
        //<<DELTA 01
        if SalesLine.CheckItemAvailabilityOnValidateSalesLineQty(false, false) then
            exit;

        //10.10.2018 EB.P7 DE012WAE3-15 >>
        //>>DELTA 01
        //if ServiceSetup."Item No. Replacement Warnings" and (Type = Type::Item) then
        //    ItemSubstitutionMgt.CheckDiscontinued("No.", Quantity);
        //10.10.2018 EB.P7 DE012WAE3-15 <<
        //<<DELTA 01 


        //09.05.2008. EDMS P2 >>
        if (SalesLine."Line Type" = SalesLine."line type"::Vehicle) and (SalesLine.Quantity > 1) then begin
            OnBeforeTestVehicleQuantity(SalesLine, IsHandled);
            if not IsHandled then
                SalesLine.TestField(Quantity, 1);
        end;

        //09.05.2008. EDMS P2 <<

    end;


    //>>ADDED For table 37
    /*  [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterCreateDimTableIDs', '', false, false)]
      local procedure OnAfterCreateDimTableIDs(var SalesLine: Record "Sales Line"; CallingFieldNo: Integer; var TableID: array[10] of Integer; var No: array[10] of Code[20])
      var
          DimMgt: Codeunit DimensionManagement;
      begin
          case CallingFieldNo of

              7:
                  begin
                      TableID[4] := Database::"Vehicle Status";
                      No[4] := SalesLine."Vehicle Status Code";
                      TableID[5] := Database::"Deal Type";
                      No[5] := SalesLine."Deal Type Code";
                      TableID[6] := Database::"Make";
                      No[6] := SalesLine."Make Code";
                      TableID[7] := Database::"Payment Method";
                      No[7] := SalesLine."Payment Method Code";
                      TableID[8] := Database::Vehicle;
                      No[8] := SalesLine."Vehicle Serial No.";
                  end;
              1002:
                  begin
                      TableID[2] := Database::"Responsibility Center";
                      No[2] := SalesLine."Responsibility Center";
                      TableID[3] := Database::"Vehicle Status";
                      No[3] := SalesLine."Vehicle Status Code";
                      TableID[4] := Database::"Deal Type";
                      No[4] := SalesLine."Deal Type Code";
                      TableID[5] := Database::"Make";
                      No[5] := SalesLine."Make Code";
                      TableID[6] := Database::"Payment Method";
                      No[6] := SalesLine."Payment Method Code";
                      TableID[7] := Database::Vehicle;
                      No[7] := SalesLine."Vehicle Serial No.";
                      TableID[8] := Database::Location;
                      No[8] := SalesLine."Location Code";
                  end;
              5700:
                  begin
                      TableID[2] := DimMgt.TypeToTableID3(SalesLine.Type.AsInteger());
                      No[2] := SalesLine."No.";
                      TableID[3] := Database::"Vehicle Status";
                      No[3] := SalesLine."Vehicle Status Code";
                      TableID[4] := Database::"Deal Type";
                      No[4] := SalesLine."Deal Type Code";
                      TableID[5] := Database::"Make";
                      No[5] := SalesLine."Make Code";
                      TableID[6] := Database::"Payment Method";
                      No[6] := SalesLine."Payment Method Code";
                      TableID[7] := Database::Vehicle;
                      No[7] := SalesLine."Vehicle Serial No.";
                      TableID[8] := Database::Location;
                      No[8] := SalesLine."Location Code";
                  end;
              55010:
                  begin
                      TableID[4] := Database::"Deal Type";
                      No[4] := SalesLine."Deal Type Code";
                      TableID[5] := Database::Make;
                      No[5] := SalesLine."Make Code";
                      TableID[6] := Database::"Payment Method";
                      No[6] := SalesLine."Payment Method Code";
                      TableID[7] := Database::Vehicle;
                      No[7] := SalesLine."Vehicle Serial No.";
                      TableID[8] := Database::Location;
                      No[8] := SalesLine."Location Code";
                  end;
              25006001:
                  begin
                      TableID[4] := Database::"Deal Type";
                      No[4] := SalesLine."Deal Type Code";

                      TableID[5] := Database::Make;
                      No[5] := SalesLine."Make Code";

                      TableID[6] := Database::"Payment Method";
                      No[6] := SalesLine."Payment Method Code";

                      TableID[7] := Database::Vehicle;
                      No[7] := SalesLine."Vehicle Serial No.";

                      TableID[8] := Database::Location;
                      No[8] := SalesLine."Location Code";
                  end;
              25006002:
                  begin
                      TableID[4] := Database::"Deal Type";
                      No[4] := SalesLine."Deal Type Code";

                      TableID[5] := Database::Make;
                      No[5] := SalesLine."Make Code";

                      TableID[6] := Database::"Payment Method";
                      No[6] := SalesLine."Payment Method Code";

                      TableID[7] := Database::Vehicle;
                      No[7] := SalesLine."Vehicle Serial No.";

                      TableID[8] := Database::Location;
                      No[8] := SalesLine."Location Code";

                  end;
              25006370:
                  begin
                      TableID[4] := Database::"Deal Type";
                      No[4] := SalesLine."Deal Type Code";

                      TableID[5] := Database::Make;
                      No[5] := SalesLine."Make Code";

                      TableID[6] := Database::"Payment Method";
                      No[6] := SalesLine."Payment Method Code";

                      TableID[7] := Database::Vehicle;
                      No[7] := SalesLine."Vehicle Serial No.";

                      TableID[8] := Database::Location;
                      No[8] := SalesLine."Location Code";
                  end;

              25006375:
                  begin
                      TableID[4] := Database::"Deal Type";
                      No[4] := SalesLine."Deal Type Code";

                      TableID[5] := Database::Make;
                      No[5] := SalesLine."Make Code";

                      TableID[6] := Database::"Payment Method";
                      No[6] := SalesLine."Payment Method Code";

                      TableID[7] := Database::Vehicle;
                      No[7] := SalesLine."Vehicle Serial No.";

                      TableID[8] := Database::Location;
                      No[8] := SalesLine."Location Code";
                  end;
              25006380:
                  begin
                      TableID[4] := Database::"Deal Type";
                      No[4] := SalesLine."Deal Type Code";

                      TableID[5] := Database::Make;
                      No[5] := SalesLine."Make Code";

                      TableID[6] := Database::"Payment Method";
                      No[6] := SalesLine."Payment Method Code";

                      TableID[7] := Database::Vehicle;
                      No[7] := SalesLine."Vehicle Serial No.";

                      TableID[8] := Database::Location;
                      No[8] := SalesLine."Location Code";
                  end;


          end;
      end;*/

    //>>ADDED For table 37
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeUpdateUnitPrice', '', false, false)]
    local procedure OnBeforeUpdateUnitPrice(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line"; CalledByFieldNo: Integer; CurrFieldNo: Integer; var Handled: Boolean)
    var
        PriceCalculation: Interface "Price Calculation";
        PriceType: Enum "Price Type";
        lsalesheader: Record "Sales Header";
    begin
        if lsalesheader.Get(SalesLine."Document Type", SalesLine."Document No.") then begin
            if SalesLine.type = SalesLine.Type::"External Service" then begin
                SalesLine.GetPriceCalculationHandler(PriceType::Sale, lsalesheader, PriceCalculation);
                if not (SalesLine."Copied From Posted Doc." and SalesLine.IsCreditDocType()) then begin
                    PriceCalculation.ApplyDiscount();
                    SalesLine.ApplyPrice(CalledByFieldNo, PriceCalculation);
                end;
                Handled := true;
            end;
            if SalesLine.type = SalesLine.Type::"Charge (Item)" then begin
                SalesLine.UpdateItemChargeAssgnt;
                Handled := true;
            end;

        end;
    end;

    //>>ADDED For table 37
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeUpdatePrepmtSetupFields', '', false, false)]
    local procedure OnBeforeUpdatePrepmtSetupFields(var SalesLine: Record "Sales Line"; var IsHandled: Boolean; CurrentFieldNo: Integer)
    var
        GenPostingSetup: Record "General Posting Setup";
        GLAcc: Record "G/L Account";
        GLSetup: Record "General Ledger Setup";
        VATPostingSetup: Record "VAT Posting Setup";
    begin
        if (SalesLine."Prepayment %" <> 0) and (SalesLine.Type <> SalesLine.Type::" ") then begin
            SalesLine.TestField("Document Type", SalesLine."Document Type"::Order);
            SalesLine.TestField("No.");
            GLSetup.Get; //EDMS
            if CurrentFieldNo = SalesLine.FieldNo("Prepayment %") then
                if SalesLine."System-Created Entry" and not SalesLine.IsServiceChargeLine() then
                    SalesLine.FieldError(SalesLine."Prepmt. Line Amount", StrSubstNo(Text045, 0));
            if SalesLine."System-Created Entry" and not SalesLine.IsServiceChargeLine() then
                SalesLine."Prepayment %" := 0;
            GenPostingSetup.Get(SalesLine."Gen. Bus. Posting Group", SalesLine."Gen. Prod. Posting Group");
            if GenPostingSetup."Sales Prepayments Account" <> '' then begin
                if GLSetup."Calc.Prepmt.VAT by Line PostGr" then //EDMS
                    VATPostingSetup.Get(SalesLine."VAT Bus. Posting Group", SalesLine."VAT Prod. Posting Group") //EDMS
                else begin
                    GLAcc.Get(GenPostingSetup."Sales Prepayments Account");
                    VATPostingSetup.Get(SalesLine."VAT Bus. Posting Group", GLAcc."VAT Prod. Posting Group");
                    VATPostingSetup.TestField("VAT Calculation Type", SalesLine."VAT Calculation Type");
                end;
            end else
                Clear(VATPostingSetup);
            if (SalesLine."Prepayment VAT %" <> 0) and (SalesLine."Prepayment VAT %" <> VATPostingSetup."VAT %") and (SalesLine."Prepmt. Amt. Inv." <> 0) then
                Error(CannotChangePrepmtAmtDiffVAtPctErr);
            SalesLine."Prepayment VAT %" := VATPostingSetup."VAT %";
            SalesLine."Prepmt. VAT Calc. Type" := VATPostingSetup."VAT Calculation Type";
            SalesLine."Prepayment VAT Identifier" := VATPostingSetup."VAT Identifier";
            if SalesLine."Prepmt. VAT Calc. Type" in
               [SalesLine."Prepmt. VAT Calc. Type"::"Reverse Charge VAT", SalesLine."Prepmt. VAT Calc. Type"::"Sales Tax"]
            then
                SalesLine."Prepayment VAT %" := 0;
            SalesLine."Prepayment Tax Group Code" := GLAcc."Tax Group Code";
        end;
        IsHandled := true;
    end;
    //>>ADDED For table 37
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeUpdateAmounts', '', false, false)]
    local procedure OnBeforeUpdateAmounts(var SalesLine: Record "Sales Line"; xSalesLine: Record "Sales Line"; CurrentFieldNo: Integer; var IsHandled: Boolean)
    var
        lsalesheader: Record "Sales Header";
    begin
        if SalesLine.Type = SalesLine.Type::" " then
            exit;

        if lsalesheader.Get(SalesLine."Document Type", SalesLine."Document No.") then begin

            //02.01.08 EDMS P1
            if SalesLine."Line Type" = SalesLine."line type"::Vehicle then
                SalesLine.CheckVehicleDiscount;

            //27.01.2010. EDMS P2 >>
            if (SalesLine."Document Profile" in [SalesLine."document profile"::"Spare Parts Trade", SalesLine."document profile"::Service]) and
               ((CurrentFieldNo = SalesLine.FieldNo("Line Discount %")) or (CurrentFieldNo = SalesLine.FieldNo("Line Discount Amount")))
            then
                if SalesLine.Type = SalesLine.Type::Item then
                    SalesLine.CheckDiscount;
            //27.01.2010. EDMS P2 >>
        end;
    end;
    //>>ADDED For table 37
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnAfterUpdateAmountsDone', '', false, false)]
    local procedure OnAfterUpdateAmountsDone(var SalesLine: Record "Sales Line"; var xSalesLine: Record "Sales Line"; CurrentFieldNo: Integer)
    var
    begin
        SalesLine.ApplyMarkupRestrictions(0);
    end;

    //>>ADDED For table 37
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnBeforeCheckItemAvailable', '', false, false)]
    local procedure OnBeforeCheckItemAvailable(var SalesLine: Record "Sales Line"; CalledByFieldNo: Integer; var IsHandled: Boolean; CurrentFieldNo: Integer; xSalesLine: Record "Sales Line")
    var
    begin
        if SalesLine."Line Type" = SalesLine."line type"::Vehicle Then
            IsHandled := true;

    end;

    //>>ADDED For table 37
    [EventSubscriber(ObjectType::Table, Database::"Sales Line", 'OnUpdateAmountOnBeforeCheckCreditLimit', '', false, false)]
    local procedure OnUpdateAmountOnBeforeCheckCreditLimit(var SalesLine: Record "Sales Line"; var IsHandled: Boolean; CurrentFieldNo: Integer)
    var
    begin
        if SalesLine."Line Type" = SalesLine."line type"::Vehicle Then
            IsHandled := true;
    end;

    //>>ADDED For table 37
    [EventSubscriber(ObjectType::Table, Database::"sales line", 'OnAfterGetUnitCost', '', false, false)]
    local procedure OnAfterGetUnitCost(var SalesLine: Record "Sales Line"; Item: Record Item)
    var
        Vehicle: Record Vehicle;
        ActualUnitCost: Decimal;
    begin
        if not SalesLine.GetSKU then begin
            //03.06.2013 Elva Baltic P15 >>
            ActualUnitCost := Item."Unit Cost";   //Unit Cost - by default
            Vehicle.Reset;
            if (SalesLine."Line Type" = SalesLine."line type"::Vehicle) and (SalesLine."Vehicle Serial No." <> '') then
                if Vehicle.Get(SalesLine."Vehicle Serial No.") then begin
                    Vehicle.CalcFields(Inventory);
                    if Vehicle.Inventory > 0 then
                        ActualUnitCost := SalesLine.GetVehUnitCost_ILE;        // if there are Open ILE record
                    SalesLine.VALIDATE("Unit Cost (LCY)", ActualUnitCost * SalesLine."Qty. per Unit of Measure");
                end;
            //03.06.2013 Elva Baltic P15 <<
        end;
    end;
    //>>ADDED For table 37
    [EventSubscriber(ObjectType::Table, Database::"sales line", 'OnBeforeCalcPrepmtToDeduct', '', false, false)]
    local procedure OnBeforeCalcPrepmtToDeduct(var SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
        //02.01.08 EDMS P1 >>
        if SalesLine."Line Type" = SalesLine."line type"::Vehicle then
            SalesLine.CheckVehicleDiscount;
        //02.01.08 EDMS P1 <<

        //27.01.2010. EDMS P2 >>
        /* To verify
        if (SalesLine."Document Profile" in [SalesLine."document profile"::"Spare Parts Trade", SalesLine."document profile"::Service])
        and ((SalesLine.CurrFieldNo = FieldNo("Line Discount %")) or (CurrFieldNo = FieldNo("Line Discount Amount")))
        then
            if Type in [Type::Item] then
                CheckDiscount;
                */
        //27.01.2010. EDMS P2 >>
    end;


    //>>ADDED For table 37
    [EventSubscriber(ObjectType::Table, Database::"sales line", 'OnAfterInitHeaderDefaults', '', false, false)]
    local procedure OnAfterInitHeaderDefaults(var SalesLine: Record "Sales Line"; SalesHeader: Record "Sales Header"; xSalesLine: Record "Sales Line")
    begin
        SalesLine."Contract No." := SalesHeader."Contract No.";                                     // 17.04.2014 Elva Baltic P21
        SalesLine."Document Profile" := SalesHeader."Document Profile";
        //EDMS >>
        if SalesLine."Document Profile" <> SalesLine."document profile"::"Vehicles Trade" then begin
            SalesLine.Validate("Vehicle Serial No.", SalesHeader."Vehicle Serial No.");
            SalesLine.Validate("Deal Type Code", SalesHeader."Deal Type Code");
        end;
        SalesLine.Validate("Payment Method Code", SalesHeader."Payment Method Code");
        //EDMS <<
    end;



    //>>ADDED For table 37
    [EventSubscriber(ObjectType::Codeunit, Codeunit::"Sales Warehouse Mgt.", 'OnAfterSalesLineDelete', '', false, false)]
    local procedure OnAfterSalesLineDelete(var SalesLine: Record "Sales Line")
    var
        VehReserveSalesLine: Codeunit "Sales Line-Veh. Reserve";
    begin
        if SalesLine."Line Type" = SalesLine."line type"::Vehicle then
            VehReserveSalesLine.DeleteLine(SalesLine);
    end;



    //>>ADDED For table 37
    [EventSubscriber(ObjectType::Table, Database::"sales line", 'OnAfterInsertEvent', '', false, false)]
    local procedure OnAfterInsertsalesline(var Rec: Record "sales line"; RunTrigger: Boolean)
    var
        DealApplEntry: Record "Deal Application Entry";
        DealApplType: Record "Deal Application Type";
    begin
        //EDMS P3>>
        DealApplType.SetRange("System Type", DealApplType."system type"::Leasing);
        if DealApplType.FindFirst then
            if DealApplEntry.Get(DealApplType."No.", 0, Rec."Document Type", Rec."Document No.", Rec."Line No.") then
                if Confirm(Text103, false) then
                    DealApplEntry.Delete
        //EDMS P3<<
    end;

    //>>ADDED For table 37
    [EventSubscriber(ObjectType::Table, Database::"sales line", 'OnbeforeInsertEvent', '', false, false)]
    local procedure OnbeforeInsertEvent(var Rec: Record "sales line"; RunTrigger: Boolean)
    var
        SalesHeader: record "sales header";
    begin

        if (rec.IsTemporary = FALSE) And (RunTrigger = true) then Begin
            //27.07.2007 EDMS P1 >>
            if SalesHeader.get(rec."Document Type", rec."Document No.") then
                if Rec."Document Profile" <> Rec."document profile"::"Vehicles Trade" then
                    Rec.Validate("Vehicle Serial No.", SalesHeader."Vehicle Serial No."); //23.01.2013 EDMS P8
                                                                                          //27.07.2007 EDMS P1 <<
        End;
    end;

    //>>ADDED For table 37
    [EventSubscriber(ObjectType::Table, Database::"sales line", 'OnaftermodifyEvent', '', false, false)]
    local procedure OnaftermodifyEvent(var Rec: Record "sales line"; RunTrigger: Boolean)
    var
        DealApplEntry: Record "Deal Application Entry";
        DealApplType: Record "Deal Application Type";
    begin

        //EDMS P3 >>
        DealApplType.SetRange("System Type", DealApplType."system type"::Leasing);
        if DealApplType.FindFirst then
            if DealApplEntry.Get(DealApplType."No.", 0, Rec."Document Type", Rec."Document No.", Rec."Line No.") then
                if Confirm(Text103, false) then
                    DealApplEntry.Delete
        //EDMS P3 <<

    end;

    //>>ADDED For table 246
    [EventSubscriber(ObjectType::Table, Database::"Requisition Line", 'OnAfterdeleteEvent', '', false, false)]
    local procedure OnAfterdeleteEvent(var Rec: Record "Requisition Line"; RunTrigger: Boolean)
    var
        VehReserveReqLine: Codeunit "Req. Line-Veh. Reserve";
    begin
        if RunTrigger then
            VehReserveReqLine.DeleteLine(Rec);
    end;

    //>>ADDED For table 246
    [EventSubscriber(ObjectType::Table, Database::"Requisition Line", 'OnGetLocationCodeOnBeforeUpdate', '', false, false)]
    local procedure OnGetLocationCodeOnBeforeUpdate(var RequisitionLine: Record "Requisition Line"; CurrentFieldNo: Integer; var IsHandled: Boolean)
    var
        Vend: Record Vendor;
    begin

        if (RequisitionLine."Vendor No." <> '') and (Vend."Location Code" <> '') then begin
            Vend.Get(RequisitionLine."Vendor No.");
            if Vend."Location Code" <> '' then
                RequisitionLine."Location Code" := Vend."Location Code";
        end else
            if (RequisitionLine."Document Profile" <> RequisitionLine."document profile"::"Vehicles Trade") and (RequisitionLine."Document Profile" <> RequisitionLine."document profile"::"Spare Parts Trade") then //29.05.2019 EB.P7
                RequisitionLine."Location Code" := '';
        IsHandled := true;
    end;

    //>>ADDED For table 337
    [EventSubscriber(ObjectType::Table, Database::"Reservation Entry", 'OnAfterTextCaption', '', false, false)]
    local procedure OnAfterTextCaption(SourceType: Integer; var NewTextCaption: Text[255])
    var
        ServLineEDMS: Record "Service Line EDMS";
    begin
        case SourceType of
            Database::"Service Line EDMS":    //08.07.08 EDMS P1
                NewTextCaption := ServLineEDMS.TableCaption; //08.07.08 EDMS P1
        end;
    end;

    //>>ADDED For table 337
    [EventSubscriber(ObjectType::Table, Database::"Reservation Entry", 'OnBeforeSummEntryNo', '', false, false)]
    local procedure OnBeforeSummEntryNo(ReservationEntry: Record "Reservation Entry"; var ReturnValue: Integer; var IsHandled: Boolean)
    var

    begin
        IsHandled := true;
        case ReservationEntry."Source Type" of
            DATABASE::"Item Ledger Entry":
                ReturnValue := "Reservation Summary Type"::"Item Ledger Entry".AsInteger();
            DATABASE::"Purchase Line":
                ReturnValue := "Reservation Summary Type"::"Purchase Quote".AsInteger() + ReservationEntry."Source Subtype";
            DATABASE::"Requisition Line":
                ReturnValue := "Reservation Summary Type"::"Requisition Line".AsInteger();
            DATABASE::"Sales Line":
                ReturnValue := "Reservation Summary Type"::"Sales Quote".AsInteger() + ReservationEntry."Source Subtype";
            DATABASE::"Item Journal Line":
                ReturnValue := "Reservation Summary Type"::"Item Journal Purchase".AsInteger() + ReservationEntry."Source Subtype";
            DATABASE::"Job Journal Line":
                ReturnValue := "Reservation Summary Type"::"Job Journal Usage".AsInteger() + ReservationEntry."Source Subtype";
            DATABASE::"Prod. Order Line":
                ReturnValue := "Reservation Summary Type"::"Simulated Production Order".AsInteger() + ReservationEntry."Source Subtype";
            DATABASE::"Prod. Order Component":
                ReturnValue := "Reservation Summary Type"::"Simulated Prod. Order Comp.".AsInteger() + ReservationEntry."Source Subtype";
            DATABASE::"Transfer Line":
                ReturnValue := "Reservation Summary Type"::"Transfer Shipment".AsInteger() + ReservationEntry."Source Subtype";
            DATABASE::"Service Line":
                ReturnValue := "Reservation Summary Type"::"Service Order".AsInteger();
            DATABASE::"Assembly Header":
                ReturnValue := "Reservation Summary Type"::"Assembly Quote Header".AsInteger() + ReservationEntry."Source Subtype";
            DATABASE::"Assembly Line":
                ReturnValue := "Reservation Summary Type"::"Assembly Quote Line".AsInteger() + ReservationEntry."Source Subtype";
            DATABASE::"Invt. Document Line":
                ReturnValue := "Reservation Summary Type"::"Inventory Receipt".AsInteger() + ReservationEntry."Source Subtype";
            Database::"Service Line EDMS": //08.07.08 EDMS P1
                ReturnValue := 220; //08.07.08 EDMS P1
            else
                ReturnValue := 0;
        end;
    end;

    //>>ADDED For table 352
    [EventSubscriber(ObjectType::Table, Database::"Default Dimension", 'OnAfterUpdateGlobalDimCode', '', false, false)]
    local procedure OnAfterUpdateGlobalDimCode(GlobalDimCodeNo: Integer; TableID: Integer; AccNo: Code[20]; NewDimValue: Code[20])
    var
        "DefaultDimension": record "Default Dimension";
    begin
        if TableID = Database::"Service Labor" then
            "DefaultDimension".UpdateServiceLaborEDMSGLobalDimCode(GlobalDimCodeNo, AccNo, NewDimValue);

    end;

    //>>ADDED For table 454
    [EventSubscriber(ObjectType::Table, Database::"Approval Entry", 'OnBeforeRecordCaption', '', false, false)]
    local procedure OnBeforeRecordCaption(var ApprovalEntry: Record "Approval Entry"; var Result: Text; var IsHandled: Boolean)
    var
        AllObjWithCaption: Record AllObjWithCaption;
        RecRef: RecordRef;
        PageNo: Integer;
        PurchaseHeader: Record "Purchase Header";
        Text001: Label 'Demande d''achat';
        PageManagement: Codeunit "Page Management";
    begin

        IsHandled := true;
        if not RecRef.Get(ApprovalEntry."Record ID to Approve") then
            exit;
        PageNo := PageManagement.GetPageID(RecRef);
        if PageNo = 0 then
            exit;
        AllObjWithCaption.Get(AllObjWithCaption."Object Type"::Page, PageNo);
        //>>DELTA BCH 29/11/2021
        IF (ApprovalEntry."Table ID" = 38) AND (ApprovalEntry."Document Type" = ApprovalEntry."Document Type"::Quote) THEN BEGIN
            PurchaseHeader.RESET;
            PurchaseHeader.SETRANGE("Document Type", PurchaseHeader."Document Type"::Quote);
            PurchaseHeader.SETFILTER("No.", ApprovalEntry."Document No.");
            IF PurchaseHeader.FINDFIRST THEN
                IF PurchaseHeader."Purchase Request" = TRUE THEN
                    Result := STRSUBSTNO('%1 %2', Text001, ApprovalEntry."Document No.");
        END else
            //<<DELTA BCH 29/11/2021
            Result := StrSubstNo('%1 %2', AllObjWithCaption."Object Caption", ApprovalEntry."Document No.");

    end;


    //>>ADDED For table 5050
    [EventSubscriber(ObjectType::Table, Database::"contact", 'OnAfterOnInsert', '', false, false)]
    local procedure OnAfterOnInsert(var Contact: Record Contact; xContact: Record Contact)
    var
    begin
        Contact."Last User Modified" := UserId; //24.10.2007 EDMS P3
    end;

    //>>ADDED For table 5050
    [EventSubscriber(ObjectType::Table, Database::"contact", 'OnAfterOnModify', '', false, false)]
    local procedure OnAfterOnModify(var Contact: Record Contact; xContact: Record Contact)
    var
    begin
        Contact."Last User Modified" := UserId; //24.10.2007 EDMS P3
    end;

    //>>ADDED For table 5050
    [EventSubscriber(ObjectType::Table, Database::"contact", 'OnBeforeChooseNewCustomerTemplate', '', false, false)]
    local procedure OnBeforeChooseNewCustomerTemplate(var Contact: Record Contact; var CustTemplateCode: Code[10]; var IsHandled: Boolean)
    var
        CustTemplate: Record "Customer Templ.";
        ContBusRel: Record "Contact Business Relation";
    begin
        IsHandled := true;
        Contact.CheckForExistingRelationships(ContBusRel."Link to Table"::Customer);
        ContBusRel.Reset();
        ContBusRel.SetRange("Contact No.", Contact."No.");
        ContBusRel.SetRange("Link to Table", ContBusRel."Link to Table"::Customer);
        if ContBusRel.FindFirst() then
            Error(
              Text019,
            Contact.TableCaption, Contact."No.", ContBusRel.TableCaption, ContBusRel."Link to Table", ContBusRel."No.")

        else
            //BEGIN  //08-08-2007 EDMS P3 >>
            if Confirm(CreateCustomerFromContactQst, true) then begin
                CustTemplate.SetRange("Contact Type", Contact.Type);
                if PAGE.RunModal(0, CustTemplate) = ACTION::LookupOK then
                    CustTemplateCode := CustTemplate.Code;

                Error(Text022);
            end   //08-08-2007 EDMS P3  <<
    end;

    //>>ADDED For table 5050
    [EventSubscriber(ObjectType::Table, Database::"contact", 'OnAfterUpdateQuotesForContact', '', false, false)]
    local procedure OnAfterUpdateQuotesForContact(Contact: Record Contact; Customer: Record Customer)
    var
        ServiceHeader: Record "Service Header EDMS";
        ServiceLine: Record "Service Line EDMS";
        Vehicle: Record Vehicle;
    begin
        //EDMS P3 >>
        ServiceHeader.Reset;
        ServiceHeader.SetCurrentkey("Document Type", "Sell-to Contact No.");
        ServiceHeader.SetRange("Document Type", ServiceHeader."document type"::Quote);
        ServiceHeader.SetRange("Sell-to Contact No.", Contact."No.");
        if ServiceHeader.Find('-') then
            repeat
                ServiceHeader."Sell-to Customer No." := Customer."No.";
                ServiceHeader."Sell-to Customer Template Code" := '';
                ServiceHeader.Modify;
                ServiceLine.SetRange("Document Type", ServiceHeader."Document Type");
                ServiceLine.SetRange("Document No.", ServiceHeader."No.");
                if ServiceLine.Find('-') then
                    ServiceLine.ModifyAll("Sell-to Customer No.", ServiceHeader."Sell-to Customer No.");
            until ServiceHeader.Next = 0;

        ServiceHeader.Reset;
        ServiceHeader.SetCurrentkey("Bill-to Contact No.");
        ServiceHeader.SetRange("Document Type", ServiceHeader."document type"::Quote);
        ServiceHeader.SetRange("Bill-to Contact No.", Contact."No.");
        if ServiceHeader.Find('-') then
            repeat
                ServiceHeader."Bill-to Customer No." := Customer."No.";
                ServiceHeader."Bill-to Customer Template Code" := '';
                ServiceHeader.Modify;
                ServiceLine.SetRange("Document Type", ServiceHeader."Document Type");
                ServiceLine.SetRange("Document No.", ServiceHeader."No.");
                if ServiceLine.Find('-') then
                    ServiceLine.ModifyAll("Bill-to Customer No.", ServiceHeader."Bill-to Customer No.");
            until ServiceHeader.Next = 0;

        //EDMS P3 <<
    end;

    //>>ADDED For table 5065
    [EventSubscriber(ObjectType::Table, Database::"Interaction Log Entry", 'OnAfterCopyFromSegment', '', false, false)]
    local procedure OnAfterCopyFromSegment(var InteractionLogEntry: Record "Interaction Log Entry"; SegmentLine: Record "Segment Line")
    begin
        // 10.11.2015 EB.P30 #T065 >>
        if SegmentLine."Vehicle Serial No." <> '' then
            InteractionLogEntry."Vehicle Serial No." := SegmentLine."Vehicle Serial No."
        else
            InteractionLogEntry."Vehicle Serial No." := SegmentLine.GetFirstVehicleNo;  //26.07.2013 EDMS P8
        // 10.11.2015 EB.P30 #T065 <<
    end;

    //>>ADDED For table 5077
    [EventSubscriber(ObjectType::Table, Database::"Segment Line", 'OnBeforeSetCorrespondenceType', '', false, false)]
    local procedure OnBeforeSetCorrespondenceType(var SegmentLine: Record "Segment Line"; var xSegmentLine: Record "Segment Line"; var IsHandled: Boolean)
    var
        InteractTmpl: Record "Interaction Template";
    begin
        if SegmentLine.Description = '' then
            if InteractTmpl.Get(SegmentLine."Interaction Template Code") then
                SegmentLine.Description := InteractTmpl.Description;
    end;

    //>>ADDED For table 5077
    [EventSubscriber(ObjectType::Table, Database::"Segment Line", 'OnAfterdeleteEvent', '', false, false)]
    local procedure OnAfterdeleteSeglineEvent(var Rec: Record "Segment Line"; RunTrigger: Boolean)
    var
        SegmentSubLine: Record "Segment SubLine";
    begin
        SegmentSubLine.Reset;
        SegmentSubLine.SetRange("Segment No.", Rec."Segment No.");
        SegmentSubLine.SetRange("Line No.", Rec."Line No.");
        SegmentSubLine.DeleteAll(true);
    end;
    //>>ADDED For table 5077
    [EventSubscriber(ObjectType::Table, Database::"Segment Line", 'OnCreateInteractionFromContactOnBeforeStartWizard', '', false, false)]
    local procedure OnCreateInteractionFromContactOnBeforeStartWizard(var SegmentLine: Record "Segment Line"; var Contact: Record Contact)
    var
        UserSetup: Record "User Setup";
        PurchSlsPer: Record "Salesperson/Purchaser";
    begin
        //28.01.2008 EDMS P3 >>
        if UserSetup.Get(UserId) then;
        if PurchSlsPer.Get(UserSetup."Salespers./Purch. Code") then
            if UserSetup."Salespers./Purch. Code" <> '' then
                SegmentLine."Salesperson Code" := UserSetup."Salespers./Purch. Code"
    end;

    //>>ADDED For table 5077
    [EventSubscriber(ObjectType::Table, Database::"Segment Line", 'OnAfterCreateFromTask', '', false, false)]
    local procedure OnAfterCreateFromTask(var SegmentLine: Record "Segment Line"; Task: Record "To-do")
    var
        SalesPurchPerson: Record "Salesperson/Purchaser";
        Campaign: Record Campaign;
        Opportunity: Record Opportunity;
        Cont: Record Contact;
    begin
        SegmentLine.Init();
        SegmentLine."To-do No." := Task."No.";
        SegmentLine.SetRange("To-do No.", SegmentLine."To-do No.");
        if Cont.Get(Task."Contact No.") then
            SegmentLine.Validate("Contact No.", Task."Contact No.");
        if SalesPurchPerson.Get(Task."Salesperson Code") then
            SegmentLine."Salesperson Code" := SalesPurchPerson.Code;
        if Campaign.Get(Task."Campaign No.") then
            SegmentLine."Campaign No." := Campaign."No.";
        if Opportunity.Get(Task."Opportunity No.") then
            SegmentLine."Opportunity No." := Task."Opportunity No.";
    end;

    //>>ADDED For table 5080
    [EventSubscriber(ObjectType::Table, Database::"To-do", 'OnAfterValidateEvent', 'Interaction Template Code', true, true)]
    local procedure OnAfterValidateInteractionTemplateCode(var Rec: Record "To-do"; var xRec: Record "To-do"; CurrFieldNo: Integer)
    var
        IntTempl: Record "Interaction Template";
    begin
        IntTempl.Get(rec."Interaction Template Code"); //08-08-2007 EDMS P3
        if rec.Description = '' then begin               //08-08-2007 EDMS P3
            rec.Description := IntTempl.Description;     //08-08-2007 EDMS P3
            rec.Modify();
        end;
    end;

    //>>ADDED For table 5080
    [EventSubscriber(ObjectType::Table, Database::"To-do", 'OnCreateTaskFromTaskOnBeforeStartWizard', '', false, false)]
    local procedure OnCreateTaskFromTaskOnBeforeStartWizard(var Task: Record "To-do"; FromTask: Record "To-do")
    var
        Vehicle: Record Vehicle;
    begin
        //07.10.2009. EDMS P2 >>
        if Vehicle.Get(FromTask.GetFilter("Vehicle Serial No.")) then
            Task."Vehicle Serial No." := Vehicle."Serial No.";

        //07.10.2009. EDMS P2 <<
    end;


    //>>ADDED For table 5089
    [EventSubscriber(ObjectType::Table, Database::"Contact Profile Answer", 'OnAfterdeleteEvent', '', false, false)]
    local procedure OnAfterdeleteCtProfile(var Rec: Record "Contact Profile Answer"; RunTrigger: Boolean)
    var
        AnswerComments: Record "Profile Answer Comment Line";
    begin
        //10-08-2007 EDMS P3 >>
        AnswerComments.SetRange("Contact No.", Rec."Contact No.");
        AnswerComments.SetRange("Profile Questionnaire Code", Rec."Profile Questionnaire Code");
        AnswerComments.SetRange("Answer Line No.", Rec."Line No.");
        AnswerComments.DeleteAll;
        //10-08-2007 EDMS P3 <<
    end;

    //>>ADDED For TABLE 99000853
    [EventSubscriber(ObjectType::Table, Database::"Inventory Profile", 'OnTransferToTrackingEntrySourceTypeElseCase', '', false, false)]
    local procedure OnTransferToTrackingEntrySourceTypeElseCase(var InventoryProfile: Record "Inventory Profile"; var ReservationEntry: Record "Reservation Entry"; UseSecondaryFields: Boolean; var IsHandled: Boolean)
    var
    begin
        if InventoryProfile."Source Type" = Database::"Service Line EDMS" then begin
            ReservationEntry."Source Type" := Database::"Service Line EDMS";
            ReservationEntry."Source Subtype" := InventoryProfile."Source Order Status";
            ReservationEntry."Source ID" := InventoryProfile."Source ID";
            ReservationEntry."Source Ref. No." := InventoryProfile."Source Ref. No.";
            IsHandled := true;
        end;
    end;

    //>>ADDED For table 99000880
    [EventSubscriber(ObjectType::Table, Database::"Order Promising Line", 'OnAfterValidateEvent', 'Requested Delivery Date', true, true)]
    local procedure OnAfterValidateEventRqDeliveryDate(var Rec: Record "Order Promising Line"; var xRec: Record "Order Promising Line"; CurrFieldNo: Integer)
    var
        ServiceLineEDMS: Record "Service Line EDMS";
    begin
        if rec."Source Type" = rec."source type"::"Service Order EDMS" then begin
            ServiceLineEDMS.Get(rec."Source Subtype", rec."Source ID", rec."Source Line No.");
            rec."Requested Shipment Date" := ServiceLineEDMS."Planned Service Date";
        end;
    end;

    //>>ADDED for table 9053
    [EventSubscriber(ObjectType::Table, Database::"Sales Cue", 'OnFilterOrdersOnAfterSalesHeaderSetFilters', '', false, false)]
    local procedure OnFilterOrdersOnAfterSalesHeaderSetFilters(var SalesHeader: Record "Sales Header");
    var
        DocProfMgt: Codeunit "Document Profile Mgt. EDMS";
    begin
        SalesHeader.SetRange("Document Profile", DocProfMgt.GetDefaultDocProfile());
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeCheckReplacement(var SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeTestVehicleQuantity(var SalesLine: Record "Sales Line"; var IsHandled: Boolean)
    begin
    end;




    var

        Text103: label 'There are linked deal documents. All links will be deleted. Are you sure you want to change this line?';
        Text045: Label 'cannot be more than %1';
        Text022: Label 'The creation of the customer has been aborted.';
        Text019: Label 'The %2 record of the %1 already has the %3 with %4 %5.';
        CreateCustomerFromContactQst: Label 'Do you want to create a contact as a customer using a customer template?';
        CannotChangePrepmtAmtDiffVAtPctErr: Label 'You cannot change the prepayment amount because the prepayment invoice has been posted with a different VAT percentage. Please check the settings on the prepayment G/L account.';
}

