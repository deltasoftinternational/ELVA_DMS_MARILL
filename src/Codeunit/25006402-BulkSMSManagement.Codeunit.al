//Not used at this moment. Comes from GH
Codeunit 25006402 "BulkSMS Management"
{

    trigger OnRun()
    var
        ResponseData: Text;
        ResponseStatus: Text;
    begin
    end;

    var
        Username: Text[50];
        Password: Text[50];
        Msisdn: Text[30];
        RequestUrlSendSMS: Text;
        RequestPort: Text[6];
        Repliable: Integer;
        SenderId: Text;
        SMSManagement: Codeunit "SMS Management";
        ServicesURL: Text[50];

    local procedure RequestData(Url: Text; Body: Text; var ResponseText: Text) RequestStatus: Boolean
    var
        // WebRequest: dotnet HttpWebRequest;
        // WebResponse: dotnet HttpWebResponse;
        RequestDetails: Text;
    begin

        if Request(Url, Body, ResponseText) then
            RequestStatus := true
        else
            RequestStatus := false;

    end;

    [TryFunction]
    local procedure Request(Url: Text; Body: Text; var ResponseText: Text)//FIXME
    var
        // WebRequest: dotnet HttpWebRequest;
        // WebResponse: dotnet HttpWebResponse;
        RequestDetails: Text;
    begin

        // WebRequest := WebRequest.Create(Url);
        // WebRequest.ContentType := 'application/x-www-form-urlencoded';
        // WebRequest.Method := 'POST';

        // SetRequestText(WebRequest, Body);
        // WebResponse := WebRequest.GetResponse();
        // GetResponseText(WebResponse, ResponseText);
    end;

    // local procedure GetResponseText(WebResponse: dotnet HttpWebResponse; var ResponseText: Text): Boolean //FIXME
    // var
    //     ResponseStream: dotnet Stream;
    //     StreamReader: dotnet StreamReader;
    // begin
    //     Clear(ResponseText);
    //     ResponseStream := WebResponse.GetResponseStream();
    //     StreamReader := StreamReader.StreamReader(ResponseStream);
    //     ResponseText.AddText(StreamReader.ReadToEnd());
    // end;

    // local procedure SetRequestText(var WebRequest: dotnet HttpWebRequest; RequestText: Text) //FIXME
    // var
    //     RequestStream: dotnet Stream;
    //     Bytes: dotnet Array;
    //     Encoding: dotnet Encoding;
    // begin
    //     Bytes := Encoding.Ascii.GetBytes(RequestText);
    //     WebRequest.ContentLength := Bytes.Length;
    //     RequestStream := WebRequest.GetRequestStream();
    //     RequestStream.Write(Bytes, 0, Bytes.Length);
    // end;


    procedure SetPrerequisites(UsernameToSet: Text[30]; PasswordToSet: Text[30]; ServicesURLToSet: Text[50])
    begin
        Username := UsernameToSet;
        Password := PasswordToSet;
        ServicesURL := ServicesURLToSet;
    end;

    local procedure UrlEncode(Text: Text) Result: Text
    var
    //HttpUtility: dotnet HttpUtility;
    begin
        Text := DelChr(Text, '<>', ' ');
        // Result := HttpUtility.UrlEncode(Text); //FIXME
    end;


    procedure RequestSendSMS(PhoneNo: Text[20]; Message: Text; SourceId: Integer; var ResponseData: Text) RequestStatus: Boolean
    var
        RequestBody: Text;
        RequestUrl: Text[250];
    begin
        RequestUrl := ServicesURL + '/submission/send_sms/2/2.0';
        RequestBody += StrSubstNo(
          'username=%1&' +
          'password=%2&' +
          'message=%3&' +
          'msisdn=%4&' +
          'source_id=%5&' +
          'allow_concat_text_sms=1&' +
          'concat_text_sms_max_parts=2&' +
          'repliable=%6&' +
          'sender=%7', UrlEncode(Username), UrlEncode(Password), UrlEncode(Message), UrlEncode(PhoneNo), Format(SourceId), Repliable, UrlEncode(SenderId));

        RequestStatus := RequestData(RequestUrl, RequestBody, ResponseData);
        SMSManagement.LogRequest(RequestUrl, RequestBody, ResponseData, 2, SourceId);
    end;


    procedure RequestSendSMSBatch(SourceId: Integer; BatchData: Text; Message: Text; var ResponseData: Text) RequestStatus: Boolean
    var
        RequestBody: Text;
        RequestUrl: Text[250];
        cr: Char;
    begin
        RequestUrl := ServicesURL + '/submission/send_sms/2/2.0';
        RequestBody += StrSubstNo(
          'username=%1&' +
          'password=%2&' +
          'message=%3&' +
          'source_id=%4&' +
          'allow_concat_text_sms=1&' +
          'concat_text_sms_max_parts=2&' +
          'repliable=%5&' +
          'sender=%6&' +
          'msisdn=', UrlEncode(Username), UrlEncode(Password), UrlEncode(Message), Format(SourceId), Repliable, UrlEncode(SenderId));

        //RequestBody.AddText(BatchData);
        RequestBody += BatchData;

        RequestStatus := RequestData(RequestUrl, RequestBody, ResponseData);
        SMSManagement.LogRequest(RequestUrl, RequestBody, ResponseData, 2, SourceId);
    end;


    procedure RequestSendMultipleSMS(SourceId: Integer; BatchData: Text; var ResponseData: Text) RequestStatus: Boolean
    var
        RequestBody: Text;
        RequestUrl: Text[250];
        cr: Char;
    begin
        RequestUrl := ServicesURL + '/submission/send_batch/1/1.0';
        RequestBody += StrSubstNo(
          'username=%1&' +
          'password=%2&' +
          'source_id=%3&' +
          'allow_concat_text_sms=1&' +
          'concat_text_sms_max_parts=2&' +
          'repliable=%4&' +
          'sender=%5&' +
          'batch_data=', UrlEncode(Username), UrlEncode(Password), Format(SourceId), Repliable, UrlEncode(SenderId));

        RequestBody += BatchData;

        RequestStatus := RequestData(RequestUrl, RequestBody, ResponseData);
        SMSManagement.LogRequest(RequestUrl, RequestBody, ResponseData, 2, SourceId);
    end;


    procedure RequestSendSMSQuote(PhoneNo: Text[20]; Message: Text; SourceId: Integer; var ResponseData: Text) RequestStatus: Boolean
    var
        RequestBody: Text;
        RequestUrl: Text[250];
    begin
        RequestUrl := ServicesURL + '/submission/quote_sms/2/2.0';
        RequestBody += StrSubstNo(
          'username=%1&' +
          'password=%2&' +
          'message=%3&' +
          'msisdn=%4&' +
          'source_id=%5&' +
          'allow_concat_text_sms=1&' +
          'concat_text_sms_max_parts=2&' +
          'repliable=%6&' +
          'sender=%7', UrlEncode(Username), UrlEncode(Password), UrlEncode(Message), UrlEncode(PhoneNo), Format(SourceId), Repliable, UrlEncode(SenderId));

        RequestStatus := RequestData(RequestUrl, RequestBody, ResponseData);
        SMSManagement.LogRequest(RequestUrl, RequestBody, ResponseData, 2, SourceId);
    end;


    procedure RequestSendSMSBatchQuote(SourceId: Integer; BatchData: Text; Message: Text; var ResponseData: Text) RequestStatus: Boolean
    var
        RequestBody: Text;
        RequestUrl: Text[250];
        cr: Char;
    begin
        RequestUrl := ServicesURL + '/submission/quote_sms/2/2.0';
        RequestBody += StrSubstNo(
          'username=%1&' +
          'password=%2&' +
          'message=%3&' +
          'source_id=%4&' +
          'allow_concat_text_sms=1&' +
          'concat_text_sms_max_parts=2&' +
          'repliable=%5&' +
          'sender=%6&' +
          'msisdn=', UrlEncode(Username), UrlEncode(Password), UrlEncode(Message), Format(SourceId), Repliable, UrlEncode(SenderId));

        RequestBody += BatchData;

        RequestStatus := RequestData(RequestUrl, RequestBody, ResponseData);
        SMSManagement.LogRequest(RequestUrl, RequestBody, ResponseData, 2, SourceId);
    end;


    procedure RequestQuote(PhoneNo: Text[20]; Message: Text; var ResponseData: Text) RequestStatus: Boolean
    var
        RequestBody: Text;
        RequestUrl: Text[250];
    begin
        RequestUrl := ServicesURL + '/submission/quote_sms/2/2.0';
        RequestBody += StrSubstNo(
          'username=%1&' +
          'password=%2&' +
          'message=%3&' +
          'msisdn=%4&' +
          'allow_concat_text_sms=1&' +
          'concat_text_sms_max_parts=2', UrlEncode(Username), UrlEncode(Password), UrlEncode(Message), UrlEncode(PhoneNo));

        RequestStatus := RequestData(RequestUrl, RequestBody, ResponseData);
        SMSManagement.LogRequest(RequestUrl, RequestBody, ResponseData, 0, 0);
    end;


    procedure RequestReport(SourceId: Integer; BatchId: Text[20]; PhoneNo: Text[20]; var ResponseData: Text) RequestStatus: Boolean
    var
        RequestBody: Text;
        RequestUrl: Text[250];
        ResponseStatus: Text;
        ResponseText: Text;
    begin
        PhoneNo := DelChr(PhoneNo, '=', '+');
        RequestUrl := ServicesURL + '/status_reports/get_report/2/2.0';
        RequestBody += StrSubstNo(
          'username=%1&' +
          'password=%2&' +
          'batch_id=%3&' +
          'msisdn=%4', UrlEncode(Username), UrlEncode(Password), UrlEncode(BatchId), UrlEncode(PhoneNo));

        RequestStatus := RequestData(RequestUrl, RequestBody, ResponseData);
        SMSManagement.LogRequest(RequestUrl, RequestBody, ResponseData, 2, SourceId);
    end;


    procedure RequestCredits(var ResponseData: Text) RequestStatus: Boolean
    var
        RequestBody: Text;
        RequestUrl: Text[250];
        ResponseStatus: Text;
        ResponseText: Text;
    begin
        RequestUrl := ServicesURL + '/user/get_credits/1/1.1';
        RequestBody += StrSubstNo(
          'username=%1&' +
          'password=%2', UrlEncode(Username), UrlEncode(Password));

        RequestStatus := RequestData(RequestUrl, RequestBody, ResponseData);
        SMSManagement.LogRequest(RequestUrl, RequestBody, ResponseData, 0, 0);

        ResponseData := ResponseText.Substring(1, 250);
        ResponseStatus := CopyStr(ResponseText, 1, 19);
        if ResponseStatus = '0|Results to follow' then begin
            ResponseText := DelStr(ResponseText, 1, 19);
            ResponseText := DelChr(ResponseText, '<>', ' ');
            ResponseText := ClearText(ResponseText);
            ResponseText := DelChr(ResponseText, '<>', ' ');
        end;
    end;


    procedure RequestReplays(LastRetrievedMessage: Integer; var ResponseData: Text) RequestStatus: Boolean
    var
        RequestBody: Text;
        RequestUrl: Text[250];
        ResponseStatus: Text;
    begin
        RequestUrl := ServicesURL + '/reception/get_inbox/1/1.1';
        RequestBody += StrSubstNo(
          'username=%1&' +
          'password=%2&' +
          'last_retrieved_id=%3', UrlEncode(Username), UrlEncode(Password), LastRetrievedMessage);

        RequestStatus := RequestData(RequestUrl, RequestBody, ResponseData);
        SMSManagement.LogRequest(RequestUrl, RequestBody, ResponseData, 0, 0);
    end;


    procedure SetRepliable(RepliableToSet: Boolean)
    begin
        if RepliableToSet then begin
            Repliable := 1;
            SenderId := '';
        end else begin
            Repliable := 0;
        end;
    end;


    procedure SetSenderId(SenderIdToSet: Text)
    begin
        if SenderIdToSet <> '' then begin
            SenderId := SenderIdToSet;
            Repliable := 0;
        end;
    end;

    [TryFunction]
    local procedure TryGetResponseField(ResponseText: Text; FieldNo: Integer; var FieldText: Text)
    var
        WorkingString: Text;
    begin

        WorkingString := ConvertStr(ResponseText, ',', ' ');
        WorkingString := ConvertStr(WorkingString, '|', ',');
        FieldText := SelectStr(FieldNo, WorkingString);

        FieldText := ClearText(FieldText);
    end;


    procedure GetResponseField(ResponseText: Text; FieldNo: Integer) ReturnText: Text
    begin
        if not TryGetResponseField(ResponseText, FieldNo, ReturnText) then ReturnText := '';
    end;


    procedure ClearText(TextToClear: Text): Text
    var
        cr: Char;
        lf: Char;
        tab: Char;
    begin
        cr := 13;
        lf := 10;
        tab := 9;
        TextToClear := DelChr(TextToClear, '=', Format(cr));
        TextToClear := DelChr(TextToClear, '=', Format(lf));
        TextToClear := DelChr(TextToClear, '=', Format(tab));
        exit(TextToClear)
    end;
}

