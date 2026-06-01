Page 25006524 "Vehicle Opt. Jnl. Lines"
{
    // 19.06.2004 EDMS P1
    //    * Created

    Caption = 'Vehicle Option Journal Lines';
    Editable = false;
    PageType = List;
    SourceTable = "Vehicle Opt. Jnl. Line";

    layout
    {
        area(content)
        {
            repeater(Control1)
            {
                field(JournalTemplateName; Rec."Journal Template Name")
                {
                    ApplicationArea = Basic;
                }
                field(LineNo; Rec."Line No.")
                {
                    ApplicationArea = Basic;
                }
                field(PostingDate; Rec."Posting Date")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(JournalBatchName; Rec."Journal Batch Name")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentDate; Rec."Document Date")
                {
                    ApplicationArea = Basic;
                }
                field(PostingNoSeries; Rec."Posting No. Series")
                {
                    ApplicationArea = Basic;
                }
                field(ExternalDocumentNo; Rec."External Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(SourceCode; Rec."Source Code")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field(OptionType; Rec."Option Type")
                {
                    ApplicationArea = Basic;
                }
                field(OptionCode; Rec."Option Code")
                {
                    ApplicationArea = Basic;
                }
                field(ExternalCode; Rec."External Code")
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
                field(Standard; Rec.Standard)
                {
                    ApplicationArea = Basic;
                }
                field(OptionSubtype; Rec."Option Subtype")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(Description2; Rec."Description 2")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
        area(navigation)
        {
            group(Line)
            {
                Caption = '&Line';
                action(ShowBatch)
                {
                    ApplicationArea = Basic;
                    Caption = 'Show Batch';
                    Image = Description;

                    trigger OnAction()
                    begin
                        recVehOptJnlTemplate.Get(Rec."Journal Template Name");
                        recVehOptJnlLine := Rec;
                        recVehOptJnlLine.FilterGroup(2);
                        recVehOptJnlLine.SetRange("Journal Template Name", Rec."Journal Template Name");
                        recVehOptJnlLine.SetRange("Journal Batch Name", Rec."Journal Batch Name");
                        recVehOptJnlLine.FilterGroup(0);
                        Page.Run(recVehOptJnlTemplate."Form ID", recVehOptJnlLine);
                    end;
                }
            }
        }
    }

    var
        recVehOptJnlLine: Record "Vehicle Opt. Jnl. Line";
        recVehOptJnlTemplate: Record "Vehicle Opt. Jnl. Template";
}

