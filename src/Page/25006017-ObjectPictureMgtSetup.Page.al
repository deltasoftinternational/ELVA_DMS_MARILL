Page 25006017 "Object Picture Mgt. Setup"
{
    // 06/03/2018 GH P1
    //   *Added "Camera Picture Quality"

    ApplicationArea = Basic;
    Caption = 'Picture Mgt. Setup';
    SourceTable = "Picture Mgt. Setup";
    UsageCategory = Administration;

    layout
    {
        area(content)
        {
            group(Numbering)
            {
                Caption = 'Numbering';
                field("Picture Nos."; rec."Picture Nos.")
                {
                    ApplicationArea = Basic;
                    Caption = 'Picture Nos.';
                }
                field(CameraPictureQuality; rec."Camera Picture Quality")
                {
                    ApplicationArea = Basic;
                }
            }
            group(ImageSize)
            {
                Caption = 'Image Size';
                field(ThumbnailWidth; rec."Thumbnail Width")
                {
                    ApplicationArea = Basic;
                }
                field(ThumbnailHeight; rec."Thumbnail Height")
                {
                    ApplicationArea = Basic;
                }
            }
        }
    }

    actions
    {
    }

    trigger OnOpenPage()
    begin
        rec.Reset;
        if not rec.Get then begin
            rec.Init;
            rec.Insert;
        end;
    end;
}

