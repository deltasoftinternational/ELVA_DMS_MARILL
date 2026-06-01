Page 25006431 "BLS Journal DMS"
{
    ApplicationArea = Basic;
    AutoSplitKey = true;
    Caption = 'Service Journal For DMS';
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "BLS Journal Line";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field(CurrentJnlBatchName; CurrentJnlBatchName)
            {
                ApplicationArea = Basic;
                Caption = 'Batch Name';
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord;
                    BLSJnlManagement.LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    BLSJnlManagement.CheckName(CurrentJnlBatchName, Rec);
                    CurrentJnlBatchNameOnAfterVali;
                end;
            }
            repeater(Control1)
            {
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentDate; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(ExternalDocumentNo; Rec."External Document No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(EntryType; Rec."Entry Type")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
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
                    Visible = false;
                }
                field(CustomerDiscountGroup; Rec."Customer Discount Group")
                {
                    ApplicationArea = Basic;
                    Visible = false;
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

                    trigger OnAssistEdit()
                    begin
                        Rec.SetPrice;
                    end;
                }
                field(TotalPrice; Rec."Total Price")
                {
                    ApplicationArea = Basic;
                }
                field(Discount; Rec."Discount, %")
                {
                    ApplicationArea = Basic;

                    trigger OnAssistEdit()
                    begin
                        Rec.SetDiscount;
                    end;
                }
                field(DiscountAmount; Rec."Discount Amount")
                {
                    ApplicationArea = Basic;
                }
                field(TotalPriceInclDiscount; Rec."Total Price Incl. Discount")
                {
                    ApplicationArea = Basic;
                }
                field(Correction; Rec.Correction)
                {
                    ApplicationArea = Basic;
                }
                field(ReasonCode; Rec."Reason Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
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
                RunPageLink = "Contract No." = field("Contract No.");
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
        area(processing)
        {
            group(Suggest)
            {
                Caption = 'Suggest';
                action(SuggestLinesFromDMS)
                {
                    ApplicationArea = Basic;
                    Caption = 'Suggest Lines From DMS';
                    Image = Suggest;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;

                    trigger OnAction()
                    begin
                        Clear(BLSCalculateMotorhours);
                        BLSCalculateMotorhours.SetParam(Rec);
                        BLSCalculateMotorhours.RunModal;
                    end;
                }
            }
            group(Posting)
            {
                Caption = 'P&osting';
                Image = Post;
                action(Post)
                {
                    ApplicationArea = Basic;
                    Caption = 'P&ost';
                    Image = PostOrder;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"BLS Jnl.-Post", Rec);
                        CurrentJnlBatchName := Rec.GetRangemax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        Rec.ShowShortcutDimCode(ShortcutDimCode);
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetUpNewLine(xRec);
        Clear(ShortcutDimCode);
    end;

    trigger OnInit()
    begin
        SetVariableFields;
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin
        OpenedFromBatch := (Rec."Journal Batch Name" <> '') and (Rec."Journal Template Name" = '');
        if OpenedFromBatch then begin
            CurrentJnlBatchName := Rec."Journal Batch Name";
            BLSJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
            exit;
        end;
        BLSJnlManagement.TemplateSelection(Page::"BLS Journal DMS", false, Rec, JnlSelected);
        if not JnlSelected then
            Error('');
        BLSJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
    end;

    var
        BLSJnlManagement: Codeunit BLSJnlManagement;
        CurrentJnlBatchName: Code[10];
        ShortcutDimCode: array[8] of Code[20];
        OpenedFromBatch: Boolean;
        Text001: label '';
        BLSCalculateMotorhours: Report "BLS Calculate Motorhours";
        VFRun1StartVisible: Boolean;
        VFRun2StartVisible: Boolean;
        VFRun3StartVisible: Boolean;
        VFRun1EndVisible: Boolean;
        VFRun2EndVisible: Boolean;
        VFRun3EndVisible: Boolean;

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord;
        BLSJnlManagement.SetName(CurrentJnlBatchName, Rec);
        CurrPage.Update(false);
    end;

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

