Codeunit 25006772 "Integration Message Mgt. EDMS"
{

    trigger OnRun()
    begin
    end;

    var
        IntegrationMgt: Codeunit "Integration Management EDMS";
        IntegrationIsNotActiveErr: label 'DMS integration is not active.';
        EmptyVaueErr: label '%1 is empty.';
        UnknownMethodErr: label 'Unknown DMS integration method %1.';


    procedure CreateIntegrationMessage(ConnectorCode: Code[20]; MethodCode: Code[20]; Type: Option " ",Single,"Request-Response","Multi Step"; InitiatorSide: Option " ",NAV,External; var MessageHeader: Record "Integration Message EDMS"; var ErrorMessage: Text): Boolean
    var
        IntegrationMethod: Record "Integration Method EDMS";
    begin
        ErrorMessage := '';

        if ConnectorCode = '' then begin
            ErrorMessage := StrSubstNo(EmptyVaueErr, MessageHeader.FieldCaption("Connector Code"));
            exit(false);
        end;

        if MethodCode = '' then begin
            ErrorMessage := StrSubstNo(EmptyVaueErr, MessageHeader.FieldCaption("Method Code"));
            exit(false);
        end;

        if Type = Type::" " then begin
            ErrorMessage := StrSubstNo(EmptyVaueErr, MessageHeader.FieldCaption(Type));
            exit(false);
        end;

        if InitiatorSide = Initiatorside::" " then begin
            ErrorMessage := StrSubstNo(EmptyVaueErr, MessageHeader.FieldCaption("Initiator Side"));
            exit(false);
        end;

        if not IntegrationMgt.GetIntegrationMethod(MethodCode, IntegrationMethod) then
            Error(UnknownMethodErr, MethodCode);

        Clear(MessageHeader);
        MessageHeader."Connector Code" := ConnectorCode;
        MessageHeader."Method Code" := IntegrationMethod.Code;
        MessageHeader.Type := Type;
        MessageHeader."Initiator Side" := InitiatorSide;

        MessageHeader.TestField("Connector Code");
        MessageHeader.TestField("Method Code");
        MessageHeader.TestField(Type);
        MessageHeader.TestField("Initiator Side");

        MessageHeader.Insert(true);

        exit(true);
    end;


    procedure StartIntegrationMessageRequest(var MessageHeader: Record "Integration Message EDMS"; var ErrorMessage: Text): Boolean
    begin
        ErrorMessage := '';

        if not Codeunit.Run(Codeunit::"Integration Message-Start", MessageHeader) then begin
            ErrorMessage := GetLastErrorText;
            MessageHeader.InsertInfo(1, ErrorMessage);
            MessageHeader.FinishHandling(1);
            Commit;
            exit(false);
        end;

        exit(true);
    end;


    procedure StartIntegrationMessageResponse(var MessageHeader: Record "Integration Message EDMS"; var ErrorMessage: Text): Boolean
    begin
        ErrorMessage := '';

        if not Codeunit.Run(Codeunit::"Integration Message-Finalize", MessageHeader) then begin
            ErrorMessage := GetLastErrorText;
            MessageHeader.InsertInfo(1, ErrorMessage);
            Commit;
            MessageHeader.FinishHandling(1);
            exit(false);
        end;

        exit(true);
    end;
}

