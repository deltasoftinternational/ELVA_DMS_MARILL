Page 25006790 "EDMS IR Items"
{
    PageType = List;
    SourceTable = "User Integr. Session Line";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                    StyleExpr = LineStyleExpr;
                }
                field(ItemNo; Rec."Item No.")
                {
                    ApplicationArea = Basic;
                    StyleExpr = LineStyleExpr;
                }
                field(VariantCode; Rec."Variant Code")
                {
                    ApplicationArea = Basic;
                    StyleExpr = LineStyleExpr;
                }
                field(ItemDescription; Rec."Item Description")
                {
                    ApplicationArea = Basic;
                    StyleExpr = LineStyleExpr;
                }
                field(UnitOfMeasureCode; Rec."Unit Of Measure Code")
                {
                    ApplicationArea = Basic;
                    StyleExpr = LineStyleExpr;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                    StyleExpr = LineStyleExpr;
                }
                field(Quantity; Rec.Quantity)
                {
                    ApplicationArea = Basic;
                    StyleExpr = LineStyleExpr;
                }
                field(AvailableQuantity; Rec."Available Quantity")
                {
                    ApplicationArea = Basic;
                    StyleExpr = LineStyleExpr;
                }
                field(UnitCost; Rec."Unit Cost")
                {
                    ApplicationArea = Basic;
                    StyleExpr = LineStyleExpr;
                }
                field(TotalCost; Rec."Total Cost")
                {
                    ApplicationArea = Basic;
                    StyleExpr = LineStyleExpr;
                }
            }
        }
        area(factboxes)
        {
            part(Control25006005; "Integration Message Info Sub")
            {
                ApplicationArea = All;
                Caption = 'DMS Integration Info';
                SubPageLink = "Source Type" = const(25006791),
                              "Source Subtype" = const("0"),
                              //"Source ID"=field("Session ID"), //FIXME
                              "Source Ref. No." = field("Line No.");
            }
            part(Control25006004; "Integration Message Params Sub")
            {
                ApplicationArea = All;
                Caption = 'DMS Integration Params';
                SubPageLink = "Source Type" = const(25006791),
                              "Source Subtype" = const("0"),
                              //"Source ID"=field("Session ID"), //FIXME
                              "Source Ref. No." = field("Line No.");
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Start)
            {
                ApplicationArea = Basic;
                Caption = 'Start';
                Image = Start;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Message('Start Request');
                end;
            }
            action(RefreshStatus)
            {
                ApplicationArea = Basic;
                Caption = 'Refresh Status';
                Image = RefreshLines;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                begin
                    Message('Update Request Status');
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        LineStyleExpr := Rec.GetStatusStyleExpr;
    end;

    trigger OnOpenPage()
    begin
        Rec.FilterGroup(100);
        Rec.SetRange("Session ID", UserIntegrationSession.ID);
        Rec.FilterGroup(0);
    end;

    var
        UserIntegrationSession: Record "User Integr. Session Header";
        Mode: Integer;
        StartOnOpen: Boolean;
        [InDataSet]
        LineStyleExpr: Text;


    procedure SetUserSession(var NewUserIntegrationSession: Record "User Integr. Session Header"; NewMode: Integer; NewStartOnOpen: Boolean)
    begin
        UserIntegrationSession.Copy(NewUserIntegrationSession);
        Mode := NewMode;
        StartOnOpen := NewStartOnOpen;
    end;
}

