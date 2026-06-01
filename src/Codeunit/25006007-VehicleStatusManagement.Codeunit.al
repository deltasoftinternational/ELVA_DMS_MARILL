Codeunit 25006007 "VehicleStatusManagement"
{

    trigger OnRun()
    begin
    end;


    procedure fDocLinkStatus2(intTableID: Integer; intDocType: Integer; codDocNo: Code[20]; intLineNo: Integer; intVehStatus: Integer)
    var
        codNewDimCode: Code[20];
        codNewDimValueCode: Code[20];
    begin
        /*
        recVehStatusDimLink.RESET;
        recVehStatusDimLink.FILTERGROUP(0);
        recVehStatusDimLink.SETRANGE("Vehicle Status",intVehStatus);
        recVehStatusDimLink.FILTERGROUP(2);
        
        IF recVehStatusDimLink.COUNT = 0 THEN
         EXIT;
        
        codNewDimCode := '';
        codNewDimValueCode := '';
        
        IF recVehStatusDimLink.COUNT = 1 THEN
         BEGIN
          recVehStatusDimLink.FIND('-');
          codNewDimCode := recVehStatusDimLink."Dimension Code";
          codNewDimValueCode := recVehStatusDimLink."Dimension Value Code";
         END
        ELSE //Count > 1
         BEGIN
          recVehStatusDimLink.FIND('-');
          IF PAGE.RUNMODAL(PAGE::Form25006529,recVehStatusDimLink) = ACTION::LookupOK THEN
           BEGIN
            codNewDimCode := recVehStatusDimLink."Dimension Code";
            codNewDimValueCode := recVehStatusDimLink."Dimension Value Code";
           END;
         END;
        
        IF codNewDimValueCode = '' THEN
         EXIT;
        
        recDocDim.RESET;
        recDocDim.SETRANGE("Table ID",intTableID);
        recDocDim.SETRANGE("Document Type",intDocType);
        recDocDim.SETRANGE("Document No.",codDocNo);
        recDocDim.SETRANGE("Line No.",intLineNo);
        
        recDocDim.SETRANGE("Dimension Code",codNewDimCode);
        IF recDocDim.FIND('-') THEN
         BEGIN
          recDocDim.VALIDATE("Dimension Value Code",codNewDimValueCode);
          recDocDim.MODIFY(TRUE);
         END
        ELSE
         BEGIN
          recDocDim.INIT;
           recDocDim."Table ID" := intTableID;
           recDocDim."Document Type" := intDocType;
           recDocDim."Document No." := codDocNo;
           recDocDim."Line No." := intLineNo;
           recDocDim.VALIDATE("Dimension Code",codNewDimCode);
           recDocDim.VALIDATE("Dimension Value Code",codNewDimValueCode);
          recDocDim.INSERT(TRUE);
         END;
        */

    end;


    procedure fDocLinkStatusNew(intTableID: Integer; intDocType: Integer; codDocNo: Code[20]; intVehStatus: Integer; var recDimBuff: Record "Dimension Buffer" temporary)
    var
        codNewDimCode: Code[20];
        codNewDimValueCode: Code[20];
    begin
        /*
        recVehStatusDimLink.RESET;
        recVehStatusDimLink.FILTERGROUP(0);
        recVehStatusDimLink.SETRANGE("Vehicle Status",intVehStatus);
        recVehStatusDimLink.FILTERGROUP(2);
        
        IF recVehStatusDimLink.COUNT = 0 THEN
         EXIT;
        
        codNewDimCode := '';
        codNewDimValueCode := '';
        
        IF recVehStatusDimLink.COUNT = 1 THEN
         BEGIN
          recVehStatusDimLink.FIND('-');
          codNewDimCode := recVehStatusDimLink."Dimension Code";
          codNewDimValueCode := recVehStatusDimLink."Dimension Value Code";
         END
        ELSE //Count > 1
         BEGIN
          recVehStatusDimLink.FIND('-');
          IF PAGE.RUNMODAL(PAGE::Form25006529,recVehStatusDimLink) = ACTION::LookupOK THEN
           BEGIN
            codNewDimCode := recVehStatusDimLink."Dimension Code";
            codNewDimValueCode := recVehStatusDimLink."Dimension Value Code";
           END;
         END;
        
        IF codNewDimValueCode = '' THEN
         EXIT;
        
        
        recDimBuff.SETRANGE("Dimension Code",codNewDimCode);
        IF recDimBuff.FIND('-') THEN
         BEGIN
          recDimBuff.VALIDATE("Dimension Value Code",codNewDimValueCode);
          recDimBuff.MODIFY(TRUE);
         END
        ELSE
         BEGIN
          recDimBuff.INIT;
           recDimBuff.VALIDATE("Dimension Code",codNewDimCode);
           recDimBuff.VALIDATE("Dimension Value Code",codNewDimValueCode);
          recDimBuff.INSERT(TRUE);
         END;
        recDimBuff.SETRANGE("Dimension Code");
        */

    end;
}

