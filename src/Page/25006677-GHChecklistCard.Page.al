Page 25006677 "GH Checklist Card"
{
    //For CT

    Caption = 'Checklist Card';
    LinksAllowed = false;
    PageType = Document;
    PopulateAllFields = true;
    RefreshOnActivate = true;
    SourceTable = "Process Checklist Header";

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(No; Rec."No.")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field(TemplateCode; Rec."Template Code")
                {
                    ApplicationArea = All;
                    ShowMandatory = true;
                }
                field("Checklist Category"; Rec."Checklist Category")
                {
                    ToolTip = 'Specifies the Category of this checklist. It comes from Template.';
                    ApplicationArea = All;
                    Editable = false;
                }

                field(VehicleRegistrationNo; Rec."Vehicle Registration No.")
                {
                    ApplicationArea = All;
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = All;
                }
                field(VehicleDescription; Rec.VehicleDescription)
                {
                    ApplicationArea = All;
                    Caption = 'Vehicle Description';
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = All;

                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = All;
                    Editable = false;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                }
                field(ProcessStatus; Rec."Process Status")
                {
                    ApplicationArea = All;
                }
                field(ConfirmedbyAdvisor; Rec."Confirmed by Advisor")
                {
                    ApplicationArea = All;
                }
                field(Make; Rec.Make)
                {
                    ApplicationArea = All;
                }
                field(Model; Rec.Model)
                {
                    ApplicationArea = All;
                }
            }
            group(Details)
            {
                Caption = 'Details';
                field(CreationDate; Rec."Creation Date")
                {
                    ApplicationArea = All;
                }
                field(CreationTime; Rec."Creation Time")
                {
                    ApplicationArea = All;
                }
                field(CompletionDate; Rec."Completion Date")
                {
                    ApplicationArea = All;
                }
                field(CompletionTime; Rec."Completion Time")
                {
                    ApplicationArea = All;
                }
                field(CompletedbyUserID; Rec."Completed by User ID")
                {
                    ApplicationArea = All;
                }
                field(Type; Rec.Type)
                {
                    ApplicationArea = All;
                }
            }
            group(Reference)
            {
                Caption = 'Reference';
                field(SourceType; Rec."Source Type")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Editable = false;
                }
                field(SourceSubtype; Rec."Source Subtype")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Editable = false;
                }
                field(SourceID; Rec."Source ID")
                {
                    ApplicationArea = All;
                    Importance = Additional;
                    Editable = false;
                }
                field(ReferenceDescription; ReferenceDescription)
                {
                    ApplicationArea = All;
                    Caption = 'Reference Description';
                    Editable = false;
                }
                field(VHCNo; Rec."VHC No.")
                {
                    ApplicationArea = All;
                }
            }
        }
    }


    trigger OnAfterGetCurrRecord()
    var
        AddInData: Text;
        Buffer: Record "Checklist Buffer" temporary;
    begin
        ReferenceDescription := GHFeaturesMgt.ChecklistReferenceDescription(Rec."Source Type", Rec."Source Subtype", Rec."Source ID");  // 17/08/2018 EB.P30 GH
    end;

    trigger OnAfterGetRecord()
    var
    begin
    end;

    trigger OnDeleteRecord(): Boolean
    begin
        ProcessChecklistSetup.Get;
        if ProcessChecklistSetup."Archive on Delete" then begin
            Clear(VehicleProposalMgtEDMS);
            VehicleProposalMgtEDMS.ArchiveProcessChecklistDocumentNoConfirm(Rec);
        end;
    end;

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.Type := Rec.Type::"Vehicle Inspection";               // 17/08/2018 EB.P30 GH
    end;

    trigger OnOpenPage()
    begin
        //HasCamera := CameraProvider.IsAvailable;
        //IF HasCamera THEN
        //  CameraProvider := CameraProvider.Create;
    end;

    var
        GHCheckListAddInManagement: Codeunit "Checklist AddIn Management";
        ChecklistHeader: Record "Process Checklist Header";
        VehicleSerialNoVisible: Boolean;
        ProcessChecklistSetup: Record "Process Checklist Setup";
        ArchiveManagement: Codeunit ArchiveManagement;
        VehicleProposalMgtEDMS: Codeunit "Vehicle Proposal Mgt. EDMS";
        GHFeaturesMgt: Codeunit "Checklist Features Mgt.";
        ReferenceDescription: Text;
        ChecklistFeaturesMgt: Codeunit "Checklist Features Mgt.";



    local procedure CaptionText(): Text
    begin
        //EXIT(STRSUBSTNO('%1 %2 %3 %4',Type,"Template Code","Vehicle Registration No.",VehicleDescription));
    end;

    local procedure SetChecklistInProgress()
    begin
        if Rec."Process Status" <> Rec."process status"::"In Progress" then
            Rec.Validate("Process Status", Rec."process status"::"In Progress");
    end;


}