Codeunit 25006783 "Item Purch. Doc. Mgt. EDMS"
{
    // #Owner EDMS.Integration


    trigger OnRun()
    begin
    end;

    var
        DMSIntegrationMgt: Codeunit "Integration Management EDMS";
        DMSIntegrationMsgMgt: Codeunit "Integration Message Mgt. EDMS";
        SubmitConfirmRst: label 'Do You want  submit document No. %1?';

    local procedure "-- Submit PO --"()
    begin
    end;


    procedure SubmitPurchOrderYN(var PurchHeader: Record "Purchase Header")
    var
        MethodCode: Code[20];
        ErrorMessage: Text;
    begin
        PurchHeader.TestField("No.");
        PurchHeader.TestField("Document Type", PurchHeader."document type"::Order);

        if not Confirm(SubmitConfirmRst, false, PurchHeader."No.") then
            exit;

        MethodCode := 'PO_SUBMIT_ITEMS';
        if not SubmitPurchOrderReq(PurchHeader, MethodCode, ErrorMessage) then
            Error(ErrorMessage);
    end;


    procedure SubmitPurchOrderReq(var PurchHeader: Record "Purchase Header"; MethodCode: Code[20]; var ErrorMessage: Text): Boolean
    var
        MessageHeader: Record "Integration Message EDMS";
        PurchLine: Record "Purchase Line";
        ConnectorCode: Code[20];
    begin
        ErrorMessage := '';

        if not CheckPurchOrderBeforeSubmit(PurchHeader, PurchLine) then begin
            ErrorMessage := GetLastErrorText;
            exit(false);
        end;

        ConnectorCode := DMSIntegrationMgt.GetConnectorCodeByVendor(PurchHeader."Buy-from Vendor No.");
        if not DMSIntegrationMsgMgt.CreateIntegrationMessage(ConnectorCode, MethodCode, 2, 1, MessageHeader, ErrorMessage) then begin
            ErrorMessage := GetLastErrorText;
            exit(false);
        end;

        MessageHeader.SetSource(Database::"Purchase Header", PurchHeader."Document Type".AsInteger(), PurchHeader."No.", '', 0, 0, 0);
        MessageHeader.Modify;

        if not FillMessageDataOnPurchOrder(MessageHeader, PurchHeader, PurchLine, ErrorMessage) then begin
            MessageHeader.InsertInfo(1, ErrorMessage);
            exit(false);
        end;

        MessageHeader.SetAsPrepared;

        if not DMSIntegrationMsgMgt.StartIntegrationMessageRequest(MessageHeader, ErrorMessage) then begin
            MessageHeader.InsertInfo(1, ErrorMessage);
            exit(false);
        end;

        PurchHeader.Validate("Document Vendor Status", PurchHeader."document vendor status"::Sent);
        PurchHeader.Modify;

        MessageHeader.SetAsWaiting;

        exit(true);
    end;

    [TryFunction]
    local procedure CheckPurchOrderBeforeSubmit(var PurchHeader: Record "Purchase Header"; var PurchLine: Record "Purchase Line")
    begin
        PurchHeader.TestField("No.");
        PurchHeader.TestField("Document Type", PurchHeader."document type"::Order);
        PurchHeader.TestField("Document Vendor Status", PurchHeader."document vendor status"::" ");

        PurchLine.Reset;
        PurchLine.SetRange("Document Type", PurchHeader."Document Type");
        PurchLine.SetRange("Document No.", PurchHeader."No.");
        PurchLine.SetRange(Type, PurchLine.Type::Item);
        PurchLine.SetFilter("No.", '<>%1', '');
        PurchLine.FindFirst;
    end;

    local procedure FillMessageDataOnPurchOrder(var MessageHeader: Record "Integration Message EDMS"; var PurchHeader: Record "Purchase Header"; var PurchLine: Record "Purchase Line"; var ErrorMessage: Text): Boolean
    var
        MessageLine1: Record "Integration Message Line EDMS";
        MessageLine2: Record "Integration Message Line EDMS";
    begin
        ErrorMessage := '';

        MessageHeader.AddLine(MessageLine1);
        MessageLine1.SetSource(Database::"Purchase Header", PurchHeader."Document Type".AsInteger(), PurchHeader."No.", '', 0, 0, 0);
        MessageLine1.Validate("Vendor No.", PurchHeader."Buy-from Vendor No.");
        MessageLine1.Validate("Ordering Price Type Code", PurchHeader."Ordering Price Type Code");
        MessageLine1.Validate("Document No.", PurchHeader."No.");
        MessageLine1.Validate("Document Date", PurchHeader."Document Date");
        MessageLine1.Modify;

        PurchLine.FindFirst;
        repeat
            MessageLine1.AddChildLine(MessageLine2);
            MessageLine2.SetSource(Database::"Purchase Line", PurchLine."Document Type".AsInteger(), PurchLine."Document No.", '', 0, PurchLine."Line No.", 0);
            MessageLine2.Validate("Item No.", PurchLine."No.");
            MessageLine2.Validate("Variant Code", PurchLine."Variant Code");
            MessageLine2.Validate("Unit Of Measure Code", PurchLine."Unit of Measure Code");
            MessageLine2.Validate("Location Code", PurchLine."Location Code");
            MessageLine2.Validate("Location Code Original", PurchLine."Location Code");
            MessageLine2.Validate(Quantity, PurchLine.Quantity);
            MessageLine2.Validate("Ordering Price Type Code", PurchLine."Ordering Price Type Code");
            MessageLine2.Validate("Unit Price", PurchLine."Direct Unit Cost");
            MessageLine2.Modify;
        until PurchLine.Next = 0;

        exit(true);
    end;


    procedure SubmitPurchOrderResp(MessageHeader: Record "Integration Message EDMS"): Boolean
    var
        PurchHeader: Record "Purchase Header";
        PurchLine: Record "Purchase Line";
        MessageLine1: Record "Integration Message Line EDMS";
        ConnectorCode: Code[20];
    begin
        MessageLine1.PrepareLinesOnMessage(MessageHeader);
        MessageLine1.FindFirst;

        MessageLine1.TestField("Source Type", Database::"Purchase Header");
        MessageLine1.TestField("Source Subtype");
        MessageLine1.TestField("Source ID");
        PurchHeader.Get(MessageLine1."Source Subtype", MessageLine1."Source ID");
        PurchHeader.TestField("DMS Integration Status", PurchHeader."dms integration status"::Waiting);
        PurchHeader.TestField("Document Vendor Status", PurchHeader."document vendor status"::Sent);

        PurchHeader.Validate("Document Vendor Status", PurchHeader."document vendor status"::Confirmed);
        PurchHeader.Modify;
    end;
}

