Page 25006773 "Integration Connector Setup"
{
    // #Owner EDMS.Integration

    Caption = 'Integration Connector Setup';
    DelayedInsert = true;
    PageType = List;
    SourceTable = "Integration Connector Setup";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(ConnectorCode; Rec."Connector Code")
                {
                    ApplicationArea = Basic;
                    Visible = false;
                }
                field(MethodCode; Rec."Method Code")
                {
                    ApplicationArea = Basic;
                }
                field(MethodDescription; Rec."Method Description")
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
                field(RequestHandlerCodeunitID; Rec."Request Handler Codeunit ID")
                {
                    ApplicationArea = Basic;
                }
                field(RequestExternalMethodName; Rec."Request External Method Name")
                {
                    ApplicationArea = Basic;
                }
                field(ResponseHandlerCodeunitID; Rec."Response Handler Codeunit ID")
                {
                    ApplicationArea = Basic;
                }
                field(ResponseExternalMethodName; Rec."Response External Method Name")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }
}

