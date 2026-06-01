Page 25006430 "BLS Ledger Entries"
{
    ApplicationArea = Basic;
    Caption = 'Service Ledger Entries';
    Editable = false;
    PageType = List;
    SourceTable = "BLS Ledger Entry";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentDate; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(ExternalDocumentNo; Rec."External Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(EntryType; Rec."Entry Type")
                {
                    ApplicationArea = Basic;
                }
                field(ContractNo; Rec."Contract No.")
                {
                    ApplicationArea = Basic;
                }
                field(ExternalContractNo; Rec."External Contract No.")
                {
                    ApplicationArea = Basic;
                }
                field(CustomerNo; Rec."Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field(CustomerName; Rec."Customer Name")
                {
                    ApplicationArea = Basic;
                }
                field(CustomerPriceGroup; Rec."Customer Price Group")
                {
                    ApplicationArea = Basic;
                }
                field(CustomerDiscountGroup; Rec."Customer Discount Group")
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
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(CurrencyCode; Rec."Currency Code")
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
                field(UserID; Rec."User ID")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SourceCode; Rec."Source Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ReasonCode; Rec."Reason Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Correction; Rec.Correction)
                {
                    ApplicationArea = Basic;
                }
                field(SystemCreatedEntry; Rec."System-Created Entry")
                {
                    ApplicationArea = Basic;
                }
                field(JournalBatchName; Rec."Journal Batch Name")
                {
                    ApplicationArea = Basic;
                }
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(VariableFieldRunStart1; Rec."Variable Field Run Start 1")
                {
                    ApplicationArea = Basic;
                    Visible = VFRun1StartVisible;
                }
                field(VariableFieldRunEnd1; Rec."Variable Field Run End 1")
                {
                    ApplicationArea = Basic;
                    Visible = VFRun1EndVisible;
                }
                field("Variable Field Run Start 2"; Rec."Variable Field Run Start 2")
                {
                    ApplicationArea = Basic;
                    Visible = VFRun2StartVisible;
                }
                field("Variable Field Run End 2"; Rec."Variable Field Run End 2")
                {
                    ApplicationArea = Basic;
                    Visible = VFRun2EndVisible;
                }
                field("Variable Field Run Start 3"; Rec."Variable Field Run Start 3")
                {
                    ApplicationArea = Basic;
                    Visible = VFRun3StartVisible;
                }
                field("Variable Field Run End 3"; Rec."Variable Field Run End 3")
                {
                    ApplicationArea = Basic;
                    Visible = VFRun3EndVisible;
                }
                field("Calculation Ledger Entry No."; Rec."Calculation Ledger Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field("Vehicle Serial No."; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field(VIN; Rec.VIN)
                {
                    ApplicationArea = Basic;
                }
                field("Veh. Make Code"; Rec."Veh. Make Code")
                {
                    ApplicationArea = Basic;
                }
                field("Veh. Model Code"; Rec."Veh. Model Code")
                {
                    ApplicationArea = Basic;
                }
                field("Veh. Model Version No."; Rec."Veh. Model Version No.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Entry)
            {
                Caption = 'Ent&ry';
                Image = Entry;
                action(Dimensions)
                {
                    AccessByPermission = TableData Dimension = R;
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions;
                    end;
                }
            }
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
        area(processing)
        {
            action(Navigate)
            {
                ApplicationArea = Basic;
                Caption = '&Navigate';
                Image = Navigate;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                begin
                    Navigate.SetDoc(Rec."Posting Date", Rec."Document No.");
                    Navigate.Run;
                end;
            }
            action(ReverseEntry)
            {
                ApplicationArea = Basic;
                Caption = 'Reverse Entry';
                Image = ReverseRegister;

                trigger OnAction()
                var
                    BLSLedgerEntry: Record "BLS Ledger Entry";
                    BLSManagement: Codeunit "BLS Management";
                begin
                    BLSLedgerEntry.SetRange("Entry No.", Rec."Entry No.");
                    BLSManagement.ReverseLedgerEntry(BLSLedgerEntry);
                end;
            }
        }
    }

    trigger OnInit()
    begin
        SetVariableFields;
    end;

    var
        Navigate: Page Navigate;
        VFRun1StartVisible: Boolean;
        VFRun2StartVisible: Boolean;
        VFRun3StartVisible: Boolean;
        VFRun1EndVisible: Boolean;
        VFRun2EndVisible: Boolean;
        VFRun3EndVisible: Boolean;

    procedure SetVariableFields()
    begin
        VFRun1StartVisible := rec.IsVFActive(rec.FieldNo("Variable Field Run Start 1"));
        VFRun2StartVisible := rec.IsVFActive(rec.FieldNo("Variable Field Run Start 2"));
        VFRun3StartVisible := rec.IsVFActive(rec.FieldNo("Variable Field Run Start 3"));
        VFRun1EndVisible := rec.IsVFActive(rec.FieldNo("Variable Field Run End 1"));
        VFRun2EndVisible := rec.IsVFActive(rec.FieldNo("Variable Field Run End 2"));
        VFRun3EndVisible := rec.IsVFActive(rec.FieldNo("Variable Field Run End 3"));
    end;
}

