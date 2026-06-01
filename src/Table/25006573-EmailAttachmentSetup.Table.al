/*Table 25006573 "Email Attachment Setup" 
{
    Caption = 'Email Attachment Setup';
    LookupPageID = "Email Attachment Setup";
    DrillDownPageID = "Email Attachment Setup";

    fields
    {
        field(1; ID; Guid)
        {
            Caption = 'ID';
        }
        field(10; "Report ID"; Integer)
        {
            TableRelation = AllObjWithCaption."Object ID" WHERE("Object Type" = CONST(Report));
            Caption = 'Report ID';
        }
        field(20; "Location Code"; Code[20])
        {
            TableRelation = Location.Code;
            Caption = 'Location Code';
        }
        field(30; "Deal Type Code"; Code[10])
        {
            TableRelation = "Deal Type";
            Caption = 'Deal Type Code';
        }
        field(40; Attachment; BLOB)
        {
            Caption = 'Attachment';
        }
        field(50; "Attachment Name"; Text[30])
        {
            Caption = 'Attachment Name';
        }
    }
    keys
    {
        key(Key1; ID)
        {
            Clustered = true;
        }
    }

    var


    procedure ImportFile();
    var
        FileName: Text;
        FileMgt: Codeunit "File Management";
        ServerFileName: Text;
        TempBlob: Codeunit "Temp Blob";
    begin
        CLEAR(Attachment);
        ServerFileName := TEMPORARYPATH;
        FileName := '';
        IF NOT UPLOAD('Import Attachment', '', 'All Files (*.*)|*.*', FileName, ServerFileName) then
            ERROR('Error during copying file: %1.', GETLASTERRORTEXT);

        CLEAR(TempBlob);
        FileMgt.BLOBImportFromServerFile(TempBlob, ServerFileName);
        SetAttachmentFileFromBlob(TempBlob);
        "Attachment Name" := FileMgt.GetFileName(ServerFileName);
        MODIFY;
    end;

    procedure DeleteFile();
    begin
        CALCFIELDS(Attachment);
        IF Attachment.HASVALUE then begin
            CLEAR(Attachment);
            MODIFY;
        end;
    end;

    procedure SetAttachmentFileFromBlob(TempBlob: Codeunit "Temp Blob")
    var
        RecordRef: RecordRef;
    begin
        RecordRef.GetTable(Rec);
        TempBlob.ToRecordRef(RecordRef, FieldNo("Attachment"));
        RecordRef.SetTable(Rec);
    end;

}*/