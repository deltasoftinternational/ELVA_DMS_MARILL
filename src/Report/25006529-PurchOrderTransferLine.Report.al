Report 25006529 "Purch. Order-Transfer Line"
{
    // 19.03.2014 Elva Baltic P18
    //   Added function SetParams()
    //   Rewrote Lookup for Request Page field "Purchase Order No.");

    Caption = 'Transfer Lines';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Purchase Line"; "Purchase Line")
        {
            DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
            column(ReportForNavId_1; 1)
            {
            }

            trigger OnAfterGetRecord()
            begin
                TestField("Document Type");
                TestField("Document No.");
                TestField("Quantity Received", 0);
                TestField("Buy-from Vendor No.", PurchaseLine3."Buy-from Vendor No.");

                iLineNo := 0;
                if PurchaseLine2.FindLast then
                    iLineNo := PurchaseLine2."Line No.";
                iLineNo := iLineNo + 10000;

                PurchaseLine2.Init;
                PurchaseLine2.TransferFields("Purchase Line");
                PurchaseLine2."Document Type" := PurchaseLine3."Document Type";
                PurchaseLine2."Document No." := PurchaseLine3."Document No.";
                PurchaseLine2."Line No." := iLineNo;
                PurchaseLine2.Insert;
                case Type of
                    Type::Item:
                        begin
                            CalcFields("Reserved Quantity");
                            if "Reserved Quantity" > 0 then begin
                                recReservEntry.Reset;
                                recReservEntry.SetRange("Source Type", Database::"Purchase Line");
                                recReservEntry.SetRange("Source Subtype", 1);
                                recReservEntry.SetRange("Source ID", "Document No.");
                                recReservEntry.SetRange("Source Ref. No.", "Line No.");
                                recReservEntry.SetRange("Reservation Status", recReservEntry."reservation status"::Reservation);
                                if recReservEntry.FindFirst then
                                    repeat
                                        recReservEntry."Source ID" := PurchaseLine2."Document No.";
                                        recReservEntry."Source Ref. No." := PurchaseLine2."Line No.";
                                        recReservEntry.Modify;
                                    until recReservEntry.Next = 0;
                            end;
                        end;
                    Type::"Charge (Item)":
                        begin
                            //IT COULD be done for the case then all lines goes
                            ItemChargeAssignment.Reset;
                            ItemChargeAssignment.SetRange("Document Type", ItemChargeAssignment."document type"::Order);
                            ItemChargeAssignment.SetRange("Document No.", "Document No.");
                            ItemChargeAssignment.SetRange("Document Line No.", "Line No.");
                            ItemChargeAssignment.SetRange("Item Charge No.", "No.");
                            if ItemChargeAssignment.FindFirst then
                                if not Confirm(Text002, true) then
                                    CurrReport.Break
                                else
                                    ItemChargeAssignment.DeleteAll;
                            /*
                              REPEAT
                              UNTIL ItemChargeAssignment.NEXT = 0;
                            END;
                            */
                        end;
                end;
                Delete;

            end;

            trigger OnPreDataItem()
            begin
                PurchaseHeader.Reset;
                PurchaseHeader.Get(PurchaseHeader."document type"::Order, OrderNo);
                PurchaseLine2.Reset;
                PurchaseLine2.SetRange("Document Type", PurchaseLine2."document type"::Order);
                PurchaseLine2.SetRange("Document No.", OrderNo);
                if not PurchaseLine2.FindFirst then begin
                    PurchaseLine2.Init;
                    PurchaseLine2."Document Type" := PurchaseLine2."document type"::Order;
                    PurchaseLine2."Document No." := OrderNo;
                    PurchaseLine2."Buy-from Vendor No." := PurchaseHeader."Buy-from Vendor No.";
                end;
                PurchaseLine3.TransferFields(PurchaseLine2);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(OrderNo; OrderNo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Purchase Order No.';
                    TableRelation = "Purchase Header"."No." where("Document Type" = const(Order),
                                                                   "Document Profile" = const("Spare Parts Trade"));

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        PurchHeader2.SetRange("Document Type", PurchHeader2."document type"::Order);
                        PurchHeader2.SetRange("Document Profile", PurchHeader2."document profile"::"Spare Parts Trade");
                        if BuyFromVendNo <> '' then
                            PurchHeader2.SetRange("Buy-from Vendor No.", BuyFromVendNo);

                        PurchOrder.SetTableview(PurchHeader2);
                        PurchOrder.LookupMode := true;
                        if PurchOrder.RunModal = Action::LookupOK then
                            PurchOrder.GetRecord(PurchHeader2);

                        OrderNo := PurchHeader2."No.";
                    end;
                }
            }
        }

        actions
        {
        }
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        if OrderNo = '' then
            Error(Text001);
    end;

    var
        OrderNo: Code[20];
        BuyFromVendNo: Code[20];
        PurchaseHeader: Record "Purchase Header";
        PurchHeader2: Record "Purchase Header";
        PurchaseLine2: Record "Purchase Line";
        PurchaseLine3: Record "Purchase Line";
        Text001: label 'Please specify Destination Purchase Order No.';
        iLineNo: Integer;
        recReservEntry: Record "Reservation Entry";
        recReservEntry2: Record "Reservation Entry";
        ItemChargeAssignment: Record "Item Charge Assignment (Purch)";
        Text002: label 'Charges distribution along lines is not supported, remember you must complete it manually. Contitue?';
        PurchOrder: Page "Purchase Order List";


    procedure SetParams(var ParamPurchLine: Record "Purchase Line")
    begin
        if ParamPurchLine.FindFirst then
            BuyFromVendNo := ParamPurchLine."Buy-from Vendor No.";
    end;
}

