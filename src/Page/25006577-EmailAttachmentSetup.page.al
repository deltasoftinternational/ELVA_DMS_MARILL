/*page 25006577 "Email Attachment Setup"
{
    PageType = List;
    ApplicationArea = All;
    UsageCategory = Lists;
    SourceTable = "Email Attachment Setup";
    DelayedInsert = true;

    layout
    {
        area(Content)
        {
            repeater(GroupName)
            {

                field("Report ID"; "Report ID")
                {
                    ApplicationArea = All;

                }
                field("Location Code"; "Location Code")
                {
                    ApplicationArea = All;
                }
                field("Deal Type Code"; "Deal Type Code")
                {
                    ApplicationArea = All;

                }
                field("Attachment Name"; "Attachment Name")
                {
                    ApplicationArea = All;

                }
                field(HasAttachment; HasAttachment)
                {
                    Caption = 'Has Attachment';
                    ApplicationArea = All;

                }

            }
        }
        area(Factboxes)
        {

        }
    }

    actions
    {
        area(Processing)
        {
            action(SelectFile)
            {
                ApplicationArea = All;
                Caption = 'Select File';
                Promoted = true;
                PromotedIsBig = true;
                Image = Import;
                PromotedCategory = Process;
                trigger OnAction();
                begin
                    ImportFile;
                end;
            }
            action(DeleteFile)
            {
                ApplicationArea = All;
                Caption = 'Delete File';
                Promoted = true;
                PromotedIsBig = true;
                Image = Delete;
                PromotedCategory = Process;
                trigger OnAction();
                begin
                    DeleteFile;
                end;
            }
        }
    }
    var
        HasAttachment: Boolean;

    trigger OnAfterGetRecord()
    var
    begin
        HasAttachment := Attachment.HASVALUE;
    end;


    trigger OnNewRecord(BelowxRec: Boolean)
    var
    begin
        ID := CreateGuid();
        HasAttachment := false;
    end;
}*/