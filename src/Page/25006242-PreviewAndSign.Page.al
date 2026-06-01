Page 25006242 "Preview And Sign"
{
    // 
    // 02.05.2017 EB.P7
    //   Created

    Caption = 'Preview And Sign';
    PageType = StandardDialog;
    SourceTable = "Email Item";
    SourceTableTemporary = true;

    layout
    {
        area(content)
        {
            field("Attachment Name"; AttachmentFileName)
            {
                ApplicationArea = Basic;
                Caption = 'Preview';
                Editable = false;

                trigger OnAssistEdit()
                var
                begin
                    DownloadFromStream(AttachmentFileIns, SaveFileDialogTitleMsg, '', SaveFileDialogFilterMsg, AttachmentFileName);
                end;
            }
            label(SignatureCaption)
            {
                ApplicationArea = Basic;
                CaptionClass = '3,' + SignatureCaption;
                Caption = 'SignatureCaption';
            }
            usercontrol(TouchSign; TouchSignAddIn)
            {
                ApplicationArea = Basic;

                trigger ControlAddInReady()
                begin
                    CurrPage.TouchSign.RecieveSetDocumentNo(DocumentType, DocumentNo);
                end;

                trigger RecieveTouchSignData(RecievedDocumentType: Code[20]; RecievedDocumentNo: Code[20]; SignImg: Text)
                var
                    Img: Text;
                begin
                    SignManagement.SetDocumentSignature(RecievedDocumentType, RecievedDocumentNo, SignImg, SignatureType);
                end;

                trigger RecieveClearSignData(RecievedDocumentType: Code[20]; RecievedDocumentNo: Code[20]; SignImg: Text)
                var
                    Img: Text;
                begin
                    SignManagement.ClearDocumentSignature(RecievedDocumentType, RecievedDocumentNo, SignImg, SignatureType);
                end;
            }
            field(SignatureName; SignatureName)
            {
                ApplicationArea = Basic;
                Caption = 'Name';
            }
        }
    }

    actions
    {
    }

    trigger OnInit()
    begin
        SignatureCaption := 'test';
    end;

    trigger OnOpenPage()
    var
        OrigMailBodyText: Text;
    begin
    end;

    trigger OnQueryClosePage(CloseAction: action): Boolean
    var
        ServiceHeader: Record "Service Header EDMS";
        SalesHeader: Record "Sales Header";
        ChecklistHeader: Record "Process Checklist Header";
        InStream: InStream;
    begin
        if CloseAction = Action::OK then
            case DocumentType of
                'SERVICE ORDER':
                    begin
                        if ServiceHeader.Get(ServiceHeader."document type"::Order, DocumentNo) then begin
                            ServiceHeader.CalcFields("Employee Signature Image", "Customer Signature Image");
                            if SignatureType = 'EMPLOYEE' then begin
                                ServiceHeader."Employee Signature Image".CreateInstream(InStream);
                                if SignManagement.GetBlobSize(InStream) < 1000 then
                                    Error(SignatureFieldIsEmptyTxt)
                            end else begin
                                ServiceHeader."Customer Signature Image".CreateInstream(InStream);
                                if SignManagement.GetBlobSize(InStream) < 1000 then
                                    Error(SignatureFieldIsEmptyTxt)
                            end;
                        end;
                    end;
                'SALES ORDER':
                    begin
                        if SalesHeader.Get(SalesHeader."document type"::Order, DocumentNo) then begin
                            SalesHeader.CalcFields("Employee Signature Image", "Customer Signature Image");
                            if SignatureType = 'EMPLOYEE' then begin
                                SalesHeader."Employee Signature Image".CreateInstream(InStream);
                                if SignManagement.GetBlobSize(InStream) < 1000 then
                                    Error(SignatureFieldIsEmptyTxt)
                            end else begin
                                SalesHeader."Customer Signature Image".CreateInstream(InStream);
                                if SignManagement.GetBlobSize(InStream) < 1000 then
                                    Error(SignatureFieldIsEmptyTxt)
                            end;
                        end;
                    end;
                'CHECKLIST':
                    begin
                        if ChecklistHeader.Get(DocumentNo) then begin
                            ChecklistHeader.CalcFields("Employee Signature Image", "Customer Signature Image");
                            if SignatureType = 'EMPLOYEE' then begin
                                ChecklistHeader."Employee Signature Image".CreateInstream(InStream);
                                if SignManagement.GetBlobSize(InStream) < 1000 then
                                    Error(SignatureFieldIsEmptyTxt)
                            end else begin
                                ChecklistHeader."Customer Signature Image".CreateInstream(InStream);
                                if SignManagement.GetBlobSize(InStream) < 1000 then
                                    Error(SignatureFieldIsEmptyTxt)
                            end;
                        end;
                    end;
            end
    end;

    var
        AttachmentFileIns: InStream;
        AttachmentFileName: Text;
        SaveFileDialogTitleMsg: Text;
        SaveFileDialogFilterMsg: Text;
        FileManagement: Codeunit "File Management";
        DocumentNo: Code[20];
        DocumentType: Code[20];
        SignManagement: Codeunit "Sign Management";
        SignatureName: Text[250];
        SignatureType: Code[20];
        SignatureCaption: Text;
        CustSignatureCaptionLbl: label 'Customer Signature:';
        EmplSignatureCaptionLbl: label 'Witness Signature:';
        SignatureFieldIsEmptyTxt: label 'Signature field is empty. Please write a signature.';


    procedure SetValues(DocumentTypeToSet: Code[20]; DocumentNoToSet: Code[20]; var TempBlob: Codeunit "Temp Blob"; AttachmentFileNamePar: Text; SaveFileDialogTitleMsgPar: Text; SaveFileDialogFilterMsgPar: Text; SignatureTypePar: Code[20])
    begin
        DocumentType := DocumentTypeToSet;
        DocumentNo := DocumentNoToSet;
        AttachmentFileName := AttachmentFileNamePar;
        TempBlob.CreateInStream(AttachmentFileIns);
        SaveFileDialogTitleMsg := SaveFileDialogTitleMsgPar;
        SaveFileDialogFilterMsg := SaveFileDialogFilterMsgPar;
        SignatureType := SignatureTypePar;

        if SignatureType = 'CUSTOMER' then
            SignatureCaption := CustSignatureCaptionLbl
        else
            SignatureCaption := EmplSignatureCaptionLbl;
    end;


    procedure GetName(): Text[250]
    begin
        exit(SignatureName);
    end;
}

