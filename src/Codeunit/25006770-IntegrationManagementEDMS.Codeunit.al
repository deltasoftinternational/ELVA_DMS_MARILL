Codeunit 25006770 "Integration Management EDMS"
{
    // #Owner EDMS.Integration


    trigger OnRun()
    begin
        Message(GetConnectorCodeByItemCategory('AIR_FILTER'));
    end;

    local procedure "-- Is Active Or Enabled --"()
    begin
    end;


    procedure IsEnabledActionsByArr10(ConnectorCode: Code[20]; MethodCode: array[10] of Code[20]; var MethodIsEnabled: array[10] of Boolean): Boolean
    var
        IntegrationMethod: Record "Integration Method EDMS";
        IntegrationConnector: Record "Integration Connector EDMS";
        IntegrationConnectorSetup: Record "Integration Connector Setup";
        i: Integer;
    begin
        Clear(MethodIsEnabled);
        if (ConnectorCode = '') then
            exit;
        if not IsIntegrationActive then
            exit;
        if not IntegrationConnector.Get(ConnectorCode) then
            exit;
        if not IntegrationConnector."Is Active" then
            exit;

        for i := 1 to 10 do begin
            if GetIntegrationMethod(MethodCode[i], IntegrationMethod) then
                if IntegrationMethod."Is Active" then
                    if IntegrationConnectorSetup.Get(IntegrationConnector."Connector Code", IntegrationMethod.Code) then
                        MethodIsEnabled[i] := true;
        end;
    end;


    procedure IsIntegrationActive(): Boolean
    var
        IntegrationSetup: Record "Integration Setup EDMS";
    begin
        if IntegrationSetup.Get then
            exit(IntegrationSetup."Integration Is Active" and
                 (IntegrationSetup."Company Name" = COMPANYNAME));
        exit(false);
    end;

    local procedure "-- Integration Connector ---"()
    begin
    end;


    procedure IsConnectorActive("Code": Code[20]): Boolean
    var
        IntegrationConnector: Record "Integration Connector EDMS";
    begin
        if Code <> '' then
            if IntegrationConnector.Get(Code) then
                exit(IntegrationConnector."Is Active");
        exit(false);
    end;


    procedure GetConnectorCodeByItem(ItemNo: Code[20]): Code[20]
    var
        Item: Record Item;
    begin
        if ItemNo <> '' then
            if Item.Get(ItemNo) then
                exit(GetConnectorCodeByItemCategory(Item."Item Category Code"));
        exit('');
    end;


    procedure GetConnectorCodeByItemCategory(ItemCategoryCode: Code[20]): Code[20]
    var
        ItemCategory: Record "Item Category";
    begin
        if ItemCategoryCode <> '' then
            if ItemCategory.Get(ItemCategoryCode) then begin
                repeat
                    if (ItemCategory."Integration Connector Code" = '') and
                       (ItemCategory."Parent Category" <> '')
                    then
                        if not ItemCategory.Get(ItemCategory."Parent Category") then
                            exit('');
                until (ItemCategory."Integration Connector Code" <> '') or
                      (ItemCategory."Parent Category" = '');
                exit(ItemCategory."Integration Connector Code");
            end;
        exit('');
    end;


    procedure GetConnectorCodeByMake(MakeCode: Code[10]): Code[20]
    var
        MakeSetup: Record "Make Setup";
    begin
        if MakeCode <> '' then
            if MakeSetup.Get(MakeCode) then
                exit(MakeSetup."Integration Connector Code");
        exit('');
    end;


    procedure GetConnectorCodeByVendor(VendorNo: Code[20]): Code[20]
    var
        Vendor: Record Vendor;
    begin
        if VendorNo <> '' then
            if Vendor.Get(VendorNo) then
                exit(Vendor."Integration Connector Code");
        exit('');
    end;

    local procedure "-- Integration Methods --"()
    begin
    end;


    procedure GetIntegrationMethod("Code": Code[20]; var IntegrationMethod: Record "Integration Method EDMS"): Boolean
    begin
        Clear(IntegrationMethod);
        if Code = '' then
            exit(false);

        if IntegrationMethod.Get(Code) then
            exit(true);

        IntegrationMethod.SetRange(Alias, Code);
        if IntegrationMethod.Count <> 1 then
            exit(false);

        IntegrationMethod.FindSet;
        exit(true);
    end;


    procedure InitMethodAliasArrayBySource(var MethodAliasArr: array[10] of Code[20]; SourceType: Integer; SourceSubtype: Integer; PageID: Integer; Specific: Integer)
    begin
        Clear(MethodAliasArr);

        case SourceType of
            Database::Item:
                begin
                    MethodAliasArr[1] := 'ITEM_GET_PRICE';
                    MethodAliasArr[2] := 'ITEM_GET_AVAILABLE';
                end;

            Database::"Purchase Header":
                begin
                    MethodAliasArr[1] := 'ITEM_GET_PRICE';
                    MethodAliasArr[2] := 'ITEM_GET_AVAILABLE';
                    if SourceSubtype in [1] then begin
                        if Specific = 0 then
                            MethodAliasArr[3] := 'PO_SUBMIT_ITEMS'
                        else
                            MethodAliasArr[3] := 'PO_SUBMIT_VEH';
                    end;
                end;

            Database::"Sales Header":
                begin
                    MethodAliasArr[1] := 'ITEM_GET_PRICE';
                    MethodAliasArr[2] := 'ITEM_GET_AVAILABLE';
                    if SourceSubtype in [1] then begin
                        if Specific = 0 then
                            MethodAliasArr[3] := 'SO_SUBMIT_ITEMS'
                        else
                            MethodAliasArr[3] := 'SO_SUBMIT_VEH';
                    end;
                end;
        end;
    end;

    local procedure "-- User Session --"()
    begin
    end;


    procedure OpenUserSession(ConnectorSourceType: Integer; SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceLineNo: Integer; PerUser: Boolean; var UserIntegrationSession: Record "User Integr. Session Header")
    begin
        if not FindUserSession(ConnectorSourceType, SourceType, SourceSubtype, SourceID, SourceLineNo, PerUser, UserIntegrationSession) then begin
            CreateUserSession(UserIntegrationSession);
            UserIntegrationSession."Connector Source Type" := ConnectorSourceType;
            UserIntegrationSession."Source Type" := SourceType;
            UserIntegrationSession."Source Subtype" := SourceSubtype;
            UserIntegrationSession."Source ID" := SourceID;
            UserIntegrationSession."Source Line No." := SourceLineNo;
            UserIntegrationSession.Modify;
        end;
    end;


    procedure CreateUserSession(var UserIntegrationSession: Record "User Integr. Session Header")
    begin
        Clear(UserIntegrationSession);
        UserIntegrationSession.Insert(true);
    end;


    procedure CloseUserSession(ID: Integer)
    var
        UserIntegrationSession: Record "User Integr. Session Header";
    begin
        if UserIntegrationSession.Get(ID) then
            UserIntegrationSession.Delete(true);
    end;


    procedure FindUserSession(ConnectorSourceType: Integer; SourceType: Integer; SourceSubtype: Integer; SourceID: Code[20]; SourceLineNo: Integer; PerUser: Boolean; var UserIntegrationSession: Record "User Integr. Session Header"): Boolean
    var
        DT: DateTime;
        TimeOut: Duration;
    begin
        UserIntegrationSession.Reset;
        UserIntegrationSession.SetRange("Connector Source Type", ConnectorSourceType);
        UserIntegrationSession.SetRange("Source Type", SourceType);
        UserIntegrationSession.SetRange("Source Subtype", SourceSubtype);
        UserIntegrationSession.SetRange("Source ID", SourceID);
        UserIntegrationSession.SetRange("Source Line No.", SourceLineNo);
        if PerUser then
            UserIntegrationSession.SetRange("User ID", UserId);

        TimeOut := GetTimeOut(0);
        DT := CurrentDatetime - TimeOut;
        UserIntegrationSession.SetFilter("Started At", '<%1', DT);
        if UserIntegrationSession.FindSet then
            repeat
                CloseUserSession(UserIntegrationSession.ID);
            until UserIntegrationSession.Next = 0;

        UserIntegrationSession.SetRange("Started At");
        exit(UserIntegrationSession.FindLast);
    end;


    procedure OpenUserSessionDialog(var UserIntegrationSession: Record "User Integr. Session Header"; Mode: Integer; StartOnOpen: Boolean)
    var
        ItemIntegrationBuffer: Page "EDMS IR Items";
    begin
        UserIntegrationSession.TestField(ID);

        Clear(ItemIntegrationBuffer);
        ItemIntegrationBuffer.SetUserSession(UserIntegrationSession, Mode, StartOnOpen);
        ItemIntegrationBuffer.RunModal;
    end;

    local procedure "-- Specific --"()
    begin
    end;

    local procedure GetTimeOut(Subj: Option " ",Short,Medium,Long): Duration
    begin
        // By Setup in future
        exit(1000 * 60 * 2);
    end;
}

