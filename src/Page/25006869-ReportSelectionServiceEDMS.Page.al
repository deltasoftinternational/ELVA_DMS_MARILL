Page 25006869 "Report Selection - ServiceEDMS"
{
    ApplicationArea = Basic;
    Caption = 'Report Selection - Service EDMS';
    PageType = Worksheet;
    SaveValues = true;
    SourceTable = "Report Selections";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            field(ReportUsage2; ReportUsage2)
            {
                ApplicationArea = Basic;
                Caption = 'Usage';
                OptionCaption = 'Invoice,Credit Memo';

                trigger OnValidate()
                begin
                    SetUsageFilter;
                    ReportUsage2OnAfterValidate;
                end;
            }
            repeater(Control1)
            {
                field(Sequence; Rec.Sequence)
                {
                    ApplicationArea = Basic;
                }
                field(ReportID; Rec."Report ID")
                {
                    ApplicationArea = Basic;
                    LookupPageID = Objects;
                }
                field(ReportCaption; Rec."Report Caption")
                {
                    ApplicationArea = Basic;
                    DrillDown = false;
                    LookupPageID = Objects;
                }
            }
        }
        area(factboxes)
        {
            systempart(Control1900383207; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Control1905767507; Notes)
            {
                ApplicationArea = All;
                Visible = false;
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        ReportUsage2 := Reportusage2::Invoice;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.NewRecord;
    end;

    trigger OnOpenPage()
    begin
        SetUsageFilter;
    end;

    var
        ReportUsage2: Option Invoice,"Credit Memo";

    local procedure SetUsageFilter()
    begin
        Rec.FilterGroup(2);
        case ReportUsage2 of
            Reportusage2::Invoice:
                Rec.SetRange(Usage, Rec.Usage::"Pst.Serv.Inv.Edms");
            Reportusage2::"Credit Memo":
                Rec.SetRange(Usage, Rec.Usage::"Pst.Serv.Cr.M.Edms");
        end;
        Rec.FilterGroup(0);
    end;

    local procedure ReportUsage2OnAfterValidate()
    begin
        CurrPage.Update;
    end;
}

