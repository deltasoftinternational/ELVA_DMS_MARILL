Page 25006442 "Rent Billing Worksheet"
{
    ApplicationArea = Basic;
    Caption = 'Rent Billing Worksheet';
    InsertAllowed = false;
    ModifyAllowed = true;
    PageType = Worksheet;
    SourceTable = "Rent Billing Worksheet Line";
    UsageCategory = Tasks;
    Editable = true;


    layout
    {
        area(content)
        {
            repeater(Group)
            {
                FreezeColumn = RentOrderNo;
                field("Process Line"; Rec."Process Line")
                {
                    ApplicationArea = Basic;
                }
                field(ToInvoice; Rec."To Invoice")
                {
                    ApplicationArea = Basic;

                }
                field(RentOrderNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Rent Order No.';
                    Editable = RowEditable;
                }
                field(RentType; Rec."Rent Type")
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }
                field(SelltoCustomerNo; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }
                field(SelltoCustomerName; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }
                field(DealType; Rec."Deal Type")
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }
                field(PeriodStartingDate; Rec."Period Starting Date")
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }
                field(PeriodEndingDate; Rec."Period Ending Date")
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }
                field(BilltoCustomerNo; Rec."Bill-to Customer No.")
                {
                    Visible = false;
                    ApplicationArea = Basic;
                    TableRelation = Customer;
                    Editable = RowEditable;
                }
                field(BilltoCustomerName; Rec."Bill-to Customer Name")
                {
                    Visible = false;
                    ApplicationArea = Basic;
                    TableRelation = Customer.Name;
                    Editable = RowEditable;
                }
                field(OvertimeCalculation; Rec."Overtime Calculation")
                {
                    Visible = false;
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    StyleExpr = StatusStyleExpression;
                    Editable = RowEditable;
                }
                field(LineNo; Rec."Line No.")
                {
                    Caption = 'Rent Line No.';
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }
                field(RentItemNo; Rec."Rent Item No.")
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }
                field("Rent Line Description"; Rec."Rent Line Description")
                {
                    ApplicationArea = Basic;
                }
                field(RentPeriodType; Rec."Rent Period Type")
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }
                field(RentAssetQuantity; Rec."Rent Asset Quantity")
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }
                field(Periods; Rec.Periods)
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                    DecimalPlaces = 0 : 5;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                    DecimalPlaces = 0 : 5;
                }
                field(UnitPrice; Rec."Unit Price")
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }
                field(RentStartDate; Rec."Rent Start Date")
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }
                field(RentEndDate; Rec."Rent End Date")
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }
                field(DimensionSetID; Rec."Dimension Set ID")
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }
                field(ActualShipmentDate; Rec."Actual Shipment Date")
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }
                field(ActualReturnDate; Rec."Actual Return Date")
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }
                field(LineAmount; Rec."Line Amount")
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }
                /*
                field(QtytoInvoice; "Qty. to Invoice")
                {
                    ApplicationArea = Basic;
                }
                */
                field(QuantityInvoiced; Rec."Quantity Invoiced")
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }
                field(PlannedShipmentDate; Rec."Planned Shipment Date")
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }
                field(PlannedReturnDate; Rec."Planned Return Date")
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }
                field(AttachedtoLineNo; Rec."Attached to Line No.")
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }
                field(RentAssetNo; Rec."Rent Asset No.")
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }
                field(LineDiscount; Rec."Line Discount %")
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }
                field(LineDiscountAmount; Rec."Line Discount Amount")
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }
                field(SerialNo; Rec."Serial No.")
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }
                field(ShortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }
                field(ShortcutDimCode3; ShortcutDimCode[3])
                {
                    ApplicationArea = Suite;
                    Visible = false;
                    Editable = RowEditable;

                }
                field(ShortcutDimCode4; ShortcutDimCode[4])
                {
                    ApplicationArea = Suite;
                    Visible = false;
                    Editable = RowEditable;
                }
                field(ShortcutDimCode5; ShortcutDimCode[5])
                {
                    ApplicationArea = Suite;
                    CaptionClass = '1,2,5';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(5),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    Visible = false;
                    Editable = RowEditable;


                }
                field(ShortcutDimCode6; ShortcutDimCode[6])
                {
                    ApplicationArea = Suite;
                    CaptionClass = '1,2,6';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(6),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    Visible = false;
                    Editable = RowEditable;

                }
                field(ShortcutDimCode7; ShortcutDimCode[7])
                {
                    ApplicationArea = Suite;
                    CaptionClass = '1,2,7';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(7),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    Visible = false;
                    Editable = RowEditable;

                }
                field(ShortcutDimCode8; ShortcutDimCode[8])
                {
                    ApplicationArea = Suite;
                    CaptionClass = '1,2,8';
                    TableRelation = "Dimension Value".Code where("Global Dimension No." = const(8),
                                                                  "Dimension Value Type" = const(Standard),
                                                                  Blocked = const(false));
                    Visible = false;
                    Editable = RowEditable;

                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }
                field(VFRun1From; Rec."VF Run 1 From")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun1Visible;
                    Editable = RowEditable;
                }
                field(VFRun1To; Rec."VF Run 1 To")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun2Visible;
                    Editable = RowEditable;
                }
                field(VFRun2From; Rec."VF Run 2 From")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun3Visible;
                    Editable = RowEditable;
                }
                field(VFRun2To; Rec."VF Run 2 To")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun4Visible;
                    Editable = RowEditable;
                }
                field(VFRun3From; Rec."VF Run 3 From")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun5Visible;
                    Editable = RowEditable;
                }
                field(VFRun3To; Rec."VF Run 3 To")
                {
                    ApplicationArea = Basic;
                    Visible = IsVFRun6Visible;
                    Editable = RowEditable;
                }
                field(LastDateInvoiced; Rec."Last Date Invoiced")
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }
                field("Quantity Shipped"; Rec."Quantity Shipped")
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }
                field("Quantity Returned"; Rec."Quantity Returned")
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }
                field("Unit of Measure Code"; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                    Editable = RowEditable;
                }

            }
        }
    }
    actions
    {
        area(processing)
        {
            action(OpenOrder)
            {
                ApplicationArea = Basic;
                Caption = 'Open Order';
                Ellipsis = true;
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Rent Order";
                RunPageLink = "No." = FIELD("Document No."), "Document Type" = FIELD("Document Type");

            }
            action(CalculateRentWkshtLines)
            {
                ApplicationArea = Basic;
                Caption = 'Calculate Rent Worksheet Lines';
                Ellipsis = true;
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Report.RunModal(Report::"Rent Calculate Worksheet Lines");
                    CurrPage.Update(true);
                    Message('Finished createing Rent Billint Worksheet Lines.');
                end;
            }

            action(AddSpecialChargeLine)
            {
                ApplicationArea = Basic;
                Caption = 'Add Special Charge Line';
                Ellipsis = true;
                Image = Create;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SpecialChargePage: Page "Rent Billing Special Charge";
                    RentWkshtLine: Record "Rent Billing Worksheet Line" temporary;
                    RentWkshtLineToInsert: Record "Rent Billing Worksheet Line";
                    RentWkshEntryNo: Integer;
                begin
                    RentWkshtLineToInsert.Reset();
                    if RentWkshtLineToInsert.FindLast() then
                        RentWkshEntryNo := RentWkshtLineToInsert."Entry No." + 1
                    else
                        RentWkshEntryNo := 1000;

                    RentWkshtLine.Init();
                    RentWkshtLine."Entry No." := RentWkshEntryNo;
                    RentWkshtLine."Document Type" := Rec."Document Type";
                    RentWkshtLine."Document No." := Rec."Document No.";
                    RentWkshtLine.Insert(true);

                    SpecialChargePage.LookupMode(true);
                    SpecialChargePage.Editable(true);
                    SpecialChargePage.SetRecord(RentWkshtLine);
                    SpecialChargePage.SetDefaults(RentWkshtLine);
                    if SpecialChargePage.RunModal() = ACTION::LookupOK then begin
                        SpecialChargePage.GetRecord(RentWkshtLine);
                        RentWkshtLineToInsert.Init();
                        RentWkshtLineToInsert := RentWkshtLine;
                        RentWkshtLineToInsert."Process Line" := true;
                        RentWkshtLineToInsert."To Invoice" := true;
                        RentWkshtLineToInsert.Insert(true);
                    end;
                end;
            }
            action(CalculateRentWkshtLinesReport)
            {
                ApplicationArea = Basic;
                Caption = 'Create Seperate Invoices Report';
                Ellipsis = true;
                Image = CreateDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Report.RunModal(Report::"Rent Create Invoices");
                    CurrPage.Update(true);
                    //Message('Finished createing Rent Billint Worksheet Lines.');
                end;
            }
            action(CalculateRentWkshtLinesCombinedReport)
            {
                ApplicationArea = Basic;
                Caption = 'Create Combined Invoices Report';
                Ellipsis = true;
                Image = CreateDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Report.RunModal(Report::"Rent Create Combined Invoices");
                    CurrPage.Update(true);
                    //Message('Finished createing Rent Billint Worksheet Lines.');
                end;
            }
            action(CreateSingleInvoices)
            {
                ApplicationArea = Basic;
                Caption = 'Create Seperate Invoices';
                Ellipsis = true;
                Image = CreateDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                var
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

                begin
                    RentWkshtLines.Reset();
                    //RentWkshtLines.SetRange("To Invoice", true);
                    RentWkshtLines.SetRange("Process Line", true);
                    RentOrdersCombined.DeleteAll();
                    if RentWkshtLines.FindFirst() then
                        repeat
                            if RentLine.Get(RentWkshtLines."Document Type", RentWkshtLines."Document No.", RentWkshtLines."Line No.") then begin
                                if not RentWkshtLines."Extra Charge Line" then begin
                                    RentHeader.Get(RentLine."Document Type", RentLine."Document No.");
                                    if RentHeader."Rent Type" = RentHeader."Rent Type"::"Open End Date" then
                                        if RentWkshtLines.Quantity + RentLine."Quantity Invoiced" > RentLine.Quantity then
                                            RentLine.Validate(Quantity, RentWkshtLines.Quantity + RentLine."Quantity Invoiced");
                                    RentLine."Qty. to Invoice" := RentWkshtLines.Quantity;
                                    RentLine.Modify(true);
                                end;
                                RentPost.GroupRentOrders(RentWkshtLines, RentOrdersCombined);
                            end;
                        until RentWkshtLines.Next() = 0;

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
                                    RentItem.Get(Rec."Rent Item No.");
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
                                    RentSalesLine."Vehicle Serial No." := Rec."Vehicle Serial No.";
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

                            InvoiceNoLast := RentPost.CreateInvoices(RentHeader, false, Today);
                            if InvoiceNoFirst = '' then
                                InvoiceNoFirst := InvoiceNoLast;


                            InvoicesCreated := true;
                        until RentOrdersCombined.Next() = 0;

                    //Delete processed worksheet lines
                    RentWkshtLines.Reset();
                    //RentWkshtLines.SetRange("To Invoice", true);
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
                    CurrPage.Update(true);
                end;
            }
            action(CreateInvoices)
            {
                ApplicationArea = Basic;
                Caption = 'Create Combined Invoices';
                Ellipsis = true;
                Image = CreateDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = false;

                trigger OnAction()
                var
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

                begin
                    RentWkshtLines.Reset();
                    //RentWkshtLines.SetRange("To Invoice", true);
                    RentWkshtLines.SetRange("Process Line", true);
                    if RentWkshtLines.FindFirst() then
                        repeat
                            if RentLine.Get(RentWkshtLines."Document Type", RentWkshtLines."Document No.", RentWkshtLines."Line No.") then begin
                                if not RentWkshtLines."Extra Charge Line" then begin
                                    RentHeader.Get(RentLine."Document Type", RentLine."Document No.");
                                    if RentHeader."Rent Type" = RentHeader."Rent Type"::"Open End Date" then
                                        if RentWkshtLines.Quantity + RentLine."Quantity Invoiced" > RentLine.Quantity then
                                            RentLine.Validate(Quantity, RentWkshtLines.Quantity + RentLine."Quantity Invoiced");

                                    RentLine."Qty. to Invoice" := RentWkshtLines.Quantity;
                                    RentLine.Modify(true);
                                end;
                                RentPost.GroupRentOrders(RentWkshtLines, RentOrdersCombined);
                            end;
                        until RentWkshtLines.Next() = 0;


                    //Call create rent sales lines
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
                                    RentItem.Get(Rec."Rent Item No.");
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
                                    RentSalesLine."Unit of Measure Code" := RentPeriod."Unit of Measure Code";

                                    RentSalesLine."Attached to Rent Line No." := RentWkshtLines."Line No.";
                                    RentSalesLine."Attach. to Rent Sales Line No." := RentWkshtLines."Attach. to Rent Sales Line No.";

                                    RentSalesLine.Validate("Rent Asset Quantity", RentWkshtLines."Rent Asset Quantity");
                                    RentSalesLine.Validate(Periods, RentWkshtLines.Periods);
                                    RentSalesLine.Validate(Quantity, RentWkshtLines.Quantity);

                                    RentSalesLine.Validate("Unit Price", RentWkshtLines."Unit Price");
                                    RentSalesLine.Validate("Line Discount %", RentWkshtLines."Line Discount %");

                                    RentSalesLine."Location Code" := RentWkshtLines."Location Code";
                                    RentSalesLine."Rent Item No." := RentWkshtLines."Rent Item No.";
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
                                    RentSalesLine."Unit of Measure Code" := RentWkshtLines."Unit of Measure Code";
                                    RentSalesLine."Vehicle Serial No." := RentWkshtLines."Vehicle Serial No.";

                                    //RentSalesLine."To Invoice" := RentWkshtLines."To Invoice";
                                    RentSalesLine."Extra Charge Line" := RentWkshtLines."Extra Charge Line";

                                    OnBeforeInsertRensSalesLine(RentSalesLine, RentWkshtLines);

                                    RentSalesLine.Insert(true);

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

                                            RentLine."Last Date Invoiced" := RentSalesLine."End Date";
                                            RentLine.Modify;
                                        end;
                                    end;
                                /*
                                if RentLine.Get(RentWkshtLines."Document Type", RentWkshtLines."Document No.", RentWkshtLines."Line No.") then begin
                                    if RentWkshtLines."Extra Charge Line" = true then
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

                        until RentOrdersCombined.Next() = 0;


                    //Call create rent invoice
                    RentWkshtLines.Reset();
                    RentPost.GroupRentOrderMerchants(RentWkshtLines, RentMerchantsCombined);
                    RentMerchantsCombined.Reset();
                    If RentMerchantsCombined.FindFirst() then
                        repeat

                            RentWkshtLines.Reset();
                            RentWkshtLines.SetRange("Process Line", true);
                            RentWkshtLines.SetRange("To Invoice", true);
                            RentWkshtLines.SetRange("Sell-to Customer No.", RentMerchantsCombined."Sell-to Customer No.");
                            RentWkshtLines.SetRange("Bill-to Customer No.", RentMerchantsCombined."Bill-to Customer No.");
                            RentOrdersCombined.DeleteAll();
                            if RentWkshtLines.FindFirst() then
                                repeat
                                    RentPost.GroupRentOrders(RentWkshtLines, RentOrdersCombined);
                                until RentWkshtLines.Next() = 0;

                            InvoiceNoLast := RentPost.CreateInvoiceByRentOrders(RentOrdersCombined, false, Today);
                            if InvoiceNoFirst = '' then
                                InvoiceNoFirst := InvoiceNoLast;

                            InvoicesCreated := true;

                        until RentMerchantsCombined.Next() = 0;

                    //Delete processed worksheet lines


                    RentWkshtLines.Reset();
                    RentWkshtLines.SetRange("Process Line", true);
                    //RentWkshtLines.SetRange("To Invoice", true);
                    if RentWkshtLines.FindFirst() then
                        repeat
                            RentWkshtLines.Delete();
                        until RentWkshtLines.Next() = 0;

                    RentPost.AutoPostRentInvoices(InvoiceNoFirst, InvoiceNoLast);

                    if InvoicesCreated then
                        Message('Sales Invoice for Rent Orders created.')
                    else
                        Message('Nothing to create.');
                    CurrPage.Update(true);
                end;
            }

        }
    }
    var
        BLSCreateInv: Report "BLS Create Invoices";
        InvCnt: Integer;
        SalesHeader: Record "Sales Header";
        NewInvoiceMsg: label 'Created %1 invoice(-s). Do You want open invoice list?';
        BLSCreateInvLease: Report "BLS Create Invoices Lease";
        StatusStyleExpression: Text[30];
        ShortcutDimCode: array[8] of Code[20];
        IsVFRun1Visible: Boolean;
        IsVFRun2Visible: Boolean;
        IsVFRun3Visible: Boolean;
        IsVFRun4Visible: Boolean;
        IsVFRun5Visible: Boolean;
        IsVFRun6Visible: Boolean;
        RowEditable: Boolean;


    trigger OnOpenPage()
    begin
        IsVFRun1Visible := Rec.IsVFActive(Rec.FieldNo("VF Run 1 From"));
        IsVFRun2Visible := Rec.IsVFActive(Rec.FieldNo("VF Run 1 To"));
        IsVFRun3Visible := Rec.IsVFActive(Rec.FieldNo("VF Run 2 From"));
        IsVFRun4Visible := Rec.IsVFActive(Rec.FieldNo("VF Run 2 To"));
        IsVFRun5Visible := Rec.IsVFActive(Rec.FieldNo("VF Run 3 From"));
        IsVFRun6Visible := Rec.IsVFActive(Rec.FieldNo("VF Run 3 To"));
    end;

    [IntegrationEvent(false, false)]
    local procedure OnBeforeInsertRensSalesLine(var RentSalesLine: Record "Rent Sales Line"; RentBillWkshLine: Record "Rent Billing Worksheet Line")
    begin
    end;

}

