Page 25006432 "BLS Calculation Worksheet"
{
    ApplicationArea = Basic;
    Caption = 'Calculation Worksheet';
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "BLS Calculation Worksheet Line";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(CustomerNo; Rec."Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field(CustomerName; Rec."Customer Name")
                {
                    ApplicationArea = Basic;
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field(ContractNo; Rec."Contract No.")
                {
                    ApplicationArea = Basic;
                }
                field(LineType; Rec."Line Type")
                {
                    ApplicationArea = Basic;
                }
                field(ExternalContractNo; Rec."External Contract No.")
                {
                    ApplicationArea = Basic;
                }
                field(ServiceCode; Rec."Service Code")
                {
                    ApplicationArea = Basic;
                }
                field(ServiceDescription; Rec."Service Description")
                {
                    ApplicationArea = Basic;
                }
                field(ObjectCode; Rec."Object Code")
                {
                    ApplicationArea = Basic;
                }
                field(ObjectName; Rec."Object Name")
                {
                    ApplicationArea = Basic;
                }
                field(PeriodStartingDate; Rec."Period Starting Date")
                {
                    ApplicationArea = Basic;
                }
                field(PeriodEndingDate; Rec."Period Ending Date")
                {
                    ApplicationArea = Basic;
                }
                field(StartingDate; Rec."Starting Date")
                {
                    ApplicationArea = Basic;
                }
                field(EndingDate; Rec."Ending Date")
                {
                    ApplicationArea = Basic;
                }
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(UnitPrice; Rec."Unit Price")
                {
                    ApplicationArea = Basic;
                }
                field(TotalPrice; Rec."Total Price")
                {
                    ApplicationArea = Basic;
                }
                field(Discount; Rec."Discount, %")
                {
                    ApplicationArea = Basic;
                }
                field(DiscountAmount; Rec."Discount Amount")
                {
                    ApplicationArea = Basic;
                }
                field(TotalPriceInclDiscount; Rec."Total Price Incl. Discount")
                {
                    ApplicationArea = Basic;
                }
                field(CalculationPeriodCode; Rec."Calculation Period Code")
                {
                    ApplicationArea = Basic;
                }
                field(InvoiceGroupCode; Rec."Invoice Group Code")
                {
                    ApplicationArea = Basic;
                }
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(BaseUnitPrice; Rec."Base Unit Price")
                {
                    ApplicationArea = Basic;
                }
                field(BaseUnitPriceInclDiscount; Rec."Base Unit Price Incl. Discount")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field(VehMakeCode; Rec."Veh. Make Code")
                {
                    ApplicationArea = Basic;
                }
                field(VehModelCode; Rec."Veh. Model Code")
                {
                    ApplicationArea = Basic;
                }
                field(VehModelVersionNo; Rec."Veh. Model Version No.")
                {
                    ApplicationArea = Basic;
                }
                field(VIN; Rec.VIN)
                {
                    ApplicationArea = Basic;
                }
                field(LeasingScheduleNo; Rec."Leasing Schedule No.")
                {
                    ApplicationArea = Basic;
                }
                field(LeasingScheduleLineNo; Rec."Leasing Schedule Line No.")
                {
                    ApplicationArea = Basic;
                }
                field(LeasingScheduleBase; Rec."Lease Base Amount")
                {
                    ApplicationArea = Basic;
                }
                field(LeasingScheduleInterest; Rec."Lease Interest Amount")
                {
                    ApplicationArea = Basic;
                }
                field(LeasingScheduleTotal; Rec."Lease Total Amount")
                {
                    ApplicationArea = Basic;
                }
                field(AddServAmt; Rec."Additional Service Amount")
                {
                    ApplicationArea = Basic;
                }
                field("BLS Service Ledger Entry No."; Rec."BLS Service Ledger Entry No.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(CalculateServices)
            {
                ApplicationArea = Basic;
                Caption = 'Calculate Services';
                Ellipsis = true;
                Image = Calculate;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    Report.RunModal(Report::"BLS Calculate Services");
                    CurrPage.Update(true);
                end;
            }
            action(CreateInvoices)
            {
                ApplicationArea = Basic;
                Caption = 'Create Invoices';
                Ellipsis = true;
                Image = CreateDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    BLSCreateInv.SetTableView(Rec);
                    BLSCreateInv.Run();
                    //BLSCreateInv.GetProcessInfo(InvCnt, SalesHeader);
                    //if Confirm(NewInvoiceMsg, true, InvCnt) then
                    //Page.Run(Page::"Sales Invoice List", SalesHeader);
                    CurrPage.Update(true);
                end;
            }
            action(CreateInvoicesLease)
            {
                ApplicationArea = Basic;
                Caption = 'Create Invoices Lease';
                Ellipsis = true;
                Image = CreateDocument;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                begin
                    BLSCreateInvLease.SetTableView(Rec);
                    BLSCreateInvLease.Run();
                    //BLSCreateInv.GetProcessInfo(InvCnt, SalesHeader);
                    //if Confirm(NewInvoiceMsg, true, InvCnt) then
                    //Page.Run(Page::"Sales Invoice List", SalesHeader);
                    CurrPage.Update(true);
                end;
            }
        }
        area(navigation)
        {
            action(Customer)
            {
                ApplicationArea = Basic;
                Caption = 'Customer';
                Image = Customer;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Customer Card";
                RunPageLink = "No." = field("Customer No.");
            }
            action(Contract)
            {
                ApplicationArea = Basic;
                Caption = 'Contract';
                Image = Document;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page Contract;

                trigger OnAction()
                begin
                    Rec.ShowContract;
                end;
            }
            action(Service)
            {
                ApplicationArea = Basic;
                Caption = 'Service';
                Image = ServiceItem;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "BLS Service List";
                RunPageLink = Code = field("Service Code");
            }
            action("Object")
            {
                ApplicationArea = Basic;
                Caption = 'Object';
                Image = ServiceZone;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "BLS Objects";
                RunPageLink = Code = field("Object Code");
            }
        }
    }
    var
        BLSCreateInv: Report "BLS Create Invoices";
        InvCnt: Integer;
        SalesHeader: Record "Sales Header";
        NewInvoiceMsg: label 'Created %1 invoice(-s). Do You want open invoice list?';
        BLSCreateInvLease: Report "BLS Create Invoices Lease";

}

