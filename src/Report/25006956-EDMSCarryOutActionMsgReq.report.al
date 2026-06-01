report 25006956 "EDMS CarryOut Action Msg.-Req."//493
{
    // 28.08.2018 EB.P30 EDMS
    //   Added option:
    //     "Combine Class 1 orders"
    // 
    // 26.02.2010 EDMS P2
    //   * Added code UseOneJnl
    //   * Added field in Request Form

    Caption = 'Carry Out Action Msg. - Req.';
    ProcessingOnly = true;

    dataset
    {
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
                    field(PrintOrders; PrintOrders)
                    {
                        ApplicationArea = Planning;
                        Caption = 'Print Orders';
                        ToolTip = 'Specifies whether to print the purchase orders after they are created.';
                    }
                    field(CombineClassOrders; CombineClassOrders)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Combine Class 1 orders';
                    }
                }
            }
        }

        actions
        {
        }

        trigger OnOpenPage()
        begin
            PurchOrderHeader."Order Date" := WorkDate;
            PurchOrderHeader."Posting Date" := WorkDate;
            if ReqWkshTmpl.Recurring then
                EndOrderDate := WorkDate
            else
                EndOrderDate := 0D;
        end;
    }

    labels
    {
    }

    trigger OnPreReport()
    begin
        OnBeforePreReport(PrintOrders);

        UseOneJnl(ReqLine);
    end;

    trigger OnPostReport()
    begin
        OnBeforePostReport(ReqWkshMakeOrders);
    end;

    var
        Text000: Label 'cannot be filtered when you create orders';
        Text001: Label 'There is nothing to create.';
        Text003: Label 'You are now in worksheet %1.';
        ReqWkshTmpl: Record "Req. Wksh. Template";
        ReqWkshName: Record "Requisition Wksh. Name";
        ReqLine: Record "Requisition Line";
        PurchOrderHeader: Record "Purchase Header";
        ReqWkshMakeOrders: Codeunit "EDMS Req. Wksh.-Make Order";
        EndOrderDate: Date;
        PrintOrders: Boolean;
        TempJnlBatchName: Code[10];
        HideDialog: Boolean;
        SuppressCommit: Boolean;
        ConvertReservation: Boolean;
        CombineClassOrders: Boolean;

    procedure SetReqWkshLine(var NewReqLine: Record "Requisition Line")
    begin
        ReqLine.Copy(NewReqLine);
        ReqWkshTmpl.Get(NewReqLine."Worksheet Template Name");

        OnAfterSetReqWkshLine(NewReqLine);
    end;

    procedure GetReqWkshLine(var NewReqLine: Record "Requisition Line")
    begin
        NewReqLine.Copy(ReqLine);
    end;

    procedure SetReqWkshName(var NewReqWkshName: Record "Requisition Wksh. Name")
    begin
        ReqWkshName.Copy(NewReqWkshName);
        ReqWkshTmpl.Get(NewReqWkshName."Worksheet Template Name");
    end;

    local procedure UseOneJnl(var ReqLine: Record "Requisition Line")
    begin
        ReqWkshTmpl.Get(ReqLine."Worksheet Template Name");
        if ReqWkshTmpl.Recurring and (ReqLine.GetFilter("Order Date") <> '') then
            ReqLine.FieldError("Order Date", Text000);
        TempJnlBatchName := ReqLine."Journal Batch Name";
        OnUseOneJnlOnBeforeSetReqWkshMakeOrdersParameters(ReqLine, ReqWkshMakeOrders, PurchOrderHeader, EndOrderDate, PrintOrders);
        ReqWkshMakeOrders.SetDocProfile(ReqWkshTmpl."Document Profile"); //25.02.2008 EDMS P1
        ReqWkshMakeOrders.Set(PurchOrderHeader, EndOrderDate, PrintOrders, CombineClassOrders);
        ReqWkshMakeOrders.SetSuppressCommit(SuppressCommit);
        ReqWkshMakeOrders.CarryOutBatchAction(ReqLine);

        //26.02.2010 EDMS P2 >>
        if ConvertReservation then
            ReqWkshMakeOrders.SetConvertReservation;
        //26.02.2010 EDMS P2 <<

        if ReqLine."Line No." = 0 then
            Message(Text001)
        else
            if not HideDialog then
                if TempJnlBatchName <> ReqLine."Journal Batch Name" then
                    Message(
                      Text003,
                      ReqLine."Journal Batch Name");

        if not ReqLine.Find('=><') or (TempJnlBatchName <> ReqLine."Journal Batch Name") then begin
            ReqLine.Reset;
            ReqLine.FilterGroup := 2;
            ReqLine.SetRange("Worksheet Template Name", ReqLine."Worksheet Template Name");
            ReqLine.SetRange("Journal Batch Name", ReqLine."Journal Batch Name");
            ReqLine.FilterGroup := 0;
            ReqLine."Line No." := 1;
        end;
    end;

    procedure InitializeRequest(ExpirationDate: Date; OrderDate: Date; PostingDate: Date; ExpectedReceiptDate: Date; YourRef: Text[50])
    begin
        EndOrderDate := ExpirationDate;
        PurchOrderHeader."Order Date" := OrderDate;
        PurchOrderHeader."Posting Date" := PostingDate;
        PurchOrderHeader."Expected Receipt Date" := ExpectedReceiptDate;
        PurchOrderHeader."Your Reference" := YourRef;
    end;

    procedure SetHideDialog(NewHideDialog: Boolean)
    begin
        HideDialog := NewHideDialog;
    end;

    procedure SetSupressCommit(NewSupressCommit: Boolean)
    begin
        SuppressCommit := NewSupressCommit;
    end;

    [IntegrationEvent(false, false)]
    local procedure OnAfterSetReqWkshLine(var RequisitionLine: Record "Requisition Line")
    begin
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnBeforePreReport(var PrintOrders: Boolean)
    begin
    end;

    [IntegrationEvent(TRUE, false)]
    local procedure OnBeforePostReport(var ReqWkshMakeOrders: Codeunit "EDMS Req. Wksh.-Make Order")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnUseOneJnlOnBeforeSetReqWkshMakeOrdersParameters(var ReqLine: Record "Requisition Line"; var ReqWkshMakeOrders: Codeunit "EDMS Req. Wksh.-Make Order"; PurchOrderHeader: Record "Purchase Header"; EndOrderDate: Date; PrintOrders: Boolean)
    begin
    end;
}

