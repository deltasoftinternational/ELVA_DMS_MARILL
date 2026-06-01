Page 25006295 "Resource Time Reg. Entries"
{
    ApplicationArea = Basic;
    Editable = false;
    PageType = List;
    SourceTable = "Resource Time Reg. Entry";
    SourceTableView = where(Canceled = const(false));
    UsageCategory = History;

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(EntryNo; Rec."Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(AllocationEntryNo; Rec."Allocation Entry No.")
                {
                    ApplicationArea = Basic;
                }
                field(ResourceNo; Rec."Resource No.")
                {
                    ApplicationArea = Basic;
                }
                field(EntryType; Rec."Entry Type")
                {
                    ApplicationArea = Basic;
                }
                field(Date; Rec.Date)
                {
                    ApplicationArea = Basic;
                }
                field(Time; Rec.Time)
                {
                    ApplicationArea = Basic;
                }
                field(TimeSpent; Rec."Time Spent")
                {
                    ApplicationArea = Basic;
                }
                field(Travel; Rec.Travel)
                {
                    ApplicationArea = Basic;
                }
                field(SourceType; Rec."Source Type")
                {
                    ApplicationArea = Basic;
                }
                field(SourceSubtype; Rec."Source Subtype")
                {
                    ApplicationArea = Basic;
                }
                field(SourceID; Rec."Source ID")
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
            group(ActionGroup25006012)
            {
                action(ModifyResourceTimeRegEntry)
                {
                    ApplicationArea = Basic;
                    Caption = 'Modify Last Entry Time';
                    Enabled = false;
                    Image = Edit;
                    Visible = false;

                    trigger OnAction()
                    begin
                        ResourceTimeRegMgt.CheckPostedDocumentForTimeEntryModify(Rec);
                        ResourceTimeRegMgt.ModifyLastTimeRegEntry(Rec);
                    end;
                }
                action(DeleteEntry)
                {
                    ApplicationArea = Basic;
                    Caption = 'Delete Entry';
                    Enabled = false;
                    Image = Delete;
                    Visible = false;

                    trigger OnAction()
                    begin
                        ResourceTimeRegMgt.CheckPostedDocumentForTimeEntryModify(Rec);
                        if Dialog.Confirm(Text001) then
                            Rec.Delete;
                    end;
                }
            }
        }
    }

    var
        ResourceTimeRegMgt: Codeunit "Resource Time Reg. Mgt.";
        Text001: label 'Are you sure you want to delete the entry?';
}

