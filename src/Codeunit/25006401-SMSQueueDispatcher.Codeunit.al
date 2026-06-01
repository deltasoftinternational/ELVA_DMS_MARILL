Codeunit 25006401 "SMS Queue Dispatcher"
{

    trigger OnRun()
    var
        ResponseText: Text[250];
        ReportedStatus: Integer;
        ResponseData: Text;
        ResponseStatus: Text;
        BatchQueueEntry: Record "SMS Batch Queue Entry";
        RequestLog: Record "SMS Request Log";
        cr: Char;
        BatchData: Text;
        AllSMSEntryFinished: Boolean;
        ProviderField: Text;
        ProviderBatchCost: Decimal;
        TokenManagement: Codeunit "Token Management";
    begin
        SMSMgtSetup.Get;
        BulkSMSManagement.SetPrerequisites(SMSMgtSetup."SMS Provider Username", SMSMgtSetup."SMS Provider Password", SMSMgtSetup."Provider URL");

        //Clear Old History Entries
        BatchQueueEntry.Reset;
        BatchQueueEntry.SetFilter("Expire Date Time", '<%1', CreateDatetime(CalcDate(SMSManagement.GetBatchQueueArchivePeriodFormula, Today), Time));
        if BatchQueueEntry.FindFirst then begin
            BatchQueueEntry.DeleteAll;
        end;

        RequestLog.Reset;
        RequestLog.SetFilter(RequestLog."Entry Time", '<%1', CreateDatetime(CalcDate(SMSManagement.GetBatchQueueArchivePeriodFormula, Today), Time));
        if RequestLog.FindFirst then begin
            RequestLog.DeleteAll;
        end;

        //Finish Expired batches
        BatchQueueEntry.Reset;
        if BatchQueueEntry.FindFirst then begin
            repeat
                if BatchQueueEntry."Expire Date Time" < CurrentDatetime then begin
                    BatchQueueEntry.Status := BatchQueueEntry.Status::Finished;
                    BatchQueueEntry.Modify;
                end;
            until BatchQueueEntry.Next = 0;
        end;

        //Get report for all sent sms
        ResponseText := '';
        BatchQueueEntry.Reset;
        BatchQueueEntry.SetRange(BatchQueueEntry.Status, BatchQueueEntry.Status::"Waiting Report");
        if BatchQueueEntry.FindFirst then begin
            repeat
                AllSMSEntryFinished := true;

                //Single SMS Batch
                SMSEntry.Reset;
                SMSEntry.SetRange(SMSEntry."Batch Queue Entry No.", BatchQueueEntry."Entry No.");
                SMSEntry.SetRange(SMSEntry."Queue Status", SMSEntry."queue status"::"Waiting Report");
                if SMSEntry.FindFirst then begin
                    repeat
                        if BulkSMSManagement.RequestReport(BatchQueueEntry."Entry No.", BatchQueueEntry."Provider BatchId", SMSEntry."Phone No.", ResponseData) then begin
                            //ResponseData.GetSubText(ResponseText, 1, 250);
                            ResponseData := ResponseText.Substring(1, 250);

                            ResponseStatus := BulkSMSManagement.GetResponseField(ResponseText, 1);
                            if ResponseStatus = '0' then begin
                                ResponseText := DelStr(ResponseText, 1, 19);
                                ResponseText := DelChr(ResponseText, '<>', ' ');
                                ResponseText := BulkSMSManagement.ClearText(ResponseText);
                                ResponseText := DelChr(ResponseText, '<>', ' ');
                            end else
                                ResponseText := '';

                            if Evaluate(ReportedStatus, BulkSMSManagement.GetResponseField(ResponseText, 2)) then;
                            if ReportedStatus <> 0 then begin
                                //(0 - in progress)
                                SMSEntry."Provider Reported Status" := ReportedStatus;
                                SMSEntry."Queue Status" := SMSEntry."queue status"::Finished;
                                SMSEntry.Modify;
                            end else
                                AllSMSEntryFinished := false;
                            SMSManagement.UpdateSMSByReportedStatus(SMSEntry."Entry No.", ReportedStatus);
                        end else begin
                            AllSMSEntryFinished := false;
                            BatchQueueEntry."Last Request Attempt" := CurrentDatetime;
                            BatchQueueEntry."Request Attempts" += 1;
                            BatchQueueEntry.Modify;
                        end;
                    until SMSEntry.Next = 0;
                end;
                if AllSMSEntryFinished then begin
                    BatchQueueEntry.Status := BatchQueueEntry.Status::Finished;
                    BatchQueueEntry.Modify;
                end;
            until BatchQueueEntry.Next = 0;
        end;

        //Send All Queued SMS Messages
        ResponseText := '';
        BatchQueueEntry.Reset;
        BatchQueueEntry.SetRange(BatchQueueEntry.Status, BatchQueueEntry.Status::Pending);

        if BatchQueueEntry.FindFirst then begin
            repeat
                ProviderBatchCost := 0;
                if BatchQueueEntry."Entry Type" = BatchQueueEntry."entry type"::"Single SMS" then begin
                    //Single SMS Batch
                    SMSEntry.Reset;
                    SMSEntry.SetRange(SMSEntry."Batch Queue Entry No.", BatchQueueEntry."Entry No.");
                    if SMSEntry.FindFirst then begin
                        BulkSMSManagement.SetRepliable(BatchQueueEntry."SMS Repliable");
                        BulkSMSManagement.SetSenderId(BatchQueueEntry."SMS SenderId");

                        //Get Batch Cost
                        BulkSMSManagement.RequestSendSMSQuote(SMSEntry."Phone No.", SMSEntry."Message Text", BatchQueueEntry."Entry No.", ResponseData);
                        ResponseData := ResponseText.Substring(1, 250);
                        ProviderField := BulkSMSManagement.GetResponseField(ResponseText, 3);
                        if ProviderField <> '' then
                            Evaluate(ProviderBatchCost, ProviderField);

                        if BulkSMSManagement.RequestSendSMS(SMSEntry."Phone No.", SMSEntry."Message Text", BatchQueueEntry."Entry No.", ResponseData) then begin
                            ResponseData := ResponseText.Substring(1, 250);
                            ResponseStatus := BulkSMSManagement.GetResponseField(ResponseText, 1);
                            if ResponseStatus = '0' then begin
                                BatchQueueEntry."Provider BatchId" := BulkSMSManagement.GetResponseField(ResponseText, 3);
                                BatchQueueEntry.Status := BatchQueueEntry.Status::"Waiting Report";
                                BatchQueueEntry."Last Request Attempt" := CurrentDatetime;
                                BatchQueueEntry."Request Attempts" += 1;
                                BatchQueueEntry."Provider Batch Cost" := ProviderBatchCost;
                                BatchQueueEntry.Modify;

                                SMSEntry."Provider BatchId" := BatchQueueEntry."Provider BatchId";
                                SMSEntry."Queue Status" := SMSEntry."queue status"::"Waiting Report";
                                SMSEntry."Delivery Status" := SMSEntry."delivery status"::Sent;
                                SMSEntry."Message Sent" := CurrentDatetime;
                                SMSEntry."Provider Batch Cost" := ProviderBatchCost;
                                SMSEntry.Modify;
                                TokenManagement.RegisterSpentTokens(1, 'SMS', Format(SMSEntry."Entry No."));
                            end else begin
                                BatchQueueEntry."Provider BatchId" := BulkSMSManagement.GetResponseField(ResponseText, 3);
                                BatchQueueEntry.Status := BatchQueueEntry.Status::Finished;
                                BatchQueueEntry."Last Request Attempt" := CurrentDatetime;
                                BatchQueueEntry."Request Attempts" += 1;
                                BatchQueueEntry."Provider Batch Cost" := ProviderBatchCost;
                                BatchQueueEntry.Modify;

                                SMSEntry."Provider BatchId" := BatchQueueEntry."Provider BatchId";
                                SMSEntry."Delivery Status" := SMSEntry."delivery status"::Failed;
                                SMSEntry."Queue Status" := SMSEntry."queue status"::Finished;
                                SMSEntry."Provider Batch Cost" := ProviderBatchCost;
                                SMSEntry.Modify;
                            end;
                        end else begin
                            BatchQueueEntry."Last Request Attempt" := CurrentDatetime;
                            BatchQueueEntry."Request Attempts" += 1;
                            BatchQueueEntry."Provider Batch Cost" := ProviderBatchCost;
                            BatchQueueEntry.Modify;
                        end;
                    end;
                end else begin
                    //Multiple SMS Batch
                    SMSEntry.Reset;
                    SMSEntry.SetRange(SMSEntry."Batch Queue Entry No.", BatchQueueEntry."Entry No.");
                    if SMSEntry.FindFirst then begin
                        BulkSMSManagement.SetRepliable(BatchQueueEntry."SMS Repliable");
                        BulkSMSManagement.SetSenderId(BatchQueueEntry."SMS SenderId");

                        Clear(BatchData);
                        repeat
                            //BatchData.AddText(SMSEntry."Phone No." + ',');
                            BatchData += SMSEntry."Phone No." + ',';

                        until SMSEntry.Next = 0;

                        //Get Batch Cost
                        BulkSMSManagement.RequestSendSMSBatchQuote(BatchQueueEntry."Entry No.", BatchData, SMSEntry."Message Text", ResponseData);
                        ResponseData := ResponseText.Substring(1, 250);
                        ProviderField := BulkSMSManagement.GetResponseField(ResponseText, 3);
                        if ProviderField <> '' then
                            Evaluate(ProviderBatchCost, ProviderField);

                        if BulkSMSManagement.RequestSendSMSBatch(BatchQueueEntry."Entry No.", BatchData, SMSEntry."Message Text", ResponseData) then begin
                            ResponseData := ResponseText.Substring(1, 250);
                            ResponseStatus := BulkSMSManagement.GetResponseField(ResponseText, 1);
                            if ResponseStatus = '0' then begin
                                BatchQueueEntry."Provider BatchId" := BulkSMSManagement.GetResponseField(ResponseText, 3);
                                BatchQueueEntry.Status := BatchQueueEntry.Status::"Waiting Report";
                                BatchQueueEntry."Last Request Attempt" := CurrentDatetime;
                                BatchQueueEntry."Request Attempts" += 1;
                                BatchQueueEntry."Provider Batch Cost" := ProviderBatchCost;
                                BatchQueueEntry.Modify;
                                SMSManagement.UpdateSMSEntryStatusForBatch(
                                  BatchQueueEntry."Entry No.",
                                  SMSEntry."queue status"::"Waiting Report",
                                  SMSEntry."delivery status"::Sent,
                                  BatchQueueEntry."Provider BatchId");
                                TokenManagement.RegisterSpentTokens(1, 'SMS', Format(SMSEntry."Entry No."));
                            end else begin
                                BatchQueueEntry.Status := BatchQueueEntry.Status::Finished;
                                BatchQueueEntry."Last Request Attempt" := CurrentDatetime;
                                BatchQueueEntry."Request Attempts" += 1;
                                BatchQueueEntry."Provider Batch Cost" := ProviderBatchCost;
                                BatchQueueEntry.Modify;
                                SMSManagement.UpdateSMSEntryStatusForBatch(
                                  BatchQueueEntry."Entry No.",
                                  SMSEntry."queue status"::Finished,
                                  SMSEntry."delivery status"::Failed,
                                  BatchQueueEntry."Provider BatchId");
                            end;
                        end else begin
                            BatchQueueEntry."Last Request Attempt" := CurrentDatetime;
                            BatchQueueEntry."Request Attempts" += 1;
                            BatchQueueEntry."Provider Batch Cost" := ProviderBatchCost;
                            BatchQueueEntry.Modify;
                        end;
                    end;
                end;
            until BatchQueueEntry.Next = 0;
        end;

        //Get Replay messages
        SMSManagement.GetReplays();
    end;

    var
        SMSEntry: Record "SMS Entry";
        SMSManagement: Codeunit "SMS Management";
        BulkSMSManagement: Codeunit "BulkSMS Management";
        SMSMgtSetup: Record "SMS Management Setup";
}

