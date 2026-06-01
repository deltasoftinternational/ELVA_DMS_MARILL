Page 25006434 "BLS Invoicing Ledger Entries"
{
    ApplicationArea = Basic;
    Caption = 'Billing Invoicing Ledger Entries';
    Editable = false;
    PageType = List;
    SourceTable = "BLS Invoicing Ledger Entry";
    UsageCategory = History;

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
                field(LineType; Rec."Line type")
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
                field(CalculationEntryCount; Rec."Calculation Entry Count")
                {
                    ApplicationArea = Basic;
                }
                field(EntryNo; Rec."Entry No.")
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
            group(Calculation)
            {
                Caption = 'Calculation';
                action(VoidCalculation)
                {
                    ApplicationArea = Basic;
                    Caption = 'Void Calculation';

                    trigger OnAction()
                    var
                        InvoicingLedgEntry: Record "BLS Invoicing Ledger Entry";
                        VoidCalculationCfg: label 'Are You sure to void calculation of %1 lines?';
                        BLSMgt: Codeunit "BLS Management";
                    begin
                        CurrPage.SetSelectionFilter(InvoicingLedgEntry);
                        if not InvoicingLedgEntry.Find('-') then
                            exit;

                        if not Confirm(StrSubstNo(VoidCalculationCfg, InvoicingLedgEntry.Count), false) then
                            exit;

                        BLSMgt.CancelInvoicingLedgEntries(InvoicingLedgEntry);
                    end;
                }
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
                RunObject = Page "BLS Service Card";
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
}

