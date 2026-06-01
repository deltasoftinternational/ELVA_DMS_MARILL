Codeunit 25006602 "Rent Jnl.-Post Line"
{
    Permissions = TableData "Rent Ledger Entry" = imd,
                  TableData "Rent Register" = imd;
    TableNo = "Rent Journal Line";

    trigger OnRun()
    begin
        GetGLSetup;

        RunWithCheck(Rec);
    end;

    var
        GLSetup: Record "General Ledger Setup";
        RentJnlLine: Record "Rent Journal Line";
        RentLedgEntry: Record "Rent Ledger Entry";
        RentItem: Record "Rent Item";
        RentReg: Record "Rent Register";
        GenPostingSetup: Record "General Posting Setup";
        ResUOM: Record "Resource Unit of Measure";
        RentJnlCheckLine: Codeunit "Rent Jnl.-Check Line";
        DimMgt: Codeunit DimensionManagement;
        NextEntryNo: Integer;
        GLSetupRead: Boolean;
        RentMgtSetup: Record "Rent Mgt. Setup";
        NotEnaughQtyErr: Label 'Rent Item %1, Rent Asset %2 has not enaugh Quantity in %3. Available Quantity: %4';


    procedure GetRentReg(var NewRentReg: Record "Rent Register")
    begin
        NewRentReg := RentReg;
    end;


    procedure RunWithCheck(var RentJnlLine2: Record "Rent Journal Line")
    begin
        RentJnlLine.Copy(RentJnlLine2);
        Code;
        RentJnlLine2 := RentJnlLine;
    end;

    local procedure "Code"()
    var
        TmpRentJnlLine: Record "Rent Journal Line";
    begin
        RentMgtSetup.Get;
        //  IF EmptyLine THEN
        //    EXIT;
        RentJnlCheckLine.RunCheck(RentJnlLine);

        if NextEntryNo = 0 then begin
            RentLedgEntry.LockTable;
            if RentLedgEntry.Find('+') then
                NextEntryNo := RentLedgEntry."Entry No.";
            NextEntryNo := NextEntryNo + 1;
        end;

        if RentJnlLine."Document Date" = 0D then
            RentJnlLine."Document Date" := RentJnlLine."Posting Date";

        if RentReg."No." = 0 then begin
            RentReg.LockTable;
            if (not RentReg.Find('+')) or (RentReg."To Entry No." <> 0) then begin
                RentReg.Init;
                RentReg."No." := RentReg."No." + 1;
                RentReg."From Entry No." := NextEntryNo;
                RentReg."To Entry No." := NextEntryNo;
                RentReg."Creation Date" := Today;
                RentReg."Source Code" := RentJnlLine."Source Code";
                RentReg."Journal Batch Name" := RentJnlLine."Journal Batch Name";
                RentReg."User ID" := UserId;
                RentReg.Insert;
            end;
        end;
        RentReg."To Entry No." := NextEntryNo;
        RentReg.Modify;


        //if RentJnlLine."Entry Type" = RentJnlLine."entry type"::Inventory then begin            
        //    //Create ship entry
        //    Clear(TmpRentJnlLine);
        //    TmpRentJnlLine := RentJnlLine;
        //    TmpRentJnlLine."Document Type" := TmpRentJnlLine."document type"::Shipment;
        //    CreateRentLedgEntry(TmpRentJnlLine, NextEntryNo);
        //    NextEntryNo := NextEntryNo + 1;

        //Create recieve entry
        //    Clear(TmpRentJnlLine);
        //    TmpRentJnlLine := RentJnlLine;
        //    TmpRentJnlLine."Document Type" := TmpRentJnlLine."document type"::Receipt;
        //    CreateRentLedgEntry(TmpRentJnlLine, NextEntryNo);
        //    NextEntryNo := NextEntryNo + 1;
        //end else begin
        CreateRentLedgEntry(RentJnlLine, NextEntryNo);
        NextEntryNo := NextEntryNo + 1;
        //end;
        OnAfterPostRentJnlLine(RentJnlLine);
    end;

    local procedure GetGLSetup()
    begin
        if not GLSetupRead then
            GLSetup.Get;
        GLSetupRead := true;
    end;


    procedure CreateRentLedgEntry(RentJnlLine1: Record "Rent Journal Line"; NextEntryNo1: Integer)
    var
        RentAssetToUpdate: Record "Rent Asset";
    begin
        RentLedgEntry.Init;
        RentLedgEntry."Entry Type" := RentJnlLine1."Entry Type";
        RentLedgEntry."Document No." := RentJnlLine1."Document No.";
        RentLedgEntry."External Document No." := RentJnlLine1."External Document No.";
        RentLedgEntry."Posting Date" := RentJnlLine1."Posting Date";
        RentLedgEntry."Document Date" := RentJnlLine1."Document Date";
        RentLedgEntry.Description := RentJnlLine1.Description;
        RentLedgEntry."Global Dimension 1 Code" := RentJnlLine1."Shortcut Dimension 1 Code";
        RentLedgEntry."Global Dimension 2 Code" := RentJnlLine1."Shortcut Dimension 2 Code";
        RentLedgEntry."Dimension Set ID" := RentJnlLine1."Dimension Set ID";
        RentLedgEntry."Responsibility Center" := RentJnlLine1."Responsibility Center";
        RentLedgEntry."Deal Type" := RentJnlLine1."Deal Type";
        RentLedgEntry."Source Code" := RentJnlLine1."Source Code";
        RentLedgEntry."Journal Batch Name" := RentJnlLine1."Journal Batch Name";
        RentLedgEntry."Reason Code" := RentJnlLine1."Reason Code";
        RentLedgEntry."No. Series" := RentJnlLine1."Posting No. Series";
        RentLedgEntry."Rent Item No." := RentJnlLine1."Rent Item No.";
        RentLedgEntry."Rent Asset No." := RentJnlLine1."Rent Asset No.";
        RentLedgEntry."Document Type" := RentJnlLine1."Document Type";
        RentLedgEntry."Document Line No." := RentJnlLine1."Document Line No.";
        RentLedgEntry."Location Code" := RentJnlLine1."Location Code";

        if RentLedgEntry."Entry Type" = RentLedgEntry."entry type"::Inventory then begin
            case RentLedgEntry."Document Type" of
                RentLedgEntry."document type"::Shipment, RentLedgEntry."document type"::"Negative Adjmt.":
                    begin
                        RentLedgEntry.Quantity := -RentJnlLine1.Quantity;
                        UpdateAvailableQty(RentJnlLine1."Rent Item No.", RentJnlLine1."Rent Asset No.", RentJnlLine1.Quantity, RentJnlLine1."Location Code");
                    end;
                RentLedgEntry."document type"::Receipt, RentLedgEntry."document type"::"Positive Adjmt.":
                    begin
                        RentLedgEntry.Quantity := RentJnlLine1.Quantity;
                        RentLedgEntry."Available Quantity" := RentJnlLine1.Quantity;
                        RentLedgEntry.Open := True;
                    end;
                else begin
                    RentLedgEntry.Quantity := RentJnlLine1.Quantity;
                end;
            end;
        end else begin
            RentLedgEntry.Quantity := RentJnlLine1.Quantity;
        end;

        RentLedgEntry."Rent Order No." := RentJnlLine1."Rent Order No.";
        RentLedgEntry."Rent Order Type" := RentJnlLine1."Rent Order Type";
        RentLedgEntry."Rent Order Line No." := RentJnlLine1."Rent Order Line No.";
        RentLedgEntry."Rent Order Sales Line No." := RentJnlLine1."Rent Order Sales Line No.";
        RentLedgEntry."Rent Transfer Type" := RentJnlLine1."Rent Transfer Type";
        RentLedgEntry."Shipment Date" := RentJnlLine1."Shipment Date";

        RentLedgEntry."Gen. Bus. Posting Group" := RentJnlLine1."Gen. Bus. Posting Group";
        RentLedgEntry."Gen. Prod. Posting Group" := RentJnlLine1."Gen. Prod. Posting Group";
        RentLedgEntry."VAT Bus. Posting Group" := RentJnlLine1."VAT Bus. Posting Group";
        RentLedgEntry."VAT Prod. Posting Group" := RentJnlLine1."VAT Prod. Posting Group";
        RentLedgEntry."Unit of Measure Code" := RentJnlLine1."Unit of Measure Code";
        RentLedgEntry."Unit Cost" := RentJnlLine1."Unit Cost";
        RentLedgEntry."Total Cost" := RentJnlLine1."Total Cost";
        RentLedgEntry."Unit Price" := RentJnlLine1."Unit Price";
        RentLedgEntry.Amount := RentJnlLine1.Amount;
        RentLedgEntry."Discount %" := RentJnlLine1."Discount %";
        RentLedgEntry."Line Discount Amount" := RentJnlLine1."Line Discount Amount";
        RentLedgEntry."Line Discount Amount (LCY)" := RentJnlLine1."Line Discount Amount (LCY)";
        RentLedgEntry."Inv. Discount Amount" := RentJnlLine1."Inv. Discount Amount";
        RentLedgEntry."Inv. Discount Amount (LCY)" := RentJnlLine1."Inv. Discount Amount (LCY)";
        RentLedgEntry."Amount Including VAT (LCY)" := RentJnlLine1."Amount Including VAT (LCY)";
        RentLedgEntry."Amount Including VAT" := RentJnlLine1."Amount Including VAT";
        RentLedgEntry."Amount (LCY)" := RentJnlLine1."Amount (LCY)";
        RentLedgEntry."Currency Code" := RentJnlLine1."Currency Code";
        RentLedgEntry."Sell-to Customer No." := RentJnlLine1."Sell-to Customer No.";
        RentLedgEntry."Bill-to Customer No." := RentJnlLine1."Bill-to Customer No.";
        RentLedgEntry."Salesperson Code" := RentJnlLine1."Salesperson Code";
        RentLedgEntry."Variable Field Run 1" := RentJnlLine1."Variable Field Run 1";
        RentLedgEntry."Variable Field Run 2" := RentJnlLine1."Variable Field Run 2";
        RentLedgEntry."Variable Field Run 3" := RentJnlLine1."Variable Field Run 3";
        RentLedgEntry.Type := RentJnlLine1.Type;
        RentLedgEntry."No." := RentJnlLine1."No.";
        RentLedgEntry."User ID" := UserId;
        RentLedgEntry."Entry No." := NextEntryNo1;
        RentLedgEntry."Service Order No." := RentJnlLine1."Service Order No.";
        RentLedgEntry."Starting Date" := RentJnlLine1."Starting Date";
        RentLedgEntry."Ending Date" := RentJnlLine1."Ending Date";
        RentLedgEntry."Vehicle Serial No." := RentJnlLine1."Vehicle Serial No.";
        RentLedgEntry.VIN := RentJnlLine1.VIN;
        //>>DELTA RC
        OnBeforeInsertRentLedgEntry(RentLedgEntry, RentJnlLine);
        //<<DELTA RC            

        RentLedgEntry.Insert;

        if (RentLedgEntry."Entry Type" = RentLedgEntry."Entry type"::Inventory) and (RentLedgEntry."Document Type" = RentLedgEntry."Document type"::"Positive Adjmt.") then begin
            if RentAssetToUpdate.Get(RentJnlLine1."Rent Asset No.") then
                if RentAssetToUpdate.Status = RentAssetToUpdate.Status::" " then begin
                    RentAssetToUpdate.Validate(Status, RentAssetToUpdate.Status::Available);
                    RentAssetToUpdate.Modify();
                end;
        end;
    end;

    local procedure UpdateOutstandingQty(RentAssetNo: Code[20]; Qty: Integer; LocationCode: Code[10])
    var
        OutstandingRentLedgEntry: Record "Rent Ledger Entry";
    begin
        OutstandingRentLedgEntry.Reset;
        OutstandingRentLedgEntry.SetRange("Rent Asset No.", RentAssetNo);
        OutstandingRentLedgEntry.SetRange("Location Code", LocationCode);
        OutstandingRentLedgEntry.SetRange("Entry Type", OutstandingRentLedgEntry."entry type"::Inventory);
        OutstandingRentLedgEntry.SetRange("Document Type", OutstandingRentLedgEntry."document type"::Receipt);
        OutstandingRentLedgEntry.SetFilter("Outstanding Qty.", '>0');
        if OutstandingRentLedgEntry.FindFirst then
            repeat
                if OutstandingRentLedgEntry."Outstanding Qty." = Qty then begin
                    OutstandingRentLedgEntry."Outstanding Qty." := 0;
                    OutstandingRentLedgEntry.Modify;
                    exit;
                end else
                    if OutstandingRentLedgEntry."Outstanding Qty." > Qty then begin
                        OutstandingRentLedgEntry."Outstanding Qty." -= Qty;
                        OutstandingRentLedgEntry.Modify;
                        exit;
                    end else begin
                        Qty -= OutstandingRentLedgEntry."Outstanding Qty.";
                        OutstandingRentLedgEntry."Outstanding Qty." := 0;
                        OutstandingRentLedgEntry.Modify;
                    end;
            until OutstandingRentLedgEntry.Next = 0;
    end;

    local procedure UpdateAvailableQty(RentItemNo: Code[20]; RentAssetNo: Code[20]; Qty: Integer; LocationCodeFrom: Code[10])
    var
        AvailableRentLedgEntry: Record "Rent Ledger Entry";
        AvailableQty: Decimal;
    begin
        AvailableQty := GetAvailableQty(RentAssetNo, Qty, LocationCodeFrom);
        if (AvailableQty < Qty) then
            Error(NotEnaughQtyErr, RentItemNo, RentAssetNo, LocationCodeFrom, AvailableQty);
        //'Rent Item %1, Rent Asset %2 has not enaugh Quantity in %3. Available Quantity: %4';

        AvailableRentLedgEntry.Reset;
        AvailableRentLedgEntry.SetRange("Rent Asset No.", RentAssetNo);
        AvailableRentLedgEntry.SetRange("Location Code", LocationCodeFrom);
        AvailableRentLedgEntry.SetRange("Entry Type", AvailableRentLedgEntry."entry type"::Inventory);
        AvailableRentLedgEntry.SetFilter("Document Type", '%1|%2', AvailableRentLedgEntry."document type"::Receipt, AvailableRentLedgEntry."document type"::"Positive Adjmt.");
        AvailableRentLedgEntry.SetFilter("Available Quantity", '>0');
        if AvailableRentLedgEntry.FindFirst then
            repeat
                if AvailableRentLedgEntry."Available Quantity" = Qty then begin
                    AvailableRentLedgEntry."Available Quantity" := 0;
                    AvailableRentLedgEntry.Open := false;
                    AvailableRentLedgEntry.Modify;
                    exit;
                end else
                    if AvailableRentLedgEntry."Available Quantity" > Qty then begin
                        AvailableRentLedgEntry."Available Quantity" -= Qty;
                        AvailableRentLedgEntry.Modify;
                        exit;
                    end else begin
                        Qty -= AvailableRentLedgEntry."Available Quantity";
                        AvailableRentLedgEntry."Available Quantity" := 0;
                        AvailableRentLedgEntry.Open := false;
                        AvailableRentLedgEntry.Modify;
                    end;
            until AvailableRentLedgEntry.Next = 0;
    end;

    local procedure GetAvailableQty(RentAssetNo: Code[20]; Qty: Integer; LocationCodeFrom: Code[10]): Decimal
    var
        AvailableRentLedgEntry: Record "Rent Ledger Entry";
        AvailableQty: Decimal;
    begin
        AvailableRentLedgEntry.Reset;
        AvailableRentLedgEntry.SetRange("Rent Asset No.", RentAssetNo);
        AvailableRentLedgEntry.SetRange("Location Code", LocationCodeFrom);
        AvailableRentLedgEntry.SetRange("Entry Type", AvailableRentLedgEntry."entry type"::Inventory);
        AvailableRentLedgEntry.SetFilter("Document Type", '%1|%2', AvailableRentLedgEntry."document type"::Receipt, AvailableRentLedgEntry."document type"::"Positive Adjmt.");
        AvailableRentLedgEntry.SetFilter("Available Quantity", '>0');
        if AvailableRentLedgEntry.FindFirst then
            repeat
                AvailableQty += AvailableRentLedgEntry."Available Quantity";
            until AvailableRentLedgEntry.Next = 0;

        EXIT(AvailableQty)
    end;

    [IntegrationEvent(false, false)]

    procedure OnAfterPostRentJnlLine(var RentJnlLine: Record "Rent Journal Line")
    begin
    end;

    //>>DELTA RC
    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertRentLedgEntry(var RentLedgerEntry: Record "Rent Ledger Entry"; RentJournalLine: Record "Rent Journal Line")
    begin
    end;
    //<<DELTA RC    

}

