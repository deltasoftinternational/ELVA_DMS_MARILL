Page 25006211 "Service Ledger Entries EDMS"
{
    // 11.06.2015 EB.P30 #T041
    //   Added fields:
    //     "Resource Cost Amount"
    //     "Quantity (Hours)"
    //     "Resources"
    // 
    // 12.02.2015 EB.P7 #T020
    //   Removed field "Date Filter" because of Clipboard Crash
    // 
    // 29.05.2013 Elva Baltic P15
    //   * Added ShowDocument function
    // 
    // 2012.09.14 EDMS P8
    //   * Added fields: "Minutes Per UoM", "Quantity (Hours)"
    // 
    // 28.01.2010 EDMSB P2
    //   * Opened field "Standard Time", "Campaign No.", "Labor Group Code", "Labor Subgroup Code"
    // 
    // 20.10.2008. EDMS P2
    //   * Opened field "Deal Type code"
    // 
    // 29.05.2008. EDMS P2
    //   * Opened field VIN

    ApplicationArea = Basic;
    Caption = 'Service Ledger Entries EDMS';
    DataCaptionFields = "Vehicle Serial No.";
    Editable = false;
    PageType = List;
    SourceTable = "Service Ledger Entry EDMS";
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(EntryType; Rec."Entry Type")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentType; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;

                    trigger OnLookup(var Text: Text): Boolean
                    var
                        PostedServOrder: Record "Posted Serv. Order Header";
                        PostedRetOrder: Record "Posted Serv. Ret. Order Header";
                        SalesInvoiceHdr: Record "Sales Invoice Header";
                    begin
                        //29.05.2013 Elva Baltic P15 >>
                        ShowDocument;
                        //29.05.2013 Elva Baltic P15 <<
                    end;
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
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
                field(AmountLCY; Rec."Amount (LCY)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                }
                field(Discount; Rec."Discount %")
                {
                    ApplicationArea = Basic;
                }
                field(LineDiscountAmount; Rec."Line Discount Amount")
                {
                    ApplicationArea = Basic;
                }
                field(AmountIncludingVAT; Rec."Amount Including VAT")
                {
                    ApplicationArea = Basic;
                }
                field(InvDiscountAmount; Rec."Inv. Discount Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(UnitCost; Rec."Unit Cost")
                {
                    ApplicationArea = Basic;
                }
                field(TotalCost; Rec."Total Cost")
                {
                    ApplicationArea = Basic;
                }
                field(ChargedQty; Rec."Charged Qty.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Chargeable; Rec.Chargeable)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field(CustomerNo; Rec."Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoCustomerNo; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension1Code; Rec."Global Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                }
                field(GlobalDimension2Code; Rec."Global Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
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
                field(ModelVersionNo; Rec."Model Version No.")
                {
                    ApplicationArea = Basic;
                }
                field(VariableFieldRun1; Rec."Variable Field Run 1")
                {
                    ApplicationArea = Basic;
                    Visible = VFRun1Visible;
                }
                field(VariableFieldRun2; Rec."Variable Field Run 2")
                {
                    ApplicationArea = Basic;
                    Visible = VFRun2Visible;
                }
                field(VariableFieldRun3; Rec."Variable Field Run 3")
                {
                    ApplicationArea = Basic;
                    Visible = VFRun3Visible;
                }
                field(UserID; Rec."User ID")
                {
                    ApplicationArea = Basic;
                }
                field(DealTypeCode; Rec."Deal Type Code")
                {
                    ApplicationArea = Basic;
                }
                field(ServiceOrderType; Rec."Service Order Type")
                {
                    ApplicationArea = Basic;
                }
                field(ServiceOrderNo; Rec."Service Order No.")
                {
                    ApplicationArea = Basic;
                }
                field(JobNo; Rec."Job No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(LaborGroupCode; Rec."Labor Group Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(LaborSubgroupCode; Rec."Labor Subgroup Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(GenBusPostingGroup; Rec."Gen. Bus. Posting Group")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(GenProdPostingGroup; Rec."Gen. Prod. Posting Group")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field(ResponsibilityCenter; Rec."Responsibility Center")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Open; Rec.Open)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ExternalDocumentNo; Rec."External Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentDate; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                }
                field(NoSeries; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(SourceCode; Rec."Source Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(JournalBatchName; Rec."Journal Batch Name")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ReasonCode; Rec."Reason Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PreAssignedNo; Rec."Pre-Assigned No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ServiceReceiver; Rec."Service Receiver")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleAccountingCycleNo; Rec."Vehicle Accounting Cycle No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(RemainingAmount; Rec."Remaining Amount")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(CustLedgerEntryNo; Rec."Cust. Ledger Entry No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ServOrderRemainingAmt; Rec."Serv. Order Remaining Amt")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PaymentMethodCode; Rec."Payment Method Code")
                {
                    ApplicationArea = Basic;
                }
                field(WarrantyClaimNo; Rec."Warranty Claim No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VariableField25006800; Rec."Variable Field 25006800")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006800Visibl;
                }
                field(VariableField25006801; Rec."Variable Field 25006801")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006801Visibl;
                }
                field(VariableField25006802; Rec."Variable Field 25006802")
                {
                    ApplicationArea = Basic;
                    Visible = DMSVariableField25006802Visibl;
                }
                field(DocumentLineNo; Rec."Document Line No.")
                {
                    ApplicationArea = Basic;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        //29.05.2013 Elva Baltic P15 >>
                        ShowDocument;
                        //29.05.2013 Elva Baltic P15 <<
                    end;
                }
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(PackageNo; Rec."Package No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PackageVersionNo; Rec."Package Version No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PackageVersionSpecLineNo; Rec."Package Version Spec. Line No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(StandardTime; Rec."Standard Time")
                {
                    ApplicationArea = Basic;
                }
                field(CampaignNo; Rec."Campaign No.")
                {
                    ApplicationArea = Basic;
                }
                field(ParentVehicleSerialNo; Rec."Parent Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(MinutesPerUoM; Rec."Minutes Per UoM")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(FinishedHours; Rec."Finished Hours")
                {
                    ApplicationArea = Basic;
                    Visible = true;
                }
                field(ResourceCostAmount; Rec."Resource Cost Amount")
                {
                    ApplicationArea = Basic;
                }
                field(Resources; Rec.GetResourceTextFieldValue())
                {
                    ApplicationArea = Basic;
                    Caption = 'Resources';
                    DrillDown = true;

                    trigger OnDrillDown()
                    begin
                        Rec.ShowDetLedgEntries;
                    end;
                }
                field(ServiceAddressCode; Rec."Service Address Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ServiceAddress; Rec."Service Address")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ContractNo; Rec."Contract No.")
                {
                    ApplicationArea = Basic;
                }
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
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions;
                        CurrPage.SaveRecord;
                    end;
                }
                action(TireEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Tire Entries';
                    Image = ItemLedger;
                    RunObject = Page "Tire Entries";
                    RunPageLink = "Service Ledger Entry No." = field("Entry No.");
                }
                action(DetailedServiceLedgerEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Detailed Service Ledger Entries';
                    Image = ItemLedger;
                    RunObject = Page "Det. Serv. Ledger Entries EDMS";
                    RunPageLink = "Service Ledger Entry No." = field("Entry No.");
                    ShortCutKey = 'Ctrl+F5';
                }
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
            action(Comments)
            {
                ApplicationArea = Basic;
                Caption = 'Comments';
                Image = ViewComments;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    ServiceCommentLine: Record "Service Comment Line EDMS";
                    SalesCommentLine: Record "Sales Comment Line";
                begin
                    case Rec."Entry Type" of
                        Rec."entry type"::Usage:
                            begin
                                ServiceCommentLine.Reset;
                                ServiceCommentLine.SetRange(Type, ServiceCommentLine.Type::"Service Order");
                                ServiceCommentLine.SetRange("No.", Rec."Document No.");
                                Page.Run(Page::"Service Comment Sheet EDMS", ServiceCommentLine);
                            end;
                        Rec."entry type"::Sale:
                            begin
                                SalesCommentLine.Reset;
                                SalesCommentLine.SetRange("Document Type", SalesCommentLine."document type"::"Posted Invoice");
                                SalesCommentLine.SetRange("No.", Rec."Document No.");
                                Page.Run(Page::"Sales Comment Sheet", SalesCommentLine);
                            end;
                    end
                end;
            }
        }
    }

    trigger OnInit()
    begin
        fSetVariableFields;
    end;

    var
        Navigate: Page Navigate;
        [InDataSet]
        DMSVariableField25006800Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006801Visibl: Boolean;
        [InDataSet]
        DMSVariableField25006802Visibl: Boolean;
        ResourcesNo: Text;
        VFRun1Visible: Boolean;
        VFRun2Visible: Boolean;
        VFRun3Visible: Boolean;


    procedure fSetVariableFields()
    begin
        //Variable Fields
        DMSVariableField25006800Visibl := Rec.IsVFActive(Rec.FieldNo("Variable Field 25006800"));
        DMSVariableField25006801Visibl := Rec.IsVFActive(Rec.FieldNo("Variable Field 25006801"));
        DMSVariableField25006802Visibl := Rec.IsVFActive(Rec.FieldNo("Variable Field 25006802"));
        VFRun1Visible := rec.IsVFActive(rec.FieldNo("Variable Field Run 1"));
        VFRun2Visible := rec.IsVFActive(rec.FieldNo("Variable Field Run 2"));
        VFRun3Visible := rec.IsVFActive(rec.FieldNo("Variable Field Run 3"));
    end;


    procedure fHideVariableFields()
    begin
        //Variable Fields
        DMSVariableField25006800Visibl := false;
        DMSVariableField25006801Visibl := false;
        DMSVariableField25006802Visibl := false;
    end;


    procedure ShowDocument()
    var
        PostedServOrder: Record "Posted Serv. Order Header";
        PostedRetOrder: Record "Posted Serv. Ret. Order Header";
        SalesInvoiceHdr: Record "Sales Invoice Header";
    begin
        //29.05.2013 Elva Baltic P15
        if Rec."Entry Type" = Rec."entry type"::Usage then begin
            PostedServOrder.Reset;
            PostedServOrder.SetRange("No.", Rec."Document No.");
            if PostedServOrder.FindFirst then
                Page.Run(Page::"Posted Service Order EDMS", PostedServOrder)
            else begin
                PostedRetOrder.Reset;
                PostedRetOrder.SetRange("No.", Rec."Document No.");
                if PostedRetOrder.FindFirst then
                    Page.Run(Page::"Posted Service Ret.Order EDMS", PostedRetOrder)
            end;
        end else
            if Rec."Entry Type" = Rec."entry type"::Sale then begin
                SalesInvoiceHdr.Reset;
                SalesInvoiceHdr.SetRange("No.", Rec."Document No.");
                if SalesInvoiceHdr.FindFirst then
                    Page.Run(Page::"Posted Sales Invoice", SalesInvoiceHdr)

            end else      //Info
                ;
    end;
}

