Page 25006772 "Integration Methods EDMS"
{
    // #Owner EDMS.Integration

    ApplicationArea = Basic;
    Caption = 'Integration Connectors';
    PageType = List;
    SourceTable = "Integration Method EDMS";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                IndentationColumn = NameIndent;
                IndentationControls = "Code", Description;
                field("Code"; Rec.Code)
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = Rec."Group Header";
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Style = Strong;
                    StyleExpr = Rec."Group Header";
                }
                field(GroupHeader; Rec."Group Header")
                {
                    ApplicationArea = Basic;
                }
                field(IsActive; Rec."Is Active")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(Alias; Rec.Alias)
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
            action(SuggestAllMethods)
            {
                ApplicationArea = Basic;
                Caption = 'Suggest All Methods';
                Image = SuggestLines;

                trigger OnAction()
                begin
                    Rec.SuggestMethods(0);
                end;
            }
            action(SuggestItemMethods)
            {
                ApplicationArea = Basic;
                Caption = 'Suggest Item Methods';
                Image = SuggestLines;

                trigger OnAction()
                begin
                    Rec.SuggestMethods(1);
                end;
            }
            action(SuggestVehicleMethods)
            {
                ApplicationArea = Basic;
                Caption = 'Suggest Vehicle Methods';
                Image = SuggestLines;

                trigger OnAction()
                begin
                    Rec.SuggestMethods(2);
                end;
            }
            action(Activate)
            {
                ApplicationArea = Basic;
                Caption = 'Activate';
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;

                trigger OnAction()
                var
                    Rec2: Record "Integration Method EDMS";
                begin
                    CurrPage.SetSelectionFilter(Rec2);
                    Rec.ActivateMethods(Rec2);
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

                trigger OnAction()
                var
                    Rec2: Record "Integration Method EDMS";
                begin
                    CurrPage.SetSelectionFilter(Rec2);
                    Rec.DeactivateMethods(Rec2);
                end;
            }
        }
    }

    trigger OnAfterGetRecord()
    begin
        if Rec."Group Header" then
            NameIndent := 0
        else
            NameIndent := 1;
    end;

    var
        [InDataSet]
        NameIndent: Integer;
}

