Table 25006780 "Integration Message EDMS"
{
    // #Owner EDMS.Integration

    Caption = 'DMS Integration Message';
    DrillDownPageID = "Integration Message List EDMS";
    LookupPageID = "Integration Message List EDMS";

    fields
    {
        field(10; ID; Integer)
        {
            AutoIncrement = true;
            Caption = 'ID';
        }
        field(100; "Connector Code"; Code[20])
        {
            Caption = 'Connector Code';
            TableRelation = "Integration Connector EDMS"."Connector Code";
        }
        field(110; "Method Code"; Code[20])
        {
            Caption = 'Method Code';
            DataClassification = ToBeClassified;
            TableRelation = "Integration Method EDMS".Code;
        }
        field(200; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = ' ,Single,Request-Response,Multi Step';
            OptionMembers = " ",Single,"Request-Response","Multi Step";
        }
        field(210; "Initiator Side"; Option)
        {
            Caption = 'Initiator Side';
            OptionMembers = " ",NAV,External;
        }
        field(220; "Single Instance"; Boolean)
        {
            Caption = 'Single Instance';
            DataClassification = ToBeClassified;
        }
        field(300; Status; Option)
        {
            Caption = 'Status';
            OptionCaption = ' ,Prepared,Waiting,OK,Error,Action';
            OptionMembers = " ",Prepared,Waiting,OK,Error,"Action";
        }
        field(305; "Error Description"; Text[250])
        {
            DataClassification = ToBeClassified;
        }
        field(310; "Started At"; DateTime)
        {
            Caption = 'Started At';
        }
        field(320; "Waiting At"; DateTime)
        {
            Caption = 'Waiting At';
        }
        field(330; "Finished At"; DateTime)
        {
            Caption = 'Finished At';
        }
        field(400; "Call Next Method Code"; Code[20])
        {
            Caption = 'Call Next DMS Method ID';
            DataClassification = ToBeClassified;
        }
        field(410; "Previouse Message ID"; Integer)
        {
            Caption = 'Previouse Message ID';
            DataClassification = ToBeClassified;
            TableRelation = "Integration Message EDMS".ID where("Connector Code" = field("Connector Code"));
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                PrevIntegrationRegister: Record "Integration Message EDMS";
            begin
                if "Previouse Message ID" = 0 then
                    "Iteration No." := 0
                else begin
                    if PrevIntegrationRegister.Get("Previouse Message ID") then
                        "Iteration No." := PrevIntegrationRegister."Iteration No." + 1;
                end;
            end;
        }
        field(420; "Iteration No."; Integer)
        {
            Caption = 'Iteration No.';
            DataClassification = ToBeClassified;
        }
        field(1000; "Source Type"; Integer)
        {
            Caption = 'Source Type';
            Description = '1000..1999   NAV side info';
        }
        field(1010; "Source Subtype"; Option)
        {
            Caption = 'Source Subtype';
            OptionCaption = '0,1,2,3,4,5,6,7,8,9,10';
            OptionMembers = "0","1","2","3","4","5","6","7","8","9","10";
        }
        field(1020; "Source ID"; Code[20])
        {
            Caption = 'Source ID';
        }
        field(1021; "Source ID1"; Code[20])
        {
            Caption = 'Source ID1';
        }
        field(1022; "Source ID2"; Code[20])
        {
            Caption = 'Source ID2';
        }
        field(1030; "Source Batch Name"; Code[10])
        {
            Caption = 'Source Batch Name';
        }
        field(1040; "Source Prod. Order Line"; Integer)
        {
            Caption = 'Source Prod. Order Line';
        }
        field(1050; "Source Ref. No."; Integer)
        {
            Caption = 'Source Ref. No.';
        }
        field(1070; "Item Ledger Entry No."; Integer)
        {
            Caption = 'Item Ledger Entry No.';
            Editable = false;
            TableRelation = "Item Ledger Entry";
        }
        field(2000; "Entry Count"; Integer)
        {
            CalcFormula = count("Integration Message Line EDMS" where("Message ID" = field(ID)));
            Caption = 'Entry Count';
            Editable = false;
            FieldClass = FlowField;
        }
        field(2010; "Entry Count (1st Level)"; Integer)
        {
            CalcFormula = count("Integration Message Line EDMS" where("Message ID" = field(ID),
                                                                       "Parent Line No." = const(0)));
            Caption = 'Entry Count (1st Level)';
            Editable = false;
            FieldClass = FlowField;
        }
        field(3000; "External ID"; Code[30])
        {
            Description = '3000..3999   External side info';
        }
        field(3010; "Request Blob"; Blob)
        {
            DataClassification = ToBeClassified;
        }
        field(3020; "Response Blob"; Blob)
        {
            DataClassification = ToBeClassified;
        }
        field(10000; "Item No."; Code[20])
        {
            Caption = 'Item No.';
            DataClassification = ToBeClassified;
            Description = '10000..19999 Item info';
            TableRelation = Item."No.";

            trigger OnValidate()
            begin
                /*
                IF "Item No." = '' THEN BEGIN
                  "Vendor Item No. Prefix" := '';
                  "Vendor Item No. Base" := '';
                  "Unit Of Measure Code" := '';
                  VALIDATE("Item Category Code", '');
                END ELSE BEGIN
                  Item.GET("Item No.");
                  "Vendor Item No. Prefix" := Item."Vendor Item No. Prefix";
                  "Vendor Item No. Base" := Item."Vendor Item No. Base";
                  "Unit Of Measure Code" := Item."Base Unit of Measure";
                  VALIDATE("Item Category Code", Item."Item Category Code");
                END;
                */

            end;
        }
        field(10010; "Variant Code"; Code[10])
        {
            Caption = 'Variant Code';
            DataClassification = ToBeClassified;
            TableRelation = "Item Variant".Code;
        }
        field(10100; "Location Code"; Code[10])
        {
            Caption = 'Location Code';
            DataClassification = ToBeClassified;
            TableRelation = Location.Code;
        }
        field(10110; "Bin Code"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(30000; "Customer No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '30000..39999 Customer info';
            TableRelation = Customer;
        }
        field(30010; "Customer ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(40000; "Vendor No."; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '40000..49999 Vendor info';
            TableRelation = Vendor;
        }
        field(40020; "Vendor ID"; Code[20])
        {
            DataClassification = ToBeClassified;
        }
        field(40030; "Make ID"; Code[20])
        {
            Caption = 'Make ID';
            DataClassification = ToBeClassified;
        }
        field(50000; "Dealer ID"; Code[20])
        {
            DataClassification = ToBeClassified;
            Description = '50000..59999 Dealer info';
        }
    }

    keys
    {
        key(Key1; ID)
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        DeleteInfo;
        DeleteParams;
        DeleteLines;
    end;

    local procedure "-- Message --"()
    begin
    end;


    procedure SetDealerID()
    var
        IntegrConnector: Record "Integration Connector EDMS";
        IntegrConnectorSetup: Record "Integration Connector Setup";
    begin
        if ("Connector Code" = '') or ("Method Code" = '') then
            exit;
        if not IntegrConnector.Get("Connector Code") then
            exit;
        if not IntegrConnectorSetup.Get("Connector Code", "Method Code") then
            exit;

        if IntegrConnectorSetup."Dealer ID" <> '' then
            "Dealer ID" := IntegrConnectorSetup."Dealer ID"
        else
            "Dealer ID" := IntegrConnector."Dealer ID";

        /*
        CASE ConnectorMethodSetup."Dealer ID Source" OF
          ConnectorMethodSetup."Dealer ID Source"::Connector:
            "Dealer ID" := ConnectorMethodSetup."Dealer ID";
          ConnectorMethodSetup."Dealer ID Source"::Connector:
            BEGIN
              IntegrationConnector.GET("Connector Code");
              "Dealer ID" := IntegrationConnector."Dealer ID";
            END;
          ConnectorMethodSetup."Dealer ID Source"::"Params (Location)":
            BEGIN
              IF "Location Code Original" <> '' THEN BEGIN
                IF ConnectorParam.GET("Connector Code", ConnectorParam.Type::Location, "Location Code Original") THEN
                   "Dealer ID" := ConnectorParam."Dealer ID";
              END ELSE BEGIN
                ConnectorParam.RESET;
                ConnectorParam.SETRANGE(Type, ConnectorParam.Type::Location);
                ConnectorParam.SETRANGE(Default, TRUE);
                ConnectorParam.SETFILTER("Dealer ID", '<>%1', '');
                IF ConnectorParam.FINDFIRST THEN
                  "Dealer ID" := ConnectorParam."Dealer ID";
              END;
            END;
        END;
        
        IF "Dealer ID" = '' THEN
          "Dealer ID" := ConnectorMethodSetup."Dealer ID";
        */

    end;


    procedure SetCustomerID()
    var
        IntegrConnector: Record "Integration Connector EDMS";
        IntegrConnectorSetup: Record "Integration Connector Setup";
    begin
        if ("Connector Code" = '') or ("Method Code" = '') then
            exit;
        if not IntegrConnector.Get("Connector Code") then
            exit;
        if not IntegrConnectorSetup.Get("Connector Code", "Method Code") then
            exit;

        if IntegrConnectorSetup."Customer ID" <> '' then
            "Customer ID" := IntegrConnectorSetup."Customer ID"
        else
            "Customer ID" := IntegrConnector."Customer ID";

        /*
        CASE ConnectorMethodSetup."Customer ID Source" OF
          ConnectorMethodSetup."Customer ID Source"::Connector:
            "Customer ID" := ConnectorMethodSetup."Customer ID";
          ConnectorMethodSetup."Customer ID Source"::Connector:
            BEGIN
              IntegrationConnector.GET("Connector Code");
              "Customer ID" := IntegrationConnector."Customer ID";
            END;
          ConnectorMethodSetup."Customer ID Source"::"Params (Location)":
            BEGIN
              IF "Location Code Original" <> '' THEN BEGIN
                IF ConnectorParam.GET("Connector Code", ConnectorParam.Type::Location, "Location Code Original") THEN
                   "Customer ID" := ConnectorParam."Customer ID";
              END ELSE BEGIN
                ConnectorParam.RESET;
                ConnectorParam.SETRANGE(Type, ConnectorParam.Type::Location);
                ConnectorParam.SETRANGE(Default, TRUE);
                ConnectorParam.SETFILTER("Customer ID", '<>%1', '');
                IF ConnectorParam.FINDFIRST THEN
                  "Customer ID" := ConnectorParam."Customer ID";
              END;
            END;
        END;
        
        IF "Customer ID" = '' THEN
          "Customer ID" := ConnectorMethodSetup."Customer ID";
        */

    end;


    procedure SetVendorID()
    var
        IntegrConnector: Record "Integration Connector EDMS";
        IntegrConnectorSetup: Record "Integration Connector Setup";
    begin
        if ("Connector Code" = '') or ("Method Code" = '') then
            exit;
        if not IntegrConnector.Get("Connector Code") then
            exit;
        if not IntegrConnectorSetup.Get("Connector Code", "Method Code") then
            exit;

        if IntegrConnectorSetup."Vendor ID" <> '' then
            "Vendor ID" := IntegrConnectorSetup."Vendor ID"
        else
            "Vendor ID" := IntegrConnector."Vendor ID";

        /*
        CASE ConnectorMethodSetup."Vendor ID Source" OF
          ConnectorMethodSetup."Vendor ID Source"::Connector:
            "Vendor ID" := ConnectorMethodSetup."Vendor ID";
          ConnectorMethodSetup."Vendor ID Source"::Connector:
            BEGIN
              IntegrationConnector.GET("Connector Code");
              "Vendor ID" := IntegrationConnector."Vendor ID";
            END;
          ConnectorMethodSetup."Vendor ID Source"::"Params (Location)":
            BEGIN
              IF "Location Code Original" <> '' THEN BEGIN
                IF ConnectorParam.GET("Connector Code", ConnectorParam.Type::Location, "Location Code Original") THEN
                   "Vendor ID" := ConnectorParam."Vendor ID";
              END ELSE BEGIN
                ConnectorParam.RESET;
                ConnectorParam.SETRANGE(Type, ConnectorParam.Type::Location);
                ConnectorParam.SETRANGE(Default, TRUE);
                ConnectorParam.SETFILTER("Vendor ID", '<>%1', '');
                IF ConnectorParam.FINDFIRST THEN
                  "Vendor ID" := ConnectorParam."Vendor ID";
              END;
            END;
        END;
        
        IF "Vendor ID" = '' THEN
          "Vendor ID" := ConnectorMethodSetup."Vendor ID";
        */

    end;


    procedure SetMakeID()
    var
        IntegrConnector: Record "Integration Connector EDMS";
        IntegrConnectorSetup: Record "Integration Connector Setup";
    begin
        if ("Connector Code" = '') or ("Method Code" = '') then
            exit;
        if not IntegrConnector.Get("Connector Code") then
            exit;
        if not IntegrConnectorSetup.Get("Connector Code", "Method Code") then
            exit;

        if IntegrConnectorSetup."Make ID" <> '' then
            "Make ID" := IntegrConnectorSetup."Make ID"
        else
            "Make ID" := IntegrConnector."Make ID";

        /*
        CASE ConnectorMethodSetup."Make ID Source" OF
          ConnectorMethodSetup."Make ID Source"::Connector:
            "Make ID" := ConnectorMethodSetup."Make ID";
          ConnectorMethodSetup."Make ID Source"::Connector:
            BEGIN
              IntegrationConnector.GET("Connector Code");
              "Make ID" := IntegrationConnector."Make ID";
            END;
          ConnectorMethodSetup."Make ID Source"::"Params (Location)":
            BEGIN
              IF "Location Code Original" <> '' THEN BEGIN
                IF ConnectorParam.GET("Connector Code", ConnectorParam.Type::Location, "Location Code Original") THEN
                   "Make ID" := ConnectorParam."Make ID";
              END ELSE BEGIN
                ConnectorParam.RESET;
                ConnectorParam.SETRANGE(Type, ConnectorParam.Type::Location);
                ConnectorParam.SETRANGE(Default, TRUE);
                ConnectorParam.SETFILTER("Make ID", '<>%1', '');
                IF ConnectorParam.FINDFIRST THEN
                  "Make ID" := ConnectorParam."Make ID";
              END;
            END;
        END;
        
        IF "Make ID" = '' THEN
          "Make ID" := ConnectorMethodSetup."Make ID";
        */

    end;


    procedure SetSource(SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceBatchName: Code[10]; SourceProdLineNo: Integer; SourceRefNo: Integer; ItemLedgEntryNo: Integer)
    begin
        "Source Type" := SourceType;
        "Source Subtype" := SourceSubtype;
        "Source ID" := SourceID;
        "Source Batch Name" := SourceBatchName;
        "Source Prod. Order Line" := SourceProdLineNo;
        "Source Ref. No." := SourceRefNo;
        "Item Ledger Entry No." := ItemLedgEntryNo;
    end;


    procedure StartRequest()
    var
        ErrorMessage: Text;
    begin
        if IsTemporary or
           (ID = 0) or
           (Status <> Status::" ")
        then
            exit;

        Status := Status::Prepared;
        Modify;
        Commit;
        /*
        IF NOT DMSIntegrationMgt.IntegrationIsActive("Connector Code", "Method Code", ErrorMessage) THEN BEGIN
          InsertMessage(1, ErrorMessage);
          FinishHandling(1);  // Error
          EXIT;
        END;
        
        DMSIntegrationSetup.GET;
        DMSIntegrationConnector.GET("Connector Code");
        DMSIntegrConnectorMethod.GET("Connector Code", "DMS Integration Method ID");
        
        CASE "Initiator Side" OF
          "Initiator Side"::NAV:
            BEGIN
              IF "Dealer ID" = '' THEN
                SetDealerID;
              IF "Customer ID" = '' THEN
                SetCustomerID;
              IF "Vendor ID" = '' THEN
                SetVendorID;
              IF "Make ID" = '' THEN
                SetMakeID;
              IF NOT CODEUNIT.RUN(DMSIntegrConnectorMethod., Rec) THEN BEGIN
                InsertMessage(1, GETLASTERRORTEXT);
                FinishHandling(1);  // Error
                EXIT;
              END;
            END;
        
          "Initiator Side"::External:
            BEGIN
              IF NOT CODEUNIT.RUN(DMSIntegrConnectorMethod."Handler Codeunit ID", Rec) THEN BEGIN
                InsertMessage(1, GETLASTERRORTEXT);
                FinishHandling(1);  // Error
                EXIT;
              END;
            END;
        END;
        */

    end;


    procedure DeletePreviouseMessage(PrevMessageID: Integer)
    var
        PreviouseMessage: Record "Integration Message EDMS";
    begin
        PreviouseMessage.Get(PrevMessageID);
        PreviouseMessage.Delete(true);
    end;

    local procedure "-- Message Processing --"()
    begin
    end;


    procedure SetAsPrepared()
    begin
        TestField(ID);
        TestField(Status, Status::" ");
        Status := Status::Prepared;
        "Started At" := CurrentDatetime;
        Modify;

        UpdateSourceStatus;
        Commit;
    end;


    procedure SetAsWaiting()
    begin
        TestField(ID);
        TestField(Status, Status::Prepared);
        Status := Status::Waiting;
        "Waiting At" := CurrentDatetime;
        Modify;

        UpdateSourceStatus;
        Commit;
    end;


    procedure SetAsFinished()
    begin
        TestField(ID);
        "Finished At" := CurrentDatetime;
        Modify;

        UpdateSourceStatus;
        Commit;
    end;


    procedure FinishHandling(HandlingStatus: Option OK,Error,"Action")
    begin
        if IsTemporary then
            exit;

        TestField(ID);

        if Codeunit.Run(Codeunit::"Integration Message-Finalize", Rec) then begin
            case HandlingStatus of
                Handlingstatus::OK:
                    Status := Status::OK;
                Handlingstatus::Error:
                    Status := Status::Error;
                Handlingstatus::Action:
                    Status := Status::Action;
                else
                    Status := Status::Error;
            end;
        end else begin
            Status := Status::Error;
            "Error Description" := CopyStr(GetLastErrorText, 1, MaxStrLen("Error Description"));
            InsertInfo(1, "Error Description");
        end;
        Modify;

        SetAsFinished;
    end;


    procedure UpdateSourceStatus()
    var
        PurchHeader: Record "Purchase Header";
        RecallCampaign: Record "Recall Campaign";
        ReqWorksheetLine: Record "Requisition Line";
        ServiceHdrEDMS: Record "Service Header EDMS";
        Vehicle: Record Vehicle;
        WarrantyDocHeader: Record "Warranty Document Header";
        NewStatus: Option " ",Waiting,OK,Error,"Action";
    begin
        if ID = 0 then
            exit;

        case Status of
            Status::" ":
                NewStatus := Newstatus::" ";
            Status::Prepared:
                NewStatus := Newstatus::" ";
            Status::Waiting:
                NewStatus := Newstatus::Waiting;
            Status::OK:
                NewStatus := Newstatus::OK;
            Status::Error:
                NewStatus := Newstatus::Error;
            Status::Action:
                NewStatus := Newstatus::Action;
        end;

        case "Source Type" of
            /*
            DATABASE::"DMS Integr. UI Item Buffer":
              BEGIN
                IF ItemUIBuf.GET("Source ID", "Source Ref. No.") THEN BEGIN
                  ItemUIBuf."DMS Integration Status" := NewStatus;
                  ItemUIBuf.MODIFY;
                END;
              END;
            */

            Database::"Purchase Header":
                begin
                    if PurchHeader.Get("Source Subtype", "Source ID") then begin
                        PurchHeader."DMS Integration Status" := NewStatus;
                        PurchHeader.Modify;
                    end;
                end;

        /*
        DATABASE::"Recall Campaign":
          BEGIN
            IF RecallCampaign.GET("Source ID") THEN BEGIN
              RecallCampaign."DMS Integration Status" := NewStatus;
              RecallCampaign.MODIFY;
            END;
          END;

        DATABASE::"Requisition Line":
          BEGIN
            ReqWorksheetLine.RESET;
            ReqWorksheetLine.SETRANGE("Journal Batch Name", "Source Batch Name");
            ReqWorksheetLine.SETRANGE("Line No.", "Source Ref. No.");
            IF ReqWorksheetLine.FINDFIRST THEN BEGIN
              ReqWorksheetLine."DMS Integration Status" := NewStatus;
              ReqWorksheetLine.MODIFY;
            END;
          END;

        DATABASE::"Service Header EDMS":
          BEGIN
            IF ServiceHdrEDMS.GET("Source Subtype", "Source ID") THEN BEGIN
              ServiceHdrEDMS."DMS Integration Status" := NewStatus;
              ServiceHdrEDMS.MODIFY;
            END;
          END;

        DATABASE::Vehicle:
          BEGIN
            IF Vehicle.GET("Source ID") THEN BEGIN
              Vehicle."DMS Integration Status" := NewStatus;
              Vehicle.MODIFY;
            END;
          END;

        DATABASE::"Warranty Document Header":
          BEGIN
            IF WarrantyDocHeader.GET("Source ID") THEN BEGIN
              WarrantyDocHeader."DMS Integration Status" := NewStatus;
              WarrantyDocHeader.MODIFY;
            END;
          END;
        */
        end;

    end;

    local procedure "-- Lines --"()
    begin
    end;

    local procedure DeleteLines()
    var
        MessageLine: Record "Integration Message Line EDMS";
    begin
        MessageLine.Reset;
        MessageLine.SetRange("Message ID", ID);
        MessageLine.DeleteAll(true);
    end;


    procedure AddLine(var NewMessageLine: Record "Integration Message Line EDMS")
    begin
        TestField(ID);

        Clear(NewMessageLine);
        NewMessageLine."Message ID" := ID;
        NewMessageLine.Insert(true);
    end;

    local procedure "-- Param --"()
    begin
    end;


    procedure InsertParam(ParamName: Text[50]; ParamValue: Text[250]; VisibleForUser: Boolean)
    var
        MessageParam: Record "Integration Message Param EDMS";
    begin
        if (ParamName = '') or (ParamValue = '') then
            exit;

        MessageParam.Reset;
        MessageParam.Init;
        MessageParam."Message ID" := ID;
        MessageParam."Message Line No." := 0;
        MessageParam."Entry No." := 0;
        MessageParam."Param Name" := ParamName;
        MessageParam."Param Value" := ParamValue;
        MessageParam.Visible := VisibleForUser;

        MessageParam.SetSource("Source Type", "Source Subtype", "Source ID",
                              "Source Batch Name", "Source Prod. Order Line", "Source Ref. No.", "Item Ledger Entry No.");
        MessageParam.Insert(true);
    end;


    procedure GetParamValue(ParamName: Text[50]; ParamScore: Option " ",Header,Lines): Text[250]
    var
        MessageParam: Record "Integration Message Param EDMS";
    begin
        if (ParamName = '') then
            exit('');

        MessageParam.Reset;
        MessageParam.SetRange("Message ID", ID);
        case ParamScore of
            Paramscore::Header:
                MessageParam.SetRange("Message Line No.", 0);
            Paramscore::Lines:
                MessageParam.SetFilter("Message Line No.", '<>0');
        end;
        MessageParam.SetRange("Param Name", ParamName);

        if MessageParam.FindLast then
            exit(MessageParam."Param Value");

        exit('');
    end;


    procedure ShowParams(ParamScore: Option " ",Header,Lines; OnlyVisible: Boolean)
    var
        MessageParam: Record "Integration Message Param EDMS";
    begin
        MessageParam.Reset;
        MessageParam.SetRange("Message ID", ID);
        case ParamScore of
            Paramscore::Header:
                MessageParam.SetRange("Message Line No.", 0);
            Paramscore::Lines:
                MessageParam.SetFilter("Message Line No.", '<>0');
        end;
        if OnlyVisible then
            MessageParam.SetRange(Visible, true);

        Page.Run(0, MessageParam);
    end;

    local procedure DeleteParams()
    var
        MessageParam: Record "Integration Message Param EDMS";
    begin
        MessageParam.Reset;
        MessageParam.SetRange("Message ID", ID);
        MessageParam.DeleteAll(true);
    end;


    procedure ClearParams(IncludingLines: Boolean)
    var
        MessageParam: Record "Integration Message Param EDMS";
    begin
        MessageParam.Reset;
        MessageParam.SetRange("Message ID", ID);
        if not IncludingLines then
            MessageParam.SetRange("Message Line No.", 0);
        MessageParam.DeleteAll(true);
    end;

    local procedure "-- Info --"()
    begin
    end;

    local procedure DeleteInfo()
    var
        MessageInfo: Record "Integration Message Info EDMS";
    begin
        MessageInfo.Reset;
        MessageInfo.SetRange("Message ID", ID);
        MessageInfo.DeleteAll(true);
    end;


    procedure ClearInfo(IncludingLines: Boolean)
    var
        MessageInfo: Record "Integration Message Info EDMS";
    begin
        MessageInfo.Reset;
        MessageInfo.SetRange("Message ID", ID);
        if not IncludingLines then
            MessageInfo.SetRange("Message Line No.", 0);
        MessageInfo.SetRange("Disable Deleting", false);
        MessageInfo.DeleteAll(true);
    end;


    procedure InsertInfo(InfoType: Option " ",Error,Warning,Change,Info; InfoText: Text)
    var
        MessageInfo: Record "Integration Message Info EDMS";
    begin
        MessageInfo.Reset;
        MessageInfo.Init;
        MessageInfo."Message ID" := ID;
        MessageInfo."Message Line No." := 0;
        MessageInfo."Entry No." := 0;
        MessageInfo."Connector Code" := "Connector Code";
        MessageInfo."Method Code" := "Method Code";
        MessageInfo.Validate(Type, InfoType);
        MessageInfo.Text := CopyStr(InfoText, 1, MaxStrLen(MessageInfo.Text));

        MessageInfo.SetSource("Source Type", "Source Subtype", "Source ID",
                              "Source Batch Name", "Source Prod. Order Line", "Source Ref. No.", "Item Ledger Entry No.");
        MessageInfo.Insert(true);
    end;


    procedure InsertInfoValueChanged(FieldCaption: Text; OldValue: Text; NewValue: Text)
    begin
        if NewValue = OldValue then
            exit;

        InsertInfo(3, StrSubstNo('%1: %2 -> %3', FieldCaption, OldValue, NewValue));
    end;


    procedure ShowInfoMessages(MessageScore: Option " ",Header,Lines)
    var
        MessageInfo: Record "Integration Message Info EDMS";
    begin
        MessageInfo.Reset;
        MessageInfo.SetRange("Message ID", ID);
        case MessageScore of
            Messagescore::Header:
                MessageInfo.SetRange("Message Line No.", 0);
            Messagescore::Lines:
                MessageInfo.SetFilter("Message Line No.", '<>0');
        end;

        Page.Run(0, MessageInfo);
    end;

    local procedure "-- Blob --"()
    begin
    end;


    procedure ImportFile(Subj: Option Request,Response)
    var
        //TempBlob: Record TempBlob;
        TempBlob: Codeunit "Temp Blob";
        FileMgt: Codeunit "File Management";
        FileName: Text;
        ServerFileName: Text;
        InStreamData: InStream;
        OutStreamData: OutStream;
        BufferText: Text;
        InStream: InStream;
    begin
        if Subj = Subj::Request then
            TestField(Status, Status::Prepared)
        else
            TestField(Status, Status::Waiting);

        //ServerFileName := TemporaryPath;
        FileName := '';
        if not UploadIntoStream('Import Attachment', '', 'All Files (*.*)|*.*', FileName, InStream) then
            Error('Error during copying file: %1.', GetLastErrorText);

        Clear(TempBlob);
        //FileMgt.BLOBImportFromServerFile(TempBlob, ServerFileName); // Copy from file on server (UNC location also)//FIXME
        // Erase(ServerFileName);

        if Subj = Subj::Request then begin
            Clear("Request Blob");
            "Request Blob".CreateOutStream(OutStreamData);
            TempBlob.CreateInStream(InStreamData);
            InStreamData.ReadText(BufferText);
            OutStreamData.WriteText(BufferText);
        end else begin
            Clear("Response Blob");
            "Response Blob".CreateOutStream(OutStreamData);
            TempBlob.CreateInStream(InStreamData);
            InStreamData.ReadText(BufferText);
            OutStreamData.WriteText(BufferText);
        end;

        if Subj = Subj::Request then begin
            CalcFields("Request Blob");
            "Request Blob".CreateInStream(InStreamData);
            InStreamData.ReadText(BufferText);
            TempBlob.CreateOutStream(OutStreamData);
            OutStreamData.WriteText(BufferText);
        end else begin
            CalcFields("Response Blob");
            "Response Blob".CreateInStream(InStreamData);
            InStreamData.ReadText(BufferText);
            TempBlob.CreateOutStream(OutStreamData);
            OutStreamData.WriteText(BufferText);
        end;


        Modify;
    end;


    procedure ExportFile(Subj: Option Request,Response)
    var
        //TempBlob: Record TempBlob;
        TempBlob: Codeunit "Temp Blob";
        FileMgt: Codeunit "File Management";
        ServerFileName: Text;
        ExportToFile: Text;
        Path: Text;
        InStreamData: InStream;
        OutStreamData: OutStream;
        BufferText: Text;
        InStream: InStream;
    begin
        // ServerFileName := FileMgt.ServerTempFileName('');

        if Subj = Subj::Request then begin
            CalcFields("Request Blob");
            "Request Blob".CreateInStream(InStreamData);
            InStreamData.ReadText(BufferText);
            TempBlob.CreateOutStream(OutStreamData);
            OutStreamData.WriteText(BufferText);
        end else begin
            CalcFields("Response Blob");
            "Response Blob".CreateInStream(InStreamData);
            InStreamData.ReadText(BufferText);
            TempBlob.CreateOutStream(OutStreamData);
            OutStreamData.WriteText(BufferText);
        end;

        if TempBlob.HasValue then begin
            TempBlob.CreateInStream(InStream);
            DownloadFromStream(InStream, '', '', '', ServerFileName);
            //  FileMgt.BLOBExportToServerFile(TempBlob, ServerFileName); // export BLOB to file on server (UNC location also) 
            Path := FileMgt.Magicpath;
            if ExportToFile = '' then begin
                //  ExportToFile := FileMgt.GetFileName(FileMgt.ClientTempFileName(''));
                Path := '';
            end;
            DownloadFromStream(InStreamData, 'Export Attachment', Path, 'All Files (*.*)|*.*', ExportToFile);
            // Erase(ServerFileName); //FIXME
            Hyperlink(ExportToFile);
        end;
    end;
}

