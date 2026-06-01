Page 25006770 "Integration Setup EDMS"
{
    // #Owner EDMS.Integration

    ApplicationArea = Basic;
    Caption = 'Integration Setup';
    DeleteAllowed = false;
    InsertAllowed = false;
    SourceTable = "Integration Setup EDMS";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(CompanyName; Rec."Company Name")
                {
                    ApplicationArea = Basic;

                    trigger OnAssistEdit()
                    begin
                        Rec."Company Name" := COMPANYNAME;
                        Rec.Modify;
                    end;
                }
                field(IntegrationIsActive; Rec."Integration Is Active")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Activate)
            {
                ApplicationArea = Basic;
                Caption = 'Activate';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = not Rec."Integration Is Active";

                trigger OnAction()
                begin
                    Rec.ActivateIntegration;
                end;
            }
            action(Deactivate)
            {
                ApplicationArea = Basic;
                Caption = 'Deactivate';
                Image = Reject;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                Visible = Rec."Integration Is Active";

                trigger OnAction()
                begin
                    Rec.DeactivateIntegration;
                end;
            }
        }
    }

    trigger OnOpenPage()
    begin
        Rec.Reset;
        if not Rec.Get then begin
            Rec.Init;
            Rec.Insert;
        end;
    end;
}

