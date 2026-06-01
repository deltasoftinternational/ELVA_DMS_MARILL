pageextension 25006099 "Item Charge Assignment (Sales)" extends "Item Charge Assignment (Sales)"//5814
{
    layout
    {

        addlast(Control1)
        {
            field(VehicleSerialNo; Rec."Vehicle Serial No.")
            {
                ApplicationArea = Basic;
                Editable = false;
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
                    ItemChargeAssgntSales: Record "Item Charge Assignment (Sales)";
                    ReceiptLines: Page "Purch. Receipt Lines";
                    PostedTransferReceiptLines: Page "Posted Transfer Receipt Lines";
                    ShipmentLines: Page "Return Shipment Lines";
                    SalesShipmentLines: Page "Sales Shipment Lines";
                    AssignmentType: Option Sale,Purchase;
                    ReturnRcptLines: Page "Return Receipt Lines";
                    OperationDescr: Text[10];
                    SalesShptLine1: Record "Sales Shipment Line";
                begin
                    //16.01.2014 EDMS P15 - created
                    ItemChargeAssgntSales.SetRange("Document Type", Rec."Document Type");
                    ItemChargeAssgntSales.SetRange("Document No.", Rec."Document No.");
                    ItemChargeAssgntSales.SetRange("Document Line No.", Rec."Document Line No.");

                    GetVehicle.LookupMode(true);
                    if GetVehicle.RunModal = Action::LookupOK then begin
                        GetVehicle.GetVehicleParams(VehSerNoPar, VehAccCycleNo, VehOperationPositive);
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
                                ItemLedgerEntry.SetFilter("Document Type", '%1', ItemLedgerEntry."document type"::"Sales Return Receipt")
                            else
                                ItemLedgerEntry.SetFilter("Document Type", '%1', ItemLedgerEntry."document type"::"Sales Shipment");

                            if ItemLedgerEntry.FindLast then begin   //means - the last of sorted by "Entry No."
                                case ItemLedgerEntry."Document Type" of
                                    ItemLedgerEntry."document type"::"Sales Shipment":
                                        begin
                                            SalesShipmentLines.SetTableview(SalesShptLine);
                                            if ItemChargeAssgntSales.FindLast then
                                                // ???               SalesShipmentLines.InitializeSales(ItemChargeAssgntSales,SalesLine2."Unit Cost")
                                                SalesShipmentLines.InitializeSales(ItemChargeAssgntSales, SalesLine2."Sell-to Customer No.", UnitCost)
                                            else begin
                                                InitializeItemChargeAssgntSales(ItemChargeAssgntSales);
                                                //???                SalesShipmentLines.InitializePurchase(Rec,SalesLine2."Unit Cost");
                                                SalesShipmentLines.InitializeSales(Rec, SalesLine2."Sell-to Customer No.", UnitCost);
                                            end;

                                            SalesShptLine1.Reset;
                                            SalesShptLine1.SetRange("Document No.", ItemLedgerEntry."Document No.");
                                            SalesShptLine1.SetRange("Line No.", ItemLedgerEntry."Document Line No.");
                                            if SalesShptLine1.FindFirst then begin
                                                AssignmentType := Assignmenttype::Sale;

                                                FromSalesShptLine.Copy(SalesShptLine1);
                                                if FromSalesShptLine.FindFirst then
                                                    if AssignmentType = Assignmenttype::Sale then begin
                                                        ItemChargeAssgntSales."Unit Cost" := UnitCost;
                                                        AssignItemChargeSales.CreateShptChargeAssgnt(FromSalesShptLine, ItemChargeAssgntSales);
                                                    end else
                                                        if AssignmentType = Assignmenttype::Purchase then begin
                                                            ItemChargeAssgntPurch."Unit Cost" := UnitCost;
                                                            AssignItemChargePurch.CreateSalesShptChargeAssgnt(FromSalesShptLine, ItemChargeAssgntPurch);
                                                        end;
                                            end;
                                        end;

                                    ItemLedgerEntry."document type"::"Sales Return Receipt":
                                        begin
                                            ReturnRcptLines.SetTableview(ReturnRcptLine);
                                            if ItemChargeAssgntSales.FindLast then
                                                // ???                  ReturnRcptLines.InitializePurchase(ItemChargeAssgntSales,SalesLine2."Unit Cost")
                                                ReturnRcptLines.InitializeSales(ItemChargeAssgntSales, SalesLine2."Sell-to Customer No.", UnitCost)
                                            else begin
                                                // ???                  InitializeItemChargeAssgntPurch(ItemChargeAssgntSales);
                                                ReturnRcptLines.InitializeSales(Rec, SalesLine2."Sell-to Customer No.", UnitCost);
                                            end;

                                            ReturnRcptLine1.Reset;
                                            ReturnRcptLine1.SetRange("Document No.", ItemLedgerEntry."Document No.");
                                            ReturnRcptLine1.SetRange("Line No.", ItemLedgerEntry."Document Line No.");
                                            if ReturnRcptLine1.FindFirst then begin
                                                AssignmentType := Assignmenttype::Sale;

                                                FromReturnRcptLine.Copy(ReturnRcptLine1);
                                                if FromReturnRcptLine.FindFirst then
                                                    if AssignmentType = Assignmenttype::Sale then begin
                                                        ItemChargeAssgntSales."Unit Cost" := UnitCost;
                                                        AssignItemChargeSales.CreateRcptChargeAssgnt(FromReturnRcptLine, ItemChargeAssgntSales);

                                                    end else
                                                        if AssignmentType = Assignmenttype::Purchase then begin
                                                            ItemChargeAssgntPurch."Unit Cost" := UnitCost;
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
                end;
            }
        }
    }
    var
        SalesLine2: Record "Sales Line";
        ReturnRcptLine: Record "Return Receipt Line";
        SalesShptLine: Record "Sales Shipment Line";
        AssignItemChargeSales: Codeunit "Item Charge Assgnt. (Sales)";
        FromSalesShptLine: Record "Sales Shipment Line";
        SalesShptLine1: Record "Sales Shipment Line";
        FromReturnRcptLine: Record "Return Receipt Line";
        ReturnRcptLine1: Record "Return Receipt Line";
        ItemChargeAssgntPurch: Record "Item Charge Assignment (Purch)";
        AssignItemChargePurch: Codeunit "Item Charge Assgnt. (Purch.)";
        Text001: label 'The Rem. to Assign amount is %1. It must be zero before you can post %2 %3.\ \Are you sure that you want to close the page?', Comment = '%2 = Document Type, %3 = Document No.';
        Text002: label '%1 of %2: %3, %4: %5 not found.';


    procedure InitializeItemChargeAssgntSales(var ItemChargeAssgntSalesPar: Record "Item Charge Assignment (Sales)")
    begin
        //16.01.2014 EDMS P15 - created
        ItemChargeAssgntSalesPar."Document Type" := SalesLine2."Document Type";
        ItemChargeAssgntSalesPar."Document No." := SalesLine2."Document No.";
        ItemChargeAssgntSalesPar."Document Line No." := SalesLine2."Line No.";
        ItemChargeAssgntSalesPar."Item Charge No." := SalesLine2."No.";
    end;
}