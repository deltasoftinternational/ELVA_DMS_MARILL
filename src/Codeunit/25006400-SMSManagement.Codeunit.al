Codeunit 25006400 "SMS Management"
{

    trigger OnRun()
    begin
    end;

    var
        BulkSMSMgt: Codeunit "BulkSMS Management";
        SMSBatchBuffer: Record "SMS Entry" temporary;
        SMSMgtSetup: Record "SMS Management Setup";
        ContactNo: Code[20];
        SalespersonCode: Code[10];
        DocumentType: Option;
        DocumentNo: Code[20];


    procedure AddSMSToQueue(PhoneNo: Text[30]; Message: Text[250]): Boolean
    var
        BatchQueueEntryNo: Integer;
    begin
        SMSMgtSetup.Get;
        BatchQueueEntryNo := CreateSMSBatchQueueEntry(false, SMSMgtSetup."Enable Repliable SMS", SMSMgtSetup."SMS Sender Id");
        CreateSMSEntry(BatchQueueEntryNo, PhoneNo, Message);
    end;


    procedure AddSMSBatchToQueue() ResponseText: Text
    var
        SMSEntryNo: Integer;
        EntryNo: Integer;
        BatchQueueEntryNo: Integer;
        BatchData: Text;
    begin
        SMSMgtSetup.Get;
        BatchQueueEntryNo := CreateSMSBatchQueueEntry(true, SMSMgtSetup."Enable Repliable SMS", SMSMgtSetup."SMS Sender Id");
        SMSBatchBuffer.Reset;
        if SMSBatchBuffer.FindFirst then begin
            repeat
                CreateSMSEntry(BatchQueueEntryNo, SMSBatchBuffer."Phone No.", SMSBatchBuffer."Message Text");
            until SMSBatchBuffer.Next = 0;
        end;
    end;


    procedure GetSMSQuotation(PhoneNo: Text[30]; Message: Text[250]) ResponseText: Text
    var
        ResponseData: Text;
    begin
        SMSMgtSetup.Get;
        BulkSMSMgt.SetPrerequisites(SMSMgtSetup."SMS Provider Username", SMSMgtSetup."SMS Provider Password", SMSMgtSetup."Provider URL");
        BulkSMSMgt.RequestQuote(PhoneNo, Message, ResponseData);
        //ResponseData.GetSubText(ResponseText, 1, 250);
        ResponseData := ResponseText.Substring(1, 250);
    end;


    procedure GetCredits() ResponseText: Text
    var
        ResponseData: Text;
    begin
        SMSMgtSetup.Get;
        BulkSMSMgt.SetPrerequisites(SMSMgtSetup."SMS Provider Username", SMSMgtSetup."SMS Provider Password", SMSMgtSetup."Provider URL");
        BulkSMSMgt.RequestCredits(ResponseData);
        //ResponseData.GetSubText(ResponseText, 1, 250);
        ResponseData := ResponseText.Substring(1, 250);

    end;


    procedure GetReplays() ResponseText: Text
    var
        ResponseData: Text;
        crlf: Text[2];
        i: Integer;
        ResponseDataTmp: Text;
        ResponseLine: Text;
        ResponseStatus: Text;
        LineNo: Integer;
    begin
        SMSMgtSetup.Get;
        BulkSMSMgt.SetPrerequisites(SMSMgtSetup."SMS Provider Username", SMSMgtSetup."SMS Provider Password", SMSMgtSetup."Provider URL");
        BulkSMSMgt.RequestReplays(GetLastReplayId, ResponseData);
        //ResponseData.GetSubText(ResponseText, 1, 250);
        ResponseData := ResponseText.Substring(1, 250);
        ResponseStatus := CopyStr(ResponseText, 1, 19);

        if ResponseStatus = '0|records to follow' then begin
            ResponseDataTmp := ResponseData;
            //crlf[1] := 13;
            crlf[1] := 10;
            //i := ResponseDataTmp.TEXTPOS(Format(crlf));
            i := StrPos(ResponseDataTmp, Format(crlf));
            while i > 0 do begin
                LineNo += 1;
                //ResponseDataTmp.GetSubText(ResponseLine, 1, i);
                ResponseDataTmp := ResponseLine.Substring(1, i);
                if LineNo > 2 then begin
                    CreateSMSReplayEntry(
                      BulkSMSMgt.GetResponseField(ResponseLine, 5),
                      BulkSMSMgt.GetResponseField(ResponseLine, 3),
                      BulkSMSMgt.GetResponseField(ResponseLine, 2),
                      BulkSMSMgt.GetResponseField(ResponseLine, 6),
                      BulkSMSMgt.GetResponseField(ResponseLine, 1)
                    );
                end;
                //ResponseDataTmp.GetSubText(ResponseDataTmp, i + 1);
                ResponseDataTmp := ResponseDataTmp.Substring(i + 1);

                //i := ResponseDataTmp.TEXTPOS(Format(crlf));
                i := StrPos(ResponseDataTmp, Format(crlf))
            end;
        end;
    end;


    procedure GetLastReplayId(): Integer
    var
        SMSEntry: Record "SMS Entry";
    begin
        SMSEntry.Reset;
        SMSEntry.SetRange(Replay, true);
        if SMSEntry.FindLast then
            exit(SMSEntry."Provider ReplayId");
    end;

    local procedure CreateSMSEntry(BatchQueueEntryNo: Integer; PhoneNo: Text[30]; Message: Text[250]) EntryNo: Integer
    var
        SMSEntry: Record "SMS Entry";
    begin
        SMSEntry.Reset;
        if SMSEntry.FindLast then
            EntryNo := SMSEntry."Entry No." + 1
        else
            EntryNo := 1;

        SMSEntry.Init;
        SMSEntry."Entry No." := EntryNo;
        SMSEntry."Phone No." := PhoneNo;
        SMSEntry."Message Text" := Message;
        SMSEntry."Delivery Status" := SMSEntry."delivery status"::Queued;
        SMSEntry."Queue Status" := SMSEntry."queue status"::Pending;
        SMSEntry."Batch Queue Entry No." := BatchQueueEntryNo;
        SMSEntry."Entry Created" := CurrentDatetime;
        SMSEntry."Contact No." := ContactNo;
        SMSEntry."Salesperson Code" := SalespersonCode;
        SMSEntry."Document No." := DocumentNo;
        SMSEntry."Document Type" := DocumentType;
        SMSEntry.Insert;
    end;

    local procedure CreateSMSReplayEntry(PhoneNo: Text[30]; Message: Text[250]; ReplayPhoneNo: Text[30]; BatchId: Text; ReplayId: Text) EntryNo: Integer
    var
        SMSEntry: Record "SMS Entry";
    begin
        SMSEntry.Reset;
        if SMSEntry.FindLast then
            EntryNo := SMSEntry."Entry No." + 1
        else
            EntryNo := 1;

        SMSEntry.Init;
        SMSEntry."Entry No." := EntryNo;
        SMSEntry."Phone No." := PhoneNo;
        SMSEntry."Message Text" := Message;
        SMSEntry.Replay := true;
        SMSEntry."Replay Phone No." := ReplayPhoneNo;
        SMSEntry."Provider BatchId" := BatchId;
        Evaluate(SMSEntry."Provider ReplayId", ReplayId);
        SMSEntry."Delivery Status" := SMSEntry."delivery status"::Delivered;
        SMSEntry."Queue Status" := SMSEntry."queue status"::Finished;
        SMSEntry."Entry Created" := CurrentDatetime;
        SMSEntry.Insert;
    end;


    procedure CreateSMSBatchQueueEntry(MultipleMessageBatch: Boolean; Repliable: Boolean; SenderId: Text) EntryNo: Integer
    var
        SMSBatchQueueEntry: Record "SMS Batch Queue Entry";
        TokenManagement: Codeunit "Token Management";
        ErrMsg: Text;
    begin
        if not TokenManagement.CheckTokens(1, 'SMS', ErrMsg) then
            Error(ErrMsg);

        SMSMgtSetup.Get;
        SMSBatchQueueEntry.Reset;
        if SMSBatchQueueEntry.FindLast then
            EntryNo := SMSBatchQueueEntry."Entry No." + 1
        else
            EntryNo := 1;

        SMSBatchQueueEntry.Init;
        SMSBatchQueueEntry."Entry No." := EntryNo;
        SMSBatchQueueEntry.Status := SMSBatchQueueEntry.Status::Pending;
        SMSBatchQueueEntry."SMS Repliable" := Repliable;
        SMSBatchQueueEntry."SMS SenderId" := SenderId;
        if MultipleMessageBatch then
            SMSBatchQueueEntry."Entry Type" := SMSBatchQueueEntry."entry type"::"Multiple SMS"
        else
            SMSBatchQueueEntry."Entry Type" := SMSBatchQueueEntry."entry type"::"Single SMS";
        SMSBatchQueueEntry."Entry Created" := CurrentDatetime;
        SMSBatchQueueEntry."Expire Date Time" := CreateDatetime(CalcDate(GetBatchQueueExpirePeriodFormula, Today), Time);
        SMSBatchQueueEntry.Insert;
    end;


    procedure LogRequest(Url: Text; RequestData: Text; ResponseData: Text; "Source Type": Option "Std. Request","SMS Message","SMS Batch"; "Source Id": Integer)
    var
        SMSRequestLog: Record "SMS Request Log";
        EntryNo: Integer;
        OstreamReq: OutStream;
        OstreamResp: OutStream;
        ReqText: Text;
        RespText: Text;
    begin
        SMSRequestLog.Reset;
        if SMSRequestLog.FindLast then
            EntryNo := SMSRequestLog."Entry No." + 1
        else
            EntryNo := 1;


        //RequestData.GetSubText(ReqText, 1, 250);
        RequestData := ReqText.Substring(1, 250);

        //ResponseData.GetSubText(RespText, 1, 250);
        ResponseData := RespText.Substring(1, 250);

        SMSRequestLog.Init;
        SMSRequestLog."Entry No." := EntryNo;
        SMSRequestLog.Url := Url;
        SMSRequestLog.RequestData := ReqText;
        SMSRequestLog.ResponseData := RespText;
        SMSRequestLog."Source Type" := "Source Type";
        SMSRequestLog."Source Id" := "Source Id";
        SMSRequestLog.RequestDataBlob.CreateOutstream(OstreamReq);
        //RequestData.Write(OstreamReq);
        OstreamReq.WriteText(RequestData);
        SMSRequestLog.ResponseDataBlob.CreateOutstream(OstreamResp);
        //ResponseData.Write(OstreamResp);
        OstreamResp.WriteText(ResponseData);
        SMSRequestLog."Entry Time" := CurrentDatetime;
        SMSRequestLog.Insert;
        Commit;
    end;


    procedure ClearSMSBatch()
    begin
        SMSBatchBuffer.DeleteAll;
    end;


    procedure AddSMSToBatch(PhoneNo: Text; MessageText: Text)
    var
        EntryNo: Integer;
    begin
        if SMSBatchBuffer.FindLast then
            EntryNo := SMSBatchBuffer."Entry No." + 1
        else
            EntryNo := 1;

        SMSBatchBuffer.Init;
        SMSBatchBuffer."Entry No." := EntryNo;
        SMSBatchBuffer."Phone No." := PhoneNo;
        SMSBatchBuffer."Message Text" := MessageText;
        SMSBatchBuffer.Insert;
    end;


    procedure UpdateSMSEntryStatusForBatch(BatchQueueEntryNo: Integer; SMSQueueStatus: Option; SMSDeliveryStatus: Option; ProviderBatchId: Text): Boolean
    var
        SMSEntry: Record "SMS Entry";
    begin
        SMSEntry.Reset;
        SMSEntry.SetRange(SMSEntry."Batch Queue Entry No.", BatchQueueEntryNo);
        if SMSEntry.FindFirst then
            repeat
                SMSEntry."Provider BatchId" := ProviderBatchId;
                SMSEntry."Queue Status" := SMSQueueStatus;
                SMSEntry."Delivery Status" := SMSDeliveryStatus;
                SMSEntry."Sent In Multiple Batch" := true;
                if SMSEntry."Delivery Status" = SMSEntry."delivery status"::Sent then
                    SMSEntry."Message Sent" := CurrentDatetime;
                SMSEntry.Modify;
            until SMSEntry.Next = 0;
    end;


    procedure UpdateSMSByReportedStatus(SMSEntryNo: Integer; ReportedStatus: Integer)
    var
        SMSEntry: Record "SMS Entry";

    begin
        if SMSEntry.Get(SMSEntryNo) then begin
            case ReportedStatus of
                0://In Progress
                    SMSEntry."Delivery Status" := SMSEntry."delivery status"::Sent;
                10:
                    SMSEntry."Delivery Status" := SMSEntry."delivery status"::Delivered;
                11:
                    SMSEntry."Delivery Status" := SMSEntry."delivery status"::Delivered;
                12:
                    SMSEntry."Delivery Status" := SMSEntry."delivery status"::Delivered;
                50:
                    SMSEntry."Delivery Status" := SMSEntry."delivery status"::Failed;
                else
                    SMSEntry."Delivery Status" := SMSEntry."delivery status"::Failed;
            end;

            if SMSEntry."Delivery Status" = SMSEntry."delivery status"::Delivered then begin
                SMSEntry."Interaction Log Entry No." := LogSMSContactInteraction(SMSEntryNo);
            end;

            SMSEntry.Modify;
        end;
    end;


    procedure GetBatchQueueExpirePeriodFormula() ExpireFormula: Code[10]
    begin
        SMSMgtSetup.Get;
        case SMSMgtSetup."Sms Batch Queue Expire Period" of
            SMSMgtSetup."sms batch queue expire period"::"2 Days":
                ExpireFormula := '<2D>';
            SMSMgtSetup."sms batch queue expire period"::"7 Days":
                ExpireFormula := '<7D>';
            SMSMgtSetup."sms batch queue expire period"::"14 Days":
                ExpireFormula := '<14D>';
            else
                ExpireFormula := '<2D>';
        end;
    end;


    procedure GetBatchQueueArchivePeriodFormula() ArchiveFormula: Code[10]
    begin
        SMSMgtSetup.Get;
        case SMSMgtSetup."Sms Batch Queue Arch. Period" of
            SMSMgtSetup."sms batch queue arch. period"::"30 Days":
                ArchiveFormula := '<-30D>';
            SMSMgtSetup."sms batch queue arch. period"::"60 Days":
                ArchiveFormula := '<-60D>';
            SMSMgtSetup."sms batch queue arch. period"::"90 Days":
                ArchiveFormula := '<-90D>';
            else
                ArchiveFormula := '<-30D>';
        end;
    end;


    procedure SetContactNo(ContactNoToSet: Code[20])
    begin
        ContactNo := ContactNoToSet;
    end;


    procedure SetSalespersonCode(SalespersonCodeToSet: Code[10])
    begin
        SalespersonCode := SalespersonCodeToSet;
    end;


    procedure SetDocumentNo(DocumentNoToSet: Code[20])
    begin
        DocumentNo := DocumentNoToSet;
    end;


    procedure SetDocumentType(DocumentTypeToSet: Option)
    begin
        DocumentType := DocumentTypeToSet;
    end;

    procedure LogSMSContactInteraction(SMSEntryNo: Integer) InteractionLogEntryNo: Integer
    var
        InteractTmpl: Record "Interaction Template";
        SegLine: Record "Segment Line" temporary;
        ContBusRel: Record "Contact Business Relation";
        Attachment: Record Attachment;
        InteractTmplLanguage: Record "Interaction Tmpl. Language";
        InterLogEntryCommentLine: Record "Inter. Log Entry Comment Line" temporary;
        InteractTmplCode: Code[10];
        SMSEntry: Record "SMS Entry";
        Description: Text[50];
    begin
        InteractionTmplSetup.Get;
        if InteractionTmplSetup.SMS = '' then
            exit;
        InteractTmpl.Get(InteractionTmplSetup.SMS);
        InteractTmplLanguage.SetRange("Interaction Template Code", InteractionTmplSetup.SMS);
        if InteractTmplLanguage.FindFirst then
            Error(Text003, InteractionTmplSetup.SMS, InteractTmplLanguage."Language Code");

        if SMSEntry.Get(SMSEntryNo) and (SMSEntry."Contact No." <> '') and (SMSEntry."Salesperson Code" <> '') then begin
            Description := CopyStr(SMSEntry."Message Text", 1, 50);
            if Description = '' then
                Description := InteractTmpl.Description;

            SegLine.Init;
            SegLine.Validate("Contact No.", SMSEntry."Contact No.");
            SegLine.Date := Today;
            SegLine."Time of Interaction" := Time;
            SegLine.Description := Description;
            SegLine."Salesperson Code" := SMSEntry."Salesperson Code";
            SegLine."Document Type" := SMSEntry."Document Type";
            SegLine."Document No." := SMSEntry."Document No.";
            SegLine.Insert;
            SegLine.Validate("Interaction Template Code", InteractTmpl.Code);
            SegLine."Cost (LCY)" := SMSEntry."Provider Batch Cost";
            SegLine."Duration (Min.)" := 1;
            SegLine.Modify;
            ;
            InteractionLogEntryNo := SegManagement.LogInteraction(SegLine, Attachment, InterLogEntryCommentLine, false, false);
        end;
    end;

    var
        InteractionTmplSetup: Record "Interaction Template Setup";
        SegManagement: Codeunit SegManagement;
        Text003: Label 'Interaction Template %1 has assigned Interaction Template Language %2.\It is not allowed to have languages assigned to templates used for system document logging.';
}

