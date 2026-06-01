Table 25006060 "Picture"
{
    // 19/06/2017 GP1
    //   Added fields:
    //    *Date
    //    *Time
    //    *User ID
    // 
    // 31.07.2013 EDMS P15
    //   * fix of No Series OnInsert (it worked with Manual allowed only)


    fields
    {
        field(1; "No."; Code[20])
        {
            Caption = 'No.';
            Editable = false;
        }
        field(10; "Source Type"; Integer)
        {
            Caption = 'Source Type';
        }
        field(11; "Source Subtype"; Option)
        {
            Caption = 'Source Subtype';
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
        }
        field(12; "Source ID"; Code[20])
        {
            Caption = 'Source ID';
        }
        field(13; "Source Ref. No."; Integer)
        {
            Caption = 'Source Ref. No.';
        }
        field(20; Description; Text[100])
        {
            Caption = 'Description';
        }
        field(30; Imported; Boolean)
        {
            Caption = 'Imported';
            Editable = false;
            FieldClass = Normal;
        }
        field(40; Default; Boolean)
        {
            Caption = 'Default';

            trigger OnValidate()
            var
                Picture3: Record Picture;
                PictDefaultID: Code[20];
            begin
                if xRec.Default <> Rec.Default then
                    if Default = true then begin
                        PictDefaultID := GetPictDefaultID;
                        if Picture3.Get(PictDefaultID) then begin
                            Picture3.Default := false;
                            Picture3.CalcFields(Blob);
                            Picture3.Modify;
                        end;
                    end else begin    //FALSE
                        Message(Text002, FieldCaption("Source Type"), "Source Type", FieldCaption("Source Subtype"), "Source Subtype",
                          FieldCaption("Source ID"), "Source ID", FieldCaption("Source Ref. No."), "Source Ref. No.");
                        Default := xRec.Default;
                    end;
            end;
        }
        field(50; Blob; Blob)
        {
            Caption = 'BLOB';
            SubType = Bitmap;

            trigger OnValidate()
            begin
                if Rec.Blob.Hasvalue then
                    Imported := true
                else
                    Imported := false;
            end;
        }
        field(70; Thumbnail; Blob)
        {
            SubType = Bitmap;
        }
        field(90; "No. Series"; Code[10])
        {
            Caption = 'No. Series';
            Editable = false;
            TableRelation = "No. Series";
        }
        field(25006950; Date; Date)
        {
        }
        field(25006960; Time; Time)
        {
        }
        field(25006970; "User ID"; Code[50])
        {
        }
        field(25006980; "Vehicle Serial No."; Code[20])
        {
            Caption = 'Vehicle Serial No.';
            DataClassification = ToBeClassified;
            TableRelation = Vehicle;
        }
        field(25006990; "Version No."; Integer)
        {
            Caption = 'Version No.';
            DataClassification = ToBeClassified;
        }
        field(25006995; "Doc. No. Occurrence"; Integer)
        {
            Caption = 'Doc. No. Occurrence';
            DataClassification = ToBeClassified;
        }
    }

    keys
    {
        key(Key1; "No.")
        {
            Clustered = true;
        }
        key(Key2; "Source Type", "Source Subtype", "Source ID", "Source Ref. No.", "No.")
        {
        }
        key(Key3; "Vehicle Serial No.")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        if (Default = true) and (Count > 1) then
            Error(Text002, FieldCaption("Source Type"), "Source Type", FieldCaption("Source Subtype"), "Source Subtype",
                FieldCaption("Source ID"), "Source ID", FieldCaption("Source Ref. No."), "Source Ref. No.");
    end;

    trigger OnInsert()
    var
        SerialNos: Code[20];
    begin
        if "No." = '' then begin
            GetPictureMgtSetup;
            PictureMgtSetup.TestField("Picture Nos.");
            //NoSeriesMgt.InitSeries(PictureMgtSetup."Picture Nos.",xRec."No. Series",0D,"No.","No. Series");
            SerialNos := PictureMgtSetup."Picture Nos.";
            //MESSAGE("No.");
            "No." := NoSeriesMgt.GetNextNo(SerialNos, 0D, true);
        end;
        if GetPictDefaultID = '' then   //means no Default yet
            Default := true;
    end;

    trigger OnModify()
    begin
        if (xRec."Source Type" <> Rec."Source Type") or (xRec."Source Subtype" <> Rec."Source Subtype") or
          (xRec."Source Ref. No." <> Rec."Source Ref. No.") or (xRec."Source ID" <> Rec."Source ID") then
            if GetPictDefaultID = '' then   //means no Default yet
                Default := true;

        Validate(Blob);
    end;

    var
        PictureMgtSetup: Record "Picture Mgt. Setup";
        PictureGlobal: Record Picture;
        NoSeriesMgt: Codeunit "No. Series";
        Text001: label 'The Object Picture %1 already exists.';
        HasPictureMgtSetup: Boolean;
        Text002: label 'You must set another Default Picture for %1: %2, %3: %4, %5: %6, %7: %8. ';


    procedure AssistEdit(OldPicture: Record Picture): Boolean
    var
        Picture2: Record Picture;
    begin
        GetPictureMgtSetup;
        PictureMgtSetup.TestField("Picture Nos.");
        if NoSeriesMgt.LookupRelatedNoSeries(PictureMgtSetup."Picture Nos.", xRec."No. Series", "No. Series") then begin
            "No." := NoSeriesMgt.GetNextNo("No. Series", WorkDate(), true);
            exit(true);
        end;
    end;


    procedure InitRecord()
    var
        FieldVal: Text[100];
    begin
        if NoSeriesMgt.IsAutomatic(PictureMgtSetup."Picture Nos.") then
            "No. Series" := PictureMgtSetup."Picture Nos.";
    end;


    procedure PopulateSourceFields()
    var
        FieldVal: Text[100];
    begin
        //31.07.2013 EDMS P15>>
        // property PopulateAllFields - emulation
        //MESSAGE('No.-' + "No.");
        FieldVal := GetFilter("Source Type");      //Integer
        //MESSAGE('SourceType-' + FieldVal);
        Evaluate("Source Type", FieldVal);  // add validation further

        FieldVal := GetFilter("Source Subtype");   //Option
        //MESSAGE('SourceSubType-' + FieldVal);
        if (FieldVal <> '') then
            Evaluate("Source Subtype", FieldVal);  // add validation further

        FieldVal := GetFilter("Source ID");
        //MESSAGE('Source ID-' + FieldVal);
        "Source ID" := FieldVal;  // add validation further

        FieldVal := GetFilter("Source Ref. No.");  //Integer
        //MESSAGE('Source Ref. No.-' + FieldVal);
        if (FieldVal <> '') then
            Evaluate("Source Ref. No.", FieldVal);  // add validation further


        //MODIFY;
        //31.07.2013 EDMS P15<<
    end;

    local procedure TestNoSeries(): Boolean
    begin
        PictureMgtSetup.TestField("Picture Nos.");
    end;


    procedure GetPictureMgtSetup()
    begin
        if not HasPictureMgtSetup then begin
            PictureMgtSetup.Get;
            HasPictureMgtSetup := true;
        end;
    end;


    procedure GetPictDefaultID(): Code[20]
    var
        Picture2: Record Picture;
    begin
        Picture2.Reset;
        Picture2.CopyFilters(Rec);
        Picture2.SetRange(Default, true);
        if Picture2.FindFirst then
            exit(Picture2."No.")
        else
            exit('');
    end;
}

