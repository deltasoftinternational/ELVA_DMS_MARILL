Page 25006520 "Vehicle Option Journal"
{
    // 19.06.2004 EDMS P1
    //    * Created

    ApplicationArea = Basic;
    AutoSplitKey = true;
    Caption = 'Vehicle Option Journal';
    DataCaptionFields = "Journal Batch Name";
    DelayedInsert = true;
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Vehicle Opt. Jnl. Line";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field(codCurrentJnlBatchName; codCurrentJnlBatchName)
            {
                ApplicationArea = Basic;
                Caption = 'Batch Name';
                Lookup = true;

                trigger OnLookup(var Text: Text): Boolean
                begin
                    CurrPage.SaveRecord;
                    cuVehOptJnlMgt.fLookupName(codCurrentJnlBatchName, Rec);
                    CurrPage.Update(false);
                end;

                trigger OnValidate()
                begin
                    cuVehOptJnlMgt.fCheckName(codCurrentJnlBatchName, Rec);
                    codCurrentJnlBatchNameOnAfterV;
                end;
            }
            repeater(Control1)
            {
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentNo; Rec."Document No.")
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
                field(ExternalDocumentNo; Rec."External Document No.")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(VIN; Rec.VIN)
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
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
                field(OptionType; Rec."Option Type")
                {
                    ApplicationArea = Basic;
                }
                field(OptionSubtype; Rec."Option Subtype")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(OptionCode; Rec."Option Code")
                {
                    ApplicationArea = Basic;
                }
                field(ExternalCode; Rec."External Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Standard; Rec.Standard)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(Description2; Rec."Description 2")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(CostAmountLCY; Rec."Cost Amount (LCY)")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(Correction; Rec.Correction)
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(AppliestoEntry; Rec."Applies-to Entry")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Control22)
            {
                field(txtItemDescription; txtItemDescription)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicle Serial No.';
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Vehicle)
            {
                Caption = 'Vehicle';
                action(Card)
                {
                    ApplicationArea = Basic;
                    Caption = 'Card';
                    Image = Edit;
                    RunObject = Page "Vehicle Card";
                    RunPageLink = "Serial No." = field("Vehicle Serial No.");
                    ShortCutKey = 'Shift+F5';
                }
            }
        }
        area(processing)
        {
            group(Posting)
            {
                Caption = 'P&osting';
                action(Post)
                {
                    ApplicationArea = Basic;
                    Caption = 'P&ost';
                    Image = Post;
                    Promoted = true;
                    PromotedCategory = Process;
                    PromotedIsBig = true;
                    ShortCutKey = 'F9';

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Vehicle Opt. Jnl.-Post", Rec);
                        codCurrentJnlBatchName := Rec.GetRangemax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
                action(PostandPrint)
                {
                    ApplicationArea = Basic;
                    Caption = 'Post and &Print';
                    ShortCutKey = 'Shift+F9';
                    Visible = false;

                    trigger OnAction()
                    begin
                        Codeunit.Run(Codeunit::"Vehicle Opt. Jnl.-Post+Print", Rec);
                        codCurrentJnlBatchName := Rec.GetRangemax("Journal Batch Name");
                        CurrPage.Update(false);
                    end;
                }
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        OnAfterGetCurrRecord;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.fSetUpNewLine(xRec);
        OnAfterGetCurrRecord;
    end;

    trigger OnOpenPage()
    begin
        cuVehOptJnlMgt.fTemplateSelection(Rec);
        cuVehOptJnlMgt.fOpenJnl(codCurrentJnlBatchName, Rec);
    end;

    var
        cuVehOptJnlMgt: Codeunit VehicleOptJnlManagement;
        codCurrentJnlBatchName: Code[10];
        txtItemDescription: Text[50];
        txtNewItemDescription: Text[50];

    local procedure codCurrentJnlBatchNameOnAfterV()
    begin
        CurrPage.SaveRecord;
        cuVehOptJnlMgt.fSetName(codCurrentJnlBatchName, Rec);
        CurrPage.Update(false);
    end;

    local procedure OnAfterGetCurrRecord()
    begin
        xRec := Rec;

        txtItemDescription := Rec."Vehicle Serial No.";
    end;
}

