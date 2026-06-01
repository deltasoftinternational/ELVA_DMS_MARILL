Page 25006771 "Integration Connectors EDMS"
{
    // #Owner EDMS.Integration

    ApplicationArea = Basic;
    Caption = 'Integration Connectors';
    CardPageID = "Integration Connector Card";
    Editable = false;
    PageType = List;
    SourceTable = "Integration Connector EDMS";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ConnectorCode; Rec."Connector Code")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(IsActive; Rec."Is Active")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(DealerID; Rec."Dealer ID")
                {
                    ApplicationArea = Basic;
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
                Visible = not Rec."Is Active";

                trigger OnAction()
                begin
                    Rec.ActivateConnector;
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
                Visible = Rec."Is Active";

                trigger OnAction()
                begin
                    Rec.DeactivateConnector;
                end;
            }
        }
        area(navigation)
        {
            action(MethodSetup)
            {
                ApplicationArea = Basic;
                Caption = 'Method Setup';
                Image = SetupLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Integration Connector Setup";
                RunPageLink = "Connector Code" = field("Connector Code");
            }
            action(ValueMapping)
            {
                ApplicationArea = Basic;
                Caption = 'Value Mapping';
                Image = ShowMatrix;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                RunObject = Page "Integration Connector Mapping";
                RunPageLink = "Connector Code" = field("Connector Code");
            }
        }
    }
}

