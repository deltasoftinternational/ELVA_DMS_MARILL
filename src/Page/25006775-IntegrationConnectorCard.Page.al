Page 25006775 "Integration Connector Card"
{
    // #Owner EDMS.Integration

    Caption = 'Integration Connectors';
    PageType = Card;
    SourceTable = "Integration Connector EDMS";

    layout
    {
        area(content)
        {
            group(Group)
            {
                Caption = 'General';
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
                field(ActivationCodeunitID; Rec."Activation Codeunit ID")
                {
                    ApplicationArea = Basic;
                }
                field(DealerID; Rec."Dealer ID")
                {
                    ApplicationArea = Basic;
                }
                field(VendorID; Rec."Vendor ID")
                {
                    ApplicationArea = Basic;
                }
                field(MakeID; Rec."Make ID")
                {
                    ApplicationArea = Basic;
                }
                field(CustomerID; Rec."Customer ID")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Connection)
            {
                Caption = 'Connection';
                field(ConnectionAddress; Rec."Connection Address")
                {
                    ApplicationArea = Basic;
                }
                field(UserID; Rec."User ID")
                {
                    ApplicationArea = Basic;
                }
                field(Password; Rec.Password)
                {
                    ApplicationArea = Basic;
                }
            }
            group(WMQ)
            {
                Caption = 'WMQ';
                field(WMQHostname; Rec."WMQ Hostname")
                {
                    ApplicationArea = Basic;
                }
                field(WMQPort; Rec."WMQ Port")
                {
                    ApplicationArea = Basic;
                }
                field(WMQChannel; Rec."WMQ Channel")
                {
                    ApplicationArea = Basic;
                }
                field(WMQManager; Rec."WMQ Manager")
                {
                    ApplicationArea = Basic;
                }
                field(WMQAllowSendReceive; Rec."WMQ Allow Send/Receive")
                {
                    ApplicationArea = Basic;
                }
            }
            group(Additional)
            {
                Caption = 'Additional';
                field(MAXQueueToSend; Rec."MAX Queue To Send")
                {
                    ApplicationArea = Basic;
                }
                field(MAXQueueToReceive; Rec."MAX Queue To Receive")
                {
                    ApplicationArea = Basic;
                }
                field(AllowResetErrorsOnSend; Rec."Allow Reset Errors On Send")
                {
                    ApplicationArea = Basic;
                }
                field(AllowResetErrorsOnReceive; Rec."Allow Reset Errors On Receive")
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

