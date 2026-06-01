Page 25006104 "Checklist Card"
{
    // 17/08/2018 EB.P30 GH
    //   Modified triggers:
    //     OnNewRecord
    //     OnAfterGetCurrRecord
    // 
    // 09/08/2018 EB.P30 GH
    //   Added field:
    //     "No. of Archived Versions"
    //   Added action:
    //     ArchiveDocument

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
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(TemplateCode; Rec."Template Code")
                {
                    ApplicationArea = Basic;
                    ShowMandatory = true;

                    trigger OnValidate()
                    var
                        AddInData: Text;
                        Buffer: Record "Checklist Buffer" temporary;
                    begin
                        GHCheckListAddInManagement.FillCheckList(Rec, Buffer);
                        GHCheckListAddInManagement.CheckListRequestRefreshPage(AddInData, 0);
                        CurrPage.CheckList.RecieveRefreshCheckListData(AddInData);
                    end;
                }
                field("Checklist Category"; Rec."Checklist Category")
                {
                    ToolTip = 'Specifies the Category of this checklist. It comes from Template.';
                    ApplicationArea = All;
                    Editable = false;
                }

                field(VehicleRegistrationNo; Rec."Vehicle Registration No.")
                {
                    ApplicationArea = Basic;
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                    Visible = VehicleSerialNoVisible;
                }
                field(VehicleDescription; Rec.VehicleDescription)
                {
                    ApplicationArea = Basic;
                    Caption = 'Vehicle Description';
                }
                field("Sell-to Customer No."; Rec."Sell-to Customer No.")
                {
                    ApplicationArea = Basic;

                }
                field("Sell-to Customer Name"; Rec."Sell-to Customer Name")
                {
                    ApplicationArea = Basic;
                    Editable = false;
                }
                field(LocationCode; Rec."Location Code")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                }
                field(ProcessStatus; Rec."Process Status")
                {
                    ApplicationArea = Basic;
                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field(ConfirmedbyAdvisor; Rec."Confirmed by Advisor")
                {
                    ApplicationArea = Basic;
                }
            }
            group(CheckListLines)
            {
                Caption = 'Check List Lines';
                usercontrol(CheckList; CheckListAddIn)
                {
                    ApplicationArea = Basic;

                    trigger ControlAddInReady()
                    begin
                        UpdateLines;
                    end;

                    trigger RequestRefreshPage(ActLineNo: Integer)
                    var
                        AddInData: Text;
                        Buffer: Record "Checklist Buffer" temporary;
                    begin
                        GHCheckListAddInManagement.FillCheckList(Rec, Buffer);
                        GHCheckListAddInManagement.CheckListRequestRefreshPage(AddInData, ActLineNo);
                        CurrPage.CheckList.RecieveRefreshCheckListData(AddInData);
                    end;

                    trigger RequestTextChange(LineNo: Integer; CommentText: Text)
                    var
                        ChecklistAddInMgt: Codeunit "Checklist AddIn Management";
                    begin
                        //MESSAGE('Line No.: '+FORMAT(LineNo)+' Text Value: '+CommentText);
                        ChecklistAddInMgt.RequestTextChange(rec."No.", LineNo, CommentText);
                    end;

                    trigger RequestRadioChange(LineNo: Integer; RadioValue: Text)
                    var
                        ChecklistAddInMgt: Codeunit "Checklist AddIn Management";
                    begin
                        //MESSAGE('RequestRadioChange\Line No.: '+FORMAT(LineNo)+' Radio Value: '+FORMAT(RadioValue));
                        ChecklistAddInMgt.RequestRadioChange(rec."No.", LineNo, RadioValue);
                    end;

                    trigger RequestCheckChange(LineNo: Integer; CheckValue: Text)
                    var
                        ChecklistAddInMgt: Codeunit "Checklist AddIn Management";
                    begin
                        //MESSAGE('RequestCheckChange\Line No.: '+FORMAT(LineNo)+' Check Value: '+FORMAT(CheckValue));
                        ChecklistAddInMgt.RequestCheckChange(rec."No.", LineNo, CheckValue);
                    end;

                    trigger RequestAssistEditButton(LineNo: Integer)
                    begin
                        //MESSAGE('Line No.: '+FORMAT(LineNo));
                    end;

                    trigger RequestButton(LineNo: Integer)
                    begin
                        //MESSAGE('Line No.: '+FORMAT(LineNo));
                    end;

                    trigger RequestLastFocusField(LineNo: Integer)
                    begin
                        //MESSAGE('Line No.: '+FORMAT(LineNo));
                    end;

                    trigger RequestExtendedText(LineNo: Integer; CommentText: Text)
                    var
                        ChecklistAddInMgt: Codeunit "Checklist AddIn Management";
                    begin
                        //MESSAGE('Line No.: '+FORMAT(LineNo)+' Value:'+CommentText);

                        ChecklistAddInMgt.RequestExtendedText(rec."No.", LineNo, CommentText);
                        //MESSAGE('Got text: ' + ExtendedText.GetFieldData());
                    end;

                }
            }
            group(Details)
            {
                Caption = 'Details';
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
            }
            group(Reference)
            {
                Caption = 'Reference';
                field(SourceType; Rec."Source Type")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    Editable = false;
                }
                field(SourceSubtype; Rec."Source Subtype")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    Editable = false;
                }
                field(SourceID; Rec."Source ID")
                {
                    ApplicationArea = Basic;
                    Importance = Additional;
                    Editable = false;
                }
                field(ReferenceDescription; ReferenceDescription)
                {
                    ApplicationArea = Basic;
                    Caption = 'Reference Description';
                    Editable = false;
                }
                field(VHCNo; Rec."VHC No.")
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
            action("Print CheckList")
            {
                ApplicationArea = Basic;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    PrintCheckList: Report "Print Checklist";
                    GHCheckListBuffer: Record "Checklist Buffer" temporary;
                begin
                    GHCheckListAddInManagement.FillCheckList(Rec, GHCheckListBuffer);
                    PrintCheckList.FillItemCheckList(GHCheckListBuffer);
                    PrintCheckList.SetCheckListHeader(Rec);
                    PrintCheckList.Run;
                end;
            }
            action("Take a Picture")
            {
                ApplicationArea = Basic;
                Image = Camera;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                Visible = HasCamera;

                trigger OnAction()
                var
                    // CameraOptions: dotnet CameraOptions;
                    PictureMgtSetup: Record "Picture Mgt. Setup";
                    Picture: Record Picture;
                    Camera: Codeunit camera;
                    InstreamPic: InStream;
                    PicName: Text;
                    Out: OutStream;
                    NoSeriesMgt: Codeunit "No. Series";
                begin
                    if not HasCamera then
                        exit;

                    //CameraOptions := CameraOptions.CameraOptions;

                    PictureMgtSetup.Get;
                    if PictureMgtSetup."Camera Picture Quality" = 0 then
                        // CameraOptions.Quality := 100 // 100%*
                         Camera.GetPicture(100, InstreamPic, PicName)
                    else
                        Camera.GetPicture(PictureMgtSetup."Camera Picture Quality", InstreamPic, PicName);
                    Picture.Init();
                    Picture.Validate("Source Type", Database::"Process Checklist Header");
                    // Picture.Validate("Source Subtype", Rec."Source Subtype");
                    Picture.Validate("Source ID", Rec."No.");
                    Clear(Picture.Blob);
                    Picture.Blob.CreateOutStream(Out);
                    CopyStream(Out, InstreamPic);
                    Picture."No." := NoSeriesMgt.GetNextNo(PictureMgtSetup."Picture Nos.", 0D, true);
                    Picture.Description := PicName;
                    Picture.Default := false;
                    Picture.Insert(true);
                    // CameraOptions.Quality := PictureMgtSetup."Camera Picture Quality";
                    // CameraProvider.RequestPictureAsync(CameraOptions);
                end;
            }
            action("Upload Picture")
            {
                ApplicationArea = Basic;
                Image = Import;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    //CameraOptions: dotnet CameraOptions;
                    CameraMgt: Codeunit "Camera Mgt";
                    PictureMgtSetup: Record "Picture Mgt. Setup";
                begin
                    PictureMgtSetup.Get;
                    if CurrentClientType in [Clienttype::Phone, Clienttype::Tablet] then begin
                        /* CameraOptions := CameraOptions.CameraOptions();
                         CameraOptions.SourceType := 'PhotoLibrary';
                         CameraOptions.EncodingType := 'JPEG, PNG';
                         if PictureMgtSetup."Camera Picture Quality" = 0 then
                            CameraOptions.Quality := 100 // 100%
                         else
                             CameraOptions.Quality := PictureMgtSetup."Camera Picture Quality";
                         CameraProvider.RequestPictureAsync(CameraOptions);*/// FIXME
                    end else begin
                        CameraMgt.CreateIncomingPictureFromBLOBBySource(Database::"Process Checklist Header", 0, Rec."No.", 0, Rec."Vehicle Serial No.");
                    end;
                end;
            }
            action("Print Pictures")
            {
                ApplicationArea = Basic;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;
                Visible = false;

                trigger OnAction()
                var
                    CameraMgt: Codeunit "Camera Mgt";
                begin
                    CameraMgt.PrintPictures(Database::"Process Checklist Header", 0, Rec."No.", 0);
                end;
            }
            action(Confirm)
            {
                ApplicationArea = Basic;
                Image = Approve;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    GHFeatureMgt: Codeunit "Checklist Features Mgt.";
                begin
                    ChecklistFeaturesMgt.ValidateChecklist(Rec);
                    //GHFeatureMgt.ConfirmChecklist(Rec);
                    Rec.Validate("Confirmed by Advisor", true);
                    Rec.Modify(true);
                end;
            }
            action(ArchiveDocument)
            {
                ApplicationArea = Basic;
                Caption = 'Archi&ve Document';
                Image = Archive;

                trigger OnAction()
                var
                    ArchiveManagement: Codeunit ArchiveManagement;
                begin
                    VehicleProposalMgtEDMS.ArchiveProcessChecklistDocument(Rec);
                    CurrPage.Update(false);
                end;
            }
            action(PrintSign)
            {
                ApplicationArea = Basic;
                Caption = 'Print & Sign';
                Image = Signature;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SignManagement: Codeunit "Sign Management";
                begin
                    SignManagement.CallSignAndPrintPageChecklist(Rec);
                end;
            }
            action(EmailSign)
            {
                ApplicationArea = Basic;
                Caption = 'Email & Sign';
                Image = Signature;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    SignManagement: Codeunit "Sign Management";
                begin
                    SignManagement.CallSignAndEmailPageChecklist(Rec);
                end;
            }
        }
        area(navigation)
        {
            action(DocPictureList)
            {
                ApplicationArea = Basic;
                Caption = 'Document Pictures';
                Image = Picture;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page Pictures;
                RunPageLink = "Source Type" = const(25006025),
                              "Source ID" = field("No.");
            }
            action(VehPictureList)
            {
                ApplicationArea = Basic;
                Caption = 'Vehicle Pictures';
                Image = Picture;
                Promoted = true;
                PromotedCategory = Process;
                RunObject = Page Pictures;
                RunPageLink = "Vehicle Serial No." = field("Vehicle Serial No.");
            }
        }
    }

    trigger OnAfterGetCurrRecord()
    var
        AddInData: Text;
        Buffer: Record "Checklist Buffer" temporary;
    begin
        ReferenceDescription := GHFeaturesMgt.ChecklistReferenceDescription(Rec."Source Type", Rec."Source Subtype", Rec."Source ID");  // 17/08/2018 EB.P30 GH
        GHCheckListAddInManagement.FillCheckList(Rec, Buffer);
        GHCheckListAddInManagement.CheckListRequestRefreshPage(AddInData, 0);
        CurrPage.CheckList.RecieveRefreshCheckListData(AddInData);
    end;

    trigger OnAfterGetRecord()
    var
        AddInData: Text;
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
    var
        Camera: Codeunit Camera;
    begin
        HasCamera := Camera.IsAvailable;
        //IF HasCamera THEN
        //  CameraProvider := CameraProvider.Create;
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    begin
        ChecklistFeaturesMgt.ValidateChecklist(Rec);

        if Rec."Process Status" <> Rec."process status"::Completed then
            if Confirm('Is the checklist complete?', true) then
                SetChecklistComplete;
    end;

    var
        GHCheckListAddInManagement: Codeunit "Checklist AddIn Management";
        // [RunOnClient]
        // [WithEvents]
        // CameraProvider: dotnet CameraProvider;//FIXME
        HasCamera: Boolean;
        ChecklistHeader: Record "Process Checklist Header";
        VehicleSerialNoVisible: Boolean;
        ProcessChecklistSetup: Record "Process Checklist Setup";
        ArchiveManagement: Codeunit ArchiveManagement;
        VehicleProposalMgtEDMS: Codeunit "Vehicle Proposal Mgt. EDMS";
        GHFeaturesMgt: Codeunit "Checklist Features Mgt.";
        ReferenceDescription: Text;
        ChecklistFeaturesMgt: Codeunit "Checklist Features Mgt.";

    local procedure UpdateLines()
    var
        AddInData: Text;
        Buffer: Record "Checklist Buffer" temporary;
    begin
        GHCheckListAddInManagement.FillCheckList(Rec, Buffer);
        GHCheckListAddInManagement.CheckListControlAddInReady(AddInData);
        CurrPage.CheckList.RecieveInitCheckListData(AddInData);
    end;

    local procedure CaptionText(): Text
    begin
        //EXIT(STRSUBSTNO('%1 %2 %3 %4',Type,"Template Code","Vehicle Registration No.",VehicleDescription));
    end;

    local procedure SetChecklistInProgress()
    begin
        if Rec."Process Status" <> Rec."process status"::"In Progress" then
            Rec.Validate("Process Status", Rec."process status"::"In Progress");
    end;

    local procedure SetChecklistComplete()
    var
        ProcessChecklistHeader: Record "Process Checklist Header";
    begin
        if Rec."Process Status" <> Rec."process status"::Completed then begin
            Rec.Validate("Process Status", Rec."process status"::Completed);
            CurrPage.Update;
        end;
        /*
        ProcessChecklistHeader.GET("No.");
        IF ProcessChecklistHeader."Process Status" <> ProcessChecklistHeader."Process Status"::Completed THEN BEGIN
          ProcessChecklistHeader.VALIDATE("Process Status","Process Status"::Completed);
          ProcessChecklistHeader.MODIFY(TRUE);
        END;
        CurrPage.UPDATE;
        */

    end;

    /* FIXME    
    trigger Cameraprovider::PictureAvailable(PictureName: Text; PictureFilePath: Text)
    var
        CameraMgt: Codeunit "Camera Mgt";
    begin
        CameraMgt.CreatePictureAndLinkToEntity(PictureName, PictureFilePath, Rec);
        CurrPage.Update;
    end;
    */
}

