Page 25006086 "Deal Application Entries"
{
    ApplicationArea = Basic;
    Caption = 'Deal Application Entries';
    Editable = false;
    PageType = List;
    SourceTable = "Deal Application Entry";
    UsageCategory = Lists;

    layout
    {
        area(content)
        {
            repeater(Control1190000)
            {
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field(DetCustLedgEntryEDMS; Rec."Det. Cust. Ledg. Entry EDMS")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentType; Rec."Document Type")
                {
                    ApplicationArea = Basic;
                }
                field(DocumentNo; Rec."Document No.")
                {
                    ApplicationArea = Basic;
                }
                field(DocLineNo; Rec."Doc. Line No.")
                {
                    ApplicationArea = Basic;
                }
                field(AppliestoEntryNo; Rec."Applies-to Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(Application; Rec.Application)
                {
                    ApplicationArea = Basic;
                }
                field(EntryNo; Rec."Entry No.")
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

