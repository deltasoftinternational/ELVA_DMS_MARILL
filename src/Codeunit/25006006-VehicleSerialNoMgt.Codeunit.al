Codeunit 25006006 "Vehicle Serial No. Mgt."
{
    // 21.01.2015 EDMS P11
    //   Fixed bug. After recreate Sales Line tracking - lost information in field "Appl.-from Item Entry"
    //   Changed functions:
    //     fDeleteSalesLineTracking
    //     fCreateSalesLineTracking


    trigger OnRun()
    begin
    end;

    var
        tcDMS001: label 'DMS generated entry';


    procedure fGetNewNo(): Code[20]
    var
        recInvSetup: Record "Inventory Setup";
        cuNoSeriesMgt: Codeunit "No. Series";
        codSerialNo: Code[20];
    begin
        recInvSetup.Get;
        recInvSetup.TestField("Vehicle Serial No. Nos.");
        codSerialNo := cuNoSeriesMgt.GetNextNo(recInvSetup."Vehicle Serial No. Nos.", WorkDate);

        exit(codSerialNo);
    end;


    procedure fDeletePurchLineTracking(var recPurchLine: Record "Purchase Line")
    var
        recReservEntry: Record "Reservation Entry";
    begin
        recPurchLine.TestField("Document No.");
        recPurchLine.TestField("Line No.");
        recPurchLine.TestField("Line Type", recPurchLine."line type"::Vehicle);

        recReservEntry.Reset;
        recReservEntry.LockTable;
        recReservEntry.SetCurrentkey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name",
         "Source Prod. Order Line", "Reservation Status");

        recReservEntry.SetRange("Source ID", recPurchLine."Document No.");
        recReservEntry.SetRange("Source Ref. No.", recPurchLine."Line No.");
        recReservEntry.SetRange("Source Type", Database::"Purchase Line");
        recReservEntry.SetRange("Source Subtype", recPurchLine."Document Type");
        recReservEntry.SetRange("Source Batch Name", '');
        recReservEntry.SetRange("Source Prod. Order Line", 0);
        recReservEntry.SetRange("Reservation Status", recReservEntry."reservation status"::Surplus);

        recReservEntry.DeleteAll;
    end;


    procedure fCreatePurchLineTracking(var recPurchLine: Record "Purchase Line")
    var
        intNewEntryNo: Integer;
        recReservEntry: Record "Reservation Entry";
    begin
        recPurchLine.TestField("Document No.");
        recPurchLine.TestField("Line No.");
        recPurchLine.TestField("Line Type", recPurchLine."line type"::Vehicle);
        recPurchLine.TestField("No.");
        recPurchLine.TestField("Vehicle Serial No.");
        recPurchLine.TestField(Quantity, 1);

        recReservEntry.Reset;
        recReservEntry.LockTable;
        intNewEntryNo := fGetLastEntryNo(recReservEntry) + 1;
        recReservEntry.Init;
        recReservEntry."Entry No." := intNewEntryNo;
        recReservEntry.Positive := true;
        recReservEntry."Item No." := recPurchLine."No.";
        recReservEntry."Location Code" := recPurchLine."Location Code";
        if (recPurchLine."Document Type" = recPurchLine."document type"::Order)
           or (recPurchLine."Document Type" = recPurchLine."document type"::Invoice) then begin
            recReservEntry."Quantity (Base)" := recPurchLine.Quantity;
            recReservEntry.Quantity := recPurchLine.Quantity;
            recReservEntry."Qty. to Handle (Base)" := recPurchLine.Quantity;
            recReservEntry."Qty. to Invoice (Base)" := recPurchLine."Qty. to Invoice";
            recReservEntry."Quantity Invoiced (Base)" := recPurchLine."Quantity Invoiced";
        end
        else //Credit Memo, Return Order
         begin
            recReservEntry."Quantity (Base)" := -recPurchLine.Quantity;
            recReservEntry.Quantity := -recPurchLine.Quantity;
            recReservEntry."Qty. to Handle (Base)" := -recPurchLine.Quantity;
            recReservEntry."Qty. to Invoice (Base)" := -recPurchLine."Qty. to Invoice";
            recReservEntry."Quantity Invoiced (Base)" := -recPurchLine."Quantity Invoiced";
        end;
        recReservEntry."Reservation Status" := recReservEntry."reservation status"::Surplus;
        recReservEntry.Description := tcDMS001;
        recReservEntry."Creation Date" := WorkDate;
        recReservEntry."Transferred from Entry No." := 0;
        recReservEntry."Source Type" := Database::"Purchase Line";
        recReservEntry."Source Subtype" := recPurchLine."Document Type";
        recReservEntry."Source ID" := recPurchLine."Document No.";
        recReservEntry."Source Batch Name" := '';
        recReservEntry."Source Prod. Order Line" := 0;
        recReservEntry."Source Ref. No." := recPurchLine."Line No.";
        recReservEntry."Item Ledger Entry No." := 0;
        recReservEntry."Expected Receipt Date" := WorkDate;
        recReservEntry."Shipment Date" := 0D;
        recReservEntry."Serial No." := recPurchLine."Vehicle Serial No.";
        recReservEntry."Created By" := UserId;
        recReservEntry."Changed By" := '';
        recReservEntry."Qty. per Unit of Measure" := recPurchLine."Qty. per Unit of Measure";
        recReservEntry.Binding := recReservEntry.Binding::" ";
        recReservEntry."Suppressed Action Msg." := false;
        recReservEntry."Planning Flexibility" := recReservEntry."planning flexibility"::Unlimited;
        recReservEntry."Warranty Date" := 0D;
        recReservEntry."Expiration Date" := 0D;
        // recReservEntry."Reserved Pick & Ship Qty." := 0;//30.10.2012 EDMS
        recReservEntry."New Serial No." := '';
        recReservEntry."New Lot No." := '';
        recReservEntry."Lot No." := '';
        recReservEntry."Variant Code" := recPurchLine."Variant Code";
        recReservEntry.Correction := false;
        recReservEntry."Action Message Adjustment" := 0;
        recReservEntry.Insert;
    end;


    procedure fDeleteTransferLineTracking(var recTransferLine: Record "Transfer Line")
    var
        recReservEntry: Record "Reservation Entry";
    begin
        recTransferLine.TestField("Document No.");
        recTransferLine.TestField("Line No.");
        recTransferLine.TestField("Document Profile", recTransferLine."document profile"::"Vehicles Trade");

        recReservEntry.Reset;
        recReservEntry.LockTable;
        recReservEntry.SetCurrentkey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name",
         "Source Prod. Order Line", "Reservation Status");

        recReservEntry.SetRange("Source ID", recTransferLine."Document No.");
        recReservEntry.SetRange("Source Ref. No.", recTransferLine."Line No.");
        recReservEntry.SetRange("Source Type", Database::"Transfer Line");
        recReservEntry.SetRange("Source Subtype");
        recReservEntry.SetRange("Source Batch Name", '');
        recReservEntry.SetRange("Source Prod. Order Line", 0);
        recReservEntry.SetRange("Reservation Status", recReservEntry."reservation status"::Surplus);

        recReservEntry.DeleteAll;
    end;


    procedure fCreateTransferLineTracking(var recTransferLine: Record "Transfer Line")
    var
        intNewEntryNo: Integer;
        recReservEntry: Record "Reservation Entry";
    begin
        recTransferLine.TestField("Document No.");
        recTransferLine.TestField("Line No.");
        recTransferLine.TestField("Document Profile", recTransferLine."document profile"::"Vehicles Trade");
        recTransferLine.TestField("Item No.");
        recTransferLine.TestField("Vehicle Serial No.");
        recTransferLine.TestField(Quantity, 1);

        recReservEntry.Reset;
        recReservEntry.LockTable;
        intNewEntryNo := fGetLastEntryNo(recReservEntry) + 1;
        recReservEntry.Init;
        recReservEntry."Entry No." := intNewEntryNo;
        recReservEntry.Positive := false;
        recReservEntry."Item No." := recTransferLine."Item No.";
        recReservEntry."Location Code" := recTransferLine."Transfer-from Code";
        recReservEntry."Quantity (Base)" := -recTransferLine.Quantity;
        recReservEntry."Reservation Status" := recReservEntry."reservation status"::Surplus;
        recReservEntry.Description := tcDMS001;
        recReservEntry."Creation Date" := WorkDate;
        recReservEntry."Transferred from Entry No." := 0;
        recReservEntry."Source Type" := Database::"Transfer Line";
        recReservEntry."Source Subtype" := 0; //!
        recReservEntry."Source ID" := recTransferLine."Document No.";
        recReservEntry."Source Batch Name" := '';
        recReservEntry."Source Prod. Order Line" := 0;
        recReservEntry."Source Ref. No." := recTransferLine."Line No.";
        recReservEntry."Item Ledger Entry No." := 0;
        //recReservEntry."Expected Receipt Date" := WORKDATE;
        recReservEntry."Shipment Date" := 0D;
        recReservEntry."Serial No." := recTransferLine."Vehicle Serial No.";
        recReservEntry."Created By" := UserId;
        recReservEntry."Changed By" := '';
        recReservEntry."Qty. per Unit of Measure" := recTransferLine."Qty. per Unit of Measure";
        recReservEntry.Quantity := -recTransferLine.Quantity;
        recReservEntry.Binding := recReservEntry.Binding::" ";
        recReservEntry."Suppressed Action Msg." := false;
        recReservEntry."Planning Flexibility" := recReservEntry."planning flexibility"::Unlimited;
        recReservEntry."Warranty Date" := 0D;
        recReservEntry."Expiration Date" := 0D;
        recReservEntry."Qty. to Handle (Base)" := -recTransferLine.Quantity;
        recReservEntry."Qty. to Invoice (Base)" := -recTransferLine.Quantity;
        // recReservEntry."Reserved Pick & Ship Qty." := 0;//30.10.2012 EDMS
        recReservEntry."New Serial No." := '';
        recReservEntry."New Lot No." := '';
        recReservEntry."Lot No." := '';
        recReservEntry."Variant Code" := recTransferLine."Variant Code";
        recReservEntry.Correction := false;
        recReservEntry."Action Message Adjustment" := 0;
        recReservEntry.Insert;

        intNewEntryNo := intNewEntryNo + 1;
        recReservEntry.Init;
        recReservEntry."Entry No." := intNewEntryNo;
        recReservEntry.Positive := true;
        recReservEntry."Item No." := recTransferLine."Item No.";
        recReservEntry."Location Code" := recTransferLine."Transfer-to Code";
        recReservEntry."Quantity (Base)" := recTransferLine.Quantity;
        recReservEntry."Reservation Status" := recReservEntry."reservation status"::Surplus;
        recReservEntry.Description := tcDMS001;
        recReservEntry."Creation Date" := WorkDate;
        recReservEntry."Transferred from Entry No." := 0;
        recReservEntry."Source Type" := Database::"Transfer Line";
        recReservEntry."Source Subtype" := 1; //!
        recReservEntry."Source ID" := recTransferLine."Document No.";
        recReservEntry."Source Batch Name" := '';
        recReservEntry."Source Prod. Order Line" := 0;
        recReservEntry."Source Ref. No." := recTransferLine."Line No.";
        recReservEntry."Item Ledger Entry No." := 0;
        //recReservEntry."Expected Receipt Date" := WORKDATE;
        recReservEntry."Shipment Date" := 0D;
        recReservEntry."Serial No." := recTransferLine."Vehicle Serial No.";
        recReservEntry."Created By" := UserId;
        recReservEntry."Changed By" := '';
        recReservEntry."Qty. per Unit of Measure" := recTransferLine."Qty. per Unit of Measure";
        recReservEntry.Quantity := recTransferLine.Quantity;
        recReservEntry.Binding := recReservEntry.Binding::" ";
        recReservEntry."Suppressed Action Msg." := false;
        recReservEntry."Planning Flexibility" := recReservEntry."planning flexibility"::Unlimited;
        recReservEntry."Warranty Date" := 0D;
        recReservEntry."Expiration Date" := 0D;
        recReservEntry."Qty. to Handle (Base)" := recTransferLine.Quantity;
        recReservEntry."Qty. to Invoice (Base)" := recTransferLine.Quantity;
        // recReservEntry."Reserved Pick & Ship Qty." := 0;//30.10.2012 EDMS
        recReservEntry."New Serial No." := '';
        recReservEntry."New Lot No." := '';
        recReservEntry."Lot No." := '';
        recReservEntry."Variant Code" := recTransferLine."Variant Code";
        recReservEntry.Correction := false;
        recReservEntry."Action Message Adjustment" := 0;
        recReservEntry.Insert;
    end;


    procedure fGetLastEntryNo(var recReservEntry: Record "Reservation Entry"): Integer
    begin
        recReservEntry.Reset;
        if recReservEntry.FindLast then
            exit(recReservEntry."Entry No.")
    end;


    procedure fDeleteSalesLineTracking(var recSalesLine: Record "Sales Line")
    var
        recReservEntry: Record "Reservation Entry";
    begin
        recSalesLine.TestField("Document No.");
        recSalesLine.TestField("Line No.");
        recSalesLine.TestField("Line Type", recSalesLine."line type"::Vehicle);

        recReservEntry.Reset;
        recReservEntry.LockTable;
        recReservEntry.SetCurrentkey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name",
         "Source Prod. Order Line", "Reservation Status");

        recReservEntry.SetRange("Source ID", recSalesLine."Document No.");
        recReservEntry.SetRange("Source Ref. No.", recSalesLine."Line No.");
        recReservEntry.SetRange("Source Type", Database::"Sales Line");
        recReservEntry.SetRange("Source Subtype", recSalesLine."Document Type");
        recReservEntry.SetRange("Source Batch Name", '');
        recReservEntry.SetRange("Source Prod. Order Line", 0);
        recReservEntry.SetRange("Reservation Status", recReservEntry."reservation status"::Surplus);

        // 21.01.2015 EDMS P11 >>
        if recReservEntry.FindFirst then
            if recSalesLine."Appl.-from Item Entry" = 0 then
                recSalesLine."Appl.-from Item Entry" := recReservEntry."Appl.-from Item Entry";  //28.08.2013 EDMS P8
        // 21.01.2015 EDMS P11 <<

        recReservEntry.DeleteAll;
    end;


    procedure fCreateSalesLineTracking(var recSalesLine: Record "Sales Line")
    var
        intNewEntryNo: Integer;
        recReservEntry: Record "Reservation Entry";
    begin
        recSalesLine.TestField("Document No.");
        recSalesLine.TestField("Line No.");
        recSalesLine.TestField("Line Type", recSalesLine."line type"::Vehicle);
        recSalesLine.TestField("No.");
        recSalesLine.TestField("Vehicle Serial No.");
        recSalesLine.TestField(Quantity, 1);

        recReservEntry.Reset;
        recReservEntry.LockTable;
        intNewEntryNo := fGetLastEntryNo(recReservEntry) + 1;
        recReservEntry.Init;
        recReservEntry."Entry No." := intNewEntryNo;
        recReservEntry.Positive := true;
        recReservEntry."Item No." := recSalesLine."No.";
        recReservEntry."Location Code" := recSalesLine."Location Code";

        if (recSalesLine."Document Type" = recSalesLine."document type"::Order)
          or (recSalesLine."Document Type" = recSalesLine."document type"::Invoice) then begin
            recReservEntry."Quantity (Base)" := -recSalesLine.Quantity;
            recReservEntry.Quantity := -recSalesLine.Quantity;
            recReservEntry."Qty. to Handle (Base)" := -recSalesLine.Quantity;
            recReservEntry."Qty. to Invoice (Base)" := -recSalesLine."Qty. to Invoice";
            recReservEntry."Quantity Invoiced (Base)" := -recSalesLine."Quantity Invoiced";
        end
        else //Credit Memo, Return Order
         begin
            recReservEntry."Quantity (Base)" := recSalesLine.Quantity;
            recReservEntry.Quantity := recSalesLine.Quantity;
            recReservEntry."Qty. to Handle (Base)" := recSalesLine.Quantity;
            recReservEntry."Qty. to Invoice (Base)" := recSalesLine."Qty. to Invoice";
            recReservEntry."Quantity Invoiced (Base)" := recSalesLine."Quantity Invoiced";
        end;

        recReservEntry."Reservation Status" := recReservEntry."reservation status"::Surplus;
        recReservEntry.Description := tcDMS001;
        recReservEntry."Creation Date" := WorkDate;
        recReservEntry."Transferred from Entry No." := 0;
        recReservEntry."Source Type" := Database::"Sales Line";
        recReservEntry."Source Subtype" := recSalesLine."Document Type";
        recReservEntry."Source ID" := recSalesLine."Document No.";
        recReservEntry."Source Batch Name" := '';
        recReservEntry."Source Prod. Order Line" := 0;
        recReservEntry."Source Ref. No." := recSalesLine."Line No.";
        // 21.01.2015 EDMS P11 >>
        recReservEntry."Appl.-to Item Entry" := 0;
        recReservEntry."Appl.-from Item Entry" := recSalesLine."Appl.-from Item Entry";
        // 21.01.2015 EDMS P11 <<
        recReservEntry."Item Ledger Entry No." := 0;
        recReservEntry."Expected Receipt Date" := WorkDate;
        recReservEntry."Shipment Date" := 0D;
        recReservEntry."Serial No." := recSalesLine."Vehicle Serial No.";
        recReservEntry."Created By" := UserId;
        recReservEntry."Changed By" := '';
        recReservEntry."Qty. per Unit of Measure" := recSalesLine."Qty. per Unit of Measure";
        recReservEntry.Binding := recReservEntry.Binding::" ";
        recReservEntry."Suppressed Action Msg." := false;
        recReservEntry."Planning Flexibility" := recReservEntry."planning flexibility"::Unlimited;
        recReservEntry."Warranty Date" := 0D;
        recReservEntry."Expiration Date" := 0D;
        // recReservEntry."Reserved Pick & Ship Qty." := 0;//30.10.2012 EDMS
        recReservEntry."New Serial No." := '';
        recReservEntry."New Lot No." := '';
        recReservEntry."Lot No." := '';
        recReservEntry."Variant Code" := recSalesLine."Variant Code";
        recReservEntry.Correction := false;
        recReservEntry."Action Message Adjustment" := 0;
        recReservEntry.Insert;
    end;


    procedure fDeleteItemJnlLineTracking(var ItemJnlLine: Record "Item Journal Line")
    var
        recReservEntry: Record "Reservation Entry";
    begin
        ItemJnlLine.TestField("Document No.");
        ItemJnlLine.TestField("Line No.");
        ItemJnlLine.TestField("Item No.");
        ItemJnlLine.TestField("Model Version No.");

        recReservEntry.Reset;
        recReservEntry.LockTable;
        recReservEntry.SetCurrentkey("Source ID", "Source Ref. No.", "Source Type", "Source Subtype", "Source Batch Name",
         "Source Prod. Order Line", "Reservation Status");

        recReservEntry.SetRange("Source ID", ItemJnlLine."Journal Template Name");
        recReservEntry.SetRange("Source Ref. No.", ItemJnlLine."Line No.");
        recReservEntry.SetRange("Source Type", Database::"Item Journal Line");
        recReservEntry.SetRange("Source Subtype", 2);//!!
        recReservEntry.SetRange("Source Batch Name", ItemJnlLine."Journal Batch Name");
        recReservEntry.SetRange("Source Prod. Order Line", 0);
        recReservEntry.SetRange("Reservation Status", recReservEntry."reservation status"::Prospect);

        recReservEntry.DeleteAll;
    end;


    procedure fCreateItemJnlLineTracking(var ItemJnlLine: Record "Item Journal Line")
    var
        intNewEntryNo: Integer;
        recReservEntry: Record "Reservation Entry";
    begin
        ItemJnlLine.TestField("Document No.");
        ItemJnlLine.TestField("Line No.");
        ItemJnlLine.TestField("Model Version No.");
        ItemJnlLine.TestField("Item No.");
        ItemJnlLine.TestField("Vehicle Serial No.");
        if ItemJnlLine."Entry Type" = ItemJnlLine."entry type"::"Positive Adjmt." then begin
            if ItemJnlLine.Quantity = 0 then
                ItemJnlLine.TestField("Qty. (Calculated)", ItemJnlLine."Qty. (Phys. Inventory)");
        end else
            ItemJnlLine.TestField(Quantity, 1);

        recReservEntry.Reset;
        recReservEntry.LockTable;
        intNewEntryNo := fGetLastEntryNo(recReservEntry) + 1;
        recReservEntry.Init;
        recReservEntry."Entry No." := intNewEntryNo;
        recReservEntry.Positive := true;
        recReservEntry."Item No." := ItemJnlLine."Item No.";
        recReservEntry."Location Code" := ItemJnlLine."Location Code";

        if (ItemJnlLine."Entry Type" = ItemJnlLine."entry type"::Sale)
          or (ItemJnlLine."Entry Type" = ItemJnlLine."entry type"::"Negative Adjmt.") then begin
            recReservEntry."Quantity (Base)" := -ItemJnlLine.Quantity;
            recReservEntry.Quantity := -ItemJnlLine.Quantity;
            recReservEntry."Qty. to Handle (Base)" := -ItemJnlLine.Quantity;
            recReservEntry."Qty. to Invoice (Base)" := -ItemJnlLine.Quantity;
            recReservEntry."Quantity Invoiced (Base)" := -ItemJnlLine.Quantity;
        end
        else //positive adjustment, purchase
         begin
            recReservEntry."Quantity (Base)" := ItemJnlLine.Quantity;
            recReservEntry.Quantity := ItemJnlLine.Quantity;
            recReservEntry."Qty. to Handle (Base)" := ItemJnlLine.Quantity;
            recReservEntry."Qty. to Invoice (Base)" := ItemJnlLine.Quantity;
            recReservEntry."Quantity Invoiced (Base)" := ItemJnlLine.Quantity;
        end;

        recReservEntry."Reservation Status" := recReservEntry."reservation status"::Prospect;
        recReservEntry.Description := tcDMS001;
        recReservEntry."Creation Date" := WorkDate;
        recReservEntry."Transferred from Entry No." := 0;
        recReservEntry."Source Type" := Database::"Item Journal Line";
        recReservEntry."Source Subtype" := 2;   //!!!
        recReservEntry."Source ID" := ItemJnlLine."Journal Template Name";
        recReservEntry."Source Batch Name" := ItemJnlLine."Journal Batch Name";
        recReservEntry."Source Prod. Order Line" := 0;
        recReservEntry."Source Ref. No." := ItemJnlLine."Line No.";
        recReservEntry."Item Ledger Entry No." := 0;
        recReservEntry."Expected Receipt Date" := WorkDate;
        recReservEntry."Shipment Date" := 0D;
        recReservEntry."Serial No." := ItemJnlLine."Vehicle Serial No.";
        recReservEntry."Created By" := UserId;
        recReservEntry."Changed By" := '';
        recReservEntry."Qty. per Unit of Measure" := ItemJnlLine."Qty. per Unit of Measure";
        recReservEntry.Binding := recReservEntry.Binding::" ";
        recReservEntry."Suppressed Action Msg." := false;
        recReservEntry."Planning Flexibility" := recReservEntry."planning flexibility"::Unlimited;
        recReservEntry."Warranty Date" := 0D;
        recReservEntry."Expiration Date" := 0D;
        // recReservEntry."Reserved Pick & Ship Qty." := 0;//30.10.2012 EDMS
        recReservEntry."New Serial No." := '';
        recReservEntry."New Lot No." := '';
        recReservEntry."Lot No." := '';
        recReservEntry."Variant Code" := ItemJnlLine."Variant Code";
        recReservEntry.Correction := false;
        recReservEntry."Action Message Adjustment" := 0;
        recReservEntry."Appl.-to Item Entry" := ItemJnlLine."Applies-to Entry";
        recReservEntry.Insert;
    end;
}

