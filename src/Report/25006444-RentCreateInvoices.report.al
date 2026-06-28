report 25006000 "Rent Create Invoices"
{
    Caption = 'Rent Create Invoices';
    ProcessingOnly = true;

    dataset
    {
        dataitem(RentBillingWkshtLines; "Rent Billing Worksheet Line")
        {

            trigger OnPreDataItem()
            begin
                //>>DELTA XX
                OnApplyingFilterOnPreDataItem(RentBillingWkshtLines);
                //DELTA XX
            end;

            trigger OnAfterGetRecord()
            begin

                If RentBillingWkshtLines."Process Line" = false then
                    CurrReport.Skip;

                if RentLine.Get(RentBillingWkshtLines."Document Type", RentBillingWkshtLines."Document No.", RentBillingWkshtLines."Line No.") then begin
                    if not RentBillingWkshtLines."Extra Charge Line" then begin
                        RentHeader.Get(RentLine."Document Type", RentLine."Document No.");
                        if RentHeader."Rent Type" = RentHeader."Rent Type"::"Open End Date" then
                            if RentBillingWkshtLines.Quantity + RentLine."Quantity Invoiced" > RentLine.Quantity then
                                RentLine.Validate(Quantity, RentBillingWkshtLines.Quantity + RentLine."Quantity Invoiced");
                        RentLine."Qty. to Invoice" := RentBillingWkshtLines.Quantity;
                        RentLine.Modify(true);
                    end;
                end;
                RentPost.GroupRentOrders(RentBillingWkshtLines, RentOrdersCombined);
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
                group(Parameters)
                {
                    Caption = 'Parameters';
                    field(InvoiceDate;
                    InvoiceDate)
                    {
                        ApplicationArea = Basic;
                        Caption = 'Invoice Date';
                    }
                }
            }
        }
        actions
        {
        }
    }


    trigger OnPreReport()
    begin
        RentOrdersCombined.DeleteAll();
    end;

    trigger OnPostReport()
    begin

        //Call create rent sales lines and Sales Invoice
        RentOrdersCombined.Reset();
        if RentOrdersCombined.FindFirst() then
            repeat
                RentHeader.Get(RentOrdersCombined."Document Type", RentOrdersCombined."Document No.");

                RentWkshtLines.Reset();
                RentWkshtLines.SetRange("Document Type", RentOrdersCombined."Document Type");
                RentWkshtLines.SetRange("Document No.", RentOrdersCombined."Document No.");
                //RentWkshtLines.SetRange("To Invoice", true);
                RentWkshtLines.SetRange("Process Line", true);
                if RentWkshtLines.FindFirst() then
                    repeat
                        if RentWkshtLines."Rent Sales Line No." = 0 then begin
                            if RentItem.Get(RentWkshtLines."Rent Item No.") then
                                RentItem.TestField("Resource No.");
                            //Create sales line
                            RentSalesLine.Reset;
                            RentSalesLine.SetRange("Document Type", RentWkshtLines."Document Type");
                            RentSalesLine.SetRange("Document No.", RentWkshtLines."Document No.");
                            if RentSalesLine.FindLast then
                                LineNo := RentSalesLine."Line No." + 10000
                            else
                                LineNo := 10000;

                            RentSalesLine.Init;
                            RentSalesLine."Document Type" := RentWkshtLines."Document Type";
                            RentSalesLine."Document No." := RentWkshtLines."Document No.";
                            RentSalesLine."Line No." := LineNo;
                            RentSalesLine.Type := RentWkshtLines.Type;
                            RentSalesLine.Validate("No.", RentWkshtLines."No.");
                            RentSalesLine.Description := RentWkshtLines.Description;
                            RentSalesLine."Unit of Measure Code" := RentWkshtLines."Unit of Measure Code";

                            RentSalesLine."Attached to Rent Line No." := RentWkshtLines."Line No.";
                            RentSalesLine."Attach. to Rent Sales Line No." := RentWkshtLines."Attach. to Rent Sales Line No.";

                            RentSalesLine.Validate("Rent Asset Quantity", RentWkshtLines."Rent Asset Quantity");
                            RentSalesLine.Validate(Periods, RentWkshtLines.Periods);
                            RentSalesLine.Validate(Quantity, RentWkshtLines.Quantity);

                            RentSalesLine.Validate("Unit Price", RentWkshtLines."Unit Price");
                            RentSalesLine.Validate("Line Discount %", RentWkshtLines."Line Discount %");

                            RentSalesLine."Location Code" := RentWkshtLines."Location Code";
                            RentSalesLine."Rent Item No." := RentWkshtLines."Rent Item No.";
                            RentSalesLine."Vehicle Serial No." := RentWkshtLines."Vehicle Serial No.";
                            RentSalesLine."Shortcut Dimension 1 Code" := RentWkshtLines."Shortcut Dimension 1 Code";
                            RentSalesLine."Shortcut Dimension 2 Code" := RentWkshtLines."Shortcut Dimension 2 Code";
                            RentSalesLine."Start Date" := RentWkshtLines."Period Starting Date";
                            RentSalesLine."End Date" := RentWkshtLines."Period Ending Date";
                            RentSalesLine."Dimension Set ID" := RentWkshtLines."Dimension Set ID";
                            RentSalesLine."VF Run 1 From" := RentWkshtLines."VF Run 1 From";
                            RentSalesLine."VF Run 2 From" := RentWkshtLines."VF Run 2 From";
                            RentSalesLine."VF Run 3 From" := RentWkshtLines."VF Run 3 From";
                            RentSalesLine."VF Run 1 To" := RentWkshtLines."VF Run 1 To";
                            RentSalesLine."VF Run 2 To" := RentWkshtLines."VF Run 2 To";
                            RentSalesLine."VF Run 3 To" := RentWkshtLines."VF Run 3 To";

                            //RentSalesLine."To Invoice" := RentWkshtLines."To Invoice";
                            RentSalesLine."Extra Charge Line" := RentWkshtLines."Extra Charge Line";

                            OnBeforeInsertRensSalesLine(RentSalesLine, RentWkshtLines);

                            RentSalesLine.Insert(true);
                        end else begin
                            RentSalesLine.Get(RentWkshtLines."Document Type", RentWkshtLines."Document No.", RentWkshtLines."Rent Sales Line No.")
                        end;


                        if not RentWkshtLines."To Invoice" then
                            RentSalesLine."To Invoice" := RentWkshtLines."To Invoice";
                        RentSalesLine.Modify(true);

                        //Update Rent Line Quantity to invoice fields
                        if not RentWkshtLines."Extra Charge Line" then begin
                            if RentLine.Get(RentWkshtLines."Document Type", RentWkshtLines."Document No.", RentWkshtLines."Line No.") then begin
                                RentLine."Quantity Invoiced" := RentLine.GetQuantityInvoiced();
                                if RentLine.Quantity <> RentLine."Quantity Invoiced" then
                                    RentLine."Qty. to Invoice" := RentLine.Quantity - RentLine."Quantity Invoiced"
                                else
                                    RentLine."Qty. to Invoice" := 0;

                                //>>DELTA XX
                                OnBeforeUpdateLastInvoiceDateForSingleInvoices(ishandled);
                                if isHandled = false then
                                    //<<DELTA XX
                                    RentLine."Last Date Invoiced" := RentSalesLine."End Date";
                                RentLine.Modify;
                            end;
                        end;


                    /*
                    if RentLine.Get(RentWkshtLines."Document Type", RentWkshtLines."Document No.", RentWkshtLines."Line No.") then begin
                        if RentWkshtLines."Extra Charge Line" = true then
                            if RentHeader."Overtime Calculation" = RentHeader."Overtime Calculation"::"Total Period" then
                                RentLine.CreateExtraChargeLines(RentWkshtLines."Period Ending Date")
                        else
                            RentLine.CreateSalesLine(RentWkshtLines."Period Ending Date");
                    end else begin
                        if RentWkshtLines."Rent Sales Line No." = 0 then begin
                            //Cretae special charge line
                            RentLine.CreateSpecialChargeSalesLine(RentWkshtLines);
                        end;
                    end;
                    */
                    until RentWkshtLines.Next() = 0;

                InvoiceNoLast := RentPost.CreateInvoices(RentHeader, false, InvoiceDate);
                if InvoiceNoFirst = '' then
                    InvoiceNoFirst := InvoiceNoLast;

                InvoicesCreated := true;
            until RentOrdersCombined.Next() = 0;

        //Delete processed worksheet lines
        RentWkshtLines.Reset();
        //RentWkshtLines.SetRange("To Invoice", true);
        //>>DELTA XX
        OnApplyingFilterOnPreDataItem(RentWkshtLines);
        //DELTA XX
        RentWkshtLines.SetRange("Process Line", true);
        if RentWkshtLines.FindFirst() then
            repeat
                RentWkshtLines.Delete();
            until RentWkshtLines.Next() = 0;

        RentPost.AutoPostRentInvoices(InvoiceNoFirst, InvoiceNoLast);

        if InvoicesCreated then
            Message('Sales Invoice for Rent Orders created.')
        else
            Message('Nothing to create.');
        //CurrPage.Update(true);
    end;

    var
        CompanyInfo: Record "Company Information";
        DateEmptyErr: label 'Invoice date is empty.';
        NoSerieEmptyErr: label 'No. serie is empty.';
        DueDateBeforeInvDateErr: label 'Invoice date %1 is after Due Date %2';
        NothingCreatedTxt: label 'None invoice created.';
        NewInvoiceMsg: label 'Created %1 invoice(-s). Do You want open invoice list?';
        WindowTxt: label 'Worksheet processing  @1@@@@@@@@@@@@@@\Creating Invoices     @2@@@@@@@@@@@@@@';
        Window: Dialog;
        RentWkshtLines: Record "Rent Billing Worksheet Line";
        RentLine: Record "Rent Line";
        RentHeader: Record "Rent Header";
        RentPost: Codeunit "Rent-Post";
        InvoicesCreated: Boolean;
        RentMerchantsCombined: Record "Rent Billing Worksheet Line" temporary;
        RentOrdersCombined: Record "Rent Billing Worksheet Line" temporary;
        RentSalesLine: Record "Rent Sales Line";
        LineNo: Integer;
        RentItem: Record "Rent Item";
        RentPeriod: Record "Rent Period";
        InvoiceNoFirst: Code[20];
        InvoiceNoLast: Code[20];
        InvoiceDate: Date;
        isHandled: Boolean;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertRensSalesLine(var RentSalesLine: Record "Rent Sales Line"; RentBillWkshLine: Record "Rent Billing Worksheet Line")
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeUpdateLastInvoiceDateForSingleInvoices(var IsHandled: Boolean)
    begin
    end;

    [IntegrationEvent(false, false)]
    local procedure OnApplyingFilterOnPreDataItem(Var RentWorkSheetHeader: Record "Rent Billing Worksheet Line")
    begin

    end;



}

