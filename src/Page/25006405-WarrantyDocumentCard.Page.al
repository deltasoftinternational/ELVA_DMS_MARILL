Page 25006405 "Warranty Document Card"
{
    // 06.10.2017 EB.AKR Warranty
    //   Added fields:
    //     51240 Initial Service Order No.
    //     52001 Unplanned Stop
    //     52002 Item Repair Status
    //     52004 Causal Item Serial No.
    //     52005 Causal Part Serial No.
    //     52011 Parts Fitted Date
    //     52012 Parts Operation Hours
    //     52016 Repair Date
    //     52110 Recall Campaign External No.

    Caption = 'Warranty Document Card';
    SourceTable = "Warranty Document Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;

                    trigger OnValidate()
                    begin
                        if Rec.AssistEdit(xRec) then
                            CurrPage.Update;
                    end;
                }
                field(DocumentDate; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                }
                field(InitialServiceOrderNo; Rec."Initial Service Order No.")
                {
                    ApplicationArea = Basic;
                }
                field(ServiceOrderNo; Rec."Service Order No.")
                {
                    ApplicationArea = Basic;
                }
                field(ServiceOrderSequenceNo; Rec."Service Order Sequence No.")
                {
                    ApplicationArea = Basic;
                }
                field("External Claim No."; Rec."External Claim No.")
                {
                    ApplicationArea = All;
                }
                field("Deal Type"; Rec."Deal Type")
                {
                    ApplicationArea = All;
                }
                field(RepairDate; Rec."Repair Date")
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
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleStatusCode; Rec."Vehicle Status Code")
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
                field(ClaimJobType; Rec."Claim Job Type")
                {
                    ApplicationArea = Basic;
                }
                field(SymptomCode; Rec."Symptom Code")
                {
                    ApplicationArea = Basic;
                }
                field(RecalCampaignCode; Rec."Recal Campaign Code")
                {
                    ApplicationArea = Basic;
                }
                field(RecallCampaignExternalNo; Rec."Recall Campaign External No.")
                {
                    ApplicationArea = Basic;
                }
                field(CurrencyCode; Rec."Currency Code")
                {
                    ApplicationArea = Basic;
                }
                field("Document Status"; Rec."Document Status")
                {
                    ApplicationArea = All;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field(UnplannedStop; Rec."Unplanned Stop")
                {
                    ApplicationArea = Basic;
                }
                field(ItemRepairStatus; Rec."Item Repair Status")
                {
                    ApplicationArea = Basic;
                }
                field(CausalItemNo; Rec."Causal Item No.")
                {
                    ApplicationArea = Basic;
                }
                field(CausalItemSerialNo; Rec."Causal Item Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field(PartsFittedDate; Rec."Parts Fitted Date")
                {
                    ApplicationArea = Basic;
                }
                field(PartsOperationHours; Rec."Parts Operation Hours")
                {
                    ApplicationArea = Basic;
                }
            }
            part(Control25006022; "Warranty Document Subform")
            {
                ApplicationArea = All;
                SubPageLink = "Document No." = field("No.");
            }
        }
        area(factboxes)
        {
            part(Control25006029; "Vehicle Service FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Serial No." = field("Vehicle Serial No.");
                Visible = true;
            }
            part(Control25006028; "Vehicle Info FactBox")
            {
                ApplicationArea = All;
                SubPageLink = "Serial No." = field("Vehicle Serial No.");
            }
            part("Vehicle Pictures"; "Object Picture FactBox")
            {
                ApplicationArea = All;
                Caption = 'Vehicle Pictures';
                SubPageLink = "Source Type" = const(Database::Vehicle),
                              //"Source Subtype" = const("0"),
                              "Vehicle Serial No." = field("Vehicle Serial No.");
                //"Source Ref. No." = const(0);
                SubPageView = sorting("Source Type", "Source Subtype", "Source ID", "Source Ref. No.", "No.");
            }
            systempart(Control25006026; Links)
            {
                ApplicationArea = All;
                Visible = true;
            }
            systempart(Control25006020; Notes)
            {
                ApplicationArea = All;
                Visible = true;
            }
        }
    }

    actions
    {
        area(navigation)
        {
            action("Warranty Reimbursement Entries")
            {
                ApplicationArea = Basic;
                Caption = 'Warranty Reimbursement Entries';
                Image = AllLines;
                RunObject = Page "Warranty Reimbursement Entries";
                RunPageLink = "Warranty Document No." = field("No.");
            }
            action("Page Service Comment Sheet EDMS")
            {
                ApplicationArea = Basic;
                Caption = 'Co&mments';
                Image = ViewComments;
                RunObject = Page "Service Comment Sheet EDMS";
                RunPageLink = "No." = field("No."),
                              Type = const("Warranty Doc");
            }
        }
    }

    trigger OnInit()
    begin
        SetVariableFields;
    end;

    var
        VFRun1Visible: Boolean;
        VFRun2Visible: Boolean;
        VFRun3Visible: Boolean;

    procedure SetVariableFields()
    begin
        VFRun1Visible := rec.IsVFActive(rec.FieldNo("Variable Field Run 1"));
        VFRun2Visible := rec.IsVFActive(rec.FieldNo("Variable Field Run 2"));
        VFRun3Visible := rec.IsVFActive(rec.FieldNo("Variable Field Run 3"));
    end;
}

