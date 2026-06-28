page 25006447 "Closed Warranty Document List"
{
    ApplicationArea = All;
    Caption = 'Closed Warranty Document List';
    CardPageID = "Closed Warranty Document";
    PageType = List;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    SourceTable = "Warranty Document Header";
    SourceTableView = where(Closed = const(true));
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
                }
                field(VariableFieldRun2; Rec."Variable Field Run 2")
                {
                    ApplicationArea = Basic;
                }
                field(VariableFieldRun3; Rec."Variable Field Run 3")
                {
                    ApplicationArea = Basic;
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
}
