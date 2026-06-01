//Not used by DMS at this moment. Comes from GH
Codeunit 25006950 "VRM Lookup Management"
{

    trigger OnRun()
    begin
    end;

    var
        DataBuffer: Record "Data Buffer" temporary;
        TokenManagement: Codeunit "Token Management";
        Text001: label 'VRM Lookup unsuccessful';

    [EventSubscriber(ObjectType::Table, Database::"Service Header EDMS", 'OnBeforeValidateEvent', 'Vehicle Registration No.', false, false)]
    local procedure GetVRMLookupData(var Rec: Record "Service Header EDMS"; var xRec: Record "Service Header EDMS"; CurrFieldNo: Integer)
    var
        Vehicle: Record Vehicle;
        ThirdPartiesService: Record "3rd Parties Services";
        ErrorMsg: Text;
    begin
        /*
        IF NOT VRMLookupSetup.GET THEN
          EXIT;
        IF NOT VRMLookupSetup."VRM Lookup Activated" THEN
          EXIT;
        
        IF NOT ThirdPartiesService.GET('VRM LOOKUP') THEN
          EXIT
        ELSE IF NOT ThirdPartiesService.Enabled THEN
          EXIT;
        
        IF NOT TokenManagement.CheckTokens(1,'VRM LOOKUP',ErrorMsg) THEN
          EXIT;
        
        Vehicle.RESET;
        Vehicle.SETRANGE("Registration No.",Rec."Vehicle Registration No.");
        IF NOT Vehicle.FINDFIRST THEN BEGIN
          CASE VRMLookupSetup."VRM Lookup Provider" OF
            VRMLookupSetup."VRM Lookup Provider"::"0":
              ProcessDVLASearchProvider(Rec."Vehicle Registration No.");
            VRMLookupSetup."VRM Lookup Provider"::"1":
              ProcessCarWebProvider(Rec."Vehicle Registration No.");
          END;
        END;
        DataBuffer.RESET;
        DataBuffer.DELETEALL;
        */

    end;

    local procedure ProcessDVLASearchProvider(VehicleRegNo: Code[20])
    var
        ResponseData: Text;
        RequestString: Text;
        ResponseString: Text;
        ThirdPartiesService: Record "3rd Parties Services";
    begin
        /*
        VRMLookupSetup.TESTFIELD(URL);
        VRMLookupSetup.TESTFIELD(Key);
        RequestString := STRSUBSTNO(VRMLookupSetup.URL,VehicleRegNo,VRMLookupSetup.Key);
        IF NOT GetDVLASearchResponse(RequestString,ResponseString,VehicleRegNo,TRUE) THEN BEGIN
          MESSAGE(Text001);
          EXIT;
        END;
        IF ResponseString <> '' THEN
          ParseJSON(ResponseString);
        
        // Check for errors
        DataBuffer.RESET;
        DataBuffer.SETRANGE("Text Field 1",'message');
        IF DataBuffer.FINDFIRST THEN
          MESSAGE(DataBuffer."Text Field 2")
        ELSE
          ApplyVRMLookupData(VehicleRegNo);
        */

    end;

    [TryFunction]

    procedure GetDVLASearchResponse(RequestString: Text; var ResponseString: Text; VehicleRegNo: Code[20]; RegisterTokens: Boolean)
    var
    //WebClient: dotnet WebClient;//FIXME
    begin
        //FIXME
        // WebClient := WebClient.WebClient;
        // //ResponseString := WebClient.DownloadString('https://dvlasearch.appspot.com/DvlaSearch?licencePlate=mt09nks&apikey=DvlaSearchDemoAccount');
        // ResponseString := WebClient.DownloadString(RequestString);
        // if RegisterTokens then
        //     TokenManagement.RegisterSpentTokens(1, 'VRM LOOKUP', VehicleRegNo);
        // Clear(WebClient);
    end;


    procedure ParseJSON(StringToParse: Text)
    var
        "Key": Text;
        Mode: Integer;
        i: Integer;
        KeyValue: Text;
    begin
        /*
        DataBuffer.Reset;
        DataBuffer.DeleteAll;
        Mode := 1;

        for i := 1 to StrLen(StringToParse) do begin
            case Mode of
                0: // Search for key end
                    begin
                        if StringToParse[i] = '"' then begin
                            Mode := 6;
                        end else
                            Key := Key + Format(StringToParse[i]);
                    end;
                1: // Search for key begin
                    begin
                        if StringToParse[i] = '"' then begin
                            Mode := 0;
                        end;
                    end;
                2: // Handle complex data types not required in this case...
                    begin
                        //message('Complex Type ' + Key);
                        Key := '';
                        if StringToParse[i] = '"' then
                            Mode := 0
                        else
                            Mode := 1;
                    end;
                3: // Search for Value end
                    begin
                        if StringToParse[i] = '"' then begin
                            Mode := 1;
                            ProcessKeyValue(Key, KeyValue);
                            Key := '';
                            KeyValue := '';
                        end else
                            KeyValue := KeyValue + Format(StringToParse[i]);
                    end;

                4: // Search for Value begin
                    begin
                        if (StringToParse[i] = '{') or (StringToParse[i] = '[') then
                            Mode := 2;
                        if StringToParse[i] = '"' then
                            Mode := 3;
                        if (StringToParse[i] in ['0' .. '9']) or (StringToParse[i] in ['t', 'f', 'n']) then begin
                            KeyValue := KeyValue + Format(StringToParse[i]);
                            Mode := 5;
                        end;
                    end;
                5: // Numeric value or false,true,null
                    begin
                        if (StringToParse[i] in ['0' .. '9']) or (StringToParse[i] in ['a', 'l', 's', 'e', 't', 'r', 'u', 'n', 'u', 'l']) then
                            KeyValue := KeyValue + Format(StringToParse[i])
                        else begin
                            Mode := 1;
                            ProcessKeyValue(Key, KeyValue);
                            Key := '';
                            KeyValue := '';
                        end;
                    end;
                6: // Search for :
                    begin
                        if StringToParse[i] = ':' then Mode := 4;
                    end;
            end;
        end;
        */
    end;

    [TryFunction]
    local procedure ParseDate(DateString: Text; var DateDate: DateTime)
    var
    // date: dotnet DateTime;//FIXME
    //provider: dotnet IFormatProvider; //FIXME
    // culture: dotnet CultureInfo;//FIXME
    begin
        /* FIXME
        provider := culture.InvariantCulture;
        date := date.Parse(DateString,provider);
        DateDate := date;
        Clear(provider);
        Clear(date);
        */
    end;


    procedure GetDVLAAccountStatus()
    var
        Text001: label 'Used Credit %1 \Total Credit %2';
        RequestString: Text;
        ResponseString: Text;
        UsedCredit: Text;
        TotalCredit: Text;
    begin
        /*
        IF NOT VRMLookupSetup.GET THEN
          EXIT;
        VRMLookupSetup.TESTFIELD(URL);
        VRMLookupSetup.TESTFIELD(Key);
        RequestString := STRSUBSTNO(VRMLookupSetup.AdminURL,VRMLookupSetup.Key);
        IF NOT GetDVLASearchResponse(RequestString,ResponseString,'',FALSE) THEN BEGIN
          MESSAGE(GETLASTERRORTEXT);
          EXIT;
        END;
        IF ResponseString <> '' THEN
          ParseJSON(ResponseString);
        
        DataBuffer.RESET;
        DataBuffer.SETRANGE("Text Field 1",'message');
        IF DataBuffer.FINDFIRST THEN
          MESSAGE(DataBuffer."Text Field 2")
        ELSE BEGIN
          DataBuffer.RESET;
          DataBuffer.SETRANGE("Text Field 1",'usedCredit');
          IF DataBuffer.FINDFIRST THEN
            UsedCredit := DataBuffer."Text Field 2";
          DataBuffer.RESET;
          DataBuffer.SETRANGE("Text Field 1",'totalCredit');
          IF DataBuffer.FINDFIRST THEN
            TotalCredit := DataBuffer."Text Field 2";
          MESSAGE(Text001,UsedCredit,TotalCredit);
        END;
        DataBuffer.RESET;
        DataBuffer.DELETEALL;
        */

    end;

    local procedure ProcessCarWebProvider(VehicleRegNo: Code[20])
    var
        RequestString: Text;
        ResponseString: Text;
    begin
        /*
        VRMLookupSetup.TESTFIELD(URL);
        VRMLookupSetup.TESTFIELD(Key);
        VRMLookupSetup.TESTFIELD("User Name");
        VRMLookupSetup.TESTFIELD(Password);
        VRMLookupSetup.TESTFIELD("Client Ref");
        
        RequestString := STRSUBSTNO(VRMLookupSetup.URL,VehicleRegNo,VRMLookupSetup.Key);
        IF NOT GetCarWebResponse(VehicleRegNo) THEN BEGIN
          MESSAGE(Text001);
          EXIT;
        END;
        
         // Check for errors
        DataBuffer.RESET;
        DataBuffer.SETRANGE("Text Field 1",'message');
        IF DataBuffer.FINDFIRST THEN
          MESSAGE(DataBuffer."Text Field 2")
        ELSE
          ApplyVRMLookupData(VehicleRegNo);
        */

    end;

    [TryFunction]
    local procedure GetCarWebResponse(VehicleRegNo: Code[20])
    var
        //HttpWebRequest: dotnet WebRequest;//FIXME
        //HttpWebResponse: dotnet WebResponse; //FIXME
        ResponseInStream: InStream;
        ResponseText: Text;
        // XmlDocument: dotnet XmlDocument;//FIXME
        // XmlNodeList: dotnet XmlNodeList;//FIXME
        // XmlNode: dotnet XmlNode;//FIXME
        // XmlNodeList2: dotnet XmlNodeList;//FIXME
        // XmlNode2: dotnet XmlNode;//FIXME
        // MemoryStream: dotnet MemoryStream;//FIXME
        // StreamReader: dotnet StreamReader;//FIXME
        n: Integer;
        MyFile: File;
        FileName: Text;
    begin
        /*
        IF VRMLookupSetup.GET THEN;
        
        HttpWebRequest := HttpWebRequest.Create(VRMLookupSetup.URL + '/strB2BGetVehicleByVRM?'
                        + 'strUserName=' + VRMLookupSetup."User Name"+'&strPassword=' + VRMLookupSetup.Password
                        + '&strClientRef=' + VRMLookupSetup."Client Ref" +'&strClientDescription=' + VRMLookupSetup."Client Description"
                        + '&strKey1=' + VRMLookupSetup.Key +'&strVRM=' + VehicleRegNo
                        + '&strVersion=' + VRMLookupSetup.Version
                        );
        HttpWebRequest.Method := 'GET';
        HttpWebRequest.Timeout := 60000;
        HttpWebRequest.ContentType('application/xml');
        HttpWebResponse := HttpWebRequest.GetResponse;
        // Register Spent Tokens ----->
        TokenManagement.RegisterSpentTokens(1,'VRM LOOKUP',VehicleRegNo);
        // <--------------------------
        
        //MyFile.OPEN('E:\Darbi\GH\Carweb.txt');
        // UPLOADINTOSTREAM('Select the simple.xml file',
        //                        'c:\temp',
        //                        'TXT File *.txt| *.txt',
        //                         FileName,
        //                         ResponseInStream);
        
        
        MemoryStream := MemoryStream.MemoryStream;
        HttpWebResponse.GetResponseStream.CopyTo(MemoryStream);
        MemoryStream.Position(0);
        StreamReader := StreamReader.StreamReader(MemoryStream);
        //StreamReader := StreamReader.StreamReader(ResponseInStream);
        ResponseText.ADDTEXT(StreamReader.ReadToEnd);
        XmlDocument := XmlDocument.XmlDocument;
        XmlDocument.LoadXml(ResponseText);
        n := 0;
        XmlNodeList := XmlDocument.GetElementsByTagName('Vehicle');
        WHILE n < XmlNodeList.Count DO BEGIN
          XmlNode := XmlNodeList.Item(n);
          XmlNode2 := XmlNode.SelectSingleNode('DateOfFirstRegistrationUK');
          ProcessNode('DateOfFirstRegistrationUK',XmlNode2);
          XmlNode2 := XmlNode.SelectSingleNode('ManufacturerModelYr');
          ProcessNode('ManufacturerModelYr',XmlNode2);
          XmlNode2 := XmlNode.SelectSingleNode('Combined_VIN');
          ProcessNode('Combined_VIN',XmlNode2);
          XmlNode2 := XmlNode.SelectSingleNode('ColourCurrent');
          ProcessNode('ColourCurrent',XmlNode2);
          XmlNode2 := XmlNode.SelectSingleNode('NumberOfDoors');
          ProcessNode('NumberOfDoors',XmlNode2);
          XmlNode2 := XmlNode.SelectSingleNode('BodyStyle');
          ProcessNode('BodyStyle',XmlNode2);
          XmlNode2 := XmlNode.SelectSingleNode('BodyStyleDescription');
          ProcessNode('BodyStyleDescription',XmlNode2);
          XmlNode2 := XmlNode.SelectSingleNode('lrHandDrive');
          ProcessNode('lrHandDrive',XmlNode2);
          XmlNode2 := XmlNode.SelectSingleNode('StartDateOfCurrentKeeper');
          ProcessNode('StartDateOfCurrentKeeper',XmlNode2);
          XmlNode2 := XmlNode.SelectSingleNode('DateOfPreviousKepperDisposal');
          ProcessNode('DateOfPreviousKepperDisposal',XmlNode2);
          XmlNode2 := XmlNode.SelectSingleNode('ScrappingMarker');
          ProcessNode('ScrappingMarker',XmlNode2);
          XmlNode2 := XmlNode.SelectSingleNode('ScrappingDate');
          ProcessNode('ScrappingDate',XmlNode2);
          XmlNode2 := XmlNode.SelectSingleNode('Combined_Make');
          ProcessNode('Combined_Make',XmlNode2);
          XmlNode2 := XmlNode.SelectSingleNode('Combined_Model');
          ProcessNode('Combined_Model',XmlNode2);
          XmlNode2 := XmlNode.SelectSingleNode('ModelYear');
          ProcessNode('ModelYear',XmlNode2);
          XmlNode2 := XmlNode.SelectSingleNode('VehicleCategoryDescription');
          ProcessNode('VehicleCategoryDescription',XmlNode2);
          XmlNode2 := XmlNode.SelectSingleNode('Aspiration');
          ProcessNode('Aspiration',XmlNode2);
          XmlNode2 := XmlNode.SelectSingleNode('Combined_EngineCapacity');
          ProcessNode('Combined_EngineCapacity',XmlNode2);
          XmlNode2 := XmlNode.SelectSingleNode('Combined_FuelType');
          ProcessNode('Combined_FuelType',XmlNode2);
          XmlNode2 := XmlNode.SelectSingleNode('Combined_Transmission');
          ProcessNode('Combined_Transmission',XmlNode2);
          XmlNode2 := XmlNode.SelectSingleNode('Combined_ForwardGears');
          ProcessNode('Combined_ForwardGears',XmlNode2);
        
          XmlNode2 := XmlNode.SelectSingleNode('NumberOfCylinders');
          ProcessNode('NumberOfCylinders',XmlNode2);
          XmlNode2 := XmlNode.SelectSingleNode('EngineNumber');
          ProcessNode('EngineNumber',XmlNode2);
          XmlNode2 := XmlNode.SelectSingleNode('EngineModelCode');
          ProcessNode('EngineModelCode',XmlNode2);
          XmlNode2 := XmlNode.SelectSingleNode('ValveGear');
          ProcessNode('ValveGear',XmlNode2);
          XmlNode2 := XmlNode.SelectSingleNode('NumberOfValvesPerCylinder');
          ProcessNode('NumberOfValvesPerCylinder',XmlNode2);
          XmlNode2 := XmlNode.SelectSingleNode('MaximumPowerInKW');
          ProcessNode('MaximumPowerInKW',XmlNode2);
          XmlNode2 := XmlNode.SelectSingleNode('MaximumTorqueNM');
          ProcessNode('MaximumTorqueNM',XmlNode2);
          XmlNode2 := XmlNode.SelectSingleNode('FuelConsumptionExtraUrbanMPG');
          ProcessNode('FuelConsumptionExtraUrbanMPG',XmlNode2);
          XmlNode2 := XmlNode.SelectSingleNode('FuelConsumptionCombinedMPG');
          ProcessNode('FuelConsumptionCombinedMPG',XmlNode2);
          XmlNode2 := XmlNode.SelectSingleNode('FuelConsumptionUrbanColdMPG');
          ProcessNode('FuelConsumptionUrbanColdMPG',XmlNode2);
        
          XmlNode2 := XmlNode.SelectSingleNode('AccelerationTo100KPHSecs');
          ProcessNode('AccelerationTo100KPHSecs',XmlNode2);
          XmlNode2 := XmlNode.SelectSingleNode('EuroStatus');
          ProcessNode('EuroStatus',XmlNode2);
          XmlNode2 := XmlNode.SelectSingleNode('CO2');
          ProcessNode('CO2',XmlNode2);
          XmlNode2 := XmlNode.SelectSingleNode('CO_GtoKm');
          ProcessNode('CO_GtoKm',XmlNode2);
          XmlNode2 := XmlNode.SelectSingleNode('GrossWeightKG');
          ProcessNode('GrossWeightKG',XmlNode2);
          n += 1;
        END;
        
        XmlNodeList := XmlDocument.GetElementsByTagName('ErrorDescription');
        XmlNode := XmlNodeList.Item(0);
        IF NOT ISNULL(XmlNode) THEN
          IF XmlNode.InnerText <> '' THEN
            ProcessNode('message',XmlNode);
        */

    end;

    // local procedure ProcessNode("Key": Text; XmlNode: dotnet XmlNode)//FIXME
    // begin
    //     /*
    //     IF NOT ISNULL(XmlNode) THEN
    //       ProcessKeyValue(Key,XmlNode.InnerText);
    //     */

    // end;

    local procedure InsertVariablFieldOption(MakeCode: Code[20]; VarFieldCode: Code[10]; "Code": Code[20]; Description: Text)
    var
        VariableFieldOptions: Record "Variable Field Options";
    begin
        /*
        IF NOT VariableFieldOptions.GET(MakeCode,VarFieldCode,Code) THEN BEGIN
          VariableFieldOptions.INIT;
          VariableFieldOptions."Make Code" := MakeCode;
          VariableFieldOptions."Variable Field Code" := VarFieldCode;
          VariableFieldOptions.Code := Code;
          VariableFieldOptions.Description := Description;
          VariableFieldOptions.INSERT;
        END;
        */

    end;

    local procedure ProcessKeyValue("Key": Text; KValue: Text)
    var
        n: Integer;
    begin
        /*
        n := 1;
        IF DataBuffer.FINDLAST THEN
          n:=DataBuffer."Entry No." + 1;
        DataBuffer.INIT;
        DataBuffer."Entry No." := n;
        DataBuffer."Text Field 1" := Key;
        DataBuffer."Text Field 2" := KValue;
        DataBuffer.INSERT;
        */

    end;

    local procedure ApplyVRMLookupData(VehRegNo: Text)
    var
        Make: Record Make;
        Model: Record Model;
        BodyColor: Record "Body Color";
        Vehicle: Record Vehicle;
        Date: DateTime;
        VariableFieldUsage: Record "Variable Field Usage";
    begin
        /*
        // Look for make
        DataBuffer.RESET;
        DataBuffer.SETFILTER("Text Field 1",'%1|%2','make','Combined_Make');
        IF DataBuffer.FINDFIRST THEN BEGIN
          IF NOT Make.GET(DELSTR(DataBuffer."Text Field 2",21)) THEN BEGIN
            Make.INIT;
            Make.Code := DELSTR(DataBuffer."Text Field 2",21);
            Make.Name := DELSTR(DataBuffer."Text Field 2",31);
            Make.INSERT;
          END;
        END;
        
        // Look for model
        DataBuffer.RESET;
        DataBuffer.SETFILTER("Text Field 1",'%1|%2','model','Combined_Model');
        IF DataBuffer.FINDFIRST THEN BEGIN
          IF NOT Model.GET(Make.Code,DELSTR(DataBuffer."Text Field 2",21)) THEN BEGIN
            Model.INIT;
            Model."Make Code" := Make.Code;
            Model.Code := DELSTR(DataBuffer."Text Field 2",21);
            Model.INSERT;
          END;
        END;
        
        // Look for color code
        DataBuffer.RESET;
        DataBuffer.SETFILTER("Text Field 1",'%1|%2','colour','ColourCurrent');
        IF DataBuffer.FINDFIRST THEN BEGIN
          IF NOT BodyColor.GET(DELSTR(DataBuffer."Text Field 2",21)) THEN BEGIN
            BodyColor.INIT;
            BodyColor.Code := DELSTR(DataBuffer."Text Field 2",21);
            BodyColor.Description := DELSTR(DataBuffer."Text Field 2",31);
            BodyColor.INSERT;
          END;
        END;
        
        Vehicle.INIT;
        Vehicle."Make Code" := Make.Code;
        Vehicle."Model Code" := Model.Code;
        Vehicle."Registration No." := VehRegNo;
        Vehicle."Body Color Code" := BodyColor.Code;
        
        DataBuffer.RESET;
        IF DataBuffer.FIND('-') THEN BEGIN
          REPEAT
            CASE DataBuffer."Text Field 1" OF
              'ManufacturerModelYr','yearOfManufacture':
                Vehicle."Production Year" := DELSTR(DataBuffer."Text Field 2",5);
              'dateOfFirstRegistration':
                BEGIN
                  IF ParseDate(DataBuffer."Text Field 2",Date) THEN
                    Vehicle."First Registration Date" := DT2DATE(Date);
                END;
              'DateOfFirstRegistrationUK':
                 EVALUATE(Vehicle."First Registration Date", DataBuffer."Text Field 2",9);
              'Combined_VIN':
                Vehicle.VIN := DELSTR(DataBuffer."Text Field 2",21);
              'EngineModelCode':
                Vehicle."Engine Code" := DELSTR(DataBuffer."Text Field 2",31);
            END;
          UNTIL DataBuffer.NEXT=0;
        END;
        
        Vehicle.INSERT(TRUE);
        
        IF DataBuffer.FIND('-') THEN BEGIN
          REPEAT
            CASE DataBuffer."Text Field 1" OF
              'sixMonthRate':
                BEGIN
                  VariableFieldUsage.RESET;
                  VariableFieldUsage.SETRANGE("Table No.",DATABASE::Vehicle);
                  VariableFieldUsage.SETRANGE("Variable Field Code",'SIXMONTH');
                  IF VariableFieldUsage.FINDFIRST THEN
                    UpdateVehicleVariableField(VariableFieldUsage."Field No.",DataBuffer."Text Field 2",Vehicle,'SIXMONTH');
                END;
              'twelveMonthRate':
                BEGIN
                  VariableFieldUsage.RESET;
                  VariableFieldUsage.SETRANGE("Table No.",DATABASE::Vehicle);
                  VariableFieldUsage.SETRANGE("Variable Field Code",'TWMONTH');
                  IF VariableFieldUsage.FINDFIRST THEN
                    UpdateVehicleVariableField(VariableFieldUsage."Field No.",DataBuffer."Text Field 2",Vehicle,'TWMONTH');
                END;
              'Combined_EngineCapacity','cylinderCapacity':
                BEGIN
                  VariableFieldUsage.RESET;
                  VariableFieldUsage.SETRANGE("Table No.",DATABASE::Vehicle);
                  VariableFieldUsage.SETRANGE("Variable Field Code",'CYLCAP');
                  IF VariableFieldUsage.FINDFIRST THEN
                    UpdateVehicleVariableField(VariableFieldUsage."Field No.",DataBuffer."Text Field 2",Vehicle,'CYLCAP');
                END;
              'CO2','co2Emissions':
                BEGIN
                  VariableFieldUsage.RESET;
                  VariableFieldUsage.SETRANGE("Table No.",DATABASE::Vehicle);
                  VariableFieldUsage.SETRANGE("Variable Field Code",'CO2');
                  IF VariableFieldUsage.FINDFIRST THEN
                    UpdateVehicleVariableField(VariableFieldUsage."Field No.",DataBuffer."Text Field 2",Vehicle,'CO2');
                END;
              'Combined_FuelType','fuelType':
                BEGIN
                  VariableFieldUsage.RESET;
                  VariableFieldUsage.SETRANGE("Table No.",DATABASE::Vehicle);
                  VariableFieldUsage.SETRANGE("Variable Field Code",'FUEL TYPE');
                  IF VariableFieldUsage.FINDFIRST THEN
                    UpdateVehicleVariableField(VariableFieldUsage."Field No.",DataBuffer."Text Field 2",Vehicle,'FUEL TYPE');
                END;
              'taxStatus':
                BEGIN
                  VariableFieldUsage.RESET;
                  VariableFieldUsage.SETRANGE("Table No.",DATABASE::Vehicle);
                  VariableFieldUsage.SETRANGE("Variable Field Code",'TAX STATUS');
                  IF VariableFieldUsage.FINDFIRST THEN
                    UpdateVehicleVariableField(VariableFieldUsage."Field No.",DataBuffer."Text Field 2",Vehicle,'TAX STATUS');
                END;
              'typeApproval':
                BEGIN
                  VariableFieldUsage.RESET;
                  VariableFieldUsage.SETRANGE("Table No.",DATABASE::Vehicle);
                  VariableFieldUsage.SETRANGE("Variable Field Code",'TYPE APPR');
                  IF VariableFieldUsage.FINDFIRST THEN
                    UpdateVehicleVariableField(VariableFieldUsage."Field No.",DataBuffer."Text Field 2",Vehicle,'TYPE APPR');
                END;
              'wheelPlan':
                BEGIN
                  VariableFieldUsage.RESET;
                  VariableFieldUsage.SETRANGE("Table No.",DATABASE::Vehicle);
                  VariableFieldUsage.SETRANGE("Variable Field Code",'WHEEL PLAN');
                  IF VariableFieldUsage.FINDFIRST THEN
                    UpdateVehicleVariableField(VariableFieldUsage."Field No.",DataBuffer."Text Field 2",Vehicle,'WHEEL PLAN');
                END;
              'revenueWeight':
                BEGIN
                  VariableFieldUsage.RESET;
                  VariableFieldUsage.SETRANGE("Table No.",DATABASE::Vehicle);
                  VariableFieldUsage.SETRANGE("Variable Field Code",'REVENUE W.');
                  IF VariableFieldUsage.FINDFIRST THEN
                    UpdateVehicleVariableField(VariableFieldUsage."Field No.",DataBuffer."Text Field 2",Vehicle,'REVENUE W.');
                END;
              'taxDetails':
                BEGIN
                  VariableFieldUsage.RESET;
                  VariableFieldUsage.SETRANGE("Table No.",DATABASE::Vehicle);
                  VariableFieldUsage.SETRANGE("Variable Field Code",'TAXDETAILS');
                  IF VariableFieldUsage.FINDFIRST THEN
                    UpdateVehicleVariableField(VariableFieldUsage."Field No.",DataBuffer."Text Field 2",Vehicle,'TAXDETAILS');
                END;
              'motDetails':
                BEGIN
                  VariableFieldUsage.RESET;
                  VariableFieldUsage.SETRANGE("Table No.",DATABASE::Vehicle);
                  VariableFieldUsage.SETRANGE("Variable Field Code",'MOTDETAILS');
                  IF VariableFieldUsage.FINDFIRST THEN
                    UpdateVehicleVariableField(VariableFieldUsage."Field No.",DataBuffer."Text Field 2",Vehicle,'MOTDETAILS');
                END;
              'tax':
                BEGIN
                  VariableFieldUsage.RESET;
                  VariableFieldUsage.SETRANGE("Table No.",DATABASE::Vehicle);
                  VariableFieldUsage.SETRANGE("Variable Field Code",'TAX');
                  IF VariableFieldUsage.FINDFIRST THEN
                    UpdateVehicleVariableField(VariableFieldUsage."Field No.",DataBuffer."Text Field 2",Vehicle,'TAX');
                END;
              'mot':
                BEGIN
                  VariableFieldUsage.RESET;
                  VariableFieldUsage.SETRANGE("Table No.",DATABASE::Vehicle);
                  VariableFieldUsage.SETRANGE("Variable Field Code",'MOT');
                  IF VariableFieldUsage.FINDFIRST THEN
                    UpdateVehicleVariableField(VariableFieldUsage."Field No.",DataBuffer."Text Field 2",Vehicle,'MOT');
                END;
        //      'EngineModelCode':
        //        BEGIN
        //          VariableFieldUsage.RESET;
        //          VariableFieldUsage.SETRANGE("Table No.",DATABASE::Vehicle);
        //          VariableFieldUsage.SETRANGE("Variable Field Code",'ENGINECODE');
        //          IF VariableFieldUsage.FINDFIRST THEN
        //            UpdateVehicleVariableField(VariableFieldUsage."Field No.",DataBuffer."Text Field 2",Vehicle,'ENGINECODE');
        //        END;
              'NumberOfDoors':
                BEGIN
                  VariableFieldUsage.RESET;
                  VariableFieldUsage.SETRANGE("Table No.",DATABASE::Vehicle);
                  VariableFieldUsage.SETRANGE("Variable Field Code",'DOORCOUNT');
                  IF VariableFieldUsage.FINDFIRST THEN
                    UpdateVehicleVariableField(VariableFieldUsage."Field No.",DataBuffer."Text Field 2",Vehicle,'DOORCOUNT');
                END;
              'BodyStyle':
                BEGIN
                  VariableFieldUsage.RESET;
                  VariableFieldUsage.SETRANGE("Table No.",DATABASE::Vehicle);
                  VariableFieldUsage.SETRANGE("Variable Field Code",'BODYSTYLE1');
                  IF VariableFieldUsage.FINDFIRST THEN
                    UpdateVehicleVariableField(VariableFieldUsage."Field No.",DataBuffer."Text Field 2",Vehicle,'BODYSTYLE1');
                END;
              'Combined_Transmission':
                BEGIN
                  VariableFieldUsage.RESET;
                  VariableFieldUsage.SETRANGE("Table No.",DATABASE::Vehicle);
                  VariableFieldUsage.SETRANGE("Variable Field Code",'TRANSMIS');
                  IF VariableFieldUsage.FINDFIRST THEN
                    UpdateVehicleVariableField(VariableFieldUsage."Field No.",DataBuffer."Text Field 2",Vehicle,'TRANSMIS');
                END;
              'Combined_ForwardGears':
                BEGIN
                  VariableFieldUsage.RESET;
                  VariableFieldUsage.SETRANGE("Table No.",DATABASE::Vehicle);
                  VariableFieldUsage.SETRANGE("Variable Field Code",'GEARBOX2');
                  IF VariableFieldUsage.FINDFIRST THEN
                    UpdateVehicleVariableField(VariableFieldUsage."Field No.",DataBuffer."Text Field 2",Vehicle,'GEARBOX2');
                END;
              END;
          UNTIL DataBuffer.NEXT=0;
        END;
        */

    end;
    /*
      local procedure UpdateVehicleVariableField(FieldNo: Integer; FieldValue: Text; var Vehicle: Record Vehicle; FieldCode: Code[10])
      var
          RecRef1: RecordRef;
          FieldRef1: FieldRef;
      begin
          // RecRef1.OPEN(DATABASE::Vehicle);
          // RecRef1.GETTABLE(Vehicle);
          // FieldRef1 := RecRef1.FIELD(FieldNo);
          // FieldRef1.VALUE := COPYSTR(FieldValue,1,20);
          // RecRef1.SETTABLE(Vehicle);
          // Vehicle.MODIFY;
          // InsertVariablFieldOption(Vehicle."Make Code",FieldCode,COPYSTR(FieldValue,1,20),COPYSTR(FieldValue,1,30));
      end;
      */
}

