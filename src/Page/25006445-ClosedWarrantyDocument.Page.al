page 25006445 "Closed Warranty Document"
{
    Caption = 'Closed Warranty Document';
    PageType = Card;
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    SourceTable = "Warranty Document Header";
    SourceTableView = where(Closed = const(true));
    PromotedActionCategories = 'New,Process,Report,Navigate';

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
            part(Control25006022; "Closed Warranty Document Subf")
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
                SubPageLink = "Source Type" = const(25006005),
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
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "Warranty Reimbursement Entries";
                RunPageLink = "Warranty Document No." = field("No.");
            }
            action("Page Service Comment Sheet EDMS")
            {
                ApplicationArea = Basic;
                Caption = 'Co&mments';
                Image = ViewComments;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                RunObject = Page "Service Comment Sheet EDMS";
                RunPageLink = "No." = field("No."),
                              Type = const("Warranty Doc");
            }
            action(ServiceOrder)
            {
                ApplicationArea = Basic;
                Caption = 'Open Service Order';
                Image = PostedOrder;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    ServiceOrder: Record "Service Header EDMS";
                    PostedServiceOrder: Record "Posted Serv. Order Header";
                begin
                    PostedServiceOrder.Reset;
                    PostedServiceOrder.SetRange("No.", Rec."Service Order No.");
                    if PostedServiceOrder.FindFirst() then
                        Page.RunModal(Page::"Posted Service Order EDMS", PostedServiceOrder)
                    else begin
                        ServiceOrder.Reset;
                        ServiceOrder.SetRange("No.", Rec."Service Order No.");
                        if ServiceOrder.FindFirst() then
                            Page.RunModal(Page::"Service Order EDMS", ServiceOrder);
                    end;
                end;
            }
        }
        area(Processing)
        {
            action(Reopen)
            {
                ApplicationArea = Basic;
                Caption = 'Reopen';
                Image = ReOpen;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    WarrantyLine: Record "Warranty Document Line";
                begin
                    Rec.Closed := false;
                    Rec.Modify;
                    WarrantyLine.Reset();
                    WarrantyLine.SetRange("Document No.", Rec."No.");
                    if WarrantyLine.FindFirst() then
                        repeat
                            WarrantyLine.Closed := false;
                            WarrantyLine.Modify(false);
                        until WarrantyLine.Next = 0;
                end;
            }
        }
    }
}
