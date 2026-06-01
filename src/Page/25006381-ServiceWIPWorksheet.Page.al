Page 25006381 "Service WIP Worksheet"
{
    ApplicationArea = Basic;
    PageType = List;
    SourceTable = "Service Order WIP Header";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            group(Control20)
            {
                Caption = 'Service Orders';
                repeater(Group)
                {
                    Caption = 'Service Orders';
                    field(ServiceOrderNo; Rec."Service Order No.")
                    {
                        ApplicationArea = Basic;
                    }
                    field(ServiceOrderDate; Rec."Service Order Date")
                    {
                        ApplicationArea = Basic;
                    }
                    field(SelltoCustomerNo; Rec."Sell-to Customer No.")
                    {
                        ApplicationArea = Basic;
                    }
                    field(SelltoCustomerName; Rec."Sell-to Customer Name")
                    {
                        ApplicationArea = Basic;
                    }
                    field(GenBusPostingGroup; Rec."Gen. Bus. Posting Group")
                    {
                        ApplicationArea = Basic;
                    }
                    field(Amount; Rec.Amount)
                    {
                        ApplicationArea = Basic;
                    }
                    field(WIPDate; Rec."WIP Date")
                    {
                        ApplicationArea = Basic;
                    }
                    field(BilltoCustomerNo; Rec."Bill-to Customer No.")
                    {
                        ApplicationArea = Basic;
                    }
                    field(BilltoName; Rec."Bill-to Name")
                    {
                        ApplicationArea = Basic;
                    }
                    field(LocationCode; Rec."Location Code")
                    {
                        ApplicationArea = Basic;
                    }
                    field(CurrencyCode; Rec."Currency Code")
                    {
                        ApplicationArea = Basic;
                    }
                    field(CurrencyFactor; Rec."Currency Factor")
                    {
                        ApplicationArea = Basic;
                    }
                    field(PricesIncludingVAT; Rec."Prices Including VAT")
                    {
                        ApplicationArea = Basic;
                    }
                    field(VIN; Rec.VIN)
                    {
                        ApplicationArea = Basic;
                    }
                    field(VehicleRegistrationNo; Rec."Vehicle Registration No.")
                    {
                        ApplicationArea = Basic;
                    }
                    field(MakeCode; Rec."Make Code")
                    {
                        ApplicationArea = Basic;
                    }
                    field(ModelCode; Rec."Model Code")
                    {
                        ApplicationArea = Basic;
                    }
                    field(VehicleSerialNo; Rec."Vehicle Serial No.")
                    {
                        ApplicationArea = Basic;
                    }
                    field(VehicleAccountingCycleNo; Rec."Vehicle Accounting Cycle No.")
                    {
                        ApplicationArea = Basic;
                    }
                    field(ItemCostAmt; Rec."Item Cost Amt.")
                    {
                        ApplicationArea = Basic;
                    }
                    field(ItemSalesAmt; Rec."Item Sales Amt.")
                    {
                        ApplicationArea = Basic;
                    }
                    field(LaborCostAmt; Rec."Labor Cost Amt.")
                    {
                        ApplicationArea = Basic;
                    }
                    field(LaborSalesAmt; Rec."Labor Sales Amt.")
                    {
                        ApplicationArea = Basic;
                    }
                    field(ExtSCostAmt; Rec."Ext. S. Cost Amt.")
                    {
                        ApplicationArea = Basic;
                    }
                    field(ExtSSalesAmt; Rec."Ext. S. Sales Amt.")
                    {
                        ApplicationArea = Basic;
                    }
                    field(TotalCostAmt; Rec."Total Cost Amt.")
                    {
                        ApplicationArea = Basic;
                    }
                    field(TotalSalesAmt; Rec."Total Sales Amt.")
                    {
                        ApplicationArea = Basic;
                    }
                }
            }
            part(Control9; "Service WIP Worksheet Lines")
            {
                ApplicationArea = All;
                SubPageLink = "Service Order No." = field("Service Order No.");
            }
        }
        area(factboxes)
        {
            part(Control15; "Service WIP Document Totals")
            {
                ApplicationArea = All;
                SubPageLink = "Service Order No." = field("Service Order No.");
            }
            part(Control17; "Service WIP Actual Totals")
            {
                ApplicationArea = All;
                SubPageLink = "Service Order No." = field("Service Order No.");
                SubPageView = where(Reversed = const(false));
            }
        }
    }

    actions
    {
        area(processing)
        {
            group(ActionGroup3)
            {
                action("Generate WIP")
                {
                    ApplicationArea = Basic;
                    Caption = 'Generate WIP Worksheet Lines';

                    trigger OnAction()
                    var
                        WIPCalculation: Report "Service WIP Calculate";
                    begin
                        WIPCalculation.RunModal;
                    end;
                }
                action("Recalculate WIP Amounts")
                {
                    ApplicationArea = Basic;
                    Caption = 'Recalculate WIP Amounts';

                    trigger OnAction()
                    var
                        WIPRecalculation: Report "Service WIP Recalculate";
                        WIPServiceOrderHeader: Record "Service Order WIP Header";
                    begin
                        WIPServiceOrderHeader.Reset;
                        if Rec.GetFilters <> '' then
                            WIPServiceOrderHeader.CopyFilters(Rec)
                        else
                            WIPServiceOrderHeader.SetRange("Service Order No.", Rec."Service Order No.");
                        WIPRecalculation.SetTableview(WIPServiceOrderHeader);
                        WIPRecalculation.RunModal;
                    end;
                }
                action("Post WIP")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post WIP';

                    trigger OnAction()
                    var
                        WIPPost: Report "Service WIP Post to G/L";
                        WIPServiceOrderHeader: Record "Service Order WIP Header";
                    begin
                        WIPServiceOrderHeader.Reset;
                        if Rec.GetFilters <> '' then
                            WIPServiceOrderHeader.CopyFilters(Rec)
                        else
                            WIPServiceOrderHeader.SetRange("Service Order No.", Rec."Service Order No.");
                        WIPPost.SetTableview(WIPServiceOrderHeader);
                        WIPPost.RunModal;
                    end;
                }
            }
        }
        area(navigation)
        {
            group(ActionGroup18)
            {
                action("Show Actual WIP Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Actual WIP Entries';
                    RunObject = Page "Service WIP Entries";
                    RunPageLink = "Service Order No." = field("Service Order No.");
                    RunPageView = where(Reversed = const(false));
                }
                action("Show Actual WIP G/L Entries")
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Actual WIP G/L Entries';

                    trigger OnAction()
                    var
                        WIPTotal: Record "Service WIP Total";
                        GLEntries: Record "G/L Entry";
                        GLEntriesPage: Page "General Ledger Entries";
                        SourceCodeSetup: Record "Source Code Setup";
                    begin
                        SourceCodeSetup.Get;
                        WIPTotal.Reset;
                        WIPTotal.SetRange(Reversed, false);
                        WIPTotal.SetRange("Service Order No.", Rec."Service Order No.");
                        if WIPTotal.FindFirst then begin
                            GLEntries.Reset;
                            GLEntries.SetRange("Document No.", WIPTotal."Document No.");
                            GLEntries.SetRange("Source Code", SourceCodeSetup."Service G/L WIP EDMS");
                            GLEntriesPage.SetTableview(GLEntries);
                            GLEntriesPage.RunModal;
                        end;
                    end;
                }
            }
        }
    }
}

