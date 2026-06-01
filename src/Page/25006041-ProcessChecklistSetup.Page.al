Page 25006041 "Process Checklist Setup"
{
    // 10/08/2018 EB.P30 GH
    //   Added field:
    //     130 "Archive on Delete"

    ApplicationArea = Basic;
    Caption = 'Process Checklist Setup';
    PageType = Card;
    SourceTable = "Process Checklist Setup";
    UsageCategory = Tasks;

    layout
    {
        area(content)
        {
            group(General)
            {
                field(ProcessChecklistNos; Rec."Process Checklist Nos.")
                {
                    ApplicationArea = Basic;
                }
                field(CheckBoxChecked; Rec."CheckBox Checked")
                {
                    ApplicationArea = Basic;
                }
                field(CheckBoxUnchecked; Rec."CheckBox Unchecked")
                {
                    ApplicationArea = Basic;
                }
                field(ArchiveonDelete; Rec."Archive on Delete")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        rec.Reset;
        if not rec.Get then begin
            rec.Init;
            rec.Insert;
        end;
    end;
}

