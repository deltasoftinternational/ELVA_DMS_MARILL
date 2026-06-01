Report 25006537 "Sales Order-Transfer Line"
{
    Caption = 'Sales Order-Transfer Line';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Sales Line"; "Sales Line")
        {
            DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
            column(ReportForNavId_2844; 2844)
            {
            }

            trigger OnAfterGetRecord()
            var
                iLineNo: Integer;
                recReservEntry: Record "Reservation Entry";
                ResQtyITL: Decimal;
                recReservEntry2: Record "Reservation Entry";
            begin
                TestField("Document Type");
                TestField("Document No.");
                TestField("Quantity Shipped", 0);
                TestField("Sell-to Customer No.", recSalesLine3."Sell-to Customer No.");
                TestField("Bill-to Customer No.", recSalesLine3."Bill-to Customer No.");

                ResQtyITL := 0;
                ResQtyITL := ReservedToStock("Sales Line");

                if TransferOnlyStock then begin
                    if ResQtyITL > 0 then begin
                        iLineNo := 0;
                        if recSalesLine2.Find('+') then
                            iLineNo := recSalesLine2."Line No.";
                        iLineNo := iLineNo + 10000;
                        recSalesLine2.Init;
                        recSalesLine2.TransferFields("Sales Line");
                        recSalesLine2."Document Type" := recSalesLine3."Document Type";
                        recSalesLine2."Document No." := recSalesLine3."Document No.";
                        recSalesLine2."Line No." := iLineNo;
                        recSalesLine2.Validate(Quantity, ResQtyITL);
                        recSalesLine2.Insert;

                        recReservEntry.Reset;
                        recReservEntry.SetRange("Source Type", Database::"Sales Line");
                        recReservEntry.SetRange("Source Subtype", 1);
                        recReservEntry.SetRange("Source ID", "Document No.");
                        recReservEntry.SetRange("Source Ref. No.", "Line No.");
                        recReservEntry.SetRange("Reservation Status", recReservEntry."reservation status"::Reservation);
                        if recReservEntry.Find('-') then
                            repeat
                                recReservEntry2.Reset;
                                recReservEntry2.Get(recReservEntry."Entry No.", true);
                                if recReservEntry2."Source Type" = Database::"Item Ledger Entry" then begin
                                    recReservEntry."Source ID" := recSalesLine2."Document No.";
                                    recReservEntry."Source Ref. No." := recSalesLine2."Line No.";
                                    recReservEntry.Modify;
                                end;
                            until recReservEntry.Next = 0;

                        //30.10.12 EDMS >>
                        /*
                        recDocDim1.RESET;
                        recDocDim1.SETRANGE("Table ID",DATABASE::"Sales Line");
                        recDocDim1.SETRANGE("Document Type","Document Type");
                        recDocDim1.SETRANGE("Document No.","Document No.");
                        recDocDim1.SETRANGE("Line No.","Line No.");
                        IF recDocDim1.FIND('-') THEN
                         REPEAT
                          recDocDim2.INIT;
                           recDocDim2."Table ID" := DATABASE::"Sales Line";
                           recDocDim2."Document Type" := recSalesLine3."Document Type";
                           recDocDim2."Document No." := recSalesLine3."Document No.";
                           recDocDim2."Line No." := iLineNo;
                           recDocDim2."Dimension Code" := recDocDim1."Dimension Code";
                           recDocDim2."Dimension Value Code" := recDocDim1."Dimension Value Code";
                          recDocDim2.INSERT;
                         UNTIL recDocDim1.NEXT = 0;
                        */
                        //30.10.12 EDMS <<

                        if Quantity = ResQtyITL then begin
                            Delete;
                            //30.10.12 EDMS
                            //recDocDim1.DELETEALL;
                        end
                        else begin
                            Validate(Quantity, Quantity - ResQtyITL);
                            Modify;
                        end;
                    end;
                end
                else begin
                    iLineNo := 0;
                    if recSalesLine2.Find('+') then
                        iLineNo := recSalesLine2."Line No.";

                    iLineNo := iLineNo + 10000;

                    recSalesLine2.Init;
                    recSalesLine2.TransferFields("Sales Line");
                    recSalesLine2."Document Type" := recSalesLine3."Document Type";
                    recSalesLine2."Document No." := recSalesLine3."Document No.";
                    recSalesLine2."Line No." := iLineNo;
                    recSalesLine2.Insert;

                    CalcFields("Reserved Quantity");
                    if "Reserved Quantity" > 0 then begin
                        recReservEntry.Reset;
                        recReservEntry.SetRange("Source Type", Database::"Sales Line");
                        recReservEntry.SetRange("Source Subtype", 1);
                        recReservEntry.SetRange("Source ID", "Document No.");
                        recReservEntry.SetRange("Source Ref. No.", "Line No.");
                        recReservEntry.SetRange("Reservation Status", recReservEntry."reservation status"::Reservation);
                        if recReservEntry.Find('-') then begin
                            repeat
                                recReservEntry."Source ID" := recSalesLine2."Document No.";
                                recReservEntry."Source Ref. No." := recSalesLine2."Line No.";
                                recReservEntry.Modify;
                            until recReservEntry.Next = 0;
                        end;
                    end;
                    //30.10.12 EDMS >>
                    /*
                    recDocDim1.RESET;
                    recDocDim1.SETRANGE("Table ID",DATABASE::"Sales Line");
                    recDocDim1.SETRANGE("Document Type","Document Type");
                    recDocDim1.SETRANGE("Document No.","Document No.");
                    recDocDim1.SETRANGE("Line No.","Line No.");
                    IF recDocDim1.FIND('-') THEN
                     REPEAT
                      recDocDim2.INIT;
                       recDocDim2."Table ID" := DATABASE::"Sales Line";
                       recDocDim2."Document Type" := recSalesLine3."Document Type";
                       recDocDim2."Document No." := recSalesLine3."Document No.";
                       recDocDim2."Line No." := iLineNo;
                       recDocDim2."Dimension Code" := recDocDim1."Dimension Code";
                       recDocDim2."Dimension Value Code" := recDocDim1."Dimension Value Code";
                      recDocDim2.INSERT;
                     UNTIL recDocDim1.NEXT = 0;
                     recDocDim1.DELETEALL;
                     */
                    //30.10.12 EDMS <<
                    Delete;
                end;

            end;

            trigger OnPreDataItem()
            var
                SalesHeader: Record "Sales Header";
            begin
                SalesHeader.Reset;
                SalesHeader.Get(SalesHeader."document type"::Order, SalesOrderNo);

                recSalesLine2.Reset;
                recSalesLine2.SetRange("Document Type", recSalesLine2."document type"::Order);
                recSalesLine2.SetRange("Document No.", SalesOrderNo);
                if not recSalesLine2.Find('-') then begin
                    recSalesLine2.Init;
                    recSalesLine2."Document Type" := recSalesLine2."document type"::Order;
                    recSalesLine2."Document No." := SalesOrderNo;
                    recSalesLine2."Sell-to Customer No." := SalesHeader."Sell-to Customer No.";
                    recSalesLine2."Bill-to Customer No." := SalesHeader."Bill-to Customer No.";
                end;

                recSalesLine3.TransferFields(recSalesLine2);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(SalesOrderNo; SalesOrderNo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Sales Order No.';
                    TableRelation = "Sales Header"."No." where("Document Type" = const(Order),
                                                                "Document Profile" = const("Spare Parts Trade"));
                }
                field(TransferOnlyStock; TransferOnlyStock)
                {
                    ApplicationArea = Basic;
                    Caption = 'Transfer Only Stock';
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
        if SalesOrderNo = '' then
            Error(Text001);
    end;

    var
        SalesOrderNo: Code[20];
        recSalesLine2: Record "Sales Line";
        recSalesLine3: Record "Sales Line";
        TransferOnlyStock: Boolean;
        Text001: label 'Please specify Service Order No.';


    procedure ReservedToStock(SalesLine: Record "Sales Line"): Decimal
    var
        ReservEntry: Record "Reservation Entry";
        ReservEntry2: Record "Reservation Entry";
        ResultQty: Decimal;
    begin
        ResultQty := 0;
        ReservEntry.Reset;
        ReservEntry.SetRange("Source Type", Database::"Sales Line");
        ReservEntry.SetRange("Source Subtype", 1);
        ReservEntry.SetRange("Source ID", SalesLine."Document No.");
        ReservEntry.SetRange("Source Ref. No.", SalesLine."Line No.");
        ReservEntry.SetRange("Reservation Status", ReservEntry."reservation status"::Reservation);
        if ReservEntry.Find('-') then
            repeat
                ReservEntry2.Reset;
                ReservEntry2.Get(ReservEntry."Entry No.", true);
                if ReservEntry2."Source Type" = Database::"Item Ledger Entry" then
                    ResultQty += ReservEntry2.Quantity;
            until ReservEntry.Next = 0;
        exit(ResultQty);
    end;
}

