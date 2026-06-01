pageextension 25006097 "Item Charge Assignment (Purch)" extends "Item Charge Assignment (Purch)"//5805
{
    layout
    {

        addlast(Control1)
        {
            field(VehicleSerialNo; Rec."Vehicle Serial No.")
            {
                ApplicationArea = Basic;
            }
            field(VehicleAccountingCycleNo; Rec."Vehicle Accounting Cycle No.")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field(VIN; Rec.VIN)
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field(MakeCode; Rec."Make Code")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field(ModelCode; Rec."Model Code")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field(ModelVersionNo; Rec."Model Version No.")
            {
                ApplicationArea = Basic;
                Visible = false;
            }
            field(GrossWeight; GrossWeight)
            {
                ApplicationArea = Basic;
                Caption = 'Gross Weight';
                Editable = false;
            }
        }
    }
    actions
    {
        addbefore(SuggestItemChargeAssignment)
        {
            action(GetVehicleToCharge)
            {
                ApplicationArea = Basic;
                Caption = 'Get Vehicle to Charge';
                Image = Receipt;

                trigger OnAction()
                var
                    VehSerNoPar: Code[20];
                    VehAccCycleNo: Code[20];
                    VehOperationPositive: Boolean;
                    GetVehicle: Page "Get Vehicle to Charge";
                    ItemLedgerEntry: Record "Item Ledger Entry";
                    ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
                    ReceiptLines: Page "Purch. Receipt Lines";
                    PostedTransferReceiptLines: Page "Posted Transfer Receipt Lines";
                    ShipmentLines: Page "Return Shipment Lines";
                    SalesShipmentLines: Page "Sales Shipment Lines";
                    AssignmentType: Option Sale,Purchase;
                    ReturnRcptLines: Page "Return Receipt Lines";
                    OperationDescr: Text[10];
                begin
                    //16.01.2014 EDMS P15 - created

                    GetVehicle.LookupMode(true);
                    if GetVehicle.RunModal = Action::LookupOK then begin
                        GetVehicle.GetVehicleParams(VehSerNoPar, VehAccCycleNo, VehOperationPositive);
                        DoVehicleChargeAssignment(VehSerNoPar, VehAccCycleNo, VehOperationPositive, rec."Document Type", rec."Document No.", rec."Document Line No.");
                    end;
                end;
            }
        }
    }
    var
        UnitCost: Decimal;
        AssignItemChargePurch: Codeunit "Item Charge Assgnt. (Purch.)";
        FromPurchRcptLine: Record "Purch. Rcpt. Line";
        PurchRcptLine1: Record "Purch. Rcpt. Line";
        FromTransRcptLine: Record "Transfer Receipt Line";
        TransRcptLine1: Record "Transfer Receipt Line";
        FromReturnShptLine: Record "Return Shipment Line";
        ReturnShptLine1: Record "Return Shipment Line";
        FromSalesShptLine: Record "Sales Shipment Line";
        SalesShptLine1: Record "Sales Shipment Line";
        FromReturnRcptLine: Record "Return Receipt Line";
        ReturnRcptLine1: Record "Return Receipt Line";
        PurchLine2: Record "Purchase Line";
        TransferRcptLine: Record "Transfer Receipt Line";
        SalesShptLine: Record "Sales Shipment Line";
        ReturnRcptLine: Record "Return Receipt Line";
        ReturnShptLine: Record "Return Shipment Line";
        ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
        AssignItemChargeSales: Codeunit "Item Charge Assgnt. (Sales)";
        Text002: label '%1 of %2: %3, %4: %5 not found.';


    procedure InitializeItemChargeAssgntPurch(var ItemChargeAssgntPurchPar: Record "Item Charge Assignment (Purch)")
    begin
        //16.01.2014 EDMS P15 - created
        ItemChargeAssgntPurchPar."Document Type" := PurchLine2."Document Type";
        ItemChargeAssgntPurchPar."Document No." := PurchLine2."Document No.";
        ItemChargeAssgntPurchPar."Document Line No." := PurchLine2."Line No.";
        ItemChargeAssgntPurchPar."Item Charge No." := PurchLine2."No.";
    end;


    procedure DoVehicleChargeAssignment(VehSerNoPar: Code[20]; VehAccCycleNo: Code[20]; VehOperationPositive: Boolean; PrchLineDocumentType: Option; PrchLineDocumentNo: Code[20]; PrchDocumentLineNo: Integer)
    var
        GetVehicle: Page "Get Vehicle to Charge";
        ItemLedgerEntry: Record "Item Ledger Entry";
        ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
        ReceiptLines: Page "Purch. Receipt Lines";
        PostedTransferReceiptLines: Page "Posted Transfer Receipt Lines";
        ShipmentLines: Page "Return Shipment Lines";
        SalesShipmentLines: Page "Sales Shipment Lines";
        AssignmentType: Option Sale,Purchase;
        ReturnRcptLines: Page "Return Receipt Lines";
        OperationDescr: Text[10];
    begin
        ItemChargeAssgntPurch.Reset;
        ItemChargeAssgntPurch.SetRange("Document Type", PrchLineDocumentType);
        ItemChargeAssgntPurch.SetRange("Document No.", PrchLineDocumentNo);
        ItemChargeAssgntPurch.SetRange("Document Line No.", PrchDocumentLineNo);

        if VehOperationPositive then
            OperationDescr := 'Income'
        else
            OperationDescr := 'Outcome';

        if VehSerNoPar <> '' then begin
            ItemLedgerEntry.Reset;
            ItemLedgerEntry.SetRange("Serial No.", VehSerNoPar);
            ItemLedgerEntry.SetRange("Vehicle Accounting Cycle No.", VehAccCycleNo);
            ItemLedgerEntry.SetRange(Positive, VehOperationPositive);
            if VehOperationPositive then
                ItemLedgerEntry.SetFilter("Document Type", '%1|%2|%3',
                          ItemLedgerEntry."document type"::"Purchase Receipt",
                          ItemLedgerEntry."document type"::"Transfer Receipt",
                          ItemLedgerEntry."document type"::"Sales Return Receipt")
            else
                ItemLedgerEntry.SetFilter("Document Type", '%1|%2',
                          ItemLedgerEntry."document type"::"Purchase Return Shipment",
                          ItemLedgerEntry."document type"::"Sales Shipment");

            if ItemLedgerEntry.FindLast then begin   //means - the last of sorted by "Entry No."
                case ItemLedgerEntry."Document Type" of
                    ItemLedgerEntry."document type"::"Purchase Receipt":
                        begin
                            if ItemChargeAssgntPurch.FindLast then
                                ReceiptLines.Initialize(ItemChargeAssgntPurch, PurchLine2."Unit Cost")
                            else begin
                                InitializeItemChargeAssgntPurch(ItemChargeAssgntPurch);
                                ReceiptLines.Initialize(Rec, PurchLine2."Unit Cost");
                            end;

                            PurchRcptLine1.Reset;
                            PurchRcptLine1.SetRange("Document No.", ItemLedgerEntry."Document No.");
                            PurchRcptLine1.SetRange("Line No.", ItemLedgerEntry."Document Line No.");
                            if PurchRcptLine1.FindFirst then begin
                                FromPurchRcptLine.Copy(PurchRcptLine1);
                                ItemChargeAssgntPurch."Unit Cost" := PurchLine2."Unit Cost";
                                AssignItemChargePurch.CreateRcptChargeAssgnt(FromPurchRcptLine, ItemChargeAssgntPurch);
                            end;
                        end;

                    ItemLedgerEntry."document type"::"Transfer Receipt":
                        begin
                            PostedTransferReceiptLines.SetTableview(TransferRcptLine);
                            if ItemChargeAssgntPurch.FindLast then
                                PostedTransferReceiptLines.Initialize(ItemChargeAssgntPurch, PurchLine2."Unit Cost")
                            else begin
                                InitializeItemChargeAssgntPurch(ItemChargeAssgntPurch);
                                PostedTransferReceiptLines.Initialize(Rec, PurchLine2."Unit Cost");
                            end;

                            TransRcptLine1.Reset;
                            TransRcptLine1.SetRange("Document No.", ItemLedgerEntry."Document No.");
                            TransRcptLine1.SetRange("Line No.", ItemLedgerEntry."Document Line No.");
                            if TransRcptLine1.FindFirst then begin
                                FromTransRcptLine.Copy(TransRcptLine1);
                                ItemChargeAssgntPurch."Unit Cost" := PurchLine2."Unit Cost";
                                AssignItemChargePurch.CreateTransferRcptChargeAssgnt(FromTransRcptLine, ItemChargeAssgntPurch);
                            end;
                        end;

                    ItemLedgerEntry."document type"::"Purchase Return Shipment":
                        begin
                            ShipmentLines.SetTableview(ReturnShptLine);
                            if ItemChargeAssgntPurch.FindLast then
                                ShipmentLines.Initialize(ItemChargeAssgntPurch, PurchLine2."Unit Cost")
                            else begin
                                InitializeItemChargeAssgntPurch(ItemChargeAssgntPurch);
                                ShipmentLines.Initialize(Rec, PurchLine2."Unit Cost");
                            end;

                            ReturnShptLine1.Reset;
                            ReturnShptLine1.SetRange("Document No.", ItemLedgerEntry."Document No.");
                            ReturnShptLine1.SetRange("Line No.", ItemLedgerEntry."Document Line No.");
                            if ReturnShptLine1.FindFirst then begin
                                FromReturnShptLine.Copy(ReturnShptLine1);
                                if FromReturnShptLine.FindFirst then begin
                                    ItemChargeAssgntPurch."Unit Cost" := PurchLine2."Unit Cost";
                                    AssignItemChargePurch.CreateShptChargeAssgnt(FromReturnShptLine, ItemChargeAssgntPurch);
                                end;
                            end;
                        end;

                    ItemLedgerEntry."document type"::"Sales Shipment":
                        begin
                            SalesShipmentLines.SetTableview(SalesShptLine);
                            if ItemChargeAssgntPurch.FindLast then
                                SalesShipmentLines.InitializePurchase(ItemChargeAssgntPurch, PurchLine2."Unit Cost")
                            else begin
                                InitializeItemChargeAssgntPurch(ItemChargeAssgntPurch);
                                SalesShipmentLines.InitializePurchase(Rec, PurchLine2."Unit Cost");
                            end;

                            SalesShptLine1.Reset;
                            SalesShptLine1.SetRange("Document No.", ItemLedgerEntry."Document No.");
                            SalesShptLine1.SetRange("Line No.", ItemLedgerEntry."Document Line No.");
                            if SalesShptLine1.FindFirst then begin
                                AssignmentType := Assignmenttype::Purchase;

                                FromSalesShptLine.Copy(SalesShptLine1);
                                if FromSalesShptLine.FindFirst then
                                    if AssignmentType = Assignmenttype::Sale then begin
                                        ItemChargeAssgntSales."Unit Cost" := PurchLine2."Unit Cost";
                                        AssignItemChargeSales.CreateShptChargeAssgnt(FromSalesShptLine, ItemChargeAssgntSales);
                                    end else
                                        if AssignmentType = Assignmenttype::Purchase then begin
                                            ItemChargeAssgntPurch."Unit Cost" := PurchLine2."Unit Cost";
                                            AssignItemChargePurch.CreateSalesShptChargeAssgnt(FromSalesShptLine, ItemChargeAssgntPurch);
                                        end;
                            end;
                        end;

                    ItemLedgerEntry."document type"::"Sales Return Receipt":
                        begin
                            ReturnRcptLines.SetTableview(ReturnRcptLine);
                            if ItemChargeAssgntPurch.FindLast then
                                ReturnRcptLines.InitializePurchase(ItemChargeAssgntPurch, PurchLine2."Unit Cost")
                            else begin
                                InitializeItemChargeAssgntPurch(ItemChargeAssgntPurch);
                                ReturnRcptLines.InitializePurchase(Rec, PurchLine2."Unit Cost");
                            end;

                            ReturnRcptLine1.Reset;
                            ReturnRcptLine1.SetRange("Document No.", ItemLedgerEntry."Document No.");
                            ReturnRcptLine1.SetRange("Line No.", ItemLedgerEntry."Document Line No.");
                            if ReturnRcptLine1.FindFirst then begin
                                AssignmentType := Assignmenttype::Purchase;

                                FromReturnRcptLine.Copy(ReturnRcptLine1);
                                if FromReturnRcptLine.FindFirst then
                                    if AssignmentType = Assignmenttype::Sale then begin
                                        ItemChargeAssgntSales."Unit Cost" := PurchLine2."Unit Cost";
                                        AssignItemChargeSales.CreateRcptChargeAssgnt(FromReturnRcptLine, ItemChargeAssgntSales);

                                    end else
                                        if AssignmentType = Assignmenttype::Purchase then begin
                                            ItemChargeAssgntPurch."Unit Cost" := PurchLine2."Unit Cost";
                                            AssignItemChargePurch.CreateReturnRcptChargeAssgnt(FromReturnRcptLine, ItemChargeAssgntPurch);
                                        end;
                            end;
                        end;

                    else
                        Message(Text002, OperationDescr, Rec.FieldCaption("Vehicle Serial No."), VehSerNoPar, Rec.FieldCaption("Vehicle Accounting Cycle No."), VehAccCycleNo);
                end;
            end else
                Message(Text002, OperationDescr, Rec.FieldCaption("Vehicle Serial No."), VehSerNoPar, Rec.FieldCaption("Vehicle Accounting Cycle No."), VehAccCycleNo);
        end;
    end;
}

