Page 25006406 "Warranty Document List"
{
    // 06.10.2017 EB.AKR Warranty
    //   Added fields:
    //     51200 Total Amount
    //     51201 Total Adjusted
    //     51202 Total Approved
    //     51203 Total Rejected
    //     51240 Initial Service Order No.
    //     52110 Recall Campaign External No.

    ApplicationArea = Basic;
    Caption = 'Warranty Document List';
    CardPageID = "Warranty Document Card";
    Editable = false;
    PageType = List;
    SourceTable = "Warranty Document Header";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec."No.")
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
                    ApplicationArea = Basic;
                }
                field("Deal Type"; Rec."Deal Type")
                {
                    ApplicationArea = Basic;
                }

                field("Document Status"; Rec."Document Status")
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
                field(VehicleAccountingCycleNo; Rec."Vehicle Accounting Cycle No.")
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
                field(ModelCommercialName; Rec."Model Commercial Name")
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
                field(CurrencyFactor; Rec."Currency Factor")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field("Total Amount"; Rec."Total Amount")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    Editable = false;
                }
                field("Total Adjusted Amount"; Rec."Total Adjusted")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field("Total Approved"; Rec."Total Approved")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    Editable = false;
                }
                field("Total Rejected"; Rec."Total Rejected")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(General)
            {
                Caption = 'General';
                action(Comments)
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

