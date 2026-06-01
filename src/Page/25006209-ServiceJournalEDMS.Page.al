Page 25006209 "Service Journal EDMS"
{
    // 2012.09.14 EDMS P8
    //   * Added fields: "Minutes Per UoM", "Quantity (Hours)"
    // 
    // 20.10.2008. EDMS P2
    //   * Opened field "Deal Type code"

    ApplicationArea = Basic;
    AutoSplitKey = true;
    Caption = 'Service Journal EDMS';
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Serv. Journal Line";
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
                    ServJnlManagement.LookupName(CurrentJnlBatchName, Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    ServJnlManagement.CheckName(CurrentJnlBatchName, Rec);
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
                field(EntryType; Rec."Entry Type")
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
                    Visible = false;
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        SerialNoOnAfterValidate;
                    end;
                }
                field(MakeCode; Rec."Make Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;

                    trigger OnValidate()
                    begin
                        //ShowShortcutDimCode(ShortcutDimCode);//29.10.2012 EDMS
                    end;
                }
                field(ModelCode; Rec."Model Code")
                {
                    ApplicationArea = Basic;
                }
                field(ModelVersionNo; Rec."Model Version No.")
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
                field(CustomerNo; Rec."Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field(BilltoCustomerNo; Rec."Bill-to Customer No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(ShortcutDimension1Code; Rec."Shortcut Dimension 1 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ShortcutDimension2Code; Rec."Shortcut Dimension 2 Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(ShortcutDimCode3; ShortcutDimCode[3])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,3';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        //LookupShortcutDimCode(3,ShortcutDimCode[3]);//29.10.2012 EDMS
                    end;

                    trigger OnValidate()
                    begin
                        //ValidateShortcutDimCode(3,ShortcutDimCode[3]);//29.10.2012 EDMS
                    end;
                }
                field(ShortcutDimCode4; ShortcutDimCode[4])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,4';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        //LookupShortcutDimCode(4,ShortcutDimCode[4]);//29.10.2012 EDMS
                    end;

                    trigger OnValidate()
                    begin
                        //ValidateShortcutDimCode(4,ShortcutDimCode[4]);//29.10.2012 EDMS
                    end;
                }
                field(ShortcutDimCode5; ShortcutDimCode[5])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,5';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        //LookupShortcutDimCode(5,ShortcutDimCode[5]);//29.10.2012 EDMS
                    end;

                    trigger OnValidate()
                    begin
                        //ValidateShortcutDimCode(5,ShortcutDimCode[5]);//29.10.2012 EDMS
                    end;
                }
                field(ShortcutDimCode6; ShortcutDimCode[6])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,6';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        //LookupShortcutDimCode(6,ShortcutDimCode[6]);//29.10.2012 EDMS
                    end;

                    trigger OnValidate()
                    begin
                        //ValidateShortcutDimCode(6,ShortcutDimCode[6]);//29.10.2012 EDMS
                    end;
                }
                field(ShortcutDimCode7; ShortcutDimCode[7])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,7';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        //LookupShortcutDimCode(7,ShortcutDimCode[7]);//29.10.2012 EDMS
                    end;

                    trigger OnValidate()
                    begin
                        //ValidateShortcutDimCode(7,ShortcutDimCode[7]);//29.10.2012 EDMS
                    end;
                }
                field(ShortcutDimCode8; ShortcutDimCode[8])
                {
                    ApplicationArea = Basic;
                    CaptionClass = '1,2,8';
                    Visible = false;

                    trigger OnLookup(var Text: Text): Boolean
                    begin
                        //LookupShortcutDimCode(8,ShortcutDimCode[8]);//29.10.2012 EDMS
                    end;

                    trigger OnValidate()
                    begin
                        //ValidateShortcutDimCode(8,ShortcutDimCode[8]);//29.10.2012 EDMS
                    end;
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
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                }
                field(UnitofMeasureCode; Rec."Unit of Measure Code")
                {
                    ApplicationArea = Basic;
                }
                field(UnitCost; Rec."Unit Cost")
                {
                    ApplicationArea = Basic;
                }
                field(TotalCost; Rec."Total Cost")
                {
                    ApplicationArea = Basic;
                }
                field(UnitPrice; Rec."Unit Price")
                {
                    ApplicationArea = Basic;
                }
                field(Amount; Rec.Amount)
                {
                    ApplicationArea = Basic;
                }
                field(DealTypeCode; Rec."Deal Type Code")
                {
                    ApplicationArea = Basic;
                }
                field(Chargeable; Rec.Chargeable)
                {
                    ApplicationArea = Basic;
                }
                field(ReasonCode; Rec."Reason Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(TireOperationType; Rec."Tire Operation Type")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleAxleCode; Rec."Vehicle Axle Code")
                {
                    ApplicationArea = Basic;
                }
                field(TirePositionCode; Rec."Tire Position Code")
                {
                    ApplicationArea = Basic;
                    DrillDown = true;
                    DrillDownPageID = "Vehicle Tire Positions";
                    Lookup = true;
                    LookupPageID = "Vehicle Tire Positions";
                }
                field(TireCode; Rec."Tire Code")
                {
                    ApplicationArea = Basic;
                }
                field(NewVehicleAxleCode; Rec."New Vehicle Axle Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(NewTirePositionCode; Rec."New Tire Position Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VariableFieldRun1; Rec."Variable Field Run 1")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VariableFieldRun2; Rec."Variable Field Run 2")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VariableFieldRun3; Rec."Variable Field Run 3")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PlanNo; Rec."Plan No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(PlanStageRecurrence; Rec."Plan Stage Recurrence")
                {
                    ApplicationArea = Basic;
                }
                field(PlanStageCode; Rec."Plan Stage Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(MinutesPerUoM; Rec."Minutes Per UoM")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(QuantityHours; Rec."Quantity (Hours)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
            }
            group(Control41)
            {
                field(VehName; VehName)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicle Name';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Line)
            {
                Caption = '&Line';
                action(Dimensions)
                {
                    ApplicationArea = Basic;
                    Caption = 'Dimensions';
                    Image = Dimensions;
                    Promoted = true;
                    PromotedCategory = Process;
                    ShortCutKey = 'Shift+Ctrl+D';

                    trigger OnAction()
                    begin
                        Rec.ShowDimensions;
                        CurrPage.SaveRecord;
                    end;
                }
                action(Details)
                {
                    ApplicationArea = Basic;
                    Caption = 'D&etails';
                    Ellipsis = true;
                    Image = ViewDetails;
                    RunObject = Page "Det. Service Journal EDMS";
                    RunPageLink = "Journal Template Name" = field("Journal Template Name"),
                                  "Journal Batch Name" = field("Journal Batch Name"),
                                  "Journal Line No." = field("Line No.");
                }
            }
            group(Service)
            {
                Caption = '&Service';
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = EditLines;
                    RunObject = Page "Vehicle Card";
                    RunPageLink = "Serial No." = field("Vehicle Serial No.");
                    ShortCutKey = 'Shift+F5';
                }
                action(LedgerEntries)
                {
                    ApplicationArea = Basic;
                    Caption = 'Ledger E&ntries';
                    Image = ItemLedger;
                    RunObject = Page "Service Ledger Entries EDMS";
                    RunPageLink = "Vehicle Serial No." = field("Vehicle Serial No.");
                    RunPageView = sorting("Vehicle Serial No.");
                    ShortCutKey = 'Ctrl+F5';
                }
                action(TireEntries)
                {
                    ApplicationArea = Basic;
                    Caption = '&Tire Entries';
                    Image = ItemLedger;
                    RunObject = Page "Tire Entries";
                    RunPageLink = "Vehicle Serial No." = field("Vehicle Serial No.");
                }
            }
        }
        area(processing)
        {
            group(Posting)
            {
                Caption = 'P&osting';
                action(TestReport)
                {
                    ApplicationArea = Basic;
                    Caption = 'Test Report';
                    Image = TestReport;

                    trigger OnAction()
                    var
                        "Item Sales Doc. Mgt. EDMS": Codeunit "Item Sales Doc. Mgt. EDMS";
                    begin
                        "Item Sales Doc. Mgt. EDMS".PrintServJnlLine(Rec);
                    end;
                }
                action(Post)
                {
                    ApplicationArea = Basic;
                    Caption = 'P&ost';
                    Image = PostOrder;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Serv. Jnl.-Post", Rec);
                        CurrentJnlBatchName := Rec.GetRangemax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
                action("<Action1101901008>")
                {
                    ApplicationArea = Basic;
                    Caption = 'Post and &Print';
                    Image = PostPrint;
                    ShortCutKey = 'Shift+F11';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Service Jnl.-Post+Print", Rec);
                        CurrentJnlBatchName := Rec.GetRangemax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        //ShowShortcutDimCode(ShortcutDimCode);// 29.10.2012 EDMS
        OnAfterGetCurrRecord;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.SetUpNewLine(xRec);
        Clear(ShortcutDimCode);
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    var
        JnlSelected: Boolean;
    begin
        ServJnlManagement.TemplateSelection(Page::"Service Journal EDMS", false, Rec, JnlSelected);
        if not JnlSelected then
            Error('');
        ServJnlManagement.OpenJnl(CurrentJnlBatchName, Rec);
    end;

    var
        ServJnlManagement: Codeunit ServJnlManagement;
        ReportPrint: Codeunit "Test Report-Print";
        CurrentJnlBatchName: Code[10];
        VehName: Text[30];
        ShortcutDimCode: array[8] of Code[20];

    local procedure SerialNoOnAfterValidate()
    begin
        CurrPage.Update;
    end;

    local procedure CurrentJnlBatchNameOnAfterVali()
    begin
        CurrPage.SaveRecord;
        ServJnlManagement.SetName(CurrentJnlBatchName, Rec);
        CurrPage.Update(false);
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;
        ServJnlManagement.GetVeh(Rec."Vehicle Serial No.", VehName);
    end;
}

