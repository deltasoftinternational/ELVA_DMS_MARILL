Codeunit 25006015 "Picture Management"
{

    trigger OnRun()
    begin
    end;

    var
        Text007: label 'Import';
        Text009: label 'Image files|*.bmp;*.emf;*.gif;*.ico;*.jpg;*.jpeg;*.png;*.tiff;*.wmf';
        NoLinkEntityFoundErr: label 'No data Entity found to link pictures to.';
        LargerImageErr: label 'Can''t make image larger than it is.';
        TakeAPictureSuccessMsg: label 'Image uploaded successfully.';


    procedure BLOBImport(var PictureRef: Record Picture temporary; Name: Text): Boolean
    var
        NVInStream: InStream;
        NVInStream1: InStream;
        NVOutStream1: OutStream;
        NVOutStream2: OutStream;
        UploadResult: Boolean;
        ErrorMessage: Text;
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
        ClearLastError;
        // There is no way to check if NVInStream is null before using it after calling the
        // UPLOADINTOSTREAM therefore if result is false this is the only way we can throw the error.
        UploadResult := UploadIntoStream(Text007, '', Text009, Name, NVInStream);
        if UploadResult then begin
            PictureRef.Blob.CreateOutstream(NVOutStream1);
            PictureRef.Thumbnail.CreateOutstream(NVOutStream2);
            CopyStream(NVOutStream1, NVInStream);
            PictureRef.Modify(true);

            PictureRef.Blob.CreateInStream(NVInStream1);

            Width := PictureMgtSetup."Thumbnail Width";
            Height := PictureMgtSetup."Thumbnail Height";
            if (Width = 0) or (Height = 0) then begin
                Width := 100;
                Height := 100;
            end;
            MaintainAspectRatio := true;
            image.FromStream(NVInStream1);

            // Bitmap := Bitmap.Bitmap(NVInStream);

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
            image.Resize(Width, Height);
            image.SetFormat(imageformat::Jpeg);
            image.Save(NVOutStream2);
            // Bitmap := Bitmap.Bitmap(Bitmap, Width, Height);
            // Bitmap.Save(NVOutStream2, ImageFormat.Jpeg);

            PictureRef.Description := CopyStr(Name, 1, MaxStrLen(PictureRef.Description));


            PictureRef.Modify(true);
            //EXIT(Name);
        end else
            PictureRef.Modify(true);

        ErrorMessage := GetLastErrorText;
        if ErrorMessage <> '' then
            Error(ErrorMessage);

        exit(UploadResult);
    end;


    procedure UpdateVehicleSerialNo(SourceType: Integer; SourceSubType: Integer; SourceId: Code[20]; VehicleSerialNo: Code[20])
    var
        Picture: Record Picture;
    begin
        Picture.Reset;
        Picture.SetRange("Source Type", SourceType);
        Picture.SetRange("Source Subtype", SourceSubType);
        Picture.SetRange("Source ID", SourceId);
        if Picture.FindFirst then
            repeat
                if Picture."Vehicle Serial No." <> VehicleSerialNo then begin
                    Picture."Vehicle Serial No." := VehicleSerialNo;
                    Picture.Modify;
                end;
            until Picture.Next = 0;
    end;


    procedure DeleteRelatedPictures(SourceType: Integer; SourceSubType: Integer; SourceId: Code[20]; VehicleSerialNo: Code[20])
    var
        Picture: Record Picture;
    begin
        Picture.Reset;
        Picture.SetRange("Source Type", SourceType);
        Picture.SetRange("Source Subtype", SourceSubType);
        Picture.SetRange("Source ID", SourceId);
        if Picture.FindSet then
            Picture.DeleteAll;
    end;
}

