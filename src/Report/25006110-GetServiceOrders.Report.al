Report 25006110 "Get Service Orders"
{
    Caption = 'Get Service Orders';
    ProcessingOnly = true;

    dataset
    {
        dataitem("Service Line EDMS"; "Service Line EDMS")
        {
            DataItemTableView = where("Document Type" = const(Order), Type = const(Item), "Purch. Order Line No." = const(0), "Outstanding Quantity" = filter(<> 0));
            RequestFilterFields = "Document No.", "Sell-to Customer No.", "No.";
            RequestFilterHeading = 'Sales Order Line';
            column(ReportForNavId_2689; 2689)
            {
            }

            trigger OnAfterGetRecord()
            begin
                if ("Purchasing Code" = '') and (SpecOrder <> 1) then
                    if "Drop Shipment" then begin
                        LineCount := LineCount + 1;
                        Window.Update(1, LineCount);
                        InsertReqWkshLine("Service Line EDMS");
                    end;

                if "Purchasing Code" <> '' then
                    if PurchasingCode.Get("Purchasing Code") then
                        if (PurchasingCode."Drop Shipment") and (SpecOrder <> 1) then begin
                            LineCount := LineCount + 1;
                            Window.Update(1, LineCount);
                            InsertReqWkshLine("Service Line EDMS");
                        end else
                            if (PurchasingCode."Special Order") and
                               ("Special Order Purchase No." = '') and
                               (SpecOrder <> 0)
                            then begin
                                LineCount := LineCount + 1;
                                Window.Update(1, LineCount);
                                InsertReqWkshLine("Service Line EDMS");
                            end;
            end;

            trigger OnPostDataItem()
            begin
                if LineCount = 0 then
                    Error(Text001);
            end;
        }
    }

    requestpage
    {
        SaveValues = true;

        layout
        {
            area(content)
            {
                group(Options)
                {
                    Caption = 'Options';
                    field(GetDim; GetDim)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Retrieve dimensions from';
                        OptionCaption = 'Item,Sales Line';
                    }
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
        ReqWkshTmpl.Get(ReqLine."Worksheet Template Name");
        ReqWkshName.Get(ReqLine."Worksheet Template Name", ReqLine."Journal Batch Name");
        ReqLine.SetRange("Worksheet Template Name", ReqLine."Worksheet Template Name");
        ReqLine.SetRange("Journal Batch Name", ReqLine."Journal Batch Name");
        ReqLine.LockTable;
        if ReqLine.Find('+') then begin
            ReqLine.Init;
            LineNo := ReqLine."Line No.";
        end;
        Window.Open(Text000);
    end;

    var
        Text000: label 'Processing sales lines  #1######';
        Text001: label 'There are no sales lines to retrieve.';
        ReqWkshTmpl: Record "Req. Wksh. Template";
        ReqWkshName: Record "Requisition Wksh. Name";
        ReqLine: Record "Requisition Line";
        ServiceHeader: Record "Service Header EDMS";
        PurchasingCode: Record Purchasing;
        ItemTrackingMgt: Codeunit "Item Tracking Management";
        LeadTimeMgt: Codeunit "Lead-Time Management";
        Window: Dialog;
        LineCount: Integer;
        SpecOrder: Integer;
        GetDim: Option Item,"Sales Line";
        LineNo: Integer;


    procedure SetReqWkshLine(NewReqLine: Record "Requisition Line"; SpecialOrder: Integer)
    begin
        ReqLine := NewReqLine;
        SpecOrder := SpecialOrder;
    end;

    local procedure InsertReqWkshLine(ServiceLine: Record "Service Line EDMS")
    begin
        ReqLine.Reset;
        ReqLine.SetCurrentkey(Type, "No.");
        ReqLine.SetRange(Type, "Service Line EDMS".Type);
        ReqLine.SetRange("No.", "Service Line EDMS"."No.");
        ReqLine.SetRange("Service Order No.", "Service Line EDMS"."Document No.");
        ReqLine.SetRange("Service Order Line No.", "Service Line EDMS"."Line No.");
        if ReqLine.Find('-') then
            exit;

        LineNo := LineNo + 10000;
        ReqLine.Init;
        ReqLine."Worksheet Template Name" := ReqWkshName."Worksheet Template Name";
        ReqLine."Journal Batch Name" := ReqWkshName.Name;
        ReqLine."Line No." := LineNo;
        ReqLine.Validate(Type, ServiceLine.Type);
        ReqLine.Validate("No.", ServiceLine."No.");
        ReqLine."Variant Code" := ServiceLine."Variant Code";
        //<<DELTA BCH 03/02/2021
        //Validate("Location Code", ServiceLine."Location Code");
        if ServiceLine."Transfer From Location Code" <> '' then
            ReqLine.Validate("Location Code", ServiceLine."Transfer From Location Code")
        else
            ReqLine.Validate("Location Code", ServiceLine."Location Code");
        //"Bin Code" := ServiceLine."Bin Code";
        ReqLine."Document Profile" := ReqLine."Document Profile"::"Spare Parts Trade";
        //>>DELTA BCH 03/02/2021


        // Drop Shipment means replenishment by purchase only
        if (ReqLine."Replenishment System" <> ReqLine."replenishment system"::Purchase) and
           ServiceLine."Drop Shipment"
        then
            ReqLine.Validate("Replenishment System", ReqLine."replenishment system"::Purchase);

        if SpecOrder <> 1 then
            ReqLine.Validate("Unit of Measure Code", ServiceLine."Unit of Measure Code");
        ReqLine.Validate(
          Quantity,
          ROUND(ServiceLine."Outstanding Quantity" * ServiceLine."Qty. per Unit of Measure" / ReqLine."Qty. per Unit of Measure", 0.00001));
        ReqLine."Service Order No." := ServiceLine."Document No.";
        ReqLine."Service Order Line No." := ServiceLine."Line No.";
        ReqLine."Sell-to Customer No." := ServiceLine."Sell-to Customer No.";
        ServiceHeader.Get(1, ServiceLine."Document No.");
        ReqLine."Item Category Code" := ServiceLine."Item Category Code";
        ReqLine.Nonstock := ServiceLine.Nonstock;
        ReqLine."Action Message" := ReqLine."action message"::New;
        //"Product Group Code" := ServiceLine."Product Group Code";
        ReqLine."Purchasing Code" := ServiceLine."Purchasing Code";
        // Backward Scheduling
        ReqLine."Due Date" := ServiceLine."Shipment Date";
        ReqLine."Ending Date" :=
          LeadTimeMgt.GetPlannedEndingDate(
            ReqLine."No.", ReqLine."Location Code", ReqLine."Variant Code", ReqLine."Due Date", ReqLine."Vendor No.", ReqLine."Ref. Order Type");
        ReqLine.CalcStartingDate('');
        ReqLine.UpdateDatetime;

        ReqLine.Insert;
        ItemTrackingMgt.CopyItemTracking(ServiceLine.RowID1, ReqLine.RowID1, true);
        if GetDim = Getdim::"Sales Line" then begin

            ReqLine."Shortcut Dimension 1 Code" := ServiceLine."Shortcut Dimension 1 Code";
            ReqLine."Shortcut Dimension 2 Code" := ServiceLine."Shortcut Dimension 2 Code";
            ReqLine.Modify;


        end;
        OnAfterInsertReqWkshLine(ReqLine, ServiceLine);
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterInsertReqWkshLine(ReqLine: Record "Requisition Line"; ServiceLine: Record "Service Line EDMS")
    begin
    end;
}

