Page 25006059 "Pictures"
{
    // 19/06/2017 P1
    // * Changed property CardPageID => Picture Card
    // * Editable => No
    // *! Completeley redesigend

    Caption = 'Pictures';
    CardPageID = "Picture Card";
    DeleteAllowed = false;
    Editable = true;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = List;
    SourceTable = Picture;
    SourceTableView = sorting("Source Type", "Source Subtype", "Source ID", "Source Ref. No.", "No.");

    layout
    {
        area(content)
        {
            repeater(Control1101907000)
            {
                field(No; Rec."No.")
                {
                    ApplicationArea = Basic;
                }
                field(SourceType; DecodeSourceType(Rec."Source Type"))
                {
                    ApplicationArea = Basic;
                    Caption = 'Source Type';
                    Visible = false;
                }
                field(SourceSubtype; DecodeSourceSubType(Rec."Source Type", Rec."Source Subtype", Rec."Source ID"))
                {
                    ApplicationArea = Basic;
                    Caption = 'Source Subtype';
                    Visible = false;
                }
                field(SourceID; Rec."Source ID")
                {
                    ApplicationArea = Basic;
                    Caption = 'Source ID';
                    Visible = false;
                }
                field(SourceRefNo; Rec."Source Ref. No.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Source Ref. No.';
                    Visible = false;
                }
                field(Description; Rec.Description)
                {
                    ApplicationArea = Basic;
                    Caption = 'Description';
                }
                field(Imported; Rec.Imported)
                {
                    ApplicationArea = Basic;
                    Caption = 'Imported';
                    Visible = false;
                }
                field(Default; Rec.Default)
                {
                    ApplicationArea = Basic;
                    Caption = 'Default';
                }
                field(VehicleSerialNo; Rec."Vehicle Serial No.")
                {
                    ApplicationArea = Basic;
                }
            }
        }
        area(factboxes)
        {
            part(Picture; "Picture FactBox")
            {
                ApplicationArea = All;
                Caption = 'Picture';
                SubPageLink = "No." = field("No.");
                SubPageView = sorting("Source Type", "Source Subtype", "Source ID", "Source Ref. No.", "No.");
            }
        }
    }

    actions
    {
        area(navigation)
        {
        }
        area(processing)
        {
            action("Take Picture")
            {
                ApplicationArea = Basic;
                Image = Camera;
                Promoted = true;
                PromotedCategory = New;
                PromotedIsBig = true;
                Visible = CameraAvailable;

                trigger OnAction()
                var
                    //  CameraOptions: dotnet CameraOptions;

                    NVInStream: InStream;
                    NVInStream1: InStream;
                    NVOutStream1: OutStream;
                    NVOutStream2: OutStream;
                    PictureDescription: Text;
                    Camera: Codeunit Camera;
                    FileName: Text;
                    NoSeriesMgt: Codeunit "No. Series";
                    PictureMgtSetup: Record "Picture Mgt. Setup";
                    "Camera Mgt": Codeunit "Camera Mgt";
                    AspectRatio: Decimal;
                    Width: Integer;
                    Height: Integer;
                    MaintainAspectRatio: Boolean;
                    image: Codeunit Image;
                    imageformat: enum "Image Format";
                    ErrorMessage: Text;
                    LargerImageErr: label 'Can''t make image larger than it is.';
                    Picture: record "Picture";
                begin
                    // CameraOptions := CameraOptions.CameraOptions();
                    // CameraOptions.Quality := 50;
                    // Camera.RequestPictureAsync(CameraOptions);
                    PictureMgtSetup.Get();
                    PictureMgtSetup.TestField("Picture Nos.");

                    if Camera.GetPicture(50, NVInStream, PictureDescription) then begin
                        "Camera Mgt".CreatePictureBySource('descr', '', Rec."Source Type", Rec."Source Subtype", Rec."Source ID", Rec."Source Ref. No.", Rec."Vehicle Serial No.", Picture);

                        Picture.Blob.CreateOutstream(NVOutStream1);
                        Picture.Thumbnail.CreateOutstream(NVOutStream2);
                        CopyStream(NVOutStream1, NVInStream);
                        Picture.Modify(true);

                        Picture.Blob.CreateInStream(NVInStream1);

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

                        Picture.Description := CopyStr(PictureDescription, 1, MaxStrLen(Picture.Description));


                        Picture.Modify(true);

                    end;

                end;
            }
            action("Upload Picture")
            {
                ApplicationArea = Basic;
                Image = Import;
                Promoted = true;
                PromotedIsBig = true;

                trigger OnAction()
                var
                    // CameraOptions: dotnet CameraOptions;
                    CameraMgt: Codeunit "Camera Mgt";
                    Camera: Codeunit Camera;
                begin
                    /*if CurrentClientType in [Clienttype::Phone, Clienttype::Tablet] then begin
                        // CameraOptions := CameraOptions.CameraOptions();//FIXME
                        // CameraOptions.SourceType := 'PhotoLibrary';
                        // CameraOptions.EncodinsgType := 'JPEG, PNG';
                        // Camera.RequestPictureAsync(CameraOptions);
                    end else begin*/
                    CameraMgt.CreateIncomingPictureFromBLOBBySource(Rec."Source Type", Rec."Source Subtype", Rec."Source ID", Rec."Source Ref. No.", Rec."Vehicle Serial No.");
                    //end;
                end;
            }
            action("Download Picture")
            {
                ApplicationArea = Basic;
                Image = Export;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    CameraMgt: Codeunit "Camera Mgt";
                begin
                    CameraMgt.DownloadPicture(Rec."No.");
                end;
            }
            action("Print Pictures")
            {
                ApplicationArea = Basic;
                Image = Print;
                Promoted = true;
                PromotedCategory = Process;

                trigger OnAction()
                var
                    CameraMgt: Codeunit "Camera Mgt";
                begin
                    CameraMgt.PrintPictures(Rec."Source Type", Rec."Source Subtype", Rec."Source ID", Rec."Source Ref. No.");
                end;
            }
        }
    }

    trigger OnNewRecord(BelowxRec: Boolean)
    begin
        Rec.PopulateSourceFields;
    end;

    trigger OnOpenPage()
    var
        Camera: Codeunit Camera;
    begin

        if Camera.IsAvailable then begin //FIXME
                                         // Camera := Camera.Create;
            CameraAvailable := true;
        end;
    end;

    var
        PictureMgt: Codeunit "Picture Management";
        // [RunOnClient]
        // [WithEvents]
        //Camera: dotnet CameraProvider;//FIXME
        CameraAvailable: Boolean;

    local procedure DecodeSourceType(SourceType: Integer) TableCaption: Text
    var
        TableRef: RecordRef;
    begin
        if Rec."Source Type" <> 0 then begin
            TableRef.Open(SourceType);
            TableCaption := TableRef.Caption;
            TableRef.Close;
        end;
    end;

    local procedure DecodeSourceSubType(SourceType: Integer; SourceSubtype: Integer; SourceId: Code[20]) SourceSubtypeCaption: Text
    var
        ServiceHeaderEDMS: Record "Service Header EDMS";
        ProcessChecklistHeader: Record "Process Checklist Header";
        Vehicle: Record Vehicle;
    begin
        case SourceType of
            Database::"Service Header EDMS":
                begin
                    if ServiceHeaderEDMS.Get(SourceSubtype, SourceId) then
                        exit(Format(ServiceHeaderEDMS."Document Type"));
                end;
            else
                exit('');
        end;
    end;

    // trigger Camera::PictureAvailable(PictureName: Text; PictureFilePath: Text) //FIXME
    // var
    //     CameraMgt: Codeunit "Camera Mgt";
    //     NewPictureID: Code[20];
    //     Picture: Record Picture;
    // begin
    //     NewPictureID := CameraMgt.CreateIncomingPictureFromServerFileBySource(PictureName, PictureFilePath, Rec."Source Type", Rec."Source Subtype", Rec."Source ID", Rec."Source Ref. No.", Rec."Vehicle Serial No.");
    //     if NewPictureID <> '' then begin
    //         Picture.Get(NewPictureID);
    //         Page.Run(Page::"Picture Card", Picture);
    //     end;
    //     CurrPage.Update;
    // end;
}

