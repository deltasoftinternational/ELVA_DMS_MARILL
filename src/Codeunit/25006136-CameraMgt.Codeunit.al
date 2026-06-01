Codeunit 25006136 "Camera Mgt"
{

    trigger OnRun()
    begin
    end;

    var
        NoLinkEntityFoundErr: label 'No data Entity found to link pictures to.';
        LargerImageErr: label 'Can''t make image larger than it is.';
        TakeAPictureSuccessMsg: label 'Image uploaded successfully.';


    procedure CreateIncomingPictureFromServerFile(FileName: Text; FilePath: Text)
    var
        IncomingDocument: Record "Incoming Document";
        VehSerialNo: Code[20];
        Picture: Record Picture;
        PictureMgt: Codeunit "Picture Management";
    begin
        if (FileName = '') or (FilePath = '') then
            exit;

        VehSerialNo := '';
        if not SelectVehicle(VehSerialNo) then
            exit;


        CreatePictureRecord(FileName, '', Database::Vehicle, 0, VehSerialNo, VehSerialNo, Picture);
        //IncomingDocument.COPYFILTERS(Rec);
        //CreateIncomingDocument(FileName,'');

        AddAttachmentFromServerFile(FileName, FilePath, Picture);

        //COPYFILTERS(IncomingDocument);
        Message('Picture successfuly added to vehicle file');
    end;


    procedure CreatePictureRecord(NewDescription: Text; NewURL: Text; SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; VehicleSerialNo: Code[20]; var Picture: Record Picture): Integer
    begin
        Picture.Reset;
        Picture.Init;
        Picture.Insert(true);
        Picture.Validate("Source Type", SourceType);
        Picture.Validate("Source Subtype", SourceSubtype);
        Picture.Validate("Source ID", SourceID);
        Picture.Description := CopyStr(NewDescription, 1, MaxStrLen(Picture.Description));
        if VehicleSerialNo <> '' then
            Picture."Vehicle Serial No." := VehicleSerialNo
        else
            Picture."Vehicle Serial No." := GetVehicleSerialNo(SourceType, SourceSubtype, SourceID);

        Picture.Modify(true);
    end;


    procedure CreateIncomingPictureFromServerFileBySource(FileName: Text; FilePath: Text; SourceType: Integer; SourceSubType: Integer; SourceID: Code[20]; SourceRefNo: Integer; VehicleSerialNo: Code[20]) NewPictureNo: Code[20]
    var
        IncomingDocument: Record "Incoming Document";
        VehSerialNo: Code[20];
        Picture: Record Picture;
        PictureMgt: Codeunit "Picture Management";
    begin
        if (FileName = '') or (FilePath = '') then
            exit;

        CreatePictureBySource(FileName, '', SourceType, SourceSubType, SourceID, SourceRefNo, VehicleSerialNo, Picture);

        AddAttachmentFromServerFile(FileName, FilePath, Picture);

        //MESSAGE('Picture successfuly added to vehicle file');

        NewPictureNo := Picture."No."
    end;


    procedure CreatePictureBySource(NewDescription: Text; NewURL: Text; SourceType: Integer; SourceSubType: Integer; SourceID: Code[20]; SourceRefNo: Integer; VehicleSerialNo: Code[20]; var Picture: Record Picture): Integer
    begin
        Picture.Reset;
        Picture.Init;
        Picture.Insert(true);
        Picture.Validate("Source Type", SourceType);
        Picture.Validate("Source Subtype", SourceSubType);
        Picture.Validate("Source ID", SourceID);
        Picture.Validate("Source Ref. No.", SourceRefNo);
        Picture.Description := CopyStr(NewDescription, 1, MaxStrLen(Picture.Description));
        if VehicleSerialNo <> '' then
            Picture."Vehicle Serial No." := VehicleSerialNo
        else
            Picture."Vehicle Serial No." := GetVehicleSerialNo(SourceType, SourceSubType, SourceID);
        Picture.Modify(true);
    end;


    procedure CreateIncomingPictureFromBLOBBySource(SourceType: Integer; SourceSubType: Integer; SourceID: Code[20]; SourceRefNo: Integer; VehicleSerialNo: Code[20]) NewPictureNo: Code[20]
    var
        IncomingDocument: Record "Incoming Document";
        VehSerialNo: Code[20];
        Picture: Record Picture;
        PictureMgt: Codeunit "Picture Management";
    begin


        CreatePictureBySource('descr', '', SourceType, SourceSubType, SourceID, SourceRefNo, VehicleSerialNo, Picture);

        if (PictureMgt.BLOBImport(Picture, '')) then
            Message(TakeAPictureSuccessMsg);

        NewPictureNo := Picture."No."
    end;


    procedure AddAttachmentFromStream(var Picture: Record Picture; OrgFileName: Text; FileExtension: Text; var InStr: InStream)
    var
        FileManagement: Codeunit "File Management";
        OutStr: OutStream;
    begin

        Picture.TestField("No.");
        Picture.Blob.CreateOutstream(OutStr);
        CopyStream(OutStr, InStr);
        Picture.Modify(true);
        /*
        IncomingDocumentAttachment.SETRANGE("Incoming Document Entry No.","Entry No.");
        IF NOT IncomingDocumentAttachment.FINDLAST THEN
          IncomingDocumentAttachment."Line No." := 10000
        ELSE
          IncomingDocumentAttachment."Line No." += 10000;
        IncomingDocumentAttachment."Incoming Document Entry No." := "Entry No.";
        IncomingDocumentAttachment.INIT;
        IncomingDocumentAttachment.Name :=
          COPYSTR(FileManagement.GetFileNameWithoutExtension(OrgFileName),1,MAXSTRLEN(IncomingDocumentAttachment.Name));
        IncomingDocumentAttachment.VALIDATE(
          "File Extension",COPYSTR(FileExtension,1,MAXSTRLEN(IncomingDocumentAttachment."File Extension")));
        IncomingDocumentAttachment.Content.CREATEOUTSTREAM(OutStr);
        COPYSTREAM(OutStr,InStr);
        IncomingDocumentAttachment.INSERT(TRUE);
        */

    end;


    procedure AddAttachmentFromServerFile(FileName: Text; FilePath: Text; var Picture: Record Picture)
    var
        IncomingDocumentAttachment: Record "Incoming Document Attachment";
        FileManagement: Codeunit "File Management";
        File: File;
        InStr: InStream;
        TempBlob_L: Codeunit "Temp Blob";
    begin
        if (FileName = '') or (FilePath = '') then
            exit;

        // if not File.Open(FilePath) then
        //     exit;
        // File.CreateInstream(InStr);

        TempBlob_L.CreateInStream(InStr);
        if not UploadIntoStream('', '', '', FilePath, InStr) then
            exit;
        AddAttachmentFromStream(Picture, FileName, FileManagement.GetExtension(FileName), InStr);
        // File.Close;
        // if Erase(FilePath) then;//FixME
    end;

    local procedure SelectVehicle(var VehSerialNo: Code[20]): Boolean
    var
        Vehicle: Record Vehicle;
    begin
        Vehicle.Reset;
        if Page.RunModal(Page::"Vehicle List", Vehicle) = Action::LookupOK then begin
            VehSerialNo := Vehicle."Serial No.";
            exit(true);
        end;
        exit(false);
    end;


    procedure CreatePictureAndLinkToEntity(FileName: Text; FilePath: Text; Entity: Variant)
    var
        Picture: Record Picture;
        PictureMgt: Codeunit "Picture Management";
        SourceSubtype: Option;
        SourceId: Code[20];
        SourceRefNo: Integer;
        RecRef: RecordRef;
        FieldRef: FieldRef;
        ProcessChecklistHeader: Record "Process Checklist Header";
    begin
        if (FileName = '') or (FilePath = '') then
            exit;
        if not Entity.IsRecord then
            exit;

        RecRef.GetTable(Entity);
        case RecRef.Number of
            Database::"Process Checklist Header":
                begin
                    SourceSubtype := 0;
                    SourceId := RecRef.Field(ProcessChecklistHeader.FieldNo("No.")).Value;
                    SourceRefNo := 0;
                end;
        end;

        if (SourceId <> '') then begin
            if CreatePicture(FileName, FilePath, Picture) then begin
                Picture.Validate("Source Type", RecRef.Number);
                Picture.Validate("Source Subtype", SourceSubtype);
                Picture.Validate("Source ID", SourceId);
                Picture.Validate("Source Ref. No.", SourceRefNo);
                Picture."Vehicle Serial No." := GetVehicleSerialNo(RecRef.Number, SourceSubtype, SourceId);
                Picture.Modify;
            end;

        end else
            Error(NoLinkEntityFoundErr);

        //  if Erase(FilePath) then; //FIXME

        Message(TakeAPictureSuccessMsg);
    end;

    local procedure CreatePicture(FileName: Text; FilePath: Text; var Picture: Record Picture): Boolean
    var
        FileManagement: Codeunit "File Management";
        File: File;
        InStr: InStream;
        OutStr1: OutStream;
        OutStr2: OutStream;
        // Bitmap: dotnet Bitmap;
        // ImageFormat: dotnet ImageFormat;
        AspectRatio: Decimal;
        Width: Integer;
        Height: Integer;
        MaintainAspectRatio: Boolean;
        PictureMgtSetup: Record "Picture Mgt. Setup";
        image: Codeunit Image;
        imageformat: enum "Image Format";

    begin
        PictureMgtSetup.Get;
        if (FileName = '') or (FilePath = '') then
            exit;
        // if not File.Open(FilePath) then
        //     exit;
        Picture.Reset;
        Picture.Init;
        Picture."No." := '';
        Picture.Insert(true);
        Picture.TestField("No.");

        if not UploadIntoStream('', '', '', FilePath, InStr) then
            exit;

        Clear(Picture.Thumbnail);
        Clear(Picture.Blob);

        Picture.Blob.CreateOutstream(OutStr1);
        Picture.Thumbnail.CreateOutstream(OutStr2);
        CopyStream(OutStr1, InStr);
        Picture.Modify(true);


        Width := PictureMgtSetup."Thumbnail Width";
        Height := PictureMgtSetup."Thumbnail Height";
        if (Width = 0) or (Height = 0) then begin
            Width := 100;
            Height := 100;
        end;
        MaintainAspectRatio := true;

        // Bitmap := Bitmap.Bitmap(InStr); //FIXME

        if (Width >= image.getWidth()) or (Height >= image.getHeight()) then
            Error(LargerImageErr);

        if image.getWidth() / Width < image.getHeight() / Height then
            AspectRatio := image.getWidth() / Width
        else
            AspectRatio := image.getHeight() / Height;

        if MaintainAspectRatio then begin
            Height := ROUND(image.getHeight() / AspectRatio, 1);
            Width := ROUND(image.getWidth() / AspectRatio, 1);
        end;
        // Bitmap := Bitmap.Bitmap(Bitmap, Width, Height);
        // Bitmap.Save(OutStr2, ImageFormat.Jpeg);
        image.Resize(Width, Height);
        image.SetFormat(imageformat::Jpeg);
        image.Save(OutStr2);

        Picture.Description := CopyStr(FileName, 1, MaxStrLen(Picture.Description));
        Picture.Modify(true);
        //File.Close;
        exit(true);
    end;


    procedure DownloadPicture(No: Code[20])
    var
        Picture: Record Picture;
        InStr: InStream;
        OutStr: OutStream;
        fileName: Text;
        exportFile: File;
        FileManagement: Codeunit "File Management";
        TempBlob: Codeunit "Temp Blob";
    begin
        if Picture.Get(No) then begin
            Picture.CalcFields(Blob);
            if Picture.Blob.Hasvalue then begin
                //fileName := 'C:\images\export\' + 'ItemPictureFromStream' + FORMAT(Picture."No.") + '.jpg';
                fileName := Format(Picture."No.") + '.jpg';
                // exportFile.Create(fileName);
                // exportFile.CreateOutstream(OutStr);
                TempBlob.CreateOutStream(OutStr);
                Picture.Blob.CreateInstream(InStr);
                CopyStream(OutStr, InStr);
                // exportFile.Close;
                DownloadFromStream(InStr, '', '', '', fileName);
                // FileManagement.DownloadHandler(fileName, '', '', '',
                //   FileManagement.GetFileName(fileName));
            end;
        end;
    end;


    procedure PrintPictures(SourceType: Integer; SourceSubType: Integer; SourceID: Code[20]; SourceRefNo: Integer)
    var
        PrintPictures: Report "Print Pictures";
        Picture: Record Picture;
    begin
        Picture.Reset;
        Picture.SetRange("Source Type", SourceType);
        Picture.SetRange("Source Subtype", SourceSubType);
        Picture.SetRange("Source ID", SourceID);
        Picture.SetRange("Source Ref. No.", SourceRefNo);
        PrintPictures.SetTableview(Picture);
        PrintPictures.Run;
    end;

    local procedure GetVehicleSerialNo(SourceType: Integer; SourceSubType: Integer; SourceId: Code[20]): Code[20]
    var
        ServiceHeaderEDMS: Record "Service Header EDMS";
        ProcessChecklistHeader: Record "Process Checklist Header";
        Vehicle: Record Vehicle;
    begin
        case SourceType of
            Database::"Service Header EDMS":
                begin
                    if ServiceHeaderEDMS.Get(SourceSubType, SourceId) then
                        exit(ServiceHeaderEDMS."Vehicle Serial No.");
                end;
            Database::"Process Checklist Header":
                begin
                    if ProcessChecklistHeader.Get(SourceId) then
                        exit(ProcessChecklistHeader."Vehicle Serial No.");
                end;
            Database::Vehicle:
                begin
                    if Vehicle.Get(SourceId) then
                        exit(Vehicle."Serial No.");
                end;
        end;
    end;
}

