Page 25006106 "Checklist List Arch."
{
    // 09/08/2018 EB.P30 GH
    //   Created

    Caption = 'Process Checklist List Archive';
    CardPageID = "Checklist Card Arch.";
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = "Process Checklist Header Arch.";

    layout
    {
        area(content)
        {
            repeater(Group)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                }
                field(NoSeries; Rec."No. Series")
                {
                    ApplicationArea = Basic;
                }
                field(VIN; Rec.VIN)
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
                field(TemplateCode; Rec."Template Code")
                {
                    ApplicationArea = Basic;
                }
                field(Status; Rec.Status)
                {
                    ApplicationArea = Basic;
                }
                field(ProcessDate; Rec."Process Date")
                {
                    ApplicationArea = Basic;
                }
                field(TimeArchived; Rec."Time Archived")
                {
                    ApplicationArea = Basic;
                }
                field(DateArchived; Rec."Date Archived")
                {
                    ApplicationArea = Basic;
                }
                field(ArchivedBy; Rec."Archived By")
                {
                    ApplicationArea = Basic;
                }
                field(VersionNo; Rec."Version No.")
                {
                    ApplicationArea = Basic;
                }
                field(DocNoOccurrence; Rec."Doc. No. Occurrence")
                {
                    ApplicationArea = Basic;
                }
                field(ProcessStatus; Rec."Process Status")
                {
                    ApplicationArea = Basic;
                }
                field(CreationDate; Rec."Creation Date")
                {
                    ApplicationArea = Basic;
                }
                field(CreationTime; Rec."Creation Time")
                {
                    ApplicationArea = Basic;
                }
                field(CompletionDate; Rec."Completion Date")
                {
                    ApplicationArea = Basic;
                }
                field(CompletionTime; Rec."Completion Time")
                {
                    ApplicationArea = Basic;
                }
                field(CompletedbyUserID; Rec."Completed by User ID")
                {
                    ApplicationArea = Basic;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = Basic;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleRegistrationNo; Rec."Vehicle Registration No.")
                {
                    ApplicationArea = Basic;
                }
                field(ConfirmedbyAdvisor; Rec."Confirmed by Advisor")
                {
                    ApplicationArea = Basic;
                }
                field(VHCNo; Rec."VHC No.")
                {
                    ApplicationArea = Basic;
                }
                field("Checklist Category"; Rec."Checklist Category")
                {
                    ToolTip = 'Specifies the Checklist Category.';
                    ApplicationArea = All;
                }
            }
        }
    }

    actions
    {
    }
}

