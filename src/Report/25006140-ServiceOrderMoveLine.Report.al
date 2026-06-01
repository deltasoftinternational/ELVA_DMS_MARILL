Report 25006140 "Service Order-Move Line"
{
    // 09.10.2007. EDMS P2
    //   * Created

    Caption = 'Service Order-Move Line';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Service Line EDMS"; "Service Line EDMS")
        {
            DataItemTableView = sorting("Document Type", "Document No.", "Line No.");
            column(ReportForNavId_2689; 2689)
            {
            }

            trigger OnAfterGetRecord()
            var
                iLineNo: Integer;
                Window: Dialog;
                DiagText: label 'Quantity: #1#####\Quantity to Transfer: #2#####';
                QtyToTransfer: Decimal;
                ErrWrongValue: label 'Wrong Value!';
                QtyToTransferR: Decimal;
            begin
                CalcFields("Reserved Quantity");
                TestField("Document Type");
                TestField("Document No.");
                TestField("Bill-to Customer No.");
                TestField("Sell-to Customer No.");
                TestField("Prepmt. Line Amount", 0);
                //TESTFIELD("Reserved Quantity", 0);                                    // 21.12.2015 EB.P30

                ServOrdAlloc.Reset;
                ServOrdAlloc.SetRange("Document Type", "Document Type");
                ServOrdAlloc.SetRange("Document No.", "Document No.");
                ServOrdAlloc.SetRange("Document Line No.", "Line No.");
                if ServOrdAlloc.FindFirst then
                    Error(EDMS003);

                PartialTransfer := false;

                QtyToTransfer := Quantity;
                if PartialTransfer then begin
                    Window.Open(DiagText, Quantity, QtyToTransfer);
                    //Window.INPUT(2,QtyToTransfer); //FIXME
                    if (QtyToTransfer <= 0) or (QtyToTransfer > Quantity) then
                        Error(ErrWrongValue);
                    if QtyToTransfer = Quantity then
                        PartialTransfer := false;
                end;

                iLineNo := WriteLine(QtyToTransfer);

                // 21.12.2015 EB.P30 >>
                if Type = Type::Item then begin
                    ReservEntry.Reset;
                    ReservEntry.SetRange("Source Type", Database::"Service Line EDMS");
                    ReservEntry.SetRange("Source Subtype", 1);
                    ReservEntry.SetRange("Source ID", "Document No.");
                    ReservEntry.SetRange("Source Ref. No.", "Line No.");
                    ReservEntry.SetRange("Reservation Status", ReservEntry."reservation status"::Reservation);
                    if ReservEntry.Find('-') then
                        repeat
                            ReservEntry2.Reset;
                            ReservEntry2.Get(ReservEntry."Entry No.", true);
                            if ReservEntry2."Source Type" = Database::"Item Ledger Entry" then begin
                                ReservEntry."Source ID" := ServLine3."Document No.";
                                ReservEntry."Source Ref. No." := iLineNo;
                                ReservEntry.Modify;
                            end else begin
                                Object.Get(Object."Object Type"::Table, '', ReservEntry2."Source Type");
                                Error(EDMS004, Object."Object Name");
                            end;
                        until ReservEntry.Next = 0;
                end;
                // 21.12.2015 EB.P30 <<

                if PartialTransfer then begin
                    Validate(Quantity, Quantity - QtyToTransfer);
                    Modify;
                end
                else
                    Delete;
            end;

            trigger OnPreDataItem()
            var
                PurchHeader: Record "Purchase Header";
            begin
                StartProcess;
                IsSingleLine := false;
                IsSingleLine := (Count = 1);
            end;
        }
    }

    requestpage
    {

        layout
        {
            area(content)
            {
                field(ServiceOrderNo; ServiceOrderNo)
                {
                    ApplicationArea = Basic;
                    Caption = 'Service Order No.';
                    TableRelation = "Service Header EDMS"."No." where("Document Type" = const(Order));
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
        if ServiceOrderNo = '' then
            Error(EDMS002);
    end;

    var
        ServHdr: Record "Service Header EDMS";
        ServLine2: Record "Service Line EDMS";
        ServLine3: Record "Service Line EDMS";
        ServOrdAlloc: Record "Serv. Labor Alloc. Application";
        ServiceOrderNo: Code[20];
        IsSingleLine: Boolean;
        ConfirmTransferAll: label 'Do you want to transfer whole line?';
        PartialTransfer: Boolean;
        EDMS001: label 'There is not such service order!';
        EDMS002: label 'You have to choose order No.';
        EDMS003: label 'Not able to transfer because there are entries ir Scheduler!';
        ReservEntry: Record "Reservation Entry";
        ReservEntry2: Record "Reservation Entry";
        EDMS004: label 'No able to transfer bacause there are Reservation Entries against %1';
        RecRef: RecordRef;
        "Object": Record AllObjWithCaption;


    procedure StartProcess()
    begin
        ServHdr.Reset;
        if not ServHdr.Get(ServHdr."document type"::Order, ServiceOrderNo) then
            Error(EDMS001);

        ServLine2.Reset;
        ServLine2.SetRange("Document Type", ServLine2."document type"::Order);
        ServLine2.SetRange("Document No.", ServiceOrderNo);
        if not ServLine2.Find('-') then begin
            ServLine2.Init;
            ServLine2."Document Type" := ServLine2."document type"::Order;
            ServLine2."Document No." := ServiceOrderNo;
            ServLine2."Sell-to Customer No." := ServLine2."Sell-to Customer No.";
            ServLine2."Bill-to Customer No." := ServLine2."Bill-to Customer No.";
        end;

        ServLine3.TransferFields(ServLine2);
    end;


    procedure WriteLine(QtyToTransfer: Decimal): Integer
    var
        LineNo: Integer;
    begin
        LineNo := 0;
        if ServLine2.Find('+') then
            LineNo := ServLine2."Line No.";

        LineNo := LineNo + 10000;

        ServLine2.Init;
        ServLine2.TransferFields("Service Line EDMS");
        ServLine2."Document Type" := ServLine3."Document Type";
        ServLine2."Document No." := ServLine3."Document No.";
        ServLine2."Line No." := LineNo;
        ServLine2.Insert;
        ServLine2.SetRecreate(true);
        ServLine2.Validate("No.", ServLine2."No.");
        ServLine2.Validate(Quantity, QtyToTransfer);
        ServLine2.Modify;

        exit(LineNo);
    end;
}

